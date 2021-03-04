Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA15332D49C
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 14:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241623AbhCDNvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 08:51:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60749 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241615AbhCDNvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 08:51:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614865813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8dKD6EMo2YP510AzFfioC+1u/tF8yICEAGoshmqfTsM=;
        b=Aj32o2n/kc8gt+sksaZNyZPW8ET25ijRMQ+132WUnRK0TWXhdkRSYRH2y16kgZXnrVoaat
        XvuYVjxHI5A8m3tI3u6QaT4Eg7fh++kOwCVT5VdTO/NWK3siKuxKfdmF8pJrcz26hrA7et
        fxHV5XF03xNXCDndqLgiDF9jNBjRSNg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-ZZNokqHgORCQ1jjP6EJ2mA-1; Thu, 04 Mar 2021 08:50:10 -0500
X-MC-Unique: ZZNokqHgORCQ1jjP6EJ2mA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1275874998;
        Thu,  4 Mar 2021 13:50:08 +0000 (UTC)
Received: from gondolin (ovpn-114-163.ams2.redhat.com [10.36.114.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A28D60244;
        Thu,  4 Mar 2021 13:50:03 +0000 (UTC)
Date:   Thu, 4 Mar 2021 14:50:00 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        virtio-dev@lists.oasis-open.org
Subject: Re: [virtio-dev] Re: [PATCH] vdpa/mlx5: set_features should allow
 reset to zero
Message-ID: <20210304145000.149706ae.cohuck@redhat.com>
In-Reply-To: <1b5b3f9b-41d7-795c-c677-c45f1d5a774e@redhat.com>
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
        <20210303092905.677eb66c.cohuck@redhat.com>
        <1b5b3f9b-41d7-795c-c677-c45f1d5a774e@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Mar 2021 16:24:16 +0800
Jason Wang <jasowang@redhat.com> wrote:

> On 2021/3/3 4:29 =E4=B8=8B=E5=8D=88, Cornelia Huck wrote:
> > On Wed, 3 Mar 2021 12:01:01 +0800
> > Jason Wang <jasowang@redhat.com> wrote:
> > =20
> >> On 2021/3/2 8:08 =E4=B8=8B=E5=8D=88, Cornelia Huck wrote: =20
> >>> On Mon, 1 Mar 2021 11:51:08 +0800
> >>> Jason Wang <jasowang@redhat.com> wrote:
> >>>    =20
> >>>> On 2021/3/1 5:25 =E4=B8=8A=E5=8D=88, Michael S. Tsirkin wrote: =20
> >>>>> On Fri, Feb 26, 2021 at 04:19:16PM +0800, Jason Wang wrote: =20
> >>>>>> On 2021/2/26 2:53 =E4=B8=8A=E5=8D=88, Michael S. Tsirkin wrote: =20
> >>>>>>> Confused. What is wrong with the above? It never reads the
> >>>>>>> field unless the feature has been offered by device. =20
> >>>>>> So the spec said:
> >>>>>>
> >>>>>> "
> >>>>>>
> >>>>>> The following driver-read-only field, max_virtqueue_pairs only exi=
sts if
> >>>>>> VIRTIO_NET_F_MQ is set.
> >>>>>>
> >>>>>> "
> >>>>>>
> >>>>>> If I read this correctly, there will be no max_virtqueue_pairs fie=
ld if the
> >>>>>> VIRTIO_NET_F_MQ is not offered by device? If yes the offsetof() vi=
olates
> >>>>>> what spec said.
> >>>>>>
> >>>>>> Thanks =20
> >>>>> I think that's a misunderstanding. This text was never intended to
> >>>>> imply that field offsets change beased on feature bits.
> >>>>> We had this pain with legacy and we never wanted to go back there.
> >>>>>
> >>>>> This merely implies that without VIRTIO_NET_F_MQ the field
> >>>>> should not be accessed. Exists in the sense "is accessible to drive=
r".
> >>>>>
> >>>>> Let's just clarify that in the spec, job done. =20
> >>>> Ok, agree. That will make things more eaiser. =20
> >>> Yes, that makes much more sense.
> >>>
> >>> What about adding the following to the "Basic Facilities of a Virtio
> >>> Device/Device Configuration Space" section of the spec:
> >>>
> >>> "If an optional configuration field does not exist, the corresponding
> >>> space is still present, but reserved." =20
> >>
> >> This became interesting after re-reading some of the qemu codes.
> >>
> >> E.g in virtio-net.c we had:
> >>
> >> *static VirtIOFeature feature_sizes[] =3D {
> >>   =C2=A0=C2=A0=C2=A0 {.flags =3D 1ULL << VIRTIO_NET_F_MAC,
> >>   =C2=A0=C2=A0=C2=A0=C2=A0 .end =3D endof(struct virtio_net_config, ma=
c)},
> >>   =C2=A0=C2=A0=C2=A0 {.flags =3D 1ULL << VIRTIO_NET_F_STATUS,
> >>   =C2=A0=C2=A0=C2=A0=C2=A0 .end =3D endof(struct virtio_net_config, st=
atus)},
> >>   =C2=A0=C2=A0=C2=A0 {.flags =3D 1ULL << VIRTIO_NET_F_MQ,
> >>   =C2=A0=C2=A0=C2=A0=C2=A0 .end =3D endof(struct virtio_net_config, ma=
x_virtqueue_pairs)},
> >>   =C2=A0=C2=A0=C2=A0 {.flags =3D 1ULL << VIRTIO_NET_F_MTU,
> >>   =C2=A0=C2=A0=C2=A0=C2=A0 .end =3D endof(struct virtio_net_config, mt=
u)},
> >>   =C2=A0=C2=A0=C2=A0 {.flags =3D 1ULL << VIRTIO_NET_F_SPEED_DUPLEX,
> >>   =C2=A0=C2=A0=C2=A0=C2=A0 .end =3D endof(struct virtio_net_config, du=
plex)},
> >>   =C2=A0=C2=A0=C2=A0 {.flags =3D (1ULL << VIRTIO_NET_F_RSS) | (1ULL <<
> >> VIRTIO_NET_F_HASH_REPORT),
> >>   =C2=A0=C2=A0=C2=A0=C2=A0 .end =3D endof(struct virtio_net_config, su=
pported_hash_types)},
> >>   =C2=A0=C2=A0=C2=A0 {}
> >> };*
> >>
> >> *It has a implict dependency chain. E.g MTU doesn't presnet if
> >> DUPLEX/RSS is not offered ...
> >> * =20
> > But I think it covers everything up to the relevant field, no? So MTU
> > is included if we have the feature bit, even if we don't have
> > DUPLEX/RSS.
> >
> > Given that a config space may be shorter (but must not collapse
> > non-existing fields), maybe a better wording would be:
> >
> > "If an optional configuration field does not exist, the corresponding
> > space will still be present if it is not at the end of the
> > configuration space (i.e., further configuration fields exist.) =20
>=20
>=20
> This should work but I think we need to define the end of configuration=20
> space first?

What about sidestepping this:

"...the corresponding space will still be present, unless no further
configuration fields exist."

?

>=20
> > This
> > implies that a given field, if it exists, is always at the same offset
> > from the beginning of the configuration space."

