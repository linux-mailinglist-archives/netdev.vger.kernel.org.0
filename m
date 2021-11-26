Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96F145F294
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 18:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235224AbhKZRGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 12:06:30 -0500
Received: from mail-db8eur05on2076.outbound.protection.outlook.com ([40.107.20.76]:44641
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229769AbhKZREa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 12:04:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJ/n8RJxKRzxKrdoKMVMFIrSZLs0ltpz9uU0+BVsPTyogKMAcjEngyYW0IwuC+wXwTtg4y7+WEi+CXGvV0jDN99MrMTGbVO4QTv2ZYvvLaLngpFz7VvupwWyFDcVMYic61L9zUmYuZ8kiK02XVx7lR6tGqC3SxMECOZwMtDW92daDMd4BMvlApIKROu+DmLMVv559q6UnH/2qLt3MMq8p45TPDyE8rQSjOliSXbMRpckQLWeEJiO6MNOJMLBWn/OdfTiAk+34U6fk622DLiEB3S+rxLGS1pWQeHxZAnfob50gtUl1M7vhNQZz3eaBFhcVAcPPwYZ/XmUGFCEhDCOyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vEB/8LgmZRmfu+dn069P/ZUagpMWj/XkEnZajRQEJbs=;
 b=b6dbJLQAxdddSW5MtzalyFZ7N6O8cCHJBcHWl/0VnciC5byjVsQJIEG7NA/cu31mJOCWzk5FKM74DiF9GL4DIxf6Io35EitricK1TlxeOi/BOCdgYwqhqB3Cc2nOHSeJRHKwrfSotZB+9Ig2colsPwA3fsemeZDVjKGzfTcClcsRiukeVQt/sUJizRGTNexK8G2k7qb8GQTIdjlRzR5wuz04yblf7fZGpE4ZJBtghkEQ5uzFx+lkdxb/m2CcJXBFSS2n+8TB3oqNozufvFNVx/39BsKXfo+4liLVfLuJeceXOAjwz5MyoXV4m28RMOR/yKNqd9Lv5bp/p2IlV7AZRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vEB/8LgmZRmfu+dn069P/ZUagpMWj/XkEnZajRQEJbs=;
 b=K8hnyqB6QQpODsIaQPsp7dRDVGFn6ZEvj4cQuBwgm9fK99c77M98/3XJ5MDZPRbfUn5hPeDuqiYqUYH6wEaNVIRyms4TEwdayYxohHeeN5BdUcdvyTvwhoL8KbIub5Gp422FgYd90VTSFZNRJSnF93Jml1ehuIzuugDkFrFJwAM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5695.eurprd04.prod.outlook.com (2603:10a6:803:e9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Fri, 26 Nov
 2021 17:01:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 17:01:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Po Liu <po.liu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.B. Lu" <yangbo.lu@nxp.com>, Rui Sousa <rui.sousa@nxp.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>
Subject: Re: [PATCH net-next 4/4] net: mscc: ocelot: set up traps for PTP
 packets
Thread-Topic: [PATCH net-next 4/4] net: mscc: ocelot: set up traps for PTP
 packets
Thread-Index: AQHX4lM42QuMRV/jlUGB3MXS4i2cH6wWCRqAgAAArQA=
Date:   Fri, 26 Nov 2021 17:01:13 +0000
Message-ID: <20211126170112.cw53nmeb6usv63bl@skbuf>
References: <20211125232118.2644060-1-vladimir.oltean@nxp.com>
 <20211125232118.2644060-5-vladimir.oltean@nxp.com>
 <20211126165847.GD27081@hoboy.vegasvil.org>
In-Reply-To: <20211126165847.GD27081@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 516683ad-9208-4849-0781-08d9b0fe5a92
x-ms-traffictypediagnostic: VI1PR04MB5695:
x-microsoft-antispam-prvs: <VI1PR04MB5695512563A220C1C5FE9C6FE0639@VI1PR04MB5695.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ggrO629dLhRrrmMAfDhuWo//9+8oLbLtPLmxpyL+h2Bkn8Tj98MKt9xrJGs8riV7dfOg9ZXaKjcsy061vZv6IbBaGt09BdjHXxMHR4QNXvRnroRYdu/TItCUslMxnt5Ev9UQ8HGg/RjxolRZT/nKsVzgyZ5pH9LjPkHoEcYWF0IuAHkD37rcYUeL+/xEeevyyCoojdByWsI0+kZjRvnxROvvKamA08hJJSKmX21fToGAjYRpWN2PXrP/vDn2SUKYyCeuAl9t/2aSJOT3pOu7DPc5tFPjHCAWimaL1ZpFvgOK7pbn+eA98cdpcYY2AN+tfoQ0Urz4rD3w+WaQiH48R893Wbw+h1FX/+HkBzHpV7p/nrHVuSi3p6yMFbSpoVSL/fp+HgwtqVJnXW8zAH1CBVYS9tACs5H+0s/npdh+lIFIJi2hS88PaScTLybS9p5HReXHvKDQF7IO6XJMYHBx6mr0YWwaFXJNaJB9MSiZehkN8YopPkrwf+ZbldoSZ3cY0ItCcgIcHfbItg6GFy+RElIjvynY2saJkH1rYy74TGPAgT0IkXJDfFosAM+oPIBNlTGjiKraFbnRyAX5J+geSU6KUygWDLOL9KeodW9J93IW4hFZ4w5ztPJHdJvLmyFMPI2cC/z//a6tduxPlb6bO/1STSKNwq+X0YBpAuhheWXUxQvT/ccrNDzx/6WvL/XKOs1gEWzD8klYpK/s/eDCeZqvxaWCU6zO4lVoF9ZqRDj77iG97EZjdp+0CZwU/9Q5yDzp7PPQUD9ydJ2G0vHchyJReC//EMU/CBk3AmDFNIY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(6512007)(76116006)(91956017)(6916009)(9686003)(966005)(66946007)(86362001)(66476007)(38100700002)(122000001)(8676002)(508600001)(5660300002)(44832011)(8936002)(186003)(4326008)(2906002)(26005)(6506007)(83380400001)(38070700005)(316002)(71200400001)(6486002)(66556008)(66446008)(54906003)(1076003)(33716001)(64756008)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4VOJRRQcAQn5reHltJwUy0wMH8a3g59cNbvfsQuFXzlXmSup+feebzb0xhMb?=
 =?us-ascii?Q?feHuZYIeHwXgg9sAWFSRw7VUjF/i8ssvCbHd8vQrkxg6W5XsCUCQCH07BdAm?=
 =?us-ascii?Q?2yAQDFw1fVDQ0/ZdfNOpjtRWbH1hVgI9Q06YEv5utQ6IkhuMjAPSh+gF+tuh?=
 =?us-ascii?Q?k2d69EwGlj6508Ri1147myq2keB+TLXQ9y2/r9BCBO30+1UCpu51M9rLU5mE?=
 =?us-ascii?Q?GcpIKqJBKgQrJa6rJ9v4E+kGMs1zSycEnMR2IIhBiTzvza/M8R7aZMbc0EgN?=
 =?us-ascii?Q?wXc+V9BKm9JWMW8FXgXjStSmHRe0kuYLiB0HfU1hX4WbGEMFpee7WhZO7q4k?=
 =?us-ascii?Q?QktN/SK7/ljs2vl505Noqe1oGEp/524oiu5v7DqcYlAVa58YZwynIZlePJQ9?=
 =?us-ascii?Q?FCF4jirrK1Nowphirw69l8IxbQS+Jw4YMq/xZa/JHi2TVhJTYMfYriSXBCmp?=
 =?us-ascii?Q?lkapBd0Pb1eFJ1tE0B3Qe/Gohqu+/EzM+jBbSvPqdsu9Ypmkd/pk2Tu/N91h?=
 =?us-ascii?Q?ktePFoWvB96Y9oOkE2WNnVvlOYYFvQ62Mkg4n261OEsV4xPL0yVHs8b3ZNso?=
 =?us-ascii?Q?0/ALO3b5Iis3gOulxDcrSQ2WfRRTy5Hb4Lv0SK1C8RdYMunaSCPevX4R+BM3?=
 =?us-ascii?Q?6cakamVIv3k3onTbJ0MX5+8TTcQD9XQEhjRZu99KLIa5/ceprGNpLT6BPwQj?=
 =?us-ascii?Q?dwH5FB5BHagvRgLGnvppW/0nOW0KxuwDklchR/zTSVazbIAsf7ImtpxELRB+?=
 =?us-ascii?Q?VY4W3RucmwVoLS/C3bn0O9RrItraXN/cayUMe4omwpC1Z/uNSCjhwCID7Sgt?=
 =?us-ascii?Q?rtQVce7xOOxiN0LhRG9N1Rfp0+47mOmSHK0wXsSkJxVEFT2E1J5DRQap+vD3?=
 =?us-ascii?Q?Z3kmQN43gu5lXB5TegMquOf5ccSRc4/nOD1HykA/0l2CiI1jqDSETBTsJ4P7?=
 =?us-ascii?Q?/KFY7uId76odp4GJvpNJjKL7T+TeWOlzqgmzj4iBeCm281KUqVlY+lAOKA9H?=
 =?us-ascii?Q?FYzzM/qPa+3JRW1HDqZyYcDNOoQgDS5/6QnwsNnAXfgpTMj0bSagrOIsdevO?=
 =?us-ascii?Q?gfKZ8kjz4M/lwX+E2MEt0AKgMN4+a3Y+79eU7QNghtqBfNdTo32kWmvLZkWy?=
 =?us-ascii?Q?yLvCL8q9nnxhGtXcuMjSWEDX9W2KmecRQU7SsupTentucdXHj59OV//3xkn1?=
 =?us-ascii?Q?ym/WYq8ueESDWmwyfZ31TJXWeppHJMSOIn7VhjUAaiwVuUcIuohyRSCb79+q?=
 =?us-ascii?Q?A3hXSqUnWTq4BBXgvPGAjFZfWUgeFEg8CZX+/4TCaz+csXwGEJDep159s6ej?=
 =?us-ascii?Q?YQTMoaqByLRegiAnZHbb55rn/lOP2VnVXmW50czIUS3i0eI6U4gDeabgn5Hb?=
 =?us-ascii?Q?0tOGGKNhkFxEtlS/IozokivchPDycolzIxE2WuUqMb8GsUQN1TbIfLVM7UBG?=
 =?us-ascii?Q?DiAti717KDrXP2QE/q7kYEltPGxFev4rEUH/x+vE1kwUC//SoVcnH+xSAu9k?=
 =?us-ascii?Q?nvcqQFjhJvh6lRDZqpTWujNyRAIoWujRc1G3+TpGQbY64bIfAQ7EIy7KPc0B?=
 =?us-ascii?Q?cymNvI/Nimxmhk84qeT2myyeg3umTDt0vDOaKJiYBp0CeUU3cv6arOAc/K7V?=
 =?us-ascii?Q?YzUa8Vzurckzc1b0Df87M64=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <64C5E8D7678E41409090F060511A1BA7@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 516683ad-9208-4849-0781-08d9b0fe5a92
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2021 17:01:13.5118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lXODFy7iLP7KxHm37buUtR4Ju0nfy+GQgnu5FYzdPRutasRmQoRY+tez+Ne2Ss7t2AinJkygXIh2frYu5Xsigg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5695
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 08:58:47AM -0800, Richard Cochran wrote:
> On Fri, Nov 26, 2021 at 01:21:18AM +0200, Vladimir Oltean wrote:
>=20
> > So PTP over L2 barely works, in the sense that PTP packets reach the CP=
U
> > port, but they reach it via flooding, and therefore reach lots of other
> > unwanted destinations too. But PTP over IPv4/IPv6 does not work at all.
> > This is because the Ocelot switch have ...
>=20
> Not that the details are same, but I'd like to report that the Marvell
> switches (or driver or kernel) also have issues with PTP over UDP/IPv4.
>=20
> When configured with separate interfaces, not in a bridge, you can run
> ptp4l as a UDP/IPv4 Boundary Clock, and it works fine.
>=20
> When configured as a bridge, and running ptp4l as a UDP/IPv4
> Transparent Clock, it doesn't work.  It has been a while, and I don't
> have the HW any more, but I don't recall the exact behavior.  I think
> the switch did not treat the Event frames as switch management frames.
>=20
> (BTW, running ptp4l TC over Layer-2 worked just fine with the switch
> configured as a bridge.)
>=20
> Just saying, in case somebody with such a switch would like to try and
> fix the driver by adding special forwarding rules for the IPv4/6
> multicast addresses.

This, to me, sounds more like the bridge trapping the packets on br0
instead of letting them flow on the port netdevices, which is solved by
some netfilter rules? Or is it really a driver/hardware issue?

https://lore.kernel.org/netdev/20211116102138.26vkpeh23el6akya@skbuf/=
