Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2784913AE11
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 16:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgANPzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 10:55:51 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41681 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726971AbgANPzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 10:55:51 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 14 Jan 2020 17:55:45 +0200
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.134.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00EFtjvm015200;
        Tue, 14 Jan 2020 17:55:45 +0200
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 00EFtjh3019700;
        Tue, 14 Jan 2020 17:55:45 +0200
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 00EFtjWo019699;
        Tue, 14 Jan 2020 17:55:45 +0200
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC 1/3] net/mlx5: Add structure layout and defines for MFRL register
Date:   Tue, 14 Jan 2020 17:55:26 +0200
Message-Id: <1579017328-19643-2-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1579017328-19643-1-git-send-email-moshe@mellanox.com>
References: <1579017328-19643-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add needed structure layouts and defines for MFRL (Management Firmware
Reset Level) register. This structure will be used for the firmware
upgrade and reset flow in the downstream patches.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
 include/linux/mlx5/driver.h   |  1 +
 include/linux/mlx5/mlx5_ifc.h | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 583733a..268ecfd 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -130,6 +130,7 @@ enum {
 	MLX5_REG_NODE_DESC	 = 0x6001,
 	MLX5_REG_HOST_ENDIANNESS = 0x7004,
 	MLX5_REG_MCIA		 = 0x9014,
+	MLX5_REG_MFRL		 = 0x9028,
 	MLX5_REG_MLCR		 = 0x902b,
 	MLX5_REG_MTRC_CAP	 = 0x9040,
 	MLX5_REG_MTRC_CONF	 = 0x9041,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 178757c..7684537 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -9584,6 +9584,22 @@ struct mlx5_ifc_mcda_reg_bits {
 	u8         data[0][0x20];
 };
 
+enum {
+	MLX5_MFRL_REG_RESET_LEVEL0  = 0x1,
+	MLX5_MFRL_REG_RESET_LEVEL3  = 0x8,
+	MLX5_MFRL_REG_RESET_LEVEL6  = 0x40,
+};
+
+struct mlx5_ifc_mfrl_reg_bits {
+	u8         reserved_at_0[0x20];
+
+	u8         reserved_at_20[0x5];
+	u8         rst_type_sel[0x3];
+	u8         reserved_at_28[0x8];
+	u8         reset_type[0x8];
+	u8         reset_level[0x8];
+};
+
 struct mlx5_ifc_mirc_reg_bits {
 	u8         reserved_at_0[0x18];
 	u8         status_code[0x8];
@@ -9646,6 +9662,7 @@ struct mlx5_ifc_mirc_reg_bits {
 	struct mlx5_ifc_mcqi_reg_bits mcqi_reg;
 	struct mlx5_ifc_mcc_reg_bits mcc_reg;
 	struct mlx5_ifc_mcda_reg_bits mcda_reg;
+	struct mlx5_ifc_mfrl_reg_bits mfrl_reg;
 	struct mlx5_ifc_mirc_reg_bits mirc_reg;
 	u8         reserved_at_0[0x60e0];
 };
-- 
1.8.3.1

