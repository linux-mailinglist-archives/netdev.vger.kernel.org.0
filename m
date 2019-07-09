Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFBF62F1D
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 06:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfGID7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:59:52 -0400
Received: from ozlabs.org ([203.11.71.1]:35047 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbfGID7w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 23:59:52 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45jT9J2k2dz9s7T;
        Tue,  9 Jul 2019 13:59:47 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562644788;
        bh=RgjpdRAvdzbPAMVLAeQMRJv+UJy8bs/j18MWrpoy9Og=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l9HD78KpfDWMpjSQLQ/aJuDVQn23+9qjQuL/zpniYcKni9gOtaiva//OWfpNWolbr
         PMahEF9iXg/MnRGBAZfW0GxMvoTgLNsgAb5o0RJe8dyp0Op/8ww/QuRXrDNkcaNALP
         FqVW6w1lalePk8Nov9Ff+2W3oKmA1TfgFn4yuebAH9Pk//2SOBmkraaoT1OEYUllIb
         W7JkfLpKM89ljU6q1/MFn0Fp9yNA3RgmrlNADyWj/zJFpxbXkA+MUQtgOWBdOKo1GY
         jlgQLvD1Y/E8DsIF6vsgmz/6URUW/cw58fVp7Aw3ax/1ikJrnNqpFse/BWBmKkyabW
         erav/B2AJQ6PA==
Date:   Tue, 9 Jul 2019 13:59:47 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        wenxu <wenxu@ucloud.cn>
Subject: Re: linux-next: build failure after merge of the netfilter-next
 tree
Message-ID: <20190709135947.225603dc@canb.auug.org.au>
In-Reply-To: <20190708133958.6a30f5cb@canb.auug.org.au>
References: <20190708133958.6a30f5cb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/hz4YiY3dpqX1kPdvlStk//p"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/hz4YiY3dpqX1kPdvlStk//p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 8 Jul 2019 13:39:58 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> After merging the netfilter-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> In file included from <command-line>:
> include/net/netfilter/nft_meta.h:6:21: warning: 'key' is narrower than va=
lues of its type
>   enum nft_meta_keys key:8;
>                      ^~~
> include/net/netfilter/nft_meta.h:6:21: error: field 'key' has incomplete =
type
> include/net/netfilter/nft_meta.h:8:22: warning: 'dreg' is narrower than v=
alues of its type
>    enum nft_registers dreg:8;
>                       ^~~~
> include/net/netfilter/nft_meta.h:8:22: error: field 'dreg' has incomplete=
 type
> include/net/netfilter/nft_meta.h:9:22: warning: 'sreg' is narrower than v=
alues of its type
>    enum nft_registers sreg:8;
>                       ^~~~
> include/net/netfilter/nft_meta.h:9:22: error: field 'sreg' has incomplete=
 type
> include/net/netfilter/nft_meta.h:13:32: error: array type has incomplete =
element type 'struct nla_policy'
>  extern const struct nla_policy nft_meta_policy[];
>                                 ^~~~~~~~~~~~~~~
> include/net/netfilter/nft_meta.h:17:22: warning: 'struct nlattr' declared=
 inside parameter list will not be visible outside of this definition or de=
claration
>          const struct nlattr * const tb[]);
>                       ^~~~~~
> include/net/netfilter/nft_meta.h:16:22: warning: 'struct nft_expr' declar=
ed inside parameter list will not be visible outside of this definition or =
declaration
>          const struct nft_expr *expr,
>                       ^~~~~~~~
> include/net/netfilter/nft_meta.h:15:36: warning: 'struct nft_ctx' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration
>  int nft_meta_get_init(const struct nft_ctx *ctx,
>                                     ^~~~~~~
> include/net/netfilter/nft_meta.h:21:22: warning: 'struct nlattr' declared=
 inside parameter list will not be visible outside of this definition or de=
claration
>          const struct nlattr * const tb[]);
>                       ^~~~~~
> include/net/netfilter/nft_meta.h:20:22: warning: 'struct nft_expr' declar=
ed inside parameter list will not be visible outside of this definition or =
declaration
>          const struct nft_expr *expr,
>                       ^~~~~~~~
> include/net/netfilter/nft_meta.h:19:36: warning: 'struct nft_ctx' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration
>  int nft_meta_set_init(const struct nft_ctx *ctx,
>                                     ^~~~~~~
> include/net/netfilter/nft_meta.h:24:22: warning: 'struct nft_expr' declar=
ed inside parameter list will not be visible outside of this definition or =
declaration
>          const struct nft_expr *expr);
>                       ^~~~~~~~
> include/net/netfilter/nft_meta.h:23:30: warning: 'struct sk_buff' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration
>  int nft_meta_get_dump(struct sk_buff *skb,
>                               ^~~~~~~
> include/net/netfilter/nft_meta.h:27:22: warning: 'struct nft_expr' declar=
ed inside parameter list will not be visible outside of this definition or =
declaration
>          const struct nft_expr *expr);
>                       ^~~~~~~~
> include/net/netfilter/nft_meta.h:26:30: warning: 'struct sk_buff' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration
>  int nft_meta_set_dump(struct sk_buff *skb,
>                               ^~~~~~~
> include/net/netfilter/nft_meta.h:31:23: warning: 'struct nft_pktinfo' dec=
lared inside parameter list will not be visible outside of this definition =
or declaration
>           const struct nft_pktinfo *pkt);
>                        ^~~~~~~~~~~
> include/net/netfilter/nft_meta.h:30:17: warning: 'struct nft_regs' declar=
ed inside parameter list will not be visible outside of this definition or =
declaration
>           struct nft_regs *regs,
>                  ^~~~~~~~
> include/net/netfilter/nft_meta.h:29:37: warning: 'struct nft_expr' declar=
ed inside parameter list will not be visible outside of this definition or =
declaration
>  void nft_meta_get_eval(const struct nft_expr *expr,
>                                      ^~~~~~~~
> include/net/netfilter/nft_meta.h:35:23: warning: 'struct nft_pktinfo' dec=
lared inside parameter list will not be visible outside of this definition =
or declaration
>           const struct nft_pktinfo *pkt);
>                        ^~~~~~~~~~~
> include/net/netfilter/nft_meta.h:34:17: warning: 'struct nft_regs' declar=
ed inside parameter list will not be visible outside of this definition or =
declaration
>           struct nft_regs *regs,
>                  ^~~~~~~~
> include/net/netfilter/nft_meta.h:33:37: warning: 'struct nft_expr' declar=
ed inside parameter list will not be visible outside of this definition or =
declaration
>  void nft_meta_set_eval(const struct nft_expr *expr,
>                                      ^~~~~~~~
> include/net/netfilter/nft_meta.h:38:19: warning: 'struct nft_expr' declar=
ed inside parameter list will not be visible outside of this definition or =
declaration
>       const struct nft_expr *expr);
>                    ^~~~~~~~
> include/net/netfilter/nft_meta.h:37:40: warning: 'struct nft_ctx' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration
>  void nft_meta_set_destroy(const struct nft_ctx *ctx,
>                                         ^~~~~~~
> include/net/netfilter/nft_meta.h:42:19: warning: 'struct nft_data' declar=
ed inside parameter list will not be visible outside of this definition or =
declaration
>       const struct nft_data **data);
>                    ^~~~~~~~
> include/net/netfilter/nft_meta.h:41:19: warning: 'struct nft_expr' declar=
ed inside parameter list will not be visible outside of this definition or =
declaration
>       const struct nft_expr *expr,
>                    ^~~~~~~~
> include/net/netfilter/nft_meta.h:40:40: warning: 'struct nft_ctx' declare=
d inside parameter list will not be visible outside of this definition or d=
eclaration
>  int nft_meta_set_validate(const struct nft_ctx *ctx,
>                                         ^~~~~~~
>=20
> Caused by commit
>=20
>   30e103fe24de ("netfilter: nft_meta: move bridge meta keys into nft_meta=
_bridge")
>=20
> interacting with commit
>=20
>   3a768d9f7ae5 ("kbuild: compile-test kernel headers to ensure they are s=
elf-contained")
>=20
> from the kbuild tree.
>=20
> I have applied the following patch for today.
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 8 Jul 2019 13:34:42 +1000
> Subject: [PATCH] don't test build another netfilter header
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  include/Kbuild | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/include/Kbuild b/include/Kbuild
> index 78434c59701f..cfd73c94d015 100644
> --- a/include/Kbuild
> +++ b/include/Kbuild
> @@ -900,6 +900,7 @@ header-test-			+=3D net/netfilter/nf_tables_core.h
>  header-test-			+=3D net/netfilter/nf_tables_ipv4.h
>  header-test-			+=3D net/netfilter/nf_tables_ipv6.h
>  header-test-			+=3D net/netfilter/nft_fib.h
> +header-test-			+=3D net/netfilter/nft_meta.h
>  header-test-			+=3D net/netfilter/nft_reject.h
>  header-test-			+=3D net/netns/can.h
>  header-test-			+=3D net/netns/generic.h

I reported this yesterday against the netflter-next tree, but now the
fix patch is needed in the merge of the net-next tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/hz4YiY3dpqX1kPdvlStk//p
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0kETMACgkQAVBC80lX
0GxRnwf+MiRLsKZsmwRDeYoqyZYev7qEhxT3w3Mgk5Uv5JbqGs/VKzKgDtnnMPbF
oHh+Hb+vio1WsbNX99nym5KaCq0jgVrjPganqE375dzl8CoARnb/K2NjmTurzQ7y
ZQzx1g/sTiRo+0BP7EF/i6gsiLoiw10n8GgnX1wkRsC/K34wZ+ZR3XgiGNMw0ssy
8j3NdSbIofTAevJI11HUoZ3ghPdzqkg+RKchk1ySN4vDuOVCtJhoBpy/NBHeST08
TEeNXorTMhuDdHeNLdf4+TgSfKXVXzHFngrzpCQrB/ewUCtWTSf2G2HdloUN0GpB
PCVd1+1ViowhjuF1pxc7aMOrLx1rGg==
=hLZQ
-----END PGP SIGNATURE-----

--Sig_/hz4YiY3dpqX1kPdvlStk//p--
