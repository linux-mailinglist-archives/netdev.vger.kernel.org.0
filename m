Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E0CD3FAD4C
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 18:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235805AbhH2Q6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 12:58:21 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:57956 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235720AbhH2Q6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 12:58:20 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id AD4AA220CD;
        Sun, 29 Aug 2021 16:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1630256247; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rbpQS2hwxa54gSudWvQkVXmmBw/rHMcdIilb1NfBTYQ=;
        b=C1opHVYnaz0KHz7Bzr6PsZAu4bsH6lrVlSiM0H9cmHprB6BcDjZkTMvfrXjdLGJK1yG/GG
        05X7wTiPh/64gYxA12Gdm09SPEWE09nuGHYZojxFqaDA9sZ5CuSnkK30xI27ZSaJuCHcwX
        P8gZIUboGSi+j3hpyG4wyBAbbBfP6z8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1630256247;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rbpQS2hwxa54gSudWvQkVXmmBw/rHMcdIilb1NfBTYQ=;
        b=DLMGzTa+G5gHfVIr6khzPbwKCBGvMVCVWx2sMPuCwPRWcZYjt7FDq7KqZvxSNloALCjve0
        uaZbLkay/ixrBbBw==
Received: from lion.mk-sys.cz (unknown [10.163.29.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 15A89A3B9D;
        Sun, 29 Aug 2021 16:57:26 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id BAB7D603F7; Sun, 29 Aug 2021 18:57:25 +0200 (CEST)
Date:   Sun, 29 Aug 2021 18:57:25 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Yufeng Mo <moyufeng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, amitc@mellanox.com,
        idosch@idosch.org, andrew@lunn.ch, o.rempel@pengutronix.de,
        f.fainelli@gmail.com, jacob.e.keller@intel.com, mlxsw@mellanox.com,
        netdev@vger.kernel.org, lipeng321@huawei.com, linuxarm@huawei.com,
        linuxarm@openeuler.org
Subject: Re: [PATCH RESEND ethtool-next] netlink: settings: add netlink
 support for coalesce cqe mode parameter
Message-ID: <20210829165725.p7tbqwdeaugekb3v@lion.mk-sys.cz>
References: <1630044408-32819-1-git-send-email-moyufeng@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5t3rxzyjcd2vxh6v"
Content-Disposition: inline
In-Reply-To: <1630044408-32819-1-git-send-email-moyufeng@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5t3rxzyjcd2vxh6v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 27, 2021 at 02:06:48PM +0800, Yufeng Mo wrote:
> Add support for "ethtool -c <dev> cqe-mode-rx/cqe-mode-tx on/off"
> for setting coalesce cqe mode.
>=20
> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
> ---
>  ethtool.c          |  2 ++
>  netlink/coalesce.c | 15 +++++++++++++++
>  2 files changed, 17 insertions(+)

Please update also the man page (file ethtool.8.in) to show the new
parameters.

Michal

> diff --git a/ethtool.c b/ethtool.c
> index 2486caa..a6826e9 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -5703,6 +5703,8 @@ static const struct option args[] =3D {
>  			  "		[tx-usecs-high N]\n"
>  			  "		[tx-frames-high N]\n"
>  			  "		[sample-interval N]\n"
> +			  "		[cqe-mode-rx on|off]\n"
> +			  "		[cqe-mode-tx on|off]\n"
>  	},
>  	{
>  		.opts	=3D "-g|--show-ring",
> diff --git a/netlink/coalesce.c b/netlink/coalesce.c
> index 75922a9..762d0e3 100644
> --- a/netlink/coalesce.c
> +++ b/netlink/coalesce.c
> @@ -66,6 +66,9 @@ int coalesce_reply_cb(const struct nlmsghdr *nlhdr, voi=
d *data)
>  	show_u32(tb[ETHTOOL_A_COALESCE_TX_USECS_HIGH], "tx-usecs-high: ");
>  	show_u32(tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH], "tx-frame-high: ");
>  	putchar('\n');
> +	show_bool("rx", "CQE mode RX: %s  ",
> +		  tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX]);
> +	show_bool("tx", "TX: %s\n", tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX]);
> =20
>  	return MNL_CB_OK;
>  }
> @@ -226,6 +229,18 @@ static const struct param_parser scoalesce_params[] =
=3D {
>  		.handler	=3D nl_parse_direct_u32,
>  		.min_argc	=3D 1,
>  	},
> +	{
> +		.arg		=3D "cqe-mode-rx",
> +		.type		=3D ETHTOOL_A_COALESCE_USE_CQE_MODE_RX,
> +		.handler	=3D nl_parse_u8bool,
> +		.min_argc	=3D 1,
> +	},
> +	{
> +		.arg		=3D "cqe-mode-tx",
> +		.type		=3D ETHTOOL_A_COALESCE_USE_CQE_MODE_TX,
> +		.handler	=3D nl_parse_u8bool,
> +		.min_argc	=3D 1,
> +	},
>  	{}
>  };
> =20
> --=20
> 2.8.1
>=20

--5t3rxzyjcd2vxh6v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmErvG0ACgkQ538sG/LR
dpVycQgAjYMEhG8gkk7+DGg4cFTlfH44vG2/rU7+rsuR6QoeUikFRK+UpZpRaSln
dnIO8mfIoc8LfS8aqG+Bm8uC44QzKohT+wGG1nQOZ7GVbwJRECBgqipNMl4uJ3Px
1R84YF2lUvpo80ndI3WS/bbMmD4WqG72EYA0ctxWIzn4qCiM3NDwH2u2GB9jfXoU
mG4XRJUZXXd0vtxpyYeWJypu8C0Do+gAtZ4xnZ2fuL1/T6dK/F/19NUNmpalAfsW
735B5pOkh8e54beIDwQD0+Lx2gtj08FakIC7i21X7kdlNuHngr74L9Bp1jBH38sW
/L4G7K6fzqp50QjH0VLPK572xLxR1g==
=HQO3
-----END PGP SIGNATURE-----

--5t3rxzyjcd2vxh6v--
