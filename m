Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6FA22F702
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 19:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730913AbgG0Rtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 13:49:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbgG0Rte (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 13:49:34 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39C8F2070B;
        Mon, 27 Jul 2020 17:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595872174;
        bh=2HB61QDPf92Lsa6Jf9B/n+P3MmdDD0gqtDvjOvcjP1g=;
        h=Date:From:To:Cc:Subject:From;
        b=UvUboc7otMxoumCsLUUP+igA9u9ZI3B8OmQXctMhbTROY+Bi5UZcwBQj468javLeg
         qGOLSbbqKUQiM1LzYbtPooWQSyXO3YodxM9b+ZsvG3zBs7w/NVzrlY/M/NxENCA9SD
         qgJFoRBthteOsmqjxUGcmYTfHnl+Zqckim4GbHkM=
Date:   Mon, 27 Jul 2020 12:55:26 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] net/mlx4: Use fallthrough pseudo-keyword
Message-ID: <20200727175526.GA21335@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the existing /* fall through */ comments and its variants with
the new pseudo-keyword macro fallthrough[1].

[1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_rx.c | 4 ++--
 drivers/net/ethernet/mellanox/mlx4/eq.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx4/mcg.c   | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index 8a10285b0e10..b50c567ef508 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -806,10 +806,10 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
 				goto xdp_drop_no_cnt; /* Drop on xmit failure */
 			default:
 				bpf_warn_invalid_xdp_action(act);
-				/* fall through */
+				fallthrough;
 			case XDP_ABORTED:
 				trace_xdp_exception(dev, xdp_prog, act);
-				/* fall through */
+				fallthrough;
 			case XDP_DROP:
 				ring->xdp_drop++;
 xdp_drop_no_cnt:
diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
index c790a5fcea73..ae305c2e9225 100644
--- a/drivers/net/ethernet/mellanox/mlx4/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
@@ -558,7 +558,7 @@ static int mlx4_eq_int(struct mlx4_dev *dev, struct mlx4_eq *eq)
 			mlx4_dbg(dev, "%s: MLX4_EVENT_TYPE_SRQ_LIMIT. srq_no=0x%x, eq 0x%x\n",
 				 __func__, be32_to_cpu(eqe->event.srq.srqn),
 				 eq->eqn);
-			/* fall through */
+			fallthrough;
 		case MLX4_EVENT_TYPE_SRQ_CATAS_ERROR:
 			if (mlx4_is_master(dev)) {
 				/* forward only to slave owning the SRQ */
diff --git a/drivers/net/ethernet/mellanox/mlx4/mcg.c b/drivers/net/ethernet/mellanox/mlx4/mcg.c
index 9486caecfbdc..f1b4ad9c66d2 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mcg.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mcg.c
@@ -1412,7 +1412,7 @@ int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 	case MLX4_STEERING_MODE_A0:
 		if (prot == MLX4_PROT_ETH)
 			return 0;
-		/* fall through */
+		fallthrough;
 
 	case MLX4_STEERING_MODE_B0:
 		if (prot == MLX4_PROT_ETH)
@@ -1442,7 +1442,7 @@ int mlx4_multicast_detach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 	case MLX4_STEERING_MODE_A0:
 		if (prot == MLX4_PROT_ETH)
 			return 0;
-		/* fall through */
+		fallthrough;
 
 	case MLX4_STEERING_MODE_B0:
 		if (prot == MLX4_PROT_ETH)
-- 
2.27.0

