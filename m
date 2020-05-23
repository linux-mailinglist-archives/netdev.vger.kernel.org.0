Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE131DFA5D
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 20:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387569AbgEWSso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 14:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbgEWSso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 14:48:44 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5C8C061A0E;
        Sat, 23 May 2020 11:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=MExD8EvnERDLrOwxj63NVqjFoSK5y3DVkOPyC697E54=; b=DRjiCKzKRinpBcI+2GZD0BHRj
        gq21xR43KOb+37XVRi1mvRLs9tHBv0gHXNZGxF1cGX6TrMi3TnJZJPPVAtb0spgLTVRLTBr8tQtml
        AKR+q/FV24zbqfnn5rWjP/xTKPLGsj7h3d7f6qeBb3GDW9PoEfnGVsCLwOKsN6p24G81d6XLyChT3
        tfujlqQmrL3SC0nmR5Lg8MPGkyf/CeukMXDJD7JdJjykpYd+5Mu53aJJX//LWidrCb83NS85zcygc
        xGY8r9fWYr6Ia9vLW9LbCG1/RjbIKLpXn4HU6ESaCl7vR6nmLVkDUvnCZyIaTw7QhLPMUqmzJ1zIn
        PIu+tlTOw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:44096)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jcZCH-0000Vi-28; Sat, 23 May 2020 19:48:37 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jcZCF-0002Ui-U1; Sat, 23 May 2020 19:48:35 +0100
Date:   Sat, 23 May 2020 19:48:35 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 10/11] net: example acpize xgmac_mdio
Message-ID: <20200523184835.GB1551@shell.armlinux.org.uk>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-11-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522213059.1535892-11-jeremy.linton@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 04:30:58PM -0500, Jeremy Linton wrote:
> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> ---
>  drivers/net/ethernet/freescale/xgmac_mdio.c | 27 +++++++++++++--------
>  1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
> index c82c85ef5fb3..96ee3bd89983 100644
> --- a/drivers/net/ethernet/freescale/xgmac_mdio.c
> +++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
> @@ -245,14 +245,14 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
>  {
>  	struct device_node *np = pdev->dev.of_node;
>  	struct mii_bus *bus;
> -	struct resource res;
> +	struct resource *res;
>  	struct mdio_fsl_priv *priv;
>  	int ret;
>  
> -	ret = of_address_to_resource(np, 0, &res);
> -	if (ret) {
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
>  		dev_err(&pdev->dev, "could not obtain address\n");
> -		return ret;
> +		return -EINVAL;
>  	}
>  
>  	bus = mdiobus_alloc_size(sizeof(struct mdio_fsl_priv));
> @@ -263,21 +263,21 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
>  	bus->read = xgmac_mdio_read;
>  	bus->write = xgmac_mdio_write;
>  	bus->parent = &pdev->dev;
> -	snprintf(bus->id, MII_BUS_ID_SIZE, "%llx", (unsigned long long)res.start);
> +	snprintf(bus->id, MII_BUS_ID_SIZE, "%llx", (unsigned long long)res->start);
>  
>  	/* Set the PHY base address */
>  	priv = bus->priv;
> -	priv->mdio_base = of_iomap(np, 0);
> +	priv->mdio_base = devm_platform_ioremap_resource(pdev, 0);
>  	if (!priv->mdio_base) {

I think you need to pay greater attention to the return value of
functions - this is one such case, where
devm_platform_ioremap_resource() does not return NULL on failure.
It uses devm_ioremap_resource(), which is documented in lib/devres.c
to return an error-pointer on failure.

>  		ret = -ENOMEM;
>  		goto err_ioremap;
>  	}
>  
> -	priv->is_little_endian = of_property_read_bool(pdev->dev.of_node,
> -						       "little-endian");
> +	priv->is_little_endian = device_property_read_bool(&pdev->dev,
> +							   "little-endian");
>  
> -	priv->has_a011043 = of_property_read_bool(pdev->dev.of_node,
> -						  "fsl,erratum-a011043");
> +	priv->has_a011043 = device_property_read_bool(&pdev->dev,
> +						      "fsl,erratum-a011043");
>  
>  	ret = of_mdiobus_register(bus, np);
>  	if (ret) {
> @@ -320,10 +320,17 @@ static const struct of_device_id xgmac_mdio_match[] = {
>  };
>  MODULE_DEVICE_TABLE(of, xgmac_mdio_match);
>  
> +static const struct acpi_device_id xgmac_acpi_match[] = {
> +	{ "NXP0006", (kernel_ulong_t)NULL },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(acpi, xgmac_acpi_match);
> +
>  static struct platform_driver xgmac_mdio_driver = {
>  	.driver = {
>  		.name = "fsl-fman_xmdio",
>  		.of_match_table = xgmac_mdio_match,
> +		.acpi_match_table = xgmac_acpi_match,
>  	},
>  	.probe = xgmac_mdio_probe,
>  	.remove = xgmac_mdio_remove,
> -- 
> 2.26.2
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
