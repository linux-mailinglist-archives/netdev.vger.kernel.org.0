Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C90753A967B
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 11:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbhFPJsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 05:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbhFPJsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 05:48:45 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C72C061574
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 02:46:39 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ltS83-0007Ch-S3; Wed, 16 Jun 2021 11:46:35 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:27:4a54:dbae:b593])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 4ADB263D01E;
        Wed, 16 Jun 2021 09:46:34 +0000 (UTC)
Date:   Wed, 16 Jun 2021 11:46:33 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH v2 2/2] can: netlink: add interface for CAN-FD
 Transmitter Delay Compensation (TDC)
Message-ID: <20210616094633.fwg6rsyxyvm2zc6d@pengutronix.de>
References: <20210603151550.140727-1-mailhol.vincent@wanadoo.fr>
 <20210603151550.140727-3-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="z3ft7oxhu7toexlx"
Content-Disposition: inline
In-Reply-To: <20210603151550.140727-3-mailhol.vincent@wanadoo.fr>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--z3ft7oxhu7toexlx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04.06.2021 00:15:50, Vincent Mailhol wrote:
[...]

> +static size_t can_tdc_get_size(const struct net_device *dev)
> +{
> +	struct can_priv *priv =3D netdev_priv(dev);
> +	size_t size;
> +
> +	if (!priv->tdc_const)
> +		return 0;
> +
> +	size =3D nla_total_size(0);			/* nest IFLA_CAN_TDC */
> +	size +=3D nla_total_size(sizeof(u32));		/* IFLA_CAN_TDCV_MAX */
> +	size +=3D nla_total_size(sizeof(u32));		/* IFLA_CAN_TDCO_MAX */
> +	size +=3D nla_total_size(sizeof(u32));		/* IFLA_CAN_TDCF_MAX */
> +
> +	if (priv->tdc.tdco) {

Naively I'd say, iff the device has tdc_const give the user space the
tdc parameters, regardless if some value is 0 or not.

What do you think?

Marc
--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--z3ft7oxhu7toexlx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmDJyHYACgkQqclaivrt
76lNngf/S0HVNuyUJm2+Aooh1rzOnUEieq36RoeSYqtT3jrt+LTP1S6Wii8w2IPU
GSXUv8Kzu7SN0D26DLptrwJYj6VN6kV67iSIeQ4mvTPUUheqY2izjvWgfy2kmScc
f19PdkHYwE2QJbqAsR04He2L7K4gQoBMd24mxHeRHygrh07In/Jj/D0eB19wyCFD
Vd9obvdcboCBKcPhDjiekZq3dcsWbvFdZ0HpfHJaLoku9NeGgZ9JWwGrF1UgSqB5
ykZdVR7fGNaYBt/K96jAloiiRXHb8JVgZWrIpCPZv7HMsp9/IOWT60BZ4vf7Wj2X
ZkqVUwnkxb9NjMoO4lPlwcMV5UwpiA==
=6ogY
-----END PGP SIGNATURE-----

--z3ft7oxhu7toexlx--
