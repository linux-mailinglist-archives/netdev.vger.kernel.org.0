Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65721417B46
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 20:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346885AbhIXSuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 14:50:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239329AbhIXStw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 14:49:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD57661278;
        Fri, 24 Sep 2021 18:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632509299;
        bh=d5ZqYaJG4nHoFIQFDHDv9wUBFTekpdzrqPG2AEeTWPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9AdO4SnkFOtH17CaCYNFoduqEhMWh+UOZVuMVRO2H73Cq0U109hORkDyeNnHit52
         aVMh3exea1rKubgwF6ACBK2LIU0PKfSoZJfBFZrU6ga6aF6rbcHErdvkzXrqGtkF4a
         kR3LU5hE/CQjMObolUqp6XxrjVSmeGT1jbo4hu2M8elidBH5SKF7cWZv9tRajHqKJR
         KHHPALVMKDxQsq+slre/4eoWxuX0oFyOXA702Zx/KX5Bc5HONBWWcI5U35RSCDIAYC
         UDJfsJuuy47Sr+GykqKZq3XIE3pPNsqHfUM9sE4g1Z5L4yHGraPDD/PC86a/TNSVtG
         8xa2LwKf9O1Hw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/12] net/mlx5e: Remove incorrect addition of action fwd flag
Date:   Fri, 24 Sep 2021 11:48:00 -0700
Message-Id: <20210924184808.796968-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924184808.796968-1-saeed@kernel.org>
References: <20210924184808.796968-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

A user is expected to explicit request a fwd or drop action.
It is not correct to implicit add a fwd action for the user,
when modify header action flag exists.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index f55fc8553664..d68c67b98d94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3491,9 +3491,6 @@ static int parse_tc_nic_actions(struct mlx5e_priv *priv,
 		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	}
 
-	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
-		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
-
 	if (!actions_match_supported(priv, flow_action, parse_attr, flow, extack))
 		return -EOPNOTSUPP;
 
-- 
2.31.1

