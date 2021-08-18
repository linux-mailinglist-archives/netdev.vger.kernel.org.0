Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6997A3F03B6
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236676AbhHRMaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236578AbhHRMaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 08:30:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06628C061764
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 05:29:30 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mGKhC-0005ts-LS; Wed, 18 Aug 2021 14:29:26 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:ed04:8488:5061:54d4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id A1429669BDE;
        Wed, 18 Aug 2021 12:29:24 +0000 (UTC)
Date:   Wed, 18 Aug 2021 14:29:23 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can <linux-can@vger.kernel.org>,
        Stefan =?utf-8?B?TcOkdGpl?= <Stefan.Maetje@esd.eu>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 2/7] can: bittiming: allow TDC{V,O} to be zero and add
 can_tdc_const::tdc{v,o,f}_min
Message-ID: <20210818122923.hvxmffoi5rf7rbe6@pengutronix.de>
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-3-mailhol.vincent@wanadoo.fr>
 <20210816084235.fr7fzau2ce7zl4d4@pengutronix.de>
 <CAMZ6RqK5t62UppiMe9k5jG8EYvnSbFW3doydhCvp72W_X2rXAw@mail.gmail.com>
 <20210816122519.mme272z6tqrkyc6x@pengutronix.de>
 <20210816123309.pfa57tke5hrycqae@pengutronix.de>
 <20210816134342.w3bc5zjczwowcjr4@pengutronix.de>
 <CAMZ6RqJFxKSZahAMz9Y8hpPJPh858jxDEXsRm1YkTwf4NFAFwg@mail.gmail.com>
 <20210817200123.4wcdwsdfsdjr3ovk@pengutronix.de>
 <CAMZ6RqKsjPF2gBbzsKatFG7S4qcOahSX9vSU=dj_e9R-Kqq0CA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="innagn5z65fxcw7l"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqKsjPF2gBbzsKatFG7S4qcOahSX9vSU=dj_e9R-Kqq0CA@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--innagn5z65fxcw7l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18.08.2021 18:22:33, Vincent MAILHOL wrote:
> > Backwards compatibility using an old ip tool on a new kernel/driver must
> > work.
>=20
> I am not trying to argue against backward compatibility :)
> My comment was just to point out that I had other intents as well.
>=20
> > In case of the mcp251xfd the tdc mode must be activated and tdcv
> > set to the automatic calculated value and tdco automatically measured.
>=20
> Sorry but I am not sure if I will follow you. Here, do you mean
> that "nothing" should do the "fully automated" calculation?

Sort of.
The use case is the old ip tool with a driver that supports tdc, for
CAN-FD to work it must be configured in fully automated mode.

> In your previous message, you said:
>=20
> > Does it make sense to let "mode auto" without a tdco value switch the
> > controller into full automatic mode and /* nothing */ not tough the tdc
> > config at all?
>=20
> So, you would like this behavior:
>=20
> | mode auto, no tdco provided -> kernel decides between TDC_AUTO and TDC =
off.

NACK - mode auto, no tdco -> TDC_AUTO with tdco calculated by the kernel

> | mode auto, tdco provided -> TDC_AUTO

ACK - TDC_AUTO with user supplied tdco

> | mode manual, tdcv and tdco provided -> TDC_MANUAL

ACK - TDC_MANUAL with tdco and tdcv user provided

> | mode off is not needed anymore (redundant with "nothing")
> (TDCF left out of the picture intentionally)

NACK - TDC is switched off

> | "nothing" -> TDC is off (not touch the tdc config at all)

NACK - do not touch TDC setting, use previous setting

> Correct?

See above. Plus a change that addresses your issue 1/ from below.

If driver supports TDC it should be initially brought into TDC auto
mode, if no TDC mode is given. Maybe we need an explizit TDC off to make
that work.

> If you do so, I see three issues:
>=20
> 1/ Some of the drivers already implement TDC. Those will
> automatically do a calculation as long as FD is on. If "nothing"
> now brings TDC off, some users will find themselves with some
> error on the bus after the iproute2 update if they continue using
> the same command.

Nothing would mean "do not touch" and as TDC auto is default a new ip
would work out of the box. Old ip will work, too. Just failing to decode
TDC_AUTO...

> 2/ Users will need to read and understand how to use the TDC
> parameters of iproute2. And by experience, too many people just
> don't read the doc. If I can make the interface transparent and
> do the correct thing by default ("nothing"), I prefer to do so.

ACK, see above

> 3/ Final one is more of a nitpick. The mode auto might result in
> TDC being off. If we have a TDC_AUTO flag, I would expect the
> auto mode to always set that flag (unless error occurs). I see
> this to be slightly counter intuitive (I recognize that my
> solution also has some aspects which are not intuitive, I just
> want to point here that none are perfect).

What are the corner cases where TDC_AUTO results in TDC off?

> To be honest, I really preferred the v1 of this series where
> there were no tdc-mode {auto,manual,off} and where the "off"
> behavior was controlled by setting TDCO to zero. However, as we
> realized, zero is a valid value and thus, I had to add all this
> complexity just to allow that damn zero value.

Maybe we should not put the TDC mode _not_ into ctrl-mode, but info a
dedicated tdc-mode (which is not bit-field) inside the struct tdc?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--innagn5z65fxcw7l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEc/SAACgkQqclaivrt
76kZcAf/d4n7QoNll8SzFymvXaIESoY1UdozAIg5hh7oD85P+ySg/Mtsx1+C+Az6
sVa1S6HpceB1JneW6EsDyh+dxjlqENV+3J4Z/bgfyhRT2GO8t494m/YgmlQdaUl6
3Zyx2xFR5zWQObob1NIMMrahlJo0VXv0m+3rRX7DWZlARAU4yN7q1YiEp0OdCR4A
pzJ27LXGSXuJfpl/95fXvkOVN/pf5qLkWTTBTWQ4gDHuGVHMirP2uIpK/+1yl+Kp
ijr+u58kY59ucr6IISWAhGpBhcC6kdJAzuVqN+p7B7c+fvTqeCPoFWoONZ7+v5eO
HroaZzuz/Td28ChWtW1JUgRR1KGBvA==
=f8yt
-----END PGP SIGNATURE-----

--innagn5z65fxcw7l--
