Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE0022F6CA
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 19:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730313AbgG0Rhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 13:37:31 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:58234 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731344AbgG0Rh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 13:37:29 -0400
Received: from pendragon.ideasonboard.com (81-175-216-236.bb.dnainternet.fi [81.175.216.236])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 60EE0556;
        Mon, 27 Jul 2020 19:37:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1595871445;
        bh=XZ5UmqXA5czY35VWinVmDMvOn/YIwPOlRwwuxlDX1Qo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Agq8rjvPeVHUjYarOnsB0EsZpsyzd1r1GZE/2YAszslrWb+1Bp7yx5CcMw05I7PtN
         hDbYe+SCgoewcrT5j+w8EjqhaYMoCCsOjFm/mNlZgkBpZ47hLVxQfaTADG60Aykr2h
         2OeH45VjGmxJtF0z47Z7M3Z14QgIdxXGnteiee8U=
Date:   Mon, 27 Jul 2020 20:37:17 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Chris Healy <cphealy@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>
Subject: Re: [RESENT PATCH net--stat 1/1] net: ethernet: fec: Revert "net:
 ethernet: fec: Replace interrupt driven MDIO with polled IO"
Message-ID: <20200727173717.GJ17521@pendragon.ideasonboard.com>
References: <20200727012354.GT28704@pendragon.ideasonboard.com>
 <20200727020631.GW28704@pendragon.ideasonboard.com>
 <20200727021432.GM1661457@lunn.ch>
 <20200727023310.GA23988@pendragon.ideasonboard.com>
 <CAFXsbZrf11Nj4rzLJfisPr-fFo-+stt-G3-XQ_Mwus_2z0nsAg@mail.gmail.com>
 <CAFXsbZrysb6SGisEhgXHzj8NZ5o_EjY-rtiqg3gypgr0w-d-dw@mail.gmail.com>
 <CAFXsbZpBP_kzsC_dLYezJWo7+dQufoRmaFpJgKJbnn6T=sc5QA@mail.gmail.com>
 <20200727120545.GN1661457@lunn.ch>
 <20200727152434.GF20890@pendragon.ideasonboard.com>
 <CAFXsbZo5ufE0v_dmzQU9oWBeeRj+DKzDoiMj6OjuiER0O7nFfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFXsbZo5ufE0v_dmzQU9oWBeeRj+DKzDoiMj6OjuiER0O7nFfQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chris,

On Mon, Jul 27, 2020 at 08:41:23AM -0700, Chris Healy wrote:
> On Mon, Jul 27, 2020 at 8:24 AM Laurent Pinchart wrote:
> > On Mon, Jul 27, 2020 at 02:05:45PM +0200, Andrew Lunn wrote:
> > > On Sun, Jul 26, 2020 at 08:01:25PM -0700, Chris Healy wrote:
> > > > It appears quite a few boards were affected by this micrel PHY driver change:
> > > >
> > > > 2ccb0161a0e9eb06f538557d38987e436fc39b8d
> > > > 80bf72598663496d08b3c0231377db6a99d7fd68
> > > > 2de00450c0126ec8838f72157577578e85cae5d8
> > > > 820f8a870f6575acda1bf7f1a03c701c43ed5d79
> > > >
> > > > I just updated the phy-mode with my board from rgmii to rgmii-id and
> > > > everything started working fine with net-next again:
> > >
> > > Hi Chris
> > >
> > > Is this a mainline supported board? Do you plan to submit a patch?
> > >
> > > Laurent, does the change also work for your board? This is another one
> > > of those cases were a bug in the PHY driver, not respecting the
> > > phy-mode, has masked a bug in the device tree, using the wrong
> > > phy-mode. We had the same issue with the Atheros PHY a while back.
> >
> > Yes, setting the phy-mode to rgmii-id fixes the issue.
> >
> > Thank you everybody for your quick responses and very useful help !
> >
> > On a side note, when the kernel boots, there's a ~10s delay for the
> > ethernet connection to come up:
> >
> > [    4.050754] Micrel KSZ9031 Gigabit PHY 30be0000.ethernet-1:01: attached PHY driver [Micrel KSZ9031 Gigabit PHY] (mii_bus:phy_addr=30be0000.ethernet-1:01, irq=POLL)
> > [   15.628528] fec 30be0000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx
> > [   15.676961] Sending DHCP requests ., OK
> > [   15.720925] IP-Config: Got DHCP answer from 192.168.2.47, my address is 192.168.2.210
> >
> > The LED on the connected switch confirms this, it lits up synchronously
> > with the "Link is up" message. It's not an urgent issue, but if someone
> > had a few pointers on how I could debug that, it would be appreciated.
> 
> Here's a few suggestions that could help in learning more:
> 
> 1) Review the KSZ9031 HW errata and compare against the PHY driver
> code.  There's a number of errata that could cause this from my quick
> review.

I'll have a look at that, thanks.

> 2) Based on what I read in the HW errata, try different link partners
> that utilize different copper PHYs to see if it results in different
> behaviour.

I have limited available test equipment, but I can give it a try.

> 3) Try setting your autonegotiate advertisement to only advertise
> 100Mbps and see if this affects the timing.  Obviously this would not
> be a solution but might help in better understanding the issue.

I've tested this, and the link then comes up in ~2 seconds instead of
~10. That's clearly an improvement, but I have no idea what it implies
:-)

[    4.090655] Micrel KSZ9031 Gigabit PHY 30be0000.ethernet-1:01: attached PHY driver [Micrel KSZ9031 Gigabit PHY] (mii_bus:phy_addr=30be0000.ethernet-1:01, irq=POLL)
[    6.188347] fec 30be0000.ethernet eth0: Link is Up - 100Mbps/Full - flow control rx/tx
[    6.236843] Sending DHCP requests ., OK
[    6.280807] IP-Config: Got DHCP answer from 192.168.2.47, my address is 192.168.2.210

-- 
Regards,

Laurent Pinchart
