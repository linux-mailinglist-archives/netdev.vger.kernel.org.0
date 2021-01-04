Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051432E9CCE
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 19:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbhADSJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 13:09:18 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:4464 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbhADSJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 13:09:18 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff359a50000>; Mon, 04 Jan 2021 10:08:37 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 Jan
 2021 18:08:35 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 4 Jan 2021 18:08:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FhER2jPesHAWZ1bJXQV+ge2RwYJKaLYIwcWdbMkn3z4bpxOv00Ay+0bTohau9MiVgeqMWJ1I/N+K7GYnzrys06rNlSL5T88o8FUijqTAyQL7aIIyMqfp+Hk0HtRJkcz2/VE28TvblKNBMnguCB5QuvVr8zyk5taOANCvm3ftM9MjqgT4fWrahUH7KNFW9WS89lqzBMjU0TYxXBXAdryFRhY0qdxukx2Us7tqNG/GE7YIIYbb66sLI2dL0pKPZyjeUcyu/SIqlynTxx8HG79abWpUvT74rPzAetr8aM8g+3fLDhIl9chkE5eMY8oWc7LKQ6qaXFf1yzHmnlzl3rQWlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jYWF5Za5RQIKsxGqPAjvR0Bf5RAvnJ0hHtXWaOODqsw=;
 b=Fb9y+rIh28xBSl6BHojToSMiEmP5Vj6z3iam/ID16/9v+wtz02fnpWXGC0XSJVrAUV+113GyMHSli7o8dN18aJajsCzrKjNh5YMH17zTL3TGlSwRUSdZZTAlMRi1tVcgsOhUDf1sz4mArFTUhTqqXOZ80d+cND1SrVp38AhB76wGM0e8pWYtP/Y1cXAPuywJvNP6Ng68Ud5GTsbPQq2ifY3uJO0v5aoILbbyevEAM+WqblmtnO8fLoyCh+hxjJJvdD8DdFaKvirUVlpmOmgzZjrVm2MFnaGnCHj+g/NzKW2J7BouOR1caXtI06pkCVZPIC2OSO55Vr4M1ij7Ckcm3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3401.namprd12.prod.outlook.com (2603:10b6:5:39::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19; Mon, 4 Jan
 2021 18:08:33 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3721.024; Mon, 4 Jan 2021
 18:08:33 +0000
Date:   Mon, 4 Jan 2021 14:08:31 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Mark Brown <broonie@kernel.org>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        <alsa-devel@alsa-project.org>, Kiran Patil <kiran.patil@intel.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Martin Habets <mhabets@solarflare.com>,
        "Liam Girdwood" <lgirdwood@gmail.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        "Dave Ertman" <david.m.ertman@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>, <lee.jones@linaro.org>
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
Message-ID: <20210104180831.GD552508@nvidia.com>
References: <X9xV+8Mujo4dhfU4@kroah.com> <20201218131709.GA5333@sirena.org.uk>
 <20201218140854.GW552508@nvidia.com> <20201218155204.GC5333@sirena.org.uk>
 <20201218162817.GX552508@nvidia.com> <20201218180310.GD5333@sirena.org.uk>
 <20201218184150.GY552508@nvidia.com> <20201218203211.GE5333@sirena.org.uk>
 <20201218205856.GZ552508@nvidia.com> <20201221185140.GD4521@sirena.org.uk>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201221185140.GD4521@sirena.org.uk>
X-ClientProxiedBy: MN2PR04CA0021.namprd04.prod.outlook.com
 (2603:10b6:208:d4::34) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by MN2PR04CA0021.namprd04.prod.outlook.com (2603:10b6:208:d4::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20 via Frontend Transport; Mon, 4 Jan 2021 18:08:33 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kwUHP-001zC1-Fx; Mon, 04 Jan 2021 14:08:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609783717; bh=jYWF5Za5RQIKsxGqPAjvR0Bf5RAvnJ0hHtXWaOODqsw=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=LPiLlt1g/HZDtpXcsJ2Bwq06TRD6MJWZ42Cszedhx65KExX4C06vZyyV/gzV/xKgB
         nkcNWrqx4S+4UaK/DGfjRg1Dy/BR854zj97kCs9anlkuBetxNoJwyRangA6gRCxren
         0nOgW6p9MAIW6dVBE9VtDA1/7Z6MFACZ33Ig1QqGgiBH9+OzF6WOWqecFcr9iVtiYT
         0gGWflIvnIwlzZ1+LSB0di1vMpcrNyPYFsC/LuFV/elXWwXwZJ8FtKKZiuut3Vl/1V
         6vO3aX9hPCThx3N3phGl5Xo0QKHW1gK3WaJaoKopWXXBEjWC3XDZ+VnBLS0mWtcG4M
         /Kaan5mZGrKaQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 06:51:40PM +0000, Mark Brown wrote:

> > with some kind of inheritance scheme where platform device remained as
> > only instantiated directly in board files, while drivers could bind to
> > OF/DT/ACPI/FPGA/etc device instantiations with minimal duplication &
> > boilerplate.
> 
> Like I said in my previous message that is essentially what we have now.
> It's not worded in quite that way but it's how all the non-enumerable
> buses work.  

I think it is about half way there. We jammed everything into platform
device and platform bus and then had a few api aspects to tell if
which of the subtypes it might be.

That functions sort of like an object model with inheritance, but a
single type and 'is it a XXX' queries is not quite the same thing.

> BTW I did have a bit of a scan through some of the ACPI devices and
> for a good proportion of them it seems fairly clear that they are
> not platform devices at all - they were mostly interacting with ACPI
> firmware functionality rather than hardware, something you can't
> really do with FDT at all.

Right, that is kind of the point. We also have cases where ACPI
devices are just an ioresource list and don't have any special
ACPIness. IIRC DT has a similar issue where there are DT drivers that
just don't work without the OF stuff. Why are they platform drivers?

IMHO the point of the bus type is to tell the driver what API set you
have. If you have a of_device then you have an OF node and can do all
the of operations. Same for PCI/ACPI/etc.

We fake this idea out by being able to convert platform to DT and OF,
but if platform is to be the universal device then why do we have PCI
device and not a 'platform to pci' operator instead? None of this is
consistent.

Regardless of the shortcut to make everything a struct
platform_device, I think it was a mistake to put OF devices on
platform_bus. Those should have remained on some of_bus even if they
are represented by struct platform_device and fiddling in the core
done to make that work OK.

It is much easier to identify what a bus_type is (the unique
collection of APIs) and thus when to create those.

If the bus_type should contain struct platform_device or a unqiue
struct then becomes a different question.

Yes that is very hacky, but it feels less hacky than the platform
bus/device is everything and can be used everwhere idea.

> > The only problem with mfd as far as SOF is concerned was Greg was not
> > happy when he saw PCI stuff in the MFD subsystem.
> 
> This is a huge part of the problem here - there's no clearly articulated
> logic, it's all coming back to these sorts of opinion statements about
> specific cases which aren't really something you can base anything
> on.

I agree with this, IMHO there is no really cohesive explanation for
when to create a bus vs use the "universal bus" (platform) that can
also explain the things platform is already doing.

This feels like a good conference topic someday..

> Personally I'm even struggling to identify a practical problem that
> we're trying to solve here.  Like Alexandre says what would an
> mfd_driver actually buy us?

Well, there is the minor issue of name collision eg
/sys/bus/XX/devices/* must list all devices in the system with no
collisions.

The owner of the bus is supposed to define the stable naming scheme
and all the devices are supposed to follow it. platform doesn't have
this:

$ ls /sys/bus/platform/devices/
 ACPI000C:00	     dell-smbios.0	'Fixed MDIO bus.0'   INT33A1:00         microcode     PNP0C04:00   PNP0C0B:03   PNP0C14:00
 alarmtimer.0.auto   dell-smbios.1	 GHES.0		     intel_rapl_msr.0   MSFT0101:00   PNP0C0B:00   PNP0C0B:04   PNP0C14:01
 coretemp.0	     efi-framebuffer.0	 GHES.1		     iTCO_wdt	        pcspkr	      PNP0C0B:01   PNP0C0C:00   reg-dummy
 dcdbas		     eisa.0		 INT0800:00	     kgdboc	        PNP0103:00    PNP0C0B:02   PNP0C0E:00   serial8250

Why are ACPI names in here? It looks like "because platform drivers
were used to bind to ACPI devices" 

eg INT33A1 is pmc_core_driver so the device was moved from acpi_bus to
platform_bus? How does that make sense??

Why is pmc_core_driver a platform device instead of ACPI? Because some
platforms don't have ACPI and the board file properly creates a
platform device in C code.

> I have some bad news for you about the hardware description problem
> space.  Among other things we have a bunch of platform devices that
> don't have any resources exposed through the resource API but are still
> things like chips on a board, doing some combination of exposing
> resources for other devices (eg, a fixed voltage regulator) and
> consuming things like clocks or GPIOs that don't appear in the resource
> API.

So in these cases how do I use the generic platform bus API to find
the GPIOs, regulators, and so on to connect with?

If drivers take a platform device and immediately covert it to an OF
object and use OF APIs to find those connections then it really
*never* was a platform device in the first place and coding an OF
driver as platform is an abuse.

A decent step would be to accept that 'platform_device' is something
weird and special and split its bus_type. Only devices created
direclty in C code should be on the platform_bus, OF/ACPI/etc should
all be on their own bus_types, even though they all use the same
'struct platform_bus'

Yes, it is super hacky, but at least the bus side would follow the
basic architecture..
 
> that but it is not clear what the upside of doing that would be,
> especially given the amount of upheval it would generate and the
> classification issues that will inevitably result.

Well, I think the upside for existing is very small, but I would like
to see a shared idea about how to answer questions like 'when should I
use a existing device type' and 'when should I make a new device type'.

Jason
