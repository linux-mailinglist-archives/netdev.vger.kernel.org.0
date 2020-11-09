Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340342ABE0C
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 15:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731351AbgKIOAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 09:00:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:43816 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730072AbgKIOAE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 09:00:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B53A0AD4F;
        Mon,  9 Nov 2020 14:00:02 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 3F7BD60344; Mon,  9 Nov 2020 15:00:02 +0100 (CET)
Date:   Mon, 9 Nov 2020 15:00:02 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] ethtool: netlink: add missing
 netdev_features_change() call
Message-ID: <20201109140002.g45cbbroshyjotdh@lion.mk-sys.cz>
References: <ahA2YWXYICz5rbUSQqNG4roJ8OlJzzYQX7PTiG80@cp4-web-028.plabs.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kabiacxtqtoc2zqu"
Content-Disposition: inline
In-Reply-To: <ahA2YWXYICz5rbUSQqNG4roJ8OlJzzYQX7PTiG80@cp4-web-028.plabs.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--kabiacxtqtoc2zqu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 08, 2020 at 12:46:15AM +0000, Alexander Lobakin wrote:
> After updating userspace Ethtool from 5.7 to 5.9, I noticed that
> NETDEV_FEAT_CHANGE is no more raised when changing netdev features
> through Ethtool.
> That's because the old Ethtool ioctl interface always calls
> netdev_features_change() at the end of user request processing to
> inform the kernel that our netdevice has some features changed, but
> the new Netlink interface does not. Instead, it just notifies itself
> with ETHTOOL_MSG_FEATURES_NTF.
> Replace this ethtool_notify() call with netdev_features_change(), so
> the kernel will be aware of any features changes, just like in case
> with the ioctl interface. This does not omit Ethtool notifications,
> as Ethtool itself listens to NETDEV_FEAT_CHANGE and drops
> ETHTOOL_MSG_FEATURES_NTF on it
> (net/ethtool/netlink.c:ethnl_netdev_event()).
>=20
> From v1 [1]:
> - dropped extra new line as advised by Jakub;
> - no functional changes.
>=20
> [1] https://lore.kernel.org/netdev/AlZXQ2o5uuTVHCfNGOiGgJ8vJ3KgO5YIWAnQjH=
0cDE@cp3-web-009.plabs.ch
>=20
> Fixes: 0980bfcd6954 ("ethtool: set netdev features with FEATURES_SET requ=
est")
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

> ---
>  net/ethtool/features.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/ethtool/features.c b/net/ethtool/features.c
> index 8ee4cdbd6b82..1c9f4df273bd 100644
> --- a/net/ethtool/features.c
> +++ b/net/ethtool/features.c
> @@ -280,7 +280,7 @@ int ethnl_set_features(struct sk_buff *skb, struct ge=
nl_info *info)
>  					  active_diff_mask, compact);
>  	}
>  	if (mod)
> -		ethtool_notify(dev, ETHTOOL_MSG_FEATURES_NTF, NULL);
> +		netdev_features_change(dev);
> =20
>  out_rtnl:
>  	rtnl_unlock();
> --=20
> 2.29.2
>=20
>=20

--kabiacxtqtoc2zqu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl+pS1sACgkQ538sG/LR
dpVc/wgAhPzbYoT4cIBpAgOork4F228kOK5CTAXW39iq0ms5xYC44R3ThegOMlpc
e+OZxcL8BsALZ8WN/fOA29tEIAFKPuAVSPH6EdsddYtP7Rc90DCrBBB3kl7XpK7j
ZcE5TbDf+KPbFaeJWxjya4ERA7tzzSgO+0dblfNLW6b7P8RERmtkpauGv+/tvrs6
3oz0/OnX8Uli+nX2sLttl/QLMKywYbLFSNBbA5MffjXR5MOOh/G79uMLmblu5L9Z
VU8HfQDlJSuZAJW1++DgPWaqHCoNVqWD1LzEfNfQ1Bw9UowgvCK2cbbYiYE+FUyr
3pLBXPm4qp3p95006yWKzRj7HpfLhw==
=zqEO
-----END PGP SIGNATURE-----

--kabiacxtqtoc2zqu--
