Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9892718AD
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 01:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgITXwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 19:52:08 -0400
Received: from mail-vi1eur05on2053.outbound.protection.outlook.com ([40.107.21.53]:52896
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726156AbgITXwH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 19:52:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8GG2xoSbWKdPsRdn1zif2M958Ow1V//p4lPeTlD0ns6FD74tK0Mwfuy5FMlB0JBnpF2i41hx8esgxoSj93Nx57g6hMJGku/yEa/r1p3HN8uisKi72xboE5JqRRfV6dHmvcnGRv/iIXdGOKrtuNHvd25GZR14q94tdqB1UMBc2wC9JqiyZ6cVR06tXepob4z/CTRosJjatzq3FQ5gw1+irnSZLwzDxfCIK7deZRbPEZFRyBNx6Ojiu3U4CN1yI9I9sAKNfvgfvmrLyQKs6Pu5mzbfCjLnFPE+pKE4PGhT8lFgU8R4UcL9jeGkwgggb0z8lnshGmxq9YfCw5gHVey4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/aoXm8VCajDFqWFoFPfj+D22cjG3z4KoyvDeI8A/Nw=;
 b=OaxAMky5g4RBKg4z/JD1U2tvy6Nt3OA/HX/AcXYNttkfTKBINmloKvsI3oufwRgptE7QKns5rFf56NlCELOV6h3V96nXIn87/c9cf1zDnc3ohmg3LwE++cgQASWQc8x4M1j/9xUES2ahhL8xz/bdcSAp8f0ta3z7F7d3IYpSxhg+jhhJkr+rXVB1GL01uS9LcoAXjKQTmiK5a8pOQbPpqXvltQzDhoqBpUsJJh4gu3dndTjozhyA8skJZhblvXPDI4T8k3/MEscni3szd5LgOSrCiBbiNnTS8qC37DjRw0womORCTorgCu49Kj2PGHbh0DZ6bixItXeb9j9yKbUMnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B/aoXm8VCajDFqWFoFPfj+D22cjG3z4KoyvDeI8A/Nw=;
 b=la2WIFM5q7enzHln/IVgJ2J5CDOu2bGA6qse3JvtyXGbki2U1DUowMYgWZpSosh6LimFPNT2YZQul9iO++TKenN6K91gIsftNywtYI9kua/IYRJQl5Ghq6VFa9htLV1X418hE9i/ZE7P8MAshgZuOaDJpEAS+J8nidCX5/Foz70=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB3199.eurprd04.prod.outlook.com (2603:10a6:802:3::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Sun, 20 Sep
 2020 23:52:04 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Sun, 20 Sep 2020
 23:52:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH net-next RFC v1 3/4] net: dsa: Add helper for converting
 devlink port to ds and port
Thread-Topic: [PATCH net-next RFC v1 3/4] net: dsa: Add helper for converting
 devlink port to ds and port
Thread-Index: AQHWjpNTyvQBof3yfk6dvEbEaJL7XqlyNOyA
Date:   Sun, 20 Sep 2020 23:52:03 +0000
Message-ID: <20200920235203.5r4srjqyjl5lutan@skbuf>
References: <20200919144332.3665538-1-andrew@lunn.ch>
 <20200919144332.3665538-4-andrew@lunn.ch>
In-Reply-To: <20200919144332.3665538-4-andrew@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 24c093c5-8dd4-47ff-ee62-08d85dc02cd7
x-ms-traffictypediagnostic: VI1PR04MB3199:
x-microsoft-antispam-prvs: <VI1PR04MB31992B78559A56C318D071D1E03D0@VI1PR04MB3199.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sexgtNUk52kGwOSbKpE7DVA21EaULXkeLEQXXOffC09uE21zQnePcJRv8070oZtNmv0CD/WOcnK2I+EKHBZOe/SeXx/bBqhys6Ahy21RhQRzwL50J3GRTYcFxMdYTHh+jHv1I3fKeRpaAA6rCTU56kLmUvksKb5SlYKYwfREoVye5JfhgxoXSuxPgcAdjf4yQazPaUwvh2ZXI0mIFtp87g6jm41IDdAu8DzzAdZJX7iKZpIcUXFK1h8g92PKAsyxqeq0eHKN2TJ598cLuuVD1VejLm67hYg9OcZ5LvrqmaVXcUBzWAUOerPMgalroQrB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(376002)(346002)(366004)(136003)(39860400002)(396003)(8936002)(4326008)(64756008)(478600001)(2906002)(66446008)(66556008)(66476007)(26005)(76116006)(33716001)(66946007)(86362001)(44832011)(316002)(6486002)(6506007)(6916009)(1076003)(6512007)(9686003)(5660300002)(186003)(71200400001)(54906003)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: b/AIUgkcpVjQqjhh/nTAcdZSp8mZIPUDZ50bHXChMbixMToNBNTQtuJTcYYsHFVWmFlLdV6La1HQxrfSPrPNFtcwLNvoQQULFp5v0Lfn2SDni9iVxuCCntstbt+hDJLMxCJT60NGt9Aq3/cXB7aJVc8KjORAlWOQNHYEfbwHZRehEfPkd2SL6qUPiAMws5VhQBK6q8UW6w/m8UtVblfX0nlbb0liLCBCcm5lerpQx4wiRQLKpAcCsCZP5zA718gwFxD81F/8fh7Hn1zJw2lqjyQA8V0MPhvPFnOCe03f4dv9uv/iwaBCv8fUxNue3v2BOIx/npAVWqyD5zwuOI9g7KHxWTj7VsOyZlijNVD1T2KV212vK7iW0vcmFG4TbCCc5tTwH2mnYhrqWF4i02iaTgbRcJarumwtCLN9w+w3Azjo8nyi2QOOBgPENaBjia6wgejNouHZ3J22wRv4hyQTYZE1nOILuUSbYnp+UWfSMLOiYcx4qMaf0GWI4TK8Icsijws+tKlGAGy6vHcVdtngcEI0jXpleadTH03seX8DySSNuKUN/9Fr1taFvqSf8o6+4tpL7B05wv0i8RqbxRhvmq6p66nnGJPeZiAYEHXHAqPWWMrz46FdypoZO5v/Tmk31UXHSpsGU7azTWoY6QUFFA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <98D627A335D34247824A5A6F64513B59@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24c093c5-8dd4-47ff-ee62-08d85dc02cd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2020 23:52:03.9858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MpUOo/d9pDBenNmClVvDEH4AcQkwmY2k3IpmS5ZUhV/xRxLGKXqzEWAgchd6SH6JeTf5MbwOVVxjdeZDNA3XLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3199
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 04:43:31PM +0200, Andrew Lunn wrote:
> Hide away from DSA drivers how devlink works.
>=20
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  include/net/dsa.h | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>=20
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 01da896b2998..a24d5158ee0c 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -685,6 +685,20 @@ static inline struct dsa_switch *dsa_devlink_to_ds(s=
truct devlink *dl)
>  	return dl_priv->ds;
>  }
> =20
> +static inline
> +struct dsa_switch *dsa_devlink_port_to_ds(struct devlink_port *port)
> +{
> +	struct devlink *dl =3D port->devlink;
> +	struct dsa_devlink_priv *dl_priv =3D devlink_priv(dl);
> +
> +	return dl_priv->ds;
> +}
> +
> +static inline int dsa_devlink_port_to_port(struct devlink_port *port)

How about dsa_devlink_port_to_index?
It avoids the repetition and it also indicates more clearly that it
returns an index rather than a struct dsa_port, without needing to fire
up ctags.

> +{
> +	return port->index;
> +}
> +
>  struct dsa_switch_driver {
>  	struct list_head	list;
>  	const struct dsa_switch_ops *ops;
> --=20
> 2.28.0
>=20

Thanks,
-Vladimir=
