Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20DFE549A2D
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 19:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241933AbiFMRhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 13:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242226AbiFMRfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 13:35:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7A285ED9
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 06:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=PcuHLRvGs3fpWyOw/LTcYbQ+ggld//CVlSNz0F3XgDA=; b=JUmKK8JSXfCLwfMxD3pXrqYKXm
        AiKq5+6Y8KMrB6gvllFx7o1f+PLzDPzZFZfB5XhBWF4kmsVZvAbs/nRM7c1FKrFc8NwnbAqsms2gW
        togeH78NqCBO6l8sPKoXZF2M+nskuK2rNROVdmv29j9sMi0YZZuECHELIT5gOx3Ed3qFq1NBqjt4E
        UBGJiyfQJihK+MIl3J+dK9sm0HPZiqDfJ6SE6piL27eIyQRnkBOdN19CaH7+3GARr2y0+0khv6j3Y
        YnRcW2HCSWgnLcHhjtxTFJEpWB8TTtk8F6HrNYWpvNHScCvNvqEj5hD/8dAqicPUKfv2N7UWI88/O
        htgEE+Ng==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52078 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o0jgF-0001qY-NI; Mon, 13 Jun 2022 14:00:31 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o0jgF-000JYC-49; Mon, 13 Jun 2022 14:00:31 +0100
In-Reply-To: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
References: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Robert Hancock <robert.hancock@calian.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 02/15] net: phylink: add phylink_pcs_inband()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o0jgF-000JYC-49@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 13 Jun 2022 14:00:31 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add phylink_pcs_inband() to indicate whether the PCS should be using
inband signalling.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c |  5 +----
 include/linux/phylink.h   | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 5bc58e50e318..076e50578169 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -3029,10 +3029,7 @@ int phylink_mii_c22_pcs_config(struct mdio_device *pcs, unsigned int mode,
 	}
 
 	/* Ensure ISOLATE bit is disabled */
-	if (mode == MLO_AN_INBAND &&
-	    (interface == PHY_INTERFACE_MODE_SGMII ||
-	     interface == PHY_INTERFACE_MODE_QSGMII ||
-	     linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, advertising)))
+	if (phylink_pcs_inband(mode, interface, advertising))
 		bmcr = BMCR_ANENABLE;
 	else
 		bmcr = 0;
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 6d06896fc20d..91ba7e4d72db 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -50,6 +50,28 @@ static inline bool phylink_autoneg_inband(unsigned int mode)
 	return mode == MLO_AN_INBAND;
 }
 
+/**
+ * phylink_pcs_inband() - helper to indicate whether to enable inband signalling
+ * @mode: one of %MLO_AN_FIXED, %MLO_AN_PHY, %MLO_AN_INBAND.
+ * @interface: interface mode to be used
+ * @advertising: adertisement ethtool link mode mask
+ *
+ * Returns true if the mode/interface/advertising mask indicates that we
+ * should be using inband signalling at the PCS block, false otherwise.
+ */
+static inline bool phylink_pcs_inband(unsigned int mode,
+				      phy_interface_t interface,
+				      const unsigned long *advertising)
+{
+	if (phylink_autoneg_inband(mode) &&
+	    (interface == PHY_INTERFACE_MODE_SGMII ||
+	     interface == PHY_INTERFACE_MODE_QSGMII ||
+	     linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, advertising)))
+		return true;
+	else
+		return false;
+}
+
 /**
  * struct phylink_link_state - link state structure
  * @advertising: ethtool bitmask containing advertised link modes
-- 
2.30.2

