Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A624792F5
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 18:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237663AbhLQRkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 12:40:15 -0500
Received: from mail-eopbgr140057.outbound.protection.outlook.com ([40.107.14.57]:15233
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230326AbhLQRkP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 12:40:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ki1y4bwksxf/uTAQUKXN6E+Fkw01S7XGZslDFsWFDR+wo6Q16UfqsWU1b9o8omRLqkcxdCXZbMwa9zck2u0Ca3765NeqSfOTBSEvfo2E3jn84Vw0YVh5T5WKicu0/ndVfm4r5B2cidnmAI/PB6UKLLipinTLxR0PpzfzW3hlKe4LxlRQENihbJy0jvtczNw+GZ5NG7OgpheP7BW7XzI5aPJlq3PTStm1MRTdXjgIiThK++xHGmM0RFxDkrZnUcFVMQQuyfnB1+1jueLpJ+fAvcSKIkffTCD25/aVTwgRR5NVyK0iTDbUQ9iEeJmK8w9EnwCinmq/CLU5MDLcoIHrTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AKFq1bgWeBJHiWpPBHZGGucTEqZHY+N3iIo8YxWO/+M=;
 b=joShVOsWuyfjpCcD0K7kYtVJpXdVTW0HvrnIAVfOIDUS3oRmrABB+rbLPfpsymMJBeeGGt63eT9fgJAcXBcl9ep1UxM41LBO/hdAyQ7iiqTJA8SNPb4CJKhkXq7ZH25hKQgwcO81GC7dEXco63e3qX1g+cbUeALT746KLaUorBKcKX77kQLEg0dqbDWWr5DDTMXe4+HYngbIPfgAF0tOMrNM71t55KPGRbdF9Xk7vQ8cUNO3UGErZSYkNK2wz3yluML/IWCnfCKhKWabrH2E1HxJKUZpTkpst1ojSemWjc/opSDZTjOkWv3TEI6qfbp0VOUXk386p1teeUKYF0RDjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AKFq1bgWeBJHiWpPBHZGGucTEqZHY+N3iIo8YxWO/+M=;
 b=OuS4YtOS8NQvwYWAYQU9MjqTqhytqJRl+FM+cWaAOCRkGNq0ETLBL7aQaSfJcLrt/tFnvLh35ixu0cpqyNLjjmjvkHvICqETNlpcUeueDGfFd+A0Q3a1uSlbA2tOWT4tmOJd/4lyz7Gqi3XwehKCA1vlfTJo+Hd5JSPlZi4kwZE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5294.eurprd04.prod.outlook.com (2603:10a6:803:5a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Fri, 17 Dec
 2021 17:40:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4801.015; Fri, 17 Dec 2021
 17:40:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v7 8/9] net: lan966x: Extend switchdev bridge
 flags
Thread-Topic: [PATCH net-next v7 8/9] net: lan966x: Extend switchdev bridge
 flags
Thread-Index: AQHX8143qV6KlHecU0+fH+ACGy7jyKw2834A
Date:   Fri, 17 Dec 2021 17:40:00 +0000
Message-ID: <20211217174000.febeewxdio6dbmb6@skbuf>
References: <20211217155353.460594-1-horatiu.vultur@microchip.com>
 <20211217155353.460594-9-horatiu.vultur@microchip.com>
In-Reply-To: <20211217155353.460594-9-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a64b751d-ca8e-44dd-dda3-08d9c184402c
x-ms-traffictypediagnostic: VI1PR04MB5294:EE_
x-microsoft-antispam-prvs: <VI1PR04MB5294AEAFB6D635D96707DD11E0789@VI1PR04MB5294.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SXTuO+ILBXy631HAGzHAX2PcmVrR3QA+IYpoR5AcdIMcw65ocb7jEd+hhhCFgMNuiFehUr6yV06zvlbjvpeVyKgO/58qWDPVXdrl7/0CFeYHql8zpnJ1Aq/uKuiKmM9BF/mjIxPJXaqWVrePf1rHp+1T5vfoS9+1yJ+pBen/BShfPdSNJXtjCeNktdFRDYUSuwUL9T5yp+9EADZ5sGWZCbjoHJ4nuOlQ4TjKnMjdVNKBhXmxlYsaRCHy8Pta3itN2RYaBTMLi6D3eSAZMJlRNsy/io4MBMq7Zyr6NOC6QK8FwlTYQb/g4zNUA+f+tRa7AAlLgpoz0yxvYDmkatnGWMpVvedlOJ8Ggd24wpynQcz8U2cCJO2mcVzWY9m6vdc8APXKsPT3k6keUkt7Nzjn6y5D5mKfEDrxjUkqZCdRXksaLiQZyUQ4tpQxm1xW6Q6zOLWq5ErxMSeuv7xnL9kewF+YfM4aW18+JDYniSh+JFVhzsvre3wk0NwJsN4mb54CaXV/4mc1e2+ZYU/DZpNktoB2srlMh4rJVt2fdzHFTmmeZvo8DiplNrXGbPsku5Fk3/4tEEt6f0XfOLybSNwUErjU7oV0x1lGjP3BxSjiRQK/Is+GD31+9x5pE3tyLCHPJ7qCtCe6LWID8axNxO7+WZxQl+BaP/uALeTQW+4v1ybj0y5To2wZ4ERCpMz8UeK1ASbuYn/afqMxNL+EnX0vqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(8676002)(6506007)(6486002)(71200400001)(38070700005)(26005)(186003)(9686003)(6512007)(54906003)(6916009)(86362001)(8936002)(508600001)(5660300002)(316002)(122000001)(38100700002)(7416002)(66446008)(64756008)(66476007)(44832011)(83380400001)(66556008)(66946007)(76116006)(4326008)(1076003)(33716001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pKLGi2HHr63A1ukJwp4mNbDaOswb3S57D1aRc6EK6/xPjROhO1bYpLzQ/UzF?=
 =?us-ascii?Q?l2e3TKRRYWvjHSiNXZtootXIKrNjrVazT5uOL8qL1hxf4QUOvFPnTrQ7Bga3?=
 =?us-ascii?Q?nOkJWNtq4O+AOU32BAuCmuKam3F11HkkDU2osNfz7960f9IW/QxtUIPJEJG8?=
 =?us-ascii?Q?CEP3fvFet0LnM4i+YaL75IQ12xzvfq/stFapXHLPH9+Pk57M8f4x6iwfBVqv?=
 =?us-ascii?Q?uetoAB3mwywiYl16AaFgCcQ58qTE5i1MjosEV9MaccQSj7JabzvNg2F0/doW?=
 =?us-ascii?Q?58UbVO7vTxs5zrxJYnijRTT7LV5f0QcWaYz09tZ+OcsDACUvLaTlaEbXPGpN?=
 =?us-ascii?Q?fiDHwSIv5hW1KGA5AkiJ9RTPvMhu5YgfKHzgSHLeRvu3TN7DWy/R2/nx5tI2?=
 =?us-ascii?Q?RkQWs1nFaaGZKu+m+d8b1WSaAqP9HLicwfMTwy4hv8u1a6xZaTW6B3pF7N1d?=
 =?us-ascii?Q?Ev7h3iYOMWluwr9uLRQifdWQzAdoHwzGVO27euvTjX0jHicYQZA6iVEmdMAM?=
 =?us-ascii?Q?saILQr6XSE7in5btZ8TDQpJuxcXScmlulbvNP8w8B1d0wS3PR2toFDFby5KE?=
 =?us-ascii?Q?Ld/TWvpJrwj1QbrL9fjlmHgY6jYESlHdLDA9YLADnutUsf/IwiGxb/3yM9Ln?=
 =?us-ascii?Q?B//KA25rT9lyzc6UergbLjgEYngXiTASHTuNGdzpchWziE+REyUG715GrLYU?=
 =?us-ascii?Q?TAQ+CT+d8ZyQ26qZueYcZDW21vZNsB2dYoExhDXjrqglBuDBX3vfLvWzgenp?=
 =?us-ascii?Q?3KrVZFbIRrVvs6zsGC0cQvngQwTnKXIX3luUNSC1xGn56K5/W2CJukmsuvQB?=
 =?us-ascii?Q?xQ9m7j2IvB97tfuTppC7ZOIsyTPg6zonh9xxIccnnk2p73gx8HmDUaeA7RWg?=
 =?us-ascii?Q?KHowgxqr3RksfekdT89AP/zFVUisDQxKZqntHS5WwgxqjG6XbNBQy6ssG/30?=
 =?us-ascii?Q?pDBklIaBiM+tRmtgoG2mgVtU8mQIANoMu4EO/b5G34HCELq4PQixJOHkD6gt?=
 =?us-ascii?Q?fmj+vbiz3rwALdZqw5qSxCzRjeUY9csZkLYKQSE1vo5nzbUJgLTGvt6UD9GX?=
 =?us-ascii?Q?HBbdg0Ly+c0QY4TYNNrhLKQltGnOynH/p2LhGuhJGY4x5T9HtvySif1+dBy/?=
 =?us-ascii?Q?DuyFw+tmslNCLHqgHnaqrDl/+nby6JnTc9UpsmYY9SP5g6xlgIx45DSPEdAk?=
 =?us-ascii?Q?XfvCckaz0ciD/lvDetevCj5YxC4TNMfJlUA9y787DsNTZ8+viIF/1kcd4F01?=
 =?us-ascii?Q?zqBef1FuTqcGoaNWSk69aviQjPSQ9VAo/9jiQZhEvAQijn7B/ghIBRObMivA?=
 =?us-ascii?Q?3XbyqDW6lAR6KN6vYWZrvRyi/lID/8nOrFjv6S5pRlj6uWozs2VDIA2fpaTd?=
 =?us-ascii?Q?Uw69z0uvcvUemXztCUQE3qysZIwFOgodhEZezK/suD7E3lxoQStaZAgFSMlD?=
 =?us-ascii?Q?s4RC9XIhB+baX6oTVzmAKnCKKfpW1wDh+oFl7QBeI/F/TaGr1ePyLC/KY0sy?=
 =?us-ascii?Q?lJ/yV/NhVa1e1uWhio1v8QBdIEeksru5SJCUeQPNjm7vCFadZKpo2Dok+JMS?=
 =?us-ascii?Q?BNk6mwV7oUyjb8WeAtvi8MQ7P4jPOOGN8ScIpvu6RymuDWTbExDh00aQBRmt?=
 =?us-ascii?Q?16Yyw3aJDFupLgXWKZFD9c4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <981EE02D15E2C04CBD1AA5E638590CA1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a64b751d-ca8e-44dd-dda3-08d9c184402c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2021 17:40:00.5536
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rrLZlWFUVDRdTUB36RW8Svp4Ul5CMOz8cikh56UEbQ+mBIc2ImjcO0Nu3q5ZGRGhTiYfFfDYKZmG4BR13NYApg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5294
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 04:53:52PM +0100, Horatiu Vultur wrote:
> Currently allow a port to be part or not of the multicast flooding mask.
> By implementing the switchdev calls SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS
> and SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS.
>=20
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../microchip/lan966x/lan966x_switchdev.c     | 34 +++++++++++++++++++
>  1 file changed, 34 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b=
/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> index cef9e690fb82..af227b33cb3f 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
> @@ -9,6 +9,34 @@ static struct notifier_block lan966x_netdevice_nb __read=
_mostly;
>  static struct notifier_block lan966x_switchdev_nb __read_mostly;
>  static struct notifier_block lan966x_switchdev_blocking_nb __read_mostly=
;
> =20
> +static void lan966x_port_bridge_flags(struct lan966x_port *port,
> +				      struct switchdev_brport_flags flags)
> +{
> +	u32 val =3D lan_rd(port->lan966x, ANA_PGID(PGID_MC));
> +
> +	val =3D ANA_PGID_PGID_GET(val);

Ideally you'd want to read PGID_MC only if you know that BR_MCAST_FLOOD
is the flag getting changed. Otherwise you'd have to refactor this when
you add support for more brport flags.

> +
> +	if (flags.mask & BR_MCAST_FLOOD) {
> +		if (flags.val & BR_MCAST_FLOOD)
> +			val |=3D BIT(port->chip_port);
> +		else
> +			val &=3D ~BIT(port->chip_port);
> +	}
> +
> +	lan_rmw(ANA_PGID_PGID_SET(val),
> +		ANA_PGID_PGID,
> +		port->lan966x, ANA_PGID(PGID_MC));
> +}
> +
> +static int lan966x_port_pre_bridge_flags(struct lan966x_port *port,
> +					 struct switchdev_brport_flags flags)
> +{
> +	if (flags.mask & ~BR_MCAST_FLOOD)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>  static void lan966x_update_fwd_mask(struct lan966x *lan966x)
>  {
>  	int i;
> @@ -67,6 +95,12 @@ static int lan966x_port_attr_set(struct net_device *de=
v, const void *ctx,
>  		return 0;
> =20
>  	switch (attr->id) {
> +	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
> +		lan966x_port_bridge_flags(port, attr->u.brport_flags);
> +		break;
> +	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
> +		err =3D lan966x_port_pre_bridge_flags(port, attr->u.brport_flags);
> +		break;
>  	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
>  		lan966x_port_stp_state_set(port, attr->u.stp_state);
>  		break;
> --=20
> 2.33.0
>=
