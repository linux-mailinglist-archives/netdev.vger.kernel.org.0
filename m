Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8F65F675
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 12:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfGDKRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 06:17:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49152 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727249AbfGDKRG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 06:17:06 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 824E930001E2;
        Thu,  4 Jul 2019 10:17:05 +0000 (UTC)
Received: from localhost (ovpn-117-206.ams2.redhat.com [10.36.117.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6416118B93;
        Thu,  4 Jul 2019 10:17:02 +0000 (UTC)
Date:   Thu, 4 Jul 2019 11:17:01 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] vsock/virtio: use RCU to avoid use-after-free on
 the_virtio_vsock
Message-ID: <20190704101701.GD1609@stefanha-x1.localdomain>
References: <20190628123659.139576-1-sgarzare@redhat.com>
 <20190628123659.139576-2-sgarzare@redhat.com>
 <05311244-ed23-d061-a620-7b83d83c11f5@redhat.com>
 <20190703104135.wg34dobv64k7u4jo@steredhat>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tEFtbjk+mNEviIIX"
Content-Disposition: inline
In-Reply-To: <20190703104135.wg34dobv64k7u4jo@steredhat>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 04 Jul 2019 10:17:05 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--tEFtbjk+mNEviIIX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 03, 2019 at 12:41:35PM +0200, Stefano Garzarella wrote:
> On Wed, Jul 03, 2019 at 05:53:58PM +0800, Jason Wang wrote:
> > On 2019/6/28 =E4=B8=8B=E5=8D=888:36, Stefano Garzarella wrote:
> > Another more interesting question, I believe we will do singleton for
> > virtio_vsock structure. Then what's the point of using vdev->priv to ac=
cess
> > the_virtio_vsock? It looks to me we can it brings extra troubles for do=
ing
> > synchronization.
>=20
> I thought about it when I tried to use RCU to stop the worker and I
> think make sense. Maybe can be another series after this will be merged.
>=20
> @Stefan, what do you think about that?

Yes, let's make it a singleton and keep no other references to it.

Stefan

--tEFtbjk+mNEviIIX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl0d0h0ACgkQnKSrs4Gr
c8i7uAf/QXuDj1LvILBy4mvMHIq38SqbW5mFIsodkTbGDB7yc/P8sUakOgHd3iqg
B7T4t6bHfBmin86sSvgINZoQ2Ce0Cl5gfAUArX22oxCNNwo5U0rb6uLLj0aIi66M
JgXi44ww1uhDIqrgJAVltxIQCV6jjLNNR0Qz19oTEV1qNl4UkY4+iew3ebbt/sid
lBqxCSTTuA6dhA2R74j7mNtahfRXHiKqfz/fvnMIt6eayMHvx9cIpGJn+ZcJ5wNr
n55WOBLvBc+xom4siTtiE+R5ZOATuxyfbvCncpj5a6p3wfMDtYIWTh/UeAEyDesp
lL1CmfZat5mLZ1F0gxgjgE5alpkjuw==
=02pH
-----END PGP SIGNATURE-----

--tEFtbjk+mNEviIIX--
