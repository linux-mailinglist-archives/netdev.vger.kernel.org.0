Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAAB2D9760
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 12:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437766AbgLNLcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 06:32:11 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55297 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437677AbgLNLbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 06:31:49 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 79CE75C0098;
        Mon, 14 Dec 2020 06:31:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 14 Dec 2020 06:31:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=HWY0p3OJKNVUIb/JUoSXQGS7oqvB/Y1kPFZyDj6+HC0=; b=inkb+bYm
        9BZUtu6roxIm9Xyd/6TZ952lLTVTUa+DaFlPzsu/JRgw1KUTxWe5DsYkziE/IdD3
        AuQCngJOkUPVAp2JhzkkO0ByiflsiCsUrtnqEefVKCQT/AZ/fbwR+8M0JE31fmj+
        i3XLsbjFa5Aeo+jAZIk2YPjP1gWqQ56SDVjxRSlQoqd8q8i5QaJeI45AXU3U8HBu
        K218GJIGkJtprq9whrli5j9oysGQ/++aSBvbNid3BXND0+3XUJgNLihAMsKEOLF6
        kZC++gFtXvQE0JcGei0waKc5Y0tmDCtmF/KtKD8JsvRUvYhAAeAJktmrEHfwR+pM
        MWPFFSRGSadu+Q==
X-ME-Sender: <xms:90zXX0ZUJY3zEXOujyyrhhP4d56JwqQQTfOrf0FfHCrUI1EEUwFyPQ>
    <xme:90zXX_bhGU87OCZJRdB2uXexAV31HTz2qTR7aTS-ZVRuSJqO8NogCdNairWanBXHi
    0iAuqqsEIsDF-4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrfedu
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:90zXX--RMIl-3n4qj6OKRDTp8nD9j4CIE1Tvsaj-hPLzwKl8rxgoIA>
    <xmx:90zXX-pIAhwmQKDHccey81AX2ithEj1-OXCbemt4zF0llG0VbJAbKg>
    <xmx:90zXX_oLd1roUuC0My9IoMar_RNVaz7mncvz1j_4jfKu7W1PPP-AtQ>
    <xmx:90zXX23etVeFyGH3JRBNjoz8JcM0TD1mrBWzAh3SPrNyD-cvG1wagw>
Received: from shredder.mtl.com (igld-84-229-152-31.inter.net.il [84.229.152.31])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4597C1080067;
        Mon, 14 Dec 2020 06:31:02 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 02/15] mlxsw: reg: Add Router XLT Enable Register
Date:   Mon, 14 Dec 2020 13:30:28 +0200
Message-Id: <20201214113041.2789043-3-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214113041.2789043-1-idosch@idosch.org>
References: <20201214113041.2789043-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The RXLTE enables XLT (eXtended Lookup Table) LPM lookups if a capable
XM is present on the system.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 44 +++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index e7979edadf4c..ebde4fc860e2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8469,6 +8469,49 @@ mlxsw_reg_rmft2_ipv6_pack(char *payload, bool v, u16 offset, u16 virtual_router,
 	mlxsw_reg_rmft2_sip6_mask_memcpy_to(payload, (void *)&sip6_mask);
 }
 
+/* RXLTE - Router XLT Enable Register
+ * ----------------------------------
+ * The RXLTE enables XLT (eXtended Lookup Table) LPM lookups if a capable
+ * XM is present on the system.
+ */
+
+#define MLXSW_REG_RXLTE_ID 0x8050
+#define MLXSW_REG_RXLTE_LEN 0x0C
+
+MLXSW_REG_DEFINE(rxlte, MLXSW_REG_RXLTE_ID, MLXSW_REG_RXLTE_LEN);
+
+/* reg_rxlte_virtual_router
+ * Virtual router ID associated with the router interface.
+ * Range is 0..cap_max_virtual_routers-1
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, rxlte, virtual_router, 0x00, 0, 16);
+
+enum mlxsw_reg_rxlte_protocol {
+	MLXSW_REG_RXLTE_PROTOCOL_IPV4,
+	MLXSW_REG_RXLTE_PROTOCOL_IPV6,
+};
+
+/* reg_rxlte_protocol
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, rxlte, protocol, 0x04, 0, 4);
+
+/* reg_rxlte_lpm_xlt_en
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, rxlte, lpm_xlt_en, 0x08, 0, 1);
+
+static inline void mlxsw_reg_rxlte_pack(char *payload, u16 virtual_router,
+					enum mlxsw_reg_rxlte_protocol protocol,
+					bool lpm_xlt_en)
+{
+	MLXSW_REG_ZERO(rxlte, payload);
+	mlxsw_reg_rxlte_virtual_router_set(payload, virtual_router);
+	mlxsw_reg_rxlte_protocol_set(payload, protocol);
+	mlxsw_reg_rxlte_lpm_xlt_en_set(payload, lpm_xlt_en);
+}
+
 /* Note that XMDR and XRALXX register positions violate the rule of ordering
  * register definitions by the ID. However, XRALXX pack helpers are
  * using RALXX pack helpers, RALXX registers have higher IDs.
@@ -11754,6 +11797,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(rigr2),
 	MLXSW_REG(recr2),
 	MLXSW_REG(rmft2),
+	MLXSW_REG(rxlte),
 	MLXSW_REG(xmdr),
 	MLXSW_REG(xralta),
 	MLXSW_REG(xralst),
-- 
2.29.2

