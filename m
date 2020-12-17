Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB102DD005
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 12:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgLQLEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 06:04:02 -0500
Received: from mail-eopbgr50085.outbound.protection.outlook.com ([40.107.5.85]:25356
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726160AbgLQLEA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 06:04:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kEJu11jCPY6M+obyz8j0yuOHoexHjc9qnDmzqi8509iNPBHYawx+EpS+UXrdoE5y7gMSBXj3H+fyognyLh7jlqKRN0oqNih39VWm9VpLrnfyi4Xk0BFJNJ8jE14xobmHOpXIJqQoqtEQwTPhdgLxcBNVmOMtgbQpiQstv2gim17z25At6A1Msyc8Xt7fzozL4bbJ/P86VvHdgxeoXSDsPeAQSbOJwoz+FxuYLw+VVlwvoymW/s62tQhMmhABEcLeAoscHfUudlVzKG9qn/NpuzE3C1BAR7vgJdynFEyJoYh3E4Rr6DR9RWjb/0VEUZAONHecPM2VUKixZ1IbzY/qXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WqzQwTvtJW6wyhdxeoJqnQWTGfMziRq0JoIA4f+m0dA=;
 b=i3uuIYL8FWcKU9EErgik2CpFao2WqWOt8KqozbFlLHUx0eXOeTKsHoTmIYZrTptiY4wigxff0n9U9h2tswFhLGMEu/JxMJyVAlGs5xX1Mxxyw0+JxaTmKoWzfudE1M7eJ7ti/ne9Iz1794ioSY2Mm9Oec/xx/w1lxkSwn87YnvdpKgwLyJv4w997Kzhc3N+uEuGEUbhNwSLxmHfw7IxEzDUJ5Fc1AZcGLUlfMbC2inWMUGVlP3iFod9wlOchrbdTEayUJdQbaTE+lUp4aNx1+Ycm1w7s3Xm99/FQkcMXp/NqKIydG4Rytoahgf4TxUA6PHDyrNUY9S+rP6VXYVAUnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WqzQwTvtJW6wyhdxeoJqnQWTGfMziRq0JoIA4f+m0dA=;
 b=BBjvTiYpaRGi4Yo3ogG8ZqV75Q9BB44F1ZDQWIzt/3HRgHZLWJiuzQFNPCOdAO50aqJ1kctL0CDaanCaYzE76RL9UMRPcAbUkZ9CNdLHc9jQAnEsGabPoKlKji5StHCiIDS6bW1crI0cH7ZohjblEgxNs5g7QyQCiL+9NxCDWzw=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6942.eurprd04.prod.outlook.com (2603:10a6:803:136::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Thu, 17 Dec
 2020 11:03:12 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.025; Thu, 17 Dec 2020
 11:03:12 +0000
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
Subject: Re: [RFC PATCH net-next 5/9] net: dsa: remove the transactional logic
 from MDB entries
Thread-Topic: [RFC PATCH net-next 5/9] net: dsa: remove the transactional
 logic from MDB entries
Thread-Index: AQHW1Bg0Hp+3K7+ng0uXRrurJpbRoqn7IDgA
Date:   Thu, 17 Dec 2020 11:03:11 +0000
Message-ID: <20201217110310.fqkn7dh5sre7ycqb@skbuf>
References: <20201217015822.826304-1-vladimir.oltean@nxp.com>
 <20201217015822.826304-6-vladimir.oltean@nxp.com>
In-Reply-To: <20201217015822.826304-6-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7f796b7b-ffd7-4bed-1317-08d8a27b586d
x-ms-traffictypediagnostic: VI1PR04MB6942:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB69421DA83CC4F6E2079279CEE0C40@VI1PR04MB6942.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GwbaxSe/om3j8cfCvknhFPfZdOmK0SRlQzd2r8UztAqpXXSXQGN3aPqiRBZMcArPN9W35AgluY9iSezT34BzeZIyS9Ku0GXSOEmiJkLrs4/UJIwMroUXdXJB4hCqdvL0aMdbmBBf0Q2umYko13gTXI2on6ZBEskwSBDcBl0XHcDvhrzXv2WoRtuw6XObxQccXH2w+A0NGBFrSjy+urhXoodkr7yS5NluyKoDeSDMu8dfzluMZKb0daz8EGY/BzWy9BlJnDO3Fw8Y0QFITbEwSfWHA25cZhKp8gumsDdacuddeYmuuul6SqJtT82hndvk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(8936002)(4326008)(66476007)(71200400001)(64756008)(478600001)(6506007)(186003)(66946007)(2906002)(9686003)(26005)(83380400001)(44832011)(6512007)(76116006)(54906003)(8676002)(6486002)(66446008)(66556008)(5660300002)(110136005)(1076003)(86362001)(7416002)(33716001)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?epemUeHmLvKHAsvU8aRBES30C4ly9NBcrZv2RGKTFxgv/l8n/OOONQh+5A7j?=
 =?us-ascii?Q?0P0zjaNA9WG2A0Uf4W1cry5Ej1dfSbRYlFYm1RrWhpkU2F0XLk0/s/ZfxzVH?=
 =?us-ascii?Q?Z0/pbMEw8GnMpDJXUdmcxCVv+uYUq2qIpyvpkZO/yYAXdMfJGwQ2qtPsnD19?=
 =?us-ascii?Q?/ShlUjEXv3SqRSQFxJm1lTZl6B2ZGA00tXFsXNxXesiLOhKJLkt/NWkJdPBn?=
 =?us-ascii?Q?p/FSORXFPAm1DnYfkEc+Pq0kKxO0JIiwrkkhXbvvz8zI/LqH9rrbLb7E1CJx?=
 =?us-ascii?Q?JejZl3YXvShKCM6ceK9YVVr+j78dkJ36LpzesnZpKoWE2o/HmI/5xf5F4iFL?=
 =?us-ascii?Q?+PhEz/brL+0rQ+lUaNqASa87DKOt9sR4xDSnP0On1L+9NPF5qDKVrNHG+kj1?=
 =?us-ascii?Q?8Bbr9F5XNiHbh3UNEM7Agkl0zyQQKmp6Uga+9oQsKQumXl9qhw3crZFkwyjQ?=
 =?us-ascii?Q?hVi3NDn2/xS1T97vyv9yJdPIn84dvsff7W9Y6XJXN70y+SutV2NQ0jIAlYC+?=
 =?us-ascii?Q?H6ah9JNim1afKqVHE7VnkTYQiPeuimQnYYUfhIm3jjiv6144JZrvg+YQP1PB?=
 =?us-ascii?Q?ruUDzfiWr/nX4dZGqvrhDZ1r0oCQHKx19yGf7zi8SF7V+5wKFH2VUpvkyrKw?=
 =?us-ascii?Q?jCl5j9r6msEVjlMbL8qooQHQKivm79X5nplZOzRUf8M2Sq8EK7Eq0aMT6CUp?=
 =?us-ascii?Q?gdzwYM8Ivp7i4Lr3KUyj0QXYlO6CC/mj/dx1ZiQy+LM/XpCNxUFeWo+NE4HJ?=
 =?us-ascii?Q?uRcRBFWfRwKKSc65HhEaoqeUffnRvISyC+2J9hB6p9uc6dUa5c/GS2XMNArA?=
 =?us-ascii?Q?Q84bl2vhk+L50uPDu8SBzbNYfvGD1Yu/VCqiCwaPCaHfhK3FLzsaQ9YFdgGq?=
 =?us-ascii?Q?x1MQOK4vGsdSMdqQuwN4UFOo7iuhfElQK5MBlTZ9qPE8T2aSxC/nkqnDuqr3?=
 =?us-ascii?Q?cnyu+xPcm9Ldw49N+3OrV2s3U060LFeLZ0p1Pv8yzFZyRXg01sMiNp1338YX?=
 =?us-ascii?Q?dLPr?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D88F1CE9D80C0C41AEDF9421C6AFD93F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f796b7b-ffd7-4bed-1317-08d8a27b586d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2020 11:03:11.9666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tGSB4IdESwUB9NNGAWY/bY3WnPNHybJ2pWJoLFkwImX3dNiuEm67EBLXymD80Uvf2Lx4e3s0pVix7wpS9UDFwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6942
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 03:58:18AM +0200, Vladimir Oltean wrote:
> For many drivers, the .port_mdb_prepare callback was not a good opportuni=
ty
> to avoid any error condition, and they would suppress errors found during
> the actual commit phase.
>=20
> Where a logical separation between the prepare and the commit phase
> existed, the function that used to implement the .port_mdb_prepare
> callback still exists, but now it is called directly from .port_mdb_add,
> which was modified to return an int code.
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
[...]
> diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> index 39848eac1da8..65124bc3ddfb 100644
> --- a/net/dsa/switch.c
> +++ b/net/dsa/switch.c
> @@ -178,35 +178,13 @@ static bool dsa_switch_mdb_match(struct dsa_switch =
*ds, int port,
>  	return false;
>  }
> =20
> -static int dsa_switch_mdb_prepare(struct dsa_switch *ds,
> -				  struct dsa_notifier_mdb_info *info)
> -{
> -	int port, err;
> -
> -	if (!ds->ops->port_mdb_prepare || !ds->ops->port_mdb_add)
> -		return -EOPNOTSUPP;
> -
> -	for (port =3D 0; port < ds->num_ports; port++) {
> -		if (dsa_switch_mdb_match(ds, port, info)) {
> -			err =3D ds->ops->port_mdb_prepare(ds, port, info->mdb);
> -			if (err)
> -				return err;
> -		}
> -	}
> -
> -	return 0;
> -}
> -
>  static int dsa_switch_mdb_add(struct dsa_switch *ds,
>  			      struct dsa_notifier_mdb_info *info)
>  {
>  	int port;
> =20
> -	if (switchdev_trans_ph_prepare(info->trans))
> -		return dsa_switch_mdb_prepare(ds, info);
> -
>  	if (!ds->ops->port_mdb_add)
> -		return 0;
> +		return -EOPNOTSUPP;
> =20
>  	for (port =3D 0; port < ds->num_ports; port++)
>  		if (dsa_switch_mdb_match(ds, port, info))
> --=20
> 2.25.1
>=20

For anybody who wants to test, I forgot to update dsa_switch_mdb_add to
propagate the errors. It should look like this:

static int dsa_switch_mdb_add(struct dsa_switch *ds,
			      struct dsa_notifier_mdb_info *info)
{
	int err =3D 0;
	int port;

	if (!ds->ops->port_mdb_add)
		return -EOPNOTSUPP;

	for (port =3D 0; port < ds->num_ports; port++) {
		if (dsa_switch_mdb_match(ds, port, info)) {
			err =3D ds->ops->port_mdb_add(ds, port, info->mdb);
			if (err)
				break;
		}
	}

	return err;
}=
