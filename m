Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8379A53A346
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 12:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351004AbiFAKwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 06:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348534AbiFAKwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 06:52:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478C45003F
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 03:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=g9E1AuvfWCcgmnbnc+/gxYATcNLA28C8pxI3YFEc5Wc=; b=b7SFSzmZFpGx+Dqa4Ii6NnJG3n
        0lUTX9EqK2Mwb+P+1zle6sjWVzOmGlql4JJNFyMoYfOpf6egA4zF7ECd5VNToYZKBsckc/W4QyMIa
        qC4ISC/B/Ca6XXsfLmU1TYFju0uesu5wZib/QQAi5MEPMSBtGpk4ADFSxLLdZErb5/RHyEenKrGfd
        LDsfNiMWOAQktgMZp3tvz9vB7vXaJfA+zMDaIpuudpv6JdoJZdejaIvbEPJp4yWuHAJVdiwPm9M7d
        rWO7SAnDRyebIfYHIEiAM9xdKf3LeejdEFJNoo3avyl3qTAypPIkYR9ktBQQGOAuwlB8NaG9uY8zK
        OxmmSiwg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60920)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nwLxU-0005wC-L7; Wed, 01 Jun 2022 11:52:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nwLxS-0003Oo-BP; Wed, 01 Jun 2022 11:52:10 +0100
Date:   Wed, 1 Jun 2022 11:52:10 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Josua Mayer <josua@solid-run.com>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, rafal@milecki.pl
Subject: Re: [PATCH RFC] net: sfp: support assigning status LEDs to SFP
 connectors
Message-ID: <YpdE2sflpqRkWKns@shell.armlinux.org.uk>
References: <20220509122938.14651-1-josua@solid-run.com>
 <Ynk5UPWkuoXeqfJj@shell.armlinux.org.uk>
 <bc461bd4-e123-212d-42a5-2da2efb7235a@solid-run.com>
 <20220511132221.pkvi3g7agjm2xuph@skbuf>
 <Ynu8ixB5cm3zy6Yx@shell.armlinux.org.uk>
 <7c70ab93-6d35-52f5-ab11-e3b4ecd622f2@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7c70ab93-6d35-52f5-ab11-e3b4ecd622f2@solid-run.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 01, 2022 at 01:18:12PM +0300, Josua Mayer wrote:
> Hi Russell,
> 
> Thank you for the examples below!
> Stable names do help in some cases, but not in all.
> 
> I did some testing the other day with renaming network interfaces through
> the ip command:
> ip link set dev eth8 down
> ip link set dev eth12 down
> ip link set eth12 name eth20
> ip link set eth8 name eth12
> ip link set eth20 name eth8
> ip link set eth8 up
> ip link set dev eth12 up
> 
> Swapping interface names like this seems a perfectly legal thing for
> userspace to do. I personally would in such case expect the previous LED
> assignment to move along with the name change, however this does not happen.
> Instead after the interface rename, the LEDs are effectively swapped.

Someone may also take the view that this is exactly what should happen.
The requested configuration was to bind the trigger to a network
interface called "eth8" and if that interface goes away (through
whatever means) and then something else comes back as "eth8" then
"eth8" should be used.

The same is true of netfilter rules. If you specify a rule that
matches an interface called "eth8" then you get that match on that
name irrespective of network interface renames. The rule doesn't get
updated because you've changed the interface name. So in that regard,
the netdev LED trigger is operating just the same way as other parts
of the network subsystem.

> Further the netdev trigger implementation seems incorrect when you add
> network namespaces.
> Two namespaces can each contain a device named eth0, but the netdev trigger
> does not look at the namespace id when matching events to triggers, just the
> name.

That sounds like a bug - the netdev trigger will select the last
matching interface that it hears about when a netdev is registered or
its name is changed to something that matches what it's looking for.
So if you have multiple namespaces with identical names, the last
namespace with a matching interface name gets to control the LED.

However, I suspect the LED trigger folk may say "don't do that".

> Is it intended for userspace to track interface renames and reassign LEDs?
> Or should the trigger driver watch for name changes and adapt accordingly?
> 
> Finally I also noticed that the netdev trigger by default does not propagate
> any information to the LED.
> All properties - link, rx, tx are 0.
> Attempts at setting this by default through udev were widely unsuccessful:
> E.g. before setting the trigger property to netdev, the device_name or link
> properties do not exist.

The trigger specific properties will not exist until such time that
the trigger has been assigned - because each trigger is an entirely
separate chunk of code which might even be in a loadable module, and
each trigger driver is responsible for creating the properties that
it needs. I'm guessing this was part of the design of the LED
subsystem from the start, and it does make total sense.

> Therefore a rule that sets trigger and link and device at the same time does
> not function:
> SUBSYSTEM=="leds", ACTION=="add|change",
> ENV{OF_FULLNAME}=="/leds/led_c1_at", ATTR{trigger}="netdev", ATTR{link}="1",
> ATTR{device_name}="eth0"

I'm guessing that's because udev effectively sorts or randomises
the attributes, and gives no guarantees what order the attributes
are written. Sounds like we need udev people to comment on that
point.

> It appears necessary to use 2 rules, one that selects netdev, another one
> that chooses what property to show, e.g. link;
> and finally some rule that tracks the netdev name and updates device_name
> property accordingly.
> All while watching out for infinite loops because the property changes
> appear to trigger more change events, and e.g. setting trigger to netdev
> again causes another change event and resets the properties ...
> 
> I get the impression that this is very complex and might be described much
> better in device-tree, at least when a vendor makes explicit decisions to
> the purpose of each led.
> 
> Thee has been a recent patchset floating this list by Rafał Miłecki,
> which I very much liked:
> [PATCH RESEND PoC] leds: trigger: netdev: support DT "trigger-sources"
> property
> 
> It does allow declaring the relation from dpmac to led in dts as I would
> have expected.
> 
> In addition I believe there should be a way in dts to also set a default for
> what information to show, e.g.
> default-function = "link";
> 
> And finally dynamic tracking of the interface name.
> 
> I would be willing to work on the last two ideas, if this is an acceptable
> approach.

I think this is all something to bring up with those who look after
the netdev trigger.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
