Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F147723078A
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 12:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgG1KUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 06:20:52 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:35659 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728755AbgG1KUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 06:20:52 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id AA0165C018D;
        Tue, 28 Jul 2020 06:20:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 28 Jul 2020 06:20:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=7w4orU/Symd+k9aINvRBNFXLm0USfhzg0ncgLZE9mkE=; b=d7eOZlo+
        n/5ucfdsyiBYyBwVM5X18V+zqM5y6yaruW5+H2msCgJ5xQJZaoB2HZ8piwugrqQz
        1uTI6akRoZblduyac/B4NBh1tZ2+Gm1tQPUyiR7GWrAA7qYZ0ZQovPaMSrbFNt/e
        ul0X0dbt9RQMfWbdGOs/D1Y4+ecNWJjQHwz6LIrnOt9tkmnIibmpAeFvhkBu28Yo
        vXNv0TFpzMHhJExmy9OU9/0gyKEa9Q3YIBCEa+3ZgRhET4OPH9alPk9ROE0o7PF+
        bbE/jJzXrtzw423qK/h/cc+tk5pGFGAifmiQok9djwkBCfxA9pTicpLpP8yh5ZZa
        Rv3HiThWP54NFw==
X-ME-Sender: <xms:AvwfX_2lVEy0N1symhKYSCGxB0G9cxGVWCuzWE0zDl-O9NoHD4f-tA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedriedvgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepjeelrddukedurddvrddujeelnecu
    vehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:AvwfX-EWXkBVqyHzoiVaMDcsKdUXjcE_P76DRufynrfRZ4cFZcOehA>
    <xmx:AvwfX_47ah2SBtOlLoz9DK8jumq1Zu0KO1lT_ZLloPS4R3IC-5_SMg>
    <xmx:AvwfX00rLc-O97ZeB2vIU95NcPifHsbFbkxN3WD1aUhRasmhzIfo8g>
    <xmx:AvwfX-hKpnkqri5SEcFeMVYNr5H79oAbXGwU32IYsnjQ3zNmAnBkcg>
Received: from shredder.mtl.com (bzq-79-181-2-179.red.bezeqint.net [79.181.2.179])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0E04530600A6;
        Tue, 28 Jul 2020 06:20:47 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, andrew@lunn.ch, popadrian1996@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 2/2] mlxsw: core: Add support for temperature thresholds reading for QSFP-DD transceivers
Date:   Tue, 28 Jul 2020 13:20:16 +0300
Message-Id: <20200728102016.1960193-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728102016.1960193-1-idosch@idosch.org>
References: <20200728102016.1960193-1-idosch@idosch.org>
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
 .../net/ethernet/mellanox/mlxsw/core_env.c    | 32 +++++++++++++------
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  1 +
 2 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 1828dc569524..44fa02cbb683 100644
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
@@ -117,7 +121,8 @@ int mlxsw_env_module_temp_thresholds_get(struct mlxsw_core *core, int module,
 	char mcia_pl[MLXSW_REG_MCIA_LEN] = {0};
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
 	unsigned int module_temp;
-	bool qsfp;
+	bool qsfp, cmis;
+	int page;
 	int err;
 
 	mlxsw_reg_mtmp_pack(mtmp_pl, MLXSW_REG_MTMP_MODULE_INDEX_MIN + module,
@@ -141,21 +146,28 @@ int mlxsw_env_module_temp_thresholds_get(struct mlxsw_core *core, int module,
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
@@ -252,8 +264,8 @@ int mlxsw_env_get_module_eeprom(struct net_device *netdev,
 {
 	int offset = ee->offset;
 	unsigned int read_size;
+	bool qsfp, cmis;
 	int i = 0;
-	bool qsfp;
 	int err;
 
 	if (!ee->len)
@@ -261,7 +273,7 @@ int mlxsw_env_get_module_eeprom(struct net_device *netdev,
 
 	memset(data, 0, ee->len);
 	/* Validate module identifier value. */
-	err = mlxsw_env_validate_cable_ident(mlxsw_core, module, &qsfp);
+	err = mlxsw_env_validate_cable_ident(mlxsw_core, module, &qsfp, &cmis);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 0638dfb23b7e..1d23ad70e83d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8605,6 +8605,7 @@ MLXSW_ITEM32(reg, mcia, size, 0x08, 0, 16);
 #define MLXSW_REG_MCIA_PAGE0_LO_OFF		0xa0
 #define MLXSW_REG_MCIA_TH_ITEM_SIZE		2
 #define MLXSW_REG_MCIA_TH_PAGE_NUM		3
+#define MLXSW_REG_MCIA_TH_PAGE_CMIS_NUM		2
 #define MLXSW_REG_MCIA_PAGE0_LO			0
 #define MLXSW_REG_MCIA_TH_PAGE_OFF		0x80
 #define MLXSW_REG_MCIA_EEPROM_CMIS_FLAT_MEMORY	BIT(7)
-- 
2.26.2

