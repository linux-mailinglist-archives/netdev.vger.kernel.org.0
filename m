Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B02359D0D6
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 07:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240427AbiHWF4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 01:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240414AbiHWFzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 01:55:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D8B5F216
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 22:55:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 163D46144E
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBD9C433D6;
        Tue, 23 Aug 2022 05:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661234151;
        bh=NoKw4Bx/+0vCI0tKQXGdXJE5xDMEfOXbG/PufxDgFbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZlzgC7s0eVqH7TGXmSaJWsXXXuHJpb2Kaon+thb7aSNJhL5n+zKH8bKefRGNaTEiK
         ISVo6iNWkHM0awTnx15OkxuEnFMvKF/NIc2eH/FVmvNWr4+/yY7EHIzR2s0ub/P/wf
         Om90Y8up+gZ2/dUl3y5G5m+uRp+TiwhWxxvjR81ahX3Fafi8uLfeuA5Q0vk64lUypT
         Z+auLE37HvMJK5Mbyey3icBUT8u6PvhVTzvFSkC5+BJrHjee5NQni3L23BzBYuost3
         9kWCVh8URrLb5DQFsbzdjjDoXOzsNO85Kk/GPMizauKUbGh8MAuNG2uIyFS5U+gu17
         lqpWqawNrP99w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lama Kayal <lkayal@nvidia.com>
Subject: [net-next 08/15] net/mlx5e: Introduce flow steering debug macros
Date:   Mon, 22 Aug 2022 22:55:26 -0700
Message-Id: <20220823055533.334471-9-saeed@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220823055533.334471-1-saeed@kernel.org>
References: <20220823055533.334471-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lama Kayal <lkayal@nvidia.com>

Introduce flow steering debug macros family, fs_*.
These macros bring clean finish to the decoupling of flow steering
process such that all flow steering flows can report warnings and
provide debug information via these exclusive macros.

Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   | 13 ++++
 .../mellanox/mlx5/core/en/fs_tt_redirect.c    | 40 +++++------
 .../mellanox/mlx5/core/en_accel/fs_tcp.c      | 33 +++++-----
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   | 66 +++++++++----------
 4 files changed, 76 insertions(+), 76 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 6d26a5415afc..66f71813702e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -176,5 +176,18 @@ int mlx5e_fs_vlan_rx_kill_vid(struct mlx5e_flow_steering *fs,
 			      struct net_device *netdev,
 			      __be16 proto, u16 vid);
 void mlx5e_fs_init_l2_addr(struct mlx5e_flow_steering *fs, struct net_device *netdev);
+
+#define fs_err(fs, fmt, ...) \
+	mlx5_core_err(mlx5e_fs_get_mdev(fs), fmt, ##__VA_ARGS__)
+
+#define fs_dbg(fs, fmt, ...) \
+	mlx5_core_dbg(mlx5e_fs_get_mdev(fs), fmt, ##__VA_ARGS__)
+
+#define fs_warn(fs, fmt, ...) \
+	mlx5_core_warn(mlx5e_fs_get_mdev(fs), fmt, ##__VA_ARGS__)
+
+#define fs_warn_once(fs, fmt, ...) \
+	mlx5_core_warn_once(mlx5e_fs_get_mdev(fs), fmt, ##__VA_ARGS__)
+
 #endif /* __MLX5E_FLOW_STEER_H__ */
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
index db731019bb11..03cb79adf912 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
@@ -105,8 +105,8 @@ mlx5e_fs_tt_redirect_udp_add_rule(struct mlx5e_flow_steering *fs,
 
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
-		mlx5_core_err(mlx5e_fs_get_mdev(fs), "%s: add %s rule failed, err %d\n",
-			      __func__, fs_udp_type2str(type), err);
+		fs_err(fs, "%s: add %s rule failed, err %d\n",
+		       __func__, fs_udp_type2str(type), err);
 	}
 	return rule;
 }
@@ -127,9 +127,8 @@ static int fs_udp_add_default_rule(struct mlx5e_flow_steering *fs, enum fs_udp_t
 	rule = mlx5_add_flow_rules(fs_udp_t->t, NULL, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
-		mlx5_core_err(mlx5e_fs_get_mdev(fs),
-			      "%s: add default rule failed, fs type=%d, err %d\n",
-			      __func__, type, err);
+		fs_err(fs, "%s: add default rule failed, fs type=%d, err %d\n",
+		       __func__, type, err);
 		return err;
 	}
 
@@ -264,9 +263,8 @@ static int fs_udp_disable(struct mlx5e_flow_steering *fs)
 		/* Modify ttc rules destination to point back to the indir TIRs */
 		err = mlx5_ttc_fwd_default_dest(ttc, fs_udp2tt(i));
 		if (err) {
-			mlx5_core_err(mlx5e_fs_get_mdev(fs),
-				      "%s: modify ttc[%d] default destination failed, err(%d)\n",
-				      __func__, fs_udp2tt(i), err);
+			fs_err(fs, "%s: modify ttc[%d] default destination failed, err(%d)\n",
+			       __func__, fs_udp2tt(i), err);
 			return err;
 		}
 	}
@@ -288,9 +286,8 @@ static int fs_udp_enable(struct mlx5e_flow_steering *fs)
 		/* Modify ttc rules destination to point on the accel_fs FTs */
 		err = mlx5_ttc_fwd_dest(ttc, fs_udp2tt(i), &dest);
 		if (err) {
-			mlx5_core_err(mlx5e_fs_get_mdev(fs),
-				      "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
-				      __func__, fs_udp2tt(i), err);
+			fs_err(fs, "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
+			       __func__, fs_udp2tt(i), err);
 			return err;
 		}
 	}
@@ -389,8 +386,8 @@ mlx5e_fs_tt_redirect_any_add_rule(struct mlx5e_flow_steering *fs,
 
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
-		mlx5_core_err(mlx5e_fs_get_mdev(fs), "%s: add ANY rule failed, err %d\n",
-			      __func__, err);
+		fs_err(fs, "%s: add ANY rule failed, err %d\n",
+		       __func__, err);
 	}
 	return rule;
 }
@@ -410,9 +407,8 @@ static int fs_any_add_default_rule(struct mlx5e_flow_steering *fs)
 	rule = mlx5_add_flow_rules(fs_any_t->t, NULL, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
-		mlx5_core_err(mlx5e_fs_get_mdev(fs),
-			      "%s: add default rule failed, fs type=ANY, err %d\n",
-			      __func__, err);
+		fs_err(fs, "%s: add default rule failed, fs type=ANY, err %d\n",
+		       __func__, err);
 		return err;
 	}
 
@@ -524,9 +520,9 @@ static int fs_any_disable(struct mlx5e_flow_steering *fs)
 	/* Modify ttc rules destination to point back to the indir TIRs */
 	err = mlx5_ttc_fwd_default_dest(ttc, MLX5_TT_ANY);
 	if (err) {
-		mlx5_core_err(mlx5e_fs_get_mdev(fs),
-			      "%s: modify ttc[%d] default destination failed, err(%d)\n",
-			      __func__, MLX5_TT_ANY, err);
+		fs_err(fs,
+		       "%s: modify ttc[%d] default destination failed, err(%d)\n",
+		       __func__, MLX5_TT_ANY, err);
 		return err;
 	}
 	return 0;
@@ -545,9 +541,9 @@ static int fs_any_enable(struct mlx5e_flow_steering *fs)
 	/* Modify ttc rules destination to point on the accel_fs FTs */
 	err = mlx5_ttc_fwd_dest(ttc, MLX5_TT_ANY, &dest);
 	if (err) {
-		mlx5_core_err(mlx5e_fs_get_mdev(fs),
-			      "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
-			      __func__, MLX5_TT_ANY, err);
+		fs_err(fs,
+		       "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
+		       __func__, MLX5_TT_ANY, err);
 		return err;
 	}
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index 7f0564ab95eb..285d32d2fd08 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -92,11 +92,11 @@ struct mlx5_flow_handle *mlx5e_accel_fs_add_sk(struct mlx5e_flow_steering *fs,
 	case AF_INET:
 		accel_fs_tcp_set_ipv4_flow(spec, sk);
 		ft = &fs_tcp->tables[ACCEL_FS_IPV4_TCP];
-		mlx5_core_dbg(mlx5e_fs_get_mdev(fs), "%s flow is %pI4:%d -> %pI4:%d\n", __func__,
-			      &inet_sk(sk)->inet_rcv_saddr,
-			      inet_sk(sk)->inet_sport,
-			      &inet_sk(sk)->inet_daddr,
-			      inet_sk(sk)->inet_dport);
+		fs_dbg(fs, "%s flow is %pI4:%d -> %pI4:%d\n", __func__,
+		       &inet_sk(sk)->inet_rcv_saddr,
+		       inet_sk(sk)->inet_sport,
+		       &inet_sk(sk)->inet_daddr,
+		       inet_sk(sk)->inet_dport);
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6:
@@ -138,8 +138,7 @@ struct mlx5_flow_handle *mlx5e_accel_fs_add_sk(struct mlx5e_flow_steering *fs,
 	flow = mlx5_add_flow_rules(ft->t, spec, &flow_act, &dest, 1);
 
 	if (IS_ERR(flow))
-		mlx5_core_err(mlx5e_fs_get_mdev(fs), "mlx5_add_flow_rules() failed, flow is %ld\n",
-			      PTR_ERR(flow));
+		fs_err(fs, "mlx5_add_flow_rules() failed, flow is %ld\n", PTR_ERR(flow));
 
 out:
 	kvfree(spec);
@@ -163,9 +162,8 @@ static int accel_fs_tcp_add_default_rule(struct mlx5e_flow_steering *fs,
 	rule = mlx5_add_flow_rules(accel_fs_t->t, NULL, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
-		mlx5_core_err(mlx5e_fs_get_mdev(fs),
-			      "%s: add default rule failed, accel_fs type=%d, err %d\n",
-			      __func__, type, err);
+		fs_err(fs, "%s: add default rule failed, accel_fs type=%d, err %d\n",
+		       __func__, type, err);
 		return err;
 	}
 
@@ -284,8 +282,8 @@ static int accel_fs_tcp_create_table(struct mlx5e_flow_steering *fs, enum accel_
 		return err;
 	}
 
-	mlx5_core_dbg(mlx5e_fs_get_mdev(fs), "Created fs accel table id %u level %u\n",
-		      ft->t->id, ft->t->level);
+	fs_dbg(fs, "Created fs accel table id %u level %u\n",
+	       ft->t->id, ft->t->level);
 
 	err = accel_fs_tcp_create_groups(ft, type);
 	if (err)
@@ -310,9 +308,9 @@ static int accel_fs_tcp_disable(struct mlx5e_flow_steering *fs)
 		/* Modify ttc rules destination to point back to the indir TIRs */
 		err = mlx5_ttc_fwd_default_dest(ttc, fs_accel2tt(i));
 		if (err) {
-			mlx5_core_err(mlx5e_fs_get_mdev(fs),
-				      "%s: modify ttc[%d] default destination failed, err(%d)\n",
-				      __func__, fs_accel2tt(i), err);
+			fs_err(fs,
+			       "%s: modify ttc[%d] default destination failed, err(%d)\n",
+			       __func__, fs_accel2tt(i), err);
 			return err;
 		}
 	}
@@ -334,9 +332,8 @@ static int accel_fs_tcp_enable(struct mlx5e_flow_steering *fs)
 		/* Modify ttc rules destination to point on the accel_fs FTs */
 		err = mlx5_ttc_fwd_dest(ttc, fs_accel2tt(i), &dest);
 		if (err) {
-			mlx5_core_err(mlx5e_fs_get_mdev(fs),
-				      "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
-				      __func__, fs_accel2tt(i), err);
+			fs_err(fs, "%s: modify ttc[%d] destination to accel failed, err(%d)\n",
+			       __func__, fs_accel2tt(i), err);
 			return err;
 		}
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 71d9eab49ec5..734faf7e821d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -177,9 +177,8 @@ static int mlx5e_vport_context_update_vlans(struct mlx5e_flow_steering *fs)
 	max_list_size = 1 << MLX5_CAP_GEN(fs->mdev, log_max_vlan_list);
 
 	if (list_size > max_list_size) {
-		mlx5_core_warn(fs->mdev,
-			       "netdev vlans list size (%d) > (%d) max vport list size, some vlans will be dropped\n",
-			       list_size, max_list_size);
+		fs_warn(fs, "netdev vlans list size (%d) > (%d) max vport list size, some vlans will be dropped\n",
+			list_size, max_list_size);
 		list_size = max_list_size;
 	}
 
@@ -196,8 +195,8 @@ static int mlx5e_vport_context_update_vlans(struct mlx5e_flow_steering *fs)
 
 	err = mlx5_modify_nic_vport_vlans(fs->mdev, vlans, list_size);
 	if (err)
-		mlx5_core_err(fs->mdev, "Failed to modify vport vlans list err(%d)\n",
-			      err);
+		fs_err(fs, "Failed to modify vport vlans list err(%d)\n",
+		       err);
 
 	kvfree(vlans);
 	return err;
@@ -278,7 +277,7 @@ static int __mlx5e_add_vlan_rule(struct mlx5e_flow_steering *fs,
 	if (IS_ERR(*rule_p)) {
 		err = PTR_ERR(*rule_p);
 		*rule_p = NULL;
-		mlx5_core_err(fs->mdev, "%s: add rule failed\n", __func__);
+		fs_err(fs, "%s: add rule failed\n", __func__);
 	}
 
 	return err;
@@ -390,8 +389,8 @@ int mlx5e_add_vlan_trap(struct mlx5e_priv *priv, int trap_id, int tir_num)
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		priv->fs->vlan->trap_rule = NULL;
-		mlx5_core_err(priv->fs->mdev, "%s: add VLAN trap rule failed, err %d\n",
-			      __func__, err);
+		fs_err(priv->fs, "%s: add VLAN trap rule failed, err %d\n",
+		       __func__, err);
 		return err;
 	}
 	priv->fs->vlan->trap_rule = rule;
@@ -416,8 +415,8 @@ int mlx5e_add_mac_trap(struct mlx5e_priv *priv, int trap_id, int tir_num)
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		priv->fs->l2.trap_rule = NULL;
-		mlx5_core_err(priv->fs->mdev, "%s: add MAC trap rule failed, err %d\n",
-			      __func__, err);
+		fs_err(priv->fs, "%s: add MAC trap rule failed, err %d\n",
+		       __func__, err);
 		return err;
 	}
 	priv->fs->l2.trap_rule = rule;
@@ -491,7 +490,7 @@ int mlx5e_fs_vlan_rx_add_vid(struct mlx5e_flow_steering *fs,
 {
 
 	if (!fs->vlan) {
-		mlx5_core_err(fs->mdev, "Vlan doesn't exist\n");
+		fs_err(fs, "Vlan doesn't exist\n");
 		return -EINVAL;
 	}
 
@@ -508,7 +507,7 @@ int mlx5e_fs_vlan_rx_kill_vid(struct mlx5e_flow_steering *fs,
 			      __be16 proto, u16 vid)
 {
 	if (!fs->vlan) {
-		mlx5_core_err(fs->mdev, "Vlan doesn't exist\n");
+		fs_err(fs, "Vlan doesn't exist\n");
 		return -EINVAL;
 	}
 
@@ -597,8 +596,9 @@ static void mlx5e_execute_l2_action(struct mlx5e_flow_steering *fs,
 	}
 
 	if (l2_err)
-		mlx5_core_warn(fs->mdev, "MPFS, failed to %s mac %pM, err(%d)\n",
-			       action == MLX5E_ACTION_ADD ? "add" : "del", mac_addr, l2_err);
+		fs_warn(fs, "MPFS, failed to %s mac %pM, err(%d)\n",
+			action == MLX5E_ACTION_ADD ? "add" : "del",
+			mac_addr, l2_err);
 }
 
 static void mlx5e_sync_netdev_addr(struct mlx5e_flow_steering *fs,
@@ -669,9 +669,8 @@ static void mlx5e_vport_context_update_addr_list(struct mlx5e_flow_steering *fs,
 		size++;
 
 	if (size > max_size) {
-		mlx5_core_warn(fs->mdev,
-			       "mdev %s list size (%d) > (%d) max vport list size, some addresses will be dropped\n",
-			      is_uc ? "UC" : "MC", size, max_size);
+		fs_warn(fs, "mdev %s list size (%d) > (%d) max vport list size, some addresses will be dropped\n",
+			is_uc ? "UC" : "MC", size, max_size);
 		size = max_size;
 	}
 
@@ -687,9 +686,8 @@ static void mlx5e_vport_context_update_addr_list(struct mlx5e_flow_steering *fs,
 	err = mlx5_modify_nic_vport_mac_list(fs->mdev, list_type, addr_array, size);
 out:
 	if (err)
-		mlx5_core_err(fs->mdev,
-			      "Failed to modify vport %s list err(%d)\n",
-			      is_uc ? "UC" : "MC", err);
+		fs_err(fs, "Failed to modify vport %s list err(%d)\n",
+		       is_uc ? "UC" : "MC", err);
 	kfree(addr_array);
 }
 
@@ -759,7 +757,7 @@ static int mlx5e_add_promisc_rule(struct mlx5e_flow_steering *fs)
 	if (IS_ERR(*rule_p)) {
 		err = PTR_ERR(*rule_p);
 		*rule_p = NULL;
-		mlx5_core_err(fs->mdev, "%s: add promiscuous rule failed\n", __func__);
+		fs_err(fs, "%s: add promiscuous rule failed\n", __func__);
 	}
 	kvfree(spec);
 	return err;
@@ -779,7 +777,7 @@ static int mlx5e_create_promisc_table(struct mlx5e_flow_steering *fs)
 	ft->t = mlx5_create_auto_grouped_flow_table(fs->ns, &ft_attr);
 	if (IS_ERR(ft->t)) {
 		err = PTR_ERR(ft->t);
-		mlx5_core_err(fs->mdev, "fail to create promisc table err=%d\n", err);
+		fs_err(fs, "fail to create promisc table err=%d\n", err);
 		return err;
 	}
 
@@ -836,8 +834,8 @@ void mlx5e_fs_set_rx_mode_work(struct mlx5e_flow_steering *fs,
 		if (err)
 			enable_promisc = false;
 		if (!fs->vlan_strip_disable && !err)
-			mlx5_core_warn_once(fs->mdev,
-					    "S-tagged traffic will be dropped while C-tag vlan stripping is enabled\n");
+			fs_warn_once(fs,
+				     "S-tagged traffic will be dropped while C-tag vlan stripping is enabled\n");
 	}
 	if (enable_allmulti)
 		mlx5e_add_l2_flow_rule(fs, &ea->allmulti, MLX5E_ALLMULTI);
@@ -988,8 +986,7 @@ static int mlx5e_add_l2_flow_rule(struct mlx5e_flow_steering *fs,
 
 	ai->rule = mlx5_add_flow_rules(ft, spec, &flow_act, &dest, 1);
 	if (IS_ERR(ai->rule)) {
-		mlx5_core_err(fs->mdev, "%s: add l2 rule(mac:%pM) failed\n",
-			      __func__, mv_dmac);
+		fs_err(fs, "%s: add l2 rule(mac:%pM) failed\n", __func__, mv_dmac);
 		err = PTR_ERR(ai->rule);
 		ai->rule = NULL;
 	}
@@ -1298,6 +1295,8 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 {
 	struct mlx5_flow_namespace *ns = mlx5_get_flow_namespace(priv->fs->mdev,
 								 MLX5_FLOW_NAMESPACE_KERNEL);
+	struct mlx5e_flow_steering *fs = priv->fs;
+
 	int err;
 
 	if (!ns)
@@ -1306,36 +1305,31 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 	mlx5e_fs_set_ns(priv->fs, ns, false);
 	err = mlx5e_arfs_create_tables(priv);
 	if (err) {
-		mlx5_core_err(priv->fs->mdev, "Failed to create arfs tables, err=%d\n",
-			      err);
+		fs_err(fs, "Failed to create arfs tables, err=%d\n", err);
 		priv->netdev->hw_features &= ~NETIF_F_NTUPLE;
 	}
 
 	err = mlx5e_create_inner_ttc_table(priv);
 	if (err) {
-		mlx5_core_err(priv->fs->mdev,
-			      "Failed to create inner ttc table, err=%d\n", err);
+		fs_err(fs, "Failed to create inner ttc table, err=%d\n", err);
 		goto err_destroy_arfs_tables;
 	}
 
 	err = mlx5e_create_ttc_table(priv);
 	if (err) {
-		mlx5_core_err(priv->fs->mdev, "Failed to create ttc table, err=%d\n",
-			      err);
+		fs_err(fs, "Failed to create ttc table, err=%d\n", err);
 		goto err_destroy_inner_ttc_table;
 	}
 
 	err = mlx5e_create_l2_table(priv);
 	if (err) {
-		mlx5_core_err(priv->fs->mdev, "Failed to create l2 table, err=%d\n",
-			      err);
+		fs_err(fs, "Failed to create l2 table, err=%d\n", err);
 		goto err_destroy_ttc_table;
 	}
 
 	err = mlx5e_fs_create_vlan_table(priv->fs);
 	if (err) {
-		mlx5_core_err(priv->fs->mdev, "Failed to create vlan table, err=%d\n",
-			      err);
+		fs_err(fs, "Failed to create vlan table, err=%d\n", err);
 		goto err_destroy_l2_table;
 	}
 
-- 
2.37.1

