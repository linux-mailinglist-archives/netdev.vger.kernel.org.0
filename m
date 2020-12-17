Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C312DD008
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 12:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgLQLFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 06:05:17 -0500
Received: from mail-eopbgr60061.outbound.protection.outlook.com ([40.107.6.61]:29314
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726533AbgLQLFQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 06:05:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NYdvU53vck7j+CmhnTSo3IVZMUrqw3ixZct2Sfqy5MNZlpxVftHf+kLfx/Z8wEoXfpQ/IiDGL4h4TKgs4SeXWfhMuPFH7rzhWGOGPl56e8tCtDhjOtRbpkAkf1MHXYPTv68qy/c3kysiwQ8qo/vx3c1ZUfFcSQa3QaWl+nEduIdmyL2Fnq1jlnaD/Rk0yNI5U6v0GDCiI2djjbVPpEBNP/0kRxNz3Og/AWRAxjMMbMfe8eyE0cGunNVSyG9qLMb49oErHWRmH24kRaVbdUpk1qnTOKq3Bax6S4Z+o2ZKTUggwo2nW9b3mvvjo4cDF0oFMV1t1dcePjWVWv87m/CdTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nbdg+dnjxbO+iYzkP9ql9A7Ob4HlcmmKvdtYd8MOyk=;
 b=LHD0VfNOc8XH4B47KPwWcK4UZu+GhjyrxAPicseESfJmuw7ID7gg9xl7/aVkrb6E+RVlkDAb8JJWvTLZgLwSh2ZMHJZ4ToG6RTsdpWc1Xp+44GPyiZ8BzZMAaxN1iKHXlAuL0k8onKfUBq/Dw8RLO4pXVCs8E7wpeClhgTS2ys6PL4dE+7EbY7OlNZ87fIRTZmduuc91pm4kHEQW06qkOXhY1DYimpquD4IOkrBh7/GuldjV/PAwVrrDzpDAoqFfm2t9ODjjWlF0NL8gEZEQszov+BY866sedEOZgS4X+9EZ3GEyJnbg8m29qTBB+holQbcZh7+/1RJYrKxIBN63IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nbdg+dnjxbO+iYzkP9ql9A7Ob4HlcmmKvdtYd8MOyk=;
 b=YHCaoTwYBLaUym9ARcH8ET5e308bhdXMfUXd+dzxrB/S2ASkwaogPS8ptA75XaC/KR6EeL7qjFKxCb4qk2ft9IiH2dw3+RRVEhJs/xXwusIKiu8kiInRe/BktmRvlb2dFq00zvv/XqOMCgg0DR3mwnXOORqrn+RWHlKKKHKxf9Q=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5855.eurprd04.prod.outlook.com (2603:10a6:803:de::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Thu, 17 Dec
 2020 11:04:27 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.025; Thu, 17 Dec 2020
 11:04:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: Re: [RFC PATCH net-next 6/9] net: dsa: remove the transactional logic
 from VLAN objects
Thread-Topic: [RFC PATCH net-next 6/9] net: dsa: remove the transactional
 logic from VLAN objects
Thread-Index: AQHW1Bg1LphJyPDTWkShJXAdzSKQ5Kn7IJMA
Date:   Thu, 17 Dec 2020 11:04:27 +0000
Message-ID: <20201217110426.cacyce4vg643gku6@skbuf>
References: <20201217015822.826304-1-vladimir.oltean@nxp.com>
 <20201217015822.826304-7-vladimir.oltean@nxp.com>
In-Reply-To: <20201217015822.826304-7-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6375a81a-adaa-49aa-cba9-08d8a27b8526
x-ms-traffictypediagnostic: VI1PR04MB5855:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB585533EC2BD0AF0343677360E0C40@VI1PR04MB5855.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VWPpY7OgmtBa8bQv5rvyU8wdqY6iWbjNzfiBTAHOCp5IAqw1/0wuP8MxP5CvEeLhO9CLMt9hxhU7fKWjsSPE793qIhk3eP43+llv/dpYmOGqZ5hmutU9+5ECeFeQkmCSmsE79FxOVoz07tv+EMsHI24jZ1wlZudxD7E4vTTAsTlOFSydn+tNlqLa7zSJGtdpXDWbtmP24zXbR3QXPixwMSwGG/YK6UNsUMqvBFNyVfGs09FMV5fWXKtbmAByaJKV/IUXPcKASMNYLTyyFdJ1nWnu59heY0P2kETBsYucPOkkNvsOSMLj/rU84df+gGPKcp6yQboh+ZIBSgRF4dHB6g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(7416002)(186003)(6486002)(5660300002)(110136005)(54906003)(44832011)(76116006)(64756008)(66476007)(1076003)(8676002)(8936002)(33716001)(9686003)(316002)(6512007)(2906002)(66446008)(86362001)(66946007)(71200400001)(6506007)(66556008)(26005)(4326008)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?C6pbK6Vjxj0ceHAe28lVNhzAVAR8FHYCwe8grlRVcIBY68tSdQDg1ZNhT2GZ?=
 =?us-ascii?Q?S5No4O4v6LORtJqN4WMJuw4gDTLT9smq7HCX6+GiNxkHVzP2wSv5uC3+8j/Y?=
 =?us-ascii?Q?RTNyiucf1KiO0oJE1Ahc6H/1dNv5WtoCp0HCG12U9fpaW5NvQtxX5p83qM7j?=
 =?us-ascii?Q?ouE+G+wOhhtl5SQkz1sH9FiRoInrVdXMKjRsudnsuc3YBQZHAbYk/cmcGAHb?=
 =?us-ascii?Q?spnRAzJmFAYYhw/vcfhoCFYX3xM7p1wOBTI8f6C2dPryDtpJLZP5FtmvOzUt?=
 =?us-ascii?Q?tlcnPT4Z87xp4kiFNEznaJMX48V+RRpkOdjBb+Zlt2Tw4i0yIpYT2EU7q08P?=
 =?us-ascii?Q?yIt9C1cAyKQwjeUFqtqVmdk9CE66eAFnQOGPXi9qmZN7YMhGp5frYpgQEr2a?=
 =?us-ascii?Q?itLWkeQdIv8Veb4VFurREXa+4XSih2A16yAZ1w+ci0mHvAAAyH11QmSl7xfc?=
 =?us-ascii?Q?f657jhEt/eHMyi4MDF3X0aHQonrNQid2Mj8CY4uSsnztbRMmBqS6ljFoDTyO?=
 =?us-ascii?Q?jeTHqoSM+1yqaaNy8If4Rw+o4QjAWp4iiQAfcrERB/iI5+X30asG3qaQF3YV?=
 =?us-ascii?Q?CrHnJVCaETp2IGdGwgG59gkgR2qw04+RewWON/k1yx++sDaItI1iEFi1W7TC?=
 =?us-ascii?Q?tGbwCPqRJeEfpX59IrsfHcOgIGHr4Sfm+uDM9s+MPJycpcQDMTcrkvFjjDr8?=
 =?us-ascii?Q?LC22e9W3JS4VIQRnlUMZizCWBd7fFHRP5JsJRoMTqxjsU8JGDrwxVDIP/rU1?=
 =?us-ascii?Q?/Ty8btWrGOD56y+DjB6OF5jZ0/207RXUywi9Y1TtsJzLVc/L3xqaxslg1H2n?=
 =?us-ascii?Q?wjwaoyL3yn3PM750Wb7OVbjiDtnsuKvrFGWtt/DGpLqn9oCesH5wfD1cnaDB?=
 =?us-ascii?Q?XQOJj6yZ4kCQw0YmbqQId3yoOhTRE2jfj8lgqqPuYyuIInamtpBMyrbTHAFY?=
 =?us-ascii?Q?yTjlME8oEng0zUSrWIulvZbfcfPSeF607AiUzv/5rjjScUS7J1+6umoQPlhg?=
 =?us-ascii?Q?KEDj?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C7F100F5A82F1C4B9C904306CC8CB5A2@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6375a81a-adaa-49aa-cba9-08d8a27b8526
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2020 11:04:27.0325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /0X3amijcGE3lA0y8aQuFpNAZWeyDpUC3zZ9eG4w1yExrszIkxTpP4jJWt97y8G7eZ+Yv0UoM6bbI4Ct3pNAdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5855
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 03:58:19AM +0200, Vladimir Oltean wrote:
> It should be the driver's business to logically separate its VLAN
> offloading into a preparation and a commit phase, and some drivers don't
> need / can't do this.
>=20
> So remove the transactional shim from DSA and let drivers to propagate
> errors directly from the .port_vlan_add callback.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
[...]
> diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> index 65124bc3ddfb..bd00ef6296f9 100644
> --- a/net/dsa/switch.c
> +++ b/net/dsa/switch.c
> @@ -217,35 +217,13 @@ static bool dsa_switch_vlan_match(struct dsa_switch=
 *ds, int port,
>  	return false;
>  }
> =20
> -static int dsa_switch_vlan_prepare(struct dsa_switch *ds,
> -				   struct dsa_notifier_vlan_info *info)
> -{
> -	int port, err;
> -
> -	if (!ds->ops->port_vlan_prepare || !ds->ops->port_vlan_add)
> -		return -EOPNOTSUPP;
> -
> -	for (port =3D 0; port < ds->num_ports; port++) {
> -		if (dsa_switch_vlan_match(ds, port, info)) {
> -			err =3D ds->ops->port_vlan_prepare(ds, port, info->vlan);
> -			if (err)
> -				return err;
> -		}
> -	}
> -
> -	return 0;
> -}
> -
>  static int dsa_switch_vlan_add(struct dsa_switch *ds,
>  			       struct dsa_notifier_vlan_info *info)
>  {
>  	int port;
> =20
> -	if (switchdev_trans_ph_prepare(info->trans))
> -		return dsa_switch_vlan_prepare(ds, info);
> -
>  	if (!ds->ops->port_vlan_add)
> -		return 0;
> +		return -EOPNOTSUPP;
> =20
>  	for (port =3D 0; port < ds->num_ports; port++)
>  		if (dsa_switch_vlan_match(ds, port, info))
> --=20
> 2.25.1
>=20

For anybody who wants to test, please paste this instead of the existing
dsa_switch_vlan_add, to propagate the errors:

static int dsa_switch_vlan_add(struct dsa_switch *ds,
			       struct dsa_notifier_vlan_info *info)
{
	int err =3D 0;
	int port;

	if (!ds->ops->port_vlan_add)
		return -EOPNOTSUPP;

	for (port =3D 0; port < ds->num_ports; port++) {
		if (dsa_switch_vlan_match(ds, port, info)) {
			err =3D ds->ops->port_vlan_add(ds, port, info->vlan);
			if (err)
				break;
		}
	}

	return err;
}=
