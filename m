Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C8A506888
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 12:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350594AbiDSKR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 06:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350718AbiDSKRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 06:17:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DFDFA
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 03:14:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D9C060EBA
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 10:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625D5C385A5;
        Tue, 19 Apr 2022 10:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650363293;
        bh=++m14ooka9ncmVZ1F2XNBipegiEmCO4rY+nkOQ7sxVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMLntiuiQHR4yncik8w08jiBvnufYXAlDLWb3qvvOiH7v3fxinBVQpzlmEn2sT+5Y
         ZgjPr7G3LBS9zKM1D/JpdTW3T0k1/uRx1+R07KTXW9BMaXl9XVbcim60yU4sIoiKd9
         KEoNQ2G88zEHT9C5VXVFZ7hWQvWHQFLNmn0t1RrcVGsQNtOj6gDdsw8VG07EjTDROE
         6zGwHFplKCeyfwmTn/RNgL97PVLMFcv1/gNYJ0WakUH7CuU59bg2/0CoBSukF52xsw
         668JMLcSyEIx9Ic1oIxRV+XeNV5TpyW3B6ZbpFJucQdeyMawKoo2LXV1Xj/o67ggyT
         IMUmTQ89cuZTg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next v1 15/17] net/mlx5: Cleanup XFRM attributes struct
Date:   Tue, 19 Apr 2022 13:13:51 +0300
Message-Id: <5910e1bca2a5d34b8669b8ddc6c62943435e566f.1650363043.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1650363043.git.leonro@nvidia.com>
References: <cover.1650363043.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Remove everything that is not used or from mlx5_accel_esp_xfrm_attrs,
together with change type of spi to store proper type from the beginning.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 10 ++-------
 .../mellanox/mlx5/core/en_accel/ipsec.h       | 21 ++-----------------
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  4 ++--
 .../mlx5/core/en_accel/ipsec_offload.c        |  4 ++--
 4 files changed, 8 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index be7650d2cfd3..35e2bb301c26 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -137,7 +137,7 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 				   struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
 	struct xfrm_state *x = sa_entry->x;
-	struct aes_gcm_keymat *aes_gcm = &attrs->keymat.aes_gcm;
+	struct aes_gcm_keymat *aes_gcm = &attrs->aes_gcm;
 	struct aead_geniv_ctx *geniv_ctx;
 	struct crypto_aead *aead;
 	unsigned int crypto_data_len, key_len;
@@ -171,12 +171,6 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 			attrs->flags |= MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP;
 	}
 
-	/* rx handle */
-	attrs->sa_handle = sa_entry->handle;
-
-	/* algo type */
-	attrs->keymat_type = MLX5_ACCEL_ESP_KEYMAT_AES_GCM;
-
 	/* action */
 	attrs->action = (!(x->xso.flags & XFRM_OFFLOAD_INBOUND)) ?
 			MLX5_ACCEL_ESP_ACTION_ENCRYPT :
@@ -187,7 +181,7 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 			MLX5_ACCEL_ESP_FLAGS_TUNNEL;
 
 	/* spi */
-	attrs->spi = x->id.spi;
+	attrs->spi = be32_to_cpu(x->id.spi);
 
 	/* source , destination ips */
 	memcpy(&attrs->saddr, x->props.saddr.a6, sizeof(attrs->saddr));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 97c55620089d..16bcceec16c4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -55,11 +55,6 @@ enum mlx5_accel_esp_action {
 	MLX5_ACCEL_ESP_ACTION_ENCRYPT,
 };
 
-enum mlx5_accel_esp_keymats {
-	MLX5_ACCEL_ESP_KEYMAT_AES_NONE,
-	MLX5_ACCEL_ESP_KEYMAT_AES_GCM,
-};
-
 struct aes_gcm_keymat {
 	u64   seq_iv;
 
@@ -73,21 +68,9 @@ struct aes_gcm_keymat {
 struct mlx5_accel_esp_xfrm_attrs {
 	enum mlx5_accel_esp_action action;
 	u32   esn;
-	__be32 spi;
-	u32   seq;
-	u32   tfc_pad;
+	u32   spi;
 	u32   flags;
-	u32   sa_handle;
-	union {
-		struct {
-			u32 size;
-
-		} bmp;
-	} replay;
-	enum mlx5_accel_esp_keymats keymat_type;
-	union {
-		struct aes_gcm_keymat aes_gcm;
-	} keymat;
+	struct aes_gcm_keymat aes_gcm;
 
 	union {
 		__be32 a4;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 9d95a0025fd6..8315e8f603d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -356,8 +356,8 @@ static void setup_fte_common(struct mlx5_accel_esp_xfrm_attrs *attrs,
 
 	/* SPI number */
 	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, misc_parameters.outer_esp_spi);
-	MLX5_SET(fte_match_param, spec->match_value, misc_parameters.outer_esp_spi,
-		 be32_to_cpu(attrs->spi));
+	MLX5_SET(fte_match_param, spec->match_value,
+		 misc_parameters.outer_esp_spi, attrs->spi);
 
 	if (ip_version == 4) {
 		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 91ec8b8bf1ec..b13e152fe9fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -50,7 +50,7 @@ static int mlx5_create_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
 	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
-	struct aes_gcm_keymat *aes_gcm = &attrs->keymat.aes_gcm;
+	struct aes_gcm_keymat *aes_gcm = &attrs->aes_gcm;
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
 	u32 in[MLX5_ST_SZ_DW(create_ipsec_obj_in)] = {};
 	void *obj, *salt_p, *salt_iv_p;
@@ -106,7 +106,7 @@ static void mlx5_destroy_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
 
 int mlx5_ipsec_create_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
-	struct aes_gcm_keymat *aes_gcm = &sa_entry->attrs.keymat.aes_gcm;
+	struct aes_gcm_keymat *aes_gcm = &sa_entry->attrs.aes_gcm;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 	int err;
 
-- 
2.35.1

