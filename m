Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04DC2EED0E
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 06:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbhAHFcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 00:32:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727145AbhAHFcR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 00:32:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77415235FA;
        Fri,  8 Jan 2021 05:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610083859;
        bh=eG6R1DIS9cGxxRKoIEcaWliWd3ODZo8VQnU1QivRPAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oIp73Xo4rkvv9JF2w2lWE5Yf0nItFdAn0tJVK82u4cE/aA6beJSwV02aJSX4XyeVP
         RhxNoDifPe0RSPLxU1AJr0a/X1LpoRdcMV0xXGuZ4n+9+bq1ON8bIMXTO1H7eIM6YL
         z5CGuAAMWVJINKlIJeFtgRapIMDwWopKwdQRl9MRjHruOazywBdSJTPhJEMsDRWUdP
         QkWTuHYEssBVhRxGUJNBNbpV7MmvnfxYaD34Yn+u3wRJfeb+3cOFG29vKqJM0lFJct
         eIbbNgSRHjq3+yWlpTWK0D4dCGk3HjtH9BQJw1UYFT9lU6iH7BWoVExT+S6vYNAQ6m
         T2/0lkrmqzmxg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/15] net/mlx5e: CT: Remove redundant usage of zone mask
Date:   Thu,  7 Jan 2021 21:30:46 -0800
Message-Id: <20210108053054.660499-8-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210108053054.660499-1-saeed@kernel.org>
References: <20210108053054.660499-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

The zone member is of type u16 so there is no reason to apply
the zone mask on it. This is also matching the call to set a
match in other places which don't need and don't apply the mask.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index a0b193181ba5..d7ecd5e5f7c4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -703,9 +703,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	attr->flags |= MLX5_ESW_ATTR_FLAG_NO_IN_PORT;
 
 	mlx5_tc_ct_set_tuple_match(netdev_priv(ct_priv->netdev), spec, flow_rule);
-	mlx5e_tc_match_to_reg_match(spec, ZONE_TO_REG,
-				    entry->tuple.zone & MLX5_CT_ZONE_MASK,
-				    MLX5_CT_ZONE_MASK);
+	mlx5e_tc_match_to_reg_match(spec, ZONE_TO_REG, entry->tuple.zone, MLX5_CT_ZONE_MASK);
 
 	zone_rule->rule = mlx5_tc_rule_insert(priv, spec, attr);
 	if (IS_ERR(zone_rule->rule)) {
-- 
2.26.2

