Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379622DC7D1
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 21:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgLPUg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 15:36:26 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5494 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726745AbgLPUgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 15:36:25 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fda6fa10000>; Wed, 16 Dec 2020 12:35:45 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 16 Dec
 2020 20:35:40 +0000
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.51) by
 HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 16 Dec 2020 20:35:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FG88B4sURB4NGcEkaYr5Oz1LB2Drs7jixoNM+SS4heamJ/yFirLlKNdCImTVAC9Yipgp5pTkVjspBLUa9sOr7oVN3xbmhrz6sReVE1JoYk0ocb+OX9NQgppAOkqseZ5NOETb0qx2Sdd3/2wBN72wwyAIzb0CIFRTcJweYM+0RvMZfsAj6xpJ2mIV7ZO/uHPUSaET12FrYIORtgNWSzqphGUfJ6Qz7GYJawMkCvdySaUgD2Vei1Jhy6eAPgIr4r+Gqtr1+RCNPyP4MIo2YgxejHOaSpErycUFmhjFxr3V4BVBZsShGcXsopbLTSJtCoPn6NwR9K2XZIWnunvLY2IwdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5ER/ZXcJK7f+1eiaF16a/dEQth3PajOZogSgFwBXzc=;
 b=JlMyEu4md/VUz7iRpLbS2N69f74zNZnKwpp8Q6gA6pPibTvqF4yclGrwNRNmpQxLI+WaeuzMmhj6T2YeDugRqGp/q9oWECftPWgSFcVJU1dtcYt4z2fCff6VBbEroELyXyLzQGAmHMXh9q9rmMkuPucN8vLyj0apVefdukD6Y5CkIxMY05FYhthZYK+QJzukh0T6I7ZFFFgFxdeWKWgJ6HOfBFqlmts05CMpKrcX+MDd0Wtqqr53Jskjan0JOXs/girhLDkxDdcMYApy0M0NcKxB5cOC03/UsK5crgCQRKh4RWWTXNztETIlDwkdp1GtR1CIstl8+SZELmI+HljBlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3401.namprd12.prod.outlook.com (2603:10b6:5:39::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Wed, 16 Dec
 2020 20:35:39 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1ce9:3434:90fe:3433]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1ce9:3434:90fe:3433%3]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 20:35:39 +0000
Date:   Wed, 16 Dec 2020 16:35:37 -0400
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
Message-ID: <20201216203537.GM552508@nvidia.com>
References: <ecad34f5c813591713bb59d9c5854148c3d7f291.camel@kernel.org>
 <CAKgT0UfTOqS9PBeQFexyxm7ytQzdj0j8VMG71qv4+Vn6koJ5xQ@mail.gmail.com>
 <20201216001946.GF552508@nvidia.com>
 <CAKgT0UeLBzqh=7gTLtqpOaw7HTSjG+AjXB7EkYBtwA6EJBccbg@mail.gmail.com>
 <20201216030351.GH552508@nvidia.com>
 <CAKgT0UcwP67ihaTWLY1XsVKEgysa3HnjDn_q=Sgvqnt=Uc7YQg@mail.gmail.com>
 <20201216133309.GI552508@nvidia.com>
 <CAKgT0UcRfB8a61rSWW-NPdbGh3VcX_=LCZ5J+-YjqYNtm+RhVg@mail.gmail.com>
 <20201216175112.GJ552508@nvidia.com>
 <CAKgT0Uerqg5F5=jrn5Lu33+9Y6pS3=NLnOfvQ0dEZug6Ev5S6A@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKgT0Uerqg5F5=jrn5Lu33+9Y6pS3=NLnOfvQ0dEZug6Ev5S6A@mail.gmail.com>
X-ClientProxiedBy: MN2PR18CA0016.namprd18.prod.outlook.com
 (2603:10b6:208:23c::21) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR18CA0016.namprd18.prod.outlook.com (2603:10b6:208:23c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Wed, 16 Dec 2020 20:35:38 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kpdWL-00Btlb-EK; Wed, 16 Dec 2020 16:35:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608150945; bh=F5ER/ZXcJK7f+1eiaF16a/dEQth3PajOZogSgFwBXzc=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=JIYj8HNADKNI6nivG37zhV1mnt9u8xFPYFduZe9M8PR5UX3AfzX5fb+/6+h8tSvPB
         oB6c9B4as/jHsRKbuAD0hap/I/XJMyaLhD/AKl0oI7EETNUTGyAX6RvV5P0cqP8fQk
         pc6MedVYATcX2yvfIqNTFEbVjwqxJ9Vid5a5AvThsSDpHkd3F8iWBvIEbdFhDV6oPa
         1CSJyssNUa33gv4tNDdtvz6P3ANqR/0D+9xAOM1AGtOIcp08lk49iDNSfkulnMM8Ey
         Rgav2hfV6DO1QNxtHaqFt5FcrkjFtQ6B/SA5WbkMVMwUwsGldsYjCvaJl1rhP172Lh
         xA+SIJO0d5dfQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 11:27:32AM -0800, Alexander Duyck wrote:

> That has been the case for a long time. However it had been my
> experience that SR-IOV never scaled well to meet those needs and so it
> hadn't been used in such deployments.

Seems to be going quite well here, perhaps the applications are
different.

> > The optimization here is to reduce the hypervisor workload and free up
> > CPU cycles for the VMs/containers to consume. This means less handling
> > of packets in the CPU, especially for VM cases w/ SRIOV or VDPA.
> >
> > Even the extra DMA on the NIC is not really a big deal. These are 400G
> > NICs with big fast PCI. If you top them out you are already doing an
> > aggregate of 400G of network traffic. That is a big number for a
> > single sever, it is OK.
> 
> Yes, but at a certain point you start bumping up against memory
> throughput limitations as well. Doubling up the memory footprint by
> having the device have to write to new pages instead of being able to
> do something like pinning and zero-copy would be expensive.

You can't zero-copy when using VMs.

And when using containers every skb still has to go through all the
switching and encapsulation logic, which is not free in SW.

At a certain point the gains of avoiding the DMA copy are lost by the
costs of all the extra CPU work. The factor being optimized here is
CPU capacity.

> > Someone might feel differently if they did this on a 10/40G NIC, in
> > which case this is not the solution for their application.
> 
> My past experience was with 10/40G NIC with tens of VFs. When we start
> talking about hundreds I would imagine the overhead becomes orders of
> magnitudes worse as the problem becomes more of an n^2 issue since you
> will have n times more systems sending to n times more systems

The traffic demand is application dependent. If an application has an
n^2 traffic pattern then it needs a network to sustain that cross
sectional bandwidth regardless of how the VMs are packed.

It just becomes a design factor of the network and now the network
includes that switching component on the PCIe NIC as part of the
capacity for cross sectional BW.

There is some balance where a VM can only generate so much traffic
based on the CPU it has available, and you can design the entire
infrastructure to balance the CPU with the NIC with the switches and
come to some packing factor of VMs. 

As CPU constrains VM performance, removing CPU overheads from the
system will improve packing density. A HW network data path in the VMs
is one such case that can turn to a net win if the CPU bottleneck is
bigger than the network bottleneck.

It is really over simplifiying to just say PCIe DMA copies are bad.

> receiving. As such things like broadcast traffic would end up
> consuming a fair bit of traffic.

I think you have a lot bigger network problems if your broadcast
traffic is so high that you start to worry about DMA copy performance
in a 400G NIC.

> The key bit here is outside of netdev. Like I said, SIOV and SR-IOV
> tend to be PCIe specific specifications. What we are defining here is
> how the network interfaces presented by such devices will work.

I think we've achieved this..

> > That seems small enough it should be resolvable, IMHO. eg some new
> > switch rule that matches that specific HW behavior?
> 
> I would have to go digging to find the conversation. It was about 3 or
> 4 years ago. I seem to recall mentioning the idea of having some
> static rules but it was a no-go at the time. If we wanted to spin off
> this conversation and pull in some Intel folks I would be up for us
> revisiting it. However I'm not with Intel anymore so it would mostly
> be something I would be working on as a hobby project instead of
> anything serious.

Personally I welcome getting more drivers to implement the switchdev
model, I think it is only good for the netdev community as as a whole
to understand and standardize on this.

> > > Something like the vdpa model is more like what I had in mind. Only
> > > vdpa only works for the userspace networking case.
> >
> > That's because making a driver that converts the native HW to VDPA and
> > then running a generic netdev on the resulting virtio-net is a pretty
> > wild thing to do. I can't really think of an actual use case.
> 
> I'm not talking about us drastically changing existing models. I would
> still expect the mlx5 driver to be running on top of the aux device.
> However it may be that the aux device is associated with something
> like the switchdev port as a parent 
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

That is exactly how this works. The switchdev representor and the aux
device are paired and form the analog of the veth tunnel. IIRC this
relationship with the aux device is shown in the devlink output for
the switchdev ports.

I still can't understand what you think should be changed here.

We can't get rid of the aux device, it is integral to the software
layering and essential to support any device assignment flow.

We can't add a mandatory netdev, because that is just pure waste for
any device assignment flow.

> The basic idea is most of the control is still in the switchdev
> port, but it becomes more visible that the switchdev port and the
> subfunction netdev are linked with the switchdev port as the parent.

If a user netdev is created, say for a container, then it should have
as a parent the aux device.

If you inspect the port configuration on the switchdev side it will
show the aux device associated with the port.

Are you just asking that the userspace tools give a little help and
show that switchdev port XX is visable as netdev YYY by cross matching
the auxbus?

> > > they are pushed into containers you don't have to rip them out if for
> > > some reason you need to change the network configuration.
> >
> > Why would you need to rip them out?
> 
> Because they are specifically tied to the mlx5 device. So if for
> example I need to hotplug out the mlx5 and replace it, 

Uhh, I think we are very very far away from being able to hot unplug a
switchdev driver, keep the switchdev running, and drop in a different
driver.

That isn't even on the radar, AFAIK.

> namespace. One of the issues with VFs is that we have always had to
> push some sort of bond on top, or switch over to a virtio-net
> interface in order to support fail-over. If we can resolve that in the
> host case that would go a long way toward solving one of the main
> issues of SR-IOV.

This is all solved already, virtio-net is the answer.

qemu can swap back ends under the virtio-net ADI it created on the
fly. This means it can go from processing a virtio-net queue in mlx5
HW, to full SW, to some other HW on another machine. All hitlessly and
transparently to the guest VM.

Direct HW processing of a queue inside a VM without any downsides for
VM migration. Check.

I have the feeling this stuff you are asking for is already done..

Jason
