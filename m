Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D57948A537
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346249AbiAKBnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345998AbiAKBnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:43:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36580C06173F
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 17:43:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A2CD61499
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 01:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B777C36AE5;
        Tue, 11 Jan 2022 01:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641865429;
        bh=cApz8STkTtwA6gL2B6CCiyVU0g3P8YofAc3IrQspYDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r+OvBEJ8m8TFDFe4pwK2Ay+QodiOINLnNNBa0MfOLNckJZJTiochYQKo5PhK+5OmE
         8pVJY/2mENP6C4czgQUzCynXlqZCqgMtD6K89xMx+UwrKnSdQCkzUQv9G1KvJibZww
         ITX4N4mqXSaIpMhbREOYJeprpe80zYmMp3XeqvDPndjNed5Klsfr5qjfJEc+yDTfBm
         b953kJ+LJmPDOZLNloch4aThs/wddvnvgB+SvJAG2EIODL2oVTRgmeSlgDKUDTrLFS
         qEHKE/V/YZnqoJhrNsS7I2tOTCTT4+HpBx8v7hktNKDPbyK5Hrb7YTnWoOBLMxlA3t
         bGkRTRzFdwkzg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/17] net/mlx5e: TC, Pass attr to tc_act can_offload()
Date:   Mon, 10 Jan 2022 17:43:25 -0800
Message-Id: <20220111014335.178121-8-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111014335.178121-1-saeed@kernel.org>
References: <20220111014335.178121-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

In later commit we are going to instantiate multiple attr instances
for flow instead of single attr.
Make sure the parsing using correct attr and not flow->attr.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc/act/accept.c   |  3 ++-
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/act.h  |  3 ++-
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/csum.c |  5 +++--
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c   |  3 ++-
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c |  3 ++-
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c | 12 +++++++-----
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/mark.c |  3 ++-
 .../ethernet/mellanox/mlx5/core/en/tc/act/mirred.c   |  7 ++++---
 .../mellanox/mlx5/core/en/tc/act/mirred_nic.c        |  3 ++-
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/mpls.c |  9 +++++----
 .../ethernet/mellanox/mlx5/core/en/tc/act/pedit.c    |  3 ++-
 .../ethernet/mellanox/mlx5/core/en/tc/act/ptype.c    |  3 ++-
 .../mellanox/mlx5/core/en/tc/act/redirect_ingress.c  |  8 ++++----
 .../ethernet/mellanox/mlx5/core/en/tc/act/sample.c   |  3 ++-
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c |  3 ++-
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/tun.c  |  6 ++++--
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c |  3 ++-
 .../mellanox/mlx5/core/en/tc/act/vlan_mangle.c       |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c      |  4 ++--
 19 files changed, 53 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c
index b0de6b999675..84c1e8719d34 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c
@@ -7,7 +7,8 @@
 static bool
 tc_act_can_offload_accept(struct mlx5e_tc_act_parse_state *parse_state,
 			  const struct flow_action_entry *act,
-			  int act_index)
+			  int act_index,
+			  struct mlx5_flow_attr *attr)
 {
 	return true;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
index 48c06a20aecf..04734e59bbc4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
@@ -29,7 +29,8 @@ struct mlx5e_tc_act_parse_state {
 struct mlx5e_tc_act {
 	bool (*can_offload)(struct mlx5e_tc_act_parse_state *parse_state,
 			    const struct flow_action_entry *act,
-			    int act_index);
+			    int act_index,
+			    struct mlx5_flow_attr *attr);
 
 	int (*parse_action)(struct mlx5e_tc_act_parse_state *parse_state,
 			    const struct flow_action_entry *act,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/csum.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/csum.c
index 29920ef0180a..c0f08ae6a57f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/csum.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/csum.c
@@ -38,11 +38,12 @@ csum_offload_supported(struct mlx5e_priv *priv,
 static bool
 tc_act_can_offload_csum(struct mlx5e_tc_act_parse_state *parse_state,
 			const struct flow_action_entry *act,
-			int act_index)
+			int act_index,
+			struct mlx5_flow_attr *attr)
 {
 	struct mlx5e_tc_flow *flow = parse_state->flow;
 
-	return csum_offload_supported(flow->priv, flow->attr->action,
+	return csum_offload_supported(flow->priv, attr->action,
 				      act->csum_flags, parse_state->extack);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
index 06ec30cdb269..0d08cc35ea6f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
@@ -8,7 +8,8 @@
 static bool
 tc_act_can_offload_ct(struct mlx5e_tc_act_parse_state *parse_state,
 		      const struct flow_action_entry *act,
-		      int act_index)
+		      int act_index,
+		      struct mlx5_flow_attr *attr)
 {
 	struct netlink_ext_ack *extack = parse_state->extack;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c
index 2e29a23bed12..3d5f23636a02 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c
@@ -7,7 +7,8 @@
 static bool
 tc_act_can_offload_drop(struct mlx5e_tc_act_parse_state *parse_state,
 			const struct flow_action_entry *act,
-			int act_index)
+			int act_index,
+			struct mlx5_flow_attr *attr)
 {
 	return true;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c
index f44515061228..fb1be822ad25 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c
@@ -8,6 +8,7 @@
 static int
 validate_goto_chain(struct mlx5e_priv *priv,
 		    struct mlx5e_tc_flow *flow,
+		    struct mlx5_flow_attr *attr,
 		    const struct flow_action_entry *act,
 		    struct netlink_ext_ack *extack)
 {
@@ -32,7 +33,7 @@ validate_goto_chain(struct mlx5e_priv *priv,
 	}
 
 	if (!mlx5_chains_backwards_supported(chains) &&
-	    dest_chain <= flow->attr->chain) {
+	    dest_chain <= attr->chain) {
 		NL_SET_ERR_MSG_MOD(extack, "Goto lower numbered chain isn't supported");
 		return -EOPNOTSUPP;
 	}
@@ -43,8 +44,8 @@ validate_goto_chain(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
-	if (flow->attr->action & (MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT |
-				  MLX5_FLOW_CONTEXT_ACTION_DECAP) &&
+	if (attr->action & (MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT |
+			    MLX5_FLOW_CONTEXT_ACTION_DECAP) &&
 	    !reformat_and_fwd) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Goto chain is not allowed if action has reformat or decap");
@@ -57,12 +58,13 @@ validate_goto_chain(struct mlx5e_priv *priv,
 static bool
 tc_act_can_offload_goto(struct mlx5e_tc_act_parse_state *parse_state,
 			const struct flow_action_entry *act,
-			int act_index)
+			int act_index,
+			struct mlx5_flow_attr *attr)
 {
 	struct netlink_ext_ack *extack = parse_state->extack;
 	struct mlx5e_tc_flow *flow = parse_state->flow;
 
-	if (validate_goto_chain(flow->priv, flow, act, extack))
+	if (validate_goto_chain(flow->priv, flow, attr, act, extack))
 		return false;
 
 	return true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mark.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mark.c
index d775c3d9edf3..e8d227595b3e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mark.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mark.c
@@ -7,7 +7,8 @@
 static bool
 tc_act_can_offload_mark(struct mlx5e_tc_act_parse_state *parse_state,
 			const struct flow_action_entry *act,
-			int act_index)
+			int act_index,
+			struct mlx5_flow_attr *attr)
 {
 	if (act->mark & ~MLX5E_TC_FLOW_ID_MASK) {
 		NL_SET_ERR_MSG_MOD(parse_state->extack, "Bad flow mark, only 16 bit supported");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
index c614fc7fdc9c..99fb98b3e71b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
@@ -99,7 +99,8 @@ get_fdb_out_dev(struct net_device *uplink_dev, struct net_device *out_dev)
 static bool
 tc_act_can_offload_mirred(struct mlx5e_tc_act_parse_state *parse_state,
 			  const struct flow_action_entry *act,
-			  int act_index)
+			  int act_index,
+			  struct mlx5_flow_attr *attr)
 {
 	struct netlink_ext_ack *extack = parse_state->extack;
 	struct mlx5e_tc_flow *flow = parse_state->flow;
@@ -108,8 +109,8 @@ tc_act_can_offload_mirred(struct mlx5e_tc_act_parse_state *parse_state,
 	struct mlx5e_priv *priv = flow->priv;
 	struct mlx5_esw_flow_attr *esw_attr;
 
-	parse_attr = flow->attr->parse_attr;
-	esw_attr = flow->attr->esw_attr;
+	parse_attr = attr->parse_attr;
+	esw_attr = attr->esw_attr;
 
 	if (!out_dev) {
 		/* out_dev is NULL when filters with
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred_nic.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred_nic.c
index 2c74567b6d25..16681cf6e93e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred_nic.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred_nic.c
@@ -7,7 +7,8 @@
 static bool
 tc_act_can_offload_mirred_nic(struct mlx5e_tc_act_parse_state *parse_state,
 			      const struct flow_action_entry *act,
-			      int act_index)
+			      int act_index,
+			      struct mlx5_flow_attr *attr)
 {
 	struct netlink_ext_ack *extack = parse_state->extack;
 	struct mlx5e_tc_flow *flow = parse_state->flow;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mpls.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mpls.c
index 784fc4f68b1e..40332949509a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mpls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mpls.c
@@ -8,7 +8,8 @@
 static bool
 tc_act_can_offload_mpls_push(struct mlx5e_tc_act_parse_state *parse_state,
 			     const struct flow_action_entry *act,
-			     int act_index)
+			     int act_index,
+			     struct mlx5_flow_attr *attr)
 {
 	struct netlink_ext_ack *extack = parse_state->extack;
 	struct mlx5e_priv *priv = parse_state->flow->priv;
@@ -36,13 +37,13 @@ tc_act_parse_mpls_push(struct mlx5e_tc_act_parse_state *parse_state,
 static bool
 tc_act_can_offload_mpls_pop(struct mlx5e_tc_act_parse_state *parse_state,
 			    const struct flow_action_entry *act,
-			    int act_index)
+			    int act_index,
+			    struct mlx5_flow_attr *attr)
 {
 	struct netlink_ext_ack *extack = parse_state->extack;
-	struct mlx5e_tc_flow *flow = parse_state->flow;
 	struct net_device *filter_dev;
 
-	filter_dev = flow->attr->parse_attr->filter_dev;
+	filter_dev = attr->parse_attr->filter_dev;
 
 	/* we only support mpls pop if it is the first action
 	 * and the filter net device is bareudp. Subsequent
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.c
index a70460c1b98d..39f8f71bed9e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.c
@@ -122,7 +122,8 @@ mlx5e_tc_act_pedit_parse_action(struct mlx5e_priv *priv,
 static bool
 tc_act_can_offload_pedit(struct mlx5e_tc_act_parse_state *parse_state,
 			 const struct flow_action_entry *act,
-			 int act_index)
+			 int act_index,
+			 struct mlx5_flow_attr *attr)
 {
 	return true;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ptype.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ptype.c
index 0819110193dc..6454b031ff7a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ptype.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ptype.c
@@ -7,7 +7,8 @@
 static bool
 tc_act_can_offload_ptype(struct mlx5e_tc_act_parse_state *parse_state,
 			 const struct flow_action_entry *act,
-			 int act_index)
+			 int act_index,
+			 struct mlx5_flow_attr *attr)
 {
 	return true;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/redirect_ingress.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/redirect_ingress.c
index 1c32e24e528d..9dd244147385 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/redirect_ingress.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/redirect_ingress.c
@@ -7,16 +7,16 @@
 static bool
 tc_act_can_offload_redirect_ingress(struct mlx5e_tc_act_parse_state *parse_state,
 				    const struct flow_action_entry *act,
-				    int act_index)
+				    int act_index,
+				    struct mlx5_flow_attr *attr)
 {
 	struct netlink_ext_ack *extack = parse_state->extack;
-	struct mlx5e_tc_flow *flow = parse_state->flow;
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct net_device *out_dev = act->dev;
 	struct mlx5_esw_flow_attr *esw_attr;
 
-	parse_attr = flow->attr->parse_attr;
-	esw_attr = flow->attr->esw_attr;
+	parse_attr = attr->parse_attr;
+	esw_attr = attr->esw_attr;
 
 	if (!out_dev)
 		return false;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
index 6699bdf5cf01..0d71e97f4eb9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
@@ -8,7 +8,8 @@
 static bool
 tc_act_can_offload_sample(struct mlx5e_tc_act_parse_state *parse_state,
 			  const struct flow_action_entry *act,
-			  int act_index)
+			  int act_index,
+			  struct mlx5_flow_attr *attr)
 {
 	struct netlink_ext_ack *extack = parse_state->extack;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c
index 046b64c2cec4..72811e0430c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c
@@ -7,7 +7,8 @@
 static bool
 tc_act_can_offload_trap(struct mlx5e_tc_act_parse_state *parse_state,
 			const struct flow_action_entry *act,
-			int act_index)
+			int act_index,
+			struct mlx5_flow_attr *attr)
 {
 	struct netlink_ext_ack *extack = parse_state->extack;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/tun.c
index 6f4a2cf46afd..b4fa2de9711d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/tun.c
@@ -8,7 +8,8 @@
 static bool
 tc_act_can_offload_tun_encap(struct mlx5e_tc_act_parse_state *parse_state,
 			     const struct flow_action_entry *act,
-			     int act_index)
+			     int act_index,
+			     struct mlx5_flow_attr *attr)
 {
 	if (!act->tunnel) {
 		NL_SET_ERR_MSG_MOD(parse_state->extack,
@@ -34,7 +35,8 @@ tc_act_parse_tun_encap(struct mlx5e_tc_act_parse_state *parse_state,
 static bool
 tc_act_can_offload_tun_decap(struct mlx5e_tc_act_parse_state *parse_state,
 			     const struct flow_action_entry *act,
-			     int act_index)
+			     int act_index,
+			     struct mlx5_flow_attr *attr)
 {
 	return true;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
index f4659254f8f3..6378b7558ba2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
@@ -150,7 +150,8 @@ mlx5e_tc_act_vlan_add_pop_action(struct mlx5e_priv *priv,
 static bool
 tc_act_can_offload_vlan(struct mlx5e_tc_act_parse_state *parse_state,
 			const struct flow_action_entry *act,
-			int act_index)
+			int act_index,
+			struct mlx5_flow_attr *attr)
 {
 	return true;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan_mangle.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan_mangle.c
index 396b32e4b6e2..28444d4ffd73 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan_mangle.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan_mangle.c
@@ -53,7 +53,8 @@ mlx5e_tc_act_vlan_add_rewrite_action(struct mlx5e_priv *priv, int namespace,
 static bool
 tc_act_can_offload_vlan_mangle(struct mlx5e_tc_act_parse_state *parse_state,
 			       const struct flow_action_entry *act,
-			       int act_index)
+			       int act_index,
+			       struct mlx5_flow_attr *attr)
 {
 	return true;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 5eb5f6ec2f0d..de07ccd6ac7b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3302,7 +3302,7 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 			return -EOPNOTSUPP;
 		}
 
-		if (!tc_act->can_offload(parse_state, act, i))
+		if (!tc_act->can_offload(parse_state, act, i, attr))
 			return -EOPNOTSUPP;
 
 		err = tc_act->parse_action(parse_state, act, priv, attr);
@@ -3313,7 +3313,7 @@ parse_tc_actions(struct mlx5e_tc_act_parse_state *parse_state,
 	flow_action_for_each(i, act, flow_action) {
 		tc_act = mlx5e_tc_act_get(act->id, ns_type);
 		if (!tc_act || !tc_act->post_parse ||
-		    !tc_act->can_offload(parse_state, act, i))
+		    !tc_act->can_offload(parse_state, act, i, attr))
 			continue;
 
 		err = tc_act->post_parse(parse_state, priv, attr);
-- 
2.34.1

