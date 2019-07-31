Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 743EF7BF36
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 13:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbfGaLYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 07:24:54 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:53106 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfGaLYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 07:24:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NNkKpSgMuJ0KRRXiISTaddlqY+jM8kpTuvVm8K7loEo=; b=m/zIh+7lsaMz2pnXHbCTB9AVJ
        mV40UnIA7bnq14o76hcNSjOpD6JbreoPgt+MGAR2O1CuqmWu8ljttfVxcmnORwU/401Nbl2UEq9BG
        TuOwWWGC8jd4PU1/gHwfmgG4gkJEMReqYJEJ13AdV3B2stt59YpknqEboxMWWgIJa1Ueo=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=ypsilon.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hsmio-0001kD-NN; Wed, 31 Jul 2019 11:24:42 +0000
Received: by ypsilon.sirena.org.uk (Postfix, from userid 1000)
        id C59922742C99; Wed, 31 Jul 2019 12:24:41 +0100 (BST)
Date:   Wed, 31 Jul 2019 12:24:41 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     kernel-build-reports@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-next@vger.kernel.org
Subject: Re: next/master build: 221 builds: 11 failed, 210 passed, 13 errors,
 1174 warnings (next-20190731)
Message-ID: <20190731112441.GB4369@sirena.org.uk>
References: <5d41767d.1c69fb81.d6304.4c8c@mx.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Content-Disposition: inline
In-Reply-To: <5d41767d.1c69fb81.d6304.4c8c@mx.google.com>
X-Cookie: FEELINGS are cascading over me!!!
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2019 at 04:07:41AM -0700, kernelci.org bot wrote:

Today's -next fails to build an ARM allmodconfig due to:

> allmodconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 40 warnings, 0 section=
 mismatches
>=20
> Errors:
>     drivers/net/phy/mdio-cavium.h:111:36: error: implicit declaration of =
function 'writeq'; did you mean 'writel'? [-Werror=3Dimplicit-function-decl=
aration]

as a result of the changes that introduced:

WARNING: unmet direct dependencies detected for MDIO_OCTEON
  Depends on [n]: NETDEVICES [=3Dy] && MDIO_DEVICE [=3Dm] && MDIO_BUS [=3Dm=
] && 64BIT && HAS_IOMEM [=3Dy] && OF_MDIO [=3Dm]
  Selected by [m]:
  - OCTEON_ETHERNET [=3Dm] && STAGING [=3Dy] && (CAVIUM_OCTEON_SOC && NETDE=
VICES [=3Dy] || COMPILE_TEST [=3Dy])

which is triggered by the staging OCTEON_ETHERNET driver which misses a
64BIT dependency but added COMPILE_TEST in 171a9bae68c72f2
(staging/octeon: Allow test build on !MIPS).

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl1BengACgkQJNaLcl1U
h9DLnwf/f8I9dl2D69S1eeFNRVh2aLjJV9PMJSjfoyGSDSEKyrS7CVSR8qWRkfir
LwbOCkTe7W9RVxR409aCkPkHcqLlCquQxDeyihTP00ZevmIzgLN7A1mLv0LmoIbn
vldWfuGkbKM67v9n1nwgNBuZK/6eXFobpRlAFrPBx6tiMH4zvAbMKQgO8GuHXdQs
EFd9Wxa38ixftAfcoNbMng2vmYqFiU/nOM9MUQBtWwZ30OV359/nSHMpwfyO9KEJ
sfd866tLAddesCX15Kk/DS/r1qQViMKmqTiOTSHe4r3YKQL9/o8NByGs7k0rWG6t
hgLW0Xnb1iREo3Scv3PBByS5PuMdbw==
=Oxer
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
