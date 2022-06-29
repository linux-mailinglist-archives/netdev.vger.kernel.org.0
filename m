Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF4456007C
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 14:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233486AbiF2Mvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 08:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233465AbiF2Mvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 08:51:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685053615F
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 05:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=COtSMS1/jgOQId0wNJWuS9lCVZlVYXaj70Wqb6aMgkQ=; b=jgV1nvGqD5c3BjilnaoN2aUVVK
        swFvnCfiFAFjlYKqOuRzcT3wRDxSZJu7CG84rbvFu3BHrKqtPnhgxLSi438Or+lWEcYCHsPSQZhT8
        L97Z6kktZ3TntRB8/E72Nx0uQys8ckv3/X3dohbg8AnopMIEJNmcB+69NUkebSffzDIj5+9gDRPN2
        nmWZmiKeeTXFRqsLuHLM80tmL1G99+/Gw3wGnVfE7gXqiVlzIx5zFj9fqRdRF+KUfi02YdUhn+5jQ
        +evfgNSsWy/Ug9fGRxSlwaeHhFEfr84ynJHQWntvzjyczRM2F4lThn8HVvrppeiWBQbeMTTmfSWg2
        gr0zbk4g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:35716 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o6XAQ-00037F-V2; Wed, 29 Jun 2022 13:51:38 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o6XAQ-004pVw-7o; Wed, 29 Jun 2022 13:51:38 +0100
In-Reply-To: <YrxKdVmBzeMsVjsH@shell.armlinux.org.uk>
References: <YrxKdVmBzeMsVjsH@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Alvin __ipraga" <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: [PATCH RFC net-next 4/6] net: phylink: add
 phylink_set_max_fixed_link()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o6XAQ-004pVw-7o@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 29 Jun 2022 13:51:38 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a function for DSA to use to configure phylink, in the absence of
any other configuration, to a fixed link operating at the maximum
supported link speed.

This is needed so we can support phylink usage on CPU and DSA ports.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 110 ++++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |   5 ++
 2 files changed, 115 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 4645ac6e553d..23be3f041705 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1333,6 +1333,116 @@ void phylink_destroy(struct phylink *pl)
 }
 EXPORT_SYMBOL_GPL(phylink_destroy);
 
+static struct {
+	unsigned long fd_mask;
+	unsigned long hd_mask;
+	int speed;
+} phylink_caps_speeds[] = {
+	{ MAC_400000FD, 0,          SPEED_400000 },
+	{ MAC_200000FD, 0,          SPEED_200000 },
+	{ MAC_100000FD, 0,          SPEED_100000 },
+	{ MAC_56000FD,  0,          SPEED_56000  },
+	{ MAC_50000FD,  0,          SPEED_50000  },
+	{ MAC_40000FD,  0,          SPEED_40000  },
+	{ MAC_25000FD,  0,          SPEED_40000  },
+	{ MAC_20000FD,  0,          SPEED_20000  },
+	{ MAC_10000FD,  0,          SPEED_10000  },
+	{ MAC_5000FD,   0,          SPEED_5000   },
+	{ MAC_2500FD,   0,          SPEED_2500   },
+	{ MAC_1000FD,   MAC_1000HD, SPEED_1000   },
+	{ MAC_100FD,    MAC_100HD,  SPEED_100    },
+	{ MAC_10FD,     MAC_10HD,   SPEED_10     },
+};
+
+/**
+ * phylink_set_max_fixed_link() - set a fixed link configuration for phylink
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ *
+ * Set a maximum speed fixed-link configuration for the chosen interface
+ * mode and MAC capabilities for the phylink instance. Only valid for use
+ * immediately after creation. Must not be used at any other time.
+ *
+ * The user must have initialised mac_capabilities and set a valid interface.
+ */
+int phylink_set_max_fixed_link(struct phylink *pl)
+{
+	phy_interface_t intf, interface;
+	unsigned long caps, max_caps;
+	unsigned long *interfaces;
+	int speed, duplex;
+	int i;
+
+	/* If we are not in PHY mode, or have a PHY, or have a SFP bus,
+	 * then we must not default to a fixed link.
+	 */
+	if (pl->cfg_link_an_mode != MLO_AN_PHY || pl->phydev || pl->sfp_bus)
+		return -EBUSY;
+
+	interface = pl->link_interface;
+	if (interface != PHY_INTERFACE_MODE_NA) {
+		/* Get the speed/duplex capabilities and reduce according to the
+		 * specified interface mode.
+		 */
+		caps = pl->config->mac_capabilities;
+		caps &= phylink_interface_to_caps(interface);
+	} else {
+		interfaces = pl->config->supported_interfaces;
+		max_caps = 0;
+
+		/* Find the supported interface mode which gives the maximum
+		 * speed.
+		 */
+		for (intf = 0; intf < PHY_INTERFACE_MODE_MAX; intf++) {
+			if (test_bit(intf, interfaces)) {
+				caps = pl->config->mac_capabilities;
+				caps &= phylink_interface_to_caps(intf);
+				if (caps > max_caps) {
+					max_caps = caps;
+					interface = intf;
+				}
+			}
+		}
+
+		caps = max_caps;
+	}
+
+	caps &= ~(MAC_SYM_PAUSE | MAC_ASYM_PAUSE);
+
+	/* If there are no capabilities, then we are not using this default. */
+	if (!caps)
+		return -EINVAL;
+
+	/* Decode to fastest speed and duplex */
+	duplex = DUPLEX_UNKNOWN;
+	speed = SPEED_UNKNOWN;
+	for (i = 0; i < ARRAY_SIZE(phylink_caps_speeds); i++) {
+		if (caps & phylink_caps_speeds[i].fd_mask) {
+			duplex = DUPLEX_FULL;
+			speed = phylink_caps_speeds[i].speed;
+			break;
+		} else if (caps & phylink_caps_speeds[i].hd_mask) {
+			duplex = DUPLEX_HALF;
+			speed = phylink_caps_speeds[i].speed;
+			break;
+		}
+	}
+
+	/* If we didn't find anything, bail. */
+	if (speed == SPEED_UNKNOWN)
+		return -EINVAL;
+
+	pl->link_interface = interface;
+	pl->link_config.interface = interface;
+	pl->link_config.speed = speed;
+	pl->link_config.duplex = duplex;
+	pl->link_config.link = 1;
+	pl->cfg_link_an_mode = MLO_AN_FIXED;
+	pl->cur_link_an_mode = MLO_AN_FIXED;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(phylink_set_max_fixed_link);
+
 static void phylink_phy_change(struct phy_device *phydev, bool up)
 {
 	struct phylink *pl = phydev->phylink;
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 6d06896fc20d..9e2fb476d19c 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -23,6 +23,9 @@ enum {
 
 	MAC_SYM_PAUSE	= BIT(0),
 	MAC_ASYM_PAUSE	= BIT(1),
+	/* These speed bits must be sorted according to speed for
+	 * phylink_set_max_fixed_link()
+	 */
 	MAC_10HD	= BIT(2),
 	MAC_10FD	= BIT(3),
 	MAC_10		= MAC_10HD | MAC_10FD,
@@ -529,6 +532,8 @@ struct phylink *phylink_create(struct phylink_config *, struct fwnode_handle *,
 			       const struct phylink_mac_ops *mac_ops);
 void phylink_destroy(struct phylink *);
 
+int phylink_set_max_fixed_link(struct phylink *pl);
+
 int phylink_connect_phy(struct phylink *, struct phy_device *);
 int phylink_of_phy_connect(struct phylink *, struct device_node *, u32 flags);
 int phylink_fwnode_phy_connect(struct phylink *pl,
-- 
2.30.2

