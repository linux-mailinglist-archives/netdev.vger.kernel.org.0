Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C713E9770
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 20:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbhHKSSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 14:18:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229847AbhHKSSg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 14:18:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 688926101D;
        Wed, 11 Aug 2021 18:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628705892;
        bh=BiN855KtI/R8hEJql+Tf9np2GssqNCPt2H4o2oOKfrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BjguM6n7hclxL/+AcLDBgqSJIO0HfoFji9JWAkukHYSn1pMYHP2jH4nzy/2IpKRhF
         PI4JCFqX2A+LrH5rf0Yuw72bAtXPkWVi39i36v+85OE4w2c0Nw+63T1ZB8N9zXdiHu
         kXc9O6PpBE4N21DE7o0XdJ9CeHsCxZUPFHfKO71QhojMuUbOQzN7F/SV2S87GB67No
         jAG9ly6aPoGX1XwZ2IWcYJV9+Vmc0Bb7Um2HcxPm8Z8BltSccvQhsnrTAgecMoy53B
         Sgaca5q/A9q8xxQSn6LT6cOi+cxYd6I80FtyUmUUmcvOAeDVdCQwG0bXifnDEaLB9v
         s5wPMw2VLgL4A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/12] net/mlx5: Fix inner TTC table creation
Date:   Wed, 11 Aug 2021 11:16:48 -0700
Message-Id: <20210811181658.492548-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210811181658.492548-1-saeed@kernel.org>
References: <20210811181658.492548-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Fix typo of the cited commit that calls to mlx5_create_ttc_table, instead
of mlx5_create_inner_ttc_table.

Fixes: f4b45940e9b9 ("net/mlx5: Embed mlx5_ttc_table")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 5c754e9af669..c06b4b938ae7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -1255,7 +1255,8 @@ static int mlx5e_create_inner_ttc_table(struct mlx5e_priv *priv)
 		return 0;
 
 	mlx5e_set_inner_ttc_params(priv, &ttc_params);
-	priv->fs.inner_ttc = mlx5_create_ttc_table(priv->mdev, &ttc_params);
+	priv->fs.inner_ttc = mlx5_create_inner_ttc_table(priv->mdev,
+							 &ttc_params);
 	if (IS_ERR(priv->fs.inner_ttc))
 		return PTR_ERR(priv->fs.inner_ttc);
 	return 0;
-- 
2.31.1

