Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83639280F26
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 10:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387596AbgJBImY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 04:42:24 -0400
Received: from mail-eopbgr60089.outbound.protection.outlook.com ([40.107.6.89]:16647
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726051AbgJBImX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 04:42:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JEhTW/+9Ol2jyDUSYooRBJ6bfmIOIxzPzdUelwgTDABTiRe53odzQrzWTJoHFxpXwfre6AUbd0PLBakoO0MyVreibEzcdyVHHNgyZnsXlK779xo11FM3bf+q1Ii0y/uMmGwkIzXw6tUKO6xMZC5soxujyYTK63lVCiGu1sDhiXs0CRMyUaskeextRPcZLJN54Dmz7nJBdccB+ZIsaTV5YH55gGPwY5tYqieFsV2MF2A5VksaKzPXWVjeIItQDjx+J/D+LiSWBT30sjukbrIjeMF2C2EVsF/f3Jsx9/WPuf6ETXg0eglcYORmPGEoKx8g1g7B1Tel1OpwEVFKVF2RVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oCpb9zxbViNHCTzFdgZEAvXztsA0U9M17LQEmKzpc7k=;
 b=hg5WTbS2zyOZgoNUj9XCgi6yb92jlIwspMDShlfx/WJuuCnSPot1a4RnzwH5zGnKBjF0mLYGlULjgIbNdIABPxLj6lK8UzRsm1u2R9NhO94hzGQI6HZ6YBm9fy0tuqL2Sk8LsGQFFQFQNNDjfqr2gShz9pP11IEGHiPF7EDYXDPkJL1dT/I3zfG8MVDLksRE11nc96PdD08vii3OoOLJMo1EAPMYxNjyvQTdvvGP0IN2DPf+ROxajWJNQKnQaXYk32O6iG8fu9wjl7T3VDUy+qLi1aa6/NBDgWcBcp2Kt+8S6PYgrCmTSs8dfb5r9+FPYxNeAYzYmJj06jZuPkjCdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oCpb9zxbViNHCTzFdgZEAvXztsA0U9M17LQEmKzpc7k=;
 b=Xn/yPKdMQtJdQARitm8zHhOp7CWpR8t47M9b4Z09SjTrdNLSmFrCy2q3lztipuF9+eJ45JiUffIzBDGSiq+iEcZqsKv9fBXO1MY9h+VxmDZ3vf/ixmNsjxOAqeb3WRZpakOqcE7SaslTY0FstP19Lv+uOqDiNkrm2ZG5sP654wo=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2800.eurprd04.prod.outlook.com (2603:10a6:800:b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37; Fri, 2 Oct
 2020 08:42:20 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.038; Fri, 2 Oct 2020
 08:42:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "olteanv@gmail.com" <olteanv@gmail.com>
Subject: Re: [PATCH net-next 4/4] net: dsa: Utilize __vlan_find_dev_deep_rcu()
Thread-Topic: [PATCH net-next 4/4] net: dsa: Utilize
 __vlan_find_dev_deep_rcu()
Thread-Index: AQHWmGW4wzwMq4u/PEuSLyFs6DyMXKmD/xSA
Date:   Fri, 2 Oct 2020 08:42:20 +0000
Message-ID: <20201002084219.w54cgkivclwzuy44@skbuf>
References: <20201002024215.660240-1-f.fainelli@gmail.com>
 <20201002024215.660240-5-f.fainelli@gmail.com>
In-Reply-To: <20201002024215.660240-5-f.fainelli@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fba67a77-770f-481b-23f1-08d866af1362
x-ms-traffictypediagnostic: VI1PR0402MB2800:
x-microsoft-antispam-prvs: <VI1PR0402MB2800DB752D791442A107A91EE0310@VI1PR0402MB2800.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fpU2+oHcG+wPId4AoXLBjcQzSuwSwO2WWmhyWuyGoVIWRsa9sRPLwyna9MfIE0Ty4kOJD0C2Qkblp3OOpnCfq+W1JhvIPh2t+8AoZJXVirslutKd7E5CvjeEO3fv1mh2BoGKJKlhH6KKl54gW6GKGnq0O7AeZ9CAYQJzZJ6ocYWa6kXA0o121f1qZpt/LJ7igyKLaECAcQmNfqD26JFio3cXCrf1UZ/74AakBdePvCK2kZoDxJPe/JbummqthfZ7In/S5EOmWir2bLGqRXUTgqyFoNVwFYtinAPrYKtGpYb23kTpPCSn2gm5BtsEZ/r4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(6512007)(6486002)(2906002)(33716001)(1076003)(9686003)(4326008)(66476007)(64756008)(66946007)(54906003)(5660300002)(86362001)(316002)(186003)(6916009)(83380400001)(26005)(66556008)(478600001)(44832011)(6506007)(66446008)(76116006)(8676002)(71200400001)(8936002)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: aoRpIoAL1IY76TiVF+9HXhP5QvIXVQA8CIJ3Dvoyhg5qm9mX0yWsAIsW+cF8l1uaM3JNuddSLYgoofNetMy/bQA+wVFUswCdEt4hPpvYolDCjFJ02hGGNASeENMcPvZsCGVveckeI7tANOsaf0IOdXTFdiUkQTaREeeScP9Y4WMEw8NXiXunrk8eiiDOZYwKRNC0FrXzQc0HgQBuEQeoWYxcwULHDOZGpQn7i9lOZtwJCwUXnOXfiCQjofyrFFZAuALNMF6PjUE9Gu0S3LyKCcbm3chXCauaFKwE8P7AGKzUIxWueiBYo0emX7imvNMMeQjE1alr8X8apDDI3SlicDOvfudiJSsub1DBTbUjB9+vm4QiQ2ub4BPDy6iCUIgD6U/Wk+wjhJ9QiR1EBvPmi6Cq7SSFRWihIv+vs/CrbPYurJecLeyA3if7kSQgilGvj73wpkWDQfabUhwpOwQ2JcwAJqnXm0P9vh+CTNHQbMSCQ6j7mZ++Tn90/Ge9FMOe4YpyhU9GvJvWk34V8YUaBMHxGjbIjkFr6vp6buOhFuSE2jLvBA3hD8XQIANOaKc04Fa4HffT+duI4hfoH5xfr5qiHsC4aWMVxWDurePkI4gJlXB5cQHRKRXs3g75udYCcoC+5aFJLVkCp6/CnlJqUQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <50818BC761B7E745A3FFF2716E1EF5A3@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fba67a77-770f-481b-23f1-08d866af1362
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2020 08:42:20.2094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kkAX6cHPSy0bQWnemeaW9wMsn4s4JVD7fLgwnd3GcLrkZeRkdT4uCUnt6fCVK9OAD1qwFFy0YWoNP5OsXbCK5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2800
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 01, 2020 at 07:42:15PM -0700, Florian Fainelli wrote:
> Now that we are guaranteed that dsa_untag_bridge_pvid() is called after
> eth_type_trans() we can utilize __vlan_find_dev_deep_rcu() which will
> take care of finding an 802.1Q upper on top of a bridge master.
>=20
> A common use case, prior to 12a1526d067 ("net: dsa: untag the bridge
> pvid from rx skbs") was to configure a bridge 802.1Q upper like this:
>=20
> ip link add name br0 type bridge vlan_filtering 0
> ip link add link br0 name br0.1 type vlan id 1
>=20
> in order to pop the default_pvid VLAN tag.
>=20
> With this change we restore that behavior while still allowing the DSA
> receive path to automatically pop the VLAN tag.
>=20
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  net/dsa/dsa_priv.h | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
>=20
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index d6ce8c2a2590..12998bf04e55 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -204,7 +204,6 @@ static inline struct sk_buff *dsa_untag_bridge_pvid(s=
truct sk_buff *skb)
>  	struct net_device *br =3D dp->bridge_dev;
>  	struct net_device *dev =3D skb->dev;
>  	struct net_device *upper_dev;
> -	struct list_head *iter;
>  	u16 vid, pvid, proto;
>  	int err;
> =20
> @@ -246,13 +245,9 @@ static inline struct sk_buff *dsa_untag_bridge_pvid(=
struct sk_buff *skb)
>  	 * supports because vlan_filtering is 0. In that case, we should
>  	 * definitely keep the tag, to make sure it keeps working.
>  	 */
> -	netdev_for_each_upper_dev_rcu(dev, upper_dev, iter) {
> -		if (!is_vlan_dev(upper_dev))
> -			continue;
> -
> -		if (vid =3D=3D vlan_dev_vlan_id(upper_dev))
> -			return skb;
> -	}
> +	upper_dev =3D __vlan_find_dev_deep_rcu(br, htons(proto), vid);
> +	if (upper_dev)
> +		return skb;
> =20
>  	__vlan_hwaccel_clear_tag(skb);
> =20
> --=20
> 2.25.1
> =
