Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1490526A116
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 10:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgIOImI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 04:42:08 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36909 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726285AbgIOIlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 04:41:55 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 056175C012C;
        Tue, 15 Sep 2020 04:41:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 15 Sep 2020 04:41:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=b+nxJjp0FfSyYPsIo66BRkZCPpHi7L4/v+JNR3ze888=; b=n6o8hmY+
        p41xPebZQc3/Lb/Aj1khvuznR9KxL3OCKvNLQJSV9rv70ylqipia4pwJoBV12Qhr
        spvCqCvenSMy3I7WhXJvvpujGrSplds5TMZSYgYRpHqYajzLKwOY5d+bZB6LntnW
        DjK77JNdwH9Vjbavai6qG5pN9PW6itGjBTiK30r70bwBBTDIIrWUklEDFgfF37TY
        dFAR1g7o315ibEv9RdJp9m0ydcw9FtB35Jm6jIxfiujxHvHpn6r2MIEPyZEQu84N
        BZMAKzto195bXgql7OJ23Gpup8LZkz74SK1HT9Np8b9dekxuCqAAsmDK56NceIzg
        iDfiB7zJbmBJfQ==
X-ME-Sender: <xms:UX5gX_ojw0wc4jvqmIZydnkq0G-VUlKxEdruH3Hb3VuIEL8AfP7_zQ>
    <xme:UX5gX5oJ1z_Ps8if9TGjiqdvNMbcUvvPNTQbNGUAPbWEUL9MD1ilnINAXHhEEkm_M
    8ul4YvYsmUeM1o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeikedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdekvden
    ucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:UX5gX8PKh74I73nnPvuBpRegZpOnfqvqOVlgasmx4mxw8e1w7e2bBA>
    <xmx:UX5gXy7zo2qDG9U_ET6bW4yV_UAtK5s3BVJeboVmKUBRD2uq_Kutcw>
    <xmx:UX5gX-6i9QJeaGHKdL7dA8PqBVxBjpZSD_Jkv_pjwaVJLrfxQTwBlg>
    <xmx:Un5gX-HfDA3Yt-o33-a12Y7MPa8FLFkgbsKri4whgGV8TZ3DEzJ0Rg>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2FE433064682;
        Tue, 15 Sep 2020 04:41:51 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 6/8] mlxsw: reg: Add Monitoring FW General Debug Register
Date:   Tue, 15 Sep 2020 11:40:56 +0300
Message-Id: <20200915084058.18555-7-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915084058.18555-1-idosch@idosch.org>
References: <20200915084058.18555-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Introduce MFGD register that is used to configure firmware debugging.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index f53761114f5a..421f02eac20f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -9821,6 +9821,26 @@ static inline void mlxsw_reg_mtptptp_pack(char *payload,
 	mlxsw_reg_mtptpt_message_type_set(payload, message_type);
 }
 
+/* MFGD - Monitoring FW General Debug Register
+ * -------------------------------------------
+ */
+#define MLXSW_REG_MFGD_ID 0x90F0
+#define MLXSW_REG_MFGD_LEN 0x0C
+
+MLXSW_REG_DEFINE(mfgd, MLXSW_REG_MFGD_ID, MLXSW_REG_MFGD_LEN);
+
+/* reg_mfgd_fw_fatal_event_mode
+ * 0 - don't check FW fatal (default)
+ * 1 - check FW fatal - enable MFDE trap
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, mfgd, fatal_event_mode, 0x00, 9, 2);
+
+/* reg_mfgd_trigger_test
+ * Access: WO
+ */
+MLXSW_ITEM32(reg, mfgd, trigger_test, 0x00, 11, 1);
+
 /* MGPIR - Management General Peripheral Information Register
  * ----------------------------------------------------------
  * MGPIR register allows software to query the hardware and
@@ -11071,6 +11091,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(mtpppc),
 	MLXSW_REG(mtpptr),
 	MLXSW_REG(mtptpt),
+	MLXSW_REG(mfgd),
 	MLXSW_REG(mgpir),
 	MLXSW_REG(mfde),
 	MLXSW_REG(tngcr),
-- 
2.26.2

