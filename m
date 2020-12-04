Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F4C2CF3C4
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbgLDSPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:15:46 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:50783 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727729AbgLDSPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 13:15:45 -0500
X-Greylist: delayed 37108 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Dec 2020 13:15:45 EST
X-Originating-IP: 86.194.74.19
Received: from localhost (lfbn-lyo-1-997-19.w86-194.abo.wanadoo.fr [86.194.74.19])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id D82C71BF20E;
        Fri,  4 Dec 2020 18:15:02 +0000 (UTC)
Date:   Fri, 4 Dec 2020 19:15:02 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: Re: [PATCH v2 net] net: mscc: ocelot: install MAC addresses in
 .ndo_set_rx_mode from process context
Message-ID: <20201204181502.GN74177@piout.net>
References: <20201204175125.1444314-1-vladimir.oltean@nxp.com>
 <20201204100021.0b026725@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201204181250.t5d4hc7wis7pzqa2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204181250.t5d4hc7wis7pzqa2@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/12/2020 18:12:51+0000, Vladimir Oltean wrote:
> Yeah, well I more or less deliberately lose track of the workqueue as
> soon as ocelot_enqueue_mact_action is over, and that is by design. There
> is potentially more than one address to offload to the hardware in progress
> at the same time, and any sort of serialization in .ndo_set_rx_mode (so
> I could add the workqueue to a list of items to cancel on unbind)
> would mean
> (a) more complicated code
> (b) more busy waiting
> 
> > >  drivers/net/ethernet/mscc/ocelot_net.c | 83 +++++++++++++++++++++++++-
> > >  1 file changed, 80 insertions(+), 3 deletions(-)
> >
> > This is a little large for a rc7 fix :S
> 
> Fine, net-next it is then.
> 
> > What's the expected poll time? maybe it's not that bad to busy wait?
> > Clearly nobody noticed the issue in 2 years (you mention lockdep so
> > not a "real" deadlock) which makes me think the wait can't be that long?
> 
> Not too much, but the sleep is there.
> Also, all 3 of ocelot/felix/seville are memory-mapped devices. But I
> heard from Alex a while ago that he intends to add support for a switch
> managed over a slow bus like SPI, and to use the same regmap infrastructure.
> That would mean that this problem would need to be resolved anyway.
> 

This is still on the way but it will not happen this year unfortunately.


-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
