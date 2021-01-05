Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6FF22EAD6C
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 15:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbhAEOhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 09:37:17 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2065 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbhAEOhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 09:37:17 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff479740000>; Tue, 05 Jan 2021 06:36:36 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 5 Jan
 2021 14:36:32 +0000
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.55) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 5 Jan 2021 14:36:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m41B1rp2qw3CGWjLE4HUj1kQIhulMVfj9wNR8TdK6Ew+PPi6T4t7dGWV7rCkdohsPwff3/QY6aKdTEZIY/na1rgYtPZ9YUU8KR4WpXHX7U/S5fCb0XEBQZzw4sxyQUEE2JmxVGgJG4yiYNsYjRxoQXo0vhXj665aswnsDpVbetzZfFDJ1NQ8kF97FKG26nTVkt3yhvybyOwS7NDgMweNc6YPcRCdPb/lQfJqTjy4rsSu+9cL+im4OojHJNmkXmN+gMKdUziFd2MAViFtFcRYbfa7c1fF+cc1yDCaWKUzsmSsq7nSRZ8X6U67l3vkimwbrMP6jDDWq4og3FR/7IO0KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PAwrKySJQvQFPuf6e10AMprqTOhIvV+daRoILtUq4QM=;
 b=V+pmMd775DjQhFXf2SydKhowmJUav5ntBDIt2xnOZmqJRMCowTbTYPotex4urT12HmZL0gSIxMkR5XgNt7kZ4A6JNhe/A42VkSDRs8HqGDD+nLBthCqxB9uV74hYqFZAS6JU65Y9X3aRXaUFmrDigPHrzAEQ+kp5gPRTU/5tmAQXCdXhrcCkiv7WNfj1zopT9NDDXY0HE0cAtxHpJg246XCPiXoRc0LUTrv8heyly2b2BFxPn87R+iVP5apmUw115LZ6SfbaNlZ9YEem1WdktyW1H2ulbSiByuuE3oqR7hm2bYmKs3ucLwaWQLVrsblALaW/3XfcmJLCfnibFYioPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2440.namprd12.prod.outlook.com (2603:10b6:4:b6::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 5 Jan
 2021 14:36:29 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3721.024; Tue, 5 Jan 2021
 14:36:29 +0000
Date:   Tue, 5 Jan 2021 10:36:27 -0400
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
Message-ID: <20210105143627.GT552508@nvidia.com>
References: <20201218162817.GX552508@nvidia.com>
 <20201218180310.GD5333@sirena.org.uk> <20201218184150.GY552508@nvidia.com>
 <20201218203211.GE5333@sirena.org.uk> <20201218205856.GZ552508@nvidia.com>
 <20201221185140.GD4521@sirena.org.uk> <20210104180831.GD552508@nvidia.com>
 <20210104211930.GI5645@sirena.org.uk> <20210105001341.GL552508@nvidia.com>
 <20210105134256.GA4487@sirena.org.uk>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210105134256.GA4487@sirena.org.uk>
X-ClientProxiedBy: BL1PR13CA0140.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::25) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BL1PR13CA0140.namprd13.prod.outlook.com (2603:10b6:208:2bb::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.4 via Frontend Transport; Tue, 5 Jan 2021 14:36:29 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kwnRj-002I0M-Hy; Tue, 05 Jan 2021 10:36:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1609857397; bh=PAwrKySJQvQFPuf6e10AMprqTOhIvV+daRoILtUq4QM=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=CQa8SH9GIYMJA6nt71T+rpipSFvqRsSJhRmvYTKsGLjtFkpVJpee92z8jmi6+loVJ
         qGYMM4abqJpYhpnynIZkqmwsl58T86E8dl2ONysMl8uBUsPc0haiUOhErMM40/kWd5
         X5ScPjNlwA1sjqDAPJ0s61OCH4UtzNl2wXkdiNJQ9BCfRlhQMji6WgCBXOpLWZjR/a
         bk403GxmonQ/QdEWS6KGmQicXEDL7QRJjthswRZ7dl5d5aBD18b6OJSluqw+3yBqTp
         KY+fTysxhVoSGKyJ/II7IK7GPpuuDqOOJry7RyPHoSx29JLUegwMPFD31x/QubCQMg
         7SwK2TAxk1lGQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 01:42:56PM +0000, Mark Brown wrote:
> On Mon, Jan 04, 2021 at 08:13:41PM -0400, Jason Gunthorpe wrote:
> > On Mon, Jan 04, 2021 at 09:19:30PM +0000, Mark Brown wrote:
> 
> > > Like I keep saying the same thing applies to all non-enumerable buses -
> > > exactly the same considerations exist for all the other buses like I2C
> > > (including the ACPI naming issue you mention below), and for that matter
> > > with enumerable buses which can have firmware info.
> 
> > And most busses do already have their own bus type. ACPI, I2C, PCI,
> > etc. It is just a few that have been squished into platform, notably
> > OF.
> 
> You're missing the point there.  I2C is enumerated by firmware in
> exactly the same way as the platform bus is, it's not discoverable from
> the hardware (and similarly for a bunch of other buses).  If we were to
> say that we need separate device types for platform devices enumerated
> using firmware then by analogy we should do the same for devices on
> these other buses that happen to be enumerated by firmware.

No, I understand how I2C works and I think it is fine as is because
the enumeration outcome is all standard. You always end up with a
stable I2C device address (the name) and you always end up with the
I2C programming API. So it doesn't matter how I2C gets enumerated, it
is always an I2C device.

PCI does this too, pci_device gets crossed over to the DT data, but it
is still a pci_device.

I see a big difference between attaching FW data to an existing
subsystem's HW centric bus (and possibly guiding enumeration of a HW
bus from FW data) and directly creating struct devices based on FW
data unconnected to any existing subsystem.

The latter case is where the enumerating FW should stay on its own
bus_type because there is no standardized subsystem bus providing an
API or naming rules, so the FW type should provide those rules
instead.

> > With an actual bus specific virtual function:
> 
> >     return dev->bus->gpio_count(dev);
> 
> That won't work, you might have a mix of enumeration types for a given
> bus type in a single system so you'd need to do this per device. 

I'm being very general here, probably what we want is a little more
formal 'fw_type' concept, so a device is on a bus and also has a FW
attachment which can provide this other data.

Jason
