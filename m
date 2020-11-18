Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABB42B83F5
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 19:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgKRSig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 13:38:36 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:63783 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbgKRSig (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 13:38:36 -0500
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb56a2a0000>; Thu, 19 Nov 2020 02:38:34 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 18 Nov
 2020 18:38:34 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 18 Nov 2020 18:38:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3zVkCPdIydQFmGgrSeui7NLNZAb/NToe0Jns/kldc6EIR9rGIGnZOQb1McBK15xEq1nyTjUATJS7Iz3nZKi3ra+y4fatWNmHxVpuhzatJX0EiPWvwJ5Y+5fim22zvqZzz6F6Y2QUMJky8ZRYkZn1VmufZFQxjEW14hdbs/HYhAUSzjT6Gk5ejCWqAUzyJcvlBoQUeiavxMjs6gdWt/Uwt/OPkS5xy9WqneqPNbW/ThjKJ3WxkoT39FTvWxS3yFj68WisKLwpfaI0LdQkrli/Xw/nPc6OIq5/5TbWTHrTsX2gV4LhFSz+enj1lICyJZ/bTrrLR1n6FGUo+cnryCYsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MYKhiLwmvWlpvlGROuoP9wg6zdOwuThucrHKDRyYJV4=;
 b=PRsL1VBXvKIs/fQx4cCimt6tKzKn+0qo6n1M1DRG0D1tQJC0h6thhy8TWlsZ/e+B4um+vIfz+d+PlP50wxuemeGfcR5CN6oRFZtSR9gECRxRBKDf0fXDlVAgQp0SdlrJrNM153dck5o6phNRJGnZGFkiIc2//YEcskwK2z6AEzXSRaCnao4DaG1vZOHt2hDbREenvLo3ZFoOO+oOod1PjYQZKz/CVeWjPOkYLTJI4rl365AqnzbPTn69Vkin+ip8Aa6fGAI9VXNJdGKRFfbFlkIGM77wG91OUennW6+/rAhpqU7ikK0xiXXfb+RZCzTw+7DXUkZKIb411OIlTcPinQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0106.namprd12.prod.outlook.com (2603:10b6:4:4f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Wed, 18 Nov
 2020 18:38:32 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9%7]) with mapi id 15.20.3564.028; Wed, 18 Nov 2020
 18:38:32 +0000
Date:   Wed, 18 Nov 2020 14:38:30 -0400
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
Message-ID: <20201118183830.GA917484@nvidia.com>
References: <20201112192424.2742-1-parav@nvidia.com>
 <20201112192424.2742-4-parav@nvidia.com>
 <e7b2b21f-b7d0-edd5-1af0-a52e2fc542ce@gmail.com>
 <BY5PR12MB43222AB94ED279AF9B710FF1DCE10@BY5PR12MB4322.namprd12.prod.outlook.com>
 <b34d8427-51c0-0bbd-471e-1af30375c702@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b34d8427-51c0-0bbd-471e-1af30375c702@gmail.com>
X-ClientProxiedBy: BL1PR13CA0266.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::31) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL1PR13CA0266.namprd13.prod.outlook.com (2603:10b6:208:2ba::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.9 via Frontend Transport; Wed, 18 Nov 2020 18:38:32 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kfSLe-007pL1-4d; Wed, 18 Nov 2020 14:38:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605724714; bh=MYKhiLwmvWlpvlGROuoP9wg6zdOwuThucrHKDRyYJV4=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=TPUT8yb0yx7tYU+r49P5E0L5sUkJaijO8kVBKb4DSxQjEyzU4xP6ITRpzQYmJjcpQ
         6TkgeMbKhGujR3foixB7wfMwFMvJJuGD1QNwiM4ziJs+gaQFpZA4L1E4OqCWzeAZb6
         /e/8DBfQrXn1NhrIg6VAFMINtyXBhsNeNJLJpq5q99fFQq9czU0h3u4rFwfDogRsoi
         JbBYkRYHJJg9zjYoZ0CFUZwUmt8q208XnvMYYQ8PSPGARHc9QzXITPz3BriZ71h9yJ
         ejdzpKqXc4bZ6YD+uUL6JqcwM1z5vS0fPjMFqiUYVvHVheLGHJHgWlAQZUp480uCxl
         pGdi5XXfd/soA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 11:03:24AM -0700, David Ahern wrote:

> With Connectx-4 Lx for example the netdev can have at most 63 queues

What netdev calls a queue is really a "can the device deliver
interrupts and packets to a given per-CPU queue" and covers a whole
spectrum of smaller limits like RSS scheme, # of available interrupts,
ability of the device to create queues, etc.

CX4Lx can create a huge number of queues, but hits one of these limits
that mean netdev's specific usage can't scale up. Other stuff like
RDMA doesn't have the same limits, and has tonnes of queues.

What seems to be needed is a resource controller concept like cgroup
has for processes. The system is really organized into a tree:

           physical device
              mlx5_core
        /      |      \      \                        (aux bus)
     netdev   rdma    vdpa   SF  etc
                             |                        (aux bus)
                           mlx5_core
                          /      \                    (aux bus)
                       netdev   vdpa

And it does make a lot of sense to start to talk about limits at each
tree level.

eg the top of the tree may have 128 physical interrupts. With 128 CPU
cores that isn't enough interrupts to support all of those things
concurrently.

So the user may want to configure:
 - The first level netdev only gets 64,
 - 3rd level mlx5_core gets 32 
 - Final level vdpa gets 8

Other stuff has to fight it out with the remaining shared interrupts.

In netdev land # of interrupts governs # of queues

For RDMA # of interrupts limits the CPU affinities for queues

VPDA limits the # of VMs that can use VT-d

The same story repeats for other less general resources, mlx5 also
has consumption of limited BAR space, and consumption of some limited
memory elements. These numbers are much bigger and may not need
explicit governing, but the general concept holds.

It would be very nice if the limit could be injected when the aux
device is created but before the driver is bound. I'm not sure how to
manage that though..

I assume other devices will be different, maybe some devices have a
limit on the number of total queues, or a limit on the number of
VDPA or RDMA devices.

Jason
