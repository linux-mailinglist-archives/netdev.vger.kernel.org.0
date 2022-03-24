Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104054E6101
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 10:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349178AbiCXJWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 05:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346488AbiCXJWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 05:22:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E4AC65D65E
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 02:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648113636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m6cTh4I7UZgOvgJZg1g3+MamKX/v6MrkfYevPTqDtOQ=;
        b=T3dzAKokgF24odxQyjCqAf2BZNNdTP+Vc7dnEea7pfyYY+0fQVqwB0bKpNPf1OSgdW6gzo
        h/M1kPsP4lqJNqUOWCG2oDnfQ0q5tNOfmrFWWg6kM+CNCOK/k6XUvLO1ZspzyFb//2joU3
        uqHBvmUMywGtdxoRkXP43bBiAyw6MI0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-251-gVDYTvbPMXGAN7VyNstF0A-1; Thu, 24 Mar 2022 05:20:32 -0400
X-MC-Unique: gVDYTvbPMXGAN7VyNstF0A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 360163806648;
        Thu, 24 Mar 2022 09:20:32 +0000 (UTC)
Received: from localhost (unknown [10.39.195.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD764140262B;
        Thu, 24 Mar 2022 09:20:31 +0000 (UTC)
Date:   Thu, 24 Mar 2022 09:20:30 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net v3 0/3] vsock/virtio: enable VQs early on probe and
 finish the setup before using them
Message-ID: <Yjw33hb1u4Da6pKK@stefanha-x1.localdomain>
References: <20220323173625.91119-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eKzvWnn8+0FZDZiL"
Content-Disposition: inline
In-Reply-To: <20220323173625.91119-1-sgarzare@redhat.com>
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


--eKzvWnn8+0FZDZiL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 23, 2022 at 06:36:22PM +0100, Stefano Garzarella wrote:
> The first patch fixes a virtio-spec violation. The other two patches
> complete the driver configuration before using the VQs in the probe.
>=20
> The patch order should simplify backporting in stable branches.
>=20
> v3:
> - re-ordered the patch to improve bisectability [MST]
>=20
> v2: https://lore.kernel.org/netdev/20220323084954.11769-1-sgarzare@redhat=
=2Ecom/
> v1: https://lore.kernel.org/netdev/20220322103823.83411-1-sgarzare@redhat=
=2Ecom/
>=20
> Stefano Garzarella (3):
>   vsock/virtio: initialize vdev->priv before using VQs
>   vsock/virtio: read the negotiated features before using VQs
>   vsock/virtio: enable VQs early on probe
>=20
>  net/vmw_vsock/virtio_transport.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>=20
> --=20
> 2.35.1
>=20

A subtle point is that we still drop events and rx packets during the
window where DRIVER_OK has been set but vqs haven't been filled.
This is acceptable because it's unavoidable and equivalent to events
happening before DRIVER_OK is set. What this revision *does* fix is that
vq used buffer notifications are no longer lost. Good.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--eKzvWnn8+0FZDZiL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmI8N94ACgkQnKSrs4Gr
c8j+jAgAl3SNYonulML5v3KQQY538H3xIog/TepsoHOzV9JYFRnvHbKd45XUy9uQ
/SWZsBt1J4gXz73ejgF+aNpMhfy5rNvFzEETQhsdm8Jd9Nsdh9bmh53GBaYzXm8M
SzhrB2Zje+VAVpemGrAWfpSSIuc8ZbZYUOb2eQzpWelR2GKiVyqAXdjyZzbr5CLI
n0T9fgrzNIejcl6AQ0sGKNw8a60ArlWdU0EHQzaT5hmeDbUF3dsZ9lfGT5IFrxpu
ksdPyCe5vidOQye9dRAvRQVXhVpo9MPAL83jcKY09QWpSrsz3UJZZbYAbULbOQhO
IrbJvaefmdbRXxr1Ylv8d1qhJ9pWXA==
=bbzl
-----END PGP SIGNATURE-----

--eKzvWnn8+0FZDZiL--

