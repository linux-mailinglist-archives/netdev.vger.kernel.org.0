Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF95D33A93C
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 02:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhCOBJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 21:09:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56112 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229476AbhCOBJL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Mar 2021 21:09:11 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lLbjB-00AyVG-Mg; Mon, 15 Mar 2021 02:09:01 +0100
Date:   Mon, 15 Mar 2021 02:09:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 2/2] net: macb: Disable PCS auto-negotiation for
 SGMII fixed-link mode
Message-ID: <YE6zrUufDhOp31SJ@lunn.ch>
References: <20210311201813.3804249-1-robert.hancock@calian.com>
 <20210311201813.3804249-3-robert.hancock@calian.com>
 <YEwZOKNaKegMCyGv@lunn.ch>
 <e2a5ec71e9897eedd8a826ca75f71a721425f4c7.camel@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2a5ec71e9897eedd8a826ca75f71a721425f4c7.camel@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 14, 2021 at 11:22:03PM +0000, Robert Hancock wrote:
> On Sat, 2021-03-13 at 02:45 +0100, Andrew Lunn wrote:
> > On Thu, Mar 11, 2021 at 02:18:13PM -0600, Robert Hancock wrote:
> > > When using a fixed-link configuration in SGMII mode, it's not really
> > > sensible to have auto-negotiation enabled since the link settings are
> > > fixed by definition. In other configurations, such as an SGMII
> > > connection to a PHY, it should generally be enabled.
> > 
> > So how do you tell the PCS it should be doing 10Mbps over the SGMII
> > link? I'm assuming it is the PCS which does the bit replication, not
> > the MAC?
> 
> I'm not sure if this is the same for all devices using this Cadence IP, but the
> register documentation I have for the Xilinx UltraScale+ MPSoC we are using
> indicates this PCS is only capable of 1000 Mbps speeds:
> 
> https://www.xilinx.com/html_docs/registers/ug1087/gem___pcs_control.html
> 
> So it doesn't actually seem applicable in this case.
> 
> > 
> > I'm surprised you are even using SGMII with a fixed link. 1000BaseX is
> > the norm, and then you don't need to worry about the speed.
> > 
> 
> That would be a bit simpler, yes - but it seems like this hardware is set up
> more for SGMII mode - it's not entirely clear to me that 1000BaseX is supported
> in the hardware, and it's not currently supported in the driver that I can see.

This hardware just seems odd. If it was not for the fact the
documentation say SGMII all over the place, i would be temped to say
it is actually doing 1000BaseX.

Assuming the documentation is not totally wrong, your code seems
sensible for the hardware.

	Andrew
