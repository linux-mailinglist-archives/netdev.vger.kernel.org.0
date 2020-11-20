Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127062BAB8E
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgKTNzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:55:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41254 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgKTNzY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 08:55:24 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kg6sf-0087Jz-7R; Fri, 20 Nov 2020 14:55:17 +0100
Date:   Fri, 20 Nov 2020 14:55:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <atenart@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: net: phy: Dealing with 88e1543 dual-port mode
Message-ID: <20201120135517.GH1804098@lunn.ch>
References: <20201119152246.085514e1@bootlin.com>
 <20201119145500.GL1551@shell.armlinux.org.uk>
 <20201119162451.4c8d220d@bootlin.com>
 <87k0uh9dd0.fsf@waldekranz.com>
 <20201119231613.GN1551@shell.armlinux.org.uk>
 <87eekoanvj.fsf@waldekranz.com>
 <20201120103601.313a166b@bootlin.com>
 <20201120102538.GP1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120102538.GP1551@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 10:25:38AM +0000, Russell King - ARM Linux admin wrote:
> On Fri, Nov 20, 2020 at 10:36:01AM +0100, Maxime Chevallier wrote:
> > So maybe we could be a bit more generic, with something along these lines :
> > 
> >     ethernet-phy@0 {
> >         ...
> > 
> >         mdi {
> >             port@0 {
> >                 media = "10baseT", "100baseT", "1000baseT";
> >                 pairs = <1>;
> > 	    };
> > 
> >             port@1 {
> >                 media = "1000baseX", "10gbaseR"
> >             };
> >         };
> >     };
> 
> Don't forget that TP requires a minimum of two pairs.

Hi Russell

Well, actually, there are automotive PHYs which use just one pair, so
called T1 PHYs. We have drivers for i think two so far, with one more
on the way.

You also have to watch out for 'clever' PHYs. The Aquantia PHY can do
1000Base-T2, i.e. 1G over two pairs. This might be a proprietary
extension, rather than standardized, but it shows it can be done. So
you have to be careful about assumptions based on the number of pairs.

    Andrew
