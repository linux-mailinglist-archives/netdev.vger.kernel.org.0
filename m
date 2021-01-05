Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129F32EA312
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 02:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727748AbhAEByC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 20:54:02 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7170 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbhAEByC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 20:54:02 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff3c6910000>; Mon, 04 Jan 2021 17:53:21 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 5 Jan
 2021 01:53:19 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 5 Jan 2021 01:53:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RFVVEinAHqq577P/12aU3sIQZriWUwmlURHfnMv9xUJjOFLioKshh+5kaS8xmE6BulCa2ZYlx8ggMzlSIeiCoev81/O06mhuAwBSSZp93IQeCYOJhbsCT5tpnyB1VH5y3I/brzMX3UD13zNNeHTtbpbOCgFRNSl6ifwtdJfvpAPcUOn7Z01P54JV1WLx9kHyQ9wsGY3I4UsV+Mf3IImiOS1yaEJvtQFsUYM+hlC+BzepUEcNhQQiOzexD1/VF5BAZi6nlpI5S9keH9l65gEv/ijS3FSqsSoRBGPFfWITcUbtUV2ChyWx1LzEYPYyF2s0EWjH+9V9kKnQu7FnbW24DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3NSVHr65QSe5/misEmnitZ3kyjdEHvvwH86gYiinZ3I=;
 b=UtCppMUiX+VAwIpf8g0pDklLhOE6prxun0REyEXNMKBea1f5MZr4qRwHXI9j2rWUDkz7xSJaYbwFaufy9PwP6BsrCb1qIIcKOhbhEyeqMtcmwY9QIVFVFDZJzPALuHAkpPHzdkcpSxk3pcNxPbqGtEnCCo1ORwOVQyQJFjr/GjMNUnAYmYdm1WzGVrurd54sbFTqPoEZijx2iRkWA6Xd8xGPlgA085Thjsh4JM3k/4IYcNpEPP8/TNEKkV+ANFJZ1bSLE+lx8fSxzo1hkYkksVm2NvSLEYU7A0f3PbIGaWLo33VtHw7seDvlmAYxQPwMT3FXY9CwEwdCsOxVnQ/KrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1338.namprd12.prod.outlook.com (2603:10b6:3:71::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19; Tue, 5 Jan
 2021 01:53:16 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 01:53:16 +0000
Date:   Mon, 4 Jan 2021 21:53:14 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dan Williams <dan.j.williams@intel.com>
CC:     Mark Brown <broonie@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        <alsa-devel@alsa-project.org>,
        "Kiran Patil" <kiran.patil@intel.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Martin Habets <mhabets@solarflare.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "Ranjani Sridharan" <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        David Miller <davem@davemloft.net>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
Message-ID: <20210105015314.GM552508@nvidia.com>
References: <20201218162817.GX552508@nvidia.com>
 <20201218180310.GD5333@sirena.org.uk> <20201218184150.GY552508@nvidia.com>
 <20201218203211.GE5333@sirena.org.uk> <20201218205856.GZ552508@nvidia.com>
 <20201221185140.GD4521@sirena.org.uk> <20210104180831.GD552508@nvidia.com>
 <20210104211930.GI5645@sirena.org.uk> <20210105001341.GL552508@nvidia.com>
 <CAPcyv4gxprMo1LwGTqGDyN-z2TrXLcAvJ3AN9-fbUs6y-LwXeA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAPcyv4gxprMo1LwGTqGDyN-z2TrXLcAvJ3AN9-fbUs6y-LwXeA@mail.gmail.com>
X-ClientProxiedBy: YT1PR01CA0143.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::22) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0143.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2f::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19 via Frontend Transport; Tue, 5 Jan 2021 01:53:16 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kwbX8-002742-Jj; Mon, 04 Jan 2021 21:53:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609811602; bh=3NSVHr65QSe5/misEmnitZ3kyjdEHvvwH86gYiinZ3I=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=H91eoS3PdysjX/7eMQ2XKD6CcuQX5uxy2tM1O1IN4Rrs9yMOHRLLJw8WrMWtR1EW8
         eJ3n4YGvCr8wCgVCnm/GMd9WLZJDX19JNhJy4tuO9qs749XCZ8gUa4jGDumAGxpNuN
         1mA84KF21n9xIGMWAMd3sCZYM4Asw8S1+z0fpzOs5pO8WjIrFZFLXcELIkvbgrPp0+
         e7hsPDPDlWwaZHuvchco2KD++e1VNmlhKm+/+tdAtUmdQToBQxK+1NGnLG/uh+b2ma
         jDfWDs9Tc4mBXyq3D+MMCaids7kfKF/2NK/ZxyfizDuwGpCkMidR3TzMW+D/Et0TO/
         SfEoBpoFztT3A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 04, 2021 at 04:51:51PM -0800, Dan Williams wrote:
> On Mon, Jan 4, 2021 at 4:14 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Mon, Jan 04, 2021 at 09:19:30PM +0000, Mark Brown wrote:
> >
> >
> > > > Regardless of the shortcut to make everything a struct
> > > > platform_device, I think it was a mistake to put OF devices on
> > > > platform_bus. Those should have remained on some of_bus even if they
> > >
> > > Like I keep saying the same thing applies to all non-enumerable buses -
> > > exactly the same considerations exist for all the other buses like I2C
> > > (including the ACPI naming issue you mention below), and for that matter
> > > with enumerable buses which can have firmware info.
> >
> > And most busses do already have their own bus type. ACPI, I2C, PCI,
> > etc. It is just a few that have been squished into platform, notably
> > OF.
> >
> 
> I'll note that ACPI is an outlier that places devices on 2 buses,
> where new acpi_driver instances are discouraged [1] in favor of
> platform_drivers. ACPI scan handlers are awkwardly integrated into the
> Linux device model.
> 
> So while I agree with sentiment that an "ACPI bus" should
> theoretically stand on its own there is legacy to unwind.
> 
> I only bring that up to keep the focus on how to organize drivers
> going forward, because trying to map some of these arguments backwards
> runs into difficulties.
> 
> [1]: http://lore.kernel.org/r/CAJZ5v0j_ReK3AGDdw7fLvmw_7knECCg2U_huKgJzQeLCy8smug@mail.gmail.com

Well, this is the exact kind of thing I think we are talking about
here..

> > It should be split up based on the unique naming scheme and any bus
> > specific API elements - like raw access to ACPI or OF data or what
> > have you for other FW bus types.
> 
> I agree that the pendulum may have swung too far towards "reuse
> existing bus_type", and auxiliary-bus unwinds some of that, but does
> the bus_type really want to be an indirection for driver apis outside
> of bus-specific operations?

If the bus is the "enumeration entity" and we define that things like
name, resources, gpio's, regulators, etc are a generic part of what is
enumerated, then it makes sense that the bus would have methods
to handle those things too.

In other words, the only way to learn what GPIO 'resource' is to ask
the enumeration mechnism that is providing the bus. If the enumeration
and bus are 1:1 then you can use a function pointer on the bus type
instead of open coding a dispatch based on an indirect indication.

Jason
