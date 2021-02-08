Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C26313802
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbhBHPf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhBHPcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 10:32:32 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB13C061793;
        Mon,  8 Feb 2021 07:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tdwCgKoyLdHxRuD+Ock+CY1gFHQqJYRvjdWG9ShjOkY=; b=zU/66JgRfM3qSDf+yVQGplFKy
        365CNDWp7LAaZkjasaEkkS9zdxY9mFrU7lvKhaut2GV1Ldn4/Fij0JXoLSfivEaHY9RLDom9KJ3dD
        MA3nRv/2W6bgJRVSxydYqGIjiNQR5Q23I0A91aNIdjgp8TcdQwsFxmWf2l7PMpgPZ0YqZaoAgXA2B
        cpr8PNOGalTRQrkS5nsYuJTuPJDt/PcJoLAx42ZUSBpyVY9im2aHU4b3wjeCPzzcCZpNB2rxJBFfg
        jCTsl0+X7RuBRskZz01elt+0+w3Ww0lp+GfXzhiyDE4wGLYeIYG6LiS6mmEdUv13JUT9xjeSpFtSn
        LnmJIFeXQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:40812)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l98VN-0002Bx-JF; Mon, 08 Feb 2021 15:31:13 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l98VL-00039T-3P; Mon, 08 Feb 2021 15:31:11 +0000
Date:   Mon, 8 Feb 2021 15:31:11 +0000
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
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH v5 13/15] phylink: introduce
 phylink_fwnode_phy_connect()
Message-ID: <20210208153111.GK1463@shell.armlinux.org.uk>
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
 <20210208151244.16338-14-calvin.johnson@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208151244.16338-14-calvin.johnson@oss.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 08:42:42PM +0530, Calvin Johnson wrote:
> +int phylink_fwnode_phy_connect(struct phylink *pl,
> +			       struct fwnode_handle *fwnode,
> +			       u32 flags)
> +{
> +	struct fwnode_handle *phy_fwnode;
> +	struct phy_device *phy_dev;
> +	int ret;
> +
> +	if (is_of_node(fwnode)) {
> +		/* Fixed links and 802.3z are handled without needing a PHY */
> +		if (pl->cfg_link_an_mode == MLO_AN_FIXED ||
> +		    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
> +		     phy_interface_mode_is_8023z(pl->link_interface)))
> +			return 0;

This difference between ACPI and DT really needs to be described in the
commit description.

For example, why is it acceptable to have a PHY in fixed-link mode if
we're using ACPI, and not DT?

If we look at the phylink code, accepting a PHY when in fixed-link mode
is basically not supported... so why should ACPI allow this?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
