Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4A8640EE8
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234410AbiLBULJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbiLBULF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:11:05 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD5EBE126
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:11:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C4635CE1FA5
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8507AC433C1;
        Fri,  2 Dec 2022 20:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670011860;
        bh=xzxiK7zwX7e0BR4TIgxLs6ousyvgr9Nx+R7Pa40ZvcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tSvuUO3ny6c74AH9qVqmRgTSDT3VwgafloYfxYMlvpv93j1ej/BDHRpyAGWsSL/Ty
         FtynOBeUvQ0ZIyl7eiGUpiGwTX4gUGG3+1KQxDxpUpRp+Soc0km99RuNyfM4FfqBie
         VjimuOb3QmcQWok+KAw/3PwEzkQnKGkAMvS1RGYXAzPquan3Q3IfVt9tDlPRRoUFVc
         qdWVCvrW6a1biPP/Bh1cgQgNBJ0U/XoYwlL8YahYG/BbYdoha2oeOKP37uBnhApvCn
         SXGGL7Ul9ky9W5RtQC/4m+jVNhSJ3gO0J37OOw67baaiBwbwmvA9NwtShajtcI/dSI
         l32pZPN/6qdhg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH xfrm-next 05/16] net/mlx5e: Remove extra layers of defines
Date:   Fri,  2 Dec 2022 22:10:26 +0200
Message-Id: <21697336425b13c8c5765d392b4400270859a4b9.1670011671.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670011671.git.leonro@nvidia.com>
References: <cover.1670011671.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Instead of performing redefinition of XFRM core defines to same
values but with MLX5_* prefix, cache the input values as is by making
sure that the proper storage objects are used.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 17 ++++-----------
 .../mellanox/mlx5/core/en_accel/ipsec.h       | 18 ++++------------
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 21 ++++++++++---------
 .../mlx5/core/en_accel/ipsec_offload.c        | 10 ++++-----
 4 files changed, 23 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 734b486db5d6..14ed72b26bbe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -162,29 +162,20 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 
 	/* esn */
 	if (sa_entry->esn_state.trigger) {
-		attrs->flags |= MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED;
+		attrs->esn_trigger = true;
 		attrs->esn = sa_entry->esn_state.esn;
-		if (sa_entry->esn_state.overlap)
-			attrs->flags |= MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP;
+		attrs->esn_overlap = sa_entry->esn_state.overlap;
 		attrs->replay_window = x->replay_esn->replay_window;
 	}
 
-	/* action */
-	attrs->action = (x->xso.dir == XFRM_DEV_OFFLOAD_OUT) ?
-				MLX5_ACCEL_ESP_ACTION_ENCRYPT :
-				      MLX5_ACCEL_ESP_ACTION_DECRYPT;
-	/* flags */
-	attrs->flags |= (x->props.mode == XFRM_MODE_TRANSPORT) ?
-			MLX5_ACCEL_ESP_FLAGS_TRANSPORT :
-			MLX5_ACCEL_ESP_FLAGS_TUNNEL;
-
+	attrs->dir = x->xso.dir;
 	/* spi */
 	attrs->spi = be32_to_cpu(x->id.spi);
 
 	/* source , destination ips */
 	memcpy(&attrs->saddr, x->props.saddr.a6, sizeof(attrs->saddr));
 	memcpy(&attrs->daddr, x->id.daddr.a6, sizeof(attrs->daddr));
-	attrs->is_ipv6 = (x->props.family != AF_INET);
+	attrs->family = x->props.family;
 }
 
 static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 6fe55675bee9..05790b7d062f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -43,18 +43,6 @@
 #define MLX5E_IPSEC_SADB_RX_BITS 10
 #define MLX5E_IPSEC_ESN_SCOPE_MID 0x80000000L
 
-enum mlx5_accel_esp_flags {
-	MLX5_ACCEL_ESP_FLAGS_TUNNEL            = 0,    /* Default */
-	MLX5_ACCEL_ESP_FLAGS_TRANSPORT         = 1UL << 0,
-	MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED     = 1UL << 1,
-	MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP = 1UL << 2,
-};
-
-enum mlx5_accel_esp_action {
-	MLX5_ACCEL_ESP_ACTION_DECRYPT,
-	MLX5_ACCEL_ESP_ACTION_ENCRYPT,
-};
-
 struct aes_gcm_keymat {
 	u64   seq_iv;
 
@@ -66,7 +54,6 @@ struct aes_gcm_keymat {
 };
 
 struct mlx5_accel_esp_xfrm_attrs {
-	enum mlx5_accel_esp_action action;
 	u32   esn;
 	u32   spi;
 	u32   flags;
@@ -82,7 +69,10 @@ struct mlx5_accel_esp_xfrm_attrs {
 		__be32 a6[4];
 	} daddr;
 
-	u8 is_ipv6;
+	u8 dir : 2;
+	u8 esn_overlap : 1;
+	u8 esn_trigger : 1;
+	u8 family;
 	u32 replay_window;
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index b859e4a4c744..886263228b5d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -341,7 +341,7 @@ static void setup_fte_common(struct mlx5_accel_esp_xfrm_attrs *attrs,
 			     struct mlx5_flow_spec *spec,
 			     struct mlx5_flow_act *flow_act)
 {
-	u8 ip_version = attrs->is_ipv6 ? 6 : 4;
+	u8 ip_version = (attrs->family == AF_INET) ? 4 : 6;
 
 	spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS | MLX5_MATCH_MISC_PARAMETERS;
 
@@ -411,7 +411,7 @@ static int rx_add_rule(struct mlx5e_priv *priv,
 	int err = 0;
 
 	accel_esp = priv->ipsec->rx_fs;
-	type = attrs->is_ipv6 ? ACCEL_FS_ESP6 : ACCEL_FS_ESP4;
+	type = (attrs->family == AF_INET) ? ACCEL_FS_ESP4 : ACCEL_FS_ESP6;
 	fs_prot = &accel_esp->fs_prot[type];
 
 	err = rx_ft_get(priv, type);
@@ -453,8 +453,8 @@ static int rx_add_rule(struct mlx5e_priv *priv,
 	rule = mlx5_add_flow_rules(fs_prot->ft, spec, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
-		netdev_err(priv->netdev, "fail to add ipsec rule attrs->action=0x%x, err=%d\n",
-			   attrs->action, err);
+		netdev_err(priv->netdev, "fail to add RX ipsec rule err=%d\n",
+			   err);
 		goto out_err;
 	}
 
@@ -505,8 +505,8 @@ static int tx_add_rule(struct mlx5e_priv *priv,
 	rule = mlx5_add_flow_rules(priv->ipsec->tx_fs->ft, spec, &flow_act, NULL, 0);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
-		netdev_err(priv->netdev, "fail to add ipsec rule attrs->action=0x%x, err=%d\n",
-				sa_entry->attrs.action, err);
+		netdev_err(priv->netdev, "fail to add TX ipsec rule err=%d\n",
+			   err);
 		goto out;
 	}
 
@@ -522,7 +522,7 @@ static int tx_add_rule(struct mlx5e_priv *priv,
 int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_priv *priv,
 				  struct mlx5e_ipsec_sa_entry *sa_entry)
 {
-	if (sa_entry->attrs.action == MLX5_ACCEL_ESP_ACTION_ENCRYPT)
+	if (sa_entry->attrs.dir == XFRM_DEV_OFFLOAD_OUT)
 		return tx_add_rule(priv, sa_entry);
 
 	return rx_add_rule(priv, sa_entry);
@@ -533,17 +533,18 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_priv *priv,
 {
 	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
+	enum accel_fs_esp_type type;
 
 	mlx5_del_flow_rules(ipsec_rule->rule);
 
-	if (sa_entry->attrs.action == MLX5_ACCEL_ESP_ACTION_ENCRYPT) {
+	if (sa_entry->attrs.dir == XFRM_DEV_OFFLOAD_OUT) {
 		tx_ft_put(priv);
 		return;
 	}
 
 	mlx5_modify_header_dealloc(mdev, ipsec_rule->set_modify_hdr);
-	rx_ft_put(priv,
-		  sa_entry->attrs.is_ipv6 ? ACCEL_FS_ESP6 : ACCEL_FS_ESP4);
+	type = (sa_entry->attrs.family == AF_INET) ? ACCEL_FS_ESP4 : ACCEL_FS_ESP6;
+	rx_ft_put(priv, type);
 }
 
 void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 3d5a1f875398..3f2aeb07ea84 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -72,11 +72,10 @@ static int mlx5_create_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
 	salt_iv_p = MLX5_ADDR_OF(ipsec_obj, obj, implicit_iv);
 	memcpy(salt_iv_p, &aes_gcm->seq_iv, sizeof(aes_gcm->seq_iv));
 	/* esn */
-	if (attrs->flags & MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED) {
+	if (attrs->esn_trigger) {
 		MLX5_SET(ipsec_obj, obj, esn_en, 1);
 		MLX5_SET(ipsec_obj, obj, esn_msb, attrs->esn);
-		if (attrs->flags & MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP)
-			MLX5_SET(ipsec_obj, obj, esn_overlap, 1);
+		MLX5_SET(ipsec_obj, obj, esn_overlap, attrs->esn_overlap);
 	}
 
 	MLX5_SET(ipsec_obj, obj, dekn, sa_entry->enc_key_id);
@@ -158,7 +157,7 @@ static int mlx5_modify_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry,
 	void *obj;
 	int err;
 
-	if (!(attrs->flags & MLX5_ACCEL_ESP_FLAGS_ESN_TRIGGERED))
+	if (!attrs->esn_trigger)
 		return 0;
 
 	general_obj_types = MLX5_CAP_GEN_64(mdev, general_obj_types);
@@ -189,8 +188,7 @@ static int mlx5_modify_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry,
 		   MLX5_MODIFY_IPSEC_BITMASK_ESN_OVERLAP |
 			   MLX5_MODIFY_IPSEC_BITMASK_ESN_MSB);
 	MLX5_SET(ipsec_obj, obj, esn_msb, attrs->esn);
-	if (attrs->flags & MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP)
-		MLX5_SET(ipsec_obj, obj, esn_overlap, 1);
+	MLX5_SET(ipsec_obj, obj, esn_overlap, attrs->esn_overlap);
 
 	/* general object fields set */
 	MLX5_SET(general_obj_in_cmd_hdr, in, opcode, MLX5_CMD_OP_MODIFY_GENERAL_OBJECT);
-- 
2.38.1

