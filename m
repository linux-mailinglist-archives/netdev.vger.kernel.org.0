Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F3D426405
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 07:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhJHFXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 01:23:01 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:56787 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbhJHFXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 01:23:01 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HQc3h4ytdz4xbc;
        Fri,  8 Oct 2021 16:21:04 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1633670465;
        bh=fO46+zE2G2W+f4Yn3/vP4Zgexf2v7j+Wy7IxhBJwVa8=;
        h=Date:From:To:Cc:Subject:From;
        b=Y3UOlASfMJ911Ajsw4HHvQVsRa73GSRtLOq0eKqKmW62uPplVF6nGFGcHnVMdJJJ5
         wOs2oak8osIcbyJWm2RgYggGm4pE7MmIXyeaSzybOKoX+a7xIUlKpgtNTARb92Is+Y
         cdIyt2M+ZSeH/ShUypfRBklraL80DIzl19BMjqjHkZi2zlaPNt/gZgd4ovBKJ3Opyq
         YRxUCCMtHUhUt8MEb3+KR2qtiRH8ZgGIMqPrLdKX6et1edJ38W//Dzd74dmuTeyNJr
         xSOIrCjpp/ReRH+kdRLLbDCJMpMSYSXwBnDrPUpQ6BahekQOVrwLUCeOLsYvDq+EYW
         yhQ+PMoI5chKg==
Date:   Fri, 8 Oct 2021 16:21:03 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20211008162103.1921a7a7@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/OWkET=COPDXOIyb7J.sAON7";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/OWkET=COPDXOIyb7J.sAON7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (xtensa,
m68k allmodconfig) failed like this:

In file included from <command-line>:0:0:
In function 'ath11k_peer_assoc_h_smps',
    inlined from 'ath11k_peer_assoc_prepare' at drivers/net/wireless/ath/at=
h11k/mac.c:2362:2:
include/linux/compiler_types.h:317:38: error: call to '__compiletime_assert=
_650' declared with attribute error: FIELD_GET: type of reg too small for m=
ask
  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                      ^
include/linux/compiler_types.h:298:4: note: in definition of macro '__compi=
letime_assert'
    prefix ## suffix();    \
    ^
include/linux/compiler_types.h:317:2: note: in expansion of macro '_compile=
time_assert'
  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
  ^
include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_a=
ssert'
 #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                     ^
include/linux/bitfield.h:52:3: note: in expansion of macro 'BUILD_BUG_ON_MS=
G'
   BUILD_BUG_ON_MSG((_mask) > (typeof(_reg))~0ull,  \
   ^
include/linux/bitfield.h:108:3: note: in expansion of macro '__BF_FIELD_CHE=
CK'
   __BF_FIELD_CHECK(_mask, _reg, 0U, "FIELD_GET: "); \
   ^
drivers/net/wireless/ath/ath11k/mac.c:2079:10: note: in expansion of macro =
'FIELD_GET'
   smps =3D FIELD_GET(IEEE80211_HE_6GHZ_CAP_SM_PS,
          ^

Caused by commit

  6f4d70308e5e ("ath11k: support SMPS configuration for 6 GHz")

--=20
Cheers,
Stephen Rothwell

--Sig_/OWkET=COPDXOIyb7J.sAON7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFf1T8ACgkQAVBC80lX
0GxN4gf/XbvnPj4onsQ0DSCEd/9Xm7lJxN/nxwMngxwhgMoHk+1XYT8jMH+pybyW
vcOOqFUJ3Bmvw8baM5KSBp0lvykxqvNsIuYLfTa282R10gn5+gZ3zRpBH7TBlveG
7/xqiH8y6GVTO3IZVcc9Z14FNOGd4zb1VV8trqbPITu1Rt2qowoFilyPlQQL6nha
RbWDJfe8Ve06pN5vLEX0v6DX6obZoF6ibUEuzB9XnXXVup+AkoTxehXbEr4U1Jle
TCLk8SQ6g39T5iirdxj2k+r94I5JeyYw5G1iCl7hS3kTfZhKSRqZBMBteLc219DV
tWCTJxgMTKf9ENfTu/MXTnA7xg7gpQ==
=Zz2x
-----END PGP SIGNATURE-----

--Sig_/OWkET=COPDXOIyb7J.sAON7--
