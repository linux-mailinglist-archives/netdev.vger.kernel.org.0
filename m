Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C561FD3AD
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 19:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgFQRo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 13:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgFQRo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 13:44:57 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67FD3C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 10:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sP4esYTCr2LhkSIzZcK1ak7EiITZvWXf0AVx4fvIvzk=; b=uNJpwC8wb3tK1sNw/tWPixZdf
        1rNjWEdAPu+vq9DSHt3VEJKQx4YZxjjgaGMMEkPvSjSS393S9pqWcg5Bdk3rC4e0uPl1BJB6XUibF
        YXKN7p7JlPSJDGceqJH1hbdFrdmYuE/E6LLy3GM/XAAj06Cj1OxktvIbML/VBL5Vrfeyd2UsiMj+c
        EP7Mwq0AsghYraRHQZQXGbh/5cYrWku/74Xh/KWe0vuItxk1cwMXVbQu2MtQjZDar1jsQzgm8cZPF
        +5+c2hb+QXW+poHu1mz3Ssefzaxa+QhejJf3W/uu7+JLDiWdTEesWmQ7SkAaYMRd/JMB1seg90jsa
        f1cb6uEHA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58570)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jlc7I-0003xQ-G0; Wed, 17 Jun 2020 18:44:52 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jlc7H-0003v4-Cj; Wed, 17 Jun 2020 18:44:51 +0100
Date:   Wed, 17 Jun 2020 18:44:51 +0100
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
Subject: Re: [PATCH v1 1/3] net: phy: Allow mdio buses to auto-probe c45
 devices
Message-ID: <20200617174451.GT1551@shell.armlinux.org.uk>
References: <20200617171536.12014-1-calvin.johnson@oss.nxp.com>
 <20200617171536.12014-2-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617171536.12014-2-calvin.johnson@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 10:45:33PM +0530, Calvin Johnson wrote:
> From: Jeremy Linton <jeremy.linton@arm.com>
> 
> The mdiobus_scan logic is currently hardcoded to only
> work with c22 devices. This works fairly well in most
> cases, but its possible a c45 device doesn't respond
> despite being a standard phy. If the parent hardware
> is capable, it makes sense to scan for c22 devices before
> falling back to c45.
> 
> As we want this to reflect the capabilities of the STA,
> lets add a field to the mii_bus structure to represent
> the capability. That way devices can opt into the extended
> scanning. Existing users should continue to default to c22
> only scanning as long as they are zero'ing the structure
> before use.
> 
> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

I know that we've hashed this out quite a bit already, but I would like
to point out that include/linux/mdio.h contains:

 * struct mdio_if_info - Ethernet controller MDIO interface
 * @mode_support: MDIO modes supported.  If %MDIO_SUPPORTS_C22 is set then
 *      MII register access will be passed through with @devad =
 *      %MDIO_DEVAD_NONE.  If %MDIO_EMULATE_C22 is set then access to
 *      commonly used clause 22 registers will be translated into
 *      clause 45 registers.

#define MDIO_SUPPORTS_C22               1
#define MDIO_SUPPORTS_C45               2
#define MDIO_EMULATE_C22                4

While this structure is not applicable to phylib or mii_bus, it may be
worth considering that there already exist definitions for identifying
the properties of the underlying bus.

> ---
> 
>  drivers/net/phy/mdio_bus.c | 17 +++++++++++++++--
>  include/linux/phy.h        |  7 +++++++
>  2 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 6ceee82b2839..e6c179b89907 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -739,10 +739,23 @@ EXPORT_SYMBOL(mdiobus_free);
>   */
>  struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr)
>  {
> -	struct phy_device *phydev;
> +	struct phy_device *phydev = ERR_PTR(-ENODEV);
>  	int err;
>  
> -	phydev = get_phy_device(bus, addr, false);
> +	switch (bus->probe_capabilities) {
> +	case MDIOBUS_C22:
> +		phydev = get_phy_device(bus, addr, false);
> +		break;
> +	case MDIOBUS_C45:
> +		phydev = get_phy_device(bus, addr, true);
> +		break;
> +	case MDIOBUS_C22_C45:
> +		phydev = get_phy_device(bus, addr, false);
> +		if (IS_ERR(phydev))
> +			phydev = get_phy_device(bus, addr, true);
> +		break;
> +	}
> +
>  	if (IS_ERR(phydev))
>  		return phydev;
>  
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 9248dd2ce4ca..50e5312b2304 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -298,6 +298,13 @@ struct mii_bus {
>  	/* RESET GPIO descriptor pointer */
>  	struct gpio_desc *reset_gpiod;
>  
> +	/* bus capabilities, used for probing */
> +	enum {
> +		MDIOBUS_C22 = 0,
> +		MDIOBUS_C45,
> +		MDIOBUS_C22_C45,
> +	} probe_capabilities;

I think it would be better to reserve "0" to mean that no capabilities
have been declared.  We hae the situation where we have mii_bus that
exist which do support C45, but as they stand, probe_capabilities will
be zero, and with your definitions above, that means MDIOBUS_C22.

It seems this could lock in some potential issues later down the line
if we want to use this elsewhere.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
