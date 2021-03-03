Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F3332C432
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382366AbhCDALm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:11:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22874 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349849AbhCCLfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 06:35:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614771241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YtKbwEmP7H421NTmXaZCzpu8hrW/nWzRy135iMLmxUk=;
        b=PPCfze3K91eoAHI8BBp0MHOo4qAQiWSmipQR6dhhaxKp0Hn6j5ux9ehA+ayM09OZh8U22o
        KxIBoNgZCWQ/7MvE+jvj3QKGZCYqeQjtPkSJ2mUkIjWyPBokefUX+Eo9JLaTF/YVq5P6zz
        d+bp/F6R10kp0hQdn0nY0styeS25xZw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-Qzbk6FMePyuxAZzVB2-Njw-1; Wed, 03 Mar 2021 03:29:16 -0500
X-MC-Unique: Qzbk6FMePyuxAZzVB2-Njw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93B7D80196C;
        Wed,  3 Mar 2021 08:29:14 +0000 (UTC)
Received: from gondolin (ovpn-113-85.ams2.redhat.com [10.36.113.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED0395C257;
        Wed,  3 Mar 2021 08:29:07 +0000 (UTC)
Date:   Wed, 3 Mar 2021 09:29:05 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        virtio-dev@lists.oasis-open.org
Subject: Re: [virtio-dev] Re: [PATCH] vdpa/mlx5: set_features should allow
 reset to zero
Message-ID: <20210303092905.677eb66c.cohuck@redhat.com>
In-Reply-To: <5f6972fe-7246-b622-958d-9cab8dd98e21@redhat.com>
References: <20210223041740-mutt-send-email-mst@kernel.org>
        <788a0880-0a68-20b7-5bdf-f8150b08276a@redhat.com>
        <20210223110430.2f098bc0.cohuck@redhat.com>
        <bbb0a09e-17e1-a397-1b64-6ce9afe18e44@redhat.com>
        <20210223115833.732d809c.cohuck@redhat.com>
        <8355f9b3-4cda-cd2e-98df-fed020193008@redhat.com>
        <20210224121234.0127ae4b.cohuck@redhat.com>
        <be6713d3-ac98-bbbf-1dc1-a003ed06a156@redhat.com>
        <20210225135229-mutt-send-email-mst@kernel.org>
        <0f8eb381-cc98-9e05-0e35-ccdb1cbd6119@redhat.com>
        <20210228162306-mutt-send-email-mst@kernel.org>
        <cdd72199-ac7b-cc8d-2c40-81e43162c532@redhat.com>
        <20210302130812.6227f176.cohuck@redhat.com>
        <5f6972fe-7246-b622-958d-9cab8dd98e21@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Mar 2021 12:01:01 +0800
Jason Wang <jasowang@redhat.com> wrote:

> On 2021/3/2 8:08 =E4=B8=8B=E5=8D=88, Cornelia Huck wrote:
> > On Mon, 1 Mar 2021 11:51:08 +0800
> > Jason Wang <jasowang@redhat.com> wrote:
> > =20
> >> On 2021/3/1 5:25 =E4=B8=8A=E5=8D=88, Michael S. Tsirkin wrote: =20
> >>> On Fri, Feb 26, 2021 at 04:19:16PM +0800, Jason Wang wrote: =20
> >>>> On 2021/2/26 2:53 =E4=B8=8A=E5=8D=88, Michael S. Tsirkin wrote: =20
> >>>>> Confused. What is wrong with the above? It never reads the
> >>>>> field unless the feature has been offered by device. =20
> >>>> So the spec said:
> >>>>
> >>>> "
> >>>>
> >>>> The following driver-read-only field, max_virtqueue_pairs only exist=
s if
> >>>> VIRTIO_NET_F_MQ is set.
> >>>>
> >>>> "
> >>>>
> >>>> If I read this correctly, there will be no max_virtqueue_pairs field=
 if the
> >>>> VIRTIO_NET_F_MQ is not offered by device? If yes the offsetof() viol=
ates
> >>>> what spec said.
> >>>>
> >>>> Thanks =20
> >>> I think that's a misunderstanding. This text was never intended to
> >>> imply that field offsets change beased on feature bits.
> >>> We had this pain with legacy and we never wanted to go back there.
> >>>
> >>> This merely implies that without VIRTIO_NET_F_MQ the field
> >>> should not be accessed. Exists in the sense "is accessible to driver".
> >>>
> >>> Let's just clarify that in the spec, job done. =20
> >>
> >> Ok, agree. That will make things more eaiser. =20
> > Yes, that makes much more sense.
> >
> > What about adding the following to the "Basic Facilities of a Virtio
> > Device/Device Configuration Space" section of the spec:
> >
> > "If an optional configuration field does not exist, the corresponding
> > space is still present, but reserved." =20
>=20
>=20
> This became interesting after re-reading some of the qemu codes.
>=20
> E.g in virtio-net.c we had:
>=20
> *static VirtIOFeature feature_sizes[] =3D {
>  =C2=A0=C2=A0=C2=A0 {.flags =3D 1ULL << VIRTIO_NET_F_MAC,
>  =C2=A0=C2=A0=C2=A0=C2=A0 .end =3D endof(struct virtio_net_config, mac)},
>  =C2=A0=C2=A0=C2=A0 {.flags =3D 1ULL << VIRTIO_NET_F_STATUS,
>  =C2=A0=C2=A0=C2=A0=C2=A0 .end =3D endof(struct virtio_net_config, status=
)},
>  =C2=A0=C2=A0=C2=A0 {.flags =3D 1ULL << VIRTIO_NET_F_MQ,
>  =C2=A0=C2=A0=C2=A0=C2=A0 .end =3D endof(struct virtio_net_config, max_vi=
rtqueue_pairs)},
>  =C2=A0=C2=A0=C2=A0 {.flags =3D 1ULL << VIRTIO_NET_F_MTU,
>  =C2=A0=C2=A0=C2=A0=C2=A0 .end =3D endof(struct virtio_net_config, mtu)},
>  =C2=A0=C2=A0=C2=A0 {.flags =3D 1ULL << VIRTIO_NET_F_SPEED_DUPLEX,
>  =C2=A0=C2=A0=C2=A0=C2=A0 .end =3D endof(struct virtio_net_config, duplex=
)},
>  =C2=A0=C2=A0=C2=A0 {.flags =3D (1ULL << VIRTIO_NET_F_RSS) | (1ULL <<=20
> VIRTIO_NET_F_HASH_REPORT),
>  =C2=A0=C2=A0=C2=A0=C2=A0 .end =3D endof(struct virtio_net_config, suppor=
ted_hash_types)},
>  =C2=A0=C2=A0=C2=A0 {}
> };*
>=20
> *It has a implict dependency chain. E.g MTU doesn't presnet if=20
> DUPLEX/RSS is not offered ...
> *

But I think it covers everything up to the relevant field, no? So MTU
is included if we have the feature bit, even if we don't have
DUPLEX/RSS.

Given that a config space may be shorter (but must not collapse
non-existing fields), maybe a better wording would be:

"If an optional configuration field does not exist, the corresponding
space will still be present if it is not at the end of the
configuration space (i.e., further configuration fields exist.) This
implies that a given field, if it exists, is always at the same offset
from the beginning of the configuration space."


> >
> > (Do we need to specify what a device needs to do if the driver tries to
> > access a non-existing field? We cannot really make assumptions about
> > config space accesses; virtio-ccw can just copy a chunk of config space
> > that contains non-existing fields... =20
>=20
>=20
> Right, it looks to me ccw doesn't depends on config len which is kind of=
=20
> interesting. I think the answer depends on the implementation of both=20
> transport and device:

(virtio-ccw is a bit odd, because channel I/O does not have the concept
of a config space and I needed to come up with something)

>=20
> Let's take virtio-net-pci as an example, it fills status unconditionally=
=20
> in virtio_net_set_config() even if VIRTIO_NET_F_STATUS is not=20
> negotiated. So with the above feature_sizes:
>=20
> 1) if one of the MQ, MTU, DUPLEX or RSS is implemented, driver can still=
=20
> read status in this case
> 2) if none of the above four is negotied, driver can only read a 0xFF=20
> (virtio_config_readb())
>=20
>=20
> > I guess the device could ignore
> > writes and return zeroes on read?) =20
>=20
>=20
> So consider the above, it might be too late to fix/clarify that in the=20
> spec on the expected behaviour of reading/writing non-exist fields.

We could still advise behaviour via SHOULD, though I'm not sure it adds
much at this point in time.

It really feels a bit odd that a driver can still read and write fields
for features that it did not negotiate, but I fear we're stuck with it.

>=20
> Thanks
>=20
>=20
> >
> > I've opened https://github.com/oasis-tcs/virtio-spec/issues/98 for the
> > spec issues.
> > =20

