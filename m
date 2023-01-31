Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5601F68229B
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 04:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjAaDMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 22:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbjAaDMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 22:12:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2C53756A
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 19:12:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 490EE61383
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B799C433EF;
        Tue, 31 Jan 2023 03:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675134730;
        bh=jUdBo0tijD0KAEl0DgVPvqocTVOuxXxx2gYjRlhrQ/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O4opSdSLaIk2zS9RDpM8ESvV92E3t2goEdaBfPykLVYY9feZ+9VN5D3KkTIZtEMXc
         0Yt+GC+f5uaJbScMMioD85NpzJT0HJDKLtGkwiIImjvwg8pwI1qfyM/5rt+/4CejPh
         Fhy1l77cqhvLwi4D4T8OnBaAvwt39UixCiqJFiHrUFyyMFgMvyti0NCVvk01arjTwG
         b8TqrABwhs/78RPykq3uFq0hRsjUi2orLu+wy34Ql7P4ygu3g+niX8zgSrVmZ/H4l2
         gzZLWASXnKQtYPItUXkBXAAJx1jvcE4+dHomXbOgcxpNZGV3aZ3IOD1S404iVxufYV
         +HLHB+qZemDhQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: [net-next 04/15] net/mlx5: Change key type to key purpose
Date:   Mon, 30 Jan 2023 19:11:50 -0800
Message-Id: <20230131031201.35336-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230131031201.35336-1-saeed@kernel.org>
References: <20230131031201.35336-1-saeed@kernel.org>
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

From: Jianbo Liu <jianbol@nvidia.com>

Change the naming of key type in DEK fields and macros, to be
consistent with the device spec.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.h | 6 +++---
 include/linux/mlx5/mlx5_ifc.h                        | 8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
index 2521f31d36b7..7614595c5416 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
@@ -41,7 +41,7 @@ int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
 	memcpy(key_p, key, sz_bytes);
 
 	MLX5_SET(encryption_key_obj, obj, key_size, general_obj_key_size);
-	MLX5_SET(encryption_key_obj, obj, key_type, key_type);
+	MLX5_SET(encryption_key_obj, obj, key_purpose, key_type);
 	MLX5_SET(general_obj_in_cmd_hdr, in, opcode,
 		 MLX5_CMD_OP_CREATE_GENERAL_OBJECT);
 	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.h
index cb85da9e3964..0a5a7dc9fa05 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.h
@@ -5,9 +5,9 @@
 #define __MLX5_LIB_CRYPTO_H__
 
 enum {
-	MLX5_ACCEL_OBJ_TLS_KEY = MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_TLS,
-	MLX5_ACCEL_OBJ_IPSEC_KEY = MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_IPSEC,
-	MLX5_ACCEL_OBJ_MACSEC_KEY = MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_MACSEC,
+	MLX5_ACCEL_OBJ_TLS_KEY = MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_PURPOSE_TLS,
+	MLX5_ACCEL_OBJ_IPSEC_KEY = MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_PURPOSE_IPSEC,
+	MLX5_ACCEL_OBJ_MACSEC_KEY = MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_PURPOSE_MACSEC,
 };
 
 int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 7143b65f9f4a..1b6201bb04c1 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -11986,7 +11986,7 @@ struct mlx5_ifc_encryption_key_obj_bits {
 	u8         reserved_at_49[0xb];
 	u8         key_size[0x4];
 	u8         reserved_at_58[0x4];
-	u8         key_type[0x4];
+	u8         key_purpose[0x4];
 
 	u8         reserved_at_60[0x8];
 	u8         pd[0x18];
@@ -12135,9 +12135,9 @@ enum {
 };
 
 enum {
-	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_TLS = 0x1,
-	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_IPSEC = 0x2,
-	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_MACSEC = 0x4,
+	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_PURPOSE_TLS = 0x1,
+	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_PURPOSE_IPSEC = 0x2,
+	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_PURPOSE_MACSEC = 0x4,
 };
 
 struct mlx5_ifc_tls_static_params_bits {
-- 
2.39.1

