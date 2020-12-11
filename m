Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FB32D7C6F
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394175AbgLKRHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:07:55 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:45065 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730230AbgLKRGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 12:06:49 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id CC745B17;
        Fri, 11 Dec 2020 12:05:19 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 11 Dec 2020 12:05:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=7lI11MtjNSMgM14iF5Kd9tOuUEofnvUAdFw5IN/V48I=; b=ok8Tib4Y
        YnyFcx+LHNS3ZZermyqq0l71PONGAWwZvy4u+EMUCaUZ6x762GUwMatGv4eu5oE+
        S/u+OEdl6OnPEp2zIyRFCj8KvWOZ5sZjNBMbSHibgPaQ59lBEbvMHYrj086WzIPv
        E+TH0CDZtLVFwBwxjdLQBJj7QvXYw0Ocy8JU4WG18SJmoLhtIkunfpc0uibS8QR7
        Kz8N7J6aiej5iZosE5/uMsVen4DRExH7TgY6meMaSxDDGyP0LfQSCYy8wevvW9O8
        T5r8cIQZEuNyd7dsoZl5Sky8W+FRbW7v/8NK1ZV1d5xWVJL1KKtTJBs3RoVbxpS5
        D9QbQmDyGYDR4Q==
X-ME-Sender: <xms:z6bTXx4appwVZM3Q1zVTug60Y_ZonykNccI5slVxLQkDCy4IDzKMIg>
    <xme:z6bTX6zlvPyXgG0QIVkmi-VXJ-U1M41rTPVemyif9Ya_6FP1hST7CKGyTywee7BET
    S_TGeVREE2FMfg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekvddgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrjeek
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:z6bTX1dtIQWRd_boSffrYWqFaxtpa6HBO1QnefpIXhzTJpaWcNLAdg>
    <xmx:z6bTX_Ai3TITeknldVbS6UrD46W0jRbKBhzuBctTghZRkjdhnqpuPA>
    <xmx:z6bTX565HHMpn4QMQ1YhfDDrC0VUPAgUlIroN9ZPpgweAZZVOWJD6Q>
    <xmx:z6bTX0LkLtNn0Ry7zxrLBH3q7PwrF5YW-e3VqgXAU7JvSDsVlyJecw>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5B0711080059;
        Fri, 11 Dec 2020 12:05:18 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/15] mlxsw: reg: Add Router XLT M select Register
Date:   Fri, 11 Dec 2020 19:04:04 +0200
Message-Id: <20201211170413.2269479-7-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201211170413.2269479-1-idosch@idosch.org>
References: <20201211170413.2269479-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The RXLTM configures and selects the M for the XM lookups.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 32 +++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index ebde4fc860e2..07445db6a018 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8512,6 +8512,37 @@ static inline void mlxsw_reg_rxlte_pack(char *payload, u16 virtual_router,
 	mlxsw_reg_rxlte_lpm_xlt_en_set(payload, lpm_xlt_en);
 }
 
+/* RXLTM - Router XLT M select Register
+ * ------------------------------------
+ * The RXLTM configures and selects the M for the XM lookups.
+ */
+
+#define MLXSW_REG_RXLTM_ID 0x8051
+#define MLXSW_REG_RXLTM_LEN 0x14
+
+MLXSW_REG_DEFINE(rxltm, MLXSW_REG_RXLTM_ID, MLXSW_REG_RXLTM_LEN);
+
+/* reg_rxltm_m0_val_v6
+ * Global M0 value For IPv6.
+ * Range 0..128
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, rxltm, m0_val_v6, 0x10, 16, 8);
+
+/* reg_rxltm_m0_val_v4
+ * Global M0 value For IPv4.
+ * Range 0..32
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, rxltm, m0_val_v4, 0x10, 0, 6);
+
+static inline void mlxsw_reg_rxltm_pack(char *payload, u8 m0_val_v4, u8 m0_val_v6)
+{
+	MLXSW_REG_ZERO(rxltm, payload);
+	mlxsw_reg_rxltm_m0_val_v6_set(payload, m0_val_v6);
+	mlxsw_reg_rxltm_m0_val_v4_set(payload, m0_val_v4);
+}
+
 /* Note that XMDR and XRALXX register positions violate the rule of ordering
  * register definitions by the ID. However, XRALXX pack helpers are
  * using RALXX pack helpers, RALXX registers have higher IDs.
@@ -11798,6 +11829,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(recr2),
 	MLXSW_REG(rmft2),
 	MLXSW_REG(rxlte),
+	MLXSW_REG(rxltm),
 	MLXSW_REG(xmdr),
 	MLXSW_REG(xralta),
 	MLXSW_REG(xralst),
-- 
2.29.2

