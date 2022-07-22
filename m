Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83DF57E296
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 15:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235277AbiGVNwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 09:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235213AbiGVNwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 09:52:07 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B892B74CC2;
        Fri, 22 Jul 2022 06:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5wmEZg8e3eCAlKcAUPdfdOasbgULgwSt4SV8j8Mdeec=; b=yqkIcaBlLNpNZg1fKq0xUDZaiZ
        iniVnF2uQqxoURzJGfe+foJIZJA+90DvfpWrORP117AxcQhfYr+R5WIIUB7i+JLt7vQqAALkB4gA/
        fcumWs66Qis+iOWEuEYNSOwpggdqavJ53C7r8Q5tE4muoGOuZbWFyZZYU1JjfmcF58SVFI4NflHZr
        IimUKjJKKexGBcP6VG3Hjcw2ux5PbHtOQulZ5UMzGwSpbc6RpRwiRifhg+0WKqLDgHNKVXE+FweeV
        WQ1CbuHcTVKxDdRyobiRZ4MMKKO8/Zp2/h7g6jnf0TxcXhRkPxlFxL8cbsZoVnpoCZ2fxVx4L++XX
        hQnqqlEg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33506)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oEr5N-0006q5-FF; Fri, 22 Jul 2022 12:44:49 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oEr4r-0005nM-D3; Fri, 22 Jul 2022 12:44:17 +0100
Date:   Fri, 22 Jul 2022 12:44:17 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
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
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net-next 3/6] net: dsa: add support for retrieving the
 interface mode
Message-ID: <YtqNkSDLRDtuooy/@shell.armlinux.org.uk>
References: <20220721134618.axq3hmtckrumpoy6@skbuf>
 <Ytlol8ApI6O2wy99@shell.armlinux.org.uk>
 <20220721151533.3zomvnfogshk5ze3@skbuf>
 <20220721192145.1f327b2a@dellmb>
 <20220721192145.1f327b2a@dellmb>
 <20220721182216.z4vdaj4zfb6w3emo@skbuf>
 <YtnBmFm8Jhokgp7Q@shell.armlinux.org.uk>
 <20220721213645.57ne2jf7f6try4ec@skbuf>
 <YtpfmF37FmfY6BV5@shell.armlinux.org.uk>
 <20220722105238.qhfq5myqa4ixkvy4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722105238.qhfq5myqa4ixkvy4@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 01:52:38PM +0300, Vladimir Oltean wrote:
> On Fri, Jul 22, 2022 at 09:28:08AM +0100, Russell King (Oracle) wrote:
> > On Fri, Jul 22, 2022 at 12:36:45AM +0300, Vladimir Oltean wrote:
> > > On Thu, Jul 21, 2022 at 10:14:00PM +0100, Russell King (Oracle) wrote:
> > > > > > So currently we try to enable C37 AN in 2500base-x mode, although
> > > > > > the standard says that it shouldn't be there, and it shouldn't be there
> > > > > > presumably because they want it to work with C73 AN.
> > > > > > 
> > > > > > I don't know how to solve this issue. Maybe declare a new PHY interface
> > > > > > mode constant, 2500base-x-no-c37-an ?
> > > > > 
> > > > > So this is essentially what I'm asking, and you didn't necessarily fully
> > > > > answer. I take it that there exist Marvell switches which enable in-band
> > > > > autoneg for 2500base-x and switches which don't, and managed = "in-band-status"
> > > > > has nothing to do with that decision. Right?
> > > > 
> > > > I think we're getting a little too het up over this.
> > > 
> > > No, I think it's relevant to this patch set.
> > > 
> > > > We have 1000base-X where, when we're not using in-band-status, we don't
> > > > use autoneg (some drivers that weren't caught in review annoyingly do
> > > > still use autoneg, but they shouldn't). We ignore the ethtool autoneg
> > > > bit.
> > > > 
> > > > We also have 1000base-X where we're using in-band-status, and we then
> > > > respect the ethtool autoneg bit.
> > > > 
> > > > So, wouldn't it be logical if 2500base-X were implemented the same way,
> > > > and on setups where 2500base-X does not support clause 37 AN, we
> > > > clear the ethtool autoneg bit? If we have 2500base-X being used as the
> > > > media link, surely this is the right behaviour?
> > > 
> > > The ethtool autoneg bit is only relevant when the PCS is the last thing
> > > before the medium. But if the SERDES protocol connects the MAC to the PHY,
> > > or the MAC to another MAC (such as the case here, CPU or DSA ports),
> > > there won't be any ethtool bit to take into consideration, and that's
> > > where my question is. Is there any expected correlation between enabling
> > > in-band autoneg and the presence or absence of managed = "in-band-status"?
> > 
> > This topic is something I was looking at back in November 2021, trying
> > to work out what the most sensible way of indicating to a PCS whether
> > it should enable in-band or not:
> > 
> > http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=net-queue&id=e4ea7d035e7e04e87dfd86702f59952e0cecc18d
> > http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=net-queue&id=e454bf101fa457dd5c2cea0b1aaab7ba33048089
> > http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=net-queue&id=e2c57490f205ae7c0e11fcf756675937f933be5e
> > 
> > The intention there was to move the decision about whether a PCS should
> > enable autoneg out of the PCS and into phylink, but doing that one comes
> > immediately on the problem of (e.g.) Marvell NETA/PP2 vs Lynx having
> > different interpretations for 2500base-X. There are also a number of
> > drivers that do not follow MLO_AN_INBAND-means-use-inband or not for
> > things such as SGMII or 1000base-X.
> > 
> > This means we have no standard interpretation amongst phylink users
> > about when in-band signalling should be enabled or disabled, which
> > means moving that decision into phylink today isn't possible.
> > 
> > The only thing we could do is provide the PCS with an additional bit
> > of information so it can make the decision - something like a boolean
> > "pcs_connects_to_medium" flag, and keep the decision making in the
> > PCS-specific code - sadly keeping the variability between different
> > PCS implementations.
> 
> The way I understand what you're saying is that there is no guarantee
> that the DSA master and CPU port will agree whether to use in-band
> autoneg or not here (and implicitly, there is no guarantee that this
> link will work):
> 
> 	&eth0 {
> 		phy-mode = "2500base-x";
> 		managed = "in-band-status";
> 	};
> 
> 	&switch_cpu_port {
> 		ethernet = <&eth0>;
> 		phy-mode = "25000base-x";

I'll assume that 25000 is a typo.

> 		managed = "in-band-status";
> 	};

Today, there is no guarantee - because it depends on how people have
chosen to implement 2500base-X, and whether the hardware requires the
use of in-band AN or prohibits it. This is what happens when stuff
isn't standardised - one ends up with differing implementations doing
different things, and this has happened not _only_ at hardware level
but also software level as well.

You have to also throw into this that various implementations also have
an "AN bypass" flag, which means if they see what looks like a valid
SERDES data stream, but do not see the AN data, after a certain timeout
they allow the link to come up - and again, whether that is enabled or
not is pot luck today.

> similarly, there is a good chance that the DT description below might
> result in a functional link:
> 
> 	&eth0 {
> 		phy-mode = "2500base-x";
> 		managed = "in-band-status";
> 	};
> 
> 	&switch_cpu_port {
> 		ethernet = <&eth0>;
> 		phy-mode = "25000base-x";
> 
> 		fixed-link {
> 			speed = <2500>;
> 			full-duplex;
> 		};
> 	};
> 
> There is no expectation from either DT description to use in-band
> autoneg or not.
> 
> The fact that of_phy_is_fixed_link() was made by Stas Sergeev to say
> that a 'managed' link with the value != 'auto' is fixed prompted me to
> study exactly what those changes were about.

From what I can see, there is no formal definition of "in-band-status"
beyond what it says on the tin. The description in the DT binding
specification, which is really where this should be formally documented,
is totally lacking.

>     This patch introduces the new string property 'managed' that allows
>     the user to set the management type explicitly.
>     The supported values are:
>     "auto" - default. Uses either MDIO or nothing, depending on the presence
>     of the fixed-link node
>     "in-band-status" - use in-band status

This, and how this is implemented by mvneta, is the best we have to go
on for the meaning of this.

> This is why I am asking whether there is any formal definition of what
> managed = "in-band-status" means. You've said it means about retrieving
> link status from the PCS. What are you basing upon when you are saying that?

Given that this managed property was introduced for mvneta, mvneta's
implementation of it is the best reference we have to work out what
the intentions of it were beyond the commit text.

With in-band mode enabled, mvneta makes use of a fixed-link PHY, and
updates the fixed-link PHY with the status from its GMAC block (which
is the combined PCS+MAC).

So, when in-band mode is specified, the results from SGMII or 1000base-X
negotiation are read from the MAC side of the link, pushed into the
fixed-PHY, which then are reflected back into the driver via the usual
phylib adjust_link().

Have a read through mvneta's code at this commit:

git show 2eecb2e04abb62ef8ea7b43e1a46bdb5b99d1bf8:drivers/net/ethernet/marvell/mvneta.c

specifically, mvneta_fixed_link_update() and mvneta_adjust_link().
Note that when operating in in-band mode, there is actually no need
for the configuration of MVNETA_GMAC_AUTONEG_CONFIG to be touched
in any way since the values read from the MVNETA_GMAC_STATUS register
indicate what parameters the MAC is actually using. (The speed,
duplex, and pause bits in AUTONEG_CONFIG are ignored anyway if AN
is enabled.)

I know this is rather wooly, but not everything is defined in black and
white, and we need to do the best we can with the information that is
available.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
