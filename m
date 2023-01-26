Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 311B267D186
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbjAZQ0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:26:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbjAZQ0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:26:09 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55566FD3B
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 08:25:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MhmD9RiH7g+iDURIb79AXnTixH+50qq02SM6ty8/Tm8ute8tU7RBsRo1tvh+lMy0kVV3/4Y63z7SUJuBKbvawp+1tzr2sq9sqadN7U19T2JfJp4Kez8Qyy5eG70daiII6Ry9iG7TH3owpyAx8b8z3U4sBFlLv6s7bN5JOfdtHdBiiqb1GStZhYsWt5kWWiS+5GlcJINNzUKJE/i2ndV4uu66IytmYxmvHQ25Bss4zG6ukv/EzBMgkXaR1dRQU6HPFvYKU7ZpRJPypdAFFY3xrKo32JQcJFewCWOJf70wxhki7awWHfp6aygmp1ipdX3RVGJrjcgrlACvV/vPUkXxLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lrc12jOdCtcWAZpDl6exyKOUTQAWtd7ghIfy+oHMu8s=;
 b=BF0uakExvdAoOJVh5QLj+5r/yht32f93rAuBKrZEW5ELOPjjOYJB2bKOFyaHjHLBxnih4GpB2t1aYWufPJfAJr2PK1gD22ZjBSUkd7iut4F+Vty61vaOHDFxGsfihJRWstma3IFYEl365HTusO/AQz/E5hnfLKpEV4CJKi33K6OKj/DasoSKBJLJYenbuJFpJPnyAivJ8BWNcAjcpwHL6cfBzLJ+i7YeIm2Mjhz64YtCUDftj1B+1BZM+k2LX7k8tAg0se8ATSzy084Ducw8Vc1EHIJ17BAYdbWkJ07bt201R6vsrY1qlLhF2UvyfMlkO3fJcWXssdSJBXEDE0yEtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lrc12jOdCtcWAZpDl6exyKOUTQAWtd7ghIfy+oHMu8s=;
 b=p9OazqUfWiM8OTLRmobXkjTMhs+6JqUqydjJeXYb/6cVGitK/LwD6cLbmYv8XQLUs68/G3hs3nJdrceBnQ9U6bc+Qxz8+kI+Tfa80+IZinKxs6R2a9MnH3+wI77RpcwjTworLjqQuI/BDmxcRg0oZtd0sLljOanzhyAdITLJ8pSTnOao4Sem1kHKv91valzBDqnvn5Tf2mKXipnWB6nE6JjvsIDQVK1qK9qCU4e7VR+VmyQUjwrEGbAPG+wLtlreUImBHllosLPaWYmasVSZj50gxXgsFhXv1X/Gv4LO4X9IaLUMxDIulEf3K6/6rFX6XOkHJ0Pt4T0Z6qIUEwACtg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by PH0PR12MB7792.namprd12.prod.outlook.com (2603:10b6:510:281::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Thu, 26 Jan
 2023 16:24:15 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%6]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 16:24:15 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     Aurelien Aptel <aaptel@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, borisp@nvidia.com
Subject: [PATCH v10 24/25] net/mlx5e: NVMEoTCP, data-path for DDP+DDGST offload
Date:   Thu, 26 Jan 2023 18:21:35 +0200
Message-Id: <20230126162136.13003-25-aaptel@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230126162136.13003-1-aaptel@nvidia.com>
References: <20230126162136.13003-1-aaptel@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::16) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|PH0PR12MB7792:EE_
X-MS-Office365-Filtering-Correlation-Id: a8b938db-bc37-4c82-baeb-08daffb9c408
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xENEeHEtD+d2JttvO8iAEJYkhb45eRpwogfyoIqh0F/CLWeVRslJOuUJM1199uZrGCAdzEHliMldITefZzxMn8WuixL4hUKI566mHjRnwHMRJJGg76EFuYGpBIC92S3BrTTemMcBiPslEcF0njZy+oY0oK0wSN7FKOZHo6qBOI4uK9QFWF9YcWPe3Sa6/51l6PvU5GZWTmCEVDmoj9dlMwE5jmsRd7GwUTEjtbFHNmZFgvjeuxwhML7aVv+AWA61qtBZ+X/bxVA8TBf/gZoBwqO6t9Q8Hhv97Fcgr6+/Km1LSj0TsYBj07kF5vqnvV05DYjMdNnCkkzLZKqTQ7KtasrT19W/I03WQ+42MP69JY7vt0aBg+rBj2wKnJLuR/ArB1cQcgpjcQEIHkL0mwNW0mJ/r7bIL3GFGyXtE6x07mGje53lb4RmwbR7ihyaQDUa7wddpZu+LhzQwQ00LamYRNy8MECYs6RlfWUDENXwk+r1NS5keIB7tunsj3zyuV8hDGRqFN0kO0niNdOE+KD+zByQwOeeWv6LdIGgpzISz0UldS/uLV620v3wD1tRRM/M3Q3+fjfU1yWhksHxwkPDNHNkIpi/8gjcuWUeaMEmvm9hAfrmFiYnaUcf+L4P+wRFmdP8SigXcaJCBbEyjBA78A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(451199018)(4326008)(66476007)(316002)(36756003)(66556008)(86362001)(66946007)(8676002)(6512007)(107886003)(478600001)(2616005)(26005)(83380400001)(8936002)(186003)(6666004)(5660300002)(1076003)(6486002)(2906002)(7416002)(38100700002)(6506007)(41300700001)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BloAwApKpH8bvrAuzmKrY4ok6ZtUqSKVhPoslnTSXiJseBl+Z8m2y3ItdD/P?=
 =?us-ascii?Q?+ZNSHjLgBKZxKrtVZc+U+0VMQLVcSl5gzyLh+MkKQRRBfBLbUsMpQFSPOWpn?=
 =?us-ascii?Q?pdCFvRUJBp9a4Bhl4UrQmo01D6sihWF3K8+3T1hFV1yYJXmq9rhuZ66TSHDY?=
 =?us-ascii?Q?ladmhJEpHcLH8VIRW5nPCiqiEkeB0xyM6REsoeZV9xRWY+NuKiFTaMMaBXVi?=
 =?us-ascii?Q?j4xnpni7ZzypJQORegG0Z5urH9izcQC/0v1/JVY/2lCs4J4/qkRtdwZ2yOYv?=
 =?us-ascii?Q?Fn04sWgmCkQ5u1fkU8iTtD6E99FEWF3AupOWeN41UKWmjBBqSh+QGO4cYZMg?=
 =?us-ascii?Q?KiHbHCRUNjbMiTYR5NIkpyP8Ek2gQhcQickNS36XqVGyyjqWH2xtQJ7nNGGQ?=
 =?us-ascii?Q?OlMduJ0qPO8RN2YlrqETJenywohxe25DDj0xjm5Pdxd1lio0ICaGnwBNsm2M?=
 =?us-ascii?Q?EzLtuEHftnXQS/NY3jhZiaHY4W8wifOJEjkpWX+hc8336CDEeFv+TvQCRwmz?=
 =?us-ascii?Q?NZBbLMCXcx+k52YQLlCGlrMNo1NKD891tFXchuQNVoCJSSFw5vAfRWHSCtdY?=
 =?us-ascii?Q?LoIwg1v7OSACenukCY1/dWSlCbai3WrwSC+qvn/l2Kp5qjyOvi3g2bpDJpuB?=
 =?us-ascii?Q?PurDryf2ATDR/O2W+PgxavdJe4jRqGlppdJYO/k1fHmI9Q7Rk5366T9dGDvp?=
 =?us-ascii?Q?pwCew9HrXXPw7FymjyDHL14TFmVk6zU8HE2RhxWlxPEDioBmeKdT03DmTdYr?=
 =?us-ascii?Q?7F/B6IziE6Fw5HC39GAnv7ERwIdU6ICAFfHKegeH/zjgTG8qW7YrhSihUWUY?=
 =?us-ascii?Q?wpbALxwINRMmN/z0+2bCCzoJb+xIRI2UQYADs9mmu/GA9MBBUvxGyWrRUX/D?=
 =?us-ascii?Q?05on7nJronnvVsomhWzBqP1xGDIe6Lx0x75ljZXp8gNMIf3oRoQedL+ZzAIA?=
 =?us-ascii?Q?o9BsD6R3LyOsg6bY30mDAsIC8dV3FboEk4yqhfsYpY0a9h/JD2y9dR6ua83K?=
 =?us-ascii?Q?mzYCbZe7wFw1mSZr4RN5YuWweaBv/qXPD0mr/5Pxo4Glbmj9afapLTyxQK6M?=
 =?us-ascii?Q?Zs0TcgbFVUtiuQP4RJLPL2qapsA3WNpbcGDwNKYWCnKkxls1si43xaOQV+WX?=
 =?us-ascii?Q?qXfIouKzpV+NikJw3zcqZls3gAC0MtEbCk4euj57+uL73ia3r9c5D/5S773y?=
 =?us-ascii?Q?8uxOpeCqXibAhnAs+uEAYaR4uMxYgDTVFRIl8keXYMhkXc/2v5Yt40GwRqbJ?=
 =?us-ascii?Q?cDZyxYay5jI7FaPPcM1SOGcIDq/6mHyiBSepy4vnwkQljBiKMXfxblL9/UeU?=
 =?us-ascii?Q?iZ5/XVrmef1/clNhqHuskB/5FaF8hRpBtNB8n7gxB2DAnp+tVUAe8HVhrgDM?=
 =?us-ascii?Q?rjWJLLsP5wAd4Qd3wukQhApx1EnxI4Xb0EpjB5QsPzTkdrnjbNA5mpFnJG3p?=
 =?us-ascii?Q?KbieCk7XJKy/BxWCxUnfOfDviF220bqcZojEIAwMfHV0sluCwPkGk1EnZYaY?=
 =?us-ascii?Q?11z9kEmiOBYti7h4iYwydL8OENaCR6tXx/lj7QlLsCYz7uPL8OwVOnPo/rhs?=
 =?us-ascii?Q?jxb49m1pnKA4tIZ9UprtsUB5u37TtJXiIvJ8ws2W?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8b938db-bc37-4c82-baeb-08daffb9c408
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 16:24:15.2410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RwDtNs94pac1NE+pvG1k71Hn4BefruBKcBcTYQ3f40u+JKvt5P/T0lR8DrTh+Y1NR+s1ZN431xLkrobeuCFcyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7792
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

This patch implements the data-path for direct data placement (DDP)
and DDGST offloads. NVMEoTCP DDP constructs an SKB from each CQE, while
pointing at NVME destination buffers. In turn, this enables the offload,
as the NVMe-TCP layer will skip the copy when src == dst.

Additionally, this patch adds support for DDGST (CRC32) offload.
HW will report DDGST offload only if it has not encountered an error
in the received packet. We pass this indication in skb->ulp_crc
up the stack to NVMe-TCP to skip computing the DDGST if all
corresponding SKBs were verified by HW.

This patch also handles context resynchronization requests made by
NIC HW. The resync request is passed to the NVMe-TCP layer
to be handled at a later point in time.

Finally, we also use the skb->ulp_ddp bit to avoid skb_condense.
This is critical as every SKB that uses DDP has a hole that fits
perfectly with skb_condense's policy, but filling this hole is
counter-productive as the data there already resides in its
destination buffer.

This work has been done on pre-silicon functional simulator, and hence
data-path performance numbers are not provided.

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@nvidia.com>
Signed-off-by: Yoray Zack <yorayz@nvidia.com>
Signed-off-by: Aurelien Aptel <aaptel@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   1 +
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |   1 +
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |   1 +
 .../mlx5/core/en_accel/nvmeotcp_rxtx.c        | 316 ++++++++++++++++++
 .../mlx5/core/en_accel/nvmeotcp_rxtx.h        |  37 ++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  51 ++-
 7 files changed, 395 insertions(+), 14 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 9df9999047d1..9804bd086bf4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -103,7 +103,7 @@ mlx5_core-$(CONFIG_MLX5_EN_TLS) += en_accel/ktls_stats.o \
 				   en_accel/fs_tcp.o en_accel/ktls.o en_accel/ktls_txrx.o \
 				   en_accel/ktls_tx.o en_accel/ktls_rx.o
 
-mlx5_core-$(CONFIG_MLX5_EN_NVMEOTCP) += en_accel/fs_tcp.o en_accel/nvmeotcp.o
+mlx5_core-$(CONFIG_MLX5_EN_NVMEOTCP) += en_accel/fs_tcp.o en_accel/nvmeotcp.o en_accel/nvmeotcp_rxtx.o
 
 mlx5_core-$(CONFIG_MLX5_SW_STEERING) += steering/dr_domain.o steering/dr_table.o \
 					steering/dr_matcher.o steering/dr_rule.o \
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 242927cf414e..8b516e389b66 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -628,6 +628,7 @@ struct mlx5e_rq;
 typedef void (*mlx5e_fp_handle_rx_cqe)(struct mlx5e_rq*, struct mlx5_cqe64*);
 typedef struct sk_buff *
 (*mlx5e_fp_skb_from_cqe_mpwrq)(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
+			       struct mlx5_cqe64 *cqe,
 			       u16 cqe_bcnt, u32 head_offset, u32 page_idx);
 typedef struct sk_buff *
 (*mlx5e_fp_skb_from_cqe)(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index c91b54d9ff27..03b416989bba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -229,6 +229,7 @@ static struct sk_buff *mlx5e_xsk_construct_skb(struct mlx5e_rq *rq, struct xdp_b
 
 struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 						    struct mlx5e_mpw_info *wi,
+						    struct mlx5_cqe64 *cqe,
 						    u16 cqe_bcnt,
 						    u32 head_offset,
 						    u32 page_idx)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
index 087c943bd8e9..22e972398d92 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
@@ -13,6 +13,7 @@ int mlx5e_xsk_alloc_rx_wqes_batched(struct mlx5e_rq *rq, u16 ix, int wqe_bulk);
 int mlx5e_xsk_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, int wqe_bulk);
 struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 						    struct mlx5e_mpw_info *wi,
+						    struct mlx5_cqe64 *cqe,
 						    u16 cqe_bcnt,
 						    u32 head_offset,
 						    u32 page_idx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
new file mode 100644
index 000000000000..4c7dab28ef56
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
@@ -0,0 +1,316 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+// Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES.
+
+#include "en_accel/nvmeotcp_rxtx.h"
+#include <linux/mlx5/mlx5_ifc.h>
+
+#define MLX5E_TC_FLOW_ID_MASK  0x00ffffff
+static void nvmeotcp_update_resync(struct mlx5e_nvmeotcp_queue *queue,
+				   struct mlx5e_cqe128 *cqe128)
+{
+	const struct ulp_ddp_ulp_ops *ulp_ops;
+	u32 seq;
+
+	seq = be32_to_cpu(cqe128->resync_tcp_sn);
+	ulp_ops = inet_csk(queue->sk)->icsk_ulp_ddp_ops;
+	if (ulp_ops && ulp_ops->resync_request)
+		ulp_ops->resync_request(queue->sk, seq, ULP_DDP_RESYNC_PENDING);
+}
+
+static void mlx5e_nvmeotcp_advance_sgl_iter(struct mlx5e_nvmeotcp_queue *queue)
+{
+	struct mlx5e_nvmeotcp_queue_entry *nqe = &queue->ccid_table[queue->ccid];
+
+	queue->ccoff += nqe->sgl[queue->ccsglidx].length;
+	queue->ccoff_inner = 0;
+	queue->ccsglidx++;
+}
+
+static inline void
+mlx5e_nvmeotcp_add_skb_frag(struct net_device *netdev, struct sk_buff *skb,
+			    struct mlx5e_nvmeotcp_queue *queue,
+			    struct mlx5e_nvmeotcp_queue_entry *nqe, u32 fragsz)
+{
+	dma_sync_single_for_cpu(&netdev->dev,
+				nqe->sgl[queue->ccsglidx].offset + queue->ccoff_inner,
+				fragsz, DMA_FROM_DEVICE);
+	page_ref_inc(compound_head(sg_page(&nqe->sgl[queue->ccsglidx])));
+	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+			sg_page(&nqe->sgl[queue->ccsglidx]),
+			nqe->sgl[queue->ccsglidx].offset + queue->ccoff_inner,
+			fragsz,
+			fragsz);
+}
+
+static inline void
+mlx5_nvmeotcp_add_tail_nonlinear(struct mlx5e_nvmeotcp_queue *queue,
+				 struct sk_buff *skb, skb_frag_t *org_frags,
+				 int org_nr_frags, int frag_index)
+{
+	while (org_nr_frags != frag_index) {
+		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+				skb_frag_page(&org_frags[frag_index]),
+				skb_frag_off(&org_frags[frag_index]),
+				skb_frag_size(&org_frags[frag_index]),
+				skb_frag_size(&org_frags[frag_index]));
+		page_ref_inc(skb_frag_page(&org_frags[frag_index]));
+		frag_index++;
+	}
+}
+
+static void
+mlx5_nvmeotcp_add_tail(struct mlx5e_nvmeotcp_queue *queue, struct sk_buff *skb,
+		       int offset, int len)
+{
+	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, virt_to_page(skb->data), offset, len,
+			len);
+	page_ref_inc(virt_to_page(skb->data));
+}
+
+static void mlx5_nvmeotcp_trim_nonlinear(struct sk_buff *skb, skb_frag_t *org_frags,
+					 int *frag_index, int remaining)
+{
+	unsigned int frag_size;
+	int nr_frags;
+
+	/* skip @remaining bytes in frags */
+	*frag_index = 0;
+	while (remaining) {
+		frag_size = skb_frag_size(&skb_shinfo(skb)->frags[*frag_index]);
+		if (frag_size > remaining) {
+			skb_frag_off_add(&skb_shinfo(skb)->frags[*frag_index],
+					 remaining);
+			skb_frag_size_sub(&skb_shinfo(skb)->frags[*frag_index],
+					  remaining);
+			remaining = 0;
+		} else {
+			remaining -= frag_size;
+			skb_frag_unref(skb, *frag_index);
+			*frag_index += 1;
+		}
+	}
+
+	/* save original frags for the tail and unref */
+	nr_frags = skb_shinfo(skb)->nr_frags;
+	memcpy(&org_frags[*frag_index], &skb_shinfo(skb)->frags[*frag_index],
+	       (nr_frags - *frag_index) * sizeof(skb_frag_t));
+	while (--nr_frags >= *frag_index)
+		skb_frag_unref(skb, nr_frags);
+
+	/* remove frags from skb */
+	skb_shinfo(skb)->nr_frags = 0;
+	skb->len -= skb->data_len;
+	skb->truesize -= skb->data_len;
+	skb->data_len = 0;
+}
+
+static bool
+mlx5e_nvmeotcp_rebuild_rx_skb_nonlinear(struct mlx5e_rq *rq, struct sk_buff *skb,
+					struct mlx5_cqe64 *cqe, u32 cqe_bcnt)
+{
+	int ccoff, cclen, hlen, ccid, remaining, fragsz, to_copy = 0;
+	struct net_device *netdev = rq->netdev;
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_nvmeotcp_queue_entry *nqe;
+	skb_frag_t org_frags[MAX_SKB_FRAGS];
+	struct mlx5e_nvmeotcp_queue *queue;
+	int org_nr_frags, frag_index;
+	struct mlx5e_cqe128 *cqe128;
+	u32 queue_id;
+
+	queue_id = (be32_to_cpu(cqe->sop_drop_qpn) & MLX5E_TC_FLOW_ID_MASK);
+	queue = mlx5e_nvmeotcp_get_queue(priv->nvmeotcp, queue_id);
+	if (unlikely(!queue)) {
+		dev_kfree_skb_any(skb);
+		return false;
+	}
+
+	cqe128 = container_of(cqe, struct mlx5e_cqe128, cqe64);
+	if (cqe_is_nvmeotcp_resync(cqe)) {
+		nvmeotcp_update_resync(queue, cqe128);
+		mlx5e_nvmeotcp_put_queue(queue);
+		return true;
+	}
+
+	/* If a resync occurred in the previous cqe,
+	 * the current cqe.crcvalid bit may not be valid,
+	 * so we will treat it as 0
+	 */
+	if (unlikely(queue->after_resync_cqe) && cqe_is_nvmeotcp_crcvalid(cqe)) {
+		skb->ulp_crc = 0;
+		queue->after_resync_cqe = 0;
+	} else {
+		if (queue->crc_rx)
+			skb->ulp_crc = cqe_is_nvmeotcp_crcvalid(cqe);
+	}
+
+	skb->ulp_ddp = cqe_is_nvmeotcp_zc(cqe);
+	if (!cqe_is_nvmeotcp_zc(cqe)) {
+		mlx5e_nvmeotcp_put_queue(queue);
+		return true;
+	}
+
+	/* cc ddp from cqe */
+	ccid	= be16_to_cpu(cqe128->ccid);
+	ccoff	= be32_to_cpu(cqe128->ccoff);
+	cclen	= be16_to_cpu(cqe128->cclen);
+	hlen	= be16_to_cpu(cqe128->hlen);
+
+	/* carve a hole in the skb for DDP data */
+	org_nr_frags = skb_shinfo(skb)->nr_frags;
+	mlx5_nvmeotcp_trim_nonlinear(skb, org_frags, &frag_index, cclen);
+	nqe = &queue->ccid_table[ccid];
+
+	/* packet starts new ccid? */
+	if (queue->ccid != ccid || queue->ccid_gen != nqe->ccid_gen) {
+		queue->ccid = ccid;
+		queue->ccoff = 0;
+		queue->ccoff_inner = 0;
+		queue->ccsglidx = 0;
+		queue->ccid_gen = nqe->ccid_gen;
+	}
+
+	/* skip inside cc until the ccoff in the cqe */
+	while (queue->ccoff + queue->ccoff_inner < ccoff) {
+		remaining = nqe->sgl[queue->ccsglidx].length - queue->ccoff_inner;
+		fragsz = min_t(off_t, remaining,
+			       ccoff - (queue->ccoff + queue->ccoff_inner));
+
+		if (fragsz == remaining)
+			mlx5e_nvmeotcp_advance_sgl_iter(queue);
+		else
+			queue->ccoff_inner += fragsz;
+	}
+
+	/* adjust the skb according to the cqe cc */
+	while (to_copy < cclen) {
+		remaining = nqe->sgl[queue->ccsglidx].length - queue->ccoff_inner;
+		fragsz = min_t(int, remaining, cclen - to_copy);
+
+		mlx5e_nvmeotcp_add_skb_frag(netdev, skb, queue, nqe, fragsz);
+		to_copy += fragsz;
+		if (fragsz == remaining)
+			mlx5e_nvmeotcp_advance_sgl_iter(queue);
+		else
+			queue->ccoff_inner += fragsz;
+	}
+
+	if (cqe_bcnt > hlen + cclen) {
+		remaining = cqe_bcnt - hlen - cclen;
+		mlx5_nvmeotcp_add_tail_nonlinear(queue, skb, org_frags,
+						 org_nr_frags,
+						 frag_index);
+	}
+
+	mlx5e_nvmeotcp_put_queue(queue);
+	return true;
+}
+
+static bool
+mlx5e_nvmeotcp_rebuild_rx_skb_linear(struct mlx5e_rq *rq, struct sk_buff *skb,
+				     struct mlx5_cqe64 *cqe, u32 cqe_bcnt)
+{
+	int ccoff, cclen, hlen, ccid, remaining, fragsz, to_copy = 0;
+	struct net_device *netdev = rq->netdev;
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_nvmeotcp_queue_entry *nqe;
+	struct mlx5e_nvmeotcp_queue *queue;
+	struct mlx5e_cqe128 *cqe128;
+	u32 queue_id;
+
+	queue_id = (be32_to_cpu(cqe->sop_drop_qpn) & MLX5E_TC_FLOW_ID_MASK);
+	queue = mlx5e_nvmeotcp_get_queue(priv->nvmeotcp, queue_id);
+	if (unlikely(!queue)) {
+		dev_kfree_skb_any(skb);
+		return false;
+	}
+
+	cqe128 = container_of(cqe, struct mlx5e_cqe128, cqe64);
+	if (cqe_is_nvmeotcp_resync(cqe)) {
+		nvmeotcp_update_resync(queue, cqe128);
+		mlx5e_nvmeotcp_put_queue(queue);
+		return true;
+	}
+
+	/* If a resync occurred in the previous cqe,
+	 * the current cqe.crcvalid bit may not be valid,
+	 * so we will treat it as 0
+	 */
+	if (unlikely(queue->after_resync_cqe) && cqe_is_nvmeotcp_crcvalid(cqe)) {
+		skb->ulp_crc = 0;
+		queue->after_resync_cqe = 0;
+	} else {
+		if (queue->crc_rx)
+			skb->ulp_crc = cqe_is_nvmeotcp_crcvalid(cqe);
+	}
+
+	skb->ulp_ddp = cqe_is_nvmeotcp_zc(cqe);
+	if (!cqe_is_nvmeotcp_zc(cqe)) {
+		mlx5e_nvmeotcp_put_queue(queue);
+		return true;
+	}
+
+	/* cc ddp from cqe */
+	ccid	= be16_to_cpu(cqe128->ccid);
+	ccoff	= be32_to_cpu(cqe128->ccoff);
+	cclen	= be16_to_cpu(cqe128->cclen);
+	hlen	= be16_to_cpu(cqe128->hlen);
+
+	/* carve a hole in the skb for DDP data */
+	skb_trim(skb, hlen);
+	nqe = &queue->ccid_table[ccid];
+
+	/* packet starts new ccid? */
+	if (queue->ccid != ccid || queue->ccid_gen != nqe->ccid_gen) {
+		queue->ccid = ccid;
+		queue->ccoff = 0;
+		queue->ccoff_inner = 0;
+		queue->ccsglidx = 0;
+		queue->ccid_gen = nqe->ccid_gen;
+	}
+
+	/* skip inside cc until the ccoff in the cqe */
+	while (queue->ccoff + queue->ccoff_inner < ccoff) {
+		remaining = nqe->sgl[queue->ccsglidx].length - queue->ccoff_inner;
+		fragsz = min_t(off_t, remaining,
+			       ccoff - (queue->ccoff + queue->ccoff_inner));
+
+		if (fragsz == remaining)
+			mlx5e_nvmeotcp_advance_sgl_iter(queue);
+		else
+			queue->ccoff_inner += fragsz;
+	}
+
+	/* adjust the skb according to the cqe cc */
+	while (to_copy < cclen) {
+		remaining = nqe->sgl[queue->ccsglidx].length - queue->ccoff_inner;
+		fragsz = min_t(int, remaining, cclen - to_copy);
+
+		mlx5e_nvmeotcp_add_skb_frag(netdev, skb, queue, nqe, fragsz);
+		to_copy += fragsz;
+		if (fragsz == remaining)
+			mlx5e_nvmeotcp_advance_sgl_iter(queue);
+		else
+			queue->ccoff_inner += fragsz;
+	}
+
+	if (cqe_bcnt > hlen + cclen) {
+		remaining = cqe_bcnt - hlen - cclen;
+		mlx5_nvmeotcp_add_tail(queue, skb,
+				       offset_in_page(skb->data) +
+				       hlen + cclen, remaining);
+	}
+
+	mlx5e_nvmeotcp_put_queue(queue);
+	return true;
+}
+
+bool
+mlx5e_nvmeotcp_rebuild_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
+			      struct mlx5_cqe64 *cqe, u32 cqe_bcnt)
+{
+	if (skb->data_len)
+		return mlx5e_nvmeotcp_rebuild_rx_skb_nonlinear(rq, skb, cqe, cqe_bcnt);
+	else
+		return mlx5e_nvmeotcp_rebuild_rx_skb_linear(rq, skb, cqe, cqe_bcnt);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.h
new file mode 100644
index 000000000000..a8ca8a53bac6
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. */
+#ifndef __MLX5E_NVMEOTCP_RXTX_H__
+#define __MLX5E_NVMEOTCP_RXTX_H__
+
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+
+#include <linux/skbuff.h>
+#include "en_accel/nvmeotcp.h"
+
+bool
+mlx5e_nvmeotcp_rebuild_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
+			      struct mlx5_cqe64 *cqe, u32 cqe_bcnt);
+
+static inline int mlx5_nvmeotcp_get_headlen(struct mlx5_cqe64 *cqe, u32 cqe_bcnt)
+{
+	struct mlx5e_cqe128 *cqe128;
+
+	if (!cqe_is_nvmeotcp_zc(cqe))
+		return cqe_bcnt;
+
+	cqe128 = container_of(cqe, struct mlx5e_cqe128, cqe64);
+	return be16_to_cpu(cqe128->hlen);
+}
+
+#else
+
+static inline bool
+mlx5e_nvmeotcp_rebuild_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
+			      struct mlx5_cqe64 *cqe, u32 cqe_bcnt)
+{ return true; }
+
+static inline int mlx5_nvmeotcp_get_headlen(struct mlx5_cqe64 *cqe, u32 cqe_bcnt)
+{ return cqe_bcnt; }
+
+#endif /* CONFIG_MLX5_EN_NVMEOTCP */
+#endif /* __MLX5E_NVMEOTCP_RXTX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 9b9c3603a00b..ea4c73cafb0a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -53,7 +53,7 @@
 #include "en_accel/macsec.h"
 #include "en_accel/ipsec_rxtx.h"
 #include "en_accel/ktls_txrx.h"
-#include "en_accel/nvmeotcp.h"
+#include "en_accel/nvmeotcp_rxtx.h"
 #include "en/xdp.h"
 #include "en/xsk/rx.h"
 #include "en/health.h"
@@ -63,9 +63,11 @@
 
 static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
+				struct mlx5_cqe64 *cqe,
 				u16 cqe_bcnt, u32 head_offset, u32 page_idx);
 static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
+				   struct mlx5_cqe64 *cqe,
 				   u16 cqe_bcnt, u32 head_offset, u32 page_idx);
 static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
 static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe);
@@ -1484,7 +1486,7 @@ static inline void mlx5e_handle_csum(struct net_device *netdev,
 
 #define MLX5E_CE_BIT_MASK 0x80
 
-static inline void mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
+static inline bool mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
 				      u32 cqe_bcnt,
 				      struct mlx5e_rq *rq,
 				      struct sk_buff *skb)
@@ -1495,6 +1497,13 @@ static inline void mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
 
 	skb->mac_len = ETH_HLEN;
 
+	if (IS_ENABLED(CONFIG_MLX5_EN_NVMEOTCP) && cqe_is_nvmeotcp(cqe)) {
+		bool ret = mlx5e_nvmeotcp_rebuild_rx_skb(rq, skb, cqe, cqe_bcnt);
+
+		if (unlikely(!ret))
+			return ret;
+	}
+
 	if (unlikely(get_cqe_tls_offload(cqe)))
 		mlx5e_ktls_handle_rx_skb(rq, skb, cqe, &cqe_bcnt);
 
@@ -1540,6 +1549,8 @@ static inline void mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
 
 	if (unlikely(mlx5e_skb_is_multicast(skb)))
 		stats->mcast_packets++;
+
+	return true;
 }
 
 static void mlx5e_shampo_complete_rx_cqe(struct mlx5e_rq *rq,
@@ -1563,7 +1574,7 @@ static void mlx5e_shampo_complete_rx_cqe(struct mlx5e_rq *rq,
 	}
 }
 
-static inline void mlx5e_complete_rx_cqe(struct mlx5e_rq *rq,
+static inline bool mlx5e_complete_rx_cqe(struct mlx5e_rq *rq,
 					 struct mlx5_cqe64 *cqe,
 					 u32 cqe_bcnt,
 					 struct sk_buff *skb)
@@ -1572,7 +1583,7 @@ static inline void mlx5e_complete_rx_cqe(struct mlx5e_rq *rq,
 
 	stats->packets++;
 	stats->bytes += cqe_bcnt;
-	mlx5e_build_rx_skb(cqe, cqe_bcnt, rq, skb);
+	return mlx5e_build_rx_skb(cqe, cqe_bcnt, rq, skb);
 }
 
 static inline
@@ -1810,7 +1821,8 @@ static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 		goto free_wqe;
 	}
 
-	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
+	if (unlikely(!mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb)))
+		goto free_wqe;
 
 	if (mlx5e_cqe_regb_chain(cqe))
 		if (!mlx5e_tc_update_skb(cqe, skb)) {
@@ -1863,7 +1875,8 @@ static void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 		goto free_wqe;
 	}
 
-	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
+	if (unlikely(!mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb)))
+		goto free_wqe;
 
 	if (rep->vlan && skb_vlan_tag_present(skb))
 		skb_vlan_pop(skb);
@@ -1910,11 +1923,12 @@ static void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5e_rq *rq, struct mlx5_cqe64
 	skb = INDIRECT_CALL_2(rq->mpwqe.skb_from_cqe_mpwrq,
 			      mlx5e_skb_from_cqe_mpwrq_linear,
 			      mlx5e_skb_from_cqe_mpwrq_nonlinear,
-			      rq, wi, cqe_bcnt, head_offset, page_idx);
+			      rq, wi, cqe, cqe_bcnt, head_offset, page_idx);
 	if (!skb)
 		goto mpwrq_cqe_out;
 
-	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
+	if (unlikely(!mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb)))
+		goto mpwrq_cqe_out;
 
 	mlx5e_rep_tc_receive(cqe, rq, skb);
 
@@ -1959,12 +1973,18 @@ mlx5e_fill_skb_data(struct sk_buff *skb, struct mlx5e_rq *rq,
 	}
 }
 
+static inline u16 mlx5e_get_headlen_hint(struct mlx5_cqe64 *cqe, u32 cqe_bcnt)
+{
+	return min_t(u32, MLX5E_RX_MAX_HEAD, mlx5_nvmeotcp_get_headlen(cqe, cqe_bcnt));
+}
+
 static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
+				   struct mlx5_cqe64 *cqe,
 				   u16 cqe_bcnt, u32 head_offset, u32 page_idx)
 {
 	union mlx5e_alloc_unit *au = &wi->alloc_units[page_idx];
-	u16 headlen = min_t(u16, MLX5E_RX_MAX_HEAD, cqe_bcnt);
+	u16 headlen        = mlx5e_get_headlen_hint(cqe, cqe_bcnt);
 	u32 frag_offset    = head_offset + headlen;
 	u32 byte_cnt       = cqe_bcnt - headlen;
 	union mlx5e_alloc_unit *head_au = au;
@@ -2000,6 +2020,7 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *w
 
 static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
+				struct mlx5_cqe64 *cqe,
 				u16 cqe_bcnt, u32 head_offset, u32 page_idx)
 {
 	union mlx5e_alloc_unit *au = &wi->alloc_units[page_idx];
@@ -2195,7 +2216,8 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cq
 		if (likely(head_size))
 			*skb = mlx5e_skb_from_cqe_shampo(rq, wi, cqe, header_index);
 		else
-			*skb = mlx5e_skb_from_cqe_mpwrq_nonlinear(rq, wi, cqe_bcnt, data_offset,
+			*skb = mlx5e_skb_from_cqe_mpwrq_nonlinear(rq, wi, cqe,
+								  cqe_bcnt, data_offset,
 								  page_idx);
 		if (unlikely(!*skb))
 			goto free_hd_entry;
@@ -2270,11 +2292,12 @@ static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cq
 			      mlx5e_skb_from_cqe_mpwrq_linear,
 			      mlx5e_skb_from_cqe_mpwrq_nonlinear,
 			      mlx5e_xsk_skb_from_cqe_mpwrq_linear,
-			      rq, wi, cqe_bcnt, head_offset, page_idx);
+			      rq, wi, cqe, cqe_bcnt, head_offset, page_idx);
 	if (!skb)
 		goto mpwrq_cqe_out;
 
-	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
+	if (unlikely(!mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb)))
+		goto mpwrq_cqe_out;
 
 	if (mlx5e_cqe_regb_chain(cqe))
 		if (!mlx5e_tc_update_skb(cqe, skb)) {
@@ -2611,7 +2634,9 @@ static void mlx5e_trap_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe
 	if (!skb)
 		goto free_wqe;
 
-	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
+	if (unlikely(!mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb)))
+		goto free_wqe;
+
 	skb_push(skb, ETH_HLEN);
 
 	dl_port = mlx5e_devlink_get_dl_port(priv);
-- 
2.31.1

