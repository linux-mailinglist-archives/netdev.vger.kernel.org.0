Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837323D3007
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 01:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbhGVWX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 18:23:58 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:42555 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231713AbhGVWX5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 18:23:57 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4GW7LX1l1Bz9sT6;
        Fri, 23 Jul 2021 09:04:20 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1626995062;
        bh=1dYc/r2vGdfoq+Khj3sHHLPZvn1tMhwl4BbcN3Q/uQs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CMgnkvN9F4PfAoayw/muHQV+WAFEkRSFIpzU+AjGuaFbitV5S2u71+gHizX2Hvdkb
         tgmsI6MDo2aFaYqJO/7uMj2mxBsib4MNM+y6l/46wYYg8H1KPOqmbdrYpuXsZNzfOD
         x030s4u88wuoXsZH1NZXUfHUTS05rYfEuAcDwBnRL65oB9wfWD5dIOD1jYFjrNiWMM
         hNfuMe8LyYrSsZeyKaLRNCK/ceaWCZboSKL4KtK0vfJnJB8wyv5C3EhYCZ3vOiLDbD
         yMp0v/lR06Y7MR1jC/+N1zSsrU7mIpO/uZkKCYlMwYAyMfcT7ys/Ye3OHq5QAsffnT
         06UJzhP/NKq4w==
Date:   Fri, 23 Jul 2021 09:04:19 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: linux-next: build failure in Linus' tree
Message-ID: <20210723090419.529ee5ef@canb.auug.org.au>
In-Reply-To: <20210720141101.78c1b8ba@cakuba>
References: <20210715095032.6897f1f6@canb.auug.org.au>
        <20210720164531.3f122a89@canb.auug.org.au>
        <20210720141101.78c1b8ba@cakuba>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/MGsEM8zq5E4uQoFtFGvvQIW";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/MGsEM8zq5E4uQoFtFGvvQIW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 20 Jul 2021 14:11:01 +0200 Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 20 Jul 2021 16:45:31 +1000, Stephen Rothwell wrote:
> >=20
> > On Thu, 15 Jul 2021 09:50:32 +1000 Stephen Rothwell <sfr@canb.auug.org.=
au> wrote: =20
> > >
> > > While compiling Linus' tree, a powerpc-allmodconfig build (and others)
> > > with gcc 4.9 failed like this:
> > >=20
> > > drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c: In function 'i=
fh_encode_bitfield':
> > > include/linux/compiler_types.h:328:38: error: call to '__compiletime_=
assert_431' declared with attribute error: Unsupported width, must be <=3D =
40
> > >   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTE=
R__)
> > >                                       ^
> > > include/linux/compiler_types.h:309:4: note: in definition of macro '_=
_compiletime_assert'
> > >     prefix ## suffix();    \
> > >     ^
> > > include/linux/compiler_types.h:328:2: note: in expansion of macro '_c=
ompiletime_assert'
> > >   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTE=
R__)
> > >   ^
> > > drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c:28:2: note: in =
expansion of macro 'compiletime_assert'
> > >   compiletime_assert(width <=3D 40, "Unsupported width, must be <=3D =
40");
> > >   ^
> > >=20
> > > Caused by commit
> > >=20
> > >   f3cad2611a77 ("net: sparx5: add hostmode with phylink support")
> > >=20
> > > I guess this is caused by the call to ifh_encode_bitfield() not being
> > > inlined.   =20
> >=20
> > I am still getting these failures. =20
>=20
> Bjarni, Steen, could you address this build failure ASAP?
>=20
> We can't have a compile time asserts in static functions, if the code
> is optimized for size chances are the function won't get inlined. clang
> is pretty bad at propagating constants to compile time asserts, too.
> Please remove this check, or refactor it to be done in a macro, or ..

I am still getting these failures.

--=20
Cheers,
Stephen Rothwell

--Sig_/MGsEM8zq5E4uQoFtFGvvQIW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmD5+XMACgkQAVBC80lX
0Gwr8ggAkx3CBF9vs58H1cjnfEL6pF5lLruvkRDy8v4xLdJXxZ+6B2v+3HyP2dog
Ak/ufAgB1SpN/Ilz9TmXwPTyRqVjP22m9IgOkM5eiTIqfz9itNFW8Eu0jvLOUTL6
2hT6Sb/qVt0a7egyDGxcaGCq9linOEa8qPxCI65meMa/tr2JUQnmVwXCKMWwlMWK
u3+767hZIYG/MMvSWXQA/cfB2CSHeJDD7CwgsfO78mFAZYmvE7GjNQ9DcZ3d3Iw9
OtawRR6o8v2lYLgpHSwCIGcDSzFBBVrbqjQYhlEDKabQ5bFOyl4v6ipT3nHReDxZ
oSOWmK4D1Ru4VvmKF+HiQQzeUzYGgg==
=ZIzZ
-----END PGP SIGNATURE-----

--Sig_/MGsEM8zq5E4uQoFtFGvvQIW--
