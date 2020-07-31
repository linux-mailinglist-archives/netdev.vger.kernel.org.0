Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77330234DB3
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 00:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbgGaWnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 18:43:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:54720 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgGaWnp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 18:43:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C2701AB7D;
        Fri, 31 Jul 2020 22:43:56 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 63166604C2; Sat,  1 Aug 2020 00:43:42 +0200 (CEST)
Date:   Fri, 31 Jul 2020 15:54:56 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Gaurav Singh <gaurav1086@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        YueHaibing <yuehaibing@huawei.com>,
        Aya Levin <ayal@mellanox.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [net/ethtool] ethnl_set_linkmodes: remove redundant null
 check
Message-ID: <20200731135456.gbzznq6x2f5pznx6@carpenter.suse.cz>
References: <20200731045908.32466-1-gaurav1086@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ltnqnoysjs5z4x72"
Content-Disposition: inline
In-Reply-To: <20200731045908.32466-1-gaurav1086@gmail.com>
Lines:  66
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ltnqnoysjs5z4x72
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 31, 2020 at 12:58:44AM -0400, Gaurav Singh wrote:
> info cannot be NULL here since its being accessed earlier
> in the function: nlmsg_parse(info->nlhdr...). Remove this
> redundant NULL check.

This is what the static checker tells you but it could still mean the
other place is missing the check. The actual reason why this check is
superfluous is that the function is only used as ->doit() handler which
is never called with null info.

> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>

The subject should rather start with "ethtool: " (instead of "[net/ethtool]=
 ").

For the change itself:

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

Michal

> ---
>  net/ethtool/linkmodes.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/net/ethtool/linkmodes.c b/net/ethtool/linkmodes.c
> index fd4f3e58c6f6..b595d87fa880 100644
> --- a/net/ethtool/linkmodes.c
> +++ b/net/ethtool/linkmodes.c
> @@ -406,8 +406,7 @@ int ethnl_set_linkmodes(struct sk_buff *skb, struct g=
enl_info *info)
> =20
>  	ret =3D __ethtool_get_link_ksettings(dev, &ksettings);
>  	if (ret < 0) {
> -		if (info)
> -			GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
> +		GENL_SET_ERR_MSG(info, "failed to retrieve link settings");
>  		goto out_ops;
>  	}
> =20
> --=20
> 2.17.1
>=20

--ltnqnoysjs5z4x72
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl8kIqYACgkQ538sG/LR
dpVuQwf/ZIW2LoV7UbsdkhDsyo2zBbjP+Ae033JR/gd0DPSYClAtBvdQIPAPKST1
5Tz2kJO1peojJcp0G3lr1EDvWzlxeCqkpq3JzN4823O1j/C2GBfRnbQx7fMO5Jj4
Ejujz+Pxkg/MVs7wgvUCuJswSuOKH9V756ClMo1BqeHwQj7vcEovdOxRQ3g+GPRc
fnKh+9DO38uWU2B0CSkrwGYeRE2K5toPj0Q2+chdNQGwJJONVUhpB9fxPNPvt3fk
A/rQrJFLv1VgNdVrw2DhV4/c1Ar9w6rlsKTDuRJg4AUUTfKjsUqW51DIZtgiMFA3
EA47sXhsxbjb/DCoFkj/101gby8VGQ==
=NBhY
-----END PGP SIGNATURE-----

--ltnqnoysjs5z4x72--

