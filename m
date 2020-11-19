Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA6D2B9406
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 15:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgKSN7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 08:59:12 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38264 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726580AbgKSN7M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 08:59:12 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kfkSr-007wPa-9E; Thu, 19 Nov 2020 14:59:09 +0100
Date:   Thu, 19 Nov 2020 14:59:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <mgr@pengutronix.de>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH 06/11] net: dsa: microchip: ksz8795: use phy_port_cnt
 where possible
Message-ID: <20201119135909.GU1804098@lunn.ch>
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
 <20201118220357.22292-7-m.grzeschik@pengutronix.de>
 <20201119002915.GJ1804098@lunn.ch>
 <20201119084005.GC6507@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119084005.GC6507@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 09:40:05AM +0100, Michael Grzeschik wrote:
> On Thu, Nov 19, 2020 at 01:29:15AM +0100, Andrew Lunn wrote:
> > >  	case BR_STATE_DISABLED:
> > >  		data |= PORT_LEARN_DISABLE;
> > > -		if (port < SWITCH_PORT_NUM)
> > > +		if (port < dev->phy_port_cnt)
> > >  			member = 0;
> > >  		break;
> > 
> > So this, unlike all the other patches so far, is not obviously
> > correct. What exactly does phy_port_cnt mean? Can there be ports
> > without PHYs? What if the PHYs are external? You still need to be able
> > to change the STP state of such ports.
> 
> The variable phy_port_cnt is referring to all external physical
> available ports, that are not connected internally to the cpu.
> 
> That means that the previous code path was already broken, when stp
> handling should include the cpu_port.

So using DSA names, it is the number of user ports. And the assumption
is, the last port is the CPU port.

Please add to the commit message that this patch fixes the code as
well. That sort of comment helps the reviewer understand why it is not
just an obvious mechanical change.

	Andrew
