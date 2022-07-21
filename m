Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6484E57D036
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbiGUPsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbiGUPs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:48:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 397A088E3A
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:47:42 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oEYOg-0005mm-2Y; Thu, 21 Jul 2022 17:47:30 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 344A7B6E79;
        Thu, 21 Jul 2022 15:47:28 +0000 (UTC)
Date:   Thu, 21 Jul 2022 17:47:25 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        llvm@lists.linux.dev
Subject: Re: [PATCH net-next 18/29] can: pch_can: do not report txerr and
 rxerr during bus-off
Message-ID: <20220721154725.ovcsfiio7e6hts2n@pengutronix.de>
References: <20220720081034.3277385-1-mkl@pengutronix.de>
 <20220720081034.3277385-19-mkl@pengutronix.de>
 <YtlwSpoeT+nhmhVn@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6whgrc2hjjl4b7xy"
Content-Disposition: inline
In-Reply-To: <YtlwSpoeT+nhmhVn@dev-arch.thelio-3990X>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6whgrc2hjjl4b7xy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 21.07.2022 08:27:06, Nathan Chancellor wrote:
> On Wed, Jul 20, 2022 at 10:10:23AM +0200, Marc Kleine-Budde wrote:
> > From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> >=20
> > During bus off, the error count is greater than 255 and can not fit in
> > a u8.
> >=20
> > Fixes: 0c78ab76a05c ("pch_can: Add setting TEC/REC statistics processin=
g")
> > Link: https://lore.kernel.org/all/20220719143550.3681-2-mailhol.vincent=
@wanadoo.fr
> > Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> > Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> > ---
> >  drivers/net/can/pch_can.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
> > index fde3ac516d26..497ef77340ea 100644
> > --- a/drivers/net/can/pch_can.c
> > +++ b/drivers/net/can/pch_can.c
> > @@ -496,6 +496,9 @@ static void pch_can_error(struct net_device *ndev, =
u32 status)
> >  		cf->can_id |=3D CAN_ERR_BUSOFF;
> >  		priv->can.can_stats.bus_off++;
> >  		can_bus_off(ndev);
> > +	} else {
> > +		cf->data[6] =3D errc & PCH_TEC;
> > +		cf->data[7] =3D (errc & PCH_REC) >> 8;
> >  	}
> > =20
> >  	errc =3D ioread32(&priv->regs->errc);
> > @@ -556,9 +559,6 @@ static void pch_can_error(struct net_device *ndev, =
u32 status)
> >  		break;
> >  	}
> > =20
> > -	cf->data[6] =3D errc & PCH_TEC;
> > -	cf->data[7] =3D (errc & PCH_REC) >> 8;
> > -
> >  	priv->can.state =3D state;
> >  	netif_receive_skb(skb);
> >  }
> > --=20
> > 2.35.1
> >=20
> >=20
> >=20
>=20
> Apologies if this has been reported already, I didn't see anything on
> the mailing lists.
>=20
> This commit is now in -next as commit 3a5c7e4611dd ("can: pch_can: do
> not report txerr and rxerr during bus-off"), where it causes the
> following clang warning:
>=20
>   ../drivers/net/can/pch_can.c:501:17: error: variable 'errc' is uninitia=
lized when used here [-Werror,-Wuninitialized]
>                   cf->data[6] =3D errc & PCH_TEC;
>                                 ^~~~
>   ../drivers/net/can/pch_can.c:484:10: note: initialize the variable 'err=
c' to silence this warning
>           u32 errc, lec;
>                   ^
>                    =3D 0
>   1 error generated.
>=20
> errc is initialized underneath this now, should it be hoisted or is
> there another fix?

Doh! I'll send a fix.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--6whgrc2hjjl4b7xy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLZdQYACgkQrX5LkNig
013hmwgAnn12oPoDrDC3N5rQawu8IQLoQMmJeDee6ufSLzIqY3BDYF2pIoEkk6Ee
PANXpP81pcYTrdTAagbOGLH0iRTkiVRZVJzyFVt7wt28s777b9EVHyMAF+mnXY+s
UmsDhU4mwKnpX4OEu4dJPVS/sfIzdwWffJWLwG56IC7pH8C/PxJEL1CoF0tXY2E4
tFvWzT6Qv1p18huSMSZghvadrfyEMA0CpBTUZjM5O3nzBLQMnCbCS99YLDn6JN32
6B+Yhahh7yDrQqeyhyIbkvxSB8WkqeQDaw9+N1WHC6mrWqAYV1CkQji+pMRma/IF
/3DigVqfVNvndoWez+TNzDq3F6G4Sw==
=tRaG
-----END PGP SIGNATURE-----

--6whgrc2hjjl4b7xy--
