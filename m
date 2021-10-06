Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27514423BB0
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 12:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238155AbhJFKta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 06:49:30 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:37445 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229824AbhJFKtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 06:49:24 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id D61C058119B;
        Wed,  6 Oct 2021 06:47:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 06 Oct 2021 06:47:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=zc8Q+43wKUcyoDL0z+m1s+vsEK7hCqxPE4CLgBiFhA8=; b=i4CoG3yb
        AiggniCtnPN15QhNDjszAQOuu/9AiC97g2/vkldh/peHrB+O6hSGkADb6Tpms0o5
        p6bSSa4cQPinvNAACeHh7FUoIEwqI2FJugUHqThzDFDaq5SVztDBKmnc4YE3HosS
        E28Wers2wsZXIW4eO3YqjwZmgCZu8yVooFdDKAVz1Yi/O7z9nzmBqJhfnRqWsjOo
        xs0EEk7r3dv1j+JfMngLS/Y0ZaknRGlYxrWXlKnQN7ROC23Ofm34jszLidDeobGT
        TM1dKlNVSObdVgrUZ0uf307G1nkv8VDvzFXQqm+yWX3GtvwSTRIVONTGznOa1TWh
        Xfz7QsYEDpZUeA==
X-ME-Sender: <xms:xH5dYUeCAjsMMK0sW2sKgTfFdUEbPGeixmj5egWhIgMcBiqgsrvYqQ>
    <xme:xH5dYWNeh1RB55P4uJwtZfdIKUUrLkyeU-lYliDzCo-axNnLdnkz_N030bwljuqCS
    UfGOnQTh4A8us8>
X-ME-Received: <xmr:xH5dYVh6FHFBHvcCIS-Up_XjHm8n9KekbPa6GLQL8wxqyYaIXkeD6f5Hq8pmRyP_-SYJG91sHI3ECcEr32iC5R7Dwo4eqRUjoYpkQGKhzPei6Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeliedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:xH5dYZ-Tpul_TnSdfhsBWECcR0MDllQ4pJy_BD08QiJvJMQtazwImQ>
    <xmx:xH5dYQt5ZVnRGhfxwwLaX5hRdkO6fT5wxrFvWoEeIbzED-9IPnn3qw>
    <xmx:xH5dYQEI_9tw6R2VqHz29T4nubAvR8P4wZbovnIiH16MVtOcmT5wBA>
    <xmx:xH5dYeCotob3LS0GiZKyr260TRWLdLkPT9u9iO0aYNPXY8nwpFfESw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 6 Oct 2021 06:47:29 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 3/6] mlxsw: reg: Add Management Cable IO and Notifications register
Date:   Wed,  6 Oct 2021 13:46:44 +0300
Message-Id: <20211006104647.2357115-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211006104647.2357115-1-idosch@idosch.org>
References: <20211006104647.2357115-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add the Management Cable IO and Notifications register. It will be used
to retrieve the power mode status of a module in subsequent patches and
whether a module is present in a cage or not.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 34 +++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index bff05a0a2f7a..ed6c3356e4eb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -10402,6 +10402,39 @@ static inline void mlxsw_reg_mlcr_pack(char *payload, u8 local_port,
 					   MLXSW_REG_MLCR_DURATION_MAX : 0);
 }
 
+/* MCION - Management Cable IO and Notifications Register
+ * ------------------------------------------------------
+ * The MCION register is used to query transceiver modules' IO pins and other
+ * notifications.
+ */
+#define MLXSW_REG_MCION_ID 0x9052
+#define MLXSW_REG_MCION_LEN 0x18
+
+MLXSW_REG_DEFINE(mcion, MLXSW_REG_MCION_ID, MLXSW_REG_MCION_LEN);
+
+/* reg_mcion_module
+ * Module number.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mcion, module, 0x00, 16, 8);
+
+enum {
+	MLXSW_REG_MCION_MODULE_STATUS_BITS_PRESENT_MASK = BIT(0),
+	MLXSW_REG_MCION_MODULE_STATUS_BITS_LOW_POWER_MASK = BIT(8),
+};
+
+/* reg_mcion_module_status_bits
+ * Module IO status as defined by SFF.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, mcion, module_status_bits, 0x04, 0, 16);
+
+static inline void mlxsw_reg_mcion_pack(char *payload, u8 module)
+{
+	MLXSW_REG_ZERO(mcion, payload);
+	mlxsw_reg_mcion_module_set(payload, module);
+}
+
 /* MTPPS - Management Pulse Per Second Register
  * --------------------------------------------
  * This register provides the device PPS capabilities, configure the PPS in and
@@ -12446,6 +12479,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mgir),
 	MLXSW_REG(mrsr),
 	MLXSW_REG(mlcr),
+	MLXSW_REG(mcion),
 	MLXSW_REG(mtpps),
 	MLXSW_REG(mtutc),
 	MLXSW_REG(mpsc),
-- 
2.31.1

