Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D644202A2
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 11:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfEPJez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 05:34:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60350 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbfEPJez (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 05:34:55 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6074B2E95B3;
        Thu, 16 May 2019 09:34:55 +0000 (UTC)
Received: from localhost (ovpn-117-183.ams2.redhat.com [10.36.117.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A1D405D6A9;
        Thu, 16 May 2019 09:34:51 +0000 (UTC)
Date:   Thu, 16 May 2019 10:34:50 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH net 0/4] Prevent vhost kthread from hogging CPU
Message-ID: <20190516093450.GR29507@stefanha-x1.localdomain>
References: <1557992862-27320-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+S4DbcR7QPeSsP0V"
Content-Disposition: inline
In-Reply-To: <1557992862-27320-1-git-send-email-jasowang@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 16 May 2019 09:34:55 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--+S4DbcR7QPeSsP0V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 16, 2019 at 03:47:38AM -0400, Jason Wang wrote:
> Hi:
>=20
> This series try to prvernt a guest triggerable CPU hogging through
> vhost kthread. This is done by introducing and checking the weight
> after each requrest. The patch has been tested with reproducer of
> vsock and virtio-net. Only compile test is done for vhost-scsi.
>=20
> Please review.
>=20
> This addresses CVE-2019-3900.
>=20
> Jason Wang (4):
>   vhost: introduce vhost_exceeds_weight()
>   vhost_net: fix possible infinite loop
>   vhost: vsock: add weight support
>   vhost: scsi: add weight support
>=20
>  drivers/vhost/net.c   | 41 ++++++++++++++---------------------------
>  drivers/vhost/scsi.c  | 21 ++++++++++++++-------
>  drivers/vhost/vhost.c | 20 +++++++++++++++++++-
>  drivers/vhost/vhost.h |  5 ++++-
>  drivers/vhost/vsock.c | 28 +++++++++++++++++++++-------
>  5 files changed, 72 insertions(+), 43 deletions(-)
>=20
> --=20
> 1.8.3.1
>=20

Looks good aside from the use-after-free in the vsock patch.

--+S4DbcR7QPeSsP0V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAlzdLroACgkQnKSrs4Gr
c8hOGgf/TuvPxOE1Wzw+hWbX63+OyCIjKxtdlJzH3ahFiBAY+mlbhloiyLFxwFwm
Her1G3erNlR7kYao/4RMryOx0Bvz6l8iPocrRdkCimdgGuue3RN2fh1lL2kkKQny
33nIZNeWyzfD1igdQ/3Oab0o98s0Nl6orEdx6Ap3cKgBjrdRLhl72qnssF4etlve
G4k/1V8OyAQchWGqLBr4/xr0bnnA7Blx4sl18NgJn251MfZazuCk8SxffpfnZ3ni
yx6HxtZmQS3fRMCWioBVkforSNUlxURBvCnZYgWpHTP5CnQxzBPyT2NNBEpgXDvi
kYJIkiL2SbXqRNh87QZIQAu/WEyUGQ==
=JvSa
-----END PGP SIGNATURE-----

--+S4DbcR7QPeSsP0V--
