Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310EE2D7C6D
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394516AbgLKRHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:07:55 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:36073 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394317AbgLKRHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 12:07:05 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id B13EDA26;
        Fri, 11 Dec 2020 12:05:23 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 11 Dec 2020 12:05:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=bNTagCLn4h36ut/17O/vNWVonbqEXAVXqx2glJgQCzI=; b=Pu+Rt++V
        p6d/KFm4aLuoKK3ATykQKwImjGq/NCsxDshG2Z5jzF9WPaotYDv0J3aK7c27bOhm
        UGoG6i8Ka/kynZQ0jTWjdlW41iKaglNaUJ4keNmXz3O3QhXOweD2S4Rya41+EUwD
        JN9OLLGNfiBKK4lMXsM2wj5n0enotHG0d7P5RUvrUsZ0LGkSB3BYyqASRVm9cKe+
        84BkOdOtiObb4V6vHRIwErLXvG2OlG0gWtGklPZGgjsKTLF63jgahZAsqgtFn+eP
        SDr/hxrO2Mg58xTdR7XI4Zp/9pf90fkQI1meZJ/HcOI4LZyil1PgL6UxYIR9EH9q
        jW+LmQWeBqTEPw==
X-ME-Sender: <xms:06bTX-WAt_IhZ6jxr9uzP4PewyEn3b9JKGrhCF3UlHlY5ZXJJVLrWQ>
    <xme:06bTX2TYsRICDgpHFTJtnIDDhUjiDCQGgc_H-SM-_-sE2ZFCZiX_gasjgkyAdiZhV
    Bof9UbwMrNne08>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekvddgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrjeek
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:06bTX-37xyKGDxwycPAWok00P1VpGuGXnr9Wm-mS1ueGq-iCBsXRow>
    <xmx:06bTX-cJF5wNJCTgUNCm7JjUOhBKyi6ETs-nIjiC9EaINeWOjrZv5A>
    <xmx:06bTX-M4q3QDvqtmKauK8_3zUtGqqeDg1GGx7hkkiw7d-oFmVEivaw>
    <xmx:06bTX0NiMOzQct6a0aak8AmwqF9VbheBMkUOnAkoLROBrgun0_ac8w>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id 445D01080066;
        Fri, 11 Dec 2020 12:05:22 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/15] mlxsw: reg: Add XM Router M Table Register
Date:   Fri, 11 Dec 2020 19:04:07 +0200
Message-Id: <20201211170413.2269479-10-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201211170413.2269479-1-idosch@idosch.org>
References: <20201211170413.2269479-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The XRMT configures the M-Table for the XLT-LPM.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 33 +++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 6db3a5b22f5d..0e3abb315e06 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8543,10 +8543,10 @@ static inline void mlxsw_reg_rxltm_pack(char *payload, u8 m0_val_v4, u8 m0_val_v
 	mlxsw_reg_rxltm_m0_val_v4_set(payload, m0_val_v4);
 }
 
-/* Note that XLTQ, XMDR and XRALXX register positions violate the rule
+/* Note that XLTQ, XMDR, XRMT and XRALXX register positions violate the rule
  * of ordering register definitions by the ID. However, XRALXX pack helpers are
  * using RALXX pack helpers, RALXX registers have higher IDs.
- * Also XMDR is using RALUE enums. XLTQ is just put alongside with the
+ * Also XMDR is using RALUE enums. XLRQ and XRMT are just put alongside with the
  * related registers.
  */
 
@@ -8874,6 +8874,34 @@ static inline void mlxsw_reg_xmdr_c_ltr_act_ip2me_tun_pack(char *xmdr_payload,
 	mlxsw_reg_xmdr_c_ltr_pointer_to_tunnel_set(payload, pointer_to_tunnel);
 }
 
+/* XRMT - XM Router M Table Register
+ * ---------------------------------
+ * The XRMT configures the M-Table for the XLT-LPM.
+ */
+#define MLXSW_REG_XRMT_ID 0x7810
+#define MLXSW_REG_XRMT_LEN 0x14
+
+MLXSW_REG_DEFINE(xrmt, MLXSW_REG_XRMT_ID, MLXSW_REG_XRMT_LEN);
+
+/* reg_xrmt_index
+ * Index in M-Table.
+ * Range 0..cap_xlt_mtable-1
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, xrmt, index, 0x04, 0, 20);
+
+/* reg_xrmt_l0_val
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, xrmt, l0_val, 0x10, 24, 8);
+
+static inline void mlxsw_reg_xrmt_pack(char *payload, u32 index, u8 l0_val)
+{
+	MLXSW_REG_ZERO(xrmt, payload);
+	mlxsw_reg_xrmt_index_set(payload, index);
+	mlxsw_reg_xrmt_l0_val_set(payload, l0_val);
+}
+
 /* XRALTA - XM Router Algorithmic LPM Tree Allocation Register
  * -----------------------------------------------------------
  * The XRALTA is used to allocate the XLT LPM trees.
@@ -11891,6 +11919,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(rxltm),
 	MLXSW_REG(xltq),
 	MLXSW_REG(xmdr),
+	MLXSW_REG(xrmt),
 	MLXSW_REG(xralta),
 	MLXSW_REG(xralst),
 	MLXSW_REG(xraltb),
-- 
2.29.2

