Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A792358CCC
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 20:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbhDHSjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 14:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbhDHSjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 14:39:05 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DAFC061761;
        Thu,  8 Apr 2021 11:38:52 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id e14so4694064ejz.11;
        Thu, 08 Apr 2021 11:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ehpBjkkvV+qL4YKuI7T1fx1UwfXjL1q52am6xl3aaCI=;
        b=X8BUADw1/R/f/qB7SoKdN37QiHNmRggFbBvXdwDzm+7lCeDL+lIUkMVCgFt7tA+FMj
         6pb//NVnHDScEbL2QAH4i9kHsYcoqhXSuGGw4/aq5XqNJ3vSo3PdfuxZ3Ja331HNxmAe
         MZFbcRYIop7z8C+pEGI6bMaVc61U0usY6DOZ7rqbtss1pTXPxMTlz9ufo8Vp0LI5rQjC
         k91zHM01lUvSDtDymPynUwBgWwCUvQafSYgPznAqYC5AEj0toWGJ1COtcxRbEWfSz6hH
         7MKZkZcFMROJFzu5DWNaeC0TRp3uqkzFhm1SggaolUOzFzLvbiy7EBJ5FuKTZzOS8H0V
         PmZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ehpBjkkvV+qL4YKuI7T1fx1UwfXjL1q52am6xl3aaCI=;
        b=RdMbskr7hDb+Zqbr75Bk30LEoa0MO6FfUo+C2u5MwXv0LXk8jeEsrArYrpDxUnCfzF
         gQ/71gn83JGrEWa4Y3iRpVcVvt308/GVBtlWEAjCZM496spEXNW8GxZvrWMvrrQSQ3U4
         VFzzShpIkP+HFq5q9sZta+9XqjAtIYYgW9cd6QfqeUMH9Z0CvW0AMGy9f8LlJF0a0quo
         Us7Fmr6wSle9lshQqvxa856su2xT8LJtZCibTqZErfwkjYw6qF1jfOjRXJb3mWVG1HDx
         H7QgbcNK7C0n7VpZtinG/jqXJTfNRw6Llo7ZvQ2ilCbBMy7nTYyQkSjo3m6yQAR1qzdG
         w26w==
X-Gm-Message-State: AOAM531GTch4pNP33QEWvpD3PpeGuGiE/XWK9G1sle4HbXi0kgAz0wWB
        RfpoqVEtiEgbzTduQwD0Zyk=
X-Google-Smtp-Source: ABdhPJxAOMKc83ibl1EmyXjYjR1puI19zJj8SOyfsSSaQgmNrL0KzNBWCU9eg6idvzJoqMCxC+3UzA==
X-Received: by 2002:a17:906:6c4:: with SMTP id v4mr11961757ejb.198.1617907131559;
        Thu, 08 Apr 2021 11:38:51 -0700 (PDT)
Received: from localhost.localdomain (p200300f1370e7400428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:370e:7400:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id yh6sm92125ejb.37.2021.04.08.11.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 11:38:51 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     hauke@hauke-m.de, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        stable@vger.kernel.org
Subject: [PATCH net v2 1/2] net: dsa: lantiq_gswip: Don't use PHY auto polling
Date:   Thu,  8 Apr 2021 20:38:27 +0200
Message-Id: <20210408183828.1907807-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210408183828.1907807-1-martin.blumenstingl@googlemail.com>
References: <20210408183828.1907807-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHY auto polling on the GSWIP hardware can be used so link changes
(speed, link up/down, etc.) can be detected automatically. Internally
GSWIP reads the PHY's registers for this functionality. Based on this
automatic detection GSWIP can also automatically re-configure it's port
settings. Unfortunately this auto polling (and configuration) mechanism
seems to cause various issues observed by different people on different
devices:
- FritzBox 7360v2: the two Gbit/s ports (connected to the two internal
  PHY11G instances) are working fine but the two Fast Ethernet ports
  (using an AR8030 RMII PHY) are completely dead (neither RX nor TX are
  received). It turns out that the AR8030 PHY sets the BMSR_ESTATEN bit
  as well as the ESTATUS_1000_TFULL and ESTATUS_1000_XFULL bits. This
  makes the PHY auto polling state machine (rightfully?) think that the
  established link speed (when the other side is Gbit/s capable) is
  1Gbit/s.
- None of the Ethernet ports on the Zyxel P-2812HNU-F1 (two are
  connected to the internal PHY11G GPHYs while the other three are
  external RGMII PHYs) are working. Neither RX nor TX traffic was
  observed. It is not clear which part of the PHY auto polling state-
  machine caused this.
- FritzBox 7412 (only one LAN port which is connected to one of the
  internal GPHYs running in PHY22F / Fast Ethernet mode) was seeing
  random disconnects (link down events could be seen). Sometimes all
  traffic would stop after such disconnect. It is not clear which part
  of the PHY auto polling state-machine cauased this.
- TP-Link TD-W9980 (two ports are connected to the internal GPHYs
  running in PHY11G / Gbit/s mode, the other two are external RGMII
  PHYs) was affected by similar issues as the FritzBox 7412 just without
  the "link down" events

Switch to software based configuration instead of PHY auto polling (and
letting the GSWIP hardware configure the ports automatically) for the
following link parameters:
- link up/down
- link speed
- full/half duplex
- flow control (RX / TX pause)

After a big round of manual testing by various people (who helped test
this on OpenWrt) it turns out that this fixes all reported issues.

Additionally it can be considered more future proof because any
"quirk" which is implemented for a PHY on the driver side can now be
used with the GSWIP hardware as well because Linux is in control of the
link parameters.

As a nice side-effect this also solves a problem where fixed-links were
not supported previously because we were relying on the PHY auto polling
mechanism, which cannot work for fixed-links as there's no PHY from
where it can read the registers. Configuring the link settings on the
GSWIP ports means that we now use the settings from device-tree also for
ports with fixed-links.

Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Fixes: 3e6fdeb28f4c33 ("net: dsa: lantiq_gswip: Let GSWIP automatically set the xMII clock")
Cc: stable@vger.kernel.org
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/dsa/lantiq_gswip.c | 185 ++++++++++++++++++++++++++++-----
 1 file changed, 159 insertions(+), 26 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 809dfa3be6bb..126d4ea868ba 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -190,6 +190,23 @@
 #define GSWIP_PCE_DEFPVID(p)		(0x486 + ((p) * 0xA))
 
 #define GSWIP_MAC_FLEN			0x8C5
+#define GSWIP_MAC_CTRL_0p(p)		(0x903 + ((p) * 0xC))
+#define  GSWIP_MAC_CTRL_0_PADEN		BIT(8)
+#define  GSWIP_MAC_CTRL_0_FCS_EN	BIT(7)
+#define  GSWIP_MAC_CTRL_0_FCON_MASK	0x0070
+#define  GSWIP_MAC_CTRL_0_FCON_AUTO	0x0000
+#define  GSWIP_MAC_CTRL_0_FCON_RX	0x0010
+#define  GSWIP_MAC_CTRL_0_FCON_TX	0x0020
+#define  GSWIP_MAC_CTRL_0_FCON_RXTX	0x0030
+#define  GSWIP_MAC_CTRL_0_FCON_NONE	0x0040
+#define  GSWIP_MAC_CTRL_0_FDUP_MASK	0x000C
+#define  GSWIP_MAC_CTRL_0_FDUP_AUTO	0x0000
+#define  GSWIP_MAC_CTRL_0_FDUP_EN	0x0004
+#define  GSWIP_MAC_CTRL_0_FDUP_DIS	0x000C
+#define  GSWIP_MAC_CTRL_0_GMII_MASK	0x0003
+#define  GSWIP_MAC_CTRL_0_GMII_AUTO	0x0000
+#define  GSWIP_MAC_CTRL_0_GMII_MII	0x0001
+#define  GSWIP_MAC_CTRL_0_GMII_RGMII	0x0002
 #define GSWIP_MAC_CTRL_2p(p)		(0x905 + ((p) * 0xC))
 #define GSWIP_MAC_CTRL_2_MLEN		BIT(3) /* Maximum Untagged Frame Lnegth */
 
@@ -653,16 +670,13 @@ static int gswip_port_enable(struct dsa_switch *ds, int port,
 			  GSWIP_SDMA_PCTRLp(port));
 
 	if (!dsa_is_cpu_port(ds, port)) {
-		u32 macconf = GSWIP_MDIO_PHY_LINK_AUTO |
-			      GSWIP_MDIO_PHY_SPEED_AUTO |
-			      GSWIP_MDIO_PHY_FDUP_AUTO |
-			      GSWIP_MDIO_PHY_FCONTX_AUTO |
-			      GSWIP_MDIO_PHY_FCONRX_AUTO |
-			      (phydev->mdio.addr & GSWIP_MDIO_PHY_ADDR_MASK);
-
-		gswip_mdio_w(priv, macconf, GSWIP_MDIO_PHYp(port));
-		/* Activate MDIO auto polling */
-		gswip_mdio_mask(priv, 0, BIT(port), GSWIP_MDIO_MDC_CFG0);
+		u32 mdio_phy = 0;
+
+		if (phydev)
+			mdio_phy = phydev->mdio.addr & GSWIP_MDIO_PHY_ADDR_MASK;
+
+		gswip_mdio_mask(priv, GSWIP_MDIO_PHY_ADDR_MASK, mdio_phy,
+				GSWIP_MDIO_PHYp(port));
 	}
 
 	return 0;
@@ -675,14 +689,6 @@ static void gswip_port_disable(struct dsa_switch *ds, int port)
 	if (!dsa_is_user_port(ds, port))
 		return;
 
-	if (!dsa_is_cpu_port(ds, port)) {
-		gswip_mdio_mask(priv, GSWIP_MDIO_PHY_LINK_DOWN,
-				GSWIP_MDIO_PHY_LINK_MASK,
-				GSWIP_MDIO_PHYp(port));
-		/* Deactivate MDIO auto polling */
-		gswip_mdio_mask(priv, BIT(port), 0, GSWIP_MDIO_MDC_CFG0);
-	}
-
 	gswip_switch_mask(priv, GSWIP_FDMA_PCTRL_EN, 0,
 			  GSWIP_FDMA_PCTRLp(port));
 	gswip_switch_mask(priv, GSWIP_SDMA_PCTRL_EN, 0,
@@ -794,20 +800,31 @@ static int gswip_setup(struct dsa_switch *ds)
 	gswip_switch_w(priv, BIT(cpu_port), GSWIP_PCE_PMAP2);
 	gswip_switch_w(priv, BIT(cpu_port), GSWIP_PCE_PMAP3);
 
-	/* disable PHY auto polling */
+	/* Deactivate MDIO PHY auto polling. Some PHYs as the AR8030 have an
+	 * interoperability problem with this auto polling mechanism because
+	 * their status registers think that the link is in a different state
+	 * than it actually is. For the AR8030 it has the BMSR_ESTATEN bit set
+	 * as well as ESTATUS_1000_TFULL and ESTATUS_1000_XFULL. This makes the
+	 * auto polling state machine consider the link being negotiated with
+	 * 1Gbit/s. Since the PHY itself is a Fast Ethernet RMII PHY this leads
+	 * to the switch port being completely dead (RX and TX are both not
+	 * working).
+	 * Also with various other PHY / port combinations (PHY11G GPHY, PHY22F
+	 * GPHY, external RGMII PEF7071/7072) any traffic would stop. Sometimes
+	 * it would work fine for a few minutes to hours and then stop, on
+	 * other device it would no traffic could be sent or received at all.
+	 * Testing shows that when PHY auto polling is disabled these problems
+	 * go away.
+	 */
 	gswip_mdio_w(priv, 0x0, GSWIP_MDIO_MDC_CFG0);
+
 	/* Configure the MDIO Clock 2.5 MHz */
 	gswip_mdio_mask(priv, 0xff, 0x09, GSWIP_MDIO_MDC_CFG1);
 
-	for (i = 0; i < priv->hw_info->max_ports; i++) {
-		/* Disable the xMII link */
+	/* Disable the xMII link */
+	for (i = 0; i < priv->hw_info->max_ports; i++)
 		gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_EN, 0, i);
 
-		/* Automatically select the xMII interface clock */
-		gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_RATE_MASK,
-				   GSWIP_MII_CFG_RATE_AUTO, i);
-	}
-
 	/* enable special tag insertion on cpu port */
 	gswip_switch_mask(priv, 0, GSWIP_FDMA_PCTRL_STEN,
 			  GSWIP_FDMA_PCTRLp(cpu_port));
@@ -1455,6 +1472,112 @@ static void gswip_phylink_validate(struct dsa_switch *ds, int port,
 	return;
 }
 
+static void gswip_port_set_link(struct gswip_priv *priv, int port, bool link)
+{
+	u32 mdio_phy;
+
+	if (link)
+		mdio_phy = GSWIP_MDIO_PHY_LINK_UP;
+	else
+		mdio_phy = GSWIP_MDIO_PHY_LINK_DOWN;
+
+	gswip_mdio_mask(priv, GSWIP_MDIO_PHY_LINK_MASK, mdio_phy,
+			GSWIP_MDIO_PHYp(port));
+}
+
+static void gswip_port_set_speed(struct gswip_priv *priv, int port, int speed,
+				 phy_interface_t interface)
+{
+	u32 mdio_phy = 0, mii_cfg = 0, mac_ctrl_0 = 0;
+
+	switch (speed) {
+	case SPEED_10:
+		mdio_phy = GSWIP_MDIO_PHY_SPEED_M10;
+
+		if (interface == PHY_INTERFACE_MODE_RMII)
+			mii_cfg = GSWIP_MII_CFG_RATE_M50;
+		else
+			mii_cfg = GSWIP_MII_CFG_RATE_M2P5;
+
+		mac_ctrl_0 = GSWIP_MAC_CTRL_0_GMII_MII;
+		break;
+
+	case SPEED_100:
+		mdio_phy = GSWIP_MDIO_PHY_SPEED_M100;
+
+		if (interface == PHY_INTERFACE_MODE_RMII)
+			mii_cfg = GSWIP_MII_CFG_RATE_M50;
+		else
+			mii_cfg = GSWIP_MII_CFG_RATE_M25;
+
+		mac_ctrl_0 = GSWIP_MAC_CTRL_0_GMII_MII;
+		break;
+
+	case SPEED_1000:
+		mdio_phy = GSWIP_MDIO_PHY_SPEED_G1;
+
+		mii_cfg = GSWIP_MII_CFG_RATE_M125;
+
+		mac_ctrl_0 = GSWIP_MAC_CTRL_0_GMII_RGMII;
+		break;
+	}
+
+	gswip_mdio_mask(priv, GSWIP_MDIO_PHY_SPEED_MASK, mdio_phy,
+			GSWIP_MDIO_PHYp(port));
+	gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_RATE_MASK, mii_cfg, port);
+	gswip_switch_mask(priv, GSWIP_MAC_CTRL_0_GMII_MASK, mac_ctrl_0,
+			  GSWIP_MAC_CTRL_0p(port));
+}
+
+static void gswip_port_set_duplex(struct gswip_priv *priv, int port, int duplex)
+{
+	u32 mac_ctrl_0, mdio_phy;
+
+	if (duplex == DUPLEX_FULL) {
+		mac_ctrl_0 = GSWIP_MAC_CTRL_0_FDUP_EN;
+		mdio_phy = GSWIP_MDIO_PHY_FDUP_EN;
+	} else {
+		mac_ctrl_0 = GSWIP_MAC_CTRL_0_FDUP_DIS;
+		mdio_phy = GSWIP_MDIO_PHY_FDUP_DIS;
+	}
+
+	gswip_switch_mask(priv, GSWIP_MAC_CTRL_0_FDUP_MASK, mac_ctrl_0,
+			  GSWIP_MAC_CTRL_0p(port));
+	gswip_mdio_mask(priv, GSWIP_MDIO_PHY_FDUP_MASK, mdio_phy,
+			GSWIP_MDIO_PHYp(port));
+}
+
+static void gswip_port_set_pause(struct gswip_priv *priv, int port,
+				 bool tx_pause, bool rx_pause)
+{
+	u32 mac_ctrl_0, mdio_phy;
+
+	if (tx_pause && rx_pause) {
+		mac_ctrl_0 = GSWIP_MAC_CTRL_0_FCON_RXTX;
+		mdio_phy = GSWIP_MDIO_PHY_FCONTX_EN |
+			   GSWIP_MDIO_PHY_FCONRX_EN;
+	} else if (tx_pause) {
+		mac_ctrl_0 = GSWIP_MAC_CTRL_0_FCON_TX;
+		mdio_phy = GSWIP_MDIO_PHY_FCONTX_EN |
+			   GSWIP_MDIO_PHY_FCONRX_DIS;
+	} else if (rx_pause) {
+		mac_ctrl_0 = GSWIP_MAC_CTRL_0_FCON_RX;
+		mdio_phy = GSWIP_MDIO_PHY_FCONTX_DIS |
+			   GSWIP_MDIO_PHY_FCONRX_EN;
+	} else {
+		mac_ctrl_0 = GSWIP_MAC_CTRL_0_FCON_NONE;
+		mdio_phy = GSWIP_MDIO_PHY_FCONTX_DIS |
+			   GSWIP_MDIO_PHY_FCONRX_DIS;
+	}
+
+	gswip_switch_mask(priv, GSWIP_MAC_CTRL_0_FCON_MASK,
+			  mac_ctrl_0, GSWIP_MAC_CTRL_0p(port));
+	gswip_mdio_mask(priv,
+			GSWIP_MDIO_PHY_FCONTX_MASK |
+			GSWIP_MDIO_PHY_FCONRX_MASK,
+			mdio_phy, GSWIP_MDIO_PHYp(port));
+}
+
 static void gswip_phylink_mac_config(struct dsa_switch *ds, int port,
 				     unsigned int mode,
 				     const struct phylink_link_state *state)
@@ -1511,6 +1634,9 @@ static void gswip_phylink_mac_link_down(struct dsa_switch *ds, int port,
 	struct gswip_priv *priv = ds->priv;
 
 	gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_EN, 0, port);
+
+	if (!dsa_is_cpu_port(ds, port))
+		gswip_port_set_link(priv, port, false);
 }
 
 static void gswip_phylink_mac_link_up(struct dsa_switch *ds, int port,
@@ -1522,6 +1648,13 @@ static void gswip_phylink_mac_link_up(struct dsa_switch *ds, int port,
 {
 	struct gswip_priv *priv = ds->priv;
 
+	if (!dsa_is_cpu_port(ds, port)) {
+		gswip_port_set_link(priv, port, true);
+		gswip_port_set_speed(priv, port, speed, interface);
+		gswip_port_set_duplex(priv, port, duplex);
+		gswip_port_set_pause(priv, port, tx_pause, rx_pause);
+	}
+
 	gswip_mii_mask_cfg(priv, 0, GSWIP_MII_CFG_EN, port);
 }
 
-- 
2.31.1

