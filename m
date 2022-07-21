Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC86F57D31A
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 20:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiGUSQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 14:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiGUSQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 14:16:25 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD6E481FB;
        Thu, 21 Jul 2022 11:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ko/ecmmHmwqq0NBK1EGja/+qrA547dXPD160U10AvfU=; b=H7A1QYw3UiBwcvwGleWFgG6vqR
        8MymHBVDUonn6FgmkbsxQ720UY+rgXmu0joP150qTGpHSaWg03+jKDktxmpiOI3vAxeFu4wKXyZ/n
        V54xaQNUPF0+tDClv0DOu56hg6vlq0Ga131rOzvLvUcEni+BIQ+43V7JCHCSw+1k80v11lnZxLV8F
        /pvS5zI2aKh/hhWxSwXGIAOKjCmqE6OniA97HkAa2vbaQjuds6BAzfF/ExwTPFCfI5mYLBBbZb00V
        6MN4xAoGuMADbFw7VQ/JtSPQ3lnyYTjtuSEwI6QCK/tLFdSPJkYTQdD4ujJVVqlkTi2ixTXHNaHSO
        FAZeRlhg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33488)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oEaiQ-0005pP-2P; Thu, 21 Jul 2022 19:16:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oEaiL-00053h-1h; Thu, 21 Jul 2022 19:15:57 +0100
Date:   Thu, 21 Jul 2022 19:15:57 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
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
Message-ID: <YtmX3cD8nUqftHDY@shell.armlinux.org.uk>
References: <YtHw0O5NB6kGkdwV@shell.armlinux.org.uk>
 <20220716105711.bjsh763smf6bfjy2@skbuf>
 <YtKdcxupT+INVAhR@shell.armlinux.org.uk>
 <20220716123608.chdzbvpinso546oh@skbuf>
 <YtUec3GTWTC59sky@shell.armlinux.org.uk>
 <20220720224447.ygoto4av7odsy2tj@skbuf>
 <20220721134618.axq3hmtckrumpoy6@skbuf>
 <Ytlol8ApI6O2wy99@shell.armlinux.org.uk>
 <20220721151533.3zomvnfogshk5ze3@skbuf>
 <20220721192145.1f327b2a@dellmb>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220721192145.1f327b2a@dellmb>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 07:21:45PM +0200, Marek Behún wrote:
> On Thu, 21 Jul 2022 18:15:33 +0300
> Vladimir Oltean <olteanv@gmail.com> wrote:
> 
> > On Thu, Jul 21, 2022 at 03:54:15PM +0100, Russell King (Oracle) wrote:
> > > Yes, which is why I said on July 7th:
> > > 
> > > "So I also don't see a problem - sja1105 rejects DTs that fail to
> > > describe a port using at least one of a phy-handle, a fixed-link, or
> > > a managed in-band link, and I don't think it needs to do further
> > > validation, certainly not for the phy describing properties that
> > > the kernel has chosen to deprecate for new implementations."
> > > 
> > > I had assumed you knew of_phy_is_fixed_link() returns true in this
> > > case. Do you now see that sja1105's validation is close enough
> > > (except for the legacy phy phandle properties which we don't care
> > > about),  
> > 
> > This is why your comment struck me as odd for mentioning managed in-band.
> > 
> > > and thus do we finally have agreement on this point?  
> > 
> > Yes we do.
> > 
> > > > On the other hand I found arm64/boot/dts/marvell/cn9130-crb.dtsi, where
> > > > the switch, a "marvell,mv88e6190"-compatible (can't determine going just
> > > > by that what it actually is) has this:
> > > > 
> > > > 			port@a {
> > > > 				reg = <10>;
> > > > 				label = "cpu";
> > > > 				ethernet = <&cp0_eth0>;
> > > > 			};  
> > > 
> > > Port 10 on 88E6393X supports 10GBASE-R, and maybe one day someone will
> > > get around to implementing USXGMII. This description relies upon this
> > > defaulting behaviour - as Andrew has described, this has been entirely
> > > normal behaviour with mv88e6xxx.
> > >   
> > > > To illustrate how odd the situation is, I am able to follow the phandle
> > > > to the CPU port and find a comment that it's a 88E6393X, and that the
> > > > CPU port uses managed = "in-band-status":
> > > > 
> > > > &cp0_eth0 {
> > > > 	/* This port is connected to 88E6393X switch */
> > > > 	status = "okay";
> > > > 	phy-mode = "10gbase-r";
> > > > 	managed = "in-band-status";
> > > > 	phys = <&cp0_comphy4 0>;
> > > > };  
> > > 
> > > 10GBASE-R has no in-band signalling per-se, so the only effect this has
> > > on the phylink instance on the CPU side is to read the status from the
> > > PCS as it does for any other in-band mode. In the case of 10GBASE-R, the
> > > only retrievable parameter is the link up/down status. This is no
> > > different from a 10GBASE-R based fibre link in that regard.  
> > 
> > Is there any formal definition for what managed = "in-band-status"
> > actually means? Is it context-specific depending on phy-mode?
> > In the case of SGMII, would it also mean that clause 37 exchange would
> > also take place (and its absence would mean it wouldn't), or does it
> > mean just that, that the driver should read the status from the PCS?
> > 
> > > A fixed link on the other hand would not read status from the PCS but
> > > would assume that the link is always up.
> > >   
> > > > Open question: is it sane to even do what we're trying here, to create a
> > > > fixed-link for port@a (which makes the phylink instance use MLO_AN_FIXED)
> > > > when &cp0_eth0 uses MLO_AN_INBAND? My simple mind thinks that if all
> > > > involved drivers were to behave correctly and not have bugs that cancel
> > > > out other bugs, the above device tree shouldn't work. The host port
> > > > would expect a clause 37 base page exchange to take place, the switch
> > > > wouldn't send any in-band information, and the SERDES lane would never
> > > > transition to data mode. To fix the above, we'd really need to chase the
> > > > "ethernet" phandle and attempt to mimic what the DSA master did. This is
> > > > indeed logic that never existed before, and I don't particularly feel
> > > > like adding it. How far do we want to go? It seems like never-ending
> > > > insanity the more I look at it.  
> > > 
> > > 10GBASE-R doesn't support clause 37 AN. 10GBASE-KR does support
> > > inband AN, but it's a different clause and different format.  
> > 
> > I thought it wouldn't, but then I was led to believe, after seeing it
> > here, that just the hardware I'm working with doesn't. How about
> > 2500base-x in Marvell, is there any base page exchange, or is this still
> > only about retrieving link status from the PCS?
> 
> Marvell documentation says that 2500base-x does not implement inband
> AN.
> 
> But when it was first implemented, for some reason it was thought that
> 2500base-x is just 1000base-x at 2.5x speed, and 1000base-x does
> support inband AN. Also it worked during tests for both switches and
> SOC NICs, so it was enabled.

It comes from Marvell NETA and PP2 documentation, which clearly states
that when a port is operating in 1000base-X mode, autonegotiation must
be enabled. It then implements 2500base-X by up-clocking the Serdes by
2.5x.

Therefore, to get 2500base-X using 1000base-X mode on these devices, it
follows that autonegotiation must be enabled. Since phylink's origins
are for these devices, and 2500base-X was not standardised at the time,
and there was no documentation online to describe what 2500base-X
actually was, a decision had to be made, and the logical thing to do
at that point was to support AN, especially as one can use it to
negotiate pause modes.

Note that NETA and PP2 have never supported half-duplex on 1G or 2.5G
speeds, so the clause 37 negotiation has only ever dealt with pause
modes, and again, it seemed logical and sensible at the time to allow
pause modes to still be negotiated at 2500base-X speed. Especially as
one can use FibreChannel SFPs to link two machines together using
2500base-X in the same way that you can link them together using
1000base-X.

Had manufacturers been more open with their documentation, and had they
used a common term, maybe this could have been different, but in an
information vacuum, decisions have to be made, even if they turn out to
be wrong later on - but we have to live with those consequences.

As I've stated before, I know I'm not alone in this - there are SFPs
that support 2500base-X (particularly GPON SFPs) that appear to expect
caluse 37 AN on 2500base-X, since the Armada 3700 uDPU product is
designed to work with them and it was a requirement to have a working
2.5G connection between the NETA interfaces and the GPON SFPs. And as
I say, NETA wants AN enabled.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
