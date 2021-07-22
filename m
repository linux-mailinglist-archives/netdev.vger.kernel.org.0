Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E0D3D227A
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhGVKZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:25:18 -0400
Received: from mail-bn8nam12on2089.outbound.protection.outlook.com ([40.107.237.89]:58592
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231698AbhGVKZM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:25:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PJ7dlShJPgkqnGjlAH4WSYaw+oCZda6H9xqqQxg+gRxhbSHJvGxGnvsqvHiuMKlZy5CGYzuJS7UMXPl3dspjX32V8PA+GIiDY2sbZaWz8hMlIQ6nv72+Dsu0zfCJAJ8dicIADlrcfO5l1i2yIOsTHseK813D4OUtEFKtmjak9odDXQ4XULSz5zolTxKh6Ka6ToVC/VpeXkRVwDmi3WVFXtgnE0Ykdb4wwk0xAH1J5GjDbYs/ZgQrrpjVtzKvaaFDI56hOyO6zjzcdZRyBesIuz6YZv9tf4af2s02o2GNgv00X2jF5OJgAiIOYfuUtdWxb6KolsFSbbCnU7n3ZVg+Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JfQ8fSajKUipAvFvd3MML2Gi+7jl0rWgHEIBjaybNtE=;
 b=XNQhwlHTjwiWJ8uC6dNfEoHoFm3y/PlJ1ItARtQOdtwaNlJvs59XIT/Kg+IJern0uwvb3MtWQeawsca74LW2OqUKz+zHGY0jWAjwnc+7e7mOF4xnj6APzdWE1qk9gd0sP9anju/7kAZ6JWIKpVM6CUV3ZMOb8Euqc0jwvcF1+SqDNsvJ+oKmfEwc487lRQ8errL17uMsak4Dofx8MRL2VnX63cuBBUDZSVIoBsTm4KcHy5wCmuiwPCx5oF28KXfc1ZCiNeVLLBSlSgn375f6ga8CnYhRb0y/yM23mCzJtRduau9ZU+BarJV0Z20+iv3oVZJGeyuLk5/DjHEz+Cg2Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=marvell.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JfQ8fSajKUipAvFvd3MML2Gi+7jl0rWgHEIBjaybNtE=;
 b=aVLET+UBdTNwLlhVv4ELlfdXe2d2Yh7XJSbQZXx1J2/W9JwWNVjR64IZILu1ZraSIR/Vu8m2MBCf9S72WNtlnoz6q/98vXpz0oPaFifSFFElepg9+RnMFWRf0xFSoFCHyOBasNJJ77kLAYkgiS7Q6MKM3T8ZrdHGSqUW55+y6KG202+nSQlAE6syqcv3NalFYJt6raNTkjSEwKEG7Oxg37ibZ/pnJJV1OfQGdb4YECUJPx11oxGnoi023a+LWAxI+sciW2FepabZHBFkuVhaWv3IfTXcs01qjooh5C1v7dwZCfM4JWOBBeYbNVV39eFywA45Zano7mVCOGjf0TUH6g==
Received: from DM6PR02CA0090.namprd02.prod.outlook.com (2603:10b6:5:1f4::31)
 by BYAPR12MB2949.namprd12.prod.outlook.com (2603:10b6:a03:12f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.31; Thu, 22 Jul
 2021 11:05:46 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::57) by DM6PR02CA0090.outlook.office365.com
 (2603:10b6:5:1f4::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend
 Transport; Thu, 22 Jul 2021 11:05:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:05:46 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 04:05:45 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:05:41 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v5 net-next 19/36] net/mlx5e: NVMEoTCP statistics
Date:   Thu, 22 Jul 2021 14:03:08 +0300
Message-ID: <20210722110325.371-20-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73611479-f08c-4c9f-59ca-08d94d00a7e3
X-MS-TrafficTypeDiagnostic: BYAPR12MB2949:
X-Microsoft-Antispam-PRVS: <BYAPR12MB2949CA98DB7AD278A66E270ABDE49@BYAPR12MB2949.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:126;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HId/qNG9yiSZ8gFpGPCe7BexEBxldsOLqhWgl3+gt4c0EF871moRlQbTyV/He9Fa/Z8ShA9FhxkOxdZXekiPck4BfoRxFLLrPtjBHEP4+mhQMFIY0Ilybi6o/jNxlDE7N41WrV+pQw+T26ReI+Mzt+xtPSrUC4iyhOo8xI1q1eKQVaRTtuPQkEbozUR1C4uVyUG8DHI9TZgYO6KYgqux6u+DUq+mGGhPjuqf925ivM2zVUcnc2ucigq/sQTRFi/X0HK6gX76SKRG+DIidbdAiWFtORKBPjL5uK08IFUrUhs24YS23U23hmHbE3ueNrmY5nCFp0fctV1wLl6pi7pQMRbApmL2ZXXg6zlDtMUOi3oRWf1WC/KcEkUHVlIETUA0ryBU/EHViz1OldoMrzjOpZmmXDeOglBL16hckhQL3UOvAHmZYBsKsY4ysGb//CQDdKlkFTjvoaJUj74dnObAe3mDj7SsM+YarrYD7ElvvS/Y7fZQ4fRPQ9Si1l5t8Su93oHTsyutbZ742O2WaBUl1cI56GRx14UA3wVMnGgttAOwAZbSRHT2xhN2A75JiHTDl/VWXcQ+WgMu9o52YgFRHYMRsHR7MNJ0DlqFAOiAZknLj+SJ+yfNWB66TEPTkXsEQJ/+H44aOOyj2oNTdNJhO8dNgmS03HdR79DaxUFJITdeKfYCmEHmxBwEaSlX9oenlLT8ngTVxgq0OWRXIxEAjVCa15YpLPYPmpmCb7WL5oE=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(346002)(396003)(46966006)(36840700001)(921005)(7636003)(70586007)(82310400003)(4326008)(30864003)(86362001)(107886003)(8676002)(1076003)(2906002)(82740400003)(336012)(186003)(5660300002)(6666004)(356005)(70206006)(7696005)(7416002)(83380400001)(8936002)(478600001)(426003)(26005)(47076005)(2616005)(36756003)(54906003)(36860700001)(110136005)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:05:46.0110
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 73611479-f08c-4c9f-59ca-08d94d00a7e3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2949
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

NVMEoTCP offload statistics includes both control and data path
statistic: counters for ndo, offloaded packets/bytes, dropped packets
and resync operation.

Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 23 +++++++++++-
 .../mlx5/core/en_accel/nvmeotcp_rxtx.c        | 16 ++++++++
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 37 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en_stats.h    | 24 ++++++++++++
 4 files changed, 98 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index 4fdfbe4468ee..7f6607cac9fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -667,6 +667,11 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_nvmeotcp_queue *queue;
 	int max_wqe_sz_cap, queue_id, err;
+	struct mlx5e_rq_stats *stats;
+	u32 channel_ix;
+
+	channel_ix = mlx5e_get_channel_ix_from_io_cpu(priv, config->io_cpu);
+	stats = &priv->channel_stats[channel_ix].rq;
 
 	if (tconfig->type != ULP_DDP_NVME) {
 		err = -EOPNOTSUPP;
@@ -694,8 +699,7 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 	queue->id = queue_id;
 	queue->dgst = config->dgst;
 	queue->pda = config->cpda;
-	queue->channel_ix = mlx5e_get_channel_ix_from_io_cpu(priv,
-							     config->io_cpu);
+	queue->channel_ix = channel_ix;
 	queue->size = config->queue_size;
 	max_wqe_sz_cap  = min_t(int, MAX_DS_VALUE * MLX5_SEND_WQE_DS,
 				MLX5_CAP_GEN(mdev, max_wqe_sz_sq) << OCTWORD_SHIFT);
@@ -715,6 +719,7 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 	if (err)
 		goto destroy_rx;
 
+	stats->nvmeotcp_queue_init++;
 	write_lock_bh(&sk->sk_callback_lock);
 	ulp_ddp_set_ctx(sk, queue);
 	write_unlock_bh(&sk->sk_callback_lock);
@@ -729,6 +734,7 @@ mlx5e_nvmeotcp_queue_init(struct net_device *netdev,
 free_queue:
 	kfree(queue);
 out:
+	stats->nvmeotcp_queue_init_fail++;
 	return err;
 }
 
@@ -739,11 +745,15 @@ mlx5e_nvmeotcp_queue_teardown(struct net_device *netdev,
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_nvmeotcp_queue *queue;
+	struct mlx5e_rq_stats *stats;
 
 	queue = container_of(ulp_ddp_get_ctx(sk), struct mlx5e_nvmeotcp_queue, ulp_ddp_ctx);
 
 	napi_synchronize(&priv->channels.c[queue->channel_ix]->napi);
 
+	stats = &priv->channel_stats[queue->channel_ix].rq;
+	stats->nvmeotcp_queue_teardown++;
+
 	WARN_ON(refcount_read(&queue->ref_count) != 1);
 	if (queue->zerocopy | queue->crc_rx)
 		mlx5e_nvmeotcp_destroy_rx(queue, mdev, queue->zerocopy);
@@ -765,6 +775,7 @@ mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct scatterlist *sg = ddp->sg_table.sgl;
 	struct mlx5e_nvmeotcp_queue *queue;
+	struct mlx5e_rq_stats *stats;
 	struct mlx5_core_dev *mdev;
 	int i, size = 0, count = 0;
 
@@ -786,6 +797,11 @@ mlx5e_nvmeotcp_ddp_setup(struct net_device *netdev,
 	queue->ccid_table[ddp->command_id].ccid_gen++;
 	queue->ccid_table[ddp->command_id].sgl_length = count;
 
+	stats = &priv->channel_stats[queue->channel_ix].rq;
+	stats->nvmeotcp_ddp_setup++;
+	if (unlikely(mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_UMR, ddp->command_id, count)))
+		stats->nvmeotcp_ddp_setup_fail++;
+
 	return 0;
 }
 
@@ -826,6 +842,7 @@ mlx5e_nvmeotcp_ddp_teardown(struct net_device *netdev,
 	struct mlx5e_nvmeotcp_queue *queue;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct nvmeotcp_queue_entry *q_entry;
+	struct mlx5e_rq_stats *stats;
 
 	queue = container_of(ulp_ddp_get_ctx(sk), struct mlx5e_nvmeotcp_queue, ulp_ddp_ctx);
 	q_entry  = &queue->ccid_table[ddp->command_id];
@@ -835,6 +852,8 @@ mlx5e_nvmeotcp_ddp_teardown(struct net_device *netdev,
 	q_entry->queue = queue;
 
 	mlx5e_nvmeotcp_post_klm_wqe(queue, KLM_UMR, ddp->command_id, 0);
+	stats = &priv->channel_stats[queue->channel_ix].rq;
+	stats->nvmeotcp_ddp_teardown++;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
index 31586f574fc0..d4ac914e2a5b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp_rxtx.c
@@ -10,12 +10,16 @@ static void nvmeotcp_update_resync(struct mlx5e_nvmeotcp_queue *queue,
 				   struct mlx5e_cqe128 *cqe128)
 {
 	const struct ulp_ddp_ulp_ops *ulp_ops;
+	struct mlx5e_rq_stats *stats;
 	u32 seq;
 
 	seq = be32_to_cpu(cqe128->resync_tcp_sn);
 	ulp_ops = inet_csk(queue->sk)->icsk_ulp_ddp_ops;
 	if (ulp_ops && ulp_ops->resync_request)
 		ulp_ops->resync_request(queue->sk, seq, ULP_DDP_RESYNC_REQ);
+
+	stats = queue->priv->channels.c[queue->channel_ix]->rq.stats;
+	stats->nvmeotcp_resync++;
 }
 
 static void mlx5e_nvmeotcp_advance_sgl_iter(struct mlx5e_nvmeotcp_queue *queue)
@@ -50,10 +54,13 @@ mlx5_nvmeotcp_add_tail_nonlinear(struct mlx5e_nvmeotcp_queue *queue,
 				 int org_nr_frags, int frag_index)
 {
 	struct mlx5e_priv *priv = queue->priv;
+	struct mlx5e_rq_stats *stats;
 
 	while (org_nr_frags != frag_index) {
 		if (skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS) {
 			dev_kfree_skb_any(skb);
+			stats = priv->channels.c[queue->channel_ix]->rq.stats;
+			stats->nvmeotcp_drop++;
 			return NULL;
 		}
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
@@ -72,9 +79,12 @@ mlx5_nvmeotcp_add_tail(struct mlx5e_nvmeotcp_queue *queue, struct sk_buff *skb,
 		       int offset, int len)
 {
 	struct mlx5e_priv *priv = queue->priv;
+	struct mlx5e_rq_stats *stats;
 
 	if (skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS) {
 		dev_kfree_skb_any(skb);
+		stats = priv->channels.c[queue->channel_ix]->rq.stats;
+		stats->nvmeotcp_drop++;
 		return NULL;
 	}
 	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
@@ -135,6 +145,7 @@ mlx5e_nvmeotcp_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
 	skb_frag_t org_frags[MAX_SKB_FRAGS];
 	struct mlx5e_nvmeotcp_queue *queue;
 	struct nvmeotcp_queue_entry *nqe;
+	struct mlx5e_rq_stats *stats;
 	int org_nr_frags, frag_index;
 	struct mlx5e_cqe128 *cqe128;
 	u32 queue_id;
@@ -172,6 +183,8 @@ mlx5e_nvmeotcp_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
 		return skb;
 	}
 
+	stats = priv->channels.c[queue->channel_ix]->rq.stats;
+
 	/* cc ddp from cqe */
 	ccid = be16_to_cpu(cqe128->ccid);
 	ccoff = be32_to_cpu(cqe128->ccoff);
@@ -214,6 +227,7 @@ mlx5e_nvmeotcp_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
 	while (to_copy < cclen) {
 		if (skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS) {
 			dev_kfree_skb_any(skb);
+			stats->nvmeotcp_drop++;
 			mlx5e_nvmeotcp_put_queue(queue);
 			return NULL;
 		}
@@ -243,6 +257,8 @@ mlx5e_nvmeotcp_handle_rx_skb(struct net_device *netdev, struct sk_buff *skb,
 							       frag_index);
 	}
 
+	stats->nvmeotcp_offload_packets++;
+	stats->nvmeotcp_offload_bytes += cclen;
 	mlx5e_nvmeotcp_put_queue(queue);
 	return skb;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index e4f5b6395148..3d95e46422e5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -34,6 +34,7 @@
 #include "en.h"
 #include "en_accel/tls.h"
 #include "en_accel/en_accel.h"
+#include "en_accel/nvmeotcp.h"
 
 static unsigned int stats_grps_num(struct mlx5e_priv *priv)
 {
@@ -187,6 +188,18 @@ static const struct counter_desc sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_resync_res_retry) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_resync_res_skip) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_tls_err) },
+#endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_queue_init) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_queue_init_fail) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_queue_teardown) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_ddp_setup) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_ddp_setup_fail) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_ddp_teardown) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_drop) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_resync) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_offload_packets) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_nvmeotcp_offload_bytes) },
 #endif
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_events) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_poll) },
@@ -349,6 +362,18 @@ static void mlx5e_stats_grp_sw_update_stats_rq_stats(struct mlx5e_sw_stats *s,
 	s->rx_tls_resync_res_skip     += rq_stats->tls_resync_res_skip;
 	s->rx_tls_err                 += rq_stats->tls_err;
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	s->rx_nvmeotcp_queue_init      += rq_stats->nvmeotcp_queue_init;
+	s->rx_nvmeotcp_queue_init_fail += rq_stats->nvmeotcp_queue_init_fail;
+	s->rx_nvmeotcp_queue_teardown  += rq_stats->nvmeotcp_queue_teardown;
+	s->rx_nvmeotcp_ddp_setup       += rq_stats->nvmeotcp_ddp_setup;
+	s->rx_nvmeotcp_ddp_setup_fail  += rq_stats->nvmeotcp_ddp_setup_fail;
+	s->rx_nvmeotcp_ddp_teardown    += rq_stats->nvmeotcp_ddp_teardown;
+	s->rx_nvmeotcp_drop            += rq_stats->nvmeotcp_drop;
+	s->rx_nvmeotcp_resync          += rq_stats->nvmeotcp_resync;
+	s->rx_nvmeotcp_offload_packets += rq_stats->nvmeotcp_offload_packets;
+	s->rx_nvmeotcp_offload_bytes   += rq_stats->nvmeotcp_offload_bytes;
+#endif
 }
 
 static void mlx5e_stats_grp_sw_update_stats_ch_stats(struct mlx5e_sw_stats *s,
@@ -1788,6 +1813,18 @@ static const struct counter_desc rq_stats_desc[] = {
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_resync_res_skip) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, tls_err) },
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_queue_init) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_queue_init_fail) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_queue_teardown) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_ddp_setup) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_ddp_setup_fail) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_ddp_teardown) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_drop) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_resync) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_offload_packets) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, nvmeotcp_offload_bytes) },
+#endif
 };
 
 static const struct counter_desc sq_stats_desc[] = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 139e59f30db0..e645ee83de97 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -194,6 +194,18 @@ struct mlx5e_sw_stats {
 	u64 rx_congst_umr;
 	u64 rx_arfs_err;
 	u64 rx_recover;
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	u64 rx_nvmeotcp_queue_init;
+	u64 rx_nvmeotcp_queue_init_fail;
+	u64 rx_nvmeotcp_queue_teardown;
+	u64 rx_nvmeotcp_ddp_setup;
+	u64 rx_nvmeotcp_ddp_setup_fail;
+	u64 rx_nvmeotcp_ddp_teardown;
+	u64 rx_nvmeotcp_drop;
+	u64 rx_nvmeotcp_resync;
+	u64 rx_nvmeotcp_offload_packets;
+	u64 rx_nvmeotcp_offload_bytes;
+#endif
 	u64 ch_events;
 	u64 ch_poll;
 	u64 ch_arm;
@@ -354,6 +366,18 @@ struct mlx5e_rq_stats {
 	u64 tls_resync_res_skip;
 	u64 tls_err;
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	u64 nvmeotcp_queue_init;
+	u64 nvmeotcp_queue_init_fail;
+	u64 nvmeotcp_queue_teardown;
+	u64 nvmeotcp_ddp_setup;
+	u64 nvmeotcp_ddp_setup_fail;
+	u64 nvmeotcp_ddp_teardown;
+	u64 nvmeotcp_drop;
+	u64 nvmeotcp_resync;
+	u64 nvmeotcp_offload_packets;
+	u64 nvmeotcp_offload_bytes;
+#endif
 };
 
 struct mlx5e_sq_stats {
-- 
2.24.1

