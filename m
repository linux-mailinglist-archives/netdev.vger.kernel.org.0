Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF68A1FFE13
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732303AbgFRW1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732290AbgFRW13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:27:29 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7885C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=g7zW+FhLoRqM5Cs284P0tjdipggPnTdNkH/p+1pFfcU=; b=ki5IqbCRSTeS9wTVlFFSU/E1s
        bmcqIN/L0A4gWDNV38BiWcTu/NgNQ13UkyWVAQfEv58Lfk5gw1z87fg8EwU+jNMzZjYiT0eWp3DeQ
        X/6AbtQYLCcrW4BtZ13GtsVpYR/Ftq1BbPe/Gd+QwqM76uDe1PJ2iULgYxfZDKK0WEHVzH4+F0s+f
        uh0stuyyEGYJQFMTAvLTF9XfTNMJnNJQllrPvn5lNgpIZfQDs82WOtFkbKxlMhCCNUuS54hIbbQKI
        I3yjDBQmotG4UiYgHy3yhZag42Bz9fdt/3h7XyLXHV87dVWB5kwNc02SmbX+DPgS87oFx83lbeIRv
        RedhhbSuA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58810)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jm30K-0005dl-10; Thu, 18 Jun 2020 23:27:28 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jm30J-000545-Em; Thu, 18 Jun 2020 23:27:27 +0100
Date:   Thu, 18 Jun 2020 23:27:27 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>, netdev@vger.kernel.org,
        davem@davemloft.net, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        michael@walle.cc, f.fainelli@gmail.com
Subject: Re: [PATCH net-next 4/5] net: phy: add Lynx PCS MDIO module
Message-ID: <20200618222727.GM1551@shell.armlinux.org.uk>
References: <20200618120837.27089-1-ioana.ciornei@nxp.com>
 <20200618120837.27089-5-ioana.ciornei@nxp.com>
 <20200618221352.GB279339@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618221352.GB279339@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 12:13:52AM +0200, Andrew Lunn wrote:
> >  MAINTAINERS                     |   7 +
> >  drivers/net/phy/Kconfig         |   6 +
> >  drivers/net/phy/Makefile        |   1 +
> >  drivers/net/phy/mdio-lynx-pcs.c | 358 ++++++++++++++++++++++++++++++++
> >  include/linux/mdio-lynx-pcs.h   |  43 ++++
> >  5 files changed, 415 insertions(+)
> >  create mode 100644 drivers/net/phy/mdio-lynx-pcs.c
> >  create mode 100644 include/linux/mdio-lynx-pcs.h
> 
> Hi Ioana
> 
> We should think about naming convention here.
> 
> All MDIO bus driver, MDIO multiplexors etc use mdio- as a prefix.
> 
> This is not a bus driver, so i don't think it should use the mdio-
> prefix. How about pcs-lynx.c?
> 
> In terms of Kconfig, MDIO_ prefix is used for MDIO bus drivers etc.  I
> don't think it is appropriate here. How about PCS_LYNX? I don't think
> any other subsystem is using PCS_ as a prefix.
> 
> > --- a/drivers/net/phy/Kconfig
> > +++ b/drivers/net/phy/Kconfig
> > @@ -235,6 +235,12 @@ config MDIO_XPCS
> >  	  This module provides helper functions for Synopsys DesignWare XPCS
> >  	  controllers.
> >  
> > +config MDIO_LYNX_PCS
> > +	bool
> > +	help
> > +	  This module provides helper functions for Lynx PCS enablement
> > +	  representing the PCS as an MDIO device.
> > +
> >  endif
> >  endif
> 
> Maybe add this at the end, and add a
> 
> comment "PCS device drivers"
> 
> before it? I'm assuming with time we will have more of these drivers.

It think we will.

The other thing is, drivers/net/phy is becoming a little cluttered -
we have approaching 100 files there.

Should we be thinking about drivers/net/phy/mdio/ (for mdio*),
drivers/net/phy/lib/ for the core phylib code or leaving it where
it is, and, hmm, drivers/net/phy/media/ maybe for the PHY and PCS
drivers?  Or something like that?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
