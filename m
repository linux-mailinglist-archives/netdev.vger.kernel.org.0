Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6483EEC5D
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 14:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239784AbhHQMYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 08:24:50 -0400
Received: from mail-eopbgr10067.outbound.protection.outlook.com ([40.107.1.67]:49413
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235925AbhHQMYt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 08:24:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fSFPQ7kHH2mADo3+RHRae3OYoqbhg9qEN2+b0wap2SKQudaVUbBFZYArumeWhATGOVlY6KorQTtFLmC7/VDGFDOQerUbgF83zzYY/N0AQ1k5iX+4tU/6xFuWVDPd/vzQy9OZO2rRUGcman5BQZTJPIocen6/zApy9hYnpOtmrxki55LIB23kZMsQrK5ZLCS6/ZS8SNTeV7SW19NDrknTTjp1k2VblA1rP4eJ/MZHa2u0Swk9TpKX0cYrvXlsS3CrSeiz3vFdE4KF50PTSTyKmalwoaJ2a33LNSiMGIr9UQc8CnXycSfhwDQuTbBtMRUPWib0Wmkrzkqwlrv54jAn+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Za6J34Bg9UY+V5d6ffOV2ECxSI4Zv0PKn/l/5YML72s=;
 b=BDaCwxxXOvURaSc5s4bLbCFJcT53s8I8+4zBGPb7U2niL1e9h25DAUrMvPAyiMF4LIcdwc/KiNXsPpqkzLug7PW7V9jbYwYIep6V1VbvCNyZums68y8MV/JUfuxvhlZp5nnRXAfaOG8nnBGsB+lUxpq2/y77QL9QzlbIL1up+83GfJ3uVgcCX8+rLrbIqulWNB2Gi0ISeWeQTeBrx4XAPMpw/PG6owMVlPzStd9q91tUYUtKhIst4ht1R6zipNoFu/+bHlZSCeVGoALlS7IEEQVSgv/DgZpmRklVLaU3RIwNqTH+gqSFa2s0D04XlRKFf0+3LTV5fhUpte2Vca2z7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Za6J34Bg9UY+V5d6ffOV2ECxSI4Zv0PKn/l/5YML72s=;
 b=IfuNfXIEq0Np9ZrGI14w3jxGjQg4DRQMkNPTZc3xCPDLEAYzBybl0mwuDG9/YkuYVa082+r3xF/tg7nmshYKVnyVtqtVGq2CiuV5zldC4dIe+d+isPTZkazHjWm5tj4Us9y9uhiV+J+xyWa0vnP0+3arg6Jp9I0Ca7GTg636+2c=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5341.eurprd04.prod.outlook.com (2603:10a6:803:3d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Tue, 17 Aug
 2021 12:24:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 12:24:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: mscc: ocelot: Fix probe for vsc7514
Thread-Topic: [PATCH net-next] net: mscc: ocelot: Fix probe for vsc7514
Thread-Index: AQHXk2BJXYz/rm4ku0ekQilwd9D2sat3ntEA
Date:   Tue, 17 Aug 2021 12:24:12 +0000
Message-ID: <20210817122412.6zjvjbfk3dnyh6uz@skbuf>
References: <20210817120633.404790-1-horatiu.vultur@microchip.com>
In-Reply-To: <20210817120633.404790-1-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af7a0b0c-8ce4-4c5d-688d-08d96179ec09
x-ms-traffictypediagnostic: VI1PR04MB5341:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB534114C862D871B7B0646748E0FE9@VI1PR04MB5341.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QwvsnOh2HUKU0QsjsLH1zElfx4GgLvpI10NNYBjCMgK4dv5gxq3uQEz3FhmH2vkvAMz9yPz46iAdINi1n3/wiwten78gYItLhrPLvrmIJcHCLZ+E+eJOE4F2HUCBsBr6Arm7VZ4fk2nsIIAgX4zOHdpdDRCWW2Pn4s6T7gOfsxt97pwglelOjdRgrukAizd3/f6BR/jISWNNj9Bpiu9F6H+IlhtItRHFaRFHvTrjau4/MJZPLHudhH8VK1EbZ56OX94VLYU2yZy5zOEdU9/HYtyx4PNW7FVgWhnC76EdfUz89jdsou7Df7lYBfUnox/lrWD9yQ9/QXGIPM4glm7TyWHeRvT62LF2SXxVQ7X2qjgkElkXHsW1Mi8w7PFq7o4EenRVb4qXd8WhpbxjtHA39/m4CfxFlorRXyaE/dsQHI8/IYTSvOfoMaPKflSaHzd425taZ/KUVVfgWZqL6UZggUBnjtFS46QTQIIdgtLHDhQXRBmpIMW7jnmDHI/f7x8/p+A+Vw9MFwSgF1oFz9OzZGLXhTV/pwr/neaYUOFjy7VkKQB44vcgQYNtuztSxFsdDr5vfPuUu6XufMSFndD54Nmhd6AkWR1EPAgFEMJhK2CtTCUbUAXFlj/l4CVj97OTMWK7VSPpNgDEWbws1ygnpuDt9s4CVerumeID9DMW8Zhvjx3e+n/j+C1g3y+xjkwh2buPVU5gq6ICI2VBr3jMsw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(376002)(39850400004)(396003)(366004)(136003)(9686003)(6512007)(38070700005)(6506007)(2906002)(5660300002)(53546011)(83380400001)(4326008)(71200400001)(44832011)(8936002)(64756008)(66556008)(66476007)(76116006)(478600001)(66446008)(6916009)(66946007)(8676002)(6486002)(1076003)(186003)(38100700002)(26005)(122000001)(316002)(54906003)(33716001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7OA//vWBFNP6taWRrDcu/An9/PbqztrVsdkVfzg/m/hMV+vKbxm4WX704OJE?=
 =?us-ascii?Q?Yco4cQ6T5fEHmvamEp4xD4BE09RIdjTiXOrK4pQEjWh5/bKhn9MigsnW/FVe?=
 =?us-ascii?Q?xtQO/u5y5fUt2MnBVD8Rzd1Q28lsCVkAaU06MbF3V46M+oCj4D7diePnZCl4?=
 =?us-ascii?Q?0l/MRi5kdytjG7BVl9omWTG6QWv4iv0XbBLYrJaNjORJKaZbo7IgV/9YKk2h?=
 =?us-ascii?Q?AuZSPYliSN7q48rwxS+mkpYB58t5FfHr4HQ5Ni3J7neIR04hlqKcQvChPz/D?=
 =?us-ascii?Q?mtaXlTkAo+zZ7QojZDKwgIu6EIZoqk5HHSAa6pT8YXNCND8KP4LH6BVDLFCl?=
 =?us-ascii?Q?n5+yxsZyLUmk6W5Zfcbqiu43IEBLD0TWMslcwrJpdoKtMGHSLbLo4KrPgcPp?=
 =?us-ascii?Q?W4OLvwasf8u+At9OvzcVAUkLvQlDMS5V+S6JgFJBCamu26tv8kTyJ5JSuiWG?=
 =?us-ascii?Q?/iQU0RErM/59Rx18ooiKnObR1WQX1mPaCTM3rIlWmPsk3+6oPiB43Mlt4Fg/?=
 =?us-ascii?Q?ZI3PV3Fw6jG6LQEiBU+ib1/woVAJUL6kIKGhBx2IixNufKbKhPHp2BFycbOa?=
 =?us-ascii?Q?XncXSqj18TMYtMHASMP45RklzgrWWnmYikX5c8MFtBJ7hKUYDqx2ooS0jtlD?=
 =?us-ascii?Q?2tbuDwnHLQpkI83UJf9CQu7yPLhMy0w0A7fN7xEccyBkpkNcZPni40+iSCfM?=
 =?us-ascii?Q?dedi28/J+TQs67t7f1BXfkeUJMf77fSAawjhL5gke7skLOdcU7KxpW78blDj?=
 =?us-ascii?Q?HqWd6QOdJPYy/aZJz/AYsw9NqkuuLlqTK0KcIQEd9GiMH5v8xRcGdewb9Hbm?=
 =?us-ascii?Q?gTc1Hz/u22/GF8G5k9JEDTXGJq+SXXJfOpZXOL6npxBVr+fbVZLMk1pkcQ6e?=
 =?us-ascii?Q?AXpsrUSfZ4NZCiQPHCACWzw8T36ZwKHR2DQ9yg465FIJeKKci+L0msaOOoon?=
 =?us-ascii?Q?waR8w+usihyqDzsdInmU06lttc7mwWMS9ZW1A968ATdFz/aCMtF0c2t7yMng?=
 =?us-ascii?Q?CVc+fO+glL1btSdpQ7ZGTJK/VYYQLj/WZIuQ4tq7EKy4cpJyPQO3SK+Hxsiy?=
 =?us-ascii?Q?UiJNhaI3sbpB5+8Zx5sdhQ7Jo/52OQPkLZ5sLrs7rSsCVbQB1WFVTKITazHI?=
 =?us-ascii?Q?ufhMVmCpvw4FaE+PMs/hdAsSY0HfIb43h/iPPYanCx/63QgdLAbS2kWCkxKw?=
 =?us-ascii?Q?7mNswBT0NmYAU9ZSuC6Y8vJpyDOH334IIocjjLHyz7Kou7sIsj6tlV+1w8fL?=
 =?us-ascii?Q?DeGfEryEC8dC+YQbMTeSZENiQNjSqh61x8pNywThA55RP6lMb1KWjM8H2n0x?=
 =?us-ascii?Q?V9Ss2b0109GmYIcxoyD3DaBM?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DFD93701AAF3964CAA5D8BC0612112F9@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af7a0b0c-8ce4-4c5d-688d-08d96179ec09
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2021 12:24:12.7822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9XmDAclbm1aDapSm9Y9E1rAWgF1bKDngAYlgP3qO0MnmdRL2yj9zRHHOA0LdSuv5OnsDEX9K44BCOOqiO4fdYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu,

On Tue, Aug 17, 2021 at 02:06:33PM +0200, Horatiu Vultur wrote:
> The check for parsing the 'phy-handle' was removed in the blamed commit.
> Therefor it would try to create phylinks for each port and connect to
> the phys. But on ocelot_pcb123 and ocelot_pcb120 not all the ports have
> a phy, so this will failed. So the probe of the network driver will
> fail.
>=20
> The fix consists in adding back the check for 'phy-handle' for vsc7514
>=20
> Fixes: e6e12df625f2 ("net: mscc: ocelot: convert to phylink")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/eth=
ernet/mscc/ocelot_vsc7514.c
> index 18aed504f45d..96ac64f13382 100644
> --- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> +++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> @@ -954,6 +954,9 @@ static int mscc_ocelot_init_ports(struct platform_dev=
ice *pdev,
>  		if (of_property_read_u32(portnp, "reg", &reg))
>  			continue;
> =20
> +		if (!of_parse_phandle(portnp, "phy-handle", 0))
> +			continue;
> +
>  		port =3D reg;
>  		if (port < 0 || port >=3D ocelot->num_phys_ports) {
>  			dev_err(ocelot->dev,
> --=20
> 2.31.1
>=20

Thanks a lot for taking the time to test!

What do you think about this alternative? It should not limit the driver
to only having phy-handle (having a fixed-link is valid too):

-----------------------------[ cut here ]-----------------------------
From 598f7795389fb127726de199bb77fd7ddf5df096 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 17 Aug 2021 15:14:57 +0300
Subject: [PATCH] net: mscc: ocelot: allow probing to continue with ports th=
at
 fail to register

The existing ocelot device trees, like ocelot_pcb123.dts for example,
have SERDES ports (ports 4 and higher) that do not have status =3D "disable=
d";
but on the other hand do not have a phy-handle or a fixed-link either.

So from the perspective of phylink, they have broken DT bindings.

Since the blamed commit, probing for the entire switch will fail when
such a device tree binding is encountered on a port. There used to be
this piece of code which skipped ports without a phy-handle:

	phy_node =3D of_parse_phandle(portnp, "phy-handle", 0);
	if (!phy_node)
		continue;

but now it is gone.

Anyway, fixed-link setups are a thing which should work out of the box
with phylink, so it would not be in the best interest of the driver to
add that check back.

Instead, let's look at what other drivers do. Since commit 86f8b1c01a0a
("net: dsa: Do not make user port errors fatal"), DSA continues after a
switch port fails to register, and works only with the ports that
succeeded.

We can achieve the same behavior in ocelot by unregistering the devlink
port for ports where ocelot_port_phylink_create() failed (called via
ocelot_probe_port), and clear the bit in devlink_ports_registered for
that port. This will make the next iteration reconsider the port that
failed to probe as an unused port, and re-register a devlink port of
type UNUSED for it. No other cleanup should need to be performed, since
ocelot_probe_port() should be self-contained when it fails.

Fixes: e6e12df625f2 ("net: mscc: ocelot: convert to phylink")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ether=
net/mscc/ocelot_vsc7514.c
index 18aed504f45d..291ae6817c26 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -978,14 +978,15 @@ static int mscc_ocelot_init_ports(struct platform_dev=
ice *pdev,
 			of_node_put(portnp);
 			goto out_teardown;
 		}
-		devlink_ports_registered |=3D BIT(port);
=20
 		err =3D ocelot_probe_port(ocelot, port, target, portnp);
 		if (err) {
-			of_node_put(portnp);
-			goto out_teardown;
+			ocelot_port_devlink_teardown(ocelot, port);
+			continue;
 		}
=20
+		devlink_ports_registered |=3D BIT(port);
+
 		ocelot_port =3D ocelot->ports[port];
 		priv =3D container_of(ocelot_port, struct ocelot_port_private,
 				    port);
-----------------------------[ cut here ]-----------------------------=
