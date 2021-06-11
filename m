Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393AE3A414C
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 13:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbhFKLhv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 07:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbhFKLhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 07:37:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7243AC061574;
        Fri, 11 Jun 2021 04:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3jUWtrXHIpKEYOUBwEqCPPvxw0WdD7WDMvIkPGmXzmE=; b=ouY8lHqzqLUZNwo7/erJkcbBy
        63F+tC8l8DI5hLdQuVrPM7Ot4w2sgivxE0uOPdFKO2vqa7mchCfks8iX5/PSkfjVmbaR3TILpTap7
        FCKIOaTxnPA7grtJafnxq7VcXSBU20FgE3CpKKcJ7kF7YVxEoc+IcvF3itIPSQWW4LhCXElEayV//
        0mqq6ZHV3+Y8GPSj75Af6YLRJE8zneCCTOo49hx8QHUXcxo0NmyB9RKrBE3ZtNq67cIVRQNRQLxzi
        BHzSxMQdcGJPNh8fVf3TbW/YCThC52LaDnXXm+ar+nYg0ln2UhK6LO03oEgtkremMRA72xqT58A+D
        idTGbFQqQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44912)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lrfS0-00016N-Au; Fri, 11 Jun 2021 12:35:48 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lrfRy-0001Fi-W5; Fri, 11 Jun 2021 12:35:47 +0100
Date:   Fri, 11 Jun 2021 12:35:46 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux.cj" <linux.cj@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next v9 04/15] of: mdio: Refactor of_phy_find_device()
Message-ID: <20210611113546.GJ22278@shell.armlinux.org.uk>
References: <20210611105401.270673-1-ciorneiioana@gmail.com>
 <20210611105401.270673-5-ciorneiioana@gmail.com>
 <CAHp75VdmqLnESxf5R8Yvn02QDv=_WmkWEcRZMjxUjLg+KDcyQg@mail.gmail.com>
 <CAHp75Ve6X5j31ZO4_Rzd5uTgVk2VOGjos4M4m=GxwnRHw2gbHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Ve6X5j31ZO4_Rzd5uTgVk2VOGjos4M4m=GxwnRHw2gbHQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 02:30:19PM +0300, Andy Shevchenko wrote:
> On Fri, Jun 11, 2021 at 2:28 PM Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
> > On Fri, Jun 11, 2021 at 1:54 PM Ioana Ciornei <ciorneiioana@gmail.com> wrote:
> > >
> > > From: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > >
> > > Refactor of_phy_find_device() to use fwnode_phy_find_device().
> >
> > I see that there are many users of this, but I think eventually we
> > should kill of_phy_find_device() completely.
> 
> Looking into other examples of such I think this series may not touch
> them right now, but clearly state that it's the plan in the future to
> kill this kind of OF APIs that call fwnode underneath.

That's something I most definitely support - once we have the fwnode
APIs in place, the OF specific APIs become an additional maintenance
burden that we don't need. So, I would also like to see the old APIs
killed.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
