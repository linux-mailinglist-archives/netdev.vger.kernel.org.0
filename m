Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18BA439DFD
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbhJYR6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:58:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42693 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232800AbhJYR6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 13:58:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635184539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8qY6kYMaRzmtdHH0RL+k6REiRSBMAcIJB16rtPRKrdY=;
        b=jUOhTW6S6+3f1Vhu8q/A9lgcQA8MoY4ISHC4tge8juchyHZhQBKJei6PNX09RnW9YSHnKF
        VoCyR3U2ZrWWjkGynM3qVCtKMC0pGry1r0HzLL5evTOxHOzv4GaRqAEWbVsmVb7oFJ7Lpz
        9BPvTesu6UfwVry6CynCSMnFx9qNCPs=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-5Pc7NI99Mgm1c0m7fFLvEw-1; Mon, 25 Oct 2021 13:55:38 -0400
X-MC-Unique: 5Pc7NI99Mgm1c0m7fFLvEw-1
Received: by mail-oo1-f69.google.com with SMTP id u11-20020a4a85cb000000b002b725ac13d8so4640690ooh.0
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 10:55:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8qY6kYMaRzmtdHH0RL+k6REiRSBMAcIJB16rtPRKrdY=;
        b=EA7jjOfvHqLNfy2f5p4LHMwmXDx7GnypRmLSwAMAc/tF0nab4XqAcmQfIvC5oqlIZP
         A54KCcMI2ayt5bTODcyaRof9dlIEVF7xFGCFgHnqMlll2aPjLg8D1Ou1KeeUmnUQJf6x
         oiAgJ1L44Z3UfJqOe8ASkfEtEDsiWNp5yWZuwg1DKnALtR5m1XH1iIwBQLfLVz2Mt1T9
         bV7pVFsdV54Q3vmK2gja1lb2GgvHQLWLSL4YdyWzvJu6RyjxKFNZi5lcfO3sFWUjndob
         g0MzD6xrniHDU+HhYggJXrZM+/w4OfP+75oVWIe2rV1UxAnj2yikK04y4B7X2nekGDQP
         /PMw==
X-Gm-Message-State: AOAM532YWjdslqq7kwInbu33B7kwlw3rS1kZD3O8kyQQhhqNiNIzQZHQ
        QtyG0IVwguQvguA6i/H5ooMpFuFncdCgidLXoTS8xCc/9vxvgJF+wpWpAXOtIkai2FX87O0Kt2B
        G4AHitv7avSDbvy74
X-Received: by 2002:aca:ebc7:: with SMTP id j190mr25018286oih.54.1635184537325;
        Mon, 25 Oct 2021 10:55:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJza3ag4zLU44DqyofbOXz5RjsC33dhdXMswjGRPcIo0uz8OZsitNLScoOUBWWV6ICy50Tsk8Q==
X-Received: by 2002:aca:ebc7:: with SMTP id j190mr25018241oih.54.1635184536961;
        Mon, 25 Oct 2021 10:55:36 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id y123sm3783863oie.0.2021.10.25.10.55.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 10:55:36 -0700 (PDT)
Date:   Mon, 25 Oct 2021 11:55:35 -0600
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
Message-ID: <20211025115535.49978053.alex.williamson@redhat.com>
In-Reply-To: <YXbceaVo0q6hOesg@work-vm>
References: <20211019105838.227569-1-yishaih@nvidia.com>
        <20211019105838.227569-13-yishaih@nvidia.com>
        <20211019124352.74c3b6ba.alex.williamson@redhat.com>
        <20211019192328.GZ2744544@nvidia.com>
        <20211019145856.2fa7f7c8.alex.williamson@redhat.com>
        <20211019230431.GA2744544@nvidia.com>
        <5a496713-ae1d-11f2-1260-e4c1956e1eda@nvidia.com>
        <20211020105230.524e2149.alex.williamson@redhat.com>
        <YXbceaVo0q6hOesg@work-vm>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Oct 2021 17:34:01 +0100
"Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:

> * Alex Williamson (alex.williamson@redhat.com) wrote:
> > [Cc +dgilbert, +cohuck]
> >=20
> > On Wed, 20 Oct 2021 11:28:04 +0300
> > Yishai Hadas <yishaih@nvidia.com> wrote:
> >  =20
> > > On 10/20/2021 2:04 AM, Jason Gunthorpe wrote: =20
> > > > On Tue, Oct 19, 2021 at 02:58:56PM -0600, Alex Williamson wrote:   =
=20
> > > >> I think that gives us this table:
> > > >>
> > > >> |   NDMA   | RESUMING |  SAVING  |  RUNNING |
> > > >> +----------+----------+----------+----------+ ---
> > > >> |     X    |     0    |     0    |     0    |  ^
> > > >> +----------+----------+----------+----------+  |
> > > >> |     0    |     0    |     0    |     1    |  |
> > > >> +----------+----------+----------+----------+  |
> > > >> |     X    |     0    |     1    |     0    |
> > > >> +----------+----------+----------+----------+  NDMA value is eithe=
r compatible
> > > >> |     0    |     0    |     1    |     1    |  to existing behavio=
r or don't
> > > >> +----------+----------+----------+----------+  care due to redunda=
ncy vs
> > > >> |     X    |     1    |     0    |     0    |  !_RUNNING/INVALID/E=
RROR
> > > >> +----------+----------+----------+----------+
> > > >> |     X    |     1    |     0    |     1    |  |
> > > >> +----------+----------+----------+----------+  |
> > > >> |     X    |     1    |     1    |     0    |  |
> > > >> +----------+----------+----------+----------+  |
> > > >> |     X    |     1    |     1    |     1    |  v
> > > >> +----------+----------+----------+----------+ ---
> > > >> |     1    |     0    |     0    |     1    |  ^
> > > >> +----------+----------+----------+----------+  Desired new useful =
cases
> > > >> |     1    |     0    |     1    |     1    |  v
> > > >> +----------+----------+----------+----------+ ---
> > > >>
> > > >> Specifically, rows 1, 3, 5 with NDMA =3D 1 are valid states a user=
 can
> > > >> set which are simply redundant to the NDMA =3D 0 cases.   =20
> > > > It seems right
> > > >   =20
> > > >> Row 6 remains invalid due to lack of support for pre-copy (_RESUMI=
NG
> > > >> | _RUNNING) and therefore cannot be set by userspace.  Rows 7 & 8
> > > >> are error states and cannot be set by userspace.   =20
> > > > I wonder, did Yishai's series capture this row 6 restriction? Yisha=
i?   =20
> > >=20
> > >=20
> > > It seems so,=C2=A0 by using the below check which includes the=20
> > > !VFIO_DEVICE_STATE_VALID clause.
> > >=20
> > > if (old_state =3D=3D VFIO_DEVICE_STATE_ERROR ||
> > >  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 !VFIO_DEVICE_STATE_VALID(state=
) ||
> > >  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 (state & ~MLX5VF_SUPPORTED_DEV=
ICE_STATES))
> > >  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 return -EINVAL;
> > >=20
> > > Which is:
> > >=20
> > > #define VFIO_DEVICE_STATE_VALID(state) \
> > >  =C2=A0=C2=A0=C2=A0 (state & VFIO_DEVICE_STATE_RESUMING ? \
> > >  =C2=A0=C2=A0=C2=A0 (state & VFIO_DEVICE_STATE_MASK) =3D=3D VFIO_DEVI=
CE_STATE_RESUMING : 1)
> > >  =20
> > > >   =20
> > > >> Like other bits, setting the bit should be effective at the comple=
tion
> > > >> of writing device state.  Therefore the device would need to flush=
 any
> > > >> outbound DMA queues before returning.   =20
> > > > Yes, the device commands are expected to achieve this.
> > > >   =20
> > > >> The question I was really trying to get to though is whether we ha=
ve a
> > > >> supportable interface without such an extension.  There's currently
> > > >> only an experimental version of vfio migration support for PCI dev=
ices
> > > >> in QEMU (afaik),   =20
> > > > If I recall this only matters if you have a VM that is causing
> > > > migratable devices to interact with each other. So long as the devi=
ces
> > > > are only interacting with the CPU this extra step is not strictly
> > > > needed.
> > > >
> > > > So, single device cases can be fine as-is
> > > >
> > > > IMHO the multi-device case the VMM should probably demand this supp=
ort
> > > > from the migration drivers, otherwise it cannot know if it is safe =
for
> > > > sure.
> > > >
> > > > A config option to override the block if the admin knows there is no
> > > > use case to cause devices to interact - eg two NVMe devices without
> > > > CMB do not have a useful interaction.
> > > >   =20
> > > >> so it seems like we could make use of the bus-master bit to fill
> > > >> this gap in QEMU currently, before we claim non-experimental
> > > >> support, but this new device agnostic extension would be required
> > > >> for non-PCI device support (and PCI support should adopt it as
> > > >> available).  Does that sound right?  Thanks,   =20
> > > > I don't think the bus master support is really a substitute, trippi=
ng
> > > > bus master will stop DMA but it will not do so in a clean way and is
> > > > likely to be non-transparent to the VM's driver.
> > > >
> > > > The single-device-assigned case is a cleaner restriction, IMHO.
> > > >
> > > > Alternatively we can add the 4th bit and insist that migration driv=
ers
> > > > support all the states. I'm just unsure what other HW can do, I get
> > > > the feeling people have been designing to the migration description=
 in
> > > > the header file for a while and this is a new idea. =20
> >=20
> > I'm wondering if we're imposing extra requirements on the !_RUNNING
> > state that don't need to be there.  For example, if we can assume that
> > all devices within a userspace context are !_RUNNING before any of the
> > devices begin to retrieve final state, then clearing of the _RUNNING
> > bit becomes the device quiesce point and the beginning of reading
> > device data is the point at which the device state is frozen and
> > serialized.  No new states required and essentially works with a slight
> > rearrangement of the callbacks in this series.  Why can't we do that? =
=20
>=20
> So without me actually understanding your bit encodings that closely, I
> think the problem is we have to asusme that any transition takes time.
> From the QEMU point of view I think the requirement is when we stop the
> machine (vm_stop_force_state(RUN_STATE_FINISH_MIGRATE) in
> migration_completion) that at the point that call returns (with no
> error) all devices are idle.  That means you need a way to command the
> device to go into the stopped state, and probably another to make sure
> it's got there.

In a way.  We're essentially recognizing that we cannot stop a single
device in isolation of others that might participate in peer-to-peer
DMA with that device, so we need to make a pass to quiesce each device
before we can ask the device to fully stop.  This new device state bit
is meant to be that quiescent point, devices can accept incoming DMA
but should cease to generate any.  Once all device are quiesced then we
can safely stop them.

> Now, you could be a *little* more sloppy; you could allow a device carry
> on doing stuff purely with it's own internal state up until the point
> it needs to serialise; but that would have to be strictly internal state
> only - if it can change any other devices state (or issue an interrupt,
> change RAM etc) then you get into ordering issues on the serialisation
> of multiple devices.

Yep, that's the proposal that doesn't require a uAPI change, we loosen
the definition of stopped to mean the device can no longer generate DMA
or interrupts and all internal processing outside or responding to
incoming DMA should halt (essentially the same as the new quiescent
state above).  Once all devices are in this state, there should be no
incoming DMA and we can safely collect per device migration data.  If
state changes occur beyond the point in time where userspace has
initiated the collection of migration data, drivers have options for
generating errors when userspace consumes that data.

AFAICT, the two approaches are equally valid.  If we modify the uAPI to
include this new quiescent state then userspace needs to make some hard
choices about what configurations they support without such a feature.
The majority of configurations are likely not exercising p2p between
assigned devices, but the hypervisor can't know that.  If we work
within the existing uAPI, well there aren't any open source driver
implementations yet anyway and any non-upstream implementations would
need to be updated for this clarification.  Existing userspace works
better with no change, so long as they already follow the guideline
that all devices in the userspace context must be stopped before the
migration data of any device can be considered valid.  Thanks,

Alex

