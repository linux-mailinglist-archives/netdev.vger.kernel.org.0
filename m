Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7984CEF3E
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 00:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729629AbfJGWso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 18:48:44 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:54385 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728980AbfJGWso (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 18:48:44 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46nFyK4Mn3z9sPT;
        Tue,  8 Oct 2019 09:48:41 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1570488521;
        bh=G56IR+b8MH/UAZzvFbGgYEyxWfeZdIJW//Ixl1WWE28=;
        h=Date:From:To:Cc:Subject:From;
        b=fU4gg2SccggVyIda0pgORMkhwr0EEU3EfzdpSIeV7h+SBZYvLID+Aoo/gqgnarUcC
         yQKL/skgJvk8RJL308u2joWNI5yy5gsWzZEcjVNX/Z3Vyh9PP0QJPukFjPQQAZqD1u
         puHEfo0aLM211NdJNGkVKCyzHHPzZhCHPQ0hssz5jtk375bN6SCjRdL2v3a1UQ7Bkn
         TwmkeTooPV5G0SN5m2qdBYLe0Uq/7HlJ0muUztP0UJpwoNSY8ZuPyftPURW7DOV5hg
         1hyqfCsPpyCxBYr/AR8p6CdtfFVwmoJzEfAxB+rwUWJR/3EC1xXmwdzLVrzL6R7r+9
         eWwIJWsfTVyFA==
Date:   Tue, 8 Oct 2019 09:48:40 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Subject: linux-next: manual merge of the bpf-next tree with the bpf tree
Message-ID: <20191008094840.1553ff38@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/d1EoAl5ASZ.KkWZIMz60_KJ";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/d1EoAl5ASZ.KkWZIMz60_KJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  tools/lib/bpf/Makefile

between commit:

  1bd63524593b ("libbpf: handle symbol versioning properly for libbpf.a")

from the bpf tree and commit:

  a9eb048d5615 ("libbpf: Add cscope and tags targets to Makefile")

from the bpf-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc tools/lib/bpf/Makefile
index 56ce6292071b,10b77644a17c..000000000000
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@@ -143,7 -133,9 +143,9 @@@ LIB_TARGET	:=3D $(addprefix $(OUTPUT),$(L
  LIB_FILE	:=3D $(addprefix $(OUTPUT),$(LIB_FILE))
  PC_FILE		:=3D $(addprefix $(OUTPUT),$(PC_FILE))
 =20
+ TAGS_PROG :=3D $(if $(shell which etags 2>/dev/null),etags,ctags)
+=20
 -GLOBAL_SYM_COUNT =3D $(shell readelf -s --wide $(BPF_IN) | \
 +GLOBAL_SYM_COUNT =3D $(shell readelf -s --wide $(BPF_IN_SHARED) | \
  			   cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' | \
  			   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$8}' | \
  			   sort -u | wc -l)

--Sig_/d1EoAl5ASZ.KkWZIMz60_KJ
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl2bwMgACgkQAVBC80lX
0Gwv0gf6A2u/cEX6FuZGcHkax6uZAJjxvSvgJXw+Bq54YH0lVG21PcK8H105l/9i
KYD2rUNTyC6xmtx/7yS2FAdwFEvZ9/AfSj8GVGyTKk5zr5CqQiyWXT5R8YsJLWVk
wjACQuGsXcsAb9ErsN6d7zflEJDnHuK3MuJ1mEV/LAMYvNFjLgEGgDiDdn4+S4YX
+x1crKkTXvPHggM8UFQ3sBd/VNdTOVjgbsMn9kc1fV/PUKN8FonnJxYEXTfhUs5b
92rEZvqixOFmMeCqdoryUZuGv/Nuc0lHS8nPAbkR1bWw8X7Rt8O76Z4isibdwPaO
GrSuLnBoqZMSPnuh7l/h2vueNhcv8g==
=tCOe
-----END PGP SIGNATURE-----

--Sig_/d1EoAl5ASZ.KkWZIMz60_KJ--
