Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57E24280F16
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 10:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387662AbgJBIkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 04:40:42 -0400
Received: from mail-eopbgr130040.outbound.protection.outlook.com ([40.107.13.40]:20422
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725961AbgJBIkl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 04:40:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e4rN5spbVvbvnGwVoePn6EM03DlsSoiFgWrdACJttxQcoJ5SuEvNWBiy5YTEeWrwjpU5i4r2yYyl+cB5ktpUF1H2OhnwBSwWc1/JC+t1ygyLBOPzKZeYbrJ8yTEiIzGnkBjmxcMXIS0UL0W3tWUxTvXerUM2QeQs34BmRPXbbwZFGpMK2M5UzX0cqY1f/szO2mk2bj/VUgJb3hx0LeTly1P/VLukTddr0kFZzNfZgf/jQzPWYpa1OzWp0nnuKj07NcaBfcAEiZ1QNH7+oMH6EfIejJa+kBphAME7YrezUaE1UsqbefLpkRWCmA+RgRU+aIS3zqyWcNbRTFLV7GykTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CL0E0TygsDl5GhW4p6tJ5RIHq/xbb0HyK1kFna5dDZ4=;
 b=F2pK2WypzqNeWrE6OiCk0HlsJ7unAfFqz3UZuwhwIFUGDlsz+GLcObGHiUznXwEK4a5ubKnYjgW8zWWtut83DP4YXkcAqzww+SmDOx8M1WjiBxt8O+NmwjZjHsdqWoWWOgbooLCwfolx68Bk2SBlELvSU48JLrOa2P6emqWCnzLk1mm7IM0dCqZOqq2Xbqpt+rd+l9Yz2ViHqu9BejKPGpJ6IyTuo3PVTfz3C2Yu8aH3a3FvxwpZ28bnwQYJy7ixv1k568sgiQK7b0HwXRCGNwEux6mfMrBPAcVBnhf8dRwQrrPKhA+FmfCNs1D5jYNWqNUp+D6cm+nW/MbQcXAjzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CL0E0TygsDl5GhW4p6tJ5RIHq/xbb0HyK1kFna5dDZ4=;
 b=hL69wpjPY3DUPNN/UNDnIYno6fA8wGD6cha2wtU5BZX+CvuUmCRUHy8VzEn28c6EJJZy8ec9FFKtEs+il0FxYkwnYzKI0+6iXnn4CTf8dPIgMdckjhFFODkac0LfOGFUDoMyuYmavaxk4UQpDvRsH3VAf31jpkSMUvKnrhT+aKA=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (20.178.127.205) by
 VI1PR0402MB3615.eurprd04.prod.outlook.com (52.134.4.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.32; Fri, 2 Oct 2020 08:40:35 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.038; Fri, 2 Oct 2020
 08:40:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "olteanv@gmail.com" <olteanv@gmail.com>
Subject: Re: [PATCH net-next 2/4] net: dsa: b53: Set untag_bridge_pvid
Thread-Topic: [PATCH net-next 2/4] net: dsa: b53: Set untag_bridge_pvid
Thread-Index: AQHWmGWxYmDACdGIjU6cTFofEHbQtqmD/piA
Date:   Fri, 2 Oct 2020 08:40:35 +0000
Message-ID: <20201002084035.zrqge6qy43xhce7a@skbuf>
References: <20201002024215.660240-1-f.fainelli@gmail.com>
 <20201002024215.660240-3-f.fainelli@gmail.com>
In-Reply-To: <20201002024215.660240-3-f.fainelli@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6a606fbb-5476-43c8-0f81-08d866aed51b
x-ms-traffictypediagnostic: VI1PR0402MB3615:
x-microsoft-antispam-prvs: <VI1PR0402MB361548CF8BA06657A50D31C4E0310@VI1PR0402MB3615.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OlFbcyex4kumLb0L0ZtgyysnRN3mYzSXyg+MZf8Gg5arYi88UEJe3RlDa8sT3m4nnFDYTboSrvVxkqXPc3A35LgNxf7WQpzfiAHigV24cmy6sXtcgNNp1A6CE3lc8110W3jCszgjPDVko7q9YMe9qAaUHN3CyAUN8XGvTHrK5WCn/dt78pJK9frcISrz9keAtt2TW/Op0dr3/wsvIUyYlN67qCH1nmQkdK/bLtcs5/8tqPWg1RErqhKhYtV+0n2Neuabms/dv99ylGg544HRNwnnVWdzo9j23/TAreoJiFjTtnAYsxSUMGaYHl4JopbQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(346002)(376002)(136003)(366004)(39860400002)(6512007)(86362001)(6486002)(6916009)(66946007)(64756008)(8936002)(66556008)(66446008)(66476007)(5660300002)(316002)(8676002)(9686003)(83380400001)(44832011)(186003)(54906003)(26005)(33716001)(4326008)(2906002)(76116006)(478600001)(1076003)(6506007)(71200400001)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: utJkqGT+t/0OHPy/l4shewZ5XbKBhX4ye99xkf1fOms+pthkMtBxzMSkRyh8hzFSPLiK1df00rgt6NxRJZcrPqPzlqbSZdIetlv153Z+PUOEAPCL+2/s9++fpLYj3DCfrnrwChmoh3TFYo48wY/03P8DIBw5yiqyqRUGGJloBWGL8B8uNU+2b+f5XecRmFfPx8n5FbtJi+YRJbfLfq/4JO3escJDbomRdRMLchwwgkqe69rPRY1k1WImHmyG+oR7fuQmkmtQyNWL0Nd4j4bCQFjbCV3DB5vrpqmvMp0CqDPvJkzWx5IrqMlH5CvHSbdBtNzLaSEG77X7hXad1tA4OV9/gvegIkD9neSkFSN0nhpMNAfxxazzZ26IP+qvGB6NAbQIZ+kfMGurjz3XzhsNvDbFzgm7Nbauo5JAh5wGpDA/lCMxWG7ZQodsdymjmU9SwpeCGJkXKiJ34AD0HfK83y8hxN7FvYuAQWlpfObjRBs/be0qe/llWevoOuVDP8C2+Sf0nbmW/IffT8cIPmyMlKXCSISHRoe1JYWqag0dPoSFiIAjp9trFgrY4UA4NKhkm49MOApUzXnN362RuOa3a/oe0V+V4TImOXOb87H6s/xt7Yv1MMYqt84aYJELLzMGuRqkVtXbBHfI5WjwvDnLvw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BA7204E3DE08724F9FB192AD767726AF@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a606fbb-5476-43c8-0f81-08d866aed51b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2020 08:40:35.7159
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8s7DNDKNyXKywN9g9swa5VQkz4zfOt4TPB44ISoa4UJdA3PpyEFYLEqGVMQZez7N+4tANs47LLaBsaL4NOcu0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3615
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 01, 2020 at 07:42:13PM -0700, Florian Fainelli wrote:
> Indicate to the DSA receive path that we need to untage the bridge PVID,
> this allows us to remove the dsa_untag_bridge_pvid() calls from
> net/dsa/tag_brcm.c.
>=20
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  drivers/net/dsa/b53/b53_common.c |  1 +
>  net/dsa/tag_brcm.c               | 15 ++-------------
>  2 files changed, 3 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_c=
ommon.c
> index 73507cff3bc4..ce18ba0b74eb 100644
> --- a/drivers/net/dsa/b53/b53_common.c
> +++ b/drivers/net/dsa/b53/b53_common.c
> @@ -2603,6 +2603,7 @@ struct b53_device *b53_switch_alloc(struct device *=
base,
>  	dev->ops =3D ops;
>  	ds->ops =3D &b53_switch_ops;
>  	ds->configure_vlan_while_not_filtering =3D true;
> +	ds->untag_bridge_pvid =3D true;
>  	dev->vlan_enabled =3D ds->configure_vlan_while_not_filtering;
>  	mutex_init(&dev->reg_mutex);
>  	mutex_init(&dev->stats_mutex);
> diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
> index 69d6b8c597a9..ad72dff8d524 100644
> --- a/net/dsa/tag_brcm.c
> +++ b/net/dsa/tag_brcm.c
> @@ -152,11 +152,6 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buf=
f *skb,
>  	/* Remove Broadcom tag and update checksum */
>  	skb_pull_rcsum(skb, BRCM_TAG_LEN);
> =20
> -	/* Set the MAC header to where it should point for
> -	 * dsa_untag_bridge_pvid() to parse the correct VLAN header.
> -	 */
> -	skb_set_mac_header(skb, -ETH_HLEN);
> -
>  	skb->offload_fwd_mark =3D 1;
> =20
>  	return skb;
> @@ -187,7 +182,7 @@ static struct sk_buff *brcm_tag_rcv(struct sk_buff *s=
kb, struct net_device *dev,
>  		nskb->data - ETH_HLEN - BRCM_TAG_LEN,
>  		2 * ETH_ALEN);
> =20
> -	return dsa_untag_bridge_pvid(nskb);
> +	return nskb;
>  }
> =20
>  static const struct dsa_device_ops brcm_netdev_ops =3D {
> @@ -214,14 +209,8 @@ static struct sk_buff *brcm_tag_rcv_prepend(struct s=
k_buff *skb,
>  					    struct net_device *dev,
>  					    struct packet_type *pt)
>  {
> -	struct sk_buff *nskb;
> -
>  	/* tag is prepended to the packet */
> -	nskb =3D brcm_tag_rcv_ll(skb, dev, pt, ETH_HLEN);
> -	if (!nskb)
> -		return nskb;
> -
> -	return dsa_untag_bridge_pvid(nskb);
> +	return brcm_tag_rcv_ll(skb, dev, pt, ETH_HLEN);
>  }
> =20
>  static const struct dsa_device_ops brcm_prepend_netdev_ops =3D {
> --=20
> 2.25.1
> =
