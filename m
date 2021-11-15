Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B70C4502D3
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 11:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhKOKys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 05:54:48 -0500
Received: from mail-eopbgr50056.outbound.protection.outlook.com ([40.107.5.56]:22501
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231207AbhKOKyp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 05:54:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fPZisldM4VqRMUbsYlGZirVVi977AGl/b3jUNv/UtR8Vsoe7LEl4HYGDQPY6Wpk5RrtNLlivfdodvKCWiOV7XA7ha1RQLA6FrI7dx/2BR07SdUxk9tnbHe6y3PKtD8t5asXXpqxhszJqWCHqKCvjjfnxCKHhyCkXCvd7WumUnOdJVHiVFhHjhNHcYfMb9nwdTqWYowVRK0EuigpZeJ25P//3kw/I/3CCAUchAJeVg/H7SZppVSsyb68M7vdjaX4U/sFLQbtWqfvx653wjdtlWEf1RQ3Ri5+/FYG/t7oD+LQdJUOGzxesfx7rHolsZAhAmjiQr368aRQAcFhvsZDWzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CU1VvCIxfiVlwEYokpHXxAwjjt+DM8kycVQXiNzNC/0=;
 b=dAS7EzPHjfPCRECtUBbcfuhyP7xE3ypU+6zLy7sd3DXCwT8NTq1Ny0LRVIcVVOGJsu64UOyW4Fnc/bZYtH0L/9BLlnZ7GpP7lgQPjv4aNs34Ua4Xmxc7tH/rl8WU6rfsR6F9DuR0WwY18d3f6aqZHtTYeXhf9yzDm44MsoY2xOtB2QwkIoxlfn+ljGyPkv4wvRSrJlcrnogaV7DmbbhN2gwQNwUdxymZ5oCZe1gXzB6chjz3K86kZjtM5ZAJ5BJZ+1oR7co7nKUGqH+kr6+BDYhLnQh4Y0n0BhGxkVr/pF0r5k3fJq+JHO+5HZ+yaAMJfKGQNj7ecH20r6EGK2bAKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CU1VvCIxfiVlwEYokpHXxAwjjt+DM8kycVQXiNzNC/0=;
 b=WnXVvPT3amEpIqwkXapxUX4FSSNEQM1uk8qwDnrUqkIW46M10F0/SyEYKxeMTaZqR23inJzqOV9pNcmx+iM1lv9FYUB9NuHYhTrVTETh+rqOioncaOS+0mkTUdTce3CGYB3VUUV44upYw/cqntyK6VMKDnB9+4qT/p347+4Reh8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4224.eurprd04.prod.outlook.com (2603:10a6:803:49::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Mon, 15 Nov
 2021 10:51:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4669.022; Mon, 15 Nov 2021
 10:51:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v2 3/6] net: ocelot: pre-compute injection frame header
 content
Thread-Topic: [PATCH v2 3/6] net: ocelot: pre-compute injection frame header
 content
Thread-Index: AQHX0JQMizPbr20xM0ur1htXAvgjtKvxviqAgAAVJICAEp56AIAACp4A
Date:   Mon, 15 Nov 2021 10:51:45 +0000
Message-ID: <20211115105144.le3a62a2wbkgp632@skbuf>
References: <20211103091943.3878621-1-clement.leger@bootlin.com>
 <20211103091943.3878621-4-clement.leger@bootlin.com>
 <20211103123811.im5ua7kirogoltm7@skbuf> <20211103145351.793538c3@fixe.home>
 <20211115111344.03376026@fixe.home>
In-Reply-To: <20211115111344.03376026@fixe.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69567c6f-c958-4140-efd1-08d9a825ead0
x-ms-traffictypediagnostic: VI1PR04MB4224:
x-microsoft-antispam-prvs: <VI1PR04MB4224134C246E5C33D6D9B569E0989@VI1PR04MB4224.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1284;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /sPK88AE/jz7NcNwLdkrafjtigHy8cyh9GM0/Wcg4SkNIAFW7fwvW82iG8lqA2HgjGtYQIRHXwEdpRRK0ctszZTS8UrG3+tjNjZCtXiw3PM1/vjiqMKSDY04Fzs59O5K6kAU45PC4fwPFazo962O0fLgiRMzHmezyGX1kj0T4CdQIzJkjJ9uGnsyZYIkdHHSnzFtVy1ZN89jtkf0/Eq/DjEO96OupuMPOgwqU1wE3KhtlZNKw2nMb3Rvg30XCJiJrtS1SmQGt0qiUhmS+xiy3ckz50uvO9sesDtwSmnxdD8TcZu1EwKIMc1ZWGT3PQQMtMg/kj3XVyHbifAAtDKn/n96L4kQFO+pTBZ4sOf0FPLQMLhKPQCVDHJbXXYFJcZy3lgRlrdTj3f8KcW+3HLlmLylEXQkoGIxbkqfVOu09C6QujlTiPiuthBjFD6KTBcbgvY4IigR6lq8c6TX/ur43CkFnlC0dcdiKXRhWGRbONkfosWKOJeIO1e+4oYZ80mLPW9kShulPeKljlsUjYIM7vULhjblR98UrbK/RoWaxiGFlztp4xeLQvU+5KaIEqlpr5td46SnMxGFPZeQKngf06KmJQAHfDL3eeZH20M1VtWnaUgzu3auygvsh1rMUP0J8PxRqxGN8IiJiremZRnHzOT2WY7ss1cG2hkmNsOihfY+yVt5Z4z/9ZeLggieu4O0JlV5am+RElGvK9bx8fp5rA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(54906003)(8936002)(6916009)(33716001)(76116006)(64756008)(91956017)(66446008)(6486002)(1076003)(4326008)(122000001)(71200400001)(38100700002)(316002)(6506007)(508600001)(66946007)(86362001)(9686003)(6512007)(66556008)(5660300002)(2906002)(66476007)(66574015)(44832011)(186003)(26005)(8676002)(83380400001)(38070700005)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?3l3PVj3/dZKhc433miDP0/BiwhC5E+C1IwGTg5HAjyRATN/Xkh0CrzAEwF?=
 =?iso-8859-1?Q?M4tp1dHWz9znBVXLtrmcKbz3PHVXc+78Cb2BiU6QOah/GSA5M2H6jP5K9T?=
 =?iso-8859-1?Q?LsrHzSxTrfV9QaL2W53RUx7dMtC3MyGBP/3CNBNkQQhRwiExdaD4es1gFa?=
 =?iso-8859-1?Q?fdVuCDk0nOcVJu+LyuxwtsLAfGzPDvbJ68PzfFkAcwCIoDKS3ZyC/5U4Q8?=
 =?iso-8859-1?Q?IZUnUNrJVg+QQHCM5Vu57WOS7qG1nG+DTDZlrGvUbyqzgBMxIMbHAd+5sy?=
 =?iso-8859-1?Q?0y+YjGb55aXwH5vT2Db19q8TytRq4aUhPcRGOMbmG2X3N4qBuenTNbz6Hc?=
 =?iso-8859-1?Q?NB5q//krW1d6w2e4SQKq5MLLaoAFpUZJp+2iiE+NFnzu3V8Qcc9rGjjD1X?=
 =?iso-8859-1?Q?F76pYXnN+Z0d8DEz+UGSqy2FoyL57Xc7RiKfdgqUfhrWKwahZLNK5tKWTF?=
 =?iso-8859-1?Q?Azgqgw8RCKnJK4aFtf3go2hHM/IvDsEcZyJo2L/OmM8PTidhEr5Jtc/XJq?=
 =?iso-8859-1?Q?rohVgo0HNSKMUiaHZ8lhpTncptY2VrH5T69+l73U2vHPUq6vyvQQo75kaz?=
 =?iso-8859-1?Q?SOs/zY+YmmBIh7b5z/2Z8Q/QaYnk0fpPEM6lBCx1IEMwWLNhXlYqRNG2Ys?=
 =?iso-8859-1?Q?CpEL5RZRBEzgHMxUAH8zNuk7D3YRNGXXhfV0B7c2xsK8bjPE0vm/4HcvPh?=
 =?iso-8859-1?Q?KxlC5a645yDxJ8RkjsUoH3sNMoKzKmcXC/8xPoieAvDX0rLDxizbd34V+y?=
 =?iso-8859-1?Q?AH8UTGUmSOd0npJYtxG4e06Fe/7mLJwIabBWjwnB+H1p9ITBe2QjXuJrkt?=
 =?iso-8859-1?Q?lX/BfacNjMNKtqa3XaNRzRaKhDIplmSyiop2RJ8P8elGQimb1B17ljRRVX?=
 =?iso-8859-1?Q?w+fmoKRq6Hih7oDkapOVwp2h/e+TMOzK8INZkbLkVAl4fqvXbiWU0jn+N+?=
 =?iso-8859-1?Q?XaBQUsE1AwAp5Dq5KArKO3cPaA+B/NBA1wHDhVuJ68iTWmZpsrwYvmqbGC?=
 =?iso-8859-1?Q?HLDP/hMc9nX3hnqQlvWLZGUkx1DoHWE3nwmgjJ4P6wWAJ+nwGYMHQQQAC7?=
 =?iso-8859-1?Q?AoQWHgqRzofLVqXBvjzXkxsRjnJcsF/5WTWXobJnItnddIleMsLCIdj6h8?=
 =?iso-8859-1?Q?jLRDvehwRJ7bqe0/Gg9Qb+nMf3QcWesSCvEAsqLKewY5GpxMp/deGxXlfh?=
 =?iso-8859-1?Q?j7kDFufZ5rqD+/SdNVDPJ3KTR0i0aNiFWJxOz0iFxq0WtmC5HONO4uMCK8?=
 =?iso-8859-1?Q?fLhkCfS1cTarCt7YKUfCFazkwMGtxVxbqYX6j8pKM/+lP8jl6DtFkd5GsO?=
 =?iso-8859-1?Q?XgOrbXqgrTG0pFyokEPUBfv0bWFKZM/JE/xfex6FnMEh7U0LYsWAIjpS80?=
 =?iso-8859-1?Q?85+VNo1eiQHn+aPdHuqqrNe9XXNKcB8UweeysMR9JqS/OhNPMYgi878dL6?=
 =?iso-8859-1?Q?eaeZzdyA3/lnlbcmHsRDLw/IOftx86MFqH4hue7FrrSnwnmUA6mnIWQrUy?=
 =?iso-8859-1?Q?qsXUfvE9nojmPsUYCu6J/4pY48DX51Ocx6cslUGU4PxLk0EBMnWFShrUGg?=
 =?iso-8859-1?Q?ZbipNIziUEswKg9e18z7Ad2+XZw2TT+ki5PSDtl8UE85NeSW9eiiP6r0Xf?=
 =?iso-8859-1?Q?L9xGbj8PCw8oxYSLIei01HPy5ar+w2j8blFwUTMRHPSLz9C3x24EUnDy9s?=
 =?iso-8859-1?Q?duTXAcd75v8LbFIazbY=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <AD2A18B9BF1BF64DA3EF5BF2166A45A4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69567c6f-c958-4140-efd1-08d9a825ead0
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2021 10:51:45.4574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 480K622C1bwkFJloiQwidG5wraTRhq8TnquRDIMta183ErcBa2dYJVehI1dbWyQRGRAMJhzZYsFxLmlYxwUlFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4224
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 11:13:44AM +0100, Cl=E9ment L=E9ger wrote:
> Le Wed, 3 Nov 2021 14:53:51 +0100,
> Cl=E9ment L=E9ger <clement.leger@bootlin.com> a =E9crit :
>=20
> > Le Wed, 3 Nov 2021 12:38:12 +0000,
> > Vladimir Oltean <vladimir.oltean@nxp.com> a =E9crit :
> >=20
> > > On Wed, Nov 03, 2021 at 10:19:40AM +0100, Cl=E9ment L=E9ger wrote: =20
> > > > IFH preparation can take quite some time on slow processors (up to
> > > > 5% in a iperf3 test for instance). In order to reduce the cost of
> > > > this preparation, pre-compute IFH since most of the parameters are
> > > > fixed per port. Only rew_op and vlan tag will be set when sending
> > > > if different than 0. This allows to remove entirely the calls to
> > > > packing() with basic usage. In the same time, export this function
> > > > that will be used by FDMA.
> > > >=20
> > > > Signed-off-by: Cl=E9ment L=E9ger <clement.leger@bootlin.com>
> > > > ---   =20
> > >=20
> > > Honestly, this feels a bit cheap/gimmicky, and not really the
> > > fundamental thing to address. In my testing of a similar idea (see
> > > commits 67c2404922c2 ("net: dsa: felix: create a template for the DSA
> > > tags on xmit") and then 7c4bb540e917 ("net: dsa: tag_ocelot: create
> > > separate tagger for Seville"), the net difference is not that stark,
> > > considering that now you need to access one more memory region which
> > > you did not need before, do a memcpy, and then patch the IFH anyway
> > > for the non-constant stuff. =20
> >=20
> > The memcpy is neglectable and the patching happens only in a few
> > cases (at least vs the packing function call). The VSC7514 CPU is reall=
y
> > slow and lead to 2.5% up to 5% time spent in packing() when using iperf=
3
> > and depending on the use case (according to ftrace).
> >=20
> > >=20
> > > Certainly, for the calls to ocelot_port_inject_frame() from DSA, I
> > > would prefer not having this pre-computed IFH.
> > >=20
> > > Could you provide some before/after performance numbers and perf
> > > counters? =20
> >=20
> > I will make another round of measure to confirm my previous number and
> > check the impact on the injection rate on ocelot.
>=20
> I checked again my bandwith numbers (obtained with iperf3) with and
> without the pre-computed header:
>=20
> Test on standard packets with UDP (iperf3 -t 100 -l 1460 -u -b 0 -c *)
> - With pre-computed header: UDP TX: 	33Mbit/s
> - Without UDP TX: 			31Mbit/s
> -> 6.5% improvement
>=20
> Test on small packets with UDP (iperf3 -t 100 -l 700 -u -b 0 -c *)
> - With pre-computed header: UDP TX: 	15.8Mbit/s
> - Without UDP TX: 			16.4Mbit/s
> -> 4.3% improvement
>=20
> The improvement might not be huge but also not negligible at all.
> Please tell me if you want me to drop it or not based on those numbers.

Is this with manual injection or with FDMA? Do you have before/after
numbers with FDMA as well? At 31 vs 33 Mbps, this isn't going to compete
for any races anyway :)=
