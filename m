Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D2E27D205
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 16:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbgI2O7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 10:59:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33792 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgI2O7W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 10:59:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNH5y-00GlhJ-GW; Tue, 29 Sep 2020 16:59:10 +0200
Date:   Tue, 29 Sep 2020 16:59:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Networking <netdev@vger.kernel.org>, linux.cj@gmail.com,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        nd <nd@arm.com>
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
Message-ID: <20200929145910.GJ3950513@lunn.ch>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <f7d2de9c-a679-1ad2-d6ba-ca7e2f823343@arm.com>
 <20200929051703.GA10849@lsv03152.swis.in-blr01.nxp.com>
 <20200929134302.GF3950513@lunn.ch>
 <CAK8P3a0etJf_SG8qLY0VjR+JamKQ8MtyPwoXnb0mpnGZawLfRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0etJf_SG8qLY0VjR+JamKQ8MtyPwoXnb0mpnGZawLfRA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> IIRC both UEFI and ACPI define only little-endian data structures.
> The code does not attempt to convert these into CPU endianness
> at the moment.  In theory it could be changed to support either, but
> this seems non-practical for the UEFI runtime services that require
> calling into firmware code in little-endian mode.

Hi Arnd

Thanks for the info. So we can assume the CPU is little endian.  That
helps narrow down the problem.

> > If this is the bus controller endianness, are all the SoCs you plan to
> > support via ACPI the same endianness? If they are all the same, you
> > can hard code it.
> 
> NXP has a bunch of SoCs that reuse the same on-chip devices but
> change the endianness between them based on what the chip
> designers guessed the OS would want, which is why the drivers
> usually support both register layouts and switch at runtime.
> Worse, depending on which SoC was the first to get a DT binding
> for a particular NXP on-chip device, the default endianness is
> different, and there is either a "big-endian" or "little-endian"
> override in the binding.
> 
> I would guess that for modern NXP chips that you might boot with
> ACPI the endianness is always wired the same way, but I
> understand the caution when they have been burned by this
> problem before.

So it might depend on if NXP is worried it might flip the endianness
of the synthesis of the MDIO controller at some point for devices it
wants to support using ACPI?

Does ACPI have a standard way of declaring the endianness of a device?
We don't really want to put the DT parameter in ACPI, we want to use
the ACPI way of doing it.

    Thanks
	Andrew
