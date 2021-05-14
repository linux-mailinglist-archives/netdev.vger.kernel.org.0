Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85DA381280
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 23:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233396AbhENVD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 17:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233622AbhENVCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 17:02:31 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3120AC061756;
        Fri, 14 May 2021 14:00:43 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id t4so647263ejo.0;
        Fri, 14 May 2021 14:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yrouvi/9fMa7pZwwu1IYTzVcHv3akTB20OT7DgY4UJw=;
        b=bZnneYn23Lk6U5XT+UYJeuq/BhMrJwfk2s8NfKv1LgELTFKvAopAz0yW3Ar5pLQ6wX
         ZuHSg3gL4cVo3XObb7Xc9s4QhWxqSJmULxR4awVM/4XlrVqZRsuRVt9oEX3Y6juWELc5
         RTkHPIqe7+tXen5593PO5VxYaykQyw1Qfykpgi8rgLNIxPd3eSOPfjuS/Epdwz/gQNgZ
         jub1BgLojXZl81SsRGkcPdEHLDiMicITBDSC7SvYz7qWyFnfyUpTSaIrquk9//dSFlg8
         XaxorXLnIp7906WoldgELrCPokFwur5Zy/NbRhMdTXxjPzk00yiF8tbclEM+hycykQpG
         yllQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yrouvi/9fMa7pZwwu1IYTzVcHv3akTB20OT7DgY4UJw=;
        b=Qdjl8bN+ljACHOTQ2RFw1PgtqerYgpbx1nrCW2OVbHEFcLmZPs9+TLTRnP3Rm6GY2a
         XPupB2HYutrrI7fPK+k2ebuDUl7WG5xa7HIfavWLEli8l8zYtgNuSA5TYUhTkWB4vKYS
         SdbDrBUbUegZrsbACRAcuNIbvt5SvarzTa0tF1t1QVEu2jdWAd4HKaZLnfXcEiM5vZqv
         F+zGLyxTHfwwPZaH59ecPsM4MBR97MF7LVQmuMIR+dAEqVBgq98XCHHxLSAGSyoZVLL/
         lys6OgLGpS3ggoLtaP/OSRpjta9UVNI8jFBhA0FgiqfZnAo2Muvi56PLltGunDTwxh4R
         NFRQ==
X-Gm-Message-State: AOAM530Zy1vFGfsCgd/+3mnmt+pPxdVT3crdNJBVdMk0TQvRFg2tsc5v
        oLOZQOksoothZyeZWq407yE=
X-Google-Smtp-Source: ABdhPJzvDYb4blbTLzB5A8o2FWjU5xn+7AMkskwRk+C66gCXbsXtBNckqTjxKq+oKK+pbWIj0ifewg==
X-Received: by 2002:a17:906:3bc6:: with SMTP id v6mr51407321ejf.165.1621026041774;
        Fri, 14 May 2021 14:00:41 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id c3sm5455237edn.16.2021.05.14.14.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 14:00:41 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH net-next v6 25/25] net: phy: add support for qca8k switch internal PHY in at803x
Date:   Fri, 14 May 2021 23:00:15 +0200
Message-Id: <20210514210015.18142-26-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210514210015.18142-1-ansuelsmth@gmail.com>
References: <20210514210015.18142-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the at803x share the same regs, it's assumed they are based on the
same implementation. Make it part of the at803x PHY driver to skip
having redudant code.
Add initial support for qca8k internal PHYs. The internal PHYs requires
special mmd and debug values to be set based on the switch revision
passwd using the dev_flags. Supports output of idle, receive and eee_wake
errors stats.
Some debug values sets can't be translated as the documentation lacks any
reference about them.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/phy/Kconfig  |   5 +-
 drivers/net/phy/at803x.c | 132 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 134 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 288bf405ebdb..25511f39b01f 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -247,10 +247,11 @@ config NXP_TJA11XX_PHY
 	  Currently supports the NXP TJA1100 and TJA1101 PHY.
 
 config AT803X_PHY
-	tristate "Qualcomm Atheros AR803X PHYs"
+	tristate "Qualcomm Atheros AR803X PHYs and QCA833x PHYs"
 	depends on REGULATOR
 	help
-	  Currently supports the AR8030, AR8031, AR8033 and AR8035 model
+	  Currently supports the AR8030, AR8031, AR8033, AR8035 and internal
+	  QCA8337(Internal qca8k PHY) model
 
 config QSEMI_PHY
 	tristate "Quality Semiconductor PHYs"
diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index d2378a73de6f..6697c9368b40 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -92,10 +92,16 @@
 #define AT803X_DEBUG_REG_5			0x05
 #define AT803X_DEBUG_TX_CLK_DLY_EN		BIT(8)
 
+#define AT803X_DEBUG_REG_3C			0x3C
+
+#define AT803X_DEBUG_REG_3D			0x3D
+
 #define AT803X_DEBUG_REG_1F			0x1F
 #define AT803X_DEBUG_PLL_ON			BIT(2)
 #define AT803X_DEBUG_RGMII_1V8			BIT(3)
 
+#define MDIO_AZ_DEBUG				0x800D
+
 /* AT803x supports either the XTAL input pad, an internal PLL or the
  * DSP as clock reference for the clock output pad. The XTAL reference
  * is only used for 25 MHz output, all other frequencies need the PLL.
@@ -144,6 +150,12 @@
 #define ATH8035_PHY_ID				0x004dd072
 #define AT8030_PHY_ID_MASK			0xffffffef
 
+#define QCA8327_PHY_ID				0x004dd034
+#define QCA8337_PHY_ID				0x004dd036
+#define QCA8K_PHY_ID_MASK			0xffffffff
+
+#define QCA8K_DEVFLAGS_REVISION_MASK		GENMASK(2, 0)
+
 #define AT803X_PAGE_FIBER			0
 #define AT803X_PAGE_COPPER			1
 
@@ -155,6 +167,24 @@ MODULE_DESCRIPTION("Qualcomm Atheros AR803x PHY driver");
 MODULE_AUTHOR("Matus Ujhelyi");
 MODULE_LICENSE("GPL");
 
+enum stat_access_type {
+	PHY,
+	MMD
+};
+
+struct at803x_hw_stat {
+	const char *string;
+	u8 reg;
+	u32 mask;
+	enum stat_access_type access_type;
+};
+
+static struct at803x_hw_stat at803x_hw_stats[] = {
+	{ "phy_idle_errors", 0xa, GENMASK(7, 0), PHY},
+	{ "phy_receive_errors", 0x15, GENMASK(15, 0), PHY},
+	{ "eee_wake_errors", 0x16, GENMASK(15, 0), MMD},
+};
+
 struct at803x_priv {
 	int flags;
 	u16 clk_25m_reg;
@@ -164,6 +194,7 @@ struct at803x_priv {
 	struct regulator_dev *vddio_rdev;
 	struct regulator_dev *vddh_rdev;
 	struct regulator *vddio;
+	u64 stats[ARRAY_SIZE(at803x_hw_stats)];
 };
 
 struct at803x_context {
@@ -175,6 +206,17 @@ struct at803x_context {
 	u16 led_control;
 };
 
+static int at803x_debug_reg_write(struct phy_device *phydev, u16 reg, u16 data)
+{
+	int ret;
+
+	ret = phy_write(phydev, AT803X_DEBUG_ADDR, reg);
+	if (ret < 0)
+		return ret;
+
+	return phy_write(phydev, AT803X_DEBUG_DATA, data);
+}
+
 static int at803x_debug_reg_read(struct phy_device *phydev, u16 reg)
 {
 	int ret;
@@ -337,6 +379,53 @@ static void at803x_get_wol(struct phy_device *phydev,
 		wol->wolopts |= WAKE_MAGIC;
 }
 
+static int at803x_get_sset_count(struct phy_device *phydev)
+{
+	return ARRAY_SIZE(at803x_hw_stats);
+}
+
+static void at803x_get_strings(struct phy_device *phydev, u8 *data)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(at803x_hw_stats); i++) {
+		strscpy(data + i * ETH_GSTRING_LEN,
+			at803x_hw_stats[i].string, ETH_GSTRING_LEN);
+	}
+}
+
+static u64 at803x_get_stat(struct phy_device *phydev, int i)
+{
+	struct at803x_hw_stat stat = at803x_hw_stats[i];
+	struct at803x_priv *priv = phydev->priv;
+	int val;
+	u64 ret;
+
+	if (stat.access_type == MMD)
+		val = phy_read_mmd(phydev, MDIO_MMD_PCS, stat.reg);
+	else
+		val = phy_read(phydev, stat.reg);
+
+	if (val < 0) {
+		ret = U64_MAX;
+	} else {
+		val = val & stat.mask;
+		priv->stats[i] += val;
+		ret = priv->stats[i];
+	}
+
+	return ret;
+}
+
+static void at803x_get_stats(struct phy_device *phydev,
+			     struct ethtool_stats *stats, u64 *data)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(at803x_hw_stats); i++)
+		data[i] = at803x_get_stat(phydev, i);
+}
+
 static int at803x_suspend(struct phy_device *phydev)
 {
 	int value;
@@ -1172,6 +1261,34 @@ static int at803x_cable_test_start(struct phy_device *phydev)
 	return 0;
 }
 
+static int qca83xx_config_init(struct phy_device *phydev)
+{
+	u8 switch_revision;
+
+	switch_revision = phydev->dev_flags & QCA8K_DEVFLAGS_REVISION_MASK;
+
+	switch (switch_revision) {
+	case 1:
+		/* For 100M waveform */
+		at803x_debug_reg_write(phydev, AT803X_DEBUG_REG_0, 0x02ea);
+		/* Turn on Gigabit clock */
+		at803x_debug_reg_write(phydev, AT803X_DEBUG_REG_3D, 0x68a0);
+		break;
+
+	case 2:
+		phy_write_mmd(phydev, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0x0);
+		fallthrough;
+	case 4:
+		phy_write_mmd(phydev, MDIO_MMD_PCS, MDIO_AZ_DEBUG, 0x803f);
+		at803x_debug_reg_write(phydev, AT803X_DEBUG_REG_3D, 0x6860);
+		at803x_debug_reg_write(phydev, AT803X_DEBUG_REG_5, 0x2c46);
+		at803x_debug_reg_write(phydev, AT803X_DEBUG_REG_3C, 0x6000);
+		break;
+	}
+
+	return 0;
+}
+
 static struct phy_driver at803x_driver[] = {
 {
 	/* Qualcomm Atheros AR8035 */
@@ -1268,7 +1385,20 @@ static struct phy_driver at803x_driver[] = {
 	.read_status		= at803x_read_status,
 	.soft_reset		= genphy_soft_reset,
 	.config_aneg		= at803x_config_aneg,
-} };
+}, {
+	/* QCA8337 */
+	.phy_id = QCA8337_PHY_ID,
+	.phy_id_mask = QCA8K_PHY_ID_MASK,
+	.name = "QCA PHY 8337",
+	/* PHY_GBIT_FEATURES */
+	.probe = at803x_probe,
+	.flags = PHY_IS_INTERNAL,
+	.config_init = qca83xx_config_init,
+	.soft_reset = genphy_soft_reset,
+	.get_sset_count = at803x_get_sset_count,
+	.get_strings = at803x_get_strings,
+	.get_stats = at803x_get_stats,
+}, };
 
 module_phy_driver(at803x_driver);
 
-- 
2.30.2

