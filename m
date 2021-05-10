Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A9B3792DE
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 17:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbhEJPiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 11:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237066AbhEJPhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 11:37:38 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F45C06134C
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 08:35:44 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lg7wc-0004BL-Oj; Mon, 10 May 2021 17:35:42 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:a33b:547d:8182:18b0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 8F6A862179F;
        Mon, 10 May 2021 15:35:41 +0000 (UTC)
Date:   Mon, 10 May 2021 17:35:40 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Torin Cooper-Bennun <torin@maxiluxsystems.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: CAN: TX frames marked as RX after the sending socket is closed
Message-ID: <20210510153540.52uzcndqyp6yu7ve@pengutronix.de>
References: <20210510142302.ijbwowv4usoiqkxq@bigthink>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hddizjikimcuaham"
Content-Disposition: inline
In-Reply-To: <20210510142302.ijbwowv4usoiqkxq@bigthink>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hddizjikimcuaham
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10.05.2021 15:23:02, Torin Cooper-Bennun wrote:
> Scenario: I open a raw CAN socket, queue a bunch of frames for TX, then
> close the socket as soon as possible. For the duration of the test, I
> have another socket open listening for all frames (candump).
>=20
> After the sending socket has been closed, and there are still frames in
> the queue yet to be transmitted, I find candump reporting the remainder
> of my sent frames as RX rather than TX.
>=20
> For example, I send 1,000 8-byte classical CAN frames, immediately close
> the socket and log the time at which I did so.

Can you provide the program to reproduce the issue?
Have you increased the CAN interface's txqueuelen?

> My application reports the socket closed:
>=20
> | Socket closed at 15:02:45.987278
>=20
> My candump log shows:
>=20
> | (2021-05-10 15:02:45.327724)  can0  TX - -  000  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:45.329578)  can0  TX - -  001  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:45.330493)  can0  TX - -  002  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:45.331341)  can0  TX - -  003  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:45.332264)  can0  TX - -  004  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:45.333148)  can0  TX - -  005  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:45.334115)  can0  TX - -  006  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:45.335061)  can0  TX - -  007  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:45.336021)  can0  TX - -  008  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:45.336951)  can0  TX - -  009  [08]  EE EE EE EE EE E=
E EE EE
> |=20
> | .... snip ....
> |
> | (2021-05-10 15:02:46.089177)  can0  TX - -  399  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:46.090001)  can0  TX - -  39A  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:46.090852)  can0  TX - -  39B  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:46.091735)  can0  TX - -  39C  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:46.092483)  can0  TX - -  39D  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:46.093313)  can0  RX - -  39E  [08]  EE EE EE EE EE E=
E EE EE <----- !!!!!
> | (2021-05-10 15:02:46.094091)  can0  RX - -  39F  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:46.094931)  can0  RX - -  3A0  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:46.095774)  can0  RX - -  3A1  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:46.096513)  can0  RX - -  3A2  [08]  EE EE EE EE EE E=
E EE EE
> |
> | .... snip ....
> |
> | (2021-05-10 15:02:46.143287)  can0  RX - -  3DE  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:46.144046)  can0  RX - -  3DF  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:46.144808)  can0  RX - -  3E0  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:46.145570)  can0  RX - -  3E1  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:46.146357)  can0  RX - -  3E2  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:46.147117)  can0  RX - -  3E3  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:46.147876)  can0  RX - -  3E4  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:46.148635)  can0  RX - -  3E5  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:46.149395)  can0  RX - -  3E6  [08]  EE EE EE EE EE E=
E EE EE
> | (2021-05-10 15:02:46.150161)  can0  RX - -  3E7  [08]  EE EE EE EE EE E=
E EE EE
>=20
> Why?
>=20
> candump.c prints 'RX' if the received frame has no MSG_DONTROUTE flag.
>=20
> |	if (msg.msg_flags & MSG_DONTROUTE)
> |		printf ("  TX %s", extra_m_info[frame.flags & 3]);
> |	else
> |		printf ("  RX %s", extra_m_info[frame.flags & 3]);
>=20
> In turn, MSG_DONTROUTE is set in net/can/raw.c: raw_rcv():
>=20
> |	/* add CAN specific message flags for raw_recvmsg() */
> |	pflags =3D raw_flags(skb);
> |	*pflags =3D 0;
> |	if (oskb->sk)
> |		*pflags |=3D MSG_DONTROUTE;
> |	if (oskb->sk =3D=3D sk)
> |		*pflags |=3D MSG_CONFIRM;
>=20
> So, I'm guessing, some 100 ms after my application begins to request
> that the socket be closed, the socket's pointer becomes NULL in further
> TX skbs in the queue, so the raw CAN layer can no longer differentiate
> these skbs as TX. (Sorry if my pathways are a bit mixed up.)
>=20
> Seems broken to me - is this known behaviour?

Looks like a unknown bug to me!

> Test setup:
>  - kernel: v5.13-rc1 with some RPi-specific patches
>  - hardware: RPi CM4 with TCAN4550 (so, m_can driver in peripheral mode)

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--hddizjikimcuaham
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmCZUsoACgkQqclaivrt
76nFgAf/b6m+O8oOzdhcwqNZYfjgZA6IzWsP5PzBRTsScGo+tlONGvaSiuVTF5LR
4ID+Tgj+4Ke6X7aAMZdFU7h5qBRoKQoCZ6193redBeU4efIXCB7yqcZXWFIT9PWg
KFYPPuJWTQlwqvhtuaLRGfGzHApLMuihD+JVWXZE6wxKRJKJYL0Mm6O8VFuU70df
Cwk/KooZzuNqc2cibxBDy7KpvDuFtc8JH5nfxEx4RpCh7pqf09Otyn+7Tv3UGfFC
EN9rfp99hMDZ1hFDKEytwz40spKOAEvGTn5gXtRQAYWvPPDt3nwpfuR2p/Q5dFPO
iyfkywa/KuYOR5JO8PVtNMqnXZB57A==
=QyjB
-----END PGP SIGNATURE-----

--hddizjikimcuaham--
