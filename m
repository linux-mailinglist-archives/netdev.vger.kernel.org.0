Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373B1460075
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 18:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbhK0RXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 12:23:06 -0500
Received: from mail-eopbgr40077.outbound.protection.outlook.com ([40.107.4.77]:21317
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1351727AbhK0RVF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Nov 2021 12:21:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N5BoxjLCaRKw+mPKXao4if86HHOIAWVNA/CA7bsnpecJWLz9jV9qkxoYPO5niodDqc3S1CKJWd2Vsl8C2ALg2Eh5QpbCQd/vAP2LX27Wtk/+MqfW3U9O0jrj53OrosTxwf72hdpOqdTbK5LfCI0nL2QLR9SQ7XsNJ5QZMBwpDsgpImv2Eg+1JRKWFqIbD44vmce2Z06Ni5TkFNKgPnchv1LtLTbunmbDOuuGEBHP9x38XVrFIkmCghyosEBZASabW5LC4++QfEXboqrSLs7FJ4xVhxEABG2+fGEbj//MbPeB7jkclIlLhYG7IMXB85vKL5wh1f+JT5sW+/fvClBJvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rclpkyuYETISowvkQidOIRyY+JiaI2bxBjpaVDHoj9A=;
 b=c/KJI06dW6RdSG+EmyhxTmrEJ/KaMaz/DKU2OFvh+VUADP40JGWQZDTj7Y+aYJbliZc5YSYas5XigppYvmqbxg1D3H4pBVAK5SIKptsj1UM0REm7hYMvI+9YlEmayccChiN5ogUkVJPDH2bvSfpRJ8T53h5jbGTmzt5f+Gt+ECYFgEgqWQcd3mKMozBGGroubSgmpK0YKw6FDuEmCekzST6xuyC2j/Q3Z5XXWg2NbivwzntoUgq51UfFeo8wabmcRhGmXoIenbq7sZqdiyOuyhfiB1Ouxy4eOpP1zTQZw0QpNY5Wcp5etwZQhU7kruUFKZCiadQpX8AGqrOrxauepw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rclpkyuYETISowvkQidOIRyY+JiaI2bxBjpaVDHoj9A=;
 b=nkUEnDtWmaxYUtZ3zo27DyTogedYvlSXgO1PjPkS3I60PVKBf8BwLMXo4hfFS5C59//CpQRcMDE8efvvgH8dZ+LMHuLglT+dmsgPFtAhj8w3ihlXUveLDX2yVtUVa6GYljCsECUjsCGe0asWMqP141lkcU+QsHKzE+D/0XE+6n4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2687.eurprd04.prod.outlook.com (2603:10a6:800:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sat, 27 Nov
 2021 17:17:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.023; Sat, 27 Nov 2021
 17:17:47 +0000
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
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v2 net-next 3/3] net: dsa: ocelot: felix: utilize shared
 mscc-miim driver for indirect MDIO access
Thread-Topic: [PATCH v2 net-next 3/3] net: dsa: ocelot: felix: utilize shared
 mscc-miim driver for indirect MDIO access
Thread-Index: AQHX4jjkQZBGgXEJxkWfdqMtJqFeg6wXoPIA
Date:   Sat, 27 Nov 2021 17:17:47 +0000
Message-ID: <20211127171746.xjtwuehixsk66ra7@skbuf>
References: <20211125201301.3748513-1-colin.foster@in-advantage.com>
 <20211125201301.3748513-4-colin.foster@in-advantage.com>
In-Reply-To: <20211125201301.3748513-4-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10e5a71e-0d9c-430c-7ca0-08d9b1c9d575
x-ms-traffictypediagnostic: VI1PR0401MB2687:
x-microsoft-antispam-prvs: <VI1PR0401MB2687585F81299B4F5B79B058E0649@VI1PR0401MB2687.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zl0Oti0E4IvXMDuW4gMTICKirYs5w1n/7xjgSt2xLCeaAhAY+SaLfYpdMWwFkLY0/OdVCI2Ajn79rCczPFbbOtnbjK1DFuc/y3Tjqluj5YEa/3jCeIZKOfii5C84U5HyrwUrckeYr968ThExPNywXBThzFwQwaFWoR0sx5VuBvJwCoxc96lck/oo70ckiVw8rIsTC+ZBos78XQrhtO42NzLHmqfODNxCsueL3NbCirJkdy/ct38V9iSW4G5deV+iZtF6zEYgU5ty3N39L1XaKXUpF3UOme2y4zhjSU5DLM0h3Vf3t0LWuIQoxWodeaPVFRsE7TiCM/aUo3A664jTRn+ZEmX0+G12xLK4U+NqFzBk8efhYMtk4oRYZ7zfhgN085cdLtCjEBwdHzoPaX1XzYAVUvIgz679R/ASz9LHmPNNbLDVSvQbHG6IDG4c4D64DJkxbnvWqT0NkX/B8XPG5dnO0EI7oJeonGnCMdHy1pEIHiyHGYWWCXiNiKQZGMwgwRBLZ09rZtkX/e7H/2jxMawjufd16Sph2yrnwFF9AgsJrENlvJH/RUBPxAB4tkZKK+Ha3LM9zidlEH5VgJJh7RAR+j6945Oj5klj9tMk3IVP/Dd5jRQ89qTf/nM4VxTsrPwC+uCTj1urc/Gyfx5be9PiUcJogNrweyjvC/bOPxaGdWiBOH0oYjg75tYVYU5lOJdD1CJg7lgEjvuw4yEwRA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(71200400001)(1076003)(4326008)(33716001)(8676002)(76116006)(86362001)(186003)(26005)(2906002)(38070700005)(508600001)(6512007)(316002)(8936002)(6486002)(7416002)(122000001)(54906003)(5660300002)(66946007)(66446008)(83380400001)(9686003)(66476007)(64756008)(66556008)(6916009)(6506007)(558084003)(38100700002)(91956017)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wS0kBL8qstTYNX7t5BsOfbaLKN9gp1CN39aOtTZW/h/dbqBxJUMeL2r1QaVQ?=
 =?us-ascii?Q?Ogm8wbCPJKACRkqAUwmHUi7TZ0Sen+xI8mMu+5uy9zyQ9G9wSjLm0o0svV/V?=
 =?us-ascii?Q?OGcBR/kTWqqCRomqX937mStYZNw11O28k7QK9gdY3CdK8W0ltakyXBFNqC9q?=
 =?us-ascii?Q?XGNohSczxiCWJ7EOyZN6Qb8BEjJ9PdzBpWM+QtyXCE4blHESA4kjjGxlpQJL?=
 =?us-ascii?Q?fFR4OEtPhdak6KV27bXDn3ab+RIBZdmw14lP7rgBoR6Hv4xfDAEb5xkHeyEa?=
 =?us-ascii?Q?RjxX5JWGj+Kh6FuxP39NFP1MP+1OZRolnW1aVzs5PKPVACB4nhN0cFrIRYK2?=
 =?us-ascii?Q?0KXL9XbibBtJLeYemCai5MeRFoHPS6fpGzr1cnsx87cumUvJPqdF9YIuSnaM?=
 =?us-ascii?Q?7IV1v9wJTTSY5WEXnWqgCYJ1hIqOghRO3XqYYZY1MNLWSKw+Yycj3MfV7yCf?=
 =?us-ascii?Q?kgyT73wQM9z2wFRnaZ7/WWvtI7xG+6SmvJIOGhN7u4gVkZBWU4sQIiw7m/9X?=
 =?us-ascii?Q?g0CWfXfHZ2GYfv0vR4BEEXgNBlwIj/KvLVv+OAeaXm553tXSSP0SU4tsWLOf?=
 =?us-ascii?Q?CzZxdZYkeD8IBsi0Bq/EThL3PiHtyYmuaofLffZT+ZQzVeljcKlD6cEzmx9x?=
 =?us-ascii?Q?GOp9Jj3ECOiUohUR6Y8EW0abPOD01fv23ptGFQgTarlsrdpaOC+HIXoP1Uk/?=
 =?us-ascii?Q?Ow8B9xYe/+9pcU4sb25rdBs1u/63EXU4ju68enTuwnt4juuq8wq5kxNuqvm+?=
 =?us-ascii?Q?upH7BrVvke+uVLKz3vQMluqH8QRaHKMZVGFQ4/LJuRVAG8e8DUfT1qxd0UwU?=
 =?us-ascii?Q?7TW2dKKQhz65LjcrjJpRSbCp8Lh2merO2UDCqWpiuesLdxal954i1svMm07p?=
 =?us-ascii?Q?yjuzw/2dOORxbWmIxiLGd5L97ib5ukSGLVKK7IbLfIt2X7SROBo/mH+tKSYK?=
 =?us-ascii?Q?dw9oiEQW6v22v+7w1uF5oy0W30gKvTFn4ZQAx73Tm4UP7yM1dBurkHbvdOIm?=
 =?us-ascii?Q?ePPDVlUz5Zbg9wgu/Qj9YzFqykwPfqFoyO6X5Gnu+HSh/0YG1+EmxiknM0V9?=
 =?us-ascii?Q?iNFEwFjrH1HyAToMKqVXxXpCgxXm+iyrMfJRx7i1Fg+d3gEQqOZpbJ/+D77G?=
 =?us-ascii?Q?Gmt9jPvw7iQ54r3COQOQ1EMzufCz62UpjOSpqBSCHLGAWCSTdzxuY6JuBqP0?=
 =?us-ascii?Q?ln2stK46Gfl/rdl8VFhFi0ZUfDkWN96q97l5GNgLuGtu7cTSxcZxBuXzU6Ac?=
 =?us-ascii?Q?PTy2jYteaJro5fHbiiKIh73mRhDg/u3pZ3QG8KTh3JaIpr74vmKJYrCLvout?=
 =?us-ascii?Q?YMACCdeDCOLUrniGAikfAIRL8sxRqKnv02a7FSKht0tUD86oEpqx9hJScCSG?=
 =?us-ascii?Q?JlSX0bUOSWF+662Ot7V9iDa1tt4lxaGAIgO+pfjJK/B9dmMVw8fVkp5OlEnz?=
 =?us-ascii?Q?FaOwavrhcC3jXufkCGtHKdeIBNJL0X7orbQIw5XQiqODqw8nL4ItaRSIKO/h?=
 =?us-ascii?Q?wB90SmKM3ab5YjsvVm4QiH6DaHQ49Ayqwfhp8YT4Th7SjQcMmN1pN8XM92O/?=
 =?us-ascii?Q?CRdL+Ju8PFZordZlFKYAJ1aHr9nShbcVCRmyjx2cH0hH0fHHTGNT7/ulBVgF?=
 =?us-ascii?Q?TLxLV9NBIhXLJwjZxrJEJh4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4E49CE86DA5E0048A53517402F448D76@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10e5a71e-0d9c-430c-7ca0-08d9b1c9d575
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2021 17:17:47.6585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KBXqrW2hX05m7rPluk60XGfAP5vuNkpaWVi4GU4VeZvC0FV1w6G0dz7ymdht9klgBnE62228dlmKc9S2B+8NjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 12:13:01PM -0800, Colin Foster wrote:
> Switch to a shared MDIO access implementation by way of the mdio-mscc-mii=
m
> driver.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
