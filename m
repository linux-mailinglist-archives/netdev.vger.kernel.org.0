Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88FECF5A6C
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfKHVwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:52:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28750 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726231AbfKHVwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 16:52:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573249939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bXQiIgSApdAbmgccznyPpFfbkUQ1dfjbMCJScMKwp7U=;
        b=F/iubziuUTrkb8fngxq0XYaaD4Obj/eeZ+qaHHmI5YLa6fLeNoLY+mEpKE5vqTjJG9oZ1M
        csPKLjHvlAFLn1Uc6ax2iakS15H5cQZ66JjSFtRqERaiW99dLQcJ24Apz57E9YDKp7StjQ
        Fgq2ToKHAl7WxUZIUhV4pbREEAKNCA4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-B9MDUM3yOaiiyDpcXfOYkQ-1; Fri, 08 Nov 2019 16:52:16 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D53B107ACC4;
        Fri,  8 Nov 2019 21:52:13 +0000 (UTC)
Received: from x1.home (ovpn-116-138.phx2.redhat.com [10.3.116.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C6479600C9;
        Fri,  8 Nov 2019 21:52:10 +0000 (UTC)
Date:   Fri, 8 Nov 2019 14:52:10 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Parav Pandit <parav@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David M <david.m.ertman@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>,
        "Jason Wang (jasowang@redhat.com)" <jasowang@redhat.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191108145210.7ad6351c@x1.home>
In-Reply-To: <20191108210545.GG10956@ziepe.ca>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107153234.0d735c1f@cakuba.netronome.com>
        <20191108121233.GJ6990@nanopsycho>
        <20191108144054.GC10956@ziepe.ca>
        <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20191108111238.578f44f1@cakuba>
        <20191108201253.GE10956@ziepe.ca>
        <20191108133435.6dcc80bd@x1.home>
        <20191108210545.GG10956@ziepe.ca>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: B9MDUM3yOaiiyDpcXfOYkQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Nov 2019 17:05:45 -0400
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Fri, Nov 08, 2019 at 01:34:35PM -0700, Alex Williamson wrote:
> > On Fri, 8 Nov 2019 16:12:53 -0400
> > Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >  =20
> > > On Fri, Nov 08, 2019 at 11:12:38AM -0800, Jakub Kicinski wrote: =20
> > > > On Fri, 8 Nov 2019 15:40:22 +0000, Parav Pandit wrote:   =20
> > > > > > The new intel driver has been having a very similar discussion =
about how to
> > > > > > model their 'multi function device' ie to bind RDMA and other d=
rivers to a
> > > > > > shared PCI function, and I think that discussion settled on add=
ing a new bus?
> > > > > >=20
> > > > > > Really these things are all very similar, it would be nice to h=
ave a clear
> > > > > > methodology on how to use the device core if a single PCI devic=
e is split by
> > > > > > software into multiple different functional units and attached =
to different
> > > > > > driver instances.
> > > > > >=20
> > > > > > Currently there is alot of hacking in this area.. And a consist=
ent scheme
> > > > > > might resolve the ugliness with the dma_ops wrappers.
> > > > > >=20
> > > > > > We already have the 'mfd' stuff to support splitting platform d=
evices, maybe
> > > > > > we need to create a 'pci-mfd' to support splitting PCI devices?
> > > > > >=20
> > > > > > I'm not really clear how mfd and mdev relate, I always thought =
mdev was
> > > > > > strongly linked to vfio.
> > > > > >   =20
> > > > >
> > > > > Mdev at beginning was strongly linked to vfio, but as I mentioned
> > > > > above it is addressing more use case.
> > > > >=20
> > > > > I observed that discussion, but was not sure of extending mdev fu=
rther.
> > > > >=20
> > > > > One way to do for Intel drivers to do is after series [9].
> > > > > Where PCI driver says, MDEV_CLASS_ID_I40_FOO
> > > > > RDMA driver mdev_register_driver(), matches on it and does the pr=
obe().   =20
> > > >=20
> > > > Yup, FWIW to me the benefit of reusing mdevs for the Intel case vs
> > > > muddying the purpose of mdevs is not a clear trade off.   =20
> > >=20
> > > IMHO, mdev has amdev_parent_ops structure clearly intended to link it
> > > to vfio, so using a mdev for something not related to vfio seems like
> > > a poor choice. =20
> >=20
> > Unless there's some opposition, I'm intended to queue this for v5.5:
> >=20
> > https://www.spinics.net/lists/kvm/msg199613.html
> >=20
> > mdev has started out as tied to vfio, but at it's core, it's just a
> > device life cycle infrastructure with callbacks between bus drivers
> > and vendor devices.  If virtio is on the wrong path with the above
> > series, please speak up.  Thanks, =20
>=20
> Well, I think Greg just objected pretty strongly.
>=20
> IMHO it is wrong to turn mdev into some API multiplexor. That is what
> the driver core already does and AFAIK your bus type is supposed to
> represent your API contract to your drivers.
>=20
> Since the bus type is ABI, 'mdev' is really all about vfio I guess?
>=20
> Maybe mdev should grow by factoring the special GUID life cycle stuff
> into a helper library that can make it simpler to build proper API
> specific bus's using that lifecycle model? ie the virtio I saw
> proposed should probably be a mdev-virtio bus type providing this new
> virtio API contract using a 'struct mdev_virtio'?

I see, the bus:API contract is more clear when we're talking about
physical buses and physical devices following a hardware specification.
But if we take PCI for example, each PCI device has it's own internal
API that operates on the bus API.  PCI bus drivers match devices based
on vendor and device ID, which defines that internal API, not the bus
API.  The bus API is pretty thin when we're talking virtual devices and
virtual buses though.  The bus "API" is essentially that lifecycle
management, so I'm having a bit of a hard time differentiating this
from saying "hey, that PCI bus is nice, but we can't have drivers using
their own API on the same bus, so can we move the config space, reset,
hotplug, etc, stuff into helpers and come up with an (ex.) mlx5_bus
instead?"  Essentially for virtual devices, we're dictating a bus per
device type, whereas it seemed like a reasonable idea at the time to
create a common virtual device bus, but maybe it went into the weeds
when trying to figure out how device drivers match to devices on that
bus and actually interact with them.

> I only looked briefly but mdev seems like an unusual way to use the
> driver core. *generally* I would expect that if a driver wants to
> provide a foo_device (on a foo bus, providing the foo API contract) it
> looks very broadly like:
>=20
>   struct foo_device {
>        struct device dev;
>        const struct foo_ops *ops;
>   };
>   struct my_foo_device {
>       struct foo_device fdev;
>   };
>=20
>   foo_device_register(&mydev->fdev);
>=20
> Which means we can use normal container_of() patterns, while mdev
> seems to want to allocate all the structs internally.. I guess this is
> because of how the lifecycle stuff works? From a device core view it
> looks quite unnatural.

Right, there's an attempt in mdev to do the common bits of the device
creation in the core and pass it to the vendor driver to fill in the
private bits.  I'm sure it could be cleaner, patches welcome :)  Thanks,

Alex

