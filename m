Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8114ADCC6
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 16:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380501AbiBHPey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 10:34:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379602AbiBHPex (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 10:34:53 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130040.outbound.protection.outlook.com [40.107.13.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897D3C0613C9;
        Tue,  8 Feb 2022 07:34:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q0IilmE1MI62vhYtC0tRpVzXBC8OnLBkPCs8YgAtZzk73Un1hxBTHdO0e+EMylCUejlnjFMiovaym8uu7ktfXWWvBzByLzE9ilYZFemGmoNsLKsv+ck0XY7LnxWte2a/q0MozOY02oqhOAlt2aBqG2/iOhxhh2/8ADlbHwVdvQhCvqQ3/ldYf2AspIIkWOu1eqJHIlWLfnWOmgrprC5jjoeRJWvuDtkX4q6TylFjT2896t0YjYxzWAyoJGH/X5jH+aS5wMgRkWc1AMJo+Z6wzoiHDpot0/gJcIrCUfDIYUdOq7LNr3i0erJ/1Mf3pvgtIqsPMWt/7X7e1A34LN867g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Inms5t+nErGP3ou4gClju8Hfs/3RjmraFNNWRk6YKlk=;
 b=NuG5l5k2XnhHD2w1udtj+NC6Yhtp2LH+6J/1ldkTjLBtLfP5rc2BQasBQHWeHa2v1jv4pXEoUH3trjeZpU3Zw4ScPPPq9eyGxUUJpKiNI3redJ1X+mn0UGYG1ltSAGcYDOMbosjtea+1SB3SZVYiPWbGk8ccwYwtfMVPhkP8T7W1s1QZUb43Vr4fOLSei4jsgWO6+CBtXHeWRuJoVIwH/Y4Z6cdQVaQFRcJcvLwGkhbGgpVSZ4ykXbyHxs6T69d90kxV3UEoNTeXnnLViA1HOewF/wzl4OIva7FP/7IgMT8wsM87UTYvaV99ionGvNtP5ObL473oltFJvYUhib9QUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Inms5t+nErGP3ou4gClju8Hfs/3RjmraFNNWRk6YKlk=;
 b=bG7i0kD/vVGwssGkpRExVt8WbyrL6arC2LiS8NslokIyjPI7QeER59W/ybza2cK8dU5m1IbkB6DnzRs45x5lzGu2O/OGeRKKd8cq8La9D3hhkJ93dhdxjH6ycnOjOGRkMnaR8pvOqBIJPrjBOkmGi1imw2+fcBl2BmdiezsxXeQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB6214.eurprd04.prod.outlook.com (2603:10a6:20b:b7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Tue, 8 Feb
 2022 15:34:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 15:34:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v5 net-next 3/3] net: mscc: ocelot: use bulk reads for
 stats
Thread-Topic: [PATCH v5 net-next 3/3] net: mscc: ocelot: use bulk reads for
 stats
Thread-Index: AQHYHKbq8GXukjoutEaxquFuvaFzqayJwKKAgAAI4IA=
Date:   Tue, 8 Feb 2022 15:34:49 +0000
Message-ID: <20220208153449.wyv7xrv4kotji7mb@skbuf>
References: <20220208044644.359951-1-colin.foster@in-advantage.com>
 <20220208044644.359951-4-colin.foster@in-advantage.com>
 <20220208150303.afoabx742j4ijry7@skbuf>
In-Reply-To: <20220208150303.afoabx742j4ijry7@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b19df91-d6bf-4613-5d42-08d9eb188b56
x-ms-traffictypediagnostic: AM6PR04MB6214:EE_
x-microsoft-antispam-prvs: <AM6PR04MB621426FCAC3ED1330611258FE02D9@AM6PR04MB6214.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u2yPnmjX27Na/FX2XizOMhZ7zyhqtbYXLfKVBz8LIhzy1MqkfDLLagAmRW+XrDDpWt9P68PtnUfHRXFsl+xIeXXc0oxLzHNRTu6OkRcFots2lCEMWgpPVFhgBt71ws7neaKMFswM2rbaFk4VwtjEZ3LInXoDnqvRmplGhbvQzi2axOG7lRoyDYo5TEscXPPpRXCamEUBw0QDq33uuEn6+bo2ZjPdlqgB60jZ+z1iXuVVtZaH4i4tiud5a4EwfY4nP4axfjDIqXSnNIaYOyi7YY4DjJ9lYqgfIh08EXGL0H/zBHNA/pUOk2RfnmiZm9ZsAyuCcExzOFP59JVFN6wynzn4nbG7W7ZOrL0jEaCzNOjpiZ7z/x1vRH+MMwSdTKOffiorcH6hMdILK3bYMssekYT/Ix9xEk/aQbOlM2X/lLNHUwVTlxU+UOJAEWWApDokCmBtFuEpqpuiOo9vEpm1XfEsXIx2UdpwqltOUOtgJo0rY2TijB8x68oQqEclfJ3e9j8IejAqoBCDUC7rOBzx2T1ll/qAqfUtlAePFJZkcCrsN3FCxVyicOnX8yg796PLDGHXD8GepBqbu4zX3UHDwyoPYG7x8kIXSNh92LYYr7fvbd+XLD0CG0P2BhSKs6dv4N+cjxC5iafGKOE7JjRxfkx1bgmLJ0pclou74EctOC8TJGs+x2Ewqpoz4rW4Zb2wg8zQOKCcXGQKYEv10THJzQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(76116006)(44832011)(38070700005)(66946007)(508600001)(8676002)(86362001)(8936002)(66556008)(64756008)(66446008)(4326008)(6486002)(83380400001)(66476007)(5660300002)(6916009)(316002)(54906003)(9686003)(6512007)(6506007)(1076003)(186003)(71200400001)(26005)(38100700002)(33716001)(122000001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LTFF03lu1BowvRL61AhSpx9diqTAFbK0VjH65/n9xxL14o7s80DjizwwHVFs?=
 =?us-ascii?Q?1vzFP4Jr+9Xtg5lk5DJ6SAQOkAy7g9a3w5re8iW2RE7UOH9Qq2Ab/olVfS8D?=
 =?us-ascii?Q?U+dB/RkiS9j5MiXz9Xrt0mFpfBaEWXCp9pmWIFAa6wJp44z5X9F3omp4CI/W?=
 =?us-ascii?Q?W6vKtSZrMyYqSiTtluMIZbxRrjo3jl+Z1IHPkYGmkpWGfDvaZdgBgp9D4eUH?=
 =?us-ascii?Q?RxbIW7G92fxncaNI1JrBb6n50xgHbqNTjZa2kscZBlanQsUEaI2qiEDfiwg2?=
 =?us-ascii?Q?zFeq3SmW+6ETUah3XFHFmH5blFLTiFYf+oSBcXSBBsyLngTyKL554uY0Kw4n?=
 =?us-ascii?Q?CANDlYZBY0+LRW9kMWLgswJrlKfjNjO/DmTocetQ5oSF3imM7Jo/oChn6qyb?=
 =?us-ascii?Q?l2+tife8mfRQfQ/vXa7wZRhdOyM5sYortyaghBN8+yPEXubXWRsHm3YNVLdO?=
 =?us-ascii?Q?VJzJb4qBJ5X75et1XcSlgb9nE+Zppxvug2hhqWmNiIUR3j28128rxAcRhCmt?=
 =?us-ascii?Q?4yDTxt4+w/fynSjFul0K8STpVVJrGZY6GcYuLYY4ZUaXUTL0o8WYvh84SrTj?=
 =?us-ascii?Q?/8x8eOSCIqwsovZ6DR/+kerglfMC7//nGk+gIfJL9kRC2aCDULKcZm48Pcav?=
 =?us-ascii?Q?rYYfqBGN8vOgxEbVB9Q12sHObw620w+NhvKZTRYkwax6rbyRMo5uIMWun+wM?=
 =?us-ascii?Q?1dBaxSSo5bhZxMgf+44qAAIfB/l4QmQluR1Iw30Ca83AlBUhkBd6vZzbwYj2?=
 =?us-ascii?Q?7ROc21bsEpoOPdwzyKEVoqyaaHzOt0DY9vhOYGKLiDNQq+DQ6dtC1YzlM9ny?=
 =?us-ascii?Q?JEOo3XPMhwjW0y9SmBulLei2AaXMls84Sx7UnWjkuSKLyTKEkxPrJklz+jCP?=
 =?us-ascii?Q?4xDDDekQlemu49NFYBn4Mnd3ZnwgfZsvAJk9QTV9MSTteDuDBUvCXHiiaU0r?=
 =?us-ascii?Q?aVTKVIc6dRSS4lLkMbO+rDCyQMNne9ScqeTWqvGCfOUvdjJgG36Wzpb+DPqh?=
 =?us-ascii?Q?47BSEqTXSYaxRVFi9rX2G1kaOKTTt9WSSAvzpgfNBB5YrmGv67dHAFIn6IjH?=
 =?us-ascii?Q?6o3irA736hAUM73yevSrDrc2JOJr+4Q2KFCHSRngjQEkq2Q37Qqm+eX/pgJG?=
 =?us-ascii?Q?711C+NnOIKaYnKUXMaJVRUp9Y877vSfdkhI2uTbsQq6QBVve27s0n5mzi/hh?=
 =?us-ascii?Q?uvv4nhiGD7T8EDCKhLvK/+YT/0TId0qizxfjadgPc5sYW8x2nMwLT1Kh+Laa?=
 =?us-ascii?Q?ypE2NAl/1z7KjOicz1ywwFYQqYtGu7j4qUEx4PaW+3+sI6dr6HFJqC64nw4L?=
 =?us-ascii?Q?BVR/Y3OgVNrb/3YlY7oNuipPKiZttr47NkUf33aN1EOs5trP9TOnez1xjDJt?=
 =?us-ascii?Q?Tlsyd50u1o3LUDcqJ6nFDv9SYkvybQSOyjntuA3qt6wRtqcCPmBKy48lFI4F?=
 =?us-ascii?Q?AKw/JRuQSY6iwMvtOuqanydeABvTln751zqEcwe6+YEQz3NZ4ecmOZKhk1K0?=
 =?us-ascii?Q?u5EVmkYGRQdK4UjOD/9GgxMFnuWpi1hE0qddmcjBC253xaQG7JK6ipHiIk1g?=
 =?us-ascii?Q?Iu3QCsrD8mPEKrhdYCuK/v2H1rECrCVXRt2XeemryRpopoFQbe2Xh2Dhj0gR?=
 =?us-ascii?Q?8cAMLQlqxIcdhiN3+0QgH77YTAnmOly5owDkHJFtx3Fh?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <ECCCF2D2CEDB0A45B0D9C8517A034632@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b19df91-d6bf-4613-5d42-08d9eb188b56
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 15:34:49.8133
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3W+DJuyVUwRaYlzzV4WUjFTjURVsB9MvwbPTZ4w/bGowykus9qMFyqIAbU2l10pofmoU9bSMbRJlPRFFc/ZWag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6214
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 05:03:03PM +0200, Vladimir Oltean wrote:
> >  	for (i =3D 0; i < ocelot->num_phys_ports; i++) {
> > +		unsigned int idx =3D 0;
> > +
>=20
> This is a bug which causes ocelot->stats to be overwritten with the
> statistics of port 0, for all ports. Either move the variable
> declaration and initialization with 0 in the larger scope (outside the
> "for" loop), or initialize idx with i * ocelot->num_stats.

My analysis was slightly incorrect. Somehow I managed to fool myself
into thinking that you had tested this in a limited scenario, hence the
reason you didn't notice it's not working. But apparently you didn't
test with traffic at all.

So ocelot->stats isn't overwritten with the stats of port 0 for all
ports. But rather, all ports write into the ocelot->stats space
dedicated for port 0, effectively overwriting the stats of port 0 with
the stats of the last port. And no one populates the ocelot->stats space
for ports [1 .. last]. So no port has good statistics, I don't see a
circumstance where testing could have misled you.=
