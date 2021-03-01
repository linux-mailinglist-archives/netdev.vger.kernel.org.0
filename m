Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF861328FCF
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 21:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242517AbhCAT61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 14:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242608AbhCATyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 14:54:11 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B958C061221
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 11:49:35 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lGoXg-0000Jv-G3; Mon, 01 Mar 2021 20:49:20 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:bdf1:58e9:8113:f2a1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id CB0C45EBC2B;
        Mon,  1 Mar 2021 19:45:51 +0000 (UTC)
Date:   Mon, 1 Mar 2021 20:45:50 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        Federico Vaga <federico.vaga@gmail.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 5/6] can: c_can: prepare to up the message objects
 number
Message-ID: <20210301194550.6zqmxzcwvzlgjzcj@pengutronix.de>
References: <20210228103856.4089-1-dariobin@libero.it>
 <20210228103856.4089-6-dariobin@libero.it>
 <20210301113805.jylhc373sip7zmed@pengutronix.de>
 <1037673059.602534.1614619302914@mail1.libero.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="c22ofk4qmvaury3p"
Content-Disposition: inline
In-Reply-To: <1037673059.602534.1614619302914@mail1.libero.it>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--c22ofk4qmvaury3p
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 01.03.2021 18:21:42, Dario Binacchi wrote:
> > > @@ -730,7 +728,7 @@ static void c_can_do_tx(struct net_device *dev)
> > >  	while ((idx =3D ffs(pend))) {
> > >  		idx--;
> > >  		pend &=3D ~(1 << idx);
> > > -		obj =3D idx + C_CAN_MSG_OBJ_TX_FIRST;
> > > +		obj =3D idx + priv->msg_obj_tx_first;
> > >  		c_can_inval_tx_object(dev, IF_TX, obj);
> > >  		can_get_echo_skb(dev, idx, NULL);
> > >  		bytes +=3D priv->dlc[idx];
> > > @@ -740,7 +738,7 @@ static void c_can_do_tx(struct net_device *dev)
> > >  	/* Clear the bits in the tx_active mask */
> > >  	atomic_sub(clr, &priv->tx_active);
> > > =20
> > > -	if (clr & (1 << (C_CAN_MSG_OBJ_TX_NUM - 1)))
> > > +	if (clr & (1 << (priv->msg_obj_tx_num - 1)))
> >=20
> > Do we need 1UL here, too?
>=20
> Do you agree if I use the BIT macro ?

No, please use GENMASK(priv->msg_obj_tx_num, 0) here.

regrads,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--c22ofk4qmvaury3p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmA9RGwACgkQqclaivrt
76lnFwf8DQbsQes5TgYSyC4pX9bemW0J96NjGsVtmJ/v+SSZGthxcz5afH0HBsPy
7GNSENjVvOY643qHAVBHpkdEwjzNQNhSIX4mLn72bSB+IhLCc9eThSt2QRmZp0zc
1KeBvbHTc1KvkUkwvUuQkfsnN8pu8a16AbmWIC/N4eu9FkupvWGG1tf0KsJDH0xT
OQB8m/x8wP78JYFs4Caebaio9FduXWVcKjoo4Uk8NdEIDQXxY7DTqKVMw3UZaHwb
G5xQD2ywOr52+gOhegJzGFecPbMr5yVJ3oQoPaw28Cfj/e2s0Ix7jj1eY7lVdox7
xXdLlAZ0JiYYwn5gowhiB4nmjpMuzQ==
=+kpR
-----END PGP SIGNATURE-----

--c22ofk4qmvaury3p--
