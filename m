Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FCC453B7D
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 22:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbhKPVNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 16:13:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27774 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229899AbhKPVNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 16:13:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637097036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=96lDap4247SDXpoDuNta31WDWX7qKzwpD/6F6PzBxSE=;
        b=SQP65c3sn/PKHho2tlJ6wrDubkNXfKWXF8mhqp11Z664o1VCgMleq5R4vcsRxF+CXLHwHA
        anH7JNNRzRDW8HGjYC2V8FMbfIGjlrj04vNQdmFWojoruGTa+nfxtSYnNXhSl/SibBoPvM
        k6x3xW2j+TQ4rZlkgWxnF55bBxUG5QQ=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-M9Ho3I77MNSpT7Kes-jiCw-1; Tue, 16 Nov 2021 16:10:35 -0500
X-MC-Unique: M9Ho3I77MNSpT7Kes-jiCw-1
Received: by mail-oo1-f72.google.com with SMTP id x23-20020a4ad057000000b002b7e3782496so284311oor.7
        for <netdev@vger.kernel.org>; Tue, 16 Nov 2021 13:10:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=96lDap4247SDXpoDuNta31WDWX7qKzwpD/6F6PzBxSE=;
        b=5EVCG4MKkKlJbhMgFMHqrHm9BFSzZtvNwlf1YxnjZkp0Qs4oIl+x7JHEE9j6DJYe6C
         VczlvktFRt8e8R6dQHazmQfg4NbynQR5wHY872VmjD2TidHGj08FEHg6ObG92iArjy62
         hc2BBzwauVR5/Zf7b4qxSzR4U2GbJM2fVzpWBqW5BqTY7b6xcL5JPaICtbZ3nWyBBsjB
         ctICPj2hvjg8TL5MD4mOY2hwgI+VXX8AUjWwcCZygtaN0/wNepTLzatMEeLnbmhLtmud
         II+BA9Qanet36zM6u3EZvREDqAYHeRumWNOFLvx0LpatZZ4/UkqqhMbHUGmaZ7uSZadF
         NZmg==
X-Gm-Message-State: AOAM533UHsI/4n4bMbl8YLbi3fa2pAnYUnzO2/rv2USZOfmRs+Jf17fs
        qBaHupcMDJpRBgyiHs7N0+S6sTl8l9EozaOqwIp1YM2DaoZjPpVrDVgER1l3bInxPDSJ7zPFLND
        7XjbHfo411msperaI
X-Received: by 2002:a05:6808:168a:: with SMTP id bb10mr57009445oib.99.1637097034206;
        Tue, 16 Nov 2021 13:10:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwH46xZjwsMx3sGxBYnqkDaoXgV1sp/vrc9SExLuNj/nZrz9s+ZcoiikJh8Hvu0OZhws8rkXg==
X-Received: by 2002:a05:6808:168a:: with SMTP id bb10mr57009400oib.99.1637097033810;
        Tue, 16 Nov 2021 13:10:33 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id 3sm4143579oif.12.2021.11.16.13.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 13:10:33 -0800 (PST)
Date:   Tue, 16 Nov 2021 14:10:31 -0700
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
Message-ID: <20211116141031.443e8936.alex.williamson@redhat.com>
In-Reply-To: <20211116192505.GB2105516@nvidia.com>
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
        <20211116192505.GB2105516@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Nov 2021 15:25:05 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Nov 16, 2021 at 10:57:36AM -0700, Alex Williamson wrote:
> 
> > > I think userspace should decide if it wants to use mlx5 built in or
> > > the system IOMMU to do dirty tracking.  
> > 
> > What information does userspace use to inform such a decision?  
> 
> Kernel can't know which approach performs better. Operators should
> benchmark and make a choice for their deployment HW. Maybe device
> tracking severely impacts device performance or vice versa.

I'm all for keeping policy decisions out of the kernel, but it's pretty
absurd to expect a userspace operator to benchmark various combination
and wire various knobs through the user interface for this.  It seems
to me that the kernel, ie. the vfio variant driver, *can* know the best
default.  We can design in interfaces so that the driver may, for
example, know whether to pin pages or defer to the system IOMMU dirty
tracking.  The driver provider can provide quirks for IOMMU
implementations that perform poorly versus device provided
alternatives.  The driver can know if a device iotlb cache provides the
better result.  The driver can provide module options or devlink tweaks
to change the behavior.  This seems like something userspace doesn't
want to care about in the common path.

> Kernel doesn't easily know what userspace has done, maybe one device
> supports migration driver dirty tracking and one device does not.

And that's exactly why the current type1 implementation exposes the
least common denominator to userspace, ie. pinned pages only if all
devices in the container have enabled this degree of granularity.

> Is user space going to use a system IOMMU for both devices? 

If the system IOMMU supports it and none of the drivers have opt'd to
report via other means, yes.

> Is it going to put the simple device in NDMA early and continue to
> dirty track to shutdown the other devices?

Yes, the current model could account for this, the device entering NDMA
mode effectively becomes enlightened because it knows that it is no
longer dirtying pages.  It'd be the same as a driver turning on page
pinning with _SAVING, we'd just need a way to do that without actually
pinning a page.

> > Ultimately userspace just wants the finest granularity of tracking,
> > shouldn't that guide our decisions which to provide?  
> 
> At least for mlx5 there is going to some trade off curve of device
> performance, dirty tracking page size, and working set.
> 
> Even lower is better is not necessarily true. After overheads on a
> 400GB RDMA NIC there is not such a big difference between doing a 4k
> and 16k scatter transfer. The CPU work to process all the extra bitmap
> data may not be a net win compared to block transfer times.
> 
> Conversly someone doing 1G TCP transfers probably cares a lot to
> minimize block size.
> 
> Overall, I think there is far too much up in the air and unmeasured to
> firmly commit the kernel to a fixed policy.
> 
> So, I would like to see userspace control most of the policy aspects,
> including the dirty track provider.

This sounds like device specific migration parameter tuning via a
devlink interface to me, tbh.  How would you propose a generic
vfio/iommufd interface to tune this sort of thing?

> > I believe the intended progression of dirty tracking is that by default
> > all mapped ranges are dirty.  If the device supports page pinning, then
> > we reduce the set of dirty pages to those pages which are pinned.  A
> > device that doesn't otherwise need page pinning, such as a fully IOMMU  
> 
> How does userspace know if dirty tracking works or not? All I see
> VFIO_IOMMU_DIRTY_PAGES_FLAG_START unconditionally allocs some bitmaps.

IIRC, it's always supported by type1.  In the worst case we always
report all mapped pages as dirty.

> I'm surprised it doesn't check that only NO_IOMMU's devices are
> attached to the container and refuse to dirty track otherwise - since
> it doesn't work..

No-IOMMU doesn't use type1, the ioctl returns errno.

> > backed device, would use gratuitous page pinning triggered by the
> > _SAVING state activation on the device.  It sounds like mlx5 could use
> > this existing support today.  
> 
> How does mlx5 know if it should turn on its dirty page tracking on
> SAVING or if the system IOMMU covers it? Or for some reason userspace
> doesn't want dirty tracking but is doing pre-copy?

Likely there'd be some sort of IOMMU property the driver could check,
type1 would need to figure out the same.  The type1/iommufd interfaces
to the driver could evolve so that the driver can know if DMA dirty
tracking is enabled by the user.

> When we mix dirty track with pre-copy, the progression seems to be:
> 
>   DITRY TRACKING | RUNNING
>      Copy every page to the remote
>   DT | SAVING | RUNNING
>      Copy pre-copy migration data to the remote
>   SAVING | NDMA | RUNNING
>      Read and clear dirty track device bitmap
>   DT | SAVING | RUNNING
>      Copy new dirtied data
>      (maybe loop back to NDMA a few times?)
>   SAVING | NDMA | RUNNING
>      P2P grace state
>   0
>     Read the dirty track and copy data
>     Read and send the migration state
> 
> Can we do something so complex using only SAVING?

I'm not demanding that triggering device dirty tracking on saving is
how this must be done, I'm only stating that's an idea that was
discussed.  If we need more complicated triggers between the IOMMU and
device, let's define those, but I don't see that doing so negates the
benefits of aggregated dirty bitmaps in the IOMMU context.

> .. and along the lines of the above how do we mix in NDMA to the iommu
> container, and how does it work if only some devices support NDMA?

As above, turning on NDMA effectively enlightens the device, we'd need
a counter interface to de-enlighten, the IOMMU dirty context
dynamically works at the least common denominator at the time.

> > We had also discussed variants to page pinning that might be more
> > useful as device dirty page support improves.  For example calls to
> > mark pages dirty once rather than the perpetual dirtying of pinned
> > pages, calls to pin pages for read vs write, etc.  We didn't dive much
> > into system IOMMU dirtying, but presumably we'd have a fault handler
> > triggered if a page is written by the device and go from there.  
> 
> Would be interesting to know for sure what current IOMMU HW has
> done. I'm supposing the easiest implementation is to write a dirty bit
> to the IO PTE the same as the CPU writes a dirty bit the normal PTE.
> 
> > > In light of all this I'm wondering if device dirty tracking should
> > > exist as new ioctls on the device FD and reserve the type1 code to
> > > only work the IOMMU dirty tracking.  
> > 
> > Our existing model is working towards the IOMMU, ie. container,
> > interface aggregating dirty page context.    
> 
> This creates inefficiencies in the kernel, we copy from the mlx5
> formed data structure to new memory in the iommu through a very
> ineffficent API and then again we do an ioctl to copy it once more and
> throw all the extra work away. It does not seem good for something
> where we want performance.

So maybe the dirty bitmaps for the IOMMU context need to be exposed to
and directly modifiable by the drivers using atomic bitmap ops.  Maybe
those same bitmaps can be mmap'd to userspace.  These bitmaps are not
insignificant, do we want every driver managing their own copies?

> > For example when page pinning is used, it's only when all devices
> > within the container are using page pinning that we can report the
> > pinned subset as dirty.  Otherwise userspace needs to poll each
> > device, which I suppose enables your idea that userspace decides
> > which source to use, but why?  
> 
> Efficiency, and user selectable policy.
> 
> Userspace can just allocate an all zeros bitmap and feed it to each of
> the providers in the kernel using a 'or in your dirty' semantic.
> 
> No redundant kernel data marshaling, userspace gets to decide which
> tracking provider to use, and it is simple to implement in the kernel.
> 
> Userspace has to do this anyhow if it has configurations with multiple
> containers. For instance because it was forced to split the containers
> due to one device not supporting NDMA.

Huh?  When did that become a requirement?  I feel like there are a lot
of excuses listed here, but nothing that really demands a per device
interface, or at least a per device interface that we have any hope of
specifying.  Shared infrastructure in the IOMMU allows both kernel-side
and userspace-side consolidation of these bitmaps.  It's pretty clear
that our current interfaces are rudimentary, but we've got to start
somewhere.
 
> > Does the IOMMU dirty page tracking exclude devices if the user
> > queries the device separately?    
> 
> What makes sense to me is multiple tracking providers. Each can be
> turned on and off.
> 
> If the container tracking provider says it supports tracking then it
> means it can track DMA from every device it is connected to (unlike
> today?). eg by using IOMMU HW that naturally does this, or by only
> having only NO_IOMMU devices.

Let's kick No-IOMMU out of this conversation, it doesn't claim to have
any of these features, it never will.  Type1 can always provide dirty
tracking with the default being to mark all mapped pages perpetually
dirty.  It doesn't make much sense for userspace to get a concise dirty
bitmap from one device and a full dirty bitmap from another.  We've
optimized that userspace gets the least common denominator for the
entire IOMMU context.

> If the migration driver says it supports tracking, then it only tracks
> DMA from that device.

I don't see what this buys us.  Userspace is only going to do a
migration if all devices support the per device migration region.  At
that point we need the best representation of the dirty bitmap we can
provide per IOMMU context.  It makes sense to me to aggregate per
device dirtying into that one context.

> > How would it know?  What's the advantage?  It seems like this
> > creates too many support paths that all need to converge on the same
> > answer.  Consolidating DMA dirty page tracking to the DMA mapping
> > interface for all devices within a DMA context makes more sense to
> > me.  
> 
> What I see is a lot of questions and limitations with this
> approach. If we stick to funneling everything through the iommu then
> answering the questions seem to create a large amount of kernel
> work. Enough to ask if it is worthwhile..

If we need a common userspace IOMMU subsystem like IOMMUfd that can
handle driver page pinning, IOMMU faults, and dirty tracking, why does
it suddenly become an unbearable burden to allow other means besides
page pinning for a driver to relay DMA page writes?  OTOH, aggregating
these features in the IOMMU reduces both overhead of per device bitmaps
and user operations to create their own consolidated view.

> .. and then we have to ask how does this all work in IOMMUFD where it
> is not so reasonable to tightly couple the migration driver and the
> IOAS and I get more questions :)

To me, the per device option seems pretty ad-hoc, cumbersome and
complicated for userspace, and invents problems with the aggregated
bitmap that either don't really exist (imo) or where interfaces could be
refined.  Maybe start with what uAPI visible knobs really make sense
and provide a benefit for per-device dirty bitmap tuning and how a
device agnostic userspace like QEMU is going to make intelligent
decisions about those knobs.  Otherwise I see the knobs as out-of-band
and most of the other arguments tending towards NIH.  Thanks,

Alex

