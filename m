Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82030440549
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 00:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbhJ2WIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 18:08:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35119 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230381AbhJ2WIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 18:08:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635545185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NSheYEDinOsJSVsc4q5gyIjt1AG7FHhaWybb1i8FUxw=;
        b=c0Yb3oCubwy8ZYPKUYQS95oo2ynf7KAmlUPuw3I3oauoqfPLTpiTg7mkybQ7C8dw01mgNx
        YI1vqYypW53A+P7F/6e/TFd2d8z63CSpZRzM7xp7sEI0RjBppqaMivljGbDrcUXIr44tOr
        6+H4kVGKYI0QDqz+Iwhogeia4AnI6HE=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-4K0kCU6LO6StG8Nz6S2c8Q-1; Fri, 29 Oct 2021 18:06:24 -0400
X-MC-Unique: 4K0kCU6LO6StG8Nz6S2c8Q-1
Received: by mail-oi1-f197.google.com with SMTP id u9-20020a056808000900b0029888aec6fbso5726084oic.6
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 15:06:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NSheYEDinOsJSVsc4q5gyIjt1AG7FHhaWybb1i8FUxw=;
        b=rBeuxqbtGI+JMIuzbsUtVDO8ZHqeI5Loqhv5ESjOken3F9OUwTaxhHqXZR9Gv0NBOL
         1XMSuYKo7XI/wpFAzuahnM7/kpwK6GnJ5Kq2Ai86t7U9aX+vJTAGPnE1+ZLK+AWR6xHR
         WiNggn9R5JMUNzojNgpIBUg2qwOyJFy153E0S6JbhDcdxwNupXYlPkn0uJlSo5Hl7Kqw
         +AXott5ksWcqSDITSweJ/iTtx8xdp9H8pN0In99TZACwve0vyUrxKaalwgODeiurU7OH
         bdMEXC/GLoehL6J4oxheCfi/OX3708EXDg8ejYbxZx0r9s703iMPJvRUkes6VYjy13HL
         ImbQ==
X-Gm-Message-State: AOAM531SWzDdksEh0rRtt0Vegczwrs1KwjqjpEFk76paTbo6/YsGwo9j
        3SnvigoBo2lkP19hv6HAM94A762nvCnGAi2juYMeeFIs59aWFdqNmaDsyNEuBLALV970X/kyW4n
        LYWnyVKi/YdQyY8vf
X-Received: by 2002:aca:1314:: with SMTP id e20mr2964742oii.93.1635545183463;
        Fri, 29 Oct 2021 15:06:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzgP7OnnCpy3KcioU7A5eIZGb2LAs3XnWl9Hm3c53SKMQFgvHcbx9uZrrnr1MylAEJHM788A==
X-Received: by 2002:aca:1314:: with SMTP id e20mr2964707oii.93.1635545183089;
        Fri, 29 Oct 2021 15:06:23 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id r44sm2423156otv.39.2021.10.29.15.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 15:06:22 -0700 (PDT)
Date:   Fri, 29 Oct 2021 16:06:21 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211029160621.46ca7b54.alex.williamson@redhat.com>
In-Reply-To: <20211028234750.GP2744544@nvidia.com>
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
        <20211028234750.GP2744544@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Oct 2021 20:47:50 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Oct 28, 2021 at 09:30:35AM -0600, Alex Williamson wrote:
> > On Wed, 27 Oct 2021 16:23:45 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Wed, Oct 27, 2021 at 01:05:20PM -0600, Alex Williamson wrote:
> > >   
> > > > > As far as the actual issue, if you hadn't just discovered it now
> > > > > nobody would have known we have this gap - much like how the very
> > > > > similar reset issue was present in VFIO for so many years until you
> > > > > plugged it.    
> > > > 
> > > > But the fact that we did discover it is hugely important.  We've
> > > > identified that the potential use case is significantly limited and
> > > > that userspace doesn't have a good mechanism to determine when to
> > > > expose that limitation to the user.      
> > > 
> > > Huh?
> > > 
> > > We've identified that, depending on device behavior, the kernel may
> > > need to revoke MMIO access to protect itself from hostile userspace
> > > triggering TLP Errors or something.
> > > 
> > > Well behaved userspace must already stop touching the MMIO on the
> > > device when !RUNNING - I see no compelling argument against that
> > > position.  
> > 
> > Not touching MMIO is not specified in our uAPI protocol,  
> 
> To be frank, not much is specified in the uAPI comment, certainly not
> a detailed meaning of RUNNING.
> 
> > nor is it an obvious assumption to me, nor is it sufficient to
> > assume well behaved userspace in the implementation of a kernel
> > interface.  
> 
> I view two aspects to !RUNNING:
> 
>  1) the kernel must protect itself from hostile userspace. This means
>     preventing loss of kernel or device integrity (ie no error TLPs, no
>     crashing/corrupting the device/etc)
> 
>  2) userspace must follow the rules so that the migration is not
>     corrupted. We want to set the rules in a way that gives the
>     greatest freedom of HW implementation
> 
> Regarding 1, I think we all agree on this, and currently we believe
> mlx5 is meeting this goal as-is.
> 
> Regarding 2, I think about possible implementations and come to the
> conclusion that !RUNNING must mean no MMIO. For several major reasons
> 
> - For whatever reason a poor device may become harmed by MMIO during
>   !RUNNING and so we may someday need to revoke MMIO like we do for
>   reset. This implies that segfault on MMIO during !RUNNING
>   is an option we should keep open.
> 
> - A simple DMA queue device, kind of like the HNS driver, could
>   implement migration without HW support. Transition to !RUNNING only
>   needs to wait for the device to fully drained the DMA queue.
> 
>   Any empty DMA queue with no MMIOs means a quiet and migration ready 
>   device.
> 
>   However, if further MMIOs poke at the device it may resume
>   operating and issue DMAs, which would corrupt the migration.
> 
> - We cannot define what MMIO during !RUNNING should even do. What
>   should a write do? What should a read return? The mlx5 version is
>   roughly discard the write and return garbage on read. While this
>   does not corrupt the migration it is also not useful behavior to
>   define.
> 
> In several of these case I'm happy if broken userspace harms itself
> and corrupts the migration. That does not impact the integrity of the
> kernel, and is just buggy userspace.
> 
> > > We've been investigating how the mlx5 HW will behave in corner cases,
> > > and currently it looks like mlx5 vfio will not generate error TLPs, or
> > > corrupt the device itself due to MMIO operations when !RUNNING. So the
> > > driver itself, as written, probably does not currently have a bug
> > > here, or need changes.  
> > 
> > This is a system level observation or is it actually looking at the
> > bus?  An Unsupported Request on MMIO write won't even generate an AER
> > on some systems, but others can trigger a fatal error on others.  
> 
> At this point this information is a design analysis from the HW
> people.
> 
> > > > We're tossing around solutions that involve extensions, if not
> > > > changes to the uAPI.  It's Wednesday of rc7.    
> > > 
> > > The P2P issue is seperate, and as I keep saying, unless you want to
> > > block support for any HW that does not have freeze&queice userspace
> > > must be aware of this ability and it is logical to design it as an
> > > extension from where we are now.  
> > 
> > Is this essentially suggesting that the uAPI be clarified to state
> > that the base implementation is only applicable to userspace contexts
> > with a single migratable vfio device instance?    
> 
> That is one way to look at it, yes. It is not just a uAPI limitation
> but a HW limitation as the NDMA state does require direct HW support
> to continue accepting MMIO/etc but not issue DMA. A simple DMA queue
> device as I imagine above couldn't implement it.
> 
> > Does that need to preemptively include /dev/iommu generically,
> > ie. anything that could potentially have an IOMMU mapping to the
> > device?  
> 
> Going back to the top, for #1 the kernel must protect its
> integrity. So, like reset, if we have a driver where revoke is
> required then the revoke must extend to /dev/iommu as well.
> 
> For #2 - it is up to userspace. If userspace plugs the device into
> /dev/iommu and keeps operating it then the migration can be
> corrupted. Buggy userspace.
> 
> > I agree that it would be easier to add a capability to expose
> > multi-device compatibility than to try to retrofit one to expose a
> > restriction.  
> 
> Yes, me too. What we have here is a realization that the current
> interface does not support P2P scenarios. There is a wide universe of
> applications that don't need P2P.
> 
> The realization is that qemu has a bug in that it allows the VM to
> execute P2P operations which are incompatible with my above definition
> of !RUNNING. The result is the #2 case: migration corruption.
> 
> qemu should protect itself from a VM causing corruption of the
> migration. Either by only supporting migration with a single VFIO
> device, or directly blocking P2P scenarios using the IOMMU.
>
> To support P2P will require new kernel support, capability and HW
> support. Which, in concrete terms, means we need to write a new uAPI
> spec, update the mlx5 vfio driver, implement qemu patches, and test
> the full solution.
> 
> Right now we are focused on the non-P2P cases, which I think is a
> reasonable starting limitation.

It's a reasonable starting point iff we know that we need to support
devices that cannot themselves support a quiescent state.  Otherwise it
would make sense to go back to work on the uAPI because I suspect the
implications to userspace are not going to be as simple as "oops, can't
migrate, there are two devices."  As you say, there's a universe of
devices that run together that don't care about p2p and QEMU will be
pressured to support migration of those configurations.

QEMU currently already supports p2p between assigned devices, which
means the user or management tool is going to need to choose whether
they prefer migration or legacy p2p compatibility.  The DMA mapping
aspects of this get complicated.  Ideally we could skip p2p DMA
mappings for any individual device that doesn't support this future
quiescent state, but we don't do mappings based on individual devices,
we do them based on the container.  There's a least common denominator
among the devices in a container, but we also support hotplug and we
can't suddenly decide to tear down p2p mappings because a new device is
added.  That probably means that we can't automatically enable both p2p
and migration, even if we initially only have devices that support this
new quiescent migration state.  We'd need to design the QEMU options
so we can't have a subset of devices that want p2p and another set that
want migration.  If we ever want both migration and p2p, QEMU would
need to reject any device that can't comply.

If we're moving forward without an independent quiescent state, the
uAPI should include clarification specifying that it's the user's
responsibility to independently prevent DMA to devices while the device
is !_RUNNING.  Whether that's because DMA to the device is always
blocked at the IOMMU or a configuration restriction to prevent
additional devices that could generate DMA is left to the user.

Support would need to be added in the kernel to tear down these
mappings if there were a scenario where the user failing to prevent DMA
to the device could cause misbehavior classified under your #1 above,
harm to host.

> > Like I've indicated, this is not an obvious corollary of the !_RUNNING
> > state to me.  I'd tend more towards letting userspace do what they want
> > and only restrict as necessary to protect the host.  For example the
> > state of the device when !_RUNNING may be changed by external stimuli,
> > including MMIO and DMA accesses, but the device does not independently
> > advance state.  
> 
> As above this is mixing #1 and #2 - it is fine to allow the device to
> do whatever as long as it doesn't harm the host - however that doesn't
> define the conditions userspace must follow to have a successful
> migration.
> 
> > Also, I think we necessarily require config space read-access to
> > support migration, which begs the question specifically which regions,
> > if any, are restricted when !_RUNNING?  Could we get away with zapping
> > mmaps (sigbus on fault) but allowing r/w access?  
> 
> Ideally we would define exactly what device operations are allowed
> during !RUNNING such that the migration will be successful. Operations
> outside that list should be considered things that could corrupt the
> migration.
> 
> This list should be as narrow as possible to allow the broadest range
> of HW designs.

So we need a proposal of that list.

> > > Yes, if qemu becomes deployed, but our testing shows qemu support
> > > needs a lot of work before it is deployable, so that doesn't seem to
> > > be an immediate risk.  
> > 
> > Good news... I guess...  but do we know what other uAPI changes might
> > be lurking without completing that effort?  
> 
> Well, I would say this patch series is approximately the mid point of
> the project. We are about 60 patches into kernel changes at this
> point. What is left is approximately:
> 
>  - fix bugs in qemu so single-device operation is robust
>  - dirty page tracking using the system iommu (via iommufd I suppose?)
>  - dirty page tracking using the device iommu
>  - migration with P2P ongoing: uAPI spec, kernel implementation
>    and qemu implementation
> 
> Then we might have a product..
> 
> I also know the mlx5 device was designed with knowledge of other
> operating systems and our team believes the device interface meets all
> needs.
> 
> So, is the uAPI OK? I'd say provisionally yes. It works within its
> limitations and several vendors have implemented it, even if only two
> are heading toward in-tree.
> 
> Is it clearly specified and covers all scenarios? No..
> 
> > > If some fictional HW can be more advanced and can snapshot not freeze,
> > > that is great, but it doesn't change one bit that mlx5 cannot and will
> > > not work that way. Since mlx5 must be supported, there is no choice
> > > but to define the uAPI around its limitations.  
> > 
> > But it seems like you've found that mlx5 is resilient to these things
> > that you're also deeming necessary to restrict.  
> 
> Here I am talking about freeze/quiesce as a HW design choice, not the
> mmio stuff.
>  
> > > So, I am not left with a clear idea what is still open that you see as
> > > blocking. Can you summarize?  
> > 
> > It seems we have numerous uAPI questions floating around, including
> > whether the base specification is limited to a single physical device
> > within the user's IOMMU context, what the !_RUNNING state actually
> > implies about the device state, expectations around userspace access
> > to device regions while in this state, and who is responsible for
> > limiting such access, and uncertainty what other uAPI changes are
> > necessary as QEMU support is stabilized.  
> 
> I think these questions have straightfoward answers. I've tried to
> explain my view above.
> 
> > Why should we rush a driver in just before the merge window and
> > potentially increase our experimental driver debt load rather than
> > continue to co-develop kernel and userspace drivers and maybe also
> > get input from the owners of the existing out-of-tree drivers?  Thanks,  
> 
> It is not a big deal to defer things to rc1, though merging a
> leaf-driver that has been on-list over a month is certainly not
> rushing either.

If "on-list over a month" is meant to imply that it's well vetted, it
does not.  That's a pretty quick time frame given the uAPI viability
discussions that it's generated.
 
> We are not here doing all this work because we want to co-develop
> kernel and user space drivers out of tree for ages.
> 
> Why to merge it? Because there is still lots of work to do, and to
> make progress on the next bits require agreeing to the basic stuff
> first!
> 
> So, lets have some actional feedback on what you need to see for an
> rc1 merging please.
> 
> Since there are currently no unaddressed comments on the patches, I
> assume you want to see more work done, please define it.

I'm tending to agree that there's value in moving forward, but there's
a lot we're defining here that's not in the uAPI, so I'd like to see
those things become formalized.

I think this version is defining that it's the user's responsibility to
prevent external DMA to devices while in the !_RUNNING state.  This
resolves the condition that we have no means to coordinate quiescing
multiple devices.  We shouldn't necessarily prescribe a single device
solution in the uAPI if the same can be equally achieved through
configuration of DMA mapping.

I was almost on board with blocking MMIO, especially as p2p is just DMA
mapping of MMIO, but what about MSI-X?  During _RESUME we must access
the MSI-X vector table via the SET_IRQS ioctl to configure interrupts.
Is this exempt because the access occurs in the host?  In any case, it
requires that the device cannot be absolutely static while !_RUNNING.
Does (_RESUMING) have different rules than (_SAVING)?

So I'm still unclear how the uAPI needs to be updated relative to
region access.  We need that list of what the user is allowed to
access, which seems like minimally config space and MSI-X table space,
but are these implicitly known for vfio-pci devices or do we need
region flags or capabilities to describe?  We can't generally know the
disposition of device specific regions relative to this access.  Thanks,

Alex

