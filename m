Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847E93ECE43
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 08:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbhHPGEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 02:04:31 -0400
Received: from mail-eopbgr130077.outbound.protection.outlook.com ([40.107.13.77]:6884
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231680AbhHPGE1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 02:04:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HNQN6VxwztdRm46Bw2YC+vjPnQLSjXItxfCobxzS3NnbFrk2Gqd2W8Ajvwp15BWFuWZ2RD3WJynFgZiFBAQgbcpQZLxcxX8atQVNX1tb1CGsWorE0gG5oxkDgc6HVTtTMxBkqJ9KU3yLV/QWTrK2jAHub7viCuhbSeMGCTITvnrzbjEwgsmaFDBTSITA4BLso/VBQGptnduevIgflrdd4XiX46AHMc1yM8e84pVYEAYSrVaUKJHhH4evKQEWNkHFVWxzNCSRNNk0BWQ9ncmaQ64DuaYFpdG047pxzQtOVCZvKtdtwyXRmEe3/cmSET3kvhOSlt1QH8YPg7yx0pen6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pPeSgCjP3AsPBIlLakeypd6PAnH7T19DH2oT8gRy7h4=;
 b=ogZch9jHFgYTyNWH1FYq8W8Y790y9Mqm7KqM0IQChe971HdPaTEAamqHRIZsLWaM1hyg3BVx+XKGj2fsOqQ04C6i/3IhFa8pWxmYz+oPTsdr/serYBM8qHNlXb4RBqA0jXRnXGkqAuBu8NwK929LzBtP7N6a9H5e6gMufc4BnsHhN6ZZWoSx1WIaOI00mIY5NwoO4/aOEJ4OvMdw9L9O/nBcnDY4EOmjVcQPKu4iv+XucSX2yxf5Nnt1mr2w5xctn9RzqlnDSKBfGXLtMuMKyT1JqpfrRs8MnMkNjN/iG+At6EWovlnBL/KkJpcLY05agmGjx2gijr/tGSyq5rlmuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pPeSgCjP3AsPBIlLakeypd6PAnH7T19DH2oT8gRy7h4=;
 b=amFNadkdXN+xyYefPUzEjEOKt7+/gR0rt0hxFKo/0wWZk2sqqLdiPBNF+8WzwfEpuXQ2YFMWJ9BLXqEc2E2gfjfHOYQfonYAFE1JqFVYZR0NngIGbhwS+CV6m2B4Tlj8rj1QArK+gHymtp3IBzULE/FJ/Yw/ZfvtvGsHnjALxqA=
Received: from VI1PR04MB5677.eurprd04.prod.outlook.com (2603:10a6:803:ed::22)
 by VI1PR0401MB2654.eurprd04.prod.outlook.com (2603:10a6:800:58::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13; Mon, 16 Aug
 2021 06:03:52 +0000
Received: from VI1PR04MB5677.eurprd04.prod.outlook.com
 ([fe80::c7c:1ecc:3ae5:6f23]) by VI1PR04MB5677.eurprd04.prod.outlook.com
 ([fe80::c7c:1ecc:3ae5:6f23%3]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 06:03:52 +0000
From:   Hongbo Wang <hongbo.wang@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Andrew Lunn <andrew@lunn.ch>, Hongjun Chen <hongjun.chen@nxp.com>,
        Po Liu <po.liu@nxp.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v1] arm64: dts: fsl: ls1028a-rdb: Add dts file
 to choose swp5 as dsa master
Thread-Topic: [EXT] Re: [PATCH v1] arm64: dts: fsl: ls1028a-rdb: Add dts file
 to choose swp5 as dsa master
Thread-Index: AQHXj+75u2Pfw5dj90eW5XnXIP17J6txaSUAgAAItjCAAAd1AIAELgBQ
Date:   Mon, 16 Aug 2021 06:03:52 +0000
Message-ID: <VI1PR04MB56777E60653203A471B9864EE1FD9@VI1PR04MB5677.eurprd04.prod.outlook.com>
References: <20210813030155.23097-1-hongbo.wang@nxp.com>
 <YRZvItRlSpF2Xf+S@lunn.ch>
 <VI1PR04MB56773CC01AB86A8AA1A33F9AE1FA9@VI1PR04MB5677.eurprd04.prod.outlook.com>
 <20210813140745.fwjkmixzgvikvffz@skbuf>
In-Reply-To: <20210813140745.fwjkmixzgvikvffz@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c4f622e-9806-42ca-3744-08d9607b9f85
x-ms-traffictypediagnostic: VI1PR0401MB2654:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0401MB2654D05BA99DB574480EDA6CE1FD9@VI1PR0401MB2654.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mk4TAH4pLtMI+3Wr1uerYVJ7pa/dVn+/zK6GO1/OYM/8oWOBFHIP6ialT9pr9YraiIZSIGurJH2FHTwxK/5q0cA7ZnkNbeYB964hpYFEElwT0d2LDCNhj9FmDSNeMifzEylUOjOu/jbCFFa5vdLAOmMZZSB2OPFOkmVbwkcTUuSHVhaKiAEH7JRE3XETGiO8KTDGJIHG4PV6P46ksXWN3+ioenNyk/bOV4sRu3Sk9zCbGPvZVTYc70Y3JWQncGkewW507wUE5YHtFRYp8On8svErW6xlhyeK29aeTmEzeILFz3IkuiOZS9BCsBC56HicXbEQeynm5AfcuhS8Y5epAJDc/E+dtHBMakNkdQKilsmAJx7hKP1qMyVUKUOoW7PUtBzjDgCna61oQGxh0NoksHZ2P4r2nkCIbmA5j01eTUpJ2GpjBp6peuESmuttaIJf+10LhDqrFYTRo9BEtXyqq6orFTlm7vGfa6en9hurF+bZa1XpuUFA3PyQaGPWAnb1yEuaMV5uMCYre/XwziitReqCJ297H6pHjAH2puMyDNZnDVh0a4G4ZDUcQnKI+GrWz/Yq+tuWwFuKA13xeamprOzBH49XjBkekVOhc0xrmHi8msaDsQ1WPP2tNP2IX1BnPeh++XajlAZpB1FT277couFbJ8MaTyJl8W4fN1INvRfGuM/w0ugtjx0MdTCuzM7M1IhXKL9NACHba8HSDGir6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5677.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6636002)(186003)(71200400001)(6862004)(7416002)(54906003)(26005)(38070700005)(2906002)(5660300002)(83380400001)(316002)(4326008)(8676002)(52536014)(508600001)(9686003)(122000001)(66556008)(66476007)(64756008)(44832011)(7696005)(66946007)(66446008)(8936002)(6506007)(33656002)(76116006)(86362001)(55016002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?psAQgs30+UumSRgCxN81wa5nTeK5ewR25l7Xn89zEzWS+Jg7pCuUSS0ehvAo?=
 =?us-ascii?Q?LimIhPi09l/N43y90nbX12ExwQ3CPlN58oND/nQ8wNyG2jq90SjI0ePVpFBK?=
 =?us-ascii?Q?uSUqo5u2/UFNC+bZjLnwDY/jDIx1xv+LU7a25pqqjgMRiPR1JVeTi7WFeSVE?=
 =?us-ascii?Q?cZHY3r+BJXJ/RuMVqSn7uWJJ+dFNHka00pjo/HCRPyA2KRUw+Kn9xMNGqlTf?=
 =?us-ascii?Q?9vP1u81XsZ2C7gIRfMR8M+IspKUFVZGK4sIsErduqiyaAaJ5nHb3tv2P/T4G?=
 =?us-ascii?Q?0dXy45c7c2XCCidYRw3if4AlseckGMd0vxDdk1OOzzYH313qXqa709vgXqCJ?=
 =?us-ascii?Q?kR4Z5Ewbi/6hRMg2UYchJ9uPL5zwXszR2ilJvHmnn7IfSbUUJ6BvexyW9qGF?=
 =?us-ascii?Q?7UgYoF3FotS9xN0z3UaXjW+h2KIX4g/0Bcef3ndhfJa7jt2FjNiyhcLpFbD8?=
 =?us-ascii?Q?yBaE3Timsu6omEwBPPh8+/3PtWXtGv/rhveAv9bI8S49yUwqPYmmHUhg/Cdx?=
 =?us-ascii?Q?GfkrItegCxWTBoaokeplXMrcSw/iaUHTEVZITNKWzFyRq1JNyo5l2/1c/Irg?=
 =?us-ascii?Q?hiAlX2Bnij0O7KkUoOK7vUK+xYJSt0zuSkwFHckKypLnnWQ/N6X8dvru8RcT?=
 =?us-ascii?Q?4jV3JVEju5QZH3OdxdgU/zzu5f/S+PzWVoVJ7e0XwKpoJTARN+Cxg+TYrjDC?=
 =?us-ascii?Q?PracHIdoKgb20wFqoJp0OhsA92tBGKOpMOUA2v6VDuR2yuYVUYJ/7TQE+Yur?=
 =?us-ascii?Q?A61OXThOENv4r3Pc4ooo2M4ktlcV8/EDEdD6jhUTnTpCtKqbUNVOf/lppyKI?=
 =?us-ascii?Q?vMgA0NvBNzhCarQXh+GHrgt36PHzWwOdO/wpzKwOFHHW5YdyS/OP4NxLRWj1?=
 =?us-ascii?Q?f1Ad3uv6iqwxQKTrhWcV4AOL/cM1Y5jleTg8EoG1UUFo1noXO7NMu6XiRGfh?=
 =?us-ascii?Q?iv04rVefHVjSblsnPgoc+mx4IKkKxNIOtlL3tauAGuqn1QrGRW52DrPo1vmp?=
 =?us-ascii?Q?XWH9UktmF6ACw2Qq6JGTwErWEvz95NMxbiunWQu9E1S1lSpECnGVoiOBQrx5?=
 =?us-ascii?Q?9uI0MqGKif/1niNMCajr1HWQfqevW8NQk9phxCtMvfHSmANLii13zn7DWt9L?=
 =?us-ascii?Q?fI4LOTrjjeTWM7clYBQmImQqjmhW7TVTlW6h3K6tUZtnTy6/+SX6KwoAGeTS?=
 =?us-ascii?Q?9L7S+02kI7EwLkp5NAlWjy1iaOU3an/EYVedOJxJZgFgOC/SLzdabqaM3QEQ?=
 =?us-ascii?Q?YuArmy+LuxlFOqjumpA4j7TtDi3t3Z/RiMeojfpMVKdg9jOuJmfI0B0dD6Vr?=
 =?us-ascii?Q?LbM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5677.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c4f622e-9806-42ca-3744-08d9607b9f85
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 06:03:52.1008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xni/9d0aAluZ9Oj5mu8vTdE1MWEKW5+2NUgOilCYjyOWATiLIqNl019hqxKuNegzFDZRCw39fJWNLJYdvJAVFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2654
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Fri, Aug 13, 2021 at 01:56:53PM +0000, Hongbo Wang wrote:
> > > You will end up with two DT blobs with the same top level
> > > compatible. This is going to cause confusion. I suggest you add an
> > > additional top level compatible to make it clear this differs from
> > > the compatible =3D "fsl,ls1028a-rdb", "fsl,ls1028a" blob.
> > >
> > >    Andrew
> >
> > hi Andrew,
> >
> >   thanks for comments.
> >
> >   this "fsl-ls1028a-rdb-dsa-swp5-eno3.dts" is also for fsl-ls1028a-rdb
> > platform, the only difference with "fsl-ls1028a-rdb.dts" is that it
> > use swp5 as dsa master, not swp4, and it's based on
> > "fsl-ls1028a-rdb.dts", so I choose this manner, if "fsl-ls1028a-rdb.dts=
" has
> some modification for new version, this file don't need be changed.
>=20
> I tend to agree with Hongbo. What confusion is it going to cause? It is
> fundamentally the same board, just an Ethernet port stopped having 'statu=
s =3D
> "disabled"' and another changed role, all inside of the SoC with no
> externally-visible change. If anything, I think that creating a new top-l=
evel
> compatible for each small change like this would create a bloat-fest of i=
ts own.
>=20
> I was going to suggest as an alternative to define a device tree overlay =
file with
> the changes in the CPU port assignment, instead of defining a wholly new =
DTS
> for the LS1028A reference design board. But I am pretty sure that it is n=
ot
> possible to specify a /delete-property/ inside a device tree overlay file=
, so that
> won't actually work.

hi Vladimir,

  if don't specify "/delete-property/" in this dts file, the corresponding =
dtb will not work well,
so I add it to delete 'ethernet' property from mscc_felix_port4 explicitly.

thanks,
hongbo



