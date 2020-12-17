Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B382DD975
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 20:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbgLQTl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 14:41:27 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:54657 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727388AbgLQTl0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 14:41:26 -0500
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fdbb43c0000>; Fri, 18 Dec 2020 03:40:44 +0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Dec
 2020 19:40:40 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 17 Dec 2020 19:40:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jo/Y377HLva3cTaxy0UDAm9SZ2X/6/um58ISbvRNPElPDF+nQz/DS8P3CtWs1i620VMf55MXZXAl2RXLrFqnzGYk2MiSTVpZPEj4fySJ4uH3pkw0MLrDxCRTV/LlWz2lMI7R1Wxs6GmnGSWWuTOAZnAKQEah8QF5QD1Ra86B0ohIcpx76uTPqFz+OoF2qFgcNuES6Hqby3CYajwyyQIHvoo6HifdXPsrZtbenqajJlsivk0XMHMfYRP+PIphZ7y5jkwleYkdcVyi1de8GEhuySUmk6uBjzjUAhzt+thYXTVetFalLf82RIPpP4In3KhP8A42f5Ey7MJntNxFe9T75Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l45ZnB9WWkXhQEZNjA5XIXHWyT1VEkjd5odqSBMAgLs=;
 b=VnHbpKvbXzRkSXJodKv1+ZLb6h+KzSMCf+KayvjWSiUemLsXXCLjC1NVDhPwS+ZJBYDxTqBDk7ccGsY+HkQ28BfZNBFQHqZbDN/Dh4tqXxSg3X52Ks/mFKg9iw06Yq2o2iKdN3ezCXmZ6GxxOg/JPaZp+N7m3DqW/X8oN8lrw0lREkt47LgAfqVdw4pzGbtjHu9fg+neTLxJLUBgs8dEpw9dfG2MXb/9srZXjlKWnZYhR5WuhJxepkQttAS/ISRMC6ij/ZxL+WNbkgLHyjZmdJuOS7OvcTVgREwnwxDqM+gtWvkTUHkVEoT2z2A6d51XcAIrUB73F7G6SS3LmbILPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from CH2PR12MB3831.namprd12.prod.outlook.com (2603:10b6:610:29::13)
 by CH2PR12MB4072.namprd12.prod.outlook.com (2603:10b6:610:7e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Thu, 17 Dec
 2020 19:40:38 +0000
Received: from CH2PR12MB3831.namprd12.prod.outlook.com
 ([fe80::9935:c6d7:b453:861f]) by CH2PR12MB3831.namprd12.prod.outlook.com
 ([fe80::9935:c6d7:b453:861f%5]) with mapi id 15.20.3654.024; Thu, 17 Dec 2020
 19:40:37 +0000
Date:   Thu, 17 Dec 2020 15:40:35 -0400
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
Message-ID: <20201217194035.GT552508@nvidia.com>
References: <20201216030351.GH552508@nvidia.com>
 <CAKgT0UcwP67ihaTWLY1XsVKEgysa3HnjDn_q=Sgvqnt=Uc7YQg@mail.gmail.com>
 <20201216133309.GI552508@nvidia.com>
 <CAKgT0UcRfB8a61rSWW-NPdbGh3VcX_=LCZ5J+-YjqYNtm+RhVg@mail.gmail.com>
 <20201216175112.GJ552508@nvidia.com>
 <CAKgT0Uerqg5F5=jrn5Lu33+9Y6pS3=NLnOfvQ0dEZug6Ev5S6A@mail.gmail.com>
 <20201216203537.GM552508@nvidia.com>
 <CAKgT0UfuSA9PdtR6ftcq0_JO48Yp4N2ggEMiX9zrXkK6tN4Pmw@mail.gmail.com>
 <20201217003829.GN552508@nvidia.com>
 <CAKgT0UcEjekh0Z+A+aZKWJmeudr5CZTXPwPtYb52pokDi1TF_w@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKgT0UcEjekh0Z+A+aZKWJmeudr5CZTXPwPtYb52pokDi1TF_w@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0323.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::28) To CH2PR12MB3831.namprd12.prod.outlook.com
 (2603:10b6:610:29::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0323.namprd13.prod.outlook.com (2603:10b6:208:2c1::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.13 via Frontend Transport; Thu, 17 Dec 2020 19:40:37 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kpz8d-00CLy1-Sx; Thu, 17 Dec 2020 15:40:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608234044; bh=l45ZnB9WWkXhQEZNjA5XIXHWyT1VEkjd5odqSBMAgLs=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=nY98WXb1i5bgftedXuba1JyqrU3dcqSYcVnbSbdPOYp7SyLW7oJezaLeDW7YOJmyY
         lxo/ZNa76YdslSjQvoPJB3R2Sh5nimsxv7Ua1RDqMRJqfGwuR4C7M26vs8XoV19PrO
         bqnoeJ68FxmzZsJpr/334rAsKZ5J0cPK/6V/zGtDNv3YDcQchldw+G66mR0vU6RFuo
         Re0ecGHKuF5zRj1sL3eUJTEC1DUQJFStKsLS6cjmFVoM4JjYXsaiA71UYVjJEwcn9B
         TD81D8TVtvx8oS1vM3ZtgyIY+McIcfomO4wErtUdu9NXWPgDYZ1tUNxIvfpuHn56S8
         Jp67bFTJ4ZvLw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 10:48:48AM -0800, Alexander Duyck wrote:

> Just to clarify I am not with Intel, nor do I plan to work on any
> Intel drivers related to this.

Sure
 
> I disagree here. In my mind a design where two interfaces, which both
> exist in the kernel, have to go to hardware in order to communicate is
> very limiting. The main thing I am wanting to see is the option of
> being able to pass traffic directly between the switchdev and the SF
> without the need to touch the hardware.

I view the SW bypass path you are talking about similarly to
GSO/etc. It should be accessed by the HW driver as an optional service
provided by the core netdev, not implemented as some wrapper netdev
around a HW implementation.

If you feel strongly it is needed then there is nothing standing in
the way to implement it in the switchdev auxdevice model.

It is simple enough, the HW driver's tx path would somehow detect
east/west and queue it differently, and the rx path would somehow be
able to mux in skbs from a SW queue. Not seeing any blockers here.

> > model. I would recommend creating a simple RDMA raw ethernet queue
> > driver over the aux device for something like this :)
> 
> You lost me here, I'm not seeing how RDMA and macvlan are connected.

RDMA is the standard uAPI to get a userspace HW DMA queue for ethernet
packets.

> > > Essentially what I am getting at is that the setup in the container
> > > should be vendor agnostic. The interface exposed shouldn't be specific
> > > to any one vendor. So if I want to fire up a container or Mellanox,
> > > Broadcom, or some other vendor it shouldn't matter or be visible to
> > > the user. They should just see a vendor agnostic subfunction
> > > netdevice.
> >
> > Agree. The agnostic container user interface here is 'struct
> > net_device'.
> 
> I disagree here. The fact is a mellanox netdev, versus a broadcom
> netdev, versus an intel netdev all have a very different look at feel
> as the netdev is essentially just the base device you are building
> around.

Then fix the lack of standardization of netdev implementations!

Adding more abstraction layers isn't going to fix that fundamental
problem.

Frankly it seems a bit absurd to complain that the very basic element
of the common kernel uAPI - struct net_device - is so horribly
fragmented and vendor polluted that we can't rely on it as a stable
interface for containers.

Even if that is true, I don't belive for a second that adding a
different HW abstraction layer is going to somehow undo the mistakes
of the last 20 years.

> Again, the hot-swap isn't necessarily what I am talking about. I am
> talking about setting up a config for a set of containers in a
> datacenter. What I don't want to do is have to have one set of configs
> for an mlx5 SF, another for a broadcom SF, and yet another set for any
> other vendors out there. I would much rather have all of that dealt
> with within the namespace that is handling the switchdev setup.

If there is real problems here then I very much encourage you to start
an effort to push all the vendors to implement a consistent user
experience for the HW netdevs.

I don't know what your issues are, but it sounds like it would be a
very interesting conference presentation.

But it has nothing to do with this series.

Jason
