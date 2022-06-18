Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FABE5504C8
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 14:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbiFRMjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 08:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiFRMjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 08:39:51 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150044.outbound.protection.outlook.com [40.107.15.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF891EAE0;
        Sat, 18 Jun 2022 05:39:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z2Q1sZnFP1SZiuxmFmnqxfFn3riuqv7uBZn8RqR4YmD1kHDcXF61ne3NAWpvPwUPu8sDGEiWwXdf+6zxI3icwmbPodVCHj0o3jiMpqS/3bDZqWEbDdEDx6Tw+HTRmKZtgwnD8fHHhQNN5Vg9EUylgReEiPRqDPPi06tD8SFbNWxq6BhZYrUNwkEMFNEsmhjya/gcuFnSCQtQWU/imji67t84kOHGc1cj6tfzdTezr7fXozR9KzBdAOLo13sRhj/f9gJdxCSFkO7yvUo3l3U+WyoZuWhrBCkvilmDk0C+twoEp9Uo1W9uc7IhBWB1HOPkwAkImKhrkTJ7lXVADcQ/VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i+j+mf2q80DWY0SFcU7s6mDbffd40dVFNkxK9c0rutc=;
 b=hrhRgJ60+PouhTAckyIZC03RF0BFo+YEbJtVGayHf3Yx71tyDGsWCrKLkPbhvp6U3grsHPe07eQ/jGucErRaERJdbnYVyI+yKyveHTcL/cfqKEMNiOnXwTel6MPOjuXjDUt2aIDdgjdVXE69Al4OPRcOIHf+pkEZSxnme8eSoSz83GyAFd10nvvEioSfczKMMNf4qPgOF6t/1+YjwLMDMjtxdqMqnIYTlRARC5gaV+61ew8uLDgFxaVhBm+BxRY5lO2dEMN1AMw6zPS1J7o3flOAU0UHrVoOghhNjJ/8ZhujGJ9yh+K2AQRfh4uWcYmhmurjO710eIhbbcwa3AMYlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i+j+mf2q80DWY0SFcU7s6mDbffd40dVFNkxK9c0rutc=;
 b=cnzbt6grmXmL/0tBjhC6GzUzuFu3AAjRpDkTKp1mrVdOQrYzwcjfWkSgg/Cy9YZ4QoqNIPjoO26iYDL26GhuHSSflBk7fYqJhDpUewSoVOEho/qlG0jGzfK8qHoBT/hH3g7GkNxeEkdezM8Wjz7//Fosx3/wA92xvrDMJJggDlM=
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AM6PR0402MB3336.eurprd04.prod.outlook.com (2603:10a6:209:12::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Sat, 18 Jun
 2022 12:39:47 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::38a9:5af1:f798:5527]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::38a9:5af1:f798:5527%3]) with mapi id 15.20.5332.015; Sat, 18 Jun 2022
 12:39:47 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>
Subject: Re: [PATCH net-next 03/28] phy: fsl: Add QorIQ SerDes driver
Thread-Topic: [PATCH net-next 03/28] phy: fsl: Add QorIQ SerDes driver
Thread-Index: AQHYgomLcMHkDxvWHkew8AbWa8wBda1VF4jJgAADnzw=
Date:   Sat, 18 Jun 2022 12:39:46 +0000
Message-ID: <GV1PR04MB9055F41AD598F85648B54EE2E0AE9@GV1PR04MB9055.eurprd04.prod.outlook.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
 <20220617203312.3799646-4-sean.anderson@seco.com>
 <GV1PR04MB905598703F5E9A0989662EFDE0AE9@GV1PR04MB9055.eurprd04.prod.outlook.com>
In-Reply-To: <GV1PR04MB905598703F5E9A0989662EFDE0AE9@GV1PR04MB9055.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2474d637-57fb-4901-a0b4-08da5127a0c9
x-ms-traffictypediagnostic: AM6PR0402MB3336:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-microsoft-antispam-prvs: <AM6PR0402MB3336FC6418514F4A4A282B75E0AE9@AM6PR0402MB3336.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xtvk97SskD3UKTEgYqwHvr0HMLKv3iXvL1rL5Lc9aqow0OeqE/+qLKwuBd+s86T0+MoQ/OvkBfHF8Nrv/iHis68U8Q43i0aOWiS+x4TARHizQRI04lmReDqvkJv5SroWJ1slHkFTD+DArhrGrCUrmnlc0sZPkU8LxFLYvQIcmu7d4Yi7CMck8+8530Vc8H7CPFwIPpI6c5dOAKcNWhwjUqwOa4DR7L+2joUHAzhxbR0xhvH2ExtgZQtiU9kpzSE4qdHo9Uq2oBYx+aQfdCV+xFxLmM1uhZavqAHCUx56MP9U+0zHlalznrnPJ/cP4fodL/Om5MscaIxnX7uoDsOJmkhcCkMEL4cysOKC8MlWL9NjsRu6pvvCRTYybuHNGWIKAMIbOAto+A5VTqGMsP4rrNphKUdn6Fyt66CW/U6mS4OqtA5nMyC1O22lCiG35LV6SXLz+HZoktB8WSCak0eISSA4iyznaglea2/KqqLMT2JAyj1EyE3eu0cz3Pre/zz4+L71tUteduaeQWD5BEZd4NOpwH0X7zBQfDKsve17l/Rr2JQfvYoZ4dPmQqV2jVUMeddH859K7Dq5ZSlSAgtp+FU6rrn7A8G900RCpjPWKSDI9GLaCDKsRNg+08vxmhTbpiAPCP7AbwrzMwK60kM1EsIWkwY5olNj3Y7oo5eqO9wK9Z1R++zkc8gkLE6dkBBnPlLHeUt1e2S/geiiZteUjA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(498600001)(316002)(7416002)(71200400001)(86362001)(52536014)(26005)(9686003)(2906002)(38100700002)(83380400001)(54906003)(66446008)(8936002)(33656002)(91956017)(66476007)(66556008)(66946007)(8676002)(2940100002)(76116006)(64756008)(7696005)(6506007)(44832011)(4326008)(110136005)(122000001)(55016003)(5660300002)(186003)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?cMFH7VUKMjGIEbtorPKctEfMjni+rVkENF/Ah9R5CdHwkPYOd6uQjOLkxh?=
 =?iso-8859-1?Q?PHSZXPd+0xygvBc1+nunBlhrZzxtAcoefdHiI/8/yX53ygiIlO1l6r1VNP?=
 =?iso-8859-1?Q?a6EVdSP9kaHmFGO1/5hqkU8uoFds9NoMc4A7GRI8RWituCnWUOQKNIs+o+?=
 =?iso-8859-1?Q?nNqZQU2eYody7juDW9+WhbM9L5nb+52Fh0lOfar8s5cCp4IpX371oH42pA?=
 =?iso-8859-1?Q?ZzxuoMol2xQJTtyMBIDdJ5Dv/Kh2ohiklsbXmoqho6Mr2YhMnH4dDpKYwV?=
 =?iso-8859-1?Q?wJtr4IUMXHUY/wJgeZl/DQdfTQc6t2ymFUHbZ11AuFkYW/G+OQKGTY3QVp?=
 =?iso-8859-1?Q?bWbeKFcpZt2SUeQSpgUn7E8yc1Q8LUhyoUoxG3qw85RJzBr/C62u97y30y?=
 =?iso-8859-1?Q?ezv/jjADv1ORaAziPrzPPXUgGkeDOH+Hvnw3HzNE1IADfe+QD4eSLua/qO?=
 =?iso-8859-1?Q?Fvc14FU9l6H3hl/8wygtIlNIhZwM1CM9Otq8iWqM2FtBtXIxCqIlJaZlsq?=
 =?iso-8859-1?Q?sMjWSSrCPvkc11Wb2WPB9LGd+x4lrxa/UcM04MH7PbzbZs4BJ7XkHbe+DS?=
 =?iso-8859-1?Q?9NkdzitjHB1RsoqSOCJHNYRnLadQDBD4Me3XvbkjaCi6P5RD/E8KQPJMLH?=
 =?iso-8859-1?Q?QVl2Skx6b6pYioJz+1en6yf9i3qV5PpgubX1hhWkpLptAf6F6TBpDj5VxW?=
 =?iso-8859-1?Q?rfYo5bYG5XPt7VjHiHh/TBmS01+oatBwzltiYsipHvHHfBL0pblLC23NFK?=
 =?iso-8859-1?Q?R+vA02IXP9qLJiQXq4Z8ToWb6OE4P44xU3SVR98iVBEW4aHoGyqQ/8fwR1?=
 =?iso-8859-1?Q?9IWvzGXVsPe2w0ZEFtU8gzChI0Xfzqrs4n1cbMVYC/9io9MZT0ZThF+69K?=
 =?iso-8859-1?Q?5EtTAlA41zpHDf1mvMaH1QO3kZp0je/tzo4WD2/mqJDCUKBssRTB7aFsuI?=
 =?iso-8859-1?Q?S5QHazYB0DVeeSFnaPqrjruzsipNOX3kDnKJ9F2dP/+lWeX5pfgrQ40TKb?=
 =?iso-8859-1?Q?tKWf58mf1C5KrwRlyOfEQYG2i+ECaR6DYlcR1jba19S/9GqWjn/X7WqDSa?=
 =?iso-8859-1?Q?SusoAwPvNTQXLvYOkfxi+FkX0oGoNlq1O11Q1Q+vma3PiD5jIzBsGYAmDP?=
 =?iso-8859-1?Q?hc0wjK1JVMv8C6av1BRwT2lLpNRT2cGoW3Jc6A1SB4vFI5iA7IMKwGS3Ot?=
 =?iso-8859-1?Q?yTLa7EvHLQIvQMl7t62QqVEyheXiQoMFoRQo8XXm7MS/9wN5wX1D2e7fxO?=
 =?iso-8859-1?Q?SbWIpcH3bSkd9BBMnUuHOVT+2h8Y26pj9a5HIFoHwAqGV/m7hPfweR/GJj?=
 =?iso-8859-1?Q?ghONiQveKPlTmRTlwACM1npPf0ymCb6ntNHIvLwuIXwZZ7RYA3FvOZkuDL?=
 =?iso-8859-1?Q?ha05Zt9RotStmTi8amIxhO5d/i+Q45zdWyfJgafCVriPJYFNwxV3k87+39?=
 =?iso-8859-1?Q?fHCF9O0gHQ4IF42VIRVq+StJsB+wenmSobVsOcfioNMAOa0mOaP9rlEFXj?=
 =?iso-8859-1?Q?Qt6HfZEXYXdICjETj4UxBuqHgbmfFa18EjBTWIf7n18Nf9gCGMiBq5DVdJ?=
 =?iso-8859-1?Q?OPNd9y/sC3jDKJumu/zmnJTYoTU/huqK4Mk5iIfK1TFreRIkzUAUaEVB6F?=
 =?iso-8859-1?Q?a1w37A5nRArd8gkHEpl3NNUnfKSvRM2ZDkAdpENQPC4ccDbru7hBXe5Nr0?=
 =?iso-8859-1?Q?FHeXDzTWvKcg/8mUWDUZ4lQMt4qjFmYfFQmzE6EAyBU+H4D3GJMeEmoTsc?=
 =?iso-8859-1?Q?YLOZ40c+Xzh93GHmyIIdhyKvl1wLY2m7q+0S/sCa2hKHgq79l144QX6T6i?=
 =?iso-8859-1?Q?023uM+Qtgg=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2474d637-57fb-4901-a0b4-08da5127a0c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2022 12:39:46.9020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hosnm66je0JBIlEt2beZKi6T+2A5lKopKvMxxyjNRi77mJGfGgn4x/uQK6VdAGTCkwxqJlTRWzXwD7DNawtAVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3336
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Subject: [PATCH net-next 03/28] phy: fsl: Add QorIQ SerDes driver=0A=
> >=0A=
=0A=
Sorry for the previous HTML formatted email...=0A=
=0A=
> =0A=
> Hi Sean,=0A=
> =0A=
> I am very much interested in giving this driver a go on other SoCs as wel=
l=0A=
> but at the moment I am in vacation until mid next week.=0A=
> =0A=
> =0A=
> > This adds support for the "SerDes" devices found on various NXP QorIQ S=
oCs.=0A=
> > There may be up to four SerDes devices on each SoC, each supporting up =
to=0A=
> > eight lanes. Protocol support for each SerDes is highly heterogeneous, =
with=0A=
> > each SoC typically having a totally different selection of supported=0A=
> > protocols for each lane. Additionally, the SerDes devices on each SoC a=
lso=0A=
> > have differing support. One SerDes will typically support Ethernet on m=
ost=0A=
> > lanes, while the other will typically support PCIe on most lanes.=0A=
> >=0A=
> > There is wide hardware support for this SerDes. I have not done extensi=
ve=0A=
> > digging, but it seems to be used on almost every QorIQ device, includin=
g=0A=
> > the AMP and Layerscape series. Because each SoC typically has specific=
=0A=
> > instructions and exceptions for its SerDes, I have limited the initial=
=0A=
> > scope of this module to just the LS1046A. Additionally, I have only add=
ed=0A=
> > support for Ethernet protocols. There is not a great need for dynamic=
=0A=
> > reconfiguration for other protocols (SATA and PCIe handle rate changes =
in=0A=
> > hardware), so support for them may never be added.>=0A=
> > Nevertheless, I have tried to provide an obvious path for adding suppor=
t=0A=
> > for other SoCs as well as other protocols. SATA just needs support for=
=0A=
> > configuring LNmSSCR0. PCIe may need to configure the equalization=0A=
> > registers. It also uses multiple lanes. I have tried to write the drive=
r=0A=
> > with multi-lane support in mind, so there should not need to be any lar=
ge=0A=
> > changes. Although there are 6 protocols supported, I have only tested S=
GMII=0A=
> > and XFI. The rest have been implemented as described in the datasheet.=
=0A=
> >=0A=
> > The PLLs are modeled as clocks proper. This lets us take advantage of t=
he=0A=
> > existing clock infrastructure. I have not given the same treatment to t=
he=0A=
> > lane "clocks" (dividers) because they need to be programmed in-concert =
with=0A=
> > the rest of the lane settings. One tricky thing is that the VCO (pll) r=
ate=0A=
> > exceeds 2^32 (maxing out at around 5GHz). This will be a problem on 32-=
bit=0A=
> > platforms, since clock rates are stored as unsigned longs. To work arou=
nd=0A=
> > this, the pll clock rate is generally treated in units of kHz.>=0A=
> > The PLLs are configured rather interestingly. Instead of the usual dire=
ct=0A=
> > programming of the appropriate divisors, the input and output clock rat=
es=0A=
> > are selected directly. Generally, the only restriction is that the inpu=
t=0A=
> > and output must be integer multiples of each other. This suggests some =
kind=0A=
> > of internal look-up table. The datasheets generally list out the suppor=
ted=0A=
> > combinations explicitly, and not all input/output combinations are=0A=
> > documented. I'm not sure if this is due to lack of support, or due to a=
n=0A=
> > oversight. If this becomes an issue, then some combinations can be=0A=
> > blacklisted (or whitelisted). This may also be necessary for other SoCs=
=0A=
> > which have more stringent clock requirements.=0A=
> =0A=
> =0A=
> I didn't get a change to go through the driver like I would like, but are=
 you=0A=
> changing the PLL's rate at runtime?=0A=
> Do you take into consideration that a PLL might still be used by a PCIe o=
r SATA=0A=
> lane (which is not described in the DTS) and deny its rate reconfiguratio=
n=0A=
> if this happens?=0A=
> =0A=
> I am asking this because when I added support for the Lynx 28G SerDes blo=
ck what=0A=
> I did in order to support rate change depending of the plugged SFP module=
 was=0A=
> just to change the PLL used by the lane, not the PLL rate itself.=0A=
> This is because I was afraid of causing more harm then needed for all the=
=0A=
> non-Ethernet lanes.=0A=
> =0A=
> >=0A=
> > The general API call list for this PHY is documented under the driver-a=
pi=0A=
> > docs. I think this is rather standard, except that most driverts config=
ure=0A=
> > the mode (protocol) at xlate-time. Unlike some other phys where e.g. PC=
Ie=0A=
> > x4 will use 4 separate phys all configured for PCIe, this driver uses o=
ne=0A=
> > phy configured to use 4 lanes. This is because while the individual lan=
es=0A=
> > may be configured individually, the protocol selection acts on all lane=
s at=0A=
> > once. Additionally, the order which lanes should be configured in is=0A=
> > specified by the datasheet. =A0To coordinate this, lanes are reserved i=
n=0A=
> > phy_init, and released in phy_exit.=0A=
> >=0A=
> > When getting a phy, if a phy already exists for those lanes, it is reus=
ed.=0A=
> > This is to make things like QSGMII work. Four MACs will all want to ens=
ure=0A=
> > that the lane is configured properly, and we need to ensure they can al=
l=0A=
> > call phy_init, etc. There is refcounting for phy_init and phy_power_on,=
 so=0A=
> > the phy will only be powered on once. However, there is no refcounting =
for=0A=
> > phy_set_mode. A "rogue" MAC could set the mode to something non-QSGMII =
and=0A=
> > break the other MACs. Perhaps there is an opportunity for future=0A=
> > enhancement here.=0A=
> >=0A=
> > This driver was written with reference to the LS1046A reference manual.=
=0A=
> > However, it was informed by reference manuals for all processors with=
=0A=
> > MEMACs, especially the T4240 (which appears to have a "maxed-out"=0A=
> > configuration).=0A=
> >=0A=
> > Signed-off-by: Sean Anderson <sean.anderson@seco.com>=0A=
> > ---=0A=
> > This appears to be the same underlying hardware as the Lynx 28G phy=0A=
> > added in 8f73b37cf3fb ("phy: add support for the Layerscape SerDes=0A=
> > 28G").=A0=0A=
> =0A=
> The SerDes block used on L1046A (and a lot of other SoCs) is not the same=
=0A=
> one as the Lynx 28G that I submitted. The Lynx 28G block is only included=
=0A=
> on the LX2160A SoC and its variants.=0A=
> =0A=
> The SerDes block that you are adding a driver for is the Lynx 10G SerDes,=
=0A=
> which is why I would suggest renaming it to phy-fsl-lynx-10g.c.=0A=
> =0A=
> Ioana=
