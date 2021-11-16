Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C19E453061
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 12:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235186AbhKPLZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 06:25:46 -0500
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:47470
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235000AbhKPLYm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 06:24:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKMT4+4J/wbjtMzeW6/6KWekade3WtyTgq4nY7Zz0YvoJ6NFVjhxm6pF0yfrZQiwKlZ5XIppqgTDX4+o5UHp9Juqg0QmmawMMw36vwkvLX/LO88GKw/XRoEAdnvlaxvzgaT6i8Rcw7hYLS9ANl9MRP81q/vrtLKo/bcVBkueVtZh6GUdRM8bCSaigcZTh9sHp99M9jW6jpvp/qyK0jBdzATtQ70Wt5K3TZ8clmU6x2YgHNRXF6T6/LPFJrOxp2N5/SXhQ+PdsKZ3Vm9WVp/CP+Y8jujq01KBdsdYjLX9lbgv5MiJ9aVH5Wkg6VlC55eQCKLy3h3X1G4JgDSh65PLtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AvZGz1IPkJDkuTxqskUQN1t81q7h6/x2Ice9C9gByvM=;
 b=Mt69F9soV4VjoKVkczLbhr20C3sFQFR7r4tOAmVmx0rIbqRXqCWlCT2GLJ5P6tQxSk8DeNS4bUlfFB9mObA3OmurHarrDuD4amPS1xUvfZN+FKjv8L2gHwXpt1+bdofy6zb9WUAUwpj3EPNXItL5kED+sgPxrdl+i0PexRP/Ea6jDhNT3no1XvMoXzHsoJnnu1IUi7HSd206JHsqeW3PITj6XM4mK4blLT1ozNBaCq/KHK56irCOZlidXfxo1X6NQGV6FCJOBfnuWz8PsATOsWS4ZjOT3gzOEpTRgb4/VvJlDTkUS83M/v/aU2cYvxuPMcvyONiavETfTa3Yt+HreQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AvZGz1IPkJDkuTxqskUQN1t81q7h6/x2Ice9C9gByvM=;
 b=biRyV7TP0oS0sMZpr6eLks4oEyaZooDByr0RtG2C2c4A1F+m7EDH5a/9c1kAWVj76TkBu/fmhApx508uhjXC9cdBRLDNeurobrxoA19J03zsevps9RFfhJAp3susy3j4/PYIH3tYM84rx1+79L9j3PH4uc+dvjFtAVb+nVoQJuA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4432.eurprd04.prod.outlook.com (2603:10a6:803:69::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Tue, 16 Nov
 2021 11:21:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4669.022; Tue, 16 Nov 2021
 11:21:41 +0000
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
Subject: Re: [RFC PATCH v4 net-next 03/23] net: dsa: ocelot: seville: utilize
 of_mdiobus_register
Thread-Topic: [RFC PATCH v4 net-next 03/23] net: dsa: ocelot: seville: utilize
 of_mdiobus_register
Thread-Index: AQHX2rKEmKEnmVBElUCpoOCB7+OPrKwGAtsA
Date:   Tue, 16 Nov 2021 11:21:41 +0000
Message-ID: <20211116112140.lfp72gvyusbkyl5r@skbuf>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
 <20211116062328.1949151-4-colin.foster@in-advantage.com>
In-Reply-To: <20211116062328.1949151-4-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22aa3307-66c6-4e15-7987-08d9a8f343ac
x-ms-traffictypediagnostic: VI1PR04MB4432:
x-microsoft-antispam-prvs: <VI1PR04MB4432B276AF9A1A0C50C00D1DE0999@VI1PR04MB4432.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wGqTG4u8TpDEqs5XxxvW2IG7OEMZ4j0OD3jKBBcvF6rNT2SrrNAdXwMoxnVYQJM3PCiblmEuAEjKnZK7WpT7cEoelI3jhmmYfT00dT3tHqQzYDIvTfqoapYS8aqlGj/igQlAr4QiAFy3nJAxkXKDjnlR5lJ4qlMv7UBmQxeh3eK1bP4seoFPknRbl3kUXBJrQhhSkDGATsrj0+MAH+ohzUakk7+ODl7zWAihmbqs6J/NBeodpgR69KvnwezppKaeyXCD3PhT5mDiLCn6c7Bm69nG4yXSmUE++xBb/5t1uCuNLv7LBMpo2XnHZ30CTfY+FtJL/7nuMBx6q34GzZfQU/NB5ksXRTFGuh+SAC+QwpdI6Bbg7hygV8bOkEbFTMxHskYSSxeX1lJosN/ykIhRuc/kVpy2SXTRYhOSbKkrMczTQyuv5ckaD1FDG5zLE7l0B9nJ9jRLt8Ehb5/cTTuBGCAJb2z+1OeGn4SscNPLZTEY+8A/vrcVdK12M2yYwGbgA2RLaEuEQA3UjGjOeiTyO39IB3lVYb5lu+SQoxXaTCbgGP6kqdj9LyF2Ykv29LCcJG8tNh2nMc+vanedhXwWO8o7mJAWl+8RRtC3UQRwMwT8hLqpmAbjT3zN0vUzAMNrVc7EGzfskha36IP274hUtoxfgPMrn/Gv4sHWUnzJVWJC1vIb0TnWv/EeeLKy8ghAway/TFGWO8FCBDfuXF3IEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(33716001)(66946007)(66556008)(66476007)(91956017)(76116006)(7416002)(44832011)(66446008)(6916009)(71200400001)(4326008)(54906003)(316002)(6506007)(5660300002)(8936002)(2906002)(508600001)(64756008)(8676002)(6486002)(186003)(1076003)(26005)(9686003)(6512007)(86362001)(83380400001)(38070700005)(38100700002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ik4Gp8Cxi+EJvwfMWUsx7drllZT97jiNN+RFd+CChxmKdlSCcT/R0U6yC4pJ?=
 =?us-ascii?Q?+6K043zZ2ChcVas9Gk674mXs7mW26P22T450E+wJoSesy4M53eIWjKNGGHoo?=
 =?us-ascii?Q?9Wn1GxicLCrFMF/EpfdhPyCU12chcyq0F/CqKhF+gSF9CRR022lUCi3gNHNw?=
 =?us-ascii?Q?C9ysK4pZqqAWm0oDc4f7vyryKN50olwu2jMZLU0ZZ/o9/5ZUlJ47ICqm9AvZ?=
 =?us-ascii?Q?aW14RdouAsINbbav/Mo+MyMUZujBj0EIo35Hlno5wlyq4w9j4+xAb051dWAt?=
 =?us-ascii?Q?ghfWwjUQ6dJVq9/0NHn+NG7ayJDpp/M+6w1KOFDcryhdVvpFE9kfJTwnBHcM?=
 =?us-ascii?Q?snKvozcKe2IMa2qnYRp1SQaR8ai+Nn3NCIkOYBMSMLMODf+GBnKqp8ffgfQ3?=
 =?us-ascii?Q?BGr3fWK/jLjJHM3tJOf17R3et+p0bzpfTi3j2vco/XNCRSm9m2KZTqXX+eN9?=
 =?us-ascii?Q?HHrgGRwcEp8pO8IpSl/tb/EtIrSX7sX3+K/Pq2Vtr1ytURvV4OXeKkGI+Pq6?=
 =?us-ascii?Q?PjeGDvRIpSTpZkxrbHtPot44n9zOLe+p01l4Fb3ObhglAR7IvDglsVnk/dHL?=
 =?us-ascii?Q?MmFWm50q9SLyi37d+Rh306Tmz5tR+pRrIyU++Ki7Zlm8baYKqlxDVjAy8sb4?=
 =?us-ascii?Q?fj1meM/USZGlaIIWjkWq1HyHQaPQFkEZp4+g+RwndBZ8Tz3nOwpQ9I1RCzp1?=
 =?us-ascii?Q?3rVZrKVWYnFmZsYboqiRAFn5Un8ZtGt5P47BmRXWdy2LOfP6/2qUimhRUbY0?=
 =?us-ascii?Q?/4Buw4MXT0R/vjUdJFqLRTnMWNlRW8FzxPNZmJ0cAz98uuolk4YFocjBbPr9?=
 =?us-ascii?Q?VF98HQIjr/vFZgYbsyIzYZTZonq24V7kAgOl1PtmpsG6rXIDkFEYJI9ctrV4?=
 =?us-ascii?Q?pyypwaZNBcF2OQMdevey8B3fEMv+afXQZD/T+S1kD15YJQzCCeolQWOBJWhe?=
 =?us-ascii?Q?hzTon6r1dz9bLO1i8AbibYWkxpvGd89oPtTCMOfK2H5IDZqddyq2fx0u1V5l?=
 =?us-ascii?Q?2wPBT3a3bjkYsLYFck9B5Kv8krEDiXYyWK/HWxKtkrxthjoyjrRfcnEmkSEc?=
 =?us-ascii?Q?NlpUyTdGXdGNhxw4CDs+NIQVSCjNhRLSScagwvFeTdeqrllS27V6C1P84hep?=
 =?us-ascii?Q?b7DZkXKY7v/aW62BXz9gn+zo4PXEXuZochKTl3BfoBrQ7q99Tw5CvAgELVwi?=
 =?us-ascii?Q?EB3RwkF7lNg3EuAvXNeN2QL87UnqqZBwdvvY1Y5oMFyCCnfcblG8Kg3EJbjW?=
 =?us-ascii?Q?jBQEQ6GbjXx87LHwJNTou2hV1u6anEtQzYxX7wTS8Dp9rzGzvzsS6INMozi5?=
 =?us-ascii?Q?UPwIE/gW04OPKCvHgQP+5ylgQGmWvfi3SDsgtNbgkV44CeoqQ3Ogn4ltgEmp?=
 =?us-ascii?Q?2BOhlS1osRs4roA3wYV5iVBzqDurnxPV543bEkjtNe01IVis1KKqbnhboF7B?=
 =?us-ascii?Q?ejTpUuKNt1VhBxqKrb25hNis4hvLVtfTEhrIHrsS5eJ9hLWPPU633ml9jrdU?=
 =?us-ascii?Q?sxQoGsJQshG/utvmPHQkvkEGo92NiAqRHZwEqP1egVy4r/F7AQl3gybjUNP2?=
 =?us-ascii?Q?d8d1KjOUrEYmjnZLK+6yyPR4y7/J9iUhUe9BRuXlL9bTrndvXXiYQxW2LNRi?=
 =?us-ascii?Q?1z7u0tS61y9jR8gI9ruFbc0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F2356F782CBED44592E9A1277D8DB8DD@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22aa3307-66c6-4e15-7987-08d9a8f343ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2021 11:21:41.3253
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nfsca914nBD/5JUJ7/+prE5NA5nZiYSeYp9JI8tdOAOlA73yB97eKMUK3zksLrGZa58P+bebqJsLbSDuj21mUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4432
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 10:23:08PM -0800, Colin Foster wrote:
> Switch seville to use of_mdiobus_register(bus, NULL) instead of just
> mdiobus_register. This code is about to be pulled into a separate module
> that can optionally define ports by the device_node.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  drivers/net/dsa/ocelot/seville_vsc9953.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/o=
celot/seville_vsc9953.c
> index 92eae63150ea..84681642d237 100644
> --- a/drivers/net/dsa/ocelot/seville_vsc9953.c
> +++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
> @@ -1108,7 +1108,7 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *oc=
elot)
>  	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-imdio", dev_name(dev));
> =20
>  	/* Needed in order to initialize the bus mutex lock */
> -	rc =3D mdiobus_register(bus);
> +	rc =3D of_mdiobus_register(bus, NULL);
>  	if (rc < 0) {
>  		dev_err(dev, "failed to register MDIO bus\n");
>  		return rc;
> --=20
> 2.25.1
>=
