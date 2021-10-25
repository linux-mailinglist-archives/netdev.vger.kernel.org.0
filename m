Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63FE9439EAE
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 20:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbhJYSt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 14:49:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30279 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233289AbhJYSt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 14:49:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635187654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6EW7txlh+uOUAxYxbDB9IshowiDOro3wjgqyCQ3sGxM=;
        b=fJkbN3PJ9OiYS+XsKMr53TPqtJNGP9g5O4cpr6IMn1bjyUT8IutVcLmAVr2gGSEWBBwYrU
        Oka0eVLXCRRwRHKHGUDEsUip1k1X9IvaXJmWyjcDTAAxbp2zGFS5UhjJG6qF5s5p0TI4Yu
        RMn+ny0Dzzkp13Cf16IY5oGcQsnLvEM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-Zicf6PoSNOCR-86M862nUg-1; Mon, 25 Oct 2021 14:47:33 -0400
X-MC-Unique: Zicf6PoSNOCR-86M862nUg-1
Received: by mail-wr1-f70.google.com with SMTP id j12-20020adf910c000000b0015e4260febdso3417463wrj.20
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 11:47:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=6EW7txlh+uOUAxYxbDB9IshowiDOro3wjgqyCQ3sGxM=;
        b=DWGQA6EwqEtgCkM1GoTxuPCrvHCgwh89K8jJfOQ7LXqDWXZZva6v3nkp6hQqrh0owS
         O06B0jkMaR1w3DaBsDip7evyU7ntIZKGdUaPYjXdhKcgpO0UPBaSFMfrVBIBbUiHAqVG
         gtjXPFFdKOfGDxeP3PZ9xJjNkHushtP7NvVK0X+uVxvlrobFrprUumoiKl6itqLb9Q50
         Q9sueW4pMpA0gk+ityKR2xsFx3tRfJsOWOt1SMYLuv/F5bPuyHhFkUGvwxCRu6ZZBCL1
         YrgY5RbuO4Y9m/jXPzllO6pge8rNNR81ffrU6+rcJ4QzUN15iC2qajp+Gn+YhtfMca87
         B64w==
X-Gm-Message-State: AOAM530xANbgADpoVWe360CyhMAIucxTL2oKGZLJGKby7Lbdwc5KAqf6
        n8a5Z3OgOX2tZk20uOD+Pjv85z7QOF4SOoX4wy4gOkuylYs55Qqe1phAp6cC7JBb22gFUuvmJh5
        XTSKxEfSD6QgPuUgG
X-Received: by 2002:a05:600c:4894:: with SMTP id j20mr18300682wmp.60.1635187652358;
        Mon, 25 Oct 2021 11:47:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwi88GrvhJPJqUxL4ZtskRmjUnoxymkGeWDaizgJygyAfc7km4fzKFhWVkl7rV8mcptOfZ47Q==
X-Received: by 2002:a05:600c:4894:: with SMTP id j20mr18300661wmp.60.1635187652104;
        Mon, 25 Oct 2021 11:47:32 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id s11sm3916497wru.16.2021.10.25.11.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 11:47:31 -0700 (PDT)
Date:   Mon, 25 Oct 2021 19:47:29 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <YXb7wejD1qckNrhC@work-vm>
References: <20211019105838.227569-1-yishaih@nvidia.com>
 <20211019105838.227569-13-yishaih@nvidia.com>
 <20211019124352.74c3b6ba.alex.williamson@redhat.com>
 <20211019192328.GZ2744544@nvidia.com>
 <20211019145856.2fa7f7c8.alex.williamson@redhat.com>
 <20211019230431.GA2744544@nvidia.com>
 <5a496713-ae1d-11f2-1260-e4c1956e1eda@nvidia.com>
 <20211020105230.524e2149.alex.williamson@redhat.com>
 <YXbceaVo0q6hOesg@work-vm>
 <20211025115535.49978053.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211025115535.49978053.alex.williamson@redhat.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Alex Williamson (alex.williamson@redhat.com) wrote:
> On Mon, 25 Oct 2021 17:34:01 +0100
> "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
> 
> > * Alex Williamson (alex.williamson@redhat.com) wrote:
> > > [Cc +dgilbert, +cohuck]
> > > 
> > > On Wed, 20 Oct 2021 11:28:04 +0300
> > > Yishai Hadas <yishaih@nvidia.com> wrote:
> > >   
> > > > On 10/20/2021 2:04 AM, Jason Gunthorpe wrote:  
> > > > > On Tue, Oct 19, 2021 at 02:58:56PM -0600, Alex Williamson wrote:    
> > > > >> I think that gives us this table:
> > > > >>
> > > > >> |   NDMA   | RESUMING |  SAVING  |  RUNNING |
> > > > >> +----------+----------+----------+----------+ ---
> > > > >> |     X    |     0    |     0    |     0    |  ^
> > > > >> +----------+----------+----------+----------+  |
> > > > >> |     0    |     0    |     0    |     1    |  |
> > > > >> +----------+----------+----------+----------+  |
> > > > >> |     X    |     0    |     1    |     0    |
> > > > >> +----------+----------+----------+----------+  NDMA value is either compatible
> > > > >> |     0    |     0    |     1    |     1    |  to existing behavior or don't
> > > > >> +----------+----------+----------+----------+  care due to redundancy vs
> > > > >> |     X    |     1    |     0    |     0    |  !_RUNNING/INVALID/ERROR
> > > > >> +----------+----------+----------+----------+
> > > > >> |     X    |     1    |     0    |     1    |  |
> > > > >> +----------+----------+----------+----------+  |
> > > > >> |     X    |     1    |     1    |     0    |  |
> > > > >> +----------+----------+----------+----------+  |
> > > > >> |     X    |     1    |     1    |     1    |  v
> > > > >> +----------+----------+----------+----------+ ---
> > > > >> |     1    |     0    |     0    |     1    |  ^
> > > > >> +----------+----------+----------+----------+  Desired new useful cases
> > > > >> |     1    |     0    |     1    |     1    |  v
> > > > >> +----------+----------+----------+----------+ ---
> > > > >>
> > > > >> Specifically, rows 1, 3, 5 with NDMA = 1 are valid states a user can
> > > > >> set which are simply redundant to the NDMA = 0 cases.    
> > > > > It seems right
> > > > >    
> > > > >> Row 6 remains invalid due to lack of support for pre-copy (_RESUMING
> > > > >> | _RUNNING) and therefore cannot be set by userspace.  Rows 7 & 8
> > > > >> are error states and cannot be set by userspace.    
> > > > > I wonder, did Yishai's series capture this row 6 restriction? Yishai?    
> > > > 
> > > > 
> > > > It seems so,  by using the below check which includes the 
> > > > !VFIO_DEVICE_STATE_VALID clause.
> > > > 
> > > > if (old_state == VFIO_DEVICE_STATE_ERROR ||
> > > >          !VFIO_DEVICE_STATE_VALID(state) ||
> > > >          (state & ~MLX5VF_SUPPORTED_DEVICE_STATES))
> > > >          return -EINVAL;
> > > > 
> > > > Which is:
> > > > 
> > > > #define VFIO_DEVICE_STATE_VALID(state) \
> > > >      (state & VFIO_DEVICE_STATE_RESUMING ? \
> > > >      (state & VFIO_DEVICE_STATE_MASK) == VFIO_DEVICE_STATE_RESUMING : 1)
> > > >   
> > > > >    
> > > > >> Like other bits, setting the bit should be effective at the completion
> > > > >> of writing device state.  Therefore the device would need to flush any
> > > > >> outbound DMA queues before returning.    
> > > > > Yes, the device commands are expected to achieve this.
> > > > >    
> > > > >> The question I was really trying to get to though is whether we have a
> > > > >> supportable interface without such an extension.  There's currently
> > > > >> only an experimental version of vfio migration support for PCI devices
> > > > >> in QEMU (afaik),    
> > > > > If I recall this only matters if you have a VM that is causing
> > > > > migratable devices to interact with each other. So long as the devices
> > > > > are only interacting with the CPU this extra step is not strictly
> > > > > needed.
> > > > >
> > > > > So, single device cases can be fine as-is
> > > > >
> > > > > IMHO the multi-device case the VMM should probably demand this support
> > > > > from the migration drivers, otherwise it cannot know if it is safe for
> > > > > sure.
> > > > >
> > > > > A config option to override the block if the admin knows there is no
> > > > > use case to cause devices to interact - eg two NVMe devices without
> > > > > CMB do not have a useful interaction.
> > > > >    
> > > > >> so it seems like we could make use of the bus-master bit to fill
> > > > >> this gap in QEMU currently, before we claim non-experimental
> > > > >> support, but this new device agnostic extension would be required
> > > > >> for non-PCI device support (and PCI support should adopt it as
> > > > >> available).  Does that sound right?  Thanks,    
> > > > > I don't think the bus master support is really a substitute, tripping
> > > > > bus master will stop DMA but it will not do so in a clean way and is
> > > > > likely to be non-transparent to the VM's driver.
> > > > >
> > > > > The single-device-assigned case is a cleaner restriction, IMHO.
> > > > >
> > > > > Alternatively we can add the 4th bit and insist that migration drivers
> > > > > support all the states. I'm just unsure what other HW can do, I get
> > > > > the feeling people have been designing to the migration description in
> > > > > the header file for a while and this is a new idea.  
> > > 
> > > I'm wondering if we're imposing extra requirements on the !_RUNNING
> > > state that don't need to be there.  For example, if we can assume that
> > > all devices within a userspace context are !_RUNNING before any of the
> > > devices begin to retrieve final state, then clearing of the _RUNNING
> > > bit becomes the device quiesce point and the beginning of reading
> > > device data is the point at which the device state is frozen and
> > > serialized.  No new states required and essentially works with a slight
> > > rearrangement of the callbacks in this series.  Why can't we do that?  
> > 
> > So without me actually understanding your bit encodings that closely, I
> > think the problem is we have to asusme that any transition takes time.
> > From the QEMU point of view I think the requirement is when we stop the
> > machine (vm_stop_force_state(RUN_STATE_FINISH_MIGRATE) in
> > migration_completion) that at the point that call returns (with no
> > error) all devices are idle.  That means you need a way to command the
> > device to go into the stopped state, and probably another to make sure
> > it's got there.
> 
> In a way.  We're essentially recognizing that we cannot stop a single
> device in isolation of others that might participate in peer-to-peer
> DMA with that device, so we need to make a pass to quiesce each device
> before we can ask the device to fully stop.  This new device state bit
> is meant to be that quiescent point, devices can accept incoming DMA
> but should cease to generate any.  Once all device are quiesced then we
> can safely stop them.

It may need some further refinement; for example in that quiesed state
do counters still tick? will a NIC still respond to packets that don't
get forwarded to the host?

Note I still think you need a way to know when you have actually reached
these states; setting a bit in a register is asking nicely for a device
to go into a state - has it got there?

> > Now, you could be a *little* more sloppy; you could allow a device carry
> > on doing stuff purely with it's own internal state up until the point
> > it needs to serialise; but that would have to be strictly internal state
> > only - if it can change any other devices state (or issue an interrupt,
> > change RAM etc) then you get into ordering issues on the serialisation
> > of multiple devices.
> 
> Yep, that's the proposal that doesn't require a uAPI change, we loosen
> the definition of stopped to mean the device can no longer generate DMA
> or interrupts and all internal processing outside or responding to
> incoming DMA should halt (essentially the same as the new quiescent
> state above).  Once all devices are in this state, there should be no
> incoming DMA and we can safely collect per device migration data.  If
> state changes occur beyond the point in time where userspace has
> initiated the collection of migration data, drivers have options for
> generating errors when userspace consumes that data.

How do you know that last device has actually gone into that state?
Also be careful; it feels much more delicate where something might
accidentally start a transaction.

> AFAICT, the two approaches are equally valid.  If we modify the uAPI to
> include this new quiescent state then userspace needs to make some hard
> choices about what configurations they support without such a feature.
> The majority of configurations are likely not exercising p2p between
> assigned devices, but the hypervisor can't know that.  If we work
> within the existing uAPI, well there aren't any open source driver
> implementations yet anyway and any non-upstream implementations would
> need to be updated for this clarification.  Existing userspace works
> better with no change, so long as they already follow the guideline
> that all devices in the userspace context must be stopped before the
> migration data of any device can be considered valid.  Thanks,

Dave

> Alex
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

