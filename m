Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83E221CBB56
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 01:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbgEHXnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 19:43:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50160 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727778AbgEHXnL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 19:43:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VieCsnbAAH7ShY/le63Gu8FMcfhJPUddj2RQTmeSZkc=; b=j/zivjwsfKTO3NJdPZ1Xkc0NMS
        stqHbu/mibnqlxCUPiEvYElq+cYGn7gXuzGJw8Y9noaxxexZeAkB30T8zy8Z9okui8vzzlQnoI2ED
        VVZhLcyi4vETgL05SKfKuVbO4i618JeaQGJTGls8WuwreVQWM7bmWTAJ+PcHMuUyctZU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXCdt-001R9J-5t; Sat, 09 May 2020 01:42:57 +0200
Date:   Sat, 9 May 2020 01:42:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        linux.cj@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev <netdev@vger.kernel.org>, Marcin Wojtas <mw@semihalf.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [net-next PATCH v3 4/5] net: phy: Introduce fwnode_get_phy_id()
Message-ID: <20200508234257.GA338317@lunn.ch>
References: <20200505132905.10276-1-calvin.johnson@oss.nxp.com>
 <20200505132905.10276-5-calvin.johnson@oss.nxp.com>
 <67e263cf-5cd7-98d1-56ff-ebd9ac2265b6@arm.com>
 <CAHp75Vew8Fh6HEoOACk+J9KCpw+AE2t2+oFnXteK1eShopfYAA@mail.gmail.com>
 <83ab4ca4-9c34-4cdd-4413-3b4cdf96727d@arm.com>
 <20200508160755.GB10296@lsv03152.swis.in-blr01.nxp.com>
 <20200508181301.GF298574@lunn.ch>
 <1e33605e-42fd-baf8-7584-e8fcd5ca6fd3@arm.com>
 <20200508202722.GI298574@lunn.ch>
 <97a9e145-bbaa-efb8-6215-dc3109ee7290@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97a9e145-bbaa-efb8-6215-dc3109ee7290@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 08, 2020 at 05:48:33PM -0500, Jeremy Linton wrote:
> Hi,
> 
> On 5/8/20 3:27 PM, Andrew Lunn wrote:
> > > > There is a very small number of devices where the vendor messed up,
> > > > and did not put valid contents in the ID registers. In such cases, we
> > > > can read the IDs from device tree. These are then used in exactly the
> > > > same way as if they were read from the device.
> > > > 
> > > 
> > > Is that the case here?
> > 
> > Sorry, I don't understand the question?
> 
> I was asking in general, does this machine report the ID's correctly.

Very likely, it does.

> The embedded single mac:mdio per nic case seems like the normal case, and
> most of the existing ACPI described devices are setup that way.

Somebody in this thread pointed to ACPI patches for the
MACCHIATOBin. If i remember the hardware correctly, it has 4 Ethernet
interfaces, and two MDIO bus masters. One of the bus masters can only
do C22 and the other can only do C45. It is expected that the busses
are shared, not a nice one to one mapping.

> But at the same time, that shifts the c22/45 question to the nic
> driver, where use of a DSD property before instantiating/probing
> MDIO isn't really a problem if needed.

This in fact does not help you. The MAC driver has no idea what PHY is
connected to it. The MAC does not know if it is C22 or C45. It uses
the phylib abstraction which hides all this. Even if you assume 1:1,
use phy_find_first(), it will not find a C45 PHY because without
knowing there is a C45 PHY, we don't scan for it. And we should expect
C45 PHYs to become more popular in the next few years.

> In fact this embedded nic/mac/mdio/phy 1:1:1 case, is likely a requirement
> for passthrough into a generic VM, otherwise someone has to create a virtual
> mdio, and pass the phy in for the nic/mac.
> 
> AFAIK, NXP's part avoids this despite having a shared MDIO, because the phy
> state never leaves the mgmt side of the picture. It monitors the state and
> then feeds that back into their nic mgmt complex rather than using it
> directly.

That is the other model. Don't use Linux to drive the PHY, use
firmware in the MAC. A number of MACs do that, but it has the usual
problems of firmware. It limits you on your choice of PHYs, bugs in
the firmware cannot be fixed by the community, no sharing of drivers
because firmware is generally proprietary, no 'for free features'
because somebody else added features to the linux PHY driver etc.  But
it will make ACPI support simple, this whole discussion goes away, no
ACPI needed at all.

   Andrew
