Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB6D2DC5B8
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 18:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgLPRwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 12:52:05 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:6075 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728217AbgLPRwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 12:52:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fda491a0000>; Wed, 16 Dec 2020 09:51:23 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 16 Dec
 2020 17:51:17 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 16 Dec 2020 17:51:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qm1RYLBRkCd+cw5KQLW0qkUTeCE6yu+jWTx+8VJmoUglgfptjxdytSm63AoRkSMIOiCZ9I0yZ1/PXwNPX0d/sQcxmL59tXZi2uy6Kdehe/9RodVPch7/b6d6Vuv11YCYy5o+WOmBQAKhz7vVLJOoNitWldZYbHxAoEi4R2CFtSdclDSI1X/GPQJgT9N8ww5ACUlzfRL4aN1ym8NACyTMwe1EZrbbjqYrwmnA2aGL20rGXiB35OmvEOm3e3gMvcIm8dj5iWFzVzoVmfew29HzaQKz6UBOjXPcU1uBtc9u/b9vQrKzFZRGQvG13N2V4qfsjHvFgJK+7ObmA5fyptAScg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nm7l5JZ3/6GAKkaJSL42nO8Z/0bZn/nWcUO0qnpW66M=;
 b=WPNopwm8i23bHinB47RX78DHC0yXv8eOBGIZZ7RwX+wz6/niv5ifGvDsV04AO3vekgKGisDuDtV/QuvZjx7urcubj/c+Q28hQzP9NKsOPLQ9RQd4w4eSb0cMvaNzeGn46N69RZMH64oGIWLQ9Aj6U5IMtrKlWMantZcpvRl18rZPNjY75MW+DHL2OEiMmDffD5jF+lNDe7cw5tTwLgxamr7BP7c8Lo+pfX11SzP7M9ODoKPAeSPbnEj2gAXdFVQ7H+YBwdUosDwKagCHgtt4pq7/jLD7pBQh3/h1yWeyPzr9QdOQK4YC6tPfb9x+6kSdsDtzVM6HcL0hN35dRUV2WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1754.namprd12.prod.outlook.com (2603:10b6:3:10f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Wed, 16 Dec
 2020 17:51:16 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1ce9:3434:90fe:3433]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1ce9:3434:90fe:3433%3]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 17:51:15 +0000
Date:   Wed, 16 Dec 2020 13:51:12 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [net-next v4 00/15] Add mlx5 subfunction support
Message-ID: <20201216175112.GJ552508@nvidia.com>
References: <608505778d76b1b01cb3e8d19ecda5b8578f0f79.camel@kernel.org>
 <CAKgT0UfEsd0hS=iJTcVc20gohG0WQwjsGYOw1y0_=DRVbhb1Ng@mail.gmail.com>
 <ecad34f5c813591713bb59d9c5854148c3d7f291.camel@kernel.org>
 <CAKgT0UfTOqS9PBeQFexyxm7ytQzdj0j8VMG71qv4+Vn6koJ5xQ@mail.gmail.com>
 <20201216001946.GF552508@nvidia.com>
 <CAKgT0UeLBzqh=7gTLtqpOaw7HTSjG+AjXB7EkYBtwA6EJBccbg@mail.gmail.com>
 <20201216030351.GH552508@nvidia.com>
 <CAKgT0UcwP67ihaTWLY1XsVKEgysa3HnjDn_q=Sgvqnt=Uc7YQg@mail.gmail.com>
 <20201216133309.GI552508@nvidia.com>
 <CAKgT0UcRfB8a61rSWW-NPdbGh3VcX_=LCZ5J+-YjqYNtm+RhVg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKgT0UcRfB8a61rSWW-NPdbGh3VcX_=LCZ5J+-YjqYNtm+RhVg@mail.gmail.com>
X-ClientProxiedBy: MN2PR08CA0026.namprd08.prod.outlook.com
 (2603:10b6:208:239::31) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR08CA0026.namprd08.prod.outlook.com (2603:10b6:208:239::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Wed, 16 Dec 2020 17:51:14 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kpaxE-00Bh0g-E0; Wed, 16 Dec 2020 13:51:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608141083; bh=Nm7l5JZ3/6GAKkaJSL42nO8Z/0bZn/nWcUO0qnpW66M=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=K9WAVV61z6/5s5JWRDVmJVKgWDn2Z8vWVrljNQ7MQ2fRy/YQ20vTHr/TlTLajDWXb
         JgFFO89zJFU3o/74YCldwyRHiVfKd/5BUOm1ganJil+5fqTn2iP6hwRDrYmgAiQt7z
         0MJNnIlg9luD4LwL27sfWtMMltSqGkOgWtVwji3a2QlIRnYR7SyoGp60GRWwSg3fnE
         LirEPkh8zsIv8QxSEu2LxmXQEjV9+REJt5kKaLHU4NViNICTeyxfwzv+Xjlie/jkF6
         MAmXznjufd6LiTY13W0pbK0kHOnKdgNvax3uGCOViI3ZhKW5RmvzOWtAXm4rIjLiN4
         dcq8EXf9LnBHg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 08:31:44AM -0800, Alexander Duyck wrote:

> You say this will scale better but I am not even sure about that. The
> fact is SR-IOV could scale to 256 VFs, but for networking I kind of
> doubt the limitation would have been the bus number and would more
> likely be issues with packet replication and PCIe throughput,
> especially when you start dealing with east-west traffic within the
> same system.

We have been seeing deployments already hitting the 256 limit. This is
not a "theoretical use" patch set. There are already VM and container
farms with SW networking that support much more than 256 VM/containers
per server.

The optimization here is to reduce the hypervisor workload and free up
CPU cycles for the VMs/containers to consume. This means less handling
of packets in the CPU, especially for VM cases w/ SRIOV or VDPA.

Even the extra DMA on the NIC is not really a big deal. These are 400G
NICs with big fast PCI. If you top them out you are already doing an
aggregate of 400G of network traffic. That is a big number for a
single sever, it is OK.

Someone might feel differently if they did this on a 10/40G NIC, in
which case this is not the solution for their application.

> Sorry you used the word "replace", and my assumption here was that the
> goal is to get something in place that can take the place of SR-IOV so
> that you wouldn't be maintaining the two systems at the same time.
> That is my concern as I don't want us having SR-IOV, and then several
> flavors of SIOV. We need to decide on one thing that will be the way
> forward.

SRIOV has to continue until the PASID and IMS platform features are
widely available and mature. It will probably be 10 years before we
see most people able to use SIOV for everything they want.

I think we will see lots of SIOV varients, I know Intel is already
pushing SIOV parts outside netdev.

> I get that. That is why I said switchdev isn't a standard for the
> endpoint. One of the biggest issues with SR-IOV that I have seen is
> the fact that the last piece isn't really defined. We never did a good
> job of defining how the ADI should look to the guest and as a result
> it kind of stalled in adoption.

The ADI is supposed to present the HW programming API that is
desired. It is always up to the implementation.

SIOV was never a project to standardize HW programming models like
virtio-net, NVMe, etc.

> > I'm a bit surprised HW that can do macvlan can't be modeled with
> > switchdev? What is missing?
> 
> If I recall it was the fact that the hardware defaults to transmitting
> everything that doesn't match an existing rule to the external port
> unless it comes from the external port.

That seems small enough it should be resolvable, IMHO. eg some new
switch rule that matches that specific HW behavior?

> Something like the vdpa model is more like what I had in mind. Only
> vdpa only works for the userspace networking case.

That's because making a driver that converts the native HW to VDPA and
then running a generic netdev on the resulting virtio-net is a pretty
wild thing to do. I can't really think of an actual use case.

> Basically the idea is to have an assignable device interface that
> isn't directly tied to the hardware. 

The switchdev model is to create a switch port. As I explained in
Linux we see "pci device" and "aux device" as being some "user port"
options to access to that switch.

If you want a "generic device" that is fine, but what exactly is that
programming interface in Linux? Sketch out an API, where does the idea
go?  What does the driver that implement it look like? What consumes
it?

Should this be a great idea, then a mlx5 version of this will still be
to create an SF aux device, bind mlx5_core, then bind "generic device"
on top of that. This is simply a reflection of how the mlx5 HW/SW
layering works. Squashing all of this into a single layer is work with
no bad ROI.

> they are pushed into containers you don't have to rip them out if for
> some reason you need to change the network configuration. 

Why would you need to rip them out?

Jason
