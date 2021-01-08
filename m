Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50DFD2EED11
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 06:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbhAHFcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 00:32:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:35874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727714AbhAHFcT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 00:32:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5429523716;
        Fri,  8 Jan 2021 05:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610083862;
        bh=RLY82qF651aA8yYnWKLwQFuD9i1A3WESheA1hYF1+2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qj/tuy/GD/3VPID8FXolc0wzNE9l1iOoFBgkpJTKYQNCla8qcvNxw8a1DpVkNnbmJ
         GKj15p6/EwqeJiYZ4GcDfu4Mt4ns64DIxsbqylNRefGRKlhHA+da7vXDQ5rQ84J6Fz
         jTIM+4ODCTJBTfEmhMU+BaFcDzmkeD5tvfK4sMZ0cYho5kbO0PNYQSydz4Y0ghmhHj
         PvEV7yMcHfmdbZ/987fUf/S/jjQd3HcBTXL8yiAWDj38qKRGpmf5rWyw3G+pd1w1ym
         mBev1wsJuszlPAeAba0m/vggrVrOw8P6lxWLdKkamEwBxxPFz/me0a7h6eO3ZyEKC1
         iUtlAiB3IgBEA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Huy Nguyen <huyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/15] net/mlx5e: IPsec, Avoid unreachable return
Date:   Thu,  7 Jan 2021 21:30:52 -0800
Message-Id: <20210108053054.660499-14-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210108053054.660499-1-saeed@kernel.org>
References: <20210108053054.660499-1-saeed@kernel.org>
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
index 899b98aca0d3..fb89b24deb2b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -142,9 +142,9 @@ static inline bool mlx5e_accel_tx_is_ipsec_flow(struct mlx5e_accel_tx_state *sta
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

