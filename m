Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E58372B29
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 15:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhEDNh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 09:37:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52394 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231159AbhEDNh0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 09:37:26 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ldvDl-002U6k-3Y; Tue, 04 May 2021 15:36:17 +0200
Date:   Tue, 4 May 2021 15:36:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "supporter:OCELOT ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:OCELOT ETHERNET SWITCH DRIVER" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH vN net-next 2/2] net: mscc: ocelot: add support for
 VSC75XX SPI control
Message-ID: <YJFN0dbvQZxkLs88@lunn.ch>
References: <20210504051130.1207550-1-colin.foster@in-advantage.com>
 <20210504051130.1207550-2-colin.foster@in-advantage.com>
 <YJE+prMCIMiQm26Z@lunn.ch>
 <20210504125942.nx5b6j2cy34qyyhm@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210504125942.nx5b6j2cy34qyyhm@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > This function seems out of place. Why would SPI access change what the
> > ports are capable of doing? Please split this up into more
> > patches. Keep the focus of this patch as being adding SPI support.
> 
> What is going on is that this is just the way in which the drivers are
> structured. Colin is not really "adding SPI support" to any of the
> existing DSA switches that are supported (VSC9953, VSC9959) as much as
> "adding support for a new switch which happens to be controlled over
> SPI" (VSC7512).
> The layering is as follows:
> - drivers/net/dsa/ocelot/felix_vsc7512_spi.c: deals with the most
>   hardware specific SoC support. The regmap is defined here, so are the
>   port capabilities.
> - drivers/net/dsa/ocelot/felix.c: common integration with DSA
> - drivers/net/ethernet/mscc/ocelot*.c: the SoC-independent hardware
>   support.

Hi Vladimir

I took a quick look at the data sheet. It says in section 2.1.5
Management:

  External access to registers through PCIe, SPI, MIIM, or through an
  Ethernet port with inline Microsemi’s Versatile Register Access
  Protocol (VRAP)

So maybe the basic 7512 support should be separate from how you access
the registers, so that somebody can later add MMIO or MDIO support?

    Andrew

P.S.

I did not know about VRAP. Marvell has something similar. It would be
nice to put together some shared generic code to support
this. Statistics would really benefit from it.
