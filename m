Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8601C21715
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 12:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbfEQKkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 06:40:46 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57253 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727689AbfEQKkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 06:40:45 -0400
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mkl@pengutronix.de>)
        id 1hRaI1-00042b-DG; Fri, 17 May 2019 12:40:37 +0200
Received: from [IPv6:2003:c7:711:c6f5:3de8:d0f0:b5f9:2a7d] (unknown [IPv6:2003:c7:711:c6f5:3de8:d0f0:b5f9:2a7d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 8893140EB44;
        Fri, 17 May 2019 10:40:33 +0000 (UTC)
Subject: Re: [PATCH] can: gw: Fix error path of cgw_module_init
To:     YueHaibing <yuehaibing@huawei.com>, davem@davemloft.net,
        socketcan@hartkopp.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-can@vger.kernel.org
References: <20190516155435.42376-1-yuehaibing@huawei.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Openpgp: preference=signencrypt
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Message-ID: <80ca1430-da86-42c3-75c7-eadf91b20220@pengutronix.de>
Date:   Fri, 17 May 2019 12:40:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190516155435.42376-1-yuehaibing@huawei.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="cPuBWzThF7gPhGlulF8GCMJHLe8C2T2Qq"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cPuBWzThF7gPhGlulF8GCMJHLe8C2T2Qq
Content-Type: multipart/mixed; boundary="7HyhubOsnI1bfLTM2ueTvbWhCyzvAY2W1";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: YueHaibing <yuehaibing@huawei.com>, davem@davemloft.net,
 socketcan@hartkopp.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 linux-can@vger.kernel.org
Message-ID: <80ca1430-da86-42c3-75c7-eadf91b20220@pengutronix.de>
Subject: Re: [PATCH] can: gw: Fix error path of cgw_module_init
References: <20190516155435.42376-1-yuehaibing@huawei.com>
In-Reply-To: <20190516155435.42376-1-yuehaibing@huawei.com>

--7HyhubOsnI1bfLTM2ueTvbWhCyzvAY2W1
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

On 5/16/19 5:54 PM, YueHaibing wrote:
> This patch fix error path for cgw_module_init
> to avoid possible crash if some error occurs.
>=20
> Fixes: c1aabdf379bc ("can-gw: add netlink based CAN routing")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  net/can/gw.c | 46 +++++++++++++++++++++++++++++++---------------
>  1 file changed, 31 insertions(+), 15 deletions(-)
>=20
> diff --git a/net/can/gw.c b/net/can/gw.c
> index 53859346..8b53ec7 100644
> --- a/net/can/gw.c
> +++ b/net/can/gw.c
> @@ -1046,32 +1046,48 @@ static __init int cgw_module_init(void)
>  	pr_info("can: netlink gateway (rev " CAN_GW_VERSION ") max_hops=3D%d\=
n",
>  		max_hops);
> =20
> -	register_pernet_subsys(&cangw_pernet_ops);
> +	ret =3D register_pernet_subsys(&cangw_pernet_ops);
> +	if (ret)
> +		return ret;
> +
> +	ret =3D -ENOMEM;
>  	cgw_cache =3D kmem_cache_create("can_gw", sizeof(struct cgw_job),
>  				      0, 0, NULL);
> -
>  	if (!cgw_cache)
> -		return -ENOMEM;
> +		goto out_cache_create;
> =20
>  	/* set notifier */
>  	notifier.notifier_call =3D cgw_notifier;
> -	register_netdevice_notifier(&notifier);
> +	ret =3D register_netdevice_notifier(&notifier);
> +	if (ret)
> +		goto out_register_notifier;
> =20
>  	ret =3D rtnl_register_module(THIS_MODULE, PF_CAN, RTM_GETROUTE,
>  				   NULL, cgw_dump_jobs, 0);
> -	if (ret) {
> -		unregister_netdevice_notifier(&notifier);
> -		kmem_cache_destroy(cgw_cache);
> -		return -ENOBUFS;
> -	}
> -
> -	/* Only the first call to rtnl_register_module can fail */
> -	rtnl_register_module(THIS_MODULE, PF_CAN, RTM_NEWROUTE,
> -			     cgw_create_job, NULL, 0);
> -	rtnl_register_module(THIS_MODULE, PF_CAN, RTM_DELROUTE,
> -			     cgw_remove_job, NULL, 0);
> +	if (ret)
> +		goto out_rtnl_register1;
> +
> +	ret =3D rtnl_register_module(THIS_MODULE, PF_CAN, RTM_NEWROUTE,
> +				   cgw_create_job, NULL, 0);
> +	if (ret)
> +		goto out_rtnl_register2;
> +	ret =3D rtnl_register_module(THIS_MODULE, PF_CAN, RTM_DELROUTE,
> +				   cgw_remove_job, NULL, 0);
> +	if (ret)
> +		goto out_rtnl_register2;
> =20
>  	return 0;
> +
> +out_rtnl_register2:
> +	rtnl_unregister_all(PF_CAN);

Currently gw.c is the only user of rtnl_register_module(PF_CAN), but
PF_CAN is not specific to gw. Better change this to individual
rtnl_unregister(int protocol, int msgtype).

> +out_rtnl_register1:
> +	unregister_netdevice_notifier(&notifier);
> +out_register_notifier:
> +	kmem_cache_destroy(cgw_cache);
> +out_cache_create:
> +	unregister_pernet_subsys(&cangw_pernet_ops);
> +
> +	return ret;
>  }
> =20
>  static __exit void cgw_module_exit(void)
>=20

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--7HyhubOsnI1bfLTM2ueTvbWhCyzvAY2W1--

--cPuBWzThF7gPhGlulF8GCMJHLe8C2T2Qq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEmvEkXzgOfc881GuFWsYho5HknSAFAlzej5wACgkQWsYho5Hk
nSDWnQgAiSTwIP05LGuj4vDQprzUDrSIm12iNB+pwMUbKo12heT6NLYMjcMlqwDl
LsYodfTBT4jqKsT4EwmVr9voAa78VbUyCPrCyovs1uVj8zehSqoh1m0unR26tNEh
N/7rhJUByPi9E0z00xFUsmlLzcybJmX2sEccbf0djNkP3No2Xfl3C5sEpmfIEl9W
M/+RedUAx7eTKh+Tv4Czp7Lma3DLGV43c2CoTmzXCB4E5oJUiw36zRk29hYKUmUP
NszCTwJfFpHFJg9AepFHWUFOeG3razNSm9b39kl3xQ+CahpdHV8cNAG4AyrmROTl
rB8jHWIb5gbi5Gk3W8msD4cKIMNtdQ==
=l9WC
-----END PGP SIGNATURE-----

--cPuBWzThF7gPhGlulF8GCMJHLe8C2T2Qq--
