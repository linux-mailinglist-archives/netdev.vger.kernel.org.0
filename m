Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A3D3A9E03
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 16:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbhFPOsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 10:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234163AbhFPOsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 10:48:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995FFC061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 07:46:45 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ltWoU-00078q-14; Wed, 16 Jun 2021 16:46:42 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:27:4a54:dbae:b593])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B244863D59F;
        Wed, 16 Jun 2021 14:46:40 +0000 (UTC)
Date:   Wed, 16 Jun 2021 16:46:40 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH v2 2/2] can: netlink: add interface for CAN-FD
 Transmitter Delay Compensation (TDC)
Message-ID: <20210616144640.l4hjc6mc3ndw25hj@pengutronix.de>
References: <20210603151550.140727-1-mailhol.vincent@wanadoo.fr>
 <20210603151550.140727-3-mailhol.vincent@wanadoo.fr>
 <20210616094633.fwg6rsyxyvm2zc6d@pengutronix.de>
 <CAMZ6RqLj59+3PrQwTCfK_bVebRBHE=HqCfRb31MU9pRDBPxG8w@mail.gmail.com>
 <20210616142940.wxllr3c55rk66rij@pengutronix.de>
 <CAMZ6RqJWeexWTGVkEJWMvBs1f=HQOc4zjd-PqPsxKnCr_XDFZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yfgh76m5lrylc5pl"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqJWeexWTGVkEJWMvBs1f=HQOc4zjd-PqPsxKnCr_XDFZQ@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yfgh76m5lrylc5pl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.06.2021 23:43:35, Vincent MAILHOL wrote:
> > Sounds good, I'm squashing this patch:
> >
> > | diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netl=
ink.c
> > | index 6134bbf69c10..d48be574eae7 100644
> > | --- a/drivers/net/can/dev/netlink.c
> > | +++ b/drivers/net/can/dev/netlink.c
> > | @@ -311,7 +311,7 @@ static size_t can_tdc_get_size(const struct net_d=
evice *dev)
> > |         size +=3D nla_total_size(sizeof(u32));            /* IFLA_CAN=
_TDCO_MAX */
> > |         size +=3D nla_total_size(sizeof(u32));            /* IFLA_CAN=
_TDCF_MAX */
> > |
> > | -       if (priv->tdc.tdco) {
> > | +       if (can_tdc_is_enabled(priv)) {
> > |                 size +=3D nla_total_size(sizeof(u32));    /* IFLA_CAN=
_TDCV */
> > |                 size +=3D nla_total_size(sizeof(u32));    /* IFLA_CAN=
_TDCO */
> > |                 size +=3D nla_total_size(sizeof(u32));    /* IFLA_CAN=
_TDCF */
> > | @@ -352,6 +352,7 @@ static size_t can_get_size(const struct net_devic=
e *dev)
> > |                                        priv->data_bitrate_const_cnt);
> > |         size +=3D sizeof(priv->bitrate_max);                      /* =
IFLA_CAN_BITRATE_MAX */
> > |         size +=3D can_tdc_get_size(dev);                          /* =
IFLA_CAN_TDC */
> > | +
> > |         return size;
> > |  }
> > |
> > | @@ -374,7 +375,7 @@ static int can_tdc_fill_info(struct sk_buff *skb,=
 const struct net_device *dev)
> > |             nla_put_u32(skb, IFLA_CAN_TDC_TDCF_MAX, tdc_const->tdcf_m=
ax))
> > |                 goto err_cancel;
> > |
> > | -       if (priv->tdc.tdco)
> > | +       if (can_tdc_is_enabled(priv)) {
> > |                 if (nla_put_u32(skb, IFLA_CAN_TDC_TDCV, tdc->tdcv) ||
> > |                     nla_put_u32(skb, IFLA_CAN_TDC_TDCO, tdc->tdco) ||
> > |                     nla_put_u32(skb, IFLA_CAN_TDC_TDCF, tdc->tdcf))
> > | diff --git a/include/linux/can/bittiming.h b/include/linux/can/bittim=
ing.h
> > | index 9de6e9053e34..b6d1db1e7258 100644
> > | --- a/include/linux/can/bittiming.h
> > | +++ b/include/linux/can/bittiming.h
> > | @@ -83,6 +83,11 @@ struct can_tdc_const {
> > |         u32 tdcf_max;
> > |  };
> > |
> > | +static inline bool can_tdc_is_enabled(const struct can_priv *priv)
>=20
> Did you try to compile?

Not before sending that mail :)

> I am not sure if bittiming.h is able to see struct can_priv which is
> defined in dev.h.

Nope it doesn't, I moved the can_tdc_is_enabled() to
include/linux/can/dev.h

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--yfgh76m5lrylc5pl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDKDs0ACgkQqclaivrt
76nmKgf+JKGqznOyIg4hPJil6qfsqgmZnRQEiy1rkwKYNbOwYXLuiFr4vf6g1H1l
r0vYi80+78mcIIlqpBGirsKB3WX993WpfLDmPnvM+vB/CV+kxmKu4gQWOr0MRMpY
QNj7qb8w3zkc1gFm6nMXWxOqXPDBPaPFEGdfF8khYzs8xJ3UUNrUhWS5KQvA1wjg
ru05plLZqUIR6qvQCcefdguE/owCLYNxf9hBsfIJc5M6Os8XmB/NO/W/FQ7pPS4p
D0dLB6v2jH1v71XjvrYbxqGFMG96PY6YOoqdYRKkFrGj4q/989A66R3jQ4VNQZgz
bKLdR+AniFa7sBGpB7b0jXgLzeSL1w==
=NYU/
-----END PGP SIGNATURE-----

--yfgh76m5lrylc5pl--
