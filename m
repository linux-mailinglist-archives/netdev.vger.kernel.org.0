Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C84B3A9D9A
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 16:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbhFPOby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 10:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233941AbhFPObw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 10:31:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D46C061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 07:29:46 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ltWY2-0004bx-UO; Wed, 16 Jun 2021 16:29:43 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:27:4a54:dbae:b593])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id AC06263D56B;
        Wed, 16 Jun 2021 14:29:41 +0000 (UTC)
Date:   Wed, 16 Jun 2021 16:29:40 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH v2 2/2] can: netlink: add interface for CAN-FD
 Transmitter Delay Compensation (TDC)
Message-ID: <20210616142940.wxllr3c55rk66rij@pengutronix.de>
References: <20210603151550.140727-1-mailhol.vincent@wanadoo.fr>
 <20210603151550.140727-3-mailhol.vincent@wanadoo.fr>
 <20210616094633.fwg6rsyxyvm2zc6d@pengutronix.de>
 <CAMZ6RqLj59+3PrQwTCfK_bVebRBHE=HqCfRb31MU9pRDBPxG8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="keephfcgqr6o5xe3"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqLj59+3PrQwTCfK_bVebRBHE=HqCfRb31MU9pRDBPxG8w@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--keephfcgqr6o5xe3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 16.06.2021 22:53:02, Vincent MAILHOL wrote:
> On Wed. 16 Jun 2021 at 18:46, Marc Kleine-Budde <mkl@pengutronix.de> wrot=
e:
> > On 04.06.2021 00:15:50, Vincent Mailhol wrote:
> > [...]
> >
> > > +static size_t can_tdc_get_size(const struct net_device *dev)
> > > +{
> > > +     struct can_priv *priv =3D netdev_priv(dev);
> > > +     size_t size;
> > > +
> > > +     if (!priv->tdc_const)
> > > +             return 0;
> > > +
> > > +     size =3D nla_total_size(0);                       /* nest IFLA_=
CAN_TDC */
> > > +     size +=3D nla_total_size(sizeof(u32));            /* IFLA_CAN_T=
DCV_MAX */
> > > +     size +=3D nla_total_size(sizeof(u32));            /* IFLA_CAN_T=
DCO_MAX */
> > > +     size +=3D nla_total_size(sizeof(u32));            /* IFLA_CAN_T=
DCF_MAX */
> > > +
> > > +     if (priv->tdc.tdco) {
> >
> > Naively I'd say, iff the device has tdc_const give the user space the
> > tdc parameters, regardless if some value is 0 or not.
> >
> > What do you think?
>=20
> I thought about that.
> The first important remark is that if tdc.tdco is zero, then TDC
> is off (c.f. documentation of struct can_tdc::tdco).
>=20
> Let me illustrate my vision through examples.

[...]

examples makes sense \o/

[...]

> Finally, I have one side comment. It seems to me that you did not
> understand that the intent of
> |     if (priv->tdc.tdco)
> was to actually check whether TDC was on or off. In other words, my
> code was unclear.
>=20
> I am now thinking to introduce an helper macro:
> static bool can_tdc_is_enabled(const struct can_priv *priv)
> |{
> |    return !!priv->tdc.tdco;
> |}
>=20
> The code would look more clear like that.
> -     if (priv->tdc.tdco) {
> +     if (can_tdc_is_enabled(priv) {

Sounds good, I'm squashing this patch:

| diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
| index 6134bbf69c10..d48be574eae7 100644
| --- a/drivers/net/can/dev/netlink.c
| +++ b/drivers/net/can/dev/netlink.c
| @@ -311,7 +311,7 @@ static size_t can_tdc_get_size(const struct net_devic=
e *dev)
|         size +=3D nla_total_size(sizeof(u32));            /* IFLA_CAN_TDC=
O_MAX */
|         size +=3D nla_total_size(sizeof(u32));            /* IFLA_CAN_TDC=
F_MAX */
| =20
| -       if (priv->tdc.tdco) {
| +       if (can_tdc_is_enabled(priv)) {
|                 size +=3D nla_total_size(sizeof(u32));    /* IFLA_CAN_TDC=
V */
|                 size +=3D nla_total_size(sizeof(u32));    /* IFLA_CAN_TDC=
O */
|                 size +=3D nla_total_size(sizeof(u32));    /* IFLA_CAN_TDC=
F */
| @@ -352,6 +352,7 @@ static size_t can_get_size(const struct net_device *d=
ev)
|                                        priv->data_bitrate_const_cnt);
|         size +=3D sizeof(priv->bitrate_max);                      /* IFLA=
_CAN_BITRATE_MAX */
|         size +=3D can_tdc_get_size(dev);                          /* IFLA=
_CAN_TDC */
| +
|         return size;
|  }
| =20
| @@ -374,7 +375,7 @@ static int can_tdc_fill_info(struct sk_buff *skb, con=
st struct net_device *dev)
|             nla_put_u32(skb, IFLA_CAN_TDC_TDCF_MAX, tdc_const->tdcf_max))
|                 goto err_cancel;
| =20
| -       if (priv->tdc.tdco)
| +       if (can_tdc_is_enabled(priv)) {
|                 if (nla_put_u32(skb, IFLA_CAN_TDC_TDCV, tdc->tdcv) ||
|                     nla_put_u32(skb, IFLA_CAN_TDC_TDCO, tdc->tdco) ||
|                     nla_put_u32(skb, IFLA_CAN_TDC_TDCF, tdc->tdcf))
| diff --git a/include/linux/can/bittiming.h b/include/linux/can/bittiming.h
| index 9de6e9053e34..b6d1db1e7258 100644
| --- a/include/linux/can/bittiming.h
| +++ b/include/linux/can/bittiming.h
| @@ -83,6 +83,11 @@ struct can_tdc_const {
|         u32 tdcf_max;
|  };
| =20
| +static inline bool can_tdc_is_enabled(const struct can_priv *priv)
| +{
| +       return !!priv->tdc.tdco;
| +}
| +
|  #ifdef CONFIG_CAN_CALC_BITTIMING
|  int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
|                        const struct can_bittiming_const *btc);

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--keephfcgqr6o5xe3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDKCs8ACgkQqclaivrt
76lt8gf/TtOfBy0Tjh1hzJDVPQBUQMDVSq0ldxwA12Uyn1toEwckuaG4fC9r3z2W
MFVqo5LRkdZwtTNArXMbE4qz3c0ei8TsTLb7ruyOSp5ell/rI0i7yT+ekJRXjcnD
lBN8UjSpN4vXDz+NcVkPOpCqq6FuqfI3FQ6qc5+/lIHf9jhsGZGhCYPdZZ12wVL9
i3Iv/N9eelMVPlyBy2+fQvklcz0q6LqKBhoyCALKo+B9lwAcFJVLTlf339CIJSZ0
fJLjJV2k9w+sjrlmAhOx9zu42wBbSuOTH6Px8RqtZc7jXOOzWqIBicxSpub/Eywi
liAdLNFt54PEkrpFc1apLQjd/wvK6A==
=8Wb0
-----END PGP SIGNATURE-----

--keephfcgqr6o5xe3--
