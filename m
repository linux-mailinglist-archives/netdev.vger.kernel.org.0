Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8E6400661
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 22:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350341AbhICUN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 16:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350210AbhICUNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 16:13:21 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9562C061575
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 13:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1RqmR7fF5uwF76ZoMHz34x87zYITUoVrBIyTrNcysuQ=; b=srqu3MZqnfvRqxorpL440CFpk
        zL1XYFpPouMF37Dd+Ges7pFnxZFXsSdHxEpIFptdiEv5MrjWC6Via2IrF+AskRNIPhhfMctuLfOwe
        SLWG9nCUn5kCjDDTEbutWRVwoIdDpss9yDy7iC1cmXpwVRwbgJQhIJ793dF46m3mroksCGnzRe50i
        sCFVlLYPNMKM6/K8/+iZlWFZD0t3h52XOPe8Axak1acRWOulu17+XMsZRTUKBZqvPMLRLGsJl3fQZ
        7ID+kods42o9mTUaoOpVJronupbg69IIBSH8o+g0QDMne0R650oP1z4mS4zwJD4hvvxz5EfyC4LNp
        HjX7VGsFQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48186)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mMFXp-0003Y2-Ht; Fri, 03 Sep 2021 21:12:13 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mMFXm-0000o6-Ms; Fri, 03 Sep 2021 21:12:10 +0100
Date:   Fri, 3 Sep 2021 21:12:10 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] net: stmmac: fix MAC not working when system resume back
 with WoL enabled
Message-ID: <20210903201210.GF1350@shell.armlinux.org.uk>
References: <DB8PR04MB67954F4650408025E6D4EE2AE6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210902104943.GD22278@shell.armlinux.org.uk>
 <DB8PR04MB6795C37D718096E7CA1AA72DE6CE9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YTDCZN/WKlv9BsNG@lunn.ch>
 <DB8PR04MB6795C36B8211EE1A1C0280D9E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210903080147.GS22278@shell.armlinux.org.uk>
 <DB8PR04MB679518228AB7B2C5CD47A1B3E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210903093246.GT22278@shell.armlinux.org.uk>
 <DB8PR04MB6795EE2FA03451AB5D73EFC3E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210903120127.GW22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903120127.GW22278@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here's a patch to try - you'll need to integrate the new calls into
stmmac's suspend and resume hooks. Obviously, given my previous
comments, this isn't tested!

I didn't need to repeat the mac_wol boolean to phylink_resume as we
can record the state internally - mac_wol should not change between
a call to phylink_suspend() and subsequent phylink_resume() anyway.

mac_wol should only be true if the MAC is involved in processing
packets for WoL, false otherwise.

Please let me know if this resolves your stmmac WoL issue.

Thanks.

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index f0c769027145..c4d0de04416a 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -33,6 +33,7 @@
 enum {
 	PHYLINK_DISABLE_STOPPED,
 	PHYLINK_DISABLE_LINK,
+	PHYLINK_DISABLE_MAC_WOL,
 };
 
 /**
@@ -1313,6 +1314,9 @@ EXPORT_SYMBOL_GPL(phylink_start);
  * network device driver's &struct net_device_ops ndo_stop() method.  The
  * network device's carrier state should not be changed prior to calling this
  * function.
+ *
+ * This will synchronously bring down the link if the link is not already
+ * down (in other words, it will trigger a mac_link_down() method call.)
  */
 void phylink_stop(struct phylink *pl)
 {
@@ -1338,6 +1342,81 @@ void phylink_stop(struct phylink *pl)
 }
 EXPORT_SYMBOL_GPL(phylink_stop);
 
+
+/**
+ * phylink_suspend() - handle a network device suspend event
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ * @mac_wol: true if the MAC needs to receive packets for Wake-on-Lan
+ *
+ * Handle a network device suspend event. There are several cases:
+ * - If Wake-on-Lan is not active, we can bring down the link between
+ *   the MAC and PHY by calling phylink_stop().
+ * - If Wake-on-Lan is active, and being handled only by the PHY, we
+ *   can also bring down the link between the MAC and PHY.
+ * - If Wake-on-Lan is active, but being handled by the MAC, the MAC
+ *   still needs to receive packets, so we can not bring the link down.
+ */
+void phylink_suspend(struct phylink *pl, bool mac_wol)
+{
+	ASSERT_RTNL();
+
+	if (mac_wol && (!pl->netdev || pl->netdev->wol_enabled)) {
+		/* Wake-on-Lan enabled, MAC handling */
+		mutex_lock(&pl->state_mutex);
+
+		/* Stop the resolver bringing the link up */
+		__set_bit(PHYLINK_DISABLE_MAC_WOL, &pl->phylink_disable_state);
+
+		/* Disable the carrier, to prevent transmit timeouts,
+		 * but one would hope all packets have been sent.
+		 */
+		netif_carrier_off(pl->netdev);
+
+		/* We do not call mac_link_down() here as we want the
+		 * link to remain up to receive the WoL packets.
+		 */
+		mutex_unlock(&pl->state_mutex);
+	} else {
+		phylink_stop(pl);
+	}
+}
+EXPORT_SYMBOL_GPL(phylink_suspend);
+
+/**
+ * phylink_resume() - handle a network device resume event
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ *
+ * Undo the effects of phylink_suspend(), returning the link to an
+ * operational state.
+ */
+void phylink_resume(struct phylink *pl)
+{
+	ASSERT_RTNL();
+
+	if (test_bit(PHYLINK_DISABLE_MAC_WOL, &pl->phylink_disable_state)) {
+		/* Wake-on-Lan enabled, MAC handling */
+
+		/* Call mac_link_down() so we keep the overall state balanced.
+		 * Do this under the state_mutex lock for consistency. This
+		 * will cause a "Link Down" message to be printed during
+		 * resume, which is harmless - the true link state will be
+		 * printed when we run a resolve.
+		 */
+		mutex_lock(&pl->state_mutex);
+		phylink_link_down(pl);
+		mutex_unlock(&pl->state_mutex);
+
+		/* Re-apply the link parameters so that all the settings get
+		 * restored to the MAC.
+		 */
+		phylink_mac_initial_config(pl, true);
+		phylink_enable_and_run_resolve(pl, PHYLINK_DISABLE_MAC_WOL);
+	} else {
+		phylink_start(pl);
+	}
+}
+EXPORT_SYMBOL_GPL(phylink_resume);
+
 /**
  * phylink_ethtool_get_wol() - get the wake on lan parameters for the PHY
  * @pl: a pointer to a &struct phylink returned from phylink_create()
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index bdeec800da5c..ba0ab7126b96 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -462,6 +462,9 @@ void phylink_mac_change(struct phylink *, bool up);
 void phylink_start(struct phylink *);
 void phylink_stop(struct phylink *);
 
+void phylink_suspend(struct phylink *pl, bool mac_wol);
+void phylink_resume(struct phylink *pl);
+
 void phylink_ethtool_get_wol(struct phylink *, struct ethtool_wolinfo *);
 int phylink_ethtool_set_wol(struct phylink *, struct ethtool_wolinfo *);
 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
