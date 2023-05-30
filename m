Return-Path: <netdev+bounces-6188-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2C3471528E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 02:19:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1583280FC0
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 00:19:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFCD67E9;
	Tue, 30 May 2023 00:19:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA69C7E4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 00:19:53 +0000 (UTC)
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2096.outbound.protection.outlook.com [40.107.113.96])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A750D2;
	Mon, 29 May 2023 17:19:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gLJAMXhn40JeADIdA1yH01elMbBsiNZbVTAz50FnnJZFui/hZRqysQVsKVriWDx06ln1K06tVEvJtM/pFtugjO5m2uwO1CPnNC6Pv0B05avxHg9nIqu3A3tVhdEZIjaLlqXT+alNKC1AgI6TKdApESEiCWDb851GqbynF0KUPr3kvk/2U0sCVVbDTuPy+/L8jGNWBjFfWKzGsocLlg5qXZ8yAgQjg55Gm6k0AJNrCdCbXztn12c1SI9FBs0Cs2A+tut3Cd40Codpw6RiffVFmnG64ECLlouW3CU1jAihrL6h4zV4XlhvsgPwyjhrxFz1nOoJrd5q25ePOFbwtBZb2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pgPmjP4GXkXH3ChBj+3btQhE0csoZFP+7gXKNchqqJw=;
 b=cZ0p/iVesj8AjqrpY2F9llo4WDePqOd3BYn6hB7Ogpwgeo437OmLoKrYCHr56XwDUho7bywHKJ0feFp3qSht+bCSEly8WA3OiN3EY+owvt1ULHOI6VuzmLO4cLMJ7FOo2WzrzLRQ1cQPZE7OyRLuNSld9Gc+vI0y2XF3E6ftpA22TCbelA/3lqxnVboPOOETizaLNUVLsT/jPyo4q8xDZGCu1sSuB/BhDfpK4Fl6SpSdc5lFBF/GICObispcqVXyZhXpapIsJ0sjPXVtLE2uJ+ZpvKwxe4FQn+7xLRnHClTwihs5iE0jLjsj/t7h2ClNEhZvi1XSxVObh5Fy3hZoDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pgPmjP4GXkXH3ChBj+3btQhE0csoZFP+7gXKNchqqJw=;
 b=ar8jbqR7OHVKAydw7qwltjHE/LBVIZSK7KUGpu1ERJGcbR1VNXtERqaytwD8yOp+Ecvf4v9jaWYAqvogeDesoxlBxFopQe64j9o5e/hP3aNBUF+s9b8K/erFrdwvtvrfG1jFTFa6zwLrMkkVUeGJi9kPEfiOLaUGXL6UHrV08bc=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by OS7PR01MB11758.jpnprd01.prod.outlook.com
 (2603:1096:604:239::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 00:19:46 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::5198:fdcf:d9b1:6003]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::5198:fdcf:d9b1:6003%6]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 00:19:46 +0000
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To: Conor Dooley <conor@kernel.org>, Andrew Lunn <andrew@lunn.ch>
CC: "s.shtylyov@omp.ru" <s.shtylyov@omp.ru>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"robh+dt@kernel.org" <robh+dt@kernel.org>,
	"krzysztof.kozlowski+dt@linaro.org" <krzysztof.kozlowski+dt@linaro.org>,
	"conor+dt@kernel.org" <conor+dt@kernel.org>, "geert+renesas@glider.be"
	<geert+renesas@glider.be>, "magnus.damm@gmail.com" <magnus.damm@gmail.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-renesas-soc@vger.kernel.org" <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH net-next 1/5] dt-bindings: net: r8a779f0-ether-switch: Add
 ACLK
Thread-Topic: [PATCH net-next 1/5] dt-bindings: net: r8a779f0-ether-switch:
 Add ACLK
Thread-Index: AQHZkgTOMehFAJcCYEiyxAnN6zOUpK9xlM6AgAAalQCAAAlMAIAANM7A
Date: Tue, 30 May 2023 00:19:46 +0000
Message-ID:
 <TYBPR01MB53413C7E1E5AE74ABE84ABE8D84B9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230529080840.1156458-1-yoshihiro.shimoda.uh@renesas.com>
 <20230529080840.1156458-2-yoshihiro.shimoda.uh@renesas.com>
 <20230529-cassette-carnivore-4109a31ccd11@spud>
 <15fece9d-a716-44d6-bd88-876979acedf1@lunn.ch>
 <20230529-ambiance-profile-d45c01caacc3@spud>
In-Reply-To: <20230529-ambiance-profile-d45c01caacc3@spud>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|OS7PR01MB11758:EE_
x-ms-office365-filtering-correlation-id: 4af80c2c-9bdb-468b-cf26-08db60a3930b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 F+taOcVdNGvIZj5ngcminECZ7K/wQrU3q2RbmwSdvcoaVTD5xuUUjgjhf291cCBjlif2r4A/nC/1YugnEgoa8L16l664Xj5R66GbPy5QHzT5lwT+8TJKYDME3E1zbbt7nI8BxsOtLteNL83hagjorzVqHrb+VxCY1DaEqz1CmtK8E/VMyy1RZ7AuQouowxxs+FZWkr6mDgUqXsf2v4it3XwoINZi5Yjg9AbdphzjE1w2Qx9o8aP6Kk5Ew2tzo1W9bHq0mDIMt33R06cxNF1yOSlsERzTbh3n//05EWa4ZRXzhc3fEVZp2YNH8kNSJzToEM4sbJ4AEyN9+i9xiHU4JEEpOVEXpX0R65FehtpZy+cC4vaeXjus5Gkkl+BhEjgVT68Wagu4riTQwAVcn7ybdNyOE2UWmI5mCZtD7JfSwLRHhsN57b6HiHv9j2tfhp1Ridd42/BUsIceE4PYUcegwD5wC0f/cEKCmasPdaPIpirAEQEYOQkamUBveid8HHsWrJLp48lGl5wdgx5bK9yD35NCuQg+NJ5MPOTI7tQXENvDqCIYDC2uxWOM6N+epRr/i0s4L0mT7LhxV+Ad5nPo6VJ6H5+tTAxzhkDKAshTkJbdmWiuLiORIzR8YoWNGkEf
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199021)(66946007)(64756008)(4326008)(66476007)(66446008)(66556008)(76116006)(86362001)(478600001)(5660300002)(41300700001)(7696005)(8936002)(8676002)(52536014)(7416002)(54906003)(110136005)(33656002)(9686003)(316002)(71200400001)(6506007)(186003)(38070700005)(83380400001)(2906002)(55016003)(38100700002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?H4MpMvzWEABUWrpBm2QqKMcT8RTJ5wt015CuDtoWBuzFahm20dNvijth0CjB?=
 =?us-ascii?Q?Y6x9xtrqw3zxu16D7vsxe8ylVMrHbsPDobjfDfO9gSD3IDyWQ5UWjtGsm7MJ?=
 =?us-ascii?Q?eLFepkjVdrWOgBmlSQLqg9ZhctzPGbNNCZJQ9Ge4SwX02oYxGLv5wF3gOQWh?=
 =?us-ascii?Q?GctEd38aPKoeeRfgdorwBb2pOLIJfv8y0eokEf1wayYNbKii3GEySqyxpOrZ?=
 =?us-ascii?Q?+uyst22JDJ4X9oCKjOP0AMlQXIIjZJAw00z5rr4/dv9+CoclH2G8YMw1KjJd?=
 =?us-ascii?Q?M+b5i5266upae2Y5S2BaR9oOSvvO7GXyx5qxsKbn10Nx7ZopO4VZzow6NIsd?=
 =?us-ascii?Q?Em/I6U2uuQsASQAeGaH+mlBFEEK0nRg0JFf3rUzB2W5l9nGzlNC1YwthmPx8?=
 =?us-ascii?Q?bVLGqRsPKmbMT7E8xyKo+bQC4YLRfu0oFUzPOyVp+xZJEBu329l3CR60uPNq?=
 =?us-ascii?Q?+w4yLGzMBeO7PeleNBrwiWjkUJB3ns1wnZ0WC8C2Rqgb2ueV/1PQ6jZ+YpMh?=
 =?us-ascii?Q?qTsfDFcUUNBJrfjldw79Y5CYvXzf5mcPevqREVl96GsEUSoLFCgxIJE4wIeC?=
 =?us-ascii?Q?qvFD/0Y/zA+Khh6GjIhjtwtmO+OY+KuVoEvdoTDSLwmII+yr5cbhMSERAbgg?=
 =?us-ascii?Q?7UXSu6yel5FHDEwHZBKP/ITG0kPbMPciEQG/8kdnLzNcJuAyN30DdOAc8dIR?=
 =?us-ascii?Q?ZFJY5lvSe1mUJL1csIG/Lw+xWrsPIPYRVA8HSrzwVoXMSPnJBalamH4gmeFA?=
 =?us-ascii?Q?cBfuD4EmASpsHszsJFVbuRxPgjxP9oJKXlXCEh+uqKCz5COm2HfftTD17x/x?=
 =?us-ascii?Q?uugSwoWotbs0HtyeGGPdozMMjQ8eXYg4I2P3psgyewrblNr86NrjDRwjcnXZ?=
 =?us-ascii?Q?JsnDALZZ/oQfBTYArbFl465SH4JhagkhLS/s8y55xWrdSrhdaMxa5cCuxYmG?=
 =?us-ascii?Q?Jc7lnaT065G6WY4WWjKzg0JvHLBraLlZ7Fkfg2iTW147o9A7w4LrQk2KMY4V?=
 =?us-ascii?Q?JYGlsUj2f+ZG8kIRtU+9BAkmsDoneeH8Wz8zOWuH6owq4PfzEmVYMqVTmzdK?=
 =?us-ascii?Q?NEY6whjP0AaFPDQ7bhLYwrJrTGmDsXReYy2zyEqYiDY70bPXeYqm/tR7dBt9?=
 =?us-ascii?Q?vKm/nIFZdtjR3PCKZASSjjBui3DMRh/D1jKGGNwNPE6QSoLfkY1UUtc6eNj/?=
 =?us-ascii?Q?FapY2H9t7dKC9poKp22MNdi6wYKPOfskFl3g4OiAX2XL8UU7TmBfIpVJ4ViO?=
 =?us-ascii?Q?iEv2TUH7qRSLK26xm0bJFkjQfu9S3xKcYQpBj3x6pjBKsoWdsOS/m05Am3dS?=
 =?us-ascii?Q?kzVPmTLxnOxupIP/oXBChcZv7VBzY04bPYN4ClieHCAOzlZQeovrYV1tABmW?=
 =?us-ascii?Q?TLfzvNMHoFiC0W1GuF8NgeqP2RADV1vePS60Ahe35w/TuTS5cFN40xtsoMZl?=
 =?us-ascii?Q?4XUHUffV6pTnjFHSaz3YBrv8FQ7cpZVsrVAJN2EYEVDXv1gGzRkkw2p3iDRZ?=
 =?us-ascii?Q?BRPhiD893uovW7ebjcZmP/7p5DzYQJDpRWc3raYwlGzw0/FvlcLdXMJoQKDR?=
 =?us-ascii?Q?YLPpj2jvKGrd9PxkYbxP+MvbuShZRmrZvOC4QNkjevvVNe53MRMIl9rPdyvw?=
 =?us-ascii?Q?ukhpiydX99TFeYDYJ7ndVA6qd+KEj9srFWd2OJ0Ur/pjelkJ4+WHC3P+yt2N?=
 =?us-ascii?Q?aUPDtg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4af80c2c-9bdb-468b-cf26-08db60a3930b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 00:19:46.5891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TIDSpiYPLL9sTAmULkQquf05MmrVwC7qy0ZH7uoe0wGA6yX7TuRTEO9f6xU+uyNB3SNO7TQrQ4g/1ODjvuvOG+4lSle8UGk4Ra13M2wlQPZQTYL79Qj3n+YH/luqGgkI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS7PR01MB11758
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Conor, Andrew,

> From: Conor Dooley, Sent: Tuesday, May 30, 2023 5:44 AM
> On Mon, May 29, 2023 at 10:11:12PM +0200, Andrew Lunn wrote:
> > On Mon, May 29, 2023 at 07:36:03PM +0100, Conor Dooley wrote:
> > > On Mon, May 29, 2023 at 05:08:36PM +0900, Yoshihiro Shimoda wrote:
> > > > Add ACLK of GWCA which needs to calculate registers' values for
> > > > rate limiter feature.
> > > >
> > > > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > > > ---
> > > >  .../bindings/net/renesas,r8a779f0-ether-switch.yaml    | 10 ++++++=
++--
> > > >  1 file changed, 8 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/Documentation/devicetree/bindings/net/renesas,r8a779f0=
-ether-switch.yaml
> b/Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch.yam=
l
> > > > index e933a1e48d67..cbe05fdcadaf 100644
> > > > --- a/Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-=
switch.yaml
> > > > +++ b/Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-=
switch.yaml
> > > > @@ -75,7 +75,12 @@ properties:
> > > >        - const: rmac2_phy
> > > >
> > > >    clocks:
> > > > -    maxItems: 1
> > > > +    maxItems: 2
> > > > +
> > > > +  clock-names:
> > > > +    items:
> > > > +      - const: fck
> > > > +      - const: aclk
> > >
> > > Since having both clocks is now required, please add some detail in t=
he
> > > commit message about why that is the case. Reading it sounds like thi=
s
> > > is an optional new feature & not something that is required.
> >
> > This is something i wondered about, backwards compatibility with old
> > DT blobs. In the C code it is optional, and has a default clock rate
> > if the clock is not present.

I'm sorry for lacking explanation. You're correct. this is backwards
compatibility with old DT blobs.

> Yeah, I did the cursory check of the code to make sure that an old dtb
> would still function, which is part of why I am asking for the
> explanation of the enforcement here. I'm not clear on what the
> consequences of getting the default rate is. Perhaps if I read the whole
> series and understood the code I would be, but this commit should
> explain the why anyway & save me the trouble ;)

The following clock rates are the same (400MHz):
 - default rate (RSWITCH_ACLK_DEFAULT) in the C code
 - R8A779F0_CLK_S0D2_HSC from dtb

Only for backwards compatibility with old DT blobs, I added
the RSWITCH_ACLK_DEFAULT, and got the aclk as optional.

By the way, R8A779F0_CLK_S0D2_HSC is fixed rate, and the r8a779f0-ether-swi=
tch
only uses the rswitch driver. Therefore, the clock rate is always 400MHz.
So, I'm thinking that the following implementation is enough.
 - no dt-bindings change. (In other words, don't add aclk in the dt-binding=
s.)
 - hardcoded the clock rate in the C code as 400MHz.

> > So the yaml should not enforce an aclk member.
>=20
> This however I could go either way on. If the thing isn't going to
> function properly with the fallback rate, but would just limp on on
> in whatever broken way it has always done, I would agree with making
> the second clock required so that no new devicetrees are written in a
> way that would put the hardware into that broken state.
> On the other hand, if it works perfectly fine for some use cases without
> the second clock & just using the default rathe then I don't think the
> presence of the second clock should be enforced.

Thank you very much for your comments! The it works perfectly fine for
all use cases without the second clock & just using the default rate.
That's why I'm now thinking that adding aclk into the dt-bindings is not
a good way...

Best regards,
Yoshihiro Shimoda

> Cheers,
> Conor.

