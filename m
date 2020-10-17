Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026712914E9
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 00:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439674AbgJQWXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 18:23:08 -0400
Received: from mail-eopbgr70042.outbound.protection.outlook.com ([40.107.7.42]:2433
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439668AbgJQWXH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 18:23:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nlXlTPzwD5teSqwcwJYdEc3Hwm76cLHwBW5EXFsEdhoP9hLdcrgrWtNwunD6rLxnMAz7MSjUTqYnBOvTOcHLp7F1LmvZ1s3/heEz46DcpSTkw4QZsl1TNtKAW16+go8KQIYIR59EkbylLr8qwjo6gkBBoS1G1Q9eVix7XlfvcBaXw8nn8CCnMxY5pBMWTFk4ynFPh3kgD7Dsco0/PxCacQ9XYG+8zKzNKntkHQS21+689tGnJfAtGYaz75KF9Ln3aYSDfDnmnpn5nHC6hFMgMmeweWYVH4oIOJgzyN2s5rsgKD+zZNhtXIBVySddiDXkBpoyj6YvveCwbOBFqJKi6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qkJsbmdFtl+VeIZFescgEdwGB6QTN9H/eUJoKbUfQY=;
 b=IBOFOE8tByi+Uio+JCfh5fsGv1m3wJKIG89QWB3+o0HLldOcSiW8c/KJq18jMIg1Qko2Q1csMQI8X5TNCXbmb44cyYLc6Mu6t080sVc7LofvgHzqAbhwpzYkBaMw7jkUlwUhmYDS6XjC4IF5newV61ahXdvkgs0fYbf717o6gGHZee7t9LD6iVbf66ZkanfmEXqwzDYrjx0flUKxGCKHGo3LG09E3AkzgCL3wkUUUx7tlMjOpvCuYZk3erudkgL+hdMphO2TKjW/29Sd195KhqfWSwk9Zzk/Ows561FrQvPMljzVUjekZrYyYbNyOhvnpd84cgTaVaH0w82q4hFYXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qkJsbmdFtl+VeIZFescgEdwGB6QTN9H/eUJoKbUfQY=;
 b=HUAHuiFFah0Va1DnK1vGqTQ93xFbo0Ob1ncrTTUS17yfF664UlS6N8tK6epuTiiVWjjJFiSIBhrKvTp/78T5ScK6YcOiaTtZxDHTPokUNsSQ6QfR64n3z9GIsZsBblAtE+lxoSGcztMrfA9jXfjlccJeWABec2PRaCpe1SxQsHc=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5501.eurprd04.prod.outlook.com (2603:10a6:803:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Sat, 17 Oct
 2020 22:19:47 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sat, 17 Oct 2020
 22:19:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [RFC PATCH 12/13] net: dsa: tag_gswip: let DSA core deal with TX
 reallocation
Thread-Topic: [RFC PATCH 12/13] net: dsa: tag_gswip: let DSA core deal with TX
 reallocation
Thread-Index: AQHWpM2aed7o+seVIEW73qqzAsotCamcXaIA
Date:   Sat, 17 Oct 2020 22:19:47 +0000
Message-ID: <20201017221946.ghaloeaj6d3k2n4m@skbuf>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-13-vladimir.oltean@nxp.com>
In-Reply-To: <20201017213611.2557565-13-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8430d4b9-2f66-436e-477b-08d872eac238
x-ms-traffictypediagnostic: VI1PR04MB5501:
x-microsoft-antispam-prvs: <VI1PR04MB550160B321FD4FD58660B6CCE0000@VI1PR04MB5501.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:370;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TU7iQR61QlHvYomqIIDH2BVXbJN8Ki984G+8oRPpkAfaWf45Vp3AJEwxZqycmElLgxV+eU5ho+RJiYq7ncZBMwD99Uf+lBlcw2slxgFiXZNRhY7HUmNukhONWFs7PR6JaHyH21nfk0K94JkBVnMJvq0I6h0zTJ/WNzUe/QHhpYZ0fUE5K1CXXIEBCNNZfADK5RF72l7pxui7drwF2SxskWfGyiIDBbfBPPOQ8EBIvFEhFgAT6de6qLHisRT6VVJwDvxgWKQfXydjxFIBH1b4d7evUkjoxfRfLZU2ISCUE1cf7c3x0zd9bM+H5SGjQm8WuFUOiUpx9bkrcDwPUWsqNA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(136003)(376002)(346002)(396003)(39850400004)(66446008)(6486002)(76116006)(64756008)(66476007)(2906002)(91956017)(5660300002)(66946007)(6512007)(478600001)(186003)(44832011)(66556008)(4744005)(6916009)(4326008)(26005)(1076003)(8936002)(6506007)(83380400001)(9686003)(8676002)(86362001)(316002)(71200400001)(33716001)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: H80Gi0y0c+iwjB7AgtuOJRF558C8Z27AE7WtTEQJ0IZMjyA4AmkJbEfCXMueYU5BTe7tqEK8mHQJA+256ca229V1N+MeywWLpds89oyeiXDNFxVUosL/sdVq6u70KeRCCTqS0VxhFUFcnOZWtm5+U00YWCoz+sK5F1I2FcOeDYTVzbyF+J9u7zY5f54cmmJ19FOeii3wwKKI0hbYiOc6ypw2QtKSGHZHbWbhUMwrgIF9Tz4pKYqdHZhqXBwcPdO8jEC481iOysLSOWvwdzUbVmbFFIYOMRyEWjD1dRE7F8bhZKPHosPpQJnm6Tef1sNQIPBZ9Cb0edEYbm3ZqJQRC2EZz4S0bjSnAjXbkf0aCQtH9/r2fpXLKVtAYo4KKRJLhS+Z0CAuS8m0xXO3b4FLP6avn9YUZBlSsSXX+JVx0ym2Ao7zOX3DP7EBf7UWXZutpOTRGbH6ioByNL1S5eQlpXsQ/JahycRiBZ63v+2JlvLi2QDImz5vdteDoUhewjNK2EXzTZkxs+zcnsDG5OeWDpQ5wJPh429Dd6x8WJvn7cZk5LAu1fBnxc3TaqcbAJVDkEHMZA7C+CGOqYd9ixZCEtkW0NNyNyx/OynPavd5rnC03k4DC0pWO3AiaKuexLW2fx6igaHHLInmYdkqZg+iWw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DFA17D0155051D4B95A783BF133966CC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8430d4b9-2f66-436e-477b-08d872eac238
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2020 22:19:47.8147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DJI6Fve7s6DyQylJvV7A+USge1CqYjz4WoCOf/xymXHq+W1WhiajlsQVkGjC8MbPUfgQoeafvfA8F56qkpU05Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 12:36:10AM +0300, Vladimir Oltean wrote:
> diff --git a/net/dsa/tag_gswip.c b/net/dsa/tag_gswip.c
> index 408d4af390a0..cde93ccb21ac 100644
> --- a/net/dsa/tag_gswip.c
> +++ b/net/dsa/tag_gswip.c
> @@ -63,10 +63,6 @@ static struct sk_buff *gswip_tag_xmit(struct sk_buff *=
skb,
>  	int err;

Unused variable "err" left behind, will delete.

>  	u8 *gswip_tag;
>
> -	err =3D skb_cow_head(skb, GSWIP_TX_HEADER_LEN);
> -	if (err)
> -		return NULL;
> -
>  	skb_push(skb, GSWIP_TX_HEADER_LEN);
>
>  	gswip_tag =3D skb->data;
> --=
