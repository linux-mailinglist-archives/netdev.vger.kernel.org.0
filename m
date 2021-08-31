Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6C83FC485
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 11:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240484AbhHaI4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 04:56:09 -0400
Received: from mail-eopbgr150040.outbound.protection.outlook.com ([40.107.15.40]:54244
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240423AbhHaI4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 04:56:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ja/l2S77WNNZ5g+giSOgC0CJuJrBDwIhWBEsokkLu3r2ZQrNgI6WJFIsRxiQrsg8uamWhnnOi6gRsInKJLhfnCTnQ0IWS1NqRFNE3Y0hTpt3lAtsZiMqh2MZi1l5+Wu9dwp1M+6QBhbUkNFzvuSh2knf5psU4/9SR4j0y089tUNDrNm+4+bPdblzSW+2rw2Fv6infWjsBeNHa75yFPn2S7QipLj7/ol9zHqJ8eQXplvR0im3fEW+OzLKkJfL2V7wrQeziHXGZJLDEV4S5axKFX1GksjXrJFc1FUvAD3z2gFit8fubiLuTFAvQx62ITu1//zaw3LuH6L1bOLtI7gTxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mh5CpfPDdLaYOmI7TbRxW38MQHirsWRzNBFDvxkSRC8=;
 b=FRa5k7zABFEwGISrzYmJkRPC8GbNggHHEiJWd5gP3PYZ9liypSGFd7iyK2qXfgdfpkmJwKHReeFga/mkad93NLCKethty00q+ATeGurwxWNr6/vYhhI7vNA2KxGY3N3hx6kZIIcSXBH+10uQZP8WCRwSS0tlgDBsgsumgN2ZccoKPLgfv0DluYlx2AgW/JqKXwIvmFf85S9CZVGHzNfLG2sAeSdP9SgFEWXrR7m3EpN+7ugxZ8m0tbp1s1zSVT94lzKygCxdHR0Jm5EUHmR+yQuVEINY8TSDDzHCFY8ABpLOuSSPlxpAmXv8qmg4xPJ6HbnpDvgePZGdOnydPKyD1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mh5CpfPDdLaYOmI7TbRxW38MQHirsWRzNBFDvxkSRC8=;
 b=SEX5DeTBMI9eZH4Qc5Bz+U1QspJy1y5G3BlG3dMyn8gogBkgN8JCcc/TZCbCiiNb1oBzNNagR3INqIxMWyuyR55uvHvqJLTkdeAwcZOnwNRC5ry0UHPiM84GvoymExy0AGt5eEZUlNm28auB6vm2FcEg4en38BhuB7WSwTbVdy0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3840.eurprd04.prod.outlook.com (2603:10a6:803:22::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Tue, 31 Aug
 2021 08:55:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4457.024; Tue, 31 Aug 2021
 08:55:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
Subject: Re: [PATCH v3 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Topic: [PATCH v3 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Index: AQHXnhk3bR+2BJOkCk2OO1PW76puEquNPsAAgAANEQCAAAFHAIAAAoQA
Date:   Tue, 31 Aug 2021 08:55:11 +0000
Message-ID: <20210831085510.7hjweoagnmwde6aq@skbuf>
References: <20210831034536.17497-1-xiaoliang.yang_1@nxp.com>
 <20210831034536.17497-6-xiaoliang.yang_1@nxp.com>
 <20210831075450.u7smg5bibz3vvw4q@skbuf>
 <DB8PR04MB5785D9E678164B7CFE2A38CCF0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210831084610.gadyyrkm4fwzf6hp@skbuf>
In-Reply-To: <20210831084610.gadyyrkm4fwzf6hp@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18ed7b0b-0a38-484c-d3e5-08d96c5d0a61
x-ms-traffictypediagnostic: VI1PR0402MB3840:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3840149FD256A5B064BBEAE5E0CC9@VI1PR0402MB3840.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ua5nXIL4Wy9tfdFGRqirbc7odqRZ6bimsVDfcV4oTF8hnnUlCjOTiPQWAPbhbhPHCaV1d79yqJZDtAvPDKrBZvaX5lTQCxTZXvaQ7q5q0ptqJsQinwpISmMdJ8TAxxhsG0KYMtnBnWuXKK79O8u4MvZvBwRzS/sMW5NS0HGxkLWtPQZrwa794zZdHk1ydLLR7i5klSUMfEoNSF1TiSHea9Xtr99APP9YPlmTTX7AohlA71otZ+KGkD4ilcG6gWl2/VWFuh7CAppUac+c9oKXzN5VLIwBidy4PxjgNZL1QF4RBMy9C4e3rp2BHn19e8BQsMu1Z0iCVn1rxM4H4OY9WqkvBKFf1ytWY06e6fiJ/McysQC/A1usp9iNha+zkykSM6kQz2EHrpRLMYdp8gOt+kgCpaJoG62NEtnPZBinF5zbDjB1T0AOvyfLKUjFT7MoGQGkkVg6ing5xGJhL7E7974mDqP823f0+CxOFlDp3dt5CyD/RfjZaQ7n7Mvr+LUnRRT/CUOKDGRteSO9RCAOzDLNKru7X5jyYrcps4y89gWp++S/6J8cZ8n1dOyJLGImjn+3MOS1an/h65Xev+yIWDBLIn+kIHayAE+kMw1QTl8Lq5z6zv02sxTF5FP5uw1GncGx5M3wyJwL0tVPXlX6QlSZo7b7+yHsbKW5kQUdU5fYU02DLMMpeSKcRBMC+XHtWiElNT/VvG+BQFtPgQz7MA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(6862004)(6512007)(9686003)(508600001)(6486002)(91956017)(316002)(26005)(33716001)(71200400001)(38070700005)(54906003)(1076003)(7416002)(6636002)(4326008)(6506007)(86362001)(186003)(66946007)(122000001)(38100700002)(76116006)(44832011)(2906002)(8936002)(66446008)(64756008)(66476007)(8676002)(66556008)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5REUdOQ2AuKaZnf3ZPyc2VCanfnRYTB+yJ4KaOvmqUe+7IBUrIXlr4moWbAe?=
 =?us-ascii?Q?XkI6wKkcZ1OrjONrjWE+EcNAuEhMus4hLB/iFgvm2hjOX5Mmsr97Pylk/BSN?=
 =?us-ascii?Q?jNx7NVW8C7wN3KOjcxAr0y1SbUzsFS9lKJPDWZRUMvvA8xSyuqqlAvFnysPb?=
 =?us-ascii?Q?+fklcgQRT9oA/X1CYrMjWEU7itOUw3nKNZMLLXrJ553+ZH3Cm4y93d4qbZCV?=
 =?us-ascii?Q?8vJ9ruKpbGEXxVuZ9QDE21CGRaxsllPdyjOkxXjg2YBWXOPqiA1NZ/fPku6p?=
 =?us-ascii?Q?wSBYWyM5cEjAkFDP+prz4TmhIvcOb1ENtM7j/8QTtbe07NkYvisviRWzCNFf?=
 =?us-ascii?Q?EfIWJheBM/Lvpz+NHSSKg/3GtRPSdsnNW8WMvT3gC+l0ECGQpAL7XPXvi1cl?=
 =?us-ascii?Q?n9EH43hv1wqkTtywR4aeh7RYObTehIwrKoY+IdTz1eq2t9h/IOCYhBWKEx9R?=
 =?us-ascii?Q?Vvoa5edOu7ZUCo0mat4PY/OCmBQlVGXYKaIN4oZHaYgXw24bclZT1Tv96s7/?=
 =?us-ascii?Q?WBaGbRItcektNu9cUsCC8OP1/zBL8wVEr2JicqIadSBbp9hNO51RjcteJHaH?=
 =?us-ascii?Q?IC+W8J1JYFuIU2Kh26QPigr8LQlvX792MAfehJV/x2x12cJpRDVS3GICnycs?=
 =?us-ascii?Q?QGTrFg2dM/Z06xLNatCxAGUao2hePUUnpifAiUEP9CW4+FaJy/aTS5JRS1di?=
 =?us-ascii?Q?4YWu8zt91hIbjkMaMO+TFugIirIROaDXr0fEX0tErELAfIGtWdF+eqc6yoBd?=
 =?us-ascii?Q?acd1LvXQdrtII6z9TuU+uxDXJbPzyzA7zweFjaLKja3Zi5gvFpHpwgZRqTlu?=
 =?us-ascii?Q?nMBKAipiLc9sc3SAzo7jxITWxDaneN3pt5DtXX98ZIZA8Z2tElNOD8GcWVLf?=
 =?us-ascii?Q?kbvnroQJEqSA4FxRWVGmXzx5FuYRg0om0R+0d8JQ9bx8DV07tZ2Yu42kPDbU?=
 =?us-ascii?Q?puz3X7zg7su8rZecw3PwH5TyjdJjXcRWxYysKBXmlJmps6WPvRTnSCJyD7dk?=
 =?us-ascii?Q?iW9G9dl7Hdtq5cDFgWpD78r5JXnM3W8AC+yzbKZOHgQXLsz4J4TEyR7eNl76?=
 =?us-ascii?Q?z2z0JuebRYKkoCcfdA7sxr39Yke1kNq8GX9J1Y+lBx6TpVcIsRR6cNa/ZH2s?=
 =?us-ascii?Q?i2DQUzfcaKNDQXFjueDXUoCdF6OycAE7LFEQXTpos8HiIYEqBomvtc/86rab?=
 =?us-ascii?Q?ZOgRAVb8jlHYiJpM9y6ddI0awi2pbKq15zJ4i68ZUeBgpEXt+desfPUEg7cI?=
 =?us-ascii?Q?n8/bvFrG4SXAf/zWE2X2SfbKICIqTOtUHedLGM0BsCjtQaXX5GSVsJ40VndX?=
 =?us-ascii?Q?yxFm7kw3CElbZ+0nqv5hlLMjvbRhSL07r0H1uwT+G+9lqw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2F8B7BE4ADBEBF499FEEEDB05A0A5C61@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18ed7b0b-0a38-484c-d3e5-08d96c5d0a61
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 08:55:11.0388
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y2kTkXP5ln4gH+klo2g0RJVF0jCt0fL4hhLjgq5cjOfm3+GWfaHse8TtTKsEymoE713qMzDbVMZWyprAls8a9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3840
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 11:46:10AM +0300, Vladimir Oltean wrote:
> On Tue, Aug 31, 2021 at 08:41:36AM +0000, Xiaoliang Yang wrote:
> > Hi Vladimir,
> >
> > On Tue, Aug 31, 2021 at 15:55:26AM +0800, Vladimir Oltean wrote:
> > > > +static int vsc9959_mact_stream_set(struct ocelot *ocelot,
> > > > +				   struct felix_stream *stream,
> > > > +				   struct netlink_ext_ack *extack) {
> > > > +	struct ocelot_mact_entry entry;
> > > > +	u32 row, col, reg, dst_idx;
> > > > +	int ret;
> > > > +
> > > > +	/* Stream identification desn't support to add a stream with non
> > > > +	 * existent MAC (The MAC entry has not been learned in MAC table)=
.
> > > > +	 */
> > >
> > > Who will add the MAC entry to the MAC table in this design? The user?
> >
> > Yes, The MAC entry is always learned by hardware, user also can add it
> > by using "bridge fdb add".
> >
> > > So if the STREAMDATA entry for this SFID was valid, you mark the MAC =
table
> > > entry as static, otherwise you mark it as ageable? Why?
> >
> > If the MAC entry is learned by hardware, it's marked as ageable. When
> > setting the PSFP filter on this stream, it needs to be set to static.
> > For example, if the MAC table entry is not set to static, when link is
> > down for a period of time, the MAC entry will be forgotten, and SFID
> > information will be lost.
> > After disable PSFP filter on the stream, there is no need to keep the
> > MAC entry static, setting the type back to ageable can cope with
> > network topology changes.
> >
>=20
> So if the MAC table entry is ageable, will the TSN stream disappear from
> hardware even though it is still present in tc?

Ah, ok, I was missing the context of the larger change.
vsc9959_psfp_filter_del sets stream->sfid_valid =3D 0, then calls
vsc9959_stream_table_del which calls the common vsc9959_mact_stream_set.

> I think in previous versions you were automatically installing a static
> MAC table entry when one was not present (either it was absent, or the
> entry was dynamically learned). Why did that change?

This question remains though.=
