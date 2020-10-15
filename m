Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DCB28FAC3
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 23:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbgJOVoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 17:44:24 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:51873 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727278AbgJOVoX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 17:44:23 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CC2qS0xCTz9sTr;
        Fri, 16 Oct 2020 08:44:20 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1602798261;
        bh=xxCONTbIooCLH5Bf98YyysiRr38oie6ZZ6U5FiXcbkI=;
        h=Date:From:To:Cc:Subject:From;
        b=OG8ho/Li0M4Gw+DaySwLdtwJ9q3QxzeGwHplZcYWDKBLkGbFNhpzJztM2HoMbnk/9
         /yWB6fQiXNdZwE5cJ5lXNGGhOXsxChpn3X4qaELOKbgdsxierhrPrOqBTvqs/GeAYa
         /ieYU7MkdNAdtwTpr0iBNUP2NUIe8KeYP+Re8rijFU91QMFIZGVn07QVSshAeLAPcU
         Em9J2pVgSajphckrLeKXVQPUVLyy1jYw+xaWCBZFZN2AA/MeCQjUoAN0dN30laeVvL
         dpf/CO5svJYAOO0gf71zyW2bTWiwxniurMYpDHhV4UQ7iBDT0/og26Hu0l/0/pggIn
         Eg0vY+N8kpRkw==
Date:   Fri, 16 Oct 2020 08:44:19 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Ido Schimmel <idosch@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Michael Jeanson <mjeanson@efficios.com>
Subject: linux-next: manual merge of the wireless-drivers tree with the net
 tree
Message-ID: <20201016084419.3c6e048a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/gHa18ALDmab4h1Q=Y3a==d9";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/gHa18ALDmab4h1Q=Y3a==d9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the wireless-drivers tree got a conflict in:

  tools/testing/selftests/net/Makefile

between commit:

  1a01727676a8 ("selftests: Add VRF route leaking tests")

from the net tree and commit:

  b7cc6d3c5c91 ("selftests: net: Add drop monitor test")

from the wireless-drivers (presumably because it has merged part of the
net-next tree) tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc tools/testing/selftests/net/Makefile
index 3e7fb1e70c77,4773ce72edbd..000000000000
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@@ -19,7 -19,7 +19,8 @@@ TEST_PROGS +=3D txtimestamp.s
  TEST_PROGS +=3D vrf-xfrm-tests.sh
  TEST_PROGS +=3D rxtimestamp.sh
  TEST_PROGS +=3D devlink_port_split.py
+ TEST_PROGS +=3D drop_monitor_tests.sh
 +TEST_PROGS +=3D vrf_route_leaking.sh
  TEST_PROGS_EXTENDED :=3D in_netns.sh
  TEST_GEN_FILES =3D  socket nettest
  TEST_GEN_FILES +=3D psock_fanout psock_tpacket msg_zerocopy reuseport_add=
r_any

--Sig_/gHa18ALDmab4h1Q=Y3a==d9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl+IwrMACgkQAVBC80lX
0GwW6Qf9GgMvt4wD9afGoWwR3PrZX5Fzbe5fqY+FJIrMG6yHYcyPxRG605Vl5gXo
JwcjFo9xXxOtEb7EDC1uwLZouTpFtoArIyhJTa7ND1psay5yu3nrTKVljZeTE2ub
DGZuF6NfGHQ7L1dE0szwqBVL99n17hF1Apvy9wRXd+lpMJllJs32orJ15h6aUdOa
K7/r8yFN8GN0LEtIw5sgRZ/nArGn/aftRHUVv79jrEzTOYSCc8nS7IQWHNXl3aQH
AQs7a5bEGg+GlI0AOCWwpDgFuCmzYFQyPlWfPEJzt9Y8+xiIiz3ep88IVKCHm5Kh
2lhbecBDqNtsb+GZW/hgj5oCcYml8Q==
=IQ4s
-----END PGP SIGNATURE-----

--Sig_/gHa18ALDmab4h1Q=Y3a==d9--
