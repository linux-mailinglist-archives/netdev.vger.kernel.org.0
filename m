Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE1BD2F28C6
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391955AbhALHPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 02:15:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:37668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391911AbhALHPE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 02:15:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F102022CAD;
        Tue, 12 Jan 2021 07:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610435627;
        bh=nIUc+HFf+UVM6UfIHdNs2NUCY5Z6eliRTtSTHmYyE54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mLnK2Y5eVkbtuxbvdNw+WjFXe+JqiZ4vsY1LA0QeYOReq/ugzOSm6qqAFOjDPWFrO
         bNs9XDHgmJlQiD9AGRFgY+sfkCCNk1KsMfqLVr81lVZJgPLemHEcAhy0jGd7avY6bK
         ZXAmTBcZwNkRoZsuGL+61mGkHc9MAAf0PQ0cH2urwRlSDs7wvilrccGuSG/AuAX4kk
         dg0tHv9qkDiwvkBvd0mvnrjPTCd/XdWjcd8yPu2SnJAN8kaGrjcI5RKUWdAaL++0UQ
         drLNZ7SV386uijBOlImyI7O4quRgR/LGLlFntuRmA0Zzs5W7aoXT8XZ8+6zySYy+h4
         iYFpCH527CvzQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 07/11] net/mlx5e: CT: Remove redundant usage of zone mask
Date:   Mon, 11 Jan 2021 23:05:30 -0800
Message-Id: <20210112070534.136841-8-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210112070534.136841-1-saeed@kernel.org>
References: <20210112070534.136841-1-saeed@kernel.org>
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
index 97bfc42e3913..e20c1da95a33 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -705,9 +705,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
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

