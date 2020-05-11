Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C801CD577
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 11:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729389AbgEKJjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 05:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725790AbgEKJjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 05:39:31 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6EBC061A0C;
        Mon, 11 May 2020 02:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=JXYKE2YvBIgyujZ6k0qik2Y4FBN5h7JmUD/1Z324Bzw=; b=06Nbqi6ULbmPZiLvQwzGzSEOH
        4qSNuekc6jhgvszk86LXQc9whmYGJChSEd1O5sgtpwpWh6Xd080AZOG3ozpuwYWBGVmlb9AOjUKoa
        mIkk+CKcCB1Vily19TBX7nK8YXr3WIx1JKuZ6N6+GHchRRZGbMIMqFuvZVCBqQ9P3URDA6Zs3xIdL
        X0RnlxZEKBlbldWHHrcFUh2KYtSKkjAT7ieXMqodj/oxQ8qC2qDO312vIhA9LUz9xfvAIiKt2RATW
        kZNtT8TBHl9vl4aZld0Cteo2T/nk3oDPcRS2cUYo9ESDve7UO2wVrNBKJ+/WGyRQ/6DyOpKt1fS2x
        QB+Rdnt7A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59006)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jY4tm-0005bR-H9; Mon, 11 May 2020 10:38:58 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jY4td-0005WV-Ml; Mon, 11 May 2020 10:38:49 +0100
Date:   Mon, 11 May 2020 10:38:49 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>, linux.cj@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
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
Message-ID: <20200511093849.GO1551@shell.armlinux.org.uk>
References: <67e263cf-5cd7-98d1-56ff-ebd9ac2265b6@arm.com>
 <CAHp75Vew8Fh6HEoOACk+J9KCpw+AE2t2+oFnXteK1eShopfYAA@mail.gmail.com>
 <83ab4ca4-9c34-4cdd-4413-3b4cdf96727d@arm.com>
 <20200508160755.GB10296@lsv03152.swis.in-blr01.nxp.com>
 <20200508181301.GF298574@lunn.ch>
 <1e33605e-42fd-baf8-7584-e8fcd5ca6fd3@arm.com>
 <20200508202722.GI298574@lunn.ch>
 <97a9e145-bbaa-efb8-6215-dc3109ee7290@arm.com>
 <20200508234257.GA338317@lunn.ch>
 <20200511080040.GC12725@lsv03152.swis.in-blr01.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511080040.GC12725@lsv03152.swis.in-blr01.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 01:30:40PM +0530, Calvin Johnson wrote:
> On Sat, May 09, 2020 at 01:42:57AM +0200, Andrew Lunn wrote:
> > On Fri, May 08, 2020 at 05:48:33PM -0500, Jeremy Linton wrote:
> > > Hi,
> > > 
> > > On 5/8/20 3:27 PM, Andrew Lunn wrote:
> > > > > > There is a very small number of devices where the vendor messed up,
> > > > > > and did not put valid contents in the ID registers. In such cases, we
> > > > > > can read the IDs from device tree. These are then used in exactly the
> > > > > > same way as if they were read from the device.
> > > > > > 
> > > > > 
> > > > > Is that the case here?
> > > > 
> > > > Sorry, I don't understand the question?
> > > 
> > > I was asking in general, does this machine report the ID's correctly.
> > 
> > Very likely, it does.
> > 
> > > The embedded single mac:mdio per nic case seems like the normal case, and
> > > most of the existing ACPI described devices are setup that way.
> > 
> > Somebody in this thread pointed to ACPI patches for the
> > MACCHIATOBin. If i remember the hardware correctly, it has 4 Ethernet
> > interfaces, and two MDIO bus masters. One of the bus masters can only
> > do C22 and the other can only do C45. It is expected that the busses
> > are shared, not a nice one to one mapping.
> > 
> > > But at the same time, that shifts the c22/45 question to the nic
> > > driver, where use of a DSD property before instantiating/probing
> > > MDIO isn't really a problem if needed.
> > 
> > This in fact does not help you. The MAC driver has no idea what PHY is
> > connected to it. The MAC does not know if it is C22 or C45. It uses
> > the phylib abstraction which hides all this. Even if you assume 1:1,
> > use phy_find_first(), it will not find a C45 PHY because without
> > knowing there is a C45 PHY, we don't scan for it. And we should expect
> > C45 PHYs to become more popular in the next few years.
> 
> Agree.
> 
> NXP's LX2160ARDB platform currently has the following MDIO-PHY connection.
> 
> MDIO-1 ==> one 40G PHY, two 1G PHYs(C45), two 10G PHYs(C22)

I'm not entirely sure you have that correct.  The Clause 45 register set
as defined by IEEE 802.3 does not define registers for 1G negotiation,
unless the PHY either supports Clause 22 accesses, or implements some
kind of vendor extension.  For a 1G PHY, this would be wasteful, and
likely incompatible with a lot of hardware/software.

Conversely, Clause 22 does not define registers for 10G speeds, except
accessing Clause 45 registers indirectly through clause 22 registers,
which would also be wasteful.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
