Return-Path: <netdev+bounces-6349-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F1586715D90
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:42:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9424F281002
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:42:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBF1A17FF9;
	Tue, 30 May 2023 11:42:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99D517FE6
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:42:35 +0000 (UTC)
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2111.outbound.protection.outlook.com [40.107.113.111])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8865D9;
	Tue, 30 May 2023 04:42:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DAN8jP9bJsTOfbySNw6HE/CJMpS4sZvsDEtp2zIu7kpb9Sxgte7kFCBubaIY0EiqetGR8YF/lATcGtkJWnLZg20AdAvvy0/T123G8IzKJdT1ItFWkhb0rJ970EuA22eN4CzF9XtQjzmcgoaRfghO87t8vMZk97/c3OUzjRBroRWMzqkh3reE4h3QkcU8/Y4xi053cqNQpM+Bomy95IjG7XsLurAqGDjMaptGtKgMx9JcytEv44i7EtwzIPhD2mHEvyaz74jvdfwGKO+aDnUgRLX9bIp1pdKkRUbs4Uj2yQWcIv9A80VLBhfP+3HLHir17vCHDxWAQMWIw5s10STlDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b6qO7p9D9UmEg5b5qIupKiPPSoxOErzf2FOXfiLA/Wk=;
 b=bXA6Jsd5OrN7Wnb7XVaIvoznK5N6wbu5BtO0EvP8FCklu/rJ6ZuvgGEnQ2R7kHlfqHGBcloEAlMr59DA2O2k7YYBPdWYJdLQ/NLbI4BTmTPc5bVE/QpgZTfloE5OrBMzu55/43oBd/dEBshN3tZT6OlnlGMVWY7OYPIQ/hhaEpzv3ZciaYlG6XZNW/qNchbgKo7gXMJeYDpMY2jz1YluOXoc+sto5t0pUAWaf/DILScI+zNAjgXvuTNuwVoQhFps7j6sP1NGwoP9xxVXEwt54BQ9QcjiccetV+YmmA6LbSJAOng3OwOk8/4JZGcF8SLsFNwZbmN2+WZFkSSMt9kN0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b6qO7p9D9UmEg5b5qIupKiPPSoxOErzf2FOXfiLA/Wk=;
 b=kJgqCKDtmoJFyIK/e0pKj362gFVCGZQ+8pgmR634ITwwweLzHn9T4iNShrkhW/k3bpPrEmvjh01E6gwpIGLKTsVmmerb1BHRfHc8fo5Ldo5PU4eA8UOTcR0Nyo4IJ0l9JS5JTnJWdL/iG8W4HTUJKq6wEV1duCMhxY4lh7EgR4A=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYWPR01MB10307.jpnprd01.prod.outlook.com
 (2603:1096:400:1d5::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 11:42:21 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::5198:fdcf:d9b1:6003]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::5198:fdcf:d9b1:6003%6]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 11:42:21 +0000
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To: Conor Dooley <conor.dooley@microchip.com>
CC: Conor Dooley <conor@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
	"s.shtylyov@omp.ru" <s.shtylyov@omp.ru>, "davem@davemloft.net"
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
Thread-Index:
 AQHZkgTOMehFAJcCYEiyxAnN6zOUpK9xlM6AgAAalQCAAAlMAIAANM7AgAB9cICAAEhYYA==
Date: Tue, 30 May 2023 11:42:21 +0000
Message-ID:
 <TYBPR01MB53414B591D8C7F458839E7E7D84B9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230529080840.1156458-1-yoshihiro.shimoda.uh@renesas.com>
 <20230529080840.1156458-2-yoshihiro.shimoda.uh@renesas.com>
 <20230529-cassette-carnivore-4109a31ccd11@spud>
 <15fece9d-a716-44d6-bd88-876979acedf1@lunn.ch>
 <20230529-ambiance-profile-d45c01caacc3@spud>
 <TYBPR01MB53413C7E1E5AE74ABE84ABE8D84B9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <20230530-nineteen-entryway-cab54d3e3624@wendy>
In-Reply-To: <20230530-nineteen-entryway-cab54d3e3624@wendy>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYWPR01MB10307:EE_
x-ms-office365-filtering-correlation-id: e3100b14-cecf-4986-a4d2-08db6102edde
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 z3YCS2bKA49KkXo1tovLWqXoA+mUIqQJnq5DdxRzUfaAKaFtvKNLqTh8sE+lZW/LhyU7mGhnJQP2+7QbOyQT0CPWjxa9ADNRe0SdVJhMUQfHSpcvPT4jXq7ASO+ymP50ElU/3EPHY+nFeWkQHSwgp9f6GypY3V36yAANiwkd5CM3qY3u0fTlapTHS9Ti8A9fD5NH9QL/Bk4AM6fis3ssqDE/FbhsYDTKlyMguZ5coiMzLAfG8VhwilQunMYKoMkvThqRWP/280asFp4IhbMh9mugpwj8MN1AEotghkUZKBNc51/K+1xZjvLYVa72FG0Kd6hugHmka2um85XoHMxgsncBbRylx9bxru0MW9ZHY7k88v8NIifHdDkB3P5CkNpKCXcD4zkCHPCPZtp3M0/9PhWI3gpHzw7yQoM2cxYnKa4N7EtkzU412J4LCuOkG/AdUyjnCFb3hW4mJgSG3UmR77O1Qxa/IgDZ8gC6e3KvGedoicxLph8RJFWSq23CuTORiO7MgvSywa0hmMTjAcrtP8Bt15/4vCYv9p6C79xjg9Ovw2Cn/o6W4bqQgXAy4w8Kih01uEdMqo70taSy10ug8gy0CcEsGYbkHPqmzEb90UOA76iQf6U+mGWGo35Go4Ox
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(451199021)(186003)(38100700002)(41300700001)(83380400001)(6506007)(26005)(9686003)(7696005)(478600001)(54906003)(71200400001)(4326008)(6916009)(66476007)(76116006)(66946007)(122000001)(64756008)(66556008)(66446008)(55016003)(316002)(52536014)(5660300002)(8676002)(8936002)(7416002)(2906002)(86362001)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?OIfN70VOWUSDlaEE3YLQJYr1nN7/DXzR77y3JUATXHnVr6JpIF9qEJfZ2uLQ?=
 =?us-ascii?Q?0eEEJdC/AXru+0ltCcJG/SqvSix2I6gh/n6sXqjV5bgR7cvehDSxP/Ds+vbH?=
 =?us-ascii?Q?MTgeLIolghSvUSzUxi4ry3oPnXIHpyRc0Am2NWL2YeRriIReQfhwbs927Kf9?=
 =?us-ascii?Q?6auGQGovKt8+MJuOBslQe6L6Vxry4Vkb33CdqXJz+wY2fEO98QBNUUbEtIs+?=
 =?us-ascii?Q?mvmTscVZjNyTd/2N7pRGR5wuZaZoMy/PsCZ6oq/oo/9y8rz8NvDAlTJRxPpP?=
 =?us-ascii?Q?D7z9I42bFuCN/Vl8nVtmgfs3ndvKZzA9Vg6Xw9Oj+JdePhoICBoY4h1IQ3Y+?=
 =?us-ascii?Q?2BLv2we+5gQiDqr3/cIYK6c8Hi0spx2TQVRWocWJ+M6FBZnbzZa4jIBnNRf8?=
 =?us-ascii?Q?uKXCx1GESQpnYMqCl7CqK2WRxHJ2fzexzHAoY4oHHUURXrPqgSEoLbsQBUzG?=
 =?us-ascii?Q?tVnenPeB7lIMY7rcgX4IwD4lOuYo5GfxXBvKPyqARlNdMFuddp0LLB3D1LfK?=
 =?us-ascii?Q?zXsQXLX8U23Ue8rTIdN1uRV0/dfV8Xl+dBYsGLnMji+AcEogF/NOfm8rb3so?=
 =?us-ascii?Q?mLkFZ6YIqdvAdtTD52M/psQBhSAAnakndwBmUZmRZzVVFSEEE4iumqaxJ36u?=
 =?us-ascii?Q?Q82TJmE7aqVshNs8B2aJZXgVMZav3K5n30i/Sl1ARbk6hP0vaH2MIzDvBpOQ?=
 =?us-ascii?Q?MtacTO8DSf1ZvR/C12dixTmaXrEf3fXEhfyhAoB/u+Sw+1zI28iz8ddy57LF?=
 =?us-ascii?Q?LQzzRaFngyLyigrkdheyP2tRNnPL7x4+sitm3WFX0mF4TkJ/w27J13zFfAOt?=
 =?us-ascii?Q?RqX7BV2dE8QPKhML7U6HcAENolIRxuNdH3ANZtXajTwddbpJCIvxikQuhRap?=
 =?us-ascii?Q?acVQQwQLs4paX+9o8UKTuB+kSl+SIoHDctRKtxKZ87w5vgQ252AY9YwQf1uV?=
 =?us-ascii?Q?ACoYtCCAkBhDZRBade1gyy88jsWDPafc8WtWZf2dcHY80saXl3FbGbFMOqlC?=
 =?us-ascii?Q?tg1+yoHesbtDSKTVZmmbYDJN/di7+1vQUilT9o3+7SjqMgVSdSwzRAYIol9o?=
 =?us-ascii?Q?5mFZ/7dryvYY1HSb8G73NOX+4UBgwFukhmmE8r4YuIz/dln4N7dXMQBk+yD0?=
 =?us-ascii?Q?DxC7MSxbrZdqDsr3d/MBgpgH+0hc4Vr6Na2lzoqGmGBqpXDTQvgdHwzFEAck?=
 =?us-ascii?Q?rb2PlO3Z1mHCG3lWJ/+IBh4YnnBeMd+cr/9TLnhcG16NbORG+R25yeWu2xw8?=
 =?us-ascii?Q?VB1K8UwFqhQe+1kRxCBaDek3Hm5O+OHwNlcVs1hdf5L3O7zW4Rtk5+Npn5f9?=
 =?us-ascii?Q?6UeUgJYfZlOYrlSXRkl6ZJql285UyzHHSRID50ct0+MyceCBsSBTm39sCFV1?=
 =?us-ascii?Q?A9poVro7oYXo4NCvOjr8LU73FrB/HSFumVs2v5KZjYIfA0J/rHsKFmLWlQ6E?=
 =?us-ascii?Q?yI7FXhcXRE1zYyerUu0rv86cDfgtC3n8+0HRWFlO0tFYirRQJeCoBy065gMI?=
 =?us-ascii?Q?QtB5LJPACV/d+4VDnY/dV9YMb9clWMgn9nwpsXGLJmp9fEh55sOcd0MH23Es?=
 =?us-ascii?Q?1W1tdrA6T3U8a0b18kZXG0QfRp/sAXy8hWzF35YIiykuk4TQ4zxlOLKRZq4X?=
 =?us-ascii?Q?SA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e3100b14-cecf-4986-a4d2-08db6102edde
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 11:42:21.1237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HYp8unKVRNRAFlnLPMjukhBMvQfDjBAWALFUk6Puejq6/g8p3tVOOvtpIiEGFYVqJqrl0Rt81SkFtNAsnGay+/yuzNcLIBgtxlsgLdt/J3lA2yHbjBpuJ1kmuIDqgJUJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB10307
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Conor,

> From: Conor Dooley, Sent: Tuesday, May 30, 2023 4:22 PM
>=20
> Hey,
>=20
> On Tue, May 30, 2023 at 12:19:46AM +0000, Yoshihiro Shimoda wrote:
> > > From: Conor Dooley, Sent: Tuesday, May 30, 2023 5:44 AM
> > > On Mon, May 29, 2023 at 10:11:12PM +0200, Andrew Lunn wrote:
> > > > On Mon, May 29, 2023 at 07:36:03PM +0100, Conor Dooley wrote:
> > > > > On Mon, May 29, 2023 at 05:08:36PM +0900, Yoshihiro Shimoda wrote=
:
> > > > > > Add ACLK of GWCA which needs to calculate registers' values for
> > > > > > rate limiter feature.
> > > > > >
> > > > > > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.=
com>
> > > > > > ---
> > > > > >  .../bindings/net/renesas,r8a779f0-ether-switch.yaml    | 10 ++=
++++++--
> > > > > >  1 file changed, 8 insertions(+), 2 deletions(-)
> > > > > >
> > > > > > diff --git a/Documentation/devicetree/bindings/net/renesas,r8a7=
79f0-ether-switch.yaml
> > > b/Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch=
.yaml
> > > > > > index e933a1e48d67..cbe05fdcadaf 100644
> > > > > > --- a/Documentation/devicetree/bindings/net/renesas,r8a779f0-et=
her-switch.yaml
> > > > > > +++ b/Documentation/devicetree/bindings/net/renesas,r8a779f0-et=
her-switch.yaml
> > > > > > @@ -75,7 +75,12 @@ properties:
> > > > > >        - const: rmac2_phy
> > > > > >
> > > > > >    clocks:
> > > > > > -    maxItems: 1
> > > > > > +    maxItems: 2
> > > > > > +
> > > > > > +  clock-names:
> > > > > > +    items:
> > > > > > +      - const: fck
> > > > > > +      - const: aclk
> > > > >
> > > > > Since having both clocks is now required, please add some detail =
in the
> > > > > commit message about why that is the case. Reading it sounds like=
 this
> > > > > is an optional new feature & not something that is required.
> > > >
> > > > This is something i wondered about, backwards compatibility with ol=
d
> > > > DT blobs. In the C code it is optional, and has a default clock rat=
e
> > > > if the clock is not present.
> >
> > I'm sorry for lacking explanation. You're correct. this is backwards
> > compatibility with old DT blobs.
> >
> > > Yeah, I did the cursory check of the code to make sure that an old dt=
b
> > > would still function, which is part of why I am asking for the
> > > explanation of the enforcement here. I'm not clear on what the
> > > consequences of getting the default rate is. Perhaps if I read the wh=
ole
> > > series and understood the code I would be, but this commit should
> > > explain the why anyway & save me the trouble ;)
> >
> > The following clock rates are the same (400MHz):
> >  - default rate (RSWITCH_ACLK_DEFAULT) in the C code
> >  - R8A779F0_CLK_S0D2_HSC from dtb
> >
> > Only for backwards compatibility with old DT blobs, I added
> > the RSWITCH_ACLK_DEFAULT, and got the aclk as optional.
> >
> > By the way, R8A779F0_CLK_S0D2_HSC is fixed rate, and the r8a779f0-ether=
-switch
> > only uses the rswitch driver. Therefore, the clock rate is always 400MH=
z.
> > So, I'm thinking that the following implementation is enough.
> >  - no dt-bindings change. (In other words, don't add aclk in the dt-bin=
dings.)
> >  - hardcoded the clock rate in the C code as 400MHz.
> >
> > > > So the yaml should not enforce an aclk member.
> > >
> > > This however I could go either way on. If the thing isn't going to
> > > function properly with the fallback rate, but would just limp on on
> > > in whatever broken way it has always done, I would agree with making
> > > the second clock required so that no new devicetrees are written in a
> > > way that would put the hardware into that broken state.
> > > On the other hand, if it works perfectly fine for some use cases with=
out
> > > the second clock & just using the default rathe then I don't think th=
e
> > > presence of the second clock should be enforced.
> >
> > Thank you very much for your comments! The it works perfectly fine for
> > all use cases without the second clock & just using the default rate.
> > That's why I'm now thinking that adding aclk into the dt-bindings is no=
t
> > a good way...
>=20
> I am biased, but I think the binding should describe the hardware &
> therefore the additional clock should be added.

I got it. I'll fix this patch on v2.

Best regards,
Yoshihiro Shimoda

> Cheers,
> Conor.

