Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6AC20E096
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730821AbgF2Urk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:47:40 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:60289 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389809AbgF2Urh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:47:37 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 55E495800BF;
        Mon, 29 Jun 2020 16:47:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 29 Jun 2020 16:47:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=mK/jGObV75lW+BfipXFfAqtiZbn44gTuChZX90M17hM=; b=pdgojH/e
        6mgUzx1Rv07ZsoNlylbvTMMZCXE4LBSPy5y4alG19dATspUUA3EEYEPeHLI0BY7/
        u4F7LCfDQNjYST8bGSFSQerjVruh+IQtOj7K0QwKfVuL28Z7iLtRRX1Q1VkiPDXN
        28ScfHFVde1QOxhYPR9RhxhDZUcf9muAiW0f6obGCE2YDPq/sLDumLB94gOck+DO
        rFh6RVelZvAswRSd6mOBoXXRiZCLeOPs7KgpoPwQeyO7HiBu2MlhW1r8jzsUWL4a
        mpffzpcs+CQfyKHg0GmiiSjgJplR8JkX4pDTumfn2okusZbVwoS5BRSEoFp3+hHq
        0tBeXGRCdFK+bQ==
X-ME-Sender: <xms:aFP6Xj8u3I1ADrkWEns1Tryg2C0or0wPLMFsBh0HyVmA8pPy8g6BUw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudelledgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppedutdelrdeiiedrudelrddufeef
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:aFP6XvtmVsT2FFwWC7Suv-2XMKPtZTpcs0onvGUQOKWjUJQvHAE3UQ>
    <xmx:aFP6XhCzE8qQ1N4uFAinShbwcv2cm07bje0yTa1D8XUdSaQU01JSvg>
    <xmx:aFP6XvcJ5_QtAA1IIpKOHX3DawUJuPXb32PXSvWLGWTuBAiNa8U4Zw>
    <xmx:aFP6Xph_VdEXjOylQn_KYLkCq1D6wrtZQgiexKc8cT92-Xp0APceBw>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 65CE6328005A;
        Mon, 29 Jun 2020 16:47:33 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        mkubecek@suse.cz, jacob.e.keller@intel.com, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@rempel-privat.de,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 06/10] mlxsw: reg: Port Diagnostics Database Register
Date:   Mon, 29 Jun 2020 23:46:17 +0300
Message-Id: <20200629204621.377239-7-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200629204621.377239-1-idosch@idosch.org>
References: <20200629204621.377239-1-idosch@idosch.org>
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

