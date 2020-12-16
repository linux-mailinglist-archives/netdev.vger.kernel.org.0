Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E1F2DB7C3
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 01:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgLPAUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 19:20:45 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:29553 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725777AbgLPAUk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 19:20:40 -0500
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd952ad0000>; Wed, 16 Dec 2020 08:19:57 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 16 Dec
 2020 00:19:53 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 16 Dec 2020 00:19:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+SU8GHRnn5YwzhE+L++RyigEr11CNvR2WPlzv7vqX049RbnvvV2Juot6FhyGsyPMGzzp4dZSIOARi/RLnVa+G106WlSaZG32GbrCzwbrILyUev0KdZqFPJEVpQTeh5F6/pLEHenx1dBamtwDOqFJOW5E5A3HmE5QKJb8cTeWap2t2SgOFVx/XnETrL85lwC7nTBk/4qAmGnDG0h4v1e12Bru3o8t5Vt/2jDfWL85vWbuRBjSuTOJQXINIkPaj3yJRajqZ3/6stR3FJ5SZr+8XHk0ykm7lHJm0vnxM/tXkcTa9WGTeeUkyuoV5fP+pL45wDQm/0hoFklQ0rMzQZlAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TeSFjQpX2b+k755ADGAi/aP2UHQbRfpQGQi/uWg0ljM=;
 b=NcOMyDBS6FozNVzU2AiXFlowb64qb8v3Ehmzvrt230nAUBlRTGvOsD71TGpJUF2Eoi/iCSWfeIbbKH3pLgzb4jc2sfTSC1EVvqLD6TtpQ9R93qbO8C3OZZslwfoVAq2zG8cZNmtYh9VatCXOxv32kElPoupYHmp1tVn8rGJcUH0lEaRCWSPNYcsiPBYO3xdvhK2xU5vGKNlbpTWY7LxntGeIUUXjHRDRu8YR2pzAzIFZvvt0u/Yvs6iUUXzG6jPK2GjZNyzKtmvrny2ap2LV3VloAjjwgsUJdrENSRO/Yq00W+5UvjJaLfSlHDeZTjG+ISBENDz4XORQ7d2SUKxyKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1433.namprd12.prod.outlook.com (2603:10b6:3:73::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Wed, 16 Dec
 2020 00:19:51 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1ce9:3434:90fe:3433]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1ce9:3434:90fe:3433%3]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 00:19:51 +0000
Date:   Tue, 15 Dec 2020 20:19:46 -0400
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
Message-ID: <20201216001946.GF552508@nvidia.com>
References: <20201214214352.198172-1-saeed@kernel.org>
 <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
 <608505778d76b1b01cb3e8d19ecda5b8578f0f79.camel@kernel.org>
 <CAKgT0UfEsd0hS=iJTcVc20gohG0WQwjsGYOw1y0_=DRVbhb1Ng@mail.gmail.com>
 <ecad34f5c813591713bb59d9c5854148c3d7f291.camel@kernel.org>
 <CAKgT0UfTOqS9PBeQFexyxm7ytQzdj0j8VMG71qv4+Vn6koJ5xQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKgT0UfTOqS9PBeQFexyxm7ytQzdj0j8VMG71qv4+Vn6koJ5xQ@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0025.namprd13.prod.outlook.com
 (2603:10b6:208:256::30) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0025.namprd13.prod.outlook.com (2603:10b6:208:256::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.9 via Frontend Transport; Wed, 16 Dec 2020 00:19:48 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kpKXi-00B5aB-Vv; Tue, 15 Dec 2020 20:19:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608077997; bh=TeSFjQpX2b+k755ADGAi/aP2UHQbRfpQGQi/uWg0ljM=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=BEYKo1M1KynNQaxQNpJDKS3TsU9UEZVS7LKKF4fj5YypY3zb9Ysy5fWlFruh/6kMb
         wdG3Tr4/J7fV2P+LFsc+yywvMht9llKb7BZeYNEuASdGv/6EH/9eirMDnZLrTk5n9B
         343iGdvJFgATxeA9aCj7l1KLk14Y/JxEuAthlS6/J5hFoMLKikqtVek27l+AyK0DPq
         fP1ZF3Eax5vxbIrRj46tvy/vJeX9tX3Mlg6WpXhKVTxX7zqa6O2KuYBQeSocKa39Qu
         X+/RcppfT5ZXrYRcVAgjxNan9ov2EX/dwfiMGtMvQIfG7P9gf2grnAVIfDwE9ZtLYX
         3mICWw4PrMA3Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 01:41:04PM -0800, Alexander Duyck wrote:

> > not just devlink and switchdev, auxbus was also introduced to
> > standardize some of the interfaces.
> 
> The auxbus is just there to make up for the fact that there isn't
> another bus type for this though. I would imagine otherwise this would
> be on some sort of platform bus.

Please lets not start this again. This was gone over with Greg for
literally a year and a half and he explicitly NAK'd platform bus for
this purpose.

Aux bus exists to connect different kernel subsystems that touch the
same HW block together. Here we have the mlx5_core subsystem, vdpa,
rdma, and netdev all being linked together using auxbus.

It is kind of like what MFD does, but again, using MFD for this was
also NAK'd by Greg.

At the very worst we might sometime find out there is some common
stuff between ADIs that we might get an ADI bus, but I'm not
optimistic. So far it looks like there is no commonality.

Aux bus has at least 4 users already in various stages of submission,
and many other target areas that should be replaced by it.

> I would really like to see is a solid standardization of what this is.
> Otherwise the comparison is going to be made. Especially since a year
> ago Mellanox was pushing this as an mdev type interface. 

mdev was NAK'd too.

mdev is only for creating /dev/vfio/*.

> That is all well and good. However if we agree that SR-IOV wasn't done
> right saying that you are spinning up something that works just like
> SR-IOV isn't all that appealing, is it?

Fitting into some universal least-common-denominator was never a goal
for SR-IOV, so I wouldn't agree it was done wrong. 

> I am talking about my perspective. From what I have seen, one-off
> features that are only available from specific vendors are a pain to
> deal with and difficult to enable when you have to support multiple
> vendors within your ecosystem. What you end up going for is usually
> the lowest common denominator because you ideally want to be able to
> configure all your devices the same and have one recipe for setup.

So encourage other vendors to support the switchdev model for managing
VFs and ADIs!

> I'm not saying you cannot enable those features. However at the same
> time I am saying it would be nice to have a vendor neutral way of
> dealing with those if we are going to support SF, ideally with some
> sort of software fallback that may not perform as well but will at
> least get us the same functionality.

Is it really true there is no way to create a software device on a
switchdev today? I looked for a while and couldn't find
anything. openvswitch can do this, so it does seem like a gap, but
this has nothing to do with this series.

A software switchdev path should still end up with the representor and
user facing netdev, and the behavior of the two netdevs should be
identical to the VF switchdev flow we already have today.

SF doesn't change any of this, it just shines a light that, yes,
people actually have been using VFs with netdevs in containers and
switchdev, as part of their operations.

FWIW, I view this as a positive because it shows the switchdev model
is working very well and seeing adoption beyond the original idea of
controlling VMs with SRIOV.

> I'm trying to remember which netdev conference it was. I referred to
> this as a veth switchdev offload when something like this was first
> brought up. 

Sure, though I think the way you'd create such a thing might be
different. These APIs are really about creating an ADI that might be
assigned to a VM and never have a netdev.

It would be nonsense to create a veth-switchdev thing with out a
netdev, and there have been various past attempts already NAK'd to
transform a netdev into an ADI.

Anyhow, if such a thing exists someday it could make sense to
automatically substitute the HW version using a SF, if available.

> could address those needs would be a good way to go for this as it
> would force everyone to come together and define a standardized
> feature set that all of the vendors would want to expose.

I would say switchdev is already the standard feature set.
 
Jason
