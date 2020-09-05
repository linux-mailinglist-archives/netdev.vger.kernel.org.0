Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3BD25E54E
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 06:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgIEEKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 00:10:07 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:41349 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgIEEKG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 00:10:06 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Bk1KQ1tPwz9sTM;
        Sat,  5 Sep 2020 14:10:02 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1599279003;
        bh=9eB4K8KoHD4blH4JPzEEGzol5NGmZwBzc3bm9jCe0kI=;
        h=Date:From:To:Cc:Subject:From;
        b=LjFj2AIzb35wjXOq5pROkUpUqJfsZ6YyZkkOOecS7cAUKK4vIXLmByARMLfthuVGe
         Q7bWJGGDIBmOotHRuDu6fh3n4sUbw+ldg6pnVo8PESucg0kKIsh+wajsD4xAgV3GlB
         AJkSbwIaH7SmyEv0gF/MP8s5tZhCUX/8OAImWwn/ZItEv3AVcGYadcYl8dm9zIdChJ
         WACX2fAiccSg6+/SUZA/ooj0k34U+s3metO5SxJmW9Ey17/pmuHcZmow5wtQfF4sL4
         Buf1qIy7rby0N0UnM0rUrpAW3j4MyJb4ncs1xSMzwwGXujdF9YR9UYKwchZNwhbJIP
         yTFWyoOrVmm7w==
Date:   Sat, 5 Sep 2020 14:10:01 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: linux-next: manual merge of the akpm-current tree with the net-next
 tree
Message-ID: <20200905141001.18356cd4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/xDXJQWw/zaBTRUF_p6lJ0UI";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/xDXJQWw/zaBTRUF_p6lJ0UI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the akpm-current tree got a conflict in:

  mm/filemap.c

between commit:

  76cd61739fd1 ("mm/error_inject: Fix allow_error_inject function signature=
s.")

from the net-next tree and commit:

  2cb138387ead ("mm/filemap: fix storing to a THP shadow entry")

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

diff --cc mm/filemap.c
index 78d07a712112,054d93a86f8a..000000000000
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@@ -827,10 -827,10 +827,10 @@@ int replace_page_cache_page(struct pag
  }
  EXPORT_SYMBOL_GPL(replace_page_cache_page);
 =20
- static int __add_to_page_cache_locked(struct page *page,
- 				      struct address_space *mapping,
- 				      pgoff_t offset, gfp_t gfp,
- 				      void **shadowp)
+ noinline int __add_to_page_cache_locked(struct page *page,
+ 					struct address_space *mapping,
 -					pgoff_t offset, gfp_t gfp_mask,
++					pgoff_t offset, gfp_t gfp,
+ 					void **shadowp)
  {
  	XA_STATE(xas, &mapping->i_pages, offset);
  	int huge =3D PageHuge(page);

--Sig_/xDXJQWw/zaBTRUF_p6lJ0UI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9TD5kACgkQAVBC80lX
0GzlKwgAgyPjNJJsKV57McF4UsmQEqwOJ3GQH1rH7VPoaZbHkktEE6jo1/rAYlz2
yuAcC0nN+BemNvQOxPGlyTFZ08viniDhMqhvwDfnsonaqlIAAQy78IbjtajYvKTK
0eBGNal9g2+NOCnRBx1RmuZaa6SGRNgUNjvgoH75ZbIB7fm4MH2nkCqyPZ/rSJ+9
5y6Hb7C+fCTcBXePvSZAJNzphTGrgvRMXWZ0azWB4ffm25yg5PHjWj0sOWWjowob
3noca6AI9xt8a5ajokOu3VN8kcfGFrfn1AuMyXV/liat28V7DNwviOvuNdIh+CEx
JnInXbOAEI5Pw4cJ12frbEKNMZmA8g==
=DI4q
-----END PGP SIGNATURE-----

--Sig_/xDXJQWw/zaBTRUF_p6lJ0UI--
