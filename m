Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8978121D191
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 10:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729354AbgGMIUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 04:20:30 -0400
Received: from ozlabs.org ([203.11.71.1]:42531 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbgGMIUa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 04:20:30 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4B4xRF6KT1z9sDX;
        Mon, 13 Jul 2020 18:20:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1594628427;
        bh=LH4FOtl0Z+kfpRZwAFFiDHlO3qpDI4fH8c6WKE5JlK4=;
        h=Date:From:To:Cc:Subject:From;
        b=iZZEY+7xZ4Owu8dkWATmnMr4gMb/dpivDUmtJ7lyVWzea/p5ORoLHse3jdw3hpjyE
         IoBD9RIB/IXngv2BCsIhlVlOsnZGx9STLcdBLR/SQhaqyFCfFKLHrjkCqXHtG3/X0g
         WzuEoHcTa+I6NruoM+iBog+hzu35DPsYp/quZZW8YcnrnOsdjTB+6vd+osgXksOyE1
         j6tXhvP+HYm4cPeYlhCVuRhrVov4Gz8u5yi+gCuDRq06foymER6+5M5Z/7bCoFzQYK
         RYL58kXANKz39/8G4Ujz46lvQpXDiXRY18p5NlX4c3JCs2wlzpge0GIdAd+R+LO8jV
         EyH5WWTyyNWwg==
Date:   Mon, 13 Jul 2020 18:20:23 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Barry Song <song.bao.hua@hisilicon.com>
Subject: linux-next: manual merge of the akpm-current tree with the net-next
 tree
Message-ID: <20200713182023.3f08605e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/2Vp1I5dWzQ=eova.7uLLoky";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/2Vp1I5dWzQ=eova.7uLLoky
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the akpm-current tree got a conflict in:

  mm/cma.h

between commit:

  a2b992c828f7 ("debugfs: make sure we can remove u32_array files cleanly")

from the net-next tree and commit:

  bc7212aceef6 ("mm: cma: fix the name of CMA areas")

from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc mm/cma.h
index 6698fa63279b,27d3f0e9f68f..000000000000
--- a/mm/cma.h
+++ b/mm/cma.h
@@@ -2,8 -2,8 +2,10 @@@
  #ifndef __MM_CMA_H__
  #define __MM_CMA_H__
 =20
 +#include <linux/debugfs.h>
 +
+ #define CMA_MAX_NAME 64
+=20
  struct cma {
  	unsigned long   base_pfn;
  	unsigned long   count;
@@@ -13,9 -13,8 +15,9 @@@
  #ifdef CONFIG_CMA_DEBUGFS
  	struct hlist_head mem_head;
  	spinlock_t mem_head_lock;
 +	struct debugfs_u32_array dfs_bitmap;
  #endif
- 	const char *name;
+ 	char name[CMA_MAX_NAME];
  };
 =20
  extern struct cma cma_areas[MAX_CMA_AREAS];

--Sig_/2Vp1I5dWzQ=eova.7uLLoky
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8MGUcACgkQAVBC80lX
0GyeuAf/aFe008ZUac4c96jkCZ7nQnIBL9wZioAPtsMBJM6sDIjWlChbH6qdKJgZ
DeTYAvLzrcX+Z3RjQuRkQrBHS9ulMOC8VYGIblWc7MNJAdV0FKCJEbzM8JolPLN4
GUkiqLmZJvh47sGWs5xnEbk2NZRuQRKZo/XC0vj2bsa4WOFdSE5SYrt0aX3SUgdg
7voHV/9NLuCpQVP4ZrZb7/lpy7BYQZ0Haa7tZdaymJmw6gPnITd/qIVYLIj0AMcv
x/NOY4rVlPPRDIgVODkY30VPmhclDWNQzuyhxT8Mj0YQu3yxNJWL6Li1GdytLXz6
U4BBLAtUcmQwVDV762JLZGAngqH7xA==
=DZqr
-----END PGP SIGNATURE-----

--Sig_/2Vp1I5dWzQ=eova.7uLLoky--
