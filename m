Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA4E1BB5DB
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 07:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgD1FYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 01:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726286AbgD1FYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 01:24:54 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC711C03C1A9
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 22:24:54 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id k18so7892695pll.6
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 22:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=s19UlkmoOr6368++osGj7SAIcDSSML34VT8HLkgde/o=;
        b=Dh9zoX4Y8Eei2VavOfYRghebTCfPVdN/i/WKmOaRUStk8NRI+3q6cm8KdS/nyR4Fv2
         d277zH5F0BuF2XxkzSx2LcQZ6QyLDomz6+MtCeVxMeXLt4OmTy6/jmpexQm2LXQz79ud
         wpJ3iWwmnlQDQxgNvsS9Wvkaa1GcAvRvlvWCdzyiSEFVP2xbmnd3+JQ9cCVLizPoDzmQ
         4wEX5Sco0we+HItrZRPXhWjzpYGCdLpEbIjz5Vh/s56E4R45s2RJrQrc9LS/XxkF+Vae
         7eE1oajI3O/mhPn7JL3dcpvBe3b4qRuSnl5F/TUhd26NzNdhZYz6myDWkDMvMk1qp0aZ
         FGRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=s19UlkmoOr6368++osGj7SAIcDSSML34VT8HLkgde/o=;
        b=fCC0ppy4G/AJ1R/MHyV18D3LieJcBSXGrtMxg3Z9hii/REEUXZk+ir0GFRmcp8vc0c
         rsj2KRdqHUuKWtkjn3DYkObSzAjzM5mDyr4acywkXSMzq37XN08oVHis2nFsUER1eEIM
         c3I//5OoaUeu8iF6ng9kkCVfJmClNXRvctfhaVXnVVRetLmq4ZkRgsblO/ISDgkCFeUf
         7NmAHF71nFxdZ6tbinmy9S2xFbkT0FFmcn2EQaVQYptUf8t7FJh7Qc6pRTdcp678h1cb
         C8XA1Ztk9PLmwUUgHy1pRmbUoT1X6acpLRDO2GIPf6CSZ7+hetKxC5imVsBC+bIYCm5O
         tDkA==
X-Gm-Message-State: AGi0PuZ4ljqhyZpNPGWM5n4XQ4IZYof15h/rxdYGPcjtxx4q2kvVXkaE
        Xp4GGt5+Bw1KxSdFr7KQ1roJpkySWQE=
X-Google-Smtp-Source: APiQypIyCcbrxaHXYY7VD//yEs9WjL4IjoPddbYEm4yFbdWjcd3jFQj9fLCTRVuql4ehyNcvS9oF8Q==
X-Received: by 2002:a17:90b:30cb:: with SMTP id hi11mr2967061pjb.103.1588051494444;
        Mon, 27 Apr 2020 22:24:54 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.142.146.4])
        by smtp.gmail.com with ESMTPSA id d8sm14093044pfd.159.2020.04.27.22.24.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 22:24:53 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     paulb@mellanox.com, saeedm@mellanox.com, roid@mellanox.com,
        gerlitz.or@gmail.com
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next 2/3] net/mlx5e: Introduce mlx5e_eswitch_rep_uplink_priv helper
Date:   Tue, 28 Apr 2020 13:24:14 +0800
Message-Id: <1588051455-42828-2-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588051455-42828-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1588051455-42828-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Introduce the mlx5e_eswitch_rep_uplink_priv helper
to make the codes readable.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  4 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |  9 +++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 30 +++++-----------------
 3 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 16416eaac39e..c5d5e69ff147 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -100,10 +100,8 @@ struct mlx5_ct_entry {
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *uplink_rpriv;
 
-	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-	uplink_priv = &uplink_rpriv->uplink_priv;
+	uplink_priv = mlx5e_eswitch_rep_uplink_priv(esw);
 	return uplink_priv->ct_priv;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 6a2337900420..899ffa0872b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -109,6 +109,15 @@ struct mlx5e_rep_priv *mlx5e_rep_to_rep_priv(struct mlx5_eswitch_rep *rep)
 	return rep->rep_data[REP_ETH].priv;
 }
 
+static inline struct mlx5_rep_uplink_priv *
+mlx5e_eswitch_rep_uplink_priv(struct mlx5_eswitch *esw)
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
index 64f5c3f3dbb3..696544e2a25b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1250,12 +1250,10 @@ static void unready_flow_del(struct mlx5e_tc_flow *flow)
 static void add_unready_flow(struct mlx5e_tc_flow *flow)
 {
 	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *rpriv;
 	struct mlx5_eswitch *esw;
 
 	esw = flow->priv->mdev->priv.eswitch;
-	rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-	uplink_priv = &rpriv->uplink_priv;
+	uplink_priv = mlx5e_eswitch_rep_uplink_priv(esw);
 
 	mutex_lock(&uplink_priv->unready_flows_lock);
 	unready_flow_add(flow, &uplink_priv->unready_flows);
@@ -1265,12 +1263,10 @@ static void add_unready_flow(struct mlx5e_tc_flow *flow)
 static void remove_unready_flow(struct mlx5e_tc_flow *flow)
 {
 	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *rpriv;
 	struct mlx5_eswitch *esw;
 
 	esw = flow->priv->mdev->priv.eswitch;
-	rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-	uplink_priv = &rpriv->uplink_priv;
+	uplink_priv = mlx5e_eswitch_rep_uplink_priv(esw);
 
 	mutex_lock(&uplink_priv->unready_flows_lock);
 	unready_flow_del(flow);
@@ -1888,7 +1884,6 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
 	struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts;
 	struct flow_match_enc_opts enc_opts_match;
 	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *uplink_rpriv;
 	struct tunnel_match_key tunnel_key;
 	bool enc_opts_is_dont_care = true;
 	u32 tun_id, enc_opts_id = 0;
@@ -1897,8 +1892,7 @@ static int mlx5e_get_flow_tunnel_id(struct mlx5e_priv *priv,
 	int err;
 
 	esw = priv->mdev->priv.eswitch;
-	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-	uplink_priv = &uplink_rpriv->uplink_priv;
+	uplink_priv = mlx5e_eswitch_rep_uplink_priv(esw);
 
 	mlx5e_make_tunnel_match_key(f, filter_dev, &tunnel_key);
 	err = mapping_add(uplink_priv->tunnel_mapping, &tunnel_key, &tun_id);
@@ -1957,13 +1951,11 @@ static int mlx5e_lookup_flow_tunnel_id(struct mlx5e_priv *priv,
 				       u32 *tun_id)
 {
 	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *uplink_rpriv;
 	struct tunnel_match_key tunnel_key;
 	struct mlx5_eswitch *esw;
 
 	esw = priv->mdev->priv.eswitch;
-	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-	uplink_priv = &uplink_rpriv->uplink_priv;
+	uplink_priv = mlx5e_eswitch_rep_uplink_priv(esw);
 
 	mlx5e_make_tunnel_match_key(f, filter_dev, &tunnel_key);
 	return mapping_find_by_data(uplink_priv->tunnel_mapping, &tunnel_key, tun_id);
@@ -1974,12 +1966,10 @@ static void mlx5e_put_flow_tunnel_id(struct mlx5e_tc_flow *flow)
 	u32 enc_opts_id = flow->tunnel_id & ENC_OPTS_BITS_MASK;
 	u32 tun_id = flow->tunnel_id >> ENC_OPTS_BITS;
 	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *uplink_rpriv;
 	struct mlx5_eswitch *esw;
 
 	esw = flow->priv->mdev->priv.eswitch;
-	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-	uplink_priv = &uplink_rpriv->uplink_priv;
+	uplink_priv = mlx5e_eswitch_rep_uplink_priv(esw);
 
 	if (tun_id)
 		mapping_remove(uplink_priv->tunnel_mapping, tun_id);
@@ -4841,7 +4831,6 @@ static bool mlx5e_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct flow_dissector_key_enc_opts enc_opts = {};
 	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *uplink_rpriv;
 	struct metadata_dst *tun_dst;
 	struct tunnel_match_key key;
 	u32 tun_id, enc_opts_id;
@@ -4854,9 +4843,7 @@ static bool mlx5e_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
 	if (!tun_id)
 		return true;
 
-	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-	uplink_priv = &uplink_rpriv->uplink_priv;
-
+	uplink_priv = mlx5e_eswitch_rep_uplink_priv(esw);
 	err = mapping_find(uplink_priv->tunnel_mapping, tun_id, &key);
 	if (err) {
 		WARN_ON_ONCE(true);
@@ -4920,7 +4907,6 @@ bool mlx5e_tc_rep_update_skb(struct mlx5_cqe64 *cqe,
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	u32 chain = 0, reg_c0, reg_c1, tunnel_id, tuple_id;
 	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *uplink_rpriv;
 	struct tc_skb_ext *tc_skb_ext;
 	struct mlx5_eswitch *esw;
 	struct mlx5e_priv *priv;
@@ -4956,9 +4942,7 @@ bool mlx5e_tc_rep_update_skb(struct mlx5_cqe64 *cqe,
 		tc_skb_ext->chain = chain;
 
 		tuple_id = reg_c1 & TUPLE_ID_MAX;
-
-		uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-		uplink_priv = &uplink_rpriv->uplink_priv;
+		uplink_priv = mlx5e_eswitch_rep_uplink_priv(esw);
 		if (!mlx5e_tc_ct_restore_flow(uplink_priv, skb, tuple_id))
 			return false;
 	}
-- 
1.8.3.1

