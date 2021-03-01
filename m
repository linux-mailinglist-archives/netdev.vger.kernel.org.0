Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7AA327F10
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 14:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbhCANKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 08:10:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235449AbhCANJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 08:09:41 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E33AC06178A
        for <netdev@vger.kernel.org>; Mon,  1 Mar 2021 05:09:01 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lGiI4-00064x-GU; Mon, 01 Mar 2021 14:08:48 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:6e66:a1a4:a449:44cd])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 655305EB278;
        Mon,  1 Mar 2021 13:08:46 +0000 (UTC)
Date:   Mon, 1 Mar 2021 14:08:45 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dariobin@libero.it>
Cc:     linux-kernel@vger.kernel.org,
        Federico Vaga <federico.vaga@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        YueHaibing <yuehaibing@huawei.com>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 5/6] can: c_can: prepare to up the message objects
 number
Message-ID: <20210301130845.3s45ujmhkazscm6x@pengutronix.de>
References: <20210228103856.4089-1-dariobin@libero.it>
 <20210228103856.4089-6-dariobin@libero.it>
 <20210301113805.jylhc373sip7zmed@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6padqo4tgffcbgov"
Content-Disposition: inline
In-Reply-To: <20210301113805.jylhc373sip7zmed@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6padqo4tgffcbgov
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 01.03.2021 12:38:05, Marc Kleine-Budde wrote:
> On 28.02.2021 11:38:54, Dario Binacchi wrote:
> [...]
>=20
> > @@ -730,7 +728,7 @@ static void c_can_do_tx(struct net_device *dev)
> >  	while ((idx =3D ffs(pend))) {
> >  		idx--;
> >  		pend &=3D ~(1 << idx);
> > -		obj =3D idx + C_CAN_MSG_OBJ_TX_FIRST;
> > +		obj =3D idx + priv->msg_obj_tx_first;
> >  		c_can_inval_tx_object(dev, IF_TX, obj);
> >  		can_get_echo_skb(dev, idx, NULL);
> >  		bytes +=3D priv->dlc[idx];
> > @@ -740,7 +738,7 @@ static void c_can_do_tx(struct net_device *dev)
> >  	/* Clear the bits in the tx_active mask */
> >  	atomic_sub(clr, &priv->tx_active);
> > =20
> > -	if (clr & (1 << (C_CAN_MSG_OBJ_TX_NUM - 1)))
> > +	if (clr & (1 << (priv->msg_obj_tx_num - 1)))
>=20
> Do we need 1UL here, too?

There are several more "1 <<" in the driver. As the right side of the
sift operation can be up to 32, I think you should replace all "1 <<"
with "1UL <<".

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--6padqo4tgffcbgov
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmA851oACgkQqclaivrt
76lVCAf/fD2kv4AaTlo/WCGvVcdQgNunuCNtU6gKv9NxYJdx8goRxw25LEPpbvgf
/LyYcc3PZdt43WSluC5YAgh9sU9u1kYONCv07w9S/hClZtlVP+7rI0C9Qhdi4rl/
Cq9nDgk560o1USfI6t2X8yzp50Jgr+6rJZaIcVhU+k3gB8IMFqQDvZmdVBabXv/z
Y95/KSaqBVK3NmD44Djd8CK2MWmoozhdQPf3HAhkCw4qusrGLDsMPMcNaQzkQ5HV
hXspd+N6IeDt+zKF96QRM+wreplpRz+1L/PA2GWW/p7E8yU5VFISlKQ/jmFoP/VT
Vca/u1cz1ChXM92jY4D8UYyrlfjSmw==
=cBHB
-----END PGP SIGNATURE-----

--6padqo4tgffcbgov--
