Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C97B9203802
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbgFVN3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728154AbgFVN3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 09:29:37 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9F9C061573;
        Mon, 22 Jun 2020 06:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nHCM22JQl59z7ZLfO6rmd8v+bKCkX31XgxEADbUAxBA=; b=CnAOe8/T/ji69oH9Lh89dfyNT
        r3NVBL5BYf9Z/mWtqcj+TRf/AbPDsi7ayJpvdYUVxM/lvsgPL3fc1ROn1+oE/m78C8PBFFKWoIKc9
        5PUYePvNjb6TeMDFlyFLQpfbmbPnwdoIZr16TGN4aQBHSnm7CDyOJtCAli7FQUVyMWaDgPYs8FKVA
        nCGd2K9JR5Sk7SDWtZKdWNN+kU0nnYrVZ5zWOEX8wcRfFDZ8uiG9kB/x34FkO8nssamRde/gBYXtB
        Nm5JQ9qIN8aTtYQKbE+ew6OEyjvu6FvJexuCSZdgZqqzR1AoKXX9XFSnoYUlah8KVn33yAu0PYX08
        YlGLAxqTQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58966)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jnMVn-0000Gz-28; Mon, 22 Jun 2020 14:29:23 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jnMVm-00005c-49; Mon, 22 Jun 2020 14:29:22 +0100
Date:   Mon, 22 Jun 2020 14:29:22 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH 14/15] net: phy: add PHY regulator support
Message-ID: <20200622132921.GI1551@shell.armlinux.org.uk>
References: <20200622093744.13685-1-brgl@bgdev.pl>
 <20200622093744.13685-15-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622093744.13685-15-brgl@bgdev.pl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 11:37:43AM +0200, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> The MDIO sub-system now supports PHY regulators. Let's reuse the code
> to extend this support over to the PHY device.
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>  drivers/net/phy/phy_device.c | 49 ++++++++++++++++++++++++++++--------
>  include/linux/phy.h          | 10 ++++++++
>  2 files changed, 48 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 58923826838b..d755adb748a5 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -827,7 +827,12 @@ int phy_device_register(struct phy_device *phydev)
>  
>  	err = mdiobus_register_device(&phydev->mdio);
>  	if (err)
> -		return err;
> +		goto err_out;
> +
> +	/* Enable the PHY regulator */
> +	err = phy_device_power_on(phydev);
> +	if (err)
> +		goto err_unregister_mdio;
>  
>  	/* Deassert the reset signal */
>  	phy_device_reset(phydev, 0);
> @@ -846,22 +851,25 @@ int phy_device_register(struct phy_device *phydev)
>  	err = phy_scan_fixups(phydev);
>  	if (err) {
>  		phydev_err(phydev, "failed to initialize\n");
> -		goto out;
> +		goto err_reset;
>  	}
>  
>  	err = device_add(&phydev->mdio.dev);
>  	if (err) {
>  		phydev_err(phydev, "failed to add\n");
> -		goto out;
> +		goto err_reset;
>  	}
>  
>  	return 0;
>  
> - out:
> +err_reset:
>  	/* Assert the reset signal */
>  	phy_device_reset(phydev, 1);
> -
> +	/* Disable the PHY regulator */
> +	phy_device_power_off(phydev);
> +err_unregister_mdio:
>  	mdiobus_unregister_device(&phydev->mdio);
> +err_out:
>  	return err;
>  }
>  EXPORT_SYMBOL(phy_device_register);
> @@ -883,6 +891,8 @@ void phy_device_remove(struct phy_device *phydev)
>  
>  	/* Assert the reset signal */
>  	phy_device_reset(phydev, 1);
> +	/* Disable the PHY regulator */
> +	phy_device_power_off(phydev);
>  
>  	mdiobus_unregister_device(&phydev->mdio);
>  }
> @@ -1064,6 +1074,11 @@ int phy_init_hw(struct phy_device *phydev)
>  {
>  	int ret = 0;
>  
> +	/* Enable the PHY regulator */
> +	ret = phy_device_power_on(phydev);
> +	if (ret)
> +		return ret;
> +
>  	/* Deassert the reset signal */
>  	phy_device_reset(phydev, 0);
>  
> @@ -1644,6 +1659,8 @@ void phy_detach(struct phy_device *phydev)
>  
>  	/* Assert the reset signal */
>  	phy_device_reset(phydev, 1);
> +	/* Disable the PHY regulator */
> +	phy_device_power_off(phydev);

This is likely to cause issues for some PHY drivers.  Note that we have
some PHY drivers which register a temperature sensor in the probe
function, which means they can be accessed independently of the lifetime
of the PHY bound to the network driver (which may only be while the
network device is "up".)  We certainly do not want hwmon failing just
because the network device is down.

That's kind of worked around for the reset stuff, because there are two
layers to that: the mdio device layer reset support which knows nothing
of the PHY binding state to the network driver, and the phylib reset
support, but it is not nice.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
