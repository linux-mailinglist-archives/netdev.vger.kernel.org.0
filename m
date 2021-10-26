Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B9F43B425
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236652AbhJZOcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:32:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55833 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236622AbhJZOcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 10:32:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635258571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2kYAPX2VGBsH1X6cP0RtYj20ucdCaNWXLNB7+ktwG10=;
        b=ILorWgMfQoZfwMguHfh4enTI52Gd9n9yJmX+xBbgqjmAAz+r4fPrsnD/b2rk25TvyuwV4X
        fE3skZIlZwj1zAsMPYycNBZc5R27ZT2fuF8FFTrSumsncHhv2yGFZYQI2aawKRw4/RKKxj
        uEZlB6Dg+yOqYDl0yTchOdHlnuIbcvQ=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-7j03rpOEMeGwm6l-XE37Vg-1; Tue, 26 Oct 2021 10:29:25 -0400
X-MC-Unique: 7j03rpOEMeGwm6l-XE37Vg-1
Received: by mail-ot1-f70.google.com with SMTP id z29-20020a9d469d000000b00552d85e0e0fso9167188ote.5
        for <netdev@vger.kernel.org>; Tue, 26 Oct 2021 07:29:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2kYAPX2VGBsH1X6cP0RtYj20ucdCaNWXLNB7+ktwG10=;
        b=m+yblCPAAl/janEkV36A0IRBjoefTcBKpdySP4ZJMAz1FLXjpXdl5rk1t3yTs0vfVx
         fvVqHQODB5DpX7SdpnycnutDC7L0gBSBSXMuXoIo1L2OHZfIVsee6uuhDO4MzRRZs5yI
         3iN+dfVzo4UyZAGqAyIUIn3y9Y40wMhNGdPTh8fRVrlxgTaJ5WfV428CCVePgE1NV2BH
         EK3MAo6DBH/aKGb3XrU3PQCsGw1BWxopbR3KU1KQupcbUfYsEsSTH9scWwa3HVJD72VP
         bA+O1ZD6QwldLYschxUK8phw0ssYgEtSkBFsmFR/WrwFq8M7I2e0m16W4itkgt6DPs1f
         poeQ==
X-Gm-Message-State: AOAM530MuEa5vf4erAKHXgRDKzH3d1kfRoiAPnv68pVqyyA2kadCfx+b
        2PXTWWHsphLOMSNBKrRFE91+9SskO+cOI+Yi4VDr/ulMOYWimW80vb+K/UM+m7tEXt/R7un8Cxh
        aNvLQYi2mNYpOaKFF
X-Received: by 2002:a05:6830:142:: with SMTP id j2mr19958161otp.252.1635258563320;
        Tue, 26 Oct 2021 07:29:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxG4KUMnqa1iY9x1BOCXowMXBHg3LGdshyNNXldXqNcmbfhcg/JpKs4aVIrfaxlvz4ZhAYNFg==
X-Received: by 2002:a05:6830:142:: with SMTP id j2mr19958135otp.252.1635258562996;
        Tue, 26 Oct 2021 07:29:22 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id v24sm3822218oou.45.2021.10.26.07.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 07:29:22 -0700 (PDT)
Date:   Tue, 26 Oct 2021 08:29:20 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211026082920.1f302a45.alex.williamson@redhat.com>
In-Reply-To: <YXb7wejD1qckNrhC@work-vm>
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
        <YXb7wejD1qckNrhC@work-vm>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Oct 2021 19:47:29 +0100
"Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:

> * Alex Williamson (alex.williamson@redhat.com) wrote:
> > On Mon, 25 Oct 2021 17:34:01 +0100
> > "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
> >  =20
> > > * Alex Williamson (alex.williamson@redhat.com) wrote: =20
> > > > [Cc +dgilbert, +cohuck]
> > > >=20
> > > > On Wed, 20 Oct 2021 11:28:04 +0300
> > > > Yishai Hadas <yishaih@nvidia.com> wrote:
> > > >    =20
> > > > > On 10/20/2021 2:04 AM, Jason Gunthorpe wrote:   =20
> > > > > > On Tue, Oct 19, 2021 at 02:58:56PM -0600, Alex Williamson wrote=
:     =20
> > > > > >> I think that gives us this table:
> > > > > >>
> > > > > >> |   NDMA   | RESUMING |  SAVING  |  RUNNING |
> > > > > >> +----------+----------+----------+----------+ ---
> > > > > >> |     X    |     0    |     0    |     0    |  ^
> > > > > >> +----------+----------+----------+----------+  |
> > > > > >> |     0    |     0    |     0    |     1    |  |
> > > > > >> +----------+----------+----------+----------+  |
> > > > > >> |     X    |     0    |     1    |     0    |
> > > > > >> +----------+----------+----------+----------+  NDMA value is e=
ither compatible
> > > > > >> |     0    |     0    |     1    |     1    |  to existing beh=
avior or don't
> > > > > >> +----------+----------+----------+----------+  care due to red=
undancy vs
> > > > > >> |     X    |     1    |     0    |     0    |  !_RUNNING/INVAL=
ID/ERROR
> > > > > >> +----------+----------+----------+----------+
> > > > > >> |     X    |     1    |     0    |     1    |  |
> > > > > >> +----------+----------+----------+----------+  |
> > > > > >> |     X    |     1    |     1    |     0    |  |
> > > > > >> +----------+----------+----------+----------+  |
> > > > > >> |     X    |     1    |     1    |     1    |  v
> > > > > >> +----------+----------+----------+----------+ ---
> > > > > >> |     1    |     0    |     0    |     1    |  ^
> > > > > >> +----------+----------+----------+----------+  Desired new use=
ful cases
> > > > > >> |     1    |     0    |     1    |     1    |  v
> > > > > >> +----------+----------+----------+----------+ ---
> > > > > >>
> > > > > >> Specifically, rows 1, 3, 5 with NDMA =3D 1 are valid states a =
user can
> > > > > >> set which are simply redundant to the NDMA =3D 0 cases.     =20
> > > > > > It seems right
> > > > > >     =20
> > > > > >> Row 6 remains invalid due to lack of support for pre-copy (_RE=
SUMING
> > > > > >> | _RUNNING) and therefore cannot be set by userspace.  Rows 7 =
& 8
> > > > > >> are error states and cannot be set by userspace.     =20
> > > > > > I wonder, did Yishai's series capture this row 6 restriction? Y=
ishai?     =20
> > > > >=20
> > > > >=20
> > > > > It seems so,=C2=A0 by using the below check which includes the=20
> > > > > !VFIO_DEVICE_STATE_VALID clause.
> > > > >=20
> > > > > if (old_state =3D=3D VFIO_DEVICE_STATE_ERROR ||
> > > > >  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 !VFIO_DEVICE_STATE_VALID(s=
tate) ||
> > > > >  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 (state & ~MLX5VF_SUPPORTED=
_DEVICE_STATES))
> > > > >  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return -EINVAL;
> > > > >=20
> > > > > Which is:
> > > > >=20
> > > > > #define VFIO_DEVICE_STATE_VALID(state) \
> > > > >  =C2=A0=C2=A0=C2=A0 (state & VFIO_DEVICE_STATE_RESUMING ? \
> > > > >  =C2=A0=C2=A0=C2=A0 (state & VFIO_DEVICE_STATE_MASK) =3D=3D VFIO_=
DEVICE_STATE_RESUMING : 1)
> > > > >    =20
> > > > > >     =20
> > > > > >> Like other bits, setting the bit should be effective at the co=
mpletion
> > > > > >> of writing device state.  Therefore the device would need to f=
lush any
> > > > > >> outbound DMA queues before returning.     =20
> > > > > > Yes, the device commands are expected to achieve this.
> > > > > >     =20
> > > > > >> The question I was really trying to get to though is whether w=
e have a
> > > > > >> supportable interface without such an extension.  There's curr=
ently
> > > > > >> only an experimental version of vfio migration support for PCI=
 devices
> > > > > >> in QEMU (afaik),     =20
> > > > > > If I recall this only matters if you have a VM that is causing
> > > > > > migratable devices to interact with each other. So long as the =
devices
> > > > > > are only interacting with the CPU this extra step is not strict=
ly
> > > > > > needed.
> > > > > >
> > > > > > So, single device cases can be fine as-is
> > > > > >
> > > > > > IMHO the multi-device case the VMM should probably demand this =
support
> > > > > > from the migration drivers, otherwise it cannot know if it is s=
afe for
> > > > > > sure.
> > > > > >
> > > > > > A config option to override the block if the admin knows there =
is no
> > > > > > use case to cause devices to interact - eg two NVMe devices wit=
hout
> > > > > > CMB do not have a useful interaction.
> > > > > >     =20
> > > > > >> so it seems like we could make use of the bus-master bit to fi=
ll
> > > > > >> this gap in QEMU currently, before we claim non-experimental
> > > > > >> support, but this new device agnostic extension would be requi=
red
> > > > > >> for non-PCI device support (and PCI support should adopt it as
> > > > > >> available).  Does that sound right?  Thanks,     =20
> > > > > > I don't think the bus master support is really a substitute, tr=
ipping
> > > > > > bus master will stop DMA but it will not do so in a clean way a=
nd is
> > > > > > likely to be non-transparent to the VM's driver.
> > > > > >
> > > > > > The single-device-assigned case is a cleaner restriction, IMHO.
> > > > > >
> > > > > > Alternatively we can add the 4th bit and insist that migration =
drivers
> > > > > > support all the states. I'm just unsure what other HW can do, I=
 get
> > > > > > the feeling people have been designing to the migration descrip=
tion in
> > > > > > the header file for a while and this is a new idea.   =20
> > > >=20
> > > > I'm wondering if we're imposing extra requirements on the !_RUNNING
> > > > state that don't need to be there.  For example, if we can assume t=
hat
> > > > all devices within a userspace context are !_RUNNING before any of =
the
> > > > devices begin to retrieve final state, then clearing of the _RUNNING
> > > > bit becomes the device quiesce point and the beginning of reading
> > > > device data is the point at which the device state is frozen and
> > > > serialized.  No new states required and essentially works with a sl=
ight
> > > > rearrangement of the callbacks in this series.  Why can't we do tha=
t?   =20
> > >=20
> > > So without me actually understanding your bit encodings that closely,=
 I
> > > think the problem is we have to asusme that any transition takes time.
> > > From the QEMU point of view I think the requirement is when we stop t=
he
> > > machine (vm_stop_force_state(RUN_STATE_FINISH_MIGRATE) in
> > > migration_completion) that at the point that call returns (with no
> > > error) all devices are idle.  That means you need a way to command the
> > > device to go into the stopped state, and probably another to make sure
> > > it's got there. =20
> >=20
> > In a way.  We're essentially recognizing that we cannot stop a single
> > device in isolation of others that might participate in peer-to-peer
> > DMA with that device, so we need to make a pass to quiesce each device
> > before we can ask the device to fully stop.  This new device state bit
> > is meant to be that quiescent point, devices can accept incoming DMA
> > but should cease to generate any.  Once all device are quiesced then we
> > can safely stop them. =20
>=20
> It may need some further refinement; for example in that quiesed state
> do counters still tick? will a NIC still respond to packets that don't
> get forwarded to the host?

I'd think no, but I imagine it's largely device specific to what extent
a device can be fully halted yet minimally handle incoming DMA.
=20
> Note I still think you need a way to know when you have actually reached
> these states; setting a bit in a register is asking nicely for a device
> to go into a state - has it got there?

It's more than asking nicely, we define the device_state bits as
synchronous, the device needs to enter the state before returning from
the write operation or return an errno.

> > > Now, you could be a *little* more sloppy; you could allow a device ca=
rry
> > > on doing stuff purely with it's own internal state up until the point
> > > it needs to serialise; but that would have to be strictly internal st=
ate
> > > only - if it can change any other devices state (or issue an interrup=
t,
> > > change RAM etc) then you get into ordering issues on the serialisation
> > > of multiple devices. =20
> >=20
> > Yep, that's the proposal that doesn't require a uAPI change, we loosen
> > the definition of stopped to mean the device can no longer generate DMA
> > or interrupts and all internal processing outside or responding to
> > incoming DMA should halt (essentially the same as the new quiescent
> > state above).  Once all devices are in this state, there should be no
> > incoming DMA and we can safely collect per device migration data.  If
> > state changes occur beyond the point in time where userspace has
> > initiated the collection of migration data, drivers have options for
> > generating errors when userspace consumes that data. =20
>=20
> How do you know that last device has actually gone into that state?

Each device cannot, the burden is on the user to make sure all devices
are stopped before proceeding to read migration data.

> Also be careful; it feels much more delicate where something might
> accidentally start a transaction.

This sounds like a discussion of theoretically broken drivers.  Like
the above device_state, drivers still have a synchronization point when
the user reads the pending_bytes field to initiate retrieving the
device state.  If the implementation requires the device to be fully
stopped to snapshot the device state to provide to the user, this is
where that would happen.  Thanks,

Alex

