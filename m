Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1796F1208A7
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 15:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbfLPObA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 09:31:00 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40322 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728014AbfLPOa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 09:30:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rDev2XCf6QPcUaBpKlxXXgkvYM25sEPS6kO7kjMcwQk=; b=EyNlTpb6UEZAxUvMGCTPQ9ZNk
        cxydnhdzDMVYfNj6WR4slV7CJsz8VQeyg8O6m/P//rPU7T9Z+CpPm6VBLGxd+lprpQ5lFA766b21c
        N36kCgxuM8ITZhzNVSL8IGi530qlu8ENnoR9h69wIUANDvTLD9I5lSRVtSeFhooA/OilpWw4AVl1L
        qjocweyH9QsAZVyAZ99StkaeybmVwHuAaa0HNnlmEqPZnk3ncduadTQZlnbqIxdQI/DoKT6MLzGJ4
        v9iF9RK5ntZakerVHBe4+/xDsGMD9yPKTgqbszxBCppEYg67DXk8ekCfOozOUqTaPBPKLOPyWLRgC
        Y8M+94PWg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53806)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1igrOY-00082M-1j; Mon, 16 Dec 2019 14:30:46 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1igrOS-0002TC-1z; Mon, 16 Dec 2019 14:30:40 +0000
Date:   Mon, 16 Dec 2019 14:30:40 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Milind Parab <mparab@cadence.com>
Cc:     "nicolas.nerre@microchip.com" <nicolas.nerre@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dhananjay Vilasrao Kangude <dkangude@cadence.com>,
        "a.fatoum@pengutronix.de" <a.fatoum@pengutronix.de>,
        "brad.mouring@ni.com" <brad.mouring@ni.com>,
        Parshuram Raju Thombare <pthombar@cadence.com>
Subject: Re: [PATCH v2 3/3] net: macb: add support for high speed interface
Message-ID: <20191216143039.GX1344@shell.armlinux.org.uk>
References: <1576230007-11181-1-git-send-email-mparab@cadence.com>
 <1576230177-11404-1-git-send-email-mparab@cadence.com>
 <20191215151249.GA25745@shell.armlinux.org.uk>
 <20191215152000.GW1344@shell.armlinux.org.uk>
 <BY5PR07MB65143D385836FF49966F5F6AD3510@BY5PR07MB6514.namprd07.prod.outlook.com>
 <20191216130908.GI25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216130908.GI25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 01:09:08PM +0000, Russell King - ARM Linux admin wrote:
> On Mon, Dec 16, 2019 at 12:49:59PM +0000, Milind Parab wrote:
> > >> > +	if (bp->phy_interface == PHY_INTERFACE_MODE_USXGMII) {
> > >>
> > >> Why bp->phy_interface and not state->interface?
> > 
> > okay, this needs to change to state->interface
> > 
> > >>
> > >> If you don't support selecting between USXGMII and other modes at
> > >> runtime, should macb_validate() be allowing ethtool link modes for
> > >> it when it's different from the configured setting?
> > 
> > We have separate SGMII and USXGMII PCS, which are enabled and programmed 
> > by MAC driver. Also, there are separate low speed (up to 1G) and high 
> > speed MAC which can be programmed though MAC driver. 
> > As long as, PHY (PMA, external to Cadence MAC controller) can handle 
> > this change, GEM can work with interface changes at a runtime.
> > 
> > >>
> > >> > +		if (gem_mac_usx_configure(bp, state) < 0) {
> > >> > +			spin_unlock_irqrestore(&bp->lock, flags);
> > >> > +			phylink_mac_change(bp->phylink, false);
> > >>
> > >> I guess this is the reason you're waiting for the USXGMII block
> > >> to lock - do you not have any way to raise an interrupt when
> > >> something changes with the USXGMII (or for that matter SGMII)
> > >> blocks?  Without that, you're fixed to a single speed.
> > 
> > Yes, we need to wait (poll) until USXGMII block lock is set.
> > Interrupt for USXGMII block lock set event is not supported.
> 
> You should poll for that status. We already have some polling support
> in phylink (in the case of a fixed link using the callback, or a GPIO
> that has no interrupt support) so it probably makes sense to extend
> that functionality for MACs that do not provide status interrupts.

And here's that extension (untested):

8<===
From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH] net: phylink: add support for polling MAC PCS

Some MAC PCS blocks are unable to provide interrupts when their status
changes. As we already have support in phylink for polling status, use
this to provide a hook for MACs to enable polling mode.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 Documentation/networking/sfp-phylink.rst |  8 +++--
 drivers/net/phy/phylink.c                | 44 ++++++++++++++++++------
 include/linux/phylink.h                  |  1 +
 3 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/Documentation/networking/sfp-phylink.rst b/Documentation/networking/sfp-phylink.rst
index a5e00a159d21..5695204be09a 100644
--- a/Documentation/networking/sfp-phylink.rst
+++ b/Documentation/networking/sfp-phylink.rst
@@ -115,7 +115,7 @@ this documentation.
     * - Original function
       - Replacement function
     * - phy_start(phydev)
-      - phylink_start(priv->phylink)
+      - phylink_start(priv->phylink) or phylink_start_poll(priv->phylink)
     * - phy_stop(phydev)
       - phylink_stop(priv->phylink)
     * - phy_mii_ioctl(phydev, ifr, cmd)
@@ -251,7 +251,9 @@ this documentation.
 	phylink_mac_change(priv->phylink, link_is_up);
 
     where ``link_is_up`` is true if the link is currently up or false
-    otherwise.
+    otherwise. If a MAC is uanble to provide these interrupts, then
+    :c:func:`phylink_start_poll` should be used in step 5.
+
 
 11. Verify that the driver does not call::
 
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index fc45657bb9c9..616d208b348e 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -964,15 +964,7 @@ static irqreturn_t phylink_link_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-/**
- * phylink_start() - start a phylink instance
- * @pl: a pointer to a &struct phylink returned from phylink_create()
- *
- * Start the phylink instance specified by @pl, configuring the MAC for the
- * desired link mode(s) and negotiation style. This should be called from the
- * network device driver's &struct net_device_ops ndo_open() method.
- */
-void phylink_start(struct phylink *pl)
+static void __phylink_start(struct phylink *pl, bool poll)
 {
 	ASSERT_RTNL();
 
@@ -1014,15 +1006,47 @@ void phylink_start(struct phylink *pl)
 		if (irq <= 0)
 			mod_timer(&pl->link_poll, jiffies + HZ);
 	}
-	if (pl->cfg_link_an_mode == MLO_AN_FIXED && pl->get_fixed_state)
+	if ((pl->cfg_link_an_mode == MLO_AN_FIXED && pl->get_fixed_state) ||
+	    poll)
 		mod_timer(&pl->link_poll, jiffies + HZ);
 	if (pl->phydev)
 		phy_start(pl->phydev);
 	if (pl->sfp_bus)
 		sfp_upstream_start(pl->sfp_bus);
 }
+
+/**
+ * phylink_start() - start a phylink instance
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ *
+ * Start the phylink instance specified by @pl, configuring the MAC for the
+ * desired link mode(s) and negotiation style. This should be called from the
+ * network device driver's &struct net_device_ops ndo_open() method.
+ */
+void phylink_start(struct phylink *pl)
+{
+	__phylink_start(pl, false);
+}
 EXPORT_SYMBOL_GPL(phylink_start);
 
+/**
+ * phylink_start_poll() - start a phylink instance with polling
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ *
+ * Start the phylink instance specified by @pl, as per phylink_start(), but
+ * also enable polling mode. This should be used if the MAC has no support
+ * for MAC PCS status interrupts.
+ *
+ * The MAC PCS must ensure that if it detects the link going down, that must
+ * be reported via mac_pcs_get_state() method to ensure proper update of the
+ * MAC.
+ */
+void phylink_start_poll(struct phylink *pl)
+{
+	__phylink_start(pl, true);
+}
+EXPORT_SYMBOL_GPL(phylink_start_poll);
+
 /**
  * phylink_stop() - stop a phylink instance
  * @pl: a pointer to a &struct phylink returned from phylink_create()
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index bedff1a217fe..529fb5ce440d 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -250,6 +250,7 @@ int phylink_fixed_state_cb(struct phylink *,
 void phylink_mac_change(struct phylink *, bool up);
 
 void phylink_start(struct phylink *);
+void phylink_start_poll(struct phylink *pl);
 void phylink_stop(struct phylink *);
 
 void phylink_ethtool_get_wol(struct phylink *, struct ethtool_wolinfo *);
-- 
2.20.1


-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
