Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 677EC57D25F
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 19:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiGURWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 13:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiGURWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 13:22:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B24B2DAAB;
        Thu, 21 Jul 2022 10:21:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9641561ED6;
        Thu, 21 Jul 2022 17:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBDBC341CE;
        Thu, 21 Jul 2022 17:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658424116;
        bh=U0B5LjvmQxLng/mwn3ADiMYfRaUDQEHObvhPDEeFM08=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DhldqkYWs/ADwWTfbvpzDfYyVqvLLv+Q2Ipo+/1dU+k2Zt9tOLQ8Aud5vf4jnKa+f
         9Rcv/ZKm8i+SCCHkv16z90qJwlEzffVL2ziPIfsg6IcdtJcyzJuR41vN0yEWC/qKVZ
         mr6uqO5pRWjIDmS1FJ/pm5u2zWJ1VlAceCMyIQnExfo+z2I/z49QnefGsmzU5OWDK4
         99I0/je8ojwplnjkTi+6R3XuKcEQC4y9xzjSKCLp8HzV6qpCR7fTia3UaHyCJQJ29K
         EIMIRgHvRNu5fc5kS7/4wGh9xf1AzfQ7HMl/YTXF+2VGhBgE4/kiSqeZ+n+NQHf6Si
         y/JxgStm8X4Sw==
Date:   Thu, 21 Jul 2022 19:21:45 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
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
Message-ID: <20220721192145.1f327b2a@dellmb>
In-Reply-To: <20220721151533.3zomvnfogshk5ze3@skbuf>
References: <YtHcpf4otJQS9hTO@shell.armlinux.org.uk>
        <20220715222348.okmeyd55o5u3gkyi@skbuf>
        <YtHw0O5NB6kGkdwV@shell.armlinux.org.uk>
        <20220716105711.bjsh763smf6bfjy2@skbuf>
        <YtKdcxupT+INVAhR@shell.armlinux.org.uk>
        <20220716123608.chdzbvpinso546oh@skbuf>
        <YtUec3GTWTC59sky@shell.armlinux.org.uk>
        <20220720224447.ygoto4av7odsy2tj@skbuf>
        <20220721134618.axq3hmtckrumpoy6@skbuf>
        <Ytlol8ApI6O2wy99@shell.armlinux.org.uk>
        <20220721151533.3zomvnfogshk5ze3@skbuf>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jul 2022 18:15:33 +0300
Vladimir Oltean <olteanv@gmail.com> wrote:

> On Thu, Jul 21, 2022 at 03:54:15PM +0100, Russell King (Oracle) wrote:
> > Yes, which is why I said on July 7th:
> > 
> > "So I also don't see a problem - sja1105 rejects DTs that fail to
> > describe a port using at least one of a phy-handle, a fixed-link, or
> > a managed in-band link, and I don't think it needs to do further
> > validation, certainly not for the phy describing properties that
> > the kernel has chosen to deprecate for new implementations."
> > 
> > I had assumed you knew of_phy_is_fixed_link() returns true in this
> > case. Do you now see that sja1105's validation is close enough
> > (except for the legacy phy phandle properties which we don't care
> > about),  
> 
> This is why your comment struck me as odd for mentioning managed in-band.
> 
> > and thus do we finally have agreement on this point?  
> 
> Yes we do.
> 
> > > On the other hand I found arm64/boot/dts/marvell/cn9130-crb.dtsi, where
> > > the switch, a "marvell,mv88e6190"-compatible (can't determine going just
> > > by that what it actually is) has this:
> > > 
> > > 			port@a {
> > > 				reg = <10>;
> > > 				label = "cpu";
> > > 				ethernet = <&cp0_eth0>;
> > > 			};  
> > 
> > Port 10 on 88E6393X supports 10GBASE-R, and maybe one day someone will
> > get around to implementing USXGMII. This description relies upon this
> > defaulting behaviour - as Andrew has described, this has been entirely
> > normal behaviour with mv88e6xxx.
> >   
> > > To illustrate how odd the situation is, I am able to follow the phandle
> > > to the CPU port and find a comment that it's a 88E6393X, and that the
> > > CPU port uses managed = "in-band-status":
> > > 
> > > &cp0_eth0 {
> > > 	/* This port is connected to 88E6393X switch */
> > > 	status = "okay";
> > > 	phy-mode = "10gbase-r";
> > > 	managed = "in-band-status";
> > > 	phys = <&cp0_comphy4 0>;
> > > };  
> > 
> > 10GBASE-R has no in-band signalling per-se, so the only effect this has
> > on the phylink instance on the CPU side is to read the status from the
> > PCS as it does for any other in-band mode. In the case of 10GBASE-R, the
> > only retrievable parameter is the link up/down status. This is no
> > different from a 10GBASE-R based fibre link in that regard.  
> 
> Is there any formal definition for what managed = "in-band-status"
> actually means? Is it context-specific depending on phy-mode?
> In the case of SGMII, would it also mean that clause 37 exchange would
> also take place (and its absence would mean it wouldn't), or does it
> mean just that, that the driver should read the status from the PCS?
> 
> > A fixed link on the other hand would not read status from the PCS but
> > would assume that the link is always up.
> >   
> > > Open question: is it sane to even do what we're trying here, to create a
> > > fixed-link for port@a (which makes the phylink instance use MLO_AN_FIXED)
> > > when &cp0_eth0 uses MLO_AN_INBAND? My simple mind thinks that if all
> > > involved drivers were to behave correctly and not have bugs that cancel
> > > out other bugs, the above device tree shouldn't work. The host port
> > > would expect a clause 37 base page exchange to take place, the switch
> > > wouldn't send any in-band information, and the SERDES lane would never
> > > transition to data mode. To fix the above, we'd really need to chase the
> > > "ethernet" phandle and attempt to mimic what the DSA master did. This is
> > > indeed logic that never existed before, and I don't particularly feel
> > > like adding it. How far do we want to go? It seems like never-ending
> > > insanity the more I look at it.  
> > 
> > 10GBASE-R doesn't support clause 37 AN. 10GBASE-KR does support
> > inband AN, but it's a different clause and different format.  
> 
> I thought it wouldn't, but then I was led to believe, after seeing it
> here, that just the hardware I'm working with doesn't. How about
> 2500base-x in Marvell, is there any base page exchange, or is this still
> only about retrieving link status from the PCS?

Marvell documentation says that 2500base-x does not implement inband
AN.

But when it was first implemented, for some reason it was thought that
2500base-x is just 1000base-x at 2.5x speed, and 1000base-x does
support inband AN. Also it worked during tests for both switches and
SOC NICs, so it was enabled.

At the time 2500base-x was not standardized. Now 2500base-x is
stanradrized, and the standard says that 2500base-x does not support
clause 37 AN. I guess this is because where it is used, it is intended
to work with clause 73 AN somehow.

And then came 6373X switch, which didn't support clause 37 inband AN in
2500base-x mode (the AN reigster returned 0xffff or something when
2500base-x CMODE was set). Maybe 6373X finally supports clause 73 AN
(I don't know, but I don't think so) and that is the reason they now
forbid clause 37 AN in HW in 2500base-x.

But the problem is that by this time there is software out there then
expects 2500base-x to have clause 37 AN enabled. Indeed a passive SFP
cable did not work between MOX' SFP port and CN9130-CRB's SFP port
when used with Peridot (6190), if C37 AN was disabled on 6393x and left
enabled on Peridot.

I managed to work out how to enable C37 AN on 6393x:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=163000dbc772c1eae9bdfe7c8fe30155db1efd74

So currently we try to enable C37 AN in 2500base-x mode, although
the standard says that it shouldn't be there, and it shouldn't be there
presumably because they want it to work with C73 AN.

I don't know how to solve this issue. Maybe declare a new PHY interface
mode constant, 2500base-x-no-c37-an ?

:)

Marek
