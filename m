Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F8B2311F0
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 20:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732495AbgG1Srf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 14:47:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60436 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729190AbgG1Sre (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 14:47:34 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k0UdQ-007K4q-6m; Tue, 28 Jul 2020 20:47:32 +0200
Date:   Tue, 28 Jul 2020 20:47:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Bruno Thomsen <bruno.thomsen@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lars Alex Pedersen <laa@kamstrup.com>,
        Bruno Thomsen <bth@kamstrup.com>
Subject: Re: [PATCH 1/2] net: mdiobus: reset deassert delay
Message-ID: <20200728184732.GB1745134@lunn.ch>
References: <20200728090203.17313-1-bruno.thomsen@gmail.com>
 <CAOMZO5D3Hiybr8dPv2LZFrqp23=N1UGiy9Qea74ZSThoZALMbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5D3Hiybr8dPv2LZFrqp23=N1UGiy9Qea74ZSThoZALMbQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 09:32:03AM -0300, Fabio Estevam wrote:

> > Signed-off-by: Bruno Thomsen <bruno.thomsen@gmail.com>
> > ---
> >  drivers/net/phy/mdio_bus.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> > index 6ceee82b2839..84d5ab07fe16 100644
> > --- a/drivers/net/phy/mdio_bus.c
> > +++ b/drivers/net/phy/mdio_bus.c
> > @@ -627,8 +627,9 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
> >                 bus->reset_gpiod = gpiod;
> >
> >                 gpiod_set_value_cansleep(gpiod, 1);
> > -               udelay(bus->reset_delay_us);
> > +               fsleep(bus->reset_delay_us);
> >                 gpiod_set_value_cansleep(gpiod, 0);
> > +               fsleep(bus->reset_delay_us);
> 

> Shouldn't it use the value passed in the reset-deassert-us property
> instead?

Hi Fabio

As Bruno pointed out, that property is not relevant here. But i agree
with you in principle. Bruno, please add a new optional property for
the delay after releasing the reset.

     Andrew
