Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64C62D977C
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 12:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438305AbgLNLgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 06:36:54 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54787 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437959AbgLNLcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 06:32:54 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 054295C0103;
        Mon, 14 Dec 2020 06:31:10 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 14 Dec 2020 06:31:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=jrEQVyUv60r3ku3dlcjPUytnqp44O2OmizDXwoXctQ0=; b=fbnZea70
        2gXE5Mwvdo4grvh1rFn8oo4MNTmhz1btDB+0qlmBh5cQbnh+DidBcFQyNmBNtKNq
        tC1nzV/bUxzCVfeuNEQ5RZYXfupBRgnjBu/PsuWShKZBEjeCJC9rqJwHIAwa96i3
        JIOsyL8AYMqPOpxPdKeBlU8cs31ul9Dajh+F5bbb81KF88ETsLMYtl2nMwZrLOTY
        7zY8kO3kSTk1yZiUDv7ZBKAYrnmg5cnlMNt7XFfwEiUaP1CIBbfFlF9dzVZXR7Vs
        uFSkaED9EWvgoiDXrq3ID2IlxR0U1hnK/WVehTXSyTyOJ/h6CjcUEGquuNldMqh8
        J5Qo0zIBFzu0nA==
X-ME-Sender: <xms:_UzXX-Bb0l87hdPyVKYxyzX86pL850ny13kXo_i-8-tcVUDoI06kMA>
    <xme:_UzXX4h6kgWcWaHm5qnuzYTRpp_FykJZm3JfkuD1iat0R5INTsdwdNQFWLP0jc-tH
    9hmVsq5xzphc74>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrfedu
    necuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:_UzXXxm0NNbmW0NnvwIfFUowqcHDnf_Mv0y7aKG-IlSeTv5Q1SbIEw>
    <xmx:_UzXX8yQLojssByoplAAHAeXOMdjok58rA11jf4Nl6XZdw2Mn0hqsw>
    <xmx:_UzXXzSzPnKOAcer3UybG4Z441FVBs_OOlS3gZQKar858JUvEU2DRw>
    <xmx:_kzXX-dysZqa8N6oVcOUhgRmlsD7r-aeza75N0suV5wVwSlUe5OY8Q>
Received: from shredder.mtl.com (igld-84-229-152-31.inter.net.il [84.229.152.31])
        by mail.messagingengine.com (Postfix) with ESMTPA id C837F1080059;
        Mon, 14 Dec 2020 06:31:08 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 07/15] mlxsw: reg: Add XM Lookup Table Query Register
Date:   Mon, 14 Dec 2020 13:30:33 +0200
Message-Id: <20201214113041.2789043-8-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214113041.2789043-1-idosch@idosch.org>
References: <20201214113041.2789043-1-idosch@idosch.org>
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

