Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548B244BEBF
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 11:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhKJKfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 05:35:22 -0500
Received: from mail-eopbgr150078.outbound.protection.outlook.com ([40.107.15.78]:55714
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231182AbhKJKfW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 05:35:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jA7UFkruKSOkWLd2bjQxAMdUo5oevr0v57skF8U7zDuxuB9peD8cQ4rIMg0f8E3vmgR/AuI6E+3kLiL2HoAGQe/RhR1GHs+s6sbV8HPLO1JxmB9qsPDg8c7c1rBvqQ5gUZyzlxqJPzkYQ6Gik/o37tfiyKpCynW/G47WpiZTmqSUF9X2ttj7GNDrhwyrDrL0BIjVDBl/jZpd/Ycn/lL04DUZeGtEir9KlrxbBC1KXpISlbOkkTEKoz/+NaFRKORb5QpcE/jM4JjrvVjLJUSSnhz6tjb/UH69cJkDtDdCHVsErN8JbshgEh2qBl7jedIsxB4D4BbK4Nu9Gi6trbRudQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6VsXTz4QaREvulBj4CL/kg91ZCQbtONIlxsDgb+kAcE=;
 b=cD4ey/P0mJ1NBcOrl4slN0uD3cMUka0PgVsw/IvSbX8LKZaH1Wv3JbbVZWpNjY0X+yamTGYTQC0+ouI5K/wDlVHPGgUSAOYj4SREQ6c2qHB8NJ2IVWA0xvg36OizzyWR8DbbxC2JD9qpsg4Gs/fsp+NbbFrgGm/lRTc8R/RRLjGlu+Fn1QOx8NcC52F5TMhJQjaXuGX9LJyEnhvPLx9hsg5Tyas5DHDkTAexe+KUWPQFTnL+6wngKSZlRhjzXhnSn5ZJF7sCpCtjCgMh/NHjLLzj+JqNdyYS7kCw7xaFzITJnsJICG7tOziLRdRXVjpB8K334OrOo/alz6XYKVdOjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6VsXTz4QaREvulBj4CL/kg91ZCQbtONIlxsDgb+kAcE=;
 b=F0JDO6p4MW9sUcBybLjimILutC5gDxnEDCqy6qlhCUwQUmdZ31OnNJa8DWQV18AJWD2k4pF6pMtppnBInnSVGZflCBy/hik8otaH5FP+rgohW7RtYveJrlzrdYaIcJQaZcIb/6s5FkCiU9/JSXFzFA0qKHLOpGI6dImJnOgnb9g=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB6PR0402MB2902.eurprd04.prod.outlook.com (2603:10a6:4:9a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.15; Wed, 10 Nov
 2021 10:32:32 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::4490:a7e9:37cb:99f8]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::4490:a7e9:37cb:99f8%3]) with mapi id 15.20.4690.016; Wed, 10 Nov 2021
 10:32:32 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        Po Liu <po.liu@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: RE: [PATCH v6 net-next 0/8] net: dsa: felix: psfp support on vsc9959
Thread-Topic: [PATCH v6 net-next 0/8] net: dsa: felix: psfp support on vsc9959
Thread-Index: AQHXtxp1Us2Ogn64FkKxLqtQLVrov6vF6JeAgDbhoDA=
Date:   Wed, 10 Nov 2021 10:32:32 +0000
Message-ID: <DB8PR04MB5785560CD2387A9D4FF9E259F0939@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20210930075948.36981-1-xiaoliang.yang_1@nxp.com>
 <20211001151115.5f583f4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211001224633.u7ylsyy4mpl5kmmo@skbuf>
 <20211001155936.48eec95d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211001231706.szeo66plekzwszci@skbuf>
 <20211006121214.q5lrg5tl4jkiqkt5@skbuf>
In-Reply-To: <20211006121214.q5lrg5tl4jkiqkt5@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62e24d35-1037-448c-0565-08d9a435678c
x-ms-traffictypediagnostic: DB6PR0402MB2902:
x-microsoft-antispam-prvs: <DB6PR0402MB2902A41B5F0314352447D26BF0939@DB6PR0402MB2902.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pK4wHjGkAilU6GroM6idNy3ljRUXM/8MY23RgBA0DP4PiP3JuFXVpuOQY2RiA1lr5ffvSZER/qjk4zGhwAjAljm9ku57Le0QynO55RzcY8dw6LFuvDMkHd6Dkk2UzxDGaDn+nbAizN3jspvfvbae8XSuhbBoNXSZBLTx6MUSxGltqFYPoON6CGrvphDzrpiACj0MDGLXEPljX+xEikMP6CW/KC1TLX2t0hgO9HQqxO9n91In0NYJrDLZLVQ5zemjhY1E7UqU8jvOdUTg4CvR9G8b+CJ/GcpOLMam0apVcaXHTOg3dkzgRK4OuZm2f3y4HfSsY9oW4XkAgDdbWJnuUPL7Bcina4zWQoGWB6xNucmoVbPuuKY866pH+cDg/8Y1U/FjFxBX6bsV+7/W0uu12JjJt33pgwFyfw6UunmFB+hoTZ+bt0Cu1DEtMq8LYB+QXabhFt7UPCv9qTaessH3kHhpvjziwuATV5EvjT3gccNgXFI4dV5/tEvC86QN3HXEuopjIXgR5D4ofh9Cjj16G9Ho6nNZoRVAZcS73vTenyC17QFM1x+u56TFiLHvSp87gms5y7iRPsqEQuXtsfWrqz+00XJGaYbXmFp5IOc8cwhqXUnUZJpR6CqndwOKb5kR4uL1MCTWYlPuKv+TuqIjR/6Hf7E7Dup7lKbXP71+wrcptEw+h4JFJOL+l2ndJzco0hCPMxG9+eajn8KqujymLQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(38070700005)(55016002)(54906003)(71200400001)(8676002)(4326008)(33656002)(76116006)(86362001)(26005)(9686003)(66946007)(508600001)(66446008)(66556008)(64756008)(316002)(66476007)(8936002)(186003)(53546011)(110136005)(66574015)(6506007)(38100700002)(122000001)(5660300002)(52536014)(2906002)(7416002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OaVY8PpBOnZJrv9hcla2wZwG2+Agtba8ApWLcGpLJFPigXWCLo6vBrdokx3f?=
 =?us-ascii?Q?iMPzk8kcC3/lK1jFpnBrjcf7FFD1iST6cr53Bo2gacDGbYIOb44VLbOvfTY4?=
 =?us-ascii?Q?UN6/7nrTGaHRKhg8y0CMQnYmd1j+4ad2n/Up/0RWO5sD+vkxojyfVuhiqMn/?=
 =?us-ascii?Q?zGqTSZz1ltvbFpeT+f4BHKgjQ/z5LSkpe+siZiPH00Mx1/HhCrRH9ergjxrZ?=
 =?us-ascii?Q?QazbC40PlQujZ132Rzik8HUFl/L4Nh26RYI8DqMTvl9QIvUVzYsMz5EmSSMk?=
 =?us-ascii?Q?ZHwEDfMmKvXTtQEeKO4GR6JFLullottEEH/SJOZRcousW+cXwEil+oMOv7zJ?=
 =?us-ascii?Q?1BZqmLLWUjcRMAWC0NyGrhSL+zJ92H2DyTbqUX7pdRnrKo3AekLh+FiChqV9?=
 =?us-ascii?Q?Hv4fnCcsM/0Bepfrrxnza38fOyrjAhOfTrn4qidHE3Lobxx150Bv/b4Tyv3H?=
 =?us-ascii?Q?toWnZ/uFF/DdEt3Xz93HCQn/LYileesEomglQNNgoCKZMA70LXG/HTIHDgDg?=
 =?us-ascii?Q?0MXi+D0X7KHdytmU6N1JVydPpR/sQrDv2/idHCAIF7q9bUAIBslJY5q1RwI/?=
 =?us-ascii?Q?lwPOwd/P1O8yYo0g+7e2pMMDWm9IKB/+ob5+wTr0X2GCv6PkdiBzyZGoP842?=
 =?us-ascii?Q?U1U/5Us3au3uTP3XcFLIFjgHcr9YcnO183Sg8cCsTPMud1hlORmy899/+Axw?=
 =?us-ascii?Q?2IUbdCPZAPon7nQ1XQML/pHHUedZKkqH0rwaS293CUptUXbQCHr8Qhjq40HB?=
 =?us-ascii?Q?YikkuCPIDEtuXmwRi+v7V1jvUl7dWCtl/sty/DYz1HsdPryYbHZYBiKrXvOJ?=
 =?us-ascii?Q?vWJyAX+M2yas6D1wer/DjLdu65nVILhxqn0sb2HcSCePkkmD492vlAXcP0/4?=
 =?us-ascii?Q?PwC/6JO0VWr6XDxsS5CGkuiycgpkIcJs1zhRoKQvLBZVyusd/81qFp3OxR8j?=
 =?us-ascii?Q?ZNOOKageCxvyhS62pDeMJYvmSDZoRVcZmZidCkRlgkueQllyr9mpHi5NiWV5?=
 =?us-ascii?Q?TVEtWodY46puI7yOOx1TZvuYOu1/7FRqFt3WWIuIOzZDL+90IQyYk/MXLqVH?=
 =?us-ascii?Q?ObfXuFxexN3wfmzN9UAscq4D2+APPfCETlLczzz7Wu+Drj0qxPxANYsciFf0?=
 =?us-ascii?Q?zA2Lu3RLPv9LLuZx0I/PSBChVXKs/kEQbQJM6tL5SuqwSXO/IH0z/rQSmKhQ?=
 =?us-ascii?Q?8UPooZFaIHnZtQZoLGwrc5+5upU27MjudwOtKr6K08DQ19o8ziQFffO3m4/M?=
 =?us-ascii?Q?s3pc0FU2sKFdRBv0l5hZ2K0KBwzW50KYxQ1+InuDW2fm34hpm1Z+33FiXJ5L?=
 =?us-ascii?Q?nc0erTBXB0/Wv43vLm+54QcCLuonmx1z9jk8bSNC/sL7xT8azHIXb4tTaji9?=
 =?us-ascii?Q?wUq9sM75TPlFSIttaS3X/Mi7O6v6FpB3tQcZfFGZhy5+Nw1PPRlIFaaW1TTc?=
 =?us-ascii?Q?fLf6kJ3MpKH+v7IsAYeZnNNl6JmpimKmGcqZy4lXRLzoicV2qXl+W4DreRyu?=
 =?us-ascii?Q?cFafwJYaWcA1vsieDnVpiVBrJY1yWeG+7zb5mwaoY9A/WnoFqMfAWImGUr80?=
 =?us-ascii?Q?MVVJQGPorytOEg2bHfR9bhChAbBTRlUOn3MvNakXw+XOjCKryf2fMOclML0k?=
 =?us-ascii?Q?pMi8ytud9RxenMQhOwQhQj9X5Us5VBH++5oWQsVpRxodipDm3B9Hvg0h345v?=
 =?us-ascii?Q?WgObuw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62e24d35-1037-448c-0565-08d9a435678c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2021 10:32:32.4269
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d8Z6JoHcgaXa16kp6wkGtwuI6RA5HQMK/CisEVloEvUNbu9modJV+RBaZF06OIEHpAhjxkPr4TiWqP3YWeE8k+Ly52z6hFk8ZGh8N1FViGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2902
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Oct 06, 2021 at 20:12:27 +0300, Vladimir Oltean wrote:
> I'm very sorry for being late.
> I wrote this selftest for the ingress time gating portion of Xiaoliang's =
work:
>=20
> cat tools/testing/selftests/drivers/net/ocelot/psfp.sh
> -----------------------------[ cut here ]----------------------------- #!=
/bin/bash #
> SPDX-License-Identifier: GPL-2.0 # Copyright 2021 NXP
>=20
> WAIT_TIME=3D1
> NUM_NETIFS=3D4
> lib_dir=3D$(dirname $0)/../../../net/forwarding source $lib_dir/tc_common=
.sh
> source $lib_dir/lib.sh
...
Skip
...
> -----------------------------[ cut here ]-----------------------------
>=20
> and both tests pass with OK, but here are some parts of my log:
>=20
>=20
> Expected filter to match on 0 packets but matched on 2 instead
>                                           ~~~~~~~~~~~~~~~~~~~~
>                                           I put "psfp_filter_check 0" at
> the end of "setup_prepare",
>                                           during a time where it is
> guaranteed that no test packet belonging
>                                           to the TSN stream has been
> sent, yet the hardware seems to
>                                           spuriously increment this
> counter. This makes it very difficult
>                                           to actually assess what's
> going on by looking at counters.
>                                           If you look at the comments,
> the SFID counters increment
>                                           spuriously even if I delete the
> MAC table entry.
>=20
> Hardware filter reports 0 drops
> OK
> [  275.429138] mscc_felix 0000:00:00.5: vsc9959_psfp_stats_get: pkts 1000
> drops 0 sfid 0 match 1000 not_pass_gate 0 not_pass_sdu 0 red 0 Expected
> filter to match on 1000 packets but matched on 1002 instead Hardware filt=
er
> reports 0 drops Accepted connection from 127.0.0.1 Accepted connection
> from 127.0.0.1 OK [  288.091715] mscc_felix 0000:00:00.5:
> vsc9959_psfp_stats_get: pkts 1000 drops 1000 sfid 0 match 1000
> not_pass_gate 1000 not_pass_sdu 0 red 0
The hardware count also increased in my test. This happens occasionally whe=
n
first plug in the internet cable.

>=20
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>=20
> the driver sums these up and puts them
>=20
> in stats->drops Expected filter to match on 2000 packets but matched on 2=
002
> instead Hardware filter reports 0 drops ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> however "tc -s filter show ..." shows 0 drops, so the information is lost
> somewhere along the way (the "packets" counter is correct though).
This is because stats.drops has not transmit to flow_stats_update() in ocel=
ot_flower.c:
	flow_stats_update(&f->stats, 0x0, stats.pkts, 0, 0x0,
                          FLOW_ACTION_HW_STATS_IMMEDIATE);
I can update this though the stats.drops is not be used for other VCAPs rul=
es.

>=20
>=20
> It's very hard to have an opinion considering the fact that the hardware
> doesn't behave according to my understanding. One of us must be wrong :)

Thanks,
Xiaoliang
