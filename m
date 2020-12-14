Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474822D9765
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 12:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438039AbgLNLdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 06:33:06 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50151 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437743AbgLNLco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 06:32:44 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 86BC75C00B5;
        Mon, 14 Dec 2020 06:31:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 14 Dec 2020 06:31:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=4n1J1hRkMTi9UwcHj9eJ9FIO/5HrTdG99h4TAUWhxUE=; b=HTnXIW5p
        j4lbfvUm8/btN10KIX5Pmy89mjf+hgWmWpHO3e+jgvZ0ddwk27v8S/YbMunOupL4
        aFTrGaFwQUx6VLN0UdPNWsTsGTQWUe0Esk2NoY1a3lQjDg9r75GOCfWh0x8QDu4H
        G1W2i+RdinfR6SM2URtUb/DsuaqWgTyNlgsxOdTKu1NLqoEBi60UVMQ0xoQmq5gX
        zoOIR7Kovomy9EEoyJpkhQ0lcyX+Y3zEMl+K77KeQsi4bhCb1Qns0Puj05zWti14
        kBbBF0ADZ34p4fDi7pvub7/SnlRwwCBscwA2eYfV6/HViLn8+GKbGq/LoHPltglU
        q4BKPUceGFQXtw==
X-ME-Sender: <xms:BE3XX24Lz0UTlRCJjYaITonGUIxC7vtBFKO323zeydx_LVyX7EAPYA>
    <xme:BE3XX8Oef2yGNKRK_uLd8mdfgBQ42uuCKAX9ryNUdsYTWwd_5C9TF7vAgsxS2J2ul
    wHXWaqH0E1qVQg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrfedu
    necuvehluhhsthgvrhfuihiivgepuddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:BE3XX4PUvF_q8j87YlF2JDhH7_54QM8i1QeM8x9LcJlP3CY_fHuSeA>
    <xmx:BE3XX0_Nq8WG5liim9QFRwvNvYEjkhQJvoYgwsa2OGtmiz2pyWFb3A>
    <xmx:BE3XX85auH9M5wEQf7DjDU0DTfa62-X406fNzZb9imPg0MLfTibBiA>
    <xmx:BE3XXxzENNGvUIal2OilmxfnJ_8vbq-ixld_VrYzG21IZVGSpqIAxg>
Received: from shredder.mtl.com (igld-84-229-152-31.inter.net.il [84.229.152.31])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5CDAD1080059;
        Mon, 14 Dec 2020 06:31:15 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 12/15] mlxsw: reg: Add Router LPM Cache Enable Register
Date:   Mon, 14 Dec 2020 13:30:38 +0200
Message-Id: <20201214113041.2789043-13-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214113041.2789043-1-idosch@idosch.org>
References: <20201214113041.2789043-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The RLPMCE allows disabling the LPM cache. Can be changed on the fly.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 35 +++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index f1c5a532454e..16e2df6ef2f4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8653,6 +8653,40 @@ static inline void mlxsw_reg_rlcmld_pack6(char *payload,
 	mlxsw_reg_rlcmld_dip_mask6_memcpy_to(payload, dip_mask);
 }
 
+/* RLPMCE - Router LPM Cache Enable Register
+ * -----------------------------------------
+ * Allows disabling the LPM cache. Can be changed on the fly.
+ */
+
+#define MLXSW_REG_RLPMCE_ID 0x8056
+#define MLXSW_REG_RLPMCE_LEN 0x4
+
+MLXSW_REG_DEFINE(rlpmce, MLXSW_REG_RLPMCE_ID, MLXSW_REG_RLPMCE_LEN);
+
+/* reg_rlpmce_flush
+ * Flush:
+ * 0: do not flush the cache (default)
+ * 1: flush (clear) the cache
+ * Access: WO
+ */
+MLXSW_ITEM32(reg, rlpmce, flush, 0x00, 4, 1);
+
+/* reg_rlpmce_disable
+ * LPM cache:
+ * 0: enabled (default)
+ * 1: disabled
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, rlpmce, disable, 0x00, 0, 1);
+
+static inline void mlxsw_reg_rlpmce_pack(char *payload, bool flush,
+					 bool disable)
+{
+	MLXSW_REG_ZERO(rlpmce, payload);
+	mlxsw_reg_rlpmce_flush_set(payload, flush);
+	mlxsw_reg_rlpmce_disable_set(payload, disable);
+}
+
 /* Note that XLTQ, XMDR, XRMT and XRALXX register positions violate the rule
  * of ordering register definitions by the ID. However, XRALXX pack helpers are
  * using RALXX pack helpers, RALXX registers have higher IDs.
@@ -12028,6 +12062,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(rxlte),
 	MLXSW_REG(rxltm),
 	MLXSW_REG(rlcmld),
+	MLXSW_REG(rlpmce),
 	MLXSW_REG(xltq),
 	MLXSW_REG(xmdr),
 	MLXSW_REG(xrmt),
-- 
2.29.2

