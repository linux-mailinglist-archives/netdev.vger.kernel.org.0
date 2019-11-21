Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70BBB1048CC
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 04:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfKUDEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 22:04:01 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:34707 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfKUDEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 22:04:01 -0500
Received: by mail-qv1-f67.google.com with SMTP id n12so846164qvt.1
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 19:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Y8zqQB43OT7mspDmm2HPH0UPJTT75TQo6PszWy4b0WQ=;
        b=g+GFcHrHaQW3vt2GDhSjVpwmoqPPLU/+Q7yA2yR+7UC6Q7JdNmC1eO4wqw3m5PS1A7
         dEOx0O5iNgqQr+fHzvEbWP2hf6Ttv9erZluGV7ItXeaKPjTYeBLr6Jt4o1GSMzSR62be
         X0B85FXkUYxvNQSLpJTlyX4m16D4fU7LfQ6Ubk2N9feq3AAASFH+XNiqdMtU14FaK7SQ
         Z8TKJ8oaMfe+4InX5kFjHvcvreOiZPAWhMbiFx/uhBlXQ5X8W2kElO2CYFYuppK7zwQ+
         8bzyghPJLVEg4/FwkyeDDYKHku63c4853rO4W6G4oEtTyhKZqPfYBZFS4vLxUhoJ/Zu7
         U36Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Y8zqQB43OT7mspDmm2HPH0UPJTT75TQo6PszWy4b0WQ=;
        b=XT1Sq0Bdiu9gzdgOKa2fDXjtKpF9JV/E+ZRy5HbLCM/bfgnIl/lxGJgCZNEFkWdtN5
         NSYPgAM1fC34IoMgAoQ3uid5Ivk2wX/tYLelGOHcyPqFM9dCVcIC/pbJw0WohEDu0t4w
         DxOaffBQORMBOpWVQ5Li7ZTpoqXdBy4k+izICF8w8Lj9N9ijQPCpeAu1hO+HbeDfw6br
         rJHzHJKtNJqKU59oBJ4XPXrER+cf0vZu4FmF/19CKcmX0T7ovYv7CjcejX+wyVOuoFRJ
         LMtlYACBuoyVwBzp88XdaSPsipwro8eTfuD8y+MrHfas7VbClrDVCKkF9i2kX0fKpUZH
         tY3A==
X-Gm-Message-State: APjAAAWItnC/1jv/GcA0CSaLKYVSlGjTuOhyFzQe/Am2RTWSoeaQ0nZ6
        QaWEkvSixaRAVfNCx12XXnvqvA==
X-Google-Smtp-Source: APXvYqztSoUyjIQ48gtcQAq6uX/e2l6rDFs8G7WyT9PUYa5hRtW9nd3d75WHJtSSbfexgjYpi7SBGg==
X-Received: by 2002:a05:6214:8d4:: with SMTP id da20mr1232813qvb.2.1574305439701;
        Wed, 20 Nov 2019 19:03:59 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id c128sm715471qkg.124.2019.11.20.19.03.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 Nov 2019 19:03:58 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iXclB-0001C0-Tf; Wed, 20 Nov 2019 23:03:57 -0400
Date:   Wed, 20 Nov 2019 23:03:57 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>,
        Tiwei Bie <tiwei.bie@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191121030357.GB16914@ziepe.ca>
References: <20191119191547.GL4991@ziepe.ca>
 <20191119163147-mutt-send-email-mst@kernel.org>
 <20191119231023.GN4991@ziepe.ca>
 <20191119191053-mutt-send-email-mst@kernel.org>
 <20191120014653.GR4991@ziepe.ca>
 <134058913.35624136.1574222360435.JavaMail.zimbra@redhat.com>
 <20191120133835.GC22515@ziepe.ca>
 <20191120102856.7e01e2e2@x1.home>
 <20191120181108.GJ22515@ziepe.ca>
 <20191120150732.2fffa141@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120150732.2fffa141@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 03:07:32PM -0700, Alex Williamson wrote:

> > On Wed, Nov 20, 2019 at 10:28:56AM -0700, Alex Williamson wrote:
> > > > > Are you objecting the mdev_set_iommu_deivce() stuffs here?    
> > > > 
> > > > I'm questioning if it fits the vfio PCI device security model, yes.  
> > > 
> > > The mdev IOMMU backing device model is for when an mdev device has
> > > IOMMU based isolation, either via the PCI requester ID or via requester
> > > ID + PASID.  For example, an SR-IOV VF may be used by a vendor to
> > > provide IOMMU based translation and isolation, but the VF may not be
> > > complete otherwise to provide a self contained device.  It might
> > > require explicit coordination and interaction with the PF driver, ie.
> > > mediation.    
> > 
> > In this case the PF does not look to be involved, the ICF kernel
> > driver is only manipulating registers in the same VF that the vfio
> > owns the IOMMU for.
> 
> The mdev_set_iommu_device() call is probably getting caught up in the
> confusion of mdev as it exists today being vfio specific.  What I
> described in my reply is vfio specific.  The vfio iommu backend is
> currently the only code that calls mdev_get_iommu_device(), JasonW
> doesn't use it in the virtio-mdev code, so this seems like a stray vfio
> specific interface that's setup by IFC but never used.

I couldn't really say, it was the only thing I noticed in IFC that
seemed to have anything to do with identifying what IOMMU group to use
for the vfio interface..
 
> > This is why I keep calling it a "so-called mediated device" because it
> > is absolutely not clear what the kernel driver is mediating. Nearly
> > all its work is providing a subsystem-style IOCTL interface under the
> > existing vfio multiplexer unrelated to vfio requirements for DMA.
> 
> Names don't always evolve well to what an interface becomes, see for
> example vfio.  However, even in the vfio sense of mediated devices we
> have protocol translation.  The mdev vendor driver translates vfio API
> callbacks into hardware specific interactions.  Is this really much
> different?

I think the name was fine if you constrain 'mediated' to mean
'mediated IOMMU'

Broading to be basically any driver interface is starting to overlap
with the role of the driver core and subsystems in Linux.

> > However, to me it feels wrong that just because a driver wishes to use
> > PASID or IOMMU features it should go through vfio and mediated
> > devices.
> 
> I don't think I said this.  IOMMU backing of an mdev is an acceleration
> feature as far as vfio-mdev is concerned.  There are clearly other ways
> to use the IOMMU.

Sorry, I didn't mean to imply you said this, I was mearly reflecting
on the mission creep comment below. Often in private converstations
the use of mdev has been justified by 'because it uses IOMMU'

> > I feel like mdev is suffering from mission creep. I see people
> > proposing to use mdev for many wild things, the Mellanox SF stuff in
> > the other thread and this 'virtio subsystem' being the two that have
> > come up publicly this month.
> 
> Tell me about it... ;)
>  
> > Putting some boundaries on mdev usage would really help people know
> > when to use it. My top two from this discussion would be:
> > 
> > - mdev devices should only bind to vfio. It is not a general kernel
> >   driver matcher mechanism. It is not 'virtual-bus'.
> 
> I think this requires the driver-core knowledge to really appreciate.
> Otherwise there's apparently a common need to create sub-devices and
> without closer inspection of the bus:driver API contract, it's too easy
> to try to abstract the device:driver API via the bus.  mdev already has
> a notion that the device itself can use any API, but the interface to
> the bus is the vendor provided, vfio compatible callbacks.

But now that we are talking about this, I think there is a pretty
clear opinion forming that if you want to do kernel-kernel drivers
that is 'virtual bus' as proposed in this threads patch, not mdev.

Adding that knowledge to the mdev documentation would probably help
future people.

> > - mdev & vfio are not a substitute for a proper kernel subsystem. We
> >   shouldn't export a complex subsystem-like ioctl API through
> >   vfio ioctl extensions. Make a proper subsystem, it is not so hard.
> 
> This is not as clear to me, is "ioctl" used once or twice too often or
> are you describing a defined structure of callbacks as an ioctl API?
> The vfio mdev interface is just an extension of the file descriptor
> based vfio device API.  The device needs to handle actual ioctls, but
> JasonW's virtio-mdev series had their own set of callbacks.  Maybe a
> concrete example of this item would be helpful.  Thanks,

I did not intend it to be a clear opinion, more of a vauge guide for
documentation. I think as a maintainer you will be asked to make this
call.

The role of a subsystem in Linux is traditionally to take many
different kinds of HW devices and bring them to a common programming
API. Provide management and diagnostics, and expose some user ABI to
access the HW.

The role of vfio has traditionally been around secure device
assignment of a HW resource to a VM. I'm not totally clear on what the
role if mdev is seen to be, but all the mdev drivers in the tree seem
to make 'and pass it to KVM' a big part of their description.

So, looking at the virtio patches, I see some intended use is to map
some BAR pages into the VM. I see an ops struct to take different
kinds of HW devices to a common internal kernel API. I understand a
desire to bind kernel drivers that are not vfio to those ops, and I
see a user ioctl ABI based around those ops.

I also understand the BAR map is not registers, but just a write-only
doorbell page. So I suppose any interaction the guest will have with
the device prior to starting DMA is going to be software emulated in
qemu, and relayed into ioctls. (?) ie this is no longer strictly
"device assignment" but "accelerated device emulation".

Is virtio more vfio or more subsystem? The biggest thing that points
toward vfio is the intended use. The other items push away.

Frankly, when I look at what this virtio stuff is doing I see RDMA:
 - Both have a secure BAR pages for mmaping to userspace (or VM)
 - Both are prevented from interacting with the device at a register
   level and must call to the kernel - ie creating resources is a
   kernel call - for security.
 - Both create command request/response rings in userspace controlled
   memory and have HW DMA to read requests and DMA to generate responses
 - Both allow the work on the rings to DMA outside the ring to
   addresses controlled by userspace.
 - Both have to support a mixture of HW that uses on-device security
   or IOMMU based security.

(I actually gave a talk on how alot of modern HW is following the RDMA
 design patterns at plumbers, maybe video will come out soon)

We've had the same debate with RDMA. Like VFIO it has an extensible
file descriptor with a driver-specific path that can serve an
unlimited range of uses. We have had to come up with some sensability
and definition for "what is RDMA" and is appropriate for the FD.

Jason
