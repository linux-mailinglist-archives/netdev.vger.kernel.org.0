Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA0E48A541
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346287AbiAKBoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:44:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346262AbiAKBny (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 20:43:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1E6C061748
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 17:43:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E684361494
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 01:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0440DC36AE5;
        Tue, 11 Jan 2022 01:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641865433;
        bh=7m7Jyzk6VdBI/d8bCqvdiXdoR5LHFNwx+3HDLiPb5PY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZFK45l1m/KCJJe4VTQx0U935sNrb4QL2Pf9IuXpNtvN3Zyt0ZQTjtHd2TUxaRO0jC
         NlRp9aw+vE5o9CJD40NqT7pyG3uqBzh6QDfwtgI8p4zVYyf3OxVFMk0oZx8DBUPC5v
         uQQLqZNmrKSYNVOb1OAG9HqGiU3wwUvGmyMKoUHfMhaMhdaQo60E0xI+P+GQCdq2lR
         hYWUJ1c1EEcaPx1nBq/uX3wYMGTDYyXJoXpI3iSwCaLEfiVCOkdX5MdM0+G5I8y4Oq
         l0UG4OvqhIMH15LUZbF+rLoRB6yVSvAHMa3iHkq4hLQQuFygePpMuWmNVfYslj/1kk
         udb/HTUL/EB/w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/17] net/mlx5e: CT, Remove redundant flow args from tc ct calls
Date:   Mon, 10 Jan 2022 17:43:33 -0800
Message-Id: <20220111014335.178121-16-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111014335.178121-1-saeed@kernel.org>
References: <20220111014335.178121-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

The flow arg is not being used so remove it.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 11 ++++-------
 .../net/ethernet/mellanox/mlx5/core/en/tc_ct.h |  4 ----
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h   |  3 +--
 .../net/ethernet/mellanox/mlx5/core/en_tc.c    | 18 ++++++++----------
 4 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 1fe6c9c786a2..0f4d3b9dd979 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1787,7 +1787,6 @@ mlx5_tc_ct_del_ft_cb(struct mlx5_tc_ct_priv *ct_priv, struct mlx5_ct_ft *ft)
  */
 static struct mlx5_flow_handle *
 __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
-			  struct mlx5e_tc_flow *flow,
 			  struct mlx5_flow_spec *orig_spec,
 			  struct mlx5_flow_attr *attr)
 {
@@ -1926,7 +1925,6 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 
 struct mlx5_flow_handle *
 mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *priv,
-			struct mlx5e_tc_flow *flow,
 			struct mlx5_flow_spec *spec,
 			struct mlx5_flow_attr *attr,
 			struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts)
@@ -1937,7 +1935,7 @@ mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *priv,
 		return ERR_PTR(-EOPNOTSUPP);
 
 	mutex_lock(&priv->control_lock);
-	rule = __mlx5_tc_ct_flow_offload(priv, flow, spec, attr);
+	rule = __mlx5_tc_ct_flow_offload(priv, spec, attr);
 	mutex_unlock(&priv->control_lock);
 
 	return rule;
@@ -1945,8 +1943,8 @@ mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *priv,
 
 static void
 __mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *ct_priv,
-			 struct mlx5e_tc_flow *flow,
-			 struct mlx5_ct_flow *ct_flow)
+			 struct mlx5_ct_flow *ct_flow,
+			 struct mlx5_flow_attr *attr)
 {
 	struct mlx5_flow_attr *pre_ct_attr = ct_flow->pre_ct_attr;
 	struct mlx5e_priv *priv = netdev_priv(ct_priv->netdev);
@@ -1966,7 +1964,6 @@ __mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *ct_priv,
 
 void
 mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *priv,
-		       struct mlx5e_tc_flow *flow,
 		       struct mlx5_flow_attr *attr)
 {
 	struct mlx5_ct_flow *ct_flow = attr->ct_attr.ct_flow;
@@ -1978,7 +1975,7 @@ mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *priv,
 		return;
 
 	mutex_lock(&priv->control_lock);
-	__mlx5_tc_ct_delete_flow(priv, flow, ct_flow);
+	__mlx5_tc_ct_delete_flow(priv, ct_flow, attr);
 	mutex_unlock(&priv->control_lock);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
index 99662af1e41a..2b21c7b97a52 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h
@@ -116,13 +116,11 @@ mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 
 struct mlx5_flow_handle *
 mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *priv,
-			struct mlx5e_tc_flow *flow,
 			struct mlx5_flow_spec *spec,
 			struct mlx5_flow_attr *attr,
 			struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts);
 void
 mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *priv,
-		       struct mlx5e_tc_flow *flow,
 		       struct mlx5_flow_attr *attr);
 
 bool
@@ -183,7 +181,6 @@ mlx5_tc_ct_parse_action(struct mlx5_tc_ct_priv *priv,
 
 static inline struct mlx5_flow_handle *
 mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *priv,
-			struct mlx5e_tc_flow *flow,
 			struct mlx5_flow_spec *spec,
 			struct mlx5_flow_attr *attr,
 			struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts)
@@ -193,7 +190,6 @@ mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *priv,
 
 static inline void
 mlx5_tc_ct_delete_flow(struct mlx5_tc_ct_priv *priv,
-		       struct mlx5e_tc_flow *flow,
 		       struct mlx5_flow_attr *attr)
 {
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index b7d14aff5f3a..9ffba584b982 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -113,13 +113,12 @@ struct mlx5e_tc_flow {
 
 struct mlx5_flow_handle *
 mlx5e_tc_rule_offload(struct mlx5e_priv *priv,
-		      struct mlx5e_tc_flow *flow,
 		      struct mlx5_flow_spec *spec,
 		      struct mlx5_flow_attr *attr);
 
 void
 mlx5e_tc_rule_unoffload(struct mlx5e_priv *priv,
-			struct mlx5e_tc_flow *flow,
+			struct mlx5_flow_handle *rule,
 			struct mlx5_flow_attr *attr);
 
 u8 mlx5e_tc_get_ip_version(struct mlx5_flow_spec *spec, bool outer);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 83ca036528bb..1287193a019b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -303,7 +303,6 @@ mlx5_tc_rule_delete(struct mlx5e_priv *priv,
 
 struct mlx5_flow_handle *
 mlx5e_tc_rule_offload(struct mlx5e_priv *priv,
-		      struct mlx5e_tc_flow *flow,
 		      struct mlx5_flow_spec *spec,
 		      struct mlx5_flow_attr *attr)
 {
@@ -313,7 +312,7 @@ mlx5e_tc_rule_offload(struct mlx5e_priv *priv,
 		struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts =
 			&attr->parse_attr->mod_hdr_acts;
 
-		return mlx5_tc_ct_flow_offload(get_ct_priv(priv), flow,
+		return mlx5_tc_ct_flow_offload(get_ct_priv(priv),
 					       spec, attr,
 					       mod_hdr_acts);
 	}
@@ -329,14 +328,13 @@ mlx5e_tc_rule_offload(struct mlx5e_priv *priv,
 
 void
 mlx5e_tc_rule_unoffload(struct mlx5e_priv *priv,
-			struct mlx5e_tc_flow *flow,
+			struct mlx5_flow_handle *rule,
 			struct mlx5_flow_attr *attr)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct mlx5_flow_handle *rule = flow->rule[0];
 
 	if (attr->flags & MLX5_ATTR_FLAG_CT) {
-		mlx5_tc_ct_delete_flow(get_ct_priv(priv), flow, attr);
+		mlx5_tc_ct_delete_flow(get_ct_priv(priv), attr);
 		return;
 	}
 
@@ -1136,7 +1134,7 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 	}
 
 	if (attr->flags & MLX5_ATTR_FLAG_CT)
-		flow->rule[0] = mlx5_tc_ct_flow_offload(get_ct_priv(priv), flow, &parse_attr->spec,
+		flow->rule[0] = mlx5_tc_ct_flow_offload(get_ct_priv(priv), &parse_attr->spec,
 							attr, &parse_attr->mod_hdr_acts);
 	else
 		flow->rule[0] = mlx5e_add_offloaded_nic_rule(priv, &parse_attr->spec,
@@ -1171,7 +1169,7 @@ static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
 	flow_flag_clear(flow, OFFLOADED);
 
 	if (attr->flags & MLX5_ATTR_FLAG_CT)
-		mlx5_tc_ct_delete_flow(get_ct_priv(flow->priv), flow, attr);
+		mlx5_tc_ct_delete_flow(get_ct_priv(flow->priv), attr);
 	else if (!IS_ERR_OR_NULL(flow->rule[0]))
 		mlx5e_del_offloaded_nic_rule(priv, flow->rule[0], attr);
 
@@ -1210,7 +1208,7 @@ mlx5e_tc_offload_fdb_rules(struct mlx5_eswitch *esw,
 	if (attr->flags & MLX5_ATTR_FLAG_SLOW_PATH)
 		return mlx5_eswitch_add_offloaded_rule(esw, spec, attr);
 
-	rule = mlx5e_tc_rule_offload(flow->priv, flow, spec, attr);
+	rule = mlx5e_tc_rule_offload(flow->priv, spec, attr);
 
 	if (IS_ERR(rule))
 		return rule;
@@ -1224,7 +1222,7 @@ mlx5e_tc_offload_fdb_rules(struct mlx5_eswitch *esw,
 	return rule;
 
 err_rule1:
-	mlx5e_tc_rule_unoffload(flow->priv, flow, attr);
+	mlx5e_tc_rule_unoffload(flow->priv, rule, attr);
 	return flow->rule[1];
 }
 
@@ -1240,7 +1238,7 @@ void mlx5e_tc_unoffload_fdb_rules(struct mlx5_eswitch *esw,
 	if (attr->esw_attr->split_count)
 		mlx5_eswitch_del_fwd_rule(esw, flow->rule[1], attr);
 
-	mlx5e_tc_rule_unoffload(flow->priv, flow, attr);
+	mlx5e_tc_rule_unoffload(flow->priv, flow->rule[0], attr);
 }
 
 struct mlx5_flow_handle *
-- 
2.34.1

