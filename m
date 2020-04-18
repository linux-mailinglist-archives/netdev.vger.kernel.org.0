Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEFF1AEC1C
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 13:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbgDRLle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 07:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725826AbgDRLle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 07:41:34 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0ED1C061A0C;
        Sat, 18 Apr 2020 04:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=f0yHxPnJ4f0dB3+aObaskVJwqP9Vh3YSIkWQwfwhGfY=; b=nAUQPpYPImHaOkKUw8FoF83Mh
        UeQPgLagCtSswt3JODiv30UXzLVtA1mLDzsumB09CfWIGMItowEg8dGwHxoBsEdnbK0RkWTR6hqpu
        rkonsHEFM/EZIr++vc7Veu5fWAQgRt1jweHDBE87ZsEnH3GL3tafalW3AhXshpgjh8ETeuJWl9XfL
        Y4MOnqOB9FNkf7N2PtpYNnzYAdJb0kNNq8SJCbNhoV8iIeGIGz7V952OXpf1Q2cnZWhAVmROfh7dF
        A3pED/rVM7Tj6TD81pcG6maoNNvpa3DtlPnFjL9TPeWt2b8wjPYh6gZO58Zi1/AO6N7mONHdW4XeJ
        VHPxZTgeQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:47572)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jPlqX-0007qT-PX; Sat, 18 Apr 2020 12:41:17 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jPlqW-0003qM-3f; Sat, 18 Apr 2020 12:41:16 +0100
Date:   Sat, 18 Apr 2020 12:41:16 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     linux.cj@gmail.com, Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev@vger.kernel.org, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-kernel@vger.kernel.org, Varun Sethi <V.Sethi@nxp.com>,
        Marcin Wojtas <mw@semihalf.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC net-next PATCH v2 1/2] net/fsl: add ACPI support for mdio
 bus
Message-ID: <20200418114116.GU25745@shell.armlinux.org.uk>
References: <20200418105432.11233-1-calvin.johnson@oss.nxp.com>
 <20200418105432.11233-2-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200418105432.11233-2-calvin.johnson@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 18, 2020 at 04:24:31PM +0530, Calvin Johnson wrote:
> @@ -241,18 +244,81 @@ static int xgmac_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
>  	return value;
>  }
>  
> +/* Extract the clause 22 phy ID from the compatible string of the form
> + * ethernet-phy-idAAAA.BBBB

This comment is incorrect.  What about clause 45 PHYs?

> + */
> +static int xgmac_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id)
> +{
> +	const char *cp;
> +	unsigned int upper, lower;
> +	int ret;
> +
> +	ret = fwnode_property_read_string(fwnode, "compatible", &cp);
> +	if (!ret) {
> +		if (sscanf(cp, "ethernet-phy-id%4x.%4x",
> +			   &upper, &lower) == 2) {
> +			*phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
> +			return 0;
> +		}
> +	}
> +	return -EINVAL;
> +}
> +
> +static int xgmac_mdiobus_register_phy(struct mii_bus *bus,
> +				      struct fwnode_handle *child, u32 addr)
> +{
> +	struct phy_device *phy;
> +	bool is_c45 = false;
> +	int rc;
> +	const char *cp;
> +	u32 phy_id;
> +
> +	fwnode_property_read_string(child, "compatible", &cp);
> +	if (!strcmp(cp, "ethernet-phy-ieee802.3-c45"))
> +		is_c45 = true;
> +
> +	if (!is_c45 && !xgmac_get_phy_id(child, &phy_id))
> +		phy = phy_device_create(bus, addr, phy_id, 0, NULL);
> +	else
> +		phy = get_phy_device(bus, addr, is_c45);
> +	if (IS_ERR(phy))
> +		return PTR_ERR(phy);
> +
> +	phy->irq = bus->irq[addr];
> +
> +	/* Associate the fwnode with the device structure so it
> +	 * can be looked up later.
> +	 */
> +	phy->mdio.dev.fwnode = child;
> +
> +	/* All data is now stored in the phy struct, so register it */
> +	rc = phy_device_register(phy);
> +	if (rc) {
> +		phy_device_free(phy);
> +		fwnode_handle_put(child);
> +		return rc;
> +	}
> +
> +	dev_dbg(&bus->dev, "registered phy at address %i\n", addr);
> +
> +	return 0;

You seem to be duplicating the OF implementation in a private driver,
converting it to fwnode.  This is not how we develop the Linux kernel.
We fix subsystem problems by fixing the subsystems, not by throwing
what should be subsystem code into private drivers.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
