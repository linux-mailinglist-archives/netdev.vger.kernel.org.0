Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B082DCA0C
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 01:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgLQAjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 19:39:23 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:19992 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbgLQAjV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 19:39:21 -0500
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fdaa88e0000>; Thu, 17 Dec 2020 08:38:38 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Dec
 2020 00:38:34 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 17 Dec 2020 00:38:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WgF9HcuKHq4uO6lL4MwEI2YO8ZtuIGSeM8lSXJ3i6LeDwpto/tHx8uKoUBNp84LreNsOAH7mvaJTc+YSBsOgX18E4tqbHaB7GYc8TP4qSDv4wqbpr4diGPlreJ2lalwkKRNaeUYd3zwGWBwYDbbZgShUJ/5SLilT7i34uLdLMoqDIT+bslwvWTHbHd/KIJH3So3qP/x34cDtSD/N9OQiXbrAO05VhIjz6VwGgW0/XbWiNszHvdkXTk8H0VlL3mkHGo2jxKiY0eOlPTjMKw/hSnQuYdk/xzwbS+QGEnCQPDnFel1whIvdGEFnKT3cTSLsAhCWMlK+XypyZnRH/ZNbbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yzzt5Jh3k64uC+nH6bIfnbcwP0H0XHUqCHKVdUAbf/8=;
 b=bH24DeQnQsXLk7BVQX1z1s7j2TQzmUcWZgPgmotpR4TS08Kq5w18oDUb/7V1qDc2naatKvRrCnQdvQt5JRpywv8RTjYybVExJDLpXF2R7ggSL2aYqEAtYCPGQ13db+SBHCkx7nVT1G81DheQ56o701IWmvtdZWa7rsQ6OziXPovnRqZwFcalu02TE+VBDfn7//aVMoAFGWJtKSIYm41r5vKwzT+8mhl1mIP7GKq6UDJC4f+r8lKoTdjucbqw3WEXmMScGXWv4jE7ENVMqlTOj3UNy647k8VRuCXenO53ytfN6Gsb6PEEqev5z+bu9qNKTsrZ5Az/ldrHWFHI3EnJxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4497.namprd12.prod.outlook.com (2603:10b6:5:2a5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 17 Dec
 2020 00:38:31 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1ce9:3434:90fe:3433]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1ce9:3434:90fe:3433%3]) with mapi id 15.20.3654.025; Thu, 17 Dec 2020
 00:38:31 +0000
Date:   Wed, 16 Dec 2020 20:38:29 -0400
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
Message-ID: <20201217003829.GN552508@nvidia.com>
References: <20201216001946.GF552508@nvidia.com>
 <CAKgT0UeLBzqh=7gTLtqpOaw7HTSjG+AjXB7EkYBtwA6EJBccbg@mail.gmail.com>
 <20201216030351.GH552508@nvidia.com>
 <CAKgT0UcwP67ihaTWLY1XsVKEgysa3HnjDn_q=Sgvqnt=Uc7YQg@mail.gmail.com>
 <20201216133309.GI552508@nvidia.com>
 <CAKgT0UcRfB8a61rSWW-NPdbGh3VcX_=LCZ5J+-YjqYNtm+RhVg@mail.gmail.com>
 <20201216175112.GJ552508@nvidia.com>
 <CAKgT0Uerqg5F5=jrn5Lu33+9Y6pS3=NLnOfvQ0dEZug6Ev5S6A@mail.gmail.com>
 <20201216203537.GM552508@nvidia.com>
 <CAKgT0UfuSA9PdtR6ftcq0_JO48Yp4N2ggEMiX9zrXkK6tN4Pmw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKgT0UfuSA9PdtR6ftcq0_JO48Yp4N2ggEMiX9zrXkK6tN4Pmw@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0088.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::33) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0088.namprd13.prod.outlook.com (2603:10b6:208:2b8::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.9 via Frontend Transport; Thu, 17 Dec 2020 00:38:30 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kphJN-00C03q-H1; Wed, 16 Dec 2020 20:38:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608165518; bh=yzzt5Jh3k64uC+nH6bIfnbcwP0H0XHUqCHKVdUAbf/8=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=aqYGPDNQn5nO1MxbqXDsU3xJ6QB08/ZZRyPe8wnKneSSTf7H5Rgp0HVN0ca6/mycD
         hW92yA+t5oSC2DXk2n/Dic4UKCdfzg0MUE2uVIFKJCiKbR0KHO79iC9JM1Os0n4G6W
         Z3oye/VGP9R+DNb72v0penUYbO5J3wI7Fu/nuCDs5J4dKjAIBlDKKdmycyAa4LNR6x
         6IeOG8gc20j76/cj0Pk/UYNi5X/QXCU8I9WC8HqspHBwZKH0rLoh1zLlAooWcwBjhl
         9gW8Hg+Yr6iXPLohRZKsIBdwXm4uqSGDljy+tG0KCYb1GhLidcU6rcQwyQheAKfCWW
         tbMyMhSa633pA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 02:53:07PM -0800, Alexander Duyck wrote:
 
> It isn't about the association, it is about who is handling the
> traffic. Going back to the macvlan model what we did is we had a group
> of rings on the device that would automatically forward unicast
> packets to the macvlan interface and would be reserved for
> transmitting packets from the macvlan interface. We took care of
> multicast and broadcast replication in software.

Okay, maybe I'm starting to see where you are coming from.

First, I think some clarity here, as I see it the devlink
infrastructure is all about creating the auxdevice for a switchdev
port.

What goes into that auxdevice is *completely* up to the driver. mlx5
is doing a SF which == VF, but that is not a requirement of the design
at all.

If an Intel driver wants to put a queue block into the aux device and
that is != VF, it is just fine.

The Intel netdev that binds to the auxdevice can transform the queue
block and specific switchdev config into a netdev identical to
accelerated macvlan. Nothing about the breaks the switchdev model.

Essentially think of it as generalizing the acceleration plugin for a
netdev. Instead of making something specific to limited macvlan, the
driver gets to provide exactly the structure that matches its HW to
provide the netdev as the user side of the switchdev port. I see no
limitation here so long as the switchdev model for controlling traffic
is followed.

Let me segue into a short story from RDMA.. We've had a netdev called
IPoIB for a long time. It is actually kind of similar to this general
thing you are talking about, in that there is a programming layer
under the IPOIB netdev called RDMA verbs that generalizes the actual
HW. Over the years this became more complicated because every new
netdev offloaded needed mirroring into the RDMA verbs general
API. TSO, GSO, checksum offload, endlessly onwards. It became quite
dumb in the end. We gave up and said the HW driver should directly
implement netdev. Implementing a middle API layer makes zero sense
when netdev is already perfectly suited to implement ontop of
HW. Removing SW layers caused performance to go up something like
2x.

The hard earned lesson I take from that is don't put software layers
between a struct net_device and the actual HW. The closest coupling is
really the best thing. Provide libary code in the kernel to help
drivers implement common patterns when making their netdevs, do not
provide wrapper netdevs around drivers.

IMHO the approach of macvlan accleration made some sense in 2013, but
today I would say it is mashing unrelated layers together and
polluting what should be a pure SW implementation with HW hooks.

I see from the mailing list comments this was done because creating a
device specific netdev via 'ip link add' was rightly rejected. However
here we *can* create a device specific vmdq *auxdevice*.  This is OK
because the netdev is controlling and containing the aux device via
switchdev.

So, Intel can get the "VMDQ link type" that was originally desired more
or less directly, so long as the associated switchdev port controls
the MAC filter process, not "ip link add".

And if you want to make the vmdq auxdevice into an ADI by user DMA to
queues, then sure, that model is completely sane too (vs hacking up
macvlan to expose user queues) - so long as the kernel controls the
selection of traffic into those queues and follows the switchdev
model. I would recommend creating a simple RDMA raw ethernet queue
driver over the aux device for something like this :)

> That might be a bad example, I was thinking of the issues we have had
> with VFs and direct assignment to Qemu based guests in the past.

As described, this is solved by VDPA.

> Essentially what I am getting at is that the setup in the container
> should be vendor agnostic. The interface exposed shouldn't be specific
> to any one vendor. So if I want to fire up a container or Mellanox,
> Broadcom, or some other vendor it shouldn't matter or be visible to
> the user. They should just see a vendor agnostic subfunction
> netdevice.

Agree. The agnostic container user interface here is 'struct
net_device'.

> > I have the feeling this stuff you are asking for is already done..
> 
> The case you are describing has essentially solved it for Qemu
> virtualization and direct assignment. It still doesn't necessarily
> solve it for the container case though.

The container case doesn't need solving.

Any scheme I've heard for container live migration, like CRIU,
essentially hot plugs the entire kernel in/out of a user process. We
rely on the kernel providing low leakage of the implementation details
of the struct net_device as part of it's uAPI contract. When CRIU
swaps the kernel the new kernel can have any implementation of the
container netdev it wants.

I've never heard of a use case to hot swap the implemention *under* a
netdev from a container. macvlan can't do this today. If you have a
use case here, it really has nothing to do with with this series.

Jason
