Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3BB3D2288
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhGVK03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 06:26:29 -0400
Received: from mail-co1nam11on2070.outbound.protection.outlook.com ([40.107.220.70]:10720
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231634AbhGVK02 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 06:26:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WMFvjXtNxUKb/ntFUq3I+fES2Wtg/+XXClZxW8RJE85NZryrEjX6k0XcXBRWujwRNp09+oHs1jdgDqruRHsr0YHu7MSC94Mz8+Z1sUoob4JKT5EjugSoVnvvBifeh25Ly1LENmoYw3iYtAsDKP/W8DTIXKwzBj3sEtzXFGw+0l7uBW/UvXn5fYrLncwQlvDvyeDbAceNy53fnKhb8708kn0RtKcg1Cryn2lwmxRdDE/nzfVO5auVrbqjcH14EKEpkJ+dM58cYwttCCgajr1KgDxl3UQ8mQVtAdZGGtMfZf5c9TfvMRBHOFMuhSVjmEdJc/dmlBu4Q/XGladPwrPzFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1h5UfwDtV1F1ZrdJ5wPNVZcWPRuJLVii37OhhJ80aX4=;
 b=Bq9P3ZUTKZVZM0/O+wEsxFQcDt3EOdbNNs8aAHmRBzS7ejD7V+jTmHTqqdzVYcRtYIvvNkvXiCRqavvKg0U3zAOOBMBa63VUZ7Vdq7Izx99MwdTsoL1uXywClItAJ73oChc0UXS41NQRmGjsA/zDz58ABl/b5M3ENlpN0OT1C23LPZZdIlfjkyd8JFYhS2WB+cLsQGtL683KPnBEAWC0/9s3QjpA00J34NOtZDluj8FKhT9ZmGpoUIbBRq4/nc4H49apRL/BHZ4n2WdzLGuUEPEFo9xV2NSDcx2Jl8SMb76W6qi8oNIUz3ob0sDSceFlHBSRc6UWvT4k3wz3exc5aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=marvell.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1h5UfwDtV1F1ZrdJ5wPNVZcWPRuJLVii37OhhJ80aX4=;
 b=b1Oxe11GNADnNYcxIFsGUvPF+g21hSdWedRGWxxAShc64p+vjjKGN2I76yul1FM4xXGcXNxjXhI57ZNwVRGQUR7tkFe7Xv5hKBi/M5rOr/KbwRF1iBK93HslGypdeceOBmT7oiWzxrYo6W+GHHKOoW/hgWilAZxZO/z6VnEWvutJ79ucDtJAX9+GK4HFPoP8nTl6qkUXtGluZMuq0cQZkyun8EsDmYSknKWxowgsaLHeDnkKQZAsP0Y5C2hpPv1I1FKK4AhuaZNWry7twznCADxDV4O3kQLASk3Tx/vqEOZFEjTAmsazleIv+GNt/IZqkGR2QsL/2ewroXTSpCTfNQ==
Received: from MWHPR17CA0069.namprd17.prod.outlook.com (2603:10b6:300:93::31)
 by MN2PR12MB3405.namprd12.prod.outlook.com (2603:10b6:208:cb::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Thu, 22 Jul
 2021 11:07:02 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:93:cafe::73) by MWHPR17CA0069.outlook.office365.com
 (2603:10b6:300:93::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend
 Transport; Thu, 22 Jul 2021 11:07:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 11:07:01 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 22 Jul
 2021 11:07:00 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 22 Jul 2021 11:06:53 +0000
From:   Boris Pismenny <borisp@nvidia.com>
To:     <dsahern@gmail.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <saeedm@nvidia.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <axboe@fb.com>, <kbusch@kernel.org>, <viro@zeniv.linux.org.uk>,
        <edumazet@google.com>, <smalin@marvell.com>
CC:     <boris.pismenny@gmail.com>, <linux-nvme@lists.infradead.org>,
        <netdev@vger.kernel.org>, <benishay@nvidia.com>,
        <ogerlitz@nvidia.com>, <yorayz@nvidia.com>
Subject: [PATCH v5 net-next 33/36] net/mlx5e: NVMEoTCP DDGST TX Data path
Date:   Thu, 22 Jul 2021 14:03:22 +0300
Message-ID: <20210722110325.371-34-borisp@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210722110325.371-1-borisp@nvidia.com>
References: <20210722110325.371-1-borisp@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a32b389e-cef2-4980-cca6-08d94d00d4c7
X-MS-TrafficTypeDiagnostic: MN2PR12MB3405:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3405093F62E1FD36877D3CD5BDE49@MN2PR12MB3405.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fLAGFQS60QpNuPf+LufZjDzqU04sn33xOCmNETbt4wMj4v4l+c6yQILLqpW387StsAr4XHFdUzx3fsvbxXGWl7YNT/3ELgA7JJASbUqt7YNrQ/FwNrXnmElqallJgL7lcjGQ23jPjtbbhCAoWP94Hee5dUdLaIqTBU9IJ+uhIaqnv/W3gV6qLyBzXM+ouTa9B9J6q4oK5sXHbEkYrmRChgfo5UY966RgKRLtNpGpcXYzVbDl5mBMQ3TkT2ZqG7xwP3I8hnr9BQu7jMy4QgoMM8vOLjXxOI6kaLNyudQ4Ka7Z+bKjVX6nyyh9QfvFrTV34DzqHKzYXtCnRjd9ik01sObpXFPtoL0XBcafBBcCtJvLPYZ8qpZtMZlHnap4wJ7/vyU3g+46mYOrOSTUR1pYxzKCJpVA78mqSr+dbmuS7UbAC2TVbG6xY7XsMHPw8NZL6j5JESs8eNMfr2w560yR+i5pPGUzWeavluLYz+QQRM1IBU9IkeC3Q0LSb6OU3VJEdWm15qFBvWxsfypowmlXS3vR2/ZpeGPwLhIEUziA+yXVcfHuCopikJ4FJWN6CsGKZwBny1x/4UaFTY97JcqYpWPSg+qki+WQ7BOBxvjlrQcBGR/LzccMf0PIO9djHjBOYMVC+GV8qkWM7qw1OFATSqEGuMCKvf3X9OlWWP16DM5bvGJNuGCoeghDl+phrbLluZrwwoLzEkPl5m+uuLXJ11up8CBOsa4xViotLM3Sht0=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(186003)(70206006)(4326008)(6666004)(47076005)(336012)(7416002)(921005)(82310400003)(2906002)(5660300002)(2616005)(107886003)(426003)(7636003)(356005)(70586007)(7696005)(1076003)(26005)(508600001)(83380400001)(36756003)(8676002)(316002)(86362001)(110136005)(36860700001)(8936002)(54906003)(36906005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 11:07:01.3739
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a32b389e-cef2-4980-cca6-08d94d00d4c7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3405
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yoray Zack <yorayz@nvidia.com>

This patch handles only the good flow for the DDGST Tx offload
 skb and wqe.
Later patches will handle bad flow (OOO packets)

1.  add mlx5e_nvmeotcp_handle_tx_skb function(skb,...):
	check if the skb can be offlaoded.
        this function track the tcp_seq of the skb,
	and check if this is the next tcp_seq.
	and if so, send this skb with DDGST Tx offload.

2. add mlx5e_nvmeotcp_handle_tx_wqe function :
	send the wqe with the correct tis number for the offload.

Signed-off-by: Yoray Zack <yorayz@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/en_accel.h    | 13 ++++
 .../mellanox/mlx5/core/en_accel/nvmeotcp.c    | 63 +++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/nvmeotcp.h    |  6 ++
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 11 ++++
 4 files changed, 93 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index b9404366e6e8..2e5a7741736f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -113,6 +113,9 @@ struct mlx5e_accel_tx_state {
 #ifdef CONFIG_MLX5_EN_IPSEC
 	struct mlx5e_accel_tx_ipsec_state ipsec;
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	int tisn;
+#endif
 };
 
 static inline bool mlx5e_accel_tx_begin(struct net_device *dev,
@@ -137,6 +140,12 @@ static inline bool mlx5e_accel_tx_begin(struct net_device *dev,
 	}
 #endif
 
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	if (test_bit(MLX5E_SQ_STATE_NVMEOTCP, &sq->state)) {
+		if (unlikely(!mlx5e_nvmeotcp_handle_tx_skb(dev, sq, skb, &state->tisn)))
+			return false;
+	}
+#endif
 	return true;
 }
 
@@ -187,6 +196,10 @@ static inline void mlx5e_accel_tx_finish(struct mlx5e_txqsq *sq,
 	mlx5e_tls_handle_tx_wqe(&wqe->ctrl, &state->tls);
 #endif
 
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	mlx5e_nvmeotcp_handle_tx_wqe(sq, &wqe->ctrl, state->tisn);
+#endif
+
 #ifdef CONFIG_MLX5_EN_IPSEC
 	if (test_bit(MLX5E_SQ_STATE_IPSEC, &sq->state) &&
 	    state->ipsec.xo && state->ipsec.tailen)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
index 624d8a28dc21..d9f6125f5dbc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.c
@@ -1160,6 +1160,69 @@ void mlx5e_nvmeotcp_tx_post_param_wqes(struct mlx5e_txqsq *sq, struct sock *sk,
 	mlx5e_nvmeotcp_tx_post_progress_params(ctx, sq, tcp_sk(sk)->copied_seq, false);
 }
 
+static inline bool mlx5e_is_sk_tx_device_offloaded(struct sock *sk)
+{
+	/* Return True after smp_store_release assing in
+	 * mlx5e_nvmeotcp_queue_tx_init().
+	 */
+	return sk && sk_fullsock(sk) &&
+		(smp_load_acquire(&sk->sk_validate_xmit_skb) ==
+		 &ulp_ddp_validate_xmit_skb);
+}
+
+bool mlx5e_nvmeotcp_handle_tx_skb(struct net_device *netdev,
+				  struct mlx5e_txqsq *sq,
+				  struct sk_buff *skb, int *nvmeotcp_tisn)
+{
+	struct mlx5e_nvmeotcp_queue *ctx;
+	int datalen;
+	u32 seq;
+
+	if (!mlx5e_is_sk_tx_device_offloaded(skb->sk))
+		goto out;
+
+	datalen = skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb));
+	if (!datalen)
+		goto out;
+
+	ctx = container_of(ulp_ddp_get_ctx(skb->sk),
+			   struct mlx5e_nvmeotcp_queue, ulp_ddp_ctx);
+	if (!ctx)
+		goto out;
+
+	mlx5e_tx_mpwqe_ensure_complete(sq);
+
+	if (WARN_ON_ONCE(ctx->ulp_ddp_ctx.netdev != netdev))
+		goto err_out;
+
+	if (unlikely(mlx5e_nvmeotcp_test_and_clear_pending(ctx)))
+		mlx5e_nvmeotcp_tx_post_param_wqes(sq, skb->sk, ctx);
+
+	seq = ntohl(tcp_hdr(skb)->seq);
+	if (unlikely(ctx->ulp_ddp_ctx.expected_seq != seq))
+		goto err_out;
+
+	*nvmeotcp_tisn = ctx->tisn;
+	ctx->ulp_ddp_ctx.expected_seq = seq + datalen;
+	goto good_out;
+out:
+	*nvmeotcp_tisn = 0;
+good_out:
+	return true;
+err_out:
+	dev_kfree_skb(skb);
+	return false;
+}
+
+void mlx5e_nvmeotcp_handle_tx_wqe(struct mlx5e_txqsq *sq,
+				  struct mlx5_wqe_ctrl_seg *cseg,
+				  int tisn)
+{
+	if (tisn) {
+		cseg->tis_tir_num = cpu_to_be32(tisn << 8);
+	}
+}
+
 void mlx5e_nvmeotcp_cleanup(struct mlx5e_priv *priv)
 {
 	struct mlx5e_nvmeotcp *nvmeotcp = priv->nvmeotcp;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
index 3bc45b81da06..0451b3ac3687 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/nvmeotcp.h
@@ -119,6 +119,12 @@ void mlx5e_nvmeotcp_ddp_inv_done(struct mlx5e_icosq_wqe_info *wi);
 void mlx5e_nvmeotcp_ctx_comp(struct mlx5e_icosq_wqe_info *wi);
 int mlx5e_nvmeotcp_init_rx(struct mlx5e_priv *priv);
 void mlx5e_nvmeotcp_cleanup_rx(struct mlx5e_priv *priv);
+bool mlx5e_nvmeotcp_handle_tx_skb(struct net_device *netdev,
+				  struct mlx5e_txqsq *sq,
+				  struct sk_buff *skb, int *tisn);
+void mlx5e_nvmeotcp_handle_tx_wqe(struct mlx5e_txqsq *sq,
+				  struct mlx5_wqe_ctrl_seg *csegl,
+				  int tisn);
 #else
 
 static inline void mlx5e_nvmeotcp_build_netdev(struct mlx5e_priv *priv) { }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index c63d78eda606..7feaf5608b9d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -249,6 +249,13 @@ mlx5e_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		eseg->cs_flags = MLX5_ETH_WQE_L3_CSUM | MLX5_ETH_WQE_L4_CSUM;
 		sq->stats->csum_partial++;
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	} else if (unlikely(accel && accel->tisn)) {
+		eseg->cs_flags = MLX5_ETH_WQE_L3_CSUM | MLX5_ETH_WQE_L4_CSUM;
+		sq->stats->csum_partial++;
+#endif
+
+
 	} else if (unlikely(mlx5e_ipsec_eseg_meta(eseg))) {
 		ipsec_txwqe_build_eseg_csum(sq, skb, eseg);
 	} else
@@ -352,6 +359,10 @@ mlx5e_tx_wqe_inline_mode(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	if (accel && accel->tls.tls_tisn)
 		return MLX5_INLINE_MODE_TCP_UDP;
 #endif
+#ifdef CONFIG_MLX5_EN_NVMEOTCP
+	if (accel && accel->tisn)
+		return MLX5_INLINE_MODE_TCP_UDP;
+#endif
 
 	mode = sq->min_inline_mode;
 
-- 
2.24.1

