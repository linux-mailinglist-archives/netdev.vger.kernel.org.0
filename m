Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175AB3CF7CC
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 12:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237255AbhGTJmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 05:42:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58951 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236994AbhGTJm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 05:42:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626776586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0iPodRufSETNQrJRGnp/ZOuGSC+uwy2pniQGdvVYYmA=;
        b=WjKSliuBu2EfrYh1nbGZUxU44ZGwJPYYwMjzqsLOVM9sHrLtoLX9LFU/k9fCh1XpdU40co
        5arMqgXwmoOszfgEsrJMsfTWSdwZuVQKQoCQre4LvTdfx/o4iyuLZJD8/UpBOvyNJevUhZ
        B6FTBxrUu0n4IE5a+T/EK0D9NiiQH0s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-YYu-6614O9CnRxBcJZSo9w-1; Tue, 20 Jul 2021 06:23:05 -0400
X-MC-Unique: YYu-6614O9CnRxBcJZSo9w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3C8E10168C7;
        Tue, 20 Jul 2021 10:23:03 +0000 (UTC)
Received: from localhost (ovpn-114-103.ams2.redhat.com [10.36.114.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3270C19C44;
        Tue, 20 Jul 2021 10:23:02 +0000 (UTC)
Date:   Tue, 20 Jul 2021 11:23:01 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Xianting Tian <xianting.tian@linux.alibaba.com>
Cc:     sgarzare@redhat.com, davem@davemloft.net, kuba@kernel.org,
        jasowang@redhat.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] vsock/virtio: set vsock frontend ready in
 virtio_vsock_probe()
Message-ID: <YPakBTVDbgVcTGQX@stefanha-x1.localdomain>
References: <20210720071337.1995-1-xianting.tian@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iV/3jVzEG68fDxrj"
Content-Disposition: inline
In-Reply-To: <20210720071337.1995-1-xianting.tian@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--iV/3jVzEG68fDxrj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 20, 2021 at 03:13:37PM +0800, Xianting Tian wrote:
> Add the missed virtio_device_ready() to set vsock frontend ready.
>=20
> Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
> ---
>  net/vmw_vsock/virtio_transport.c | 2 ++
>  1 file changed, 2 insertions(+)

Please include a changelog when you send v2, v3, etc patches.

>=20
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_tran=
sport.c
> index e0c2c992a..dc834b8fd 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -639,6 +639,8 @@ static int virtio_vsock_probe(struct virtio_device *v=
dev)
> =20
>  	mutex_unlock(&the_virtio_vsock_mutex);
> =20
> +	virtio_device_ready(vdev);

Why is this patch necessary?

The core virtio_dev_probe() code already calls virtio_device_ready for
us:

  static int virtio_dev_probe(struct device *_d)
  {
      ...
      err =3D drv->probe(dev);
      if (err)
          goto err;
 =20
      /* If probe didn't do it, mark device DRIVER_OK ourselves. */
      if (!(dev->config->get_status(dev) & VIRTIO_CONFIG_S_DRIVER_OK))
          virtio_device_ready(dev);

--iV/3jVzEG68fDxrj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmD2pAUACgkQnKSrs4Gr
c8jc0Qf/Wyv2LMSeCMqTH4Pu6GgszqoO03KHkzbyezjDhTXQiVOdXpF1rWGphdt8
/jTn7b4QGKRy0y6TQr6dtOvqjkecS45X8Nf3/x/HzXq34Y53vzV+KQ1mf9Z53SWu
BT2wBWYx19H4A9cpOI3dLsenvTipLGJPZioZWDfrXSEDgq5kExyuH+zm9ts5kZ61
QK4JoWYNnT33aH48qXZIX4W1jbPjmvF+oHbXWJIHtGOTBVX9u9xkgzBSQfB6NjPv
uCInNr/9IB+Dmo+G2ssqdl9Z4m9e3n1fr/7zRXOfktw/zREzRW3gXgqk+1IK7TTz
M03B5+fe87wBKISJqJWEpMCA3LyR0w==
=vs5c
-----END PGP SIGNATURE-----

--iV/3jVzEG68fDxrj--

