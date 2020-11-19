Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3607F2B9408
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 15:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgKSOA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 09:00:27 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:35398 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726790AbgKSOAZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 09:00:25 -0500
Received: from HKMAIL103.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb67a760003>; Thu, 19 Nov 2020 22:00:23 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 19 Nov
 2020 14:00:22 +0000
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.49) by
 HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 19 Nov 2020 14:00:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QK3elSB5tnQUWKXb1CbsiNMcp0hw8Afy0WB05CJJ95DWVgOuMubGXj06y3ccZp816Gy4Zmhie1/3ILaMoHlndXLjCR4TtRosIqD64M/mflqYWFl8DrnbM1zIFp2Q7UZs9c0prx3En10IVs8Lw2ktudA0LLOWRN3e9h3WGRT7C7TzxogXaOHdF5/i/I4efDIbEk3LQaL2f6gM5ODa79QWFOny5WndGauB2TuvqHudAZgR/V1N/xoWss8ngik7SwqaTacSdPpNSjmIwKEhro0lwiz/926xyG8CiBe/7B1PAQNlacvViqxGapclzlx2LP/ZvAA4o2fnAb7UMQ9DBXlAIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qpm3AiOzlKfA5wmelcGBOMsJTZ7+d3UwcxHf/xqmzbY=;
 b=jarar4C1l9mBeLhCy+knXEd/QWP0nixFxVJGAXPJAq5wDI6ai6j7/rRU8IFA/eMFmOWsshsnDRuXylhLDytGdyQ4D23i8AJvARcOyLH3gtfL7YE+NvTbqSdXqIM9L1EP8Sl+UnG7wPI0cl2Djc/i9rgnkah4CwvdXs2r+EHtGlpRkyCCz1KNCklT7j5irzfskDbyisGluwYJ9XjmzTMNMaTRo97Wrm37PA4VGzBtaHFMTF+fGb6RjZUqZs1/LE3tD0nR8U/JxxZAVM9v/f51HrKVCqpAbjnElWyMpz5noRwMbWbHr/Je/x2305ByhHmuzpuM81LZByV46Jc5SF4hKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2779.namprd12.prod.outlook.com (2603:10b6:5:4f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Thu, 19 Nov
 2020 14:00:19 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9%7]) with mapi id 15.20.3589.022; Thu, 19 Nov 2020
 14:00:19 +0000
Date:   Thu, 19 Nov 2020 10:00:17 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Saeed Mahameed <saeed@kernel.org>, Jakub Kicinski <kuba@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next 00/13] Add mlx5 subfunction support
Message-ID: <20201119140017.GN244516@ziepe.ca>
References: <20201112192424.2742-1-parav@nvidia.com>
 <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
 <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201117091120.0c933a4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <BY5PR12MB4322F01A4505AF21F696DCA2DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201118182319.7bad1ca6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <28239ff66a27c0ddf8be4f1461e27b0ac0b02871.camel@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <28239ff66a27c0ddf8be4f1461e27b0ac0b02871.camel@kernel.org>
X-ClientProxiedBy: MN2PR08CA0005.namprd08.prod.outlook.com
 (2603:10b6:208:239::10) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR08CA0005.namprd08.prod.outlook.com (2603:10b6:208:239::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Thu, 19 Nov 2020 14:00:19 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kfkTx-008BS8-RQ; Thu, 19 Nov 2020 10:00:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605794423; bh=Qpm3AiOzlKfA5wmelcGBOMsJTZ7+d3UwcxHf/xqmzbY=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=rN9fZDnYwwmwEUYfnccSRYjiWEW0J6mTMdFXF+z9Ty7GP5+xmik7pBA2Mal/DgVZo
         WGFB4e0XZqHsbrtlLlDIJ9NmLaeWTKnWKQepPkx3O504zQQzcEfRNNo88W6XX/ALln
         nV85uiqFTAyXo1u5A7U2QVlkaI3bScw0ZTCXo2GidM1p+K1EKcKDHyaPraeO0M0dKK
         E3eQ+w5Exci2mXFsGZOegg5fXpOUKg1sh6YNJZC/r1OKP1VBGt6/wNcifRpD/gZmDs
         nv6RRFpQu+rVTTKCh11+St6DtjNTXxT8FxzzuxCgcxRmPQKlWYVECLaxKorQiU46bx
         NcVnfdl7lWa0A==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 10:22:51PM -0800, Saeed Mahameed wrote:
> > I think the biggest missing piece in my understanding is what's the
> > technical difference between an SF and a VDPA device.
> 
> Same difference as between a VF and netdev.
> SF == VF, so a full HW function.
> VDPA/RDMA/netdev/SCSI/nvme/etc.. are just interfaces (ULPs) sharing the
> same functions as always been, nothing new about this.

All the implementation details are very different, but this white
paper from Intel goes into some detail the basic elements and rational
for the SF concept:

https://software.intel.com/content/dam/develop/public/us/en/documents/intel-scalable-io-virtualization-technical-specification.pdf

What we are calling a sub-function here is a close cousin to what
Intel calls an Assignable Device Interface. I expect to see other
drivers following this general pattern eventually.

A SF will eventually be assignable to a VM and the VM won't be able to
tell the difference between a VF or SF providing the assignable PCI
resources.

VDPA is also assignable to a guest, but the key difference between
mlx5's SF and VDPA is what guest driver binds to the virtual PCI
function. For a SF the guest will bind mlx5_core, for VDPA the guest
will bind virtio-net.

So, the driver stack for a VM using VDPA might be

 Physical device [pci] -> mlx5_core -> [aux] -> SF -> [aux] ->  mlx5_core -> [aux] -> mlx5_vdpa -> QEMU -> |VM| -> [pci] -> virtio_net

When Parav is talking about creating VDPA devices he means attaching
the VDPA accelerator subsystem to a mlx5_core, where ever that
mlx5_core might be attached to.

To your other remark:

> > What are you NAK'ing?
> Spawning multiple netdevs from one device by slicing up its queues.

This is a bit vauge. In SRIOV a device spawns multiple netdevs for a
physical port by "slicing up its physical queues" - where do you see
the cross over between VMDq (bad) and SRIOV (ok)?

I thought the issue with VMDq was more on the horrid management to
configure the traffic splitting, not the actual splitting itself?

In classic SRIOV the traffic is split by a simple non-configurable HW
switch based on MAC address of the VF.

mlx5 already has the extended version of that idea, we can run in
switchdev mode and use switchdev to configure the HW switch. Now
configurable switchdev rules split the traffic for VFs.

This SF step replaces the VF in the above, but everything else is the
same. The switchdev still splits the traffic, it still ends up in same
nested netdev queue structure & RSS a VF/PF would use, etc, etc. No
queues are "stolen" to create the nested netdev.

From the driver perspective there is no significant difference between
sticking a netdev on a mlx5 VF or sticking a netdev on a mlx5 SF. A SF
netdev is not going in and doing deep surgery to the PF netdev to
steal queues or something.

Both VF and SF will be eventually assignable to guests, both can
support all the accelerator subsystems - VDPA, RDMA, etc. Both can
support netdev.

Compared to VMDq, I think it is really no comparison. SF/ADI is an
evolution of a SRIOV VF from something PCI-SGI controlled to something
device specific and lighter weight.

SF/ADI come with a architectural security boundary suitable for
assignment to an untrusted guest. It is not just a jumble of queues.

VMDq is .. not that.

Actually it has been one of the open debates in the virtualization
userspace world. The approach to use switchdev to control the traffic
splitting to VMs is elegant but many drivers are are not following
this design. :(

Finally, in the mlx5 model VDPA is just an "application". It asks the
device to create a 'RDMA' raw ethernet packet QP that is uses rings
formed in the virtio-net specification. We can create it in the kernel
using mlx5_vdpa, and we can create it in userspace through the RDMA
subsystem. Like any "RDMA" application it is contained by the security
boundary of the PF/VF/SF the mlx5_core is running on.

Jason
