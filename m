Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A6E206EE2
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 10:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390402AbgFXIUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 04:20:42 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:36439 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390399AbgFXIUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 04:20:39 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id B5E76580519;
        Wed, 24 Jun 2020 04:20:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 24 Jun 2020 04:20:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=mK/jGObV75lW+BfipXFfAqtiZbn44gTuChZX90M17hM=; b=X5m+vJRq
        r+DbcIMkG7Kx76n3RPlHNvkZvSIFpHfsHF5cFR1z7eP0QVjO7nrKtBCxnliinZ3A
        T1FeOPgKPJGpDNmzvdYGRkiHH7uYP7eXMrJyMx+1d62/Oh9/tJq93hjQRWwpdMIR
        gIwo1X0EGR80jX+JAtT1WI93jZ4kJsyhcLFli9xn9tuNwenTENF1JgYMG/Ha12J0
        gfR/Z2WiTCUumovDalnlLR44H5SYZyFx6McpEbgK2nLBuMQB2IhiDs2w4b//+z32
        aMtn1SY4dTlro3QJZ+jVuBgJtwUkdAugnbYlHFnNgI1uJhk34GR/5DRSw3Qux7F2
        mejSw+3J+4VWmg==
X-ME-Sender: <xms:0wzzXvy49YXLJz1fEIbJM8KLdNLEQnMx9kaIVt6Dg5guG6YLN8d4WA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekjedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeduleefrdegjedrudeihedrvdeh
    udenucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:0wzzXnRHGCZgEpQLdohZWXAMRpmADAcI10m402pVvGbFTirDPws-RQ>
    <xmx:0wzzXpX82HYYk5AdJbQGAx2XvV_FYVfn_d4Bb7unvnLQCi293PytVA>
    <xmx:0wzzXpjVkOG6OOLn_rOY-A7tgkH7QZBl8kcBAHO1OPXER7f081P9qA>
    <xmx:0wzzXl00RGrFi1tZZlLb7Hyb9Bdi3twd1i5y46jvwhjx7gADAImAIg>
Received: from shredder.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B708D30675F9;
        Wed, 24 Jun 2020 04:20:32 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        mkubecek@suse.cz, jacob.e.keller@intel.com, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@rempel-privat.de,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 06/10] mlxsw: reg: Port Diagnostics Database Register
Date:   Wed, 24 Jun 2020 11:19:19 +0300
Message-Id: <20200624081923.89483-7-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624081923.89483-1-idosch@idosch.org>
References: <20200624081923.89483-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

The PDDR register enables to read the Phy debug database.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 51 +++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index fcb88d4271bf..b76c839223b5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5438,6 +5438,56 @@ static inline void mlxsw_reg_pplr_pack(char *payload, u8 local_port,
 				 MLXSW_REG_PPLR_LB_TYPE_BIT_PHY_LOCAL : 0);
 }
 
+/* PDDR - Port Diagnostics Database Register
+ * -----------------------------------------
+ * The PDDR enables to read the Phy debug database
+ */
+#define MLXSW_REG_PDDR_ID 0x5031
+#define MLXSW_REG_PDDR_LEN 0x100
+
+MLXSW_REG_DEFINE(pddr, MLXSW_REG_PDDR_ID, MLXSW_REG_PDDR_LEN);
+
+/* reg_pddr_local_port
+ * Local port number.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, pddr, local_port, 0x00, 16, 8);
+
+enum mlxsw_reg_pddr_page_select {
+	MLXSW_REG_PDDR_PAGE_SELECT_TROUBLESHOOTING_INFO = 1,
+};
+
+/* reg_pddr_page_select
+ * Page select index.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, pddr, page_select, 0x04, 0, 8);
+
+enum mlxsw_reg_pddr_trblsh_group_opcode {
+	/* Monitor opcodes */
+	MLXSW_REG_PDDR_TRBLSH_GROUP_OPCODE_MONITOR,
+};
+
+/* reg_pddr_group_opcode
+ * Group selector.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, pddr, trblsh_group_opcode, 0x08, 0, 16);
+
+/* reg_pddr_status_opcode
+ * Group selector.
+ * Access: RO
+ */
+MLXSW_ITEM32(reg, pddr, trblsh_status_opcode, 0x0C, 0, 16);
+
+static inline void mlxsw_reg_pddr_pack(char *payload, u8 local_port,
+				       u8 page_select)
+{
+	MLXSW_REG_ZERO(pddr, payload);
+	mlxsw_reg_pddr_local_port_set(payload, local_port);
+	mlxsw_reg_pddr_page_select_set(payload, page_select);
+}
+
 /* PMTM - Port Module Type Mapping Register
  * ----------------------------------------
  * The PMTM allows query or configuration of module types.
@@ -10758,6 +10808,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(pbmc),
 	MLXSW_REG(pspa),
 	MLXSW_REG(pplr),
+	MLXSW_REG(pddr),
 	MLXSW_REG(pmtm),
 	MLXSW_REG(htgt),
 	MLXSW_REG(hpkt),
-- 
2.26.2

