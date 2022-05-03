Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4ACE517CB4
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 06:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbiECErS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 00:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbiECErK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 00:47:10 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2084.outbound.protection.outlook.com [40.107.212.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1603E5CB
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 21:43:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IAZI+BW1tl07zCrIcE9fMLcFwbOkxNWf5u8qF0lqxY0GIigTDDoj7Qf4wgKxBCdFvYeWSIogOE1Shp7Gzq58BQEoekXOUG18yhD/zb5jx6P/r8AVxuje3j3LB18jqKfIHBSGTu0CQRaxWjZ5p+nIv0sqGMydjRmfDlgiURaKxID0kYamJXXbhlAP/WjfDn4fFIZVhv1PSaKMvu+IV5XJVYcGKKkWO+cDC4w+h+SaRe4duP5ZQpG0hkchlOeKHkpvPWvOh5FbzY/2uXna+BUhGJH4CamDuLYxEJIT0zPArfrKNHAlOSR4eYWyWFYDJISRcpPh5T8aia6HI6W5LvUfaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zGI/AVnpbUxhCrDbvISnYFbQMBA0NlyBKR4ayNt3iOk=;
 b=JC+k1W44hpPoV4/j0NZ56q6JTPnRa+XcE8aPhtTX6zt4ibhZzmscxmsL3yhTK1m5VVjID8Cjeoh94vLVlbffIeeyNTmlvJwFHcriu30yCRO7P1FgX0dv4xd8KUVJOO/0Lx7VkIWicP+WxMMNWQCU9T8gliWK8TFU+NgoEBWgHLsZULw57wmr6PjX3E+nbvcUP65UwzEywvTc4OJN7l++VLlY5YehERRAZiRWJo9WnQhVRfwZyCdumSrzs2uDrSQTL6G//FT8TqMMhV5iJRSOc8raoiUm7dHBllQohNFWGXwzeugL8xlvXJvJ1Va/uHdVfcTDj5lsHVcOKLMiCX+PMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zGI/AVnpbUxhCrDbvISnYFbQMBA0NlyBKR4ayNt3iOk=;
 b=mcZYpNN3DQ7VnU/I8wu+jfhtZ/xDXQqJJvCUZ3jTd7sQS2gjxNxeC+/Maq+KveGm73LElME5fmHqiT64Bl8R3yn/GF3bCCZM9AlcWl+gZfjeAZLdFcWO9CMnn0tLfm7MKO5E6JvreMxk8OWu/7VOeyixdEVY2Mvp3TnmySAjOJniC/V8TY7LAj/j+GqPe7zepyGWqgjit66Ko+1aJT7gk+sSqa1k3CLvQJU1BVhAFxDoD+ryOyrGE3LZQ0gJA4xxlpeTPKdlG/bsRzcQMXHRD38urq+ThfpWFwiyo/oZTfT839SrBL2jaSN04SeLR8Osxgt8U0EY66AYttonVeEakw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 04:43:32 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 04:43:32 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/15] net/mlx5: fs, do proper bookkeeping for forward destinations
Date:   Mon,  2 May 2022 21:42:06 -0700
Message-Id: <20220503044209.622171-13-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220503044209.622171-1-saeedm@nvidia.com>
References: <20220503044209.622171-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::35) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 634a9b62-8b98-46cf-f4b4-08da2cbf7a31
X-MS-TrafficTypeDiagnostic: BY5PR12MB4322:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB43222DD24AF522E230019E7BB3C09@BY5PR12MB4322.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yumcL3IKixK0+wky1NjjzQ8vXLl8r37lTq/JmS2Imv3jeAF/RRFTfXOzf9IIR316RYnpeOPeSEvf+Lmf7oHxUTSl+TU47bS7ANTAsqHzupZ1gidQCNHhX25JyE8+ssm3ZMV3Eh6mxssgwXnCYuHfANk1ZYFBafe27wvhJ59cdBS5M8mG3pXcawL4/cI7NA6Pil/nZeDRqlhjO2RPPzpIBB5dI1z7gZuTJ+kBS+M6RsnojP3eOjJitu44V+2UJgOyQVAPb4OUQ9w+opfQx1+R1nJFDdcUGsbMEoOtWXo5qhQ9+eXKMg91Xs3DNICvvHVsgAkdcEflt6IG63fTeuft1fGliIt3mHqRbGyNQuEzdqk86FXE9UhS16PJrJ57402u07wIZaPILTXRKHg4uBYvglcFGLJwhS8xpJMbAOW1E4RWeR0SzbzoJeT3vM5Ih1yrsM/ktkt6BvSthCZ3DtfuYdrtl7q3dXJQSFH88qlUQDxjhkd5R2+fE84zNMMOIY7G6FtcHRMAtW5tBdj61ItVHhpFtNWuPrISPeEx5deZ0Nulhk2ntIy8RQu0oyHcxNNaCOHHr9CqeBwrZLOv0faGWMCJMvWijoAdWn/wPoXucsb/Auj8XfuQkfZvvtGQCEkJauDj8amGmCkBVHeGKOJHBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66476007)(66556008)(8936002)(6666004)(8676002)(66946007)(83380400001)(6512007)(6486002)(1076003)(2906002)(508600001)(86362001)(2616005)(186003)(36756003)(107886003)(5660300002)(316002)(6506007)(38100700002)(110136005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t/5Ke6RnBy+crVltaIDCstreEQes10ffi93EZ//rn77uFLh7732C94XHK2Bz?=
 =?us-ascii?Q?jvTL1vo6XLcMRH/9D4rYl3g7/JvMum8X/3+DJq26wShDIw8uk7r49oe6e5+/?=
 =?us-ascii?Q?X5gUrwU39yn5F+hx/FshWl+JlgIynnImc6vpFMFIK8Zn3REEKYRx4icc2u0I?=
 =?us-ascii?Q?+jL19ZhryVSw4CgQUYLq2IiCTwQVPV4Z3nw6mDmV3J+YmjYAyHBox/QMuV/d?=
 =?us-ascii?Q?KBJ83W+AMccd1rDWMldDs/mJL1FNzLqaWf+4G/wW3rNy1gcO1LuQXPoTy6GE?=
 =?us-ascii?Q?tFp5wMiO0cmlDtFh6uD/AOmWtnqTK7Y0iItzLyo5qUH35cNxuuhuNrAGxCK1?=
 =?us-ascii?Q?Laopkvtd8KtqGK5kHS60NuCMOxQrc/XktgIA+PDs7q7/UINY2HSIwNMWxRwM?=
 =?us-ascii?Q?uBdxeuHu6YrL49x1cOjdZKHE2/bL5x0uB2DsSHSMwE5q6eUHo0gUqgcgvk5x?=
 =?us-ascii?Q?RyAJ7nFXZzGuPIWbzWkrcO2xH9audwvQy3Lll1SUXz8wIab/VXt+pLoH32G+?=
 =?us-ascii?Q?bixSsxLii9SnICFJviBcQF3RJ+14O3MCmVaP/3opryEskpxVfoav8hL1fXqz?=
 =?us-ascii?Q?5V5OWmC3lFXlisnylYYgLlAPj8sAHxbF/BTzZiz8u5qUjeWbrGdbswlw86bC?=
 =?us-ascii?Q?1xcdOBEzs0noBssVBXD+WYPXTExFUhDOpd/j7wgIyqRkDP5eLsrSxZ5UN5kh?=
 =?us-ascii?Q?M5vBu/clRG/Wsj0jE4mMELTMm+6ujb9q9rW69qIhiiVW9loWHYpdez6eodKZ?=
 =?us-ascii?Q?RkISQ6zKtex3LOKBbdzW/d/i8rtnr4+KxqreWynllb57dUMKHa0kZ1GV17Dh?=
 =?us-ascii?Q?pbUtnfXqpmMlrtpLCKnFHPFY40UttZ0D9w2GbKA6AHwWEY15grqIEgsOU7Pn?=
 =?us-ascii?Q?fZBkJ0QkceHhYWCSqxu5ajc1vOVyfxaRm2wdN0J9xN7qQ3jtHDh8MCUGRNSC?=
 =?us-ascii?Q?SzNoNTXGhm+YHitw1pWBK1DqyMnisBsvTTBhRZ3tQ7CyCLqXeq9Pgn2CVd2J?=
 =?us-ascii?Q?44/WKmaGh3z+jlX1Gg66srU/Sj4rvk8NC2UQIr5No/Kg6kV43p6W8VeArQEL?=
 =?us-ascii?Q?VzHhevwbu0puprWhFCl0v8uVAjnkjEnXshtSSc9PSU1L9dJ7RiSOlyM8DjtE?=
 =?us-ascii?Q?Bst+pv9N3Xk/qkOBHXQN6iEMJ6X3Ea3lcFXdMgrqLHz3z7jXupBsVqfiYT7B?=
 =?us-ascii?Q?z5CA43yZw7GSaBPNVLgM2SPs4OJOfrx8dOT75I/dQ6tJa1ECkfsbpT9Oioj/?=
 =?us-ascii?Q?cVhaMn7kCfgeArl5mcb/kpsYlg+42/mAID5goniqj/LuVgfs8/nba2SgFoTJ?=
 =?us-ascii?Q?LFIXY61g2tSiIV/u6cfcNGvsVGv02+b7pS0K0X6PduI5GiqnZ29IFXP6CA6n?=
 =?us-ascii?Q?gnGRpZDmnBSeEitA2hBz02ZY6QZW8HrUmExXfSQKZ8HuY9qqUupQ5MMLjznz?=
 =?us-ascii?Q?Ivrlvwt4k0Uj8er6/mdc6Yl9aLEtqIRFIm4ilky6/S2XXJfJ7Tit5iXQvDiM?=
 =?us-ascii?Q?k12VVEXPnPtGyzl0hFpDhwxgugt2yySO4l/B1kjJUcMbYSI/zdYWfsMlEpWU?=
 =?us-ascii?Q?vmf8nnZJo580shi/bclFp3Agx/Bv6BrLA6qRqaOuFbkVCiSPAetpbi59rJ05?=
 =?us-ascii?Q?mw4gaggLWLmHbJ8G5Obdb3lstP33NBoOy7IpN2kxsJ1jWNq/oJzRmlbsPgxH?=
 =?us-ascii?Q?YRRiYDQV8jyWBnCNLlTHGeK1xyqyOC/TvxAVEaS6NUJkwcDU/+4HWjetutN2?=
 =?us-ascii?Q?ccMnITP/dFRQmhBn/k+aN+SrSBH/h9doHqBOx2f6idWSjSCjhvCD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 634a9b62-8b98-46cf-f4b4-08da2cbf7a31
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 04:43:32.8378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QJuHzfpkjaqy2UEFb70DIf/3dE9KvQQCnP1UJuEeD3QKbxtGphHRc/w+GCvSK/KNHeAD5M2w3rDgYh8acR9V/A==
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

Keep track after destinations that are forward destinations.
When a forward destinations is removed from an FTE check if
the actions bits need to be updated.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 20 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/fs_core.h |  1 +
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index f9d6ddd865e0..ec91727eee2a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -424,6 +424,16 @@ static bool is_fwd_next_action(u32 action)
 			 MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_NS);
 }
 
+static bool is_fwd_dest_type(enum mlx5_flow_destination_type type)
+{
+	return type == MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE_NUM ||
+		type == MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE ||
+		type == MLX5_FLOW_DESTINATION_TYPE_UPLINK ||
+		type == MLX5_FLOW_DESTINATION_TYPE_VPORT ||
+		type == MLX5_FLOW_DESTINATION_TYPE_FLOW_SAMPLER ||
+		type == MLX5_FLOW_DESTINATION_TYPE_TIR;
+}
+
 static bool check_valid_spec(const struct mlx5_flow_spec *spec)
 {
 	int i;
@@ -566,8 +576,13 @@ static void del_sw_hw_rule(struct fs_node *node)
 		goto out;
 	}
 
-	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
+	if (is_fwd_dest_type(rule->dest_attr.type)) {
 		--fte->dests_size;
+		--fte->fwd_dests;
+
+		if (!fte->fwd_dests)
+			fte->action.action &=
+				~MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 		fte->modify_mask |=
 			BIT(MLX5_SET_FTE_MODIFY_ENABLE_MASK_DESTINATION_LIST);
 		goto out;
@@ -1367,6 +1382,9 @@ create_flow_handle(struct fs_fte *fte,
 		if (dest) {
 			fte->dests_size++;
 
+			if (is_fwd_dest_type(dest[i].type))
+				fte->fwd_dests++;
+
 			type = dest[i].type ==
 				MLX5_FLOW_DESTINATION_TYPE_COUNTER;
 			*modify_mask |= type ? count : dst;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index c488a7c5b07e..67cad7a6d836 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -226,6 +226,7 @@ struct fs_fte {
 	struct mlx5_fs_dr_rule		fs_dr_rule;
 	u32				val[MLX5_ST_SZ_DW_MATCH_PARAM];
 	u32				dests_size;
+	u32				fwd_dests;
 	u32				index;
 	struct mlx5_flow_context	flow_context;
 	struct mlx5_flow_act		action;
-- 
2.35.1

