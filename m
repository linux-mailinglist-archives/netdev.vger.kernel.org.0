Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4D3A174E97
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 17:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgCAQuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 11:50:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40488 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725945AbgCAQuX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 11:50:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AGfy1w0+4VKRX6In5CqQMtisuSIfijuxb2F01OkPP90=; b=Mxb/3CfW2heID9WUBvuOk9XU5i
        RTWwNhlc0i1U1nU3eUWylEkSYrYiczhen+DWhGibaKDERGQm+pLXaT30U9X0AFsRz4zMipqRQMqLe
        5T21E9QWAxKNR0//oNJjXmBR56vwclTVJ5/DeWkv66RUTzJ5CFyZakk5QsM2yT61k7f0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j8RnG-0008J1-KB; Sun, 01 Mar 2020 17:50:18 +0100
Date:   Sun, 1 Mar 2020 17:50:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dajun Jin <adajunjin@gmail.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, robh+dt@kernel.org,
        frowand.list@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] drivers/of/of_mdio.c:fix of_mdiobus_register()
Message-ID: <20200301165018.GN6305@lunn.ch>
References: <20200301164138.8542-1-adajunjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200301164138.8542-1-adajunjin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 02, 2020 at 12:41:38AM +0800, Dajun Jin wrote:
> when registers a phy_device successful, should terminate the loop
> or the phy_device would be registered in other addr.
> 
> Signed-off-by: Dajun Jin <adajunjin@gmail.com>
> ---
>  drivers/of/of_mdio.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
> index 8270bbf505fb..9f982c0627a0 100644
> --- a/drivers/of/of_mdio.c
> +++ b/drivers/of/of_mdio.c
> @@ -306,6 +306,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
>  				rc = of_mdiobus_register_phy(mdio, child, addr);
>  				if (rc && rc != -ENODEV)
>  					goto unregister;
> +				break;
>  			}
>  		}
>  	}

Hi Dajun

What problem are you seeing? You explanation needs to be better.

I'm guessing you have two or more PHYs on the bus, without reg
properties?

	Andrew
