Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32DC439004D
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 13:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbhEYLtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 07:49:33 -0400
Received: from mail-eopbgr00082.outbound.protection.outlook.com ([40.107.0.82]:23566
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231370AbhEYLtc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 07:49:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QPTcF5yR4bTBx+sHjRwZRk0RVSuV1ZkEXzDOSjb4K4N+qHWMuTct6lKMAzpTWaMR+f4b5O1WKmuLjTk1+Vy5CLO5MR4IaCSIq37dEYhZUaVvIvVRsERMoyGeqIyZrCq13i1IOjQ17HV1Em3PyVIxpaqhDBw9De5Ak6vuKxzSratV+HlkSAw1hJqakJXhik2GndOL10y3ZKrrNKdDxENq44dLs1fIyRE9W1co8mxRKKbQ/iLfsCN/bN8sdIcmSC/vEpEGeyhcr9Beu7QUStRWMBYBYWYINLIz8ubKc4BFB61KUUp/CTU9RCSn7sgADsQ3aDGrfvyKwKto08rb2p1j9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7tN8vIAvEziiqCuXJsHijImxdM/fVrTFQxQDQiHFpOY=;
 b=SIEHwi6GMzu2hedUXhcBLzDHTXYg+IJxln4UqyWWLJygUewXRaQkpjawddrrT4Ekz828pGB3QgziiqDqsUpZc8uzmTHMzTm0M6GUsmC883T0Sfmbvu5VScqNzcHjo1z4VkVV4u/QccOew5OcEnK+Fnvpa50iXLDV0rIQr8Owd5QHMJGNSIGZJqfsyGKtyQj3FKs2jdT5PNsuuwb9x3H0/98AX3tQOIOFURStnwAqA0nPzD32uWk0YwsnCiEmL++GCFZFYgdi6sgQlkwkswWQthMhB1OFqf+6+aBsX8db9yT3DbjhwxSf+1Ms//bRdoq93QWK1Xq6SPpiRSBI94hO2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7tN8vIAvEziiqCuXJsHijImxdM/fVrTFQxQDQiHFpOY=;
 b=FhTB3xfdS+ToYJoj6sdg52K3Or1kkX5S4rOH9iV5HGVg5ohnWWoTYVjzeCxckz+sP+mqP8gswyR5OreMjzayw73L623S37UDOVSS1yVJSu3UaF4aepPrACvi3QKKSaUpNpD5Qa1zH/HUq7Zvild9y1PFPWC2/3rk5BSgw2DBilE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6640.eurprd04.prod.outlook.com (2603:10a6:803:122::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Tue, 25 May
 2021 11:48:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4150.027; Tue, 25 May 2021
 11:48:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 13/13] net: dsa: sja1105: add support for the
 SJA1110 SGMII/2500base-x PCS
Thread-Topic: [PATCH net-next 13/13] net: dsa: sja1105: add support for the
 SJA1110 SGMII/2500base-x PCS
Thread-Index: AQHXUPOxr8W5cKpgckyEJUYHi/Aj/arzfIYAgACZMIA=
Date:   Tue, 25 May 2021 11:47:59 +0000
Message-ID: <20210525114759.77pkwuw36nueid3c@skbuf>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <20210524232214.1378937-14-olteanv@gmail.com>
 <65f1ea13-801b-f808-3cc1-4129ba3b14b9@gmail.com>
In-Reply-To: <65f1ea13-801b-f808-3cc1-4129ba3b14b9@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.52.84]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4555757f-2060-4397-77f5-08d91f72f239
x-ms-traffictypediagnostic: VE1PR04MB6640:
x-microsoft-antispam-prvs: <VE1PR04MB6640241220F7EBEBC94DEA60E0259@VE1PR04MB6640.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3PwPQ+3nxkOhQdGjskI6m59G41L0JV0IW9EMUsRvA32WmmOvYoaGDOrLKHlZoNCPe7xk4M5VQ2rQ9+Y/JK+2FAtA7WI/E+ziWjfBaAguYssIaGAf1sUCo0Pw74d9AaJXH9mlN3XGVvZO2IBEWIQDWaijpjDbarrsyGSj8DJgPjubAbeYMrwqkMhFJtsvrGCo6vPP0UNfIXot2eS4Yev2j3SWgS7nUhkF6J2gwU+Bys8H1J4s9FdmFhRReI8E68B7boL1tg9Ze4OrS+4J9ihpHCglfcmEfodKR3mAVinst7G+xVdbbL0hAvSbVFgkmNSP1BGsxzk4oLCfhHGOKL5BJ+65bKF04R0DTCRCMAyS0S6Rgtg33xeZOIbHIM+6rh6S81WeuMok7ZqWtT+z1o3XoUT4GfL0G5/suIkW39EzdclhSiMcd5PbF1URsHLtIqJiobjZA3Ggov72QvPu+DgFMVykQoQwYtPlOVc6RT8lcNBlXLsxXiYvOAslLePUbMcinnmqkPI6wztyHSkwr1nFAlite915BQThrenjlLAWUi4CBs0P3OsYLe8i9AjsppQ7/HmOtx6M7/Vw5lehrg1pMPMqWSlT64kYyyc5FQ8LjPM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(86362001)(44832011)(71200400001)(83380400001)(2906002)(122000001)(8936002)(38100700002)(26005)(498600001)(6486002)(8676002)(64756008)(9686003)(66556008)(76116006)(53546011)(6506007)(186003)(4326008)(54906003)(1076003)(66946007)(6916009)(33716001)(5660300002)(66446008)(6512007)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?CEYh79BMLcBb+br1lUclFZIASgoMuABpmT4CySfjrw5NeyK70fq5eihvu0tV?=
 =?us-ascii?Q?ZLtBPu0pxywSjxXWqg5NBRtg24148lKLGfD4M0bfYSl3V+/Hj2k4uosdJblI?=
 =?us-ascii?Q?Pr6P1O3g+NN8ZACyqh/ztaAedbTGfZsIfP7Rkrn957cpRiYxs+Qxiswdnzed?=
 =?us-ascii?Q?RJIcLOjG9krMJU2pXHPnbdLhtZzY2mfJlHjrZOzB+L+wBJJhhUXq+MhX3XLx?=
 =?us-ascii?Q?i/c7ujEZWS/jwzMrFqzbWAWSrSa+9yyNe3/MXLRmxvDOBDQJC0jkmbu2q7gg?=
 =?us-ascii?Q?/0qbmjl2G8mlPgFm/w3qpaLLHiGeiYb17GwEbeAobC3Qs8ThOoY3e6ebkJdv?=
 =?us-ascii?Q?diOUmugSNbesB82QUjT5fxXtbmm5QmExTAl7WTyx0XFQiMspnmhkuyT75iSs?=
 =?us-ascii?Q?GlrmWpkykSoVWhJzvdJa3sMG4cI7W2ZX35Ba/Ot3/EtqwJZBvkpZY1GTE8H1?=
 =?us-ascii?Q?zQhvs+LdPovYU353D8qt8O3b57bVcytsFl/8uCh4KxkKoPqX+XiYwwCMyCpj?=
 =?us-ascii?Q?QoVzjyeC4T8ZTxzPLrfp2voDiWVQD3n0FrgRitaeYk284q7Fvr2R5idYg6jF?=
 =?us-ascii?Q?7yW7HXOZXDCWQRgxp5Vpj3aaPd4WiVFnjWaaEv4o1O8cqtrA896Ksn4vMneu?=
 =?us-ascii?Q?ugcsKP4NGjYMoICBo/dV2myak0qpKXhVNj+vOw07Xdb4lF0r/7H46B+qdhfz?=
 =?us-ascii?Q?w69ItOKghdxIzDieET1v/lPMrKlO4YKjeamNutUrqoEkEFUMYDm8OvUFioc9?=
 =?us-ascii?Q?FBHoQa5i/yL1jAovmVvpCMdyVZK6tXnZpT2XZNk6Jl6eJwN1tGf1miFM3BDG?=
 =?us-ascii?Q?t+2s5taqvmG8L7X0Q8FHVC2xT1IxyXdjxe1JWq4MgZPj3Ah7m3pOb5Zr688J?=
 =?us-ascii?Q?IzmadU0ph6yeFPCnmHspjZYSgbGDNGudL1LGoCohvUqqBzvYEbqLiXfTTjK2?=
 =?us-ascii?Q?LPutn4Vng6h7K3usaIBoNH8PbPDZG8RzdhB5G0E//K/o4Ae696JAwPnjV4vF?=
 =?us-ascii?Q?EC5NxTBNZfm1wMxM6ZGnkMSEUnUzpv0cI6g3W6qt0rhtkG128h+8hLSGS2nu?=
 =?us-ascii?Q?YZotDpng5r3TqvCgNxtX0nmSr1DqHzfAS1mfIfBCkbh4ZqJ8YqN5J+4qsAr7?=
 =?us-ascii?Q?sYfo/cFyY6P3t7DCDvRaJkzrIy+Bl0v/l5SQamXx8UqJGIVTXVE1G6oE27P/?=
 =?us-ascii?Q?g0hc4xQJ4rNR1FTYmhig0Iyl/exzNhe5FYt3yR2x0yUAhCk6gb/XBRYF7L67?=
 =?us-ascii?Q?o52F0rauMqhMhh4XK856QgMgE60/oALowOavAW9vNwl9ZYMh8WiczU/NPKrx?=
 =?us-ascii?Q?8vpDhJ/ttVAEal4ieaA0zqZ2?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A71A36F4D3426D46AAAC6C9B763BD0B2@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4555757f-2060-4397-77f5-08d91f72f239
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2021 11:47:59.9171
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sNJ9s021hwov5H6YqS1akj7xzeCZMKduqPLVzuzB37B/8QGrTOCUJ2O29s84uXdh0T17l6jl+BHN+4/aL0SmHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6640
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 07:39:42PM -0700, Florian Fainelli wrote:
> On 5/24/2021 4:22 PM, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >=20
> > Configure the Synopsys PCS for 10/100/1000 SGMII in autoneg on/off
> > modes, or for fixed 2500base-x.
> >=20
> > The portion of PCS configuration that forces the speed is common, but
> > the portion that initializes the PCS and enables/disables autoneg is
> > different, so a new .pcs_config() method was introduced in struct
> > sja1105_info to hide away the differences.
> >=20
> > For the xMII Mode Parameters Table to be properly configured for SGMII
> > mode on SJA1110, we need to set the "special" bit, since SGMII is
> > officially bitwise coded as 0b0011 in SJA1105 (decimal 3, equal to
> > XMII_MODE_SGMII), and as 0b1011 in SJA1110 (decimal 11).
>=20
> That special bit appears to be write only in the patch you submitted, do
> we need it?

Unfortunately yes.
What happens is this:

In SJA1105, the xMII Mode Parameters Table looks like this:

BIT(2): PHY_MAC: decides the role of the port (MAC or PHY) - relevant
for MII and RMII, irrelevant for RGMII. Defined in this driver as:

typedef enum {
	XMII_MAC =3D 0,
	XMII_PHY =3D 1,
} sja1105_mii_role_t;

BITS(1:0): XMII_MODE: defined in this driver as:

typedef enum {
	XMII_MODE_MII		=3D 0,
	XMII_MODE_RMII		=3D 1,
	XMII_MODE_RGMII		=3D 2,
	XMII_MODE_SGMII		=3D 3,
} sja1105_phy_interface_t;

Here's the interesting part:
In SJA1110, the xMII Mode Parameters Table contains a single XMII_MODE
field which is 4 bit wide. The documentation lists these possible values:

0: MII interface
4: revMII interface
1: RMII interface (RMII TX interface acts as transmit protocol as
   specified in RMII 1.2 spec)
11: SGMII interface
2: RGMII interface
7: INACTIVE (the port is cut off from the outside)
8: 100BASE-TX

If we dissect these values bitwise, we see that revMII in SJA1110 is
numerically equal to XMII_MODE_MII + XMII_PHY from SJA1105, so it makes
sense to keep interpreting the MII mode as 2 separate fields (MAC/PHY
role and MII mode).

Except the SGMII port is decimal 11, and it was decimal 3 in SJA1105.
Bitwise, 11 is 0b1011 and 3 is 0b0011. So while the low-order 3 bits did
not change, the 4th bit needs to be set in order to encode SGMII in
SJA1110.

Similarly, the internal ports connected to the 100base-T1 PHYs are just
XMII_MODE_MII + XMII_MAC (numerically this is equal to decimal 0). But
the internal port connected to the 100base-TX PHY wants to be programmed
to 8. Bitwise that is 0b1000. So the low order 3 bits still encode
XMII_MODE_MII + XMII_MAC.

So the "special" bit 4 is what allows me to keep the XMII_MODE_SGMII
definition at 3 (otherwise SJA1110 wants it to be 11, for a reason I
simply cannot comprehend), and to treat the ports with internal PHYs as
XMII_MODE_MII + XMII_MAC (even if one type of internal PHY wants the
XMII_MODE to be programmed as 0 and the other as 8).

I don't know, I know this is confusing, but I think having an extra
indirection (this is the value of SGMII for this switch) would be
confusing too.

> How much of the programming you are doing is really specific to the
> SJA1110 switch family and how much would be universally (or
> configurable) applicable to a Synopsys PCS driver that would live
> outside of this switch driver?

The pcs-xpcs.c from drivers/net/pcs already handles the same PCS
registers when operating in SGMII mode (their DW_VR_MII_DIG_CTRL1 is my
SJA1105_DC1, their DW_VR_MII_AN_CTRL is my SJA1105_AC, their
DW_VR_MII_AN_INTR_STS is my SJA1105_AIS etc) so there is some
similarity, but it is not as simple as that.

The Designware XPCS block is very customizable, and NXP integrates it
with a non-Designware PMA (this handles serialization and
deserialization of data) and PMD (this implements the CTLE, CDR, PLLs,
line driver, termination resistors). The PMA and PMD are configured
through some registers which are stuffed in the same MDIO PHY/MMD
address that is used to access the PCS. For example, the MDIO_VEND2 MMD
contains the following regions:
- 0000:000f: Designware PCS registers
- 0708:0710: Designware PCS registers
- 8000:8020: Designware PCS registers
- 8030:806e: PMA registers
- 80e1:80e2: Designware PCS registers

Having a non-Synopsys PMA even creates complications for programming the
common Designware PCS registers. For example, in the SJA1105 PMA, the
polarity for the differential TX lane is already inverted (i.e. PLUS is
MINUS and MINUS is PLUS), so in order to obtain the "no TX lane polarity
inversion" effect, one actually needs to enable TX lane polarity
inversion in the _PCS_:

	/* DIGITAL_CONTROL_2: No polarity inversion for TX and RX lanes */
	sja1105_sgmii_write(priv, SJA1105_DC2, SJA1105_DC2_TX_POL_INV_DISABLE);

With the PMA from the SJA1110, this is not necessary and the DIG_CTRL2
register needs to be programmed with 0 in order for both TX and RX lane
polarities to be normal.

So integrating sja1105 with xpcs might be possible, but not all
configuration will be possible to be done there. This is an exploratory
topic that I didn't want to tackle right now, although it is a good time
to discuss it.=
