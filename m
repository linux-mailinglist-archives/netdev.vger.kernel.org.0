Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF763F4351
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 04:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbhHWCKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 22:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234740AbhHWCKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 22:10:18 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2851AC061575;
        Sun, 22 Aug 2021 19:09:36 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GtFzw0bRnz9sWS;
        Mon, 23 Aug 2021 12:09:31 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1629684572;
        bh=urcvtOto4Q3/VgDYNB5LTZdJMwfL4QJ4Fqs3AUcgWKw=;
        h=Date:From:To:Cc:Subject:From;
        b=Gv8GprYdjulnUgV/839nSb3mHVK0bPVBkZ+legtLKQ7doctvcVI0qYim+epkKO3va
         eeclEvbZ03UkbEbXLwrnxwbKf8VR1NGgff9i4l1S58o82Ri1oAeWFpTRMGQ5mV9IIS
         PoUIibNWBwwMJpA3VJdid/k9c4o4UmNuxaPZb8UGiSFnOMjhwjFRRPgDtspI0tPaVP
         udFbYVQLeb30ysTAg7YCWr87/tWNNAqlfq/w67iUW8BiK+vQVybBV/xRdkJkumyZjY
         FFNa/WjXHj7Ly+azdmB12+GURtKdSRFO90/s5/MgTeNZoMhPsS6shwQAABeU+OzALH
         xJeub2vx2ynPA==
Date:   Mon, 23 Aug 2021 12:09:29 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20210823120929.7c6f7a4f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/+ylmqHP=i0YfySSqFQ/x9wl";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/+ylmqHP=i0YfySSqFQ/x9wl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/net/ethernet/broadcom/bnx2.c: In function 'bnx2_read_vpd_fw_ver':
drivers/net/ethernet/broadcom/bnx2.c:8055:6: error: implicit declaration of=
 function 'pci_vpd_find_ro_info_keyword'; did you mean 'pci_vpd_find_info_k=
eyword'? [-Werror=3Dimplicit-function-declaration]
 8055 |  j =3D pci_vpd_find_ro_info_keyword(data, BNX2_VPD_LEN,
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |      pci_vpd_find_info_keyword

Caused by commit

  ddc122aac91f ("bnx2: Search VPD with pci_vpd_find_ro_info_keyword()")

I have used the net-next tree from next-20210820 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/+ylmqHP=i0YfySSqFQ/x9wl
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmEjA1kACgkQAVBC80lX
0GzFYggAh3Kl/lc7SKIOtE6GnkyWKWSvTURaEdcWh5igZdaecflACzwMGNbjXFjE
e4Z5vgER8VbwjFyD1iR9RwZqQsPysBYmu5bIB4Yes8/TGMQvrMsO1+rdltsuRJU5
KUv7p7vwKW9EPPnPmvZEao7zzF7DyLs7Yc8Z5wGCgzzDZitcw13RjxuVB2pJuJqe
saIlSrQWznT4SgzcXvW2AuAfVP+z9wMTqhCvcxY0yyHKMmMNeSH/aTsHFEQlFn5V
GIo/aa5/xQI5kc2I24k2yKV/9lMZuNtyNdB/bDEMOgVWWs0r4lueCLhRxbeIyiaH
Nj7ymn9iHfEQ91Ia8pOKkywdqIJy3g==
=JIN7
-----END PGP SIGNATURE-----

--Sig_/+ylmqHP=i0YfySSqFQ/x9wl--
