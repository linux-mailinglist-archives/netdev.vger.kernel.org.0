Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E3C3ED7F1
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 15:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbhHPNv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 09:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbhHPNvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 09:51:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE568C0613C1
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 06:51:20 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mFd1I-0003Ma-Pm; Mon, 16 Aug 2021 15:51:16 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:3272:cc96:80a9:1a01])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 07E3F6683A0;
        Mon, 16 Aug 2021 13:51:14 +0000 (UTC)
Date:   Mon, 16 Aug 2021 15:51:13 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        linux-can@vger.kernel.org,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/4] iplink_can: add new CAN FD bittiming parameters:
 Transmitter Delay Compensation (TDC)
Message-ID: <20210816135113.gpk3fpafiqnhjbw4@pengutronix.de>
References: <20210814101728.75334-1-mailhol.vincent@wanadoo.fr>
 <20210814101728.75334-5-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uw3za2cin73atu2y"
Content-Disposition: inline
In-Reply-To: <20210814101728.75334-5-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uw3za2cin73atu2y
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
>     mode, the user must specify both TDCV and TDCO and may also
>     specify TDCF if supported.
>=20
>   * off: TDC is explicitly disabled.
>=20
>   * tdc-mode parameter omitted (default mode): the kernel decides
>     whether TDC should be enabled or not and if so, it calculates the
>     TDC values. TDC parameters are an expert option and the average
>     user is not expected to provide those, thus the presence of this
>     "default mode".
>=20
> TDCV is always reported in manual mode. In auto mode, TDCV is reported
> only if the value is available. Especially, the TDCV might not be
> available if the controller has no feature to report it or if the
> value in not yet available (i.e. no data sent yet and measurement did
> not occur).
>=20
> TDCF is reported only if tdcf_max is not zero (i.e. if supported by the c=
ontroller).
>=20
> For reference, here are a few samples of how the output looks like:
>=20
> $ ip link set can0 type can bitrate 1000000 dbitrate 8000000 fd on tdco 7=
 tdcf 8 tdc-mode auto
>=20
> $ ip --details link show can0
> 1:  can0: <NOARP,ECHO> mtu 72 qdisc noop state DOWN mode DEFAULT group de=
fault qlen 10
>     link/can  promiscuity 0 minmtu 0 maxmtu 0
>     can <FD,TDC_AUTO> state STOPPED (berr-counter tx 0 rx 0) restart-ms 0
              ^^^^^^^^
This is just the supported mode(s), right?

> 	  bitrate 1000000 sample-point 0.750
> 	  tq 12 prop-seg 29 phase-seg1 30 phase-seg2 20 sjw 1 brp 1
> 	  ES582.1/ES584.1: tseg1 2..256 tseg2 2..128 sjw 1..128 brp 1..512 brp_i=
nc 1
> 	  dbitrate 8000000 dsample-point 0.700
> 	  dtq 12 dprop-seg 3 dphase-seg1 3 dphase-seg2 3 dsjw 1 dbrp 1
> 	  tdco 7 tdcf 8
> 	  ES582.1/ES584.1: dtseg1 2..32 dtseg2 1..16 dsjw 1..8 dbrp 1..32 dbrp_i=
nc 1
> 	  tdco 0..127 tdcf 0..127
> 	  clock 80000000 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_=
segs 65535

Is there a way to figure out, which tdc mode is currently active?

AFAICS just implicitly:
- tdco + tdcv   -> manual
- tdco          -> automatic
- neither       -> off

correct?

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--uw3za2cin73atu2y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEabU8ACgkQqclaivrt
76nQ9wf8DSYrFmAPlYxWQHsv0ovgFow7hrqpCljYwTYqsn4Ft7+s6L/1gcZtX5Uh
z9L3W4nGFtfC380xQYR9pSLSK0G300ceeN7rdbEa4cYEWPQK6OZNEszqUr+rh5ur
kbZGuc+pGVrU8ZZ3ru42ntu2Bo/ob7/s5TIdpr/Ujuish1zNLwQmWymnsGw9KQEU
g0BeZMU/FnjsTsAdr/a9DnczunuuX9AomlwrYIR4R2EdPYm3VxZnZ7ttuecTF2Ri
9Qq5y8mNaR7jrvWTOHMZc7wAeZJMugtorLUc90kmGwD3TAbjTC2TtARSKSKOLvey
Qfa0IiiGx0hgEil37JPbfVwWQ4TIHQ==
=H91n
-----END PGP SIGNATURE-----

--uw3za2cin73atu2y--
