Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42DE1280B4F
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 01:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733222AbgJAXYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 19:24:20 -0400
Received: from mail-eopbgr20069.outbound.protection.outlook.com ([40.107.2.69]:45829
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733131AbgJAXYH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 19:24:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BuPMe4PFl4n+KUMlZJ5sU3JgMFi/68BYlfDE6NLla+lvPrXwLm9IEhtq2hJ9cLvN/FvyoNo+b43pRnQ8WbEDgEprCUOiDaGTaa5bJzIvmF0/ke+nBbnNFjr+qmRZwglGnYUHRde0MIb2VnLtZZuBX6rFYvPFE+Izb63nC5X1nGcAR5CY2gxkbFfgsAEW6pOyKCvQQPmri3van+iswFDOox0HpqnFI/ilu4rR/wIpPIAgevRCTaUJfinwZK2SXgldv88hxsXJQd1hFTSvPMGeu/L+ubWq/oNSEktTjUsVvk1kSiN7Sovo2YOGt5At5h4dHdKQpQnUhh5fzTVO9aOoaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V1ebMx4s7YebbA52AzL57r93KG3mc01eixc9/U+BO38=;
 b=eUkToF9bYgY6gm61LJphCb1MlwyX7LoFPSpiQIBiz7wua3lNwvBXnDbBl3NAy4+fqdTahD8AQaBCESfRpwWameXHjgnXEw1qtxbdiumKVZ48hTOrjAB61Kdqz07608FYkoE3VhOVGgp5F9tlbIRUeT2PMYpEdIabfWdcdUqeDakKqfvD7h1as6R8O1p/TVFa9MtKlXH1d78amn2hU7IjCgGaFeoj/7ab4uVGtDI2iYvtCadIm7WwSaxGevmoBmU1uYCqBXUN9IH58DFNT8pb5D8A7yis12WYzKb8ZTMsW2naoQClnDIBW8KCE31DVi5ePjy8A7d7VbBQ6px1t2ARKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V1ebMx4s7YebbA52AzL57r93KG3mc01eixc9/U+BO38=;
 b=mfrS3MrDkPuYIU4GCWlfhd1z4XFbl9Tzg/mcCDVPkq83XDhipeoU4eLUxlIFsx0EbjKw0KW206KwXmkdQH+OB5DQBgjdUAWRDdTkUusqkTtSqlSBfrTsTwiovbrUdOy914Rm6nGihKXdbhtKz+XCV5Lx/cCDkk+c0AnnuuT+C6A=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Thu, 1 Oct
 2020 23:24:03 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Thu, 1 Oct 2020
 23:24:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: dsa: Support bridge 802.1Q while
 untagging
Thread-Topic: [PATCH net-next v2] net: dsa: Support bridge 802.1Q while
 untagging
Thread-Index: AQHWl5/dhVmGK5kbOEm6gGxCRTuWC6mDZKQA
Date:   Thu, 1 Oct 2020 23:24:03 +0000
Message-ID: <20201001232402.77gglnqqfsq6l4fj@skbuf>
References: <20201001030623.343535-1-f.fainelli@gmail.com>
In-Reply-To: <20201001030623.343535-1-f.fainelli@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3ad90ef9-a603-4d13-9f79-08d8666115a8
x-ms-traffictypediagnostic: VE1PR04MB6637:
x-microsoft-antispam-prvs: <VE1PR04MB6637561FD6BCC18BDB47B99DE0300@VE1PR04MB6637.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0lcD18x/q884wBBK0Lj4+pcNUBve9HFGKpj5pP3qsEdKZBMI0zWMdcx7WlvqTTBOqzEnbZ2jFeIYjPBq7axB36S4BBWgBFYZlooajj2qOjjCE88jNxFtUVOovPLqJf8OS0wPdCaB74u2iemJ32uI3FSU+aNVPP5lEY+Ut1wCL3rGHX9fb/V5bX5aFyERVgG8UHPbquBddHNqb3HN7QWksG8crpM5bBdEeifDor6/EvKLUNZ569gY9ktjZOCfs6ECQsH5ncD4yl4PVCcSoQF5SbuIt3TVEf2ovbSP7dxyvI5UjxoIKLkyQosoVMcChulJpUeSp1mOymjCUoymYu9tistW4+sXnfk/wVqM9v6o66oW5NbMUX9mYL3huYq7ew92
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(346002)(136003)(376002)(39850400004)(396003)(1076003)(64756008)(6916009)(478600001)(66446008)(66476007)(66556008)(86362001)(76116006)(6486002)(91956017)(71200400001)(66946007)(316002)(54906003)(83380400001)(9686003)(2906002)(186003)(44832011)(26005)(4326008)(6512007)(5660300002)(33716001)(8676002)(8936002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: qVQkitMSj49erlHMopFbr/j55zBryqeM5toU394iC9nqdwXWSv8LOUNUT24J/eDOVplpfF6srfUkineg+DLpIeb8aPWbMKpsaanCBp1HBpVLsMCuuyF/pH7LI+A4Pe+jHK7fMS5DR9Ff1caF8RP4UNguIBkvoCsXZUlMskvRVz2MwJqea1i4xHZIZnFI/65O0Ulx4jJ401muagwzPZHY+FChRnGmgsAeC008Iym6k+COM99JexuijNQQ9zqcgiGdqR8bOUYakN31rXwQAB1OjV6Ai2hd5lZKAW5gyiLM7f2BceDtX5iHttkNxAc/E3c1RmCwzOK9DemKgWtiHs9w/Qmuvfiu7yN5wbcaotlg1v1EMwH4ekDkmnmL1FinFwpSNo/yrsiCGvBt9tIdjz1Xk/LMES4TKyez8YUq3hyZjJ7y0fDh9W8nuUMFmwhll4wQfAZPiEzAuRROKm10ZyKqmY1ZTwd5Ch33nE370kCa/nESvcOtbIEyY6EqSuW2j7GLCihBurGVefIhCoo3JgHnGEWoqpttdQ2lqWGcwnY0WeWZjjOOa4JNoGCL8gg70mwElS+AnbwoB6pkNMIFN5FCmg5WBCR9Gw0Dtcq0bntGGSaUxIUdWlp7F/CvRhJPJRmp327uafLCUQdnRi6PMH2EBA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <07584C9264B66945A9167E9434F5AD2D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ad90ef9-a603-4d13-9f79-08d8666115a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2020 23:24:03.2359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eMS8Q7HnNG6okMpvHkZhON2mhZnlJWkiIHK7dHfKiNNR9vJ6E6dXCsXPn65uSwDE2h/JwbQ73tKzYGy+S5Y4pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 08:06:23PM -0700, Florian Fainelli wrote:
> The intent of 412a1526d067 ("net: dsa: untag the bridge pvid from rx
> skbs") is to transparently untag the bridge's default_pvid when the
> Ethernet switch can only support egress tagged of that default_pvid
> towards the CPU port.
>=20
> Prior to this commit, users would have to configure an 802.1Q upper on
> the bridge master device when the bridge is configured with
> vlan_filtering=3D0 in order to pop the VLAN tag:
>=20
> ip link add name br0 type bridge vlan_filtering 0
> ip link add link br0 name br0.1 type vlan id 1
>=20
> After this commit we added support for managing a switch port 802.1Q
> upper but those are not usually added as bridge members, and if they do,
> they do not actually require any special management, the data path would
> pop the desired VLAN tag accordingly.
>=20
> What we want to preserve is that use case and to manage when the user
> creates that 802.1Q upper for the bridge port.
>=20
> While we are it, call __vlan_find_dev_deep_rcu() which makes use the
> VLAN group array which is faster.
>=20
> As soon as we return the VLAN tagged SKB though it will be used by the
> following call path:
>=20
> netif_receive_skb_list_internal
>   -> __netif_receive_skb_list_core
>     -> __netif_receive_skb_core
>       -> vlan_do_receive()
>=20
> which uses skb->vlan_proto, if we do not set it to the appropriate VLAN
> protocol, we will leave it set to what the DSA master has set
> (ETH_P_XDSA).
>=20

The explanation is super confusing, although I think the placement of
the "skb->vlan_proto =3D vlan_dev_vlan_proto(upper_dev)" is correct.
Here's what I think is going on. It has to do with what's upwards of the
code you're changing:

	/* Move VLAN tag from data to hwaccel */
	if (!skb_vlan_tag_present(skb) && hdr->h_vlan_proto =3D=3D htons(proto)) {
		skb =3D skb_vlan_untag(skb);
		if (!skb)
			return NULL;
	}

So skb->vlan_proto should already be equal to the protocol of the 8021q
upper, see the call path below.

                           this is the problem
                                   |
skb_vlan_untag()                   v
  -> __vlan_hwaccel_put_tag(skb, skb->protocol, vlan_tci);
    -> skb->vlan_proto =3D vlan_proto;

But the problem is that skb_vlan_untag() calls __vlan_hwaccel_put_tag
with the wrong vlan_proto, it calls it with the skb->protocol which is
still ETH_P_XDSA because we haven't re-run eth_type_trans() yet.
It looks like this function wants pretty badly to be called after
eth_type_trans(), and it's getting pretty messy because of that, but we
don't have any other driver-specific hook afterwards..

I don't have a lot of experience, the alternatives are either to:
- move dsa_untag_bridge_pvid() after eth_type_trans(), similar to what
  you did in your initial patch - maybe this is the cleanest
- make dsa_untag_bridge_pvid() call eth_type_trans() and this gets rid
  of the extra step you need to do in tag_brcm.c
- document this very well

> Fixes: 412a1526d067 ("net: dsa: untag the bridge pvid from rx skbs")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> Changes in v2:
>=20
> - removed unused list_head iter argument
>=20
>  net/dsa/dsa_priv.h | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>=20
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index 0348dbab4131..b4aafb2e90fa 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -205,7 +205,6 @@ static inline struct sk_buff *dsa_untag_bridge_pvid(s=
truct sk_buff *skb)
>  	struct net_device *br =3D dp->bridge_dev;
>  	struct net_device *dev =3D skb->dev;
>  	struct net_device *upper_dev;
> -	struct list_head *iter;
>  	u16 vid, pvid, proto;
>  	int err;
> =20
> @@ -247,12 +246,10 @@ static inline struct sk_buff *dsa_untag_bridge_pvid=
(struct sk_buff *skb)
>  	 * supports because vlan_filtering is 0. In that case, we should
>  	 * definitely keep the tag, to make sure it keeps working.
>  	 */
> -	netdev_for_each_upper_dev_rcu(dev, upper_dev, iter) {
> -		if (!is_vlan_dev(upper_dev))
> -			continue;
> -
> -		if (vid =3D=3D vlan_dev_vlan_id(upper_dev))
> -			return skb;
> +	upper_dev =3D __vlan_find_dev_deep_rcu(br, htons(proto), vid);
> +	if (upper_dev) {
> +		skb->vlan_proto =3D vlan_dev_vlan_proto(upper_dev);
> +		return skb;
>  	}
> =20
>  	__vlan_hwaccel_clear_tag(skb);
> --=20
> 2.25.1
> =
