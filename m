Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1099C43C004
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 04:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238575AbhJ0ChX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 22:37:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238486AbhJ0ChM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 22:37:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEDD160F0F;
        Wed, 27 Oct 2021 02:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635302088;
        bh=mUSGjxDezfx9Yq2YcicOk36TCwonsBiMZX9BuD5jLIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YwqaGg31QK7pQksPlJqyfZbK2BvvP6bCWYIytiT+0t2vGHllSwiTS59lgKw0kLhDl
         wsr2MmkG5kWR3qERMVyU57yxae8Ga184jKWe0c2y37kvBgaSeR9y7wHiV1py6hiV7o
         81BEhle9QajowVR1qz6VNr9yZ298DecoqEPNk1Otav9K8hKqryXnkIycF7OjMzDu0R
         nAXMPQ2uTV7VLhmyISXHblN2S4JfbeIO0ESW3+zpfIZWcmfrdQDuAzv7yphKdoaMEL
         EyTE/ZgF4cfyb/9kyFanjZtFevIWk/8n/1oTjc1aOMzLgQFcxF64vWCdGpxlvhDlkU
         qFMtVI1hV7zig==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/14] net/mlx5: Lag, Make mlx5_lag_is_multipath() be static inline
Date:   Tue, 26 Oct 2021 19:33:47 -0700
Message-Id: <20211027023347.699076-15-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211027023347.699076-1-saeed@kernel.org>
References: <20211027023347.699076-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

Fix "no previous prototype" W=1 warnings when CONFIG_MLX5_CORE_EN is not set:

  drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h:34:6: error: no previous prototype for ‘mlx5_lag_is_multipath’ [-Werror=missing-prototypes]
     34 | bool mlx5_lag_is_multipath(struct mlx5_core_dev *dev) { return false; }
        |      ^~~~~~~~~~~~~~~~~~~~~

Fixes: 14fe2471c628 ("net/mlx5: Lag, change multipath and bonding to be mutually exclusive")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.h
index dea199e79bed..57af962cad29 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/mp.h
@@ -31,7 +31,7 @@ bool mlx5_lag_is_multipath(struct mlx5_core_dev *dev);
 static inline void mlx5_lag_mp_reset(struct mlx5_lag *ldev) {};
 static inline int mlx5_lag_mp_init(struct mlx5_lag *ldev) { return 0; }
 static inline void mlx5_lag_mp_cleanup(struct mlx5_lag *ldev) {}
-bool mlx5_lag_is_multipath(struct mlx5_core_dev *dev) { return false; }
+static inline bool mlx5_lag_is_multipath(struct mlx5_core_dev *dev) { return false; }
 
 #endif /* CONFIG_MLX5_ESWITCH */
 #endif /* __MLX5_LAG_MP_H__ */
-- 
2.31.1

