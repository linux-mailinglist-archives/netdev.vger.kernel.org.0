Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE0857CE45
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 16:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbiGUOzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 10:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbiGUOzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 10:55:04 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9256833A03;
        Thu, 21 Jul 2022 07:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=GJms8OFun/ubSdkBaWHWcb6Ty10VDWQdCs1zZ9jGyhY=; b=ParruOU1TaiFmwxpDopn8iE5xb
        PBBbcYrjpVlwn8/FVBySJV502FPEyp/NYUw9Le2G7RykZqfBiIIkMaWfkFq6SdJZcGkSTZdWNUp7g
        SO3QpJuLGsK8HgR1NpQdw11aC8U8M3NxghRuKsmxOGrFwUa9+mY9EpYdIHTzk5dXtwA51EJKJSRpD
        /tAT7222u0J0iuqxN1V56C1GmZrVv+R55s8+dorCMehGUnm3qGB9/EnrWSinar/7FStRgcmo3qH30
        LfG23A69SH9pO29kFTPie/EX7YCWBGwzMTh1JeY4Wse3ICJkM7kH/OMzNqEj49NbiUCporkPgowCA
        bF2R2EfA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33480)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oEXZF-0005Xd-9J; Thu, 21 Jul 2022 15:54:21 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oEXZ9-0004wJ-7C; Thu, 21 Jul 2022 15:54:15 +0100
Date:   Thu, 21 Jul 2022 15:54:15 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
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
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH net-next 3/6] net: dsa: add support for retrieving the
 interface mode
Message-ID: <Ytlol8ApI6O2wy99@shell.armlinux.org.uk>
References: <20220715172444.yins4kb2b6b35aql@skbuf>
 <YtHcpf4otJQS9hTO@shell.armlinux.org.uk>
 <20220715222348.okmeyd55o5u3gkyi@skbuf>
 <YtHw0O5NB6kGkdwV@shell.armlinux.org.uk>
 <20220716105711.bjsh763smf6bfjy2@skbuf>
 <YtKdcxupT+INVAhR@shell.armlinux.org.uk>
 <20220716123608.chdzbvpinso546oh@skbuf>
 <YtUec3GTWTC59sky@shell.armlinux.org.uk>
 <20220720224447.ygoto4av7odsy2tj@skbuf>
 <20220721134618.axq3hmtckrumpoy6@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721134618.axq3hmtckrumpoy6@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 04:46:18PM +0300, Vladimir Oltean wrote:
> On Thu, Jul 21, 2022 at 01:44:47AM +0300, Vladimir Oltean wrote:
> > I really wish there was a ready-made helper for validating phylink's
> > OF node; I mentioned this already, it needs to cater for all of
> > fixed-link/phy-handle/managed/sfp.
> 
> While I was going to expand on this point and state that DSA doesn't
> currently instantiate phylink for this OF node:
> 
> 			port@9 {
> 				reg = <0x9>;
> 				label = "cpu";
> 				ethernet = <&eth1>;
> 				phy-mode = "2500base-x";
> 				managed = "in-band-status";
> 			};
> 
> I was proven wrong. Today I learned that of_phy_is_fixed_link() returns
> true if the "managed" property exists and its value differs from "auto".
> So in the above case, of_phy_is_fixed_link() returns true, hmmm.

Yes, which is why I said on July 7th:

"So I also don't see a problem - sja1105 rejects DTs that fail to
describe a port using at least one of a phy-handle, a fixed-link, or
a managed in-band link, and I don't think it needs to do further
validation, certainly not for the phy describing properties that
the kernel has chosen to deprecate for new implementations."

I had assumed you knew of_phy_is_fixed_link() returns true in this
case. Do you now see that sja1105's validation is close enough
(except for the legacy phy phandle properties which we don't care
about), and thus do we finally have agreement on this point?

> On the other hand I found arm64/boot/dts/marvell/cn9130-crb.dtsi, where
> the switch, a "marvell,mv88e6190"-compatible (can't determine going just
> by that what it actually is) has this:
> 
> 			port@a {
> 				reg = <10>;
> 				label = "cpu";
> 				ethernet = <&cp0_eth0>;
> 			};

Port 10 on 88E6393X supports 10GBASE-R, and maybe one day someone will
get around to implementing USXGMII. This description relies upon this
defaulting behaviour - as Andrew has described, this has been entirely
normal behaviour with mv88e6xxx.

> To illustrate how odd the situation is, I am able to follow the phandle
> to the CPU port and find a comment that it's a 88E6393X, and that the
> CPU port uses managed = "in-band-status":
> 
> &cp0_eth0 {
> 	/* This port is connected to 88E6393X switch */
> 	status = "okay";
> 	phy-mode = "10gbase-r";
> 	managed = "in-band-status";
> 	phys = <&cp0_comphy4 0>;
> };

10GBASE-R has no in-band signalling per-se, so the only effect this has
on the phylink instance on the CPU side is to read the status from the
PCS as it does for any other in-band mode. In the case of 10GBASE-R, the
only retrievable parameter is the link up/down status. This is no
different from a 10GBASE-R based fibre link in that regard.

A fixed link on the other hand would not read status from the PCS but
would assume that the link is always up.

> Open question: is it sane to even do what we're trying here, to create a
> fixed-link for port@a (which makes the phylink instance use MLO_AN_FIXED)
> when &cp0_eth0 uses MLO_AN_INBAND? My simple mind thinks that if all
> involved drivers were to behave correctly and not have bugs that cancel
> out other bugs, the above device tree shouldn't work. The host port
> would expect a clause 37 base page exchange to take place, the switch
> wouldn't send any in-band information, and the SERDES lane would never
> transition to data mode. To fix the above, we'd really need to chase the
> "ethernet" phandle and attempt to mimic what the DSA master did. This is
> indeed logic that never existed before, and I don't particularly feel
> like adding it. How far do we want to go? It seems like never-ending
> insanity the more I look at it.

10GBASE-R doesn't support clause 37 AN. 10GBASE-KR does support
inband AN, but it's a different clause and different format.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
