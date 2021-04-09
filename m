Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D70B35A7A5
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 22:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbhDIUKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 16:10:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43232 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhDIUKx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 16:10:53 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lUxSg-00FrJK-EK; Fri, 09 Apr 2021 22:10:38 +0200
Date:   Fri, 9 Apr 2021 22:10:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sander Vanheule <sander@svanheule.net>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>, bert@biot.com
Subject: Re: [RFC PATCH 0/2] MIIM regmap and RTL8231 GPIO expander support
Message-ID: <YHC0vh/4O5Zm9+vO@lunn.ch>
References: <cover.1617914861.git.sander@svanheule.net>
 <YG+BObnBEOZnoJ1K@lunn.ch>
 <d73a44809c96abd0397474c63219a41e28f78235.camel@svanheule.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d73a44809c96abd0397474c63219a41e28f78235.camel@svanheule.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 07:42:32AM +0200, Sander Vanheule wrote:
> Hi Andrew,
> 
> Thank you for the feedback. You can find a (leaked) datasheet at:
> https://github.com/libc0607/Realtek_switch_hacking/blob/files/RTL8231_Datasheet_1.2.pdf

So this is not really an MFD. It has different ways of making use of
pins, which could be used for GPIO, but can also be used for LEDs. You
could look if it better fits in drivers/leds. But you can also use
GPIO drivers for LEDs via led-gpio.

> > I don't understand this split. Why not
> > 
> >      mdio-bus {
> >          compatible = "vendor,mdio";
> >          ...
> >  
> >          expander0: expander@0 {
> >              /*
> >               * Provide compatible for working registration of mdio
> > device.
> >               * Device probing happens in gpio1 node.
> >               */
> >              compatible = "realtek,rtl8231-expander";
> >              reg = <0>;
> >              gpio-controller;
> >          };
> >      };
> > 
> > You can list whatever properties you need in the node. Ethernet
> > switches have interrupt-controller, embedded MDIO busses with PHYs on
> > them etc.
> 
> This is what I tried initially, but it doesn't seem to work. The node
> is probably still added as an MDIO device, but rtl8231_gpio_probe()
> doesn't appear to get called at all. I do agree it would be preferable
> over the split specification.

Look at drivers/net/dsa/mv88e6xxx/chip.c for how to register an mdio
driver. If you still cannot get it to work, post your code and i will
take a look.

     Andrew
