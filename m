Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B721CDA7E
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgEKMxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:53:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53402 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbgEKMxY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 08:53:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UCjERt+maORMJwlHX05z+ypjOJgAfE49qXX7mxNSNHc=; b=lYPYuNsqZF2PI5lTSomAC3i5Eq
        GaTSHIVKs+8UyVTVrO+sgqPtlyglYPKA7Zc6xhtKlQfsFxEMbHHzt0kq/Sb542KSkL9GxetKcUR61
        z+RdHrnObgpc3s2OYXcus3QY1TGfX/h7TvLPK+0c25p9Bq8ifqnnEgtUuJMGlzBXX4T0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jY7vn-001qt8-R0; Mon, 11 May 2020 14:53:15 +0200
Date:   Mon, 11 May 2020 14:53:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
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
Message-ID: <20200511125315.GB409897@lunn.ch>
References: <20200505132905.10276-1-calvin.johnson@oss.nxp.com>
 <20200505132905.10276-5-calvin.johnson@oss.nxp.com>
 <67e263cf-5cd7-98d1-56ff-ebd9ac2265b6@arm.com>
 <CAHp75Vew8Fh6HEoOACk+J9KCpw+AE2t2+oFnXteK1eShopfYAA@mail.gmail.com>
 <83ab4ca4-9c34-4cdd-4413-3b4cdf96727d@arm.com>
 <20200508160755.GB10296@lsv03152.swis.in-blr01.nxp.com>
 <20200508181301.GF298574@lunn.ch>
 <20200511055231.GA12725@lsv03152.swis.in-blr01.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511055231.GA12725@lsv03152.swis.in-blr01.nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 11:22:31AM +0530, Calvin Johnson wrote:
> Thanks Andrew and Jeremy for the detailed discussion!
> 
> On Fri, May 08, 2020 at 08:13:01PM +0200, Andrew Lunn wrote:
> > > > It does have a numeric version defined for EISA types. OTOH I suspect that
> > > > your right. If there were a "PHY\VEN_IDvvvv&ID_DDDD" definition, it may not
> > > > be ideal to parse it. Instead the normal ACPI model of exactly matching the
> > > > complete string in the phy driver might be more appropriate.
> > > 
> > > IMO, it should be fine to parse the string to extract the phy_id. Is there any
> > > reason why we cannot do this?
> > 
> > Some background here, about what the PHY core does.
> > 
> > PHYs have two ID registers. This contains vendor, device, and often
> > revision of the PHY. Only the vendor part is standardised, vendors can
> > decide how to use the device part, but it is common for the lowest
> > nibble to be revision. The core will read these ID registers, and then
> > go through all the PHY drivers registered and ask them if they support
> > this ID. The drivers provide a table of IDs and masks. The mask is
> > applied, and then if the ID matches, the driver is used. The mask
> > allows the revision to be ignored, etc.
> > 
> > There is a very small number of devices where the vendor messed up,
> > and did not put valid contents in the ID registers. In such cases, we
> > can read the IDs from device tree. These are then used in exactly the
> > same way as if they were read from the device.
> > 
> > If you want the ACPI model to be used, an exact match on the string,
> > you are going to have to modify the core and the drivers. They
> > currently don't have any string, and have no idea about different
> > revisions which are out in the wild.
> 
> I don't think ACPI mandates that OS driver use exact string match and not parse
> the string.
> 
> First of all, I would suggest that we use "compatible" property instead of _CID.
> Not sure of a reason why we cannot. This will simplify implementation of fwnode
> APIs.
> 
> Already I've pointed out couple of ASL files in tianocore where they are already
> used.
> one eg:https://github.com/tianocore/edk2-platforms/blob/master/Silicon/Marvell/Armada7k8k/AcpiTables/Armada80x0McBin/Dsdt.asl#L280
> 
> Even if we use _CID, I'm not sure we are prohibited from extracting characters
> (phy_id) from it.
> If we decide to use _CID, then we need to define somewhere and standardize
> exactly how we are going to use it. I'm not sure where we can do this.

Hi Calvin

Whatever is decided needs to be documented as it becomes a defacto
standard. Once this is in the Linux PHY core, that is how it is done
for all boards using ACPI.

Maybe sometime in the future when the ACPI standards committee
definitively defines how this should be done, we can add a second
implementation which is standards conformant.

       Andrew
