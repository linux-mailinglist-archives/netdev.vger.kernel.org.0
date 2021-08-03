Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE753DE45F
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 04:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbhHCC3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 22:29:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233660AbhHCC3M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 22:29:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DFEE6056B;
        Tue,  3 Aug 2021 02:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627957741;
        bh=DYQBe9xGqm8tdqbLRQcptDiawJLPk3DBKJI5i6UF4sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XBiTisMAfJbI4Uin17R3scLLToDSJqcOS5GOBrDIn6qj0QerGMZLS+v1GQpTsJ69j
         KnBxVq797FS0a/Q5rTo8P6aBKhaAqFDQX4XAIkGZwqGdccmg1qvijw/xRxYiglSBQo
         6wre+stCrLQK9iezPWXujIQQSkkT6DZ7YCPpq9EiEQIqk08FITI1wmebXT4auj+sIR
         Xw8OmS1qSa1KToR6q3EY0b+AhVsOgelYUtgUarVkpnJWRv8tNMA+b5TvIWILQYYHGM
         ciN+JBY1psxvSoKEr4q9e9dPk6eZAvZxuPEiFoS9vyHGr9PhX5CVUAoiqvVR07MFxi
         hvKg/KauxYRYw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/16] net/mlx5e: Rename some related TTC args and functions
Date:   Mon,  2 Aug 2021 19:28:43 -0700
Message-Id: <20210803022853.106973-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803022853.106973-1-saeed@kernel.org>
References: <20210803022853.106973-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

Since TTC logic is going to be moved to a separate file, make the
relevant functions and arguments that used by TTC to be mlx5 generic.

Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  4 +-
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   | 41 ++++++++++---------
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 +-
 3 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 77fe98c42ec4..6b01a28e1d93 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -104,7 +104,7 @@ enum mlx5_tunnel_types {
 	MLX5_NUM_TUNNEL_TT,
 };
 
-bool mlx5e_tunnel_inner_ft_supported(struct mlx5_core_dev *mdev);
+bool mlx5_tunnel_inner_ft_supported(struct mlx5_core_dev *mdev);
 
 struct mlx5e_ttc_rule {
 	struct mlx5_flow_handle *rule;
@@ -266,7 +266,7 @@ void mlx5e_disable_cvlan_filter(struct mlx5e_priv *priv);
 int mlx5e_create_flow_steering(struct mlx5e_priv *priv);
 void mlx5e_destroy_flow_steering(struct mlx5e_priv *priv);
 
-u8 mlx5e_get_proto_by_tunnel_type(enum mlx5_tunnel_types tt);
+u8 mlx5_get_proto_by_tunnel_type(enum mlx5_tunnel_types tt);
 int mlx5e_add_vlan_trap(struct mlx5e_priv *priv, int  trap_id, int tir_num);
 void mlx5e_remove_vlan_trap(struct mlx5e_priv *priv);
 int mlx5e_add_mac_trap(struct mlx5e_priv *priv, int  trap_id, int tir_num);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 65bc1b745bb8..14a9011ea1a1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -873,12 +873,12 @@ static void mlx5e_cleanup_ttc_rules(struct mlx5e_ttc_table *ttc)
 	}
 }
 
-struct mlx5e_etype_proto {
+struct mlx5_etype_proto {
 	u16 etype;
 	u8 proto;
 };
 
-static struct mlx5e_etype_proto ttc_rules[] = {
+static struct mlx5_etype_proto ttc_rules[] = {
 	[MLX5_TT_IPV4_TCP] = {
 		.etype = ETH_P_IP,
 		.proto = IPPROTO_TCP,
@@ -925,7 +925,7 @@ static struct mlx5e_etype_proto ttc_rules[] = {
 	},
 };
 
-static struct mlx5e_etype_proto ttc_tunnel_rules[] = {
+static struct mlx5_etype_proto ttc_tunnel_rules[] = {
 	[MLX5_TT_IPV4_GRE] = {
 		.etype = ETH_P_IP,
 		.proto = IPPROTO_GRE,
@@ -953,12 +953,13 @@ static struct mlx5e_etype_proto ttc_tunnel_rules[] = {
 
 };
 
-u8 mlx5e_get_proto_by_tunnel_type(enum mlx5_tunnel_types tt)
+u8 mlx5_get_proto_by_tunnel_type(enum mlx5_tunnel_types tt)
 {
 	return ttc_tunnel_rules[tt].proto;
 }
 
-static bool mlx5e_tunnel_proto_supported_rx(struct mlx5_core_dev *mdev, u8 proto_type)
+static bool mlx5_tunnel_proto_supported_rx(struct mlx5_core_dev *mdev,
+					   u8 proto_type)
 {
 	switch (proto_type) {
 	case IPPROTO_GRE:
@@ -972,24 +973,26 @@ static bool mlx5e_tunnel_proto_supported_rx(struct mlx5_core_dev *mdev, u8 proto
 	}
 }
 
-static bool mlx5e_tunnel_any_rx_proto_supported(struct mlx5_core_dev *mdev)
+static bool mlx5_tunnel_any_rx_proto_supported(struct mlx5_core_dev *mdev)
 {
 	int tt;
 
 	for (tt = 0; tt < MLX5_NUM_TUNNEL_TT; tt++) {
-		if (mlx5e_tunnel_proto_supported_rx(mdev, ttc_tunnel_rules[tt].proto))
+		if (mlx5_tunnel_proto_supported_rx(mdev,
+						   ttc_tunnel_rules[tt].proto))
 			return true;
 	}
 	return false;
 }
 
-bool mlx5e_tunnel_inner_ft_supported(struct mlx5_core_dev *mdev)
+bool mlx5_tunnel_inner_ft_supported(struct mlx5_core_dev *mdev)
 {
-	return (mlx5e_tunnel_any_rx_proto_supported(mdev) &&
-		MLX5_CAP_FLOWTABLE_NIC_RX(mdev, ft_field_support.inner_ip_version));
+	return (mlx5_tunnel_any_rx_proto_supported(mdev) &&
+		MLX5_CAP_FLOWTABLE_NIC_RX(mdev,
+					  ft_field_support.inner_ip_version));
 }
 
-static u8 mlx5e_etype_to_ipv(u16 ethertype)
+static u8 mlx5_etype_to_ipv(u16 ethertype)
 {
 	if (ethertype == ETH_P_IP)
 		return 4;
@@ -1024,7 +1027,7 @@ mlx5e_generate_ttc_rule(struct mlx5e_priv *priv,
 		MLX5_SET(fte_match_param, spec->match_value, outer_headers.ip_protocol, proto);
 	}
 
-	ipv = mlx5e_etype_to_ipv(etype);
+	ipv = mlx5_etype_to_ipv(etype);
 	if (match_ipv_outer && ipv) {
 		spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
 		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ip_version);
@@ -1079,15 +1082,15 @@ static int mlx5e_generate_ttc_table_rules(struct mlx5e_priv *priv,
 		rule->default_dest = dest;
 	}
 
-	if (!params->inner_ttc || !mlx5e_tunnel_inner_ft_supported(priv->mdev))
+	if (!params->inner_ttc || !mlx5_tunnel_inner_ft_supported(priv->mdev))
 		return 0;
 
 	trules    = ttc->tunnel_rules;
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest.ft = params->inner_ttc->ft.t;
 	for (tt = 0; tt < MLX5_NUM_TUNNEL_TT; tt++) {
-		if (!mlx5e_tunnel_proto_supported_rx(priv->mdev,
-						     ttc_tunnel_rules[tt].proto))
+		if (!mlx5_tunnel_proto_supported_rx(priv->mdev,
+						    ttc_tunnel_rules[tt].proto))
 			continue;
 		trules[tt] = mlx5e_generate_ttc_rule(priv, ft, &dest,
 						     ttc_tunnel_rules[tt].etype,
@@ -1190,7 +1193,7 @@ mlx5e_generate_inner_ttc_rule(struct mlx5e_priv *priv,
 	if (!spec)
 		return ERR_PTR(-ENOMEM);
 
-	ipv = mlx5e_etype_to_ipv(etype);
+	ipv = mlx5_etype_to_ipv(etype);
 	if (etype && ipv) {
 		spec->match_criteria_enable = MLX5_MATCH_INNER_HEADERS;
 		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, inner_headers.ip_version);
@@ -1783,7 +1786,7 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 
 	mlx5e_set_ttc_basic_params(priv, &ttc_params);
 
-	if (mlx5e_tunnel_inner_ft_supported(priv->mdev)) {
+	if (mlx5_tunnel_inner_ft_supported(priv->mdev)) {
 		mlx5e_set_inner_ttc_ft_params(&ttc_params);
 		for (tt = 0; tt < MLX5E_NUM_INDIR_TIRS; tt++)
 			ttc_params.indir_tirn[tt] =
@@ -1837,7 +1840,7 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 err_destroy_ttc_table:
 	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
 err_destroy_inner_ttc_table:
-	if (mlx5e_tunnel_inner_ft_supported(priv->mdev))
+	if (mlx5_tunnel_inner_ft_supported(priv->mdev))
 		mlx5e_destroy_inner_ttc_table(priv, &priv->fs.inner_ttc);
 err_destroy_arfs_tables:
 	mlx5e_arfs_destroy_tables(priv);
@@ -1851,7 +1854,7 @@ void mlx5e_destroy_flow_steering(struct mlx5e_priv *priv)
 	mlx5e_destroy_vlan_table(priv);
 	mlx5e_destroy_l2_table(priv);
 	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
-	if (mlx5e_tunnel_inner_ft_supported(priv->mdev))
+	if (mlx5_tunnel_inner_ft_supported(priv->mdev))
 		mlx5e_destroy_inner_ttc_table(priv, &priv->fs.inner_ttc);
 	mlx5e_arfs_destroy_tables(priv);
 	mlx5e_ethtool_cleanup_steering(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c1469f5755b5..25a0b5f0984a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4151,7 +4151,7 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
 	/* TX inline */
 	mlx5_query_min_inline(mdev, &params->tx_min_inline_mode);
 
-	params->tunneled_offload_en = mlx5e_tunnel_inner_ft_supported(mdev);
+	params->tunneled_offload_en = mlx5_tunnel_inner_ft_supported(mdev);
 
 	/* AF_XDP */
 	params->xsk = xsk;
@@ -4212,7 +4212,7 @@ static bool mlx5e_tunnel_any_tx_proto_supported(struct mlx5_core_dev *mdev)
 	int tt;
 
 	for (tt = 0; tt < MLX5_NUM_TUNNEL_TT; tt++) {
-		if (mlx5e_tunnel_proto_supported_tx(mdev, mlx5e_get_proto_by_tunnel_type(tt)))
+		if (mlx5e_tunnel_proto_supported_tx(mdev, mlx5_get_proto_by_tunnel_type(tt)))
 			return true;
 	}
 	return (mlx5_vxlan_allowed(mdev->vxlan) || mlx5_geneve_tx_allowed(mdev));
-- 
2.31.1

