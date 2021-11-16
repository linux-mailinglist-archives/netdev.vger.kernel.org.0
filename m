Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2872F453A1E
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 20:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239820AbhKPT2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 14:28:08 -0500
Received: from mail-bn1nam07on2054.outbound.protection.outlook.com ([40.107.212.54]:13383
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229663AbhKPT2G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 14:28:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cw2rFcD76YZmFzjEKcpKVWNdTSBe3h5CnHe+pApRViou3Ggd/PWoLx0LEI6gQVl2Pxy0k38j84pw9Cc27HpmjJnpHzXgOxhjDSxgFmptqYLvFQBNwN48KDlx7uly9TLBeidXY6zXutAzptetclEXORCbUgmpJUbrhE/p9szoAQGtjZsJER3SpU61875LZInJp/4qJzPL9z3jK+FKI53JjVOsypmH6y8odXASaGXxC+HRH/bZ98tAotKLwqZWRXrqD3eFdmODkMPJNEMmwrkOqb8Lpg9KIk9qPFt4Np68XN29g4RobnsDg3D4wHcqYq60ut+F8G2/Bf5BkHG6GAryow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JcYIsBopb7Nrl3M4T9gj59ScRZb1+9TAYMDXXKld4cM=;
 b=Ljx2USncGAtXlOqSxut5CbhBtf+SzFKlj6rd6TWAjsSozBQB7Nx6fPppbV6kGFCWxx3Y3qBFgCpbWCyy8kAp3cAnrcg+huFhn4ldhtpsb6+xPJbVZNYVAhulfqMe99K6UQ27uk7lDsdPifcUAZ6+yA3BsRR06545qL0PkaJqJXhYCl/QoraUC0qCsfRzUtCT/spsCsLQGCE8HZOVRG1Lb8OHJPNoBa3YGCLB+dnxcOaAagzB2MaJwdAcaUfxBsot2BG8VL9z8mc+x1I7Ic3QY5KNq5WKXqEhEAuYZ3eoIC3Pw7E/LfKn2pbZU2kEfLDPHArm6NVfazwvKQQUxQQb7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JcYIsBopb7Nrl3M4T9gj59ScRZb1+9TAYMDXXKld4cM=;
 b=Pe+5TFQUl6i/2lFAQzMs3GpeCxb2wBBMc3c40z7PDalaOZUIzay47+jbHDnd8LJ/c/WFt0jdsoBI4uPs9Gj3gbdZetFvNxLWeVbNiiwS318MIYeNgg/0WFP1AunDfwU/iq+WlCKMt8yKqLdq9GDn2ljoVJMXSDpyN3lvEDkYKaG43VTC1Ef6rtuZwHZOjoBkcO57TpyxMLXItIDNZejLIpCYBdcB+h2FG2n7J33LdrzPRWxTMTrt9LslIBSJ2z+1y6fm9X8tPSUj3M9qolw97GCZXnM6KxknxOYlnW5yj4AfQCKB7m5qRDIBCgzUkrk3FlfKKLtKa9dAXr26Ir0oiQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5208.namprd12.prod.outlook.com (2603:10b6:208:311::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Tue, 16 Nov
 2021 19:25:07 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 19:25:07 +0000
Date:   Tue, 16 Nov 2021 15:25:05 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211116192505.GB2105516@nvidia.com>
References: <20211102163610.GG2744544@nvidia.com>
 <20211102141547.6f1b0bb3.alex.williamson@redhat.com>
 <20211103120955.GK2744544@nvidia.com>
 <20211103094409.3ea180ab.alex.williamson@redhat.com>
 <20211103161019.GR2744544@nvidia.com>
 <20211103120411.3a470501.alex.williamson@redhat.com>
 <20211105132404.GB2744544@nvidia.com>
 <20211105093145.386d0e89.alex.williamson@redhat.com>
 <20211115232921.GV2105516@nvidia.com>
 <20211116105736.0388a183.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116105736.0388a183.alex.williamson@redhat.com>
X-ClientProxiedBy: YTOPR0101CA0030.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:15::43) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YTOPR0101CA0030.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:15::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 19:25:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mn44n-00BBc8-7J; Tue, 16 Nov 2021 15:25:05 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44c38903-adf9-4be6-036d-08d9a936cc47
X-MS-TrafficTypeDiagnostic: BL1PR12MB5208:
X-Microsoft-Antispam-PRVS: <BL1PR12MB52081A96C75EEEF55E7ACB7BC2999@BL1PR12MB5208.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FeKkiuf4Un00qSqhA59o/eq5j7pcNFLaRBJx/uqeCDerB6C0SrJgKjBcg93C66iRXvJ1KBI8gxQMF2UHq3Hh3eaSiyohVw6oymkj6nLgR3hMkeD8nLe0z2pRegoSZ9Br9eCDRO75QKO3xFUXG0LgTw7w2gxrGP2WH18yGemPPFGMgsloQMZiKtqZyYul9Vcnd0C48QjKFj6qeoOhw9kcmF7npUUSFobplEOnhK0OxITF2bS0uUfGSlGNdxfoeeWX1r+YfTQuUk+mev2F0YFBxTNzd0fIGhtqt1oFxdsHeWIxSzGg6pTv1LExEqaGdYkJF2A2puDRlLbEYZvf50JzY46nnGfI2OodyICy5rko6PBYDTS/VGOwhBI1u3H16HNvgBNVEoF/FOgeN7FaprCBi+U0d5HBU8rQKJJ46tWIp8YkSd4pH/MqJKshbYOMMSSzHO8Mb+dlPuneyqgfdFNGlSWjVx/WJoXSJoB5kWxTZttUy4Cgtp60bzu/3UI0H87DesNkuNGcjKoZWuFARgTcNfgfjmpXvWQyKszqhOAwASIv6DDjgr4qAV4MNBcificFOYelHzyO0XvxC6qno9/DiiQ5tP7Lb5liLJ3xQIJEqbLHhNWhX3NQXmvp42mO5DbOnNwHZL1NjIotGtkpsuCjmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(38100700002)(426003)(2616005)(316002)(9786002)(186003)(66556008)(66946007)(8936002)(86362001)(26005)(2906002)(36756003)(54906003)(6916009)(66476007)(9746002)(8676002)(1076003)(4326008)(508600001)(83380400001)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UzTrAXt3mvBKqbfELn17LQibFTYZbJ/EBfp40R8g9nDcKV5a/JXWlW7DkLnM?=
 =?us-ascii?Q?svUaDgnbSF/0QT8ujrz/LKcpotBcYQAhNfr1jZXVEpg8K55eU69FYSfrAY+1?=
 =?us-ascii?Q?IlEim6XQYRkLVG7vQavzOzWGIJheV4ey/o44pvq9fp4u/P1WjBJxuT6mbUdO?=
 =?us-ascii?Q?OTa3VazCNmZWPiw74kBA7oASo0qIJOkPEfcP5XRL0FCoI0+NTZuFGLIcM5ph?=
 =?us-ascii?Q?MNZFzD++/2Ra/gBJPC2r9Y/ldz9HUYOTAyuibSqKZNw49dH0dEZh0ItJDYpl?=
 =?us-ascii?Q?7qs5wVBeXi9TdEUmaCt5kcOR9iQq+GJEpQYQ/jlWZq1xRBeLP7pZmg0a17Js?=
 =?us-ascii?Q?FVK3aVJg6Fb+u6tjv/IJhg3q8zL68Ubmk/d3+fS/x0U17jcZTGcrhZ5j8IBq?=
 =?us-ascii?Q?5Fpu7enhz6asKJSBOsyPIcRh79ymsefL08wwZBL2tlXiXaRu+jSPtNx902bC?=
 =?us-ascii?Q?MCpwUTePM1bpsKr6mN5pAz3vCljsJcK7PDVt//NcgDNxAYuJ6Sj7orNZClze?=
 =?us-ascii?Q?0AQP1f5zrC1ZEFAxTezL2ab6XafJmr6ct3c76w17tw8Jonb2OD8EvA1IpX6b?=
 =?us-ascii?Q?mMz9rba7XYb2GuLBhOKXfRaV3U9gb4BMqzSvcwnBWMUIxwbtpvyezsES6oxZ?=
 =?us-ascii?Q?P/ePTWMJFUi7wlTJWeCOLqXPP8eALOAoFyPFQvqm9RBLv0Mx/1OGHO2GefEC?=
 =?us-ascii?Q?9XRbUxf7Q6SK7zq9WprQh+DcKmp4TmV4uXNu454G4W1/SE4mV/H2ri+cxT+P?=
 =?us-ascii?Q?YQOVvNCWqF3v1I6EPFMx/6sWXXta3KkfS45tyKgEWXjF8sYPvhysLxK0BYBb?=
 =?us-ascii?Q?48vHhfKdENuWlTMHXn5WgkeP+Km7korEZ0Sckey0fk48DF1xPRlnXy3EOMcR?=
 =?us-ascii?Q?Sk89CuutOIvdXesFr9ne69NE4ez5T29/ye6mImSJ1KILYf9qk8x2PmEPO6fw?=
 =?us-ascii?Q?ayT7gqiwOIShM2gRWsnE/4pIDRxcLzlVPBYWjE0z4dO+CdeRpTnbtWi+29L1?=
 =?us-ascii?Q?0tmISQqg62SHmY9Nmy5m1MhmcEO6ZSkUifmBjRa6UnQdYXcYh8ltQu9i3Z+G?=
 =?us-ascii?Q?OrB4wN6izf1CtVDI/w8lfnL17btjijdcqnAw9EUzYIpQWcNxEGbpApWHTeye?=
 =?us-ascii?Q?IKca5MvLglODBl761GoTTAEqD1Dyit0xUaetYt+ONntYo2wpXVCJQjXtOxE2?=
 =?us-ascii?Q?zPGDA9KMnPFs8WOnotWor/SXZjyfKbGUQrTj+zwJUfJS0LC3z/SyQizt4P6n?=
 =?us-ascii?Q?+qtxKHnrKSFzaocdxM30cuuQbH/tCaA4DdlAUJ/+KRDYtUXsqfNv32iCoqJG?=
 =?us-ascii?Q?dR0PU2U3lL/FowHINq6Zn8fvdkE38GM5DKBebsESMQ2LGpUR8OcfL8rZ25Si?=
 =?us-ascii?Q?H7agdFjX4jXPEj1Iov5TbwdCbIZ4xm14KA5szHByE72AI+8JxOvU55cU/jCt?=
 =?us-ascii?Q?ivFewT8VoUcjIoGRtlP0cJ1lqG/1r+l1Af4dJxYfWfZVZgEW64gfQXW+JMXt?=
 =?us-ascii?Q?PDoCLcpyihdjY3+iPkbVJrWzojPB2bKEuK/R9TQBMK1DymnLfKSGw7BLc0EH?=
 =?us-ascii?Q?V5L8nNmEZlBeyytO5sg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44c38903-adf9-4be6-036d-08d9a936cc47
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 19:25:07.1822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ghEfWaj3Bk9Cww3t2enNJP80eAqdaLTA4/phLLz7uXzxq3HSj3g0zQUBfO1dJkhu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5208
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 10:57:36AM -0700, Alex Williamson wrote:

> > I think userspace should decide if it wants to use mlx5 built in or
> > the system IOMMU to do dirty tracking.
> 
> What information does userspace use to inform such a decision?

Kernel can't know which approach performs better. Operators should
benchmark and make a choice for their deployment HW. Maybe device
tracking severely impacts device performance or vice versa.

Kernel doesn't easily know what userspace has done, maybe one device
supports migration driver dirty tracking and one device does not.

Is user space going to use a system IOMMU for both devices? 

Is it going to put the simple device in NDMA early and continue to
dirty track to shutdown the other devices?

> Ultimately userspace just wants the finest granularity of tracking,
> shouldn't that guide our decisions which to provide?

At least for mlx5 there is going to some trade off curve of device
performance, dirty tracking page size, and working set.

Even lower is better is not necessarily true. After overheads on a
400GB RDMA NIC there is not such a big difference between doing a 4k
and 16k scatter transfer. The CPU work to process all the extra bitmap
data may not be a net win compared to block transfer times.

Conversly someone doing 1G TCP transfers probably cares a lot to
minimize block size.

Overall, I think there is far too much up in the air and unmeasured to
firmly commit the kernel to a fixed policy.

So, I would like to see userspace control most of the policy aspects,
including the dirty track provider.

> I believe the intended progression of dirty tracking is that by default
> all mapped ranges are dirty.  If the device supports page pinning, then
> we reduce the set of dirty pages to those pages which are pinned.  A
> device that doesn't otherwise need page pinning, such as a fully IOMMU

How does userspace know if dirty tracking works or not? All I see
VFIO_IOMMU_DIRTY_PAGES_FLAG_START unconditionally allocs some bitmaps.

I'm surprised it doesn't check that only NO_IOMMU's devices are
attached to the container and refuse to dirty track otherwise - since
it doesn't work..

> backed device, would use gratuitous page pinning triggered by the
> _SAVING state activation on the device.  It sounds like mlx5 could use
> this existing support today.

How does mlx5 know if it should turn on its dirty page tracking on
SAVING or if the system IOMMU covers it? Or for some reason userspace
doesn't want dirty tracking but is doing pre-copy?

When we mix dirty track with pre-copy, the progression seems to be:

  DITRY TRACKING | RUNNING
     Copy every page to the remote
  DT | SAVING | RUNNING
     Copy pre-copy migration data to the remote
  SAVING | NDMA | RUNNING
     Read and clear dirty track device bitmap
  DT | SAVING | RUNNING
     Copy new dirtied data
     (maybe loop back to NDMA a few times?)
  SAVING | NDMA | RUNNING
     P2P grace state
  0
    Read the dirty track and copy data
    Read and send the migration state

Can we do something so complex using only SAVING?

.. and along the lines of the above how do we mix in NDMA to the iommu
container, and how does it work if only some devices support NDMA?

> We had also discussed variants to page pinning that might be more
> useful as device dirty page support improves.  For example calls to
> mark pages dirty once rather than the perpetual dirtying of pinned
> pages, calls to pin pages for read vs write, etc.  We didn't dive much
> into system IOMMU dirtying, but presumably we'd have a fault handler
> triggered if a page is written by the device and go from there.

Would be interesting to know for sure what current IOMMU HW has
done. I'm supposing the easiest implementation is to write a dirty bit
to the IO PTE the same as the CPU writes a dirty bit the normal PTE.

> > In light of all this I'm wondering if device dirty tracking should
> > exist as new ioctls on the device FD and reserve the type1 code to
> > only work the IOMMU dirty tracking.
> 
> Our existing model is working towards the IOMMU, ie. container,
> interface aggregating dirty page context.  

This creates inefficiencies in the kernel, we copy from the mlx5
formed data structure to new memory in the iommu through a very
ineffficent API and then again we do an ioctl to copy it once more and
throw all the extra work away. It does not seem good for something
where we want performance.

> For example when page pinning is used, it's only when all devices
> within the container are using page pinning that we can report the
> pinned subset as dirty.  Otherwise userspace needs to poll each
> device, which I suppose enables your idea that userspace decides
> which source to use, but why?

Efficiency, and user selectable policy.

Userspace can just allocate an all zeros bitmap and feed it to each of
the providers in the kernel using a 'or in your dirty' semantic.

No redundant kernel data marshaling, userspace gets to decide which
tracking provider to use, and it is simple to implement in the kernel.

Userspace has to do this anyhow if it has configurations with multiple
containers. For instance because it was forced to split the containers
due to one device not supporting NDMA.

> Does the IOMMU dirty page tracking exclude devices if the user
> queries the device separately?  

What makes sense to me is multiple tracking providers. Each can be
turned on and off.

If the container tracking provider says it supports tracking then it
means it can track DMA from every device it is connected to (unlike
today?). eg by using IOMMU HW that naturally does this, or by only
having only NO_IOMMU devices.

If the migration driver says it supports tracking, then it only tracks
DMA from that device.

> How would it know?  What's the advantage?  It seems like this
> creates too many support paths that all need to converge on the same
> answer.  Consolidating DMA dirty page tracking to the DMA mapping
> interface for all devices within a DMA context makes more sense to
> me.

What I see is a lot of questions and limitations with this
approach. If we stick to funneling everything through the iommu then
answering the questions seem to create a large amount of kernel
work. Enough to ask if it is worthwhile..

.. and then we have to ask how does this all work in IOMMUFD where it
is not so reasonable to tightly couple the migration driver and the
IOAS and I get more questions :)

Jason
