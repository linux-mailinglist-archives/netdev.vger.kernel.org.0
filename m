Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E78F4744D6
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhLNO0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:26:18 -0500
Received: from mail-co1nam11on2066.outbound.protection.outlook.com ([40.107.220.66]:44352
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229731AbhLNO0R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 09:26:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jbcP9JsPJ7esskv+iklFUsn7Lz8EISFjJpybGrjPk6wsmUigpQ5e/bjgG9+uKsGuCsbDuI5PC6Cyz3N1GhRBDdds75MDH1ExYIcTQNyeETddCpjVvl/nCWUrSWSSfwYOqnu839+IJyAINZmvIzq6N/OqSKBLJKC7KSL6TYqongKsFtnOO64mEkyTWquVePiUBK3saqBBbThsEyxMPog7zZRqN+6nJB0FpRkGlwZYwJSqFvGkWPwwY2Q014/Wda31QBL6RaUb7YCfyuFU6lI02o2G4xOZUHg8OIdp2tYKfVosuKIsc4xDY7N2Pr1KduW3pnAloSkXfAmdQDF79M9WqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=onKMOd4nll4q9oWeHEnwXRSCyMgt0QtiYaIdIhQmk5s=;
 b=Kux4x/nF4DvIOHK4FOaTkyxj1qbecPvf8pjzIc2uJclwCvW/7Wzap9c1ZHWCRDcPhwUOLTPgGRFTJfMbZuUkxsAScZDmRrUA47YH6D+kFFDxuN3O4vD7KkLIof51bFDGdWaf2FinaF/JD5PvgjY/9ne4y1pviB3QkW7wGJS16432E/zzxrEJrObXhkZQLurw2L/+OvsOdz6TR8ENOOlLXobKFWU8fU1JHVsDSwbUH6ghSCYWJfzAwIudl9ruZNk5vaZz/lUTjGpKayRXN/4z04ED3XqEhfVUJ/ph9ktNGHRrp+59JkkgiTKxeL00bZgI7+Q2I970lN1sLK42kdxAtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=onKMOd4nll4q9oWeHEnwXRSCyMgt0QtiYaIdIhQmk5s=;
 b=LFeSHE5xkT4MlbttBYxoiWNZysTQlXs+h5/9dWs5zeCLWP1YWvVCmuXnXnBmgbubUkp1obIMpnsdsjBtnMC7Ghe6qnhbarJ3yTi0Ik2ZS3yHEFVZmk4IUs897LIhSwke+fsGEo9ijsyedV4mPx2exeeCKOlpSl8aAr9bNytaMgY1Y1cEoa08ulQINF168W85JkuQtSYSLhZ3DP6OxfHW3q8eOmfNSxe+GVFy+IYhnBDNF6qQ7ryLtD6IHezrGiMFhk0QWbY0SgB+hB79Or6Z2iDjkki5wD+1x5hvc+jO5L136JLWBz+4XvPgWLQ7WkLfcO8G9DHs3aymHcF8GeAg2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB4757.namprd12.prod.outlook.com (2603:10b6:a03:97::32)
 by BY5PR12MB3955.namprd12.prod.outlook.com (2603:10b6:a03:1a2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Tue, 14 Dec
 2021 14:26:15 +0000
Received: from BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b]) by BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b%3]) with mapi id 15.20.4755.028; Tue, 14 Dec 2021
 14:26:15 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/8] mlxsw: spectrum: Add hash table for IPv6 address mapping
Date:   Tue, 14 Dec 2021 16:25:44 +0200
Message-Id: <20211214142551.606542-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214142551.606542-1-idosch@nvidia.com>
References: <20211214142551.606542-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0114.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:33::30) To BYAPR12MB4757.namprd12.prod.outlook.com
 (2603:10b6:a03:97::32)
MIME-Version: 1.0
Received: from localhost (2a0d:6fc2:5560:e600:ddf8:d1fa:667a:53e3) by MR2P264CA0114.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:33::30) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 14 Dec 2021 14:26:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8190e5a1-f480-4647-8e9a-08d9bf0daff6
X-MS-TrafficTypeDiagnostic: BY5PR12MB3955:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB39558B2F384AAA492DDC3167B2759@BY5PR12MB3955.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OMha30veO9lHo6nfhrFXqSyzz2PSSmULe9Lh1xJDIM0vHOisqHmjaZKXXBSIGjFgytJaGYBi02RozE9FHiF70AdFKOpSy8UMQkFisl4Bx1l2Ol44VBVtDoQEEFB5dtjaADUhM7XJ76KRMBO9GqjTzcDWIkwF9AEXBSpKz8XPkKnUTx6bUueo+HB0AWkkJhhWZgEBcztTx8Fu5kUMBou2NTb+Zm2L1/Ad2LTfH4v89H0oA7XmKcGzqInFjYxcDX39RveMGjL4Rf/tfjfjynYuV+rmFUruqSm1mxBRyp5u7e1Qcda85V6sQ5qZw+tz3QJnSihj+XLrqJoJ69fc8SaPs3eWxEVHlzkyyMkABF1pdkPlSPPUkDYbx8Sc3pK2BzOZtalrduPGqpu/QbN1KWL6ASxm0dCax2SySKvjNHUEUF7S/sh7ixyXHQi2eJgxz2d901kkDkgJkhBg/ZZM4ysOu+5JczS0lNegTGgJjLvfjfumaxLIzUEeOMmMszTN0AqzTO6GqphtTpVfmzyxye6NEtvEQ6SzT2WI1zhV1h91nMZ6OMg+aVV76P13cSkkRWDmGL3izEtcT0PEWjczXGsvKqYL2qfSuNFmADHGCBEPpaK+t02sZ5jOKja3tY8bGCDbeUim5WD5NjX323zu8OpXmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(6666004)(6486002)(6496006)(508600001)(2906002)(6916009)(186003)(86362001)(5660300002)(66556008)(4326008)(316002)(38100700002)(8676002)(66946007)(107886003)(66574015)(8936002)(83380400001)(66476007)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f6Df0va11trfIfOw25dPBRhOaawfo+FR597QKL2t5jzVRQC55Rk/Uzit5oXX?=
 =?us-ascii?Q?UQ5L/UDdjAjl5aOqVsgwkM9SrCizly4vuvcn5ml5MJgNHrAAF5VvUdIV8ZMN?=
 =?us-ascii?Q?VG0wXd7p+9nTbfu7JseVdWcVhz77GitQVimxxAqoxcpLYctKkh65+DV7hBXJ?=
 =?us-ascii?Q?PqWRyqISGoGa56v+2WVcUm2iUnyNovJvswJIhjwlhLArKmi3jL07Rmo2HV8D?=
 =?us-ascii?Q?ewa6y7SS3b0paIR9ovK042pZNS+C9NDvxJGZMG2A+r5i178s6aHudcb+R8X7?=
 =?us-ascii?Q?X6/D33muN9fwlTIJNPAyRAZTZjNof6GWjMn3w/732FzLGkeoMq9ROyXfpv/T?=
 =?us-ascii?Q?1Jit7YtuJanB8q/2dTe0FUi5X4z4YL+axdtY0JLj55dmytDjSLg7A4eWhBzx?=
 =?us-ascii?Q?/k6qCF7Je58v+3FfDggy4cTEwv6HglDUCBtyeK0VIZaI8qhvnDF4uEZaVbUU?=
 =?us-ascii?Q?4Hhra9eoNfOzMjzYY7RpPeG9wkTMKcn6PBYRG9MOespoO20AjSCWjBwaAntv?=
 =?us-ascii?Q?xZubckFCzoEjBne/W9B/f5MfhHm36/OUVucNTESzBOVoZ0ibPJWpOn+TIW4u?=
 =?us-ascii?Q?c64PQ43RtFgMGusoi45RJL/JT+v1Nbu3jZ70GiVQ9gCoH8rl7oJZ2sYNNLd/?=
 =?us-ascii?Q?Hgnoz2HAtvyvulG5LVG9/MBGtpYDbK3Wx6bfANWGN22/8t++bl4px8hitZg2?=
 =?us-ascii?Q?WHHZAi2a4E0SVwDDT7jRWVHRFb9DGFgJrP8flvDy0Ur5FKnHU2Pb0K9dxmUS?=
 =?us-ascii?Q?xTnwK6II1hfIZhStnbq38mw93R3kDw7/yQ+y6lhpLYPfNZqLngcu2Pwk9ky5?=
 =?us-ascii?Q?UDKLVx2BrwV7pxubPTf+0YS+/eVtmNl02Z6AZvfDBfUB2RgfX8ilNvTunLF9?=
 =?us-ascii?Q?LUGYMYketGpEWJW0KyJfzeJxZJO7BE/vDKjirDudz6JMjS1EjAhptn1UFiwu?=
 =?us-ascii?Q?1tcy9otjITpajj8AbNocnw8lQMj3KFSbVnPXRUhVRs2KabzIwEIvBfhvVeZ5?=
 =?us-ascii?Q?ML7RdoqQR7ST8F7Tf5NfPvIRgHF3CFZBlSCmtDhoc3GJLrzFjtau0o/I2j+O?=
 =?us-ascii?Q?9UzcmwGHafJy/ifWvhXzcWJXE5mIAxP6gWoeCOJBJZ3CNZmoOTCObZTO7cz4?=
 =?us-ascii?Q?XYAznUV90rtwcvVPNYoiLsjTQSrlWjFmklZ2E2HehHPrxdBcS4NB1SjvD33o?=
 =?us-ascii?Q?MREHNJ6L2rzbV84agpfZ5i2PkApL9Nzz+6GZhVFHoKudYdrHbut7V7t9VI6h?=
 =?us-ascii?Q?ZnQDyQ37B8lQ5A4xQermKNHt2NP/G56+/lrARQC1KIZNKJdvoZ7CO3GGgmMz?=
 =?us-ascii?Q?+jzIm4WSsZmNwjBrmpStBJ69ZOPC23Jy4w3yuJOAnw/9tL/DE5AN+/En2ayx?=
 =?us-ascii?Q?Jh0TmpfgdliWeRFEY5XEXtj74tkB8u8YwBkccw2ya0ZFENLoFHfInyxq6cjX?=
 =?us-ascii?Q?nmB46SJrFqZ2MqSxv+XoVyYyFY0L8ALS6Tox6qqPM4K2GSpR8I9Sgv/frpyt?=
 =?us-ascii?Q?ASgdIL3kzEc8RQ8f7wNfEC9PACMA4dmECCvfuZPe3yLNeonGo9+MYuGr0C0V?=
 =?us-ascii?Q?macB7GMErQ7Rm8ZPoe1KtUwY709ht0951r0bBlaqXSdxC+753nn+hkA7gOZn?=
 =?us-ascii?Q?zDrHuP7QhJnAlzf4yvQ2tSFnHvrx10DjxMCcqfTSx4YGGUKV3xdjo4xcXl9D?=
 =?us-ascii?Q?98x+YxcqCve9064uezP7w410jpk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8190e5a1-f480-4647-8e9a-08d9bf0daff6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 14:26:15.8849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FaAUzxP5j8elGX6TN3ejoE0FGZa+eh66fzoToIKlsoLtgdbcfWNSi/pU+HlzlZptuUzpEpm9HzuqJCsCIUrVew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3955
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The device supports forwarding entries such as routes and FDBs that
perform tunnel (e.g., VXLAN, IP-in-IP) encapsulation or decapsulation.
When the underlay is IPv6, these entries do not encode the 128 bit IPv6
address used for encapsulation / decapsulation. Instead, these entries
encode a 24 bit pointer to an array called KVDL where the IPv6 address
is stored.

Currently, only IP-in-IP with IPv6 underlay is supported, but subsequent
patches will add support for VxLAN with IPv6 underlay. To avoid
duplicating the logic required to store and retrieve these IPv6
addresses, introduce a hash table that will store the mapping between
IPv6 addresses and their KVDL index.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 143 ++++++++++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   7 +
 2 files changed, 150 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index fb06b2ddfd6d..5251f33af0fb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2755,6 +2755,140 @@ static void mlxsw_sp_parsing_fini(struct mlxsw_sp *mlxsw_sp)
 	mutex_destroy(&mlxsw_sp->parsing.lock);
 }
 
+struct mlxsw_sp_ipv6_addr_node {
+	struct in6_addr key;
+	struct rhash_head ht_node;
+	u32 kvdl_index;
+	refcount_t refcount;
+};
+
+static const struct rhashtable_params mlxsw_sp_ipv6_addr_ht_params = {
+	.key_offset = offsetof(struct mlxsw_sp_ipv6_addr_node, key),
+	.head_offset = offsetof(struct mlxsw_sp_ipv6_addr_node, ht_node),
+	.key_len = sizeof(struct in6_addr),
+	.automatic_shrinking = true,
+};
+
+static int
+mlxsw_sp_ipv6_addr_init(struct mlxsw_sp *mlxsw_sp, const struct in6_addr *addr6,
+			u32 *p_kvdl_index)
+{
+	struct mlxsw_sp_ipv6_addr_node *node;
+	char rips_pl[MLXSW_REG_RIPS_LEN];
+	int err;
+
+	err = mlxsw_sp_kvdl_alloc(mlxsw_sp,
+				  MLXSW_SP_KVDL_ENTRY_TYPE_IPV6_ADDRESS, 1,
+				  p_kvdl_index);
+	if (err)
+		return err;
+
+	mlxsw_reg_rips_pack(rips_pl, *p_kvdl_index, addr6);
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(rips), rips_pl);
+	if (err)
+		goto err_rips_write;
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node) {
+		err = -ENOMEM;
+		goto err_node_alloc;
+	}
+
+	node->key = *addr6;
+	node->kvdl_index = *p_kvdl_index;
+	refcount_set(&node->refcount, 1);
+
+	err = rhashtable_insert_fast(&mlxsw_sp->ipv6_addr_ht,
+				     &node->ht_node,
+				     mlxsw_sp_ipv6_addr_ht_params);
+	if (err)
+		goto err_rhashtable_insert;
+
+	return 0;
+
+err_rhashtable_insert:
+	kfree(node);
+err_node_alloc:
+err_rips_write:
+	mlxsw_sp_kvdl_free(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_IPV6_ADDRESS, 1,
+			   *p_kvdl_index);
+	return err;
+}
+
+static void mlxsw_sp_ipv6_addr_fini(struct mlxsw_sp *mlxsw_sp,
+				    struct mlxsw_sp_ipv6_addr_node *node)
+{
+	u32 kvdl_index = node->kvdl_index;
+
+	rhashtable_remove_fast(&mlxsw_sp->ipv6_addr_ht, &node->ht_node,
+			       mlxsw_sp_ipv6_addr_ht_params);
+	kfree(node);
+	mlxsw_sp_kvdl_free(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_IPV6_ADDRESS, 1,
+			   kvdl_index);
+}
+
+int mlxsw_sp_ipv6_addr_kvdl_index_get(struct mlxsw_sp *mlxsw_sp,
+				      const struct in6_addr *addr6,
+				      u32 *p_kvdl_index)
+{
+	struct mlxsw_sp_ipv6_addr_node *node;
+	int err = 0;
+
+	mutex_lock(&mlxsw_sp->ipv6_addr_ht_lock);
+	node = rhashtable_lookup_fast(&mlxsw_sp->ipv6_addr_ht, addr6,
+				      mlxsw_sp_ipv6_addr_ht_params);
+	if (node) {
+		refcount_inc(&node->refcount);
+		*p_kvdl_index = node->kvdl_index;
+		goto out_unlock;
+	}
+
+	err = mlxsw_sp_ipv6_addr_init(mlxsw_sp, addr6, p_kvdl_index);
+
+out_unlock:
+	mutex_unlock(&mlxsw_sp->ipv6_addr_ht_lock);
+	return err;
+}
+
+void
+mlxsw_sp_ipv6_addr_put(struct mlxsw_sp *mlxsw_sp, const struct in6_addr *addr6)
+{
+	struct mlxsw_sp_ipv6_addr_node *node;
+
+	mutex_lock(&mlxsw_sp->ipv6_addr_ht_lock);
+	node = rhashtable_lookup_fast(&mlxsw_sp->ipv6_addr_ht, addr6,
+				      mlxsw_sp_ipv6_addr_ht_params);
+	if (WARN_ON(!node))
+		goto out_unlock;
+
+	if (!refcount_dec_and_test(&node->refcount))
+		goto out_unlock;
+
+	mlxsw_sp_ipv6_addr_fini(mlxsw_sp, node);
+
+out_unlock:
+	mutex_unlock(&mlxsw_sp->ipv6_addr_ht_lock);
+}
+
+static int mlxsw_sp_ipv6_addr_ht_init(struct mlxsw_sp *mlxsw_sp)
+{
+	int err;
+
+	err = rhashtable_init(&mlxsw_sp->ipv6_addr_ht,
+			      &mlxsw_sp_ipv6_addr_ht_params);
+	if (err)
+		return err;
+
+	mutex_init(&mlxsw_sp->ipv6_addr_ht_lock);
+	return 0;
+}
+
+static void mlxsw_sp_ipv6_addr_ht_fini(struct mlxsw_sp *mlxsw_sp)
+{
+	mutex_destroy(&mlxsw_sp->ipv6_addr_ht_lock);
+	rhashtable_destroy(&mlxsw_sp->ipv6_addr_ht);
+}
+
 static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 			 const struct mlxsw_bus_info *mlxsw_bus_info,
 			 struct netlink_ext_ack *extack)
@@ -2843,6 +2977,12 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 		goto err_afa_init;
 	}
 
+	err = mlxsw_sp_ipv6_addr_ht_init(mlxsw_sp);
+	if (err) {
+		dev_err(mlxsw_sp->bus_info->dev, "Failed to initialize hash table for IPv6 addresses\n");
+		goto err_ipv6_addr_ht_init;
+	}
+
 	err = mlxsw_sp_nve_init(mlxsw_sp);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Failed to initialize NVE\n");
@@ -2944,6 +3084,8 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 err_acl_init:
 	mlxsw_sp_nve_fini(mlxsw_sp);
 err_nve_init:
+	mlxsw_sp_ipv6_addr_ht_fini(mlxsw_sp);
+err_ipv6_addr_ht_init:
 	mlxsw_sp_afa_fini(mlxsw_sp);
 err_afa_init:
 	mlxsw_sp_counter_pool_fini(mlxsw_sp);
@@ -3075,6 +3217,7 @@ static void mlxsw_sp_fini(struct mlxsw_core *mlxsw_core)
 	mlxsw_sp_router_fini(mlxsw_sp);
 	mlxsw_sp_acl_fini(mlxsw_sp);
 	mlxsw_sp_nve_fini(mlxsw_sp);
+	mlxsw_sp_ipv6_addr_ht_fini(mlxsw_sp);
 	mlxsw_sp_afa_fini(mlxsw_sp);
 	mlxsw_sp_counter_pool_fini(mlxsw_sp);
 	mlxsw_sp_switchdev_fini(mlxsw_sp);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index ef4188e203a0..80580c892bb3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -203,6 +203,8 @@ struct mlxsw_sp {
 	const struct mlxsw_listener *listeners;
 	size_t listeners_count;
 	u32 lowest_shaper_bs;
+	struct rhashtable ipv6_addr_ht;
+	struct mutex ipv6_addr_ht_lock; /* Protects ipv6_addr_ht */
 };
 
 struct mlxsw_sp_ptp_ops {
@@ -587,6 +589,11 @@ mlxsw_sp_sample_trigger_params_set(struct mlxsw_sp *mlxsw_sp,
 void
 mlxsw_sp_sample_trigger_params_unset(struct mlxsw_sp *mlxsw_sp,
 				     const struct mlxsw_sp_sample_trigger *trigger);
+int mlxsw_sp_ipv6_addr_kvdl_index_get(struct mlxsw_sp *mlxsw_sp,
+				      const struct in6_addr *addr6,
+				      u32 *p_kvdl_index);
+void
+mlxsw_sp_ipv6_addr_put(struct mlxsw_sp *mlxsw_sp, const struct in6_addr *addr6);
 
 extern const struct mlxsw_sp_sb_vals mlxsw_sp1_sb_vals;
 extern const struct mlxsw_sp_sb_vals mlxsw_sp2_sb_vals;
-- 
2.31.1

