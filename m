Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3971FFDC4
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731738AbgFRWNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:13:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47756 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727827AbgFRWNy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 18:13:54 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jm2nA-001BDF-Rp; Fri, 19 Jun 2020 00:13:52 +0200
Date:   Fri, 19 Jun 2020 00:13:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, michael@walle.cc,
        linux@armlinux.org.uk, f.fainelli@gmail.com
Subject: Re: [PATCH net-next 4/5] net: phy: add Lynx PCS MDIO module
Message-ID: <20200618221352.GB279339@lunn.ch>
References: <20200618120837.27089-1-ioana.ciornei@nxp.com>
 <20200618120837.27089-5-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618120837.27089-5-ioana.ciornei@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  MAINTAINERS                     |   7 +
>  drivers/net/phy/Kconfig         |   6 +
>  drivers/net/phy/Makefile        |   1 +
>  drivers/net/phy/mdio-lynx-pcs.c | 358 ++++++++++++++++++++++++++++++++
>  include/linux/mdio-lynx-pcs.h   |  43 ++++
>  5 files changed, 415 insertions(+)
>  create mode 100644 drivers/net/phy/mdio-lynx-pcs.c
>  create mode 100644 include/linux/mdio-lynx-pcs.h

Hi Ioana

We should think about naming convention here.

All MDIO bus driver, MDIO multiplexors etc use mdio- as a prefix.

This is not a bus driver, so i don't think it should use the mdio-
prefix. How about pcs-lynx.c?

In terms of Kconfig, MDIO_ prefix is used for MDIO bus drivers etc.  I
don't think it is appropriate here. How about PCS_LYNX? I don't think
any other subsystem is using PCS_ as a prefix.

> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -235,6 +235,12 @@ config MDIO_XPCS
>  	  This module provides helper functions for Synopsys DesignWare XPCS
>  	  controllers.
>  
> +config MDIO_LYNX_PCS
> +	bool
> +	help
> +	  This module provides helper functions for Lynx PCS enablement
> +	  representing the PCS as an MDIO device.
> +
>  endif
>  endif

Maybe add this at the end, and add a

comment "PCS device drivers"

before it? I'm assuming with time we will have more of these drivers.

       Andrew
