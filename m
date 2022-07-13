Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19850573863
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 16:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236515AbiGMOI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 10:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236540AbiGMOIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 10:08:13 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83B0326E2;
        Wed, 13 Jul 2022 07:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4m6eKBcv9AePiJQLePntZlsqdp7c+M1i0Vgb52feZuk=; b=QUyro8jWz4Ux3K36TmeYNKcEuy
        OiTdIIS/3b8qV7xgWNUZCdG3LJXEz0zw6kQ/8SsX66U3rx0Q8K1OHjNrAzv0XxGzrPSYBs+I2mgFE
        DKOxY5v5THSDEHHl0Ptyc9vmRXkOksGaVytuvaxXIyrsouhQyprzcIsLZjtGvpRtN5y3EOVCDgoFq
        4DReSN7wTVx1TbFT+h6qLapOHH+WUeR0nNSCHQ2hZ6PWzoHN5rjqrrOLfzJo/S0dwL3Hfg4nvodGd
        68AGif/1coyDpsCO0jdsPKDTz9tu/dsA/27QBjUFpf0GXD1xbUavHX79qLe8SsUnU5Dw2xqMwdj5h
        J4Wt3jSw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:37050 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oBd1j-0004aW-51; Wed, 13 Jul 2022 15:07:43 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oBd1i-006UCk-Eo; Wed, 13 Jul 2022 15:07:42 +0100
In-Reply-To: <Ys7RdzGgHbYiPyB1@shell.armlinux.org.uk>
References: <Ys7RdzGgHbYiPyB1@shell.armlinux.org.uk>
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
Subject: [PATCH RFC net-next v2 1/6] net: phylink: split out and export
 interface to caps translation
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oBd1i-006UCk-Eo@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 13 Jul 2022 15:07:42 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phylink_get_linkmodes() translates the interface mode into a set of
speed and duplex capabilities which are masked with the MAC modes to
then derive the link modes that are available.

Split out the initial transformation into a new function
phylink_interface_to_caps(), and export it, which will be useful when
setting the maximum fixed link speed in DSA code.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 30 ++++++++++++++++++++++--------
 include/linux/phylink.h   |  1 +
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 9bd69328dc4d..1d4a48d5a5ac 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -297,17 +297,12 @@ static void phylink_caps_to_linkmodes(unsigned long *linkmodes,
 }
 
 /**
- * phylink_get_linkmodes() - get acceptable link modes
- * @linkmodes: ethtool linkmode mask (must be already initialised)
+ * phylink_interface_to_caps() - translate an interface mode to phylink caps
  * @interface: phy interface mode defined by &typedef phy_interface_t
- * @mac_capabilities: bitmask of MAC capabilities
  *
- * Set all possible pause, speed and duplex linkmodes in @linkmodes that
- * are supported by the @interface mode and @mac_capabilities. @linkmodes
- * must have been initialised previously.
+ * Translate the @interface mode to a phylink MAC capabilities mask.
  */
-void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
-			   unsigned long mac_capabilities)
+unsigned long phylink_interface_to_caps(phy_interface_t interface)
 {
 	unsigned long caps = MAC_SYM_PAUSE | MAC_ASYM_PAUSE;
 
@@ -381,6 +376,25 @@ void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
 		break;
 	}
 
+	return caps;
+}
+EXPORT_SYMBOL_GPL(phylink_interface_to_caps);
+
+/**
+ * phylink_get_linkmodes() - get acceptable link modes
+ * @linkmodes: ethtool linkmode mask (must be already initialised)
+ * @interface: phy interface mode defined by &typedef phy_interface_t
+ * @mac_capabilities: bitmask of MAC capabilities
+ *
+ * Set all possible pause, speed and duplex linkmodes in @linkmodes that
+ * are supported by the @interface mode and @mac_capabilities. @linkmodes
+ * must have been initialised previously.
+ */
+void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
+			   unsigned long mac_capabilities)
+{
+	unsigned long caps = phylink_interface_to_caps(interface);
+
 	phylink_caps_to_linkmodes(linkmodes, caps & mac_capabilities);
 }
 EXPORT_SYMBOL_GPL(phylink_get_linkmodes);
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 6d06896fc20d..692be109a9fa 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -518,6 +518,7 @@ void pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 		 phy_interface_t interface, int speed, int duplex);
 #endif
 
+unsigned long phylink_interface_to_caps(phy_interface_t interface);
 void phylink_get_linkmodes(unsigned long *linkmodes, phy_interface_t interface,
 			   unsigned long mac_capabilities);
 void phylink_generic_validate(struct phylink_config *config,
-- 
2.30.2

