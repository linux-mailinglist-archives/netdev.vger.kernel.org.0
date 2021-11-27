Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1CB460077
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 18:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350183AbhK0RXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 12:23:55 -0500
Received: from mail-db8eur05on2065.outbound.protection.outlook.com ([40.107.20.65]:13601
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233999AbhK0RVy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Nov 2021 12:21:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I54KvDDolSnHhcXM+ACr9M0uD8vRH7vM+bx8yeEphDV9amvzeqyiB+sBLuSVoZi2L2PBycJe2cFdtgGvw4OxSFZAX46VfKefcSePF6Xzwr0gm3ryMYbWMgNNbv+NIyPF4LFtwv76u0/yxiP8cWLM2X6rUgL8FJaJV9UEHwW+yewu4dNVgij1EM0jC0MzRJiB6z9hDgJ5WpoYz77m/UYhC0QK1JRQV49jemC0CJ9dZ/SZYM1B2FzC4sOfsscKtje2a0vB2HM2aNLI2BSBGkwJLoe5c243g0RyCH9v4bKpEWJkJrLQCfPI0isFzTpAIfoXOdZG6RbcOhWS1VpHXgS+ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MeZVRyPM9tuct1vUt4Q0ovDc/8HCNAPq77qntTEiDsw=;
 b=Qhg530an2N3W0Vp2FnNe7dwMEb3iZlveLhS28mZT7QgK8JKJw4wd5Ck63vmc36Ak52nVXu6J0hgoJecxTNZizh80FHF8q5k19B7LStyDBvgnlwLxOQU6Kgnnj2ajbdk9pNieyCLwe+7viWU/R9wxVSzTTtU+s9oYt3zyMiQfctlNIDyAN+UbXtyoScqBCx/8FmHMBZh8mtjTY0/gluT0iJjAbVWfwdD0iWdR0xl28sNVbK9nLynqwX9lZLFjq7CnvJ3ZpytTLIozw15gyWJU7kT+OoO95hZsQmCrsy6Ud1vPElX+dIPTHM23FGdSZ704A8cFwsVDCIeQFeD9PBfVIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MeZVRyPM9tuct1vUt4Q0ovDc/8HCNAPq77qntTEiDsw=;
 b=dKF1zcgjfQf7yS2+96aD6qSqlDoNWPDif83lt+NRmSGcNrCydXuqdEyf7zz67ysUILoIuvF1MtrHLaipxiQpEfeWrY6051ahPS3789WyHNGkyQRqBzHO3d0HIIM4zrZAeJdfXUUXt9XhDi0KOIv30sAP3zB65DnTX/i1Yn6l96s=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2687.eurprd04.prod.outlook.com (2603:10a6:800:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Sat, 27 Nov
 2021 17:18:03 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.023; Sat, 27 Nov 2021
 17:18:03 +0000
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
Subject: Re: [PATCH v2 net-next 2/3] net: dsa: ocelot: seville: utilize
 of_mdiobus_register
Thread-Topic: [PATCH v2 net-next 2/3] net: dsa: ocelot: seville: utilize
 of_mdiobus_register
Thread-Index: AQHX4jjjNziUFyejxEWMadIuuZjAQ6wXoQUA
Date:   Sat, 27 Nov 2021 17:18:03 +0000
Message-ID: <20211127171802.eya6yte4zgfunloq@skbuf>
References: <20211125201301.3748513-1-colin.foster@in-advantage.com>
 <20211125201301.3748513-3-colin.foster@in-advantage.com>
In-Reply-To: <20211125201301.3748513-3-colin.foster@in-advantage.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 38527e22-1d89-444b-db3f-08d9b1c9dedc
x-ms-traffictypediagnostic: VI1PR0401MB2687:
x-microsoft-antispam-prvs: <VI1PR0401MB2687C2E5D8ABD356E8C086D0E0649@VI1PR0401MB2687.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YUP9voODjtpflSWS4GGiJJXE5xlihhzRGA40b1JAsqa+JPDj3tuu2X580i3EbvtWyTA+K9mJNp7RKk7BTNbzL8AKUZr2gO7BMt+2eiqlBG2EDs2goZDRZt1q5bbu6Pw559BLRequ3GBl6amDpb12m1oYikyfaPtiXSXLLyJzxndwIZep+8otVVj5UURzNREkyjqlMwn/WP4Me78nBzU2oF7HDr5c+nXEMHyU2ls17Vily9biMrjZeGyOElCBwot7iYsU5lxXYIiKkZtI+YH/jWbuQDDxk/UMPWJdBPz25yPcC+3q7XOqjPCiyANziIYATHlHQBRz11g1cM75zkq6Ch6rBY7+VkeHYV7Rxfetsl4L4zXdFJXKKSiTBuUfmpDVD7HW41yWm4vmpz5HmBN6VXgz+Kc++M8Z0PsOCGwSeE3bDL6HVPv/Tuw5sAMVQgBW6iG0ir9nrkX4+ijydXZIEQNfQDvKTXihpbarJF0ONzUuRS2X+frMgHpUJkVZUzcfkKOppK0F4o2xqmFM+IK004gS4MgwcIcZijgNQYWHUG3bJ4t/sCK2ZUKIbXFG//cbNxYeR1+dZVWcmlyQoa/te3Vq5APNN0mrUKn3u7WdrfsU+yDUFJQ7NshBgvtjV41wjZ63jcAbBhUVoXrznWCc/woef7/xxWNUMdzcMXcyEf0J1KWoTKUgBs6oacMt+LMw3J/aZmd7TBgkgmZ5YYDucw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(71200400001)(1076003)(4326008)(33716001)(8676002)(76116006)(86362001)(186003)(26005)(2906002)(38070700005)(508600001)(6512007)(316002)(8936002)(6486002)(7416002)(122000001)(54906003)(5660300002)(66946007)(66446008)(9686003)(66476007)(64756008)(66556008)(4744005)(6916009)(6506007)(38100700002)(91956017)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jj5Z0AMTb5NmXyJmbkHaSdNdJ3X+f5c3on99iNYw64QQVEOdzWga1GIKpe+v?=
 =?us-ascii?Q?FurGq+IcdGfRwmjiEsYx523CdHLfeIKI2ee4pOVVCdN4sKgzLp9Vp6KE5jEW?=
 =?us-ascii?Q?ehITU6Jj9PcJrtRn2hcmcpjhROb9aaYmt18U1Irb6/rqAmwpvxpaI6a94Cf8?=
 =?us-ascii?Q?/Xwoy9duChHzh6sfNmiPPgHLP3/jCb+yO+SwO5aFnOrxBPOJLDC2U+LvM3SE?=
 =?us-ascii?Q?s4m9aC3rDl9/Sh09lWk//oe6ybK5jmJsDk73fIOzBSOzYTEjRk1Y5HUgUsD2?=
 =?us-ascii?Q?Y45ZROpWIGY4zuJbk6X/BJkstimxrDhRqHNaHh3igkNZT9CRvg9QU4gaQQzS?=
 =?us-ascii?Q?c1hvyp0InAbtZvIYptBEvd5n/b3DJl33gctwGQ6kBGALQ/cXFSXADubnV5WB?=
 =?us-ascii?Q?47rAaJYT/3ZAzFm1MF2o7t0jfBPDbsMV5VSo5vnXPBd0sDagUeGsyjRblyLv?=
 =?us-ascii?Q?F2tU6MLttBGeLFBMUQpgAAs18murtzCHgdu0R3zYl5Dv4/r6NvGLG2G4d0Lb?=
 =?us-ascii?Q?/UyjUqpkC2seXYhebAT8fDBXcIzHv9uKQB+v7Hm4XO+eyy0VcCAwQbSTXMv1?=
 =?us-ascii?Q?rULGw5PHD8u8LGBlKfQKekBDhfjOXQmEvYfE71uMmjiPGX6sZQiIB92AsDGw?=
 =?us-ascii?Q?JBWkfm21LMaIR1AGfEkyhS/bgLwRFxVuP4yXQmnqW2G4WZjZfGwNUjl+hS4U?=
 =?us-ascii?Q?6K3g1YBWohZTrleynEN9OjnSy7MtRpOjWDDIOe7P6emlkLJv7YL8LIkTlmQW?=
 =?us-ascii?Q?oDw0eKsRp48ckB6xqJvGNug3o5R820sJLGI5MDr2EyWtBMDcWRYhMqfpkvGr?=
 =?us-ascii?Q?yCToDVZetQYS8chI/bR7yljL2mso++qcX1AyM1WyS0uwIVgxUK8Ad9zMd8r0?=
 =?us-ascii?Q?mmWch5HXNGYemotS6KsYObWovJbuvvNQLQFF27jxAXTe/zwKr1edRfaG3cRF?=
 =?us-ascii?Q?ZmRISBvt0KQ1tpy6p/5krxvCNfDdMTCVTnvVi9WtZgvMHoW0y67nTE1rdHI2?=
 =?us-ascii?Q?u3JIYfM77O+0QhUo3kehEOK2v5FeThmEh/N049Q6eQ5lZAxMilJng/6GsNf+?=
 =?us-ascii?Q?JICrB09Gr3AB4kQUPsqLChm9TCevzNUaieBGFyyYfWbOEPZL9lTnXSgTeBzr?=
 =?us-ascii?Q?ONGlNF4LSq28plyiegYwj/eE9it+U93O72mywpWrKHFMlivxSWwJ43y3x/2/?=
 =?us-ascii?Q?28TT3hOLDzPMMfBs3rKiS83UlasyE6wjIz9PMkizLFRNjHTJIf9470sRh344?=
 =?us-ascii?Q?AeEp6pCYpcJO4LCuMPcGCR1/IKU4xD8a52CbYS570Ngtv1iXSEKU5PyYT6vG?=
 =?us-ascii?Q?Ii2ioP5iFI5l8aN3xI4WkI9k6O2ch8879NOey3jM/no/Q8H7zF7CMizgZFKv?=
 =?us-ascii?Q?eHDLx559Ry7BiFLjNlX9KoEyLYqAdG01LB9x7DYerF/2gk6TOjICCmcMzq3R?=
 =?us-ascii?Q?2EsMDTpb+IDuK8zpXxnv8PrKDzsc+lJKxRDtF2o4d5eIt8ZNFHdwQ5GfQLxE?=
 =?us-ascii?Q?yDHnO4B+yxOB0UKNuTo4QqUnt2fTLZU5ALgFsMTehc04/ftakpHpH6cF/oWX?=
 =?us-ascii?Q?T10IHpzfd+bcFg/Zlsv6SI4UDUcS8gkpcyGy0B+qzVkxFhYzTNKMXMElNkVK?=
 =?us-ascii?Q?BTHT9i74h/A91Tp6QtUtJOE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4C6089421F86B3499410C7ABA7294A52@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38527e22-1d89-444b-db3f-08d9b1c9dedc
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2021 17:18:03.3215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VrBl1WTBnw1T/Ptf6tb59WW+lr4Vom9v3spa5ZFHmhS5lEJy92+/hrH333XMrduLGDBbRZwdTXkHExqWgGWuXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2687
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 12:13:00PM -0800, Colin Foster wrote:
> Switch seville to use of_mdiobus_register(bus, NULL) instead of just
> mdiobus_register. This code is about to be pulled into a separate module
> that can optionally define ports by the device_node.
>=20
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
