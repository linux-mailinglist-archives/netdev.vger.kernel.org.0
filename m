Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32ECF466EDD
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 01:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344605AbhLCA75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 19:59:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245080AbhLCA7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 19:59:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A243DC06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 16:56:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D4BBB8259F
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 00:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96134C53FD2;
        Fri,  3 Dec 2021 00:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638492989;
        bh=vbIuiyA7CL7uXcn9wp2mBqhBI5gQpzQNOSuW/7mVG20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=chldEAtRULAvDmHdFWKkbs66uM6tTZ2qkRIo9ZBl3TsYcqRETppL9YIGnaOVn/6r2
         f8T3YbGKfTDjZkJt/0UOu5NeOK+FU1WfI21UJvna2zr02hqSWDOPTxQEI3jGVM5Gkx
         4PykXCcqOE8zWO+txN27m3QxSMnDwk9C0AtHydnngEhKJHhKGvL0WCVd5r34YruN+Z
         /BCoOuiL9eQyBJg34LorfwsGztbLCqT3ZXJsHB6F9uPnIiQ+RHvWdfYNKOBGhIsPcN
         Y+uhgPYnLjyVNFWKntTGiAUYpmPg1oHin6/nyP3ctBzAJZApP914hgHV9CHrvjrLX8
         g+ZF7QHIHyqTQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 08/14] net/mlx5e: Hide function mlx5e_num_channels_changed
Date:   Thu,  2 Dec 2021 16:56:16 -0800
Message-Id: <20211203005622.183325-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211203005622.183325-1-saeed@kernel.org>
References: <20211203005622.183325-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

No calls for mlx5e_num_channels_changed() out of en_main.c,
turn it static and remove from header.
Keep the wrapper function mlx5e_num_channels_changed_ctx exposed.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 1834efa64c1d..e77c4159713f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1057,7 +1057,6 @@ int mlx5e_safe_switch_params(struct mlx5e_priv *priv,
 			     mlx5e_fp_preactivate preactivate,
 			     void *context, bool reset);
 int mlx5e_update_tx_netdev_queues(struct mlx5e_priv *priv);
-int mlx5e_num_channels_changed(struct mlx5e_priv *priv);
 int mlx5e_num_channels_changed_ctx(struct mlx5e_priv *priv, void *context);
 void mlx5e_activate_priv_channels(struct mlx5e_priv *priv);
 void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 65571593ec5c..496977e7406e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2598,7 +2598,7 @@ static void mlx5e_set_default_xps_cpumasks(struct mlx5e_priv *priv,
 	}
 }
 
-int mlx5e_num_channels_changed(struct mlx5e_priv *priv)
+static int mlx5e_num_channels_changed(struct mlx5e_priv *priv)
 {
 	u16 count = priv->channels.params.num_channels;
 	int err;
-- 
2.31.1

