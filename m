Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A878D6DF331
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 13:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbjDLL0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 07:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbjDLL0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 07:26:14 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 898257AB3;
        Wed, 12 Apr 2023 04:25:51 -0700 (PDT)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 4D13E85F89;
        Wed, 12 Apr 2023 13:25:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1681298748;
        bh=mZoSxFyu5gl5lRzjVx2+uD113sQVwsFUxkB7gL0MZ5Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jEZ8Uxngl1L2CR4xLBR0Oh9uFOgpr0AHfVQ2l4F5c1ceAxYQVtgXZxL98S/4Rqias
         pRZZPi87UXbQSS5WUGYbwBVY+WNqM97PEFSxXgd8Ac/99qg899eXeQZgk8nyUD2Ki5
         AFRKrkOJT4bB53jKMhkOw0bouDm4OrfmMzATIPOed+OmFNhfnS0laIAHqCw2CE8043
         R3jjBdgt1FkKtOAPnx5/HSmHWJ3A8L/sIqEy+3DGHnc4faISbYJlyrBwVW2hafpgFH
         4I7U0uYaQ8Mwd8SLXL/sQWLvvPxvkKi9mrYkPzluWjX1Zky2pl/bye3+40wCAeq4MX
         KIlUJIhGq7c0Q==
Date:   Wed, 12 Apr 2023 13:25:40 +0200
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
Message-ID: <20230412132540.5a45564d@wsk>
In-Reply-To: <aa6415be-e99b-46df-bb3b-d2c732a33f31@lunn.ch>
References: <20230406131127.383006-1-lukma@denx.de>
        <ZC7Nu5Qzs8DyOfQY@corigine.com>
        <aa6415be-e99b-46df-bb3b-d2c732a33f31@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/w5rnG5uqlwlpH28QrNL1yn3";
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

--Sig_/w5rnG5uqlwlpH28QrNL1yn3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> On Thu, Apr 06, 2023 at 03:48:43PM +0200, Simon Horman wrote:
> > On Thu, Apr 06, 2023 at 03:11:27PM +0200, Lukasz Majewski wrote: =20
> > > The LAN8720Ai has special bit (12) in the PHY SPECIAL
> > > CONTROL/STATUS REGISTER (dec 31) to indicate if the
> > > AutoNeg is finished.
> > >=20
> > > Signed-off-by: Lukasz Majewski <lukma@denx.de> =20
> >=20
> > Hi Lukasz,
> >=20
> > I think you need to rebase this on net-next.
> >=20
> > If you repost please also include 'net-next' in the subject:
> > [PATCH net-next v2].
> >=20
> > And a note about the changes between v1 and v2. =20
>=20
> This actually seems like a fix. So it should probably be based on net,
> and have a Fixes: tag.

I've rebased it on the newest vanila kernel.

And this patch come from the work on LAN8720Ai based system (speed up
of the boot time).

It turned out that this IC has a dedicated bit (in vendor specific
register) to show explicitly if auto neg is done.

>=20
> Lukasz, how does this bit differ to the one in BMSR?=20

In the BMSR - bit 5 (Auto Negotiate Complete) - shows the same kind of
information.

The only difference is that this bit is described as "Auto
Negotiate Complete" and the bit in this patch indicates "Auto
Negotiation Done".

> Is the BMSR bit
> broken?=20

This bit works as expected.

> Is there an errata for this?

No, errata doesn't mention it.

I just was wondering if shall we do use the "vendor specific"
indication bit or the "standard one" from BMSR register.

I try to figure out why SMSC put bit from this patch in the SoC...

> It would be good to describe the
> problem you see which this patch fixes.
>=20
> 	Andrew




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/w5rnG5uqlwlpH28QrNL1yn3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmQ2lTQACgkQAR8vZIA0
zr3hLgf9EDUAgbaDC5yqeC2tiAF3z+aY96QRTrH5NnZsn5b991BlLNlyPcQCLWLC
XXwtEHibnpgbAbUc2WsO79KIczV/2ElNR3PJw14N2P/c3LEzkpDGghLzrydKp709
UqRjPo8kyYQNMtEVx/j0JNe9Xq/in4XfKeUpLkY0lyaAfTKiC5I7UJdsXapfpWxY
biHeFmZ0ztfBU3Zq4ilbKDkQkQfCRf8xrcwS6YRzmy348CKDU9rjbvoDyM6o/9Nl
0nkIy9x0tzHqKKWiQNhe+ca++OQ0u2rNtYgjLex6amKXgqnxRt4CG+htV3MX65l/
X+bZAuCQ0JuNpz7RemsePKeODl5T2A==
=9UhU
-----END PGP SIGNATURE-----

--Sig_/w5rnG5uqlwlpH28QrNL1yn3--
