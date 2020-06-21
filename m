Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8072029AA
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 10:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbgFUIez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 04:34:55 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40527 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729556AbgFUIey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 04:34:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 07D665C00F8;
        Sun, 21 Jun 2020 04:34:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 21 Jun 2020 04:34:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=7WR2iJLx+u+boIqOeUS9dn9WaL555MAfSiVEWBN7ZrY=; b=XjenSgDg
        D/J+O8NV1I1CDUVALjaNCHWRxLBmh7dTu7LA706JY7iGCDV9XEsD2fhhSj0Smrku
        p8hy4LVTzyh/pG96RIO/dvWlAifrHDUe1AvJkuwT8sWPcMYe/+CBYMDbUqLvGa0F
        CrzxyKqwjSlstD8vnrBeAWoG0gfUi4V2G2LwCb1m31M+vF+xZFc2SMco7/XY4ghN
        LnW/N4SZtDlQC/s7GMVEDg21zzQJdk7YRgxVMamTf2UCHf1VOAYAQ2kPLLyxLR8W
        3iIfbtpGlOriLJIfW6mPS3DJ3gPKlC28rozmusmenSROKlK4XvQ/y+0Eyi+iECJi
        jK0wFTKiNy35zQ==
X-ME-Sender: <xms:rBvvXjyH_jxwfa6JFYMGLoKIfztNIIG39NOcLKtobfQ-XOdf5AVDzg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudektddgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppedutdelrdeijedrkedruddvleen
    ucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:rBvvXrSYJaHlH5aBzRln7Y6vyADNMySc0MXDeD1A2Wftx5N7noQO4g>
    <xmx:rBvvXtUUhDmJmBKklZbKgP5XKM19jv-Djkh0xr_HY9V-M7EySKUwBg>
    <xmx:rBvvXtioM1dDb-lPDX6rqtmz88QF0THhSL9pB1zPzlpdTz8EFk10eQ>
    <xmx:rRvvXoN_gG-reguE15x4Jg-_Qcy0ljtCjKc97MoM9esGFf7mOZQ-Gg>
Received: from splinter.mtl.com (bzq-109-67-8-129.red.bezeqint.net [109.67.8.129])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9D4CB3066D7A;
        Sun, 21 Jun 2020 04:34:51 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/4] mlxsw: core_acl_flex_actions: Add L4_PORT_ACTION
Date:   Sun, 21 Jun 2020 11:34:34 +0300
Message-Id: <20200621083436.476806-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200621083436.476806-1-idosch@idosch.org>
References: <20200621083436.476806-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Add fields related to L4_PORT_ACTION, which is used for changing of TCP and
UDP port numbers.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../mellanox/mlxsw/core_acl_flex_actions.c    | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
index c3d04319ff44..a0bf0b86e25b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_actions.c
@@ -1684,3 +1684,29 @@ int mlxsw_afa_block_append_mcrouter(struct mlxsw_afa_block *block,
 	return 0;
 }
 EXPORT_SYMBOL(mlxsw_afa_block_append_mcrouter);
+
+/* L4 Port Action
+ * --------------
+ * The L4_PORT_ACTION is used for modifying the sport and dport fields of the packet, e.g. for NAT.
+ * If (the L4 is TCP) or if (the L4 is UDP and checksum field!=0) then the L4 checksum is updated.
+ */
+
+#define MLXSW_AFA_L4PORT_CODE 0x12
+#define MLXSW_AFA_L4PORT_SIZE 1
+
+enum mlxsw_afa_l4port_s_d {
+	/* configure src_l4_port */
+	MLXSW_AFA_L4PORT_S_D_SRC,
+	/* configure dst_l4_port */
+	MLXSW_AFA_L4PORT_S_D_DST,
+};
+
+/* afa_l4port_s_d
+ * Source or destination.
+ */
+MLXSW_ITEM32(afa, l4port, s_d, 0x00, 31, 1);
+
+/* afa_l4port_l4_port
+ * Number of port to change to.
+ */
+MLXSW_ITEM32(afa, l4port, l4_port, 0x08, 0, 16);
-- 
2.26.2

