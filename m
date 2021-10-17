Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8349430CEB
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 01:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344765AbhJQXyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 19:54:06 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:43397 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbhJQXyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 19:54:05 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HXcHF4dMvz4xbb;
        Mon, 18 Oct 2021 10:51:52 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1634514714;
        bh=KjGu3MGXsTCBFX+Z8yAnMd7Gs1S9zeIeL3S5XdiB67s=;
        h=Date:From:To:Cc:Subject:From;
        b=WleoNlxDPHcZWwn4tP3WO4qsGSfzqAO8CYjan8mQ75oW04t6QRYLC0EF2T5BbC/45
         9jIfqe1116RYIpPTW9oeeVKDNB+YGXEc4YUScG5ydMbS8ZBvROZ8jza4dp9BGX5OL1
         B2m6o27M5ReXX5fT/qQtmWPuyyWiqFHrbODzmK/6HCknuNL3J6gD9I42gPIoN1kmCG
         SvQ2REbdXCRmyyqneM2FTspSxMd2XkFOT0C2+QxpN1GkVZuF4s6ny1rarL3uAnS43z
         Dq1TnEUCVwXUbFPylffUOxNjARwWEtIxmO9/fqFYQC+djt2pVYKzMTAQeg1gPiDoO+
         xNlAP2pycox7A==
Date:   Mon, 18 Oct 2021 10:51:51 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Amit Cohen <amcohen@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20211018105151.16ff248d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Hs2dpeLF+Nct.9OE+F0tNkI";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/Hs2dpeLF+Nct.9OE+F0tNkI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  tools/testing/selftests/net/forwarding/forwarding.config.sample

between commit:

  0857d6f8c759 ("ipv6: When forwarding count rx stats on the orig netdev")

from the net tree and commit:

  45d45e5323a9 ("testing: selftests: forwarding.config.sample: Add tc flag")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc tools/testing/selftests/net/forwarding/forwarding.config.sample
index e5e2fbeca22e,10ce3720aa6f..000000000000
--- a/tools/testing/selftests/net/forwarding/forwarding.config.sample
+++ b/tools/testing/selftests/net/forwarding/forwarding.config.sample
@@@ -39,5 -39,6 +39,8 @@@ NETIF_CREATE=3Dye
  # Timeout (in seconds) before ping exits regardless of how many packets h=
ave
  # been sent or received
  PING_TIMEOUT=3D5
 +# IPv6 traceroute utility name.
 +TROUTE6=3Dtraceroute6
+ # Flag for tc match, supposed to be skip_sw/skip_hw which means do not pr=
ocess
+ # filter by software/hardware
+ TC_FLAG=3Dskip_hw

--Sig_/Hs2dpeLF+Nct.9OE+F0tNkI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFstxcACgkQAVBC80lX
0GxDSggAil9dModuqoVIsb9QsFofJDbAHjD0IrUra0WWOLvoB280SlYPRxZLD21J
dhw+gnoT5HvobYdK6/CqHXT0if8vYhEwwXtR8EDxtUUyBHpYBbA9KdJIhKCuUhVR
/p5r+3USy09QcVA27nGUhw+t59kpVOlvs41YVgjoyx1rEzOYcXKULrK2AC4VdGnV
debRzkkBkW2m7MKDfQoOSiN3MLx+iLMETHNk9cCXtiPq9/2Ju+fd2NKj3eI6SEW5
U8TlewuQfeHOOfKy79SVo23V0NxePsr8Dyv77f6IguX+beRKi0FC12x1cZnHSD3j
Yg2m5Zc/tRMxD+3i3JgU+qousVaMWQ==
=vWlO
-----END PGP SIGNATURE-----

--Sig_/Hs2dpeLF+Nct.9OE+F0tNkI--
