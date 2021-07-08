Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912203BF463
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 06:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbhGHEEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 00:04:14 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:33415 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhGHEEM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 00:04:12 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GL2fL016rz9sWc;
        Thu,  8 Jul 2021 14:01:29 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1625716890;
        bh=+YKT9mu/IH/qnVN0da4QeNjh6/6UrY9CLaqCs/Yq0is=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ISF7t1bYChpz72rAhrG1ZQqQRx/Oj7YOXn6IPniuQniUmh5wRs4hlvjxzf8nNpjQX
         6/s5LCrrHxKUWNOvhk+kIbYpUsgvjtEvEfkXNYZVv/yq8kxVr8UGvGH/YlYEDAYGzA
         8U/BtLU9crgycEb6qcCpEHMHtxjUi+1l0CqB24x39Fk/jIuszgXnElsISJSYFlRD+M
         Lc+kpBzBNHk874d3iqz3wjUHqtFxaPrlx1GjdpFGAJ8LtXF+MjgSuhNo8NS16G+PmH
         VR6+3SB+486tl5DyfZT9GlB9u43mN7kOL2IVVKThPgzQM5YzRI3kRg5MSF/57MNxP5
         E9E+myxdDluBg==
Date:   Thu, 8 Jul 2021 14:01:28 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Paul Blakey <paulb@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net tree
Message-ID: <20210708140128.7bce7b72@canb.auug.org.au>
In-Reply-To: <20210707091113.366cf39e@canb.auug.org.au>
References: <20210707091113.366cf39e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/SqyUqOHSO6gGZ/rVxAGSa6j";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/SqyUqOHSO6gGZ/rVxAGSa6j
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 7 Jul 2021 09:11:13 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> After merging the net tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> net/core/dev.c: In function 'gro_list_prepare':
> net/core/dev.c:6015:51: error: 'TC_SKB_EXT' undeclared (first use in this=
 function)
>  6015 |    struct tc_skb_ext *skb_ext =3D skb_ext_find(skb, TC_SKB_EXT);
>       |                                                   ^~~~~~~~~~
> net/core/dev.c:6015:51: note: each undeclared identifier is reported only=
 once for each function it appears in
> net/core/dev.c:6020:19: error: invalid use of undefined type 'struct tc_s=
kb_ext'
>  6020 |     diffs |=3D p_ext->chain ^ skb_ext->chain;
>       |                   ^~
> net/core/dev.c:6020:36: error: invalid use of undefined type 'struct tc_s=
kb_ext'
>  6020 |     diffs |=3D p_ext->chain ^ skb_ext->chain;
>       |                                    ^~
>=20
> Caused by commit
>=20
>   8550ff8d8c75 ("skbuff: Release nfct refcount on napi stolen or re-used =
skbs")
>=20
> I have used the net tree from next-20210706 for today.

I am still getting this error.  The definition of TC_SKB_EXT depend on
CONFIG_NET_TC_SKB_EXT.

--=20
Cheers,
Stephen Rothwell

--Sig_/SqyUqOHSO6gGZ/rVxAGSa6j
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDmeJgACgkQAVBC80lX
0GzHdAf/dvx+k6w+rMyQUKbd1UV7BUl/5yoSd0xO8YTzjRVBkNBAGMRIL1kMpDE9
wpEPgGCjNI7hc6dImbU/0CykR4w/2oORq+sZCHMH5VKW84WUk2IeK6JL33Szcucf
o8JPJ47Jb+7OyAJxkt7B4aMq8KpZT4iJQ1ZN/IetT+bS8astGd5/UzDMG4rrCwOb
9sEiGLLQMt8C1W5jo6ZydPZXdJ3Jui+nphuBBZxIAt8x5pD9yw8Giez8Rp4Adg/h
uTMuVkag7uP4gkDB28nThI7QmzOUTn7vA1K1WhBCV723nsFq7Wim9UY2csSGedsD
GNUpC5z+vhrUyuIJsMrBXujJXIAQ1w==
=BQod
-----END PGP SIGNATURE-----

--Sig_/SqyUqOHSO6gGZ/rVxAGSa6j--
