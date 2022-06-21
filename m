Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044E7552D1D
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348255AbiFUIgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348233AbiFUIgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:36:00 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3947C25EA8
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 01:35:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JLnUeMSDLFcNe75kXK1pwWnBdK4R/IhFZ65sINtg2L4cINwQGBB8Vn1dU8AXNoi4K0dCEC5T1oPLzUKQOSY7jOnxPeMfn26dUosGPHrvlOJBuqsmQJ64mWi+4eVoELNWK2vtzNKxbJ+4uZbPQiGvwvruYBmPQhWY3RcEJX1M6hnKsMS5Ij/XhtuEHgPF3zQb+5M1TE5Y0SvgbamgdG0BRzvWp/UFAQiaeG37tHJqHH0ttuodXWFEfbpl3nsCgu0PxVm3T94hWof9ltEFmDDE3BdstTsAol0U7rThEgn5K06ssQABxsVZPCYz70DnT8tmLjriIC/gRssszjVGwsdbPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NLgEKZb92rXIbypWvKS9adFeeYy+saY2DJzWNtop0os=;
 b=nCU5L14s0J67xWOyiCoFuQ97GK2H4676W7Byw70woAmoB83nqEHbJ5UYJWj8xFtezn5xxxpJoFUPRMopOBZDcYxGwxfNjsV+g0YoRvZLDCOD5muUvrhLFIDjJkQlTKn0S92EKeZX9BAQMAb4N+fWzOJBugOsrBjDS6rlci01V/LCkh2hyfUPqfFYcoNU1CzvnnEWtVY5i+99XqJtFRIiCo1otm+qDHUI8wTE9754MGLbZzLZBIVGjILFM0G8+gIFYJRQ/Q5lUX92oyFEIuWXo3QH3Y8iIno5unhxC9g8jdQwuZzvunBtpY8mpupNI5h5o88sQ0ZchQ6ahqiESWHlnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NLgEKZb92rXIbypWvKS9adFeeYy+saY2DJzWNtop0os=;
 b=N7gNtYB85OxcwCe1TiV+Escg7i0NfMh6t1EsgYVoWgwTNnSgvVk1Oajkh4GPV3tCxxXE6fWt4r4l6cObj8Xi3fjfCUN8V3OPpcPzDzI7s1dWocdlPibZmvr9SY+GaZuKFtOR1WQT5aZIBWdDVWPWyeL9jWYZdj8BKXgST2gWcoOjskUQwMKTr9/BrubTFv7Mib7a87T0YN7Gt9a9gYAdhAk+/Z2h7Lus/AOkdcUt5vKTPqe2i7gz6L0lwXazGYZ4uenYgTf5lup3urLAv8Ld0XldvRpgzP747J0W586X1mjRX2DZMzh1ixMNoKFyvO+Jt0L5JEZSY6N91E/5tk3w6A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3832.namprd12.prod.outlook.com (2603:10b6:610:24::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Tue, 21 Jun
 2022 08:35:54 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Tue, 21 Jun 2022
 08:35:54 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 12/13] mlxsw: spectrum_fid: Use 'fid->fid_offset' when setting VNI
Date:   Tue, 21 Jun 2022 11:33:44 +0300
Message-Id: <20220621083345.157664-13-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220621083345.157664-1-idosch@nvidia.com>
References: <20220621083345.157664-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0186.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::43) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54a1d5c0-ac28-460d-1210-08da53610e39
X-MS-TrafficTypeDiagnostic: CH2PR12MB3832:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB3832398E69B6957C38B852CDB2B39@CH2PR12MB3832.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dL22yEWL4Al5GTVOl5X8S4cZ6utbMxd5clt0wsqeItq2K0IllFKa6tscVc4eAPPkMSLQ8FIO6IO5fO2vXJwCIbiqlDGg25zLkYw36ohzIPNK+8J9PmSnSN/AdThDHp98M8P7HaSit6eVbU+yfZDxXY3RWHhadAy5sYu2BUzgwj1OM+c+83XgW/rCwbY06KMbOZHm2qRD0+M8fh9hwysSZ8WrPFiC+gqTXK/I6JXv8WBkwa7KgaUgfwZFFDLcgjn3XLNyd0p39BPkAntg5KsVfIjuxG39HZ1JFN2yrT2pgjX97Oi+7J8u08pPxDs18yE1DIFWxYU+Qbsyqq8rXmmiJcix5PXtdRVHzr27po3ZpBRcBZW6FMuy8bOFoNRFnv+1xm8PYh7ad2IQtdCFk8XVUE0X7Qnz3YkgR/y8fLQQMw26MmI7fz988/kWLQJJsEfKL1WHISCQVZOGba4fU61w8Psxgto0wJkaT8N0xhCPlAsLvyUR6apdBLL3bNzu+PbltOgCPK5lL8uKLGxBAhOnw9lWKdUsaY6/wS/4zXirzKxZ54Bq/OOiQSGLFQJmN4eTAMjZYeSb5L5OOcADPHW5QWTbkFiDfO1RqaVD8eyNPXrFcaQE+Pdl2Srvj7niDtuoFQMDWC5u6z5SNtYFEW8zjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(2616005)(1076003)(38100700002)(186003)(107886003)(41300700001)(36756003)(66946007)(316002)(8676002)(6916009)(66556008)(83380400001)(66476007)(4326008)(8936002)(478600001)(6512007)(86362001)(26005)(6506007)(6486002)(5660300002)(2906002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oTsR/3oiUjNz+elKAxdpii/prxwlrRKI36aLDkRlo7dpos91odhcYlYPgc/I?=
 =?us-ascii?Q?eEow6BreydmHxBICwUli+72P1qZXwE8ZkkpYJg3tYw/ABhX0YYyKOqueTTS3?=
 =?us-ascii?Q?5NX9h9nh/eEOIBS1UNeMo7dE/Kgw8ZcWZ3NAAyNWTlEvL1S3OAgU/6p9lZrY?=
 =?us-ascii?Q?B3KPUv1nmVVB2w3vl8vAG6YWPYYjBuKheYs5LpSYI5umaH1sJa/tnPlob5Lt?=
 =?us-ascii?Q?gEhuoK/qzXuCnZDTAmaKi0fqOJjDwdx3xU2AIfcXW0WsLZdovfXi2zdE/YRP?=
 =?us-ascii?Q?SWzQrB60OU/JQB9k9GMM+ldNn8m7OJDShVpeIsXXzaN+8P/t14CtG6+3fuk4?=
 =?us-ascii?Q?1LL9MzbNl0faxQeSDHa451fhewnSib92+Jz0oecsAPipzR6lXsPIEByAbabb?=
 =?us-ascii?Q?U4TR3rz2675aV0xdXBu//miTyT1vFPEl2RvumuIhxNRvoofMNyrHqjYmUc2m?=
 =?us-ascii?Q?DCQaKrpVZ2UtfYs49ZbUgxhCRo5tBY4uIlNdf6rlCeBOXZ0LWU5dffVp12N1?=
 =?us-ascii?Q?uth/g0eWhazZPmbvksSahOa2TybCuayoo6GT5+fsjRU3ZLTfFROrmZtu9k2Y?=
 =?us-ascii?Q?XGwbkhDMRlvAMMKcRMatBCBP33ZkEzpOvryEpuDNFH1b7BWNgX2hxxr05yqP?=
 =?us-ascii?Q?dqXDX3VBbYGYPd7kgzwbl6f88elw2vgN2rpi9E/uDZdaKGWOs83TsEv5nYHl?=
 =?us-ascii?Q?oE86x6TbTl1VriMbYpQjLQ8JH/mKNH0MZc88MQh9cyfpKm9FACsuwjoWVg+W?=
 =?us-ascii?Q?mmjoYHE9PSBvsBYWQqSKbLRMRLLis5THhs91SHtsOetxX8S6+BWphGHQ3slU?=
 =?us-ascii?Q?ZOgMsaMMQwCV4kxokeyUyiOTvaHLjzE31/cyxq/o51UNviiKpFunRdGjOfkg?=
 =?us-ascii?Q?IVfIYxayiBWcwAJs+h6+pOL96q6szbIpSZsMwwLhZzfMho4/bPolChqYee/K?=
 =?us-ascii?Q?MigxgfLNJuwZADMHomkZ044MbDfGttlTcKL36JXBgKTqDjJ3IoFzAYhfeT/v?=
 =?us-ascii?Q?aWmHf/A0FjjXVpwI1VWpPSAuK0xjHQZBBWsSVMk/0/GqJelwcnrmAiZWJIGO?=
 =?us-ascii?Q?0zlMeimth7Sqtp9ZFf4cYero+f7vLb++cXTuFBMJ75hgnKiZdfPr4wqq1frh?=
 =?us-ascii?Q?E68tsPs3aex1JEB1jfLYhT+1xzMd4swoymMycxskrmBH7wM8WuQrl1Dq91ZC?=
 =?us-ascii?Q?XYkX2KgsGLVYPDCKRqDf/ieivjucIXGNTiCz8FKLhaGD/ezGRAWW5PyaJdvL?=
 =?us-ascii?Q?Ods/5X2oD4Lv+y0kLf9b86bb6cS87YdzpWSyqNOigkSAlkX9RCYZgJzkFuPf?=
 =?us-ascii?Q?bXsvYlVeTuqtcBd5jMzPxsJlKjiOYFB8hhxlvSIRjFrkXTYCrCS0bn9DbCPf?=
 =?us-ascii?Q?rxT24TG+p3i2RyoieiZD/f8DLk9CgFtQ5AJqc1yPP36mmxj7GIPhM2kM/U1I?=
 =?us-ascii?Q?8eIrkEHDwx9+rzAg+ESACm9coANUfZ8OzAe19IL+0ys24hsmJIQfxIqyziQa?=
 =?us-ascii?Q?qIMvqTu2bfKCsaxyJONn3UCKZmxzjCyq6pO86MOsLUPwWyp7oQ4PqZ32elSH?=
 =?us-ascii?Q?ptvb+DkybcfBxRXF16XkXU+C2ktLg/XnK0FU3X54OV/Uh6JJg1DLs2W3O926?=
 =?us-ascii?Q?YqzY+b5tl4ABshRoANfTmweueHfDLSgSXribMA6yQaZuFsZjiLiVKx5g0WWP?=
 =?us-ascii?Q?mc1SfyO+vGmzMp0W1jhy36LbFYMfNhuNzCT6xwL0DEYl/tIUY6hrCD5YQ3dO?=
 =?us-ascii?Q?rmbxrNlYVg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54a1d5c0-ac28-460d-1210-08da53610e39
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 08:35:54.4556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uNA1bbR1E7Su2pgNtJ2n/+PaNb3lRpFeuRYO2eGq1Gb3xw8Eq+3ncR60yWhSXFz30C81nVcxK4+J0Tx6G9Tz2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3832
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The previous patch added 'fid_offset' field to FID structure. Now, this
field can be used when VNI is set using SFMR register. Currently
'fid_offset' is set to zero, instead, use the new field which is now set
to zero and in the future will be changed.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 25 +++++++++++--------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index df096e2c3822..fe5a60bfbf59 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -420,13 +420,13 @@ static int mlxsw_sp_fid_op(struct mlxsw_sp *mlxsw_sp, u16 fid_index,
 }
 
 static int mlxsw_sp_fid_vni_op(struct mlxsw_sp *mlxsw_sp, u16 fid_index,
-			       __be32 vni, bool vni_valid, u32 nve_flood_index,
-			       bool nve_flood_index_valid)
+			       u16 fid_offset, __be32 vni, bool vni_valid,
+			       u32 nve_flood_index, bool nve_flood_index_valid)
 {
 	char sfmr_pl[MLXSW_REG_SFMR_LEN];
 
 	mlxsw_reg_sfmr_pack(sfmr_pl, MLXSW_REG_SFMR_OP_CREATE_FID, fid_index,
-			    0);
+			    fid_offset);
 	mlxsw_reg_sfmr_vv_set(sfmr_pl, vni_valid);
 	mlxsw_reg_sfmr_vni_set(sfmr_pl, be32_to_cpu(vni));
 	mlxsw_reg_sfmr_vtfp_set(sfmr_pl, nve_flood_index_valid);
@@ -613,8 +613,9 @@ static int mlxsw_sp_fid_8021d_vni_set(struct mlxsw_sp_fid *fid, __be32 vni)
 {
 	struct mlxsw_sp_fid_family *fid_family = fid->fid_family;
 
-	return mlxsw_sp_fid_vni_op(fid_family->mlxsw_sp, fid->fid_index, vni,
-				   true, fid->nve_flood_index,
+	return mlxsw_sp_fid_vni_op(fid_family->mlxsw_sp, fid->fid_index,
+				   fid->fid_offset, vni, true,
+				   fid->nve_flood_index,
 				   fid->nve_flood_index_valid);
 }
 
@@ -622,8 +623,9 @@ static void mlxsw_sp_fid_8021d_vni_clear(struct mlxsw_sp_fid *fid)
 {
 	struct mlxsw_sp_fid_family *fid_family = fid->fid_family;
 
-	mlxsw_sp_fid_vni_op(fid_family->mlxsw_sp, fid->fid_index, 0, false,
-			    fid->nve_flood_index, fid->nve_flood_index_valid);
+	mlxsw_sp_fid_vni_op(fid_family->mlxsw_sp, fid->fid_index,
+			    fid->fid_offset, 0, false, fid->nve_flood_index,
+			    fid->nve_flood_index_valid);
 }
 
 static int mlxsw_sp_fid_8021d_nve_flood_index_set(struct mlxsw_sp_fid *fid,
@@ -632,16 +634,17 @@ static int mlxsw_sp_fid_8021d_nve_flood_index_set(struct mlxsw_sp_fid *fid,
 	struct mlxsw_sp_fid_family *fid_family = fid->fid_family;
 
 	return mlxsw_sp_fid_vni_op(fid_family->mlxsw_sp, fid->fid_index,
-				   fid->vni, fid->vni_valid, nve_flood_index,
-				   true);
+				   fid->fid_offset, fid->vni, fid->vni_valid,
+				   nve_flood_index, true);
 }
 
 static void mlxsw_sp_fid_8021d_nve_flood_index_clear(struct mlxsw_sp_fid *fid)
 {
 	struct mlxsw_sp_fid_family *fid_family = fid->fid_family;
 
-	mlxsw_sp_fid_vni_op(fid_family->mlxsw_sp, fid->fid_index, fid->vni,
-			    fid->vni_valid, 0, false);
+	mlxsw_sp_fid_vni_op(fid_family->mlxsw_sp, fid->fid_index,
+			    fid->fid_offset, fid->vni, fid->vni_valid, 0,
+			    false);
 }
 
 static void
-- 
2.36.1

