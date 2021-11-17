Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826524547B4
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 14:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237864AbhKQNuN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Nov 2021 08:50:13 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:39405 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233591AbhKQNuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 08:50:12 -0500
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id D910C20000B;
        Wed, 17 Nov 2021 13:47:05 +0000 (UTC)
Date:   Wed, 17 Nov 2021 14:47:05 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [RFC PATCH v4 net-next 11/23] pinctrl: ocelot: update pinctrl
 to automatic base address
Message-ID: <20211117144705.24f21ef1@fixe.home>
In-Reply-To: <YZPsIW2bfbBThtWj@piout.net>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
        <20211116062328.1949151-12-colin.foster@in-advantage.com>
        <YZPsIW2bfbBThtWj@piout.net>
Organization: Bootlin
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Tue, 16 Nov 2021 18:36:33 +0100,
Alexandre Belloni <alexandre.belloni@bootlin.com> a écrit :

> Hello,
> 
> On 15/11/2021 22:23:16-0800, Colin Foster wrote:
> > struct gpio_chip recommends passing -1 as base to gpiolib. Doing so avoids
> > conflicts when the chip is external and gpiochip0 already exists.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> >  drivers/pinctrl/pinctrl-ocelot.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
> > index cc7fb0556169..f015404c425c 100644
> > --- a/drivers/pinctrl/pinctrl-ocelot.c
> > +++ b/drivers/pinctrl/pinctrl-ocelot.c
> > @@ -1308,7 +1308,7 @@ static int ocelot_gpiochip_register(struct platform_device *pdev,
> >  	gc = &info->gpio_chip;
> >  	gc->ngpio = info->desc->npins;
> >  	gc->parent = &pdev->dev;
> > -	gc->base = 0;
> > +	gc->base = -1;  
> 
> I can't remember why but I'm pretty sure I did that on purpose but this
> indeed cause issues when the chip is external. I've asked Clément to
> check, let's see what the result is ;)

After testing, it works on ocelot pcb123 board.

Tested-by: Clément Léger <clement.leger@bootlin.com>

> 
> >  	gc->of_node = info->dev->of_node;
> >  	gc->label = "ocelot-gpio";
> >  
> > -- 
> > 2.25.1
> >   
> 



-- 
Clément Léger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
