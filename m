Return-Path: <netdev+bounces-11249-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 587AB7322C2
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 00:31:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D6012815D1
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 22:31:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0157610E;
	Thu, 15 Jun 2023 22:30:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44B619928
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 22:30:59 +0000 (UTC)
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A40D1FD4;
	Thu, 15 Jun 2023 15:30:56 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4Qhxp35sPpz4wjD;
	Fri, 16 Jun 2023 08:30:51 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
	s=201702; t=1686868252;
	bh=ueCWAMDvwOyDbW7uXq2ByaTQQcg7zZajxDowPF71drk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kqwB6eJXu3saeKNgTPpum8C3qUWyIykeiA4B7Ivi4FdA2gjZKCuPwERzfLJgfaEys
	 stcNJNDsK9CeGXtS0h8pD31g2eAVHpcmOcLmPx6DKoR2rCJtaoVFZ+XrFEPidHJX86
	 wH1L7jVqX7ujJgAY5EGPHpC5OOU6owNdRdu9QRdA75L7l1peWH7TpdCILRGmzQMlFU
	 HbYrdTntUl9fqkJMUXKiRt20uchN5xpLIYf1IiTJ3yniDejY1oXHlKspaoyVJYHXR+
	 sTf24ybvQ/gLuCIaV7fDIQQcglk5Ppyhgv2gvyhaRXyh0ry13vUyIwTGwKVSJ0nS5q
	 qh4sucWZbc2Pg==
Date: Fri, 16 Jun 2023 08:30:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, Networking <netdev@vger.kernel.org>
Cc: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Next
 Mailing List <linux-next@vger.kernel.org>, Simon Horman
 <simon.horman@corigine.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20230616083033.748f2def@canb.auug.org.au>
In-Reply-To: <20230613164639.164b2991@canb.auug.org.au>
References: <20230613164639.164b2991@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Z9AlY.W8SK3_1+irWRBzsR7";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--Sig_/Z9AlY.W8SK3_1+irWRBzsR7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 13 Jun 2023 16:46:39 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the net-next tree, today's linux-next build (sparc64
> defconfig) failed like this:
>=20
> drivers/net/ethernet/sun/sunvnet_common.c: In function 'vnet_handle_offlo=
ads':
> drivers/net/ethernet/sun/sunvnet_common.c:1277:16: error: implicit declar=
ation of function 'skb_gso_segment'; did you mean 'skb_gso_reset'? [-Werror=
=3Dimplicit-function-declaration]
>  1277 |         segs =3D skb_gso_segment(skb, dev->features & ~NETIF_F_TS=
O);
>       |                ^~~~~~~~~~~~~~~
>       |                skb_gso_reset
> drivers/net/ethernet/sun/sunvnet_common.c:1277:14: warning: assignment to=
 'struct sk_buff *' from 'int' makes pointer from integer without a cast [-=
Wint-conversion]
>  1277 |         segs =3D skb_gso_segment(skb, dev->features & ~NETIF_F_TS=
O);
>       |              ^
>=20
> Caused by commit
>=20
>   d457a0e329b0 ("net: move gso declarations and functions to their own fi=
les")
>=20
> I have applied the following patch for today.
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 13 Jun 2023 16:38:10 +1000
> Subject: [PATCH] Fix a sparc64 use of the gso functions
>=20
> This was missed when they were moved.
>=20
> Fixes: d457a0e329b0 ("net: move gso declarations and functions to their o=
wn files")
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/net/ethernet/sun/sunvnet_common.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/ethernet/sun/sunvnet_common.c b/drivers/net/ethe=
rnet/sun/sunvnet_common.c
> index a6211b95ed17..3525d5c0d694 100644
> --- a/drivers/net/ethernet/sun/sunvnet_common.c
> +++ b/drivers/net/ethernet/sun/sunvnet_common.c
> @@ -25,6 +25,7 @@
>  #endif
> =20
>  #include <net/ip.h>
> +#include <net/gso.h>
>  #include <net/icmp.h>
>  #include <net/route.h>
> =20

I am still applying that patch to the net-next tree merge.
--=20
Cheers,
Stephen Rothwell

--Sig_/Z9AlY.W8SK3_1+irWRBzsR7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmSLkQkACgkQAVBC80lX
0Gz8cwf/cJV2+T+zzPzWXRjPvHb88fVcdoDJa5Sxdpfa7XWOoa2nm/XfRlNS1bEV
C/0eVhQ7K45f9Lt6U1xbzlIaqH6KeQcfd+waRz4l38x2sSKz+U3B6vXEaqCy+2HU
rKCifxxrtd6uNlKxB0AZZdkfJVDM8s5GWWL8wQBZSR5U1SMQ4TD8BVOmDwJd8Fx3
K1WB3bksf6dEBGr89cx2NAhJmjc73DdwzPMfraM4Tn9dcmfaJcDD2j1u/fRDHrYp
oYW7jrakdxV/B7iurOUDZVKpXR8h76D89ebxfv9qb3SFWDUUFftoE6T6eYrLv4Ad
9BM0soKEknVg2JnjejflPVEC8H3Tkg==
=tTtV
-----END PGP SIGNATURE-----

--Sig_/Z9AlY.W8SK3_1+irWRBzsR7--

