Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7849B55FB2B
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 10:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbiF2I6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 04:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbiF2I6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 04:58:30 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E8FB4B2;
        Wed, 29 Jun 2022 01:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656493108; x=1688029108;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Beq/F3djt8kqwPMZlUOzGpv6gng0bk4dp4axW3sNFkw=;
  b=hcrDBWTIBipv1VCKLmzOBf5fJhmCoKs5Q1DU5fVR7zJo5Kzn+RTq4RC8
   oXmhrsAV5fEKxfbiUJZ018FoHnWoHODew81oKH2wakDACOMOc+ojiaezf
   gaY3laskD0mqJmMoBuX63xC4h6N/0jvKykezqgS7x8c8+R2wBkl6NJSh0
   v1Ha5vHhMf79IDNrlpux6TYP8itE+UyPrqVyJ39NfwjxX626jUMvnbw9h
   hoStwPLZbwWnpCcMMKxkYTmek/IHMkOhsjYjd4B4L7LJnmGz5R9qpasmD
   VBZshr9TXKoWk5aCgboDC0BEHkdPTDNTzjy06kl9y/H2EjgJ8lFUqg+Dn
   A==;
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="165594578"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jun 2022 01:58:27 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 29 Jun 2022 01:58:26 -0700
Received: from training-HP-280-G1-MT-PC.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 29 Jun 2022 01:58:21 -0700
From:   Divya Koppera <Divya.Koppera@microchip.com>
To:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <devicetree@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Madhuri.Sripada@microchip.com>
Subject: [PATCH v2 net-next 2/2] net: phy: micrel: Adding LED feature for LAN8814 PHY
Date:   Wed, 29 Jun 2022 14:28:00 +0530
Message-ID: <20220629085800.11600-3-Divya.Koppera@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220629085800.11600-1-Divya.Koppera@microchip.com>
References: <20220629085800.11600-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LED support for extended mode where
LED 1: Enhanced Mode 5 (10M/1000M/Activity)
LED 2: Enhanced Mode 4 (100M/1000M/Activity)

By default it supports KSZ9031 LED mode

Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
---
v1 -> v2:
- No changes

 drivers/net/phy/micrel.c | 71 +++++++++++++++++++++++++++++++---------
 1 file changed, 56 insertions(+), 15 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 22139901f01c..297e58d49159 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -209,6 +209,9 @@
 #define PTP_TSU_INT_STS_PTP_RX_TS_OVRFL_INT_	BIT(1)
 #define PTP_TSU_INT_STS_PTP_RX_TS_EN_		BIT(0)
 
+#define LAN8814_LED_CTRL_1			0x0
+#define LAN8814_LED_CTRL_1_KSZ9031_LED_MODE_	BIT(6)
+
 /* PHY Control 1 */
 #define MII_KSZPHY_CTRL_1			0x1e
 #define KSZ8081_CTRL1_MDIX_STAT			BIT(4)
@@ -308,6 +311,10 @@ struct kszphy_priv {
 	u64 stats[ARRAY_SIZE(kszphy_hw_stats)];
 };
 
+static const struct kszphy_type lan8814_type = {
+	.led_mode_reg		= ~LAN8814_LED_CTRL_1,
+};
+
 static const struct kszphy_type ksz8021_type = {
 	.led_mode_reg		= MII_KSZPHY_CTRL_2,
 	.has_broadcast_disable	= true,
@@ -1688,6 +1695,30 @@ static int kszphy_suspend(struct phy_device *phydev)
 	return genphy_suspend(phydev);
 }
 
+static void kszphy_parse_led_mode(struct phy_device *phydev)
+{
+	const struct kszphy_type *type = phydev->drv->driver_data;
+	const struct device_node *np = phydev->mdio.dev.of_node;
+	struct kszphy_priv *priv = phydev->priv;
+	int ret;
+
+	if (type && type->led_mode_reg) {
+		ret = of_property_read_u32(np, "micrel,led-mode",
+					   &priv->led_mode);
+
+		if (ret)
+			priv->led_mode = -1;
+
+		if (priv->led_mode > 3) {
+			phydev_err(phydev, "invalid led mode: 0x%02x\n",
+				   priv->led_mode);
+			priv->led_mode = -1;
+		}
+	} else {
+		priv->led_mode = -1;
+	}
+}
+
 static int kszphy_resume(struct phy_device *phydev)
 {
 	int ret;
@@ -1720,7 +1751,6 @@ static int kszphy_probe(struct phy_device *phydev)
 	const struct device_node *np = phydev->mdio.dev.of_node;
 	struct kszphy_priv *priv;
 	struct clk *clk;
-	int ret;
 
 	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -1730,20 +1760,7 @@ static int kszphy_probe(struct phy_device *phydev)
 
 	priv->type = type;
 
-	if (type && type->led_mode_reg) {
-		ret = of_property_read_u32(np, "micrel,led-mode",
-				&priv->led_mode);
-		if (ret)
-			priv->led_mode = -1;
-
-		if (priv->led_mode > 3) {
-			phydev_err(phydev, "invalid led mode: 0x%02x\n",
-				   priv->led_mode);
-			priv->led_mode = -1;
-		}
-	} else {
-		priv->led_mode = -1;
-	}
+	kszphy_parse_led_mode(phydev);
 
 	clk = devm_clk_get(&phydev->mdio.dev, "rmii-ref");
 	/* NOTE: clk may be NULL if building without CONFIG_HAVE_CLK */
@@ -2815,8 +2832,23 @@ static int lan8814_ptp_probe_once(struct phy_device *phydev)
 	return 0;
 }
 
+static void lan8814_setup_led(struct phy_device *phydev, int val)
+{
+	int temp;
+
+	temp = lan8814_read_page_reg(phydev, 5, LAN8814_LED_CTRL_1);
+
+	if (val)
+		temp |= LAN8814_LED_CTRL_1_KSZ9031_LED_MODE_;
+	else
+		temp &= ~LAN8814_LED_CTRL_1_KSZ9031_LED_MODE_;
+
+	lan8814_write_page_reg(phydev, 5, LAN8814_LED_CTRL_1, temp);
+}
+
 static int lan8814_config_init(struct phy_device *phydev)
 {
+	struct kszphy_priv *lan8814 = phydev->priv;
 	int val;
 
 	/* Reset the PHY */
@@ -2850,11 +2882,15 @@ static int lan8814_release_coma_mode(struct phy_device *phydev)
 	gpiod_set_consumer_name(gpiod, "LAN8814 coma mode");
 	gpiod_set_value_cansleep(gpiod, 0);
 
+	if (lan8814->led_mode >= 0)
+		lan8814_setup_led(phydev, lan8814->led_mode);
+
 	return 0;
 }
 
 static int lan8814_probe(struct phy_device *phydev)
 {
+	const struct kszphy_type *type = phydev->drv->driver_data;
 	struct kszphy_priv *priv;
 	u16 addr;
 	int err;
@@ -2867,6 +2903,10 @@ static int lan8814_probe(struct phy_device *phydev)
 
 	phydev->priv = priv;
 
+	priv->type = type;
+
+	kszphy_parse_led_mode(phydev);
+
 	/* Strap-in value for PHY address, below register read gives starting
 	 * phy address value
 	 */
@@ -3068,6 +3108,7 @@ static struct phy_driver ksphy_driver[] = {
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
 	.name		= "Microchip INDY Gigabit Quad PHY",
 	.config_init	= lan8814_config_init,
+	.driver_data	= &lan8814_type,
 	.probe		= lan8814_probe,
 	.soft_reset	= genphy_soft_reset,
 	.read_status	= ksz9031_read_status,
-- 
2.17.1

