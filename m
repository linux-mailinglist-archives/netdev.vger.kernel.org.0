Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3204C26DD
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 10:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232157AbiBXIyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 03:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbiBXIyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 03:54:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B4A5162020
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 00:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645692824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=thrYYz9q4DcC0rOHSVDRqBTRDM3HEZ49oAwiCU0vtIA=;
        b=XHFcKxq3HjKYkfe724sAVLTbwSG+7nf/iJTFBAXnUG5J3SkNRVIzjINqBsmeXP6lvz7EEb
        /U/h/lfubNzelj5p3WyGyLyf2vKvpIsQvxZhpeVJxpCJMJATLEjBYBl+yfgemfAKjcmEfn
        2FNW2jCL/Hvmh1vIOWew5kW5vGdCUqw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-503-2e81YYi9MyyiXnp89lNAuQ-1; Thu, 24 Feb 2022 03:53:41 -0500
X-MC-Unique: 2e81YYi9MyyiXnp89lNAuQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41803800496;
        Thu, 24 Feb 2022 08:53:39 +0000 (UTC)
Received: from localhost (unknown [10.39.194.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA567607CB;
        Thu, 24 Feb 2022 08:53:32 +0000 (UTC)
Date:   Thu, 24 Feb 2022 08:53:31 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com,
        kvm@vger.kernel.org, Anirudh Rayabharam <mail@anirudhrb.com>,
        syzbot+3140b17cb44a7b174008@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] vhost/vsock: don't check owner in vhost_vsock_stop()
 while releasing
Message-ID: <YhdHi4wHLjUfD3WN@stefanha-x1.localdomain>
References: <20220222094742.16359-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eMHA10fN330j9lI9"
Content-Disposition: inline
In-Reply-To: <20220222094742.16359-1-sgarzare@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--eMHA10fN330j9lI9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 22, 2022 at 10:47:42AM +0100, Stefano Garzarella wrote:
> vhost_vsock_stop() calls vhost_dev_check_owner() to check the device
> ownership. It expects current->mm to be valid.
>=20
> vhost_vsock_stop() is also called by vhost_vsock_dev_release() when
> the user has not done close(), so when we are in do_exit(). In this
> case current->mm is invalid and we're releasing the device, so we
> should clean it anyway.
>=20
> Let's check the owner only when vhost_vsock_stop() is called
> by an ioctl.
>=20
> When invoked from release we can not fail so we don't check return
> code of vhost_vsock_stop(). We need to stop vsock even if it's not
> the owner.
>=20
> Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com
> Reported-and-tested-by: syzbot+3140b17cb44a7b174008@syzkaller.appspotmail=
=2Ecom
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
> v2:
> - initialized `ret` in vhost_vsock_stop [Dan]
> - added comment about vhost_vsock_stop() calling in the code and an expla=
nation
>   in the commit message [MST]
>=20
> v1: https://lore.kernel.org/virtualization/20220221114916.107045-1-sgarza=
re@redhat.com
> ---
>  drivers/vhost/vsock.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--eMHA10fN330j9lI9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmIXR4oACgkQnKSrs4Gr
c8i0LQf/bGGbSYckr30SGrkHytT/rZHQYzSD8L7Mcj6YDjh7rV/lE31ATrVY9JY4
qZ/hJTMlfAx8gqVYEmZrUh9xM09BjRAdSjGy92sdpbVYhWbr1D0HmDS+hQvFQjXs
HHpjWQeHtKjAfw8nz6HfgcH3329t+oVH5V4RQ5pOeLNq0Tm58uYdhmf7IqIrb9TI
LySJlzqTqsRzI8URPo6u9i+PqNhTnbjYTSBP2/WnAZeSrHUDXlOmeJ5cXGweinGe
CiH+66Eay0ga1M/Xym1xsota2L8lfQlO9HF1XkTJiYEeQDYthIJUc7wuZvnftCgh
ZND4ieEesa+iV+Lyaxno7s+gT0fLHw==
=f2iv
-----END PGP SIGNATURE-----

--eMHA10fN330j9lI9--

