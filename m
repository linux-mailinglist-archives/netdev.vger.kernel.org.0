Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79470103260
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 04:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfKTD72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 22:59:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29996 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727586AbfKTD72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 22:59:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574222366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CXnwiK0Y1iLRPCM3j/TkttSX1L0IsRa9v3ZpAGpmQhg=;
        b=hxCmqDk/lJy+o9okI7F0iiKSkxcoDdjktz6FROTYFs95/i1GqKHFB6NmNjnYJP//KfA5cF
        3UI7+H61IXHDdm+R8lTO6gulHsNjFZvmzYXMGFIdPsj0O5It296TYsvdrh7RL5jzC+Qqax
        PWCUvHeY2weNUOcK/Rh+M6zSQq8l4RQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-7mbJFjw5NYa9Fba_z-EB-w-1; Tue, 19 Nov 2019 22:59:23 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A4D55801FBF;
        Wed, 20 Nov 2019 03:59:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 921D867673;
        Wed, 20 Nov 2019 03:59:21 +0000 (UTC)
Received: from zmail21.collab.prod.int.phx2.redhat.com (zmail21.collab.prod.int.phx2.redhat.com [10.5.83.24])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 66C691809567;
        Wed, 20 Nov 2019 03:59:21 +0000 (UTC)
Date:   Tue, 19 Nov 2019 22:59:20 -0500 (EST)
From:   Jason Wang <jasowang@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Kiran Patil <kiran.patil@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>
Message-ID: <134058913.35624136.1574222360435.JavaMail.zimbra@redhat.com>
In-Reply-To: <20191120014653.GR4991@ziepe.ca>
References: <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com> <20191119164632.GA4991@ziepe.ca> <20191119134822-mutt-send-email-mst@kernel.org> <20191119191547.GL4991@ziepe.ca> <20191119163147-mutt-send-email-mst@kernel.org> <20191119231023.GN4991@ziepe.ca> <20191119191053-mutt-send-email-mst@kernel.org> <20191120014653.GR4991@ziepe.ca>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
MIME-Version: 1.0
X-Originating-IP: [10.68.5.20, 10.4.195.6]
Thread-Topic: virtual-bus: Implementation of Virtual Bus
Thread-Index: n9NEk+gP4p+eAlBUPqjybmA1P5VVfg==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 7mbJFjw5NYa9Fba_z-EB-w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- Original Message -----
> On Tue, Nov 19, 2019 at 07:16:21PM -0500, Michael S. Tsirkin wrote:
> > On Tue, Nov 19, 2019 at 07:10:23PM -0400, Jason Gunthorpe wrote:
> > > On Tue, Nov 19, 2019 at 04:33:40PM -0500, Michael S. Tsirkin wrote:
> > > > On Tue, Nov 19, 2019 at 03:15:47PM -0400, Jason Gunthorpe wrote:
> > > > > On Tue, Nov 19, 2019 at 01:58:42PM -0500, Michael S. Tsirkin wrot=
e:
> > > > > > On Tue, Nov 19, 2019 at 12:46:32PM -0400, Jason Gunthorpe wrote=
:
> > > > > > > As always, this is all very hard to tell without actually see=
ing
> > > > > > > real
> > > > > > > accelerated drivers implement this.
> > > > > > >=20
> > > > > > > Your patch series might be a bit premature in this regard.
> > > > > >=20
> > > > > > Actually drivers implementing this have been posted, haven't th=
ey?
> > > > > > See e.g. https://lwn.net/Articles/804379/
> > > > >=20
> > > > > Is that a real driver? It looks like another example quality
> > > > > thing.
> > > > >=20
> > > > > For instance why do we need any of this if it has '#define
> > > > > IFCVF_MDEV_LIMIT 1' ?
> > > > >=20
> > > > > Surely for this HW just use vfio over the entire PCI function and=
 be
> > > > > done with it?
> > > >=20
> > > > What this does is allow using it with unmodified virtio drivers
> > > > within guests.  You won't get this with passthrough as it only
> > > > implements parts of virtio in hardware.
> > >=20
> > > I don't mean use vfio to perform passthrough, I mean to use vfio to
> > > implement the software parts in userspace while vfio to talk to the
> > > hardware.
> >=20
> > You repeated vfio twice here, hard to decode what you meant actually.
>=20
> 'while using vifo to talk to the hardware'
>=20
> > >   kernel -> vfio -> user space virtio driver -> qemu -> guest
> >
> > Exactly what has been implemented for control path.
>=20
> I do not mean the modified mediated vfio this series proposes, I mean
> vfio-pci, on a full PCI VF, exactly like we have today.
>=20
> > The interface between vfio and userspace is
> > based on virtio which is IMHO much better than
> > a vendor specific one. userspace stays vendor agnostic.
>=20
> Why is that even a good thing? It is much easier to provide drivers
> via qemu/etc in user space then it is to make kernel upgrades. We've
> learned this lesson many times.

For upgrades, since we had a unified interface. It could be done
through:

1) switch the datapath from hardware to software (e.g vhost)
2) unload and load the driver
3) switch teh datapath back

Having drivers in user space have other issues, there're a lot of
customers want to stick to kernel drivers.

>=20
> This is why we have had the philosophy that if it doesn't need to be
> in the kernel it should be in userspace.

Let me clarify again. For this framework, it aims to support both
kernel driver and userspce driver. For this series, it only contains
the kernel driver part. What it did is to allow kernel virtio driver
to control vDPA devices. Then we can provide a unified interface for
all of the VM, containers and bare metal. For this use case, I don't
see a way to leave the driver in userspace other than injecting
traffic back through vhost/TAP which is ugly.

>=20
> > > Generally we don't want to see things in the kernel that can be done
> > > in userspace, and to me, at least for this driver, this looks
> > > completely solvable in userspace.
> >=20
> > I don't think that extends as far as actively encouraging userspace
> > drivers poking at hardware in a vendor specific way.
>=20
> Yes, it does, if you can implement your user space requirements using
> vfio then why do you need a kernel driver?
>

VFIO is only for userspace driver, we want kernel virtio driver run as
well. That's why a unified API is designed for both.

> The kernel needs to be involved when there are things only the kernel
> can do. If IFC has such things they should be spelled out to justify
> using a mediated device.

Why? It allows a full functional virtio driver run on the host.


>=20
> > That has lots of security and portability implications and isn't
> > appropriate for everyone.
>=20
> This is already using vfio. It doesn't make sense to claim that using
> vfio properly is somehow less secure or less portable.
>=20
> What I find particularly ugly is that this 'IFC VF NIC' driver
> pretends to be a mediated vfio device, but actually bypasses all the
> mediated device ops for managing dma security and just directly plugs
> the system IOMMU for the underlying PCI device into vfio.

Well, VFIO have multiple types of API. The design is to stick the VFIO
DMA model like container work for making DMA API work for userspace
driver. We can invent something our own but it must duplicate with the
exist API and it will be extra overhead when VFIO DMA API starts to
support stuffs like nesting or PASID.

So in conclusion for vhost-mdev:

- DMA is still done through VFIO manner e.g container fd etc.
- device API is totally virtio specific.

Compared with vfio-pci device, the only difference is the device API,
we don't use device fd but vhost-net fd, but of course we can switch
to use device fd. I'm sure we can settle this part down by having a
way that is acceptable by both sides.

>=20
> I suppose this little hack is what is motivating this abuse of vfio in
> the first place?
>=20
> Frankly I think a kernel driver touching a PCI function for which vfio
> is now controlling the system iommu for is a violation of the security
> model, and I'm very surprised AlexW didn't NAK this idea.
>
> Perhaps it is because none of the patches actually describe how the
> DMA security model for this so-called mediated device works? :(
>
> Or perhaps it is because this submission is split up so much it is
> hard to see what is being proposed? (I note this IFC driver is the
> first user of the mdev_set_iommu_device() function)
>

Are you objecting the mdev_set_iommu_deivce() stuffs here?

> > It is kernel's job to abstract hardware away and present a unified
> > interface as far as possible.
>=20
> Sure, you could create a virtio accelerator driver framework in our
> new drivers/accel I hear was started. That could make some sense, if
> we had HW that actually required/benefited from kernel involvement.

The framework is not designed specifically for your card. It tries to be
generic to support every types of virtio hardware devices, it's not
tied to any bus (e.g PCI) and any vendor. So it's not only a question
of how to slice a PCIE ethernet device.

Thanks

>=20
> Jason
>=20
>=20

