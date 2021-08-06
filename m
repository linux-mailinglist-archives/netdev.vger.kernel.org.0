Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE693E2766
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 11:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244605AbhHFJhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 05:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244396AbhHFJhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 05:37:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09383C061799
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 02:37:09 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mBwHm-00029e-MZ; Fri, 06 Aug 2021 11:37:02 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:66f0:974b:98ab:a2fd])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 63286661D5B;
        Fri,  6 Aug 2021 09:37:00 +0000 (UTC)
Date:   Fri, 6 Aug 2021 11:36:58 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        Gianluca Falavigna <gianluca.falavigna@inwind.it>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 4/4] can: c_can: cache frames to operate as a true FIFO
Message-ID: <20210806093658.rvzw7zycrmyp4msp@pengutronix.de>
References: <20210805201900.23146-1-dariobin@libero.it>
 <20210805201900.23146-5-dariobin@libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kkgc47zk5ugabioc"
Content-Disposition: inline
In-Reply-To: <20210805201900.23146-5-dariobin@libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--kkgc47zk5ugabioc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.08.2021 22:19:00, Dario Binacchi wrote:
> As reported by a comment in the c_can_start_xmit() this was not a FIFO.
> C/D_CAN controller sends out the buffers prioritized so that the lowest
> buffer number wins.
>=20
> What did c_can_start_xmit() do if head was less tail in the tx ring ? It
> waited until all the frames queued in the FIFO was actually transmitted
> by the controller before accepting a new CAN frame to transmit, even if
> the FIFO was not full, to ensure that the messages were transmitted in
> the order in which they were loaded.
>=20
> By storing the frames in the FIFO without requiring its transmission, we
> will be able to use the full size of the FIFO even in cases such as the
> one described above. The transmission interrupt will trigger their
> transmission only when all the messages previously loaded but stored in
> less priority positions of the buffers have been transmitted.
>=20
> Suggested-by: Gianluca Falavigna <gianluca.falavigna@inwind.it>
> Signed-off-by: Dario Binacchi <dariobin@libero.it>

My review from
https://lore.kernel.org/linux-can/20210806092523.hij5ejjq6wecbgfr@pengutron=
ix.de/
applies here, too.

Please use IF_RX in c_can_do_tx(), remove the spin_lock and test. After
applying your series, I'll send a patch that changes IF_RX into IF_NAPI
to avoid any further confusion.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--kkgc47zk5ugabioc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmENArgACgkQqclaivrt
76lr2ggAtT5H7Kcg2sOQ418ClRECb7Ivlr96/mGdHw2VANvbT0xzrmACGFjFQG1k
yGPnmsKdA+SZp5lkRJNVFgZMUc5vZQjqFEh+V5YScdG1hYSnRtRkvvbqOqWrxfmG
bZBHiUJKZIGRQLT61mBHQS9HmKnGMX0j3WEGn/uNTr/guFH+P3JzbZj7GGLNUgGA
hjdTYUnO3j2i7dV/E6hPRSDwcBDkXzuwZxmtkuWOdb5ZNeokfF/1oi466phe5fBg
r1UXw830FbsaqrkI+HnoxxZRBXCl6EneRNfapJxMmtRGdc8+czpdkoo5xDL61DMW
UdcsQpCF8GUp9Igluek5mBqCnzVa1w==
=WNgH
-----END PGP SIGNATURE-----

--kkgc47zk5ugabioc--
