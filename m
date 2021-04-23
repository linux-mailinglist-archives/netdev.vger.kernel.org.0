Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F78636924E
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 14:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242326AbhDWMmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 08:42:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37902 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhDWMmp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 08:42:45 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lZv8H-000eQR-55; Fri, 23 Apr 2021 14:42:05 +0200
Date:   Fri, 23 Apr 2021 14:42:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/14] drivers: net: dsa: qca8k: add support for qca8327
 switch
Message-ID: <YILAnViiXnMdCJNv@lunn.ch>
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
 <20210423014741.11858-6-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210423014741.11858-6-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -1467,11 +1468,16 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
>  		gpiod_set_value_cansleep(priv->reset_gpio, 0);
>  	}
>  
> +	/* get the switches ID from the compatible */
> +	data = of_device_get_match_data(&mdiodev->dev);
> +	if (!data)
> +		return -ENODEV;
> +
>  	/* read the switches ID register */
>  	id = qca8k_read(priv, QCA8K_REG_MASK_CTRL);
>  	id >>= QCA8K_MASK_CTRL_ID_S;
>  	id &= QCA8K_MASK_CTRL_ID_M;
> -	if (id != QCA8K_ID_QCA8337)
> +	if (id != data->id)
>  		return -ENODEV;

It is useful to print an error message here: Found X, expected
Y. Gives the DT writer an idea what they did wrong.

   Andrew
