Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99FF146836C
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 09:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384366AbhLDJCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 04:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354761AbhLDJCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 04:02:53 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D21C061751
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 00:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sHRgdwIbiAyz1U44dM0eL4oEwzS+SpE89j1CDNQT4u8=; b=wIBE9EIOWx6Vp90BVBtoQ/CrAP
        Sv25ZTs0kxOYZf3tZgis0JQfOx0UHE/rgCNU4fmiieBGjUaviN/QtRwbBAVlHVavHIts/figh/a+x
        Z79Uay5bzeBsEd6nUk8cfjC3k4MAsIVMon243f+8+cWQ8EEkeq2QJWFYtoKZUueGKqWLguhs5n0Mr
        mdhayLmJ6sxOskt6D9JdwG8qP88a7nmEhMWQl7UjQjWZGa4FATANlY14k/K6PWpRhXA4SsY2d8psS
        QwK7t1i9W/kIDc+msUDS6hfCUme00nsLtfoxNOnRsYB9ljafGzbUOrSUxnt7buXQseymlxCr0CITg
        8IoGuytA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56042)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mtQt1-00039f-Ss; Sat, 04 Dec 2021 08:59:15 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mtQsy-0002H7-Cb; Sat, 04 Dec 2021 08:59:12 +0000
Date:   Sat, 4 Dec 2021 08:59:12 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH RFC net-next 05/12] net: dsa: bcm_sf2: convert to
 phylink_generic_validate()
Message-ID: <Yast4PrQGGLxDrCy@shell.armlinux.org.uk>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwRs-00D8LK-N3@rmk-PC.armlinux.org.uk>
 <6ef4f764-cd91-91bd-e921-407e9d198179@gmail.com>
 <3b3fed98-0c82-99e9-dc72-09fe01c2bcf3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b3fed98-0c82-99e9-dc72-09fe01c2bcf3@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 03, 2021 at 08:18:22PM -0800, Florian Fainelli wrote:
> On 12/3/21 12:03 PM, Florian Fainelli wrote:
> > On 11/24/21 9:52 AM, Russell King (Oracle) wrote:
> > > Populate the supported interfaces and MAC capabilities for the bcm_sf2
> > > DSA switch and remove the old validate implementation to allow DSA to
> > > use phylink_generic_validate() for this switch driver.
> > > 
> > > The exclusion of Gigabit linkmodes for MII and Reverse MII links is
> > > handled within phylink_generic_validate() in phylink, so there is no
> > > need to make them conditional on the interface mode in the driver.
> > > 
> > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > 
> > Tested-by: Florian Fainelli <f.fainelli@gmail.com>
> > 
> > but it looks like the fixed link ports are reporting some pretty strange
> > advertisement values one of my two platforms running the same kernel image:
> 
> We would want to amend your patch with something that caters a bit more
> towards how the ports have been configured:
> 
> diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
> index d6ef0fb0d943..88933c3feddd 100644
> --- a/drivers/net/dsa/bcm_sf2.c
> +++ b/drivers/net/dsa/bcm_sf2.c
> @@ -675,12 +675,18 @@ static u32 bcm_sf2_sw_get_phy_flags(struct
> dsa_switch *ds, int port)
>  static void bcm_sf2_sw_get_caps(struct dsa_switch *ds, int port,
>                                 struct phylink_config *config)
>  {
> -       __set_bit(PHY_INTERFACE_MODE_MII, config->supported_interfaces);
> -       __set_bit(PHY_INTERFACE_MODE_REVMII, config->supported_interfaces);
> -       __set_bit(PHY_INTERFACE_MODE_GMII, config->supported_interfaces);
> -       __set_bit(PHY_INTERFACE_MODE_INTERNAL,
> config->supported_interfaces);
> -       __set_bit(PHY_INTERFACE_MODE_MOCA, config->supported_interfaces);
> -       phy_interface_set_rgmii(config->supported_interfaces);
> +       struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
> +
> +       if (priv->int_phy_mask & BIT(port))
> +               __set_bit(PHY_INTERFACE_MODE_INTERNAL,
> config->supported_interfaces);
> +       else if (priv->moca_port == port)
> +               __set_bit(PHY_INTERFACE_MODE_MOCA,
> config->supported_interfaces);
> +       else {
> +               __set_bit(PHY_INTERFACE_MODE_MII,
> config->supported_interfaces);
> +               __set_bit(PHY_INTERFACE_MODE_REVMII,
> config->supported_interfaces);
> +               __set_bit(PHY_INTERFACE_MODE_GMII,
> config->supported_interfaces);
> +               phy_interface_set_rgmii(config->supported_interfaces);
> +       }
> 
>         config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
>                 MAC_10 | MAC_100 | MAC_1000;

That's fine, thanks for the update.

> Now, with respect to the fixed link ports reporting 1000baseKX/Full this is
> introduced by switching to your patch, it works before and it "breaks"
> after.
> 
> The first part that is a bit weird is that we seem to be calling
> phylink_generic_validate() twice in a row from the same call site.
> 
> For fixed link ports, instead of masking with what the fixed link actually
> supports, we seem to be using a supported mask which is all 1s which seems a
> bit excessive for a fixed link.
> 
> This is an excerpt with the internal PHY:
> 
> [    4.210890] brcm-sf2 f0b00000.ethernet_switch gphy (uninitialized):
> Calling phylink_generic_validate
> [    4.220063] before phylink_get_linkmodes: 0000000,00000000,00010fc0
> [    4.226357] phylink_get_linkmodes: caps: 0xffffffff mac_capabilities:
> 0xff
> [    4.233258] after phylink_get_linkmodes: c000018,00000200,00036fff
> [    4.239463] before anding supported with mask: 0000000,00000000,000062ff
> [    4.246189] after anding supported with mask: 0000000,00000000,000062ff
> [    4.252829] before anding advertising with mask:
> c000018,00000200,00036fff
> [    4.259729] after anding advertising with mask: c000018,00000200,00036fff
> [    4.266546] brcm-sf2 f0b00000.ethernet_switch gphy (uninitialized): PHY
> [f0b403c0.mdio--1:05] driver [Broadcom BCM7445] (irq=POLL)
> 
> and this is what a fixed link port looks like:
> 
> [    4.430765] brcm-sf2 f0b00000.ethernet_switch rgmii_2 (uninitialized):
> Calling phylink_generic_validate
> [    4.440205] before phylink_get_linkmodes: 0000000,00000000,00010fc0
> [    4.446500] phylink_get_linkmodes: caps: 0xff mac_capabilities: 0xff
> [    4.452880] after phylink_get_linkmodes: c000018,00000200,00036fff
> [    4.459085] before anding supported with mask: fffffff,ffffffff,ffffffff
> [    4.465811] after anding supported with mask: c000018,00000200,00036fff
> [    4.472450] before anding advertising with mask:
> c000018,00000200,00036fff
> [    4.479349] after anding advertising with mask: c000018,00000200,00036fff
> 
> or maybe the problem is with phylink_get_ksettings... ran out of time
> tonight to look further into it.

It will be:

        s = phy_lookup_setting(pl->link_config.speed, pl->link_config.duplex,
                               pl->supported, true);
        linkmode_zero(pl->supported);
        phylink_set(pl->supported, MII);
        phylink_set(pl->supported, Pause);
        phylink_set(pl->supported, Asym_Pause);
        phylink_set(pl->supported, Autoneg);
        if (s) {
                __set_bit(s->bit, pl->supported);
                __set_bit(s->bit, pl->link_config.lp_advertising);

Since 1000baseKX_Full is set in the supported mask, phy_lookup_setting()
returns the first entry it finds in the supported table:

        /* 1G */
        PHY_SETTING(   1000, FULL,   1000baseKX_Full            ),
        PHY_SETTING(   1000, FULL,   1000baseT_Full             ),
        PHY_SETTING(   1000, HALF,   1000baseT_Half             ),
        PHY_SETTING(   1000, FULL,   1000baseT1_Full            ),
        PHY_SETTING(   1000, FULL,   1000baseX_Full             ),

Consequently, 1000baseKX_Full is preferred over 1000baseT_Full.

Fixed links don't specify their underlying technology, only the speed
and duplex, so going from speed and duplex to an ethtool link mode is
not easy. I suppose we could drop 1000baseKX_Full from the supported
bitmap in phylink_parse_fixedlink() before the first phylink_validate()
call. Alternatively, the table could be re-ordered. It was supposed to
be grouped by speed and sorted in descending match priority as specified
by the comment above the table. Does it really make sense that
1000baseKX_Full is supposed to be preferred over all the other 1G
speeds? I suppose that's a question for Tom Lendacky
<thomas.lendacky@amd.com>, who introduced this in 3e7077067e80
("phy: Expand phy speed/duplex settings array") back in 2014.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
