Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5668ED297
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 09:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbfKCIgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 03:36:31 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43371 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726546AbfKCIgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 03:36:31 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 85ED721947;
        Sun,  3 Nov 2019 03:36:30 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 03 Nov 2019 03:36:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=+3bztvqHBqYK2r9bAecONaTMVxotZ7Gg9aHTsDce9ys=; b=tlZ4QgIb
        jMSeog9iQpGXLFjWG35omZ+qUKBcE3Uk4YMNZGitHweLjb3cIO2J5GElVxT1rX2M
        57cTgc60aMS7aFdXp0gqs+PlFUW+cQBh9+PBPW7BnlAGlCByeYMlK8C+GCsRVGdo
        tgoFJ8Vm/WiH6sxxJF1nBz9XVtDH9pICPsc4uiY43kxxcklgTkt27tY8nLRokabE
        iE0Z7o5X3IpaSb7+XIgBbHykNgDEqHvoPWK7UA8F9PXMm+LANBpcfs0pKRYto3zQ
        NQOX9IffUxx8wUsl5ZO7fpKIrLqWL0yNc97XL6Pte3IBiW7qcWaBJZ5WK6cQJBuR
        i1kpUFalft2s2w==
X-ME-Sender: <xms:jpG-XfGdnllhvEBPvT24_3yPnbaEOxFzvh931HiONr7deNzWEkxmTw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddutddgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:jpG-Xeppld9xWw6-DsBalyuWtd37WY_1NZ6o3NCVPgGeWzaQCf-Tcw>
    <xmx:jpG-Xf2xURxIhV9jtdJ1cvUniuCIMef4b43VnZs4rWGVmulq_f9A-Q>
    <xmx:jpG-XaAsG2mKVCR-5_cQrKkkzpXIm4Lc1bx5gAzznHmObCB6RIp-6Q>
    <xmx:jpG-XYZDvKnlqt_2HrdPmp1X9NicPugCrovaYCgJ8iCWze88ZJWFhw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2C66C306005B;
        Sun,  3 Nov 2019 03:36:29 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/6] mlxsw: core: Add EMAD string TLV
Date:   Sun,  3 Nov 2019 10:35:51 +0200
Message-Id: <20191103083554.6317-4-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191103083554.6317-1-idosch@idosch.org>
References: <20191103083554.6317-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

Add EMAD string TLV, an ASCII string the driver can receive from the
firmware in case of an error.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 19 +++++++++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/emad.h |  6 +++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 3d92956047d5..1803b246d9b4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -249,6 +249,25 @@ MLXSW_ITEM32(emad, op_tlv, class, 0x04, 0, 8);
  */
 MLXSW_ITEM64(emad, op_tlv, tid, 0x08, 0, 64);
 
+/* emad_string_tlv_type
+ * Type of the TLV.
+ * Must be set to 0x2 (string TLV).
+ */
+MLXSW_ITEM32(emad, string_tlv, type, 0x00, 27, 5);
+
+/* emad_string_tlv_len
+ * Length of the string TLV in u32.
+ */
+MLXSW_ITEM32(emad, string_tlv, len, 0x00, 16, 11);
+
+#define MLXSW_EMAD_STRING_TLV_STRING_LEN 128
+
+/* emad_string_tlv_string
+ * String provided by the device's firmware in case of erroneous register access
+ */
+MLXSW_ITEM_BUF(emad, string_tlv, string, 0x04,
+	       MLXSW_EMAD_STRING_TLV_STRING_LEN);
+
 /* emad_reg_tlv_type
  * Type of the TLV.
  * Must be set to 0x3 (register TLV).
diff --git a/drivers/net/ethernet/mellanox/mlxsw/emad.h b/drivers/net/ethernet/mellanox/mlxsw/emad.h
index 5d7c78419fa7..acfbbec52424 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/emad.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/emad.h
@@ -19,7 +19,8 @@
 enum {
 	MLXSW_EMAD_TLV_TYPE_END,
 	MLXSW_EMAD_TLV_TYPE_OP,
-	MLXSW_EMAD_TLV_TYPE_REG = 0x3,
+	MLXSW_EMAD_TLV_TYPE_STRING,
+	MLXSW_EMAD_TLV_TYPE_REG,
 };
 
 /* OP TLV */
@@ -86,6 +87,9 @@ enum {
 	MLXSW_EMAD_OP_TLV_METHOD_EVENT = 5,
 };
 
+/* STRING TLV */
+#define MLXSW_EMAD_STRING_TLV_LEN 33	/* Length in u32 */
+
 /* END TLV */
 #define MLXSW_EMAD_END_TLV_LEN 1	/* Length in u32 */
 
-- 
2.21.0

