Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51FB11EED6F
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 23:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgFDVnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 17:43:01 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:33712 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgFDVnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 17:43:01 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1E05B1C0BD2; Thu,  4 Jun 2020 23:43:00 +0200 (CEST)
Date:   Thu, 4 Jun 2020 23:42:59 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH] net/xdp: use shift instead of 64 bit division
Message-ID: <20200604214259.GA10835@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

64bit division is kind of expensive, and shift should do the job here.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

---

Now with patch. Sorry about that.

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 3889bd9aec46..d6c91a43a1ee 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -372,7 +372,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct x=
dp_umem_reg *mr)
 	if ((addr + size) < addr)
 		return -EINVAL;
=20
-	npgs =3D div_u64(size, PAGE_SIZE);
+	npgs =3D size >> PAGE_SHIFT;
 	if (npgs > U32_MAX)
 		return -EINVAL;
=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7ZauMACgkQMOfwapXb+vJ4LACfdFdG9dt5n48M+o5SD+ozcKbY
h3cAn0iL69IfeIS8iOdbbdg9tvCgwqyU
=VM7z
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
