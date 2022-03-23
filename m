Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C07B94E5376
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 14:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244462AbiCWNqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 09:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240686AbiCWNqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 09:46:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BF5284CD7C
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 06:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648043120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D9p4dT9tmB1MqpunWPOj0g10DavGp6R613Fb41aTrE0=;
        b=dBMT9i32R5owLMwHNElyRoipAyQFK5L4TqiH+8C4hMFw0FlsWeJs4+7kIM+j27pXaeMc/Q
        r3aXSeilP/FZPUY7g1VeNSEFehFmuwlTXFb9rLVx4Yhf2XMSEunvByOQVhNiANzSntjH9y
        jEO3kF/lKv/3l6skkxu8ObvPMaW10H8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-19-5PcxbFsuPcq5fgDPt_Xe0Q-1; Wed, 23 Mar 2022 09:45:17 -0400
X-MC-Unique: 5PcxbFsuPcq5fgDPt_Xe0Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3A0E804184;
        Wed, 23 Mar 2022 13:45:16 +0000 (UTC)
Received: from localhost (unknown [10.39.194.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6AE7A401E7B;
        Wed, 23 Mar 2022 13:45:16 +0000 (UTC)
Date:   Wed, 23 Mar 2022 13:45:15 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        "David S. Miller" <davem@davemloft.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net v2 2/3] vsock/virtio: initialize vdev->priv before
 using VQs
Message-ID: <Yjska4v9QaRS2pJQ@stefanha-x1.localdomain>
References: <20220323084954.11769-1-sgarzare@redhat.com>
 <20220323084954.11769-3-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3R3JLtwl44kUF4kA"
Content-Disposition: inline
In-Reply-To: <20220323084954.11769-3-sgarzare@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3R3JLtwl44kUF4kA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 23, 2022 at 09:49:53AM +0100, Stefano Garzarella wrote:
> When we fill VQs with empty buffers and kick the host, it may send
> an interrupt. `vdev->priv` must be initialized before this since it
> is used in the virtqueue callback.
>=20
> Fixes: 0deab087b16a ("vsock/virtio: use RCU to avoid use-after-free on th=
e_virtio_vsock")
> Suggested-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/virtio_transport.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_tran=
sport.c
> index b1962f8cd502..fff67ad39087 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -622,6 +622,7 @@ static int virtio_vsock_probe(struct virtio_device *v=
dev)
>  	INIT_WORK(&vsock->event_work, virtio_transport_event_work);
>  	INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
> =20
> +	vdev->priv =3D vsock;
>  	virtio_device_ready(vdev);

Doh, patch order got me. :)

Stefan

--3R3JLtwl44kUF4kA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmI7JGsACgkQnKSrs4Gr
c8jGEgf+NmY84WZKJt4M3ASm6YsR7skYma09Y+u6pulwtzHks6OpAZzjoXQHGIBS
/VimYO8GzZLJQXM7ZawAR82ynLRJR/fD4c574cymhwYyEucPvzhc6bWD/d0Wxlye
CuDUZ5ogWrl03SkA2Z7qE9hlGMxHXG9alh+uU+riRlLxRfWlxl3UQiuRwYxV9sij
v3VpMkTj4qD0IFb+BJUHCeBaTZYIufDqSExT1dAkOtfZxzsVhbK2aT7kVQT8LgoB
yZUPLgDZ83kCAsVqZfWG2Pxfi91XADhSg31ymOPAKx3Fva+7P2eRIKVXy8wT3yDi
V39sZSRcKgm9AJ/09faSF2UCwrfUKw==
=yTw0
-----END PGP SIGNATURE-----

--3R3JLtwl44kUF4kA--

