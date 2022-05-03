Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED78D517CB1
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 06:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbiECErM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 00:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiECErB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 00:47:01 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2084.outbound.protection.outlook.com [40.107.212.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9413E5C5
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 21:43:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S729jQZ+nw/CMKDkiAFDyibK42POUMjz7A3BFj1bAiRI5uBzWSiRk+YfgHuCkDxwTf8jlH/d8PGsx624BiPqfCnePaY0yoCMP0aH+S3WTHd4CZ5BtimpDfnexrfSg6QRKhqwGTnBYRPBSlYuqTHEP3JdMtMOZ9sTihMyf3aSSdAmaVFLVdDjXlr8TQ8Ea2C0/9kAJieZo4T4Ppy6vRHp/bDFcWms961Gr42wi2AQj/ho9YaQfpuUnYZ7OFGwZ1fkBWv+oZeFTOENOyicayMZnwV8biKph3Zmejyq+Aq1uTxi4bPWJgSWLkQyJASbIV90CqqO6gbU6sHQCPYy7QUdoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VytwCgDVDWSwwq+sgval8rjXZRB/vIgJMYfb5+KJobQ=;
 b=SuuKWOkZjMowxhk2B9h2/ZCKcRwZqaZcxu6mySihxiQrUciJ0j3QQ9mzqm1tzFlvGxNdqRE4BC/4uOTKzDNFTyFUmnJalj8kwpvdaGcT+eVs7bTWK+UPP0vf/JzcvuNGrpMg2RJkH6yfSSW4FaYq0B/ePnK2HkuuL0fd/eWBQvULh4zlb+i02KTUd6A9kydS50zLBI6zfY/+iMaf3JTr1NUo39WXPdW0bXkz9eT0ZKWWhPbPbeehQtMLKdwuA8yTdOv5poqt2GWqo2l7gLua4HAKBQSwg5baVtE3rWj4qZWoTZTGHyFNEsgPRoGqHiJmiyuAoE1xtKkeNuYIhEzjdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VytwCgDVDWSwwq+sgval8rjXZRB/vIgJMYfb5+KJobQ=;
 b=f6duNkDvnvw/oHnHh4D8RKmEapaRT0JbuW0uxlPTAPXfoF0bsvtLH1gWWqannYKu+Z9ge4oFKm3tyvdkU/4KQzrzQUzZKrP6sT8buphKC+0sIZC++02kBplIe/O9yKqSlUtOnFUncdbi+tb6dK6H2lpf3F5AxR7MS5cPAJ6NWAZxBvwtEzfn/luf2cSLyRym6rJtUS/uTiQNszxTwF2uzEjAQRzH5o3Wbtyx95mLlun8jI3fJwbrqx4iKEf+IuP+QyMcKeXLo0oC/tn80vgyvS5uEn9pm9C3eg13v61MSGrUsZufrf6FpFkViAVdFg/Nkav5A2MDN6cx9t5j/Jouyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 04:43:28 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 04:43:28 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 08/15] net/mlx5: fs, split software and IFC flow destination definitions
Date:   Mon,  2 May 2022 21:42:02 -0700
Message-Id: <20220503044209.622171-9-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220503044209.622171-1-saeedm@nvidia.com>
References: <20220503044209.622171-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0028.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::41) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e78762e-ead5-473b-2772-08da2cbf779d
X-MS-TrafficTypeDiagnostic: BY5PR12MB4322:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4322F167C7B86DB790E42433B3C09@BY5PR12MB4322.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CjfHGQSEYu3DDic7lb1+SHnzKI76ilN1lT6rQhU3e+kpHGx+LEqk1fk78Mz4doJ1wemyu+m6yXBa9ITEPbDlhdMvJC8s2tw6ieSbx1hKWRN/L9dYmUteH4Z4oUquqxNmCP10eOumr4x8SYHQoDDWSC6Q4h4O/TpkT1w2Tex/gLJezcY2TnPEUY5Rvy8EhL/77D0lNAquzG4Sm2feEMVqXB5PhMZNalw1q2KB6LNz9iS1GMiFKHOFKKgFCk3vARRVSQbTVA4uJAbwkTMvcTg02XTn45tdEfkD9y/jQPE4fPHmYrxjanCLvWaQPEtpWi9EnZFm9bg1ATgMrJykK/mjUU1oifbxaonM9LSXAiIOenXIjSLrQyB+NqMMG0JVUTCWC1vd1/ALffERoeoQMFCJ4vD5D39Z2dVhD2wR5j3694m/cEI9lJedfPzOkVa2K1spQpGi/2AGke/xCYc97kWgMvpOPnSUjKWYW/jjsurpFib7k/RNNoQ1w5QFbTiWpSYvDKEO8bstQg/fz/sncmIyx8Y08knueE9HP7aLBLlwGu4jcb5t0zcJiwpbI/DIIjlGP4eIJoWKrP19yQAguQnuc/4x0zmIAyrMSq325TXIR+ezjUuAgA4TiNGjjgAL7WXywbgb8uZ48Dr6z+qHFgqVxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66476007)(66556008)(8936002)(6666004)(8676002)(66946007)(83380400001)(6512007)(6486002)(1076003)(2906002)(508600001)(86362001)(2616005)(186003)(36756003)(107886003)(5660300002)(316002)(6506007)(38100700002)(110136005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iJOW7RbSuG2GfkxJgnEInWDqQwNbui3J0GXv8nbX/oMguteGtCvK7y5bSJyo?=
 =?us-ascii?Q?mIzz9HNDmmj8fyBogDxFErRwG0RiE/PXZOOT6rDTl70yExm1yHF/hG+yZEty?=
 =?us-ascii?Q?DQ/E3iGTSZID5CklK0xiVZcE+UnSljDrUdQdrBwNYpCo2SA/bfFKp9WTs7zw?=
 =?us-ascii?Q?jFhjh9+AtrBGz08QKmF7lTIhFPU5BmFgmF+2+FhkMCywky2rC4VRfhzC1KKv?=
 =?us-ascii?Q?mXsuEPuFHy8OORF2jrC7iT8ILu2YDfSShheqtqhfhKAGC0eSz3kbehHqfAnd?=
 =?us-ascii?Q?2R3sRFXlKDWvtCdIvQrTgrPT2u8DpjzY3dwhSuaBdRL9tf7PJXgIgJP2p0zU?=
 =?us-ascii?Q?OFI0J7k6lI6IbaEyticJxCf8OJbZyDn/uEpX34aXEVSLOWBXrfNO/oDNwVX2?=
 =?us-ascii?Q?Z3ZwWtG1ADA6KBWVB/q52xDxYj0y5ns1TkPWCMCR/FGnuCHuhvD4OerNvtJf?=
 =?us-ascii?Q?NH2RCt0pMeFSixGrGyvRmiNBoyDV9zyXZYVelQRimeUEOBO6qCYJ/9iZrKSz?=
 =?us-ascii?Q?qA5OUwr5N6EVpPKm7Z/J+hVHzoERswxrU8dZFFhrdTvl+/f0IrrudrzZDYeB?=
 =?us-ascii?Q?5t++LibVo6qzlqC48smNWJkmhlmoOzBUXLsqZ5NcwnsyTUe0JT+5ZZQ+qtz/?=
 =?us-ascii?Q?8De7uDD+WNxfkI4hi/UXD/vlcATz3UJdjuD+AfBht5K+DCcfjCI0AnJetFq9?=
 =?us-ascii?Q?NheRX2GWjcHLIjqyqGoDwWBlCdxuABqoJpIyFgzYKqVs1O8KdEbzQNvcGOpz?=
 =?us-ascii?Q?XgADs8cGaED0KBX++SE/QbWuKV6AHMADHfwjUI3hMNC1kWlZhqpxOkdtKXfc?=
 =?us-ascii?Q?GoocEOcCWpWkGgoM/3w01uG2jmw7SGszjflV6nBsL53j1Z2UJBvOBTbXkRQj?=
 =?us-ascii?Q?NoGP0hdmp/Lm+jB8z0wAtlc4zxzn6iEy3G+2GmgIoA8GVm8J2yuY9nhPcZNj?=
 =?us-ascii?Q?PKIFHmDp9VzD6xci8X0OYY8GAQKYin6+HiUbr0TeCizKdpep4/+eZESW1/2Z?=
 =?us-ascii?Q?q5zPLDToDxhhLVIqWpiNoT5tYDr4+wmYI8iPc5f+g1simXJHGuJqIHHqdtWy?=
 =?us-ascii?Q?AORZj9TWv6ju6rdHVF+EcLjs0v2LFb3ITKVc/Xrt26kszIreXUelK082nJEE?=
 =?us-ascii?Q?4jWQhWYISUq9b0lxXcM7f+O6WfPLwd56IdwRrviHuA04s7f1cmWQYllkSF6S?=
 =?us-ascii?Q?1o/LltL9y+T4Q9q/Os7B2UlvHutX8oEPbWV4DY/yMhUlx6CLc2/ZNJHR2ik2?=
 =?us-ascii?Q?nW6Y2Wk8gdAxXF0+hLQDnbj00CdBoI+ncRrhhr1qPed6+FRBHb3Jn6Zu0DQf?=
 =?us-ascii?Q?pFFp2LoXEhGCG1PmwXgicrrMKA5WHpZxIGPnN36bloCFyiHP7YPKkEC1nDRw?=
 =?us-ascii?Q?CFzojwnu3JPGNXUHyz49av2d+8O3tNPGo6n41HQ6ji6U6B8s9qr8e5WVeaTF?=
 =?us-ascii?Q?11F8edjiGo0rtM8p6MMXdwKPKfMCiuCyar9YPT8nE3M4hJ/Nxzbz/pSM9ncK?=
 =?us-ascii?Q?vA5VanxtngMDNAsU3FwLa0rrMvpYg/VrxgXkbXB91/a9VSgqMqef3a2A6H8E?=
 =?us-ascii?Q?X0tgzoHPL7/dq5qjlnip3GUXEly27s18Ww5MoCxdt9/kTMu1RarJfqCtBUwv?=
 =?us-ascii?Q?L1PgaUb2S4imyhvCexLXAW72DbZ04KCw5kFlc9mYQJ5z17ee5kPlQcO0Ckms?=
 =?us-ascii?Q?s/uVBJVdKXd75+rzhdoev4fpslA7daTO5zXYLHW9ldt/fLmJteZiqk3BvcHg?=
 =?us-ascii?Q?HHhpf/eq0CHltlBOJvWaYnQCkmH4olY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e78762e-ead5-473b-2772-08da2cbf779d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 04:43:28.5072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z2lbpET2J+GqxX7yckBBEuv8soNcU/VbfoDkqjs4oZcn6vOsWABANeB7Kj7W7ngi06W+15C7n4ic1VbQPwGeVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4322
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Separate flow destinations between software and IFC.
Flow destination type passed by callers was used as the input in
firmware commands and over the years software only types were added
which resulted in mixing between the two.

Create an IFC enum that contains only the flow destinations defined
when talking to the firmware.

Now that there is a proper software only enum for flow destinations
the hardcoded values can be removed as the values are no longer used
in firmware commands.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c | 13 ++++++++++---
 .../mellanox/mlx5/core/steering/dr_cmd.c         | 16 ++++++++++++----
 include/linux/mlx5/fs.h                          | 11 +++++++++++
 include/linux/mlx5/mlx5_ifc.h                    | 16 ++++++----------
 4 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index 33e9f86cf7d4..a5662cb46660 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -571,7 +571,9 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 		int list_size = 0;
 
 		list_for_each_entry(dst, &fte->node.children, node.list) {
-			unsigned int id, type = dst->dest_attr.type;
+			enum mlx5_flow_destination_type type = dst->dest_attr.type;
+			enum mlx5_ifc_flow_destination_type ifc_type;
+			unsigned int id;
 
 			if (type == MLX5_FLOW_DESTINATION_TYPE_COUNTER)
 				continue;
@@ -579,10 +581,11 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 			switch (type) {
 			case MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE_NUM:
 				id = dst->dest_attr.ft_num;
-				type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+				ifc_type = MLX5_IFC_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 				break;
 			case MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE:
 				id = dst->dest_attr.ft->id;
+				ifc_type = MLX5_IFC_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 				break;
 			case MLX5_FLOW_DESTINATION_TYPE_UPLINK:
 			case MLX5_FLOW_DESTINATION_TYPE_VPORT:
@@ -596,8 +599,10 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 				if (type == MLX5_FLOW_DESTINATION_TYPE_UPLINK) {
 					/* destination_id is reserved */
 					id = 0;
+					ifc_type = MLX5_IFC_FLOW_DESTINATION_TYPE_UPLINK;
 					break;
 				}
+				ifc_type = MLX5_IFC_FLOW_DESTINATION_TYPE_VPORT;
 				id = dst->dest_attr.vport.num;
 				if (extended_dest &&
 				    dst->dest_attr.vport.pkt_reformat) {
@@ -612,13 +617,15 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 				break;
 			case MLX5_FLOW_DESTINATION_TYPE_FLOW_SAMPLER:
 				id = dst->dest_attr.sampler_id;
+				ifc_type = MLX5_IFC_FLOW_DESTINATION_TYPE_FLOW_SAMPLER;
 				break;
 			default:
 				id = dst->dest_attr.tir_num;
+				ifc_type = MLX5_IFC_FLOW_DESTINATION_TYPE_TIR;
 			}
 
 			MLX5_SET(dest_format_struct, in_dests, destination_type,
-				 type);
+				 ifc_type);
 			MLX5_SET(dest_format_struct, in_dests, destination_id, id);
 			in_dests += dst_cnt_size;
 			list_size++;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 4dd619d238cc..728ccb950fec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -311,7 +311,7 @@ int mlx5dr_cmd_set_fte_modify_and_vport(struct mlx5_core_dev *mdev,
 
 	in_dests = MLX5_ADDR_OF(flow_context, in_flow_context, destination);
 	MLX5_SET(dest_format_struct, in_dests, destination_type,
-		 MLX5_FLOW_DESTINATION_TYPE_VPORT);
+		 MLX5_IFC_FLOW_DESTINATION_TYPE_VPORT);
 	MLX5_SET(dest_format_struct, in_dests, destination_id, vport);
 
 	err = mlx5_cmd_exec(mdev, in, inlen, out, sizeof(out));
@@ -719,7 +719,9 @@ int mlx5dr_cmd_set_fte(struct mlx5_core_dev *dev,
 		int list_size = 0;
 
 		for (i = 0; i < fte->dests_size; i++) {
-			unsigned int id, type = fte->dest_arr[i].type;
+			enum mlx5_flow_destination_type type = fte->dest_arr[i].type;
+			enum mlx5_ifc_flow_destination_type ifc_type;
+			unsigned int id;
 
 			if (type == MLX5_FLOW_DESTINATION_TYPE_COUNTER)
 				continue;
@@ -727,10 +729,12 @@ int mlx5dr_cmd_set_fte(struct mlx5_core_dev *dev,
 			switch (type) {
 			case MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE_NUM:
 				id = fte->dest_arr[i].ft_num;
-				type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+				ifc_type = MLX5_IFC_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 				break;
 			case MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE:
 				id = fte->dest_arr[i].ft_id;
+				ifc_type = MLX5_IFC_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+
 				break;
 			case MLX5_FLOW_DESTINATION_TYPE_UPLINK:
 			case MLX5_FLOW_DESTINATION_TYPE_VPORT:
@@ -740,8 +744,10 @@ int mlx5dr_cmd_set_fte(struct mlx5_core_dev *dev,
 						 destination_eswitch_owner_vhca_id_valid,
 						 !!(fte->dest_arr[i].vport.flags &
 						    MLX5_FLOW_DEST_VPORT_VHCA_ID));
+					ifc_type = MLX5_IFC_FLOW_DESTINATION_TYPE_VPORT;
 				} else {
 					id = 0;
+					ifc_type = MLX5_IFC_FLOW_DESTINATION_TYPE_UPLINK;
 					MLX5_SET(dest_format_struct, in_dests,
 						 destination_eswitch_owner_vhca_id_valid, 1);
 				}
@@ -761,13 +767,15 @@ int mlx5dr_cmd_set_fte(struct mlx5_core_dev *dev,
 				break;
 			case MLX5_FLOW_DESTINATION_TYPE_FLOW_SAMPLER:
 				id = fte->dest_arr[i].sampler_id;
+				ifc_type = MLX5_IFC_FLOW_DESTINATION_TYPE_FLOW_SAMPLER;
 				break;
 			default:
 				id = fte->dest_arr[i].tir_num;
+				ifc_type = MLX5_IFC_FLOW_DESTINATION_TYPE_TIR;
 			}
 
 			MLX5_SET(dest_format_struct, in_dests, destination_type,
-				 type);
+				 ifc_type);
 			MLX5_SET(dest_format_struct, in_dests, destination_id, id);
 			in_dests += dst_cnt_size;
 			list_size++;
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index e3bfed68b08a..9da9df9ae751 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -40,6 +40,17 @@
 
 #define MLX5_SET_CFG(p, f, v) MLX5_SET(create_flow_group_in, p, f, v)
 
+enum mlx5_flow_destination_type {
+	MLX5_FLOW_DESTINATION_TYPE_VPORT,
+	MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE,
+	MLX5_FLOW_DESTINATION_TYPE_TIR,
+	MLX5_FLOW_DESTINATION_TYPE_FLOW_SAMPLER,
+	MLX5_FLOW_DESTINATION_TYPE_UPLINK,
+	MLX5_FLOW_DESTINATION_TYPE_PORT,
+	MLX5_FLOW_DESTINATION_TYPE_COUNTER,
+	MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE_NUM,
+};
+
 enum {
 	MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO	= 1 << 16,
 	MLX5_FLOW_CONTEXT_ACTION_ENCRYPT	= 1 << 17,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 7d2d0ba82144..7f4ec9faa180 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1806,16 +1806,12 @@ struct mlx5_ifc_cmd_hca_cap_2_bits {
 	u8	   reserved_at_c0[0x740];
 };
 
-enum mlx5_flow_destination_type {
-	MLX5_FLOW_DESTINATION_TYPE_VPORT        = 0x0,
-	MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE   = 0x1,
-	MLX5_FLOW_DESTINATION_TYPE_TIR          = 0x2,
-	MLX5_FLOW_DESTINATION_TYPE_FLOW_SAMPLER = 0x6,
-	MLX5_FLOW_DESTINATION_TYPE_UPLINK       = 0x8,
-
-	MLX5_FLOW_DESTINATION_TYPE_PORT         = 0x99,
-	MLX5_FLOW_DESTINATION_TYPE_COUNTER      = 0x100,
-	MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE_NUM = 0x101,
+enum mlx5_ifc_flow_destination_type {
+	MLX5_IFC_FLOW_DESTINATION_TYPE_VPORT        = 0x0,
+	MLX5_IFC_FLOW_DESTINATION_TYPE_FLOW_TABLE   = 0x1,
+	MLX5_IFC_FLOW_DESTINATION_TYPE_TIR          = 0x2,
+	MLX5_IFC_FLOW_DESTINATION_TYPE_FLOW_SAMPLER = 0x6,
+	MLX5_IFC_FLOW_DESTINATION_TYPE_UPLINK       = 0x8,
 };
 
 enum mlx5_flow_table_miss_action {
-- 
2.35.1

