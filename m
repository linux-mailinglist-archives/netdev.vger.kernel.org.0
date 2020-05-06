Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6411C65D0
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 04:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729791AbgEFCRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 22:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbgEFCRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 22:17:13 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB00C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 19:17:12 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id m7so56472plt.5
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 19:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8NhR98I2N85/nXQPa9dkUKRJ7iNnST9fW+0IGzzxSuY=;
        b=lYRdeADCXM46iZy+u7Xn7aCfQ3KR2LV93lsIKncZgqJZKWxhqVdEbixEgAiBL43TTR
         jPA6zsUvaLWWDKg7u8klZ5v4xZO70CeIsfU9CsMwRZxxG1+UnL+yjKpf5tXSRWDUK60z
         hdXuhV8iTP/Y0w9q9XkQJyM+fX4BjRFTcMImY/fZPlO59pPPaknvHTkSFef3oVWst21T
         q3/Ea19EtbQ58Ux3uhrrCplIizwnZMRWc1zQdVUXwbJKl4kyModqbnJ58wXFYVCdlN4/
         4kfUmV8/HQ165R5K7fe8eXJyWZtmWwXf8uE6gaN0b/cwfETkpT6YB8HLZZuqiarPJ2yX
         xaOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8NhR98I2N85/nXQPa9dkUKRJ7iNnST9fW+0IGzzxSuY=;
        b=ivooxy6P500AOUFHHeKcgl0Yfqz8GbwNhM4iY2U+3ZoROBexgnWsNd1MKJQGFfN+Y7
         rOHsIKH+viAfRPC07kqxOYb+PsTCSZeEf+WxzuNOfEtAgHqrYk76I7r/WJmqEkP1tSGD
         v1jJ0d2dxQCQcqJ/Xu9cBKRW6XiTlTOo2LIG9EoOYHOvHM3YyCsGGn3i6FqsihyywNMi
         tmyeP4zuQElfXlqrQ6iBWbjJqgi/tbpKu7AD5xhA6REulicVd8tIhWYvcg4WGicURD7f
         ezGEQk55kFumCqTS+AzyJZhbQ6gXbdDPJpc5a7FI8Uu9htpirn7eLQkAoh/7oqkpVzHO
         F4/w==
X-Gm-Message-State: AGi0PuYY1hXBAfkkmfw8Gz1LCx6xQoC6fRJQl1MnAbQaiRJVI2rZJGso
        dZmnc+kxYWrrRo2U9hNPKuY=
X-Google-Smtp-Source: APiQypIFKbEGN+TEwLVVurKt/zBC6tWTM4OEcumvoJ8T5vhRWeCZmbk1EgjC+kwgO54/Ce3T30IHJA==
X-Received: by 2002:a17:902:ac87:: with SMTP id h7mr5639465plr.119.1588731432095;
        Tue, 05 May 2020 19:17:12 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.142.146.4])
        by smtp.gmail.com with ESMTPSA id ft14sm1751646pjb.46.2020.05.05.19.17.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 May 2020 19:17:11 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     paulb@mellanox.com, saeedm@mellanox.com, roid@mellanox.com,
        gerlitz.or@gmail.com
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH v2 2/3] net/mlx5e: Introduce mlx5e_rep_uplink_priv helper
Date:   Wed,  6 May 2020 10:16:32 +0800
Message-Id: <1588731393-6973-2-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588731393-6973-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1588731393-6973-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Introduce the mlx5e_rep_uplink_priv helper
to make the codes more readable.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
v2:
* change the name mlx5e_eswitch_rep_uplink_priv to mlx5e_rep_uplink_priv
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  4 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |  9 +++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 30 +++++-----------------
 3 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 5568ded97e0b..c3e0967c8e07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -99,10 +99,8 @@ struct mlx5_ct_entry {
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
index 6a2337900420..5bd2a61770ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -109,6 +109,15 @@ struct mlx5e_rep_priv *mlx5e_rep_to_rep_priv(struct mlx5_eswitch_rep *rep)
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
index 7ab1b162d317..4c3376b10c6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1255,12 +1255,10 @@ static void unready_flow_del(struct mlx5e_tc_flow *flow)
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
@@ -1270,12 +1268,10 @@ static void add_unready_flow(struct mlx5e_tc_flow *flow)
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
@@ -1892,7 +1888,6 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
 	struct flow_match_enc_opts enc_opts_match;
 	struct tunnel_match_enc_opts tun_enc_opts;
 	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *uplink_rpriv;
 	struct tunnel_match_key tunnel_key;
 	bool enc_opts_is_dont_care = true;
 	u32 tun_id, enc_opts_id = 0;
@@ -1901,8 +1896,7 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
 	int err;
 
 	esw = priv->mdev->priv.eswitch;
-	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-	uplink_priv = &uplink_rpriv->uplink_priv;
+	uplink_priv = mlx5e_rep_uplink_priv(esw);
 
 	mlx5e_make_tunnel_match_key(f, filter_dev, &tunnel_key);
 	err = mapping_add(uplink_priv->tunnel_mapping, &tunnel_key, &tun_id);
@@ -1967,13 +1961,11 @@ static int mlx5e_lookup_flow_tunnel_id(struct mlx5e_priv *priv,
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
@@ -1984,12 +1976,10 @@ static void mlx5e_put_flow_tunnel_id(struct mlx5e_tc_flow *flow)
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
@@ -4853,7 +4843,6 @@ static bool mlx5e_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct tunnel_match_enc_opts enc_opts = {};
 	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *uplink_rpriv;
 	struct metadata_dst *tun_dst;
 	struct tunnel_match_key key;
 	u32 tun_id, enc_opts_id;
@@ -4866,9 +4855,7 @@ static bool mlx5e_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
 	if (!tun_id)
 		return true;
 
-	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-	uplink_priv = &uplink_rpriv->uplink_priv;
-
+	uplink_priv = mlx5e_rep_uplink_priv(esw);
 	err = mapping_find(uplink_priv->tunnel_mapping, tun_id, &key);
 	if (err) {
 		WARN_ON_ONCE(true);
@@ -4934,7 +4921,6 @@ bool mlx5e_tc_rep_update_skb(struct mlx5_cqe64 *cqe,
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	u32 chain = 0, reg_c0, reg_c1, tunnel_id, tuple_id;
 	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *uplink_rpriv;
 	struct tc_skb_ext *tc_skb_ext;
 	struct mlx5_eswitch *esw;
 	struct mlx5e_priv *priv;
@@ -4970,9 +4956,7 @@ bool mlx5e_tc_rep_update_skb(struct mlx5_cqe64 *cqe,
 		tc_skb_ext->chain = chain;
 
 		tuple_id = reg_c1 & TUPLE_ID_MAX;
-
-		uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-		uplink_priv = &uplink_rpriv->uplink_priv;
+		uplink_priv = mlx5e_rep_uplink_priv(esw);
 		if (!mlx5e_tc_ct_restore_flow(uplink_priv, skb, tuple_id))
 			return false;
 	}
-- 
1.8.3.1

