Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E0E2DEAAB
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 22:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbgLRU7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 15:59:44 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:62787 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgLRU7n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 15:59:43 -0500
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fdd18150000>; Sat, 19 Dec 2020 04:59:01 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Dec
 2020 20:59:00 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Dec 2020 20:59:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JGrbTCunII8mPTrhgoBTw/61f7RDYJe8UwipAbQA457oKdi12GwCdewc8kpYzeMAhRbHncnaZeqbp8qhsCpzryNOOMpCFLseuSDyPwVoTWdwaThxUB6G7WiQcr5RpAyp45Z2mVKKfQ8ZxfbTZX0wGKhvMytghd8h490v1WOP8ZbyaOFJ+Dwuz/vf7vI32VZb4CbSuwQ/sIoiiDX/Nvj2UTjxh/BR+7F6G6akvndRWbiSUyKwCV5Wr34xwfzM0Lxnoz7nRNJH5+X2maeM1OytktHBvoApB3IQgkRLZ7MqkaB8fdSMFQ9mD/JbuCthVJByWcpXQs4szaYhGN0d0LZWOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IDI5Cvx/QMGqhJCQkIPCkWYEOEwvb1t/i3GIrRAP0jE=;
 b=d1XIhdVhDPfoKRtu0NO2Xf+Drb+s/9Ya41Tsi9y9X8HNn9ZDTHsaGEfuhKGKdKpfMw9+4MuA9CkvN2Phiq82vpObFyFG6ZhmM7bcc4WAS6oxJtVLaX1/0SnRBjjSNjc4oCuPI6MCCUW2Pb8j2UAkEsE/iC6h6TzoKgiaclVBI7chvpYlWT/9tMRxzTbYHsDh/zTC1kKLvY//4vBynYAeQoX8BUgWxqbj9xX3+Cr2RItrVh475GdssbU9vyzYc46keBjTlL6foJGUVHP2HeKitTmg9EebV5pnqkIonhs/Ts/FLHRpBteDVjh4Zgq9j193Miu7MX5pNuUKqwGVRYm+Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1660.namprd12.prod.outlook.com (2603:10b6:4:9::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.20; Fri, 18 Dec 2020 20:58:58 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3676.025; Fri, 18 Dec 2020
 20:58:57 +0000
Date:   Fri, 18 Dec 2020 16:58:56 -0400
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
Message-ID: <20201218205856.GZ552508@nvidia.com>
References: <X8usiKhLCU3PGL9J@kroah.com> <20201217211937.GA3177478@piout.net>
 <X9xV+8Mujo4dhfU4@kroah.com> <20201218131709.GA5333@sirena.org.uk>
 <20201218140854.GW552508@nvidia.com> <20201218155204.GC5333@sirena.org.uk>
 <20201218162817.GX552508@nvidia.com> <20201218180310.GD5333@sirena.org.uk>
 <20201218184150.GY552508@nvidia.com> <20201218203211.GE5333@sirena.org.uk>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201218203211.GE5333@sirena.org.uk>
X-ClientProxiedBy: BL0PR01CA0007.prod.exchangelabs.com (2603:10b6:208:71::20)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR01CA0007.prod.exchangelabs.com (2603:10b6:208:71::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Fri, 18 Dec 2020 20:58:57 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kqMq0-00CvHl-1X; Fri, 18 Dec 2020 16:58:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608325141; bh=IDI5Cvx/QMGqhJCQkIPCkWYEOEwvb1t/i3GIrRAP0jE=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=e4U24Cpk8UCcJbcDn9+jDbjP7qDNv3rqoxrUVk5ezTKPcccWpv9boWD7Anosm1aV+
         LDBTd+U5ZAxZ0n8yQuFiSbX9fQs9KjoVI1HcueJzwi+7tyGJT8gqrzjihUqQmBo//z
         NVZEgtR3qigkwRmHnFqqiv76radIFSLMlxr56KJDVtu7StPz+r7tDiwmpK2kZtl75b
         tR/zUiflnKJT09hUyG7P5NCNla78nMTkKFf3K5HxbNJnEgE1IgSuLWdyq5BokFpaZn
         qqUvdAStiWCCNMQDWEGD8CusvNAKMxNAwW1BHvE98MqO79QCiaXYcpkTzEauq//rDC
         LJwy5agNHp11Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 08:32:11PM +0000, Mark Brown wrote:

> > So, I strongly suspect, MFD should create mfd devices on a MFD bus
> > type.
> 
> Historically people did try to create custom bus types, as I have
> pointed out before there was then pushback that these were duplicating
> the platform bus so everything uses platform bus.

Yes, I vaugely remember..

I don't know what to say, it seems Greg doesn't share this view of
platform devices as a universal device.

Reading between the lines, I suppose things would have been happier
with some kind of inheritance scheme where platform device remained as
only instantiated directly in board files, while drivers could bind to
OF/DT/ACPI/FPGA/etc device instantiations with minimal duplication &
boilerplate.

And maybe that is exactly what we have today with platform devices,
though the name is now unfortunate.

> I can't tell the difference between what it's doing and what SOF is
> doing, the code I've seen is just looking at the system it's running
> on and registering a fixed set of client devices.  It looks slightly
> different because it's registering a device at a time with some wrapper
> functions involved but that's what the code actually does.

SOF's aux bus usage in general seems weird to me, but if you think
it fits the mfd scheme of primarily describing HW to partition vs
describing a SW API then maybe it should use mfd.

The only problem with mfd as far as SOF is concerned was Greg was not
happy when he saw PCI stuff in the MFD subsystem.

This whole thing started when Intel first proposed to directly create
platform_device's in their ethernet driver and Greg had a quite strong
NAK to that.

MFD still doesn't fit what mlx5 and others in the netdev area are
trying to do. Though it could have been soe-horned it would have been
really weird to create a platform device with an empty HW resource
list. At a certain point the bus type has to mean *something*!

Jason
