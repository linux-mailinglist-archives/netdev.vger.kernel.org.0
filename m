Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA79E353465
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 16:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbhDCO4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 10:56:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:32812 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236364AbhDCOz5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Apr 2021 10:55:57 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lShgh-00Ee3U-Vd; Sat, 03 Apr 2021 16:55:47 +0200
Date:   Sat, 3 Apr 2021 16:55:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next v1 3/9] net: dsa: qca: ar9331: reorder MDIO
 write sequence
Message-ID: <YGiB88Z7zc2h+e6u@lunn.ch>
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
 <20210403114848.30528-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210403114848.30528-4-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij

Maybe add a short comment about why the order is important.

> -	ret = __ar9331_mdio_write(sbus, AR9331_SW_MDIO_PHY_MODE_REG, reg, val);
> +	ret = __ar9331_mdio_write(sbus, AR9331_SW_MDIO_PHY_MODE_REG, reg + 2,
> +				  val >> 16);
>  	if (ret < 0)
>  		goto error;
>  
> -	ret = __ar9331_mdio_write(sbus, AR9331_SW_MDIO_PHY_MODE_REG, reg + 2,
> -				  val >> 16);
> +	ret = __ar9331_mdio_write(sbus, AR9331_SW_MDIO_PHY_MODE_REG, reg, val);
>  	if (ret < 0)
>  		goto error;
>  
>  	return 0;
> +
>  error:
>  	dev_err_ratelimited(&sbus->dev, "Bus error. Failed to write register.\n");
>  	return ret;

With that:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew





> -- 
> 2.29.2
> 
