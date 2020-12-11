Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6242D7C6A
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394527AbgLKRH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:07:56 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:45427 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387786AbgLKRH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 12:07:29 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id C2907B21;
        Fri, 11 Dec 2020 12:05:27 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 11 Dec 2020 12:05:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=4n1J1hRkMTi9UwcHj9eJ9FIO/5HrTdG99h4TAUWhxUE=; b=qdkKpp3C
        BJuqgCRX2G2wqjf8Yiz5R8Tps9o7Fahkd++d5ZBXP81PXmv1kABhA25BCJe1uM/d
        yxOWHezeTe2XQRvKy0oe5WL1YXXYztasK7RyNHLnHHi2c9GyY9K6r9ufE/wuLo0T
        qlgd3ARznVIfwjqflnivZX5MgxA0V/HyqhImU+YNkmEVFs+Ra9SSEK4jvYq4yRBA
        FAJ0w24caZZsJpW5/zkhF0hoo3dr59bhDfqEX/OZn/yWWCz3ZO0cIViOOHrMuy53
        pBDQSsM2zOkDiebbzRoMNWf/Hz4MAiqviRF/mYa+7cHBtCE/WL3hIXAu1QIsL/nd
        gBHSEdP61w2F4w==
X-ME-Sender: <xms:16bTX62QVS4IJlGHaIjIVj2Gk7GnhAcSENdWBSAiEP7vef9UUpc5iA>
    <xme:16bTX9Ej3EdC1zuSot74CmL0ahVSG26XAXFQHtxk4oS323WI1QPsPUOqsbLYliGNo
    SRIQR5fj-Nls9c>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekvddgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrjeek
    necuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:16bTXy5e9Zp2krbNc-gIS2tBEFVvZNkbDwAadS8exL4LlvvzZhSMgQ>
    <xmx:16bTX73ZYWibMJlxRd3bh0wXx8lDuoOnbZDjJ5PhWcFhCLPnCaIm5g>
    <xmx:16bTX9FHyTc5cOzXUI2-YnmvmrwEw3L7PgCoSFn3SXJOc3HoNEjnTw>
    <xmx:16bTXyQejSGpDAuwqgsQ1JykUxynGQ6h7YAZMLWdk886MD4nDKPZ8g>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2D3931080064;
        Fri, 11 Dec 2020 12:05:26 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 12/15] mlxsw: reg: Add Router LPM Cache Enable Register
Date:   Fri, 11 Dec 2020 19:04:10 +0200
Message-Id: <20201211170413.2269479-13-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201211170413.2269479-1-idosch@idosch.org>
References: <20201211170413.2269479-1-idosch@idosch.org>
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

