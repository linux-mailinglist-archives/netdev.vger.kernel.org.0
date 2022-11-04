Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF0061956B
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 12:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiKDLfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 07:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiKDLfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 07:35:15 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3292610F
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 04:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=b5LJVAtXXX88cCMkzfXg4zyuUIFcZEtxOqLanXlosaw=; b=rV2mJGgfaZX1bv5nJFFn4wuUzx
        9tlYiFrP/4yHD0M4vlhHv/voletmPLXvCCRCwmbtPu4abwLYLnwA8U3Wex9HR2NYbS7o0EEecJHg2
        CW0xEZwxTzH3XvhG3zRk90GxLjAJMHYwUB+cKbGemJt+S0Pmmk8ITue78py9dZDeVamowo1iDZnhY
        cYc56Zo5SM+vPQNDPtOfUEeYkJlTCT/JCBAST1jwpxVO/L2lIADNKDCDMCgoQrM8TdSnDoY93xBTs
        FAqk/O2sJjZR24nHfCNnMwPFaZc4FyVAmvYeCkN4yP6QNHMbxskEKKG1Axxr3C7wfk0ZK7IU6WUz/
        Fkrcq+sA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35104)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oquyc-0007Vy-AE; Fri, 04 Nov 2022 11:35:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oquya-0000r6-4X; Fri, 04 Nov 2022 11:35:08 +0000
Date:   Fri, 4 Nov 2022 11:35:08 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 4/4] net: dsa: remove phylink_validate() method
Message-ID: <Y2T47CorBztXGgS4@shell.armlinux.org.uk>
References: <20221101114806.1186516-1-vladimir.oltean@nxp.com>
 <20221101114806.1186516-5-vladimir.oltean@nxp.com>
 <Y2T2fIb5SBRQbn8I@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2T2fIb5SBRQbn8I@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 11:24:44AM +0000, Russell King (Oracle) wrote:
> On Tue, Nov 01, 2022 at 01:48:06PM +0200, Vladimir Oltean wrote:
> > As of now, all DSA drivers use phylink_generic_validate() and there is
> > no known use case remaining for a driver-specific link mode validation
> > procedure. As such, remove this DSA operation and let phylink determine
> > what is supported based on config->mac_capabilities, which all drivers
> > provide.
> > 
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> > Not all DSA drivers provide config->mac_capabilities, for example
> > mv88e6060, lan9303 and vsc73xx don't. However, there have been users of
> > those drivers on recent kernels and no one reported that they fail to
> > establish a link, so I'm guessing that they work (somehow). But I must
> > admit I don't understand why phylink_generic_validate() works when
> > mac_capabilities=0. Anyway, these drivers did not provide a
> > phylink_validate() method before and do not provide one now, so nothing
> > changes for them.
> 
> There is one remaining issue that needs to be properly addressed,
> which is the bcm_sf2 driver, which is basically buggy. The recent
> kernel build bot reports reminded me of this.
> 
> I've tried talking to Florian about it, and didn't make much progress,
> so I'm carrying a patch in my tree which at least makes what is
> provided to phylink correct.
> 
> See
> http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=net-queue&id=63d77c1f9db167fd74994860a4a899df5c957aab
> and all the FIXME comments in there.
> 
> This driver really needs to be fixed before we kill DSA's
> phylink_validate method (although doing so doesn't change anything
> in mainline, but will remove my reminder that bcm_sf2 is still
> technically broken.)

Here's the corrected patch, along with a bit more commentry about the
problems that I had kicking around in another commit.

8<=====
From: Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH] net: dsa: bcm_sf2: fix pause mode validation

The implementation appears not to appear to support pause modes on
anything but RGMII, RGMII_TXID, MII and REVMII interface modes. Let
phylink know that detail.

Moreover, RGMII_RXID and RGMII_ID appears to be unsupported.
(This may not be correct; particularly see the FIXMEs in this patch.)

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/bcm_sf2.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 18a3847bd82b..6676971128d1 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -727,6 +727,10 @@ static void bcm_sf2_sw_get_caps(struct dsa_switch *ds, int port,
 		__set_bit(PHY_INTERFACE_MODE_MII, interfaces);
 		__set_bit(PHY_INTERFACE_MODE_REVMII, interfaces);
 		__set_bit(PHY_INTERFACE_MODE_GMII, interfaces);
+
+		/* FIXME 1: Are RGMII_RXID and RGMII_ID actually supported?
+		 * See FIXME 2 and FIXME 3 below.
+		 */
 		phy_interface_set_rgmii(interfaces);
 	}
 
@@ -734,6 +738,28 @@ static void bcm_sf2_sw_get_caps(struct dsa_switch *ds, int port,
 		MAC_10 | MAC_100 | MAC_1000;
 }
 
+static void bcm_sf2_sw_validate(struct dsa_switch *ds, int port,
+				unsigned long *supported,
+				struct phylink_link_state *state)
+{
+	u32 caps;
+
+	caps = dsa_to_port(ds, port)->pl_config.mac_capabilities;
+
+	/* Pause modes are only programmed for these modes - see FIXME 3.
+	 * So, as pause modes are not configured for other modes, disable
+	 * support for them. If FIXME 3 is updated to allow the other RGMII
+	 * modes, these should be included here as well.
+	 */
+	if (!(state->interface == PHY_INTERFACE_MODE_RGMII ||
+	      state->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
+	      state->interface == PHY_INTERFACE_MODE_MII ||
+	      state->interface == PHY_INTERFACE_MODE_REVMII))
+		caps &= ~(MAC_ASYM_PAUSE | MAC_SYM_PAUSE);
+
+	phylink_validate_mask_caps(supported, state, caps);
+}
+
 static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
 				  unsigned int mode,
 				  const struct phylink_link_state *state)
@@ -747,6 +773,11 @@ static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
 		return;
 
 	switch (state->interface) {
+	/* FIXME 2: Are RGMII_RXID and RGMII_ID actually supported? This
+	 * switch statement means that the RGMII control register does not
+	 * get programmed in these two modes, but surely it needs to at least
+	 * set the port mode to EXT_GPHY?
+	 */
 	case PHY_INTERFACE_MODE_RGMII:
 		id_mode_dis = 1;
 		fallthrough;
@@ -850,6 +881,10 @@ static void bcm_sf2_sw_mac_link_up(struct dsa_switch *ds, int port,
 		else
 			offset = CORE_STS_OVERRIDE_GMIIP2_PORT(port);
 
+		/* FIXME 3: Are RGMII_RXID and RGMII_ID actually supported?
+		 * Why are pause modes only supported for a couple of RGMII
+		 * modes? Should this be using phy_interface_mode_is_rgmii()?
+		 */
 		if (interface == PHY_INTERFACE_MODE_RGMII ||
 		    interface == PHY_INTERFACE_MODE_RGMII_TXID ||
 		    interface == PHY_INTERFACE_MODE_MII ||
@@ -1207,6 +1242,7 @@ static const struct dsa_switch_ops bcm_sf2_ops = {
 	.get_ethtool_phy_stats	= b53_get_ethtool_phy_stats,
 	.get_phy_flags		= bcm_sf2_sw_get_phy_flags,
 	.phylink_get_caps	= bcm_sf2_sw_get_caps,
+	.phylink_validate	= bcm_sf2_sw_validate,
 	.phylink_mac_config	= bcm_sf2_sw_mac_config,
 	.phylink_mac_link_down	= bcm_sf2_sw_mac_link_down,
 	.phylink_mac_link_up	= bcm_sf2_sw_mac_link_up,
-- 
2.30.2

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
