Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074BA37B2CA
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 01:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhEKXxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 19:53:15 -0400
Received: from ozlabs.org ([203.11.71.1]:40961 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230075AbhEKXxO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 19:53:14 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Ffvps6xb1z9sWC;
        Wed, 12 May 2021 09:52:05 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1620777126;
        bh=M7TtSkXxMF0em4ofKmMx4OFSoudGXcoUk7yXJrm2mSw=;
        h=Date:From:To:Cc:Subject:From;
        b=BR7+Dtm3hOLEbZDwH64Edagaii6JAIUYnvjS53kvxE66ZbH/uUzJTIcBDK6kRRBl/
         hlN2Om6zfcxNSBirT7+Hu8qJhPs0yKzDqY/RxmrEpOS6VxfL2TIqVbOf0zVkqKTD5H
         w+OJBWxtlEJG8X/J90FDNwmtPA4FYSxbuTWl0o77dmQ6IdXJzoCFWaEZMY16D/A5/n
         zKy0PfjPj9zRW5fYSgy1PcOKe9LSPxI07BJUuJqo82R2zNs+JD4vsOzt7D0HBWNQCl
         94VXzZ8kKwuh99wa7GQFobgmp1z29OQTX5M1Xz+Txwqes7UyPMoBpGjP2eC5eMOHZD
         /tjlq38aLkyoA==
Date:   Wed, 12 May 2021 09:52:01 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20210512095201.09323cda@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/hG/om+Wur_o8DNz.SY9kEgL";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/hG/om+Wur_o8DNz.SY9kEgL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/usb/class/cdc-wdm.c: In function 'wdm_wwan_port_stop':
drivers/usb/class/cdc-wdm.c:858:2: error: implicit declaration of function =
'kill_urbs' [-Werror=3Dimplicit-function-declaration]
  858 |  kill_urbs(desc);
      |  ^~~~~~~~~

Caused by commit

  cac6fb015f71 ("usb: class: cdc-wdm: WWAN framework integration")

kill_urbs() was removed by commit

  18abf8743674 ("cdc-wdm: untangle a circular dependency between callback a=
nd softint")

Which is included in v5.13-rc1.

I have used the net-next tree from next-20210511 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/hG/om+Wur_o8DNz.SY9kEgL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCbGKEACgkQAVBC80lX
0GxU0wgAldBKe6NYy9f9GJkUU0xrTAXAGMJV1AHWS6Zi70FoLXiFe7Rgw6TY9BFb
4eSzo98zhvCIIEXw7vieH2kjFMb/b+cUPPimOA/FrEz9uUyBtIyAQGLgqdXgLWlA
nIEtJCivCLLHH/eTEUsya9OJsb1j9oQpGHCtyH7kmIUXsoCn5yBV/XIZ6FjblgpT
IJHkESuGDmksaZIWNBtT/iH/LBrVoJ/MfW6Q8nRNH3JV0phAViO/048oSdU0sPRH
9CR2LGiOaSD3xGJ9WD+fFoje6KBV+GKDF01ve7EO9dZyaMDTu48Y6m/xff6zGhge
SA/aH25cRFA9FTfqP9RuZFWOVK2oYw==
=Mf9w
-----END PGP SIGNATURE-----

--Sig_/hG/om+Wur_o8DNz.SY9kEgL--
