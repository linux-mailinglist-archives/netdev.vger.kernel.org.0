Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D662C49D0
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 22:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731952AbgKYVW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 16:22:28 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:2557 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730091AbgKYVW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 16:22:27 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbecb1a0000>; Wed, 25 Nov 2020 13:22:34 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 25 Nov
 2020 21:22:27 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 25 Nov 2020 21:22:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SDVLRvZy7ZJNbS1/8TmE1Kc7a4aL72xbrg7S/vReMm7beA6Cvnk7nP71B/o11MD9x4Zmnjhq4ywpL7M2suzhusybAkNlnslNd8TgdDjICAPuVF8wuwoRjJ6mW25NoEQLXcfNJQs96s6xOMipcQ+ri48hDSMqKkj9w60U8ZtauPSpuBkPGgIyuAdaD5mCDtY4rvDpOBhX/292dCmsou9tH4dM9gjFWiox6zykCJNw9CG1lAW92JTFgmNatm3MNe0WU+TGtCJQ7aFu4fU6l8hqXFFe9MKhc0VqXfrc2heQGK5pRam+jTtFSb8kDFWnHfQMs8SZDWk5Ioe2kmwi7kW/Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Y0EB4TUFa2cpWYQ7sOUIfvw0HMhIDv4p9sC+l57PM4=;
 b=DjSf5C0QlV4JzOtsvgLSJhe7oXa4pJDD84ZxnMd15R66vi7cw12kG/Bb+tK1fw3Ui7npRTJy5GiZ2+a4lygske01LT01BcfMecaU4mgr771MtNckt0zIhja7NDJ1+A6dUR+yPhxYivbeqQhmCPgzCUFf5W5+PMsZjyAiMYxvklEWqCKq8xPhx24mt0dZ8EKqigi72GIWOrwFfUUYlTN1fryE3JzXd6nGnM7T18wWRwQEWhy8FAyqEMxpob8zjoLERvwA8R6wK7wjuBupdwlREnKFHDIZfr+JC+h35Oc5K3JYDAhRlWc8BY8Ik4BiZfFhaV5XSEnsx++BimzUD3EF7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2937.namprd12.prod.outlook.com (2603:10b6:5:181::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Wed, 25 Nov
 2020 21:22:26 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9%7]) with mapi id 15.20.3589.022; Wed, 25 Nov 2020
 21:22:26 +0000
Date:   Wed, 25 Nov 2020 17:22:24 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Eli Cohen <eli@mellanox.com>, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH mlx5-next 11/16] net/mlx5: Add VDPA priority to NIC RX
 namespace
Message-ID: <20201125212224.GN4800@nvidia.com>
References: <20201120230339.651609-1-saeedm@nvidia.com>
 <20201120230339.651609-12-saeedm@nvidia.com>
 <20201121160155.39d84650@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201122064158.GA9749@mtl-vdi-166.wap.labs.mlnx>
 <20201124091219.5900e7bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201124180210.GJ5487@ziepe.ca>
 <20201124104106.0b1201b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201124194413.GF4800@nvidia.com>
 <20201125105422.7f90184c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201125105422.7f90184c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-ClientProxiedBy: BL0PR02CA0136.namprd02.prod.outlook.com
 (2603:10b6:208:35::41) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR02CA0136.namprd02.prod.outlook.com (2603:10b6:208:35::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Wed, 25 Nov 2020 21:22:25 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1ki2F6-001ON4-GS; Wed, 25 Nov 2020 17:22:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606339354; bh=5Y0EB4TUFa2cpWYQ7sOUIfvw0HMhIDv4p9sC+l57PM4=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=o2u/PezeOoBHpHAhhRGiLg/2765g6td3F2vu6iUtzcGPSlN/Sd+NIR+NzSEEyYFn8
         Bcy8if+4ZEvZehxyCGhq3AFPVmPFHP0X02Hk6dOhRxifBy9i+d44VsdjxwpiVpgJuZ
         Bty69sfYlgNJ0GEeskVJN40nJW7GjbVvAXPRV0wN5rGo1vf0M5h9w2H+2HR/JOP/pI
         BX0oj/3XFsWlh8NiuqiZWIxlW8FNN9/09dgzngq/lLNwF0cg/EiBWWY6wWop4G2Kwb
         LcCK9SNmiO/v2N62UY/mrKL44fFNxC7g0dYGBXAmWbdgHZoeObHyYPYhy1LBz4Mynl
         KaNwbfMouwyOQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 25, 2020 at 10:54:22AM -0800, Jakub Kicinski wrote:

> > RDMA covers a wide range of accelerated networking these days.. Where
> > else are you going to put this stuff in the kernel?
> 
> IDK what else you got in there :) It's probably a case by case answer.

Hmm, yes, it seems endless sometimes :(
 
> IMHO even using libibverbs is no strong reason for things to fall under
> RDMA exclusively. Client drivers of virtio don't get silently funneled
> through a separate tree just because they use a certain spec.

I'm not sure I understand this, libibverbs is the user library to
interface with the kernel RDMA subsystem. I don't care what apps
people build on top of it, it doesn't matter to me that netdev and
DPDK have some kind of feud.

> > > I'm sure if you start doing crypto over ibverbs crypto people will want
> > > to have a look.  
> > 
> > Well, RDMA has crypto transforms for a few years now too. 
> 
> Are you talking about RDMA traffic being encrypted? That's a different
> case.

That too, but in general, anything netdev can do can be done via RDMA
in userspace. So all the kTLS and IPSEC xfrm HW offloads mlx5 supports
are all available in userspace too.

> > Part of the point of the subsystem split was to end the fighting that
> > started all of it. It was very clear during the whole iWarp and TCP
> > Offload Engine buisness in the mid 2000's that netdev wanted nothing
> > to do with the accelerator world.
> 
> I was in middle school at the time, not sure what exactly went down :)

Ah, it was quite the thing. Microsoft and Co were heavilly pushing TOE
technology (Microsoft Chimney!) as the next most certain thing and I
recall DaveM&co was completely against it in Linux.

I will admit at the time I was doubtful, but in hindsight this was the
correct choice. netdev would not look like it does today if it had
been shackled by the HW implementations of the day. Instead all this
HW stuff ended up largely in RDMA and some in block with the iSCSI
mania of old. It is quite evident to me the mess being tied to HW has
caused to a SW ecosystem. DRM and RDMA both have a very similiar kind
of suffering due to this.

However - over the last 20 years it has been steadfast that there is
*always* a compelling reason for certain applications to use something
from the accelerator side. It is not for everyone, but the specialized
applications that need it, *really need it*.

For instance, it is the difference between being able to get a COVID
simulation result in a few week vs .. well.. never.

> But I'm going by common sense here. Perhaps there was an agreement
> I'm not aware of?

The resolution to the argument above was to split them in Linux.  Thus
what logically is networking was split up in the kernel between netdev
and the accelerator subsystems (iscsi, rdma, and so on).

The general notion is netdev doesn't have to accomodate anything an
accelerator does. If you choose to run them then you do not get to
complain that your ethtool counters are wrong, your routing tables
and tc don't work, firewalling doesn't work. Etc.

That is all broken by design.

In turn, the accelerators do their own thing, tap the traffic before
it hits netdev and so on. netdev does not care what goes on over there
and is not responsible.

I would say this is the basic unspoken agreement of the last 15 years.

Both have a right to exist in Linux. Both have a right to use the
physical ethernet port.

> > So why would netdev need sign off on any accelerator stuff?
> 
> I'm not sure why you keep saying accelerators!
> 
> What is accelerated in raw Ethernet frame access??

The nature of the traffic is not relavent.

It goes through RDMA, it is accelerator traffic (vs netdev traffic,
which goes to netdev). Even if you want to be pedantic, in the raw
ethernet area there is lots of HW special accelerated stuff going
on. Mellanox has some really neat hard realtime networking technology
that works on raw ethernet packets, for instance.

And of course raw ethernet is a fraction of what RDMA covers. iWarp
and RoCE are much more like you might imagine when you hear the word
accelerator.

> > Do you want to start co-operating now? I'm willing to talk about how
> > to do that.
> 
> IDK how that's even in question. I always try to bump all RDMA-looking
> stuff to linux-rdma when it's not CCed there. That's the bare minimum
> of cooperation I'd expect from anyone.

I mean co-operate in the sense of defining a scheme where the two
worlds are not completely seperated and isolated.

> > > And our policy on DPDK is pretty widely known.  
> > 
> > I honestly have no idea on the netdev DPDK policy,
> > 
> > I'm maintaining the RDMA subsystem not DPDK :)
> 
> That's what I thought, but turns out DPDK is your important user.

Nonsense.

I don't have stats but the majority of people I work with using RDMA
are not using DPDK. DPDK serves two somewhat niche markets of NFV and
certain hyperscalers - RDMA covers the entire scientific computing
community and a big swath of the classic "Big Iron" enterprise stuff,
like databases and storage.

> Now IIUC you're tapping traffic for DPDK/raw QPs _before_ all switching
> happens in the NIC? That breaks the switchdev model. We're back to
> per-vendor magic.

No, as I explained before, the switchdev completely contains the SF/VF
and all applications running on a mlx5_core are trapped by it. This
includes netdev, RDMA and VDPA.

> And why do you need a separate VDPA table in the first place?
> Forwarding to a VDPA device has different semantics than forwarding to
> any other VF/SF?

The VDPA table is not switchdev. Go back to my overly long email about
VDPA, here we are talking about the "selector" that chooses which
subsystem the traffic will go to. The selector is after switchdev but
before netdev, VDPA, RDMA.

Each accelerator subsystem gets a table. RDMA, VDPA, and netdev all
get one. It is some part of the HW to make the selectoring work.

Jason
