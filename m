Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6713885DD
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 06:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbhESEHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 00:07:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbhESEG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 00:06:58 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0FFC06175F;
        Tue, 18 May 2021 21:05:39 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FlK6667Q4z9sRf;
        Wed, 19 May 2021 14:05:34 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1621397136;
        bh=pauE8XMkpcl5YeU9UQe+H4otsmdHP12qTD5+jPriKds=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H67ZlgmgSuwuD4q7fx+JZepYdYzW05QsLkRaR08zroGyV4Rm09PROUKNOnyuyB3er
         xkjfuCzn5U0Pq4j1y5oxclhNo/b2Ai4V6c/6AT+X9BGj/yAQqNBaXBZB5itsdUTymD
         9ZhOpoUeJtzfLgFDjlsAgySNONun0s5mdjH7jGKHJBWoE0BCpnuc36oou6u3s+udzg
         cui6LzBqoki/+nHK09tcqLCxb93h+KpKxzCEkxS7ZqFBC4GH8jRr12hS2F2VSNYLdK
         4XRGtVu/xaNe9JJ9F6qqFSb45X3wsqjgo9HFmvzoviQPARip8zkhtvUkroCIOlH+aK
         jUEvXHI4Cjnlg==
Date:   Wed, 19 May 2021 14:05:32 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stefano Brivio <sbrivio@redhat.com>
Subject: Re: linux-next: manual merge of the netfilter-next tree with the
 net tree
Message-ID: <20210519140532.677d1bb6@canb.auug.org.au>
In-Reply-To: <20210519095627.7697ff12@canb.auug.org.au>
References: <20210519095627.7697ff12@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/fk7n6zHb2ovrZiubd3gbaHl";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/fk7n6zHb2ovrZiubd3gbaHl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 19 May 2021 09:56:27 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the netfilter-next tree got a conflict in:
>=20
>   net/netfilter/nft_set_pipapo.c
>=20
> between commit:
>=20
>   f0b3d338064e ("netfilter: nft_set_pipapo_avx2: Add irq_fpu_usable() che=
ck, fallback to non-AVX2 version")
>=20
> from the net tree and commit:
>=20
>   b1bc08f6474f ("netfilter: nf_tables: prefer direct calls for set lookup=
s")
>=20
> from the netfilter-next tree.
>=20
> I fixed it up (I just used the latter) and can carry the fix as necessary=
. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

This merge also needs the following merge resolution patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 19 May 2021 13:48:22 +1000
Subject: [PATCH] fix up for merge involving nft_pipapo_lookup()

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/netfilter/nft_set_pipapo.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.h b/net/netfilter/nft_set_pipapo.h
index d84afb8fa79a..25a75591583e 100644
--- a/net/netfilter/nft_set_pipapo.h
+++ b/net/netfilter/nft_set_pipapo.h
@@ -178,8 +178,6 @@ struct nft_pipapo_elem {
=20
 int pipapo_refill(unsigned long *map, int len, int rules, unsigned long *d=
st,
 		  union nft_pipapo_map_bucket *mt, bool match_only);
-bool nft_pipapo_lookup(const struct net *net, const struct nft_set *set,
-		       const u32 *key, const struct nft_set_ext **ext);
=20
 /**
  * pipapo_and_field_buckets_4bit() - Intersect 4-bit buckets
--=20
2.30.2

--=20
Cheers,
Stephen Rothwell

--Sig_/fk7n6zHb2ovrZiubd3gbaHl
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCkjowACgkQAVBC80lX
0Gyfhgf+LJu3irilPR9sd9/H8elwRHyLTv6/ff1mBI3efU4oM7G1ucFWmEfgK9Mp
CpMTpioNmg0O3IlALWc1BbFLQ6oJ9UFbg9gQcMgKllo8sZDoiCdbRCrekTaGDT/R
P/msJd7qBpxsaoYi2pZ4Dyt5fOd+qFz7BURrWCSpJpNzeXVJPJGJ6W2TpPoqCA7B
uyVklY5OA3ra8/k1sV8+bIxIUI29r1j2BtdNU4G/rVxv2f5F0SlPjZUyqzxY6Zqe
gE1WzfDDbu1um6W8dgEOWL9Bq3KT4FWYqDFS7pJJ/FuIH8zkU01GHO2sLPw85HCy
d+PclL1aPQXgmV44gJg5xZj0Fu8I1g==
=MFdv
-----END PGP SIGNATURE-----

--Sig_/fk7n6zHb2ovrZiubd3gbaHl--
