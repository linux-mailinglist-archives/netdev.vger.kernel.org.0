Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257F457F710
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 22:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiGXU2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 16:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiGXU2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 16:28:46 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130049.outbound.protection.outlook.com [40.107.13.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDBBDFB0
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 13:28:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJoZp/aT0I89+cfR80LL6vYfMcS0RMJ/ZJvXse/0zAVOOKK0xsNBV6wKM292VxBgDiGOtR/GQt5/1UsVlHXkkSU3lrMLJqYiwYJf+v4NCuSnIX1JIYcI8O0XrpjjCrw8O4Qm2tVdt69MZYexRset1BecQOdr/kgeXtm/emEI6TQL7b7qEDMG9Wyf+C7RqHx52Bf5E5xPIEaOMYvEJGIkC7RD68uG6X44+vkdxoeG3Z+habcXg4sEw7L+Jmb2ZTbYChPSGHeftME+pVKkFVXEKyREKXYIQyxKQ3cp73tkw+tPZNje6WG+KCo2/WmtfqW8/MhBIWbkR5u3kYP4lwA/oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uflQMUVys9XDPqXik2oEs0Bh+kV5ORjDq0u7bxghRLY=;
 b=dXMScoYQJid+hWvpximFU1gPit9Tikz1P5V4gDy5U4dJ8JegE5m9y4NnKQkhRBkBg3QbY/WWrfbszcnVZTg9OaoYFg/SFESFqQ8EymcPbS1KUMG2GRGi75YDX9mRjaWeb5zpNfklOslGyCwD8FnbhLon1wCA1SbFbu2BxV6VCrqiEs0oB7q2QpnZXO9w1/sSHMufIbwkF1u88U0YX2MDrRzhIWde5deJQGs4EDGIOlQ6umGzMFWnrASR0p7Wp80orAzmzHbM7Bvcuor6Nv+lse0x/96Rss6CkDRqKZYT2NrqI9wuin4EtKkvy6KRJK0CPcwYNifxGhdVLsnFp958Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uflQMUVys9XDPqXik2oEs0Bh+kV5ORjDq0u7bxghRLY=;
 b=NjRD6pdcZx/hTWEeyumpAP4PLjoBsCah30z+fgczdNJftP91O1RELoIw+DuSDxRmdBngJ1xwA34FVFsJdBk7B89smMWtJn8LxZIGtLdHwPpkZctBB70J8qehfP9aVqh+yAt3dEPGpsRkfnUFjkZDTTGSIWGoHbUtjWXi/1uResw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB5721.eurprd04.prod.outlook.com (2603:10a6:10:aa::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Sun, 24 Jul
 2022 20:28:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5458.019; Sun, 24 Jul 2022
 20:28:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?Windows-1252?Q?Alvin_=8Aipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?Windows-1252?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH net-next] net: dsa: validate that DT nodes of shared ports
 have the properties they need
Thread-Topic: [PATCH net-next] net: dsa: validate that DT nodes of shared
 ports have the properties they need
Thread-Index: AQHYnrPeu7wz7m6SPUqzAwm5CxekUa2MQVEAgAFSvgCAACvxAIAAOoKA
Date:   Sun, 24 Jul 2022 20:28:40 +0000
Message-ID: <20220724202839.klkwevxaqxnvbfha@skbuf>
References: <20220723164635.1621911-1-vladimir.oltean@nxp.com>
 <Ytw5XrDYa4FQF+Uk@lunn.ch> <20220724142158.dsj7yytiwk7welcp@skbuf>
 <df5bb0c3-d0c6-9184-5c46-f6888f9c601d@gmail.com>
In-Reply-To: <df5bb0c3-d0c6-9184-5c46-f6888f9c601d@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3118ae0e-b6cc-454c-94eb-08da6db318b0
x-ms-traffictypediagnostic: DB8PR04MB5721:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s+BzGhdbKUh1/Yir0KSTI4F6pkHhFxtFgbpvrEMSNpYV86FZ/72wNA34WNygqpLch3z4uB/RkzSvaie9eEUI39jX+aVZJFRIHqrv+EQAdHuoWhPbiRATsRbBxPpaNJx/mxNks1VqHn2I5KBNNPIvzgPPMClo/CHK6stIxZfrZvyZAwr1XPSekXhh09Z7+ukdZoFCsX4sp6D/UNpEuzJEjuVfkaIaP8ZgkVx919VdPUnCuQkNYGOSfWbBA40riukf8hNpKJQ5KjWQSvp6pO4JCtYQgoGKZ6TbjXairiXOnIeNZXjjjO/akJietpN8yeWMzvAdrqEMTcZmd3/oVeH+Y4IZ/FAqbUWjGyGmtcrAbZLsGxXK+UCBNAZlhPvVydRzcUcgYSnttAb9KMNdZD/d/4WESPYikUtRCXbhsYdKoCrz+Y84RiW8+Cs39c8hImKOCeOUoOokKItVeENICiqq7wjOjjYO5h4vlBfpK+P6XEgwKB57U50+cidxGLAJaHD3xwI1RdfiR5lNUv3dLyRKIDQzsxqW2HPo5OR569f3BjdQs9N14XQ+mD7VhUHuXTYYxf+Gv/vwvJ+lnyTZ4sPj29QiIBTF4v0d16Qcy6gNiKvUlgk94egjdHQGbZeR8DZRC799bZQ1zCDhSFDTFdcPlKvwo1qfP1t6G3J5RWCir5w7F7AdacBl2wqmMXXerXHBwPLtCnByMi8gDFwfLXe8HFzuJGTBU/4hRL33VLxzAKPkpTkmeUkqa+1iLU4APqs+5d6/ADGhOB5HcNmSDOraggPeJNR1i3W8NlyEENYgLTI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(38100700002)(6916009)(478600001)(38070700005)(6512007)(86362001)(9686003)(122000001)(33716001)(71200400001)(83380400001)(6506007)(41300700001)(1076003)(6486002)(26005)(54906003)(186003)(316002)(66946007)(5660300002)(66556008)(8936002)(76116006)(7416002)(4326008)(66476007)(66446008)(8676002)(44832011)(66574015)(64756008)(3716004)(2906002)(91956017)(15650500001)(7406005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?vkJn/8C5MS7OrNVKi09kGT+bwIpQ1I9Jyq1BVdUAHqCwooWyhZfP+rGo?=
 =?Windows-1252?Q?juZ83MM0mKOYP/HCn48EHGyYSZZ4c6yhWPP2N0Y+RVfV+vt0rk7ArlDB?=
 =?Windows-1252?Q?IPd8jQIqRIFcjCf/rbvcNMlBMADbHWj1Tkd8hb4r4vWGbFI2jYCfYidf?=
 =?Windows-1252?Q?E3okzlI7QDVh8MTJL6kcSM6hlix7IFM+KWTa9D4PmPTcEwlBy+Rxect/?=
 =?Windows-1252?Q?UkQCoq8gFk1mCc4iQXONE1r0Erox2GOuth6DrL6JNcJw+oTl+X9ukCAu?=
 =?Windows-1252?Q?Y0yVAPXannOPp1SCYdTW91qmbovCV/fyppJ0rX43HaInkxi5iDfVbRkX?=
 =?Windows-1252?Q?aw9hl0x8A2+ZAZEg5dTDJbDxg1Kjfu7pT30ecSUv+QNwvBqEq/+5YF5n?=
 =?Windows-1252?Q?iyQKQ7U5lwRoaVoLSLL9iNYTWNyNhqwSc9aw7XhB3IdUDjomMXB3cSsK?=
 =?Windows-1252?Q?E71ldCFxCWl47ivtuLjhqD5aDonHtYBFBPi1hVkBd9Lm90ZNcrrkx527?=
 =?Windows-1252?Q?HeAc8bkFI8Qz8EZI6vRV6C0Fg7VBNiPnW/K5HjdzDpNzyiEkt0zuLnd/?=
 =?Windows-1252?Q?gMXV2DpS5F40+RpBgGOzREiUf07fbYMK30x16EOeVKLyOFAPefCNk8km?=
 =?Windows-1252?Q?u6xODNg1ANfrKXGnMyM0ApHp16qBFqPkcDCNtPiO+8YicxgczXhdbmH0?=
 =?Windows-1252?Q?Spuhp/mTrIi6ezFSBEfZ0wkfDmDgCAG9boFpUpnGsmvFKvgX8jWkoLsG?=
 =?Windows-1252?Q?Mz+unTA4hGAmOROZsUMa7jxyr+VMSqOLzqHQMn14jR88w2ipk61MR5ve?=
 =?Windows-1252?Q?KAzrlF0mty9Do+yUKsMUCXMBzl8IaymwqPmGAfuwi/m/lRVw+W68NBvY?=
 =?Windows-1252?Q?pzUzrVM02wTPYwOolPJla1Kjkn9/Jft+MdYYkZ9p/qlDq2sL59Dd4I9z?=
 =?Windows-1252?Q?NnLBUOqPNw94sBtq5TF0Qu4tmU4cVR9fl/bGrvJwDEuj9swZ6Zqyds/F?=
 =?Windows-1252?Q?Ai8UZePHwcFVUAVQz1P6qEsi9lBlvu6JdlgYjwCTB+m3nZCvRIo6Nh3K?=
 =?Windows-1252?Q?cA1yimBFn96BuTDrIt0wWBz25kZejK7y1mNp251tPQr86uLv7iOL8DDo?=
 =?Windows-1252?Q?bp8f0yM4bX6YV/C4MSuwvDbCB5mrIwvOKUdrgnCMXm17lwD8LskElBzP?=
 =?Windows-1252?Q?e5nmN66mcESb1vdsLf3V4gHmHv7C4AIPNf+1x6pFNyMkWfGYSVMOOl4q?=
 =?Windows-1252?Q?koenYGCnFl1A/5drms2cE2yzpd8LsUhP18rq4734dnZkhlrRFdqM4Fms?=
 =?Windows-1252?Q?lxDb1jhnMI/dCEtf4x+c9/0In1fBJEvm5sQJUpdW2680HXwPJckBflyZ?=
 =?Windows-1252?Q?4nnVOK9uLQXDuWfofT8sS+Hu/9SG8dMJjQ2aKLVfzdCzh4kE61YkJKSD?=
 =?Windows-1252?Q?82GRp9wvM7lysCPec7JI9UeJOa5RPYJrlcPOEfR/A0cNnv+CynZiMeob?=
 =?Windows-1252?Q?EEt3EgKW37K4B777wGOVxtBUaSf8gACb1+j6VTpPDtr5thZfGjpccUqm?=
 =?Windows-1252?Q?LMOBU7RuqQnYIsFSBY+n3TE042WjyhcebERHMPyH8LUcnJhEPeAsoJN3?=
 =?Windows-1252?Q?o0d3BTDDabJErEyRN7XH/oEmyVAGrIT24tsyln8tmeyrXM61Yd4goXBW?=
 =?Windows-1252?Q?E7Kw+PW5Pb8/H0MY0VhklQMtRLyRtpwInfaqKRXQM3XE97qpXtY7ag?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <6960ACAA115A964E8038CC99C033EF7C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3118ae0e-b6cc-454c-94eb-08da6db318b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2022 20:28:40.6989
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SjqJJaJBF9jNQrlkmi78RUDlYM+p87F48dLyDPhkqBS6Ck3yzaXKjHDpUPgKXUjH/tNxzgG1g9dkgzWrb1dzXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5721
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 24, 2022 at 09:59:14AM -0700, Florian Fainelli wrote:
> Le 24/07/2022 =E0 07:21, Vladimir Oltean a =E9crit=A0:
> > On Sat, Jul 23, 2022 at 08:09:34PM +0200, Andrew Lunn wrote:
> > > Hi Vladimir
> > >=20
> > > I think this is a first good step.
> > >=20
> > > > +static const char * const dsa_switches_skipping_validation[] =3D {
> > >=20
> > > One thing to consider is do we want to go one step further and make
> > > this dsa_switches_dont_enforce_validation
> > >=20
> > > Meaning always run the validation, and report what is not valid, but
> > > don't enforce with an -EINVAL for switches on the list?
> >=20
> > Can do. The question is what are our prospects of eventually getting ri=
d
> > of incompletely specified DT blobs. If they're likely to stay around
> > forever, maybe printing with dev_err() doesn't sound like such a great
> > idea?
> >=20
> > I know what's said in Documentation/devicetree/bindings/net/dsa/marvell=
.txt
> > about not putting a DT blob somewhere where you can't update it, but
> > will that be the case for everyone? Florian, I think some bcm_sf2 devic=
e
> > trees are pretty much permanent, based on some of your past commits?
>=20
> The Device Tree blob is provided and runtime populated by the bootloader,=
 so
> we can definitively make changes and missing properties are always easy t=
o
> add as long as we can keep a reasonable window of time (2 to 3 years seem=
s
> to be about the right window) for people to update their systems. FWIW, a=
ll
> of the bcm_sf2 based systems have had a fixed-link property for the CPU
> port.

Ok, so does this mean I can remove these from dsa_switches_dont_enforce_val=
idation?

#if IS_ENABLED(CONFIG_NET_DSA_BCM_SF2)
	"brcm,bcm7445-switch-v4.0",
	"brcm,bcm7278-switch-v4.0",
	"brcm,bcm7278-switch-v4.8",
#endif

> > > Maybe it is too early for that, we first need to submit patches to th=
e
> > > mainline DT files to fixes those we can?
> > >=20
> > > Looking at the mv88e6xxx instances, adding fixed-links should not be
> > > too hard. What might be harder is the phy-mode, in particular, what
> > > RGMII delay should be specified.
> >=20
> > Since DT blobs and kernels have essentially separate lifetimes, I'm
> > thinking it doesn't matter too much if we first fix the mainline DT
> > blobs or not; it's not like that would avoid users seeing errors.
> >=20
> > Anyway I'm thinking it would be useful in general to verbally resolve
> > some of the incomplete DT descriptions I've pointed out here. This woul=
d
> > be a good indication whether we can add automatic logic that comes to
> > the same resolution at least for all known cases.
>=20
> Agreed.

Ok, so let's start with b53?

Correct me if I'm wrong, I'm just looking at code and it's been a while
since I've transitioned my drivers from adjust_link.

Essentially since b53 still implements b53_adjust_link, this makes
dsa_port_link_register_of() (what is called for DSA_PORT_TYPE_CPU and
DSA_PORT_TYPE_DSA) take the following route:

int dsa_port_link_register_of(struct dsa_port *dp)
{
	struct dsa_switch *ds =3D dp->ds;
	struct device_node *phy_np;
	int port =3D dp->index;

	if (!ds->ops->adjust_link) { // this is false, b53 has adjust_link
		phy_np =3D of_parse_phandle(dp->dn, "phy-handle", 0);
		if (of_phy_is_fixed_link(dp->dn) || phy_np) {
			if (ds->ops->phylink_mac_link_down)
				ds->ops->phylink_mac_link_down(ds, port,
					MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
			of_node_put(phy_np);
			return dsa_port_phylink_register(dp);
		}
		of_node_put(phy_np);
		return 0;
	} // as a result, we never register with phylink for CPU/DSA ports, Russel=
l's logic is avoided

	dev_warn(ds->dev,
		 "Using legacy PHYLIB callbacks. Please migrate to PHYLINK!\n"); // you d=
o see this warning

	if (of_phy_is_fixed_link(dp->dn))
		return dsa_port_fixed_link_register_of(dp);
	else
		return dsa_port_setup_phy_of(dp, true);
}

So one of dsa_port_fixed_link_register_of() or dsa_port_setup_phy_of()
is going to get called in your case.

If you have a fixed-link in your device tree, dsa_port_fixed_link_register_=
of()
will fake a call to adjust_link() with the fixed PHY that has its
phydev->interface populated based on phy-mode (if missing, this defaults to=
 NA).
The b53_adjust_link() function cares about phydev->interface only to the
extent of checking for RGMII delays, otherwise it doesn't matter that
the phy-mode is missing (arch/arm/boot/dts/bcm47094-linksys-panamera.dts),
for practical purposes.

If your description is missing a fixed-link (arch/arm/boot/dts/bcm47081-buf=
falo-wzr-600dhp2.dts),
the other function will get called, dsa_port_setup_phy_of().
Essentially this will call dsa_port_get_phy_device(), which will return
NULL, so we will exit early, do nothing and return 0. Right?

So b53 is going to be unaffected by Russell's changes, due to it still
implementing adjust_link.



Now on to the device trees, let's imagine for a second you'll actually
delete b53_adjust_link:

    arch/arm/boot/dts/bcm47094-linksys-panamera.dts
    - lacks phy-mode

phylink will call b53_srab_phylink_get_caps() to determine the maximum
supported interface. b53_srab_phylink_get_caps() will circularly look at
its current interface, p->mode (which is PHY_INTERFACE_MODE_NA, right?
because we lack a phy-mode), and not populate config->supported_interfaces
with anything.

So what is the expected phy-mode here? phylink couldn't find it :)
I think this is a case where the b53 driver would need to be patched to
report a default_interface for ports 5, 7 and 8 of brcm,bcm53012-srab.

    arch/arm/boot/dts/bcm47189-tenda-ac9.dts
    - lacks phy-mode and fixed-link

If my above logic was correct, things here are even worse, because when
phylink can't determine the supported_interfaces (no phy-mode), it can't
determine the speed for the fixed-link either.

    arch/arm/boot/dts/bcm47081-luxul-xap-1410.dts
    arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dts
    arch/arm/boot/dts/bcm47081-buffalo-wzr-600dhp2.dts
    - lacks phy-mode and fixed-link
    arch/arm/boot/dts/bcm47094-luxul-xbr-4500.dts
    arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dts
    arch/arm/boot/dts/bcm4708-luxul-xap-1510.dts
    arch/arm/boot/dts/bcm953012er.dts
    arch/arm/boot/dts/bcm4708-netgear-r6250.dts
    arch/arm/boot/dts/bcm4708-buffalo-wzr-1166dhp-common.dtsi
    arch/arm/boot/dts/bcm4708-luxul-xwc-1000.dts
    arch/arm/boot/dts/bcm47094-luxul-abr-4500.dts
    - lacks phy-mode and fixed-link
    arch/arm/boot/dts/bcm53016-meraki-mr32.dts
    - lacks phy-mode

I guess that the bottom line is that the b53 driver is safe due to adjust_l=
ink.
Beyond that, it's up to you how much you want to polish things up.
It's going to be quite a bit of work to bring everything up to date.=
