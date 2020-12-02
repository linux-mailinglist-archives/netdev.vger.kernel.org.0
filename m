Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A8E2CBE16
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 14:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730033AbgLBNSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 08:18:37 -0500
Received: from mail-eopbgr130083.outbound.protection.outlook.com ([40.107.13.83]:62958
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727531AbgLBNSh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 08:18:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UvbZa1FEdn0VyXjGwyy/BSQCXjKq5LmJA8aF7bptWaxTIihvD5cNwyoEynXTj6vNE3GXttQ8ySX5EfHa4+/0Ox9a78NRIJnIZrrawFMq4CNAElxOMU7Ycg5LwLHnN4wH8AWmgGQy9DJj9BnS35Rcr12o/GkeSj+fzwvNtZ7vsgccYZaHLbdN/fUwPzxwuPTWtCNNa2sRlRzPr281d+mTME14hBkY+J9G1BpSmf99xOrIjA78Ze8kKIEZBJkaNAIA6v+aTz08r+7XNyzXxpUHH+Jvv/nCZ++/EvGQq/EBsDdp1f0eOVZLfspfAWdP3ICs2R/KFm2O6VhkI557oxoTMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0N1Jxji+R03GcCJ5FAyD27rGb6Y48oO9SyuJM/NtOw=;
 b=QEFwL9mcCP/0wTWNCjIg2b1RdkoEgxjEIc9FMm4SCmw0CkasOLLLs76z+WwOyMll1W+jUIk0ygQavU8wXLNaal1JCth8B7TNGLlX5eC0QePv/xYkyfV0ymmCKczdjOshblJawROYXBT+nWF8et1vd1t3QOYOOPAo/dczKV48vm+u/LU87rvXu8PJevlCBkwrE0RuLDs8S5CUwiL1Y62b717aUmF+bujqPfAVroM6xNZ1KWdDL8kupWPmbKxKycEuT/rbzK1up8rCkWo8hbSUhD5J4Uw7tLmB5hzhrvinXVNVC5ZQwXm6cbvgJvSZj7XB+5/7ghSwrQGYI1rCuDO20g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0N1Jxji+R03GcCJ5FAyD27rGb6Y48oO9SyuJM/NtOw=;
 b=XPDmMVvt1NwsMkyu606Nmr0oI8y91LYVxqKyKR4DKxuU0NXEFKV/LtNugRiQAC1xwndd2gpMLjEHHnv/YjYyPxm2jNfmJLWYShPgDV0aUzbbg0X40Zh0PQj1UO9zuTQMc2PTA/HJrc6EE0J7riV3miGQ2LaMYIv+EOlWxTEIgo0=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR04MB4111.eurprd04.prod.outlook.com (2603:10a6:803:48::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Wed, 2 Dec
 2020 13:17:47 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6%3]) with mapi id 15.20.3611.033; Wed, 2 Dec 2020
 13:17:47 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: RE: [PATCH] dpaa_eth: copy timestamp fields to new skb in A-050385
 workaround
Thread-Topic: [PATCH] dpaa_eth: copy timestamp fields to new skb in A-050385
 workaround
Thread-Index: AQHWx7Y075no7Yljkk6GvqWZOspnzKnjx44g
Date:   Wed, 2 Dec 2020 13:17:46 +0000
Message-ID: <VI1PR04MB5807833DEB5F5C25D19DFD18F2F30@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20201201075258.1875-1-yangbo.lu@nxp.com>
In-Reply-To: <20201201075258.1875-1-yangbo.lu@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.78.148.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7ee800ca-b6f5-4247-4d2f-08d896c4a953
x-ms-traffictypediagnostic: VI1PR04MB4111:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4111643D78FCDD4BF3746DC4F2F30@VI1PR04MB4111.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qb9tXrkVEan2lm1xzpmB7mBlhxLWlViFIe+IMXl1li6EVzV6eJT+5WQibPhcKimtJ0NtpyM1egBeBmMSip98xik9/A6XwYKnst5BVXVspdtGY60Zmiul5GFEK/A5eaWaFAAbd4GMbv2tmQFZIt5oxmnjgzH4H9gVC77daR2hJ1Pp0Fwl5qM9iZPUjgJ5WI9hXzGWyxDOTI9DJFsyB5WhQG5bh93wPPX4vOwRnwf4VKW5mITIMqDcLDM4BIt92pnKRPmNm1uNOohQO1lIquOvpjXWxWEKGsMS0yj8GXt5VukZpMkqlfdaeGUhOIA7txmJGvtlhggmDex2XnX3d41cnw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(39850400004)(396003)(52536014)(33656002)(71200400001)(7696005)(6506007)(5660300002)(53546011)(83380400001)(2906002)(76116006)(66476007)(66946007)(66446008)(186003)(66556008)(26005)(64756008)(478600001)(316002)(8676002)(9686003)(8936002)(4326008)(55016002)(110136005)(86362001)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?SK49yKLc3Xe0Pgzwd8Ve/OiTJOs3LrktS/0c9/SPyE/b3eidT2qKP/0xRS/x?=
 =?us-ascii?Q?O8VSchmufhm70VTg4erNksWkGtGpKUCtFDgLAJPHHwapCwxWqdqrTaqQTZH+?=
 =?us-ascii?Q?uXjyyxAp9gyAmJaNLJw3Y9F0YFBxRQg/rJFw96gsplzY61gXjKGOK4NvliwT?=
 =?us-ascii?Q?HwPf2izjjgWsWqerkDJTuuTIJ98TVo57IYa2QFmSObaIUcvZ1Q6MQxyZkioh?=
 =?us-ascii?Q?nJwQiVKNzeWFZIHHsJG0ibtF2PPet9xqRUq47kQnkeK1mXNDhmgp21mJj2aY?=
 =?us-ascii?Q?S685AbhmlT+oJ7lh/+N/dyg1yCrEsSZoncthxW2nv1LUnEaUg1+iJnQv2uc9?=
 =?us-ascii?Q?hzrteCoLXbd9f5ZwvB01lZ6X9izQ/ZNvs/nHZz9Ghi3wn433ozAvlJLDsjgs?=
 =?us-ascii?Q?bZyBzpy+DRTvBHUIofV5Uwm9mqJZmDahszK99dQ35BwJzJt3TkSdHbdLMf21?=
 =?us-ascii?Q?5IdHKSJyesWPRPP7iTEvNRVniAF4H6m0vSpdIynhfaZ4jV6D9ZYOGFoLWxDr?=
 =?us-ascii?Q?UNW1ZO7h+J6cLfF3oKWG+BhPqeykSto34rOSa/htBzYDquD92MY7su6IPkYv?=
 =?us-ascii?Q?ynNs4j+0Xt2swRbxqqjFymWD2LrL7KJqeQNtR/I9oo4bqm3CmuzSdQnu+Lek?=
 =?us-ascii?Q?iaSoIVxik0WX/Z1OTSyzh4yTECqp78yvg4oGO/xU96yS+zAZ8tKtjFxvrP2k?=
 =?us-ascii?Q?jnhdwU3J/umVS8sY8MViHSYKf97VY/kOPr+d0JHMX/VaOGomWWe0LZft07rT?=
 =?us-ascii?Q?l9/M8Xd3vkVuPvXc53FRC0W/3FMdgnUZRne5u+//MupBMo8F6VFUEQiI+0an?=
 =?us-ascii?Q?wAzZrM0nRMc0TlyXiGIyq23iz/HSGlRElTodwD05jTqLa8i00SyD3YKGSceu?=
 =?us-ascii?Q?xDoSpOohOjMHstIMumI841+N4YEjEQgesJchubdg+3Z8DD5YIELuhUbcNql5?=
 =?us-ascii?Q?cThplDXQArwz7nyz5a9BAzSRvzF3AdrjorJVemSNYas=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ee800ca-b6f5-4247-4d2f-08d896c4a953
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2020 13:17:46.9931
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yp2uoUD7qsnN3TPAEZaEIPRnWT557AyWih8KiJcY3NJl2kJU+Ucri4ILKmXlwpgpsBWTjLuj5DXGT5mwcks1lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4111
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Yangbo Lu <yangbo.lu@nxp.com>
> Sent: Tuesday, December 1, 2020 09:53
> To: netdev@vger.kernel.org
> Cc: Y.b. Lu <yangbo.lu@nxp.com>; Madalin Bucur
> <madalin.bucur@nxp.com>; David S . Miller <davem@davemloft.net>
> Subject: [PATCH] dpaa_eth: copy timestamp fields to new skb in A-050385
> workaround
>=20
> The timestamp fields should be copied to new skb too in
> A-050385 workaround for later TX timestamping handling.
>=20
> Fixes: 3c68b8fffb48 ("dpaa_eth: FMan erratum A050385 workaround")
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---

Acked-by: Camelia Groza <camelia.groza@nxp.com>

>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index d9c2859..cb7c028 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -2120,6 +2120,15 @@ static int dpaa_a050385_wa(struct net_device
> *net_dev, struct sk_buff **s)
>  	skb_copy_header(new_skb, skb);
>  	new_skb->dev =3D skb->dev;
>=20
> +	/* Copy relevant timestamp info from the old skb to the new */
> +	if (priv->tx_tstamp) {
> +		skb_shinfo(new_skb)->tx_flags =3D skb_shinfo(skb)->tx_flags;
> +		skb_shinfo(new_skb)->hwtstamps =3D skb_shinfo(skb)-
> >hwtstamps;
> +		skb_shinfo(new_skb)->tskey =3D skb_shinfo(skb)->tskey;
> +		if (skb->sk)
> +			skb_set_owner_w(new_skb, skb->sk);
> +	}
> +
>  	/* We move the headroom when we align it so we have to reset the
>  	 * network and transport header offsets relative to the new data
>  	 * pointer. The checksum offload relies on these offsets.
> @@ -2127,7 +2136,6 @@ static int dpaa_a050385_wa(struct net_device
> *net_dev, struct sk_buff **s)
>  	skb_set_network_header(new_skb, skb_network_offset(skb));
>  	skb_set_transport_header(new_skb, skb_transport_offset(skb));
>=20
> -	/* TODO: does timestamping need the result in the old skb? */
>  	dev_kfree_skb(skb);
>  	*s =3D new_skb;
>=20
> --
> 2.7.4

