Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E1D566682
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 11:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiGEJsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 05:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbiGEJsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 05:48:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B8DF585
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 02:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2vpFj5+cCf6+YKlfaS7Vv6Bok0gpSkUhdwMT7QAC2mQ=; b=nHbCbkzcOZaRkjGTacW6KVLP6N
        iZsBzPFj8MZR+BdSn8GQiTpiYi6ktSLFe+TL6Bo9yBHE2RQpZQYSyad7Vie51KnpW1ZxUFptAIQhh
        plJ/T5f+68AyYnlgS7LStTXKBXTOb1dQk0Bkgh6tSz3V3XqEcCzAFxgHgBdNUderxiD5PxBNVMfh1
        IUMtDpmdjDIDPH3+Ro3jrtdqpXPP2Hb6RI3l3FraIhbRafvbHuAhQ778Mcf4WUAQV3XnSSMcRRjhu
        SizoqT2C5zmrZx6TLL48UajT7hNHkb2JmFRaIBi+8U3oBKd+kQ07QMFr5Z1l/3mpI5Wf+/RfX5gSB
        K+a+tVlw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60654 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o8fA3-00013t-7a; Tue, 05 Jul 2022 10:48:03 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o8fA2-0059aI-EN; Tue, 05 Jul 2022 10:48:02 +0100
In-Reply-To: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
References: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
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
Subject: [PATCH RFC net-next 4/5] net: phylink: add
 phylink_set_max_fixed_link()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o8fA2-0059aI-EN@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 05 Jul 2022 10:48:02 +0100
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

We use the default interface that the DSA driver provides (if any)
otherwise we attempt to find the first supported interface that gives
the maximum speed for the link.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 119 ++++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |   5 ++
 2 files changed, 124 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 2069fc902e19..7ed3b2c3a359 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1333,6 +1333,125 @@ void phylink_destroy(struct phylink *pl)
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
+ * mode and MAC capabilities for the phylink instance. If the interface mode
+ * is PHY_INTERFACE_MODE_NA, then search the supported interfaces bitmap for
+ * the first interface that gives the fastest supported speed.
+ *
+ * This is only valid for use immediately after phylink_create(). Must not
+ * be used at any other time.
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
+	interface = pl->link_interface;
+
+	phylink_dbg(pl, "sif=%*pbl if=%d(%s) cap=%lx\n",
+		    (int)PHY_INTERFACE_MODE_MAX,
+		    pl->config->supported_interfaces,
+		    interface, phy_modes(interface),
+		    pl->config->mac_capabilities);
+
+	/* If we are not in PHY mode, or have a PHY, or have a SFP bus,
+	 * then we must not default to a fixed link.
+	 */
+	if (pl->cfg_link_an_mode != MLO_AN_PHY || pl->phydev || pl->sfp_bus)
+		return -EBUSY;
+
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
+		for_each_set_bit(intf, interfaces, PHY_INTERFACE_MODE_MAX) {
+			caps = pl->config->mac_capabilities;
+			caps &= phylink_interface_to_caps(intf);
+			if (caps > max_caps) {
+				max_caps = caps;
+				interface = intf;
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

