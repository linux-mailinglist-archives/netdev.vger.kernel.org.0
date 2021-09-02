Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3863FF3CE
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 21:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347350AbhIBTHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 15:07:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347310AbhIBTHF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 15:07:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7710D610C8;
        Thu,  2 Sep 2021 19:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630609566;
        bh=d5ZqYaJG4nHoFIQFDHDv9wUBFTekpdzrqPG2AEeTWPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RelxqEZWiR8wWbK5a1Z0ypCdQ9rFxOEEDBKBCimHRVsr1UG6sJ4VVCwoEbSWRR0Oi
         y1+05dbEHhE5HkvTWp6hlwqhylWu0JIwIOdg8Jl3g9uLOe2NFBHHawWy4ttXeWFP0n
         B6mhvEVRR5UKtYwwtGylDmO0XEj9fHDyKWZ0HwVDEUXDOGE8d0QWG3SwV40pu1YEgU
         WiHCIcHLpXUX4BNqPALvUX1h8sLlMjwytly8OtrJ/uG1ASzNFxXwGPRpDw98RpDFXa
         sHhFCaHk1JpN0bFVWszZAoW+sCgDSFSwlsLNQisOvqPvJkmgjULhd34RD007Vuw3qJ
         yqEZph1yCyntg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/15] net/mlx5e: Remove incorrect addition of action fwd flag
Date:   Thu,  2 Sep 2021 12:05:44 -0700
Message-Id: <20210902190554.211497-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902190554.211497-1-saeed@kernel.org>
References: <20210902190554.211497-1-saeed@kernel.org>
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

