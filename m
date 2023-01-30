Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5994F680D5C
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 13:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235986AbjA3MP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 07:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235983AbjA3MPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 07:15:52 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786B16A40;
        Mon, 30 Jan 2023 04:15:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=C7IOc72up1/qGVK6PFZ7MoYJGV/hPDPtb8x3M4R+iU8=; b=jsXIAuAkLAbiVgS5r7/l57QsBC
        sFfYkRyJgEfhLnqA2ujwKWVqsiCHZ/zNdE2/2GwTMWc1px5tgsZl60WLCkUJ3XU4cFdUwp6zOaCku
        4cQUxEnRZ6EbAE8qeFKaQEfJr/V/hQUig3RK0+qh8INvlzeBaiVEWyk5j8tC0VcJjkkFfOEu8oymt
        qRiYrrTNg7WnJsytKy6P2kbU/g4dEJSb/OZTiW5SfhGk6Cn9s8hYZi39ClzUR56s/DUQSiFDC95w3
        IF8Hfpo6UpX/H+6mliWvHXnvpynCS335zBbNH2rNYSUuiIUOlJziDBS10CrqQpPNFy64IeqiYgBO1
        ga57mYcQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36356)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pMT4S-00036H-GZ; Mon, 30 Jan 2023 12:15:36 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pMT4P-00037k-G4; Mon, 30 Jan 2023 12:15:33 +0000
Date:   Mon, 30 Jan 2023 12:15:33 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH net-next v4 4/4] net: ethernet: renesas: rswitch: Add
 phy_power_{on,off}() calling
Message-ID: <Y9e05RJWrzFO7z4T@shell.armlinux.org.uk>
References: <20230127142621.1761278-1-yoshihiro.shimoda.uh@renesas.com>
 <20230127142621.1761278-5-yoshihiro.shimoda.uh@renesas.com>
 <Y9PrDPPbtIClVtB4@shell.armlinux.org.uk>
 <TYBPR01MB534129FDE16A6DB654486671D8D39@TYBPR01MB5341.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYBPR01MB534129FDE16A6DB654486671D8D39@TYBPR01MB5341.jpnprd01.prod.outlook.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 05:52:15AM +0000, Yoshihiro Shimoda wrote:
> Hi Russell,
> 
> > From: Russell King, Sent: Saturday, January 28, 2023 12:18 AM
> > 
> > On Fri, Jan 27, 2023 at 11:26:21PM +0900, Yoshihiro Shimoda wrote:
> > > Some Ethernet PHYs (like marvell10g) will decide the host interface
> > > mode by the media-side speed. So, the rswitch driver needs to
> > > initialize one of the Ethernet SERDES (r8a779f0-eth-serdes) ports
> > > after linked the Ethernet PHY up. The r8a779f0-eth-serdes driver has
> > > .init() for initializing all ports and .power_on() for initializing
> > > each port. So, add phy_power_{on,off} calling for it.
> > 
> > So how does this work?
> 
> This hardware has MDIO interfaces, and the MDIO can communicate the Ethernet
> PHY without the Ethernet SERDES initialization. And, the Ethernet PHY can be
> initialized, and media-side of the PHY works. So, this works.

Ethernet PHYs can generally be communicated with irrespective of the
serdes state, so that isn't the concern.

What I'm trying to grasp is your decision making behind putting the
serdes phy power control in the link_up/link_down functions, when
doing so is fundamentally problematical if in-band mode is ever
supported - and in-band mode has to be supported for things like
fibre connections to work.

> > 88x3310 can change it's MAC facing interface according to the speed
> > negotiated on the media side, or it can use rate adaption mode, but
> > if it's not a MACSEC device, the MAC must pace its transmission
> > rate to that of the media side link.
> 
> My platform has 88x2110 so that it's not a MACSEC device.

... which supports USXGMII, 10GBaseR, 5GBaseR, 2500BaseX and SGMII,
possibly with rate adaption, and if it's not a MACSEC device, that
rate adaption will likely require the MAC side to pace its
transmission to the media speed.

> > The former requires one to reconfigure the interface mode in
> > mac_config(), which I don't see happening in this patch set.
> 
> You're correct. This patch set doesn't have such reconfiguration
> because this driver doesn't support such a feature (for now).

Is this planned? When are we likely to see this code?

> > The latter requires some kind of configuration in mac_link_up()
> > which I also don't see happening in this patch set.
> 
> You're correct. This patch set doesn't have such configuration
> in mac_link_up() because this hardware cannot change speed at
> runtime (for now).

the hardware can't even change between the various SGMII speeds? What
kind of utterly crippled hardware implementation is this? You make it
sound like the hardware designers don't have a clue what they're doing.

> > So, I doubt this works properly.
> > 
> > Also, I can't see any sign of any working DT configuration for this
> > switch to even be able to review a use case - all there is in net-next
> > is the basic description of the rswitch in a .dtsi and no users. It
> > may be helpful if there was some visibility of its use, and why
> > phylink is being used in this driver - because right now with phylink's
> > MAC methods stubbed out in the way they are, and even after this patch
> > set, I see little point to this driver using phylink.
> 
> In the latest net-next, r8a779f0-spider.dts is a user.
> 
> In r8a779f0-spider-ether.dtsi:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/arch/arm64/boot/dts/renesas/r8a779f0-spider-ethernet.dtsi#n41
> 
> In r8a779f0-spider.dts:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/arch/arm64/boot/dts/renesas/r8a779f0-spider.dts#n10

So these configure the ports with PHYs on to use SGMII mode. No mention
of any speed, yet you say that's configured at probe time? Do you just
set them to 1G, and hope that the media side link negotiates to 1G
speeds?

That doesn't sound like a good idea to me.

> > Moreover, looking at the binding document, you don't even support SFPs
> > or fixed link, which are really the two reasons to use phylink over
> > phylib.
> 
> You're correct. This hardware doesn't support SFPs or fixed link.
> 
> I sent a patch at the first, I had used phylib and had added a new function
> for setting the phy_dev->host_interfaces [1]. And then, Marek suggested
> that I should use phylink instead of phylib. That's why this driver
> is using phylink even if this doesn't support SFPs and fixed link.
> 
`> [1]
> https://lore.kernel.org/netdev/20221019124100.41c9bbaf@dellmb/

[Adding Marek to the Cc]

I'm afraid I don't agree with Marek given the state of this driver.
His assertion is "there's an API for doing this" which is demonstrably
false. If his assertion were true, then you wouldn't need to add the
code to phylink to set phydev->host_interfaces for on-board PHYs.

I'm not particularly happy about adding that to phylink, and now that
I read your current rather poor implementation of phylink, I'm even
less happy about it.

> > Also, phylink only really makes sense if the methods in its _ops
> > structures actually do something useful, because without that there
> > can be no dynamic configuration of the system to suit what is
> > connected.
> 
> I think so. This rswitch doesn't need dynamic configuration,
> but Marvell 88x2110 on my platform needs dynamic configuration.
> That's why this driver uses phylink.

Given that you use the 88x2110, and you've set the phy-mode to
SGMII, it should support 10M, 100M and 1G speeds on the media
side. Please test - and if not, I think the code which supports
that should at the very least be part of this patch set - so we
begin to see a proper implementation in the mac_* ops.

The reason for this is I utterly detest shoddy users of phylink, and
I will ask people not to use phylink if they aren't prepared to
implement it properly - because shoddy phylink users add greatly to
my maintenance workload.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
