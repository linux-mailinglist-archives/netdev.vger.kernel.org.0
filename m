Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F474A4CD3
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 18:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380768AbiAaRNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 12:13:23 -0500
Received: from mail-eopbgr80074.outbound.protection.outlook.com ([40.107.8.74]:57353
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1380741AbiAaRNV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 12:13:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRg2EkTjP9NlZnPSWJunVKGKS3HrE8CwNuWAnLwOLKfrEjlAf0c2E7/aDpuRztf0kK70IOMlwpD9HUYH0OnyjdX1NBhDfFqS7z7lU7PmDIL7dkK15+oYulYtOFuxBlpepwhxymuOeqx4OFYHRq3xqyk6H/XqnuhWBZYbLb/xglhBg/qJpLzge1CGGQzK8gNq0WGx0uuvkShC0zubnJbhWD1GYwpw+4c7a487FyUvD+CHub9BV7Xzi3REtw/M46pAT8YbUv9UypRf8eb0kub1jlG4BtBCmBFLrBSnSJYotoUzjG64njiEWNJ8BACEHXRK1VbbZZFK+VdPgwXk04uflA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r13/LMTjYYU+INPuxyZKt5O+ymNh5bv87qwzG82D5Sk=;
 b=kcIWqQn9lriRdNHvr6HAiyd4F2OMdkLFro8DSEgf1FQhAp585sIbPToTtWW3HVo/9Fxeaz2XsT04cvsM6VmNtyBlf42AATQd7eRQ9lLRifL5kWnx2GO27mpUFvRS4CPfwjEfzKq6Fv77VN5DrgnmTOTySYhxytB/oN7AdVzHcre3haEmiVo88qfGzlhJoZV7c5Xh/FXo1NGz8ZfVdVNA1h+ogpJr8TLHYhQ35QVYXN+jHvT5vJ02EN6nP1j/UxAJ3nvvam0DhnIdUMaYbpi1L35QBXUVkyR7ivn5CevV1s/TcRg89dPGh2JR/am2HhnvGfaLybN2Tx0c2cp7AzJNAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r13/LMTjYYU+INPuxyZKt5O+ymNh5bv87qwzG82D5Sk=;
 b=bRkdTkSVsm6Rka2F0kkwDFFoqAit5niwrBLIARsatH4di5XZrjCkUK9FgwzN8Dz3jOpqfnuNvL3KsR0Sck7iqNCtQ4xo3zXUOSAf/3zaOGR2kiB6zY3gPPqbwWeCgmoVzcOiN+Yl20n5G1zuSxl6uzBAOyhPVC/tfGsUZ5IItcs=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (20.177.49.83) by
 PAXPR04MB9156.eurprd04.prod.outlook.com (10.141.87.237) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.21; Mon, 31 Jan 2022 17:13:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1%5]) with mapi id 15.20.4930.021; Mon, 31 Jan 2022
 17:13:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [RFC v6 net-next 4/9] net: mdio: mscc-miim: add ability to
 externally register phy reset control
Thread-Topic: [RFC v6 net-next 4/9] net: mdio: mscc-miim: add ability to
 externally register phy reset control
Thread-Index: AQHYFVv0asWdnHBRe0uYWzT4HTrVl6x9YPYA
Date:   Mon, 31 Jan 2022 17:13:19 +0000
Message-ID: <20220131171318.ryule6y6ffowbrsm@skbuf>
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
 <20220129220221.2823127-5-colin.foster@in-advantage.com>
In-Reply-To: <20220129220221.2823127-5-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c27f38de-b6f8-4d72-3603-08d9e4dcfa3e
x-ms-traffictypediagnostic: PAXPR04MB9156:EE_
x-microsoft-antispam-prvs: <PAXPR04MB9156E2EF510A942421F0229EE0259@PAXPR04MB9156.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DKnT3pl6T8zGiFaKOt4J552Ecvg22/WQHt3Yul6HvazwKH4Nqqp/rf2YQEmj2AwxW/aKtee6lYFMrA2W+I/gmYFwHJWi7CAtrIaeXWRU3WgJYw7bZlo3bvTPOoIzMHZxQx7wxMBEsV3zNpvUl4KZE13NCD1EPOwGCyl0T00qUxNKf1t7+frmGbyAJrQM35Eus5bmgUJ7+bRXSDX4CJaR1IMFdWWHaK3dkKGw/BRxdj3dhPvlD3v0HouqApKadjUDI2R+lVoNX8FS3B0GYmWFipbe2OgkDIUb10AiANI0q9D5l0q75XVf5X6EX2nn+S00O6pGpj3jSHBdNCkx3o9ARaTmreLjuKjXqmoCqgc7tuByHZfYvluS7aEInBMIZzA/8lU+J9CPycbbuo7X9n1CnPmQUcdO89tA2UcgNPag0gLk9vLHB7h/qmPWdkZkqrle3m9Hhz99FbGKUlKpgTgVqdwNxQzImBSGbUdzn/GoWLigIyJUbZM9Z3gwS6WU8KIxf3cSDIaG0qGPQtPY32VAxDIKD35c4PTA6rWJaGkyjrhqnqCyvUvfxjpP8swzYvUqgev3jXnhEkLuaE4agJgjgAlQTpCa9eVysKyNqIuCpV7nfwSOcvm1rig3aCgcoqQAHID/0rjBMVr1Bq8C+tnp3N9WX/Z5MNyYwWf/flgXZu50LPhTYgkJdhFxk5f/1HDTPzysPeB2L39XhNci9cdsJw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(38100700002)(91956017)(5660300002)(4744005)(44832011)(7416002)(4326008)(6506007)(8676002)(86362001)(6512007)(9686003)(64756008)(66946007)(76116006)(66446008)(66476007)(66556008)(8936002)(2906002)(38070700005)(54906003)(26005)(71200400001)(33716001)(83380400001)(6916009)(316002)(122000001)(1076003)(508600001)(186003)(6486002)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YiQfq5lUmQnEiB4hh0obnfxUFJBSX+Tkr06h5L0qZTUpzkrOtbjboD8O3BWd?=
 =?us-ascii?Q?RwMg4sKKiszYJ693N1Y2Thw/7AIYgZFlUI46zPmdIBLnLRJFtnAWDrb0kXLz?=
 =?us-ascii?Q?71HqrgSSTTO7irqUiqjOlax08rRuY3n1a/rLYt5R73YSTaqd/FmdWcEqD2TY?=
 =?us-ascii?Q?m3PGhDkoecmrdyVfqECnIvO/Z34LbaeMFq4Tjf1KpN8vI3IpI+zaiNObgKQT?=
 =?us-ascii?Q?Id6XzvQL8wX8gPsfAxPhDSfuGyNYRPwjk1CDCv78oA6mLMKyK/mRhQscGE+s?=
 =?us-ascii?Q?06eBcmQmHpazT79LGlCcBC0I4TZ/f3PkUFckd1cO303jmj9QvsMR0tKTYtai?=
 =?us-ascii?Q?1SM2vU7Xzne46IayWcpEUY1Qv2RCJ3hGkrmcovT5sMv00qdgijh9fQCBGevO?=
 =?us-ascii?Q?7i9wgdJxG1bdjMuox6iu59ebOkZxiL9IwNHz4I5taU2ThppLIOQVqZef+yhW?=
 =?us-ascii?Q?MRw6rrcDaxYdOPuIkp+XnLXvUOSpeCyormZP/ZaWDHMrvwmcFimLhFjZkEZC?=
 =?us-ascii?Q?SBJZYw9nX/8orcCxhVTKbUAyo5lSgbjkDTXedDmFG+Elj2QRe0Z3ffF5hNTV?=
 =?us-ascii?Q?wCWsHi4LwK8bn8w40aYOIIH45N4eRbO85kzmUPlIwJQJS5fuHPVNEEiCPZM9?=
 =?us-ascii?Q?jVI07q3JPjY5nN/x2okkm9U7j3P+SQKGY8o0/KgjiTgy1DdQxhNCDbASGcI9?=
 =?us-ascii?Q?Z7dctiW8dTwBPDODsgBpebivp49GTOaV8lrVNinx8gq0iQEKMJW8ityjhb/p?=
 =?us-ascii?Q?sHXdrYR+MmfV8EpCGm1wyP058gsLVoyhj1fUfGroMJCq0rUCgo+NAefwciFW?=
 =?us-ascii?Q?A1hX8xSWyyRSNjrCnpMwjq0NC6EorFfavW/d+rh5zDjyxnHQH2E36j9U4yH8?=
 =?us-ascii?Q?rQ+xUw+iB8IfEZ13+a0E/ag8BT4gDURQ9uAmHVgU8KCktfSipTp+30uGz5id?=
 =?us-ascii?Q?ApojcNm2Pt7zErf7ncYvxzkm4sHgrxmNhaD3XyErkezCISbSf6z/yAa0G6q4?=
 =?us-ascii?Q?rTovpCM+qMQ0YotSmuRDKisokapIkLMWmgujVDfKi1m4L2BxGL2d49+pIX3q?=
 =?us-ascii?Q?zwGdATqaVqUuvOBenn2p9uP081mIdLlbNqZf5xR7c90ChGNZRZK6qFi9bQuK?=
 =?us-ascii?Q?APQFt7+qfsu9j+IoSmcEf1x3jdNpXHcYPt/4tKBnsvkySND/6S4qrQOvu9ng?=
 =?us-ascii?Q?Eozmit5r3XGvCF4sy7X9FRbfxpHcoQwa2/4Q0BENRg2g/wZIyuPlIg3Po+/n?=
 =?us-ascii?Q?t41NaeyDJTMG2V2dXl/AJis91RzO8h3R58vSffo8jqM551mft7+sOXc1zc74?=
 =?us-ascii?Q?KIems3T0057lN4I5y3yzUSOFS8adu8zgne2XKyEMvx2EN7ei6dIqkc3m7fcb?=
 =?us-ascii?Q?j/fpc+hdTqRq2sv/ctbFAZgXwnQKn7hwpldXWZVw8lrP0Q7ivJMjTB+8hK8f?=
 =?us-ascii?Q?JVY+3J8SJuS3Xw/krMnqR0ON7pOcWJ/9F7aWpiJ1RhWPIKT3obSix2GAC4G5?=
 =?us-ascii?Q?e5H5A3CSgO93M9oed2mq/1UerQXlJpmLeejmvUfGRZL2Nqajrv5u+52oInuf?=
 =?us-ascii?Q?ENI+NSfKyWMDkc6w2uEYb2oB+ikJaAjXhTAbGxESef+Xk+zu3sOFGxLN4De/?=
 =?us-ascii?Q?HJ+ZYOjsBQTwgyz/VN+8op4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F72DD5EB1572B4438E08098CBC088719@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c27f38de-b6f8-4d72-3603-08d9e4dcfa3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 17:13:19.0861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fkZvpP/n4FmVBz45pB5KXzmqYA1tr/p2J/qoegnNjB4Aps/UqMwvZuTTxQDv+XtG0D/+VFmgRkK0QmS9XSV2Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9156
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 29, 2022 at 02:02:16PM -0800, Colin Foster wrote:
> @@ -257,15 +260,14 @@ static int mscc_miim_probe(struct platform_device *=
pdev)
>  		}
>  	}
> =20
> -	ret =3D mscc_miim_setup(dev, &bus, "mscc_miim", mii_regmap, 0);
> +	ret =3D mscc_miim_setup(&pdev->dev, &bus, "mscc_miim", mii_regmap, 0,
> +			      phy_regmap, 0);
>  	if (ret < 0) {
>  		dev_err(dev, "Unable to setup the MDIO bus\n");
>  		return ret;
>  	}
> =20
>  	miim =3D bus->priv;

You left this variable set but not used. Please delete it.

> -	miim->phy_regs =3D phy_regmap;
> -	miim->phy_reset_offset =3D 0;
> =20
>  	ret =3D of_mdiobus_register(bus, dev->of_node);
>  	if (ret < 0) {=
