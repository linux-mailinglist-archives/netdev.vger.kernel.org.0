Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1A3417B49
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 20:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347158AbhIXSuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 14:50:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242199AbhIXStx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 14:49:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C89561267;
        Fri, 24 Sep 2021 18:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632509300;
        bh=E8zHWl4Iqya/6sI3qRN3iskOXXDCAytcPn7PHr2uG1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3X3tSb+8CEuZdKww2vPkcuVZvTA1YHNKGWcGZ2TLWdxOz0nyEMqNv/uMEl49crz+
         YhfBi0Z/4t9TXAgGo4YSrgRKzi8eZVXgw920d7QfiJLsJ9pJ5HYMFtyLUCJh95WspA
         vxK8A6c++uufhPYJdT2KP5uak/aJtj1SWKgFNVWeji4YxCAI/bH5HyPR4XqfbeQ2Mk
         K5RcfIl50bJmHemtYyFOzmPvPl17eNdXXavD2cZtFPdTJ+5Eb7KNrcG/6/RCmmgHfA
         p5gH+HfRpDFayowHzJgmMRcYFV5T2rqEDtRmYHy46KEJWgVHwmPqm/ztEKaGNf0230
         wEtJiXFxDUwyQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/12] net/mlx5e: Remove redundant priv arg from parse_pedit_to_reformat()
Date:   Fri, 24 Sep 2021 11:48:03 -0700
Message-Id: <20210924184808.796968-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210924184808.796968-1-saeed@kernel.org>
References: <20210924184808.796968-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

The priv argument is not being used. remove it.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index c86fc59c645f..0664ff77c5a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2910,8 +2910,7 @@ parse_pedit_to_modify_hdr(struct mlx5e_priv *priv,
 }
 
 static int
-parse_pedit_to_reformat(struct mlx5e_priv *priv,
-			const struct flow_action_entry *act,
+parse_pedit_to_reformat(const struct flow_action_entry *act,
 			struct mlx5e_tc_flow_parse_attr *parse_attr,
 			struct netlink_ext_ack *extack)
 {
@@ -2943,7 +2942,7 @@ static int parse_tc_pedit_action(struct mlx5e_priv *priv,
 				 struct netlink_ext_ack *extack)
 {
 	if (flow && flow_flag_test(flow, L3_TO_L2_DECAP))
-		return parse_pedit_to_reformat(priv, act, parse_attr, extack);
+		return parse_pedit_to_reformat(act, parse_attr, extack);
 
 	return parse_pedit_to_modify_hdr(priv, act, namespace,
 					 parse_attr, hdrs, extack);
-- 
2.31.1

