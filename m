Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7772DB98A
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 04:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbgLPDEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 22:04:43 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:35174 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgLPDEn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 22:04:43 -0500
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd979200000>; Wed, 16 Dec 2020 11:04:00 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 16 Dec
 2020 03:03:56 +0000
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 16 Dec 2020 03:03:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DeRR3yXPv8TR7N/jhDM6wse7ffZXOyMwQJQqZ3g1mC3QATgS7OQCGkjEi0QrJevsk8w/nj4tXLxYCHyQiJgB6PTn5yvGc12nvrx+ewlEbXYp4XM+zcQUbrnOm0fwjaeqJ4ppz2R/UYf4R5TSRj3/5EYToUX9fnjzSIZm9jG0FZrCARC5CQIWbbz4jWKlwsXkym7UdtZKrZIjNH9yUOsnwaVceEw32GiaMvmeb6oYEnVIRFAn5KrF1mhSu/mT/Kxs6KZIFpvrBNmb6l1WDgbNM5sJBnmmrKvFtP6zl+XKnWOBsLzfHnyqHDNvYfhQDPfEaibiMM+zmjYPvW3rvbLdkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=toHfv58wc24MxcQlpE3jVD2WDShA7Rl6YdC+MTXoZkg=;
 b=QRI899ShywbAMqEJ0CxksY/BejV0CieOkSH995v2EEVTX//WXySLLQ8gGrQJOAYv1kHG6cJF4q0PL2WDTDiEsrZPnaAcMYhdcj4ODR/6aqvOpP6c+GciX8J+DGkDZ4E3VTZck6x35Ih68pKfkIi1egyRWkC+xPEYWiBOKlAJO1NSqsZLXa+SZSl/tz0hJagU3bUHODIsAQa5uZtZbUnAm19rJEZn192q4qHjevZuRbLr50+7m8J3FrycnZrHV6CwaxdtNwtArBs2xQlQGCQn/Vw5vC5T+M2praoEwMeSIdySjMkicjiR/O01B2Fy6LPx5M9YTDTF73saCX4iPvqEDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2437.namprd12.prod.outlook.com (2603:10b6:4:ba::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.24; Wed, 16 Dec
 2020 03:03:53 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1ce9:3434:90fe:3433]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1ce9:3434:90fe:3433%3]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 03:03:53 +0000
Date:   Tue, 15 Dec 2020 23:03:51 -0400
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
Message-ID: <20201216030351.GH552508@nvidia.com>
References: <20201214214352.198172-1-saeed@kernel.org>
 <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
 <608505778d76b1b01cb3e8d19ecda5b8578f0f79.camel@kernel.org>
 <CAKgT0UfEsd0hS=iJTcVc20gohG0WQwjsGYOw1y0_=DRVbhb1Ng@mail.gmail.com>
 <ecad34f5c813591713bb59d9c5854148c3d7f291.camel@kernel.org>
 <CAKgT0UfTOqS9PBeQFexyxm7ytQzdj0j8VMG71qv4+Vn6koJ5xQ@mail.gmail.com>
 <20201216001946.GF552508@nvidia.com>
 <CAKgT0UeLBzqh=7gTLtqpOaw7HTSjG+AjXB7EkYBtwA6EJBccbg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKgT0UeLBzqh=7gTLtqpOaw7HTSjG+AjXB7EkYBtwA6EJBccbg@mail.gmail.com>
X-ClientProxiedBy: MN2PR14CA0003.namprd14.prod.outlook.com
 (2603:10b6:208:23e::8) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR14CA0003.namprd14.prod.outlook.com (2603:10b6:208:23e::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Wed, 16 Dec 2020 03:03:52 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kpN6V-00B7g6-Tf; Tue, 15 Dec 2020 23:03:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608087840; bh=toHfv58wc24MxcQlpE3jVD2WDShA7Rl6YdC+MTXoZkg=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=XKn+/vUbTN/qXIbjKDjpANztxAcbC55i1qWyJ3GyNTyQ/pwP+9QTq6zQmXfHHdzlA
         I8zUAEp1mle+FeTwJtjmgeP+qYswjfbXt6ExseKVlLzGDXZtnTKawi8VySCu5uo+UT
         dcmPHne0TF4dKFB4FzSdfIh035ryz2DqZoAw0VL2wHp4kE4vrQIB/JKbX97LReqo5Y
         c+Ep97Nfc6ZVLdPXB41STMxsM211vj40z8SndhawQT5vqg+C/w8JuRNjxU0AR25aN/
         gYpsL45v7k42j93zAnLhWNDcK5eYNkXqg/vuWWs74tpieZq4Ef973RT8Lgm22jAxGk
         336eAoTR4J/PA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 06:19:18PM -0800, Alexander Duyck wrote:

> > > I would really like to see is a solid standardization of what this is.
> > > Otherwise the comparison is going to be made. Especially since a year
> > > ago Mellanox was pushing this as an mdev type interface.
> >
> > mdev was NAK'd too.
> >
> > mdev is only for creating /dev/vfio/*.
> 
> Agreed. However my worry is that as we start looking to make this
> support virtualization it will still end up swinging more toward
> mdev.

Of course. mdev is also the only way to create a /dev/vfio/* :)

So all paths that want to use vfio must end up creating a mdev.

Here we would choose to create the mdev on top of the SF aux device.
There isn't really anything mlx5 specific about that decision. 

The SF models the vendor specific ADI in the driver model.

> It isn't so much about right or wrong but he use cases. My experience
> has been that SR-IOV ends up being used for very niche use cases where
> you are direct assigning it into either DPDK or some NFV VM and you
> are essentially building the application around the NIC. It is all
> well and good, but for general virtualization it never really caught
> on.

Sure
 
> > So encourage other vendors to support the switchdev model for managing
> > VFs and ADIs!
> 
> Ugh, don't get me started on switchdev. The biggest issue as I see it
> with switchev is that you have to have a true switch in order to
> really be able to use it. 

That cuts both ways, suggesting HW with a true switch model itself
with VMDq is equally problematic.

> As such dumbed down hardware like the ixgbe for instance cannot use
> it since it defaults to outputting anything that doesn't have an
> existing rule to the external port. If we could tweak the design to
> allow for more dumbed down hardware it would probably be much easier
> to get wider adoption.

I'd agree with this

> interface, but keep the SF interface simple. Then you can back it with
> whatever you want, but without having to have a vendor specific
> version of the interface being plugged into the guest or container.

The entire point *is* to create the vendor version because that serves
the niche cases where SRIOV assignment is already being used.

Having a general solution that can't do vendor SRIOV is useful for
other application, but doesn't eliminate the need for the SRIOV case.

> One of the reasons why virtio-net is being pushed as a common
> interface for vendors is for this reason. It is an interface that can
> be emulated by software or hardware and it allows the guest to run on
> any arbitrary hardware.

Yes, and there is mlx5_vdpa to support this usecase, and it binds to
the SF. Of course all of that is vendor specific too, the driver to
convert HW specifc register programming into a virio-net ADI has to
live *somewhere*

> It has plenty to do with this series. This topic has been under
> discussion since something like 2017 when Mellanox first brought it up
> at Netdev 2.1. At the time I told them they should implement this as a
> veth offload. 

veth doesn't give an ADI, it is useless for these niche cases.

veth offload might be interesting for some container case, but feels
like writing an enormous amount of code to accomplish nothing new...

> Then it becomes obvious what the fallback becomes as you can place
> packets into one end of a veth and it comes out the other, just like
> a switchdev representor and the SF in this case. It would make much
> more sense to do it this way rather than setting up yet another
> vendor proprietary interface pair.

I agree it makes sense to have an all SW veth-like option, but I
wouldn't try to make that as the entry point for all the HW
acceleration or to serve the niche SRIOV use cases, or to represent an
ADI.

It just can't do that and it would make a huge mess if you tried to
force it. Didn't Intel already try this once with trying to use the
macvlan netdev and its queue offload to build an ADI?

> > Anyhow, if such a thing exists someday it could make sense to
> > automatically substitute the HW version using a SF, if available.
> 
> The main problem as I see it is the fact that the SF interface is
> bound too tightly to the hardware. 

That is goal here. This is not about creating just a netdev, this is
about the whole kit: rdma, netdev, vdpa virtio-net, virtio-mdev.

The SF has to support all of that completely. Focusing only on the
one use case of netdevs in containers misses the bigger picture. 

Yes, lots of this stuff is niche, but niche stuff needs to be
supported too.

> Yes, it is a standard feature set for the control plane. However for
> the data-path it is somewhat limited as I feel it only describes what
> goes through the switch.

Sure, I think that is its main point.

> Not the interfaces that are exposed as the endpoints. 

It came from modeling physical HW so the endports are 'physical'
things like actual HW switch ports, or SRIOV VFs, ADI, etc.

> It is the problem of that last bit and how it is handled that can
> make things ugly. For example the multicast/broadcast replication
> problem that just occurred to me while writing this up.  The fact is
> for east-west traffic there has always been a problem with the
> switchdev model as it limits everything to PCIe/DMA so there are
> cases where software switches can outperform the hardware ones.

Yes, but, mixing CPU and DMA in the same packet delivery scheme is
very complicated :)

Jason
