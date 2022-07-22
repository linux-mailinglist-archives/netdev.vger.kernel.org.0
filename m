Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3DAB57E297
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 15:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235270AbiGVNwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 09:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233627AbiGVNwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 09:52:07 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3092E7647F;
        Fri, 22 Jul 2022 06:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VrOXmyUnuTc5xwZTdtW/lrqcLh//iHh97nkUOkQ0u/Q=; b=1eQynhfG1ijDSwjXUn5TcS3pPq
        KFTspin9KhbMAylxXiqNeqKbXSCm/MY0XJmCwtzvpKdIndKd+DLgO2nALy80O+VXpHyo/VmsdOp3Q
        qk40kViUq4NVWvlovRbqAqYneLCHKBzbdnHQBvDVvGo+X+g5Cbkk6fD5QjJG6Z6B8I+c1mXdIMl1t
        TQhTkUbU7798s95iuFibC18QFuAb0b4cF0jw8YIib+Es69BMVnvKCbRDuYK//uidWnKqglsx/KaLR
        u/lwJRulW7bOOe2qj4vG5nDspR/odDJCPd4hL5H3+7Vm8DkyUUyEvluVASob6bOhdszRP5f+KMnnx
        WZ1N+LFA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33512)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oEsW2-0006y5-Au; Fri, 22 Jul 2022 14:16:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oEsVg-0005qk-Kv; Fri, 22 Jul 2022 14:16:04 +0100
Date:   Fri, 22 Jul 2022 14:16:04 +0100
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
Message-ID: <YtqjFKUTsH4CK0L+@shell.armlinux.org.uk>
References: <20220721151533.3zomvnfogshk5ze3@skbuf>
 <20220721192145.1f327b2a@dellmb>
 <20220721192145.1f327b2a@dellmb>
 <20220721182216.z4vdaj4zfb6w3emo@skbuf>
 <YtnBmFm8Jhokgp7Q@shell.armlinux.org.uk>
 <20220721213645.57ne2jf7f6try4ec@skbuf>
 <YtpfmF37FmfY6BV5@shell.armlinux.org.uk>
 <20220722105238.qhfq5myqa4ixkvy4@skbuf>
 <YtqNkSDLRDtuooy/@shell.armlinux.org.uk>
 <20220722124629.7y3p7nt6jmm5hecq@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722124629.7y3p7nt6jmm5hecq@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 03:46:29PM +0300, Vladimir Oltean wrote:
> On Fri, Jul 22, 2022 at 12:44:17PM +0100, Russell King (Oracle) wrote:
> > Today, there is no guarantee - because it depends on how people have
> > chosen to implement 2500base-X, and whether the hardware requires the
> > use of in-band AN or prohibits it. This is what happens when stuff
> > isn't standardised - one ends up with differing implementations doing
> > different things, and this has happened not _only_ at hardware level
> > but also software level as well.
> > 
> > You have to also throw into this that various implementations also have
> > an "AN bypass" flag, which means if they see what looks like a valid
> > SERDES data stream, but do not see the AN data, after a certain timeout
> > they allow the link to come up - and again, whether that is enabled or
> > not is pot luck today.
> 
> Interesting. After the timeout expires, does the lane ever transition
> back into the encoding required for AN mode, in case there appears at a
> later time someone willing to negotiate?

They don't document that it does.

> > > similarly, there is a good chance that the DT description below might
> > > result in a functional link:
> > > 
> > > 	&eth0 {
> > > 		phy-mode = "2500base-x";
> > > 		managed = "in-band-status";
> > > 	};
> > > 
> > > 	&switch_cpu_port {
> > > 		ethernet = <&eth0>;
> > > 		phy-mode = "25000base-x";
> > > 
> > > 		fixed-link {
> > > 			speed = <2500>;
> > > 			full-duplex;
> > > 		};
> > > 	};
> > > 
> > > There is no expectation from either DT description to use in-band
> > > autoneg or not.
> > > 
> > > The fact that of_phy_is_fixed_link() was made by Stas Sergeev to say
> > > that a 'managed' link with the value != 'auto' is fixed prompted me to
> > > study exactly what those changes were about.
> > 
> > From what I can see, there is no formal definition of "in-band-status"
> > beyond what it says on the tin. The description in the DT binding
> > specification, which is really where this should be formally documented,
> > is totally lacking.
> > 
> > >     This patch introduces the new string property 'managed' that allows
> > >     the user to set the management type explicitly.
> > >     The supported values are:
> > >     "auto" - default. Uses either MDIO or nothing, depending on the presence
> > >     of the fixed-link node
> > >     "in-band-status" - use in-band status
> > 
> > This, and how this is implemented by mvneta, is the best we have to go
> > on for the meaning of this.
> > 
> > > This is why I am asking whether there is any formal definition of what
> > > managed = "in-band-status" means. You've said it means about retrieving
> > > link status from the PCS. What are you basing upon when you are saying that?
> > 
> > Given that this managed property was introduced for mvneta, mvneta's
> > implementation of it is the best reference we have to work out what
> > the intentions of it were beyond the commit text.
> > 
> > With in-band mode enabled, mvneta makes use of a fixed-link PHY, and
> > updates the fixed-link PHY with the status from its GMAC block (which
> > is the combined PCS+MAC).
> > 
> > So, when in-band mode is specified, the results from SGMII or 1000base-X
> > negotiation are read from the MAC side of the link, pushed into the
> > fixed-PHY, which then are reflected back into the driver via the usual
> > phylib adjust_link().
> > 
> > Have a read through mvneta's code at this commit:
> > 
> > git show 2eecb2e04abb62ef8ea7b43e1a46bdb5b99d1bf8:drivers/net/ethernet/marvell/mvneta.c
> > 
> > specifically, mvneta_fixed_link_update() and mvneta_adjust_link().
> > Note that when operating in in-band mode, there is actually no need
> > for the configuration of MVNETA_GMAC_AUTONEG_CONFIG to be touched
> > in any way since the values read from the MVNETA_GMAC_STATUS register
> > indicate what parameters the MAC is actually using. (The speed,
> > duplex, and pause bits in AUTONEG_CONFIG are ignored anyway if AN
> > is enabled.)
> 
> I view this as just an implementation detail and not as something that
> influences what managed = "in-band-status" is supposed to mean.
> 
> > I know this is rather wooly, but not everything is defined in black and
> > white, and we need to do the best we can with the information that is
> > available.
> 
> So mvneta at the stage of the commit you've mentioned calls
> mvneta_set_autoneg() with the value of pp->use_inband_status. There is
> then the exception to be made for the PCS being what's exposed to the
> medium, and in that case, ethtool may also override the pp->use_inband_status
> variable (which in turn affects the autoneg).
> 
> So if we take mvneta at this commit as the reference, what we learn is
> that using in-band status essentially depends on using in-band autoneg
> in the first place.
> 
> What is hard for me to comprehend is how we ever came to conclude that
> for SERDES protocols where clause 37 is possible (2500base-x should be
> part of this group), managed = "in-band-status" does not imply in-band
> autoneg, considering the mvneta precedent.

That is a recent addition, since the argument was made that when using
a 1000base-X fibre transceiver, using ethtool to disable autoneg is a
reasonable thing to do - and something that was supported with
mvneta_ethtool_set_link_ksettings() as it stands at the point in the
commit above.

> And why would we essentially redefine its meaning by stating that no,
> it is only about the status, not about the autoneg, even though the
> status comes from the autoneg for these protocols.

I'm not sure I understand what you're getting at there.

Going back to the mvneta combined PCS+MAC implementation, we read the
link parameters from the PCS when operating in in-band mode and throw
them at the fixed PHY so that ethtool works, along with all the usual
link up/down state reporting, carrier etc.

If autoneg is disabled, then we effectively operate in fixed-link mode
(use_inband_status becomes false, and we start forcing the link up/down
and also force the speed and duplex parameters by disabling autoneg.)

Note that this version of mvneta does not support 1000base-X mode, only
SGMII is actually supported.

There's a few things that are rather confusing in the driver:

MVNETA_GMAC_INBAND_AN_ENABLE - this controls whether in-band negotiation
is performed or not.
MVNETA_GMAC_AN_SPEED_EN - this controls whether the result of in-band
negotiation for speed is used, or the manually programmed speed in this
register.
MVNETA_GMAC_AN_DUPLEX_EN - same for duplex.
MVNETA_GMAC_AN_FLOW_CTRL_EN - same for pause (only symmetric pause is
supported)

MVNETA_GMAC2_INBAND_AN_ENABLE - misnamed, it selects whether SGMII (set)
or 1000base-X (unset) format for the 16-bit control word is used.

There is another bit in MVNETA_GMAC_CTRL_0 that selects between
1000base-X and SGMII operation mode, and when this bit is set for
1000base-X. This version of the driver doesn't support 1000base-X,
so this bit is never set.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
