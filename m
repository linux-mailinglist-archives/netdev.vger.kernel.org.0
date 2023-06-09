Return-Path: <netdev+bounces-9404-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6978728C8D
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 02:40:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 272541C21080
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 00:40:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06CAB7F1;
	Fri,  9 Jun 2023 00:40:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2287E6
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 00:40:46 +0000 (UTC)
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C312697;
	Thu,  8 Jun 2023 17:40:44 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4Qcj162RQ9z4x42;
	Fri,  9 Jun 2023 10:40:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1686271242;
	bh=N/d6yAoCqDOR/EUBWSzsbrF4pUagpzq/67B3ewK+ELM=;
	h=Date:From:To:Cc:Subject:From;
	b=D7yo6pdWBHVGuqZv+pUFXTIlKkqMWFerXgdKtT2VTKcA9jMtG0UKFIllZ4H4zdaNL
	 byP9XkkY71sDX0Si5f2Hu2tmQvdP2YMUwTeSqhUOrtUsKgUioNByAnXDoOD2UeD96n
	 ypTEJsqM6UTJnCfF1Br7kFIRT0yi/Ut5eWsrBd/HrkQpVKaiw+cz9l3Aq+DwoGeSKv
	 zgvr0FeZvP8f7AtRFA0VGxkK7dqMdkmFwgmn3E105RtNCHIC8i0tG/8oNvBZHjcaVc
	 l6RBErYGVn/ALQcZe8+wQUfn1/17+A2X90vsebIBryiI/rrcRfi5lTcbTs1mnB+wlL
	 CGtK41NvQnIxQ==
Date: Fri, 9 Jun 2023 10:40:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, Arnd Bergmann <arnd@arndb.de>
Cc: Networking <netdev@vger.kernel.org>, David Howells
 <dhowells@redhat.com>, Linus Walleij <linus.walleij@linaro.org>, Linux
 Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next Mailing List
 <linux-next@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: linux-next: manual merge of the net-next tree with the asm-generic
 tree
Message-ID: <20230609104037.56648990@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/pq6wYUgfstq9+2qI0JoQ9jD";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/pq6wYUgfstq9+2qI0JoQ9jD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  fs/netfs/iterator.c

between commit:

  ee5971613da3 ("netfs: Pass a pointer to virt_to_page()")

from the asm-generic tree and commit:

  f5f82cd18732 ("Move netfs_extract_iter_to_sg() to lib/scatterlist.c")

from the net-next tree.

I fixed it up (I used the file from the former and applied the patch
below) and can carry the fix as necessary. This is now fixed as far as
linux-next is concerned, but any non trivial conflicts should be mentioned
to your upstream maintainer when your tree is submitted for merging.
You may also want to consider cooperating with the maintainer of the
conflicting tree to minimise any particularly complex conflicts.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 9 Jun 2023 10:35:56 +1000
Subject: [PATCH] fix up for "Move netfs_extract_iter_to_sg() to lib/scatter=
list.c"

interacting with "netfs: Pass a pointer to virt_to_page()"

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 lib/scatterlist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index e97d7060329e..e86231a44c3d 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -1237,7 +1237,7 @@ static ssize_t extract_kvec_to_sg(struct iov_iter *it=
er,
 			if (is_vmalloc_or_module_addr((void *)kaddr))
 				page =3D vmalloc_to_page((void *)kaddr);
 			else
-				page =3D virt_to_page(kaddr);
+				page =3D virt_to_page((void *)kaddr);
=20
 			sg_set_page(sg, page, len, off);
 			sgtable->nents++;
--=20
2.39.2

--=20
Cheers,
Stephen Rothwell

--Sig_/pq6wYUgfstq9+2qI0JoQ9jD
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmSCdQUACgkQAVBC80lX
0GyAigf6A4NkiP2v1mXPGYwq6k4+XJCseY4f2dcD+rGe9j99hJuWTPugeYyPCsJu
2iQOYJB8YjF+QWyQH7icRLv1+kaQfrGUoOmrrdm5FA+SmuTWB1sCjpn+U03al9VW
DWKaODP3yGAyIg3ipc1ahhoHkIfN4kNBU5rr0TUz9OdpbSagPZwU4QcWiYnYfwgs
FSKRYh2KiLPKyLV7L5cfBpoauiyvHYPTo1sW+HD2HD7B5yQORf5hk64pqaCKolCJ
L3pZk8w/L3rEkstaVjSpwu3mfyodXCgQbbeJ10eLZ3ak+aye6NLzLeXiou5+Mk6X
CdXOBxKVaz0Ky27TkucRI2aZj81rfw==
=OTSN
-----END PGP SIGNATURE-----

--Sig_/pq6wYUgfstq9+2qI0JoQ9jD--

