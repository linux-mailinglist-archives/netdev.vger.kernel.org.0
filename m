Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2876DF817
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 16:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjDLOM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 10:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbjDLOM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 10:12:27 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E1D976E;
        Wed, 12 Apr 2023 07:12:10 -0700 (PDT)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id D560F85EEF;
        Wed, 12 Apr 2023 16:12:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1681308728;
        bh=oJe+dhBRFjbufxdOE+fpKBwo+IsZBAXvxmYTN94z54E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=azIWLXEYxA366b12+jzw4lBOmUn+liadHdaTh/CEnzqSUIjbS/ZTG4QQHMNF63T+6
         5KOHFDLEB3kE7UCYi03T1LfHD5Sg7n+rkk7+WY0rdw0HNCTc4SZ1lCFkRDphWihN9O
         NWh5wTzUQ4P5bh7ES/28ufbljWUIrv66OdZK2ixfuyk4hy2q0i9eK4u2wvhiVUSOuQ
         xl1uxDT5RjRXZvxkU38vngEYC3s8/6wecYwOB1TMBnOZNvJBw6vdK7ZsuLANnt+cVp
         keCs8OiHJBJ+T/W2tdrcxy9+AOmuUbknwzC9Guqm0lb7BB+CGv9N7cyKU9Jx0wB8KI
         jv3bITN5KJlMA==
Date:   Wed, 12 Apr 2023 16:12:00 +0200
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: smsc: Implement .aneg_done callback for LAN8720Ai
Message-ID: <20230412161200.329798fb@wsk>
In-Reply-To: <7330ff6d-665f-4c79-975d-6e023c781237@lunn.ch>
References: <20230406131127.383006-1-lukma@denx.de>
        <ZC7Nu5Qzs8DyOfQY@corigine.com>
        <aa6415be-e99b-46df-bb3b-d2c732a33f31@lunn.ch>
        <20230412132540.5a45564d@wsk>
        <7330ff6d-665f-4c79-975d-6e023c781237@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/D=c1gj4OhYTF2rGw87ZDJ9S";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/D=c1gj4OhYTF2rGw87ZDJ9S
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> > > This actually seems like a fix. So it should probably be based on
> > > net, and have a Fixes: tag. =20
> >=20
> > I've rebased it on the newest vanila kernel. =20
>=20
> Please see the netdev FAQ. It talks about the two git trees used for
> networking.

Thanks for the information.

>=20
> > It turned out that this IC has a dedicated bit (in vendor specific
> > register) to show explicitly if auto neg is done.
> >  =20
> > >=20
> > > Lukasz, how does this bit differ to the one in BMSR?  =20
> >=20
> > In the BMSR - bit 5 (Auto Negotiate Complete) - shows the same kind
> > of information.
> >=20
> > The only difference is that this bit is described as "Auto
> > Negotiate Complete" and the bit in this patch indicates "Auto
> > Negotiation Done".
> >  =20
> > > Is the BMSR bit
> > > broken?  =20
> >=20
> > This bit works as expected. =20
>=20
> I would avoid the vendor bit, if it has no benefit. A lot of
> developers understand the BMSR bit, where as very few know this vendor
> bit. BMSR can probably be handled with generic code, where as the
> vendor bit requires vendor specific code etc.

Ok. Then, this patch shall be dropped. Thanks for the clarification :)

>=20
>     Andrew




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/D=c1gj4OhYTF2rGw87ZDJ9S
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmQ2vDAACgkQAR8vZIA0
zr2RXwgApqTxnLuMfw3h9YrdZSwgZ3fvI68WOFSnK9LiOPoQCVdzyH4+AB+Issja
dkY8fJ0CGWtQyNUMzgBUA8XgQzc1E1jTVtxb4tMGleioL03KWUsBVF2QWClRd8Na
iCjqy1oxioWgvrzCWWlQhRhzeyLXQ7U9w6gnfe07E5h5yLMs60RE9sv0eiW9UIYA
x8KyKTHpdikBH/swELEaJXHLVZZ7wXHrhdb0dCG8esEvLhJ5TTVDf+mAnPS36P/9
x1DQHFKcJmGsgtdMEi5OxRDlX/hCqThExSVnCMGm6sZBthi+6q7PT2HS2xYLAWk9
9kVHWBrB/KF5OWCQeeqT/gUV9kx5RA==
=Qcaf
-----END PGP SIGNATURE-----

--Sig_/D=c1gj4OhYTF2rGw87ZDJ9S--
