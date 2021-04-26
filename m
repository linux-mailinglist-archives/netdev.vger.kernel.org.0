Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B56636AA05
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 02:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbhDZA1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 20:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbhDZA1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 20:27:46 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2187BC061574;
        Sun, 25 Apr 2021 17:27:03 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FT5LT5fDmz9sV5;
        Mon, 26 Apr 2021 10:26:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1619396819;
        bh=FY6iPUabQ2q99PKDTsOxEdhhkevE6KRHUorFJx3o6fA=;
        h=Date:From:To:Cc:Subject:From;
        b=ElgIsEObHogFTBssY17uFl9XwoR6UF6OsoEiAxpH+gtNrRquuc9oKd+o1QT6ncv27
         YqHLuBRpaj3rSHKbrJ2DxbhElJWemUiEU3hjqs7HtZe0o47/YiomPXiG6+p8yjgbvk
         /lbTqjxuqARy5BpXYklRUEb/7/zNLJqF44zfHo2F4pFLFcLCpGB6sQYDOoRwbwbHK+
         ODioguhdqS2mzakAI1NycW1qeh76rKiMzpfqo2jOdOe2GBMfcUpZndOEP2/OOtPL+B
         kvqRqM/9jRbifypCSz9C9qYDiLijan3QkPDSVfuzmNHLGLZvafXyMo5yZPmJJ0N+d6
         5hXR5NiqgK6GA==
Date:   Mon, 26 Apr 2021 10:26:56 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: linux-next: manual merge of the net-next tree with the kbuild tree
Message-ID: <20210426102656.69a85cbc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/h=i6GuxYzBzDQnib.1tDksa";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/h=i6GuxYzBzDQnib.1tDksa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  tools/testing/selftests/net/mptcp/mptcp_connect.sh

between commit:

  31c330b346a6 ("kbuild: replace LANG=3DC with LC_ALL=3DC")

from the kbuild tree and commit:

  5888a61cb4e0 ("selftests: mptcp: launch mptcp_connect with timeout")

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

diff --cc tools/testing/selftests/net/mptcp/mptcp_connect.sh
index 1d2a6e7b877c,9236609731b1..000000000000
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@@ -273,7 -274,7 +274,7 @@@ check_mptcp_disabled(
  	ip netns exec ${disabled_ns} sysctl -q net.mptcp.enabled=3D0
 =20
  	local err=3D0
- 	LC_ALL=3DC ip netns exec ${disabled_ns} ./mptcp_connect -t $timeout -p 1=
0000 -s MPTCP 127.0.0.1 < "$cin" 2>&1 | \
 -	LANG=3DC ip netns exec ${disabled_ns} ./mptcp_connect -p 10000 -s MPTCP =
127.0.0.1 < "$cin" 2>&1 | \
++	LC_ALL=3DC ip netns exec ${disabled_ns} ./mptcp_connect -p 10000 -s MPTC=
P 127.0.0.1 < "$cin" 2>&1 | \
  		grep -q "^socket: Protocol not available$" && err=3D1
  	ip netns delete ${disabled_ns}
 =20

--Sig_/h=i6GuxYzBzDQnib.1tDksa
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCGCNAACgkQAVBC80lX
0Gz0Vgf+IsKIaB1CJc5jv6euAJZ1GVTmzTbEDPHZirm+/7vW75ZsMTz2C1wEKQFO
gOwmgglCjprAioQXolEVC4tZj4vwxDkHC28vnY1JKjB0M2drzHrVv6Osf9/gRdZa
hiQ/KzudfP8Gt0haGQbNWzOApgFjLCEA71C56IyOOC/gjfHw0kVStl0OGJCcLeOp
BdJkrhCT9K9EG4h2a4eygC1HdVUYtaTl/BTwHWojnZ5tr1i3C4YIIUXkaQRkYyhs
iOAYe6P9CD/eEqF1/D7j1PLljHQj+JYMvv4SVdiTEB5RMsQIaDVL+jEsImuMkRCQ
YMiUfRWn7nzBFhKf3HvTdnBAyPVeDQ==
=ntFK
-----END PGP SIGNATURE-----

--Sig_/h=i6GuxYzBzDQnib.1tDksa--
