Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBC250018
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 05:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbfFXDMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 23:12:51 -0400
Received: from ozlabs.org ([203.11.71.1]:36283 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726917AbfFXDMu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jun 2019 23:12:50 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45XDqy4v4qz9s6w;
        Mon, 24 Jun 2019 13:12:45 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1561345966;
        bh=vbo3C0mpaPp/faqogNOplgIER0UdA+wI6HpKf1tNKfQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MyRc+DEfsB2tt04AREDBb3EaQnR03G1DjHEwRFBEW0uIaVviF5RCvFs1/KJiefkCa
         ZIWqpvYorMliEYB32oUo+mfeWyvBBTFyJw0PNYObq7yLLN5F6neGc6VGaiI87nzUGm
         AhSlc10HFgcrtHykiogAN9DibjfGk3LaFCrojHbLJMcMzIPn1/KYTPlwBM86Qpf4bO
         qkZvga+3V+OTSjsYo9qFfZNUl6z8wOU4GgwpUP1xj7ioF+6E2WSrmwBC5cNh/u1bXn
         qckIH9M6017h6kIObXNYJ49YbKW0e4nLmkdZqv3PkzVqdtBr2c+1Ga8RqmUVNehiCf
         67ZOC7jXA0Q9w==
Date:   Mon, 24 Jun 2019 13:12:45 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yash Shah <yash.shah@sifive.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20190624131245.359e59a4@canb.auug.org.au>
In-Reply-To: <20190620191348.335b011d@canb.auug.org.au>
References: <20190620191348.335b011d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/nn.enAFUOl5qss4rZJlmVN."; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/nn.enAFUOl5qss4rZJlmVN.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 20 Jun 2019 19:13:48 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the net-next tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>=20
> drivers/net/ethernet/cadence/macb_main.c:48:16: error: field 'hw' has inc=
omplete type
>   struct clk_hw hw;
>                 ^~
> drivers/net/ethernet/cadence/macb_main.c:4003:21: error: variable 'fu540_=
c000_ops' has initializer but incomplete type
>  static const struct clk_ops fu540_c000_ops =3D {
>                      ^~~~~~~
> drivers/net/ethernet/cadence/macb_main.c:4004:3: error: 'const struct clk=
_ops' has no member named 'recalc_rate'
>   .recalc_rate =3D fu540_macb_tx_recalc_rate,
>    ^~~~~~~~~~~
> drivers/net/ethernet/cadence/macb_main.c:4004:17: warning: excess element=
s in struct initializer
>   .recalc_rate =3D fu540_macb_tx_recalc_rate,
>                  ^~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/cadence/macb_main.c:4004:17: note: (near initializat=
ion for 'fu540_c000_ops')
> drivers/net/ethernet/cadence/macb_main.c:4005:3: error: 'const struct clk=
_ops' has no member named 'round_rate'
>   .round_rate =3D fu540_macb_tx_round_rate,
>    ^~~~~~~~~~
> drivers/net/ethernet/cadence/macb_main.c:4005:16: warning: excess element=
s in struct initializer
>   .round_rate =3D fu540_macb_tx_round_rate,
>                 ^~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/cadence/macb_main.c:4005:16: note: (near initializat=
ion for 'fu540_c000_ops')
> drivers/net/ethernet/cadence/macb_main.c:4006:3: error: 'const struct clk=
_ops' has no member named 'set_rate'
>   .set_rate =3D fu540_macb_tx_set_rate,
>    ^~~~~~~~
> drivers/net/ethernet/cadence/macb_main.c:4006:14: warning: excess element=
s in struct initializer
>   .set_rate =3D fu540_macb_tx_set_rate,
>               ^~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/cadence/macb_main.c:4006:14: note: (near initializat=
ion for 'fu540_c000_ops')
> drivers/net/ethernet/cadence/macb_main.c: In function 'fu540_c000_clk_ini=
t':
> drivers/net/ethernet/cadence/macb_main.c:4013:23: error: storage size of =
'init' isn't known
>   struct clk_init_data init;
>                        ^~~~
> drivers/net/ethernet/cadence/macb_main.c:4032:12: error: implicit declara=
tion of function 'clk_register'; did you mean 'sock_register'? [-Werror=3Di=
mplicit-function-declaration]
>   *tx_clk =3D clk_register(NULL, &mgmt->hw);
>             ^~~~~~~~~~~~
>             sock_register
> drivers/net/ethernet/cadence/macb_main.c:4013:23: warning: unused variabl=
e 'init' [-Wunused-variable]
>   struct clk_init_data init;
>                        ^~~~
> drivers/net/ethernet/cadence/macb_main.c: In function 'macb_probe':
> drivers/net/ethernet/cadence/macb_main.c:4366:2: error: implicit declarat=
ion of function 'clk_unregister'; did you mean 'sock_unregister'? [-Werror=
=3Dimplicit-function-declaration]
>   clk_unregister(tx_clk);
>   ^~~~~~~~~~~~~~
>   sock_unregister
> drivers/net/ethernet/cadence/macb_main.c: At top level:
> drivers/net/ethernet/cadence/macb_main.c:4003:29: error: storage size of =
'fu540_c000_ops' isn't known
>  static const struct clk_ops fu540_c000_ops =3D {
>                              ^~~~~~~~~~~~~~
>=20
> Caused by commit
>=20
>   c218ad559020 ("macb: Add support for SiFive FU540-C000")
>=20
> CONFIG_COMMON_CLK is not set for this build.
>=20
> I have reverted that commit for today.

I am still reverting that commit.  Has this problem been fixed in some
subtle way?
--=20
Cheers,
Stephen Rothwell

--Sig_/nn.enAFUOl5qss4rZJlmVN.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0QP60ACgkQAVBC80lX
0Gxyxwf+OymQ1NHOgBTVJFL0Dl2ywmZ8pm1YeJ+ElTWzEUk3Ck6CHVFEaD7vXTxg
48ZKssjI3KTrQ1c3A1+tgz1ktjLjtZ/IX8oNRB/ixN2w+fuIyfa8inoe7QbVOeCP
cDzm6dJc+heg7hdqJ/Czi6UotHbTWVcM4RXeAfhdvYsjlrILlM3ieom8OjvfMMkH
CJjRpdkfZqJBvuIkz8uyvyqjpTtKaynIWlD1CnKzK8toyA+bAxT6SvgJ/4TuxRyK
vSpjKs6E3QcFGhkG2kod0f5SRgpK5iVr1dlTMVzMuIR+s65P8OZcOUGoZQJGkZKh
IBWRgzFGhZYPo2RYjVSmKK7mbFUdpQ==
=MOgz
-----END PGP SIGNATURE-----

--Sig_/nn.enAFUOl5qss4rZJlmVN.--
