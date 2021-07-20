Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F993CFA40
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236833AbhGTMcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 08:32:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35147 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235863AbhGTMcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 08:32:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626786776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9nf1v6P0JlGIoFjMRuRD5r+S7g6x4hJlGGenaSoSM68=;
        b=gfCoVMZNPnebUpRP/dSqQBz8IDAxy9zH/c1pvHvEPfy5lcUqTFuPmkR6NTIyunp84vKkm3
        QwtS6QJiFg3ScFSJOeWWOzNTn5szAPKVxWpKrFCkgt15TKtufI5IaVMFUoypQMMuMu8b4I
        jApv4mXk1ETzrt/68bE4jLp3MNFd0DQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-24-fR5MrqLFMlC5Xp2S6MrlEw-1; Tue, 20 Jul 2021 09:12:52 -0400
X-MC-Unique: fR5MrqLFMlC5Xp2S6MrlEw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A6F0100C660;
        Tue, 20 Jul 2021 13:12:51 +0000 (UTC)
Received: from localhost (ovpn-114-103.ams2.redhat.com [10.36.114.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 011C560C82;
        Tue, 20 Jul 2021 13:12:50 +0000 (UTC)
Date:   Tue, 20 Jul 2021 14:12:49 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Xianting Tian <xianting.tian@linux.alibaba.com>
Cc:     sgarzare@redhat.com, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vsock/virtio: set vsock frontend ready in
 virtio_vsock_probe()
Message-ID: <YPbL0QIgbAh/PBuC@stefanha-x1.localdomain>
References: <20210720071337.1995-1-xianting.tian@linux.alibaba.com>
 <YPakBTVDbgVcTGQX@stefanha-x1.localdomain>
 <b48bd02d-9514-ec0c-3779-fd5ddc5c2d3d@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ECpNC9XLSuXAI6rm"
Content-Disposition: inline
In-Reply-To: <b48bd02d-9514-ec0c-3779-fd5ddc5c2d3d@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ECpNC9XLSuXAI6rm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 20, 2021 at 07:05:39PM +0800, Xianting Tian wrote:
>=20
> =E5=9C=A8 2021/7/20 =E4=B8=8B=E5=8D=886:23, Stefan Hajnoczi =E5=86=99=E9=
=81=93:
> > On Tue, Jul 20, 2021 at 03:13:37PM +0800, Xianting Tian wrote:
> > > Add the missed virtio_device_ready() to set vsock frontend ready.
> > >=20
> > > Signed-off-by: Xianting Tian<xianting.tian@linux.alibaba.com>
> > > ---
> > >   net/vmw_vsock/virtio_transport.c | 2 ++
> > >   1 file changed, 2 insertions(+)
> > Please include a changelog when you send v2, v3, etc patches.
> OK, thanks.
> > > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_=
transport.c
> > > index e0c2c992a..dc834b8fd 100644
> > > --- a/net/vmw_vsock/virtio_transport.c
> > > +++ b/net/vmw_vsock/virtio_transport.c
> > > @@ -639,6 +639,8 @@ static int virtio_vsock_probe(struct virtio_devic=
e *vdev)
> > >   	mutex_unlock(&the_virtio_vsock_mutex);
> > > +	virtio_device_ready(vdev);
> > Why is this patch necessary?
>=20
> Sorry, I didn't notice the check in virtio_dev_probe(),
>=20
> As Jason comment,=C2=A0 I alsoe think we need to be consistent: switch to=
 use
> virtio_device_ready() for all the drivers. What's opinion about this?

According to the documentation the virtio_device_read() API is optional:

  /**
   * virtio_device_ready - enable vq use in probe function
   * @vdev: the device
   *
   * Driver must call this to use vqs in the probe function.
     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   *
   * Note: vqs are enabled automatically after probe returns.
     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   */

Many drivers do not use vqs during the ->probe() function. They don't
need to call virtio_device_ready(). That's why the virtio_vsock driver
doesn't call it.

But if a ->probe() function needs to send virtqueue buffers, e.g. to
query the device or activate some device feature, then the driver will
need to call it explicitly.

The documentation is clear and this design is less error-prone than
relying on all drivers to call it manually. I suggest leaving things
unchanged.

Stefan

--ECpNC9XLSuXAI6rm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmD2y9EACgkQnKSrs4Gr
c8jrqgf/S6HrkKdnFqfK+QSbiUl+UXuX9y6rWg6umKeM+V6GAOPrPw/+WZd1dM9Q
AdhHLvjaR4MNNIQj7Vm8gG7aBs4s0FO2QTH4atfH6E3bEOXBWn1sB+lduzEk87Bf
5Y/tUog1kjgiU0eTkwLAYgXs9D8dA7SkJunRPjM+prsdvYDdWo5ulpEiLsexjPSy
ye84Yg5CMWDTPCmk9yvcXBxAQaHu3jaZQChJsT72GgO4s11DgjLFqgWAMc/vs6X1
bYfP0oDKHQiJ7ag81nYxdyyNcUcf2xaX1tvfg54WwdM+oMP6vk6FqFOYuksvA8PP
Lj+uqiNg4gqv2n6SDm0v+mYH9g2QpA==
=I41d
-----END PGP SIGNATURE-----

--ECpNC9XLSuXAI6rm--

