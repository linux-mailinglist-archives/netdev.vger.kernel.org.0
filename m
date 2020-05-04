Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6AF1C3508
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgEDI4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727951AbgEDI4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:56:02 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2B0C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 01:56:02 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jVWtL-0005qz-OJ; Mon, 04 May 2020 10:55:59 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jVWtI-0006jc-S6; Mon, 04 May 2020 10:55:56 +0200
Date:   Mon, 4 May 2020 10:55:56 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        mkl@pengutronix.de, kernel@pengutronix.de,
        David Jander <david@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>,
        Christian Herber <christian.herber@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v5 1/2] ethtool: provide UAPI for PHY master/slave
 configuration.
Message-ID: <20200504085556.rzkvn47q2k5iqyap@pengutronix.de>
References: <20200504071214.5890-1-o.rempel@pengutronix.de>
 <20200504071214.5890-2-o.rempel@pengutronix.de>
 <20200504080417.i3d2jsjjpu2zjk4z@pengutronix.de>
 <20200504083734.GA5989@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bksnti5tacwemepx"
Content-Disposition: inline
In-Reply-To: <20200504083734.GA5989@lion.mk-sys.cz>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:53:13 up 171 days, 11 min, 184 users,  load average: 0.04, 0.07,
 0.08
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bksnti5tacwemepx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 04, 2020 at 10:37:34AM +0200, Michal Kubecek wrote:
> On Mon, May 04, 2020 at 10:04:17AM +0200, Oleksij Rempel wrote:
> > @Michal,
> >=20
> > i noticed that linkmodes_fill_reply() some times get not enough
> > tailroom.
> > if data->peer_empty =3D=3D 0
> > linkmodes_reply_size() size: 476
> > linkmodes_fill_reply() skb tailroom: 724
> >=20
> >=20
> > if data->peer_empty =3D=3D 1
> > linkmodes_reply_size() size: 216                                     =
=20
> > linkmodes_fill_reply() skb tailroom: 212
> >=20
> > In the last case i won't be able to attach master_lave state and cfg
> > fields.
> >=20
> > It looks like this issue was not introduced by my patches. May be you
> > have idea, what is missing?
>=20
> It's my mistake, I'm just not sure why I never ran into this while
> testing. Please try the patch below.

thx! it works now:
[   82.754019] linkmodes_reply_size:103 size: 216
[   82.758523] linkmodes_fill_reply:117 skb tailroom: 724

[  126.781892] linkmodes_reply_size:103 size: 476
[  126.786464] linkmodes_fill_reply:117 skb tailroom: 724


> Michal
>=20
> diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
> index 0c772318c023..ed5357210193 100644
> --- a/net/ethtool/netlink.c
> +++ b/net/ethtool/netlink.c
> @@ -342,7 +342,7 @@ static int ethnl_default_doit(struct sk_buff *skb, st=
ruct genl_info *info)
>  	ret =3D ops->reply_size(req_info, reply_data);
>  	if (ret < 0)
>  		goto err_cleanup;
> -	reply_len =3D ret;
> +	reply_len =3D ret + ethnl_reply_header_size();
>  	ret =3D -ENOMEM;
>  	rskb =3D ethnl_reply_init(reply_len, req_info->dev, ops->reply_cmd,
>  				ops->hdr_attr, info, &reply_payload);
> @@ -588,7 +588,7 @@ static void ethnl_default_notify(struct net_device *d=
ev, unsigned int cmd,
>  	ret =3D ops->reply_size(req_info, reply_data);
>  	if (ret < 0)
>  		goto err_cleanup;
> -	reply_len =3D ret;
> +	reply_len =3D ret + ethnl_reply_header_size();
>  	ret =3D -ENOMEM;
>  	skb =3D genlmsg_new(reply_len, GFP_KERNEL);
>  	if (!skb)
> diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
> index 95eae5c68a52..0eed4e4909ab 100644
> --- a/net/ethtool/strset.c
> +++ b/net/ethtool/strset.c
> @@ -324,7 +324,6 @@ static int strset_reply_size(const struct ethnl_req_i=
nfo *req_base,
>  	int len =3D 0;
>  	int ret;
> =20
> -	len +=3D ethnl_reply_header_size();
>  	for (i =3D 0; i < ETH_SS_COUNT; i++) {
>  		const struct strset_info *set_info =3D &data->sets[i];
> =20
>=20
>=20

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--bksnti5tacwemepx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl6v2JMACgkQ4omh9DUa
UbMzAQ/+NPU9rgdcXp+gU0iaEdIsUV67ifbNwyxojASyy3YBRTQQ8EZ60UpvGWUK
bRFDESEvMqEbweePhladfsBbFlCfmAmkOkUB3O6R8J3faIsgNZQlxVy6gBSHnbQA
H/FI66ZHk6cbZUWkHq5cn/n9ItuijxodjYj84MTjSPj0HDGv9Jo5NyXjz6A3Ymt6
es58+fJJRt4wrKLqrtx4AbhRRNun4ZRbXR9cA3qzbd24e3/MqV4+zpI8+YIk/xx+
FRTOqACrT5+83HLvSXDvryBomC3GuICab0anfLbjsjbxCv798oS+J6R5EgX/Thnq
O/nsIRwAb0BeKQFb+ys5BjGStFAEjvCrFBiRfnzHilDS8mc9lN8ON3mZ6OBnLZpv
jJAz/U3+gp23YJFNAPZhVsdBl1T2zSCRSv38mUW+lKDINxuwywmyzaNBGnZ1z92H
yk8myyK0V6Kpd+o3JEuDAAVS9pGbh8OpBzWHcMc8+g/x4DkegdqaKnRdsq71WIs1
B4qRfLSipyKlDrB8lRToCsy3UIZnCgwkhySXk+yf5S8fQQp8phvSaQZmgzUB5AnP
Bf0dtQVZ48xgs8aO1QwvCpQiXfFMJHVaFDZNqQc+/ZF4LYA7t5IZH01pGma/MGz6
rE1kAQf6Ior2iw5vOL6v5HRMDxlfTG57BsGFFDA/yeKYffqtJuA=
=BdJy
-----END PGP SIGNATURE-----

--bksnti5tacwemepx--
