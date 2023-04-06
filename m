Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46EFE6D8D29
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 04:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234351AbjDFCCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 22:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234613AbjDFCCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 22:02:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01207DB0
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 19:02:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B82F62C93
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:02:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62404C433EF;
        Thu,  6 Apr 2023 02:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680746564;
        bh=JY1his/MYcK/AOINF5EZqlQ9T0hcNoJ/8f9n+IKT/Fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WMCMFxdKYl420dy8LT048PCNYmFAX8mHNJOmz0/KjdBrJ+ZUR0iS8n73sdQ+ebe1S
         a3cN7PMLbriGtV0WNmb0VURaAw0hgXmsBan9noq5a6uEUJuI5Dp7wBmrwO8xz6WnYb
         k3ARSFhjZTT/DMFJAhq/AcVSS1P1Cqk6EzM+cGHoA3sm5L1CsCEbevNfvjEo02+kHE
         pvwRQswu/U9+tIibVZeoXsUozxqzK9RW5brv1cZn/AdBzlrewYUgCmWODRGQvGm0A+
         K56q4txHdPLuif2RiZxdcrhAirG5g62A4pYH3lc5ylm3Zzr5UIQHVAfwc4YQqH7QvA
         cNZ7mfPyoMABw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 02/15] net/mlx5e: TC, Remove unused vf_tun variable
Date:   Wed,  5 Apr 2023 19:02:19 -0700
Message-Id: <20230406020232.83844-3-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406020232.83844-1-saeed@kernel.org>
References: <20230406020232.83844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

vf_tun is being assigned but never being used so remove it.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 4140155e3487..a4cf1818e8fe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1785,8 +1785,7 @@ set_encap_dests(struct mlx5e_priv *priv,
 static void
 clean_encap_dests(struct mlx5e_priv *priv,
 		  struct mlx5e_tc_flow *flow,
-		  struct mlx5_flow_attr *attr,
-		  bool *vf_tun)
+		  struct mlx5_flow_attr *attr)
 {
 	struct mlx5_esw_flow_attr *esw_attr;
 	int out_index;
@@ -1795,17 +1794,11 @@ clean_encap_dests(struct mlx5e_priv *priv,
 		return;
 
 	esw_attr = attr->esw_attr;
-	*vf_tun = false;
 
 	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++) {
 		if (!(esw_attr->dests[out_index].flags & MLX5_ESW_DEST_ENCAP))
 			continue;
 
-		if (esw_attr->dests[out_index].flags &
-		    MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE &&
-		    !esw_attr->dest_int_port)
-			*vf_tun = true;
-
 		mlx5e_detach_encap(priv, flow, attr, out_index);
 		kfree(attr->parse_attr->tun_info[out_index]);
 	}
@@ -2039,7 +2032,6 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5_flow_attr *attr = flow->attr;
 	struct mlx5_esw_flow_attr *esw_attr;
-	bool vf_tun;
 
 	esw_attr = attr->esw_attr;
 	mlx5e_put_flow_tunnel_id(flow);
@@ -2061,7 +2053,7 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	if (flow->decap_route)
 		mlx5e_detach_decap_route(priv, flow);
 
-	clean_encap_dests(priv, flow, attr, &vf_tun);
+	clean_encap_dests(priv, flow, attr);
 
 	mlx5_tc_ct_match_del(get_ct_priv(priv), &flow->attr->ct_attr);
 
@@ -4445,7 +4437,6 @@ static void
 mlx5_free_flow_attr(struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *attr)
 {
 	struct mlx5_core_dev *counter_dev = get_flow_counter_dev(flow);
-	bool vf_tun;
 
 	if (!attr)
 		return;
@@ -4453,7 +4444,7 @@ mlx5_free_flow_attr(struct mlx5e_tc_flow *flow, struct mlx5_flow_attr *attr)
 	if (attr->post_act_handle)
 		mlx5e_tc_post_act_del(get_post_action(flow->priv), attr->post_act_handle);
 
-	clean_encap_dests(flow->priv, flow, attr, &vf_tun);
+	clean_encap_dests(flow->priv, flow, attr);
 
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_COUNT)
 		mlx5_fc_destroy(counter_dev, attr->counter);
-- 
2.39.2

