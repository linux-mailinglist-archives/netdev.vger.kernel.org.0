Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC43B2DB946
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 03:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgLPCkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 21:40:21 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:33664 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgLPCkU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 21:40:20 -0500
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd9736a0000>; Wed, 16 Dec 2020 10:39:38 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 16 Dec
 2020 02:39:32 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 16 Dec 2020 02:39:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sg0/SBUor1XWosAI1ydec0VsEh0sk9mk8PNBXa+lbKr7tILYvdY3iFlcKvM2jjQd1dwiqEX01fIyE2TUpzfIiGdbrW8Ua/JZbeJWMmASxJBOWHFKw+BxaQkZep7ggolKi5apVa3zJVno1wFbyfeXdHV/9uvmngNe0Z1QP0ORTMe8cTKCFBM6pGE65/yziZoNK+mgSSohpgzZEwSvDYOAjexQNroKB2/eVmBXoE5sB0rU8/TedBKgVODwfAcvpQGH8vzOc8zWJ9joqYEvZSF/1mIdwJZloeEOCO42p0T7xnrxQ/08h/4v0HtMGrAbA+UdFHxZCgVQEhmau3rMh271XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XARvCpEMpE5ciO8Ya/hhcMPqYkOPvrUqQJbmfp4wdJo=;
 b=bYMEoDq8ZrXfFjkAq/TqeNSX7EAX++dgHuQ0K+QhqoV1ZwrVIVGPY3b6zZm1ljjLj9DvaQL5LW4qlOrVrWS9NlzX/ENYWcdS2yC09gtT/Ky5AwC4pMguhOB47AIqFQ0qR6bBd/vh4A24L+SllaBxd/5hFSOXBlxRHeZc9BC52rQAq4gpz9liJIOzsyiLD384V75tH2SXFZtVf4ZDifnqDabCk22E+wrgce2+B6XFAImFudMIRAm2KgYT1RwwqDzH6k3oEeyxhbUrmn11tdNeC/st7JjwNmR4FHVq48p/Sx6/AQmNfo5RmqZZUTiZ8V5jaDFTjChbIYgEoy1Dqec46w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4842.namprd12.prod.outlook.com (2603:10b6:5:1fe::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Wed, 16 Dec
 2020 02:39:30 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1ce9:3434:90fe:3433]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1ce9:3434:90fe:3433%3]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 02:39:30 +0000
Date:   Tue, 15 Dec 2020 22:39:28 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Edwin Peer <edwin.peer@broadcom.com>
CC:     Alexander Duyck <alexander.duyck@gmail.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
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
Message-ID: <20201216023928.GG552508@nvidia.com>
References: <20201214214352.198172-1-saeed@kernel.org>
 <CAKgT0UejoduCB6nYFV2atJ4fa4=v9-dsxNh4kNJNTtoHFd1DuQ@mail.gmail.com>
 <BY5PR12MB43221CE397D6310F2B04D9B4DCC60@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CAKgT0Uf9C5gwVZ1DnkrGYHMUvxe-bqwwcbTo7A0q-trrULJSUg@mail.gmail.com>
 <CAKOOJTybz71h6V5228vk1erusfb-QJQEQPOaRKzmspfotRHYhA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKOOJTybz71h6V5228vk1erusfb-QJQEQPOaRKzmspfotRHYhA@mail.gmail.com>
X-ClientProxiedBy: MN2PR19CA0023.namprd19.prod.outlook.com
 (2603:10b6:208:178::36) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR19CA0023.namprd19.prod.outlook.com (2603:10b6:208:178::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Wed, 16 Dec 2020 02:39:29 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kpMiu-00B7NP-Pm; Tue, 15 Dec 2020 22:39:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608086378; bh=XARvCpEMpE5ciO8Ya/hhcMPqYkOPvrUqQJbmfp4wdJo=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=qG0FpKDU2ANgkZpx0sqVpL025e2Ny98OmmKmnl3uUCNeawofHDdF5QivtdENOoR/u
         nGFzER0oV9nDZ9C3NLOLKnxoGNPNDjivv+9IZpaxaKPbYrY+jH4/r4pZEYVnGHh4DW
         wm5Tyc2KwXFADG7loTGg9xfEnrhyk2V39HP9+uMCJScJkKspcViu1x6dBFS/7FlIRz
         4W6Dwo4KJqhbLIAR8Gl1s4uYY5Lqy5mupLbTkT+qaImmlXpRxiyb7aVdzEoQ8WXf85
         W7q9uRVMKesYbeHQyrDWcDqhMjwq6+2bLZJGJNGvXzQZrmHAZb9JzCBhXuH6ubW/5w
         f/0zJLE1C95bg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 05:12:33PM -0800, Edwin Peer wrote:

> 1) More than 256 SFs are possible: Maybe it's about time PCI-SIG
> addresses this limit for VFs? 

They can't, the Bus/Device/Function is limited by protocol and
changing that would upend the entire PCI world.

Instead PCI-SIG said PASID is the way forward.

> If that were the only problem with VFs, then fixing it once there
> would be cleaner. 

Maybe, but half the problem with VFs is how HW expensive they are. The
mlx5 SF version is not such a good example, but Intel has shown in
other recent patches, like for their idxd, that the HW side of an ADI
can be very simple and hypervisor emulation can build a simple HW
capability into a full ADI for assignment to a guest.

A lot of the trappings that PCI-SIG requires to be implemented in HW
for a VF, like PCI config space, MSI tables, BAR space, etc. is all
just dead weight when scaling up to 1000's of VFs.

The ADI scheme is not that bad, the very simplest HW is just a queue
that can have all DMA contained by a PASID and can trigger an
addr/data interrupt message. Much less HW costly than a SRIOV VF.

Regardless, Intel kicked this path off years ago when they published
their SIOV cookbook and everyone started integrating PASID support
into their IOMMUs and working on ADIs. The mlx5 SFs are kind of early
because the HW is flexible enough to avoid the parts of SIOV that are
not ready or widely deployed yet, like IMS and PASID.

> Like you, I would also prefer a more common infrastructure for
> exposing something based on VirtIO/VMDq as the container/VM facing
> netdevs. 

A major point is to get switchdev.

> I also don't see how this tackles container/VF portability,
> migration of workloads, kernel network stack bypass, or any of the
> other legacy limitations regarding SR-IOV VFs

It isn't ment too. SF/ADI are just a way to have more VF's than PCI SIG
can support..

Jason
