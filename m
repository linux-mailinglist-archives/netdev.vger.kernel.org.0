Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10FE1517CAD
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 06:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbiECErL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 00:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiECErC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 00:47:02 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2084.outbound.protection.outlook.com [40.107.212.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0BF3E0FF
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 21:43:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QKmgaXZGR1F7oFLLHb7njlaB+pRKn+MGrEvkKTuDLwYu+7Hz1Lb7Okdji6D9U/kyuLeDwP2yUU0y9t+BagXRmSuZOshtxwvZqAh33cQcAFTdUSmn/DcGROvCYha07ERsNa3oIyWYOqjnhfM1EajrK2sNZjzT3tOxfybv9fIaOsvWFLeTRTgOT6DD2sxRMte70PfY+rO0aJA1fecdCBF6dEfm2Avbkcfuk105MAV6/Ufdb9UgfPcn5xPNShx+R8ZbTepzVO3lhtQvUf7ep4qPCtX5uPkggdsjP4BK1NDedJhw0QKZaNf5VunrkX+R4zcZT+P46vC6mpsdkyrb0Q+olQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p78V0IcDYOgMDQbO2s58ftZDv/rteR9lZTw6869JeIw=;
 b=YcNGUtvzhX1pENpPxip9tXkDAwTGm8SvwHhL3Morl60zOHlF44BYhMuMqk/24ERMe38lJh9onXmGSzaTa4kXSYm4j21eZGe+18ajrxs9tVv9z5/nofUINoN8ibvfl+41ZPESuED6eS9LZJO3WyXmEXELcndP9sdYX+z9M+JiUqmaKpXzkwJhPcr5bS95YV9QHnpZsHRbP1k0CLjal+d8+veqcSYCjTACEXFb9Du+RcZpc3rEgFmbv8R8y8v4qT+DHkjqjRFUtbEsAC08fXPdQKxCPiSkZBe5Yo8ezoUX2labKHiA5KBJN4RNV63Dfe8n3GTigPFRBGiMGepFiJbSPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p78V0IcDYOgMDQbO2s58ftZDv/rteR9lZTw6869JeIw=;
 b=iDiStlI+rr0pKQ9qfqRuF8R54djrSyyXP9eRR92tOQpM1x1B+2JKZSkrpQcqhjZ1vSLs1uXcxa0dCtgH9zy0WNFQGjImdsH3Yhwinrv12hLkaqZNPsrxebJIoAIucoCqGLFRMYvtQHVLgYxFfDTATUWU8+pILyCRcxUOy1Yv+FxQ2hiFvCyMzr+Vxu+mvYDmlRdjXNA5XwJn7GkxomepZVl+C3qcGJnKFclkR5plwlrMdvaBmjx2DXW0Q5oUu6Q2ZF/zMk1eHjfh5WtzR1EhGZAUO5qDksi4WnuqZSFLSzh8B8CeW2Kv4Kj0RXIz7pb+/fvMFj5OahpP9aGW4sQC6A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 04:43:29 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 04:43:29 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/15] net/mlx5: fs, refactor software deletion rule
Date:   Mon,  2 May 2022 21:42:03 -0700
Message-Id: <20220503044209.622171-10-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220503044209.622171-1-saeedm@nvidia.com>
References: <20220503044209.622171-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0008.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::21) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b8fc285-8a50-46ba-f022-08da2cbf785b
X-MS-TrafficTypeDiagnostic: BY5PR12MB4322:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4322315B33EF86327C05B68CB3C09@BY5PR12MB4322.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BpxFDBX0Cx+5C41DoNLD7YWzjY5lBnjo7XNLo90iwO1bv1d4weYV4YtjAyd3oJpnZKmDQDk18+IElTVUE2+sEoqTwDgyNSflFT1iwruqlQgbyB7hazoHQ1MwTiiLIoBBU0s1tebcNx3MzZt+JgQKGX7j6wAQw50B5zQ0YzECSiFMU8BSoKIi6nRkwUSzgpX+b/7rIuumPj4d+E1yijYVeqgGKOTgqZSh1PbhyxxtGWt4l7lqEdK6bfp2yy02RsSqtbL2NGljJ27JILw043TlHTM+sK1utMchIr3zDeo7+I1K9d/wH7bE6g0g7BOaXFFDdVcN08ZUy7Lw6ZUdymiW2etf5Sf0rYMP9WxaKeVWBZE76qD5GANg8EaCfw+dqZ5lnROazVdfZqKy07QjoW3K5yPTVPjrFjVUj4BusNXxzZJouHbihjImLnGh+uXBgoE+XlMST33yS1DO1ETymZOnlgKri02EnQK5i12W5JFG6gNPxD/jfGjPwDzFT+DPoSTXyNCUIzTIG/arEeDzhfUIdnVVHnpmcvx86NItWdCCm7EJCys5f9aKk60rg2Xp6nDoIWmZ8TCxSlqvOHAoYldu+ravT7lQ1NhiUWJThjWJWL3qDvF27hzdeKZKcFGKrLJucydwFD4oOKdnZvcBmizxWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66476007)(66556008)(8936002)(6666004)(8676002)(66946007)(83380400001)(6512007)(6486002)(1076003)(2906002)(508600001)(86362001)(2616005)(186003)(36756003)(107886003)(5660300002)(316002)(6506007)(38100700002)(110136005)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9vFNkG2qOw8CT71zxxqc0rIoqaD+RlV8AoIic7nx8SBfBaRYSrQ68SfsVxoi?=
 =?us-ascii?Q?Lqqtpj41jUZx/zo7EZRwtrVYAXSSJZe9hQppC5im78WOxFlfQyYRRZu7+Nmu?=
 =?us-ascii?Q?fugE63h92k8+cNSvVT4TZfJ8lTKRgX/ztWUYwSSXKyk7LufoD7XH2LIFjwTF?=
 =?us-ascii?Q?K4hWfuwKRb0fy7vfKKifZRmh8S5D+TqK+//dOtyY10RoLVWq5IijlHXDdanV?=
 =?us-ascii?Q?vDrq/KWFKmW3ObSRVySA41rDlQ9ptRz8u8Lu2mhO/JyZdb18nfbAB3ehcsKj?=
 =?us-ascii?Q?YVTz7udovlGcsk+pe7btWWYI+vBF/PWYVyati7fLCT2633rghIMG+Rfi+fB9?=
 =?us-ascii?Q?bJnhP59EWpmv4TrBCcSVnqabYVfaw7hVUxQuuWcpRw867g8SlFhVQvZjdP17?=
 =?us-ascii?Q?0lHUOUPPC8AWGHZ4apgCXDYetcumN94AmuCecMWXhxJNWr0Q0FbZFNV//6v/?=
 =?us-ascii?Q?M5Hwm0Y2b7Or/BRajXumkIoc5R4fxTG6AtJ7uUwCgj2Bz6FlxJdXLsBMnLgH?=
 =?us-ascii?Q?jCU1xaIwT7Gh0f4StAlI2f9E+YZtZWEyg8f9Ve2WdQlhwGolrlT3ePlmX8fG?=
 =?us-ascii?Q?7+ocesv27DMpjn1UdQmrHL+98UfXFJzWH6LjQF3P/kgc+rMJCPfJDxNyfaV+?=
 =?us-ascii?Q?t+ike882SlRLOU0PntjUqF5IsaR1sEY0Z/WwnjGRWw3/EgD9S9oJxRZ4dx4G?=
 =?us-ascii?Q?1caklwov2TzWV318bFiMZg/dTpaA/rVg11v5d4sdxN9syZxfZGGnh5+2WdTA?=
 =?us-ascii?Q?RDYgVuV08SC/V5OO2JgB5bd5mBRx+gEv5b+hB2dJTV8Yms3DjOM8HUutoF5C?=
 =?us-ascii?Q?53f/qV66HobVXK35q5ysdSM6kGyWg6IH8gVEaHHB3W4UPtC/plqRzxNQpRP6?=
 =?us-ascii?Q?mN86aqfdnHGtjeQGTBuNPiXL9BigRQINJddjWUoKhR/N2G5UtoUaEiE+h+bh?=
 =?us-ascii?Q?mFU29+i0xEdMymHNLlqvuFUS/04adZGBTT/Dz8WRX/UUq5ymT/IMJt0wUdVQ?=
 =?us-ascii?Q?tARVzN8b8/t0JHztW11PtoyfsUCa40mDWTBkRcp8dIS+bxTo021RhTF2hkHN?=
 =?us-ascii?Q?6JKDZUqitw47M43T0EJkYoJirAgsgDnND1zuhtvaTzUGAD9SeGYgTtxpAsX7?=
 =?us-ascii?Q?Sbbiu779wk75rvCWvrwn0PunggT5DHe87a+yspxB3BnBTQydG/MW8PBWWfv/?=
 =?us-ascii?Q?HkQr4YKeaDdvf3GFvbfi2xgRZhZNCEDdDfKvWdIXXUhXmMt3KyG75EO1bxe0?=
 =?us-ascii?Q?YYVVD0bo0VcpQv1bhvpIJJuxc7XKxHkryvblPSnMQzjQxtUAs1uTGm984iqx?=
 =?us-ascii?Q?tpxYdh46yZzArqCdaDEMPVHJtPYkfszwPcGkF7LbYZNJhtEjwWa17EssH4+1?=
 =?us-ascii?Q?YsrJpH2sHcBKdza5ZSbzbbM/jfDUvGqE3eRsT2TnSyeXnfBCtQHL6Dkh6ZsV?=
 =?us-ascii?Q?z8zcTbx1RlB1DRQEwKuqqcL/IIqh8X9CPGERPG97eBITB4ymoAvykA0EOsqD?=
 =?us-ascii?Q?OXnDP6q+V+i+nH5+fdcjXkskix2ML1eK4TZLUOU3zoawror7MQFU+3cC2h9V?=
 =?us-ascii?Q?ABWfd9Cn6hcKk0zzy8SHEBo1osv1feqdNKd+lNWvmq+rrPJuVSNmg1XShriV?=
 =?us-ascii?Q?GUKXu7+IXHiPN17uLAJzb12aXCD8ExU3b/fwRFB9afbGiyFp3jyp9fF/0J/Z?=
 =?us-ascii?Q?mZnDumJPBJwRirh6WyZVfUuZwiytVRmdjyi0Wb0i/jH3SmSzrs+emSWsitRg?=
 =?us-ascii?Q?tbfxqRnBkgB8QE9Rcobw/B6CevJzi+cLWQicYzTfBK5aCP4ql/DW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b8fc285-8a50-46ba-f022-08da2cbf785b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 04:43:29.7575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YboBUs762RpbgqcwCu2+Lw1SkJ5g18PF1+6FkvV3oDNc4TXMdf8v3XOeIE5MidiZWRsImftZqWFOKUTIJq0HYQ==
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

When deleting a rule make sure that for every type dests_size is
decreased only once and no other logic is executed.

Without this dests_size might be decreased twice when dests_size == 1
so the if for that type won't be entered and if action has
MLX5_FLOW_CONTEXT_ACTION_FWD_DEST set dests_size will be decreased again.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 297e6a468a3e..ae83962fc5fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -550,8 +550,8 @@ static void del_sw_hw_rule(struct fs_node *node)
 		mutex_unlock(&rule->dest_attr.ft->lock);
 	}
 
-	if (rule->dest_attr.type == MLX5_FLOW_DESTINATION_TYPE_COUNTER  &&
-	    --fte->dests_size) {
+	if (rule->dest_attr.type == MLX5_FLOW_DESTINATION_TYPE_COUNTER) {
+		--fte->dests_size;
 		fte->modify_mask |=
 			BIT(MLX5_SET_FTE_MODIFY_ENABLE_MASK_ACTION) |
 			BIT(MLX5_SET_FTE_MODIFY_ENABLE_MASK_FLOW_COUNTERS);
@@ -559,15 +559,15 @@ static void del_sw_hw_rule(struct fs_node *node)
 		goto out;
 	}
 
-	if (rule->dest_attr.type == MLX5_FLOW_DESTINATION_TYPE_PORT &&
-	    --fte->dests_size) {
+	if (rule->dest_attr.type == MLX5_FLOW_DESTINATION_TYPE_PORT) {
+		--fte->dests_size;
 		fte->modify_mask |= BIT(MLX5_SET_FTE_MODIFY_ENABLE_MASK_ACTION);
 		fte->action.action &= ~MLX5_FLOW_CONTEXT_ACTION_ALLOW;
 		goto out;
 	}
 
-	if ((fte->action.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) &&
-	    --fte->dests_size) {
+	if (fte->action.action & MLX5_FLOW_CONTEXT_ACTION_FWD_DEST) {
+		--fte->dests_size;
 		fte->modify_mask |=
 			BIT(MLX5_SET_FTE_MODIFY_ENABLE_MASK_DESTINATION_LIST);
 	}
-- 
2.35.1

