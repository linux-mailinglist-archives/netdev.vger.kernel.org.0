Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECE057FD33
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 12:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbiGYKLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 06:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbiGYKLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 06:11:49 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6396E6352;
        Mon, 25 Jul 2022 03:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ya/mloD9INrh1JvY6dnMl/d7HT2EcwvD9REwi50/cyk=; b=p0bIhswdVBkBS4mIm0qIFUgnCj
        7Lon5zfZcgzRUiDxfEY3acPj0/9OwKG5ie7YcAYSbc/RaVmq/Gkn9ZKrmgssU2j8Im9EOKGfeR69Z
        yzCDg6ODIxjbp4pZ5NKMGyqlm6w2Z+9z9ppZrtINZU3sE5+X8IZFFwJ3puh+INL5BZGLbovyrsfYp
        qOHrc1EwKk7SZwNkRGsn5F/Njcwsqn8940ipE8nq8K5ttBpY8gxojD3PZHApC0BVHmwPpr5IfDB6m
        CD88wSJt197e6CjnizglfND0ZGL9hC/UBwOOY/EnygFklwMAoCBjd3kT1w+jXDSXcPjjea6rMoAR/
        yUddL8vQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33550)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oFv3R-0002in-6d; Mon, 25 Jul 2022 11:11:13 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oFv3L-0000Ao-4m; Mon, 25 Jul 2022 11:11:07 +0100
Date:   Mon, 25 Jul 2022 11:11:07 +0100
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
Message-ID: <Yt5sO0GUM42+yvU3@shell.armlinux.org.uk>
References: <20220722105238.qhfq5myqa4ixkvy4@skbuf>
 <YtqNkSDLRDtuooy/@shell.armlinux.org.uk>
 <20220722124629.7y3p7nt6jmm5hecq@skbuf>
 <YtqjFKUTsH4CK0L+@shell.armlinux.org.uk>
 <20220722165600.lldukpdflv7cjp4j@skbuf>
 <YtsUhdg3a2rT3NJC@shell.armlinux.org.uk>
 <YtsUhdg3a2rT3NJC@shell.armlinux.org.uk>
 <20220722223932.poxim3sxz62lhcuf@skbuf>
 <YtufRO+oeQgmQi57@shell.armlinux.org.uk>
 <20220723134444.e65w3zq6pg43fcm4@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220723134444.e65w3zq6pg43fcm4@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 23, 2022 at 04:44:44PM +0300, Vladimir Oltean wrote:
> On Sat, Jul 23, 2022 at 08:12:04AM +0100, Russell King (Oracle) wrote:
> > > > > Thanks for this explanation, if nothing else, it seems to support the
> > > > > way in which I was interpreting managed = "in-band-status" to mean
> > > > > "enable in-band autoneg", but to be clear, I wasn't debating something
> > > > > about the way in which mvneta was doing things. But rather, I was
> > > > > debating why would *other* drivers do things differently such as to come
> > > > > to expect that a fixed-link master + an in-band-status CPU port, or the
> > > > > other way around, may be compatible with each other.
> > > > 
> > > > Please note that phylink makes a DT specification including both a
> > > > fixed-link descriptor and a managed in-band-status property illegal
> > > > because these are two different modes of operating the link, and they
> > > > conflict with each other.
> > > 
> > > Ok, thank you for this information which I already knew, what is the context?
> > 
> > FFS. You're the one who's writing emails to me that include *both*
> > "fixed-link" and "in-band-status" together. I'm pointing out that
> > specifying that in DT for a port together is not permitted.
> > 
> > And here I give up reading this email. Sorry, I'm too frustrated
> > with this nitpicking, and too frustrated with spending hours writing a
> > reply only to have it torn apart.
> 
> This is becoming toxic.

It is toxic, because I'm spending longer and longer replying to each of
your emails, because every time I do, you ask more and more questions
despite my best effort to provide clear answers. This cycle of forever
growing emails that take longer and longer to reply to can not continue.

When I spend three hours trying to compose a reply to your email, and
then get a reply that tears it apart, needing another multi-hour effort
to reply, it has to stop. Sorry, but it has to.

I am not going to spend endless hours composing one reply after another
on the same topic - I will just stop trying to compose a reply to an
email if its turning into another multi-hour effort leaving the rest of
the email unreplied - and in many cases even unread. Sorry, but I don't
have the patience.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
