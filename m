Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1B5453DE1
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 02:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbhKQBvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 20:51:33 -0500
Received: from mail-bn8nam12on2087.outbound.protection.outlook.com ([40.107.237.87]:56233
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230145AbhKQBvc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 20:51:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C7R5j0JKzv2Kb1Km2sbPt9zLyhsQW0zYqjSCfrhCQf//CPxp+DbMlno9TKMVNSy1hxQkB7i9lpKrEKRJTp7k+DgYrSfrX8Bh30pvbd40qWwkgVV1G6qeaufEIYV5yqwWQ5/xAuMfxWVxM399kkO4I8WxOcmop2qZH7jSek8hUkLGerKfIhHbP43YXb4BvIJnz097seNq8+ZU4Hb2VmlRv4qMMTqWBdQ170nuMSvITF1Gs9uF09fcFKW0rs43Eo7W44dFQ0vdoyPGTxU0YbVNrbpquQogyS6airSAtmkOq99crBsW22qodO1BLQBsRSQ+U7aqiM0b4mNKqunDTobVPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7RXAh2WQUen7U6+MmmMUlAV9NlBl4Evj+RGuk4E6noY=;
 b=NcwMm80Z2qqqoG+lbxm/XtZvzIDsr9Jz/nW5qh7KwpOzaYojUVf/edmEhvefiyicPvBc8Jwhdhr7sDIzbHuo5nVSicVhxstivnMTWKNwZjJGGYspK879yucqQePG7NJ9Jzyha10LUh21ZaWeUU870AVEHZZHI5TMLUq2OVgblrbuJsGhQ6ldUSTelY7SoLra8mBax8hKihcJ7PMqnPzzDtC42jjyNg9yXbQ0bWNMblbO+TWOA+2jSRW65q4sMPMoAv7e2P3nBQYQ9TqpcJBrjpHkcs/mJDAb5GCWWO6NLdRhVJUGt7ramLP4408l4WmZr2s64/nqhKOUJ3UYg/GfLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RXAh2WQUen7U6+MmmMUlAV9NlBl4Evj+RGuk4E6noY=;
 b=JvyzkZDpzjCjNPrRxr3N1XwiIbyuBVfW2cQEOjwYm+z97FupTEZcN6+HDWwxaYxo7mo4Jjjkhhi8qovSH0uLUb9pEw/SA0XCWrL5MI4v0CUEbHRYGZcIsph92NnWM+81VF0k/SX/mQ8qmqdHOb6152EIjE+JIsmbV7EMTXCV3Xcgz0WcGyAyEvg7g8mRe+HJtG0Xl744Oy7+eRNJfYZ/C0OLAxg+EEE0ykKBC09BZm4jXsihsYWFwxTX6aRhXTDfEMbPMguA+YqPhrcI347PfSi/cVkJYrD+CJNH9V6/evIQ58dZKDFXlV3Fq56fqRDLh2ONvpTGqixJB5vGV8nefg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5126.namprd12.prod.outlook.com (2603:10b6:208:312::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Wed, 17 Nov
 2021 01:48:33 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4690.027; Wed, 17 Nov 2021
 01:48:33 +0000
Date:   Tue, 16 Nov 2021 21:48:31 -0400
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
Message-ID: <20211117014831.GH2105516@nvidia.com>
References: <20211103120955.GK2744544@nvidia.com>
 <20211103094409.3ea180ab.alex.williamson@redhat.com>
 <20211103161019.GR2744544@nvidia.com>
 <20211103120411.3a470501.alex.williamson@redhat.com>
 <20211105132404.GB2744544@nvidia.com>
 <20211105093145.386d0e89.alex.williamson@redhat.com>
 <20211115232921.GV2105516@nvidia.com>
 <20211116105736.0388a183.alex.williamson@redhat.com>
 <20211116192505.GB2105516@nvidia.com>
 <20211116141031.443e8936.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116141031.443e8936.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0196.namprd13.prod.outlook.com
 (2603:10b6:208:2be::21) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0196.namprd13.prod.outlook.com (2603:10b6:208:2be::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.15 via Frontend Transport; Wed, 17 Nov 2021 01:48:32 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mnA3r-00BHQv-Rh; Tue, 16 Nov 2021 21:48:31 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5c590b5-54f2-4cf8-dbe2-08d9a96c5ccb
X-MS-TrafficTypeDiagnostic: BL1PR12MB5126:
X-Microsoft-Antispam-PRVS: <BL1PR12MB512691F33CE73A399FC43A88C29A9@BL1PR12MB5126.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y35lmc431JIih3u9rqvlTmt67d+PLcVpcioRhVAnH1oz10cSsvn06Ftiry3sKW2/9fHHlRHJrsqaKXB8yA1qXyaLGdiXPVwVnqQYKBrZ0FH+rNAeh6hQ4N/Pt+00s5j/TTniy8zfMSDkw044qAptyDhUc1Pj9KBPIBeDHvde8OWdILKnkpv52Uxw4CD5/K7JZrFrlNGOQYWJzu681C65pZ3EJmHx7s4/PNa5x6V75qd2yW8BLaJbm28JQkLTerXWvPXpdJeggUxeRDqaMorL9cM190UQI1A2IfhaoO5+AUwBpGtvngZMcSXUizmkPIw+BCQH3eIWm7NkMxe6qFvEsK/tmaBmZlDUh27xAnNd9fF/9wW8zLPvpIl1Y/Reqod2nrG5eBS4cyjAjDTu85Ru19hH6f8f3BmuDULiWu6KW/PTpVFw6UkG3lCLcufcEng5xzLR66+8+LAKdMjDg4fG0VZ0CROmrO7sTQLBMlx+XxCPnOuqh07ksS/CbVQBRzgtPx/sRZtZfQVDwWRsIiYT9N83KiwToQ0aMSXgCBcIx6bGiDX17DcJoC0aVDosBpcI37NbgKQmNb12rPz5NiO9tPnVE7j3DqlEEbC0bSPGuACBGL1wIdUKi1Z0v9I6oVM4ylCRHmM777c3/lOjoIMJSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(26005)(2906002)(1076003)(36756003)(30864003)(8676002)(33656002)(38100700002)(8936002)(2616005)(83380400001)(86362001)(4326008)(186003)(426003)(6916009)(66556008)(66476007)(9746002)(9786002)(66946007)(54906003)(508600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eRoNtzjKk1KSRLigkJD3EoU6siwODkCTICdv6lkyt7rvV7AecIkcJkb/9Ve1?=
 =?us-ascii?Q?m/tczGNrwJzg/c2320rDYkvphxzt/EEvuxO8a17aIQT4oXuxzV5X93rDeTFL?=
 =?us-ascii?Q?fe3x0KAQgetWDe3P9plRmbJj3tTcpmM45gm9RnBuSFDpZHXEtDMTmtZsu2Nl?=
 =?us-ascii?Q?zOlsfvRhX87O9zgfhIYK2GbTQTJiQjOnmVfWiFue23Y5dZizJXkvJTZRGQG9?=
 =?us-ascii?Q?kzvPshZPO7Vh+VBrBa8S2DBprmQD3xn0+GYklsI6/K7lAq1iDe41Af9OK8gQ?=
 =?us-ascii?Q?IAopvry8Pb1r2QBHXSp/4bA2jCKIkPf2IqREOUJTnsHdcGdW0Pbo81agPTsK?=
 =?us-ascii?Q?44noB+vwqTEeXIO1Qv9fI3Q/endbHOLQDQXWIV6GmbwNjsyRMsCsul1BQ2CX?=
 =?us-ascii?Q?XLRbsJDvCus+53jsh4e97ktREHjrpUqiRLWm98CkbTS6+WozRfoMRnET3g3Y?=
 =?us-ascii?Q?3YrsfE3/cmBoDhPrs8uEKgYO0XqaNhciG5ZIAsJ3gHTWMUkpVu+XdiJT+Ll/?=
 =?us-ascii?Q?/Zy2wNd6NyEulOYNBTmPI0o1G08jsZouCvSYNltydNJuiTM3sBqicCX2wqqQ?=
 =?us-ascii?Q?B35ElDcKaFIoCK5p7E4zfCuonPM86GI+rECG7cT24JoAIRs5beZwvdEVew2y?=
 =?us-ascii?Q?Xr3KMFGtVT/oRTHwMFZaujbeIJtewVBmRfbt9kMoE1A2gv1oZapYl3QRw3az?=
 =?us-ascii?Q?2yL9jcMAu4p4NgOZGgrQ+xkbi/Y+EFsv4xj2l59UUsUNxL/W8z4BHkzbOynp?=
 =?us-ascii?Q?OvwUUWM18rBj2xm97Y2QbYKOB/jOzXtw4klVGckIHutUzKAdANPRqSLKGa1Q?=
 =?us-ascii?Q?SCqLM2IvX/c5HLjz/n0lDYb1yi9JAEyr1qduuXb69ZLMmGKAj2Lxp4guy2Br?=
 =?us-ascii?Q?7GgLZ1T4rYkBw95Vo6VK69bq3/GBhYgTZi9aZbkQm/myvaGn9RntWYkOiMlr?=
 =?us-ascii?Q?LfbS+wD1wuXn7XnTP4uC58pVyhOzRlanroFD0R0VflXzkXLHZdBwvGSH3xdI?=
 =?us-ascii?Q?r8H+4e5vhAjv7pwroXB/Z+8c0yIh0PsbADFXBCu2s+SQHVdv3/CbyOT5v9pf?=
 =?us-ascii?Q?+QnOHDtFf/L+du7kq+STZz92ArIE4VB+WZQHmqys+vOqEeB2Kp7ADtEk+hi5?=
 =?us-ascii?Q?5bFLq4dJ704TwsMgOeEfbW3CP5AWJySqJDn23ytGnju9R86m4Y/lTJtGWdm/?=
 =?us-ascii?Q?6nNlFvO0GqrknX2GILX/w6NYUDvvz32J9p+9KtvXznGoUDQitNZ2MGpF/ffJ?=
 =?us-ascii?Q?2Js5iO0Nypatqx8gzH08OAAX/MRYLzWhkqAXMJMuQdAkHxGVjEEn2d3lN+x/?=
 =?us-ascii?Q?d31zBV3cyzv97XB7YFXpZzbDVsXR+5FsdG2e59P5v90uNLnnztfKOQ56Pia4?=
 =?us-ascii?Q?2k2K9JsDvVP2GLlTW9/cl78nAKAjjrbK5pMxq13kUn9qYZzyk+wS+Mpk2yB0?=
 =?us-ascii?Q?1R8adq8n6YbALRDY7crjlJJMsDWqy/qU3hQNLyTb5do6qocyb+ItBbDg0Sq3?=
 =?us-ascii?Q?N0PtFRVi0+PXaqcqgPm4T8ncthuNYTmv0O+t8hIFonikKUt9wjzpkHYFUQEh?=
 =?us-ascii?Q?a5+0JUXrEvcWXXT4o14=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5c590b5-54f2-4cf8-dbe2-08d9a96c5ccb
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2021 01:48:33.0939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w5ZsD9YeKplux6dsMdjG1nzm7wEO+20cTcf8wOOAAr2icFDtz4DZ7B34dE3TmEfH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5126
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 02:10:31PM -0700, Alex Williamson wrote:
> On Tue, 16 Nov 2021 15:25:05 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Nov 16, 2021 at 10:57:36AM -0700, Alex Williamson wrote:
> > 
> > > > I think userspace should decide if it wants to use mlx5 built in or
> > > > the system IOMMU to do dirty tracking.  
> > > 
> > > What information does userspace use to inform such a decision?  
> > 
> > Kernel can't know which approach performs better. Operators should
> > benchmark and make a choice for their deployment HW. Maybe device
> > tracking severely impacts device performance or vice versa.
> 
> I'm all for keeping policy decisions out of the kernel, but it's pretty
> absurd to expect a userspace operator to benchmark various combination
> and wire various knobs through the user interface for this. 

Huh? This is the standard operating procedure in netdev land, mm and
others. Max performance requires tunables. And here we really do care
alot about migration time. I've seen the mm complexity supporting the
normal vCPU migration to know this is a high priority for many people.

> It seems to me that the kernel, ie. the vfio variant driver, *can*
> know the best default.  

If the kernel can have an algorithm to find the best default then qemu
can implement the same algorithm too. I'm also skeptical about this
claim the best is knowable.

> > Kernel doesn't easily know what userspace has done, maybe one device
> > supports migration driver dirty tracking and one device does not.
> 
> And that's exactly why the current type1 implementation exposes the
> least common denominator to userspace, ie. pinned pages only if all
> devices in the container have enabled this degree of granularity.

The current implementation forces no dirty tracking. That is a policy
choice that denies userspace the option to run one device with dirty
track and simply suspend the other.

> > So, I would like to see userspace control most of the policy aspects,
> > including the dirty track provider.
> 
> This sounds like device specific migration parameter tuning via a
> devlink interface to me, tbh.  How would you propose a generic
> vfio/iommufd interface to tune this sort of thing?

As I said, if each page track provider has its own interface it is
straightforward to make policy in userspace. The only tunable beyond
that is the dirty page tracking granularity. That is already
provided by userspace, but not as an parameter during START.

I don't see why we'd need something as complicated as devlink just
yet.

> > How does userspace know if dirty tracking works or not? All I see
> > VFIO_IOMMU_DIRTY_PAGES_FLAG_START unconditionally allocs some bitmaps.
> 
> IIRC, it's always supported by type1.  In the worst case we always
> report all mapped pages as dirty.

Again this denies userspace a policy choice. Why do dirty tracking
gyrations if they don't work? Just directly suspend the devices and
then copy.

> > I'm surprised it doesn't check that only NO_IOMMU's devices are
> > attached to the container and refuse to dirty track otherwise - since
> > it doesn't work..
> 
> No-IOMMU doesn't use type1, the ioctl returns errno.

Sorry, I mistyped that, I ment emulated iommu, as HCH has called it:

vfio_register_emulated_iommu_dev()

> > When we mix dirty track with pre-copy, the progression seems to be:
> > 
> >   DITRY TRACKING | RUNNING
> >      Copy every page to the remote
> >   DT | SAVING | RUNNING
> >      Copy pre-copy migration data to the remote
> >   SAVING | NDMA | RUNNING
> >      Read and clear dirty track device bitmap
> >   DT | SAVING | RUNNING
> >      Copy new dirtied data
> >      (maybe loop back to NDMA a few times?)
> >   SAVING | NDMA | RUNNING
> >      P2P grace state
> >   0
> >     Read the dirty track and copy data
> >     Read and send the migration state
> > 
> > Can we do something so complex using only SAVING?
> 
> I'm not demanding that triggering device dirty tracking on saving is
> how this must be done, I'm only stating that's an idea that was
> discussed.  If we need more complicated triggers between the IOMMU and
> device, let's define those, but I don't see that doing so negates the
> benefits of aggregated dirty bitmaps in the IOMMU context.

Okay. As far as your request to document things as we seem them
upcoming I belive we should have some idea how dirty tracking control
fits in. I agree that is not related to how the bitmap is reported. We
will continue to think about dirty tracking as not connected to
SAVING.

> > This creates inefficiencies in the kernel, we copy from the mlx5
> > formed data structure to new memory in the iommu through a very
> > ineffficent API and then again we do an ioctl to copy it once more and
> > throw all the extra work away. It does not seem good for something
> > where we want performance.
> 
> So maybe the dirty bitmaps for the IOMMU context need to be exposed to
> and directly modifiable by the drivers using atomic bitmap ops.  Maybe
> those same bitmaps can be mmap'd to userspace.  These bitmaps are not
> insignificant, do we want every driver managing their own copies?

If we look at mlx5 for example there is no choice. The dirty log is in
some device specific format and is not sharable. We must allocate
memory to work with it.

What I don't need is the bitmap memory in the iommu container, that is
all useless for mlx5.

So, down this path we need some API for the iommu context to not
allocate its memory at all and refer to storage from the tracking
provider for cases where that makes sense.

> > Userspace has to do this anyhow if it has configurations with multiple
> > containers. For instance because it was forced to split the containers
> > due to one device not supporting NDMA.
> 
> Huh?  When did that become a requirement?  

It is not a requirement, it is something userspace can do, if it
wants. And we talked about this, if NDMA isn't supported the P2P can't
work, and a way to enforce that is to not include P2P in the IOMMU
mapping. Except if you have an asymmetric NDMA you may want an
asymmetric IOMMU mapping too where the NDMA devices can do P2P and the
others don't. That is two containers and two dirty bitmaps.

Who knows, it isn't the job of the kernel to make these choices, the
kernel just provides tools.

> I feel like there are a lot of excuses listed here, but nothing that
> really demands a per device interface, 

"excuses" and "NIH" is a bit rude Alex.

From my side, you are asking for a lot work from us (who else?) to
define and implement a wack of missing kernel functionality.

I think it is very reasonable to ask what the return to the community
is for this work. "makes more sense to me" is not something that
is really compelling.

So, I'd rather you tell me concretely why doing this work, in this
way, is a good idea.

> > If the migration driver says it supports tracking, then it only tracks
> > DMA from that device.
> 
> I don't see what this buys us.  Userspace is only going to do a
> migration if all devices support the per device migration region.  At
> that point we need the best representation of the dirty bitmap we can
> provide per IOMMU context.  It makes sense to me to aggregate per
> device dirtying into that one context.

Again, there are policy choices userspace can make, like just
suspending the device that doesn't do dirty tracking and continuing to
dirty track the ones that do.

This might be very logical if a non-dirty tracking device is something
like IDXD that will just cause higher request latency and the dirty
tracking is mlx5 that will cause externally visable artifacts.

My point is *we don't know* what people will want.

I also think you are too focused on a one-size solution that fits into
a qemu sort of enteprise product. While I can agree with your position
relative to an enterprise style customer, NVIDIA has different
customers, many that have their own customized VMMs that are tuned for
their HW choices. For these customers I do like to see that the kernel
allows options, and I don't think it is appropriate to be so
dismissive of this perspective.

> > What I see is a lot of questions and limitations with this
> > approach. If we stick to funneling everything through the iommu then
> > answering the questions seem to create a large amount of kernel
> > work. Enough to ask if it is worthwhile..
> 
> If we need a common userspace IOMMU subsystem like IOMMUfd that can
> handle driver page pinning, IOMMU faults, and dirty tracking, why does
> it suddenly become an unbearable burden to allow other means besides
> page pinning for a driver to relay DMA page writes?

I can see some concrete reasons for iommufd, like it allows this code
to be shared between mutliple subsystems that need it. Its design
supports more functionality than the vfio container can.

Here, I don't quite see it. If userspace does

  for (i = 0; i != num_trackers; i++)
     ioctl(merge dirty bitmap, i, &bitmap)

Or
   ioctl(read diry bitmap, &bitmap)

Hardly seems decisive. What bothers me is the overhead and kernel
complexity.

If we split them it looks quite simple:
 - new ioctl on vfio device to read & clear dirty bitmap
    & extension flag to show this is supported
 - DIRTY_TRACK migration state bit to start/stop
   Simple logic that read is only possible in NDMA/!RUNNING
 - new ioctl on vfio device to report dirty tracking capability flags:
    - internal dirty track supported
    - real dirty track through attached container supported
      (only mdev can set this today)

Scenarios:

a. If userspace has a mlx5 and a mdev then it does a for loop as above to
   start and read the dirty bitmaps.

b. If userspace has only mlx5 it reads one bitmap

c. If userspace has mlx5 and some other PCI device it can activate
   mlx5 and leave the container alone. Suspend the PCI device early.
   Or directly give up on dirty track

For funneling through the container ioctls.. Humm:
 - Still track per device/container connection if internal/external
   dirty track is supported. Add an new ioctl so userspace can have
   this info for (c)
 - For external dirty track have some ops callbacks for start/stop,
   read bitmap and clear. (So, no migration state flag?)
 - On start make the policy choice if the external/internal will be
   used, then negotiate some uniform tracking size and iterate over
   all externals to call start
 - On read.. to avoid overheads iterate over the internal bitmap
   and read ops on all external bitmaps and or them together
   then copy to user. Just ignore NDMA and rely on userspace to
   do it right?
 - Clear iterates and zeros bitmaps
 - Change logic to not allocate tracking bitmaps if no mdevs

a. works the same, kernel turns on both trackers
b. works the same, kernel turns on only mlx5
c. Hum. We have to disable the 'no tracker report everything as
   dirty' feature somehow so we can access only the mlx5 tracker
   without forcing evey page seen as dirty. Needs a details

And figure out how this relates to the ongoing iommufd project (which,
BTW, we have now invested a lot in too).

I'm not as convinced as you are that the 2nd is obviously better, and
on principle I don't like avoidable policy choices baked in the
kernel.

And I don't see that it makes userspace really much simpler anyhow. On
the other hand it looks like a lot more kernel work..

> OTOH, aggregating these features in the IOMMU reduces both overhead
> of per device bitmaps and user operations to create their own
> consolidated view.

I don't understand this, funneling will not reduce overhead, at best
with some work we can almost break even by not allocating the SW
bitmaps.

Jason
