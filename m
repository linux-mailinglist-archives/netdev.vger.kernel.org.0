Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF87430916
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 14:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241353AbhJQMsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 08:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhJQMsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 08:48:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FA3C061765
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 05:46:33 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mc5YS-0006AU-Ks; Sun, 17 Oct 2021 14:46:20 +0200
Received: from pengutronix.de (2a03-f580-87bc-d400-7b24-848c-3829-1203.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:7b24:848c:3829:1203])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id E8C99695CEF;
        Sun, 17 Oct 2021 12:46:13 +0000 (UTC)
Date:   Sun, 17 Oct 2021 14:46:13 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Brandon Maier <brandon.maier@rockwellcollins.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        "open list:CAN NETWORK DRIVERS" <linux-can@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "moderated list:ARM/Microchip (AT91) SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] can: at91_can: fix passive-state AERR flooding
Message-ID: <20211017124613.ttplab5ydklehvxd@pengutronix.de>
References: <20211005183023.109328-1-brandon.maier@rockwellcollins.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kt7k6mpieicyhvfv"
Content-Disposition: inline
In-Reply-To: <20211005183023.109328-1-brandon.maier@rockwellcollins.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--kt7k6mpieicyhvfv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.10.2021 13:30:23, Brandon Maier wrote:
> When the at91_can is a single node on the bus and a user attempts to
> transmit, the can state machine will report ack errors and increment the
> transmit error count until it reaches the passive-state. Per the
> specification, it will then transmit with a passive error, but will stop
> incrementing the transmit error count. This results in the host machine
> being flooded with the AERR interrupt forever, or until another node
> rejoins the bus.
>=20
> To prevent the AERR flooding, disable the AERR interrupt when we are in
> passive mode.

Can you implement Bus Error Reporting?

| https://elixir.bootlin.com/linux/v5.14/source/include/uapi/linux/can/netl=
ink.h#L99

This way the user can control if bus errors, and the ACK error is one of
them, should be reported. Bus error reporting is disabled by default. I
think enabling AT91_IRQ_ERR_FRAME only if CAN_CTRLMODE_BERR_REPORTING is
active should do the trick.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--kt7k6mpieicyhvfv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmFsGxIACgkQqclaivrt
76kR6gf/SZqWy8DDw7I6Pxr3FLEttdavMEKmwFK+1T6ML0EHmsRqwTfbe3ol/eJi
CjnED87jezZM1vzfjQ0fWgSrSbY/6SYlk3fASIRLSw/0n3H9WYrzNJLvZwjMtKlH
Kw/9yQfGfHBI4FoNdWaYyo8ZSnOPzqjC9+X7/Zn7LCbNPiXw2+G41fGrzh69G6uz
AM8vNcBLx+PkF2jUodTBzspvz9auYlCO2VuDCsPIBR1pfCXKuiNjZWXZyGmW5VcR
gCykGKvzaCzCEJNxxHZAH7IJ3Zq2Std9e5btHHEim5P5WpLML/ddYxoRfQqgRZqb
y7+Vg2AWOXEe7Zsq20czLIoPvjccSA==
=FYBd
-----END PGP SIGNATURE-----

--kt7k6mpieicyhvfv--
