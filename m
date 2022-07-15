Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046195764FD
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 18:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbiGOQCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 12:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233017AbiGOQBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 12:01:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F6672ECB;
        Fri, 15 Jul 2022 09:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Lqc9QNWxCRE0ZTswNQFjHonNK/1BZ9qUO9q3VIDngCQ=; b=gYicktMMGSidoeux9ONWCsOl6r
        d4j5l757pnf2tmUl7dVOq+3DPXPO8e8PJo9ot8rem26vB+oI/lcg870EhmLqI3W/GtKLoHyTiK14R
        GCzqOV9d8jtIeIMakkx8NoRXlJsPaSq5cec4uYa+TfXBPDlnPoH1rhOCvPGOQKaTeo/Qm11W6pKpu
        1fIR2NzDJfkYA6ug0chPnZaMJg9snhoCicbkHtLY9+UysGmZUaMcDf1Zua6E8QaKylysRhbRRz5Zq
        xQJcCd0X2FXG+h6nRJSP/xMfcIqaJAjxgznq9VPYVmROtgaUHdR6aj24+UlcLnpPHPHJzIVMbW/ZQ
        k+05Ad0A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46050 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oCNl4-0007D2-Gj; Fri, 15 Jul 2022 17:01:38 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oCNl3-006e3n-PT; Fri, 15 Jul 2022 17:01:37 +0100
In-Reply-To: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Alvin __ipraga" <alsi@bang-olufsen.dk>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: [PATCH net-next 3/6] net: dsa: add support for retrieving the
 interface mode
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oCNl3-006e3n-PT@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 15 Jul 2022 17:01:37 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA port bindings allow for an optional phy interface mode. When an
interface mode is not specified, DSA uses the NA interface mode type.

However, phylink needs to know the parameters of the link, and this
will become especially important when using phylink for ports that
are devoid of all properties except the required "reg" property, so
that phylink can select the maximum supported link settings. Without
knowing the interface mode, phylink can't truely know the maximum
link speed.

Update the prototype for the phylink_get_caps method to allow drivers
to report this information back to DSA, and update all DSA
implementations function declarations to cater for this change. No
code is added to the implementations.

Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/b53/b53_common.c       |  3 ++-
 drivers/net/dsa/bcm_sf2.c              |  3 ++-
 drivers/net/dsa/hirschmann/hellcreek.c |  3 ++-
 drivers/net/dsa/lantiq_gswip.c         |  6 ++++--
 drivers/net/dsa/microchip/ksz_common.c |  3 ++-
 drivers/net/dsa/mt7530.c               |  3 ++-
 drivers/net/dsa/mv88e6xxx/chip.c       |  3 ++-
 drivers/net/dsa/ocelot/felix.c         |  3 ++-
 drivers/net/dsa/qca/ar9331.c           |  3 ++-
 drivers/net/dsa/qca8k.c                |  3 ++-
 drivers/net/dsa/realtek/rtl8365mb.c    |  3 ++-
 drivers/net/dsa/sja1105/sja1105_main.c |  3 ++-
 drivers/net/dsa/xrs700x/xrs700x.c      |  3 ++-
 include/net/dsa.h                      |  3 ++-
 net/dsa/port.c                         | 23 +++++++++++++++++------
 15 files changed, 47 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 48cf344750ff..fe75b84ab791 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1310,7 +1310,8 @@ void b53_port_event(struct dsa_switch *ds, int port)
 EXPORT_SYMBOL(b53_port_event);
 
 static void b53_phylink_get_caps(struct dsa_switch *ds, int port,
-				 struct phylink_config *config)
+				 struct phylink_config *config,
+				 phy_interface_t *default_interface)
 {
 	struct b53_device *dev = ds->priv;
 
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index be0edfa093d0..18a3847bd82b 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -713,7 +713,8 @@ static u32 bcm_sf2_sw_get_phy_flags(struct dsa_switch *ds, int port)
 }
 
 static void bcm_sf2_sw_get_caps(struct dsa_switch *ds, int port,
-				struct phylink_config *config)
+				struct phylink_config *config,
+				phy_interface_t *default_interface)
 {
 	unsigned long *interfaces = config->supported_interfaces;
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 01f90994dedd..6c1ef6997789 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1462,7 +1462,8 @@ static void hellcreek_teardown(struct dsa_switch *ds)
 }
 
 static void hellcreek_phylink_get_caps(struct dsa_switch *ds, int port,
-				       struct phylink_config *config)
+				       struct phylink_config *config,
+				       phy_interface_t *default_interface)
 {
 	struct hellcreek *hellcreek = ds->priv;
 
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index e531b93f3cb2..a43dabfa5453 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1492,7 +1492,8 @@ static int gswip_port_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 }
 
 static void gswip_xrx200_phylink_get_caps(struct dsa_switch *ds, int port,
-					  struct phylink_config *config)
+					  struct phylink_config *config,
+					  phy_interface_t *default_interface)
 {
 	switch (port) {
 	case 0:
@@ -1525,7 +1526,8 @@ static void gswip_xrx200_phylink_get_caps(struct dsa_switch *ds, int port,
 }
 
 static void gswip_xrx300_phylink_get_caps(struct dsa_switch *ds, int port,
-					  struct phylink_config *config)
+					  struct phylink_config *config,
+					  phy_interface_t *default_interface)
 {
 	switch (port) {
 	case 0:
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 28d7cb2ce98f..4329e29a1695 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -721,7 +721,8 @@ static int ksz_check_device_id(struct ksz_device *dev)
 }
 
 static void ksz_phylink_get_caps(struct dsa_switch *ds, int port,
-				 struct phylink_config *config)
+				 struct phylink_config *config,
+				 phy_interface_t *default_interface)
 {
 	struct ksz_device *dev = ds->priv;
 
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 835807911be0..dab308e454e3 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2914,7 +2914,8 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
 }
 
 static void mt753x_phylink_get_caps(struct dsa_switch *ds, int port,
-				    struct phylink_config *config)
+				    struct phylink_config *config,
+				    phy_interface_t *default_interface)
 {
 	struct mt7530_priv *priv = ds->priv;
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 37b649501500..f98be98551ef 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -819,7 +819,8 @@ static void mv88e6393x_phylink_get_caps(struct mv88e6xxx_chip *chip, int port,
 }
 
 static void mv88e6xxx_get_caps(struct dsa_switch *ds, int port,
-			       struct phylink_config *config)
+			       struct phylink_config *config,
+			       phy_interface_t *default_interface)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 859196898a7d..0c1ac902b110 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -937,7 +937,8 @@ static int felix_vlan_del(struct dsa_switch *ds, int port,
 }
 
 static void felix_phylink_get_caps(struct dsa_switch *ds, int port,
-				   struct phylink_config *config)
+				   struct phylink_config *config,
+				   phy_interface_t *default_interface)
 {
 	struct ocelot *ocelot = ds->priv;
 
diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index 0796b7cf8cae..19e95dabe5b9 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -501,7 +501,8 @@ static enum dsa_tag_protocol ar9331_sw_get_tag_protocol(struct dsa_switch *ds,
 }
 
 static void ar9331_sw_phylink_get_caps(struct dsa_switch *ds, int port,
-				       struct phylink_config *config)
+				       struct phylink_config *config,
+				       phy_interface_t *default_interface)
 {
 	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
 		MAC_10 | MAC_100;
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 1cbb05b0323f..beccd8338c81 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1749,7 +1749,8 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 }
 
 static void qca8k_phylink_get_caps(struct dsa_switch *ds, int port,
-				   struct phylink_config *config)
+				   struct phylink_config *config,
+				   phy_interface_t *default_interface)
 {
 	switch (port) {
 	case 0: /* 1st CPU port */
diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index da31d8b839ac..7bf420c2b083 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -1024,7 +1024,8 @@ static int rtl8365mb_ext_config_forcemode(struct realtek_priv *priv, int port,
 }
 
 static void rtl8365mb_phylink_get_caps(struct dsa_switch *ds, int port,
-				       struct phylink_config *config)
+				       struct phylink_config *config,
+				       phy_interface_t *default_interface)
 {
 	const struct rtl8365mb_extint *extint =
 		rtl8365mb_get_port_extint(ds->priv, port);
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b253e27bcfb4..e15033177643 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1390,7 +1390,8 @@ static void sja1105_mac_link_up(struct dsa_switch *ds, int port,
 }
 
 static void sja1105_phylink_get_caps(struct dsa_switch *ds, int port,
-				     struct phylink_config *config)
+				     struct phylink_config *config,
+				     phy_interface_t *default_interface)
 {
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_xmii_params_entry *mii;
diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index 3887ed33c5fe..214a1dd670c2 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -443,7 +443,8 @@ static void xrs700x_teardown(struct dsa_switch *ds)
 }
 
 static void xrs700x_phylink_get_caps(struct dsa_switch *ds, int port,
-				     struct phylink_config *config)
+				     struct phylink_config *config,
+				     phy_interface_t *default_interface)
 {
 	switch (port) {
 	case 0:
diff --git a/include/net/dsa.h b/include/net/dsa.h
index b902b31bebce..7c6870d2c607 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -852,7 +852,8 @@ struct dsa_switch_ops {
 	 * PHYLINK integration
 	 */
 	void	(*phylink_get_caps)(struct dsa_switch *ds, int port,
-				    struct phylink_config *config);
+				    struct phylink_config *config,
+				    phy_interface_t *default_interface);
 	void	(*phylink_validate)(struct dsa_switch *ds, int port,
 				    unsigned long *supported,
 				    struct phylink_link_state *state);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 3738f2d40a0b..35b4e1f8dc05 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1524,13 +1524,9 @@ static const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
 int dsa_port_phylink_create(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
-	phy_interface_t mode;
+	phy_interface_t mode, def_mode;
 	int err;
 
-	err = of_get_phy_mode(dp->dn, &mode);
-	if (err)
-		mode = PHY_INTERFACE_MODE_NA;
-
 	/* Presence of phylink_mac_link_state or phylink_mac_an_restart is
 	 * an indicator of a legacy phylink driver.
 	 */
@@ -1538,8 +1534,23 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 	    ds->ops->phylink_mac_an_restart)
 		dp->pl_config.legacy_pre_march2020 = true;
 
+	def_mode = PHY_INTERFACE_MODE_NA;
 	if (ds->ops->phylink_get_caps)
-		ds->ops->phylink_get_caps(ds, dp->index, &dp->pl_config);
+		ds->ops->phylink_get_caps(ds, dp->index, &dp->pl_config,
+					  &def_mode);
+
+	err = of_get_phy_mode(dp->dn, &mode);
+	if (err) {
+		/* We must not set the default mode for user ports as a PHY
+		 * overrides the NA mode in phylink. Setting it here would
+		 * prevent the interface mode being updated.
+		 */
+		if (dp->type == DSA_PORT_TYPE_CPU ||
+		    dp->type == DSA_PORT_TYPE_DSA)
+			mode = def_mode;
+		else
+			mode = PHY_INTERFACE_MODE_NA;
+	}
 
 	dp->pl = phylink_create(&dp->pl_config, of_fwnode_handle(dp->dn),
 				mode, &dsa_port_phylink_mac_ops);
-- 
2.30.2

