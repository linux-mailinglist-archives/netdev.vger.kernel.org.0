Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5FE4C2D3C
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 14:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbiBXNfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 08:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbiBXNfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 08:35:39 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378D917869E
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 05:35:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KwyWj0/AOV08K5hB/sM8wppEpYSIzTChQFwks/4Gln+4e+SJuxBkTHbGp+FAIblosIbx2AG8vI2YkyhbEyCFlBBDcD3sFU7mBKwva0I8BaoObOak+9C848+qVjxIi4QZdK1YzTZsgHni53Zpa3RIZKOA6vCEIcgZJ4UyyFARBleEwKOowLJQ8vhTvhYkBR0abD/IkfVOhy6rBhNP1YU4DQW/5DM89CtdLmvec5H99bfQL7qBn4XmqACDV087ITzT1MISYpTus74OeTOGQL0CTygvPMCzxoYule0FpviPoHcAUmKBuEJHNuRxZkWaFE4gV0qcL6P4nnEK+GBHtZOfgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gc78/ds/Dz1icWPRVPiybRT/Ox7juhxiIjIzctKkwc0=;
 b=KkKS0aP6xime7Ao57wO8EWpZMQNhU8P5TUSEGQG/2Ee7NRHhe03UcxeqwrUmWBRMBH1aSCb6Vt8m9Wb6Rojd2xOrnewZKwjGANpNfmLRTxxZL4KPPlNKLmFuZ7b083dyqncgrX/hn3m1FXxyRgc6MFHTDlyPqUF+Y8nujBADFpPDreob4TP6Oj/Ufwwrop2eAXlPMemvPaPcvpOqWPIHkUpwvVNtMuM2qQ+vt0aEYH8MeIZsMfEWRpasQSWNGCvWqRX0KAtQVXsMCe0/o58OM8R6TZDmoV3+VmN6axUjXI3ASdy/dYuUf53bW5pkMJhou78ybhFAEIkM/dY3c1Ox+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gc78/ds/Dz1icWPRVPiybRT/Ox7juhxiIjIzctKkwc0=;
 b=HPE0NAQQKXUZYpY0hdlRXmQcrm7TqdcEYFLJAMTc6pDN5viFm4viFdDNHDTFfXbw+JLbC/Bk3LzfbMQ8Hh4h38s3q82Ts1p6IL9F4QWDmKZu+cvNjeJIswwY2pbglsq2eZQJb1dLQ5pdIimPEQvMZDnP2uXu3NSDgW5IyimiBp9oL1a8lNHL4W6IUldkhM6JeOO66ldeuFZUBygRBv/2ISlE3IVQMpGdSDK3xLH2UsXyV2ZcYfCB+VBDdP19arkvp7eN4BA19JL4hhzspyMpGhZ1yeiUIOEPS/YopQvJskrbbFgDLVGK6xFLBot4TXbPmL3UZ8CQrhFo6oaO1QZIWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB6008.namprd12.prod.outlook.com (2603:10b6:8:7f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Thu, 24 Feb
 2022 13:35:07 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.025; Thu, 24 Feb 2022
 13:35:07 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, razor@blackwall.org, roopa@nvidia.com,
        dsahern@gmail.com, andrew@lunn.ch, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 11/14] mlxsw: spectrum_router: Drop mlxsw_sp arg from counter alloc/free functions
Date:   Thu, 24 Feb 2022 15:33:32 +0200
Message-Id: <20220224133335.599529-12-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220224133335.599529-1-idosch@nvidia.com>
References: <20220224133335.599529-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0066.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::19) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 196b47a2-6f81-4711-e949-08d9f79a78f7
X-MS-TrafficTypeDiagnostic: DS7PR12MB6008:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB60088081D2FC73D9F4B5AEB2B23D9@DS7PR12MB6008.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oN2z9WWlAnG9zMD1Y9Xa/x3pZpI5w+I+WjyZw2VXm6hqVzAj6otFRZxZu9/iKO2C5GxvyhKNiTxKM/kLBrYegt/n7qXixG67uOoZfnRNyilADE2w+V58xoHgKXKmpJh/yRvY/vazSXmDEuFZERXSbUMpvUVrDNA7AJ9rbDVahILxzm15xNEJ0ULeWqwS8u700+2flxxk30TN9vZw9fixu/pred7UjJUng4eRmiZv2PQnb0/kVWc8tx+0PdldJfe7hgyFj1++TgMdl6g2p+KsxNKSqBLeID2IVz+s8udPP3+UflfZR58Yq+9gDJOlrZY0O37P7hKPeG5QcF0VsET/sW67wnYaGNF4JeHECMUrMdg7NgheHYHSxj75Xnki2kpm1ZF8IJd1gGzsGH4LZV8gIjc6qvjOp3XQH9fQ1vx5KpzYTDlYhBwbDw5nYPiw4C7y59hNhkTAZAMltSExI8+AwzMvfRP/oG7x2JLunxSqQBIuyKt7kc/IM/r8949RYgNeOifnHyQ5FXyK2MaBA1FsKbXEzizUzC3sWlaMienbcuOw3EqMwhe8JEPZZq8dKFXqJxdN49ByTYKFeh8I1uJNp7nvi2Mo26bI+Y996Ypz7CGJ1r7uhLVscERBCx0BE6NjcKd/Bl7IrhiSg19MYqHMaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(2616005)(66476007)(66946007)(316002)(38100700002)(186003)(6916009)(4326008)(8676002)(86362001)(66556008)(36756003)(6512007)(1076003)(107886003)(5660300002)(83380400001)(508600001)(66574015)(6666004)(2906002)(8936002)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?62SX6ORMUvoWcAGx09Mk5Ddn6mHgwjJCQmBtEq8PiB4i6eO+ODjyCeh5q9Aq?=
 =?us-ascii?Q?jf3+ZuSaUo40AJrskYLi1pOZDCqlwLNHose8WRscI7eKG/e92QMCCS7NZqrD?=
 =?us-ascii?Q?VD8wHMd1x/iaOrwx29wUjUgBtSydlgciZpnE3keMZIZlhedMQc7YZDKxKpUH?=
 =?us-ascii?Q?BhfSomihQcl6odOYeC5iYgdmHj+hkqDMqv+7qs8io5jkGsXA4tWtDtEtKcmM?=
 =?us-ascii?Q?WPmoXmEE8VYuYJCqurp2mSNFJo0u3gugqsErWM0vvDaetB86GZ1MTNsA1G/c?=
 =?us-ascii?Q?DpjG2DmL9h9m4keHTqJ0iilxdPDo6V5HhV6oko1cS4enrV9CRltiSvG176q6?=
 =?us-ascii?Q?6Jk6OGcROmSjwr/yRDJxRv80dN39UPP56w+H5e1qb4xdn3x5zYekWRPPN7eM?=
 =?us-ascii?Q?D1ChzO4Kdhw3CWyZ8LhTFyKv+00Wnk3uBVjjmnnjk0otO5+9ZWHIlZk8J8n5?=
 =?us-ascii?Q?TPD2uY7erUWIuz4CSGtQsEjN84moItbI9zmBWoIoSw2sSxKZGGaGwdreLQK1?=
 =?us-ascii?Q?GJBBw1hsNDsGuO0Qgnhg3RectOqqzJwiIpyxn1WZ8kKTtfA80W9OC3bHedQa?=
 =?us-ascii?Q?OQ8TxhnSan4h/92Ek1hdyKRoGS0+p158BDVsemp97jsX0arLFVaxsHbzkr9p?=
 =?us-ascii?Q?pEsJkOl/6Ob36lATU35U8Kzp1jUGzA2WaMJ0gHL0uoGOUldruqL+zSNzqFcN?=
 =?us-ascii?Q?pIifC1NPEr0s43QGfrRfIKNVxP/92qul5DU+YHouQ5K+jvh2O1LNzOaOs+FW?=
 =?us-ascii?Q?0kLrrbSqR7/LwH03sdbwHQjv/3Jkm8HYWFECCjWPE1ueqwXjIFO4xkzpP5NX?=
 =?us-ascii?Q?LzdPyK+LsJBpMGZQIoiDJPKl0jEgB7KeLECNfgG51YYkx1OZv6e03reQ6V3m?=
 =?us-ascii?Q?1W5Ciq+e+iIEy12YwTm62Y0oxOk6kZmi/fpDauojut9LPIv4JwPv3zrXz7OJ?=
 =?us-ascii?Q?7U04UAUng8Q+mwZgAm+/Rc6B4ZOBA9yhFwgDa7xXnfpdpF1BABeIuuHmAvAp?=
 =?us-ascii?Q?cMn6JpyQYib96Han2rE/v+4Y375gF+mE4lLi3YD6UPYas4b69Y90zTo2n18A?=
 =?us-ascii?Q?Pyuf+EAE5baAQ1GOPBV6s+ZDZc+4ihuK2NOv1CPBBL9pBSEQ0uR09jOIf04A?=
 =?us-ascii?Q?HzTWNnqC+S4ne25Nl05B5NuVI/C6894UHOAjhQuEkMT0mY4syslsO+y2oGEs?=
 =?us-ascii?Q?hNFGPp9JrleucZbKghyUX5FRrqgqgDApE8F1oliEkCEtc4jvBifciYUfKZ4t?=
 =?us-ascii?Q?jljPdP2N2LreZO2iEUnzZZR5LiwEbvuqFd3ETqRfm2+OfTLivn2DdN/ZjjB+?=
 =?us-ascii?Q?YX14NICofFP534618yYBL92ifJXSXaOy42Ja8uMZpI+xilPxWME0sdOKyAs4?=
 =?us-ascii?Q?2MK79ko2qef8dheoQsITT2BBXNzANI6wouXx4mstQtVV68rbie3Z6uffYHe0?=
 =?us-ascii?Q?vtT0fjuneVl37/zDGnZeqZHNFfaEBXpgaCbPhJn8t4gx1dYsNZS1ndFX6/3L?=
 =?us-ascii?Q?cjWvy9x4nZvMGZUBEJcAXxw2oq4FtvFBS8cm+7BahRAIs7dEiOXMhDlvQ5fU?=
 =?us-ascii?Q?IRnMH3FnbKFyUOdh5fVu2aHuxSU2OgnWjU1ROwODlbC1PA7R8aVQ6gGN2SM1?=
 =?us-ascii?Q?LCxMQw+sARpdOlDAihUxy08=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 196b47a2-6f81-4711-e949-08d9f79a78f7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 13:35:07.7110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W8ApDy0Z8w9AcVsKD6EPa/YOj65pr+Z2sSYUxK05vm2VWxILiP4E4+wf0JQ5M2NvZ3lePjMmo1W5aXTlabSWhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6008
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The mlxsw_sp reference is carried by the mlxsw_sp_rif object that is passed
to these functions as well. Just deduce the former from the latter,
and drop the explicit mlxsw_sp parameter. Adapt callers.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_dpipe.c   |  4 ++--
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  | 14 ++++++--------
 .../net/ethernet/mellanox/mlxsw/spectrum_router.h  |  6 ++----
 3 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
index 1a2fef2a5379..5d494fabf93d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_dpipe.c
@@ -266,10 +266,10 @@ static int mlxsw_sp_dpipe_table_erif_counters_update(void *priv, bool enable)
 		if (!rif)
 			continue;
 		if (enable)
-			mlxsw_sp_rif_counter_alloc(mlxsw_sp, rif,
+			mlxsw_sp_rif_counter_alloc(rif,
 						   MLXSW_SP_RIF_COUNTER_EGRESS);
 		else
-			mlxsw_sp_rif_counter_free(mlxsw_sp, rif,
+			mlxsw_sp_rif_counter_free(rif,
 						  MLXSW_SP_RIF_COUNTER_EGRESS);
 	}
 	mutex_unlock(&mlxsw_sp->router->lock);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index d40762cfc453..2b21fea3b37d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -235,10 +235,10 @@ static int mlxsw_sp_rif_counter_clear(struct mlxsw_sp *mlxsw_sp,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ricnt), ricnt_pl);
 }
 
-int mlxsw_sp_rif_counter_alloc(struct mlxsw_sp *mlxsw_sp,
-			       struct mlxsw_sp_rif *rif,
+int mlxsw_sp_rif_counter_alloc(struct mlxsw_sp_rif *rif,
 			       enum mlxsw_sp_rif_counter_dir dir)
 {
+	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 	unsigned int *p_counter_index;
 	int err;
 
@@ -268,10 +268,10 @@ int mlxsw_sp_rif_counter_alloc(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
-void mlxsw_sp_rif_counter_free(struct mlxsw_sp *mlxsw_sp,
-			       struct mlxsw_sp_rif *rif,
+void mlxsw_sp_rif_counter_free(struct mlxsw_sp_rif *rif,
 			       enum mlxsw_sp_rif_counter_dir dir)
 {
+	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 	unsigned int *p_counter_index;
 
 	if (!mlxsw_sp_rif_counter_valid_get(rif, dir))
@@ -296,14 +296,12 @@ static void mlxsw_sp_rif_counters_alloc(struct mlxsw_sp_rif *rif)
 	if (!devlink_dpipe_table_counter_enabled(devlink,
 						 MLXSW_SP_DPIPE_TABLE_NAME_ERIF))
 		return;
-	mlxsw_sp_rif_counter_alloc(mlxsw_sp, rif, MLXSW_SP_RIF_COUNTER_EGRESS);
+	mlxsw_sp_rif_counter_alloc(rif, MLXSW_SP_RIF_COUNTER_EGRESS);
 }
 
 static void mlxsw_sp_rif_counters_free(struct mlxsw_sp_rif *rif)
 {
-	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
-
-	mlxsw_sp_rif_counter_free(mlxsw_sp, rif, MLXSW_SP_RIF_COUNTER_EGRESS);
+	mlxsw_sp_rif_counter_free(rif, MLXSW_SP_RIF_COUNTER_EGRESS);
 }
 
 #define MLXSW_SP_PREFIX_COUNT (sizeof(struct in6_addr) * BITS_PER_BYTE + 1)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 99e8371a82a5..fa829658a11b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -159,11 +159,9 @@ int mlxsw_sp_rif_counter_value_get(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_rif *rif,
 				   enum mlxsw_sp_rif_counter_dir dir,
 				   u64 *cnt);
-void mlxsw_sp_rif_counter_free(struct mlxsw_sp *mlxsw_sp,
-			       struct mlxsw_sp_rif *rif,
+void mlxsw_sp_rif_counter_free(struct mlxsw_sp_rif *rif,
 			       enum mlxsw_sp_rif_counter_dir dir);
-int mlxsw_sp_rif_counter_alloc(struct mlxsw_sp *mlxsw_sp,
-			       struct mlxsw_sp_rif *rif,
+int mlxsw_sp_rif_counter_alloc(struct mlxsw_sp_rif *rif,
 			       enum mlxsw_sp_rif_counter_dir dir);
 struct mlxsw_sp_neigh_entry *
 mlxsw_sp_rif_neigh_next(struct mlxsw_sp_rif *rif,
-- 
2.33.1

