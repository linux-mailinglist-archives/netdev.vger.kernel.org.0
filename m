Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620C16284BE
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 17:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235602AbiKNQNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 11:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237390AbiKNQNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 11:13:35 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F02F17A8B
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 08:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=a0ILLT5WBLRd1lom4q80IO2+88jbTpnqG+ctAIo2NBs=; b=gCntbFqugGGbwHmvLvNYjn8gx6
        3Cl9AvR1JiitKGgbPVRXwa8IvwEhuaXABC0EVDvON33brxplWb4pMl/57tWTMbSWYsoifCE7679MS
        mWE/GgSCFDNckLQg5NuGCL+DTcYdXk9NeKv9fl6Ys5YRpHDRFP3eKbsuC6Z5a/XQQ6/V8kV801/Ab
        XUS4AV8TF4fzsUFRq36vF4HSxPWVspZXU+XvYFZdGCPGryhisNkvvtsyvJULd1g7moQdMLxJ1Y4xZ
        FPc98eOacWrDk7nGwREZCuoIFI2K8iaGK7eRpSCyXiQzjyHrX+ddtPvkWj9Ew5c78PA0AOCM0JYwH
        YY7on+FA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35262)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ouc5O-000147-MM; Mon, 14 Nov 2022 16:13:26 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ouc5M-0003wF-Fo; Mon, 14 Nov 2022 16:13:24 +0000
Date:   Mon, 14 Nov 2022 16:13:24 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Tim Harvey <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: status of rate adaptation
Message-ID: <Y3JpJDvCdI21yb5v@shell.armlinux.org.uk>
References: <CAJ+vNU3zeNqiGhjTKE8jRjDYR0D7f=iqPLB8phNyA2CWixy7JA@mail.gmail.com>
 <b37de72c-0b5d-7030-a411-6f150d86f2dd@seco.com>
 <2a1590b2-fa9a-f2bf-0ef7-97659244fa9b@seco.com>
 <CAJ+vNU2jc4NefB-kJ0LRtP=ppAXEgoqjofobjbazso7cT2w7PA@mail.gmail.com>
 <b7f31077-c72d-5cd4-30d7-e3e58bb63059@seco.com>
 <Y2+cgh4NBQq8EHoX@shell.armlinux.org.uk>
 <ea320070-a949-c737-22c4-14fd199fdc23@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea320070-a949-c737-22c4-14fd199fdc23@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 10:33:52AM -0500, Sean Anderson wrote:
> On 11/12/22 08:15, Russell King (Oracle) wrote:
> > On Fri, Nov 11, 2022 at 04:54:40PM -0500, Sean Anderson wrote:
> >> > [    8.911932] mvpp2 f2000000.ethernet eth0: PHY
> >> > [f212a600.mdio-mii:08] driver [Aquantia AQR113C] (irq=POLL)
> >> > [    8.921577] mvpp2 f2000000.ethernet eth0: phy: 10gbase-r setting
> >> > supported 00000000,00018000,000e706f advertising
> >> > 00000000,00018000,000e706f
> > 
> >> > # ethtool eth0
> >> > Settings for eth0:
> >> >         Supported ports: [ ]
> >> >         Supported link modes:   10baseT/Half 10baseT/Full
> >> >                                 100baseT/Half 100baseT/Full
> >> 
> >> 10/100 half duplex aren't achievable with rate matching (and we avoid
> >> turning them on), so they must be coming from somewhere else. I wonder
> >> if this is because PHY_INTERFACE_MODE_SGMII is set in
> >> supported_interfaces.
> > 
> > The reason is due to the way phylink_bringup_phy() works. This is
> > being called with interface = 10GBASE-R, and the PHY is a C45 PHY,
> > which means we call phy_get_rate_matching() with 
> > PHY_INTERFACE_MODE_NA as we don't know whether the PHY will be
> > switching its interface or not.
> > 
> > Looking at the Aquanta PHY driver, this will return that pause mode
> > rate matching will be used, so config.rate_matching will be
> > RATE_MATCH_PAUSE.
> > 
> > phylink_validate() will be called for PHY_INTERFACE_MODE_NA, which
> > causes it to scan all supported interface modes (as again, we don't
> > know which will be used by the PHY [*]) and the union of those
> > results will be used.
> > 
> > So when we e.g. try SGMII mode, caps & mac_capabilities will allow
> > the half duplex modes through.
> > 
> > Now for the bit marked with [*] - at this point, if rate matching is
> > will be used, we in fact know which interface mode is going to be in
> > operation, and it isn't going to change. So maybe we need this instead
> > in phylink_bringup_phy():
> > 
> > -	if (phy->is_c45 &&
> > +	config.rate_matching = phy_get_rate_matching(phy, interface);
> > +	if (phy->is_c45 && config.rate_matching == RATE_MATCH_NONE &&
> >             interface != PHY_INTERFACE_MODE_RXAUI &&
> >             interface != PHY_INTERFACE_MODE_XAUI &&
> >             interface != PHY_INTERFACE_MODE_USXGMII)
> >                 config.interface = PHY_INTERFACE_MODE_NA;
> >         else
> >                 config.interface = interface;
> > -	config.rate_matching = phy_get_rate_matching(phy, config.interface);
> > 
> >         ret = phylink_validate(pl, supported, &config);
> > 
> > ?
> 
> Yeah, that sounds reasonable. Actually, this was the logic I was
> thinking of when I asked Tim to try USXGMII earlier. The funny thing is
> that the comment above this implies that the link mode is never actually
> (R)XAUI or USXGMII.

I think you're misunderstanding the comment...

If a clause 45 PHY is using USXGMII, then it is highly likely that the
PHY will not switch between different interface modes depending on the
media side negotiation.

If a clause 45 PHY is using RXAUI or XAUI, then I believe according to
the information available to me at the time, that there is no
possibility of different interface modes being used.

If any other interface type is specified (e.g. 10GBASE-R etc) then there
is the possibility that the PHY will be switching between different
interface modes, and we have no idea what so ever at this point what
modes the PHY will be making use of - so the best we can do is to
validate _all_ possible modes. This is what is done by setting the
interface mode to _NA.

Obviously, if we are using rate matching with a particular interface
mode (e.g. 10GBASE-R) then we know that we are only going to be using
10GBASE-R, so we can validate just the single interface mode.

> On another subject, if setting the SERDES mode field above fixes the
> issue, then the Aquantia driver should be modified to set that field to
> use a supported interface. Will host_interfaces work for this? It seems
> to be set only when there's an SFP module.

The reason I didn't push host_interfaces upstream myself is that I was
unconvinced that it was the proper approach - and I still have my
reservations with it. This can only tell the PHY driver what the MAC
driver supports, and it means the PHY driver is then free to do its
own choosing of what group of interface modes it wants to use.

However, think about what I've said above about phylink not having any
clue about what interface modes the PHY is going to be using - having
the PHY driver decide on its own which group of interface modes should
be used adds even more complexity in a completely different chunk of
code, one where driver authors are free to make whatever decisions
they deem (and we know that wildly different solutions will happen.)

I had been toying with the idea of doing this differently, and had
dropped most of the host_interfaces approach from my git tree, instead
having PHYs provide a bitmap of the interface modes they support and
having them initialise in their config_init function which interface
modes they're going to be making use of given their resulting
configuration. I never properly finished this though.

> That said, imagine if Tim was using a MAC without pause support, but
> which supported SGMII and 10GBASE-R. Currently, we would just advertise
> 10G modes. But 1G could be supported by switching the phy interface.

Note that we already have boards that make use of interface switching.
Macchiatobin has switched between 10GBASE-R, 5GBASE-R, 2500BASE-X and
SGMII depending on the negotiated media speed. In fact, that switching
is rather enforced by the 3310 PHY firmware.

We could force 10GBASE-R and enable rate matching, but then we get
into the problems that the 3310 on these boards does not have MACSEC
therefore can't send pause frames to the host MAC (and the host MAC
doesn't support pause frames - eek) and we have not come up with an
implementation for extending the IPG, although I believe mvpp2
hardware is capable of it.

However, there's also the BCM84881 PHY which does the same dynamic
switching which we can't prevent (we don't know how to!)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
