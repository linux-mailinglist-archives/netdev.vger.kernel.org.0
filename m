Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36BC3DE467
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 04:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbhHCC3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 22:29:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:59086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233769AbhHCC3U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 22:29:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1A21610A2;
        Tue,  3 Aug 2021 02:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627957746;
        bh=Rp/gFsnEkqzoyS58loewmelE0QntFJqyP1+lHb2xeh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PeEKuegyGK67D1G7KaqqY1qOif189UJKR7gNDuBik+sulpJGL1LkC/acrst0FkIKA
         cVjUx6tJQoxLOugWY24sUZcmdPq6h53266biF++7xZ4EFQt+vXGKAzw4Lsty0DiMTq
         g5Ph3C8SPTIVIJMvRJnXljdSY0btbQ4fGsznT8HGS00OXfiu5WZ/HdxXcsZYrqxqrO
         Dz9OT3JnbY167W1rOiwAsBQNF1msnM0KnTYlvJsVCL5DnsamePulY4NBr0MZz8MtQZ
         EB2zIxL8XU4w0gTZ7g0/YptWpu21qLSRC+jzeCMklUg0qoEAG2n7Jk1z3aXFpDRKBU
         YBRDGqs/qEvNQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/16] net/mlx5e: Remove redundant assignment of counter to null
Date:   Mon,  2 Aug 2021 19:28:51 -0700
Message-Id: <20210803022853.106973-15-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803022853.106973-1-saeed@kernel.org>
References: <20210803022853.106973-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

counter is being initialized before being used.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 472c0c756a69..980a668bbc3c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1037,7 +1037,7 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr = flow->attr;
 	struct mlx5_core_dev *dev = priv->mdev;
-	struct mlx5_fc *counter = NULL;
+	struct mlx5_fc *counter;
 	int err;
 
 	parse_attr = attr->parse_attr;
@@ -1361,9 +1361,9 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	bool vf_tun = false, encap_valid = true;
 	struct net_device *encap_dev = NULL;
 	struct mlx5_esw_flow_attr *esw_attr;
-	struct mlx5_fc *counter = NULL;
 	struct mlx5e_rep_priv *rpriv;
 	struct mlx5e_priv *out_priv;
+	struct mlx5_fc *counter;
 	u32 max_prio, max_chain;
 	int err = 0;
 	int out_index;
-- 
2.31.1

