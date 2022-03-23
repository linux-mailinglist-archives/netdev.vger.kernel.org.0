Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2212E4E5370
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 14:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244455AbiCWNqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 09:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244441AbiCWNqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 09:46:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8D09F13F48
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 06:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648043087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GSgoSaQ+JIfg7wq78quWtl1Bx2v1bqSuTJRYfSjlhrE=;
        b=W63ZKKS5zxypUZELKSrrkpNRyzIb1ATId2o7e9BL7U1T8R6YhSmgSghbiSsI7ZMw/zpD71
        glAhg5/X8+ZaFNdqZM2S7I5hH82NyCgNn79Qq8i+NCbPnlaAnno9pfLlSS9ELqYJSV7srn
        fbh7Ck8DYKQ63YB0qJcuxBmK4tYm1cE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-503-PE0IjX1kNEi9tDprSbLOhg-1; Wed, 23 Mar 2022 09:44:44 -0400
X-MC-Unique: PE0IjX1kNEi9tDprSbLOhg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DFBE811E75;
        Wed, 23 Mar 2022 13:44:43 +0000 (UTC)
Received: from localhost (unknown [10.39.194.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E7E2D1400E70;
        Wed, 23 Mar 2022 13:44:42 +0000 (UTC)
Date:   Wed, 23 Mar 2022 13:44:42 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        "David S. Miller" <davem@davemloft.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net v2 1/3] vsock/virtio: enable VQs early on probe
Message-ID: <YjskSh4PgXuDStAF@stefanha-x1.localdomain>
References: <20220323084954.11769-1-sgarzare@redhat.com>
 <20220323084954.11769-2-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Ew8YH6cjDCduveFO"
Content-Disposition: inline
In-Reply-To: <20220323084954.11769-2-sgarzare@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Ew8YH6cjDCduveFO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 23, 2022 at 09:49:52AM +0100, Stefano Garzarella wrote:
> virtio spec requires drivers to set DRIVER_OK before using VQs.
> This is set automatically after probe returns, but virtio-vsock
> driver uses VQs in the probe function to fill rx and event VQs
> with new buffers.
>=20
> Let's fix this, calling virtio_device_ready() before using VQs
> in the probe function.
>=20
> Fixes: 0ea9e1d3a9e3 ("VSOCK: Introduce virtio_transport.ko")
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/virtio_transport.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_tran=
sport.c
> index 5afc194a58bb..b1962f8cd502 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -622,6 +622,8 @@ static int virtio_vsock_probe(struct virtio_device *v=
dev)
>  	INIT_WORK(&vsock->event_work, virtio_transport_event_work);
>  	INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
> =20
> +	virtio_device_ready(vdev);

Can rx and event virtqueue interrupts be lost if they occur before we
assign vdev->priv later in virtio_vsock_probe()?

Stefan

--Ew8YH6cjDCduveFO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmI7JEkACgkQnKSrs4Gr
c8iwMQf6AoKiNuvBPWS3yOCgqec8X+6LYAdNCyNKlqC9GPmHeZ6YFFfiuvTxqTNg
WujzjOLTSWdMn8IOwNfNyxtIb5dLFITwd5eaAyh8zPjWTimt0JE70MU2/ezYQBJU
0pW9hKlhUT9i2HccLdSKvMRrCJfnqFyJqGod/1AXK3Bxb307mxFydP7rjOq/nGpw
BJapVkSHZ1oNbsFiad5XZMkmEnLeJbV+NKxdmlyMIXFsnCda9QsgQ+/qDwck41jQ
pMlBjnoWhwMV0NEeWqICUSp0dNOEKMzs+lrp5DJeuqnLsApUDb9DOpvtU44ZRcVF
gQHruj4EAL/97VOo0C/f/7jE6h+f+g==
=R5CZ
-----END PGP SIGNATURE-----

--Ew8YH6cjDCduveFO--

