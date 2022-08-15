Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA8B593432
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 19:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbiHORul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 13:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiHORuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 13:50:21 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2519D26F6;
        Mon, 15 Aug 2022 10:50:19 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id e28so6018431qts.1;
        Mon, 15 Aug 2022 10:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=u/zGWLqFXLX5XPvENmT0BJTHNYBYQ4uAB0ozt0RhCDo=;
        b=i8ON6mdc15CoQBM63vcNbp1/o5VhYzE/cfMivF8qdB9CulwZP1oAgbCulFia87hys0
         HV3uPbWnVkpNWspanXgyjr2+Z4BwCFCOMkn5RLIGfVVmo3IP+AMDaS/I+4Cz5oGz3hzl
         NHyln/cDA8x1taA76Wf+04pazQJCvhJn/jDocJtXerBKEybOHXg2nka/BwmC3sbHIVs0
         xj9mRTgwk9i+/4zWHx9hxAGv/SThEdMNqhnBJkyZ+w7zInkSOh4BXFoVe5Sfjw7L3Lkt
         +bWwr1O8KCP3D6sUILV1ZUehhbk+CBHje5U8VnmhFBH5y30GzenDDoG9Ta4W+dvbRyWt
         qzUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=u/zGWLqFXLX5XPvENmT0BJTHNYBYQ4uAB0ozt0RhCDo=;
        b=GXjbymFWGJKzkZTeQV5KPEq2PuDx0+OkYe1itRtqzl52/T63hyV+prd5jdq7ouuMWT
         ML0KZUHZqEK8qIfkMYx9Lx7BZFRJNAc6nP9ClDtWbLAknoJ8R8ie/ilZLIVXtFK1mMUv
         36W/eodz1XneqKYDBYf+kQ/L6cYGl2247TZYU+LFDicHGEv4a0RtJWAPosdPXknRbHhd
         7DWGBv4I+48CoX0iua9eEWBJDTpL1UoTBmGgFaLO+7NEtswivsL3asDIuePVg3v9UgCk
         LOSlkHBckn6b9U1F4ixQ9zlOsJAFlmRKSQQsdI0nu8E4CaC5fz7DXasIko9GqlI1/hYM
         d8lA==
X-Gm-Message-State: ACgBeo1yXS9VlcmfsyPLwK6pTCxEjGIQPxkyKotRu9UPrdX147pbpWxs
        /mc5H8XwpelRWTbec1Td2ndpguyFm/s=
X-Google-Smtp-Source: AA6agR7TnFUVChF9249j91RnZXWapLhDDqMzb9MDyf97vBnYSKxUqFYwBwgEgnwLAfW6oKCZmXSCCw==
X-Received: by 2002:ac8:5908:0:b0:344:5f5b:5497 with SMTP id 8-20020ac85908000000b003445f5b5497mr4909614qty.632.1660585817710;
        Mon, 15 Aug 2022 10:50:17 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ez12-20020a05622a4c8c00b00339163a06fcsm8741524qtb.6.2022.08.15.10.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 10:50:17 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 2/2] net: dsa: bcm_sf2: Have PHYLINK configure CPU/IMP port(s)
Date:   Mon, 15 Aug 2022 10:50:09 -0700
Message-Id: <20220815175009.2681932-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220815175009.2681932-1-f.fainelli@gmail.com>
References: <20220815175009.2681932-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the artificial limitations imposed upon
bcm_sf2_sw_mac_link_{up,down} and allow us to override the link
parameters for IMP port(s) as well as regular ports by accounting for
the special differences that exist there.

Remove the code that did override the link parameters in
bcm_sf2_imp_setup().

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 95 ++++++++++++++++++---------------------
 1 file changed, 43 insertions(+), 52 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 10de0cffa047..572f7450b527 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -159,7 +159,7 @@ static void bcm_sf2_imp_setup(struct dsa_switch *ds, int port)
 {
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	unsigned int i;
-	u32 reg, offset;
+	u32 reg;
 
 	/* Enable the port memories */
 	reg = core_readl(priv, CORE_MEM_PSM_VDD_CTRL);
@@ -185,17 +185,6 @@ static void bcm_sf2_imp_setup(struct dsa_switch *ds, int port)
 	b53_brcm_hdr_setup(ds, port);
 
 	if (port == 8) {
-		offset = bcm_sf2_port_override_offset(priv, port);
-
-		/* Force link status for IMP port */
-		reg = core_readl(priv, offset);
-		reg |= (MII_SW_OR | LINK_STS);
-		if (priv->type == BCM4908_DEVICE_ID)
-			reg |= GMII_SPEED_UP_2G;
-		else
-			reg &= ~GMII_SPEED_UP_2G;
-		core_writel(priv, reg, offset);
-
 		/* Enable Broadcast, Multicast, Unicast forwarding to IMP port */
 		reg = core_readl(priv, CORE_IMP_CTL);
 		reg |= (RX_BCST_EN | RX_MCST_EN | RX_UCST_EN);
@@ -826,12 +815,10 @@ static void bcm_sf2_sw_mac_link_down(struct dsa_switch *ds, int port,
 	if (priv->wol_ports_mask & BIT(port))
 		return;
 
-	if (port != core_readl(priv, CORE_IMP0_PRT_ID)) {
-		offset = bcm_sf2_port_override_offset(priv, port);
-		reg = core_readl(priv, offset);
-		reg &= ~LINK_STS;
-		core_writel(priv, reg, offset);
-	}
+	offset = bcm_sf2_port_override_offset(priv, port);
+	reg = core_readl(priv, offset);
+	reg &= ~LINK_STS;
+	core_writel(priv, reg, offset);
 
 	bcm_sf2_sw_mac_link_set(ds, port, interface, false);
 }
@@ -845,51 +832,55 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
 {
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	struct ethtool_eee *p = &priv->dev->ports[port].eee;
+	u32 reg_rgmii_ctrl = 0;
+	u32 reg, offset;
 
 	bcm_sf2_sw_mac_link_set(ds, port, interface, true);
 
-	if (port != core_readl(priv, CORE_IMP0_PRT_ID)) {
-		u32 reg_rgmii_ctrl = 0;
-		u32 reg, offset;
+	offset = bcm_sf2_port_override_offset(priv, port);
 
-		offset = bcm_sf2_port_override_offset(priv, port);
+	if (phy_interface_mode_is_rgmii(interface) ||
+	    interface == PHY_INTERFACE_MODE_MII ||
+	    interface == PHY_INTERFACE_MODE_REVMII) {
+		reg_rgmii_ctrl = bcm_sf2_reg_rgmii_cntrl(priv, port);
+		reg = reg_readl(priv, reg_rgmii_ctrl);
+		reg &= ~(RX_PAUSE_EN | TX_PAUSE_EN);
 
-		if (interface == PHY_INTERFACE_MODE_RGMII ||
-		    interface == PHY_INTERFACE_MODE_RGMII_TXID ||
-		    interface == PHY_INTERFACE_MODE_MII ||
-		    interface == PHY_INTERFACE_MODE_REVMII) {
-			reg_rgmii_ctrl = bcm_sf2_reg_rgmii_cntrl(priv, port);
-			reg = reg_readl(priv, reg_rgmii_ctrl);
-			reg &= ~(RX_PAUSE_EN | TX_PAUSE_EN);
+		if (tx_pause)
+			reg |= TX_PAUSE_EN;
+		if (rx_pause)
+			reg |= RX_PAUSE_EN;
 
-			if (tx_pause)
-				reg |= TX_PAUSE_EN;
-			if (rx_pause)
-				reg |= RX_PAUSE_EN;
+		reg_writel(priv, reg, reg_rgmii_ctrl);
+	}
 
-			reg_writel(priv, reg, reg_rgmii_ctrl);
-		}
+	reg = LINK_STS;
+	if (port == 8) {
+		if (priv->type == BCM4908_DEVICE_ID)
+			reg |= GMII_SPEED_UP_2G;
+		reg |= MII_SW_OR;
+	} else {
+		reg |= SW_OVERRIDE;
+	}
 
-		reg = SW_OVERRIDE | LINK_STS;
-		switch (speed) {
-		case SPEED_1000:
-			reg |= SPDSTS_1000 << SPEED_SHIFT;
-			break;
-		case SPEED_100:
-			reg |= SPDSTS_100 << SPEED_SHIFT;
-			break;
-		}
+	switch (speed) {
+	case SPEED_1000:
+		reg |= SPDSTS_1000 << SPEED_SHIFT;
+		break;
+	case SPEED_100:
+		reg |= SPDSTS_100 << SPEED_SHIFT;
+		break;
+	}
 
-		if (duplex == DUPLEX_FULL)
-			reg |= DUPLX_MODE;
+	if (duplex == DUPLEX_FULL)
+		reg |= DUPLX_MODE;
 
-		if (tx_pause)
-			reg |= TXFLOW_CNTL;
-		if (rx_pause)
-			reg |= RXFLOW_CNTL;
+	if (tx_pause)
+		reg |= TXFLOW_CNTL;
+	if (rx_pause)
+		reg |= RXFLOW_CNTL;
 
-		core_writel(priv, reg, offset);
-	}
+	core_writel(priv, reg, offset);
 
 	if (mode == MLO_AN_PHY && phydev)
 		p->eee_enabled = b53_eee_init(ds, port, phydev);
-- 
2.25.1

