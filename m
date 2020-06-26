Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFB920B3F8
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 16:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729461AbgFZOsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 10:48:25 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59711 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727112AbgFZOsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 10:48:23 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E2E4E5C00E1;
        Fri, 26 Jun 2020 10:48:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 26 Jun 2020 10:48:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=0s9o1GcyW00gCRuSbDOYN2xxbtUq+3zYo7jiWHYyGKE=; b=Ot9t7qO0
        4mM8JpaAvzww6nWBlLG8aZq2pWwQUNxYEUHggMTZiWfXMSnngh4Lr9wqg9BWC4XC
        2Tc3Ov+0/SAYGynfRfkEiCArJ1B9fS+c3PhIm2zkMcwOzMou/Ei4RxA/oRmvqAkG
        v1oPAofT/twAVjSrGvPJdoiESdbgsGJERRdhkUq++LcCYkk1adez03OkAU/4mRT0
        i50qZBjaqNJdTdozo8bsZ86+iNL88qQEqb+79XlyMPoiinvLsxt8AMxDcP0+wh9v
        IWs0EPKVhgR0KCttHI9vOxpdybAeYqQ6vfbtx8bT6CZAhLnfisW5p2B/wRF5vHhr
        7/7dpqFO0EqwVg==
X-ME-Sender: <xms:tgr2XohamTsSoOpr_6x4mJ3ySqoKTVe38jDmxisNiIHZFl2v091yOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeluddgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppedutdelrdeiiedrudelrddufeef
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:tgr2XhDY99Q1UC1ka9yTyAULxUA7QODZoLcKp2IaiCIfKuvAdf8j9g>
    <xmx:tgr2XgG3xV__NuMGK5x_zeHWFH_wH_yFE7avkeO1yPQfOnXXqR4WWw>
    <xmx:tgr2XpQ9aUEe7aFCpI-IeVsECwS9IgWRLO5mHSA9ByCVNGSd84KEpw>
    <xmx:tgr2XntGwxE1cnmhpxGwDDOhZS7bM7VE6dq5KZ2Sk1AfdGW3I2aPcA>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5F061306791B;
        Fri, 26 Jun 2020 10:48:20 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, andrew@lunn.ch, popadrian1996@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/2] mlxsw: core: Add support for temperature thresholds reading for QSFP-DD transceivers
Date:   Fri, 26 Jun 2020 17:47:24 +0300
Message-Id: <20200626144724.224372-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200626144724.224372-1-idosch@idosch.org>
References: <20200626144724.224372-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

Allow QSFP-DD transceivers temperature thresholds reading for hardware
monitoring and thermal control.

For this type, the thresholds are located in page 02h according to the
"Module and Lane Thresholds" description from Common Management
Interface Specification.

Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 28 +++++++++++++------
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  1 +
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 68f198afc9b0..94a208a7367f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -11,7 +11,7 @@
 #include "reg.h"
 
 static int mlxsw_env_validate_cable_ident(struct mlxsw_core *core, int id,
-					  bool *qsfp)
+					  bool *qsfp, bool *cmis)
 {
 	char eeprom_tmp[MLXSW_REG_MCIA_EEPROM_SIZE];
 	char mcia_pl[MLXSW_REG_MCIA_LEN];
@@ -25,15 +25,19 @@ static int mlxsw_env_validate_cable_ident(struct mlxsw_core *core, int id,
 		return err;
 	mlxsw_reg_mcia_eeprom_memcpy_from(mcia_pl, eeprom_tmp);
 	ident = eeprom_tmp[0];
+	*cmis = false;
 	switch (ident) {
 	case MLXSW_REG_MCIA_EEPROM_MODULE_INFO_ID_SFP:
 		*qsfp = false;
 		break;
 	case MLXSW_REG_MCIA_EEPROM_MODULE_INFO_ID_QSFP: /* fall-through */
 	case MLXSW_REG_MCIA_EEPROM_MODULE_INFO_ID_QSFP_PLUS: /* fall-through */
-	case MLXSW_REG_MCIA_EEPROM_MODULE_INFO_ID_QSFP28: /* fall-through */
+	case MLXSW_REG_MCIA_EEPROM_MODULE_INFO_ID_QSFP28:
+		*qsfp = true;
+		break;
 	case MLXSW_REG_MCIA_EEPROM_MODULE_INFO_ID_QSFP_DD:
 		*qsfp = true;
+		*cmis = true;
 		break;
 	default:
 		return -EINVAL;
@@ -106,7 +110,8 @@ int mlxsw_env_module_temp_thresholds_get(struct mlxsw_core *core, int module,
 	char mcia_pl[MLXSW_REG_MCIA_LEN] = {0};
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
 	unsigned int module_temp;
-	bool qsfp;
+	bool qsfp, cmis;
+	int page;
 	int err;
 
 	mlxsw_reg_mtmp_pack(mtmp_pl, MLXSW_REG_MTMP_MODULE_INDEX_MIN + module,
@@ -130,21 +135,28 @@ int mlxsw_env_module_temp_thresholds_get(struct mlxsw_core *core, int module,
 	 */
 
 	/* Validate module identifier value. */
-	err = mlxsw_env_validate_cable_ident(core, module, &qsfp);
+	err = mlxsw_env_validate_cable_ident(core, module, &qsfp, &cmis);
 	if (err)
 		return err;
 
-	if (qsfp)
-		mlxsw_reg_mcia_pack(mcia_pl, module, 0,
-				    MLXSW_REG_MCIA_TH_PAGE_NUM,
+	if (qsfp) {
+		/* For QSFP/CMIS module-defined thresholds are located in page
+		 * 02h, otherwise in page 03h.
+		 */
+		if (cmis)
+			page = MLXSW_REG_MCIA_TH_PAGE_CMIS_NUM;
+		else
+			page = MLXSW_REG_MCIA_TH_PAGE_NUM;
+		mlxsw_reg_mcia_pack(mcia_pl, module, 0, page,
 				    MLXSW_REG_MCIA_TH_PAGE_OFF + off,
 				    MLXSW_REG_MCIA_TH_ITEM_SIZE,
 				    MLXSW_REG_MCIA_I2C_ADDR_LOW);
-	else
+	} else {
 		mlxsw_reg_mcia_pack(mcia_pl, module, 0,
 				    MLXSW_REG_MCIA_PAGE0_LO,
 				    off, MLXSW_REG_MCIA_TH_ITEM_SIZE,
 				    MLXSW_REG_MCIA_I2C_ADDR_HIGH);
+	}
 
 	err = mlxsw_reg_query(core, MLXSW_REG(mcia), mcia_pl);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 73cc7fd5020c..55da011ad19e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8546,6 +8546,7 @@ MLXSW_ITEM32(reg, mcia, size, 0x08, 0, 16);
 #define MLXSW_REG_MCIA_PAGE0_LO_OFF		0xa0
 #define MLXSW_REG_MCIA_TH_ITEM_SIZE		2
 #define MLXSW_REG_MCIA_TH_PAGE_NUM		3
+#define MLXSW_REG_MCIA_TH_PAGE_CMIS_NUM		2
 #define MLXSW_REG_MCIA_PAGE0_LO			0
 #define MLXSW_REG_MCIA_TH_PAGE_OFF		0x80
 #define MLXSW_REG_MCIA_EEPROM_CMIS_FLAT_MEMORY	BIT(7)
-- 
2.26.2

