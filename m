Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51AE2B85D4
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgKRUma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:42:30 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7442 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgKRUm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 15:42:29 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb5872b0003>; Wed, 18 Nov 2020 12:42:19 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 18 Nov
 2020 20:42:29 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 18 Nov 2020 20:42:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QvHt7seuM5CQokARn0Xguq+WOWS50EigiMlWofvmjaumLdrvayqTpwbwQP0ib3ydLhwo4yDosRpG+noR/nRMH7X5+W6nBKWr3nT4PtYnVPsRD2nLJSF9+0qua+fU06Ar3UwSuFv8UKF8KF+8yGF/ezX2zZVClllqRF/X9mC5uY4Qoa/CGx4DcR6V/TnDQRplDUR9IIiMYJ0gP0XhoDmhfHBwZtGWHoNhfSXwwqqbAt75E/Rjm5KfJlcmfAmJFAuZgbpMQxwXKJDgKirKAiK9+a8e5jkgMZcxUpSHtO4hWpSV+as8HkTbfLMTlX+sIZE3k1oAy42vQmvEootxnhoZAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P3sKtobY9FDohelesmaY4d4N72d9+aYWxfSqsCUl9lk=;
 b=C3GPwJrwY0sUGuosGf+uAz7VCcC+omIPlDvoXjg5dj4UUTizERMh/ps8/rVKF1RRmRXe/hUz9covh3TEm7sOKFMtgAir+gI+421wPa2ZUK4B0VJXw53/xmLCMJ06EYunwDVpdSC0wLHuxweRbvBlxQy6figlWaqY4POx1nSLyPFfC1l8cDsl/OFyHDxGYQhI0GmkVVy8mwExGJv4/PVbmj65XHCenAQ6FyOc29hFOoI3gMdJzfEV/+Xcf1Ko4u9DYDPiCtdAv9wMlx5knWck6Rx3NGW9Pa+hOzcceBeI5cbOvHEpcnzirXZSaMmxiddkYCdvHoWPq8nBjAVPT92mdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3737.namprd12.prod.outlook.com (2603:10b6:5:1c5::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Wed, 18 Nov
 2020 20:42:27 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9%7]) with mapi id 15.20.3564.028; Wed, 18 Nov 2020
 20:42:27 +0000
Date:   Wed, 18 Nov 2020 16:42:26 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Ahern <dsahern@gmail.com>
CC:     Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vu Pham <vuhuong@nvidia.com>
Subject: Re: [PATCH net-next 03/13] devlink: Support add and delete devlink
 port
Message-ID: <20201118204226.GB917484@nvidia.com>
References: <20201112192424.2742-1-parav@nvidia.com>
 <20201112192424.2742-4-parav@nvidia.com>
 <e7b2b21f-b7d0-edd5-1af0-a52e2fc542ce@gmail.com>
 <BY5PR12MB43222AB94ED279AF9B710FF1DCE10@BY5PR12MB4322.namprd12.prod.outlook.com>
 <b34d8427-51c0-0bbd-471e-1af30375c702@gmail.com>
 <20201118183830.GA917484@nvidia.com>
 <ac0c5a69-06e4-3809-c778-b27d6e437ed5@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ac0c5a69-06e4-3809-c778-b27d6e437ed5@gmail.com>
X-ClientProxiedBy: BL0PR0102CA0028.prod.exchangelabs.com
 (2603:10b6:207:18::41) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR0102CA0028.prod.exchangelabs.com (2603:10b6:207:18::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Wed, 18 Nov 2020 20:42:27 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kfUHa-007s1f-20; Wed, 18 Nov 2020 16:42:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605732139; bh=P3sKtobY9FDohelesmaY4d4N72d9+aYWxfSqsCUl9lk=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=BiwJS/cHk2FsM3oONlnIPi6Q9obUeVvm+tmhL49QTod7NVs5SMfVX6rXO79NKnAFp
         TuZGZRBbxA9xY3WGk8epVa1s58rxLwXS19cltxu/lFTgikf7lRhDW53pBoV+UlWAHF
         Oc9LqPERrsNbqp+zw85lBfBKwqy/ohWPryEQjoSaaqrvxIGidIhwrSnjxilQYGKzSt
         tKKmTtjULtRnfOBC66nphM4M/F02pNK4TveFtXcEt7MRd0/lFgKSlHa1YPAi1nsOmA
         6Tlwe/goNfyHgyDI8oM4/FxOpIBsJebWyULu9jUaHKo6ye2ZJD7rqvXBeJIfmh0IDq
         sKU989AI3fGpA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 12:36:26PM -0700, David Ahern wrote:
> On 11/18/20 11:38 AM, Jason Gunthorpe wrote:
> > On Wed, Nov 18, 2020 at 11:03:24AM -0700, David Ahern wrote:
> > 
> >> With Connectx-4 Lx for example the netdev can have at most 63 queues
> > 
> > What netdev calls a queue is really a "can the device deliver
> > interrupts and packets to a given per-CPU queue" and covers a whole
> > spectrum of smaller limits like RSS scheme, # of available interrupts,
> > ability of the device to create queues, etc.
> > 
> > CX4Lx can create a huge number of queues, but hits one of these limits
> > that mean netdev's specific usage can't scale up. Other stuff like
> > RDMA doesn't have the same limits, and has tonnes of queues.
> > 
> > What seems to be needed is a resource controller concept like cgroup
> > has for processes. The system is really organized into a tree:
> > 
> >            physical device
> >               mlx5_core
> >         /      |      \      \                        (aux bus)
> >      netdev   rdma    vdpa   SF  etc
> >                              |                        (aux bus)
> >                            mlx5_core
> >                           /      \                    (aux bus)
> >                        netdev   vdpa
> > 
> > And it does make a lot of sense to start to talk about limits at each
> > tree level.
> > 
> > eg the top of the tree may have 128 physical interrupts. With 128 CPU
> > cores that isn't enough interrupts to support all of those things
> > concurrently.
> > 
> > So the user may want to configure:
> >  - The first level netdev only gets 64,
> >  - 3rd level mlx5_core gets 32 
> >  - Final level vdpa gets 8
> > 
> > Other stuff has to fight it out with the remaining shared interrupts.
> > 
> > In netdev land # of interrupts governs # of queues
> > 
> > For RDMA # of interrupts limits the CPU affinities for queues
> > 
> > VPDA limits the # of VMs that can use VT-d
> > 
> > The same story repeats for other less general resources, mlx5 also
> > has consumption of limited BAR space, and consumption of some limited
> > memory elements. These numbers are much bigger and may not need
> > explicit governing, but the general concept holds.
> > 
> > It would be very nice if the limit could be injected when the aux
> > device is created but before the driver is bound. I'm not sure how to
> > manage that though..
> > 
> > I assume other devices will be different, maybe some devices have a
> > limit on the number of total queues, or a limit on the number of
> > VDPA or RDMA devices.
> 
> A lot of low level resource details that need to be summarized into a
> nicer user / config perspective to specify limits / allocations.

Well, now that we have the aux bus stuff there is a nice natural place
to put things..

The aux bus owner device (mlx5_core) could have a list of available
resources

Each aux bus device (netdev/rdma/vdpa) could have a list of consumed
resources

Some API to place a limit on the consumed resources at each aux bus
device.

The tricky bit is the auto-probing/configure. By the time the user has
a chance to apply a limit the drivers are already bound and have
already done their setup. So each subsystem has to support dynamically
imposing a limit..

And I simplified things a bit above too, we actually have two kinds of
interrupt demand: sharable and dedicated. The actual need is to carve
out a bunch of dedicated interrupts and only allow subsystems that are
doing VT-d guest interrupt assignment to consume them (eg VDPA)

Jason
