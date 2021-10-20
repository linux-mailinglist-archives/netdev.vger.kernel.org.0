Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8FC4350B5
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 18:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhJTQy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 12:54:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47886 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230422AbhJTQyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 12:54:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634748754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DMO8FDHuCRVN4kKXZjsmECp0YmfqK9sf2OKOuUjTnpY=;
        b=eHOmFE9Wgst5y6aCmzNjIkHNfNsaZR6WBSUPXn7HdZfTRZqkKKeaoz8rRK6INJxpdSQVNN
        obrWljDoMiieOktQD3p/Vnfb5YtyvVAH0LL7c4JsxWuf/PUY3ZRwB7/SdBli/MPstup9Pz
        y4kzWCw0F/rq93IBHVVD5l1PhYUFOGI=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-g8V7I-cjPVCe2KDeEXYSzg-1; Wed, 20 Oct 2021 12:52:33 -0400
X-MC-Unique: g8V7I-cjPVCe2KDeEXYSzg-1
Received: by mail-oo1-f72.google.com with SMTP id w1-20020a4a2741000000b002b6eb5b596cso3488422oow.9
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 09:52:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DMO8FDHuCRVN4kKXZjsmECp0YmfqK9sf2OKOuUjTnpY=;
        b=aOH6mr6LOhmGQWOg4YK76SdUHU4t8LEvttO+Izy+cqmKVld3nBBDIV499TJKjnnmv3
         Z2f7apIZ4xS1thS9BGvJp8Xj/rOUEEAQYI+NUWPecAFc0gzaGn7M96XQ3U/f7FpIvHxP
         yJrG/JMGshMbZKzF3zsD7OttgotzqHpnBWV41AsQd2BsRph75fRsfJsrpDcyAOz0eD4C
         49RuSKeaJ/w/5Ll5WVlcdMbs2FRMsoLfZjzeM9/aIHXWo+Q1KnNgVl5fTldYka07TYt4
         9CaBvFSp0UK2M07LaZZamAA1hZrDivviytnwt3+8jrYcqvqxMO/VN9ikgCbWlcgN586k
         T6ag==
X-Gm-Message-State: AOAM533g30OgNfkVfY6HjQLApI7fh+6knNofgDKh319l0OvfCVRZv7EA
        W+fCRKh3Ro7GYRxI4++PR/WOXpjCp4EZGaFLEIvS4yjWneGHrvaHM2CFa2SdJDm113o8/pYYRIu
        oo5JDS16FdNIsEO5p
X-Received: by 2002:a9d:70c4:: with SMTP id w4mr325772otj.170.1634748752452;
        Wed, 20 Oct 2021 09:52:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzzOgKbiWMKhtw+UeLQTUwrrEtd9Xc3Qa+N5PuSEeak8bCHKcZf74/kKQ1BBtuRTLElvLapVw==
X-Received: by 2002:a9d:70c4:: with SMTP id w4mr325733otj.170.1634748752197;
        Wed, 20 Oct 2021 09:52:32 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id bk8sm534452oib.57.2021.10.20.09.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 09:52:31 -0700 (PDT)
Date:   Wed, 20 Oct 2021 10:52:30 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>
Cc:     <bhelgaas@google.com>, <saeedm@nvidia.com>,
        <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>, <maorg@nvidia.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211020105230.524e2149.alex.williamson@redhat.com>
In-Reply-To: <5a496713-ae1d-11f2-1260-e4c1956e1eda@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
        <20211019105838.227569-13-yishaih@nvidia.com>
        <20211019124352.74c3b6ba.alex.williamson@redhat.com>
        <20211019192328.GZ2744544@nvidia.com>
        <20211019145856.2fa7f7c8.alex.williamson@redhat.com>
        <20211019230431.GA2744544@nvidia.com>
        <5a496713-ae1d-11f2-1260-e4c1956e1eda@nvidia.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Cc +dgilbert, +cohuck]

On Wed, 20 Oct 2021 11:28:04 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> On 10/20/2021 2:04 AM, Jason Gunthorpe wrote:
> > On Tue, Oct 19, 2021 at 02:58:56PM -0600, Alex Williamson wrote: =20
> >> I think that gives us this table:
> >>
> >> |   NDMA   | RESUMING |  SAVING  |  RUNNING |
> >> +----------+----------+----------+----------+ ---
> >> |     X    |     0    |     0    |     0    |  ^
> >> +----------+----------+----------+----------+  |
> >> |     0    |     0    |     0    |     1    |  |
> >> +----------+----------+----------+----------+  |
> >> |     X    |     0    |     1    |     0    |
> >> +----------+----------+----------+----------+  NDMA value is either co=
mpatible
> >> |     0    |     0    |     1    |     1    |  to existing behavior or=
 don't
> >> +----------+----------+----------+----------+  care due to redundancy =
vs
> >> |     X    |     1    |     0    |     0    |  !_RUNNING/INVALID/ERROR
> >> +----------+----------+----------+----------+
> >> |     X    |     1    |     0    |     1    |  |
> >> +----------+----------+----------+----------+  |
> >> |     X    |     1    |     1    |     0    |  |
> >> +----------+----------+----------+----------+  |
> >> |     X    |     1    |     1    |     1    |  v
> >> +----------+----------+----------+----------+ ---
> >> |     1    |     0    |     0    |     1    |  ^
> >> +----------+----------+----------+----------+  Desired new useful cases
> >> |     1    |     0    |     1    |     1    |  v
> >> +----------+----------+----------+----------+ ---
> >>
> >> Specifically, rows 1, 3, 5 with NDMA =3D 1 are valid states a user can
> >> set which are simply redundant to the NDMA =3D 0 cases. =20
> > It seems right
> > =20
> >> Row 6 remains invalid due to lack of support for pre-copy (_RESUMING
> >> | _RUNNING) and therefore cannot be set by userspace.  Rows 7 & 8
> >> are error states and cannot be set by userspace. =20
> > I wonder, did Yishai's series capture this row 6 restriction? Yishai? =
=20
>=20
>=20
> It seems so,=C2=A0 by using the below check which includes the=20
> !VFIO_DEVICE_STATE_VALID clause.
>=20
> if (old_state =3D=3D VFIO_DEVICE_STATE_ERROR ||
>  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 !VFIO_DEVICE_STATE_VALID(state) ||
>  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 (state & ~MLX5VF_SUPPORTED_DEVICE_=
STATES))
>  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return -EINVAL;
>=20
> Which is:
>=20
> #define VFIO_DEVICE_STATE_VALID(state) \
>  =C2=A0=C2=A0=C2=A0 (state & VFIO_DEVICE_STATE_RESUMING ? \
>  =C2=A0=C2=A0=C2=A0 (state & VFIO_DEVICE_STATE_MASK) =3D=3D VFIO_DEVICE_S=
TATE_RESUMING : 1)
>=20
> > =20
> >> Like other bits, setting the bit should be effective at the completion
> >> of writing device state.  Therefore the device would need to flush any
> >> outbound DMA queues before returning. =20
> > Yes, the device commands are expected to achieve this.
> > =20
> >> The question I was really trying to get to though is whether we have a
> >> supportable interface without such an extension.  There's currently
> >> only an experimental version of vfio migration support for PCI devices
> >> in QEMU (afaik), =20
> > If I recall this only matters if you have a VM that is causing
> > migratable devices to interact with each other. So long as the devices
> > are only interacting with the CPU this extra step is not strictly
> > needed.
> >
> > So, single device cases can be fine as-is
> >
> > IMHO the multi-device case the VMM should probably demand this support
> > from the migration drivers, otherwise it cannot know if it is safe for
> > sure.
> >
> > A config option to override the block if the admin knows there is no
> > use case to cause devices to interact - eg two NVMe devices without
> > CMB do not have a useful interaction.
> > =20
> >> so it seems like we could make use of the bus-master bit to fill
> >> this gap in QEMU currently, before we claim non-experimental
> >> support, but this new device agnostic extension would be required
> >> for non-PCI device support (and PCI support should adopt it as
> >> available).  Does that sound right?  Thanks, =20
> > I don't think the bus master support is really a substitute, tripping
> > bus master will stop DMA but it will not do so in a clean way and is
> > likely to be non-transparent to the VM's driver.
> >
> > The single-device-assigned case is a cleaner restriction, IMHO.
> >
> > Alternatively we can add the 4th bit and insist that migration drivers
> > support all the states. I'm just unsure what other HW can do, I get
> > the feeling people have been designing to the migration description in
> > the header file for a while and this is a new idea.

I'm wondering if we're imposing extra requirements on the !_RUNNING
state that don't need to be there.  For example, if we can assume that
all devices within a userspace context are !_RUNNING before any of the
devices begin to retrieve final state, then clearing of the _RUNNING
bit becomes the device quiesce point and the beginning of reading
device data is the point at which the device state is frozen and
serialized.  No new states required and essentially works with a slight
rearrangement of the callbacks in this series.  Why can't we do that?

Maybe a clarification of the uAPI spec is sufficient to achieve this,
ex. !_RUNNING devices may still update their internal state machine
based on external access.  Userspace is expected to quiesce all external
access prior to initiating the retrieval of the final device state from
the data section of the migration region.  Failure to do so may result
in inconsistent device state or optionally the device driver may induce
a fault if a quiescent state is not maintained.

> Just to be sure,
>=20
> We refer here to some future functionality support with this extra 4th=20
> bit but it doesn't enforce any change in the submitted code, right ?
>=20
> The below code uses the (state & ~MLX5VF_SUPPORTED_DEVICE_STATES) clause=
=20
> which fails any usage of a non-supported bit as of this one.
>=20
> if (old_state =3D=3D VFIO_DEVICE_STATE_ERROR ||
>  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 !VFIO_DEVICE_STATE_VALID(state) ||
>  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 (state & ~MLX5VF_SUPPORTED_DEVICE_=
STATES))
>  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return -EINVAL;

Correct, userspace shouldn't be setting any extra bits unless we
advertise support, such as via a capability or flag.  Drivers need to
continue to sanitize user input to validate yet-to-be-defined bits are
not accepted from userspace or else we risk not being able to define
them later without breaking userspace.  Thanks,

Alex

