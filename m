Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0441B7105
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 11:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgDXJed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 05:34:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726298AbgDXJec (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 05:34:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6FBD20736;
        Fri, 24 Apr 2020 09:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587720872;
        bh=Sw8H8k9G1mqrfCV+C7cERqQwqb47p7sRVyuxrdCLxGU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M//pRCL0EJp/Wnw5mUyVlLArY3rFY0Ba+XmihieCWjqsDy6X1mFErbNp+a+sRQWC4
         0YwsJvemoSF8NH/6VMq7398wHFlhIMxoxvJaclaBUQLTEVIcUqnaXRlEVx5fHuSS/w
         TozwshZcbzrrjs99Z/TqTkrtrFfOhZp/BJzd8vQY=
Date:   Fri, 24 Apr 2020 11:34:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, linux.cj@gmail.com,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Varun Sethi <V.Sethi@nxp.com>, Marcin Wojtas <mw@semihalf.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [net-next PATCH v1 1/2] device property: Introduce
 fwnode_phy_find_device()
Message-ID: <20200424093430.GA376180@kroah.com>
References: <20200424031617.24033-1-calvin.johnson@oss.nxp.com>
 <20200424031617.24033-2-calvin.johnson@oss.nxp.com>
 <b583f6fb-e6fe-3320-41c6-e019a4e10388@gmail.com>
 <20200424092651.GA4501@lsv03152.swis.in-blr01.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424092651.GA4501@lsv03152.swis.in-blr01.nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 02:56:51PM +0530, Calvin Johnson wrote:
> On Thu, Apr 23, 2020 at 08:45:03PM -0700, Florian Fainelli wrote:
> > 
> > 
> > On 4/23/2020 8:16 PM, Calvin Johnson wrote:
> > > Define fwnode_phy_find_device() to iterate an mdiobus and find the
> > > phy device of the provided phy fwnode.
> > > 
> > > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > 
> > If you forget to update the MAINTAINERS file, or do not place this code
> > under drivers/net/phy/* or drivers/of/of_mdio.c then this is going to
> > completely escape the sight of the PHYLIB/PHYLINK maintainers...
> 
> Did you mean the following change?
> 
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6354,6 +6354,7 @@ F:
> Documentation/devicetree/bindings/net/ethernet-phy.yaml
>  F:     Documentation/devicetree/bindings/net/mdio*
>  F:     Documentation/devicetree/bindings/net/qca,ar803x.yaml
>  F:     Documentation/networking/phy.rst
> +F:     drivers/base/property.c
>  F:     drivers/net/phy/
>  F:     drivers/of/of_mdio.c

I really doubt the phy maintainers want to maintain all of property.c,
right?  Please be kinder...

greg k-h
