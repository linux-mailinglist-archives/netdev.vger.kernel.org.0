Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B78823142C
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbgG1Up6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:45:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60712 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728828AbgG1Up6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 16:45:58 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k0WTs-007LJA-5w; Tue, 28 Jul 2020 22:45:48 +0200
Date:   Tue, 28 Jul 2020 22:45:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Callaghan <dan.callaghan@opengear.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Russell King <linux@armlinux.org.uk>, Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, "linux.cj" <linux.cj@gmail.com>,
        linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
Message-ID: <20200728204548.GC1748118@lunn.ch>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch>
 <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
 <20200724191436.GH1594328@lunn.ch>
 <1595922651-sup-5323@galangal.danc.bne.opengear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1595922651-sup-5323@galangal.danc.bne.opengear.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 06:06:26PM +1000, Dan Callaghan wrote:
> Excerpts from Andrew Lunn's message of 2020-07-24 21:14:36 +02:00:
> > Now i could be wrong, but are Ethernet switches something you expect
> > to see on ACPI/SBSA platforms? Or is this a legitimate use of the
> > escape hatch?
> 
> As an extra data point: right now I am working on an x86 embedded 
> appliance (ACPI not Device Tree) with 3x integrated Marvell switches. 
> I have been watching this patch series with great interest, because 
> right now there is no way for me to configure a complex switch topology 
> in DSA without Device Tree.
> 
> For the device I am working on, we will have units shipping before these 
> questions about how to represent Ethernet switches in ACPI can be 
> resolved. So realistically, we will have to actually configure the 
> switches using software_node structures supplied by an out-of-tree 
> platform driver, or some hackery like that, rather than configuring them 
> through ACPI.

Hi Dan

I also have an x86 platform, but with a single switch. For that, i
have a platform driver, which instantiates a bit banging MDIO bus, and
sets up the switch using platform data. This works, but it is limited
to internal Copper only PHYs.

> An approach I have been toying with is to port all of DSA to use the 
> fwnode_handle abstraction instead of Device Tree nodes, but that is 
> obviously a large task, and frankly I was not sure whether such a patch 
> series would be welcomed.

I would actually suggest you look at using DT. We are struggling to
get ACPI maintainers involved with really simple things, like the ACPI
equivalent of a phandle from the MAC to the PHY. A full DSA binding
for Marvell switches is pretty complex, especially if you need SFP
support. I expect the ACPI maintainers will actively run away
screaming when you make your proposal.

DT can be used on x86, and i suspect it is a much easier path of least
resistance.

	Andrew
