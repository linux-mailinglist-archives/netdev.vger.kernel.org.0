Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068AF2D1A61
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 21:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgLGUQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 15:16:19 -0500
Received: from mail-db8eur05on2072.outbound.protection.outlook.com ([40.107.20.72]:61665
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725808AbgLGUQS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 15:16:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UPqZluODnywAN7kYSnaAp7eJ7U36FxCJs/FoqXZpavE8eeEKICt5LSOuUqOwlSz9a4YInH0KFuUSXsR5Sd/H3fyaEWN7ABxuUVji99G4VPvhylsxraMgbuiQBTpnAmUoJ9c1yS2Y4u8e1XuZ/yh2TksD7Q51jciTCt6d6za5y8d8cQt+zdB8ZwVV0t8hPx8oEpHLmUWe5/7sH5R6bD+ZF0CnqPE8Dw9Ct8zFp65I++X4dMIXMRu+GbOMqqB6bMf1Kv9GdzKl7sgb/r6KBWsx69qire+IYgRDZnzp8uBhO/VIAffc/k4Bs3+ot9J4jf2jQojJzeucjeR9S9EpEth+Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTHNBBJLBmecbTXCvVcHoH7zwMMPZ21WHhByU9d6Rzk=;
 b=Sl8fMwa27SJcNoI8YyVcGK+sdzUN1aivhigkMw2e2ZZcQD4Iv+b4Fm1DLs+Y2NWcUzmFRTy3ZtyJEDLNQRmrk6jtqhgBKRKNydmBBLOsp8J4JNHmFfPi6hYpm2yVip6AnlUOwPjWtsFCQ8ck8ryDsII4+eQCGIOrJLox7pKGZW+EM+6qYlzTshF+c9x8t8GDW9KHAMVxdVgraYqaa5FBWP/9jLw6Hp1FkaMX7aCOhZ5+OKEOzNPoWjZC5/tYxaBBPmU66g7ohfc4JnOExnt7B75fNSs3bh+4KgkkYIFFm4EXKxRu+7mfXxtaT0X4huQ8Nyj8mF12MyiJT4T+coI9HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTHNBBJLBmecbTXCvVcHoH7zwMMPZ21WHhByU9d6Rzk=;
 b=DdJppRbXY7c07csFkpIIS+bhngZ5n2jnWzhetng+uUESB47gPHgRFSgKsiP11JyETmQ1YWolHJOq8cvmhNsjbg3pdjwsUDzw1UXXYpQDv5z2Z6RwERSsuCCYH21feI3S0fC7bBIa9opnNh2FoV8Z2kqrwYvJ03hw0BQoYR65wQE=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3550.eurprd04.prod.outlook.com (2603:10a6:803:3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Mon, 7 Dec
 2020 20:15:28 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Mon, 7 Dec 2020
 20:15:28 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Network Development <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: vlan_filtering=1 breaks all traffic
Thread-Topic: vlan_filtering=1 breaks all traffic
Thread-Index: AQHWy0MhpNKtLM78DUiJl/hLVHZUnKnqeh0AgAGRyACAAAj8gA==
Date:   Mon, 7 Dec 2020 20:15:28 +0000
Message-ID: <20201207201527.nbo4jz5bga26celo@skbuf>
References: <b4adfc0b-cd48-b21d-c07f-ad35de036492@prevas.dk>
 <20201130160439.a7kxzaptt5m3jfyn@skbuf>
 <61a2e853-9d81-8c1a-80f0-200f5d8dc650@prevas.dk>
 <6424c14e-bd25-2a06-cf0b-f1a07f9a3604@prevas.dk>
 <20201205190310.wmxemhrwxfom3ado@skbuf>
 <ecb50a5e-45e5-a6a6-5439-c0b5b60302a9@prevas.dk>
 <20201206194516.adym47b4ppohiqpl@skbuf>
 <f47bd572-7d0a-c763-c3b2-20c89cba9e7c@prevas.dk>
In-Reply-To: <f47bd572-7d0a-c763-c3b2-20c89cba9e7c@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: prevas.dk; dkim=none (message not signed)
 header.d=none;prevas.dk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 59902fc0-01db-4899-353d-08d89aecd756
x-ms-traffictypediagnostic: VI1PR0402MB3550:
x-microsoft-antispam-prvs: <VI1PR0402MB3550D75F521F0107F190F5E0E0CE0@VI1PR0402MB3550.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4iftsV4Z3Oy2GYacFNUlaDQHL8fSaBACmMuSvDbGR8tHPWxYOXtm3G2UN+pEyNzsuW4NJr2gvaQ35jv7A0aE6CkiSiK5a7d1mC7KqvzS+synBA45lbPGHUoCralZJ+3wsylLvANQQVc8eGDRNX1dJrhBAU1Yzn0kZIZE45qDo0EfnrKQnyLBGhb7yF2TLvyQLcE3Z3CH2Ag3pw7lzhemcuYcvf3rzDBzFpRFUOqg73tEcsrJ1q4kFwSNYHGyuSpjRAY6dSeRuMqa3hDoAgGzKedfvsIXzqmJfB4k8DIn/tFADQUylXHb00os03ihzW9Lq2cRG2KnN6Q9Zul+/1BU4UapiYcR2sUOJsJQCtQDPNIZmW9st2V60VOtiJ0c7yLtO7kB3d/+NXF8zamZKkezFQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(136003)(396003)(39860400002)(376002)(346002)(366004)(2906002)(9686003)(110136005)(64756008)(26005)(66476007)(66446008)(5660300002)(186003)(83380400001)(6486002)(71200400001)(66556008)(44832011)(6506007)(91956017)(33716001)(966005)(8936002)(6512007)(66946007)(316002)(4326008)(8676002)(86362001)(478600001)(1076003)(76116006)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?lLAHPD34CaFtIyvVeQNGY2boxjHXPv5jihCR8phZj+jocf22/nW+j75+fYub?=
 =?us-ascii?Q?eXz0WA7+pSUUz/6Mh4UvQXdhJEkhLvzpdj28GeRw38IoqjsXBevyihDAN50m?=
 =?us-ascii?Q?WSEp0+H1/hmiLB+zS0EWuVuPAbFmhHe1TbtXzPKkJ1DEkaTpLs6CeLj9y5Nc?=
 =?us-ascii?Q?nCno41feqWFOS8zH6Y7ZxR6VHWo6BYPfyYlXVGwH6JI+4FARSCv0NCfw+0XZ?=
 =?us-ascii?Q?A0bkKJglBE/h4OTE4SyxM9GaBsMFn3Xa3M3RXejyFN7z/q7RjgOo4aTg9UsI?=
 =?us-ascii?Q?v6ELwAlUY0POR8MkwAC4ucgfzrWwNuo8AMAcDz/W98e4QFK5xFjDnGEJn6PM?=
 =?us-ascii?Q?ARuLVRBTwxZnMC+44Ir1ecpRFMayxJJ4+9h6lHa+rP/y34/T3CfErAlWH60H?=
 =?us-ascii?Q?ikRBt6meBnGGD9nYqr/BCPI8FtS3EsK9vGUI27zCTimv1NQ5Umbpp6uiD/hi?=
 =?us-ascii?Q?q2GdNKeWKTB5UHWnH4wxJ2hexinO8HARqZPoIbg9jPJ7Aye+1Qs7e41j9qnQ?=
 =?us-ascii?Q?n/Y8oP1GhLgQQXu+7u974i8XnMYL/LjJ0Na5BpCYT0t9N4o7qZ8ApN11EhlL?=
 =?us-ascii?Q?xkUfB+gh8KREJiqOfuUcCw6UsRu3YyNcfCSOwcLJ5xQ5bOMZU7eQPibl66zy?=
 =?us-ascii?Q?dDQqjjGi4WiVX+mkap7TcEVv27ySBQ3WQeI1ftRZHufkjWMxszY1jZJtyjkH?=
 =?us-ascii?Q?Z1WLBsV+8bkcSEWoZz6Q9XgcvAz/JSFv6t9fG09rsZRbpXHpA+WUyNNIpZQj?=
 =?us-ascii?Q?OEaAVYh/wtWlDJU/V1U2bVmPE1oOJv88GWrFwnklJNg5KAu7xLkqAEHHlmIn?=
 =?us-ascii?Q?R7VUtz8fuQ3qL2fTr9fzwCy6r3wv8FWs7pRSOuzJT1Mugh55VaOwsTflh4Ue?=
 =?us-ascii?Q?CPJ55XbmA4mtv4nbkjFCZKMRsI4GQFWY/0zn2oF6q+LzNLZms7CruVfFU0c4?=
 =?us-ascii?Q?a+HnglxzFWcyOHIKxxW7YRtATdnjByBci9Cpu0dNj/2iuw6SGz9UpAF47bBE?=
 =?us-ascii?Q?bnTQ?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AA4111ACE99524499D74E3343943569D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59902fc0-01db-4899-353d-08d89aecd756
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2020 20:15:28.7266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gTa6WeT+Psp9+1Yk3kVmyWs34RqlkQhu6JNAhPq0zQe3XPHndFOsOlYz8/q1goBWpN6/P3DvkCpPoQUE7oBlMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3550
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 07, 2020 at 08:43:18PM +0100, Rasmus Villemoes wrote:
> # uname -a
> Linux (none) 5.10.0-rc7-00035-g66d777e1729d #194 Mon Dec 7 16:00:30 CET
> 2020 ppc GNU/Linux
> # devlink dev
> mdio_bus/mdio@e0102120:10
> # mv88e6xxx_dump --device mdio_bus/mdio@e0102120:10 --vtu
> VTU:
> Error: devlink: The requested region does not exist.
> devlink answers: Invalid argument
> Unable to snapshot vtu
>
> --atu, --global1 and --global2 does work, but the latter two say
> "Unknown mv88e6xxx chip 186a" (and 186a is 6250 in hex, so I think that
> should have been printed in decimal to reduce confusion). Whether that
> has anything to do with --vtu not working I don't know - the global1/2
> registers to seem to get printed correctly.

Ahh, this is probably because Andrew didn't know how many bits is the
FID field width for 6250. The code has the 6250 treated the same as the
"default" case, which is to error out:

cmd_vtu:
	switch (ctx->chip) {
	case MV88E6190:
	case MV88E6191:
	case MV88E6290:
	case MV88E6390:
		return vtu_mv88e6xxx(ctx, 0x7ff);
	case MV88E6171:
	case MV88E6175:
	case MV88E6350:
	case MV88E6351:
	case MV88E6172:
	case MV88E6176:
	case MV88E6240:
	case MV88E6352:
		return vtu_mv88e6xxx(ctx, 0x7ff);
	case MV88E6141:
	case MV88E6341:
		return vtu_mv88e6xxx(ctx, 0xff);
	case MV88E6320:
	case MV88E6321:
		return vtu_mv88e6xxx(ctx, 0x7ff);
	case MV88E6220:
	case MV88E6250:
	case MV88E6131:
	case MV88E6185:
	case MV88E6123:
	case MV88E6161:
	case MV88E6165:
	default:
		printf("Unknown mv88e6xxx chip %x\n", ctx->chip);
	}

You can probably figure out the width of that field based on your
datasheet. You can probably just put a value in there and get some
output regardless of whether it's actually correct or not.

The kernel takes care of issuing the VTU GetNext operation and performs
a raw read of the VTU Data registers, which are passed to user space
(and where they get interpreted).

Nonetheless, I'm adding Andrew as well.

Andrew, this is the thread, for context, in case you haven't been
following. The threading got broken multiple times, it seems.
https://lore.kernel.org/netdev/6424c14e-bd25-2a06-cf0b-f1a07f9a3604@prevas.=
dk/=
