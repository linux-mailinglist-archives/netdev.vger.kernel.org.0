Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981DF27F10B
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 20:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729351AbgI3SHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 14:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbgI3SHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 14:07:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D87C061755;
        Wed, 30 Sep 2020 11:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uShV4aZV0sOQPScv6kvv8M8xF1Pqa9FFraKmruEA5YI=; b=iuAGM7wLs0u/JhRHhU5OKESMA
        CpeXu6cKMr6bL+xEi0wXMyPVsxuAm7eYj3NHm/sGf/NbCZMISdL6CiqrD+TdfHELb/9O0UMgN7FhZ
        OrYYSH+gp34wOpIe+6K+mlgh8iHdfkOn6jUszoiGcviFrAJ+++FHJyBq4YxaGb2ODo/Xe9pertYSN
        /ftJcKPgk6g+QfQC633HHznr5sP3AZcFYlLkUQWLKH0LDRPprUTydKjDt/HL6hPfQrxg7MXYvnU+B
        uiWJqoK2UWR69NbwH5h6UsjvX5HosXE59NiwMQ7OrQJVvDbXWb9vyXjgAi0acdVYsnPyzSTU3RpYv
        beMTQbYgw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40280)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kNgVn-0002zh-7O; Wed, 30 Sep 2020 19:07:31 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kNgVh-0002Kj-KP; Wed, 30 Sep 2020 19:07:25 +0100
Date:   Wed, 30 Sep 2020 19:07:25 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v1 3/7] net: phy: Introduce fwnode_get_phy_id()
Message-ID: <20200930180725.GE1551@shell.armlinux.org.uk>
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
 <20200930160430.7908-4-calvin.johnson@oss.nxp.com>
 <20200930163440.GR3996795@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930163440.GR3996795@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 06:34:40PM +0200, Andrew Lunn wrote:
> > @@ -2866,7 +2888,15 @@ EXPORT_SYMBOL_GPL(device_phy_find_device);
> >   */
> >  struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
> >  {
> > -	return fwnode_find_reference(fwnode, "phy-handle", 0);
> > +	struct fwnode_handle *phy_node;
> > +
> > +	phy_node = fwnode_find_reference(fwnode, "phy-handle", 0);
> > +	if (is_acpi_node(fwnode) || !IS_ERR(phy_node))
> > +		return phy_node;
> > +	phy_node = fwnode_find_reference(fwnode, "phy", 0);
> > +	if (IS_ERR(phy_node))
> > +		phy_node = fwnode_find_reference(fwnode, "phy-device", 0);
> > +	return phy_node;
> 
> Why do you have three different ways to reference a PHY?

Compatibility with the DT version - note that "phy" and "phy-device"
are only used for non-ACPI fwnodes. This should allow us to convert
drivers where necessary without fear of causing DT regressions.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
