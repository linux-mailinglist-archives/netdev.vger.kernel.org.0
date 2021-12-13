Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8793F471F0C
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 01:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhLMAtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 19:49:07 -0500
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:60480
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229540AbhLMAtH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Dec 2021 19:49:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EqjtaXhfGn5Cpo5bD7tOrNmD063lTUebiLn8biNuNTtesDFE1wDfUY/UOkDLziT8EPqjdcRrn1y4gRDMYDuQyM6MOBjf4hvsIJVX0yhiq31sXu31MSE6TFdDFj3c4+uF/CKlgdqiA2u7xU5izaDC/PmZzSzoLi6UsGbC0IL1U6/BDPXZRlt9Fdzm4r6Ml3QtNLb3F+EcHRPSLb3UcfKgFKzDfhbcfBttpw7WS/20bafWrTOSsTc+LIQJw/Pq+5rACltKBqLbtWBzPSzTL4usw0Rm8H8B4yQL1HJcecBWlHOSisfjujiHyiuZro5/Fpme8y1rbYrPiUcaSP++sEn8UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XHSIMfwbB24gtoLFlnTdQBHR/grEr4pGBhT1XjxBnSk=;
 b=UKff9Fhlr8NHlqunpflHy9dvInNVaVvuo9V9HIDm3Fo/bSeSP+/rcLFHuY7GdlQww8DZTVPBCAd1epFUXQCtOM/c3PPiZNUKPh2A/4vTb1H8PSwrSnoxoeh8ySMktJJF7n1+wR+ppPc3PUvTUJlnY8fTIQVSCXFesctnJardT+r+dQIPpMjXIE1/PAvt1gov9j/X/a0CWFix+FZLBv5uZlcDIIf9x2J63aGwXF4IFQoqjH2LGBrF0QSNwdR8gUGkUYO9M48Gwxpuo0cHSxhKhlU3ZVUv1T1pEp5eprJZfg1umZ7l6WTUxvxC0P2A/E80lRoBqpdiWtNGjur1Yi6klA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHSIMfwbB24gtoLFlnTdQBHR/grEr4pGBhT1XjxBnSk=;
 b=C8Afi29ayZmDrClv5JeeYpSd0SDYRYb09UcKy5hYkiYeNiTZJK4Tt3EVlYSU9j5RHpW5gAe+uICqn57e3pq3D3bCUzJcKG/EJTAaX1kAQJEHdgSGGbwZ0A8zFL53VjLWImyq1T1AyUNNtrXNiOoOHHHkyAdxhUGaQ7oK+heRniM=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DBBPR04MB6137.eurprd04.prod.outlook.com (2603:10a6:10:c1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Mon, 13 Dec
 2021 00:49:04 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::30f6:2b14:3433:c9bf]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::30f6:2b14:3433:c9bf%5]) with mapi id 15.20.4778.017; Mon, 13 Dec 2021
 00:49:04 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        Yannick Vignon <yannick.vignon@nxp.com>,
        "boon.leong.ong@intel.com" <boon.leong.ong@intel.com>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        Mingkai Hu <mingkai.hu@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: RE: [EXT] Re: [PATCH net-next] net: stmmac: bump tc when get
 underflow error from DMA descriptor
Thread-Topic: [EXT] Re: [PATCH net-next] net: stmmac: bump tc when get
 underflow error from DMA descriptor
Thread-Index: AQHX7Bmwj7VotTMrk0auLbMKkiRGRqwpYOIAgAGlwYCAAAEj4IAA39cAgAOzRbA=
Date:   Mon, 13 Dec 2021 00:49:03 +0000
Message-ID: <DB8PR04MB5785AC0B2197DC4EBD28B146F0749@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20211208100651.19369-1-xiaoliang.yang_1@nxp.com>
        <VI1PR04MB68009F16CAA80DCEBFA8F170E6709@VI1PR04MB6800.eurprd04.prod.outlook.com>
        <20211209184123.63117f42@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DB8PR04MB57852B80794A0B487167D3A2F0719@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20211210080636.3c1ab98f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211210080636.3c1ab98f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e0a062bc-94da-437b-068b-08d9bdd25c86
x-ms-traffictypediagnostic: DBBPR04MB6137:EE_
x-microsoft-antispam-prvs: <DBBPR04MB613766C49F907EF3C1EF1F83F0749@DBBPR04MB6137.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4bAO8pvRdURobdYQSg4CQo3BK0GhtyRlW/OEBe4Z0x9j6+fP9uigTGitmgm2Nj7ldDrTQjm8B732Dii7W4cvtEkh6GxfIRvsdH0QV+agivigvE6G60DyJ0m05yLlxi6QOSTQsanpkHzFqBpwgsGz8lGuNA2xcku/qYzGSD8MG/AgS8jbyN+PAC8qyTZ0LXasYs1Ea1IBDvZSQOlpdmCWy4pgdCmWzf79TzTTletfBO3l4ktZX73DPlQ9seLG4sw/wg/H3BaOZY8CI6FUOcpm5dSsRAv+iBYBGgqG/OmMiZROBomFeTRfQ3M5gBF6ikZOrSkMjFiMSATwEZ2mZKOI3I4ASzV/rmePU90lkpKuD2nY+/otfKd1EfcePpK+c5pnT+xfHdhqc/j7NM2pC06p6tUfB7cZcrjdO0O1B9J0OW9SogUjA10mBuyYAg61v44yN2wwAEAWbsG6cZ709mRcyR2f5Ls1UvtIm5aRVBKQC3OboR8wp43KoWajdMU8vouVcFIbboD7n9e4KDOoQrJGV+4Shn7qGiNuw0Gm7Kt+FKU1J4lQ10lY3yEGbOizpvpM9ZqkXxzSE+tiLcaejNTSeLA1zUQUAVI6cB62zi0GdeKA1Ul4jPlTjsGmAFaS+NpUj6l6BhfQAPWDWdF/Qbwrz/PvuZg25Hm6IxSyLAXlwNhUEH5uMR1BtLak1smEQSrSgxdzvjelbMhCS+B61UFz9g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(8936002)(5660300002)(2906002)(9686003)(54906003)(122000001)(6916009)(7416002)(316002)(6506007)(83380400001)(26005)(52536014)(86362001)(186003)(8676002)(55016003)(66946007)(33656002)(76116006)(66556008)(508600001)(66476007)(71200400001)(66446008)(7696005)(64756008)(38100700002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+Al2rneXR5k+YmMWTkN/h4XRSqCQwP4kc79a1XI+iczvKQ7abiBeHvzSX0tN?=
 =?us-ascii?Q?NDuhJTuSOZOBTxiv4+8M67WhUf/VteEandVDWconsdW8Fw2ngN6u3/MWb/b5?=
 =?us-ascii?Q?RMyUpLaIvDSw0wL6GgqZCvQhiPrXdIcf++VsIInOOS/PKotXvntYKklRWniq?=
 =?us-ascii?Q?wBQjftqOk+z4iU4urwPROuuYbgodxtdivM/9WuGGrQ+oMfNUFjK02fv2XkQT?=
 =?us-ascii?Q?xIlZxZECW8Zk0q9h7mDAPm1d08NSiPDPHBKuv+d7n8L1J9fuG4IEVmM3G1TQ?=
 =?us-ascii?Q?YvT9cu/giTewRDPzhy3EA/+LtpR1MDuDDlxTGKkyqhyH9tD5MFQMk1yWpGu7?=
 =?us-ascii?Q?faiDAWFxh03B+3SE8x+0uSpHQDaN26bm5N7GBnWBIhpKWfM1ijw57hGDB00f?=
 =?us-ascii?Q?Xy1FnS0e4Z5oB9RpPjpfMh9UcREUtfupSS3+jOjJj/0Myh6Q1XOZyOU1Pgud?=
 =?us-ascii?Q?VVHFL1QaonYe1ffl2ZsqR0VKYo/qVttu/F4iArK30nmUnNsnRLMV0nkTRrxh?=
 =?us-ascii?Q?0FDTPht/792+q3FkRo0mFh8i2T/rTDQUfL22rBa8ZOIosxUH8Zip16yYBcCY?=
 =?us-ascii?Q?JgIgOAxv4scuxxe17MpBN5EZtrqM18G6zpId2rUrI7AQ+4qEHwPlPY+ckH6m?=
 =?us-ascii?Q?rKQjXQJOZhzsVff4no7q4nPkX24a9Q8i4Bo+raH9ioXgB6/MSwfvmiy7i3PR?=
 =?us-ascii?Q?noVQceF7ivJNFYgyRA8F4oF9bpzZ11/j5DLW6TAO+Bfl/POhD2CbGlWRfvxw?=
 =?us-ascii?Q?/xee9wDW8peLAOhwAnf5NKlWO+3jMqyL0W9yT19A5v4R1Pu89JqE/nvLcigK?=
 =?us-ascii?Q?Whf4HVYkiE7cOCKqvNk2yRI1wRYKZPURW1XfrTVJwNyUu0WP6MO5KxKfMn61?=
 =?us-ascii?Q?ADqhbL6eBJQvssmN2TGhT/4Kph1X72qSWzTaaxSseqFb1JTpPg11AtbfNi17?=
 =?us-ascii?Q?cPORYNWKujc2ms5l0jVjxlZUurJ+RIZjq1aau2orpgDQF3Ol1IsxUoD4290B?=
 =?us-ascii?Q?Q5c3dZbPY3ghbtUloRn1fyOSPlxuwRw9woVEOymU7bQ8WJ/Da5yaFY/zONDp?=
 =?us-ascii?Q?pDX9IxWApiqu4ayrWe5/K6dLsR5CDpsd2Xq2nmENOgeLpss7kFKTKJLh3EEL?=
 =?us-ascii?Q?/9yD5e8rp/9VRHJo5gm1bo9Js59tOCABkUApMp0bIbp9Unt7RSa7cOVlr0oh?=
 =?us-ascii?Q?67hMBdGIYZMHOFg7eV0k6sZJV18M6imHzEGv5he+gZXNjRT58UWoxuHXCfV/?=
 =?us-ascii?Q?xSo5OiYIWwIf34pJJthviK2onnoihwwQwZK1GyBxXOq/c66aaFApvtaFQed5?=
 =?us-ascii?Q?V7TBlY1CfW5ueqsJqBidy9HpMK1D/IYb9c+lSmKwr0+EPdOHmkAMTlLq54Ft?=
 =?us-ascii?Q?grpgDeRHi3xiKbE6NfFMIP/ChcoKpLoJQlNT04UyUINPHGODmUy2XHpsS4r9?=
 =?us-ascii?Q?CZEIwyFbqy9wX8BE2wrLhKgio7q3PdXUsDHCdXqxnaAegDgNn+y+6CrZW6rl?=
 =?us-ascii?Q?vXJquLXsMZK0AO1iOOa4mrEMfQT3XZGykG7vdJ//aodY/6oU8umoVEMdACkv?=
 =?us-ascii?Q?1l1MOilFUBtVZbkcULh/4n/uMJhTORKKW57fGM8SjvryoABpmFnOHOUetK1A?=
 =?us-ascii?Q?/Pthn1jgEb21r4aUik8EXyXIL/wu3lxv0aZeOUFctnNKX2Red7Y7ArxBzI0C?=
 =?us-ascii?Q?lk6tKQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0a062bc-94da-437b-068b-08d9bdd25c86
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 00:49:03.9986
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wk8dDGxxfRnI7IMV7ZUzUAi2teHhb5prvqNk3oihHtmW18Ux4dsPxNfFznH9XOjGe0WVv1w6rE3z3bpoyhQXhf/KCgBGw5qXj6ph+N9BWuA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6137
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 11 Dec 2021 00:07:13 Jakub Kicinski wrote:
> > > > 5 queues with FIFO cut-through mode can work well after applying th=
is
> patch.
> > >
> > > This never worked, correct? It's not a regression fix?
> >
> > Yes, it's never worked when the underflow error is observed in the
> > case of NFS boot on i.mx8mp. I'm not sure if other SoC have same issue
> > in this case, but I think it's necessary to increase the threshold
> > value in case of underflow error.
>=20
> Oh, so NFS boot works for the most part on i.mx8mp but under certain
> conditions (or with certain configuration?) this error can be observed an=
d the
> boot will fail?
Yes, when configure the DMA as threshold mode, this error can be observed.

>=20
> > Do you mean that I need to send the patch as a bug fix to net branch?
>=20
> Your call, if you would like for the patch to go to stable and LTS releas=
es -- then
> it need to be resent for net with a Fixes tag.
>=20
> LMK if you prefer net or net-next.
Because this error requires a certain condition in DTS file, and I haven't =
update the DTS file. So I prefer to add the patch in net-next, thanks.

