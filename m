Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 962AC64095D
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 16:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbiLBP1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 10:27:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233545AbiLBP11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 10:27:27 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC72CFE67
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 07:27:26 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p17wW-0007eq-GS; Fri, 02 Dec 2022 16:27:12 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:63a6:d4c5:22e2:f72a])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1E2CB1317A1;
        Fri,  2 Dec 2022 15:27:10 +0000 (UTC)
Date:   Fri, 2 Dec 2022 16:27:01 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Cc:     dario.binacchi@amarulasolutions.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Palethorpe <richard.palethorpe@suse.com>,
        Petr Vorel <petr.vorel@suse.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        Max Staudt <max@enpas.org>
Subject: Re: [PATCH] can: slcan: fix freed work crash
Message-ID: <20221202152701.ewnillsqded7uby4@pengutronix.de>
References: <20221201073426.17328-1-jirislaby@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ojrs3pnyh3h6c3hc"
Content-Disposition: inline
In-Reply-To: <20221201073426.17328-1-jirislaby@kernel.org>
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


--ojrs3pnyh3h6c3hc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 01.12.2022 08:34:26, Jiri Slaby (SUSE) wrote:
> The LTP test pty03 is causing a crash in slcan:
>   BUG: kernel NULL pointer dereference, address: 0000000000000008
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 0 P4D 0
>   Oops: 0000 [#1] PREEMPT SMP NOPTI
>   CPU: 0 PID: 348 Comm: kworker/0:3 Not tainted 6.0.8-1-default #1 openSU=
SE Tumbleweed 9d20364b934f5aab0a9bdf84e8f45cfdfae39dab
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.15.0-=
0-g2dd4b9b-rebuilt.opensuse.org 04/01/2014
>   Workqueue:  0x0 (events)
>   RIP: 0010:process_one_work (/home/rich/kernel/linux/kernel/workqueue.c:=
706 /home/rich/kernel/linux/kernel/workqueue.c:2185)
>   Code: 49 89 ff 41 56 41 55 41 54 55 53 48 89 f3 48 83 ec 10 48 8b 06 48=
 8b 6f 48 49 89 c4 45 30 e4 a8 04 b8 00 00 00 00 4c 0f 44 e0 <49> 8b 44 24 =
08 44 8b a8 00 01 00 00 41 83 e5 20 f6 45 10 04 75 0e
>   RSP: 0018:ffffaf7b40f47e98 EFLAGS: 00010046
>   RAX: 0000000000000000 RBX: ffff9d644e1b8b48 RCX: ffff9d649e439968
>   RDX: 00000000ffff8455 RSI: ffff9d644e1b8b48 RDI: ffff9d64764aa6c0
>   RBP: ffff9d649e4335c0 R08: 0000000000000c00 R09: ffff9d64764aa734
>   R10: 0000000000000007 R11: 0000000000000001 R12: 0000000000000000
>   R13: ffff9d649e4335e8 R14: ffff9d64490da780 R15: ffff9d64764aa6c0
>   FS:  0000000000000000(0000) GS:ffff9d649e400000(0000) knlGS:00000000000=
00000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 0000000000000008 CR3: 0000000036424000 CR4: 00000000000006f0
>   Call Trace:
>    <TASK>
>   worker_thread (/home/rich/kernel/linux/kernel/workqueue.c:2436)
>   kthread (/home/rich/kernel/linux/kernel/kthread.c:376)
>   ret_from_fork (/home/rich/kernel/linux/arch/x86/entry/entry_64.S:312)
>=20
> Apparently, the slcan's tx_work is freed while being scheduled. While
> slcan_netdev_close() (netdev side) calls flush_work(&sl->tx_work),
> slcan_close() (tty side) does not. So when the netdev is never set UP,
> but the tty is stuffed with bytes and forced to wakeup write, the work
> is scheduled, but never flushed.
>=20
> So add an additional flush_work() to slcan_close() to be sure the work
> is flushed under all circumstances.
>=20
> The Fixes commit below moved flush_work() from slcan_close() to
> slcan_netdev_close(). What was the rationale behind it? Maybe we can
> drop the one in slcan_netdev_close()?
>=20
> I see the same pattern in can327. So it perhaps needs the very same fix.
>=20
> Fixes: cfcb4465e992 ("can: slcan: remove legacy infrastructure")
> Link: https://bugzilla.suse.com/show_bug.cgi?id=3D1205597
> Reported-by: Richard Palethorpe <richard.palethorpe@suse.com>
> Tested-by: Petr Vorel <petr.vorel@suse.com>
> Cc: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> Cc: Wolfgang Grandegger <wg@grandegger.com>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: linux-can@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: Max Staudt <max@enpas.org>
> Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>

Added to linux-can,

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ojrs3pnyh3h6c3hc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmOKGUMACgkQrX5LkNig
011wWQgAn+U91/ZltYGvoyP6wurNPczrfH4QqhMQ3x77TXxYpIO7Bme9LzWgnowK
aCZGAi6RhnBCwVHYrRkPuQ9karVWhlrEYkLRKZJcBG3fbbOFMC+lUy51Tk4Dd+fR
GZKwdr4ODTxerh5E6PBqCais4zGBdzBqGB+md9C7EUnvgC5MeGSAf8EFUkRrmb8T
Wd8F2IRz5FCOZ0JjlTDHWWoS4dedoiodLUhyDCXn2mDMVjtDGkCHcvMM+3MO1bE1
GLU21H65XDHg6nVBDmvMpLdfbvDxc3qVroe3wXyeJ8wzSd/acELrHusTZXKvmDg+
IU0m+hpBwzplYQLMJSzmk5zZN76bWQ==
=XIQ/
-----END PGP SIGNATURE-----

--ojrs3pnyh3h6c3hc--
