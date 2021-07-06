Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D743BD781
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 15:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbhGFNQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 09:16:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53894 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231563AbhGFNQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 09:16:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625577259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A+vURWiwExzHKQ1zqn329GpoJ8uorhaLWw889D3KLCk=;
        b=TU2iM6Imqt1+5nnxGcjSw+++JzHS4c7U6pWq5EJuxZ4XnwX/wjPAFMqNxyDO59O0JXC2rx
        m7P5RtxlhTVFzP6OZ55rJj24BR4GwUymeE0zSP80E7hBFj7Pvssz3S5IZrL0ZVzo/xNqm9
        AJjArOgR/2NT3suCqJkgY2LbI+qDslI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-Rm8scm4zMfycpyJd6ld4yQ-1; Tue, 06 Jul 2021 09:14:15 -0400
X-MC-Unique: Rm8scm4zMfycpyJd6ld4yQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90CE7824F98;
        Tue,  6 Jul 2021 13:14:14 +0000 (UTC)
Received: from localhost (ovpn-115-23.ams2.redhat.com [10.36.115.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F3BF5DA60;
        Tue,  6 Jul 2021 13:14:10 +0000 (UTC)
Date:   Tue, 6 Jul 2021 14:14:09 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, xieyongji@bytedance.com
Subject: Re: [PATCH 1/2] vdpa: support per virtqueue max queue size
Message-ID: <YORXIS+WmDkX2DN7@stefanha-x1.localdomain>
References: <20210705071910.31965-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LaXrVM2vNYxuaCd2"
Content-Disposition: inline
In-Reply-To: <20210705071910.31965-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--LaXrVM2vNYxuaCd2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 05, 2021 at 03:19:09PM +0800, Jason Wang wrote:
> Virtio spec allows the device to specify the per virtqueue max queue
> size. vDPA needs to adapt to this flexibility. E.g Qemu advertise a
> small control virtqueue for virtio-net.
>=20
> So this patch adds a index parameter to get_vq_num_max bus operations
> for the device to report its per virtqueue max queue size.
>=20
> Both VHOST_VDPA_GET_VRING_NUM and VDPA_ATTR_DEV_MAX_VQ_SIZE assume a
> global maximum size. So we iterate all the virtqueues to return the
> minimal size in this case. Actually, the VHOST_VDPA_GET_VRING_NUM is
> not a must for the userspace. Userspace may choose to check the
> VHOST_SET_VRING_NUM for proving or validating the maximum virtqueue
> size. Anyway, we can invent a per vq version of
> VHOST_VDPA_GET_VRING_NUM in the future if it's necessary.
>=20
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vdpa/ifcvf/ifcvf_main.c   |  2 +-
>  drivers/vdpa/mlx5/net/mlx5_vnet.c |  2 +-
>  drivers/vdpa/vdpa.c               | 22 +++++++++++++++++++++-
>  drivers/vdpa/vdpa_sim/vdpa_sim.c  |  2 +-
>  drivers/vdpa/virtio_pci/vp_vdpa.c |  2 +-
>  drivers/vhost/vdpa.c              |  9 ++++++---
>  drivers/virtio/virtio_vdpa.c      |  2 +-
>  include/linux/vdpa.h              |  5 ++++-
>  8 files changed, 36 insertions(+), 10 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--LaXrVM2vNYxuaCd2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmDkVyEACgkQnKSrs4Gr
c8hTKggAp8tSQbbf8/pQa6Bi9ldcTpa4FzjzvITQFELFg45XJ9q4WDx+eNMxRTpe
IuvanLQoWiiQL2pYcUZCi/+PCGsj+bu44yJ24Uk9/cIWUbg+s8T+GLMxaNdEP8WO
52McfMT5MK+waHfnbhZ2jaNEGAdo5EVRBIF1Q/7vdg9Lfr0YxRtVuZ6EVuuncW5y
jETFKnKb0YdHpbO//gK/a7L6jLJEABTm0QQNK9OZnxnlbEuduUfeu8saUZSdDbWL
G/7TR55TF+CFd27T7gTA7WLcQszFk1tg1fTbdnDUpU/588L6Gy5+6CoCb+5+a6Ts
vdBRToz2iTg0KTFP/gYhTTQcxq7wmA==
=eXQg
-----END PGP SIGNATURE-----

--LaXrVM2vNYxuaCd2--

