Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9BE276305
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 23:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgIWVXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 17:23:45 -0400
Received: from mail-eopbgr60059.outbound.protection.outlook.com ([40.107.6.59]:65353
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726199AbgIWVXp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 17:23:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eolX0AHI/eQ1qJaydoX48osH6jifz6nxiFF2lEMlUtfIIHx4QnTlRYSRvqQLOWHDJqGIjFYmFjd6bB6e+ZIC+8yjXtpA1Dwu7lhD0Ijn7YiOrDDVHfeEZA4YY++5tRXJ6xLb6spfss5W9lxnaFBrhaeMDSoWO4KTPJ/U62JG2+wC0SBiwM/2MQLCiPv6Q7cdjFW79SEVHSG4BlhcdvonIj7NYUMcl7iZW+zPctqnt0eouSyzyQ60eow6qIK9DXgQVLeJjQwK3llMHOupusO0682B6P0vlD1T9YX8QMCb2d+Wi7G+yoPsEQ8cZ5l40SFD8BIgVw9mlv2wvPFOWNGRYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCcEmIVwVzgN10v/ifrCCjO8BfiZvasxo1emO/7t7I4=;
 b=Vs6swsQQE9oqT2GNHktWssuPKAred8rIEJTtdB7NAoHTTWZVqO/Bu6V0xfYR8tnOMf4F20UBBKgafftaiQZv7em82nBeTnZuxFBis6zVJnORbUIEr69ypjZpVhUH7wtEqOpa+mtnz0kwZ5m9bcKpvavYIdkH9XEaM7P5OuS3SraGy8myPFKfQO5BKIVDZzPjk5zdlofIVsh7oRo/Xpg4aNQNXLyW1PMdcLRpzDQ6Jm5KH9sGRpFpV+6eyA/3qMasa0Hr/Zc5Ilich8xgldY9V0/paKH1hkmMN3hEJRE17dhCZfPCd+L8S+v15Pou6a76EOgLF36C94qGUuZiyCnGTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCcEmIVwVzgN10v/ifrCCjO8BfiZvasxo1emO/7t7I4=;
 b=LMKDntmVxin6rHpg0pKL0QNBtDuJ+in6FyRzPciSoPHd4u5ixNr7ZswB3KnKM3/O9X+Mlckvg+M6HpJLdlPgipsQafC9hMJAC5jnP7tnUEet8q+N1UfqQdKXLAXC5lSG19AyshOZjfnAdgr1sU14pZuHj2H/RRXKfOyKUrJEUcs=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6639.eurprd04.prod.outlook.com (2603:10a6:803:129::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Wed, 23 Sep
 2020 21:23:40 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.020; Wed, 23 Sep 2020
 21:23:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>
Subject: Re: [PATCH net-next v2 2/2] net: dsa: b53: Configure VLANs while not
 filtering
Thread-Topic: [PATCH net-next v2 2/2] net: dsa: b53: Configure VLANs while not
 filtering
Thread-Index: AQHWkep/dRHPASo30E+nWKzcj5j3Wal2u8aA
Date:   Wed, 23 Sep 2020 21:23:39 +0000
Message-ID: <20200923212339.v5cbpzwczyhoi4xs@skbuf>
References: <20200923204514.3663635-1-f.fainelli@gmail.com>
 <20200923204514.3663635-3-f.fainelli@gmail.com>
In-Reply-To: <20200923204514.3663635-3-f.fainelli@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1c3c77d5-cbb6-4448-6046-08d86006f0e3
x-ms-traffictypediagnostic: VE1PR04MB6639:
x-microsoft-antispam-prvs: <VE1PR04MB663949FA745F92F51598CE07E0380@VE1PR04MB6639.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +Ls+5SfJVWxkRd0gn5dP0Pet6cgg1HjS7lAD4zlByNtD7ZU4mjsNo2pUqrlYmmVCEra8hFsgsIPcSzWqsb7waLJP66wCUtY0PdS9W7z7mxj69Y8TWTePumgKxcLr3sXlkpH+XwLgu2tmz41TvUCMxsx6BRcdSgfciXwjP93PpPAabDkPKZqgha3ObIDQVmMyuRrU3r5hDKzZogdjtO2GAHdiOlnCGekxcWAJwz3SGJ0kE9ZFTRMSQIoZD4M9oMp6X4QlDnkfBrNqAH1HCVZV5IM7g7cFHkU747A719/I9/7znkQ61cnGVW1arF35oB5U
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(6512007)(6916009)(9686003)(6506007)(44832011)(33716001)(8676002)(4326008)(8936002)(6486002)(66556008)(478600001)(66446008)(186003)(86362001)(1076003)(76116006)(71200400001)(316002)(91956017)(66946007)(5660300002)(83380400001)(2906002)(54906003)(66476007)(26005)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: cLIbZdKsAQKuk+Aknxkl39N70ALUZalqrpxfMbjjwLvaZh+D9tTpTzQZ/hZdFYQcJvhkHCegL8YJb0g7WJ96kvLMHcCEnDuzUplRnyPTntq5eY/u0hNXJ/7iCQnISuzXc+YUIuDmiL9tG5c6d9inUVLJge1S17Niue+qiiAmqV8wH38sr9mGiTGtVTRTGG6OoNNJIYLKk6tp/cUtKZvDdjfiGf89NoQir7Mabbd8vHrSqRWPO0as3+yFFOOak1PYVk1Q4e3IwEnRuWcQG9pRPwXC+q2K0EDByENQxbQgBopm490xhpobSTALGDH6rm4TX3ogHVY9uTXr0LREudvTyzrWAUveWV1gSWSLMlR/HphNzQWhgjkXxGo4uN/sYpC1pIEVHJpjSuE2/ci7TNFSeZecTmAoLLkDiDFZXcYJGKvpGhnboo8kzzlF4XaImlEVKZGNvq/G5LsEntLMJaTxqJ7aM4alznlRpSc8ISGow6vXLRqtp7PeXyrhO8Oa9Xpthv6Ut6nCwX9YOkFuBtZrwvhJRsGuungzv9Hw1hXHHy9oXLmP6i/GJAC2ukO9ZP5ALUMRkobtuW+ysIUQiIy0ki1zutZGb0ZIw2TlRNbN5sCMiUgevKTrHy2YPQgVDbGZFatl0Dp4qU1Lh4HYj1Ue1Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <615F13CFA70C10478C7D913A8ED6C867@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c3c77d5-cbb6-4448-6046-08d86006f0e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 21:23:39.9968
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zj9hTwA6xBZBnC9HYHeg0+pr3Qf+N3AWncaASUBDkRLy3nJglzbExko8rSZaGpM3woBPrFXC0iNHwFCJmj7eIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6639
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 01:45:14PM -0700, Florian Fainelli wrote:
> Update the B53 driver to support VLANs while not filtering. This
> requires us to enable VLAN globally within the switch upon driver
> initial configuration (dev->vlan_enabled).
>=20
> We also need to remove the code that dealt with PVID re-configuration in
> b53_vlan_filtering() since that function worked under the assumption
> that it would only be called to make a bridge VLAN filtering, or not
> filtering, and we would attempt to move the port's PVID accordingly.
>=20
> Now that VLANs are programmed all the time, even in the case of a
> non-VLAN filtering bridge, we would be programming a default_pvid for
> the bridged switch ports.
>=20
> We need the DSA receive path to pop the VLAN tag if it is the bridge's
> default_pvid because the CPU port is always programmed tagged in the
> programmed VLANs. In order to do so we utilize the
> dsa_untag_bridge_pvid() helper introduced in the commit before by
> setting ds->untag_bridge_pvid to true.
>=20
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  drivers/net/dsa/b53/b53_common.c | 19 ++-----------------
>  drivers/net/dsa/b53/b53_priv.h   |  1 -
>  net/dsa/tag_brcm.c               | 16 ++++++++++++++--
>  3 files changed, 16 insertions(+), 20 deletions(-)
>=20
> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_c=
ommon.c
> index 6a5796c32721..73507cff3bc4 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c
> @@ -1377,23 +1377,6 @@ EXPORT_SYMBOL(b53_phylink_mac_link_up);
>  int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filter=
ing)
>  {
>  	struct b53_device *dev =3D ds->priv;
> -	u16 pvid, new_pvid;
> -
> -	b53_read16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port), &pvid);
> -	if (!vlan_filtering) {
> -		/* Filtering is currently enabled, use the default PVID since
> -		 * the bridge does not expect tagging anymore
> -		 */
> -		dev->ports[port].pvid =3D pvid;
> -		new_pvid =3D b53_default_pvid(dev);
> -	} else {
> -		/* Filtering is currently disabled, restore the previous PVID */
> -		new_pvid =3D dev->ports[port].pvid;
> -	}
> -
> -	if (pvid !=3D new_pvid)
> -		b53_write16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port),
> -			    new_pvid);
> =20
>  	b53_enable_vlan(dev, dev->vlan_enabled, vlan_filtering);
> =20
> @@ -2619,6 +2602,8 @@ struct b53_device *b53_switch_alloc(struct device *=
base,
>  	dev->priv =3D priv;
>  	dev->ops =3D ops;
>  	ds->ops =3D &b53_switch_ops;
> +	ds->configure_vlan_while_not_filtering =3D true;
> +	dev->vlan_enabled =3D ds->configure_vlan_while_not_filtering;
>  	mutex_init(&dev->reg_mutex);
>  	mutex_init(&dev->stats_mutex);
> =20
> diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_pri=
v.h
> index c55c0a9f1b47..24893b592216 100644
> --- a/drivers/net/dsa/b53/b53_priv.h
> +++ b/drivers/net/dsa/b53/b53_priv.h
> @@ -91,7 +91,6 @@ enum {
>  struct b53_port {
>  	u16		vlan_ctl_mask;
>  	struct ethtool_eee eee;
> -	u16		pvid;
>  };
> =20
>  struct b53_vlan {
> diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
> index cc8512b5f9e2..703770161738 100644
> --- a/net/dsa/tag_brcm.c
> +++ b/net/dsa/tag_brcm.c
> @@ -7,6 +7,7 @@
> =20
>  #include <linux/etherdevice.h>
>  #include <linux/list.h>
> +#include <linux/if_vlan.h>
>  #include <linux/slab.h>
> =20
>  #include "dsa_priv.h"
> @@ -140,6 +141,11 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buf=
f *skb,
>  	/* Remove Broadcom tag and update checksum */
>  	skb_pull_rcsum(skb, BRCM_TAG_LEN);
> =20
> +	/* Set the MAC header to where it should point for
> +	 * dsa_untag_bridge_pvid() to parse the correct VLAN header.
> +	 */
> +	skb_set_mac_header(skb, -ETH_HLEN);
> +
>  	skb->offload_fwd_mark =3D 1;
> =20
>  	return skb;
> @@ -191,7 +197,7 @@ static struct sk_buff *brcm_tag_rcv(struct sk_buff *s=
kb, struct net_device *dev,
>  		nskb->data - ETH_HLEN - BRCM_TAG_LEN,
>  		2 * ETH_ALEN);
> =20
> -	return nskb;
> +	return dsa_untag_bridge_pvid(nskb);
>  }
> =20
>  static const struct dsa_device_ops brcm_netdev_ops =3D {
> @@ -219,8 +225,14 @@ static struct sk_buff *brcm_tag_rcv_prepend(struct s=
k_buff *skb,
>  					    struct net_device *dev,
>  					    struct packet_type *pt)
>  {
> +	struct sk_buff *nskb;
> +
>  	/* tag is prepended to the packet */
> -	return brcm_tag_rcv_ll(skb, dev, pt, ETH_HLEN);
> +	nskb =3D brcm_tag_rcv_ll(skb, dev, pt, ETH_HLEN);
> +	if (!nskb)
> +		return nskb;
> +
> +	return dsa_untag_bridge_pvid(nskb);
>  }
> =20
>  static const struct dsa_device_ops brcm_prepend_netdev_ops =3D {
> --=20
> 2.25.1
> =
