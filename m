Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E0E576D6E
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 13:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiGPLOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 07:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiGPLOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 07:14:49 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A7011803;
        Sat, 16 Jul 2022 04:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XzMT14sUU2E655PYspLy4XNG8Jmc0tDfi5jTkVcr5qA=; b=j/PxaB3Iq9cfiMfg+sWGsxUq/c
        eOYREffgaFz3+bAkJVxZKqFqtLOtZ3L2sfM9vXX7yj4vGGIsEEOfSlw3z+KpZ6ejT9rNCQQlBmCbw
        cPt/n5G/KeqLukSSUlZu32GYVkjziA0PRQCM1MVHawXTsGlRWY7m+4jC/mhHhI15eXI07v4I83/Aj
        2/CCvyJDP0oq6gLOgVcXM/C6OClcTqC0DqpfQTEzGIsgfJ8xU8Kv0WKXtut/u0BEw6nbtqiRjcd6A
        3ykG5ipnyfYy4EmfE8q4UY0tuOS0VR8ScKOsHtJgGadwXSK9HY1JbovS/IvxglBVDUHEgKdcOWk0I
        /Fz/X1Rg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33376)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oCfkI-0008Ep-6v; Sat, 16 Jul 2022 12:14:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oCfkB-0008SP-Ln; Sat, 16 Jul 2022 12:13:55 +0100
Date:   Sat, 16 Jul 2022 12:13:55 +0100
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
Message-ID: <YtKdcxupT+INVAhR@shell.armlinux.org.uk>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <E1oCNl3-006e3n-PT@rmk-PC.armlinux.org.uk>
 <E1oCNl3-006e3n-PT@rmk-PC.armlinux.org.uk>
 <20220715172444.yins4kb2b6b35aql@skbuf>
 <YtHcpf4otJQS9hTO@shell.armlinux.org.uk>
 <20220715222348.okmeyd55o5u3gkyi@skbuf>
 <YtHw0O5NB6kGkdwV@shell.armlinux.org.uk>
 <20220716105711.bjsh763smf6bfjy2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220716105711.bjsh763smf6bfjy2@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 16, 2022 at 01:57:11PM +0300, Vladimir Oltean wrote:
> On Fri, Jul 15, 2022 at 11:57:20PM +0100, Russell King (Oracle) wrote:
> > > > The problem is this - we call get_caps(), and we have to read registers
> > > > to work out what the port supports. If we have a separate callback, then
> > > > we need to re-read those registers to get the same information to report
> > > > what the default interface should be.
> > > > 
> > > > Since almost all of the Marvell implementations the values for both the
> > > > list of supported interfaces and the default interface both require
> > > > reading a register and translating it to a phy_interface_t, and then
> > > > setting the support mask, it seems logical to combine these two
> > > > functioalities into one function.
> > > 
> > > In essence that doesn't mean much; DSA isn't Marvell only, but I'll give
> > > it to you: if only the Marvell driver (and Broadcom later, I expect) is
> > > going to add support for the context-specific interpretation of CPU port
> > > OF nodes, then we may consider tailoring the implementation to their
> > > hardware register layout details. In any case, my concern can be
> > > addressed even if you insist on keeping the default interface as an
> > > argument of phylink_get_caps. There just needs to be a lot more
> > > documentation explaining who needs to populate that argument and why.
> > 
> > I don't get the point you're making here.
> 
> The point I'm making is that I dislike where this is going. The addition
> of "default_interface" to phylink_get_caps is confusing because it lacks
> proper qualifiers.
> 
> The concrete reasons why it's confusing are:
> 
> (a) there is no comment which specifies on which kinds of ports (DSA and CPU)
>     the default_interface will be used. This might result in useless effort
>     from driver authors to report a default_interface for a port where it
>     will never be asked for.
> 
> (b) there is no comment which specifies that only the drivers which have
>     DT blobs with missing phylink bindings on CPU and DSA ports should
>     fill this out. I wouldn't want to see a new driver use this facility,
>     I just don't see a reason for it. I'd rather see a comment that the
>     recommendation for new drivers is to validate their bindings and not
>     rely on context-specific interpretations of empty DT nodes.
> 
> (c) especially with the dsa_port_find_max_caps() heuristic in place, I
>     can't say I'm clear at all on who should populate "default_interface"
>     and who could safely rely on the heuristic if they populate
>     supported_interfaces. It's simply put unclear what is the expectation
>     from driver authors.
> 
> For (b) I was thinking that making it a separate function would make it
> clearer that it isn't for everyone. Doing just that wouldn't solve everything,
> so I've also said that adding more documentation to this function
> prototype would go a long way.
> 
> Some dsa_switch_ops already have inline comments in include/net/dsa.h,
> see get_tag_protocol, change_tag_protocol, port_change_mtu. Also, there
> is the the "PHY devices and link management" chapter in Documentation/networking/dsa/dsa.rst.
> We have places to document what the DSA framework expects drivers to do.
> I was expecting that wherever default_interface gets reported, we could
> see some answers and explanations to the questions above.

Thanks for clarifying.

> > > Also, perhaps more importantly, a real effort needs to be put to prevent
> > > breakage for drivers that work without a phylink instance registered for
> > > the CPU port, and also don't report the default interface. Practically
> > > that just means not deleting the current logic, but making it one of 3
> > > options.
> > > 
> > > fwnode is valid from phylink's perspective?
> > >        /                             \
> > >  yes  /                               \ no
> > >      /                                 \
> > > register with phylink         can we determine the link parameters to create
> > >                                   a fixed-link software node?
> > >                                        /                \                     \
> > >                                  yes  /                  \  no                |
> > >                                      /                    \                   | this is missing
> > >                                     /                      \                  |
> > >              create the software node and       don't put the port down,      |
> > >              register with phylink              don't register with phylink   /
> > 
> > This is exactly what we have today,
> 
> Wait a minute, how come this is exactly what we have "today"?
> 
> In tree we have this:
> 
> fwnode is valid from phylink's perspective?
>        /                             \
>  yes  /                               \  no
>      /                                 \
> register with phylink                   \
>                              don't put the port down,
>                              don't register with phylink
> 
> 
> In your patch set we have this:
> 
> 
> fwnode is valid from phylink's perspective?
>        /                             \
>  yes  /                               \ no
>      /                                 \
> register with phylink         can we determine the link parameters to create
>                                   a fixed-link software node?
>                                        /                \
>                                  yes  /                  \  no
>                                      /                    \
>                                     /                      \
>              create the software node and            fail to create the port
>              register with phylink
> 
> > and is exactly what I'm trying to get rid of, so we have _consistency_
> > in the implementation, to prevent fuckups like I've created by
> > converting many DSA drivers to use phylink_pcs. Any DSA driver that
> > used a PCS for the DSA or CPu port and has been converted to
> > phylink_pcs support has been broken in the last few kernel cycles. I'm
> > trying to address that breakage before converting the Marvell DSA
> > driver - which is the driver that highlighted the problem.
> 
> You are essentially saying that it's of no use to keep in DSA the
> fallback logic of not registering with phylink, because the phylink_pcs
> conversions have broken the defaulting functionality already in all
> other drivers.

Correct, and I don't want these exceptions precisely because it creates
stupid mistakes like the one I've highlighted. If we have one way of
doing something, then development becomes much easier. When we have
multiple different ways, mistakes happen, stuff breaks.

> I may have missed something, but this is new information to me.
> Specifically, before you've said that it is *this* patch set which would
> risk introducing breakage (by forcing a link down + a phylink creation).
> https://lore.kernel.org/netdev/YsCqFM8qM1h1MKu%2F@shell.armlinux.org.uk/
> What you're saying now directly contradicts that.

No, it is not contradictory at all.

There is previous breakage caused by converting DSA drivers to
phylink_pcs - because the PCS code will *not* be called where a driver
makes use of the "default-to-fastest-speed" mechanism, so is likely
broken. Some drivers work around this by doing things manually.

This series *also* risks breakage, because it means phylink gets used
in more situations which could confuse drivers - such as those which
have manually brought stuff up and are not expecting phylink to also
do it. Or those which do not fill in the mac_capabilities but do
default to this "fastest-speed" mechanism. Or some other unforseen
scenario.

So there's known breakage - which we know because we've tripped over
the issue with mv88e6xxx pcs conversion which isn't in net-next yet,
but illustrates the issue, and there's unknown breakage through
applying this patch and not having had test feedback from all the
DSA driver authors.

There are no contradiction there what so ever.

> Do you have concrete evidence that there is actually any regression of
> this kind introduced by prior phylink_pcs conversions? Because if there
> is, I retract the proposal to keep the fallback logic.

Since we have no idea which DSA drivers make use of this "default-to-
fastest-speed", and Andrew who has been promoting this doesn't seem to
know which drivers make use of this, I do not, but we know that the
breakage does occur if someone does make use of this with one of the
converted DSA drivers through the behaviour of mv88e6xxx. Just because
no one has reported it yet does not mean it doesn't exist. Not everyone
updates their kernels each time Linus releases a final kernel version,
especially in the embedded world. Sometimes it can take until a LTS
release until people move forward, which we think will be 5.21.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
