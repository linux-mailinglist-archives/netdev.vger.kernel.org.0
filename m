Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E7F4538A0
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 18:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238944AbhKPRjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 12:39:37 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:47763 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbhKPRjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 12:39:36 -0500
Received: (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 67A7560011;
        Tue, 16 Nov 2021 17:36:34 +0000 (UTC)
Date:   Tue, 16 Nov 2021 18:36:33 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Colin Foster <colin.foster@in-advantage.com>,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
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
Subject: Re: [RFC PATCH v4 net-next 11/23] pinctrl: ocelot: update pinctrl to
 automatic base address
Message-ID: <YZPsIW2bfbBThtWj@piout.net>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
 <20211116062328.1949151-12-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211116062328.1949151-12-colin.foster@in-advantage.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 15/11/2021 22:23:16-0800, Colin Foster wrote:
> struct gpio_chip recommends passing -1 as base to gpiolib. Doing so avoids
> conflicts when the chip is external and gpiochip0 already exists.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
>  drivers/pinctrl/pinctrl-ocelot.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
> index cc7fb0556169..f015404c425c 100644
> --- a/drivers/pinctrl/pinctrl-ocelot.c
> +++ b/drivers/pinctrl/pinctrl-ocelot.c
> @@ -1308,7 +1308,7 @@ static int ocelot_gpiochip_register(struct platform_device *pdev,
>  	gc = &info->gpio_chip;
>  	gc->ngpio = info->desc->npins;
>  	gc->parent = &pdev->dev;
> -	gc->base = 0;
> +	gc->base = -1;

I can't remember why but I'm pretty sure I did that on purpose but this
indeed cause issues when the chip is external. I've asked Clément to
check, let's see what the result is ;)

>  	gc->of_node = info->dev->of_node;
>  	gc->label = "ocelot-gpio";
>  
> -- 
> 2.25.1
> 

-- 
Alexandre Belloni, co-owner and COO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
