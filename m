Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E491E636D38
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 23:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiKWWee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 17:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiKWWea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 17:34:30 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948A211DA18
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 14:34:28 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oxyJq-00014w-Us; Wed, 23 Nov 2022 23:34:15 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:2e2e:9f36:4c74:dde5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 9F6EA127BAB;
        Wed, 23 Nov 2022 22:34:12 +0000 (UTC)
Date:   Wed, 23 Nov 2022 23:34:10 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Yasushi SHOJI <yasushi.shoji@gmail.com>,
        Remigiusz =?utf-8?B?S2/FgsWCxIV0YWo=?= 
        <remigiusz.kollataj@mobica.com>
Cc:     Yasushi SHOJI <yashi@spacecubics.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: mcba_usb: Fix termination command argument
Message-ID: <20221123223410.sg2ixkaqg4dpe7ew@pengutronix.de>
References: <20221123194406.80575-1-yashi@spacecubics.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="33zoh2sobjkt3oh7"
Content-Disposition: inline
In-Reply-To: <20221123194406.80575-1-yashi@spacecubics.com>
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


--33zoh2sobjkt3oh7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Let's take the original driver author into the loop.

On 24.11.2022 04:44:06, Yasushi SHOJI wrote:
> Microchip USB Analyzer can be set with termination setting ON or OFF.
> As I've observed, both with my oscilloscope and USB packet capture
> below, you must send "0" to turn it ON, and "1" to turn it OFF.
>=20
> Reverse the argument value to fix this.
>=20
> These are the two commands sequence, ON then OFF.
>=20
> > No.     Time           Source                Destination           Prot=
ocol Length Info
> >       1 0.000000       host                  1.3.1                 USB =
     46     URB_BULK out
> >
> > Frame 1: 46 bytes on wire (368 bits), 46 bytes captured (368 bits)
> > USB URB
> > Leftover Capture Data: a80000000000000000000000000000000000a8
> >
> > No.     Time           Source                Destination           Prot=
ocol Length Info
> >       2 4.372547       host                  1.3.1                 USB =
     46     URB_BULK out
> >
> > Frame 2: 46 bytes on wire (368 bits), 46 bytes captured (368 bits)
> > USB URB
> > Leftover Capture Data: a80100000000000000000000000000000000a9

Is this the USB data after applying the patch?

Can you measure the resistance between CAN-H and CAN-L to verify that
your patch fixes the problem?

> Signed-off-by: Yasushi SHOJI <yashi@spacecubics.com>
> ---
>  drivers/net/can/usb/mcba_usb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_us=
b.c
> index 218b098b261d..67beff1a3876 100644
> --- a/drivers/net/can/usb/mcba_usb.c
> +++ b/drivers/net/can/usb/mcba_usb.c
> @@ -785,9 +785,9 @@ static int mcba_set_termination(struct net_device *ne=
tdev, u16 term)
>  	};
> =20
>  	if (term =3D=3D MCBA_TERMINATION_ENABLED)
> -		usb_msg.termination =3D 1;
> -	else
>  		usb_msg.termination =3D 0;
> +	else
> +		usb_msg.termination =3D 1;
> =20
>  	mcba_usb_xmit_cmd(priv, (struct mcba_usb_msg *)&usb_msg);

What about the static void mcba_usb_process_ka_usb() function? Do you
need to convert this, too?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--33zoh2sobjkt3oh7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmN+n98ACgkQrX5LkNig
012L1QgAoWGeBydYaNVMgeqAWNQXxd2DUQMDWZsXHQ5Iaq583nK4EiBy1DrOGY8p
93zFNw0Dha9KFuCcYVonIom9M4H6CFfm/0IabGGoltcjFoEby+4bsllBkQshr4vL
1mBTJDYcgTgCVkex86uyYRChmVZGgqyLg2vnCjkXZb2Dyj7A5ssmnIxESfCWKlI3
ANV8ZmP6+Xcw3Ws163IDXWy3+mcF0gXn0nNuvVSfyopsZcgVUX9Cv+1rI97i/7Ew
MYs2oTlmylZWAIj6fN0Zv4bfP5Q1bvawp49BDMPOeeJphlFQhvroR4gBIC2s+wBn
/rW7EnUI9rCUhLBzQ3ENFrNHqPO6iw==
=oknD
-----END PGP SIGNATURE-----

--33zoh2sobjkt3oh7--
