Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2419D4025A9
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 10:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244495AbhIGIyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 04:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244341AbhIGIyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 04:54:02 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF92BC061575
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 01:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FILHmB7QkajkVtljgJWx7TB0BqoWCiNebwpr1OiknzM=; b=loQO1ZjkfndB8/px5uqQHebc9o
        8jgPBjYa8B2IB6LAAscubQv1ede73J/mlGF6yG/iMQUqar77aw/MZvLgssKLMVzKbkHkOJcqAwOtk
        6jFbyU9Ub0ixtQ7UU42jOvZwv5i13SK4jg0hQUSsbqlayfcQPsXdIUXMNcACA4rM9z3pLSEkmCLlk
        a+HK197Zh8KKi66qm3aOjq1wP/X6MppefFEU4Zw+xvCtL/uqus+uE7nBSCKmKNCtFSeQ/9N9dd8tY
        kyCEEby9HUMsPM8STLQtaALoptvvHuPVnTVcVXBmx9XKcUNjvFIDBmacN5wEkf+l6LN1ycC4NlnWy
        KTBD153g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44988)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mNWqW-0002rr-9T; Tue, 07 Sep 2021 09:52:47 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mNWqQ-00046A-IP; Tue, 07 Sep 2021 09:52:42 +0100
Date:   Tue, 7 Sep 2021 09:52:42 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
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
Message-ID: <YTcoWsZ77pXW2+uK@shell.armlinux.org.uk>
References: <20210903080147.GS22278@shell.armlinux.org.uk>
 <DB8PR04MB679518228AB7B2C5CD47A1B3E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210903093246.GT22278@shell.armlinux.org.uk>
 <DB8PR04MB6795EE2FA03451AB5D73EFC3E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210903120127.GW22278@shell.armlinux.org.uk>
 <20210903201210.GF1350@shell.armlinux.org.uk>
 <DB8PR04MB6795FC58C1D0E2481E2BC35EE6D29@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YTXgqBRMRvYdPyJU@shell.armlinux.org.uk>
 <DB8PR04MB67958E22A85B15FFCA7CDA70E6D29@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YTX515RMVNmT4q+o@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTX515RMVNmT4q+o@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 06, 2021 at 12:22:00PM +0100, Russell King (Oracle) wrote:
> I'll prepare a proper patch for the net tree for phylink, which I'll
> send you, so you can include with your patch set.

Hi,

Here is the patch. I've tweaked some of the comments a little bit
further to explain more what is going on. Please submit this with
your patch for stmmac.

Thanks.

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net] net: phylink: add suspend/resume support

Joakim Zhang reports that Wake-on-Lan with the stmmac ethernet driver
broke when moving the incorrect handling of mac link state out of
mac_config(). This reason this breaks is because the stmmac's WoL is
handled by the MAC rather than the PHY, and phylink doesn't cater for
that scenario.

This patch adds the necessary phylink code to handle suspend/resume
events according to whether the MAC still needs a valid link or not.
This is the barest minimum for this support.

Reported-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 83 +++++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  3 ++
 2 files changed, 86 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 2cdf9f989dec..13d9191e8526 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -33,6 +33,7 @@
 enum {
 	PHYLINK_DISABLE_STOPPED,
 	PHYLINK_DISABLE_LINK,
+	PHYLINK_DISABLE_MAC_WOL,
 };
 
 /**
@@ -1282,6 +1283,9 @@ EXPORT_SYMBOL_GPL(phylink_start);
  * network device driver's &struct net_device_ops ndo_stop() method.  The
  * network device's carrier state should not be changed prior to calling this
  * function.
+ *
+ * This will synchronously bring down the link if the link is not already
+ * down (in other words, it will trigger a mac_link_down() method call.)
  */
 void phylink_stop(struct phylink *pl)
 {
@@ -1301,6 +1305,85 @@ void phylink_stop(struct phylink *pl)
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
+		 * but one would hope all packets have been sent. This
+		 * also means phylink_resolve() will do nothing.
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
+
+		/* Re-enable and re-resolve the link parameters */
+		clear_bit(PHYLINK_DISABLE_MAC_WOL, &pl->phylink_disable_state);
+		phylink_run_resolve(pl);
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
index afb3ded0b691..237291196ce2 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -451,6 +451,9 @@ void phylink_mac_change(struct phylink *, bool up);
 void phylink_start(struct phylink *);
 void phylink_stop(struct phylink *);
 
+void phylink_suspend(struct phylink *pl, bool mac_wol);
+void phylink_resume(struct phylink *pl);
+
 void phylink_ethtool_get_wol(struct phylink *, struct ethtool_wolinfo *);
 int phylink_ethtool_set_wol(struct phylink *, struct ethtool_wolinfo *);
 
-- 
2.30.2

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
