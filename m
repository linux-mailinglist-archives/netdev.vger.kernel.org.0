Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8558216313
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 02:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgGGAkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 20:40:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50090 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725942AbgGGAkm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 20:40:42 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsbf0-003vqW-Tz; Tue, 07 Jul 2020 02:40:34 +0200
Date:   Tue, 7 Jul 2020 02:40:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Healy <cphealy@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: sfp: Unique GPIO interrupt names
Message-ID: <20200707004034.GA935794@lunn.ch>
References: <CAFXsbZoOoOkgkxXNbG5JTXHdJiSoxu2OiHKHh39m3GfYE2jGcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFXsbZoOoOkgkxXNbG5JTXHdJiSoxu2OiHKHh39m3GfYE2jGcg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index 73c2969f11a4..193a124c26c4 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -2239,6 +2239,7 @@ static int sfp_probe(struct platform_device *pdev)
>      const struct sff_data *sff;
>      struct i2c_adapter *i2c;
>      struct sfp *sfp;
> +    char *sfp_irq_name;
>      int err, i;

Hi Chris

Reverse Christmas tree.

> 
>      sfp = sfp_alloc(&pdev->dev);
> @@ -2349,12 +2350,16 @@ static int sfp_probe(struct platform_device *pdev)
>              continue;
>          }
> 
> +        sfp_irq_name = devm_kasprintf(sfp->dev, GFP_KERNEL,
> +                          "%s-%s", dev_name(sfp->dev),
> +                          gpio_of_names[i]);
> +

Did you run ./scripts/checkpatch.pl on this patch? I suspect it will
complain about spaces, not tabs.

Humm, actually, all tabs seem to of been converted to spaces.

Something David often recommends. email the patch to yourself, and
then apply it using git am. If it does not apply cleanly, something
has mangled it.

    Andrew
