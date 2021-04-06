Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967DC355CFA
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 22:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347182AbhDFUfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 16:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347164AbhDFUfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 16:35:34 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28266C06174A;
        Tue,  6 Apr 2021 13:35:26 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id i18so12112294wrm.5;
        Tue, 06 Apr 2021 13:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0ZMHaXt7XXI9ABuw1RdKwbfMjbSWc6TJlQKyK/zQ2zg=;
        b=ayFhE5oLd3CD7nhG3LYl55A5owG/aF1ckGa8XyusALudpjakelkVjGSYOajgrkp8IF
         rJ+dTQXpzLtGlK0wAlnz4yGooNTMO6M1mEe2lUt8LN3SkSVx2/wRcZolxhjwq7StLYLB
         cM3Q5+QOT7ZcLKQXRFQrweP2/UciUs2oKbqQCGydBnMqUzRSSFiaKtVyAHDcCWw8mrJG
         jlcavOZ77ALNTdpoFJTgnsIipY0pbl0C8XMGSOJULrsr/iNWWAUFMV+nOjZImeO9pWwE
         yNa2HeJImLfFne/pEJqm/PcxdudXS1ePvpFYgOONZBg0Ab3aVcIVNxhWK1EMW9HdPps7
         7yTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0ZMHaXt7XXI9ABuw1RdKwbfMjbSWc6TJlQKyK/zQ2zg=;
        b=YldLqsBOqze2hclytQgB4MywjDwR+c0QtTfjRAFD2Yzv/00tTJEoo1c2IPmwcCQkaz
         fNz8mVr2UxiaJsGa270EEPcSr0YwgfkuE7MLDMOpfg7VZ04d7PEApu0FD0B8SrWf7eHk
         NRHcR4FKReOIFwca+rMVgdf8u75PmBwiWYsjlymza96RESx750bYnZAfb3BdcQPpX9Tw
         GoxNdb+bNqM1XoQwkG49qijJSCq09S05lmtLrRhFz9IvQTguLbfZZcdutsKbqHDkeQFc
         iALauczxVBQP+9BEKzNXi9mUnE53jeqCf0kSAtR9PZuTC9R6D0J7LkA8pcR6lH6VUQxF
         zWTg==
X-Gm-Message-State: AOAM533PDsWpQE7//KfLnlnBhi3jZfCfbF11g6KNKd1PJjbPvuIaNM63
        RpnvqMK6KHO1i3k4HcwfWag=
X-Google-Smtp-Source: ABdhPJz8vNZvg4k8GDuM2K0VJoqLMa8VCGWniL/IrS/mnesxLouSjp24FA+JveYbVD71k+qiOkIliQ==
X-Received: by 2002:a05:6000:1ce:: with SMTP id t14mr66802wrx.85.1617741324816;
        Tue, 06 Apr 2021 13:35:24 -0700 (PDT)
Received: from localhost.localdomain (p200300f1370b4300428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:370b:4300:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id q14sm14040564wrg.64.2021.04.06.13.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 13:35:24 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     hauke@hauke-m.de, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        stable@vger.kernel.org
Subject: [PATCH RFC net 1/2] net: dsa: lantiq_gswip: Don't use PHY auto polling
Date:   Tue,  6 Apr 2021 22:35:07 +0200
Message-Id: <20210406203508.476122-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210406203508.476122-1-martin.blumenstingl@googlemail.com>
References: <20210406203508.476122-1-martin.blumenstingl@googlemail.com>
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
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/dsa/lantiq_gswip.c | 191 ++++++++++++++++++++++++++++-----
 1 file changed, 165 insertions(+), 26 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 809dfa3be6bb..47ea3a8c90a4 100644
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
@@ -1488,6 +1611,12 @@ static void gswip_phylink_mac_config(struct dsa_switch *ds, int port,
 	}
 	gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_MODE_MASK, miicfg, port);
 
+	gswip_port_set_link(priv, port, state->link);
+	gswip_port_set_speed(priv, port, state->speed, state->interface);
+	gswip_port_set_duplex(priv, port, state->duplex);
+	gswip_port_set_pause(priv, port, !!(state->pause & MLO_PAUSE_TX),
+			     !!(state->pause & MLO_PAUSE_RX));
+
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_RGMII_ID:
 		gswip_mii_mask_pcdu(priv, GSWIP_MII_PCDU_TXDLY_MASK |
@@ -1511,6 +1640,9 @@ static void gswip_phylink_mac_link_down(struct dsa_switch *ds, int port,
 	struct gswip_priv *priv = ds->priv;
 
 	gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_EN, 0, port);
+
+	if (!dsa_is_cpu_port(ds, port))
+		gswip_port_set_link(priv, port, false);
 }
 
 static void gswip_phylink_mac_link_up(struct dsa_switch *ds, int port,
@@ -1522,6 +1654,13 @@ static void gswip_phylink_mac_link_up(struct dsa_switch *ds, int port,
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

