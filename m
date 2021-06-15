Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2323A7818
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 09:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhFOHmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 03:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbhFOHmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 03:42:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614FDC061767
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 00:40:00 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lt3ft-0002gp-Fa; Tue, 15 Jun 2021 09:39:53 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:8a21:1526:9696:549])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 6258D63BCCA;
        Tue, 15 Jun 2021 07:39:48 +0000 (UTC)
Date:   Tue, 15 Jun 2021 09:39:47 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Kirill Tkhai <ktkhai@virtuozzo.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-can@vger.kernel.org
Subject: Re: [PATCH v2] can: bcm/raw/isotp: use per module netdevice notifier
Message-ID: <20210615073947.jyznw75esoetjg7x@pengutronix.de>
References: <20210602151733.3630-1-penguin-kernel@I-love.SAKURA.ne.jp>
 <265c1129-96f1-7bb1-1d01-b2b8cc5b1a42@hartkopp.net>
 <51ed3352-b5b0-03a1-ec25-faa368adcc46@i-love.sakura.ne.jp>
 <5e4693cf-4691-e7da-9a04-3e70cc449bf5@i-love.sakura.ne.jp>
 <e5a53bed-4333-bd99-ca3d-0e25dfb546e5@virtuozzo.com>
 <54a5f451-05ed-f977-8534-79e7aa2bcc8f@i-love.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="knf33wvbzsd6nlhj"
Content-Disposition: inline
In-Reply-To: <54a5f451-05ed-f977-8534-79e7aa2bcc8f@i-love.sakura.ne.jp>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--knf33wvbzsd6nlhj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.06.2021 19:26:35, Tetsuo Handa wrote:
> From 12c61ae3d06889c9bbc414f0230c05dc630f6409 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Sat, 5 Jun 2021 19:18:21 +0900
> Subject: [PATCH v2] can: bcm/raw/isotp: use per module netdevice notifier
>=20
> syzbot is reporting hung task at register_netdevice_notifier() [1] and
> unregister_netdevice_notifier() [2], for cleanup_net() might perform
> time consuming operations while CAN driver's raw/bcm/isotp modules are
> calling {register,unregister}_netdevice_notifier() on each socket.
>=20
> Change raw/bcm/isotp modules to call register_netdevice_notifier() from
> module's __init function and call unregister_netdevice_notifier() from
> module's __exit function, as with gw/j1939 modules are doing.
>=20
> Link: https://syzkaller.appspot.com/bug?id=3D391b9498827788b3cc6830226d4f=
f5be87107c30 [1]
> Link: https://syzkaller.appspot.com/bug?id=3D1724d278c83ca6e6df100a2e320c=
10d991cf2bce [2]
> Reported-by: syzbot <syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.co=
m>
> Reported-by: syzbot <syzbot+0f1827363a305f74996f@syzkaller.appspotmail.co=
m>
> Tested-by: syzbot <syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.com>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Applied to linux-can/testing.

Tnx,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--knf33wvbzsd6nlhj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDIWUEACgkQqclaivrt
76kQHwgAqF7nAU6Rtezb1ileRu23thA493XpOLsold1ZIO1m0KmngEa2YtYvREZq
ArRCDTbIcu4s3AyTYsLVKQS6gKu+gz96mU4GnEStMRELytHUSRDIfqRVIx9Lljwh
LoRS6rTX2Lu3xHVn7bdTumdajZjjVIhRP0SlXC+6R1zqOMcBORzB2fUY1ESNlUqr
zR7xt1TU1lGqvHxJHPErhrkqpI/r8NkRoZIGiC5kwl/blLNsC/tNWyzOV+Qv0L/7
kR5Q4XLzSSsGCjIGB6YxGP70tBNsS8czD8I0sFo7uSpRivuIbQUjjAENwKOfc+kw
SarW4hsee9gWAOvKpUvInflNLrc4zA==
=qZIz
-----END PGP SIGNATURE-----

--knf33wvbzsd6nlhj--
