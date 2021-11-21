Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBEB45855B
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 18:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238414AbhKURWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 12:22:13 -0500
Received: from mail-eopbgr130041.outbound.protection.outlook.com ([40.107.13.41]:21230
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238440AbhKURWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 12:22:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G1Ye8yr/OuryMw3sIoO5vUyowth1rWMNxdZwFJo33ouSrLfiP9OwFuuLh5Crd6zlISrBYt2KxSwBF32VNFulHggi2R5GF5qrwX8exl4nGWl4ObplSUAZqWuAxLg+Izl6Avd3UrLC6o2u2xI5jY2UILAWjj8wEXkIEJ6BH435lB39/etKCSuqdd5Xp6vXCvm3t1x0O5qj6RV0q2h7QRyYBIXwcY5FGG6KmWV5wmVR/1Ofdhf01WAru0G3eXqT+dBmf3iYfMSdGiRdQIBq4rUHJD5DwCdV3cBy4orCrf0eic0M74ZOKvjraxuqqGGHyiqUWj74ZS65Er51f2KrbBHIGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OTSQjkQwLXkzV3J0bovKqco0rW7jKkP6R1Pu6GZyIEo=;
 b=BK3dEDytY7HQoxDfSNLGgFY9iFp4/dFwRwaUhaoO0O6Uj0NimkqwzEx+YC+bRyjplxgGH7F6ql4fLEPneitpBoLjoymBXeiMP6tqOGyX0w/JTPaOofyqjC0R+hlJ6WYiYY1KVQXh3E/mzG1W9li9KLSqMXjnVNbS62T+tXPZm5dz2IMWZ5OxK1JdNRab16VDzk7VEPn7ZkR3KY6kGVw91+e5dLGs1BVA4w3kMuh/7Jo6VYDxB1hD7Ws+wl3j8r53YWKu9bS078ljS5D80v1HhJt3e2Dkhc50n7vWaZfjn0rexavabZZS2JWkW+WW4FwTuBn3KnLthQlpJ18cUMPfSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OTSQjkQwLXkzV3J0bovKqco0rW7jKkP6R1Pu6GZyIEo=;
 b=TVmtjFSTeraDA7qf0UjssqTvT7j9hgybjt4F4LCPffKFjV0SMeRdfbWtQwhxa3Mkfr+QWHf5tWuPBzds7UVEtGdziPLamvoN4g+WmcHpE/n2/29Ty9HW7i+CZ1C4p9NnHuW35Ar9Vq+33SKEMGkL1tlc1bclw7bg4XLk/ZxoAO0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5343.eurprd04.prod.outlook.com (2603:10a6:803:48::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Sun, 21 Nov
 2021 17:19:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4713.024; Sun, 21 Nov 2021
 17:19:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v1 net-next 3/6] net: dsa: ocelot: felix: add interface
 for custom regmaps
Thread-Topic: [PATCH v1 net-next 3/6] net: dsa: ocelot: felix: add interface
 for custom regmaps
Thread-Index: AQHX3ZbhuZ+MuOcG/UKDWCVExhOGcawOPJKA
Date:   Sun, 21 Nov 2021 17:19:02 +0000
Message-ID: <20211121171901.nodvawmwxp6uwnim@skbuf>
References: <20211119224313.2803941-1-colin.foster@in-advantage.com>
 <20211119224313.2803941-4-colin.foster@in-advantage.com>
In-Reply-To: <20211119224313.2803941-4-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 457f1b62-f587-49ee-89fc-08d9ad130363
x-ms-traffictypediagnostic: VI1PR04MB5343:
x-microsoft-antispam-prvs: <VI1PR04MB5343CAAED79441D4C5576807E09E9@VI1PR04MB5343.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0ez0IefacxtUbxBGbpQItT41vGTOV5YEE6b1126Z/6eu0F+oBz2nzz//QgvShfhck1DNOsiHSeTy/MxrJnOdbf+gLwzjBFeaxxk8gD8BVPMEn8XaQQLbhPTf4iA2kHP2RPduvb0idOWSuo0ryjhKrqhyvahyGRQbB4FxtfFGrgBLFEI8yzvDV98H7+U4NFMrV/43HeJ3ZTg92Gdo7sDITTRwYzxLjHxsuKqubns2NlIAdMfA/K4cDYMJ3wePX2eQN9ZiW09rmF0r+g+GQ+wpYHsfcWASzWvnJO6/P17awfyQtst0xf/sa+G+JiL6WiGPXInZRUGkp130KKaXaBgwr255QyGTB3+HB6Zp+iq0qYc4tLMxaKN1joUpiEjH2fWpUmqh9cqyT+ttRmn1jJcoAU4vzgb6E1tTxoYS7vgQEnkSkFRHc4qQ892YCvENYSlJ+Y9f749nHTkefKN6UE2fKe3+SzlUQ8qOArLNclidD0sSFWMUgaU6D5yuaJDwZPC63AkLII6Gq0UoSLAgoFCto76eltq/5zoRwYgxu+cxeLAjUX360rAxA9jqGBX00Xvq59smX9zy5pWkiGnPUHajKMx653lE67tmvQV2bU62fFgnZW5R+6hcud0PDEtV7t+z9OkT19ayrqFmJ2flo0rP8FqgEvotFT9k+2ZmUjuD5TodMobnjDxjWsC6pPMJz0/im7WOXSBeds51YW3HLqO5UQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(7416002)(33716001)(5660300002)(6916009)(26005)(9686003)(4326008)(64756008)(66446008)(44832011)(38100700002)(54906003)(71200400001)(2906002)(122000001)(66476007)(66556008)(38070700005)(1076003)(66946007)(6506007)(6486002)(508600001)(4744005)(8936002)(316002)(8676002)(91956017)(76116006)(86362001)(6512007)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/P61tdET269OovB7PODTHB0+UTdtBX8W77otIL9W4N23GEL+KITgUCtjdQAE?=
 =?us-ascii?Q?ZZie74KwaFxaITX4wLTVThxdn+Mndp41EdBI+C1j/JYhH4BpOzwOz3BwNJQK?=
 =?us-ascii?Q?b5GTUpJgKokeoUamBUIANVqJdYOqmxjeLqRG7XtZI9GGtlSfFWLZxFCuLBUN?=
 =?us-ascii?Q?dNlQbpUSnitdm9PLTyT2ZrY40AQX+9x8+KJJRyxTodJUUt6grMMSxvd2oUZp?=
 =?us-ascii?Q?VxNYg5xtdOGKphySDKNqGDFoeeLGvanY9BS072h30e2WAb2WqjMwBe/ze32U?=
 =?us-ascii?Q?wAslviY5fTiAYxrW3htZCIOCk6Vmq49amgLU3n45UrWRzSxhYrTDsSjjU021?=
 =?us-ascii?Q?WVyrz2lh7I/ayrFcJ7S/N9nUHw6Qg5EklnsBc/yeW1GmA4aHxsZCWlXAlUXu?=
 =?us-ascii?Q?ZVlTRwZr56bK4W0JjWZGBhiagV3BkKd1D1BAVrk9d3/sjxmp2Z6L1PbYV//q?=
 =?us-ascii?Q?QIdNFs1l77iWVa/r5vXn0sCpVwrHEskF8vPbkjhNZO56tzvzUgQbTs36euLZ?=
 =?us-ascii?Q?qT99LHlWZMg5JqDbXZ36xqJMCDGyVtjeAUNJaPhAyRt3aAN2C/5ma3Q2FDbe?=
 =?us-ascii?Q?KzU6dRZrgwBZ9BRJj9MOvnztLc9QfEo+wnICK9aJ8QEiK7+JGvWwGzYnN4R1?=
 =?us-ascii?Q?lNlA0R2xzfDG7xZ9pAEqWAgInWz5PO41sqJHY4YBFg6U3/qrI3n9raEuCYuq?=
 =?us-ascii?Q?edLWwuWiT905rifbxlcylMRuSuT9xX5WcthHdF7yN1jujx9Xh0VuplKgl8v4?=
 =?us-ascii?Q?C2GdqYN6HXH+OKw99rJ94eluETBAcT5urGPqvieiUDf13H6vYH1ZY42NNY+8?=
 =?us-ascii?Q?AP2vSZib0QVZc57fii0A+7EbHFLjge2DA4sw51xbbavz3tRqfR2ETKlOYaZn?=
 =?us-ascii?Q?+d8aPNOC/O4WE7kzAEmH9Nit2+eHuuRKQRbIVGCHaHKZENJQrD9OCNfJWHJo?=
 =?us-ascii?Q?ewKDE6ZcLAuZNWwJNBfdWbBGu3sdIMA4t5APaqfXYHXSXvp1hqKyCguQesv8?=
 =?us-ascii?Q?CnARwRUlebDMlfQR6Cy8QTMQ1LpT52SAOtRSKzkEogvDnGgkkZ8FjPrKdAVf?=
 =?us-ascii?Q?qBflObtdtNrfp02XV2V9Y2y/JgaFqNZ7ThSrOSfRdhITa0yOKKWHXzZqmXsP?=
 =?us-ascii?Q?apbt0rL7ppQKQLZXevJQr2QJhtBJ35JtnzWgrw/ZlSqAbc+uJTCD91S7BWLc?=
 =?us-ascii?Q?89qh3W9cRRjdZVNo3V06+FSPjqA0wBdphLP6lhJmNrXpCymssE6ZBXyFcLfJ?=
 =?us-ascii?Q?h4YLUA7cYb6dV6cR4Gtt6OAyRRHR76XNcM41WanAFynvCzY9aCx4tCyBzWIm?=
 =?us-ascii?Q?BDAszCLpxTGT9V90vkkAzOG+XDVmdm5SQK1AxWTaTwG+TDw4rCU06uFaCVEH?=
 =?us-ascii?Q?VUU8AuSl5OyoSJTuY547lDmjvoqkn1m8LU6+jaqeOVluklTLZfH4ZYAwPe/9?=
 =?us-ascii?Q?p2FJ06Xcav1RWDOkswVccxTX/syCRrnoQmbXuGUgM69eF5wyrW+VvBSOSnzm?=
 =?us-ascii?Q?En/Sg2HJsRGZMhPXoCUcd+9ijGBPD9Ac6W0H5lNa/y0ygBNs0tACw1CuR4ll?=
 =?us-ascii?Q?3tvc1oXCt4UaWecXysx6tGNOmH+nDt/KVDetF+OPj8J5iPHXDaTMH1Bwh527?=
 =?us-ascii?Q?CYzRArdVYxO8W3N8muYA4F4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5EE6E7837A89CB428417A7E90DFE4C1A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 457f1b62-f587-49ee-89fc-08d9ad130363
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2021 17:19:02.0735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cSp6ZC7f9XTIZBHaQ3jgR2Vyw8Jv1iiIggpmZ1QfQUgd0Qr7gIFm78jUlqDN7rBBmh5XMr/GLtEb/07LZFKjiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 02:43:10PM -0800, Colin Foster wrote:
> Add an interface so that non-mmio regmaps can be used
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

What is your plan with treating the vsc7514 spi chip as a multi function
device, of which the DSA driver would probe only on the Ethernet switch
portion of it? Would this patch still be needed in its current form?=
