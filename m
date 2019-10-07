Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7B9DCEF27
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 00:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbfJGWmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 18:42:31 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:40005 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728654AbfJGWmb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 18:42:31 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46nFq871TRz9sPT;
        Tue,  8 Oct 2019 09:42:28 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1570488149;
        bh=t1+QL3NVj1xEg9Hc5TIAtTlFoQW7X/JWQPEMb3/QOac=;
        h=Date:From:To:Cc:Subject:From;
        b=EyeN0p85cgnBuFiDJtN2P3nFz0eRTOBUCTi1HnCx9p/NtPUyQOthHQTP3leGw6LuD
         kDaA8zDv3pbxozTW08qSw3J+EqSqCGBvfdm93x99raTVh/j0ey789r1Roqlb5RdDPq
         YTs3UcYZxt+Vn000Rg76r0/Q9gELvs9c9ayN6aTs09J8ihVx4nXOMuqk0h0n+qq8Iu
         eKycxtgUlk/LnUjcNc042QOlQ+WJ/Dhqa5mFk//RUKG8DD3yDiI3+pAjccAybyOV9D
         0GhohJ0WobOuA5izBl4yiAaAedPi/FjR+ejkzNu1l1lvuvlc8CxClTihDHDl6L5R5k
         lVX1dDv14iqpA==
Date:   Tue, 8 Oct 2019 09:42:21 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: linux-next: build warning after merge of the net-next tree
Message-ID: <20191008094221.62d84587@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Xj_X7JA3EV9XdyAej7t7QRR";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Xj_X7JA3EV9XdyAej7t7QRR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64
allmodconfig) produced this warning:


Introduced by commit

  033b2c7f0f26 ("rxrpc: Add missing "new peer" trace")

interacting with commit

  55f6c98e3674 ("rxrpc: Fix trace-after-put looking at the put peer record")

from the net tree.

I have applied the following merge fix patch.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 8 Oct 2019 09:37:50 +1100
Subject: [PATCH] rxrpc: fix up for "rxrpc: Fix trace-after-put looking at t=
he
 put peer record"

interacting with commit

  033b2c7f0f26 ("rxrpc: Add missing "new peer" trace")

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/rxrpc/peer_object.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index a7f1a2cdd198..452163eadb98 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -231,7 +231,7 @@ struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local =
*local, gfp_t gfp)
 			peer->cong_cwnd =3D 3;
 		else
 			peer->cong_cwnd =3D 4;
-		trace_rxrpc_peer(peer, rxrpc_peer_new, 1, here);
+		trace_rxrpc_peer(peer->debug_id, rxrpc_peer_new, 1, here);
 	}
=20
 	_leave(" =3D %p", peer);
--=20
2.23.0.rc1

--=20
Cheers,
Stephen Rothwell

--Sig_/Xj_X7JA3EV9XdyAej7t7QRR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl2bv00ACgkQAVBC80lX
0Gw2zAf/W7h8UKvXttU794iCM0slur9fhK6ToIThd4CmP7wvbjIa3q9JO3NOi+VQ
MU72DirzJ7mDVrOeJb+8NNagX48Njh+QYt20rHLEjBhNyvpvWweqaGoAXhwMIW5v
H9osNyDGhwsbVabWa3h1Qnh+ZNJbyDbq3vPFNVFW/BiPvGeffqHKgaYYnWQCRenR
FcLx8jS2133KzYpVwv7eWiXeMy6liLxjw7sIcvFWI7hrXMzBoUtmYIP1nwJsd0Xt
Qslm+bsqppTl/fMTikJG/MGNu/bTLxhbj+qoCqGKnMdvh9k5JSNLy7k7JJsJyFyY
eu/GylQPO5wfY4V4Hj21M7vxomX3zg==
=83Rl
-----END PGP SIGNATURE-----

--Sig_/Xj_X7JA3EV9XdyAej7t7QRR--
