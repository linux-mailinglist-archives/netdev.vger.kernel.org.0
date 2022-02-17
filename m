Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1084B9A3D
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 08:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236903AbiBQH5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 02:57:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236825AbiBQH51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 02:57:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB39DF58
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 23:56:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABB9DB8215F
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 07:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE8E0C340ED;
        Thu, 17 Feb 2022 07:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645084601;
        bh=cCt7O8SLELzLLU7zbPlJ48WdRznoZHtOw3/AKLFvd0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b3dZWRm3HLqpSFvYTYsuRQ8N9rtIil3mILfjAeL4uI0lRjoGQOIxA7sN7v+YBl9YI
         VE7SxYMSc3yjy9mDDTaFnBhimDzvCg05R2ZhQREtesuf2oKfMwihHp6aZFHans1niN
         CiscLstr57lfptx5S8zeBx82xzIvXrf6NkbPFlrXVMI85nL9hFpdgK91RfYMQ/VrrC
         VOa1PjKSWYIWtEfLAS1VInHvYuIGTjgosnzNx+ZV0o9FeJudnDbJyymI5ziR6/lFYQ
         mbHi0tx3HiCHBeNhjKxspRluWdF4wsPzkZfZigcKDRHR1bocvtcxF/xtXljgEavmTg
         xH7+RKlvYGseA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/15] net/mlx5e: TC, Clean redundant counter flag from tc action parsers
Date:   Wed, 16 Feb 2022 23:56:30 -0800
Message-Id: <20220217075632.831542-14-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217075632.831542-1-saeed@kernel.org>
References: <20220217075632.831542-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

When tc actions being parsed only the last flow attr created needs the
counter flag and the previous flags being reset.
Clean the flag from the tc action parsers.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c     | 3 +--
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c       | 3 +--
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c       | 3 +--
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c     | 3 +--
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred_nic.c | 3 +--
 .../ethernet/mellanox/mlx5/core/en/tc/act/redirect_ingress.c   | 3 +--
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c       | 3 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c                | 1 -
 8 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c
index 2b53738938a9..21aab96357b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c
@@ -19,8 +19,7 @@ tc_act_parse_accept(struct mlx5e_tc_act_parse_state *parse_state,
 		    struct mlx5e_priv *priv,
 		    struct mlx5_flow_attr *attr)
 {
-	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-			MLX5_FLOW_CONTEXT_ACTION_COUNT;
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	attr->flags |= MLX5_ATTR_FLAG_ACCEPT;
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c
index 3d5f23636a02..dd025a95c439 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c
@@ -19,8 +19,7 @@ tc_act_parse_drop(struct mlx5e_tc_act_parse_state *parse_state,
 		  struct mlx5e_priv *priv,
 		  struct mlx5_flow_attr *attr)
 {
-	attr->action |= MLX5_FLOW_CONTEXT_ACTION_DROP |
-			MLX5_FLOW_CONTEXT_ACTION_COUNT;
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c
index fb1be822ad25..4726bcb46eec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c
@@ -76,8 +76,7 @@ tc_act_parse_goto(struct mlx5e_tc_act_parse_state *parse_state,
 		  struct mlx5e_priv *priv,
 		  struct mlx5_flow_attr *attr)
 {
-	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-			MLX5_FLOW_CONTEXT_ACTION_COUNT;
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	attr->dest_chain = act->chain_index;
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
index 99fb98b3e71b..d08abec93704 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
@@ -296,8 +296,7 @@ tc_act_parse_mirred(struct mlx5e_tc_act_parse_state *parse_state,
 	if (err)
 		return err;
 
-	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-			MLX5_FLOW_CONTEXT_ACTION_COUNT;
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred_nic.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred_nic.c
index 16681cf6e93e..90b4c1b34776 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred_nic.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred_nic.c
@@ -40,8 +40,7 @@ tc_act_parse_mirred_nic(struct mlx5e_tc_act_parse_state *parse_state,
 {
 	attr->parse_attr->mirred_ifindex[0] = act->dev->ifindex;
 	flow_flag_set(parse_state->flow, HAIRPIN);
-	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-			MLX5_FLOW_CONTEXT_ACTION_COUNT;
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/redirect_ingress.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/redirect_ingress.c
index 9dd244147385..ad09a8a5f36e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/redirect_ingress.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/redirect_ingress.c
@@ -58,8 +58,7 @@ tc_act_parse_redirect_ingress(struct mlx5e_tc_act_parse_state *parse_state,
 	struct net_device *out_dev = act->dev;
 	int err;
 
-	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-			MLX5_FLOW_CONTEXT_ACTION_COUNT;
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 
 	err = mlx5e_set_fwd_to_int_port_actions(priv, attr, out_dev->ifindex,
 						MLX5E_TC_INT_PORT_INGRESS,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c
index 9ea293fdc434..a7d9eab19e4a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c
@@ -26,8 +26,7 @@ tc_act_parse_trap(struct mlx5e_tc_act_parse_state *parse_state,
 		  struct mlx5e_priv *priv,
 		  struct mlx5_flow_attr *attr)
 {
-	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-			MLX5_FLOW_CONTEXT_ACTION_COUNT;
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	attr->flags |= MLX5_ATTR_FLAG_SLOW_PATH;
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index b9d6a2e8b240..76a015dfc5fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3536,7 +3536,6 @@ alloc_flow_post_acts(struct mlx5e_tc_flow *flow, struct netlink_ext_ack *extack)
 			/* Set counter action on last post act rule. */
 			attr->action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
 		} else {
-			attr->action &= ~MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			err = mlx5e_tc_act_set_next_post_act(flow, attr, next_attr);
 			if (err)
 				goto out_free;
-- 
2.34.1

