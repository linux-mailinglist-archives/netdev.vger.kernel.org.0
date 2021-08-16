Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00F4B3ED00B
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 10:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234872AbhHPIMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 04:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbhHPIMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 04:12:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90FCDC061764
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 01:12:16 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mFXj8-0003Xd-29; Mon, 16 Aug 2021 10:12:10 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:3272:cc96:80a9:1a01])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 3FA99668018;
        Mon, 16 Aug 2021 08:12:07 +0000 (UTC)
Date:   Mon, 16 Aug 2021 10:12:05 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        linux-can@vger.kernel.org,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/4] iplink_can: add new CAN FD bittiming parameters:
 Transmitter Delay Compensation (TDC)
Message-ID: <20210816081205.7rjdskaui35f3jml@pengutronix.de>
References: <20210814101728.75334-1-mailhol.vincent@wanadoo.fr>
 <20210814101728.75334-5-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hiskfds7hw52oih6"
Content-Disposition: inline
In-Reply-To: <20210814101728.75334-5-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hiskfds7hw52oih6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.08.2021 19:17:28, Vincent Mailhol wrote:
> At high bit rates, the propagation delay from the TX pin to the RX pin
> of the transceiver causes measurement errors: the sample point on the
> RX pin might occur on the previous bit.
>=20
> This issue is addressed in ISO 11898-1 section 11.3.3 "Transmitter
> delay compensation" (TDC).
>=20
> This patch brings command line support to nine TDC parameters which
> were recently added to the kernel's CAN netlink interface in order to
> implement TDC:
>   - IFLA_CAN_TDC_TDCV_MIN: Transmitter Delay Compensation Value
>     minimum value
>   - IFLA_CAN_TDC_TDCV_MAX: Transmitter Delay Compensation Value
>     maximum value
>   - IFLA_CAN_TDC_TDCO_MIN: Transmitter Delay Compensation Offset
>     minimum value
>   - IFLA_CAN_TDC_TDCO_MAX: Transmitter Delay Compensation Offset
>     maximum value
>   - IFLA_CAN_TDC_TDCF_MIN: Transmitter Delay Compensation Filter
>     window minimum value
>   - IFLA_CAN_TDC_TDCF_MAX: Transmitter Delay Compensation Filter
>     window maximum value
>   - IFLA_CAN_TDC_TDCV: Transmitter Delay Compensation Value
>   - IFLA_CAN_TDC_TDCO: Transmitter Delay Compensation Offset
>   - IFLA_CAN_TDC_TDCF: Transmitter Delay Compensation Filter window
>=20
> All those new parameters are nested together into the attribute
> IFLA_CAN_TDC.
>=20
> A tdc-mode parameter allow to specify how to operate. Valid options
> are:
>=20
>   * auto: the transmitter automatically measures TDCV. As such, TDCV
>     values can not be manually provided. In this mode, the user must
>     specify TDCO and may also specify TDCF if supported.
>=20
>   * manual: Use the TDCV value provided by the user are used. In this
                           ^^^^^                      ^^^
                           singular                   plural
>     mode, the user must specify both TDCV and TDCO and may also
>     specify TDCF if supported.
>=20

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--hiskfds7hw52oih6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEaHdMACgkQqclaivrt
76kK2gf7ByQgT+oT/maYnG88lnvjMyyv+jPt7G6VOHxu8uc0KpNqzJbUstcfnFVg
SXcJclJHbFeUj1PFtebuGRARQRTbCiYYC0YF9GcYdQoU7tFmeHEH0kiktmlKdiVu
JbzcaEwnmmDBMFC8h6Cg1sOnnGpBcluLed1WEoqs/UmqYbY9U9owhzOV7NSbukQq
TzlbpKPkXsAUZW2q2NBYvbljDubSC+Cb88C0Qxwa25ulQYkDmHnIqsq8HNSEYfsS
hFVLndgSmtfobUKbDogLlqYN9vYN4bFl7nFeqcaH4ShlC01YefxjnEjBhJYRpXt5
8wpUiZ5+Jjxr7U3MpsgsQAbLQJClPA==
=+mR+
-----END PGP SIGNATURE-----

--hiskfds7hw52oih6--
