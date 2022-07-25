Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA26E5805A9
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 22:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237148AbiGYUcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 16:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236580AbiGYUcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 16:32:03 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC42826FF
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 13:32:01 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id a23so17426510lfm.10
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 13:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0J0/JcqIAZNOiFmKJyXlaBZVSCBCl0AWsEvUhhkoIJY=;
        b=eJy55uraWQ2XxrbDf2sTFVVJWFhf1Vr++dlZ5YPtqq0JDgex47PMZ9jkkWa/+Dq7i/
         lQMjDuFzZtD4RfAoejJtMEJxIPJpL5wd+oQDukUu+yuSVSzaRye0E3RStJCnAxRu1sZM
         py5H9aA0RK+Uavt28SICZpRk8mMVV3w5IiZet0G1RL83aLZmofTDZCJ8FpUz8zE78bSs
         4EdcC/ESfMqselMF4bj2HKEIs8PZWKj/M1NFrXMg1Q265BwwJ9hD+LkEYbM4wDGBUSDD
         Ch8ME+uYEIvLJoq18vHZ5smtXQHR8QdSFZn98FzXvvKw3mdB2zPdANEbVkZhsMasuzfy
         6xDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0J0/JcqIAZNOiFmKJyXlaBZVSCBCl0AWsEvUhhkoIJY=;
        b=0Dtj3QKqNqevoFhgttzkKYL+X9t9Qjp9uc3S4TR8JiJQbECsHDskp687y44jVQCR4M
         uJnWhyfapMXSNsrMMVMlRjFXwOJCLO7UGVHen/cPc9eYIbQLjNm7Ihjhh7pEN777ktB5
         s1z0cxLtErq4yREhIfuDIJg4xPR1IWP6moYgbQwlqVKWstR9403Xk3Tn7UGP6MLnhm7O
         ul4wXE0wAGB5Ut+VLsxjFKK0/QD4AaTSXkl9XU9T+Uvjjoq6uvqxNFXovY6VNeokekRr
         K++wOu0E8sJc8VEHYl1L2wcaNmopLKLOBbb34ZypAfgTtdIPGdAxlKqREC9ME9d05W6P
         Hcug==
X-Gm-Message-State: AJIora+Zmp8tpCrH2iTUXFITj8jhpRR1MyVkot3+H4ei1Bkpt2ZFg/3x
        YiA3W3nzfvw0wSjNngwfsPAQi7iyHaeumw==
X-Google-Smtp-Source: AGRyM1tju/zcLgY0wLoQRPl5diUNxv1OO8N+hjCN5tksP/Tzt//XOuDEgcPhzjgcr8FsdGUlm946XQ==
X-Received: by 2002:ac2:5f9c:0:b0:48a:8595:c84f with SMTP id r28-20020ac25f9c000000b0048a8595c84fmr3350984lfe.657.1658781120214;
        Mon, 25 Jul 2022 13:32:00 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id c2-20020a056512324200b0048a7b1530cesm1882055lfr.284.2022.07.25.13.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 13:31:59 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next] net: dsa: realtek: rtl8366rb: Configure ports properly
Date:   Mon, 25 Jul 2022 22:29:57 +0200
Message-Id: <20220725202957.2460420-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of just hammering the CPU port up at 1GBit at
.phylink_mac_link_up calls for that specific port, support
configuring any port: this works like a charm.

Drop the code to enable/disable the port in the
.phylink_mac_link_up/.phylink_mac_link_down callbacks:
this is handled perfectly well by the callbacks to
.port_enable/.port_disable.

Tested on the D-Link DIR-685.

Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/net/dsa/realtek/rtl8366rb.c | 155 ++++++++++++++++++++--------
 1 file changed, 111 insertions(+), 44 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8366rb.c b/drivers/net/dsa/realtek/rtl8366rb.c
index 25f88022b9e4..6ef8449d3e7a 100644
--- a/drivers/net/dsa/realtek/rtl8366rb.c
+++ b/drivers/net/dsa/realtek/rtl8366rb.c
@@ -95,12 +95,6 @@
 #define RTL8366RB_PAACR_RX_PAUSE	BIT(6)
 #define RTL8366RB_PAACR_AN		BIT(7)
 
-#define RTL8366RB_PAACR_CPU_PORT	(RTL8366RB_PAACR_SPEED_1000M | \
-					 RTL8366RB_PAACR_FULL_DUPLEX | \
-					 RTL8366RB_PAACR_LINK_UP | \
-					 RTL8366RB_PAACR_TX_PAUSE | \
-					 RTL8366RB_PAACR_RX_PAUSE)
-
 /* bits 0..7 = port 0, bits 8..15 = port 1 */
 #define RTL8366RB_PSTAT0		0x0014
 /* bits 0..7 = port 2, bits 8..15 = port 3 */
@@ -1049,63 +1043,134 @@ static enum dsa_tag_protocol rtl8366_get_tag_protocol(struct dsa_switch *ds,
 	return DSA_TAG_PROTO_RTL4_A;
 }
 
-static void
-rtl8366rb_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
-		      phy_interface_t interface, struct phy_device *phydev,
-		      int speed, int duplex, bool tx_pause, bool rx_pause)
+static void rtl8366rb_link_get_caps(struct dsa_switch *ds, int port,
+				    struct phylink_config *config)
 {
-	struct realtek_priv *priv = ds->priv;
-	int ret;
+	/* The SYM and ASYM pause is RX and TX pause */
+	config->mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
+				   MAC_10 | MAC_100 | MAC_1000;
 
-	if (port != priv->cpu_port)
-		return;
+	/* These are all internal, no external interfaces supported */
+	__set_bit(PHY_INTERFACE_MODE_INTERNAL, config->supported_interfaces);
 
-	dev_dbg(priv->dev, "MAC link up on CPU port (%d)\n", port);
+	/* GMII is the default interface mode for phylib, so
+	 * we have to support it for ports with integrated PHY.
+	 */
+	__set_bit(PHY_INTERFACE_MODE_GMII, config->supported_interfaces);
+}
 
-	/* Force the fixed CPU port into 1Gbit mode, no autonegotiation */
-	ret = regmap_update_bits(priv->map, RTL8366RB_MAC_FORCE_CTRL_REG,
-				 BIT(port), BIT(port));
-	if (ret) {
-		dev_err(priv->dev, "failed to force 1Gbit on CPU port\n");
-		return;
+static int rtl8366rb_config_link(struct realtek_priv *priv, int port, bool link,
+				 int speed, int duplex, bool tx_pause, bool rx_pause)
+{
+	u32 paacr;
+	u32 portreg;
+	u32 portmask;
+	u32 portshift;
+	int ret;
+
+	switch (port) {
+	case 0:
+		portreg = RTL8366RB_PAACR0;
+		portshift = 0;
+		break;
+	case 1:
+		portreg = RTL8366RB_PAACR0;
+		portshift = 8;
+		break;
+	case 2:
+		portreg = RTL8366RB_PAACR1;
+		portshift = 0;
+		break;
+	case 3:
+		portreg = RTL8366RB_PAACR1;
+		portshift = 8;
+		break;
+	case 4:
+		portreg = RTL8366RB_PAACR2;
+		portshift = 0;
+		break;
+	case 5:
+		portreg = RTL8366RB_PAACR2;
+		portshift = 8;
+		break;
+	default:
+		dev_err(priv->dev, "illegal port %d\n", port);
+		return -EINVAL;
 	}
 
-	ret = regmap_update_bits(priv->map, RTL8366RB_PAACR2,
-				 0xFF00U,
-				 RTL8366RB_PAACR_CPU_PORT << 8);
-	if (ret) {
-		dev_err(priv->dev, "failed to set PAACR on CPU port\n");
-		return;
+	portmask = GENMASK(portshift + 7, portshift);
+
+	if (link) {
+		switch (speed) {
+		case SPEED_1000:
+			paacr = RTL8366RB_PAACR_SPEED_1000M;
+			dev_dbg(priv->dev, "set port %d to 1Gbit\n", port);
+			break;
+		case SPEED_100:
+			paacr = RTL8366RB_PAACR_SPEED_100M;
+			dev_dbg(priv->dev, "set port %d to 100Mbit\n", port);
+			break;
+		case SPEED_10:
+			paacr = RTL8366RB_PAACR_SPEED_10M;
+			dev_dbg(priv->dev, "set port %d to 10Mbit\n", port);
+			break;
+		default:
+			dev_err(priv->dev, "illegal speed request on port %d\n", port);
+			return -EINVAL;
+		}
+
+		if (duplex == DUPLEX_FULL)
+			paacr |= RTL8366RB_PAACR_FULL_DUPLEX;
+		dev_dbg(priv->dev, "set port %d to %s duplex\n", port,
+			(duplex == DUPLEX_FULL) ? "full" : "half");
+
+		if (tx_pause)
+			paacr |= RTL8366RB_PAACR_TX_PAUSE;
+
+		if (rx_pause)
+			paacr |= RTL8366RB_PAACR_RX_PAUSE;
+
+		/* We are in the link up function so force it up */
+		paacr |= RTL8366RB_PAACR_LINK_UP;
+	} else {
+		/* If link goes down just zero the register including link up */
+		paacr = 0;
 	}
 
-	/* Enable the CPU port */
-	ret = regmap_update_bits(priv->map, RTL8366RB_PECR, BIT(port),
-				 0);
+	ret = regmap_update_bits(priv->map, portreg, portmask, paacr << portshift);
 	if (ret) {
-		dev_err(priv->dev, "failed to enable the CPU port\n");
-		return;
+		dev_err(priv->dev, "failed to set PAACR on port %d\n", port);
+		return ret;
 	}
+	dev_dbg(priv->dev, "Updated port %d reg %08x, mask %08x, shift %d with value %08x\n",
+		port, portreg, portmask, portshift, paacr);
+
+	return 0;
 }
 
 static void
-rtl8366rb_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
-			phy_interface_t interface)
+rtl8366rb_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
+		      phy_interface_t interface, struct phy_device *phydev,
+		      int speed, int duplex, bool tx_pause, bool rx_pause)
 {
 	struct realtek_priv *priv = ds->priv;
 	int ret;
 
-	if (port != priv->cpu_port)
-		return;
+	ret = rtl8366rb_config_link(priv, port, true, speed, duplex, tx_pause, rx_pause);
+	if (ret)
+		dev_err(priv->dev, "error configuring link on port %d\n", port);
+}
 
-	dev_dbg(priv->dev, "MAC link down on CPU port (%d)\n", port);
+static void
+rtl8366rb_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
+			phy_interface_t interface)
+{
+	struct realtek_priv *priv = ds->priv;
+	int ret;
 
-	/* Disable the CPU port */
-	ret = regmap_update_bits(priv->map, RTL8366RB_PECR, BIT(port),
-				 BIT(port));
-	if (ret) {
-		dev_err(priv->dev, "failed to disable the CPU port\n");
-		return;
-	}
+	ret = rtl8366rb_config_link(priv, port, false, 0, 0, false, false);
+	if (ret)
+		dev_err(priv->dev, "error configuring link on port %d\n", port);
 }
 
 static void rb8366rb_set_port_led(struct realtek_priv *priv,
@@ -1796,6 +1861,7 @@ static int rtl8366rb_detect(struct realtek_priv *priv)
 static const struct dsa_switch_ops rtl8366rb_switch_ops_smi = {
 	.get_tag_protocol = rtl8366_get_tag_protocol,
 	.setup = rtl8366rb_setup,
+	.phylink_get_caps = rtl8366rb_link_get_caps,
 	.phylink_mac_link_up = rtl8366rb_mac_link_up,
 	.phylink_mac_link_down = rtl8366rb_mac_link_down,
 	.get_strings = rtl8366_get_strings,
@@ -1821,6 +1887,7 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops_mdio = {
 	.setup = rtl8366rb_setup,
 	.phy_read = rtl8366rb_dsa_phy_read,
 	.phy_write = rtl8366rb_dsa_phy_write,
+	.phylink_get_caps = rtl8366rb_link_get_caps,
 	.phylink_mac_link_up = rtl8366rb_mac_link_up,
 	.phylink_mac_link_down = rtl8366rb_mac_link_down,
 	.get_strings = rtl8366_get_strings,
-- 
2.36.1

