Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC922150FDE
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 19:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729735AbgBCSns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 13:43:48 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38080 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728901AbgBCSnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 13:43:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qvDOaWUiHvwEs516vyd8sNz5hwIl/fKnRnf/xSvQNXw=; b=vNytEFPAc0JcaO3v6lOGWH4IT
        hAGORSJAZ0N3rLsGuzorgd9Vu07isRjWebVZrsZCGi3Yo3TPLyA9pRYMGpJkDpyxoiFuzrM5k6KPX
        GQrsW5gkzqTdQOjENDR2AxjdF1j4AvXYBWqRprzuOQhc3s05Q3dq7pC+zwn5dS0GJcwK5/vvz104c
        fSjVqbgi9ZUfTzfB9VLJGrctaMNR+hvHC6UFapoBKwuZCWO90DWyH35mWhxJlDbJ85kq7OwSXtD0p
        dRy/QgMWEdSi2MGUJpazxfSD9fnILYolBTKyZ7YkGqCvysDOq4HI8CE3pkvMWYIIV1eRxfCsIlCfd
        k8J+pHmoQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:35510)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iygh2-0005Fj-My; Mon, 03 Feb 2020 18:43:32 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iygh0-000083-Gi; Mon, 03 Feb 2020 18:43:30 +0000
Date:   Mon, 3 Feb 2020 18:43:30 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Calvin Johnson <calvin.johnson@nxp.com>
Cc:     linux.cj@gmail.com, Jon Nettleton <jon@solid-run.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        cristian.sovaiala@nxp.com, laurentiu.tudor@nxp.com,
        ioana.ciornei@nxp.com, V.Sethi@nxp.com, pankaj.bansal@nxp.com,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v1 6/7] net: phylink: Introduce
 phylink_fwnode_phy_connect()
Message-ID: <20200203184330.GF18808@shell.armlinux.org.uk>
References: <20200131153440.20870-1-calvin.johnson@nxp.com>
 <20200131153440.20870-7-calvin.johnson@nxp.com>
 <20200203184121.GR25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203184121.GR25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 03, 2020 at 06:41:21PM +0000, Russell King - ARM Linux admin wrote:
> On Fri, Jan 31, 2020 at 09:04:39PM +0530, Calvin Johnson wrote:
> > From: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > 
> > Introduce phylink_fwnode_phy_connect API to connect the PHY using
> > fwnode.
> > 
> > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > ---
> > 
> >  drivers/net/phy/phylink.c | 64 +++++++++++++++++++++++++++++++++++++++
> >  include/linux/phylink.h   |  2 ++
> >  2 files changed, 66 insertions(+)
> > 
> > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > index ee7a718662c6..f211f62283b5 100644
> > --- a/drivers/net/phy/phylink.c
> > +++ b/drivers/net/phy/phylink.c
> > @@ -18,6 +18,7 @@
> >  #include <linux/spinlock.h>
> >  #include <linux/timer.h>
> >  #include <linux/workqueue.h>
> > +#include <linux/acpi.h>
> >  
> >  #include "sfp.h"
> >  #include "swphy.h"
> > @@ -817,6 +818,69 @@ int phylink_connect_phy(struct phylink *pl, struct phy_device *phy)
> >  }
> >  EXPORT_SYMBOL_GPL(phylink_connect_phy);
> >  
> > +/**
> > + * phylink_fwnode_phy_connect() - connect the PHY specified in the fwnode.
> > + * @pl: a pointer to a &struct phylink returned from phylink_create()
> > + * @dn: a pointer to a &struct device_node.
> > + * @flags: PHY-specific flags to communicate to the PHY device driver
> > + *
> > + * Connect the phy specified in the device node @dn to the phylink instance
> > + * specified by @pl. Actions specified in phylink_connect_phy() will be
> > + * performed.
> > + *
> > + * Returns 0 on success or a negative errno.
> > + */
> > +int phylink_fwnode_phy_connect(struct phylink *pl,
> > +			       struct fwnode_handle *fwnode,
> > +			       u32 flags)
> > +{
> > +	struct fwnode_handle *phy_node;
> > +	struct phy_device *phy_dev;
> > +	int ret;
> > +	int status;
> > +	struct fwnode_reference_args args;
> > +
> > +	/* Fixed links and 802.3z are handled without needing a PHY */
> > +	if (pl->link_an_mode == MLO_AN_FIXED ||
> > +	    (pl->link_an_mode == MLO_AN_INBAND &&
> > +	     phy_interface_mode_is_8023z(pl->link_interface)))
> > +		return 0;
> > +
> > +	status = acpi_node_get_property_reference(fwnode, "phy-handle", 0,
> > +						  &args);
> > +	if (ACPI_FAILURE(status) || !is_acpi_device_node(args.fwnode))
> > +		status = acpi_node_get_property_reference(fwnode, "phy", 0,
> > +							  &args);
> > +	if (ACPI_FAILURE(status) || !is_acpi_device_node(args.fwnode))
> > +		status = acpi_node_get_property_reference(fwnode,
> > +							  "phy-device", 0,
> > +							  &args);
> 
> This is a copy-and-paste of phylink_of_phy_connect() without much
> thought.
> 
> There is no need to duplicate the legacy DT functionality of
> phy/phy-device/phy-handle in ACPI - there is no legacy to support,
> so it's pointless trying to find one of three properties here.
> 
> I'd prefer both the DT and ACPI variants to be more integrated, so
> we don't have two almost identical functions except for the firmware
> specific detail.

Also, I don't see any ACPI folk in the list of recipients to your
series.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
