Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F612F28C4
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391947AbhALHPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 02:15:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:37676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391923AbhALHPF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 02:15:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 125F022D37;
        Tue, 12 Jan 2021 07:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610435628;
        bh=IE6lXAokl896ORwgu2QbyoRCsGUo1Ehb0KDPFpnkqMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lvvlCTTD2w6G764WpLErhHnqAynCoEzSONOY7y9RUZt16YGjExXI19IhM9W4deS79
         FYsQGTD/nJ8MlnQtLDkthrfoPO66d5OkNPbmXAoiBU2gCiELEWZszv81SdG521N/ky
         XoPL1dVQmpJwO/5MAp87l2iMrsmdbVPiegpPrdAtCV1JkCvIVhJcRoUFsLWs4ZOpYq
         PtDSLEImmJACVp5rm/CrbrZkaN1g5SDixncyIaBIqZ4Fhapm65xXoAB8Jf4opb6FqU
         DwPl5j5h8thDrYZMLZk13h0WysBTqrarCpLcROl7DYJji16ufczAnLiwpPseU4xuwe
         yMH3cIn5UfURg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Huy Nguyen <huyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 09/11] net/mlx5e: IPsec, Avoid unreachable return
Date:   Mon, 11 Jan 2021 23:05:32 -0800
Message-Id: <20210112070534.136841-10-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210112070534.136841-1-saeed@kernel.org>
References: <20210112070534.136841-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Simple code improvement, move default return operation under
the #else block.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Huy Nguyen <huyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 1fae7fab8297..6488098d2700 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -144,9 +144,9 @@ static inline bool mlx5e_accel_tx_is_ipsec_flow(struct mlx5e_accel_tx_state *sta
 {
 #ifdef CONFIG_MLX5_EN_IPSEC
 	return mlx5e_ipsec_is_tx_flow(&state->ipsec);
-#endif
-
+#else
 	return false;
+#endif
 }
 
 static inline unsigned int mlx5e_accel_tx_ids_len(struct mlx5e_txqsq *sq,
-- 
2.26.2

