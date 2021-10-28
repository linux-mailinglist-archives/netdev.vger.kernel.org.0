Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2645D43F394
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 01:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhJ1XuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 19:50:23 -0400
Received: from mail-mw2nam10on2076.outbound.protection.outlook.com ([40.107.94.76]:50321
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229621AbhJ1XuX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 19:50:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+Vf7pCSHuOiufTvbKlE1rK4X1wD6zmlJ3wrJx2rAP3ifXxJQceGGTom64TzFZuL4wfdhkK5rYm7N4D0IMt2ayRWh1l3Ko5PxqZqUfTcRTsKX51i6AbtgwUuTk+qaQKlHh9pSIvc7+A18WFDhb0KsuVlVkNLlwg0wzIxr477qTf3XbSF+l6ECnxnlUyglE6DrPCQGoF3Ae3KlQEDYJecyBEui2saSmFbx6v+AWA19bGPMYEV0Nn7pJm2qRsp/EyFKjGeWIolZfH/mFAdobQGUN1yyv8ZQrzAuun92NtRYz24qrNTmZonJ8v54deP82kklbvl8HJFxK8TOjoS46c3BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TldwpGtOs2nEP44fBgkEtePEa37DlL6zAODCWhLmXb4=;
 b=HEjMz4p1ol0WrW8v4wg6L5RIxe3R8vgLeOd/Q8mDeSqpLP24lkUJn05HPHmh+h5ITpu/4RXZtvYHqqrpWQDM5n+NUNEYSa28GwfORNkE4G/sNKkW5DVR1G5ZxVD7esYV3CixicqvKLLRk2Lj3eb9DSt6+uTSXNj/rxgM6ixoDxZRMXFfu1ePTBSN0sRisYg42lMHT9HluCET8UPrdAP73yUhzGSnRzTWEwsmxerMwkrmWKPhydgtHeI5wrCeWYzY0s+m+a+XpO8VBSiY4SJHDewv8/C825uUOugMNVW0FCav3b3XhkWORNRZJDKWcVHsFGyUGSh8oWqJCn+ztGLXIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TldwpGtOs2nEP44fBgkEtePEa37DlL6zAODCWhLmXb4=;
 b=Vk9dCZbKfxZRyz35c5y1MKTT+BlV8d1HgEOXTqbPTe218mwZz0lBYWZO7e3vgRRNBaouYGEGiIC42gByU6I6fF05PEzIXFtw/Dk8UwXPYafhisHNfBvtDun18IDxThOus/5eyS5wC8VLWOfeu53j+X9REYwczutig78rAhnLta3wMpDAm49utaswZcSrQsUlvnrKnuryqo5JzH+0gTvbBV0Y4vv4NRlWmQjb92OgH7OswLOTiGmw2vXmaL4LUG1N89fAC0ZTrw0fNl3X/aIesZSnR69Xb5bjb+mkSQ94Gslm0ogdCfvFUKQHtCT8U9V4rXGqJBG8rSDK4QICEZSo8g==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5080.namprd12.prod.outlook.com (2603:10b6:208:30a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Thu, 28 Oct
 2021 23:47:53 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.015; Thu, 28 Oct 2021
 23:47:53 +0000
Date:   Thu, 28 Oct 2021 20:47:50 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211028234750.GP2744544@nvidia.com>
References: <20211025122938.GR2744544@nvidia.com>
 <20211025082857.4baa4794.alex.williamson@redhat.com>
 <20211025145646.GX2744544@nvidia.com>
 <20211026084212.36b0142c.alex.williamson@redhat.com>
 <20211026151851.GW2744544@nvidia.com>
 <20211026135046.5190e103.alex.williamson@redhat.com>
 <20211026234300.GA2744544@nvidia.com>
 <20211027130520.33652a49.alex.williamson@redhat.com>
 <20211027192345.GJ2744544@nvidia.com>
 <20211028093035.17ecbc5d.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211028093035.17ecbc5d.alex.williamson@redhat.com>
X-ClientProxiedBy: SJ0PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::26) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by SJ0PR03CA0021.namprd03.prod.outlook.com (2603:10b6:a03:33a::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Thu, 28 Oct 2021 23:47:52 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mgF7e-003BQJ-4h; Thu, 28 Oct 2021 20:47:50 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9701c254-1184-476c-b138-08d99a6d5b8f
X-MS-TrafficTypeDiagnostic: BL1PR12MB5080:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5080A8B7AE0234CBF50A9F96C2869@BL1PR12MB5080.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GHL2x4RNjTFkRFl16AfX5Leg+sORX6RCTprWMszNsgKiRo4bFnnGFzAL9HfklxA+hnqv9RZBbJkpQKYAw1yl18jNrGt+/clLNIbi8O7Y9AOafH8DRkqF1xwybmv2Sz8PTptwD50lWFDFmbS4f0TMmGVuWXQl0lOH8wWsObJuhiCJTE+9X4EtM8gEqmWba+Z2DjwjljNigiVawI3WssdzIHa8oF5aFO/RHrKAgDnwxXgHEGYAk/w4+Uk4JWhCE2X5lEy0iJlcdRXX13w8SAN/djhFtIbvZXSYMQUY7Uk6RzD/oRj3vz9HXT91e53yDmW2q27W/nLBwbvYRJ4PrRFWakyYTNl2A5xoFiLR2JXkSOvF0NYWNXUccAKXkZH04dc/h/IJ0nps0XUGQ4OddmaOt6xJ/YCcfVY5dP1JuM7I7EQOMVit7Sx78JVB32sXKsg1/weshCQvWVf+Tt+IFuOLi8ht0Ncm2EsaaqM8982BkjTDLsmNFz+d+r8H+0Tgxv/tJ3uGxzlEjz22foHTud7W2VgBmG4N/vFFwEOwTzXsKLrw5Mdw0zdk4UPfYp9pcmijBsMpAWb+nD/yA+Ib4D794DjpqL7LiIQnU56Cvd0mw7l2pPAbKtLPkKhRg84FQP4xBDCoKJ334GDfpdUkc969ag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(6916009)(9786002)(86362001)(186003)(30864003)(316002)(54906003)(9746002)(36756003)(66946007)(66556008)(426003)(66476007)(2906002)(2616005)(5660300002)(1076003)(38100700002)(33656002)(26005)(83380400001)(508600001)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jMAoiSdjOeATskLyLUMGWQzwUxFxoE3N6a15Ey4uJbKbcCnmSDo8Jjm8y4cH?=
 =?us-ascii?Q?vXwmQ3Zlvw0yxN2X/5utIjPlcDN3AvEUWFRuxHbZhsSub/D6toBAPBgtD970?=
 =?us-ascii?Q?jpDS/PbiphF2LgtXWScoSohaNWH/ibk1+v2rAW53Sc8maF1sS9fFaO1zg2o8?=
 =?us-ascii?Q?tB43g8/NQ+ZUlRjkuclwpL9VS9hZ9mRDBMjvy9KjvdTCZfXTnT6MDcWb0Q8q?=
 =?us-ascii?Q?qXOvpkdQI8orZHs2oSbdAj5QYxB/wZfV2KfDuag38i5txPTyMRJ3JBmjE/6H?=
 =?us-ascii?Q?fGNB0EWsu0WcZ8RdZFStK/jX/8V6yHX3V4vv0ZIPDy3vTWLH1BeTWhXYmhv/?=
 =?us-ascii?Q?JdzE0NpY1imT2uMAAm/pX/x8xn7RaEIU+ZqmDtsNdw86yySUTMA53TTVTKFX?=
 =?us-ascii?Q?8cUdgP3ROS3ZOvM7MhVXgolkRj9sLp8ggQVmMQrheyoEIPNkIvsAt/y3Bgpy?=
 =?us-ascii?Q?RvpzZ6nEFBhn48UVQpBp1Zj7WCd+LkRFYzM8Z6PAm0llI0uaBZlik01EGfCd?=
 =?us-ascii?Q?1WBuk9K2cgR6ALBvEmzxmitdzzmezHQPQ5ITAIXJphrpg2ou9xGxlVYB0N3c?=
 =?us-ascii?Q?aJONghRiv8zp++mILSdAMpDIjnRGHglLlMowpS5iyDPRVwvJ6IHMKNDpbFhH?=
 =?us-ascii?Q?YURqpNnkfBslMwKAdeSbOfNnNaJNA4+grqLGlQaNn4h0JSQOTCBzjnSPdEvi?=
 =?us-ascii?Q?2vzn5uy9CsBWPhA1rf1cqoa7LamiBrFM5jDvcRp52bkzIMBACYpQtEOY1bA2?=
 =?us-ascii?Q?YbqQ5VF7AG/Q3NRfwnvgIZm3iscNqz8v0MjhzPpEwPWqnF6hXAsfL96gIkpD?=
 =?us-ascii?Q?oZkc1byMKmEh7UVdVZZdR53VFd2lribPTg/u3eaRvH6EqomHkIcssbMmT1Kl?=
 =?us-ascii?Q?sEefBR3f54dokfnHCQxY+hdUrsn6Mz8Hsr0B5RV/kF7Dla6k0q7aQv0zF3uW?=
 =?us-ascii?Q?rEQyQcAAvptL1xrYKMYulxClCx3UjKnJv/qmonVtjHCyf0Wghd1x9Rjow14J?=
 =?us-ascii?Q?vmIJ8wpJMLNqGg6o6Rt95I2q8g5rmTbUFgqA9OYqVMi0boe8wjCWBRvuxlC8?=
 =?us-ascii?Q?JfQXCChi9se08WwaeYbEs896fxPqObLTmUD/uDSnH0JYNe+kTM0leCccAhDS?=
 =?us-ascii?Q?obmM/fFM2gs9AUHHdRUw+0Kil3ClPDuaZA81dfvb5X3tApva30nk32bsfKah?=
 =?us-ascii?Q?e/g+4NJ+xCtV+jFf7b7pSpDWrph+MfSK9COTQUcjzAi0kXWLMAMLrj7mPI29?=
 =?us-ascii?Q?nbqTvl95+swr7ppxrQVXKcX0DsBuPSthus62zxgLP7TOkM7BKtB3loOawL9f?=
 =?us-ascii?Q?VV9sW25tLBw9SR1SPzO/FdP18N0IjdMgfbjmXuRdvXPPAGJMU+vJ7NZdw7yr?=
 =?us-ascii?Q?TcwGSXWP3CM1mOYdFT37IO8OxuT9jINFLBdFfnN1WeCuI9dpbDK3tuAcuDEV?=
 =?us-ascii?Q?KoWbre2rmt7XtbD847+UDPh1bLcUOPoBhqAeBErUlp4TT+2Z3mWYkHVNz9TC?=
 =?us-ascii?Q?J0XQozqDi8S/TqGDEeY6KiydmV3OC2N/XpTXnLMN8NfdRaCW78ut7CXPmeuk?=
 =?us-ascii?Q?491BJlEfZD3BdAt17q8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9701c254-1184-476c-b138-08d99a6d5b8f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2021 23:47:53.6614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fAJmS5NT9/iaFReuD25pz4yOkGyak/ym2WL/V3iwKYyVhyeFzIjYkCQXSsU+mGDC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5080
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 09:30:35AM -0600, Alex Williamson wrote:
> On Wed, 27 Oct 2021 16:23:45 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Wed, Oct 27, 2021 at 01:05:20PM -0600, Alex Williamson wrote:
> > 
> > > > As far as the actual issue, if you hadn't just discovered it now
> > > > nobody would have known we have this gap - much like how the very
> > > > similar reset issue was present in VFIO for so many years until you
> > > > plugged it.  
> > > 
> > > But the fact that we did discover it is hugely important.  We've
> > > identified that the potential use case is significantly limited and
> > > that userspace doesn't have a good mechanism to determine when to
> > > expose that limitation to the user.    
> > 
> > Huh?
> > 
> > We've identified that, depending on device behavior, the kernel may
> > need to revoke MMIO access to protect itself from hostile userspace
> > triggering TLP Errors or something.
> > 
> > Well behaved userspace must already stop touching the MMIO on the
> > device when !RUNNING - I see no compelling argument against that
> > position.
> 
> Not touching MMIO is not specified in our uAPI protocol,

To be frank, not much is specified in the uAPI comment, certainly not
a detailed meaning of RUNNING.

> nor is it an obvious assumption to me, nor is it sufficient to
> assume well behaved userspace in the implementation of a kernel
> interface.

I view two aspects to !RUNNING:

 1) the kernel must protect itself from hostile userspace. This means
    preventing loss of kernel or device integrity (ie no error TLPs, no
    crashing/corrupting the device/etc)

 2) userspace must follow the rules so that the migration is not
    corrupted. We want to set the rules in a way that gives the
    greatest freedom of HW implementation

Regarding 1, I think we all agree on this, and currently we believe
mlx5 is meeting this goal as-is.

Regarding 2, I think about possible implementations and come to the
conclusion that !RUNNING must mean no MMIO. For several major reasons

- For whatever reason a poor device may become harmed by MMIO during
  !RUNNING and so we may someday need to revoke MMIO like we do for
  reset. This implies that segfault on MMIO during !RUNNING
  is an option we should keep open.

- A simple DMA queue device, kind of like the HNS driver, could
  implement migration without HW support. Transition to !RUNNING only
  needs to wait for the device to fully drained the DMA queue.

  Any empty DMA queue with no MMIOs means a quiet and migration ready 
  device.

  However, if further MMIOs poke at the device it may resume
  operating and issue DMAs, which would corrupt the migration.

- We cannot define what MMIO during !RUNNING should even do. What
  should a write do? What should a read return? The mlx5 version is
  roughly discard the write and return garbage on read. While this
  does not corrupt the migration it is also not useful behavior to
  define.

In several of these case I'm happy if broken userspace harms itself
and corrupts the migration. That does not impact the integrity of the
kernel, and is just buggy userspace.

> > We've been investigating how the mlx5 HW will behave in corner cases,
> > and currently it looks like mlx5 vfio will not generate error TLPs, or
> > corrupt the device itself due to MMIO operations when !RUNNING. So the
> > driver itself, as written, probably does not currently have a bug
> > here, or need changes.
> 
> This is a system level observation or is it actually looking at the
> bus?  An Unsupported Request on MMIO write won't even generate an AER
> on some systems, but others can trigger a fatal error on others.

At this point this information is a design analysis from the HW
people.

> > > We're tossing around solutions that involve extensions, if not
> > > changes to the uAPI.  It's Wednesday of rc7.  
> > 
> > The P2P issue is seperate, and as I keep saying, unless you want to
> > block support for any HW that does not have freeze&queice userspace
> > must be aware of this ability and it is logical to design it as an
> > extension from where we are now.
> 
> Is this essentially suggesting that the uAPI be clarified to state
> that the base implementation is only applicable to userspace contexts
> with a single migratable vfio device instance?  

That is one way to look at it, yes. It is not just a uAPI limitation
but a HW limitation as the NDMA state does require direct HW support
to continue accepting MMIO/etc but not issue DMA. A simple DMA queue
device as I imagine above couldn't implement it.

> Does that need to preemptively include /dev/iommu generically,
> ie. anything that could potentially have an IOMMU mapping to the
> device?

Going back to the top, for #1 the kernel must protect its
integrity. So, like reset, if we have a driver where revoke is
required then the revoke must extend to /dev/iommu as well.

For #2 - it is up to userspace. If userspace plugs the device into
/dev/iommu and keeps operating it then the migration can be
corrupted. Buggy userspace.

> I agree that it would be easier to add a capability to expose
> multi-device compatibility than to try to retrofit one to expose a
> restriction.

Yes, me too. What we have here is a realization that the current
interface does not support P2P scenarios. There is a wide universe of
applications that don't need P2P.

The realization is that qemu has a bug in that it allows the VM to
execute P2P operations which are incompatible with my above definition
of !RUNNING. The result is the #2 case: migration corruption.

qemu should protect itself from a VM causing corruption of the
migration. Either by only supporting migration with a single VFIO
device, or directly blocking P2P scenarios using the IOMMU.

To support P2P will require new kernel support, capability and HW
support. Which, in concrete terms, means we need to write a new uAPI
spec, update the mlx5 vfio driver, implement qemu patches, and test
the full solution.

Right now we are focused on the non-P2P cases, which I think is a
reasonable starting limitation.

> Like I've indicated, this is not an obvious corollary of the !_RUNNING
> state to me.  I'd tend more towards letting userspace do what they want
> and only restrict as necessary to protect the host.  For example the
> state of the device when !_RUNNING may be changed by external stimuli,
> including MMIO and DMA accesses, but the device does not independently
> advance state.

As above this is mixing #1 and #2 - it is fine to allow the device to
do whatever as long as it doesn't harm the host - however that doesn't
define the conditions userspace must follow to have a successful
migration.

> Also, I think we necessarily require config space read-access to
> support migration, which begs the question specifically which regions,
> if any, are restricted when !_RUNNING?  Could we get away with zapping
> mmaps (sigbus on fault) but allowing r/w access?

Ideally we would define exactly what device operations are allowed
during !RUNNING such that the migration will be successful. Operations
outside that list should be considered things that could corrupt the
migration.

This list should be as narrow as possible to allow the broadest range
of HW designs.

> > Yes, if qemu becomes deployed, but our testing shows qemu support
> > needs a lot of work before it is deployable, so that doesn't seem to
> > be an immediate risk.
> 
> Good news... I guess...  but do we know what other uAPI changes might
> be lurking without completing that effort?

Well, I would say this patch series is approximately the mid point of
the project. We are about 60 patches into kernel changes at this
point. What is left is approximately:

 - fix bugs in qemu so single-device operation is robust
 - dirty page tracking using the system iommu (via iommufd I suppose?)
 - dirty page tracking using the device iommu
 - migration with P2P ongoing: uAPI spec, kernel implementation
   and qemu implementation

Then we might have a product..

I also know the mlx5 device was designed with knowledge of other
operating systems and our team believes the device interface meets all
needs.

So, is the uAPI OK? I'd say provisionally yes. It works within its
limitations and several vendors have implemented it, even if only two
are heading toward in-tree.

Is it clearly specified and covers all scenarios? No..

> > If some fictional HW can be more advanced and can snapshot not freeze,
> > that is great, but it doesn't change one bit that mlx5 cannot and will
> > not work that way. Since mlx5 must be supported, there is no choice
> > but to define the uAPI around its limitations.
> 
> But it seems like you've found that mlx5 is resilient to these things
> that you're also deeming necessary to restrict.

Here I am talking about freeze/quiesce as a HW design choice, not the
mmio stuff.
 
> > So, I am not left with a clear idea what is still open that you see as
> > blocking. Can you summarize?
> 
> It seems we have numerous uAPI questions floating around, including
> whether the base specification is limited to a single physical device
> within the user's IOMMU context, what the !_RUNNING state actually
> implies about the device state, expectations around userspace access
> to device regions while in this state, and who is responsible for
> limiting such access, and uncertainty what other uAPI changes are
> necessary as QEMU support is stabilized.

I think these questions have straightfoward answers. I've tried to
explain my view above.

> Why should we rush a driver in just before the merge window and
> potentially increase our experimental driver debt load rather than
> continue to co-develop kernel and userspace drivers and maybe also
> get input from the owners of the existing out-of-tree drivers?  Thanks,

It is not a big deal to defer things to rc1, though merging a
leaf-driver that has been on-list over a month is certainly not
rushing either.

We are not here doing all this work because we want to co-develop
kernel and user space drivers out of tree for ages.

Why to merge it? Because there is still lots of work to do, and to
make progress on the next bits require agreeing to the basic stuff
first!

So, lets have some actional feedback on what you need to see for an
rc1 merging please.

Since there are currently no unaddressed comments on the patches, I
assume you want to see more work done, please define it.

Thanks,
Jason
