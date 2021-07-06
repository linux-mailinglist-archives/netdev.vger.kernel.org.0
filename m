Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C223BDFA6
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 01:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhGFXN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 19:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbhGFXN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 19:13:59 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775A3C061574;
        Tue,  6 Jul 2021 16:11:19 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GKJFv3Y82z9t0k;
        Wed,  7 Jul 2021 09:11:14 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1625613075;
        bh=0y4+TCTSpG29+lkSp8FnnBkU1yCSP9lCF2dUAo7xvW8=;
        h=Date:From:To:Cc:Subject:From;
        b=ViqpqNhOkmGk6omv3MdO5Xo9wzGltRzja/ebfjSkKjwXsDh8SnDomwNtOtFV7P0l8
         0SI+j1dqdYD3EvS5ylVxiXGBjIYXWL4zYeMqW9i1s4uSsCiq4S6FWj8YAHsZcpd+Ff
         7O3qsli2GO3Vltvsm4oOHmzrgJNj1OOxW2gUDcezL6xZat2zMH9RYkoEfK3xtIH/O5
         NEJlHihHrBDv9QJIf95ZdlAkQ+YtzaHP+5xebkYFXYu/mgPxyo8qEkS0WxZQimaD/M
         BPy9+sfLywWcGUA5wszMOUOhXeF1SCGNOu++jzK93dOraCRHwxbT5k0/zzZ7TdVUzE
         pl4ajkiIBPccw==
Date:   Wed, 7 Jul 2021 09:11:13 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Paul Blakey <paulb@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net tree
Message-ID: <20210707091113.366cf39e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/vfgil2FE8QCzHJVA55lNhey";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/vfgil2FE8QCzHJVA55lNhey
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

net/core/dev.c: In function 'gro_list_prepare':
net/core/dev.c:6015:51: error: 'TC_SKB_EXT' undeclared (first use in this f=
unction)
 6015 |    struct tc_skb_ext *skb_ext =3D skb_ext_find(skb, TC_SKB_EXT);
      |                                                   ^~~~~~~~~~
net/core/dev.c:6015:51: note: each undeclared identifier is reported only o=
nce for each function it appears in
net/core/dev.c:6020:19: error: invalid use of undefined type 'struct tc_skb=
_ext'
 6020 |     diffs |=3D p_ext->chain ^ skb_ext->chain;
      |                   ^~
net/core/dev.c:6020:36: error: invalid use of undefined type 'struct tc_skb=
_ext'
 6020 |     diffs |=3D p_ext->chain ^ skb_ext->chain;
      |                                    ^~

Caused by commit

  8550ff8d8c75 ("skbuff: Release nfct refcount on napi stolen or re-used sk=
bs")

I have used the net tree from next-20210706 for today.

--=20
Cheers,
Stephen Rothwell

--Sig_/vfgil2FE8QCzHJVA55lNhey
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDk4xEACgkQAVBC80lX
0Gx3Tgf/a3fFpCF2jwJceBG4ctxIl23QAOO40LJKLb3hvj0QRwCZ0fYIwJ1s5Ry7
SMzsPNqR7LvJUNBwv8FDfAZ0QozlOq9e+Xw8dW5st/aqD/UNe5GIWKqMhIO6xdEV
01QonBEvDYu0m+ILRaitTihG1x146CvFzXuAGkUkN8TV37QqRjbUEjh2Qi+aXX4y
lj0Oerp5xDiWaxnX8QZt6adfSVZLHoMLzfTFKIt+BYQsJTVsgh96GbF28bDYdW0G
Ai0XLK3SDPXNZD+D3hnKhE8td9iC4HfsVmJdXW1j/jwVLF3+yRSZqkavhMKGbC/M
b5LQWoO/U7YzCn5XANcftL/dIkVuQQ==
=+SRs
-----END PGP SIGNATURE-----

--Sig_/vfgil2FE8QCzHJVA55lNhey--
