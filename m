Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA26030B833
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 08:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbhBBG64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 01:58:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:50148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232285AbhBBG4e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 01:56:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0A7F64EED;
        Tue,  2 Feb 2021 06:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612248920;
        bh=FMeYCNWXU022BQExeUWC4TDVVSXvKS/Lj0aBudnOhk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jbqkAX+d7vqMpvepSm8AJ1sx31ygAS7zUZDeTZBl6rk5qCiBMyeiMoQcm7VanDsln
         6BaQANStSUWdTB+7Lvtmia9S86KTbdDBgZVCXARD5lFc//1OIKKMUWIPtNXmry+YV8
         ntwsupCZMgBJyq6L3s5yb8jeoI7Fbt/nrQ4088Og6IYO/TqXsDV1j3WUcWQKvCX8KI
         KwtDbE5lmsKXtCLd/2nSO0xxVJn2ACKYXYcLVChnZEBT7+gYhnoXk6Km2lvNF5S+hN
         V1gaVv7BXVL/0VdrI/G6hjkJgXZH8qFXjWgJJym5vu7SZbYVCp6YRGHjXXYKWy5gj5
         J6YZK+HsDM4yQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tom Rix <trix@redhat.com>, Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/14] net/mlx5e: remove h from printk format specifier
Date:   Mon,  1 Feb 2021 22:54:53 -0800
Message-Id: <20210202065457.613312-11-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202065457.613312-1-saeed@kernel.org>
References: <20210202065457.613312-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

This change fixes the checkpatch warning described in this commit
commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use of unnecessary %h[xudi] and %hh[xudi]")

Standard integer promotion is already done and %hx and %hhx is useless
so do not encourage the use of %hh[xudi] or %h[xudi].

Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
index 43271a3856ca..36381a2ed5a5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -179,7 +179,7 @@ int mlx5e_validate_params(struct mlx5e_priv *priv, struct mlx5e_params *params)
 
 	stop_room = mlx5e_calc_sq_stop_room(priv->mdev, params);
 	if (stop_room >= sq_size) {
-		netdev_err(priv->netdev, "Stop room %hu is bigger than the SQ size %zu\n",
+		netdev_err(priv->netdev, "Stop room %u is bigger than the SQ size %zu\n",
 			   stop_room, sq_size);
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 41c611197211..2a6f9d042f51 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3888,7 +3888,7 @@ static int set_feature_lro(struct net_device *netdev, bool enable)
 	mutex_lock(&priv->state_lock);
 
 	if (enable && priv->xsk.refcnt) {
-		netdev_warn(netdev, "LRO is incompatible with AF_XDP (%hu XSKs are active)\n",
+		netdev_warn(netdev, "LRO is incompatible with AF_XDP (%u XSKs are active)\n",
 			    priv->xsk.refcnt);
 		err = -EINVAL;
 		goto out;
@@ -4139,7 +4139,7 @@ static bool mlx5e_xsk_validate_mtu(struct net_device *netdev,
 			max_mtu_page = mlx5e_xdp_max_mtu(new_params, &xsk);
 			max_mtu = min(max_mtu_frame, max_mtu_page);
 
-			netdev_err(netdev, "MTU %d is too big for an XSK running on channel %hu. Try MTU <= %d\n",
+			netdev_err(netdev, "MTU %d is too big for an XSK running on channel %u. Try MTU <= %d\n",
 				   new_params->sw_mtu, ix, max_mtu);
 			return false;
 		}
-- 
2.29.2

