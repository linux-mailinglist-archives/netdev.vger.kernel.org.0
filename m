Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550DE2F7836
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 13:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730455AbhAOMDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 07:03:15 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:36615 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729961AbhAOMDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 07:03:14 -0500
X-Originating-IP: 86.202.109.140
Received: from localhost (lfbn-lyo-1-13-140.w86-202.abo.wanadoo.fr [86.202.109.140])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 17AC21C000A;
        Fri, 15 Jan 2021 12:02:30 +0000 (UTC)
Date:   Fri, 15 Jan 2021 13:02:30 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [RFC PATCH net-next 12/16] net: mscc: ocelot: drop the use of
 the "lags" array
Message-ID: <20210115120230.GF3654@piout.net>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
 <20201208120802.1268708-13-vladimir.oltean@nxp.com>
 <20210115110547.fwfyl3lnplbvqieu@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115110547.fwfyl3lnplbvqieu@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/01/2021 13:05:47+0200, Vladimir Oltean wrote:
> > -static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
> > +static int ocelot_set_aggr_pgids(struct ocelot *ocelot)
> >  {
> > +	struct net_device **bonds;
> >  	int i, port, lag;
> >  
> > +	bonds = kcalloc(ocelot->num_phys_ports, sizeof(struct net_device *),
> > +			GFP_KERNEL);
> > +	if (!bonds)
> > +		return -ENOMEM;
> > +
> 
> I remember somebody complaining about the temporary memory allocation
> done here, but I can't seem to find that email for some reason.
> 
> Is it ok if I still keep the dynamic allocation there, though? Felix has
> up to 5 user ports, Seville has up to 9, Ocelot up to 11. I would like
> to not hardcode anything, in case (who knows!) more switches get added.
> 

I was probably the one, the main reason being that this make this
function able to fail. Removing the dynamic allocation would ensure it
never fails. However, I didn't suggest any other solution so I'm fine if
you keep it.


-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
