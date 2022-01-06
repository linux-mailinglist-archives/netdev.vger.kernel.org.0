Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA2348675B
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 17:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240974AbiAFQHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 11:07:49 -0500
Received: from mail-bn8nam11on2058.outbound.protection.outlook.com ([40.107.236.58]:31232
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240914AbiAFQHs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 11:07:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BeWJKTaxgAIKN6SOFsLNFJ4TuXbxHMs4yczMAzOqoT64ZD7tdTJh1cUGWcdMWImlmN6kDJGLKjAab+ACKvlLSSdx8+WdUREoMtEj+CBideus9SvgMbSvGn64tfxSzDBL/DaWren5XTFn6TK4gZlvzNUke1tbK6FpnkwZILyifcJesAo43XlcWE85wAscIhQ/AC+6kMbBBWQ4A0Idw5Ue/c5zmnCYQQRNgXqvd17Mqd7gAk9k6qHnmhmpPwyaS9HHrQB5JCJbfsZ6JEaodNe+5V2SiQNQx6uHd1Nj3PQ/qv9QSiTwRrsuWyYK+KRlt06wn4/QRpXwJygsrK8+BcJd8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qSMKX0JAqZN8er7iphqSvq58JTv9+OzAotKphdplC0s=;
 b=dA+UkDEBfrKL4Hga/1h5knSH+StA2/t19sC2x0ylyNET8c2BSck9bwkvTKVhJrcLz8e/Q8z6MDxBJJwyTkf+omQt2nSSPlDKGJr55CADSiLR5AvaZz+P64kWaignfZVY3csl0EJ5bwfR8b3s94+GZIm3PGxipnwrmWXO2XJd3UJ64u1gkqMdepERHj+TZE0oVMx1to799pO+/U22QExfnLk12WHlxnKACVSddTEjalr7HkVXTqhO1RQzFLdHw2YFYc/ykz2tozA3SCsmjSBLH1DyrCJmdu2DqsNyYzV0b+1OMvwFKfenRDVDjb7lu9wlJleiTduW2MXPL4txbBChVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qSMKX0JAqZN8er7iphqSvq58JTv9+OzAotKphdplC0s=;
 b=M6hjXhH09hnR782axdMzYqK7dqhSbItgc1P1i3V/O74GafdvuCuaDSVeZoPlNxGeqZohvgOYvc55FlkeiL62MFe9pqbdV2cmyOhnyX3V4tX1WVMGo591SIylXVgqcbksreSCj0TtvkYzqwmexn5BUkhJX3GeFuDqD71u0LdZGqvhFn7qSSGRL7DHwkKDUsdgDy5u52gu/FV+Kqj+IY+VxNeP2ySfKgI4FxH9kF8ydXhdsQ8L3QPthIzUmpWdkM/hh6ztuBaPYKMvpPZ9AlPUojDlmA+V618Eh1hFN2durRYT21O89oV+3TTF1DiDND5TPmhE6IL7vM1A6bVN1M9g9A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1641.namprd12.prod.outlook.com (2603:10b6:4:10::23) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.7; Thu, 6 Jan 2022 16:07:47 +0000
Received: from DM5PR12MB1641.namprd12.prod.outlook.com
 ([fe80::41f2:c3c7:f19:7dfa]) by DM5PR12MB1641.namprd12.prod.outlook.com
 ([fe80::41f2:c3c7:f19:7dfa%11]) with mapi id 15.20.4844.016; Thu, 6 Jan 2022
 16:07:47 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/8] mlxsw: Add operations structure for bloom filter calculation
Date:   Thu,  6 Jan 2022 18:06:50 +0200
Message-Id: <20220106160652.821176-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220106160652.821176-1-idosch@nvidia.com>
References: <20220106160652.821176-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0033.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500::21)
 To DM5PR12MB1641.namprd12.prod.outlook.com (2603:10b6:4:10::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc172523-bad1-4839-7cc8-08d9d12eae0c
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB40584A1432E08FD1EB556C6EB24C9@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j7amcUMm0T4IQDk5/ObqjQTMqWWpf5K37hntrv3GSLEnJvYsyM7P44pdVLMEdyJYK2ftp9xNhbInFAeT52u26tx3Vc/zWxzGlLyS0tvWzAFe5jj3c5i/6uP7FkDk5sZ405TvB1xKOE2MgQ7IYAJcomvmddD4x2u8Oickz61dN+gkluxg2TUcUJBFGVPSOMdFdwd6JjxZ95JGYDuw4UoCaAyqR+sHMV0+Ui3JtDsPoKCGopdKFwBAFhx2/o/JjOQEVNa+fZ+6BzsoBQFyzN1y22BexeTRXh43M/HuysxhlJtY6dlg1m7NcjlYSBdXUAhzvjnJ7B/y4Z3zGgaJiohZYhGkM59y8sEM489rvpLrpqzr5jrOl8DCrALfjCJvVHDmOF0aQUhgTujYBe9dojQ/6wdOICkk2jF05xVp5Bs/UNWyIqdQRqbZCBxEFaovGthSq6EEEYaPcMRT47F3XrzgH5bs0JTfp/WwkPUciiSJz1Dxh/gI9IOHaIbmw+ULuugwwDhgQW+aWh+MmXUSiyze5cwkkpgIOPQInQBzQnisA7JJoG98gQsDjO7I82E3zIg7KTTFy+3Lf4GgQu6QF9yCZOxxCon0TkRssttQjv4kD5L+YduvdiYLQs2wiU9w51kMBQRl8wtLcT83oWI4k/LNLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(6666004)(508600001)(66946007)(66476007)(5660300002)(36756003)(66556008)(6916009)(316002)(86362001)(4326008)(26005)(38100700002)(8676002)(2616005)(83380400001)(6512007)(6486002)(2906002)(1076003)(107886003)(8936002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OxqhsifK/liWd4sop74ntXSDP0sN90tpJRkgNLnyywHwHhObxeYhYn3F8fgF?=
 =?us-ascii?Q?RqoQzeg/LUUbPCzUMIfEH3yolmB/VRkor/f44L1Bf4c150bEWL6SLthzKFVN?=
 =?us-ascii?Q?+k2IaYy9ZFhIkoa0T6Bee4rLZyID+KiONidV5gDoICC+F1b8Q34ChFM3F1Db?=
 =?us-ascii?Q?Yc7MkQRPsnyQzqQNbB+4W+z7jo8TJQzKeZT/acYCd26JQYlkE5FdWCeuvE6j?=
 =?us-ascii?Q?a5U4o97KY/xnuOEr6haErTirFjwPQUvNVjXB/i0wouFDoRsru26xjRM3a81F?=
 =?us-ascii?Q?V5Ectw175OtvXPgAARavzuJN4niyYk6GGBP+891uvdRZiKUHwSJSCF6p7KGe?=
 =?us-ascii?Q?7A8+E7O9r6hb26VAqaMB0C868u8VxS2BYJauxjZww+KQ6y8Bg3XdYiPOdJhz?=
 =?us-ascii?Q?FNt/jbLG95cXHsiU/Lls2v1oOmR69FazEr7ayppTf5yntiS4n50bNcC7z95H?=
 =?us-ascii?Q?imcrWL+X7OLFP6fA2rQ6Kg8oa1D1Xa9DnNi/A20fl5ZxPasA/JyLWMD9hltr?=
 =?us-ascii?Q?p6jOlzxw23iJUyqsvdfdAeEKqRwMGO422ify/QdX3AICrxMBFTLhBLlf5Jic?=
 =?us-ascii?Q?aTsddr09jhDGpLsz4Mc20cJXXZFvXf5W8kPxdLElHYte7fyjWGxG0sNkLTQ3?=
 =?us-ascii?Q?fbSPt2BAwUcDcLJGwlcu1wPo3TlFhIko+IXvGeuFyOiP9Lr4KhkQp9fRwapI?=
 =?us-ascii?Q?Uvurx+OEzr8QtiJ2kM9BnTkBlnsuGPgKH+pgaKbt4SO1WK639aRDCizKEb05?=
 =?us-ascii?Q?QaTwkzAUjdczMtc/cDavd0lUFfVSZhSk1iQDZJKhm/XIQIljwXyi5xAIFn0N?=
 =?us-ascii?Q?LR+kGfv2Snmjyvz7v8nNp0LIpfyG4z552z8Ob1ZEwih62mOjEIYvjINULtjj?=
 =?us-ascii?Q?5CF1p6S0lSnUmIm/PUMIKA5oUqD+lxn//ZrY99LUWZXQR0aNcz5Gmscyz7Uw?=
 =?us-ascii?Q?4m+x4XVtH+VwulbRBkYuv+djge8Y/QQTdrePGqV6HSfbqslJzyxSk/YDv5VR?=
 =?us-ascii?Q?/Q8e+nbOIIghaoq80L2QNuL1Lzam2tW0j2S5nr2obE42Lbf8FuJ/s7nDvMNJ?=
 =?us-ascii?Q?N0Qec2cs0Uw6MCXR84256X0Q1Oc79Z+dnPe6jL+Md65IkWs9BeC5Hw7He9Vk?=
 =?us-ascii?Q?tlMPZDE838RyaOsRtiFoNcmVOuOGU8uEVJufc2nDxmR7uGDPXx4hQ8hEovGw?=
 =?us-ascii?Q?0MoflXRZNt7ZJoadc6i5YjE7kD0El1CFuEyw54eRJ7jRD6xunsXchBrFAaLH?=
 =?us-ascii?Q?3S3dgfcVfpMQgZEJprUcu5mk4310eVQCcVZoM8avg/4J/9ccweTB+8mpRIB3?=
 =?us-ascii?Q?b1uLbaw0rxTyINJ9uS8xMAadGgM0mSLXOGzgDySDMclQCsdjfKvVpEo4GlU7?=
 =?us-ascii?Q?r1DiCOt+wsfrDZa9j7aVivZdOzY3ljK+nISg6hChuHAm0wUJ4X6iP23ZB0EF?=
 =?us-ascii?Q?35n83rPIUtw/rxdVrSG8b+tcb9yiLJbNz2bDSJ96upgTdzvJu328EF/L93wA?=
 =?us-ascii?Q?E9TyL98fPnFWl9BmAFeB/POjmzFPYkolLv2mFrB/0wvl/7aV8MrTFEe7IAGc?=
 =?us-ascii?Q?f4V1Jf5HQsDpO+yxaFn8VWJPy0HHTXjdqbhe+41dahPyx0RS6TSsojlcWM/m?=
 =?us-ascii?Q?lwtGvGufVK4/P9TE6kENwIg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc172523-bad1-4839-7cc8-08d9d12eae0c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1641.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2022 16:07:47.0265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kkbhE+yGoX6I02FTahQS5eNPTxNk9DTByUBJNcCjORyCPFiIyLTQL2/KTr3nVaMeS1yjs6nPW/fo7Ian4m3dFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Spectrum-4 will calculate hash function for bloom filter differently from
the existing ASICs.

There are two changes:
1. Instead of using one hash function to calculate 16 bits output (CRC-16),
   two functions will be used.
2. The chunks will be built differently, without padding.

As preparation for support of Spectrum-4 bloom filter, add 'ops'
structure to allow handling different calculation for different ASICs.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c            | 2 ++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h            | 4 ++++
 .../ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c   | 8 ++++++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.h   | 6 ++++++
 4 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 5251f33af0fb..6e4265c86eb8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3155,6 +3155,7 @@ static int mlxsw_sp2_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->mr_tcam_ops = &mlxsw_sp2_mr_tcam_ops;
 	mlxsw_sp->acl_rulei_ops = &mlxsw_sp2_acl_rulei_ops;
 	mlxsw_sp->acl_tcam_ops = &mlxsw_sp2_acl_tcam_ops;
+	mlxsw_sp->acl_bf_ops = &mlxsw_sp2_acl_bf_ops;
 	mlxsw_sp->nve_ops_arr = mlxsw_sp2_nve_ops_arr;
 	mlxsw_sp->mac_mask = mlxsw_sp2_mac_mask;
 	mlxsw_sp->sb_vals = &mlxsw_sp2_sb_vals;
@@ -3184,6 +3185,7 @@ static int mlxsw_sp3_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->mr_tcam_ops = &mlxsw_sp2_mr_tcam_ops;
 	mlxsw_sp->acl_rulei_ops = &mlxsw_sp2_acl_rulei_ops;
 	mlxsw_sp->acl_tcam_ops = &mlxsw_sp2_acl_tcam_ops;
+	mlxsw_sp->acl_bf_ops = &mlxsw_sp2_acl_bf_ops;
 	mlxsw_sp->nve_ops_arr = mlxsw_sp2_nve_ops_arr;
 	mlxsw_sp->mac_mask = mlxsw_sp2_mac_mask;
 	mlxsw_sp->sb_vals = &mlxsw_sp2_sb_vals;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index a49316d0bd37..e7da6c83c442 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -190,6 +190,7 @@ struct mlxsw_sp {
 	const struct mlxsw_sp_mr_tcam_ops *mr_tcam_ops;
 	const struct mlxsw_sp_acl_rulei_ops *acl_rulei_ops;
 	const struct mlxsw_sp_acl_tcam_ops *acl_tcam_ops;
+	const struct mlxsw_sp_acl_bf_ops *acl_bf_ops;
 	const struct mlxsw_sp_nve_ops **nve_ops_arr;
 	const struct mlxsw_sp_sb_vals *sb_vals;
 	const struct mlxsw_sp_sb_ops *sb_ops;
@@ -1108,6 +1109,9 @@ extern const struct mlxsw_afk_ops mlxsw_sp1_afk_ops;
 extern const struct mlxsw_afk_ops mlxsw_sp2_afk_ops;
 extern const struct mlxsw_afk_ops mlxsw_sp4_afk_ops;
 
+/* spectrum_acl_bloom_filter.c */
+extern const struct mlxsw_sp_acl_bf_ops mlxsw_sp2_acl_bf_ops;
+
 /* spectrum_matchall.c */
 struct mlxsw_sp_mall_ops {
 	int (*sample_add)(struct mlxsw_sp *mlxsw_sp,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
index 3a3c7683b725..c6dab9615a0a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_bloom_filter.c
@@ -190,7 +190,7 @@ mlxsw_sp_acl_bf_entry_add(struct mlxsw_sp *mlxsw_sp,
 
 	mutex_lock(&bf->lock);
 
-	bf_index = mlxsw_sp2_acl_bf_index_get(bf, aregion, aentry);
+	bf_index = mlxsw_sp->acl_bf_ops->index_get(bf, aregion, aentry);
 	rule_index = mlxsw_sp_acl_bf_rule_count_index_get(bf, erp_bank,
 							  bf_index);
 
@@ -233,7 +233,7 @@ mlxsw_sp_acl_bf_entry_del(struct mlxsw_sp *mlxsw_sp,
 
 	mutex_lock(&bf->lock);
 
-	bf_index = mlxsw_sp2_acl_bf_index_get(bf, aregion, aentry);
+	bf_index = mlxsw_sp->acl_bf_ops->index_get(bf, aregion, aentry);
 	rule_index = mlxsw_sp_acl_bf_rule_count_index_get(bf, erp_bank,
 							  bf_index);
 
@@ -281,3 +281,7 @@ void mlxsw_sp_acl_bf_fini(struct mlxsw_sp_acl_bf *bf)
 	mutex_destroy(&bf->lock);
 	kfree(bf);
 }
+
+const struct mlxsw_sp_acl_bf_ops mlxsw_sp2_acl_bf_ops = {
+	.index_get = mlxsw_sp2_acl_bf_index_get,
+};
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.h
index a41df10ade9b..edbbc89e7a71 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.h
@@ -287,6 +287,12 @@ void mlxsw_sp_acl_erps_fini(struct mlxsw_sp *mlxsw_sp,
 
 struct mlxsw_sp_acl_bf;
 
+struct mlxsw_sp_acl_bf_ops {
+	unsigned int (*index_get)(struct mlxsw_sp_acl_bf *bf,
+				  struct mlxsw_sp_acl_atcam_region *aregion,
+				  struct mlxsw_sp_acl_atcam_entry *aentry);
+};
+
 int
 mlxsw_sp_acl_bf_entry_add(struct mlxsw_sp *mlxsw_sp,
 			  struct mlxsw_sp_acl_bf *bf,
-- 
2.33.1

