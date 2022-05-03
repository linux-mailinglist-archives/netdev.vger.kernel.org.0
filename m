Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11083517CB8
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 06:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbiECErN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 00:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbiECErG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 00:47:06 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2084.outbound.protection.outlook.com [40.107.212.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E65003E5CD
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 21:43:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOsPrMTPdxWsF3D/McPsIApKqlUNv9D2FG+3dQQMkF+xTc+x7CKHEn+kC6BmmgV4qWc2Y9TKnWt3yZoqCbMgArad/Kn+snoshj2GdLOBwQh+Y9a9msXWKGeG9ZR4aS70j+Ltl0yTXDql90Xavi4lXhSzqr3UYa+Wyj6PcWNajBpPEu4IR/wurQo/93PFE7Zi2pUdIOa/iUKK2swqsv3IizcnZYjLGCKT1qNIiZJW/ISxmv1nR1IWys288QsHUFS8yC5qipDTVEkm10oKkBjklL0ZHMoj+98dgufSNZ9ayF4SVdrT2AzY1DEhuc43vJkS+u5MuzrOm/fxXEbeuJcSbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vLU5RJgg1CRJ+Ssid3A8i9JfPEWrbd8/yHStneLgme0=;
 b=hKb0gwVnjZW8U/mBkO4she4Sp+mMgnFjYrYE2pPqIP/bN9yBdYdJ4IRGKtkXpbendrmKCVEyh5zbSUEMfaSxuHqRVPx8X5FkCczreJyV6cRrrBxTfFa2XgNe8eCxdTSvHstFhoMCUDT8mx1mXgq0n5vAtV5XjKGTpVAJBtJuHcXJFcLD7npFIp2OAHlEIL9qIrxDxbLltamAJtl4dihregrOeP9j/T7n77vnzjeJJLLbnozOVDic4/JgOgisxC+rLwjy5/WPBULpQbn/r41TI0EmNpinkeE+LKjmavT8YUGI8562J6hb2YiBd13Zu6ZlOKhi3lYCZmhT3hKm2WttGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vLU5RJgg1CRJ+Ssid3A8i9JfPEWrbd8/yHStneLgme0=;
 b=KJIc6DzCLy0KC8Jzh6K67K8lmycQ+HU1yeExEa4STl3MfWxveskM9EpaWNucmUgYs4uFu5F5TWzShfr9B74x5vJgMgIYm1k1Tx34uxyme0crops/KL+6GbN/jMMgnqszuJPtzK877Xm4YgKEi0W7E5EyiKvHuJgzyY6mqyT3nH3ugvzNBVYV/QTPB3SPstKVd1Swa/SB5aVkoNw/xTl3SXG3iXya4rZ/icy6QOc3ZcPBBIDfi3ktDSbOiIFVoGWTH6uFWEDkP3Zf0EPC80a6oiQMzIp47x3b8g4Qluh6CpIPneUrQz8yVmReUM0aK5O/DK+LHzP/Wyvbo/+NlecxLg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 04:43:31 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 04:43:31 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/15] net/mlx5: fs, add unused destination type
Date:   Mon,  2 May 2022 21:42:05 -0700
Message-Id: <20220503044209.622171-12-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220503044209.622171-1-saeedm@nvidia.com>
References: <20220503044209.622171-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::38) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3a28625-a064-4fa1-d43e-08da2cbf7977
X-MS-TrafficTypeDiagnostic: BY5PR12MB4322:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4322C6C5B27778A67D1F8267B3C09@BY5PR12MB4322.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S18FOq2CmQemMxjHQoP9KnbdjpggePIGEgrp+KRAObDo1upzclHshSXc8Kb6GMsVvCo43/aXg2ANdhgITBk3c8k2BXxTHqRFvpflessm32dPXtzImEWC38Y0rVY2JibuSfEA7/y+dgE9//8RaQrQE34iYGoM38sKxaNHvC22y+2VZwMAHCtCMwrulNuJQaSImAFz6OMM+u8hXdEfTHZPu2dhj/ECzBV3hByOJ75rDKDQg7IHORpXUzddigW02Ad+imF7Ei1tb4NpQPHeQmStGCNMiDaf7vQh2x9XqWv5wmcBOSncFDXcC55Ap7S0iaUPutXPvg3eUuJNN0H2I3lXPq5q1/J65Y0aRKpH6/rAxL123HGx/axConVa3TmMEjVQzDTpY83JJ+H4wj51LL7DQJyvCnPZQmVgGxjWQ7KMXhazayhSVZhdBEWuvx0IxEGJYcS8XF77QJb6YRO72vQRBEP19qvMPmwOLVFR4Qegyv/087y7A56LFs8xFUMirrEu/B8MoURp4ioPNyRLKsJXtl2xaqkh6RdO8o/IGyEaJtmF24A/8MoA1k/2mxBZ5/6Y12BRnugfS15Mcb4TpGl9ew3qrzUUFi1SOiVeNBsHv43dW440NPDxpVl+8PJpSkOA2EN/IlLJQvnGGxPM7WSyaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66476007)(66556008)(8936002)(6666004)(8676002)(66946007)(83380400001)(6512007)(6486002)(1076003)(2906002)(508600001)(86362001)(2616005)(186003)(36756003)(107886003)(5660300002)(316002)(6506007)(38100700002)(110136005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pqaid4lxwzBS+PPNcqGu/zufOZoC/UO7qmN8Jusdv/ma9Y4LlAaE/4Yg1qjZ?=
 =?us-ascii?Q?n2Jhp9e0cjZQyVkIrO//AgR91B0mPN0xtyN/OuauseGVrUSDQqxECiX/8UgV?=
 =?us-ascii?Q?btH/1PA5LLcT0m2DnZtnlJHwuoLP9C7ii3AsCffMqhiFg2OmjW5uYXxXnPx9?=
 =?us-ascii?Q?prw4zpLkC88EPICRtcvkj4Y59yFUAbXKFhsi7EEmuIoB3OepXaSQ9Z9DHxb3?=
 =?us-ascii?Q?pZ1RqgdDieJTS2IWyR9Tv3/fWR399u3BQH5Oz2cw4q9seJxRBQaOuG90zDsA?=
 =?us-ascii?Q?KX+/6hhYwJSSTa2rE9de2uWpruQfQBiAV0wbb5nhE7/tHFEfHRltKnzu2MLc?=
 =?us-ascii?Q?kUBqT42AgQDOw4FqouBR/lOb7o9lQIzPgPVCLNkaErLYar6/xDajQF3qasfI?=
 =?us-ascii?Q?xz26prb0/HN086WRYribvxME47l5XzSNTP4o/2x9+hjaNB2Gzgog0ZhjhOr8?=
 =?us-ascii?Q?o/AphgrEYg5Ahs0DUJixcXwIoyLpni80iT3ULSlhowY5Ofjnx0NFCLSCBKA3?=
 =?us-ascii?Q?u1pdtO7RqwhpujPdUpU997i054xKT5AqNr8KmgC3JD8gW8PxkufwmgvZ/gQ6?=
 =?us-ascii?Q?7V4Pedjzhy4vs4aY795DCKjW+g70HTR++ARbsGQjSEH6WSmkALMM9smDwZr4?=
 =?us-ascii?Q?D8OOw3i1CQmvw7L+HnFWDEkHA3EhzjVFovyxdSPjKaV23El2GXsW/ZSYK750?=
 =?us-ascii?Q?c1lr+9b7fkhs7iYp/+SkUPWVtCT2H0tLaQLemqU5wD58JZXlj1sK8lwrJo3e?=
 =?us-ascii?Q?OCflMMM46tUuMpS03xf64uYBCrPHeSfWplBLv4UcVn0lwfG5IzsaXSLdGXIg?=
 =?us-ascii?Q?PSa5avjMQqw+J6HMK8kxrovr9zhQRuZTulBLJoMBMR58/Nr/JJQN5kgkEnT4?=
 =?us-ascii?Q?dE1zgmSfEdaRlwDdo1Kthfed4P+tp1HOwVfTkxwwbpwDBClbyiS9N/0PFJp1?=
 =?us-ascii?Q?2DHRlsw+XM8TuLQiWpZ0Ol9MpkkgGvZB1QwpZs2POCnr1lpRzKMT7PAOW3s1?=
 =?us-ascii?Q?OjaB4F0sgtXCMbQYNC7DcuvcENSc9oq4Qn5usVKBcYyJUYtO57FBYsBIq3VU?=
 =?us-ascii?Q?8ol1Lf62NdYMxzI5Isei7LqC0pLVM61wjrNAK8NKkZ1/wdNGwbFjclBmSemg?=
 =?us-ascii?Q?TbdWTMqymNHQ9/wv+e0B16GN9g9gY/cwNixmsF02zF7akWjopqHAuJxz+Op8?=
 =?us-ascii?Q?0XUkF7YUDqenVsk7btSzs80zHOJ34osc0gc/5jvTMzjHIg3M4/yIdxzB68H4?=
 =?us-ascii?Q?laieCeAWqSTI3gbjemBak3IS+icjI9mIR8r7WPUAbIuvAUyKxRV0P3s2Omqa?=
 =?us-ascii?Q?mYSuFm3NzFSLr/6dpyyKXXq4YpPc/SbmvN+LcPBYW3ZZstEDSOJDYLOwRQmV?=
 =?us-ascii?Q?VpP3yW1yZBwVyDaV/PTRxF9c7UkqGET2ZKLWsOJsu3CcfiUzFAQyNbI/E2eA?=
 =?us-ascii?Q?EhSTSyTQ/Sq4oLQCo0eZdif/yXvZmCmjx3sI2luuSKmzSx9+X0DZy0EwtPcQ?=
 =?us-ascii?Q?4B1Xh3okQykerKPm8iwdv3CuKyuMs20kjHyY+GTOHOEyzjlx8Uv3YyI/noKC?=
 =?us-ascii?Q?tiAGAhyN4yUy1AZyHkVIlzDr17qiQtH62MujxphR0EoAHtn2RzY/pytx4Xss?=
 =?us-ascii?Q?BM6Zjf3chLL+jt0CqsqtFcvbHvQZZ6iwW05SK5DR7Gio2a+ODIjrA6arxcCo?=
 =?us-ascii?Q?MRi19nEyVgVdqSTrnVhN59foTpG0Yr/lhmuimURkpfQgb1mqgFfj0pwf8W3r?=
 =?us-ascii?Q?JS6CRUGzffSmZ6jZRX9A3hIayKgHWh6CvvlfVdJBx5tPqkXugi+h?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3a28625-a064-4fa1-d43e-08da2cbf7977
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 04:43:31.6180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k0JvcpxQgm+VPxBktkOrM417eUBL6ueEAvuKTZCphfLBJJbhLtoorPclARjhkZ3MukHcBiO2UQsgnpmQzKqsVQ==
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

When the caller doesn't pass a destination fs_core will create a unused
rule just so a context can be returned. This unused rule
is zeroed out and its type is 0 which can be mixed up with
MLX5_FLOW_DESTINATION_TYPE_VPORT.

Create a dedicated type to differentiate between the two
named MLX5_FLOW_DESTINATION_TYPE_NONE.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c             | 5 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c            | 2 ++
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c    | 5 ++++-
 include/linux/mlx5/fs.h                                      | 1 +
 5 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
index 7841ef6c193c..c5bb79a4fa57 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
@@ -259,6 +259,9 @@ const char *parse_fs_dst(struct trace_seq *p,
 	case MLX5_FLOW_DESTINATION_TYPE_PORT:
 		trace_seq_printf(p, "port\n");
 		break;
+	case MLX5_FLOW_DESTINATION_TYPE_NONE:
+		trace_seq_printf(p, "none\n");
+		break;
 	}
 
 	trace_seq_putc(p, 0);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index a5662cb46660..2ccf7bef9b05 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -455,7 +455,8 @@ static int mlx5_set_extended_dest(struct mlx5_core_dev *dev,
 		return 0;
 
 	list_for_each_entry(dst, &fte->node.children, node.list) {
-		if (dst->dest_attr.type == MLX5_FLOW_DESTINATION_TYPE_COUNTER)
+		if (dst->dest_attr.type == MLX5_FLOW_DESTINATION_TYPE_COUNTER ||
+		    dst->dest_attr.type == MLX5_FLOW_DESTINATION_TYPE_NONE)
 			continue;
 		if ((dst->dest_attr.type == MLX5_FLOW_DESTINATION_TYPE_VPORT ||
 		     dst->dest_attr.type == MLX5_FLOW_DESTINATION_TYPE_UPLINK) &&
@@ -579,6 +580,8 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 				continue;
 
 			switch (type) {
+			case MLX5_FLOW_DESTINATION_TYPE_NONE:
+				continue;
 			case MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE_NUM:
 				id = dst->dest_attr.ft_num;
 				ifc_type = MLX5_IFC_FLOW_DESTINATION_TYPE_FLOW_TABLE;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index e282d80f1fd2..f9d6ddd865e0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1289,6 +1289,8 @@ static struct mlx5_flow_rule *alloc_rule(struct mlx5_flow_destination *dest)
 	rule->node.type = FS_TYPE_FLOW_DEST;
 	if (dest)
 		memcpy(&rule->dest_attr, dest, sizeof(*dest));
+	else
+		rule->dest_attr.type = MLX5_FLOW_DESTINATION_TYPE_NONE;
 
 	return rule;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 728ccb950fec..223c8741b7ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -604,7 +604,8 @@ static int mlx5dr_cmd_set_extended_dest(struct mlx5_core_dev *dev,
 	if (!(fte->action.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST))
 		return 0;
 	for (i = 0; i < fte->dests_size; i++) {
-		if (fte->dest_arr[i].type == MLX5_FLOW_DESTINATION_TYPE_COUNTER)
+		if (fte->dest_arr[i].type == MLX5_FLOW_DESTINATION_TYPE_COUNTER ||
+		    fte->dest_arr[i].type == MLX5_FLOW_DESTINATION_TYPE_NONE)
 			continue;
 		if ((fte->dest_arr[i].type == MLX5_FLOW_DESTINATION_TYPE_VPORT ||
 		     fte->dest_arr[i].type == MLX5_FLOW_DESTINATION_TYPE_UPLINK) &&
@@ -727,6 +728,8 @@ int mlx5dr_cmd_set_fte(struct mlx5_core_dev *dev,
 				continue;
 
 			switch (type) {
+			case MLX5_FLOW_DESTINATION_TYPE_NONE:
+				continue;
 			case MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE_NUM:
 				id = fte->dest_arr[i].ft_num;
 				ifc_type = MLX5_IFC_FLOW_DESTINATION_TYPE_FLOW_TABLE;
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 9da9df9ae751..8135713b0d2d 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -41,6 +41,7 @@
 #define MLX5_SET_CFG(p, f, v) MLX5_SET(create_flow_group_in, p, f, v)
 
 enum mlx5_flow_destination_type {
+	MLX5_FLOW_DESTINATION_TYPE_NONE,
 	MLX5_FLOW_DESTINATION_TYPE_VPORT,
 	MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE,
 	MLX5_FLOW_DESTINATION_TYPE_TIR,
-- 
2.35.1

