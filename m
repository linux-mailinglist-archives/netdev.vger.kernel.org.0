Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDEA3A4120
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 13:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbhFKLUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 07:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbhFKLUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 07:20:02 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27489C061574;
        Fri, 11 Jun 2021 04:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=J8owCuPd5/8ySW2SHSltyMbz8eudomH+a+c2304+N58=; b=c9Kuu1ayjF5HovhwoYXeYzQeY
        NWZThOyYoZbCSL3cUyQpeoQcN2b3xN9smeGgaw9oJ5PVEbfaoiulwzv+xrBpOQUS6GNKPBcA7oFwf
        MiFYMDc5uyfjz+gSUyqVE5KLoKP5kleD/eqcEh06mns0VO3INcb1XM3UjpM4zacVfhgWXFkvI/8CG
        EiU7XITuKMAqKyCnYTL7GJmPMLFS/VLAYHJ5EbeGLKSZstNIhfNnnJZ9fPnG4mlhWa2zJgONkqvDL
        xn3HfoARosG+fID2HgP+jQ4yBPK+gBhFrfaK7EZ3BLk4c7K+cYs08CMGgpgRV1YBFGGiqHpBoYA2F
        6qGQmaJVg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44908)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lrfAi-00012V-2O; Fri, 11 Jun 2021 12:17:56 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lrfAc-0001EC-Hz; Fri, 11 Jun 2021 12:17:50 +0100
Date:   Fri, 11 Jun 2021 12:17:50 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        calvin.johnson@oss.nxp.com,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux.cj@gmail.com, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next v9 13/15] net: phylink: introduce
 phylink_fwnode_phy_connect()
Message-ID: <20210611111750.GH22278@shell.armlinux.org.uk>
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
 <20210611105401.270673-14-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210611105401.270673-14-ciorneiioana@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 01:53:59PM +0300, Ioana Ciornei wrote:
> From: Calvin Johnson <calvin.johnson@oss.nxp.com>
> 
> Define phylink_fwnode_phy_connect() to connect phy specified by
> a fwnode to a phylink instance.
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Acked-by: Grant Likely <grant.likely@arm.com>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks.

> ---
> 
> Changes in v9: None
> Changes in v8: None
> Changes in v7: None
> Changes in v6:
> - remove OF check for fixed-link
> 
> Changes in v5: None
> Changes in v4:
> - call phy_device_free() before returning
> 
> Changes in v3: None
> Changes in v2: None
> 
> 
> 
>  drivers/net/phy/phylink.c | 54 +++++++++++++++++++++++++++++++++++++++
>  include/linux/phylink.h   |  3 +++
>  2 files changed, 57 insertions(+)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 96d8e88b4e46..9cc0f69faafe 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -5,6 +5,7 @@
>   *
>   * Copyright (C) 2015 Russell King
>   */
> +#include <linux/acpi.h>
>  #include <linux/ethtool.h>
>  #include <linux/export.h>
>  #include <linux/gpio/consumer.h>
> @@ -1125,6 +1126,59 @@ int phylink_of_phy_connect(struct phylink *pl, struct device_node *dn,
>  }
>  EXPORT_SYMBOL_GPL(phylink_of_phy_connect);
>  
> +/**
> + * phylink_fwnode_phy_connect() - connect the PHY specified in the fwnode.
> + * @pl: a pointer to a &struct phylink returned from phylink_create()
> + * @fwnode: a pointer to a &struct fwnode_handle.
> + * @flags: PHY-specific flags to communicate to the PHY device driver
> + *
> + * Connect the phy specified @fwnode to the phylink instance specified
> + * by @pl.
> + *
> + * Returns 0 on success or a negative errno.
> + */
> +int phylink_fwnode_phy_connect(struct phylink *pl,
> +			       struct fwnode_handle *fwnode,
> +			       u32 flags)
> +{
> +	struct fwnode_handle *phy_fwnode;
> +	struct phy_device *phy_dev;
> +	int ret;
> +
> +	/* Fixed links and 802.3z are handled without needing a PHY */
> +	if (pl->cfg_link_an_mode == MLO_AN_FIXED ||
> +	    (pl->cfg_link_an_mode == MLO_AN_INBAND &&
> +	     phy_interface_mode_is_8023z(pl->link_interface)))
> +		return 0;
> +
> +	phy_fwnode = fwnode_get_phy_node(fwnode);
> +	if (IS_ERR(phy_fwnode)) {
> +		if (pl->cfg_link_an_mode == MLO_AN_PHY)
> +			return -ENODEV;
> +		return 0;
> +	}
> +
> +	phy_dev = fwnode_phy_find_device(phy_fwnode);
> +	/* We're done with the phy_node handle */
> +	fwnode_handle_put(phy_fwnode);
> +	if (!phy_dev)
> +		return -ENODEV;
> +
> +	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
> +				pl->link_interface);
> +	if (ret) {
> +		phy_device_free(phy_dev);
> +		return ret;
> +	}
> +
> +	ret = phylink_bringup_phy(pl, phy_dev, pl->link_config.interface);
> +	if (ret)
> +		phy_detach(phy_dev);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(phylink_fwnode_phy_connect);
> +
>  /**
>   * phylink_disconnect_phy() - disconnect any PHY attached to the phylink
>   *   instance.
> diff --git a/include/linux/phylink.h b/include/linux/phylink.h
> index fd2acfd9b597..afb3ded0b691 100644
> --- a/include/linux/phylink.h
> +++ b/include/linux/phylink.h
> @@ -441,6 +441,9 @@ void phylink_destroy(struct phylink *);
>  
>  int phylink_connect_phy(struct phylink *, struct phy_device *);
>  int phylink_of_phy_connect(struct phylink *, struct device_node *, u32 flags);
> +int phylink_fwnode_phy_connect(struct phylink *pl,
> +			       struct fwnode_handle *fwnode,
> +			       u32 flags);
>  void phylink_disconnect_phy(struct phylink *);
>  
>  void phylink_mac_change(struct phylink *, bool up);
> -- 
> 2.31.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
