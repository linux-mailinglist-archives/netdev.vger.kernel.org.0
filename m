Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC6B313B47
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235055AbhBHRoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:44:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234958AbhBHRms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 12:42:48 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FCABC061793;
        Mon,  8 Feb 2021 09:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rSvUqI1XpEJ7iOVNKklLJYoFPByM1N15BVSh8fTJEs4=; b=YP5IJV54bH0CVu7bFAy4QFDd6
        L/8EWZvKtF6hlcGGoWvEfzAGpUGMm+SB7k04JMz9qOyr5Rb16758zcs5ohXwJ+ozP6oE0CXcJLeJ7
        XVs3JVcHjgmo3we123AbijWApG4b5ndwjDtF7SP+X+lPlpLLZS5Jw00qNIF/5nENMNLJ2YwNwdMQf
        V09DaW714TEgEmrv61HaZFGtpTlYiTR4Nf5477cKFkxJR/R8xM1zRUGa1BYMbSF+w98BDf1/0lfFw
        Q7Xk4dbu7+49dAItkuS05nCI3PhruFP9DWviRT4Efh5JXfa5UzpHTa/PRCNayz+x8o5g13j8c03bT
        YuyjonbeA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40850)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l9AWH-0002M7-MZ; Mon, 08 Feb 2021 17:40:17 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l9AWD-0003FA-S0; Mon, 08 Feb 2021 17:40:13 +0000
Date:   Mon, 8 Feb 2021 17:40:13 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux.cj@gmail.com, Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: Re: [net-next PATCH v5 07/15] net: mdiobus: Introduce
 fwnode_mdiobus_register_phy()
Message-ID: <20210208174013.GN1463@shell.armlinux.org.uk>
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
 <20210208151244.16338-8-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208151244.16338-8-calvin.johnson@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 08:42:36PM +0530, Calvin Johnson wrote:
> +int fwnode_mdiobus_register_phy(struct mii_bus *bus,
> +				struct fwnode_handle *child, u32 addr)
> +{
> +	struct mii_timestamper *mii_ts;

If you initialise this to NULL...

> +	struct phy_device *phy;
> +	bool is_c45 = false;
> +	u32 phy_id;
> +	int rc;
> +
> +	if (is_of_node(child)) {
> +		mii_ts = of_find_mii_timestamper(to_of_node(child));
> +		if (IS_ERR(mii_ts))
> +			return PTR_ERR(mii_ts);
> +	}
> +
> +	rc = fwnode_property_match_string(child, "compatible", "ethernet-phy-ieee802.3-c45");
> +	if (rc >= 0)
> +		is_c45 = true;
> +
> +	if (is_c45 || fwnode_get_phy_id(child, &phy_id))
> +		phy = get_phy_device(bus, addr, is_c45);
> +	else
> +		phy = phy_device_create(bus, addr, phy_id, 0, NULL);
> +	if (IS_ERR(phy)) {
> +		if (mii_ts && is_of_node(child))

Then you don't need is_of_node() here.

> +		/* phy->mii_ts may already be defined by the PHY driver. A
> +		 * mii_timestamper probed via the device tree will still have
> +		 * precedence.
> +		 */
> +		if (mii_ts)
> +			phy->mii_ts = mii_ts;

Should this be moved out of the if() case?

I'm thinking of the future where we may end up adding mii timestamper
support for ACPI.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
