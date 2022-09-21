Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 460DA5BF85A
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 09:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbiIUHy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 03:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIUHy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 03:54:26 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2099.outbound.protection.outlook.com [40.107.114.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8763785FB1;
        Wed, 21 Sep 2022 00:54:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V1Fv3/kggnTc3jVgSJJaUGMyk41WIdYXQf3iaHl3SpR6oqesU4lDRUiflEF+6yQoUYgGUpKt/BWKUaEcO8oLpi103a+ObLu9PkfR4J5/tHXEFyTQMlbFw8XqlC5MRlPgFoho5NfpwqVmP5tAUANTKIOQA2wkC4wlPychRANoUxMOXSgiQteXi/Ca323jpOorY94zIVelq7ve8byGfMttjfZLVqcBesEcmjQDruz5dvjW+K9qQlSiPg595KKHkYoJJsvLfLt8tYNwoKkHN+taVnA9jFI1w/NgYPlvmOmJUghE47TCPgKD08KLDGWQ1F1wBSVNi9B2mePmIJi8QidnuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jc+1h/MsZrGkfmuc8l4I1a9EYxQGa05oHLOdmfLGoEQ=;
 b=RsRzGSJM0BfUpGl8gmG6UFc3sPk82I/CxfvtJNzCB2Q9SxN/89QN7nvcss8YOWn4Dyu3Yntu4tHRz+MvfelnRU5RI/RdRTDtvzGPNAtvZ8HLnzTuI47Ob/Il30QlqlTmVuDo0U14cJmBsFHnjG903zjh1Ez4w99kWfcFMsYESibnrCZ7CfJfvh4vADORUTZADstHzYPscQ+Ib/SOoXErtjXeeSSqfWw9FLuyqPtODNoCkYZD1fK0onCft4Qml3uWmNwSIy3mNKNrMgfmxVvGcCi45LVryEEsN5FMGVJQK2gP0Tj2ol7zjBrFQzldYkiv3RrpYOsD+Mt8rpPn+B8wSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jc+1h/MsZrGkfmuc8l4I1a9EYxQGa05oHLOdmfLGoEQ=;
 b=H69a2+E2ki9C6kk7SKKzgApfEP0Oj7Q2MfAXF+CbOXDii/f5QsiJivkwp9HSVayaqh0/uIYwaldqbKGUOEOaPCOlguzQMwWEgOu1mkRxARX0Mf6UiQkLGL2mMvyRC+YtWxlxcTUKhs8YwWvJO0iVi9lWkxLrY1KqhIAtV6iojYY=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by OS3PR01MB5815.jpnprd01.prod.outlook.com
 (2603:1096:604:b5::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 07:54:21 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::2991:1e2d:e62c:37d0%3]) with mapi id 15.20.5654.016; Wed, 21 Sep 2022
 07:54:21 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 5/5] arm64: dts: renesas: r8a779f0: spider: Enable
 Ethernet Switch
Thread-Topic: [PATCH 5/5] arm64: dts: renesas: r8a779f0: spider: Enable
 Ethernet Switch
Thread-Index: AQHYxE/KYBwY6XjQF0ijnvFAnT+7Rq3cg3qAgAHcCKCAAH7ogIAKtoSA
Date:   Wed, 21 Sep 2022 07:54:21 +0000
Message-ID: <TYBPR01MB534149AC78A0014DFCA587ABD84F9@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20220909132614.1967276-1-yoshihiro.shimoda.uh@renesas.com>
 <20220909132614.1967276-6-yoshihiro.shimoda.uh@renesas.com>
 <Yx/L1VeVmR/QAErf@lunn.ch>
 <TYBPR01MB53414B8CA1157760148FACB9D8469@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <YyHFnZdGTJL8uLxn@lunn.ch>
In-Reply-To: <YyHFnZdGTJL8uLxn@lunn.ch>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|OS3PR01MB5815:EE_
x-ms-office365-filtering-correlation-id: c219bfc1-d45a-469f-9b48-08da9ba67e61
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EuV706oPvZ2PuxD7UW934CTlOU2WnjqYIfBFTwS+HW57yz2ZyE3shjMB4GL6xlExz1tsGW0P6WeES0IKQPCLYzH7mLLBsCMACziLo60WE3O1oxQJRkGSMBr9z32hmavaCU+rQqc+hADhyRO5DfEQoYQqOg0oDY7rJ9SEOcqsy5cgH5jDtm9YLHdOwxaaqr1dGe8GdshWnxwFVDdCZriXeMY5U5+OXqlj4wPwXJONJZ6GfDSzxgBxJ1BpKXJ/ey8TiP9Ojf3umoLkCCcOgqKy4S73rlEFGrg0qq1EQo+45u3NCX1EOI34k5nkd3upJ84C80T2R9T0qnqtSUn9KRxxMaic2BpV2w4uWOVoENpDnu7VDznQzdx3jlUoin1FpLR7G/9DtARgqxM8z9SC4VALZ41tHKaoasu5r/DRR9D9gift/jDwlJZcwZzveuqpnAHqAojTUg5nTi2C09StLWeeP2qp+J2zoDWm2PZkY6LBv3fen77uHPzcgEVoRR97Ci8I625PFhvI6NzPzOFpNqUOx1A17r0/niDTj+CsiYXfiu++nStREMMKFvm1uCx7CSjhogIJBZ3K7lrhH5dKVyI31e76i9ojx1j06fj01HSDr6T7v4Pu9P5gaBlucbrxORCNuPaatjZwj9DCEZoKfFxl0e58v4f97Is72qTQekaHYws0xRyT2AwHeOY5DynYFYmnwGhC9JcVew80lwT6jkqmkZQbTEXZjHbeo1VygdT27REYQfjj/VNDHYh4JPmFSYnk69tvBIiilkXljL2ORat7DsYEI62FD8HLGjte/eKbRzg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(451199015)(38100700002)(122000001)(4326008)(54906003)(76116006)(66556008)(66476007)(66446008)(8676002)(316002)(66946007)(55016003)(6916009)(33656002)(9686003)(186003)(6506007)(7696005)(86362001)(478600001)(83380400001)(71200400001)(5660300002)(64756008)(8936002)(2906002)(7416002)(52536014)(41300700001)(38070700005)(43134003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1pV/UC5DOaTe61g+O0UpUIvZr2eO93CRimXwCkh5D6xp5BvzYHvXosZTgzpY?=
 =?us-ascii?Q?qXPkYsJ0TGHSaptn7ADcoBOdZBGLXegAVHiv8XIlOh96rsGBldCCy2vlAf4f?=
 =?us-ascii?Q?QOwd7M6n267IbJgPVNTte6VPuz12S8PsX7lGXnobtgXWm84c0Nf2ajMV9vW9?=
 =?us-ascii?Q?YrLoDL3zj4Imglf/CCRrKqb39KyEQQ3IrAchCcaQ5fzD2Qkevyz/BVyKPNmH?=
 =?us-ascii?Q?kpiiaFZeRG1EKJcAGWhjvM3Rwco2DoW+B+ybf76E8T4BxG7sMkeRTMXJuW5I?=
 =?us-ascii?Q?x6q1dkEpDd4SD/YXjA/j/SurY3+llg1wLYLlawyPp4s0YsaBIEsOarqfVvsR?=
 =?us-ascii?Q?jI1sFwlm9OOkjEQ7/mI8HCBppudVoG197ZzTC/XDzgioiM6bAzBZ+pbCjTRA?=
 =?us-ascii?Q?/2pXyyVviP6NYXzo9aXZ6VGzZMiRWF2tZfOhvrdUAtn4PuX7v5ey7bJkd/kV?=
 =?us-ascii?Q?kCf2UIvJmiQRTWUXwr7ku58vfJHES1pQ/q+L4S6wzfQwfY8gXcphn0KHSX+S?=
 =?us-ascii?Q?mZ3SxNAsm969bDYPpW/o1eN/zAGbPepDYTHc4MjSyS7nFxraFcZEvF3IW8e0?=
 =?us-ascii?Q?SYmbB15/8PuGyUQsLd2wrZqDtR3jT3q+Hd03PYrphYa55YNwftSsAWYOOfA4?=
 =?us-ascii?Q?P4yHmDbsNA9ST5smtfkPRS1CjMRAjLN94yZlBAbSBuRkPeJnk4t+pMw4xqk/?=
 =?us-ascii?Q?L7iSIXygamIR+VNXba1F66AP6ZrJTnmrw3JHY8w+GlGZq95bYRO3aO6s3VxE?=
 =?us-ascii?Q?uxP4mEXpxDSNHHHoT7/S1aEVYV7Yo5ds53mLgQ7rMrjihCf4O99u9TEMIu7c?=
 =?us-ascii?Q?HL1X3Qd1RBAjMi8LwaqntOJ9J1Fv4tfdrjiM02+/S0WVZHMvs19r5GOCb2WL?=
 =?us-ascii?Q?5a3E+KXTbMDF0qgWu9zH6sONj/+h3OV/HdLTFy3LIHxt6jvt94PNObPy8UiB?=
 =?us-ascii?Q?zrOLRWT6vMdSkdOjfHGGLnKhG06jO2Nm6HaPeg+VWiCMAwmVu/3tb+xMpoRn?=
 =?us-ascii?Q?DLF+lrsQWfY0ndqmCFxodYYDwwvpiG1gHMSIOzMvpYBmbyu75b/mjW+3MBeN?=
 =?us-ascii?Q?stbi/LfndLDF7RpWTZ1lU69HvpZJtzlA+egAbYdQKgfE2PSqNsHaRjBXCpjs?=
 =?us-ascii?Q?cVnq/D79onUP+QTDouttdn3dOpCFPp6u5e89xdIMlqxQSmP3B4QxOrXYf43v?=
 =?us-ascii?Q?UacQUXK8oeSuDnOHl3+9k8uY8cziCq7WM7AdG85fc5sycnKR7wqY97d9cnrF?=
 =?us-ascii?Q?HefXruEcNhscJBOXHkGG9o6kbr87NH9otRZoFC3/VNDLZSquFrJ8MItjWHy1?=
 =?us-ascii?Q?qfcwxVI+LPhxFwL/Qo6PsGvEsHyUM+2ZHP2RP3wQNySbyZvObz8ZoEZlK5vz?=
 =?us-ascii?Q?d8CVkEZrB9P9XLvvaE8YUtq1OgqvH0LNmfrwoQDydd9jOQdj45brjSjSaSAj?=
 =?us-ascii?Q?5/ZOFlNH/EqILA5pk2mmB8/gcLq1+3sf/6x45WAioR/LV0zNpxXADuap8FTT?=
 =?us-ascii?Q?BveNCGtU6fxEAulUSauIeWq71cQeKtRiS+4yHiHuw1RTGlZyTMmxWslXazUB?=
 =?us-ascii?Q?HIMjHMlNAhvDw484UKNQy0NNSQnOZcyu/FadgdlgJcJZZWKQWITvzU/Z37yN?=
 =?us-ascii?Q?BdgosbL1CZH9zSYDBWfZl03gfRPWgcBc7cm99AB6AvxrGZl4zJMZK6uvgS70?=
 =?us-ascii?Q?zKrgFQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c219bfc1-d45a-469f-9b48-08da9ba67e61
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2022 07:54:21.2945
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IWcAPw3jcpUSorW7T2vMEH3Fgh6Fo5AaC7q2WFMzRTQQib1+LjiuuSvXl2jX600ivbgQwf3YRIBKFT6s5QqPKtV/HHP+YrASomMhCpZpaSwpQppqtyoImWO2s8z+3hl6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB5815
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> From: Andrew Lunn, Sent: Wednesday, September 14, 2022 9:14 PM
>=20
> > > > +		port@2 {
> > > > +			reg =3D <2>;
> > > > +			phy-handle =3D <&etha2>;
> > > > +			phy-mode =3D "sgmii";
> > > > +			#address-cells =3D <1>;
> > > > +			#size-cells =3D <0>;
> > > > +			etha2: ethernet-phy@2 {
> > > > +				reg =3D <3>;
> > > > +				compatible =3D "ethernet-phy-ieee802.3-c45";
> > > > +			};
> > > > +		};
> > >
> > > I find it interesting you have PHYs are address 1, 2, 3, even though
> > > they are on individual busses. Why pay for the extra pullup/down
> > > resistors when they could all have the same address?
> >
> > I don't know why. But, the board really configured such PHY addresses..=
.
>=20
> That is not wrong. It could be the hardware engineer is used to shared
> MDIO busses, and just copy/pasted an existing design, but then
> separated the busses?

It's possible.

> You might see actual customer boards putting all the PHYs on one MDIO
> bus, to save pins. Linux has no problem with that, the phy-handle can
> point anywhere.

I see.

> One last thought. Is there anything in the data sheet about the switch
> hardware directly talking the PHY?

Yes, the switch hardware can talk the PHY directly.

> Some of the Marvell switches can do
> that, but we disable that feature. The hardware has no idea what the
> PHY driver is doing, such as selecting different pages.

That's interesting.

Best regards,
Yoshihiro Shimoda

