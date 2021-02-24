Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951A23234D6
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 02:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234356AbhBXBFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 20:05:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:55340 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232242AbhBXAzJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 19:55:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BC823AE05;
        Wed, 24 Feb 2021 00:32:51 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 49E6760795; Wed, 24 Feb 2021 01:32:51 +0100 (CET)
Date:   Wed, 24 Feb 2021 01:32:51 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: Re: [PATCH net] ethtool: fix the check logic of at least one channel
 for RX/TX
Message-ID: <20210224003251.6lwgj2k73jt3edk5@lion.mk-sys.cz>
References: <20210223132440.810-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="r7d7rchzanybcpds"
Content-Disposition: inline
In-Reply-To: <20210223132440.810-1-simon.horman@netronome.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--r7d7rchzanybcpds
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 23, 2021 at 02:24:40PM +0100, Simon Horman wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
>=20
> The command "ethtool -L <intf> combined 0" may clean the RX/TX channel
> count and skip the error path, since the attrs
> tb[ETHTOOL_A_CHANNELS_RX_COUNT] and tb[ETHTOOL_A_CHANNELS_TX_COUNT]
> are NULL in this case when recent ethtool is used.
>=20
> Tested using ethtool v5.10.
>=20
> Fixes: 7be92514b99c ("ethtool: check if there is at least one channel for=
 TX/RX in the core")
> Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@netronome.com>
> Signed-off-by: Louis Peens <louis.peens@netronome.com>

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

> ---
>  net/ethtool/channels.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
> index 25a9e566ef5c..e35ef627f61f 100644
> --- a/net/ethtool/channels.c
> +++ b/net/ethtool/channels.c
> @@ -175,14 +175,14 @@ int ethnl_set_channels(struct sk_buff *skb, struct =
genl_info *info)
> =20
>  	/* ensure there is at least one RX and one TX channel */
>  	if (!channels.combined_count && !channels.rx_count)
> -		err_attr =3D tb[ETHTOOL_A_CHANNELS_RX_COUNT];
> +		err_attr =3D mod_combined ? tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT] :
> +					  tb[ETHTOOL_A_CHANNELS_RX_COUNT];
>  	else if (!channels.combined_count && !channels.tx_count)
> -		err_attr =3D tb[ETHTOOL_A_CHANNELS_TX_COUNT];
> +		err_attr =3D mod_combined ? tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT] :
> +					  tb[ETHTOOL_A_CHANNELS_TX_COUNT];
>  	else
>  		err_attr =3D NULL;
>  	if (err_attr) {
> -		if (mod_combined)
> -			err_attr =3D tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT];
>  		ret =3D -EINVAL;
>  		NL_SET_ERR_MSG_ATTR(info->extack, err_attr, "requested channel counts =
would result in no RX or TX channel being configured");
>  		goto out_ops;
> --=20
> 2.20.1
>=20

--r7d7rchzanybcpds
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmA1nqwACgkQ538sG/LR
dpXYfwf+NCJA19mRbKY6IJHk7xX1I0mDj3Fa/OZpX1UEVonYAJ6BBEPxCQx7vQbL
M8gtle2U6LCNQInxEX3NGccGaJ3h8C3h0Kn3OtQ/q0Xh3aRkNsM1WEWr4TW1ZZj2
KBadVB3A/mWPw4unvwXKxbR1QFtKqIwBrZhhxfDGfoaIP+v88k26f1G+50wa6fUs
GgyZ2ka2bc7zMdJ1kyQ2eONA4eFgt8oA3R2bV1SL4ApbSASoGm4fAb0EIOY0mbG2
GVsAdfQG+P+8sGOgSZ706g/h0Bep+RXtZLJtHATOhi/RAsKu20tE3moEUn0XdG7U
y/MH50COmixa/8bbhUS1hgx3X81Weg==
=qET7
-----END PGP SIGNATURE-----

--r7d7rchzanybcpds--
