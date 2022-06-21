Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E447552D14
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347433AbiFUIfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347674AbiFUIfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:35:19 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3692324965
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 01:35:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNgcIO53VBJSwJWR4YI9orHDBmBxj0kAbfRbI96ZDMgfgDOFiNGg3kjWIL1TL9vb25Cv4RAfzIiG6aVL4tPxttzhwLC0Whf39esrfM8V2vw46mLQ+UHOEEjBiy40ohxF0VYWEHVYpD2QvOSFaGlpji1HUwJywRPGyyKBjYCUvLFVLToTrwwvjO6Nejx4PQ0LT93nQ9EXKw++0cE6xw767HRX15zb3IWuR0xqTqBKDekEFie0S/DrEQOvqtWt1XvWo8+LOD4ELRqoPHsavKDL/3VessXr6hKZPxfobA46o1kYtiXlgp7z9XJoxWTkWINA2qX82HvCO4FWaxG+Z8gqJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mNd4qA0n/grUxnzJMdcH39+kHyVq0vIE97DnsYjU4Xc=;
 b=D1C98eFMUlAxcaYu0t/EcIJy5MSkCCp2jdtdK9LH4a6hsaBcSV0/iULU3Y/nlEZ7dC+klUagLbMaZZPq7/mEpiOMkixa/uYTfAITOhrYxOcYAyzL5K/eMsLJHutq88tEE/fGeBhf70ZWq9sLQpUdWjzbLZfmJhJ8F975PxyqA1kUzLTMohioY7H7DKwphmMatyi2F7hz5e7WWsrxBYfWszgThiPe+gy4wa6VirDDgne4syMC5B/2BpygYsIZJCgbWQH5O0+0KnpYG3dG3w1acWytzxBaRJK5W8vqL8akYE7/mlFZFheHc7g75Dsupsha3TT5ebtBE/IHilT6nl5PZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNd4qA0n/grUxnzJMdcH39+kHyVq0vIE97DnsYjU4Xc=;
 b=D2qY9B4hqjrjrk4DFiDT0TFQmZmofGJEXK3GNcVZJe6F71OeCC+HJXuFCMouJkT8ep9DgAZsG2WnsMwQ4zm9kE3Za6B0k4fwAUNm3d859/A59pxxbRlRydNS57KCKfYG+mnaeUPerKpvkM5yJsoQh6A+s6/rrpkeaoadycrgeBQfksTI74LKhRtMQxaA+8i9947iG+MVIn2d+EJRMGPbglA1+Y8vEzK6rPLLpbje+cnm+MlxRhlq0CMAVkAPOgVsfKJ54xVGp51Q9dkrAVHfmD4hllb1bHgaexGWE5KWbQHEvf5jygOJvh133vmJ9+j3/oiUUX02tKvnvh8W3VV+Qw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH2PR12MB3832.namprd12.prod.outlook.com (2603:10b6:610:24::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Tue, 21 Jun
 2022 08:35:16 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Tue, 21 Jun 2022
 08:35:16 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/13] mlxsw: spectrum_switchdev: Convert mlxsw_sp_mc_write_mdb_entry() to return int
Date:   Tue, 21 Jun 2022 11:33:38 +0300
Message-Id: <20220621083345.157664-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220621083345.157664-1-idosch@nvidia.com>
References: <20220621083345.157664-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0161.eurprd07.prod.outlook.com
 (2603:10a6:802:16::48) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cae4c4f4-7b51-4729-edf6-08da5360f79c
X-MS-TrafficTypeDiagnostic: CH2PR12MB3832:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB383275444E84015F1698962BB2B39@CH2PR12MB3832.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 01K9RaTuD56gPE1AcaxKjR1LSYNtASz+DFpGjJuJk2wgra0z95sAgtPn5bfYICpx67KzD8pGhlU2iR+hry9yHH6NgKtE7kN8pAzHXGiG8NP5wHr2Hio8DrQnaKD1R0fNhSJkCNJjQCIqHu9Bkx5gMfiUL27jSZKjIOmLwTU5L5XY2YQPySsXDFw1IRxeWjgMSh/7jbSphRaWZqAhZXCQB1nN9k10LcN5hB4tmHBPL5s6kOAT8iMYBtLFmykaLFYLrexpkZPwN7+eVSwmGb3ljNkfqyVVGiu4LEb9RU7Cp440NSBmqJ0ay/f6I1ngkIpAlEiS172RlizAAm4HHKqa4nejTfOpW/T0QPctpPNprIwCHXs/0VTsxHng52bM9dA+b8PzvAKItjH5HY8fqmvrCoktoqQYP77lQhNGVNZaEgZZSMugADTItCAC8ENrPfWwN7h+HSDDusa5Cs5GaVciEsiQevRD1Fp9pe97apaGKkyJbQ7t6kiyspIgLbF0TmZhQHp1deH96lyujOCS3lmEoD8Pv3NK8DWhnoup+Pcss3x4nvog5kNt9gcGeBxmY2OpZ1Bfn+RectE2xaBEPHXQho+FLyKqq7xAwkpv8Hi1Qcboqj86AEuBV8iVUtInqTUtZ0p/fHhdzNHUCqKQINlJ3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(2616005)(1076003)(38100700002)(186003)(107886003)(41300700001)(36756003)(66946007)(316002)(8676002)(6916009)(66556008)(83380400001)(66476007)(4326008)(8936002)(478600001)(6512007)(86362001)(26005)(6506007)(6486002)(5660300002)(2906002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m/z0Df6hSRp0SRdrzos57C7oQ3tSpgrS9ArxFGMEbyYEPu8DfjysWVJ5Q4rF?=
 =?us-ascii?Q?uVMVcP3GTaWSkJPad9lQ5l72PCRvLSKYYHlckNLF6y/1gqZRDCbXrW+m1ORg?=
 =?us-ascii?Q?UrUZgdkwxmB4szWeXiBaNao6WDwro+e+/VjIaTPYRl3VSmMdPGwABKDBGANI?=
 =?us-ascii?Q?suAK+zjg0PfdFiZSNMIQRzHOGzrMJ+UeM5xFfHRerMi5pqO/yaATQcmAXFEU?=
 =?us-ascii?Q?Cw729lK7sa3cy0HFHUxoLZHr5LZoQeTqN7BBbCeU2QSMSs6dFsfZhSz2dmUJ?=
 =?us-ascii?Q?x0QMVBo4NVMJrXpYZ285WinPSShIosASBOUvcfawL7itJN/0pc0S2v3V939F?=
 =?us-ascii?Q?7zTM2pLGCQ4xdxtCzBIBkWQlrWDzfyY3Y++vEqoNkYN6KkrTgDrpoiLStqy0?=
 =?us-ascii?Q?xHHrmhoOoZc9qX7a5VwhQnbTVqPhTFzsz4BlttjVFx0XUhvCqZvK2DnAktyY?=
 =?us-ascii?Q?mD2nVbwSs1ihZyZHngpjFB308SkPEDe3VJtiFeEy75Z+mgBlVMuTKRIVEopv?=
 =?us-ascii?Q?g11H12SzP5BQ4rVPinlj48yY+ol3O0+p/vmOHdJyB4xChWqj0IGwyyoBrtwk?=
 =?us-ascii?Q?oVWk/AfKFzkRP89qEbTpyqUtxwqAKg3Si5ezuoqhNTp+ACMZvbZTg85eBqbO?=
 =?us-ascii?Q?us+myLEZymb7AmtJ5aYo9mC/nbVuSbvTbAHFearOCSPXVGbecQlVN/miKycI?=
 =?us-ascii?Q?PsNncuF6fqjUP7bpwrcojwf5WcZDxDdqB+v40c2hXVnmoKp6LnwpRdoq6x7t?=
 =?us-ascii?Q?lsUHt3p08quNY9IVkZGQF2H5jIGfPffuQhUNTx7KYv5PMuTrIl9XUnslnoqe?=
 =?us-ascii?Q?cE2ccGbMVn2NMCElpeb5uD5lS0miMnudeRoOe/RltKsks6l5LuXfs8n6nRxM?=
 =?us-ascii?Q?tiDZuPo4EQWmIFxOqRqk5iMcVOIG5Gno5KJNE4YMnLmdDqxuUqo1Fh+oWjRV?=
 =?us-ascii?Q?3dHpsOhH0SQ2K2G6UY0xVGbdaMjGXUgT/bQObAcVLSYzLb6Ch/rlcza2F19q?=
 =?us-ascii?Q?LakVFx6Bz8Ji5xLTiJRX2OhDcvzsja408ca+6ghGmUsPyzxKKoMGbrwLDXdM?=
 =?us-ascii?Q?xdkUNNTsqO1hd00O5yHH7+xhjPw63wLUbV3iy4tjWEFCnqtyig7sxrYdI8DW?=
 =?us-ascii?Q?NoHVmydncGUQpnvl1R22BkWvCY7a17nCm7ahqmblwjmgY1eDrmhlseu37WHQ?=
 =?us-ascii?Q?UHkMElyPKKPFCLEoAUNkp0MrDa7QwMmGQ1hn0ERG6/SKqnxgsj3TiIYGEbnH?=
 =?us-ascii?Q?bXvgIFvUp7YNCAEH+9Wl7l1y6fIu83wVAgN3bWxqeK6cSFAoBtmJQLEXUd50?=
 =?us-ascii?Q?U7GrJn2bxkmLgcdXre42UnvhQGncab1PoMoB+cP1hB31xvhYU5VNFgLh88wh?=
 =?us-ascii?Q?sI5qpdBGHuQjLO/SailcrMcPPY+Tv6UqGQG09BxpW48uRFSIMkCpbqUt+YK2?=
 =?us-ascii?Q?bhO1qpqhSXr9hvX2EQVTc0xLtC+q/M8dq6DPaZ0VzP1xhz6k9B+bJzGeZPh7?=
 =?us-ascii?Q?T3VEuFL3JxrZw9KMqgwZHn7zE5JwmstHy/Fy2UoWIJ7WyiCvOgcvZTUQ6cPc?=
 =?us-ascii?Q?RoCQ2jQxBvQA1HCa9Uu9BW79BJsUNdlCZDC1CDVKI8fMdCHskomGQJdZyd4v?=
 =?us-ascii?Q?7mIF4zd4KC4s/nlNyY7F9clGte+GxMEOPJAilZHFkdmNLALSaJh4/joYVLAC?=
 =?us-ascii?Q?zWittxG+CHRSNMPD245UdVb2slpQH2Cfcqjeqq1oBpkvejrrNBGLOf8Gy+32?=
 =?us-ascii?Q?72McPDiQSw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cae4c4f4-7b51-4729-edf6-08da5360f79c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 08:35:16.5237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j3X4nNPbmpVY+++uK7R3oGvVrkStQnZlJ20yrr299c172EtUuv3ecdWH9BsLU3vQQcbVcgMt1eUDBX2LJrEG+g==
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

The function returns 'false' upon failure and 'true' upon success.
Convert it to the usual scheme of returning integer error codes and
align the callers.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 127ebd10c16e..9043c6cdae89 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -1746,7 +1746,7 @@ mlxsw_sp_mc_get_mrouters_bitmap(unsigned long *flood_bitmap,
 	}
 }
 
-static bool
+static int
 mlxsw_sp_mc_write_mdb_entry(struct mlxsw_sp *mlxsw_sp,
 			    struct mlxsw_sp_mid *mid,
 			    struct mlxsw_sp_bridge_device *bridge_device)
@@ -1759,12 +1759,12 @@ mlxsw_sp_mc_write_mdb_entry(struct mlxsw_sp *mlxsw_sp,
 	mid_idx = find_first_zero_bit(mlxsw_sp->bridge->mids_bitmap,
 				      MLXSW_SP_MID_MAX);
 	if (mid_idx == MLXSW_SP_MID_MAX)
-		return false;
+		return -ENOBUFS;
 
 	num_of_ports = mlxsw_core_max_ports(mlxsw_sp->core);
 	flood_bitmap = bitmap_alloc(num_of_ports, GFP_KERNEL);
 	if (!flood_bitmap)
-		return false;
+		return -ENOMEM;
 
 	bitmap_copy(flood_bitmap, mid->ports_in_mid, num_of_ports);
 	mlxsw_sp_mc_get_mrouters_bitmap(flood_bitmap, bridge_device, mlxsw_sp);
@@ -1774,16 +1774,16 @@ mlxsw_sp_mc_write_mdb_entry(struct mlxsw_sp *mlxsw_sp,
 					    bridge_device->mrouter);
 	bitmap_free(flood_bitmap);
 	if (err)
-		return false;
+		return err;
 
 	err = mlxsw_sp_port_mdb_op(mlxsw_sp, mid->addr, mid->fid, mid_idx,
 				   true);
 	if (err)
-		return false;
+		return err;
 
 	set_bit(mid_idx, mlxsw_sp->bridge->mids_bitmap);
 	mid->in_hw = true;
-	return true;
+	return 0;
 }
 
 static int mlxsw_sp_mc_remove_mdb_entry(struct mlxsw_sp *mlxsw_sp,
@@ -1805,6 +1805,7 @@ mlxsw_sp_mid *__mlxsw_sp_mc_alloc(struct mlxsw_sp *mlxsw_sp,
 				  u16 fid)
 {
 	struct mlxsw_sp_mid *mid;
+	int err;
 
 	mid = kzalloc(sizeof(*mid), GFP_KERNEL);
 	if (!mid)
@@ -1822,7 +1823,8 @@ mlxsw_sp_mid *__mlxsw_sp_mc_alloc(struct mlxsw_sp *mlxsw_sp,
 	if (!bridge_device->multicast_enabled)
 		goto out;
 
-	if (!mlxsw_sp_mc_write_mdb_entry(mlxsw_sp, mid, bridge_device))
+	err = mlxsw_sp_mc_write_mdb_entry(mlxsw_sp, mid, bridge_device);
+	if (err)
 		goto err_write_mdb_entry;
 
 out:
-- 
2.36.1

