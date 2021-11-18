Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92890456227
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 19:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbhKRSTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 13:19:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42927 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231194AbhKRSTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 13:19:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637259360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1BMm9rGzrrD8XaEqAqT2sIlHRe5EeHJl8zPYp/Wh2BQ=;
        b=U4YYKUmM+WJhjwjeEvEfQjbRtAHDV9Ra/z5g5g7U//kNlU3/T0YehFmtbpdFcoBUlFR1gS
        GKTZFf2OokBFKh+oq4mymECNxjnOYcV2Pp0CzlKzbzVnEcEcaWf5KnUGByg5UEUg0D4olu
        m5kXs02dm3X9xBWcgjYuMkygZtx3xQM=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-3K6RqAUxPg2JgD0GUHWjhw-1; Thu, 18 Nov 2021 13:15:59 -0500
X-MC-Unique: 3K6RqAUxPg2JgD0GUHWjhw-1
Received: by mail-oi1-f198.google.com with SMTP id bi9-20020a056808188900b002bc4f64083aso4925274oib.7
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 10:15:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1BMm9rGzrrD8XaEqAqT2sIlHRe5EeHJl8zPYp/Wh2BQ=;
        b=QU8242MZs7TpO/qRLGIMsNEdfxCp9pRTwvlBQnhdzP4QQBbM6HfXSbn4L6hHZn7Jjp
         D8aTrhiGyKAIE8NXXdUVOAM7A1wTHl08J+lGLvuLmre/NJqt1bAQibzJB6Po9hl2pa01
         NdfdiXgApwwS0KauFOC2A1YpkVGbAWLIihVcO9iQzBBp6gCAtINzVRP972ohCbD3lI6d
         SgPV0e8aE73GUYFX519hMdwSmFtO9gEBemU7Y14nRVSPZX6+i6HjnvEhds3chNFH6Od6
         4fKp8d0H7wim2DSOsNL730oS+K4uNhAXHiJDnQNosHKsHn1GB4Ms1PI2yKfz4wh6H3F5
         EYNA==
X-Gm-Message-State: AOAM531M8AqKNiJpFbM7jzW/JhYIwVSzSsbYzlhWGLd99q1wPEvhSe11
        +OM5TgOQquZhXuN0+mUGpUDk5iPBtLqKg1yqzaAI3kfsYwL4IcfChP6Fv88dZ4+j6vW9ue78RrG
        +efI7J3VDWhqB3lyL
X-Received: by 2002:a05:6808:20a6:: with SMTP id s38mr9945450oiw.152.1637259358046;
        Thu, 18 Nov 2021 10:15:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzU2oAPsg+DvG5pXa4tS6amTbtgCoStSO75SHuiNY+kb5GgDJg4+guOVlw+70OiiAh+GsWDxA==
X-Received: by 2002:a05:6808:20a6:: with SMTP id s38mr9945366oiw.152.1637259357361;
        Thu, 18 Nov 2021 10:15:57 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id r26sm104747otn.15.2021.11.18.10.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:15:57 -0800 (PST)
Date:   Thu, 18 Nov 2021 11:15:55 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211118111555.18dd7d4f.alex.williamson@redhat.com>
In-Reply-To: <20211117014831.GH2105516@nvidia.com>
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
 <20211117014831.GH2105516@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Nov 2021 21:48:31 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Nov 16, 2021 at 02:10:31PM -0700, Alex Williamson wrote:
> > On Tue, 16 Nov 2021 15:25:05 -0400
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Tue, Nov 16, 2021 at 10:57:36AM -0700, Alex Williamson wrote:
> > >   
> > > > > I think userspace should decide if it wants to use mlx5 built in or
> > > > > the system IOMMU to do dirty tracking.    
> > > > 
> > > > What information does userspace use to inform such a decision?    
> > > 
> > > Kernel can't know which approach performs better. Operators should
> > > benchmark and make a choice for their deployment HW. Maybe device
> > > tracking severely impacts device performance or vice versa.  
> > 
> > I'm all for keeping policy decisions out of the kernel, but it's pretty
> > absurd to expect a userspace operator to benchmark various combination
> > and wire various knobs through the user interface for this.   
> 
> Huh? This is the standard operating procedure in netdev land, mm and
> others. Max performance requires tunables. And here we really do care
> alot about migration time. I've seen the mm complexity supporting the
> normal vCPU migration to know this is a high priority for many people.

Per previous reply:

"Maybe start with what uAPI visible knobs really make sense
and provide a benefit for per-device dirty bitmap tuning and how a
device agnostic userspace like QEMU is going to make intelligent
decisions about those knobs."

> > It seems to me that the kernel, ie. the vfio variant driver, *can*
> > know the best default.    
> 
> If the kernel can have an algorithm to find the best default then qemu
> can implement the same algorithm too. I'm also skeptical about this
> claim the best is knowable.

QEMU is device agnostic and has no visibility to the system IOMMU
capabilities.
 
> > > Kernel doesn't easily know what userspace has done, maybe one device
> > > supports migration driver dirty tracking and one device does not.  
> > 
> > And that's exactly why the current type1 implementation exposes the
> > least common denominator to userspace, ie. pinned pages only if all
> > devices in the container have enabled this degree of granularity.  
> 
> The current implementation forces no dirty tracking. That is a policy
> choice that denies userspace the option to run one device with dirty
> track and simply suspend the other.

"Forces no dirty tracking"?  I think you're suggesting that if a device
within an IOMMU context doesn't support dirty tracking that we're
forced to always report all mappings within that context as dirty,
because for some reason we're not allowed to evolve how devices can
interact with a shared dirty context, but we are allowed to invent a new
per-device uAPI?

> > > So, I would like to see userspace control most of the policy aspects,
> > > including the dirty track provider.  
> > 
> > This sounds like device specific migration parameter tuning via a
> > devlink interface to me, tbh.  How would you propose a generic
> > vfio/iommufd interface to tune this sort of thing?  
> 
> As I said, if each page track provider has its own interface it is
> straightforward to make policy in userspace. The only tunable beyond
> that is the dirty page tracking granularity. That is already
> provided by userspace, but not as an parameter during START.
> 
> I don't see why we'd need something as complicated as devlink just
> yet.

The approaches aren't that different.  It seems like you want userspace
to be able to select which devices to get dirty page info from while
I'm suggesting that we can develop ways that the user can manage how
the device interacts with a shared dirty page state.  Per-device dirty
page state doesn't preclude a shared dirty state, we still expect that
any IOMMU interface is the source of truth when we have multiple
devices sharing an IOMMU context.

What if we have a scenario where devices optionally have per device
dirty page tracking.

A) mlx5 w/ device level dirty page tracking, vGPU w/ page pinning

vs

B) mlx5 w/ device level dirty page tracking, NIC with system IOMMU
   dirty page tracking

Compare and contrast in which case the shared IOMMU context dirty page
tracking reports both device's versus only the devices without
per-device tracking.  Is this obvious to both userspace and the shared
dirty page tracking if it's the same or different in both cases?

> > > How does userspace know if dirty tracking works or not? All I see
> > > VFIO_IOMMU_DIRTY_PAGES_FLAG_START unconditionally allocs some bitmaps.  
> > 
> > IIRC, it's always supported by type1.  In the worst case we always
> > report all mapped pages as dirty.  
> 
> Again this denies userspace a policy choice. Why do dirty tracking
> gyrations if they don't work? Just directly suspend the devices and
> then copy.

As above, it seems like you're freezing one interface and allowing the
other to evolve.  We can create ways that a device without dirty
tracking can be marked as not generating DMA within a shared dirty page
context.

If maybe what you're really trying to get at all along is visibility to
the per-device dirty page contribution, that does sound interesting.
But I also don't know how that interacts with system IOMMU based
reporting.  Does the IOMMU report to the driver that reports to
userspace the per-device dirty pages?

> > > I'm surprised it doesn't check that only NO_IOMMU's devices are
> > > attached to the container and refuse to dirty track otherwise - since
> > > it doesn't work..  
> > 
> > No-IOMMU doesn't use type1, the ioctl returns errno.  
> 
> Sorry, I mistyped that, I ment emulated iommu, as HCH has called it:
> 
> vfio_register_emulated_iommu_dev()

Ok, so that's essentially the vfio IOMMU driver just keeping track of
userspace mappings in order to provide page pinning, where a device
supporting page pinning is our first step in more fine grained dirty
tracking.  Type1 keeps track of pages pinned across all devices sharing
the IOMMU container, thus we have container based dirty page reporting.
 
> > > When we mix dirty track with pre-copy, the progression seems to be:
> > > 
> > >   DITRY TRACKING | RUNNING
> > >      Copy every page to the remote
> > >   DT | SAVING | RUNNING
> > >      Copy pre-copy migration data to the remote
> > >   SAVING | NDMA | RUNNING
> > >      Read and clear dirty track device bitmap
> > >   DT | SAVING | RUNNING
> > >      Copy new dirtied data
> > >      (maybe loop back to NDMA a few times?)
> > >   SAVING | NDMA | RUNNING
> > >      P2P grace state
> > >   0
> > >     Read the dirty track and copy data
> > >     Read and send the migration state
> > > 
> > > Can we do something so complex using only SAVING?  
> > 
> > I'm not demanding that triggering device dirty tracking on saving is
> > how this must be done, I'm only stating that's an idea that was
> > discussed.  If we need more complicated triggers between the IOMMU and
> > device, let's define those, but I don't see that doing so negates the
> > benefits of aggregated dirty bitmaps in the IOMMU context.  
> 
> Okay. As far as your request to document things as we seem them
> upcoming I belive we should have some idea how dirty tracking control
> fits in. I agree that is not related to how the bitmap is reported. We
> will continue to think about dirty tracking as not connected to
> SAVING.

Ok.
 
> > > This creates inefficiencies in the kernel, we copy from the mlx5
> > > formed data structure to new memory in the iommu through a very
> > > ineffficent API and then again we do an ioctl to copy it once more and
> > > throw all the extra work away. It does not seem good for something
> > > where we want performance.  
> > 
> > So maybe the dirty bitmaps for the IOMMU context need to be exposed to
> > and directly modifiable by the drivers using atomic bitmap ops.  Maybe
> > those same bitmaps can be mmap'd to userspace.  These bitmaps are not
> > insignificant, do we want every driver managing their own copies?  
> 
> If we look at mlx5 for example there is no choice. The dirty log is in
> some device specific format and is not sharable. We must allocate
> memory to work with it.
> 
> What I don't need is the bitmap memory in the iommu container, that is
> all useless for mlx5.
> 
> So, down this path we need some API for the iommu context to not
> allocate its memory at all and refer to storage from the tracking
> provider for cases where that makes sense.

That depends whether there are other devices in the context and if the
container dirty context is meant to include all devices or if the
driver is opt'ing out of the shared tracking... if that's a thing.
Alternatively, drivers could register callbacks to report their dirty
pages into the shared tracking for ranges requested by the user.  We
need to figure out how per-device tracking an system IOMMU tracking get
along if that's where we're headed.
 
> > > Userspace has to do this anyhow if it has configurations with multiple
> > > containers. For instance because it was forced to split the containers
> > > due to one device not supporting NDMA.  
> > 
> > Huh?  When did that become a requirement?    
> 
> It is not a requirement, it is something userspace can do, if it
> wants. And we talked about this, if NDMA isn't supported the P2P can't
> work, and a way to enforce that is to not include P2P in the IOMMU
> mapping. Except if you have an asymmetric NDMA you may want an
> asymmetric IOMMU mapping too where the NDMA devices can do P2P and the
> others don't. That is two containers and two dirty bitmaps.

I'm not sure how I was supposed to infer that use case from "...forced
to split the containers due to one device not support NDMA".  That's
certainly an option, but not a requirement.  In fact, if QEMU were to
do something like that, then we have some devices that can do p2p and
some devices that cannot... all or none seems like a much more
deterministic choice for QEMU.  How do guest drivers currently test p2p?
 
> Who knows, it isn't the job of the kernel to make these choices, the
> kernel just provides tools.

Agreed, but I don't see that userspace choosing to use separate
contexts either negates the value of the kernel aggregating dirty pages
within a container or clearly makes the case for per-device dirty pages.

> > I feel like there are a lot of excuses listed here, but nothing that
> > really demands a per device interface,   
> 
> "excuses" and "NIH" is a bit rude Alex.
> 
> From my side, you are asking for a lot work from us (who else?) to
> define and implement a wack of missing kernel functionality.
> 
> I think it is very reasonable to ask what the return to the community
> is for this work. "makes more sense to me" is not something that
> is really compelling.
> 
> So, I'd rather you tell me concretely why doing this work, in this
> way, is a good idea.

On my end, we have a defined dirty page tracking interface at the IOMMU
context with some, admittedly rough, plans on how we intend to evolve
that interface for both device level and IOMMU level tracking feeding
into a shared dirty page interfaces.  The example scenarios presented
mostly seem to have solutions within that design framework if we put a
little effort into it.  There are unanswered questions down either
path, but one of those paths is the path we previously chose.  The
greater burden is to switch paths, so rather I need to understand why
this is the better path, with due diligence to explore what the same
looks like with the current design.

It's only finally here in the thread that we're seeing some of the mlx5
implementation details that might favor a per-device solution, hints
that per device page granularity might be useful, and maybe that
exposing per-device dirty page footprints to userspace is underlying
this change of course.

> > > If the migration driver says it supports tracking, then it only tracks
> > > DMA from that device.  
> > 
> > I don't see what this buys us.  Userspace is only going to do a
> > migration if all devices support the per device migration region.  At
> > that point we need the best representation of the dirty bitmap we can
> > provide per IOMMU context.  It makes sense to me to aggregate per
> > device dirtying into that one context.  
> 
> Again, there are policy choices userspace can make, like just
> suspending the device that doesn't do dirty tracking and continuing to
> dirty track the ones that do.
> 
> This might be very logical if a non-dirty tracking device is something
> like IDXD that will just cause higher request latency and the dirty
> tracking is mlx5 that will cause externally visable artifacts.
> 
> My point is *we don't know* what people will want.
> 
> I also think you are too focused on a one-size solution that fits into
> a qemu sort of enteprise product. While I can agree with your position
> relative to an enterprise style customer, NVIDIA has different
> customers, many that have their own customized VMMs that are tuned for
> their HW choices. For these customers I do like to see that the kernel
> allows options, and I don't think it is appropriate to be so
> dismissive of this perspective.

So provide the justification I asked for previously and quoted above,
what are the things we want to be able to tune that cannot be done
through reasonable extensions of the current design?  I'm not trying to
be dismissive, I'm lacking facts and evidence of due diligence that the
current design is incapable of meeting our goals.
 
> > > What I see is a lot of questions and limitations with this
> > > approach. If we stick to funneling everything through the iommu then
> > > answering the questions seem to create a large amount of kernel
> > > work. Enough to ask if it is worthwhile..  
> > 
> > If we need a common userspace IOMMU subsystem like IOMMUfd that can
> > handle driver page pinning, IOMMU faults, and dirty tracking, why does
> > it suddenly become an unbearable burden to allow other means besides
> > page pinning for a driver to relay DMA page writes?  
> 
> I can see some concrete reasons for iommufd, like it allows this code
> to be shared between mutliple subsystems that need it. Its design
> supports more functionality than the vfio container can.
> 
> Here, I don't quite see it. If userspace does
> 
>   for (i = 0; i != num_trackers; i++)
>      ioctl(merge dirty bitmap, i, &bitmap)
> 
> Or
>    ioctl(read diry bitmap, &bitmap)
> 
> Hardly seems decisive.

On the same order as "makes more sense to me" ;)

> What bothers me is the overhead and kernel
> complexity.
> 
> If we split them it looks quite simple:
>  - new ioctl on vfio device to read & clear dirty bitmap
>     & extension flag to show this is supported
>  - DIRTY_TRACK migration state bit to start/stop

Is this another device_state bit?

>    Simple logic that read is only possible in NDMA/!RUNNING
>  - new ioctl on vfio device to report dirty tracking capability flags:
>     - internal dirty track supported
>     - real dirty track through attached container supported
>       (only mdev can set this today)

How does system IOMMU dirty tracking work?
 
> Scenarios:
> 
> a. If userspace has a mlx5 and a mdev then it does a for loop as above to
>    start and read the dirty bitmaps.
> 
> b. If userspace has only mlx5 it reads one bitmap
> 
> c. If userspace has mlx5 and some other PCI device it can activate
>    mlx5 and leave the container alone. Suspend the PCI device early.
>    Or directly give up on dirty track
> 
> For funneling through the container ioctls.. Humm:
>  - Still track per device/container connection if internal/external
>    dirty track is supported. Add an new ioctl so userspace can have
>    this info for (c)
>  - For external dirty track have some ops callbacks for start/stop,
>    read bitmap and clear. (So, no migration state flag?)
>  - On start make the policy choice if the external/internal will be
>    used, then negotiate some uniform tracking size and iterate over
>    all externals to call start
>  - On read.. to avoid overheads iterate over the internal bitmap
>    and read ops on all external bitmaps and or them together
>    then copy to user. Just ignore NDMA and rely on userspace to
>    do it right?
>  - Clear iterates and zeros bitmaps
>  - Change logic to not allocate tracking bitmaps if no mdevs

I don't understand what's being described here, I'm glad an attempt is
being made to see what this might look like with the current interface,
but at the same time the outline seems biased towards a complicated
portrayal.

It's a relatively simple progression, with no outside information the
container exposes all mapped pages as dirty.  Individual devices in the
container can expose themselves as enlightened in various ways,
initially we mark devices that pin pages as enlightened and when all
devices in the container are enlightened we can reduce the reported
bitmap.  As devices add their own dirty tracking we can add interfaces
to allow devices to register their status, mark dirty pages, and
potentially poll devices to update their dirty pages against ranges
requested by the user.  A device that's suspended, for example in PCI
D3 state, might mark itself as becoming enlightened and report no page
dirtying, a device ioctl might allow a more explicit instruction for
the same.  As IOMMU dirty page tracking comes online, the IOMMU can
essentially enlighten all the devices attached to the context.
 
> a. works the same, kernel turns on both trackers
> b. works the same, kernel turns on only mlx5
> c. Hum. We have to disable the 'no tracker report everything as
>    dirty' feature somehow so we can access only the mlx5 tracker
>    without forcing evey page seen as dirty. Needs a details

Doesn't seem as complicated in my rendition.
 
> And figure out how this relates to the ongoing iommufd project (which,
> BTW, we have now invested a lot in too).
> 
> I'm not as convinced as you are that the 2nd is obviously better, and
> on principle I don't like avoidable policy choices baked in the
> kernel.

Userspace has the same degree of policy decision in my version, what's
missing from my version is userspace visibility to the per device dirty
footprint and the newly mentioned desire for per-device page granularity.
 
> And I don't see that it makes userspace really much simpler anyhow. On
> the other hand it looks like a lot more kernel work..

There's kernel work either way.

> > OTOH, aggregating these features in the IOMMU reduces both overhead
> > of per device bitmaps and user operations to create their own
> > consolidated view.  
> 
> I don't understand this, funneling will not reduce overhead, at best
> with some work we can almost break even by not allocating the SW
> bitmaps.

The moment we have more than one device that requires a bitmap, where
the device doesn't have the visibility of the extent of the bitmap, we
introduce both space and time overhead versus a shared bitmap that can
be pre-allocated.

What's being asked for here is a change from the current plan of
record, that entails work and justification, including tangible
benefits versus a fair exploration of how the same might work in the
current design.

Anyway, as Connie mentioned off-list, we're deep into a comment thread
that's becoming more and more tangential to the original patch, I'm not
sure how many relevant contributors are still following this, and it's
probably best to propose a change in course to dirty bitmap tracking in
a new thread.  Thanks,

Alex

