Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3965D3B2ACD
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 10:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhFXI47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 04:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbhFXI45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 04:56:57 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE10C061574;
        Thu, 24 Jun 2021 01:54:38 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4G9Ypx0hW8z9sX2;
        Thu, 24 Jun 2021 18:54:33 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1624524874;
        bh=QVw365DMsvwcIhQnqzCSRuPl780dS01pENxqnUncAC8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DeVESwJuuciIXHDy/kswL3tXLepX50sCPNUIYXJUv2JlCM9essXCrR7CZdw7pEay/
         38v/AHqMoDMva5/+5795B2bKK/2pBNuqWGvhzVKoWXy+O0vBLceoCriquBqjmgCM8o
         4IOl7PSMZAxcXXn2Ei5yDRTqyYXPw42W1YFkze4LkWJkj1B9ZIdharHZwYmYXwfOz5
         IzYa8Nf3aAsc9AE+VX9z4JwW6bbEkJZGbwBclYGPrAvEOArGhL0e3r7zaKuKFSINrt
         GLoPN65vj0jqlrT7yRyZC7pKRYaMjsLsxr3ETbq0NswkKz5F4UJcnrKJg3PBuva4tb
         PjemlP0Dp7TrA==
Date:   Thu, 24 Jun 2021 18:54:30 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        lkft-triage@lists.linaro.org
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20210624185430.692d4b60@canb.auug.org.au>
In-Reply-To: <CA+G9fYtb07aySOpB6=wc4ip_9S4Rr2UUYNgEOG6i76g--uPryQ@mail.gmail.com>
References: <20210624082911.5d013e8c@canb.auug.org.au>
        <CAPv3WKfiL+sR+iK_BjGKDhtNgjoxKEPv49bU1X9_7+v+ytdR1w@mail.gmail.com>
        <YNPt91bfjrgSt8G3@Ryzen-9-3900X.localdomain>
        <CA+G9fYtb07aySOpB6=wc4ip_9S4Rr2UUYNgEOG6i76g--uPryQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/mhH9ao.Lz9CU8hIfwZCfJwi";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/mhH9ao.Lz9CU8hIfwZCfJwi
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 24 Jun 2021 11:43:14 +0530 Naresh Kamboju <naresh.kamboju@linaro.or=
g> wrote:
>
> On Thu, 24 Jun 2021 at 07:59, Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > On Thu, Jun 24, 2021 at 12:46:48AM +0200, Marcin Wojtas wrote: =20
> > > Hi Stephen,
> > >
> > > czw., 24 cze 2021 o 00:29 Stephen Rothwell <sfr@canb.auug.org.au> nap=
isa=C5=82(a): =20
> > > >
> > > > Hi all,
> > > >
> > > > Today's linux-next build (x86_64 modules_install) failed like this:
> > > >
> > > > depmod: ../tools/depmod.c:1792: depmod_report_cycles_from_root: Ass=
ertion `is < stack_size' failed. =20
>=20
> LKFT test farm found this build error.
>=20
> Regressions found on mips:
>=20
>  - build/gcc-9-malta_defconfig
>  - build/gcc-10-malta_defconfig
>  - build/gcc-8-malta_defconfig
>=20
> depmod: ERROR: Cycle detected: fwnode_mdio -> of_mdio -> fwnode_mdio
> depmod: ERROR: Found 2 modules in dependency cycles!
> make[1]: *** [/builds/linux/Makefile:1875: modules_install] Error 1
>=20
> > > Thank you for letting us know. Not sure if related, but I just found
> > > out that this code won't compile for the !CONFIG_FWNODE_MDIO. Below
> > > one-liner fixes it:
> > >
> > > --- a/include/linux/fwnode_mdio.h
> > > +++ b/include/linux/fwnode_mdio.h
> > > @@ -40,7 +40,7 @@ static inline int fwnode_mdiobus_register(struct mi=
i_bus *bus,
> > >          * This way, we don't have to keep compat bits around in driv=
ers.
> > >          */
> > >
> > > -       return mdiobus_register(mdio);
> > > +       return mdiobus_register(bus);
> > >  }
> > >  #endif
> > >
> > > I'm curious if this is the case. Tomorrow I'll resubmit with above, so
> > > I'd appreciate recheck. =20
>=20
> This proposed fix did not work.
>=20
> > Reverting all the patches in that series fixes the issue for me. =20
>=20
> Yes.
> Reverting all the (6) patches in that series fixed this build problem.
>=20
> git log --oneline | head
> 3752a7bfe73e Revert "Documentation: ACPI: DSD: describe additional MAC
> configuration"
> da53528ed548 Revert "net: mdiobus: Introduce fwnode_mdbiobus_register()"
> 479b72ae8b68 Revert "net/fsl: switch to fwnode_mdiobus_register"
> 92f85677aff4 Revert "net: mvmdio: add ACPI support"
> 3d725ff0f271 Revert "net: mvpp2: enable using phylink with ACPI"
> ffa8c267d44e Revert "net: mvpp2: remove unused 'has_phy' field"
> d61c8b66c840 Add linux-next specific files for 20210623

So I have reverted the merge of that topic branch from linux-next for
today.
--=20
Cheers,
Stephen Rothwell

--Sig_/mhH9ao.Lz9CU8hIfwZCfJwi
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDUSEYACgkQAVBC80lX
0Gzz2gf/e/CC/T0vUnT03R0VhJjT14jGuzHdxzq475CAfQetDb1jUPkejMsMvRmU
cbQSODJ2wAhqzZz5YWPP3Pz89nuZ6w8SIZoSZTcsOnpPjx+CcdI2WsRrkJJsBV/H
TjBL/r1zg0f8Cbyu71J5WpDTAsyO/YTRwBqk9Mx8NYuEzdrQUIQHLerE2zLwla0g
5X6HDk6YuYeB95+Zslu9jyftGvLJKtrz0OPLr7IJyBf1ibQKrY6+d7tArX8yBYrc
ZZe9Yqd9nPlkIb2ESybvdOtD2veo61pWsuOZe8zr6v0CiaGegGHOAlG0FKxsfS1L
ZJHT7wh6Q73cttVqxgZ/oPIzTHhirA==
=jwKn
-----END PGP SIGNATURE-----

--Sig_/mhH9ao.Lz9CU8hIfwZCfJwi--
