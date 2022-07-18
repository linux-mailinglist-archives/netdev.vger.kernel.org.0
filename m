Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C8C578BF6
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 22:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbiGRUm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 16:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiGRUm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 16:42:56 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6918230F50;
        Mon, 18 Jul 2022 13:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+H3yi2bDbwTjQoxRVKSELicvTZlu4EXgou/zL2++LaI=; b=dBneMK7A0jzuFkk5P7GC+m2zZD
        Nu1o2KMj3ruJg0TlMVtjIXhx2Iatm9CQsjSOKzgjP14BCooZFjzWbRYD5E3G1F7DjaGJW/AGEr+uW
        LG0ZdrvBqyKaI/HRCD2kKVMBzNg7MeOQOu7LZ8wv8Zq2DlBNIt1SXHzm04Yf8lwAnivY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oDXZV-00AkyX-50; Mon, 18 Jul 2022 22:42:29 +0200
Date:   Mon, 18 Jul 2022 22:42:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin __ipraga <alsi@bang-olufsen.dk>,
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
Subject: Re: [PATCH net-next 2/6] software node: allow named software node to
 be created
Message-ID: <YtXFtTsf++AeDm1l@lunn.ch>
References: <YtGPO5SkMZfN8b/s@shell.armlinux.org.uk>
 <E1oCNky-006e3g-KA@rmk-PC.armlinux.org.uk>
 <YtHGwz4v7VWKhIXG@smile.fi.intel.com>
 <20220715201715.foea4rifegmnti46@skbuf>
 <YtHPJNpcN4vNfgT6@smile.fi.intel.com>
 <20220715204841.pwhvnue2atrkc2fx@skbuf>
 <YtVSQI5VHtCOTCHc@smile.fi.intel.com>
 <YtVfppMtW77ICyC5@shell.armlinux.org.uk>
 <YtWp3WkpCtfe559l@smile.fi.intel.com>
 <YtWwbMucEyO+W8/Y@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtWwbMucEyO+W8/Y@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Just for my learning, why PHY uses "fixed-link" instead of relying on a
> > (firmware) graph? It might be the actual solution to your problem.
> 
> That's a question for Andrew, but I've tried to solicit his comments on
> several occasions concerning this "feature" of DSA but I keep getting
> no reply. Honestly, I don't know the answer to your question.
> 
> The only thing that I know is that Andrew has been promoting this
> feature where a switch port, whether it be connected to the CPU or
> to another switch, which doesn't specify any link parameters will
> automatically use the fastest "phy interface mode" and the fastest
> link speed that can be supported by the DSA device.

This goes back to the very beginning of DSA, as far as i know. This
was before the times of DT. Platform data was used to describe the
switch tree, and it was pretty minimalist. It just listed the ports of
the switches and their names. The 'cpu' port had the name 'cpu', and
DSA ports either did not have a name, or 'dsa'. I don't
remember. There was also a table describing the routing between
switches in the tree. The platform data had nothing to describe
interface speeds, and i'm not sure phylib was even involved to control
the integrated PHYs. Marvell switches would power up their PHYs in
autoneg mode, meaning they just worked. In order to make the CPU port
work, which did not have a PHY, the driver would configure the CPU
port into its fastest mode. Same for the DSA ports. A Marvell Switch
connected to a Marvell SoC NIC worked.

Sometime later DT became the way to describe ARM boards, and pretty
much all boards with switches were ARM boards. If i remember
correctly, Florian did the first binding, which was basically
translate the platform data straight into DT. Since the platform data
had no way to describe port speed, the DT binding had no way to
describe port speed. It just kept on defaulting to the maximum speed.

The DT world evolved, and DT bindings were produced for phylib.

At some point, DSA got an interface to phylib. Maybe it was there from
the beginning, maybe it was added later. I don't know. As a result,
the DT properties for phylib became valid for switch user ports.

Without looking at git, i'm a bit hazy why fixed-link was introduced
for CPU and DSA ports. At some point in time, i was asked to make a
Marvell switch work with a Freescale FEC. The FEC had a Fast Ethernet,
where as the switch CPU port was 1G. It could be that in order to make
this work, i added fixed-link support to CPU ports, so i could specify
the CPU port speed, rather than use the default which would not work.

At some point, i had a board with an RGMII interface used as a DSA
link between two switches, and i needed to specify the RGMII
delays. It could of been using a fixed-link allowed the phy-mode to be
specified for a DSA port, thus allowing the delays to be specified?

Basically, fixed-phy for CPU and DSA was added to solve a limitation
of the default fastest port speed not always working.

With time, more vendors got behind DSA and switches other than Marvell
were added. There was not much documentation about the expectations of
switch drivers, and i doubt this default maximum speed behaviour of
CPU ports was documented. I probably commented on earlier drivers that
fixed-link could be used, or that the Marvell behaviour could be
copied.

And some devices probably power up ports at their maximum speed,
others can probably be strapped to specific modes. Some drivers
default to maximum speed, others required fixed links to specific the
speed. As Russell says, code inspection is not enough to tell what is
going on.

	Andrew
