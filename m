Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796626C1A3F
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 16:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbjCTPuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 11:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbjCTPtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 11:49:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4551E1588E
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 08:41:16 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1peHd3-0003kL-Nu; Mon, 20 Mar 2023 16:40:57 +0100
Received: from pengutronix.de (unknown [IPv6:2a00:20:c01f:3d56:6ab1:6a2f:e979:45b0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 193DD197A1C;
        Mon, 20 Mar 2023 15:40:55 +0000 (UTC)
Date:   Mon, 20 Mar 2023 16:40:53 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     Ivan Orlov <ivan.orlov0322@gmail.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, himadrispandya@gmail.com,
        skhan@linuxfoundation.org,
        syzbot+c9bfd85eca611ebf5db1@syzkaller.appspotmail.com
Subject: Re: [PATCH] FS, NET: Fix KMSAN uninit-value in vfs_write
Message-ID: <20230320154053.x3h54b2s3r7iclby@pengutronix.de>
References: <20230314120445.12407-1-ivan.orlov0322@gmail.com>
 <0e7090c4-ca9b-156f-5922-fd7ddb55fee4@hartkopp.net>
 <ff0a4ed4-9fde-7a9f-da39-d799dfb946f1@gmail.com>
 <b4abefa2-16d0-a18c-4614-1786eb94ffab@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="p67maiohpxc2m32e"
Content-Disposition: inline
In-Reply-To: <b4abefa2-16d0-a18c-4614-1786eb94ffab@hartkopp.net>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
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


--p67maiohpxc2m32e
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.03.2023 20:23:47, Oliver Hartkopp wrote:
>=20
>=20
> On 14.03.23 16:37, Ivan Orlov wrote:
> > On 3/14/23 18:38, Oliver Hartkopp wrote:
> > > Hello Ivan,
> > >=20
> > > besides the fact that we would read some uninitialized value the
> > > outcome of the original implementation would have been an error and
> > > a termination of the copy process too. Maybe throwing a different
> > > error number.
> > >=20
> > > But it is really interesting to see what KMSAN is able to detect
> > > these days! Many thanks for the finding and your effort to
> > > contribute this fix!
> > >=20
> > > Best regards,
> > > Oliver
> > >=20
> > >=20
> > > On 14.03.23 13:04, Ivan Orlov wrote:
> > > > Syzkaller reported the following issue:
> > >=20
> > > (..)
> > >=20
> > > >=20
> > > > Reported-by: syzbot+c9bfd85eca611ebf5db1@syzkaller.appspotmail.com
> > > > Link: https://syzkaller.appspot.com/bug?id=3D47f897f8ad958bbde5790e=
bf389b5e7e0a345089
> > > > Signed-off-by: Ivan Orlov <ivan.orlov0322@gmail.com>
> > >=20
> > > Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
> > >=20
> > >=20
> > > > ---
> > > > =C2=A0 net/can/bcm.c | 16 ++++++++++------
> > > > =C2=A0 1 file changed, 10 insertions(+), 6 deletions(-)
> > > >=20
> > > > diff --git a/net/can/bcm.c b/net/can/bcm.c
> > > > index 27706f6ace34..a962ec2b8ba5 100644
> > > > --- a/net/can/bcm.c
> > > > +++ b/net/can/bcm.c
> > > > @@ -941,6 +941,8 @@ static int bcm_tx_setup(struct bcm_msg_head
> > > > *msg_head, struct msghdr *msg,
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 cf =3D op->frames + op->cfsiz * i;
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 err =3D memcpy_from_msg((u8 *)cf, msg, op->cfsiz);
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 if (err < 0)
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 goto free_op;
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (op->flags & CAN_FD_FRAME) {
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (cf->len > 64)
> > > > @@ -950,12 +952,8 @@ static int bcm_tx_setup(struct bcm_msg_head
> > > > *msg_head, struct msghdr *msg,
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D -EINVA=
L;
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 }
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 if (err < 0) {
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 if (op->frames !=3D &op->sframe)
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(op->frames);
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 kfree(op);
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 return err;
> > > > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 }
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 if (err < 0)
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 goto free_op;
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (msg_head->flags & TX_CP_CAN_ID) {
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* copy can_id into frame */
> > > > @@ -1026,6 +1024,12 @@ static int bcm_tx_setup(struct
> > > > bcm_msg_head *msg_head, struct msghdr *msg,
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bcm_tx_start=
_timer(op);
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return msg_head->nframes * op->cfsiz=
 + MHSIZ;
> > > > +
> > > > +free_op:
> > > > +=C2=A0=C2=A0=C2=A0 if (op->frames !=3D &op->sframe)
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(op->frames);
> > > > +=C2=A0=C2=A0=C2=A0 kfree(op);
> > > > +=C2=A0=C2=A0=C2=A0 return err;
> > > > =C2=A0 }
> > > > =C2=A0 /*
> >=20
> > Thank you for the quick answer! I totally agree that this patch will not
> > change the behavior a lot. However, I think a little bit more error
> > processing will not be bad (considering this will not bring any
> > performance overhead). If someone in the future tries to use the "cf"
> > object right after "memcpy_from_msg" call without proper error
> > processing it will lead to a bug (which will be hard to trigger). Maybe
> > fixing it now to avoid possible future mistakes in the future makes
> > sense?
>=20
> Yes! Definitely!
>=20
> Therefore I added my Acked-by: tag. Marc will likely pick this patch for
> upstream.

Can you create a proper Fixes tag?

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--p67maiohpxc2m32e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQYfnoACgkQvlAcSiqK
BOgJHggAs4kxDY/WxmiaOlQ4jg5qtMM36yenwMmqwGTbSHRs6ShzX/B8pK7R9XQA
Z3VLNf9gc8MqivXTSF9tbSfPQPOadGoCVAjUc4UNN9AacC9gcYA30wM3m7REYX3Q
qsud6oe/nyrnAOens7bprqUJnRX1W/qKPhJZ6hs/IlIuuRFCxvuzMqj8X0JvEPIm
51d7WPCfcVQsUrEaad7W0QLxdjreX61mtRWyDY9p1HS9kBt7n0wHToMizWMOtPjQ
lu3outarT8zLrAHaV6CPJ8v3lgtrhC4JPzcXhh5AsPtp0wAUjxedYqaxV+d/2Z4h
mR8ip99WHeYPrbWhxXB9xGfM3hIV+A==
=sdPM
-----END PGP SIGNATURE-----

--p67maiohpxc2m32e--
