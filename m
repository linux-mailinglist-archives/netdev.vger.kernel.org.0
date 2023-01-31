Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9D6682299
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 04:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjAaDMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 22:12:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjAaDML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 22:12:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D18B36FD1
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 19:12:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F06DBB81184
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919D1C4339B;
        Tue, 31 Jan 2023 03:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675134727;
        bh=rK2M26bUWpbs1XBC8i9OrPeIUZZUvHU28mVi+OrdfAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K7vzXduDKUr/pxewHK4vReOxQ+N26SCZpP+HeT3T0uPqEVLLiKHlz5SklHnQT6mqj
         M59FISNbnPM+vWI0nJw0SRdaOpJL5oAGw2Ug+2rcuW6guZjGHDK8LSe+KunmkSQEP9
         VUnD7cRVEWsDVDi3MzKZFtBXg7eOh4B26BLkTB1es4kqO6SY41B4T9Y8+QeN3wGkZH
         ubsp2W6RVqhr7z2gfvvho5HbpuazQ0WpeLOOKu/eUhMpOCJFPnZANKJuLuoibbZUGl
         FyKUaImvy7q7mzyQ6ZwqzaLBETGVptrtk4NA6ofIUE1QziyiE1JehKUcq+e6HLfH0P
         IWxyxnf2QCT3g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: [net-next 01/15] net/mlx5: Header file for crypto
Date:   Mon, 30 Jan 2023 19:11:47 -0800
Message-Id: <20230131031201.35336-2-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230131031201.35336-1-saeed@kernel.org>
References: <20230131031201.35336-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Take crypto API out of the generic mlx5.h header into a dedicated
header.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mlx5/core/en_accel/ipsec_offload.c        |  2 +-
 .../mellanox/mlx5/core/en_accel/ktls.c        |  1 +
 .../mellanox/mlx5/core/en_accel/macsec.c      |  2 +-
 .../ethernet/mellanox/mlx5/core/lib/crypto.c  |  2 +-
 .../ethernet/mellanox/mlx5/core/lib/crypto.h  | 19 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/lib/mlx5.h    | 12 ------------
 6 files changed, 23 insertions(+), 15 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 2461462b7b99..57ac0f663fcd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -4,7 +4,7 @@
 #include "mlx5_core.h"
 #include "en.h"
 #include "ipsec.h"
-#include "lib/mlx5.h"
+#include "lib/crypto.h"
 
 enum {
 	MLX5_IPSEC_ASO_REMOVE_FLOW_PKT_CNT_OFFSET,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index eb5b09f81dec..d36788119b8b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -4,6 +4,7 @@
 #include <linux/debugfs.h>
 #include "en.h"
 #include "lib/mlx5.h"
+#include "lib/crypto.h"
 #include "en_accel/ktls.h"
 #include "en_accel/ktls_utils.h"
 #include "en_accel/fs_tcp.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 7f6b940830b3..08d0929e8260 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -7,7 +7,7 @@
 
 #include "en.h"
 #include "lib/aso.h"
-#include "lib/mlx5.h"
+#include "lib/crypto.h"
 #include "en_accel/macsec.h"
 #include "en_accel/macsec_fs.h"
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
index e995f8378df7..2521f31d36b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
@@ -2,7 +2,7 @@
 // Copyright (c) 2019 Mellanox Technologies.
 
 #include "mlx5_core.h"
-#include "lib/mlx5.h"
+#include "lib/crypto.h"
 
 int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
 			       void *key, u32 sz_bytes,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.h
new file mode 100644
index 000000000000..cb85da9e3964
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#ifndef __MLX5_LIB_CRYPTO_H__
+#define __MLX5_LIB_CRYPTO_H__
+
+enum {
+	MLX5_ACCEL_OBJ_TLS_KEY = MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_TLS,
+	MLX5_ACCEL_OBJ_IPSEC_KEY = MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_IPSEC,
+	MLX5_ACCEL_OBJ_MACSEC_KEY = MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_MACSEC,
+};
+
+int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
+			       void *key, u32 sz_bytes,
+			       u32 key_type, u32 *p_key_id);
+
+void mlx5_destroy_encryption_key(struct mlx5_core_dev *mdev, u32 key_id);
+
+#endif /* __MLX5_LIB_CRYPTO_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
index 032adb21ad4b..55bd7c4c021e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
@@ -79,18 +79,6 @@ struct mlx5_pme_stats {
 void mlx5_get_pme_stats(struct mlx5_core_dev *dev, struct mlx5_pme_stats *stats);
 int mlx5_notifier_call_chain(struct mlx5_events *events, unsigned int event, void *data);
 
-/* Crypto */
-enum {
-	MLX5_ACCEL_OBJ_TLS_KEY = MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_TLS,
-	MLX5_ACCEL_OBJ_IPSEC_KEY = MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_IPSEC,
-	MLX5_ACCEL_OBJ_MACSEC_KEY = MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_MACSEC,
-};
-
-int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
-			       void *key, u32 sz_bytes,
-			       u32 key_type, u32 *p_key_id);
-void mlx5_destroy_encryption_key(struct mlx5_core_dev *mdev, u32 key_id);
-
 static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
 {
 	return devlink_net(priv_to_devlink(dev));
-- 
2.39.1

