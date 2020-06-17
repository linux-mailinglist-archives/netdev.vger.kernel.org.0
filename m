Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8A61FD3B7
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 19:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgFQRtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 13:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgFQRtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 13:49:35 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A44C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 10:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=xL3Ri7/fnlQ6mXSPI64TxQd77LmoQkjXMFiO++jtms8=; b=WGvek6gZLlDRG8WODAvnXJ/gj
        vejMUg1KgCQQFWYi02L5FY4YvEFlIxnvAtXVxw+s7PYKwCK+3zgHIRxkT+SuSZ7gUyoe94LvYx1IO
        vGDHoRgadhlC91N/xY6UdNc/EJuj1hiTWhqkQgYD5oN/eDMAQfIydpq1fNmciZNtQRpsGr/Yzvw7J
        zXfDQDSACR9tDeYBNs/WmRpMiRJcDJ3BH+jyy33wepKhWEdHTC5RLlrD1+/Z13gu5xqlQGgV6Tlxs
        OZVRPlzvZ0enOqqeZRYU89ZicAMAp1q0eB8jBrO/QgIJT06pZpxY0Y9i7ES57hi/gk2tJ3LHQmQDV
        6j0NTx3RQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58572)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jlcBn-0003xe-VJ; Wed, 17 Jun 2020 18:49:31 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jlcBn-0003vD-3O; Wed, 17 Jun 2020 18:49:31 +0100
Date:   Wed, 17 Jun 2020 18:49:31 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>, Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, linux.cj@gmail.com
Subject: Re: [PATCH v1 2/3] net/fsl: acpize xgmac_mdio
Message-ID: <20200617174930.GU1551@shell.armlinux.org.uk>
References: <20200617171536.12014-1-calvin.johnson@oss.nxp.com>
 <20200617171536.12014-3-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617171536.12014-3-calvin.johnson@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 10:45:34PM +0530, Calvin Johnson wrote:
> From: Jeremy Linton <jeremy.linton@arm.com>
> 
> Add ACPI support for xgmac MDIO bus registration while maintaining
> the existing DT support.
> 
> The function mdiobus_register() inside of_mdiobus_register(), brings
> up all the PHYs on the mdio bus and attach them to the bus.
> 
> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
> 
>  drivers/net/ethernet/freescale/xgmac_mdio.c | 27 +++++++++++++--------
>  1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
> index c82c85ef5fb3..fb7f8caff643 100644
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

I think, as you're completely rewriting the resource handling, it would
be a good idea to switch over to using devm_* stuff here.

	void __iomem *regs;

	regs = devm_platform_ioremap_resource(pdev, 0);
	if (IS_ERR(regs)) {
		dev_err(&pdev->dev, "could not map resource: %pe\n",
			regs);
		return PTR_ERR(regs);
	}

This also gets rid of the error checking on priv->mdio_base below, and
of course the unmap/resource handling for priv->mdio_base in the error
paths and device removal paths.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
