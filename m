Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F07845EADA
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 10:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239468AbhKZKAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 05:00:16 -0500
Received: from mail-eopbgr40066.outbound.protection.outlook.com ([40.107.4.66]:8206
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1376629AbhKZJ6P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 04:58:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LgOdpX4L4QiCnRiNpqkWMi6JSRm6OjVKvH9tMDITrL+P07qEuHqfGAu4LepDvPR/0X9Y/fzm+AJ8CimKCVd+m0w2YRXstVEiRe9h6/4NnBSAafwSkM2G2kFqq+Y7e/5iwZByZNaa1tG98ADpPG3gtqhcqJB5XxVZ7C9K2Mgzl5Xeny/06u8VpgSDZWa3c/0YdIRCeJKBG/irwpTqBgSKg/njUQo/WkUNRNjPm3ruZzrVHkH04b239+0Wj/r3IKRMrMrcFHMqDDms0dcqgmu6v14ZjSDDivRcqX1CN3MgSLijvnwvWO0s+JIqi8FFfwNZP8lKr8IIGkhm2PZ1Nb1uxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ekAuYR1HXe211QxRL263Apniebvoh2GcVFHQ9Ej8ubM=;
 b=J3e1TxX7x94DjEf+oiDHn/ve97WE9giEWt1dMbX9+axqRdTKdnn9IJYkCBhemDSdjxpWkgXasgBBtPOSWg0VtlioZg35Mygo7lbWeh0z6Z4msIk3cSQCgqFPyauNVkxoXFiHmqp14C7gR8KWaGzDgBvDYm6iMJ3sqsOcF9hbb41XqmSy0IyL0E4/YqYrE0tnKbqmCbC3MnrKAdjA274usx2WLXk8yrRkXALc89P8zadRihS+zehmvcAJq+Cczdiz4EUThV2v7D2v40pbk2qL1R30nIn63GJSfgoNBMNBCa/RVQi5TzzPu94uOz6z6F/E2Do/ZIZk4yS5wLdzb3afvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ekAuYR1HXe211QxRL263Apniebvoh2GcVFHQ9Ej8ubM=;
 b=D/7OfG1m3CPQzB/kOWecDhYQN0O9gV9uNOpSiCGvDW83BKMCOo2Z/T/inK5ZPNZFAu9jggzYIjCUlq8XMR0v9SYfvkisBFAvgXN71+F/AV/Qtb0PGw8BG/QSmmto4M0uLRLpzZ0GJ+FT1oDkIl/M6QsYFyaclaAlyyeZxZoLgPM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6509.eurprd04.prod.outlook.com (2603:10a6:803:125::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Fri, 26 Nov
 2021 09:55:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 09:55:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Po Liu <po.liu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.B. Lu" <yangbo.lu@nxp.com>, Rui Sousa <rui.sousa@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>
Subject: Re: [PATCH net-next 0/4] Fix broken PTP over IP on Ocelot switches
Thread-Topic: [PATCH net-next 0/4] Fix broken PTP over IP on Ocelot switches
Thread-Index: AQHX4lM06ld1R/REck2gHqZwslJbh6wU6FwAgAA2rYCAAHOqAA==
Date:   Fri, 26 Nov 2021 09:55:00 +0000
Message-ID: <20211126095500.tkcctzfh5zp2nluc@skbuf>
References: <20211125232118.2644060-1-vladimir.oltean@nxp.com>
 <20211125234520.2h6vtwar4hkb2knd@skbuf>
 <20211125190101.63f1f0a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211125190101.63f1f0a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 202af802-293f-45ce-bf72-08d9b0c2d007
x-ms-traffictypediagnostic: VE1PR04MB6509:
x-microsoft-antispam-prvs: <VE1PR04MB650974921F491C4D4C18C22AE0639@VE1PR04MB6509.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 95ZSUrN8nJyiKT7eZHe+HZCVmA32D9zbR5Gay0bYjIwH5HCEzBI3y14Sic9xwdPMlBpOqgVzMaJ9Uo2V5EDfwT1+SCuhBzNsRYPe4NK28dhFh0SQ2c35lCyrcAE4jXPJcet9i5Gdc2tv7Tcigl3dqWaUX9w9WqOy5dMrItMfrES9mw1hL/T4hTw1Vn/aqgOmdfe5TeIBnm0uCkEHToqnJNgPREatikyDeUAhdmmFJtPfBuU7ZblFyWKPbM6NEydlJ02MCp7g/uQdi8fIuuGlIcXdrvK+H/t1PmO4qpaY5WymHWmP42anwz5PJ0v2zzIS2ghmZdJshbjkHfOLt8RFtTklLQQjfJocJmyEjBIST3Z74S7BWWY+iTqTYEyWqzlja6l+1BC5ichyryztCQXfBKFKyQ3z/OBgj/jVZgig+lpdydDu6JJOvW+fmci5CkbTsx9KtgwiYjWU+0eHYroSa2+oUttB3u9kr7avDiqFqCOMM4HR0vgd+CFfgX1lr2nD20FTd5ZpEaB3eqDh9SGc4PPGLg+u6L0B0U8I8aj+qECRSiZ2NGwLpLhEgc8x4S0VtRxmC8r70MN6hn+780/eVPZ5Iwpwu8/mzrgLpRIceb7dbkM4bXT9Tufgiu82KcaSKbTMNmKyLHX8Jvwvz2Bk6wazJD1/SOoWp9Js4ZnEJ/1rUbbrVqbnDWnBsgaq8/KewM+nbYLEC+ebFVJo3sTGqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(66476007)(6512007)(4326008)(6486002)(508600001)(76116006)(1076003)(7416002)(54906003)(6506007)(26005)(5660300002)(66556008)(316002)(64756008)(9686003)(66446008)(8676002)(38070700005)(71200400001)(33716001)(83380400001)(186003)(91956017)(6916009)(44832011)(122000001)(2906002)(38100700002)(8936002)(86362001)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kpoyX9hDvXvSYwFxGyp1q0H28QSmreEJG9jR67W4oBqpqcXlQU2+8Xzlv6R2?=
 =?us-ascii?Q?vpumFtxcBz+jFBfeoEQZCpdFTpNWfLFGWX9XZPjRwYegIyGwWVwOS8lZDzm7?=
 =?us-ascii?Q?cYS/1dqQMMUdZc+ECuIPMpN36kEckZc93YhvebOJLMtn3ovtlUHg5y3ld9tU?=
 =?us-ascii?Q?vRjV+QK82kpEBZgYXIq0EvBcl4b42AtpVmMq0/bdEqYjoFfzZXknUX8j6I9q?=
 =?us-ascii?Q?mmyvdTv/92T907Zq8ECiHKmP/y6FUgwsceqa11f9lyzY81mJbGb/cXm5zXl7?=
 =?us-ascii?Q?vn2y7ZeOsl2Q4azn5JtjiW+gi+pZxtgrbi+tMPdiI/IDIsGkj+BCc11WcL5I?=
 =?us-ascii?Q?AjyDIx/d3l28D0ELmqZvYMMkVPgqFEQ9L3natcY92r9ZoYoqwALQv0BSK8Cd?=
 =?us-ascii?Q?Jt9XJ9lLVhtdEMjbE0undFcVCxRNOp2SzQjkinCgTnTTG5VQ/9Cjbhumvvuy?=
 =?us-ascii?Q?uLLX2TXjiijDL2CJPxhLPqeGCytqZYmiwL16vJe3X7tVQx4WsMq1DV+XvLeK?=
 =?us-ascii?Q?aJlloKa4hsnQKNmeyZPMd4BFQaHu7Q9ijLWVHAoKZksklxMnNG6dMHi+068J?=
 =?us-ascii?Q?puf3FTs/0MpcwQBNPfQUc/M/V9NmcWkkRWrnzRdMsoU7ACQQCO18gTjYz8QM?=
 =?us-ascii?Q?qYWM2D+6VxoLFIxWibKJOtJ0J1n12eeiG2qxPa5ZIwTFKv214hRngHY8+5pT?=
 =?us-ascii?Q?X2V0XYo/6wmyK7oYjezLvHVIlVP+GaaYINL9czGIJr5Qr1VK8bK0/BHhyJ0M?=
 =?us-ascii?Q?2payyvUYIbwOo/TmcoI7naZ+W0olHTArBo/BWY3bQm6061Uw4b9lkhkd58f8?=
 =?us-ascii?Q?oYgpnuvltCufMoX89thD6dVzrz7RVk8T5nTg49+AOz896gxQEXv/ZgIMJdtX?=
 =?us-ascii?Q?FXJ49I1mFL9Z0H62IF4wKMKuCcTQq2nytbkhfaInhONoCoWoYRMmrrEHgSBg?=
 =?us-ascii?Q?fBh6C5O3iRwWzfg5Oyy3XTSu6R2ik6wXEWirAW4UV/cWFZjHB7qeBGBusEr7?=
 =?us-ascii?Q?PtqKPkMXbypRNtdHzQi5wQ+HiZ78IxV2t73UqEKQ2E2iQQnpgCWD5arFLLwO?=
 =?us-ascii?Q?AtF5Gr1rkcwaw8IZTa6xaJ9G0Z2qE9d8UNpS7vKVA462DEqlPzjQvwa8/gO2?=
 =?us-ascii?Q?JWhDx+8nSk8lZNzU1/01N9HMi4nkvj7wL6zEZe6bsCo0BVt3uU1EOD2oZx7t?=
 =?us-ascii?Q?THibUj3Vu/fsQbFXE1AVg4l0tpk9HXWqs/29ZW54becLX4qKXzHN0aR6xeHq?=
 =?us-ascii?Q?R/2GzxdpYuKk4fpT9QtQcS4xmOvMO84jZjnboY0nmLimxHas/aPX5K3VF6K9?=
 =?us-ascii?Q?ZG/rY6+Kb/+uwNCKMNdztQ/c4YeUChix+uNx9XhlKatACuh8AscaJKN5Rfo7?=
 =?us-ascii?Q?uBqQTXvLSU1Cz3efaV0AAKK2BXm2M9SqOOZovlpV8PR7edIMkVdBQ/26TVn/?=
 =?us-ascii?Q?xi8Wz42ZW54JoBuwtP5Bl7HVPVvQN/LBiUCR78cPMYJ91sxE5f0yOsd1AvlU?=
 =?us-ascii?Q?BTeulkxKuflgiwyUp377D0unzjHkEy89W2vcpqBOlNPSUfoLtub1pe14gxGC?=
 =?us-ascii?Q?bLVXZ/fqn0y9/kp0Qjtkf8pDKcAmygsqaf7SrDXALXG0wpdliRcCU3Ea2gJS?=
 =?us-ascii?Q?9eMajJHKXtbB8E+QxUHrDPE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0A0E9D45D54E31449078B5969413D1F6@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 202af802-293f-45ce-bf72-08d9b0c2d007
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2021 09:55:00.8259
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h+xIuCT0Ko+pyX6HXfRlOI33IZrTm3/ZN7agGyXjob//HOrylSk7BC3TII/HBEZMZ8smD22hbmH+YebJGh0d2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 07:01:01PM -0800, Jakub Kicinski wrote:
> On Thu, 25 Nov 2021 23:45:21 +0000 Vladimir Oltean wrote:
> > On Fri, Nov 26, 2021 at 01:21:14AM +0200, Vladimir Oltean wrote:
> > > Po Liu reported recently that timestamping PTP over IPv4 is broken us=
ing
> > > the felix driver on NXP LS1028A. This has been known for a while, of
> > > course, since it has always been broken. The reason is because IP PTP
> > > packets are currently treated as unknown IP multicast, which is not
> > > flooded to the CPU port in the ocelot driver design, so packets don't
> > > reach the ptp4l program.
> > >
> > > The series solves the problem by installing packet traps per port whe=
n
> > > the timestamping ioctl is called, depending on the RX filter selected
> > > (L2, L4 or both).
> >
> > I don't know why I targeted these patches to "net-next". Habit I guess.
> > Nonetheless, they apply equally well to "net", can they be considered
> > for merging there without me resending?
>
> Only patch 1 looks like a fix, tho? Patch 4 seems to fall into
> the "this never worked and doesn't cause a crash" category.
>
> I'm hoping to send a PR tomorrow, so if you resend quickly it
> will be in net-next soon.

It's true that a lot of work went into ocelot_vcap.c in order to make it
safely usable for traps outside of the tc-flower offload, and I
understand that you need to draw the line somewhere. But on the other
hand, this is fixing very real problems that are bothering real users.
Patch 1, not so much, it popped up as a result of discussions and
looking at code. None of the bugs fixed here cause a crash, it's just
that things don't work as expected. Technically, a user could still set
up the appropriate traps via tc-flower and PTP would work, but they'd
have to know that they need to, in the first place. So I would still be
very appreciative if all 4 patches would be considered for inclusion
into "net". I'm not expecting them to be backported very far, of course,
but as long as they reach at least v5.15 I'm happy.=
