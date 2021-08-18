Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49033F087C
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 17:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240227AbhHRPx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 11:53:28 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:36959 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240111AbhHRPxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 11:53:22 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id D64AF582FDE;
        Wed, 18 Aug 2021 11:52:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 18 Aug 2021 11:52:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=phhofT96tIj9T3TjV/B127HoyynnMGG3okO+sLIEku0=; b=ZcYsZAKJ
        3VXif7D0BYp2M2rgmTwrPbv3UODej592x9T3QC1qrinl2ot1KqYHYfn7pWTBT7ya
        wl/KsBS8gkzBLjpRqP8Ho2RLbz4Av4Os0wI5FEo5OQ6GNXGfGvAD6KLblO1MlAgv
        g7IvVDbLqj0/NUzHlngiFOQ2mpX71FXIDgbbe7knVzVwBBYgutqDg5QCAzAOHLrj
        nnxtgv+9oO5hz8NM7OT3H8T6eZLTv4aQDgyg/O9ImN/+b+kFg4jHIcms5N0ok/QO
        giyWkgrIsgocRG9tKRlDdGuVuEBhUKWZKzJD6d/hdst2hpGHXI+DTGSnbXBUuVUx
        7ZNS5eQBKquVCQ==
X-ME-Sender: <xms:zywdYaSPO7VB4KH2fDecNYeYqj5Wgn3UAl4mUOe8KwZgbMrbA_HMGw>
    <xme:zywdYfycj5g7r84UbRVVOzCl7Ka2O5qWWXQVJLHNliE2qqz_UflbXnUk7_kcwgNot
    J39lSlEi9kr4e0>
X-ME-Received: <xmr:zywdYX2X4DPbwAz1CbndiZyy_7bE6n65Iv5EgKiVlObkPnvRQ1FXfqanQi8mJmL-Bt_oHMRvDy3d8sVMcaYGhxtLvl37_iruVgKZYNGZQs_MOw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrleehgdelfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:zywdYWA62jC6y_WUiXqw575llS2Ey5J0XK6EC0NT1_JwA4YZ4uKCUA>
    <xmx:zywdYTjfICop1qAL3ouUD9FqvgSR5xQC4axJRh_NO8Ps6Kg05XpNLA>
    <xmx:zywdYSr3EVHpmhayJtsGT_f3T0Pvxs6p5Z3OC12s7-c5PY9ANSlApA>
    <xmx:zywdYUVZiKn20mnYncsG7HPyLtxFCEFJwVMiYKfA4oqsvp_3sE48pw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Aug 2021 11:52:44 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next v2 3/6] mlxsw: reg: Add Management Cable IO and Notifications register
Date:   Wed, 18 Aug 2021 18:51:59 +0300
Message-Id: <20210818155202.1278177-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818155202.1278177-1-idosch@idosch.org>
References: <20210818155202.1278177-1-idosch@idosch.org>
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
index e30e6d3482f6..de40b59f7d00 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -10274,6 +10274,39 @@ static inline void mlxsw_reg_mlcr_pack(char *payload, u8 local_port,
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
@@ -12316,6 +12349,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mgir),
 	MLXSW_REG(mrsr),
 	MLXSW_REG(mlcr),
+	MLXSW_REG(mcion),
 	MLXSW_REG(mtpps),
 	MLXSW_REG(mtutc),
 	MLXSW_REG(mpsc),
-- 
2.31.1

