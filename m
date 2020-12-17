Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC212DD0A6
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 12:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbgLQLo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 06:44:27 -0500
Received: from mail-eopbgr140041.outbound.protection.outlook.com ([40.107.14.41]:58370
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726012AbgLQLo0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 06:44:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ByTsJic1gztwRi2kVoa1IEvTHdEeEqkH7MXb++91p3kaTD4xONPUx721M6ygkzbh+8LvTOfef8cEy7R9OPzBYVM5/HQgQMzoHhO1WrmNFaWOiKmEmMveepH70drG/FO6pYSwPOkrZBha1e14T3UPzPTEPt5FNi/gwAk9jWco9jglZWYFzpZDC+yYfIlwYXD2AgdwmrFQ/8Klba70OQUe4vTeo48tPxslMS9HIRstT+H4A/HO5ZlrdCyNAI9l1m0OVhYn+RYtqaY5ZRFwyay1WcPYAqNvmAw67Vn5V+mrIg5e4X0o1clbTdQGI0bQiKfNhzOAq+jBW/9DIf35MS45pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKYkv6bnvdMxUolT/xZan/SxJqTufzBjK3abQcesxVg=;
 b=TbfQcA76m5OmrD6H1kGrEYGsi36eWblKm9INPK92C5gqXjcEXD5Vt4sAigQBix+godN4lCN5C49lQbuZmKKfvT9LUDyzANv4Bw75iuaIrcyUODd7Ot/iBNsAnyvyL5s3OeeFry04J68PMAkmaiEOkAnAFC8nLgbnW18PcYivG6H2yHnDEBfsN2G0U+rI76R5x3/byNi/Ncab3uPYi/7pVSarogcQJszj1Wf2EOuVaK0nWjOOtosKQdKKjnqBatqx6TU1yPMBlEfjnWmd7tU+Vi3AGMWtNmVrRO/t197Fvm8uFP0wZNZK8XwFgyp7mLRJIZlbcvzttwc125LoDuaDDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKYkv6bnvdMxUolT/xZan/SxJqTufzBjK3abQcesxVg=;
 b=qF1eQTuxnKbsggwLruFlqRnIvbVdUN7PD4P/dnWmk84EiMZ7B8UtbWOlUHV4LTEbCb9VWXFmzDGPVCYQwcwBH6tRPd4GRTO8a5vBusdbvHtk2X8FvL/LwlEIx/2en16VtaYioZz0whDpG4MkyJ+Rf7DzqNxR2cs7m9oSwqINcYM=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7374.eurprd04.prod.outlook.com (2603:10a6:800:1ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 17 Dec
 2020 11:43:37 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.025; Thu, 17 Dec 2020
 11:43:37 +0000
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
Thread-Index: AQHW1Bg1LphJyPDTWkShJXAdzSKQ5Kn7IJMAgAAK8gA=
Date:   Thu, 17 Dec 2020 11:43:37 +0000
Message-ID: <20201217114336.4vohivu43hbp7ucw@skbuf>
References: <20201217015822.826304-1-vladimir.oltean@nxp.com>
 <20201217015822.826304-7-vladimir.oltean@nxp.com>
 <20201217110426.cacyce4vg643gku6@skbuf>
In-Reply-To: <20201217110426.cacyce4vg643gku6@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a5538f55-a2f9-4f8f-b9b0-08d8a280fe20
x-ms-traffictypediagnostic: VE1PR04MB7374:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB73745268377F5FD32394A289E0C40@VE1PR04MB7374.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F3sKSuGePqasFoEs8EsAuCk6dwA8vm+xbWZ6aHSJzbA2vJjVgoxE92toYzD+LQn8U6WK7U4K4dQ3AuQXPcZeLU4yg2x4mjpB/RFjyUbhVRpL9nzLR1m9PjmyxAPo/c7G56M6mKSfLWJChkMOTOWru99gKIpNxRGkpxbYUtcJ1s8hmBkEaUZbzqDMJFNP77cQ5GlboJXFVpmNlLJzyoLiP2m96xEF3Y3CYv5JWFAevVoxWBPMumRMgoPfWPDPAS1XGbKMhFn8fEtqZ2ikUtPK0tJ7gA4+EHLzO0OmKVGBXdex0Hg3snax9EGL5FBVpp0rHlKCfXOHs98ywPOq/dAtqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(396003)(366004)(39860400002)(136003)(376002)(4326008)(478600001)(83380400001)(44832011)(54906003)(7416002)(110136005)(71200400001)(2906002)(6512007)(9686003)(64756008)(1076003)(316002)(8676002)(186003)(86362001)(26005)(76116006)(8936002)(33716001)(66476007)(66556008)(66446008)(6506007)(6486002)(66946007)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?axp9v/Sl8o1/rkLkFIfm/ujGLySVqLpsdeNqatjWfauiDOk5Aa1sXmEyEwss?=
 =?us-ascii?Q?g3pKngJEhyJ0Wg4NHNVm0WeHaWqHW2X6yt03DVPA6bL5ipwYiaEw1AlzGS+3?=
 =?us-ascii?Q?UXu3Z7ZDMdzYRncKy35cpG9450MCOKdy1x0F+QIu6HZoLpIstPM4mHYEYEEj?=
 =?us-ascii?Q?b9w9K4gW0bH9p2rCnHwJP8Qf7Xw2nnNHQBew1DWnBoGKFhOqCvEFdfjPWBqh?=
 =?us-ascii?Q?Ln42XxrHBdrVpKEOwp+Mr5qAXrLkqvt2gnoiUOsALXwtfGFUvtMK8vJV7pq5?=
 =?us-ascii?Q?DNTZ5tqmxKWFmy61xzrLWSNXfhn+IppMt1/B60Q2yQRJ7tD5thpfXXfZB1jg?=
 =?us-ascii?Q?XhZCyGPksr7U0CHM+zcnI0YzE9rUsZZ3S65n83ycKQQN3HhKG0gLvEs/inDt?=
 =?us-ascii?Q?QN+kVyPUxYB9veI0TBjt3/Mn4cmFGYwuEovwXFUjuygFa9eCSIMSvIwmdgnE?=
 =?us-ascii?Q?uQ9SaAMqJzgZcHVcQNDCzKEDqSA6RNFbEpdw06RQzcbMjwk6+5wbPW0sLFwC?=
 =?us-ascii?Q?TOLSLzhoPfKzsiUtAdAkUzSlqaTIeLUxGy7UKN4y8Qr0+6fxkNvRGgjbC7Tr?=
 =?us-ascii?Q?zgVm0wUk/bgRb5uDV1p36tKJ/rY9Dk4ARm3hZwumVU7FE22aP/HkCDjna+dJ?=
 =?us-ascii?Q?DGqHtr1QpsFd9Kh+qXO1kanEZnr6pO3EonJvyXqUODkCdnf7c/rIrkfByiox?=
 =?us-ascii?Q?ypPsD0/0RMerdVeMi6N4rUlexWUZwETcGuGJ/tLn+Qbndu7xdOs0f6NawUq0?=
 =?us-ascii?Q?ZWbnY+/N+8JLPj6xbS7cMmtnaEpPTrkfalOy3gBOADpmRugtKYdJ/oFRaExW?=
 =?us-ascii?Q?hRVtcaj8WF2zOnVaaeA/N6ZZ2cziVqdlPCOsZWokFbcJvWkDphR9tGAlwb6p?=
 =?us-ascii?Q?3y46isEM5RYqvOTuv+fbqUoOFVhU4QPiSBa633BEtRffoc4eOg2Van+Zz4vn?=
 =?us-ascii?Q?nEhoYpdzuRpt8KgzNCze/IJ8xZGSJsHDS0Bk2ZOkqVJUewqe+NwZ+e3NHVB+?=
 =?us-ascii?Q?EVqu?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5D32145DA2171F42AD3B20C42E908A07@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5538f55-a2f9-4f8f-b9b0-08d8a280fe20
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2020 11:43:37.5576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p/WnNhy206ucHNR5gY0ZTVtfxTI6zK54QORfhaV/bsG14SaQMxjOp3cGSFL/gCDVM5IgrQc/rxXJbQsXvSAmWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7374
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 01:04:26PM +0200, Vladimir Oltean wrote:
> On Thu, Dec 17, 2020 at 03:58:19AM +0200, Vladimir Oltean wrote:
> > It should be the driver's business to logically separate its VLAN
> > offloading into a preparation and a commit phase, and some drivers don'=
t
> > need / can't do this.
> >=20
> > So remove the transactional shim from DSA and let drivers to propagate
> > errors directly from the .port_vlan_add callback.
> >=20
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> [...]
> > diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> > index 65124bc3ddfb..bd00ef6296f9 100644
> > --- a/net/dsa/switch.c
> > +++ b/net/dsa/switch.c
> > @@ -217,35 +217,13 @@ static bool dsa_switch_vlan_match(struct dsa_swit=
ch *ds, int port,
> >  	return false;
> >  }
> > =20
> > -static int dsa_switch_vlan_prepare(struct dsa_switch *ds,
> > -				   struct dsa_notifier_vlan_info *info)
> > -{
> > -	int port, err;
> > -
> > -	if (!ds->ops->port_vlan_prepare || !ds->ops->port_vlan_add)
> > -		return -EOPNOTSUPP;
> > -
> > -	for (port =3D 0; port < ds->num_ports; port++) {
> > -		if (dsa_switch_vlan_match(ds, port, info)) {
> > -			err =3D ds->ops->port_vlan_prepare(ds, port, info->vlan);
> > -			if (err)
> > -				return err;
> > -		}
> > -	}
> > -
> > -	return 0;
> > -}
> > -
> >  static int dsa_switch_vlan_add(struct dsa_switch *ds,
> >  			       struct dsa_notifier_vlan_info *info)
> >  {
> >  	int port;
> > =20
> > -	if (switchdev_trans_ph_prepare(info->trans))
> > -		return dsa_switch_vlan_prepare(ds, info);
> > -
> >  	if (!ds->ops->port_vlan_add)
> > -		return 0;
> > +		return -EOPNOTSUPP;
> > =20
> >  	for (port =3D 0; port < ds->num_ports; port++)
> >  		if (dsa_switch_vlan_match(ds, port, info))
> > --=20
> > 2.25.1
> >=20
>=20
> For anybody who wants to test, please paste this instead of the existing
> dsa_switch_vlan_add, to propagate the errors:
>=20
> static int dsa_switch_vlan_add(struct dsa_switch *ds,
> 			       struct dsa_notifier_vlan_info *info)
> {
> 	int err =3D 0;
> 	int port;
>=20
> 	if (!ds->ops->port_vlan_add)
> 		return -EOPNOTSUPP;
>=20
> 	for (port =3D 0; port < ds->num_ports; port++) {
> 		if (dsa_switch_vlan_match(ds, port, info)) {
> 			err =3D ds->ops->port_vlan_add(ds, port, info->vlan);
> 			if (err)
> 				break;
> 		}
> 	}
>=20
> 	return err;
> }

Having said that, now I finally understand one of the ways in which the
prepare phase was actually useful for something. Sometimes it takes
removing all the code before things like this are visible...

DSA uses notifiers to propagate a switchdev object to multiple ports.
For example, every VLAN is installed not only on the front-panel user
port, but also on the CPU port. Iterating through the port list, we find
that the addition on the user port may succeed, but the addition on the
CPU port might fail.

So, at the very least, we should attempt a rollback on error (iterating
backwards through the port list).

But there is a second problem. Nobody prevents you from adding a VLAN
twice on the same port.

bridge vlan add dev swp0 vid 100
bridge vlan add dev swp0 vid 90-110

If the second command fails at VLAN 110 and we attempt a rollback, we
would end up deleting VLAN 100 too, which was set up by the first command.

This is where the prepare/commit phase could come in handy. First all
the ports confirm that the VLAN range 90-110 is ok, and only then we
proceed to commit it. That would avoid the first problem.

However there's the other problem, which is that artificially splitting
into a prepare and a commit phase will still inevitably leave some
"catastrophic" failures unhandled in the commit phase. We typically
throw our hands up in the air when it comes to these, but normally if we
bother to do something about consistency in the first place, we should
have rollback logic too. It's just that the rollback will not be very
simple. We would need to know, for each VLAN, if it already existed or
not. And if it existed, what flags it had. Either that, or we start
disallowing the user, from the bridge code, to add VLAN objects that
already exist.=
