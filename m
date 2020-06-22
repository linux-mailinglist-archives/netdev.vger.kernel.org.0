Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A172204357
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 00:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730944AbgFVWKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 18:10:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:60250 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730701AbgFVWKX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 18:10:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B0F63AF3B;
        Mon, 22 Jun 2020 22:10:20 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id DBA5F6048B; Tue, 23 Jun 2020 00:10:20 +0200 (CEST)
Date:   Tue, 23 Jun 2020 00:10:20 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@mellanox.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Aya Levin <ayal@mellanox.com>,
        Tom Herbert <therbert@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 3/3] net: ethtool: sync netdev_features_strings order
 with enum netdev_features
Message-ID: <20200622221020.budxdjdoxwvqd42q@lion.mk-sys.cz>
References: <x6AQUs_HEHFh9N-5HYIEIDvv9krP6Fg6OgEuqUBC6jHmWwaeXSkyLVi05uelpCPAZXlXKlJqbJk8ox3xkIs33KVna41w5es0wJlc-cQhb8g=@pm.me>
 <sqZrzUWnFxtxVcoxsWQF4Nv8G9fd9g61ZQV90btG1FJpZVRU1lf2Wa6pX4XBQq1fkkUxaotZDm9Bb0z01hODC2HEhShi_GOVWqLE7pDSr8w=@pm.me>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="k22oqm7alg25phu7"
Content-Disposition: inline
In-Reply-To: <sqZrzUWnFxtxVcoxsWQF4Nv8G9fd9g61ZQV90btG1FJpZVRU1lf2Wa6pX4XBQq1fkkUxaotZDm9Bb0z01hODC2HEhShi_GOVWqLE7pDSr8w=@pm.me>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--k22oqm7alg25phu7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 19, 2020 at 06:39:59PM +0000, Alexander Lobakin wrote:
> The ordering of netdev_features_strings[] makes no sense when it comes
> to user interaction, as list of features in `ethtool -k` input is sorted
> according to the corresponding bit's position.
> Instead, it *does* make sense when it comes to adding new netdev_features
> or modifying existing ones. We have at least 2 occasions of forgetting to
> add the strings for newly introduced features, and one of them existed
> since 3.1x times till now.
>=20
> Let's keep this stringtable sorted according to bit's position in enum
> netdev_features, as this simplifies both reading and modification of the
> source code and can help not to miss or forget anything.
>=20
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

This would also rather belong to net-next, IMHO.

Michal

> ---
>  net/ethtool/common.c | 26 ++++++++++++++++++++------
>  1 file changed, 20 insertions(+), 6 deletions(-)
>=20
> diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> index c8e3fce6e48d..24f35d47832d 100644
> --- a/net/ethtool/common.c
> +++ b/net/ethtool/common.c
> @@ -8,25 +8,25 @@
>  const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN=
] =3D {
>  	[NETIF_F_SG_BIT]			=3D "tx-scatter-gather",
>  	[NETIF_F_IP_CSUM_BIT]			=3D "tx-checksum-ipv4",
> +
> +	/* __UNUSED_NETIF_F_1 - deprecated */
> +
>  	[NETIF_F_HW_CSUM_BIT]			=3D "tx-checksum-ip-generic",
>  	[NETIF_F_IPV6_CSUM_BIT]			=3D "tx-checksum-ipv6",
>  	[NETIF_F_HIGHDMA_BIT]			=3D "highdma",
>  	[NETIF_F_FRAGLIST_BIT]			=3D "tx-scatter-gather-fraglist",
>  	[NETIF_F_HW_VLAN_CTAG_TX_BIT]		=3D "tx-vlan-hw-insert",
> -
>  	[NETIF_F_HW_VLAN_CTAG_RX_BIT]		=3D "rx-vlan-hw-parse",
>  	[NETIF_F_HW_VLAN_CTAG_FILTER_BIT]	=3D "rx-vlan-filter",
> -	[NETIF_F_HW_VLAN_STAG_TX_BIT]		=3D "tx-vlan-stag-hw-insert",
> -	[NETIF_F_HW_VLAN_STAG_RX_BIT]		=3D "rx-vlan-stag-hw-parse",
> -	[NETIF_F_HW_VLAN_STAG_FILTER_BIT]	=3D "rx-vlan-stag-filter",
>  	[NETIF_F_VLAN_CHALLENGED_BIT]		=3D "vlan-challenged",
>  	[NETIF_F_GSO_BIT]			=3D "tx-generic-segmentation",
>  	[NETIF_F_LLTX_BIT]			=3D "tx-lockless",
>  	[NETIF_F_NETNS_LOCAL_BIT]		=3D "netns-local",
>  	[NETIF_F_GRO_BIT]			=3D "rx-gro",
> -	[NETIF_F_GRO_HW_BIT]			=3D "rx-gro-hw",
>  	[NETIF_F_LRO_BIT]			=3D "rx-lro",
> =20
> +	/* NETIF_F_GSO_SHIFT =3D NETIF_F_TSO_BIT */
> +
>  	[NETIF_F_TSO_BIT]			=3D "tx-tcp-segmentation",
>  	[NETIF_F_GSO_ROBUST_BIT]		=3D "tx-gso-robust",
>  	[NETIF_F_TSO_ECN_BIT]			=3D "tx-tcp-ecn-segmentation",
> @@ -43,9 +43,14 @@ const char netdev_features_strings[NETDEV_FEATURE_COUN=
T][ETH_GSTRING_LEN] =3D {
>  	[NETIF_F_GSO_TUNNEL_REMCSUM_BIT]	=3D "tx-tunnel-remcsum-segmentation",
>  	[NETIF_F_GSO_SCTP_BIT]			=3D "tx-sctp-segmentation",
>  	[NETIF_F_GSO_ESP_BIT]			=3D "tx-esp-segmentation",
> +
> +	/* NETIF_F_GSO_UDP_BIT - deprecated */
> +
>  	[NETIF_F_GSO_UDP_L4_BIT]		=3D "tx-udp-segmentation",
>  	[NETIF_F_GSO_FRAGLIST_BIT]		=3D "tx-gso-list",
> =20
> +	/* NETIF_F_GSO_LAST =3D NETIF_F_GSO_FRAGLIST_BIT */
> +
>  	[NETIF_F_FCOE_CRC_BIT]			=3D "tx-checksum-fcoe-crc",
>  	[NETIF_F_SCTP_CRC_BIT]			=3D "tx-checksum-sctp",
>  	[NETIF_F_FCOE_MTU_BIT]			=3D "fcoe-mtu",
> @@ -56,16 +61,25 @@ const char netdev_features_strings[NETDEV_FEATURE_COU=
NT][ETH_GSTRING_LEN] =3D {
>  	[NETIF_F_LOOPBACK_BIT]			=3D "loopback",
>  	[NETIF_F_RXFCS_BIT]			=3D "rx-fcs",
>  	[NETIF_F_RXALL_BIT]			=3D "rx-all",
> +	[NETIF_F_HW_VLAN_STAG_TX_BIT]		=3D "tx-vlan-stag-hw-insert",
> +	[NETIF_F_HW_VLAN_STAG_RX_BIT]		=3D "rx-vlan-stag-hw-parse",
> +	[NETIF_F_HW_VLAN_STAG_FILTER_BIT]	=3D "rx-vlan-stag-filter",
>  	[NETIF_F_HW_L2FW_DOFFLOAD_BIT]		=3D "l2-fwd-offload",
> +
>  	[NETIF_F_HW_TC_BIT]			=3D "hw-tc-offload",
>  	[NETIF_F_HW_ESP_BIT]			=3D "esp-hw-offload",
>  	[NETIF_F_HW_ESP_TX_CSUM_BIT]		=3D "esp-tx-csum-hw-offload",
>  	[NETIF_F_RX_UDP_TUNNEL_PORT_BIT]	=3D "rx-udp_tunnel-port-offload",
> -	[NETIF_F_HW_TLS_RECORD_BIT]		=3D "tls-hw-record",
>  	[NETIF_F_HW_TLS_TX_BIT]			=3D "tls-hw-tx-offload",
>  	[NETIF_F_HW_TLS_RX_BIT]			=3D "tls-hw-rx-offload",
> +
> +	[NETIF_F_GRO_HW_BIT]			=3D "rx-gro-hw",
> +	[NETIF_F_HW_TLS_RECORD_BIT]		=3D "tls-hw-record",
>  	[NETIF_F_GRO_FRAGLIST_BIT]		=3D "rx-gro-list",
> +
>  	[NETIF_F_HW_MACSEC_BIT]			=3D "macsec-hw-offload",
> +
> +	/* NETDEV_FEATURE_COUNT */
>  };
> =20
>  const char
> --=20
> 2.27.0
>=20
>=20

--k22oqm7alg25phu7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAl7xLEwACgkQ538sG/LR
dpUxfwf/Xe5uaU5cXmjHYAdIMaBuDYvteuYA1VACpIBJW+om8itcBhBzKmEuQbc6
81cU96EFBvETTQ4NMgLcumRaMFLY3urdeQKD1L9TcIn8j1yX/SUaGaQzupNBsz/c
cyyQD9xZ3PPiqVmlZCfqRm6dzM28M8F4KmbS2f1Y8tts2TmUerI3MrE9v/5IZ96F
8uwgVJ2EnRuXAddyjvvGwPouYWLpPLKmRpYwwC2/lygL3NhICKRP3H2w9sD515Nb
UadnTAsTOlsAeZuK52IkjoH4Y5JSbeQUBGWnyLpOWFspAlj/Q1AxljFTnqnMrplS
7kaDp/NwueSiBfRAZgIJxFBzZfoYng==
=ajHp
-----END PGP SIGNATURE-----

--k22oqm7alg25phu7--
