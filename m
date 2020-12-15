Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902142DB592
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 22:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgLOVEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 16:04:14 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:58019 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727653AbgLOVEL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 16:04:11 -0500
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd924a10001>; Wed, 16 Dec 2020 05:03:29 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Dec
 2020 21:03:24 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 15 Dec 2020 21:03:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MpfutC6KhyWEPUcLhVO8+YPAL9d57nj+5j3MO2vAtGAwGK/6JoQtv7ci15AQA9iiuwl+P/UzzFyt35bluBOuuTaC/Y9SMQkU+00d1dCvtq468114w3gDOrMGn5hvtaEQdCLwgeTeqfmooCwZq9wYgz+r1CJmTHRhMT/nr4loIobjQeRBr7E9EjK8umw0IkHObADNDRIjNH6sEbkGYiCTBqoUPaEb+SXDgwv6MxwR3e1zJywXw3mNO4KrIrK8V80NcQ26q/1VdsBGgf5Gpxif25EvfMuVAJ1QN8MNFOWOMR5bupzFEvTom7CWYmbQnv7o24y/fk7c5AliboAm5jkGCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mGJWn809gflYUCxzwooFe+goR/fp2to841dcy0zvSPA=;
 b=d3Sj89bRJZULTVU9IkC7//XAwGA8/Rxgc/ttRW85MQEpf4twUaYZ3/TcZNI2wo0zRO9TfPanJTry07whlEqP8TK1zxf5kBdKUEURBnWO/4ZAVEpy5xjdBN/2NkQNiHaQIemKkW/fdMw89ykeW87fKhFL40Oom8Gay8ADiZXSXmgM/xkye3QY8wgxegZA1/ZsibFS5Ij/PaIUB0NUi2C+ITMpigj+/04d7AkgeNIECtUIQR2UckFMTNWycV35sUYsGpMQ9kCin7L4RTa8AY2EckJHJNcCsgNQiqvEuxS89EcQxGyHTHAcoRVaTffX09spB7lKIpKv+RFZ/nf4PHt0OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4268.namprd12.prod.outlook.com (2603:10b6:5:223::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.24; Tue, 15 Dec
 2020 21:03:21 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1ce9:3434:90fe:3433]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1ce9:3434:90fe:3433%3]) with mapi id 15.20.3654.025; Tue, 15 Dec 2020
 21:03:21 +0000
Date:   Tue, 15 Dec 2020 17:03:19 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     Parav Pandit <parav@nvidia.com>, Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Leon Romanovsky" <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "Sridhar Samudrala" <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Kiran Patil" <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [net-next v4 00/15] Add mlx5 subfunction support
Message-ID: <20201215210319.GC552508@nvidia.com>
References: <20201214214352.198172-1-saeed@kernel.org>
 <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
 <BY5PR12MB43221CE397D6310F2B04D9B4DCC60@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CAKgT0Uf9C5gwVZ1DnkrGYHMUvxe-bqwwcbTo7A0q-trrULJSUg@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKgT0Uf9C5gwVZ1DnkrGYHMUvxe-bqwwcbTo7A0q-trrULJSUg@mail.gmail.com>
X-ClientProxiedBy: MN2PR06CA0016.namprd06.prod.outlook.com
 (2603:10b6:208:23d::21) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR06CA0016.namprd06.prod.outlook.com (2603:10b6:208:23d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 21:03:21 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kpHTb-00B2uF-9c; Tue, 15 Dec 2020 17:03:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608066209; bh=mGJWn809gflYUCxzwooFe+goR/fp2to841dcy0zvSPA=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=ds5dAr5l25lOK4fjLdS5KBTRnqE+zMLgoVpA3d/KSHNoD0FUOMceAUsf9djEDSOoa
         V8XIBwWecl8TAXSO0Uq4oWaLi6CVgyQBvSffrOhRsfcN41eb5pCWQwSr7h9zHaQpxG
         elp4QVoyWuEBTbLCgaeggR6kET851tVkOThQwvzfMKegq7WOPoW0KargNvp9QjVmwi
         ZHLXIpaPGu1clgiLb6VwBDSN/PN5q778CbP9FJF4zM87CTBbUmJwSNCH6/R/hklaEo
         obS6QG3KgBk1cRiof84Zs76WMOCWruBaW1FUepvrUCUd2xbr0Zf2T13RdjqJK6rDEH
         T/kLCwdMsgL9g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 10:47:36AM -0800, Alexander Duyck wrote:

> > Jason and Saeed explained this in great detail few weeks back in v0 version of the patchset at [1], [2] and [3].
> > I better not repeat all of it here again. Please go through it.
> > If you may want to read precursor to it, RFC from Jiri at [4] is also explains this in great detail.
> 
> I think I have a pretty good idea of how the feature works. My concern
> is more the use of marketing speak versus actual functionality. The
> way this is being setup it sounds like it is useful for virtualization
> and it is not, at least in its current state. It may be at some point
> in the future but I worry that it is really going to muddy the waters
> as we end up with yet another way to partition devices.

If we do a virtualization version then it will take a SF and instead
of loading a mlx5_core on the SF aux device, we will load some
vfio_mdev_mlx5 driver which will convert the SF aux device into a
/dev/vfio/*

This is essentially the same as how you'd take a PCI VF and replace
mlx5_core with vfio-pci to get /dev/vfio/*. It has to be a special
mdev driver because it sits on the SF aux device, not on the VF PCI
device.

The vfio_mdev_mlx5 driver will create what Intel calls an SIOV ADI
from the SF, in other words the SF is already a superset of what a
SIOV ADI should be.

This matches very nicely the driver model in Linux, and I don't think
it becomes more muddied as we go along. If anything it is becoming
more clear and sane as things progress.

> I agree with you on that. My thought was more the fact that the two
> can be easily confused. If we are going to do this we need to define
> that for networking devices perhaps that using the mdev interface
> would be deprecated and we would need to go through devlink. However
> before we do that we need to make sure we have this completely
> standardized.

mdev is for creating /dev/vfio/* interfaces in userspace. Using it for
anything else is a bad abuse of the driver model.

We had this debate endlessly already.

AFAIK, there is nothing to deprecate, there are no mdev_drivers in
drivers/net, and none should ever be added. The only mdev_driver that
should ever exists is in vfio_mdev.c

If someone is using a mdev_driver in drivers/net out of tree then they
will need to convert to an aux driver for in-tree.

> Yeah, I recall that. However I feel like it is being oversold. It
> isn't "SR-IOV done right" it seems more like "VMDq done better". The
> fact that interrupts are shared between the subfunctions is telling.

The interrupt sharing is a consequence of having an ADI-like model
without relying on IMS. When IMS works then shared interrupts won't be
very necessary. Otherwise there is no choice but to share the MSI
table of the function.

> That is exactly how things work for Intel parts when they do VMDq as
> well. The queues are split up into pools and a block of queues belongs
> to a specific queue. From what I can can tell the only difference is
> that there is isolation of the pool into specific pages in the BAR.
> Which is essentially a requirement for mediated devices so that they
> can be direct assigned.

No, I said this to Jakub, mlx5 SFs have very little to do with
queues. There is no some 'queue' HW element that needs partitioning.

The SF is a hardware security boundary that wraps every operation a
mlx5 device can do. This is why it is an ADI. It is not a crappy ADI
that relies on hypervisor emulation, it is the real thing, just like a
SRIOV VF. You stick it in the VM and the guest can directly talk to
the HW. The HW provides the security.

I can't put focus on this enough: A mlx5 SF can run a *full RDMA
stack*. This means the driver can create all the RDMA HW objects and
resources under the SF. This is *not* just steering some ethernet
traffic to a few different ethernet queues like VMDq is.

The Intel analog to a SF is a *full virtual function* on one of the
Intel iWarp capable NICs, not VMDq.

> Assuming at some point one of the flavours is a virtio-net style
> interface you could eventually get to the point of something similar
> to what seems to have been the goal of mdev which was meant to address
> these two points.

mlx5 already supports VDPA virtio-net on PF/VF and with this series SF
too.

ie you can take a SF, bind the vdpa_mlx5 driver, and get a fully HW
accelerated "ADI" that does virtio-net. This can be assigned to a
guest and shows up as a PCI virtio-net netdev. With VT-d guest packet
tx/rx on this netdev never uses the hypervisor CPU.

> The point is that we should probably define some sort of standard
> and/or expectations on what should happen when you spawn a new
> interface. Would it be acceptable for the PF and existing subfunctions
> to have to reset if you need to rebalance the IRQ distribution, or
> should they not be disrupted when you spawn a new interface?

It is best to think of the SF as an ADI, so if you change something in
the PF and that causes the driver attached to the ADI in a VM to
reset, is that OK? I'd say no.

Jason
