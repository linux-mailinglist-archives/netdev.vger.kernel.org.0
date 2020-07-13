Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02ED521D2C5
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 11:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729218AbgGMJ2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 05:28:49 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27292 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726380AbgGMJ2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 05:28:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594632527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P+elYLgq2j5qUQKLLEoBv4e9Ba57OCTVDx1n9MkHwGc=;
        b=Shu73sr1Ai4RiNhJTbavFg9vCUiYk4KN3C2ONoNz0PeeV4QgzMJZcui+02mLg8YhZyAaGR
        7P1cuEEVcGspfE6i3EDUvtU9COxrBkP/fhOOFNxqBhY6MCau5V9tkZJ+XHHIl28SCtXW6+
        E/bZLZomk4MtsiteAgyVL/+hixGbx9M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-FwrGlKyLNL-IwTkG1UdoMw-1; Mon, 13 Jul 2020 05:28:45 -0400
X-MC-Unique: FwrGlKyLNL-IwTkG1UdoMw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 085F51080;
        Mon, 13 Jul 2020 09:28:44 +0000 (UTC)
Received: from localhost (ovpn-114-66.ams2.redhat.com [10.36.114.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3B3D74F44;
        Mon, 13 Jul 2020 09:28:40 +0000 (UTC)
Date:   Mon, 13 Jul 2020 10:28:39 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     davem@davemloft.net, virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH] vsock/virtio: annotate 'the_virtio_vsock' RCU pointer
Message-ID: <20200713092839.GD28639@stefanha-x1.localdomain>
References: <20200710121243.120096-1-sgarzare@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20200710121243.120096-1-sgarzare@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YToU2i3Vx8H2dn7O"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--YToU2i3Vx8H2dn7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 10, 2020 at 02:12:43PM +0200, Stefano Garzarella wrote:
> Commit 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free
> on the_virtio_vsock") starts to use RCU to protect 'the_virtio_vsock'
> pointer, but we forgot to annotate it.
>=20
> This patch adds the annotation to fix the following sparse errors:
>=20
>     net/vmw_vsock/virtio_transport.c:73:17: error: incompatible types in =
comparison expression (different address spaces):
>     net/vmw_vsock/virtio_transport.c:73:17:    struct virtio_vsock [noder=
ef] __rcu *
>     net/vmw_vsock/virtio_transport.c:73:17:    struct virtio_vsock *
>     net/vmw_vsock/virtio_transport.c:171:17: error: incompatible types in=
 comparison expression (different address spaces):
>     net/vmw_vsock/virtio_transport.c:171:17:    struct virtio_vsock [node=
ref] __rcu *
>     net/vmw_vsock/virtio_transport.c:171:17:    struct virtio_vsock *
>     net/vmw_vsock/virtio_transport.c:207:17: error: incompatible types in=
 comparison expression (different address spaces):
>     net/vmw_vsock/virtio_transport.c:207:17:    struct virtio_vsock [node=
ref] __rcu *
>     net/vmw_vsock/virtio_transport.c:207:17:    struct virtio_vsock *
>     net/vmw_vsock/virtio_transport.c:561:13: error: incompatible types in=
 comparison expression (different address spaces):
>     net/vmw_vsock/virtio_transport.c:561:13:    struct virtio_vsock [node=
ref] __rcu *
>     net/vmw_vsock/virtio_transport.c:561:13:    struct virtio_vsock *
>     net/vmw_vsock/virtio_transport.c:612:9: error: incompatible types in =
comparison expression (different address spaces):
>     net/vmw_vsock/virtio_transport.c:612:9:    struct virtio_vsock [noder=
ef] __rcu *
>     net/vmw_vsock/virtio_transport.c:612:9:    struct virtio_vsock *
>     net/vmw_vsock/virtio_transport.c:631:9: error: incompatible types in =
comparison expression (different address spaces):
>     net/vmw_vsock/virtio_transport.c:631:9:    struct virtio_vsock [noder=
ef] __rcu *
>     net/vmw_vsock/virtio_transport.c:631:9:    struct virtio_vsock *
>=20
> Fixes: 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free on th=
e_virtio_vsock")
> Reported-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/virtio_transport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--YToU2i3Vx8H2dn7O
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8MKUcACgkQnKSrs4Gr
c8iLnAf9E+pOReZB1uxaaxHt2z9HjKmxjs6nY1gK0E/aNHGD4C4ZQFpkMMYrgACn
mTAJbmWJG/694IDC1i803aGbRKIq0VIyrezJtZWH7e8KTMG77U1YEDUr/T6yTAqf
MYrz9ylRKbEHjzAmRQtnQGJ/YtshXFVHISJf6maySSPuHHInz+n/rUlXFxxmrOme
x8cvGFTQ71RZUEWpIQxTL2vp4BEob1aIvrrFREvqgR9Xh4W1ZV641dP50QqjkJf9
ebLfHIpb+n9ZrYNa/+WwEZvMhw8r+hWA3giUXEuSwkGZkoi9s5d6WfZYeU7Lcbr7
0VLfCa/y5QsWouWZkkMZ7nLfxrMEsg==
=2Mf5
-----END PGP SIGNATURE-----

--YToU2i3Vx8H2dn7O--

