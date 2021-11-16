Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91213453C70
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 23:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhKPW7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 17:59:55 -0500
Received: from mail-eopbgr140088.outbound.protection.outlook.com ([40.107.14.88]:12561
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230411AbhKPW7y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 17:59:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NBKS1Fodk8KfcqSs5JYlOIYNXlS9D3OQYCze7efnfgv93WcKydjJpKW98B0TdEE/wd82Zst/g344+NrHPdOTJvYbbFinVDsqWb87Zb54L/y2DHl2uE53okScnceWzQeC/GiGFw6z+pTUK8AmS8k8M9y6aVON+OQW58ivju0w7dWG8I3mRB7gM1gLpkHOZQiyX6uNJZNTo+3UmGWHNWScpYRa9GQ8fvZeIsmf7OOOT1ugYNF09Wh8nTP7qm6mEOlP3ecx5GpaXX5gxjlahko1kHnr8Asv9Y3d/0YFhe5PeAXP+BrYZkn6wZqiPBzfhOlPWisSHUDD3yKpiE2M1jFb1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dclFSzQl6MNo0jhIqoQuk2QrjP3FlYVRfxUROW1pRnc=;
 b=YQBAIM/xk8mafIGkPz7+bVFsXwpnTbOQuO1X1Oscnso6lacmSYHftun8hXktr4BHg8CDCrXwcjMQe369xegtT7S7We1q0qlrRsYTTKpeTldw83DoZQpH9OPLqBs4CEPBtJxUrOdevu9tfnGwfY4lI8aBmxmCmjYPoQc5sntwEpgJ8k531UaPQHV1CyJu4z98BcKIDUF2ZZBVa+FGQdolx8OjnPG5rMb7FR5I5vzP7D1wPLbFVTY910hwIHnK6IAmXxLEpxUEM1B9oLypmwGUqufB0d906igeoTMTlj0nnEb2ZpSnm4tYwnKrvukXGKKkIksZ1OpU66ST0Puvr77s/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dclFSzQl6MNo0jhIqoQuk2QrjP3FlYVRfxUROW1pRnc=;
 b=UvHc4x87ZYo0o+RFqzJpEidpouq43KfZEZPFtLJ+IgqJAkSiCsQ1VvCtCjOXcQRdXIybQRLxvbd+O/IE/n1XiEhlTdtPTXoIA1xZ+dWUxgXFPSlZTOMdeVJu4mdVaQ0QJ7H23pFeSokix7vhATH2tFDCWJwfUTJhZ1ueaPHoDWY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3199.eurprd04.prod.outlook.com (2603:10a6:802:3::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Tue, 16 Nov
 2021 22:56:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4669.022; Tue, 16 Nov 2021
 22:56:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [RFC PATCH v4 net-next 00/23] add support for VSC75XX control
 over SPI
Thread-Topic: [RFC PATCH v4 net-next 00/23] add support for VSC75XX control
 over SPI
Thread-Index: AQHX2rKEbcpEShKMr0uAL3+1lm3+rawGxRgA
Date:   Tue, 16 Nov 2021 22:56:54 +0000
Message-ID: <20211116225652.nlw3wkktc5c572bv@skbuf>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
In-Reply-To: <20211116062328.1949151-1-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1dfd48b2-c5e6-41bb-907d-08d9a9546297
x-ms-traffictypediagnostic: VI1PR04MB3199:
x-microsoft-antispam-prvs: <VI1PR04MB3199BAA2975A4B13E03B3C13E0999@VI1PR04MB3199.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YXKsafhj12p3ChgPEKFs4aETIyWRvQB8B4PBVYfUiPdQc+tCLG/565Z3QBS1HzWPGUiSlkvFQ7I3GjXtCkjpGTntijQxE4HPXQg1p1WjDtu7VkfWzkHYKTDupTV9MLYs9Ty8Ys7roPOmGECWb29GEs1sH+1KAlnoQ3ZnkQyDIgIzE9inF5FC7Z99t43TGONmpKNsuZc80benEnyGNK/ud/D8OV99+E7pGlV64x5RUAyMb/D+7oUPPJZHvcg+iTeMEWLaAv7folN26SLZUxVBTPSXXwsmKLRIc/xdagNdFJVFlgMOOzPSMUFzT+QcRW8NS+RveAzj7astro8WWZuJWstVNOtS7burrV0dmwxOL73nJJnsVLx2JOtqkLNIIdnWQGsb1rg7us1aCxB+MEYWUk1LQ0Qo9smEjA0gnvhURzpfIi5EZbBOSC50aNK1NBpIXQiTbtewlJuvQNZtRrHwt0hnRRZSQFyIM+v+Oxq32RNl1gTGAleefuhEdj+UNvJyQtwA62LpF8PiN6zqSEs6abQcNixGBP+T/97sRi6EII5iIvTee51E0iM/JHZ5cLL/VCqA7IyJPSZkWqDPF0uqO7YfB/qtmOg+66r0CEciEseJkP8i24TFDFkoO6R+Er7r6Jz3gVYdqm0txMiZpXVc3vSnamztvBFBIa1jJBp1TGsILPLySS+nCwJaurPjYUWMkdW35BUHe52HQHGUkfuTUZd1lHvF/qRk9x6cA8tXgcH9nnOKcZKq6J/YvWxyNxJ680ye5PHC/H+hqmwzKOwoLa29w7GdVn/ONMdhrUWPclk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(76116006)(122000001)(186003)(38100700002)(8936002)(91956017)(966005)(44832011)(86362001)(7416002)(316002)(83380400001)(4326008)(6916009)(6506007)(71200400001)(2906002)(33716001)(54906003)(8676002)(1076003)(66446008)(66946007)(26005)(66556008)(66476007)(64756008)(38070700005)(6512007)(6486002)(508600001)(9686003)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/2ijKKCUhqFRKg5xRRPXNd8A3LbpufhQpsqWNAu99pzPUC7yEhTzVPEhmPlu?=
 =?us-ascii?Q?yEIRmiCnxfuppkkfBSLUWvgoD7FWvkAvyXbvO2qjL03fPbXE/r/plhfOLiaf?=
 =?us-ascii?Q?Axo6ALOeF39tWaaEaesVUKXP73GhIXqlwvz3nDBDBDGAql/1AiSAg4amXYJR?=
 =?us-ascii?Q?f8j8i0/587QpkZ+QZoXABjPmXuDLeX3MnsrinSsIIrdE0YGYTwi5Wa/01ITc?=
 =?us-ascii?Q?zb4VHMFzMucn/Jr4SnTd837BIM1G9Gg1yK5zV/cddY8O+UbdYC4gRlttv2Kt?=
 =?us-ascii?Q?uZbczQPSatBQskor+San62Tn7XZS/Sj4wYHXOkvsOg/ILosy9tzcAN9moAqt?=
 =?us-ascii?Q?HL1DDtTf0ZcApyAZzM1Ik8iAoIYBuKufv/yrg2dXiueIuyha37Xl0q9busmD?=
 =?us-ascii?Q?YkPlvEtGSTK1Z/iWcZZEgwbWLY+lvxgqgRCDVAaxVnUMpfLoy760R7I/j9ll?=
 =?us-ascii?Q?raE3QwG1lcPjKE+9D3EIIltZRPxeCIbaz4r/DZS9GdXOp+qzAqydmhgkrohV?=
 =?us-ascii?Q?Jcbwip06ILAkXJl7rYxT4/ipCiyEwfRljejSvmfHfe8hIDQvRnN0YRIAVDKe?=
 =?us-ascii?Q?+AE3q1qrAHGwEps5+vL1wPlgks3tksCmU0dZJAnX04kmoKiR6SsbsJrpUJJU?=
 =?us-ascii?Q?G3u/8pyahtcl0SCDXij37Q4f1Refgh3rhFIs7jJ8HeT825sPaXjYlsAmoec0?=
 =?us-ascii?Q?ntHt7mh7AjS9Iv7waMQ5zsQwroVwmDB5fkVgX543Olz+G/sdZHMFP9m5xXCY?=
 =?us-ascii?Q?FRw1Rbu2Cu2x6hZzCjaJ0syOAhuGQfE4p4J1EMvYnZb/AObhUgUDI+y1eW9I?=
 =?us-ascii?Q?gwuRM3iAJ3k4/AY0sLdXrg757R9FuPjzRqdAd062pLsA25NGgoB1WApHzLfe?=
 =?us-ascii?Q?kpADGxVXUmDMbZaicoMHaPU5UqPL9fqRA5t0idf8Hgu2mtydu0WfmYaTIHWq?=
 =?us-ascii?Q?QDozACIY5hXEwNnHaGcy37AULvz95eXWOkV2hHO0mNzG6xZ+BL/0OLagvr40?=
 =?us-ascii?Q?+wLEf/oeRcB7gyvkMle4xKGdUgciRNjdx81xKV22sI7IyVPyDMcE4R+erapV?=
 =?us-ascii?Q?gf714FJMILbQmTkgKDEddWMRN9IqEefE9/oL2jGdGrlnmrQlxghMXuqj88Z0?=
 =?us-ascii?Q?TQNsFfCIYHnpkpMNjcjTdQ7PC8uHdY4wUmOZ2uJhOsfxiuoXJ+1AipxiJpZh?=
 =?us-ascii?Q?RUIpXaHhFxeJNDog+PDm9cAdYUJaV42U3p2m1D0pDd8vYjk2MmyiTnaUrj6F?=
 =?us-ascii?Q?35lwR5n6FZJDmKiwxl5hIzLx46ova5mzxxeAR+y/+z/pzr0x3ycgZjz7ZMVO?=
 =?us-ascii?Q?FjN7fxp9GfztIpne4u1F+QyDkl5ORsBylu78FW0p1iP/i3pRjZdKsuREsGLn?=
 =?us-ascii?Q?8cDVhgPOyf/LQywGqA4Goyo3qrS+iHWIgHWU8yB6q22OfrcUh3lfiuluWS1/?=
 =?us-ascii?Q?uUbwQAw3mG+P6wxPQLHLbNRCFdufIR8bCqNamOYq19J1m/TSMatUscQMYm+e?=
 =?us-ascii?Q?SjOYSSsRzUBUDscBwxuJx6ZFPL/hnjjky0CpYcRqkEPQvrOHPeD+FEg/q4Lw?=
 =?us-ascii?Q?S2Xwam1UJehF4VZR5Z7grrVd3sLQLudvRKQJJ2IU+xvxyYCVLFP4v/Xmwo/n?=
 =?us-ascii?Q?YpMJHlQbiwxk65fyofgza34VFB42zjUQzydjCJcXEtOB?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BD1826CBF4F50C4195AF49B995865CD0@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dfd48b2-c5e6-41bb-907d-08d9a9546297
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2021 22:56:54.5373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P/gfSaIbg3FJLdo6uTsAHAUc0CRYO/md35l8mYF7kxQ6hKFC5pom9Rsl5iZysBMyVigIbIsHI6I7lYQuAVKQyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3199
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 10:23:05PM -0800, Colin Foster wrote:
> My apologies for this next RFC taking so long. Life got in the way.
>=20
>=20
> The patch set in general is to add support for the VSC7511, VSC7512,
> VSC7513 and VSC7514 devices controlled over SPI. The driver is
> relatively functional for the internal phy ports (0-3) on the VSC7512.
> As I'll discuss, it is not yet functional for other ports yet.
>=20
>=20
> I still think there are enough updates to bounce by the community
> in case I'm terribly off base or doomed to chase my tail.

I wanted to do some regression-testing with this patch set on the
Seville switch, but up until now I've been trying to actually make it
compile. See the changes required for that. Note that "can compile"
doesn't mean "can compile without warnings". Please check the build
reports on each individual patch on Patchwork and make sure the next
submission is warning-free. Note that there's a considerable amount of
drivers to build-test in both on and off configurations.
https://patchwork.kernel.org/project/netdevbpf/patch/20211116062328.1949151=
-21-colin.foster@in-advantage.com/

-- >8 ---------------------------------------------------------------------=
----
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelo=
t/felix_vsc9959.c
index b1032b7abaea..fbe78357ca94 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1127,11 +1127,13 @@ static void vsc9959_mdio_bus_free(struct ocelot *oc=
elot)
=20
 	for (port =3D 0; port < ocelot->num_phys_ports; port++) {
 		struct phylink_pcs *phylink_pcs =3D felix->pcs[port];
+		struct mdio_device *mdio_device;
=20
 		if (!phylink_pcs)
 			continue;
=20
-		mdio_device_free(phylink_pcs->mdio);
+		mdio_device =3D lynx_get_mdio_device(phylink_pcs);
+		mdio_device_free(mdio_device);
 		lynx_pcs_destroy(phylink_pcs);
 	}
 	mdiobus_unregister(felix->imdio);
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/oce=
lot/seville_vsc9953.c
index 268c09042824..12a87d8f977d 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1037,7 +1037,7 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocel=
ot)
 			continue;
=20
 		mdio_device =3D mdio_device_create(felix->imdio, addr);
-		if (IS_ERR(pcs))
+		if (IS_ERR(mdio_device))
 			continue;
=20
 		phylink_pcs =3D lynx_pcs_create(mdio_device);
@@ -1066,7 +1066,7 @@ static void vsc9953_mdio_bus_free(struct ocelot *ocel=
ot)
 		if (!phylink_pcs)
 			continue;
=20
-		mdio_device =3D lynx_pcs_get_mdio(phylink_pcs);
+		mdio_device =3D lynx_get_mdio_device(phylink_pcs);
 		mdio_device_free(mdio_device);
 		lynx_pcs_destroy(phylink_pcs);
 	}
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/=
ethernet/freescale/enetc/enetc_pf.c
index 3d93ac1376c6..3ab581b777eb 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -8,6 +8,7 @@
 #include <linux/of_platform.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
+#include <linux/pcs-lynx.h>
 #include "enetc_ierb.h"
 #include "enetc_pf.h"
=20
@@ -983,7 +984,7 @@ static void enetc_pl_mac_config(struct phylink_config *=
config,
=20
 	priv =3D netdev_priv(pf->si->ndev);
 	if (pf->pcs)
-		phylink_set_pcs(priv->phylink, &pf->pcs);
+		phylink_set_pcs(priv->phylink, pf->pcs);
 }
=20
 static void enetc_force_rgmii_mac(struct enetc_hw *hw, int speed, int dupl=
ex)
diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-oce=
lot.c
index f8d2494b335c..5f9fc9252c79 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
+#include <soc/mscc/ocelot.h>
=20
 #include "core.h"
 #include "pinconf.h"
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 6aeb7eac73f5..7571becba545 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -946,11 +946,12 @@ int ocelot_pinctrl_core_probe(struct device *dev,
 			      struct regmap *pincfg_base, u32 pincfg_offset,
 			      struct device_node *device_node);
 #else
-int ocelot_pinctrl_core_probe(struct device *dev,
-			      struct pinctrl_desc *pinctrl_desc,
-			      struct regmap *regmap_base, u32 regmap_offset,
-			      struct regmap *pincfg_base, u32 pincfg_offset,
-			      struct device_node *device_node)
+static inline int
+ocelot_pinctrl_core_probe(struct device *dev,
+			  struct pinctrl_desc *pinctrl_desc,
+			  struct regmap *regmap_base, u32 regmap_offset,
+			  struct regmap *pincfg_base, u32 pincfg_offset,
+			  struct device_node *device_node)
 {
 	return -EOPNOTSUPP;
 }
@@ -960,8 +961,9 @@ int ocelot_pinctrl_core_probe(struct device *dev,
 int microchip_sgpio_core_probe(struct device *dev, struct device_node *nod=
e,
 			       struct regmap *regmap, u32 offset);
 #else
-int microchip_sgpio_core_probe(struct device *dev, struct device_node *nod=
e,
-			       struct regmap *regmap, u32 offset)
+static inline int
+microchip_sgpio_core_probe(struct device *dev, struct device_node *node,
+			   struct regmap *regmap, u32 offset)
 {
 	return -EOPNOTSUPP;
 }
-- >8 ---------------------------------------------------------------------=
----=
