Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FFC4744E0
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbhLNO0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:26:54 -0500
Received: from mail-mw2nam10on2072.outbound.protection.outlook.com ([40.107.94.72]:50656
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232536AbhLNO0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 09:26:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nByttKWrfxav9pu7oyCmUIOjOY1vlVfqUqUWgPrEp1m61vAQYT1n+n4hN4Vtxj/qqPI1jzh1oI1uy3cwCt8NR7/bSBds+/GNqx2t70pz9kKnxp9eNA3s7bM2ofSXGRnew0k2DYi8FaDauSaWKaxG2BJnddjz3U6oUdzI2K4ECkt2OZCJcMy4B5CWAnRo7A+7nwkZQmwdrnuiORb/iA08IB3aV2vwwDsperAxTJEj7f2hwlq17TdyUfkKtA+hcOVSl65mvKlSGVjYF96EndkW7mdvQcCpjyVjQBIdbp0LqtKyS9sLewzAAslC9yR/cyj01VqIq5UImpaIvEQrXXM2+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nsUrAaA8O0zAh7OKuN4Ogr0fqwQj+Gp3CxL2a8gkZ6I=;
 b=G3Tdp25lImpZ0u8h/NjJ1hGnI/oCsDtWyMrfREJPJzNs4RkfvzIoKLmbjlJOXRs5Pkyw2QUwTjAh4+bL+xUTyEYw/LDZq6i1NXzazjj2k7NGO69VUaVRwEShIApPcTYeEgpzJR1lq2o29EZTHloGE4sUu/m6LHO8sibICe0f3roC2VxT8+uWesYyY/SPJ5iTZshcYkHB9gc5nJkAmNtWZCzpxLpJbCBiNa3MfjZgk+i1rK2kR2Sh3VDzYHMlU1ixqEu3/NqV7ysoRLEmVAt+jYKqzryyECgkFOJ7BKHOoLnVD2EqrDlmbOsQMGC64VLYV21gFnphrfb+hdK5d8HMeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nsUrAaA8O0zAh7OKuN4Ogr0fqwQj+Gp3CxL2a8gkZ6I=;
 b=k4djfL8D8my7Q2/2DkJBQ6lbNYWL90NJUOGLsfdxldeVkUdR6kmkQVriwX0cl54kr74xVWeIGD6LwkhwiDCtvZG8/h+52Qz2Zi1nwPGymfqoZfpOTT/8AVi3VLnKxGOJIV9MTiBDAw3Q9z6jAsex31ccwLTd1s3TQCV+gxHZpuHNIY+4/fKd/1K7aDTzjlE/IesWZ45RkE5MtmB9dmmvvXggAfPEPjLcfqP09a716QUcfYWp+9aQ1WtFLXIO3I5jWFb5maEeyBrgHdj+aJyNsRBKXXR2rsHZ0I4z3n7Yc1RM0I9jbhJ0g99D0QGKRw5sFwm81eBGTp7ciVRbgmahSQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB4757.namprd12.prod.outlook.com (2603:10b6:a03:97::32)
 by BYAPR12MB3031.namprd12.prod.outlook.com (2603:10b6:a03:d8::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.13; Tue, 14 Dec
 2021 14:26:50 +0000
Received: from BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b]) by BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b%3]) with mapi id 15.20.4755.028; Tue, 14 Dec 2021
 14:26:50 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/8] mlxsw: spectrum_nve: Keep track of IPv6 addresses used by FDB entries
Date:   Tue, 14 Dec 2021 16:25:49 +0200
Message-Id: <20211214142551.606542-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211214142551.606542-1-idosch@nvidia.com>
References: <20211214142551.606542-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0109.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:50::20) To BYAPR12MB4757.namprd12.prod.outlook.com
 (2603:10b6:a03:97::32)
MIME-Version: 1.0
Received: from localhost (2a0d:6fc2:5560:e600:ddf8:d1fa:667a:53e3) by MR1P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:50::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Tue, 14 Dec 2021 14:26:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c901344e-a761-4804-7ee2-08d9bf0dc486
X-MS-TrafficTypeDiagnostic: BYAPR12MB3031:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3031CFDF71D0DC86AFE7B4E4B2759@BYAPR12MB3031.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pf4lTy1sSPNbWfICEjoP1JcjlC1neaBrYKxK51T+KHcmK2NDzmX8+RYYf0rCLFc+Fx+lN6UOLyXi/YEdqLNcB3Y+nAC0THTLbZMsJtGADQEhJZJOIYjpzS5oI0cvIFtV9VqcblRQNRyj5MPXqHINEU43/lC51uLTfUhpy9c6rf8a/yxKRk2rsGnhq32wvIYih+eZXUDbEtUx9uEa9V6AFoLc7QVBFpYl9bvqfkleQbaJGLn6gzUxRcnvo0aK++wVLcIB7DSvk0LnEklWIkzpP/6mMjJqURI+3v2j0wMge7WihIUltzGit3cHqvp+7FV4zF/MMBELp/7XBRyR6kv/fdJKArTp1gP44kuLjWmBfUSfTWcW6Zp8U+RxC5VOMw5PBbW2qLSoP8i4gkDcO6ZPUsmGqVpMCpWF9uvqcTevucEgNS2LJl8bAvcayPz/f/V5CLzNCleCXJ83kxj8E872Uw6hF1jI7jpxyMTzoI8RgB+E8ch4542rWxGFnbqFYYFaiyWwfqWjBAYvQh28OUhlOGqi4Mvrvy8+W99Ss1rWDeBWdDSfSyBlV8i/Iu42qO92olfpdSvL6UnckFVLKrdzjcrI5BCGFw5kxAeCgKn5cwY27dKbjACyaTrjB+eFlMBOiIKhzjVgAHXHtoTq/AOjJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(6496006)(508600001)(8936002)(83380400001)(107886003)(2906002)(66476007)(66556008)(86362001)(186003)(38100700002)(316002)(4326008)(8676002)(2616005)(1076003)(5660300002)(6486002)(36756003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LczflRD4IgrOywXKz34BkP7O9TyyDqBlnAcCUZIAQ8E4g6OFj5tYlQ9Xbn+d?=
 =?us-ascii?Q?LxfKK9NtGiolvS5teapSXe+v873Yrl7axLsFDcv3VQz3DdaDn5vQ8DLqKpHV?=
 =?us-ascii?Q?s5fMr3PoVNphBwqBwNppt6/6TIWwRklGp42nkV0IiST23egUakTD6pi3Wg7T?=
 =?us-ascii?Q?TfxDBswBY8lpOO891sn3Fr2fqWO9lkK1DDf8Udc5Uax4WYTpCvvUmtS8jxM0?=
 =?us-ascii?Q?Pu4GY4ccL6ovkTls6fuHM52Y0LYwvI/cyEdhcFUfKuoSEcUpRUraskmTOuPs?=
 =?us-ascii?Q?TnBSN/S/qA7kks/nxTPXbVosYBs9po5iDQpRqGCdiugYL/3hU171uoSe/mpC?=
 =?us-ascii?Q?CHd7B8ALPnGbr+FEQUmlUqDxEuaqFd0I+SpZRaVOGXtQ45koJ29Fhp+7tVSC?=
 =?us-ascii?Q?lH00V8fclwZf4o6dwoohxCZ/UKfc4AnigpWlSJP4sMcv1wbijITnJmXIivN7?=
 =?us-ascii?Q?jvr9tQAM3No+HNNgBlzSMRwaU3wmvjUgbhUpZ/Ef6ASE9HtgzYhBXovasIvn?=
 =?us-ascii?Q?Q+4bnCF9vT1W9qjgzjXzOAfA7Bs91Tom5FRcnqKzDVjkO5W++6994t3/5myx?=
 =?us-ascii?Q?1p7+zwoyYeXhvGROY/enUhODpB3xvF2huAndllySx8eJjQSX3cufXCedoPtQ?=
 =?us-ascii?Q?5S5tgMLm79eJpeMkBcamEm1EJmE9xyDPGfNJ6nUuH9B6zgo+mf8fjgQ4oqwd?=
 =?us-ascii?Q?mdpmfyqamRykpm/K0L6V1g6neVNJbYknrVjycPmlEm5cCQtUNfHHlZ4SYl4w?=
 =?us-ascii?Q?rylpkuChJZywx8O6eh7BvSTpLzadp3Rhbhy2sp0mUzssRo1fT5jwjgLIUZos?=
 =?us-ascii?Q?I2jXd0HlaB2ISHvxwTg7h+vAVnne/1ZT+sXn1jQYLkzcyg993s6Dmd7Qymfu?=
 =?us-ascii?Q?HzdAdE8fUQyjFdvI0VyOnJkhoUkW9sLL8fXUZCUZgvWQdLXpDrygUZ+Lldnx?=
 =?us-ascii?Q?xQWjGLMoCEjbIGnkqgrK3MQkLxYNH6OMDijxVt5fAao9EGa5ydY022UqeAfQ?=
 =?us-ascii?Q?b7+p432LESaxMbbL7Qs34+n1xMtZ/BPNes9m5EklGikVlJS6xg4xrsXtfoQK?=
 =?us-ascii?Q?DTevwOWzxfRWRBuPdK3g/AkRiTDCVkQ7UvTV4yUC07Bgah+v7zutD07aslFO?=
 =?us-ascii?Q?6yMnVfi30CtbvJQkwNLpa0GjEtKw+/M4VyYywMflylt3ISDuz8DvnDJluPCX?=
 =?us-ascii?Q?/PRGp9vhXuRaNLxNUNbBYMsaW/sJFa/hhwah+DBYec6zFs+IzJ0dRFnuy7Ev?=
 =?us-ascii?Q?UTk9iATQzZccdvNRz+rc0w4LZI5izttyb3J93XRQTPJ4bmO5/8fr+Q+pfZpF?=
 =?us-ascii?Q?gL1yu14HI9dFtyUcnvo5SIR7UTPyYX7vqCnUIq0jOsTZ+0eLEnktUUf/0UWF?=
 =?us-ascii?Q?FZgMitgZob4mr2VnmaqRko6pvOltV/qhR6j4oi8mDwbkw94SUokrSMuvhJuP?=
 =?us-ascii?Q?ycwU+Lp9Ck2VZo+41+gfCO7jvT7ScehkY9DooZwXn2FnoPbp7k6bMDRJWJ5H?=
 =?us-ascii?Q?t9eGj7CarhpCbXBxkQ7y4kRI3G3aJH/nSqws14/cm+wO73tK9T2MEzZUIZac?=
 =?us-ascii?Q?Op/tRO41lMaLi8giU8qOcnwJpPAgN2IVnnNm4dLAAjnBHFVs9/dRFOhw3N+y?=
 =?us-ascii?Q?YwI18MNcQhSw0cv3rCmNbG+/QKq5VgSzXQPRR8l1pIr89dB3B429fcLOT/Ja?=
 =?us-ascii?Q?Lgia8WMp97q7zk58n00hwyNn2FE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c901344e-a761-4804-7ee2-08d9bf0dc486
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 14:26:50.6170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Je25wQ7xERaA1fg9oVMTxsZPCnQd3ApXgsIYhn/lEAhYNNtO3D7i3MZ5N7vUDOVaW4gtB8TGpN6knx2P9+WVUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3031
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

FDB entries that perform VxLAN encapsulation with an IPv6 underlay hold
a reference on a resource. Namely, the KVDL entry where the IPv6
underlay destination IP is stored. When such an FDB entry is deleted, it
needs to drop the reference from the corresponding KVDL entry.

To that end, maintain a hash table that maps an FDB entry (i.e., {MAC,
FID}) to the IPv6 address used by it.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  11 ++
 .../ethernet/mellanox/mlxsw/spectrum_nve.c    | 151 +++++++++++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_nve.h    |   2 +
 3 files changed, 162 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 80580c892bb3..8445fc5c9ea3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -1317,6 +1317,17 @@ void mlxsw_sp_nve_flood_ip_del(struct mlxsw_sp *mlxsw_sp,
 			       struct mlxsw_sp_fid *fid,
 			       enum mlxsw_sp_l3proto proto,
 			       union mlxsw_sp_l3addr *addr);
+int mlxsw_sp_nve_ipv6_addr_kvdl_set(struct mlxsw_sp *mlxsw_sp,
+				    const struct in6_addr *addr6,
+				    u32 *p_kvdl_index);
+void mlxsw_sp_nve_ipv6_addr_kvdl_unset(struct mlxsw_sp *mlxsw_sp,
+				       const struct in6_addr *addr6);
+int
+mlxsw_sp_nve_ipv6_addr_map_replace(struct mlxsw_sp *mlxsw_sp, const char *mac,
+				   u16 fid_index,
+				   const struct in6_addr *new_addr6);
+void mlxsw_sp_nve_ipv6_addr_map_del(struct mlxsw_sp *mlxsw_sp, const char *mac,
+				    u16 fid_index);
 int mlxsw_sp_nve_fid_enable(struct mlxsw_sp *mlxsw_sp, struct mlxsw_sp_fid *fid,
 			    struct mlxsw_sp_nve_params *params,
 			    struct netlink_ext_ack *extack);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
index 9eba8fa684ae..dfe070434cbe 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
@@ -787,6 +787,142 @@ static void mlxsw_sp_nve_fdb_clear_offload(struct mlxsw_sp *mlxsw_sp,
 	ops->fdb_clear_offload(nve_dev, vni);
 }
 
+struct mlxsw_sp_nve_ipv6_ht_key {
+	u8 mac[ETH_ALEN];
+	u16 fid_index;
+};
+
+struct mlxsw_sp_nve_ipv6_ht_node {
+	struct rhash_head ht_node;
+	struct list_head list;
+	struct mlxsw_sp_nve_ipv6_ht_key key;
+	struct in6_addr addr6;
+};
+
+static const struct rhashtable_params mlxsw_sp_nve_ipv6_ht_params = {
+	.key_len = sizeof(struct mlxsw_sp_nve_ipv6_ht_key),
+	.key_offset = offsetof(struct mlxsw_sp_nve_ipv6_ht_node, key),
+	.head_offset = offsetof(struct mlxsw_sp_nve_ipv6_ht_node, ht_node),
+};
+
+int mlxsw_sp_nve_ipv6_addr_kvdl_set(struct mlxsw_sp *mlxsw_sp,
+				    const struct in6_addr *addr6,
+				    u32 *p_kvdl_index)
+{
+	return mlxsw_sp_ipv6_addr_kvdl_index_get(mlxsw_sp, addr6, p_kvdl_index);
+}
+
+void mlxsw_sp_nve_ipv6_addr_kvdl_unset(struct mlxsw_sp *mlxsw_sp,
+				       const struct in6_addr *addr6)
+{
+	mlxsw_sp_ipv6_addr_put(mlxsw_sp, addr6);
+}
+
+static struct mlxsw_sp_nve_ipv6_ht_node *
+mlxsw_sp_nve_ipv6_ht_node_lookup(struct mlxsw_sp *mlxsw_sp, const char *mac,
+				 u16 fid_index)
+{
+	struct mlxsw_sp_nve_ipv6_ht_key key = {};
+
+	ether_addr_copy(key.mac, mac);
+	key.fid_index = fid_index;
+	return rhashtable_lookup_fast(&mlxsw_sp->nve->ipv6_ht, &key,
+				      mlxsw_sp_nve_ipv6_ht_params);
+}
+
+static int mlxsw_sp_nve_ipv6_ht_insert(struct mlxsw_sp *mlxsw_sp,
+				       const char *mac, u16 fid_index,
+				       const struct in6_addr *addr6)
+{
+	struct mlxsw_sp_nve_ipv6_ht_node *ipv6_ht_node;
+	struct mlxsw_sp_nve *nve = mlxsw_sp->nve;
+	int err;
+
+	ipv6_ht_node = kzalloc(sizeof(*ipv6_ht_node), GFP_KERNEL);
+	if (!ipv6_ht_node)
+		return -ENOMEM;
+
+	ether_addr_copy(ipv6_ht_node->key.mac, mac);
+	ipv6_ht_node->key.fid_index = fid_index;
+	ipv6_ht_node->addr6 = *addr6;
+
+	err = rhashtable_insert_fast(&nve->ipv6_ht, &ipv6_ht_node->ht_node,
+				     mlxsw_sp_nve_ipv6_ht_params);
+	if (err)
+		goto err_rhashtable_insert;
+
+	list_add(&ipv6_ht_node->list, &nve->ipv6_addr_list);
+
+	return 0;
+
+err_rhashtable_insert:
+	kfree(ipv6_ht_node);
+	return err;
+}
+
+static void
+mlxsw_sp_nve_ipv6_ht_remove(struct mlxsw_sp *mlxsw_sp,
+			    struct mlxsw_sp_nve_ipv6_ht_node *ipv6_ht_node)
+{
+	struct mlxsw_sp_nve *nve = mlxsw_sp->nve;
+
+	list_del(&ipv6_ht_node->list);
+	rhashtable_remove_fast(&nve->ipv6_ht, &ipv6_ht_node->ht_node,
+			       mlxsw_sp_nve_ipv6_ht_params);
+	kfree(ipv6_ht_node);
+}
+
+int
+mlxsw_sp_nve_ipv6_addr_map_replace(struct mlxsw_sp *mlxsw_sp, const char *mac,
+				   u16 fid_index,
+				   const struct in6_addr *new_addr6)
+{
+	struct mlxsw_sp_nve_ipv6_ht_node *ipv6_ht_node;
+
+	ASSERT_RTNL();
+
+	ipv6_ht_node = mlxsw_sp_nve_ipv6_ht_node_lookup(mlxsw_sp, mac,
+							fid_index);
+	if (!ipv6_ht_node)
+		return mlxsw_sp_nve_ipv6_ht_insert(mlxsw_sp, mac, fid_index,
+						   new_addr6);
+
+	mlxsw_sp_ipv6_addr_put(mlxsw_sp, &ipv6_ht_node->addr6);
+	ipv6_ht_node->addr6 = *new_addr6;
+	return 0;
+}
+
+void mlxsw_sp_nve_ipv6_addr_map_del(struct mlxsw_sp *mlxsw_sp, const char *mac,
+				    u16 fid_index)
+{
+	struct mlxsw_sp_nve_ipv6_ht_node *ipv6_ht_node;
+
+	ASSERT_RTNL();
+
+	ipv6_ht_node = mlxsw_sp_nve_ipv6_ht_node_lookup(mlxsw_sp, mac,
+							fid_index);
+	if (WARN_ON(!ipv6_ht_node))
+		return;
+
+	mlxsw_sp_nve_ipv6_ht_remove(mlxsw_sp, ipv6_ht_node);
+}
+
+static void mlxsw_sp_nve_ipv6_addr_flush_by_fid(struct mlxsw_sp *mlxsw_sp,
+						u16 fid_index)
+{
+	struct mlxsw_sp_nve_ipv6_ht_node *ipv6_ht_node, *tmp;
+	struct mlxsw_sp_nve *nve = mlxsw_sp->nve;
+
+	list_for_each_entry_safe(ipv6_ht_node, tmp, &nve->ipv6_addr_list,
+				 list) {
+		if (ipv6_ht_node->key.fid_index != fid_index)
+			continue;
+
+		mlxsw_sp_ipv6_addr_put(mlxsw_sp, &ipv6_ht_node->addr6);
+		mlxsw_sp_nve_ipv6_ht_remove(mlxsw_sp, ipv6_ht_node);
+	}
+}
+
 int mlxsw_sp_nve_fid_enable(struct mlxsw_sp *mlxsw_sp, struct mlxsw_sp_fid *fid,
 			    struct mlxsw_sp_nve_params *params,
 			    struct netlink_ext_ack *extack)
@@ -845,6 +981,7 @@ void mlxsw_sp_nve_fid_disable(struct mlxsw_sp *mlxsw_sp,
 
 	mlxsw_sp_nve_flood_ip_flush(mlxsw_sp, fid);
 	mlxsw_sp_nve_fdb_flush_by_fid(mlxsw_sp, fid_index);
+	mlxsw_sp_nve_ipv6_addr_flush_by_fid(mlxsw_sp, fid_index);
 
 	if (WARN_ON(mlxsw_sp_fid_nve_ifindex(fid, &nve_ifindex) ||
 		    mlxsw_sp_fid_vni(fid, &vni)))
@@ -981,7 +1118,13 @@ int mlxsw_sp_nve_init(struct mlxsw_sp *mlxsw_sp)
 	err = rhashtable_init(&nve->mc_list_ht,
 			      &mlxsw_sp_nve_mc_list_ht_params);
 	if (err)
-		goto err_rhashtable_init;
+		goto err_mc_rhashtable_init;
+
+	err = rhashtable_init(&nve->ipv6_ht, &mlxsw_sp_nve_ipv6_ht_params);
+	if (err)
+		goto err_ipv6_rhashtable_init;
+
+	INIT_LIST_HEAD(&nve->ipv6_addr_list);
 
 	err = mlxsw_sp_nve_qos_init(mlxsw_sp);
 	if (err)
@@ -1000,8 +1143,10 @@ int mlxsw_sp_nve_init(struct mlxsw_sp *mlxsw_sp)
 err_nve_resources_query:
 err_nve_ecn_init:
 err_nve_qos_init:
+	rhashtable_destroy(&nve->ipv6_ht);
+err_ipv6_rhashtable_init:
 	rhashtable_destroy(&nve->mc_list_ht);
-err_rhashtable_init:
+err_mc_rhashtable_init:
 	mlxsw_sp->nve = NULL;
 	kfree(nve);
 	return err;
@@ -1010,6 +1155,8 @@ int mlxsw_sp_nve_init(struct mlxsw_sp *mlxsw_sp)
 void mlxsw_sp_nve_fini(struct mlxsw_sp *mlxsw_sp)
 {
 	WARN_ON(mlxsw_sp->nve->num_nve_tunnels);
+	WARN_ON(!list_empty(&mlxsw_sp->nve->ipv6_addr_list));
+	rhashtable_destroy(&mlxsw_sp->nve->ipv6_ht);
 	rhashtable_destroy(&mlxsw_sp->nve->mc_list_ht);
 	kfree(mlxsw_sp->nve);
 	mlxsw_sp->nve = NULL;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h
index 98d1fdc25eac..0d21de1d0395 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h
@@ -23,6 +23,8 @@ struct mlxsw_sp_nve_config {
 struct mlxsw_sp_nve {
 	struct mlxsw_sp_nve_config config;
 	struct rhashtable mc_list_ht;
+	struct rhashtable ipv6_ht;
+	struct list_head ipv6_addr_list; /* Saves hash table nodes. */
 	struct mlxsw_sp *mlxsw_sp;
 	const struct mlxsw_sp_nve_ops **nve_ops_arr;
 	unsigned int num_nve_tunnels;	/* Protected by RTNL */
-- 
2.31.1

