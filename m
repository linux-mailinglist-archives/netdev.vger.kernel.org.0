Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D182D2D337B
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgLHUTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:19:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:36090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726553AbgLHUTu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:19:50 -0500
From:   saeed@kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V3 07/15] net/mlx5e: Move MLX5E_RX_ERR_CQE macro
Date:   Tue,  8 Dec 2020 11:35:47 -0800
Message-Id: <20201208193555.674504-8-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208193555.674504-1-saeed@kernel.org>
References: <20201208193555.674504-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@nvidia.com>

MLX5E_RX_ERR_CQE Macro is used only in data-path, move it to the
appropriate header file.

Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/health.h | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h   | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
index f88fbbe06995..018262d0164b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -7,8 +7,6 @@
 #include "en.h"
 #include "diag/rsc_dump.h"
 
-#define MLX5E_RX_ERR_CQE(cqe) (get_cqe_opcode(cqe) != MLX5_CQE_RESP_SEND)
-
 static inline bool cqe_syndrome_needs_recover(u8 syndrome)
 {
 	return syndrome == MLX5_CQE_SYNDROME_LOCAL_QP_OP_ERR ||
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 115ab19ffab1..7943eb30b837 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -24,6 +24,8 @@
 
 #define INL_HDR_START_SZ (sizeof(((struct mlx5_wqe_eth_seg *)NULL)->inline_hdr.start))
 
+#define MLX5E_RX_ERR_CQE(cqe) (get_cqe_opcode(cqe) != MLX5_CQE_RESP_SEND)
+
 enum mlx5e_icosq_wqe_type {
 	MLX5E_ICOSQ_WQE_NOP,
 	MLX5E_ICOSQ_WQE_UMR_RX,
-- 
2.26.2

