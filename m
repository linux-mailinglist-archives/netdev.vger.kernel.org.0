Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE171F063D
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 12:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbgFFK7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 06:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728696AbgFFK7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 06:59:17 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70106C03E96A;
        Sat,  6 Jun 2020 03:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject
        :Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TSmHMgStkMJ5gRMIvy+b9qTii6HmC3HhhWZPLLxufvs=; b=bnM7ioyTVd4u3AnsSt/NVBmEYp
        OLY3XHFizopfFrRxPGrIjrcgfoWXL9x+5R1m7Jzom51OEsClzJGKLm+i2udv4wK0/RtKZvu2Uhrfh
        kXKaLhZ/ThvFyFtgeBp1Y+l65umqaxj2kF9yTG3qq/s8fy1tNzvQq0LgpCXjUw+pDhjmbB3RK5NyC
        lZcErKsHZYrMu6pELRPJPivL0Ij2x4XdqcGHc1zB2TxkCXK8i3pgA80NpUkbeCsWyJjPbApfmB8D3
        /DY73Gnp1+pfwFYpZHWESZfAtSaCuVf5gW7D4VR+DYeuSgq5+eaL4OobiNoHpMKoogdYZiqC37/DI
        uD9il7BQ==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1jhWXd-0001Ke-J2; Sat, 06 Jun 2020 11:59:09 +0100
Date:   Sat, 6 Jun 2020 11:59:09 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: qca8k: introduce SGMII configuration
 options
Message-ID: <20200606105909.GN311@earth.li>
References: <cover.1591380105.git.noodles@earth.li>
 <8ddd76e484e1bedd12c87ea0810826b60e004a65.1591380105.git.noodles@earth.li>
 <20200605183843.GB1006885@lunn.ch>
 <20200606074916.GM311@earth.li>
 <20200606083741.GK1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200606083741.GK1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 06, 2020 at 09:37:41AM +0100, Russell King - ARM Linux admin wrote:
> On Sat, Jun 06, 2020 at 08:49:16AM +0100, Jonathan McDowell wrote:
> > On Fri, Jun 05, 2020 at 08:38:43PM +0200, Andrew Lunn wrote:
> > > On Fri, Jun 05, 2020 at 07:10:58PM +0100, Jonathan McDowell wrote:
> > > > The QCA8337(N) has an SGMII port which can operate in MAC, PHY or BASE-X
> > > > mode depending on what it's connected to (e.g. CPU vs external PHY or
> > > > SFP). At present the driver does no configuration of this port even if
> > > > it is selected.
> > > > 
> > > > Add support for making sure the SGMII is enabled if it's in use, and
> > > > device tree support for configuring the connection details.
> > > 
> > > It is good to include Russell King in Cc: for patches like this.
> > 
> > No problem, I can keep him in the thread; I used get_maintainer for the
> > initial set of people/lists to copy.
> 
> get_maintainer is not always "good" at selecting the right people,
> especially when your patches don't match the criteria; MAINTAINERS
> contains everything that is sensible, but Andrew is suggesting that
> you copy me because in his opinion, you should be using phylink -
> and that's something that you can't encode into a program.

Sure, and I appreciate the pointer to appropriate people who might
provide helpful comments.

> Note that I haven't seen your patches.

I'll make sure to copy you on v2.

> > > Also, netdev is closed at the moment, so please post patches as RFC.
> > 
> > "closed"? If you mean this won't get into 5.8 then I wasn't expecting it
> > to, I'm aware the merge window for that is already open.
> 
> See https://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt
> "How often do changes from these trees make it to the mainline Linus
> tree?"

Ta. I'll hold off on a v2 until after -rc1 drops.

> > > It sounds like the hardware has a PCS which can support SGMII or
> > > 1000BaseX. phylink will tell you what mode to configure it to. e.g. A
> > > fibre SFP module will want 1000BaseX. A copper SFP module will want
> > > SGMII. A switch is likely to want 1000BaseX. A PHY is likely to want
> > > SGMII. So remove the "sgmii-mode" property and configure it as phylink
> > > is requesting.
> > 
> > It's more than SGMII or 1000BaseX as I read it. The port can act as if
> > it's talking to an SGMII MAC, i.e. a CPU, or an SGMII PHY, i.e. an
> > external PHY, or in BaseX mode for an SFP. I couldn't figure out a way
> > in the current framework to automatically work out if I wanted PHY or
> > MAC mode. For the port tagged CPU I can assume MAC mode, but a port that
> > doesn't have that might still be attached to the CPU rather than an
> > external PHY.
> 
> That depends what you're connected to. Some people call the two sides
> of SGMII "System side" and "Media side". System side is where you're
> receiving the results of AN from a PHY. Media side is where you're
> telling the partner what you want it to do.
> 
> Media side is only useful if you're connected to another MAC, and
> unless you have a requirement for it, I would suggest not implementing
> that - you could come up with something using fixed-link, or it may
> need some other model if the settings need to change.  That depends on
> the application.

So the device in question is a 7 port stand alone switch chip. There's a
single SGMII port which is configurable between port 0 + 6 (they can
also be configure up as RGMII, while the remaining 5 ports have their
own phys).

It sounds like there's a strong preference to try and auto configure
things as much as possible, so I should assume the CPU port is in MAC
mode, and anything not tagged as a CPU port is talking to a PHY/BASEX.

I assume I can use PHY_INTERFACE_MODE_1000BASEX on the
phylink_mac_config call to choose BASEX?

> > > What exactly does sgmii-delay do?
> > 
> > As per the device tree documentation update I sent it delays the SGMII
> > clock by 2ns. From the data sheet:
> > 
> > SGMII_SEL_CLK125M	sgmii_clk125m_rx_delay is delayed by 2ns
> 
> This sounds like a new world of RGMII delay pain but for SGMII. There
> is no mention of "delay" in the SGMII v1.8 specification, so I guess
> it's something the vendor is doing. Is this device capable of
> recovering the clock from a single serdes pair carrying the data,
> or does it always require the separate clock?

Pass, but I think I might be able to get away without having to
configure that for the moment.

I'll go away and roll a v2 moving qca8k over to phylink and then using
that to auto select the appropriate SGMII mode. Thanks for the feedback.

J.

-- 
I started out with nothing & still have most of it left.
