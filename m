Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3D83027A6
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 17:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730683AbhAYQTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 11:19:48 -0500
Received: from mail-eopbgr40089.outbound.protection.outlook.com ([40.107.4.89]:62818
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730676AbhAYQTJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 11:19:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ve7pUa21EsgS2FXTaQbcCE1Wz2ECn9pEtNyrGbpbNWCklYXHIUcA7o3ro67R46wLcaAlZP241DPc4nT6lPU0THgidYSeED9bgD7NjMa4zi8m7d2H/oEPDGUkGG1E7rr55cd9imIREUBlHgHVT8jZP35T8GqbPEK3dZLfW9wxme++0I3leH46l9oovZC71DsofNO9qntKplNIfpOUnjxUcS3ubTEu+riYcnRwJLIf9hEFeig/SCP2fbXPTbCOoY1edJ9GRt3IFocVv6yKs50M6jmaiGHXH7dxp92PatLnsdxuNH5FtCCHC3EZEkZq8i6o6nqb2fDSLXykQlciIvbM2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6cBZChR0eBFle2s38YFt5T0Lr9BsP97Z/SGF7wiD8T0=;
 b=DeMu0wB9/tQFZ6VNV0OnQUg27YK0iGLz96lrPZfWow+sCeVhHiveeNeXi0zcrKDuRlBXyFFMv8lwtRRDf4SyVuITMaHPLoX1cRVhaimck8RuhI3/Omaz+JE1bEgxB9LLJCAK4f6+SNgY9dlk5ljXLMLG+jObTdgvc3GfPhCAnMS3m+5mGiyRI9XwO+UY432jNyWBTIo64VUNfqWexXf/nogsnUS7RAc+GfdCKE8VVm3A8rwXSZ5DQv66q7MDTbDvfx7Lvp9uWIeN0BSvNCnMZKfffHE1gZXv0gyBBEVU0VVyhVlzpSLTx0AXhDoe7ft9I0ZIwb4i2VZjIhIJya+wbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6cBZChR0eBFle2s38YFt5T0Lr9BsP97Z/SGF7wiD8T0=;
 b=sbEpTa3jkB7ex2H1nFeW44HB+6rB0CT0Lg9rqGMTWEPVGmglduhAAIn3eLO3jELqaRbG+mSAAQcP2bZYjfTcMFv/0cizR63EgHCoCAkB0Dav3OHFuwKTrLQ0tuiKfIvxMcTGLCsIjQ+48XoVtb02uDAqriLAodyCKHALp29tgFI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6013.eurprd04.prod.outlook.com (2603:10a6:803:cb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Mon, 25 Jan
 2021 16:18:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%6]) with mapi id 15.20.3784.012; Mon, 25 Jan 2021
 16:18:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH v2 1/2 net-next] net: mscc: ocelot: fix error handling
 bugs in mscc_ocelot_init_ports()
Thread-Topic: [PATCH v2 1/2 net-next] net: mscc: ocelot: fix error handling
 bugs in mscc_ocelot_init_ports()
Thread-Index: AQHW8vYEy9kRVDNRbU2EPw8q4M1MGKo4hWcA
Date:   Mon, 25 Jan 2021 16:18:07 +0000
Message-ID: <20210125161806.q5rmiqj6r3yvp3ke@skbuf>
References: <20210125081940.GK20820@kadam> <YA6EW9SPE4q6x7d3@mwanda>
In-Reply-To: <YA6EW9SPE4q6x7d3@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 91884fd4-bcf4-4610-6151-08d8c14cce50
x-ms-traffictypediagnostic: VI1PR04MB6013:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB6013454AA4B88BE9C3538093E0BD0@VI1PR04MB6013.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5JO+XYdNJCEvc4SbRHqEJir5rvTbrQK96fUhZRx8PoAE6cXXM1OiDgjVgRiolBTDhGWuQ0BB+37+xqjhJvuu8/QoIbDgVTPG6sN8wrnk6DhHojpIaMfRTcof51lt+/a5cdP0O17C2Er8ab9G9S4AzKHWfNF1jx2snGKWE60xwPpHp6VKRzqv8iaQrY/u/iZdvIX1J2kBfS/jyI+2SEKkqVJH7R/mzMMy+1ehNpdmdXdL0SokkOQHV9p73ouFyrjK6Yx1hT7fY/gqUMg4kdF/AjDuwtkbwHoSJHV8nNMR9IIrYUbE73L5WIJRpS7sehD029y5jGBKfiA4aCjQ6FarGqCckZdiEKxl4aOKqnbk9wSWUXtUmFutb5IIIsMFzb6aJFYwwotDqvRUGv6yrpLc9A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(136003)(366004)(346002)(376002)(39850400004)(396003)(6506007)(478600001)(66556008)(91956017)(8676002)(26005)(66946007)(66446008)(4326008)(316002)(66476007)(1076003)(5660300002)(76116006)(186003)(54906003)(64756008)(71200400001)(9686003)(6486002)(6512007)(2906002)(83380400001)(44832011)(33716001)(86362001)(8936002)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?YR8OhqUlAp5FURcyJk2EfKoetLr7eES44jMLBC9UtMEDJH67Cfzmbv7PGIK6?=
 =?us-ascii?Q?9ocr2y6iHhFhYk4Ka/nKR0SU7OpsQ71wjiBZswx/emCR3HGCL4RDHyJu706k?=
 =?us-ascii?Q?J7c/IL9FwprL42y0hrGo2PY0tfsBsF1gkI8o++UbEnDKgkrW/LTK4UMQL7LW?=
 =?us-ascii?Q?JkkuvupDEtweDjgQTNd3Z8onWNeuOwZaRQT5ptaEdFSQaWxzX6/9rhZ0jEmj?=
 =?us-ascii?Q?ISWLHvUjqTLAZ9CQVeQe6o7tUSx3C2eoBImBlYNeuTpTUIrEC9IKLiXNoe+3?=
 =?us-ascii?Q?ynUV8qYshh7fiC/YTCUn8lbegqaUq5KTEwzTHufCmau/YVPVfnWkFDwZhFmQ?=
 =?us-ascii?Q?+OHldc2kzhGbM2SbV0DDlQVlZGA0qQ90JKZfgxHPP+VyAVg8zi8irbEeCviG?=
 =?us-ascii?Q?P7WtX3d6Iv3YRBe7DXItACX7vn/6OLxE2ADpTNI+gXq9hGHATcZwsFgmQ6Cq?=
 =?us-ascii?Q?Oilt/FW38ZwGf6lnubw6W7TtKK9tyQdaIvurz3yUlsdw/G/LdDzXEpnNQOBs?=
 =?us-ascii?Q?8or4RaM91buEuF+HfErWMmBDF7bKfmobJnj7iQtzYhez4fnbV4xwAwCfu14r?=
 =?us-ascii?Q?GXquJrQW/+vZHb1gFkO2Tv49XnZW1XbhkLxpMREJUx8Rq8Mewza15DBL8ttd?=
 =?us-ascii?Q?iCgChR4hTEZ8kE6n9BbvzVK9Hl00o7b0mq3Y8YzjTYqGZqrO6ooDIquzH9js?=
 =?us-ascii?Q?i03LQD6AQrnpA4KwaoxWS2WkytMPG0DopPt//kjvQ6cpplEPtnB9W58AnGxK?=
 =?us-ascii?Q?zm945QKsmvWtGJjOc0wMbK9e36SSOdwVWNs9aMBq35TitW3YV2xKJ2Qud81P?=
 =?us-ascii?Q?f0fb9FLZY38zEDqWdcEs1uK++erykX801nK5qvlAE27yE+pbG2a8iDbss2t0?=
 =?us-ascii?Q?ac0l5CngES0hqjKGfjbQn6feW/sQCtCZiz0+Wi3zjbOkZDxpctvlFpKkHAwB?=
 =?us-ascii?Q?UKUaDyTIrCsxnzhdfyLw8EMFUQAkV+KfU+r5vGPcC0Sm3dQ9+0CKEk1E7alj?=
 =?us-ascii?Q?ktKf1whwPUDmlzvGuDvfpnsMFO6+oXutKXVbY33hPjsaUJGQ+uuvExRLN7VA?=
 =?us-ascii?Q?+RdA9tyu?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <91A6D3EBFDA93F4297412482CD1A7F50@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91884fd4-bcf4-4610-6151-08d8c14cce50
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 16:18:09.5105
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nq9M7Wr5MbUixsi9UA5R8UOUH8ACJeaN9Z/iiIDOK799q8c+2i8a2ypjxyxuoyBH1bZTp2acwVq1udSrn8+HpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6013
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

On Mon, Jan 25, 2021 at 11:42:03AM +0300, Dan Carpenter wrote:
> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/etherne=
t/mscc/ocelot_net.c
> index 9553eb3e441c..875ab8532d8c 100644
> --- a/drivers/net/ethernet/mscc/ocelot_net.c
> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> @@ -1262,7 +1262,6 @@ int ocelot_probe_port(struct ocelot *ocelot, int po=
rt, struct regmap *target,
>  	ocelot_port =3D &priv->port;
>  	ocelot_port->ocelot =3D ocelot;
>  	ocelot_port->target =3D target;
> -	ocelot->ports[port] =3D ocelot_port;

You cannot remove this from here just like that, because
ocelot_init_port right below accesses ocelot->ports[port], and it will
dereference through a NULL pointer otherwise.

>  	dev->netdev_ops =3D &ocelot_port_netdev_ops;
>  	dev->ethtool_ops =3D &ocelot_ethtool_ops;
> @@ -1282,7 +1281,19 @@ int ocelot_probe_port(struct ocelot *ocelot, int p=
ort, struct regmap *target,
>  	if (err) {
>  		dev_err(ocelot->dev, "register_netdev failed\n");
>  		free_netdev(dev);
> +		return err;
>  	}
> =20
> -	return err;
> +	ocelot->ports[port] =3D ocelot_port;
> +	return 0;
> +}
> +
> +void ocelot_release_port(struct ocelot_port *ocelot_port)
> +{
> +	struct ocelot_port_private *priv =3D container_of(ocelot_port,
> +						struct ocelot_port_private,
> +						port);

Can this assignment please be done separately from the declaration?

	struct ocelot_port_private *priv;

	priv =3D container_of(ocelot_port, struct ocelot_port_private, port);

> +
> +	unregister_netdev(priv->dev);
> +	free_netdev(priv->dev);
>  }

Fun, isn't it? :D
Thanks for taking the time to untangle this.

Additionally, you have changed the meaning of "registered_ports" from
"this port had its net_device registered" to "this port had its
devlink_port registered". This is ok, but I would like the variable
renamed now, too. I think devlink_ports_registered would be ok.

In hindsight, I was foolish for using a heap-allocated boolean array for
registered_ports, because this switch architecture is guaranteed to not
have more than 32 ports, so a u32 bitmask is fine.

If you resend, can you please squash this diff on top of your patch?

-----------------------------[cut here]-----------------------------
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/=
mscc/ocelot_net.c
index 1ca531b13497..7b2045707c5a 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1196,6 +1196,7 @@ int ocelot_probe_port(struct ocelot *ocelot, int port=
, struct regmap *target,
 	ocelot_port =3D &priv->port;
 	ocelot_port->ocelot =3D ocelot;
 	ocelot_port->target =3D target;
+	ocelot->ports[port] =3D ocelot_port;
=20
 	dev->netdev_ops =3D &ocelot_port_netdev_ops;
 	dev->ethtool_ops =3D &ocelot_ethtool_ops;
@@ -1215,10 +1216,10 @@ int ocelot_probe_port(struct ocelot *ocelot, int po=
rt, struct regmap *target,
 	if (err) {
 		dev_err(ocelot->dev, "register_netdev failed\n");
 		free_netdev(dev);
+		ocelot->ports[port] =3D NULL;
 		return err;
 	}
=20
-	ocelot->ports[port] =3D ocelot_port;
 	return 0;
 }
=20
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ether=
net/mscc/ocelot_vsc7514.c
index e99b9cdcc4a7..761834466541 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -939,8 +939,8 @@ static int mscc_ocelot_init_ports(struct platform_devic=
e *pdev,
 				  struct device_node *ports)
 {
 	struct ocelot *ocelot =3D platform_get_drvdata(pdev);
+	u32 devlink_ports_registered =3D 0;
 	struct device_node *portnp;
-	bool *registered_ports;
 	int port, err;
 	u32 reg;
=20
@@ -956,11 +956,6 @@ static int mscc_ocelot_init_ports(struct platform_devi=
ce *pdev,
 	if (!ocelot->devlink_ports)
 		return -ENOMEM;
=20
-	registered_ports =3D kcalloc(ocelot->num_phys_ports, sizeof(bool),
-				   GFP_KERNEL);
-	if (!registered_ports)
-		return -ENOMEM;
-
 	for_each_available_child_of_node(ports, portnp) {
 		struct ocelot_port_private *priv;
 		struct ocelot_port *ocelot_port;
@@ -1009,7 +1004,7 @@ static int mscc_ocelot_init_ports(struct platform_dev=
ice *pdev,
 			of_node_put(portnp);
 			goto out_teardown;
 		}
-		registered_ports[port] =3D true;
+		devlink_ports_registered |=3D BIT(port);
=20
 		err =3D ocelot_probe_port(ocelot, port, target, phy);
 		if (err) {
@@ -1069,17 +1064,16 @@ static int mscc_ocelot_init_ports(struct platform_d=
evice *pdev,
=20
 	/* Initialize unused devlink ports at the end */
 	for (port =3D 0; port < ocelot->num_phys_ports; port++) {
-		if (registered_ports[port])
+		if (devlink_ports_registered & BIT(port))
 			continue;
=20
 		err =3D ocelot_port_devlink_init(ocelot, port,
 					       DEVLINK_PORT_FLAVOUR_UNUSED);
 		if (err)
 			goto out_teardown;
-		registered_ports[port] =3D true;
-	}
=20
-	kfree(registered_ports);
+		devlink_ports_registered |=3D BIT(port);
+	}
=20
 	return 0;
=20
@@ -1088,10 +1082,9 @@ static int mscc_ocelot_init_ports(struct platform_de=
vice *pdev,
 	mscc_ocelot_release_ports(ocelot);
 	/* Tear down devlink ports for the registered network interfaces */
 	for (port =3D 0; port < ocelot->num_phys_ports; port++) {
-		if (registered_ports[port])
+		if (devlink_ports_registered & BIT(port))
 			ocelot_port_devlink_teardown(ocelot, port);
 	}
-	kfree(registered_ports);
 	return err;
 }
=20
-----------------------------[cut here]-----------------------------

Then you can add:

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Also, it's strange but I don't see the v2 patches in patchwork. Did you
send them in-reply-to v1 or something?

Thanks!=
