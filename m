Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7984430FA
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 15:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbhKBPAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 11:00:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33142 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234902AbhKBO7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 10:59:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635865015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rXNQNfiHB/PeLRGP+7hDt0wdDNq5SSU2T+fjB5p1Png=;
        b=FvpT7EMOtsB2wiPdILPFevnGy4q+TbqosSBoR/SvD3V8i04vm3SbNuyps0bpsb4ppJi1vr
        n37NkNtBW+yo1qxsojxouSKBon8OWuXuKTYmYnulMVNEsPZ+VItBlqIr+IJ4jxMDZqvbmB
        +cBTKWl+DQRyiNoK/fl+vQTIevuecjA=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-mnARhqzwN-K-S-0PrZ7RHw-1; Tue, 02 Nov 2021 10:56:54 -0400
X-MC-Unique: mnARhqzwN-K-S-0PrZ7RHw-1
Received: by mail-ot1-f69.google.com with SMTP id 93-20020a9d0866000000b00553d3cbf050so10535812oty.14
        for <netdev@vger.kernel.org>; Tue, 02 Nov 2021 07:56:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rXNQNfiHB/PeLRGP+7hDt0wdDNq5SSU2T+fjB5p1Png=;
        b=DdRk4GxJiwrAwjlGEcncR9V2sT6BdoZ/ZCIeamyB4R5GeZLQUIliIVcKc6N3RGtdIm
         QGrUEngoS1pjQuYGir6VZobZ4qoFTu/mJnKJU/TVWs8nQFne7fQ+rx+qu28WFB7t/1pZ
         j8eJZo6MsHtvcXSgIV/6PjTHocNAB5sNfjbJkdnMr7vbQ3VZhtSaSvSanUJBi1CZmc8v
         Lw4TB3uVW14s//vIkWlrNfvuLMBwLemHBnjEFMz1+w/UXKOmJuVyCRhXAvaGU4FjE5MU
         OvJIZeE4xTa4Wt+eNfHmi7mtLIYG/SdzaCzCIF+0iJ6aFWq/8XSB3PlMNJz22RH/neRi
         aUlw==
X-Gm-Message-State: AOAM530OMYBlGP9SgApqtuddfFhFQY9RW1+I0BpfJrWtqHqN2art5+ct
        LlIJLIYQJcqAokvZHZR5KL3nFHjFLQ+fV6fjMFU3my7hfy8wiDlCua4XDyHJ83o52urpIjPeeyI
        x7n3fUzSG2gB3gBXb
X-Received: by 2002:a9d:2909:: with SMTP id d9mr16105612otb.187.1635865013960;
        Tue, 02 Nov 2021 07:56:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytw8wBjugPRoTH1oiXe4YvuMOLPdBjoz6aqSXNqQjkKkVHyT46/WIQqNFRBpB6ufxkPoDYvQ==
X-Received: by 2002:a9d:2909:: with SMTP id d9mr16105590otb.187.1635865013678;
        Tue, 02 Nov 2021 07:56:53 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id d24sm2423495otq.5.2021.11.02.07.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 07:56:53 -0700 (PDT)
Date:   Tue, 2 Nov 2021 08:56:51 -0600
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
Message-ID: <20211102085651.28e0203c.alex.williamson@redhat.com>
In-Reply-To: <20211101172506.GC2744544@nvidia.com>
References: <20211025145646.GX2744544@nvidia.com>
        <20211026084212.36b0142c.alex.williamson@redhat.com>
        <20211026151851.GW2744544@nvidia.com>
        <20211026135046.5190e103.alex.williamson@redhat.com>
        <20211026234300.GA2744544@nvidia.com>
        <20211027130520.33652a49.alex.williamson@redhat.com>
        <20211027192345.GJ2744544@nvidia.com>
        <20211028093035.17ecbc5d.alex.williamson@redhat.com>
        <20211028234750.GP2744544@nvidia.com>
        <20211029160621.46ca7b54.alex.williamson@redhat.com>
        <20211101172506.GC2744544@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Nov 2021 14:25:06 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Oct 29, 2021 at 04:06:21PM -0600, Alex Williamson wrote:
> 
> > > Right now we are focused on the non-P2P cases, which I think is a
> > > reasonable starting limitation.  
> > 
> > It's a reasonable starting point iff we know that we need to support
> > devices that cannot themselves support a quiescent state.  Otherwise it
> > would make sense to go back to work on the uAPI because I suspect the
> > implications to userspace are not going to be as simple as "oops, can't
> > migrate, there are two devices."  As you say, there's a universe of
> > devices that run together that don't care about p2p and QEMU will be
> > pressured to support migration of those configurations.  
> 
> I agree with this, but I also think what I saw in the proposed hns
> driver suggests it's HW cannot do quiescent, if so this is the first
> counter-example to the notion it is a universal ability?
> 
> hns people: Can you put your device in a state where it is operating,
> able to accept and respond to MMIO, and yet guarentees it generates no
> DMA transactions?
> 
> > want migration.  If we ever want both migration and p2p, QEMU would
> > need to reject any device that can't comply.  
> 
> Yes, it looks like a complicated task on the qemu side to get this
> resolved
> 
> > > It is not a big deal to defer things to rc1, though merging a
> > > leaf-driver that has been on-list over a month is certainly not
> > > rushing either.  
> > 
> > If "on-list over a month" is meant to imply that it's well vetted, it
> > does not.  That's a pretty quick time frame given the uAPI viability
> > discussions that it's generated.  
> 
> I only said rushed :)

To push forward regardless of unresolved questions is rushing
regardless of how long it's been on-list.

> > I'm tending to agree that there's value in moving forward, but there's
> > a lot we're defining here that's not in the uAPI, so I'd like to see
> > those things become formalized.  
> 
> Ok, lets come up with a documentation patch then to define !RUNNING as
> I outlined and start to come up with the allowed list of actions..
> 
> I think I would like to have a proper rst file for documenting the
> uapi as well.
> 
> > I think this version is defining that it's the user's responsibility to
> > prevent external DMA to devices while in the !_RUNNING state.  This
> > resolves the condition that we have no means to coordinate quiescing
> > multiple devices.  We shouldn't necessarily prescribe a single device
> > solution in the uAPI if the same can be equally achieved through
> > configuration of DMA mapping.  
> 
> I'm not sure what this means?

I'm just trying to avoid the uAPI calling out a single-device
restriction if there are other ways that userspace can quiesce external
DMA outside of the uAPI, such as by limiting p2p DMA mappings at the
IOMMU, ie. define the userspace requirements but don't dictate a
specific solution.

> > I was almost on board with blocking MMIO, especially as p2p is just DMA
> > mapping of MMIO, but what about MSI-X?  During _RESUME we must access
> > the MSI-X vector table via the SET_IRQS ioctl to configure interrupts.
> > Is this exempt because the access occurs in the host?    
> 
> s/in the host/in the kernel/ SET_IRQS is a kernel ioctl that uses the
> core MSIX code to do the mmio, so it would not be impacted by MMIO
> zap.

AIUI, "zap" is just the proposed userspace manifestation that the
device cannot accept MMIO writes while !_RUNNING, but these writes must
occur in that state.

> Looks like you've already marked these points with the
> vfio_pci_memory_lock_and_enable(), so a zap for migration would have
> to be a little different than a zap for reset.
> 
> Still, this is something that needs clear definition, I would expect
> the SET_IRQS to happen after resuming clears but before running sets
> to give maximum HW flexibility and symmetry with saving.

There's no requirement that the device enters a null state (!_RESUMING
| !_SAVING | !_RUNNING), the uAPI even species the flows as _RESUMING
transitioning to _RUNNING.  There's no point at which we can do
SET_IRQS other than in the _RESUMING state.  Generally SET_IRQS
ioctls are coordinated with the guest driver based on actions to the
device, we can't be mucking with IRQs while the device is presumed
running and already generating interrupt conditions.

> And we should really define clearly what a device is supposed to do
> with the interrupt vectors during migration. Obviously there are races
> here.

The device should not be generating interrupts while !_RUNNING, pending
interrupts should be held until the device is _RUNNING.  To me this
means the sequence must be that INTx/MSI/MSI-X are restored while in
the !_RUNNING state.

> > In any case, it requires that the device cannot be absolutely static
> > while !_RUNNING.  Does (_RESUMING) have different rules than
> > (_SAVING)?  
> 
> I'd prever to avoid all device touches during both resuming and
> saving, and do them during !RUNNING

There's no such state required by the uAPI.

> > So I'm still unclear how the uAPI needs to be updated relative to
> > region access.  We need that list of what the user is allowed to
> > access, which seems like minimally config space and MSI-X table space,
> > but are these implicitly known for vfio-pci devices or do we need
> > region flags or capabilities to describe?  We can't generally know the
> > disposition of device specific regions relative to this access.  Thanks,  
> 
> I'd prefer to be general and have the spec forbid
> everything. Specifying things like VFIO_DEVICE_SET_IRQS1 covers all the
> bus types.

AFAICT, SET_IRQS while _RESUMING is a requirement, as is some degree of
access to config space.  It seems you're proposing a new required null
state which is contradictory to the existing uAPI.  Thanks,

Alex

