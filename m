Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB195451A2C
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 00:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350919AbhKOXe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 18:34:59 -0500
Received: from mail-bn8nam12on2089.outbound.protection.outlook.com ([40.107.237.89]:46485
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245321AbhKOXcU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 18:32:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iB8gxuQtL0EE6sitp2SOALh/9OfPimlWV5ouLJVWg3i/vbLjSycbBfEKoRsaH8ykCNBQMQGoPk6O4w7sktTY2xY2WEJrKE7BFdULAIUXVSG6zH1Ft3Ykdc7Zn4vp5Aq8rSWvLC0NZJV0ZsfrkDLmqn9d5rN3DkupcrHZ1m76/SUHsGmzSa5F7fEXVNqhMW+pvfIQVt9eTl+IBoguYOj31RdF6DtqxPymQuTLZPzgkP1o3p4qL/S1UXWm2o8HD0PvmmtYKuzuDHj6vfCe9tBTvWfVHdi5ldzgrzonMivbziKAwfakcTWtda7sfiZu50K8qP7Lif8i10njjhSmdPWULQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4KxrEHwNNmJapWchw+rr/3dy5g5BLYjwLHHGm8Szgr4=;
 b=Fa83OVH2FBj7jGNsB10L0K9JhL0uQGF1tc3VwU29HCsUxUhUBe2zPWyTMJej1k+cNGnDYa1pvg5TBEtk50+YizYR0+3RRLnj4i9SvBeKGRqsgg14aWrJZ2QjqwHbNv7BZo9sEfFfcaS4zHwQD97k6UxWk8y7+87tx/qqH0AHYPJ9EcS0S9ZrZwZlcFJhIE26xkUVRoBK8MSP0k58xADHdF9U6dzY9PfqExPwcvyJO15H+4LtEgQ/UkJisYy9DPdXVaFw9iLCIhLHaFbd00sUbVtfxALj1chFC/rOba+if4UtvlQy7y/Jc0Ximl3qKH2cqgGs8NnQn1Ppa//keS7miQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4KxrEHwNNmJapWchw+rr/3dy5g5BLYjwLHHGm8Szgr4=;
 b=BcWrKhAghSqZk+m3BgOrKkAOoTCE2l+Sj7nv4j57UYEuW0Y+iZxO4ycor2cOgHkZ22hwpCEOLEGPUbkb/+PTpFr3HtldcoVJB0VRpX4KbRDqBH64GyQwG9W6hRBHXxhTsEmaC151+GbY+uLmmpn5cr9km9oPGJoUXaYiw/w95spnSP9D16T1EZJNi6ZLbBMkwec6C+crJhYK+7jfV72OQ5sw/N2BKix+EpSrkO4aYft/F3pr2QJYS657+ul49KuWQ+ltLchAMijwEzEIkjTPH3ZpdMTDnGvy1vcIqKEdRkD5WGSeSJrzdAu8oMu7smv/MI9lOOZE8nJMZs6GAnyf7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5254.namprd12.prod.outlook.com (2603:10b6:208:31e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Mon, 15 Nov
 2021 23:29:23 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 23:29:23 +0000
Date:   Mon, 15 Nov 2021 19:29:21 -0400
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
Message-ID: <20211115232921.GV2105516@nvidia.com>
References: <20211102155420.GK2744544@nvidia.com>
 <20211102102236.711dc6b5.alex.williamson@redhat.com>
 <20211102163610.GG2744544@nvidia.com>
 <20211102141547.6f1b0bb3.alex.williamson@redhat.com>
 <20211103120955.GK2744544@nvidia.com>
 <20211103094409.3ea180ab.alex.williamson@redhat.com>
 <20211103161019.GR2744544@nvidia.com>
 <20211103120411.3a470501.alex.williamson@redhat.com>
 <20211105132404.GB2744544@nvidia.com>
 <20211105093145.386d0e89.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211105093145.386d0e89.alex.williamson@redhat.com>
X-ClientProxiedBy: CH0PR13CA0023.namprd13.prod.outlook.com
 (2603:10b6:610:b1::28) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by CH0PR13CA0023.namprd13.prod.outlook.com (2603:10b6:610:b1::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.18 via Frontend Transport; Mon, 15 Nov 2021 23:29:22 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mmlPd-00Af1k-7D; Mon, 15 Nov 2021 19:29:21 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 150984d2-c585-4bad-aac5-08d9a88fc14a
X-MS-TrafficTypeDiagnostic: BL1PR12MB5254:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5254FF8853005176771B3310C2989@BL1PR12MB5254.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 169B92gItOUvK/oBP/A7Pa8EjyiAUvvdP+uQrsZA+4VTxTqqVpBJHv8LqjKcSlgSrf7ckwNAoAWiUX6P8iaHJoSQJfuNB+xEJTzxR+M+dhjQwb0cSxmXPQ2hRev0+fn3u13c0GukL2/+ZC5t5AwY+4r64b4Wyh7RbqHwmQTl+NrtMwyIGDr4J5dGlf7v2AYwzro6VuCZzoVSkiL0parr/CejB6DOXiUVpn8z7FNykSs57cs+agD65yAr9WTaPpNY3Vuxo2n/vgaXn04ffuP2Tz3I7VsQxbdKikAGXAOP2t1lIciqdhLHycMp5q+4Eb2EGC/L8SEvRTg3KiNVsNeWP2hgUTNPwzythBxwWDuNyqVdFayw5S86X4EboPoQVqzGwJUeuZPnXyfNjg29jW8DqCAI4eYhVBNaYn8KzRWfQCyif9jSjNY+kN1yj1dlzg/NqrkcDItpZ+rCgIWO4r6xCu4XWNZVpC1hplw/HgVHyTnT+DOqb6ShzgBxPJDaNZyjSqzkjstegtAkIydUqSTqrHksFa8xaPSseYqGUqsN0tIt4LemCZ+QDR4eFdGDyYnh31JrnE2iPiw3LJuVsKdlHcLmPGFn1uM26hd//aXSeeJyGwif9tjh0mFvImFyIHfQ2W+Vf7Uag+5JYpZUWlM9uA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(2906002)(1076003)(33656002)(86362001)(316002)(2616005)(186003)(26005)(9786002)(5660300002)(9746002)(508600001)(36756003)(54906003)(4326008)(66476007)(83380400001)(66556008)(426003)(66946007)(8676002)(8936002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ANbGy+aJQi7GsUZG9jqKpi+dLDWelB8uEVlGlGlpV7mK6EflejtCLBCiDgsz?=
 =?us-ascii?Q?Y9x2rarpLoI0PkQqmFe+UAbSM3Q2KzawLE75+Bw5Lepru1jwJ09kjjmZkuzU?=
 =?us-ascii?Q?MMuIe1XXFtk3392oTynpkmoB83x5sN364HsWjmdFhD8QJ8hT6S0uJPLhI7Gw?=
 =?us-ascii?Q?VkgIJorc/7W3o/8HxZEn9XedwBU/n1KWWX2j9HNuTS3yc/2KAD1OZ3yKs2OL?=
 =?us-ascii?Q?8UoN4X3en1vLlqdQQrer3uhtMDI7DfMiwgVbHBPMO3KU9/+/cZMEDqWoAILX?=
 =?us-ascii?Q?xQfhG9U66C9xmQKp/LaWw6HJfhWm/nSqoQ6XzsPAHBH3LC6wxmnXMnNs38ud?=
 =?us-ascii?Q?8w2RNz0kyP3Sk8UVjdlbuHf8uMP0og6iYTOwJobOZCFeKzx6jLlL5lf63ujK?=
 =?us-ascii?Q?d2lSWPu4jcZYZO5CJpggMNsGLC3+4OU9KHNGfETjJlcWCCa1y2O5j05j5skn?=
 =?us-ascii?Q?Wv/Ol9UALpvus12toZ09pQkGuJ5Dsh5UaG/qeezWVbHaTCDb+2eky93XJSmk?=
 =?us-ascii?Q?kpVtkGakTeOND3YoWyjfB43WDuGemmJGhTsG0n6AtIRe9PJ4Jw60UtH/JjZi?=
 =?us-ascii?Q?8PtVGd0AbFa7WS8saEI82zhuCTpFvOnaGVvyb/ZkElZNbrYopCm7HcTo8igJ?=
 =?us-ascii?Q?9bqar6VhipPmFu58Z1XobjtM48e5HyZH8qLkdNTCGgNr1TRA/oJhJE52DM0m?=
 =?us-ascii?Q?Xada2V44d7vkVPrKdqOua6lhtho06FUUJKa+9OtTbHldFlknSUI62vb+kLq0?=
 =?us-ascii?Q?ngfv6p4cRwpNetyEHYtzAf6R5m/MlvggzU7gX8kLTNhqrMVNVGtFoPRw05qL?=
 =?us-ascii?Q?TpJ6vLNFG8K/IzZ9d3BdO28YaCt0TS80TdHU0mlDDgMVoRQ3ESrx5KtZsoK/?=
 =?us-ascii?Q?nXFoM4O9opetNvP9kK8kVumVfRTPZfBbT/yP9HfGr244xfi2zP1/pnWO6m/I?=
 =?us-ascii?Q?MniX3bvhSvHjCTc62XHLX/KplfDu1rhMCBcGOxd2/1tzqys5z3i3VY4AD2jG?=
 =?us-ascii?Q?fPV7DHEN2zMAJga3FzWgIGiYmi9v6Y+9o5fzDsAI9GSJL40uad7SGIVettdm?=
 =?us-ascii?Q?OK79NICqZ9fKFmQCAlu4wlkOJI7H4SYKLZSSs9GGuxUNYjsc/Gc2C/pa1apb?=
 =?us-ascii?Q?5TeL03ahVmJq+wJDGc/RWABt6cRzi+0pqTo7AydAyJTEGPKy5q3nBX+i363p?=
 =?us-ascii?Q?BxYW5xVgR2hpPftq8O1aKo7yN23b0fMzFupyn/plN8z/Owl26Oq14tymAl4C?=
 =?us-ascii?Q?LyzQBAPEnXoHFnIya6WRVVmm3QRYQecWvXtx3IJiFuXSVY0FDN19cqIM8pUS?=
 =?us-ascii?Q?ZHamQ9yVXekFUjUcac1gBxWRyMBWB8+7+1FhLGMZB5ai2Kq/wF2X1diIwB1q?=
 =?us-ascii?Q?JEsmvgoKlnziPi18dL+M4kIRsyEkcoRfq2zWN+gY6MaEBqqAcE2XQo03Nszq?=
 =?us-ascii?Q?fal5diAA5yOevSqJhHYHYSkFq/HPlG6Gw6aAhEZHNKNLIBdYCQDRXOoIFxeG?=
 =?us-ascii?Q?dX1DQvEB4/C9Shi17YWLPaYumpES8kbrsMBHFFYvZcLEbsXKVPaUCY42Na1P?=
 =?us-ascii?Q?rSEif/cO8XnRFDaYK4w=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 150984d2-c585-4bad-aac5-08d9a88fc14a
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 23:29:22.9388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yRjAnT/og9Rsj7Y9H6BlbouHy0wMEF1nKr14JRSUThaMm2VblJ00JSQFKk5wGiAU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5254
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 05, 2021 at 09:31:45AM -0600, Alex Williamson wrote:
> On Fri, 5 Nov 2021 10:24:04 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, Nov 03, 2021 at 12:04:11PM -0600, Alex Williamson wrote:
> > 
> > > We agreed that it's easier to add a feature than a restriction in a
> > > uAPI, so how do we resolve that some future device may require a new
> > > state in order to apply the SET_IRQS configuration?  
> > 
> > I would say don't support those devices. If there is even a hint that
> > they could maybe exist then we should fix it now. Once the uapi is set
> > and documented we should expect device makers to consider it when
> > building their devices.
> > 
> > As for SET_IRQs, I have been looking at making documentation and I
> > don't like the way the documentation has to be wrriten because of
> > this.
> > 
> > What I see as an understandable, clear, documentation is:
> > 
> >  - SAVING set - no device touches allowed beyond migration operations
> >    and reset via XX
> 
> I'd suggest defining reset via ioctl only.
> 
> >    Must be set with !RUNNING
> 
> Not sure what this means.  Pre-copy requires SAVING and RUNNING
> together, is this only suggesting that to get the final device state we
> need to do so in a !RUNNING state?

Sorry, I did not think about pre-copy here, mlx5 doesn't do it so I'm
not as familiar

> >  - RESUMING set - same as SAVING
> 
> I take it then that we're defining a new protocol if we can't do
> SET_IRQS here.

We've been working on some documentation and one of the challenges
turns out that all the PCI device state owned by other subsystems (eg
the PCI core, the interrupt code, power management, etc) must be kept
in sync. No matter what RESUMING cannot just async change device state
that the kernel assumes it is controlling.

So, in practice, this necessarily requires forbidding the device from
touching the MSI table, and other stuff, during RESUMING.

Further, since we can't just halt all the other kernel subsystems
during SAVING/RESUMING the device must be able to accept touches in
those areas, for completely unrelated reasons, (eg a MSI addr/data
being changed) safely.

Seems like no need to change SET_IRQs.


> >  - NDMA set - full device touches
> >    Device may not issue DMA or interrupts (??)
> >    Device may not dirty pages
> 
> Is this achievable?  We can't bound the time where incoming DMA is
> possible, devices don't have infinite buffers.

It is a necessary evil for migration. 

The device cannot know how long it will be suspended for and must
cope. With networking discarded packets can be resent, but the reality
is that real deployments need a QOS that the device will not be paused
for too long otherwise the peers may declare the node dead.

> > Not entirely, to support P2P going from RESUMING directly to RUNNING
> > is not possible. There must be an in between state that all devices
> > reach before they go to RUNNING. It seems P2P cannot be bolted into
> > the existing qmeu flow with a kernel only change?
> 
> Perhaps, yes.

We have also been looking at dirty tracking and we are wondering how
that should work. (Dirty tracking will be another followup)

If we look at mlx5, it will have built in dirty tracking, and when
used with a newer IOMMUs there is also system dirty tracking
available.

I think userspace should decide if it wants to use mlx5 built in or
the system IOMMU to do dirty tracking.

Presumably the system IOMMU is turned on via
VFIO_IOMMU_DIRTY_PAGES_FLAG_START, but what controls if the mlx5
mechanism should be used or not?

mlx5 also has no way to return the dirty log. If the system IOMMU is
not used then VFIO_IOMMU_DIRTY_PAGES_FLAG_START should not be done,
however that is what controls all the logic under the two GET_BITMAP
APIs. (even if fixed I don't really like the idea of the IOMMU
extracting this data from the migration driver in the context of
iommufd)

Further how does mlx5 even report that it has dirty tracking?

Was there some plan here we are missing?

In light of all this I'm wondering if device dirty tracking should
exist as new ioctls on the device FD and reserve the type1 code to
only work the IOMMU dirty tracking.

Jason
