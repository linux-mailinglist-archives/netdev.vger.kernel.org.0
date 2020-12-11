Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C564C2D7C7A
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392744AbgLKRIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:08:36 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:48039 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729097AbgLKRGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 12:06:49 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 1D65AB04;
        Fri, 11 Dec 2020 12:05:21 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 11 Dec 2020 12:05:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=jrEQVyUv60r3ku3dlcjPUytnqp44O2OmizDXwoXctQ0=; b=WKnX6dEP
        hZgjQWz6daw7wrirlsb0+nmbij8zdyoVIFJQQNKHS+H1Uo8tNtwjlHwNaNJyQTIX
        vyOTMSN/DbOFu/l1D+YZA9/VoW44cvgN7sGHwGh7xlSFZGnP8ewL8H2tFAkGeQI1
        FoIqCYa+wv/gIar1VmC3EOfo2d8P/OFoT6Q9fqVH+8GsLsefTuz1F03vl7FA/uVb
        SxXVvFjjDUn++7RdxCqi1f2VUYHpkQYsaICbr2mwBH2ATJnYaw9NIbLGlNNjEOBt
        JIhsAf75fda8iME7zW8PlI73eVyK3Ab8bTYUXGl//gVGoU0LG8Kp57LU7InuMkDI
        MbbVlAU+SA5ZYA==
X-ME-Sender: <xms:0KbTXxqkihZR-meXjpDlb_3evfUXf4ZMVD2ZvY2utDmBrQfAedYbKA>
    <xme:0KbTXzzMKj9Eg1EnVoIe_nmYDJjq-dBS2s2nwvJVMh4q4XLpmPYBbABoa2p7u_MEs
    59984rcBrGPSbI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekvddgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrjeek
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:0KbTX1ryOy-iwd5Ff6K2HjTEDgPWOGBOYOWM7om--Pq4u_3fR7LhWQ>
    <xmx:0KbTXzesARwA4kDO0ybB43KB6cAyT_0Q4dlEk_jZB9JqRjMwC1g2yw>
    <xmx:0KbTX4rhiv2eAX2NlSCiTyk4etURSchPpjOChQC56xAAzqM7sPP3WA>
    <xmx:0KbTX2dTNPwFxHdCcdBtMxMMKm4uUFYKBIDchtJLTd1bueP6foXm2A>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id A3F6A1080057;
        Fri, 11 Dec 2020 12:05:19 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/15] mlxsw: reg: Add XM Lookup Table Query Register
Date:   Fri, 11 Dec 2020 19:04:05 +0200
Message-Id: <20201211170413.2269479-8-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201211170413.2269479-1-idosch@idosch.org>
References: <20201211170413.2269479-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The XLTQ is used to query HW for XM-related info.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 66 +++++++++++++++++++++--
 1 file changed, 63 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 07445db6a018..6db3a5b22f5d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8543,12 +8543,71 @@ static inline void mlxsw_reg_rxltm_pack(char *payload, u8 m0_val_v4, u8 m0_val_v
 	mlxsw_reg_rxltm_m0_val_v4_set(payload, m0_val_v4);
 }
 
-/* Note that XMDR and XRALXX register positions violate the rule of ordering
- * register definitions by the ID. However, XRALXX pack helpers are
+/* Note that XLTQ, XMDR and XRALXX register positions violate the rule
+ * of ordering register definitions by the ID. However, XRALXX pack helpers are
  * using RALXX pack helpers, RALXX registers have higher IDs.
- * Also XMDR is using RALUE enums.
+ * Also XMDR is using RALUE enums. XLTQ is just put alongside with the
+ * related registers.
  */
 
+/* XLTQ - XM Lookup Table Query Register
+ * -------------------------------------
+ */
+#define MLXSW_REG_XLTQ_ID 0x7802
+#define MLXSW_REG_XLTQ_LEN 0x2C
+
+MLXSW_REG_DEFINE(xltq, MLXSW_REG_XLTQ_ID, MLXSW_REG_XLTQ_LEN);
+
+enum mlxsw_reg_xltq_xm_device_id {
+	MLXSW_REG_XLTQ_XM_DEVICE_ID_UNKNOWN,
+	MLXSW_REG_XLTQ_XM_DEVICE_ID_XLT = 0xCF71,
+};
+
+/* reg_xltq_xm_device_id
+ * XM device ID.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, xltq, xm_device_id, 0x04, 0, 16);
+
+/* reg_xltq_xlt_cap_ipv4_lpm
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, xltq, xlt_cap_ipv4_lpm, 0x10, 0, 1);
+
+/* reg_xltq_xlt_cap_ipv6_lpm
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, xltq, xlt_cap_ipv6_lpm, 0x10, 1, 1);
+
+/* reg_xltq_cap_xlt_entries
+ * Number of XLT entries
+ * Note: SW must not fill more than 80% in order to avoid overflow
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, xltq, cap_xlt_entries, 0x20, 0, 32);
+
+/* reg_xltq_cap_xlt_mtable
+ * XLT M-Table max size
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, xltq, cap_xlt_mtable, 0x24, 0, 32);
+
+static inline void mlxsw_reg_xltq_pack(char *payload)
+{
+	MLXSW_REG_ZERO(xltq, payload);
+}
+
+static inline void mlxsw_reg_xltq_unpack(char *payload, u16 *xm_device_id, bool *xlt_cap_ipv4_lpm,
+					 bool *xlt_cap_ipv6_lpm, u32 *cap_xlt_entries,
+					 u32 *cap_xlt_mtable)
+{
+	*xm_device_id = mlxsw_reg_xltq_xm_device_id_get(payload);
+	*xlt_cap_ipv4_lpm = mlxsw_reg_xltq_xlt_cap_ipv4_lpm_get(payload);
+	*xlt_cap_ipv6_lpm = mlxsw_reg_xltq_xlt_cap_ipv6_lpm_get(payload);
+	*cap_xlt_entries = mlxsw_reg_xltq_cap_xlt_entries_get(payload);
+	*cap_xlt_mtable = mlxsw_reg_xltq_cap_xlt_mtable_get(payload);
+}
+
 /* XMDR - XM Direct Register
  * -------------------------
  * The XMDR allows direct access to the XM device via the switch.
@@ -11830,6 +11889,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(rmft2),
 	MLXSW_REG(rxlte),
 	MLXSW_REG(rxltm),
+	MLXSW_REG(xltq),
 	MLXSW_REG(xmdr),
 	MLXSW_REG(xralta),
 	MLXSW_REG(xralst),
-- 
2.29.2

