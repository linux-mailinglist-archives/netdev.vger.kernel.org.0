Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789191FEDC6
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 10:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgFRIhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 04:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728465AbgFRIhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 04:37:32 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14588C0613ED
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 01:37:32 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id l6so1139701qkc.6
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 01:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cCEVW6ZBtJXEgpwnbXbhYEgSKBTezBvPxT8n/yB/Du8=;
        b=fxIzFw62Jmjjg80IrcNOZu1u7SlrT8CJPgC2M9atw+i7gxszXCczW0iRO7oRnNGP6D
         pxDMxNsTyCXUfV2njTFx8EKO0jl2UPpmnJkfBQ4p/M/gLjMj7ELhJW6tAy69STMTBxTO
         wat04r2AGogC/JRWChXcNXAs86mbj8QBlu0kWrF+yUpu8L3GqxZxNDinXa6jsuZF5Pqo
         TQ4fGQb2ts8Zxsouxo6/WVC7G9FhYG4BiulMNcra/mffEV0+uATYCD/gCwJ7Vqj+GKpu
         tYdxr2G1Fll9BakBdQsBlwRlqTqOAm1JMmWKjpdWH7FIek3Dlk70TJrjxCMvLnK8JzT2
         I5Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cCEVW6ZBtJXEgpwnbXbhYEgSKBTezBvPxT8n/yB/Du8=;
        b=rSYrpAwGr/Ef3tLNy1R7VobKDGzqT0n2Y+THO0NHy/nD6q/sAYA8V+jSfKxAVGXvaq
         aphVHX4YTgIR51rkYV6VO8xAA99Xoj1kN1CuVIq4+dxS4OvMaWRizWd8e+JG1dz559ID
         GnbLYpnOj1ik4PBoXuPX3bntn0MZmgPvvnjQAwMnVu6k5PPo3TcEMFFB725gZ9LWpRkF
         cHuj/w4kGZcFZ4bhck+WduiRF4UqV5TX/U1o3AfYVvpaWM80k/YBrepecc8K+QSgH4vS
         tLypuBw7D4Bx9bF2v6gzAO/JywIBN8tCss3k3rhk3l1uVIAaJNWuLTy1uWSSL+nsJtng
         +fqA==
X-Gm-Message-State: AOAM533l5FwlQ6DsK+LulnnToYiEsmUZ2I2b2W2U0jFxiKW3zAYzFhTw
        OLQhh2MCwhX4rptWfiU4Sfo=
X-Google-Smtp-Source: ABdhPJzOE9mKsmF7INoO9JY/xKi7YSpSn9yy+RVXEEWR8eDYlCTm2GFaxErS+ju0YHGs2+kyBoIWoA==
X-Received: by 2002:a37:a30a:: with SMTP id m10mr2768626qke.8.1592469451369;
        Thu, 18 Jun 2020 01:37:31 -0700 (PDT)
Received: from localhost.localdomain ([111.205.198.3])
        by smtp.gmail.com with ESMTPSA id l69sm2131551qke.112.2020.06.18.01.37.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jun 2020 01:37:30 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     paulb@mellanox.com, saeedm@mellanox.com, gerlitz.or@gmail.com,
        roid@mellanox.com
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v3 2/3] net/mlx5e: Introduce mlx5e_rep_uplink_priv helper
Date:   Thu, 18 Jun 2020 16:36:45 +0800
Message-Id: <20200618083646.59507-2-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <20200618083646.59507-1-xiangxia.m.yue@gmail.com>
References: <20200618083646.59507-1-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Introduce the mlx5e_rep_uplink_priv helper
to make the codes more readable.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |  9 ++-------
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  4 +---
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  9 +++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 20 +++++--------------
 4 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 80713123de5c..e92403a470cf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -507,7 +507,6 @@ static bool mlx5e_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct tunnel_match_enc_opts enc_opts = {};
 	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *uplink_rpriv;
 	struct metadata_dst *tun_dst;
 	struct tunnel_match_key key;
 	u32 tun_id, enc_opts_id;
@@ -520,9 +519,7 @@ static bool mlx5e_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
 	if (!tun_id)
 		return true;
 
-	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-	uplink_priv = &uplink_rpriv->uplink_priv;
-
+	uplink_priv = mlx5e_rep_uplink_priv(esw);
 	err = mapping_find(uplink_priv->tunnel_mapping, tun_id, &key);
 	if (err) {
 		WARN_ON_ONCE(true);
@@ -588,7 +585,6 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	u32 chain = 0, reg_c0, reg_c1, tunnel_id, tuple_id;
 	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *uplink_rpriv;
 	struct tc_skb_ext *tc_skb_ext;
 	struct mlx5_eswitch *esw;
 	struct mlx5e_priv *priv;
@@ -625,8 +621,7 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 
 		tuple_id = reg_c1 & TUPLE_ID_MAX;
 
-		uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-		uplink_priv = &uplink_rpriv->uplink_priv;
+		uplink_priv = mlx5e_rep_uplink_priv(esw);
 		if (!mlx5e_tc_ct_restore_flow(uplink_priv, skb, tuple_id))
 			return false;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 430025550fad..71841e7cca88 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -111,10 +111,8 @@ mlx5_tc_ct_get_ct_priv(struct mlx5e_priv *priv)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *uplink_rpriv;
 
-	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-	uplink_priv = &uplink_rpriv->uplink_priv;
+	uplink_priv = mlx5e_rep_uplink_priv(esw);
 	return uplink_priv->ct_priv;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 1d5669801484..adcd3db0638f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -108,6 +108,15 @@ struct mlx5e_rep_priv *mlx5e_rep_to_rep_priv(struct mlx5_eswitch_rep *rep)
 	return rep->rep_data[REP_ETH].priv;
 }
 
+static inline struct mlx5_rep_uplink_priv *
+mlx5e_rep_uplink_priv(struct mlx5_eswitch *esw)
+{
+	struct mlx5e_rep_priv *priv;
+
+	priv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+	return &priv->uplink_priv;
+}
+
 struct mlx5e_neigh {
 	struct net_device *dev;
 	union {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 05f8df8b53af..b33e40455b51 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1245,12 +1245,10 @@ static void unready_flow_del(struct mlx5e_tc_flow *flow)
 static void add_unready_flow(struct mlx5e_tc_flow *flow)
 {
 	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *rpriv;
 	struct mlx5_eswitch *esw;
 
 	esw = flow->priv->mdev->priv.eswitch;
-	rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-	uplink_priv = &rpriv->uplink_priv;
+	uplink_priv = mlx5e_rep_uplink_priv(esw);
 
 	mutex_lock(&uplink_priv->unready_flows_lock);
 	unready_flow_add(flow, &uplink_priv->unready_flows);
@@ -1260,12 +1258,10 @@ static void add_unready_flow(struct mlx5e_tc_flow *flow)
 static void remove_unready_flow(struct mlx5e_tc_flow *flow)
 {
 	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *rpriv;
 	struct mlx5_eswitch *esw;
 
 	esw = flow->priv->mdev->priv.eswitch;
-	rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-	uplink_priv = &rpriv->uplink_priv;
+	uplink_priv = mlx5e_rep_uplink_priv(esw);
 
 	mutex_lock(&uplink_priv->unready_flows_lock);
 	unready_flow_del(flow);
@@ -1937,7 +1933,6 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
 	struct flow_match_enc_opts enc_opts_match;
 	struct tunnel_match_enc_opts tun_enc_opts;
 	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *uplink_rpriv;
 	struct tunnel_match_key tunnel_key;
 	bool enc_opts_is_dont_care = true;
 	u32 tun_id, enc_opts_id = 0;
@@ -1946,8 +1941,7 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
 	int err;
 
 	esw = priv->mdev->priv.eswitch;
-	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-	uplink_priv = &uplink_rpriv->uplink_priv;
+	uplink_priv = mlx5e_rep_uplink_priv(esw);
 
 	mlx5e_make_tunnel_match_key(f, filter_dev, &tunnel_key);
 	err = mapping_add(uplink_priv->tunnel_mapping, &tunnel_key, &tun_id);
@@ -2012,13 +2006,11 @@ static int mlx5e_lookup_flow_tunnel_id(struct mlx5e_priv *priv,
 				       u32 *tun_id)
 {
 	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *uplink_rpriv;
 	struct tunnel_match_key tunnel_key;
 	struct mlx5_eswitch *esw;
 
 	esw = priv->mdev->priv.eswitch;
-	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-	uplink_priv = &uplink_rpriv->uplink_priv;
+	uplink_priv = mlx5e_rep_uplink_priv(esw);
 
 	mlx5e_make_tunnel_match_key(f, filter_dev, &tunnel_key);
 	return mapping_find_by_data(uplink_priv->tunnel_mapping, &tunnel_key, tun_id);
@@ -2029,12 +2021,10 @@ static void mlx5e_put_flow_tunnel_id(struct mlx5e_tc_flow *flow)
 	u32 enc_opts_id = flow->tunnel_id & ENC_OPTS_BITS_MASK;
 	u32 tun_id = flow->tunnel_id >> ENC_OPTS_BITS;
 	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *uplink_rpriv;
 	struct mlx5_eswitch *esw;
 
 	esw = flow->priv->mdev->priv.eswitch;
-	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-	uplink_priv = &uplink_rpriv->uplink_priv;
+	uplink_priv = mlx5e_rep_uplink_priv(esw);
 
 	if (tun_id)
 		mapping_remove(uplink_priv->tunnel_mapping, tun_id);
-- 
2.26.1

