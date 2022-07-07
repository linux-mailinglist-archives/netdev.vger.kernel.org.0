Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A3956ACA5
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 22:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236501AbiGGUYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 16:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236490AbiGGUYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 16:24:12 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5960F237F1
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 13:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=PD22TGCCsABJm2qKs+DYKyvw+YQ8I3vKEf5j/ZatNso=; b=Iy4IvCjI7hmla+Qm6hPIe6Cmzn
        OKYb/4mzecFrJoK8/sDKfmBlakRkUrVgkxHbXYMXUzeXUHAOmZFZCY6oGkOly3ljSkCIu/obEYdqP
        qUz6HzkpCRarIoQMdF5wUqsrQjZmyVRNHCJtKttSAedS3OK9AYlRvVDlKJyca44egc+G5NGHewUnf
        2yRiCwwlFpiXAcU8vtiblvwC5r6mmoM2fNHEACaciRY4wnod0140cjFS1u4teUDhwgHzrzxFnxxXk
        zdHsQl7C7oCNqc4FYI/rS7QZDrIsNFFy3Inul5h+58Wfx8JYxe1jK8PPPE0/7uPvkk1qkBG9fGGZE
        NUI76uKA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33244)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o9Y2T-0004KL-G2; Thu, 07 Jul 2022 21:23:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o9Y2M-0005ZU-Pr; Thu, 07 Jul 2022 21:23:46 +0100
Date:   Thu, 7 Jul 2022 21:23:46 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [PATCH RFC net-next 5/5] net: dsa: always use phylink for CPU
 and DSA ports
Message-ID: <YsdA0jcRCzR0c728@shell.armlinux.org.uk>
References: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
 <E1o8fA7-0059aO-K8@rmk-PC.armlinux.org.uk>
 <20220706102621.hfubvn3wa6wlw735@skbuf>
 <YsW3KSeeQBiWQOz/@shell.armlinux.org.uk>
 <Ysaw56lKTtKMh84b@shell.armlinux.org.uk>
 <20220707152727.foxrd4gvqg3zb6il@skbuf>
 <YscAPP7mF3KEE1/p@shell.armlinux.org.uk>
 <20220707163831.cjj54a6ys5bceb22@skbuf>
 <YscUwrPnBZ3dzpQ/@shell.armlinux.org.uk>
 <20220707193753.2j67ni3or3bfkt6k@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707193753.2j67ni3or3bfkt6k@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 07, 2022 at 10:37:53PM +0300, Vladimir Oltean wrote:
> On Thu, Jul 07, 2022 at 06:15:46PM +0100, Russell King (Oracle) wrote:
> > > This is why dsa_port_phylink_register() calls phylink_of_phy_connect()
> > > without checking whether it has a fixed-link or a PHY, because it
> > > doesn't fail even if it doesn't do anything.
> > > 
> > > In fact I've wanted to make a correction to my previous phrasing that
> > > "this function shouldn't be called if phylink_{,fwnode_}connect_phy() is
> > > going to be called later". The correction is "... with a phy-handle".
> > 
> > I'm not sure that clarification makes sense when talking about
> > phylink_connect_phy(), so I think if you're clarifying it with a
> > firmware property, you're only talking about
> > phylink_fwnode_connect_phy() now?
> 
> Yes, it's super hard to verbalize, and this is the reason why I didn't
> add "... with a phy-handle" in the first place.
> 
> I wanted to say: phylink_connect_phy(), OR phylink_fwnode_connect_phy()
> WITH a phy-handle. I shouldn't have conflated them in the first place.

Ah, right, because I interpreted it quite differently!

> > > > > Can phylink absorb all this logic, and automatically call phylink_set_max_fixed_link()
> > > > > based on the following?
> > > > > 
> > > > > (1) struct phylink_config gets extended with a bool fallback_max_fixed_link.
> > > > > (2) DSA CPU and DSA ports set this to true in dsa_port_phylink_register().
> > > > > (3) phylink_set_max_fixed_link() is hooked into this -ENODEV error
> > > > >     condition from phylink_fwnode_phy_connect():
> > > > > 
> > > > > 	phy_fwnode = fwnode_get_phy_node(fwnode);
> > > > > 	if (IS_ERR(phy_fwnode)) {
> > > > > 		if (pl->cfg_link_an_mode == MLO_AN_PHY)
> > > > > 			return -ENODEV; <- here
> > > > > 		return 0;
> > > > > 	}
> > > > 
> > > > My question in response would be - why should this DSA specific behaviour
> > > > be handled completely internally within phylink, when it's a DSA
> > > > specific behaviour? Why do we need boolean flags for this?
> > > 
> > > Because the end result will be simpler if we respect the separation of
> > > concerns that continues to exist, and it's still phylink's business to
> > > say what is and isn't valid. DSA still isn't aware of the bindings
> > > required by phylink, it just passes its fwnode to it. Practically
> > > speaking, I wouldn't be scratching my head as to why we're checking for
> > > half the prerequisites of phylink_set_max_fixed_link() in one place and
> > > for the other half in another.
> > > 
> > > True, through this patch set DSA is creating its own context specific
> > > extension of phylink bindings, but arguably those existed before DSA was
> > > even integrated with phylink, and we're just fixing something now we
> > > didn't realize at the time we'd need to do.
> > > 
> > > I can reverse the question, why would phylink even want to be involved
> > > in how the max fixed link parameters are deduced, and it doesn't just
> > > require that a fixed-link software node is constructed somehow
> > > (irrelevant to phylink how), and phylink is just modified to find and
> > > work with that if it exists? Isn't it for the exact same reason,
> > > separation of concerns, that it's easiest for phylink to figure out what
> > > is the most appropriate maximum fixed-link configuration?
> > 
> > If that could be done, I'd love it, because then we don't have this in
> > phylink at all, and it can all be a DSA problem to solve. It also means
> > that others won't be tempted to use the interface incorrectly.
> > 
> > I'm not sure how practical that is when we have both DT and ACPI to deal
> > with, and ACPI is certainly out of my knowledge area to be able to
> > construct a software node to specify a fixed-link. Maybe it can be done
> > at the fwnode layer? I don't know.
> 
> I don't want to be misunderstood. I brought up software nodes because
> I'm sure you must have thought about this too, before proposing what you
> did here. And unless there's a technical reason against software nodes
> (which there doesn't appear to be, but I don't want to get ahead of
> myself), I figured you must be OK with phylink absorbing the logic, case
> in which I just don't understand why you are pushing back on a proposal
> how to make phylink absorb the logic completely.

The reason I hadn't is because switching DSA to fwnode brings with it
issues for ACPI, and Andrew wants to be very careful about ACPI in
networking - and I think quite rightly. As soon as one switches from
DT APIs to fwnode APIs, you basically permit people an easy path to
re-use DT properties in ACPI-land without the ACPI issues being first
considered.

So, I think if we did go this route, we need Andrew's input.

> > Do you have a handy example of what you're suggesting?
> 
> No, I didn't, but I thought, how hard can it be, and here's a hacked up
> attempt on one of my boards:

Thanks - that looks like something that should be possible to do, and
way better than trying to shoe-horn this into phylink.

My only comment would be that Andrew would disagree with you about this
being "fixing up broken DT" - he has actively encouraged some drivers
to adopt this "default" mode, which means it's anything but "broken"
but it really is part of the DSA firmware description.

> [    4.315754] sja1105 spi0.1: configuring for fixed/rgmii link mode
> [    4.322653] sja1105 spi0.1 swp5 (uninitialized): PHY [mdio@2d24000:06] driver [Broadcom BCM5464] (irq=POLL)
> [    4.334796] sja1105 spi0.1 swp2 (uninitialized): PHY [mdio@2d24000:03] driver [Broadcom BCM5464] (irq=POLL)
> [    4.345853] sja1105 spi0.1 swp3 (uninitialized): PHY [mdio@2d24000:04] driver [Broadcom BCM5464] (irq=POLL)
> [    4.356859] sja1105 spi0.1 swp4 (uninitialized): PHY [mdio@2d24000:05] driver [Broadcom BCM5464] (irq=POLL)
> [    4.367245] device eth2 entered promiscuous mode
> [    4.371864] DSA: tree 0 setup
> [    4.376971] sja1105 spi0.1: Link is Up - 1Gbps/Full - flow control off
> (...)
> root@black:~# ip link set swp2 up && dhclient -i swp2 && ip addr show swp2
> [   64.762756] fsl-gianfar soc:ethernet@2d90000 eth2: Link is Up - 1Gbps/Full - flow control off
> [   64.771530] sja1105 spi0.1 swp2: configuring for phy/rgmii-id link mode
> [   68.955048] sja1105 spi0.1 swp2: Link is Up - 1Gbps/Full - flow control off
> 12: swp2@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
>     link/ether 00:1f:7b:63:02:48 brd ff:ff:ff:ff:ff:ff
>     inet 10.0.0.68/24 brd 10.0.0.255 scope global dynamic swp2
>        valid_lft 600sec preferred_lft 600sec
> 
> It's by far the messiest patch I've posted to the list (in the interest
> of responding quickly), but if you study the code you can obviously see
> what's missing, basically I've hardcoded the speed to 1000 and I'm
> copying the phy-mode from the real DT node.

Yep - there's at least one other property we need to carry over from the
DT node, which is the "ethernet" property.

> Unfortunately I don't have the time (and most importantly the interest)
> in pushing this any further than that. If you want to take this from
> here and integrate it with phylink_get_caps() I'd be glad to review
> the result. Otherwise, feel free to continue with phylink_set_max_fixed_link().

I think this could be a much better solution to this problem, quite
simply because we then don't end up with phylink_set_max_fixed_link()
which could be abused - and this keeps the complexity where it should
be, in the DSA code.

As I say, though, I think we need Andrew's input on this. Andrew?

I'll look at turning this into a proper solution tomorrow if Andrew is
okay with the fwnode change.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
