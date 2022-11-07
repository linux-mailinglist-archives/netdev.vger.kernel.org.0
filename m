Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C90D61FF26
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 21:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbiKGUHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 15:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232032AbiKGUHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 15:07:45 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2084.outbound.protection.outlook.com [40.107.105.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A6427145;
        Mon,  7 Nov 2022 12:07:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lw/LRUSdBWmw+GZT4zmJiZ+UIHxYExoUpIszK/k7Q4oc/5LZLIrNZJARXC1mtCtB3CiEgPzT1SGHaAHBv12/kMa0bas3fMQTzXyUXm0vwAZTvHab3Fw1KGwNxzI4oj4lTbgTyqEywr6Y7jccWVIEbmhFRTFlSEg9pf5jfZmm8/pg2M5HcOzqtQONFE8ZRNgvqbG9UYiOH9nIGUgKdjwvNUCOy2+MrR57kaVF4kXqyjNadyk9eOVZFn9kbPqxSB/M/APJ/nsEA26fl2+2HIgrbwtFBW9pK0Lw0PszRzNsmn3B6SAfUHlY1A/vm0zOY2DEUsGbIBD5gR5oyQwSXu5X2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WE85osMLjxGzueznE2urcU1wSZD8BbjPoFiwWk1pn64=;
 b=jmoXoi6R85H/MAD/oetLEXlklbT8WSPAUBq9swODT3JMS6/W4O88I3UDQulI8qj7xV2D4pa3n3YAxuM0vqsJEZtwwCf75/ZsbUfj4FLil88S40ztdT1/QlVnp0DW/I7hbts0r3feMLxin+JN6LRSBiZOIIeK9TUocBJLJo8/UxaJNJX3+t4EMMCbKcWMMSfyEi5dQG1b1iX/mQgbpvNUiYWidck+UlYAcWLZn9E5ZFO7mIAC5fHuHwFIEvru9Hd1HQKwL0xkapwsaIl3Yrxiq/JNmu2fDtCnEzLPm9Js99sLIA6zqLFZAu6WA5Bz6MBbPH+yLsEHSp1XCma+dLo/uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WE85osMLjxGzueznE2urcU1wSZD8BbjPoFiwWk1pn64=;
 b=b9Uibpku+djmgM5frWDotZ5Y6P7vrJnsbyRASVvHWUbcSWaixcEWgZz4wEiGwjYsAF+eZwSbE9kJvL/1zWbYt6k8/yepv9XkxnH0mzPTeGJRL4O4bXHoDeVdFYo8L2cepV4ZUtTcF1rRuKad59tVTHLlkrYbq1iuRd/+AKH7swo=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7488.eurprd04.prod.outlook.com (2603:10a6:800:1b0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Mon, 7 Nov
 2022 20:07:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::4a73:29eb:28e3:f66d]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::4a73:29eb:28e3:f66d%7]) with mapi id 15.20.5791.027; Mon, 7 Nov 2022
 20:07:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
Subject: Re: [PATCH net-next v8 3/5] net: dsa: add out-of-band tagging
 protocol
Thread-Topic: [PATCH net-next v8 3/5] net: dsa: add out-of-band tagging
 protocol
Thread-Index: AQHY8HTAfetHoGxM5E6HcRPQNrr8s64vpgIAgAOw8wCAAFjYgIAADBEAgAAPngCAABzHAA==
Date:   Mon, 7 Nov 2022 20:07:41 +0000
Message-ID: <20221107200740.3zx7lwjtyei3fcqp@skbuf>
References: <20221104174151.439008-1-maxime.chevallier@bootlin.com>
 <20221104174151.439008-4-maxime.chevallier@bootlin.com>
 <20221104200530.3bbe18c6@kernel.org> <20221107112736.mbdfflh6z37sijwg@skbuf>
 <20221107084535.61317862@kernel.org> <20221107172846.y5nmi3plzd4wemmv@skbuf>
 <20221107102440.1aecdbdb@kernel.org>
In-Reply-To: <20221107102440.1aecdbdb@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|VE1PR04MB7488:EE_
x-ms-office365-filtering-correlation-id: f80f46e0-5a39-4e92-542e-08dac0fbb9f0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GnuToWVVzoCxsAuypBYiftg8sjYKQEGif4m40m55SAOrRBtVDs7zxHOy+W3i/Ca+W1MeLcOHdXpcdwU88/rfeJIhXF/XZ2Y5hIZBl6BAd03dTGS9DJmtPUfMyplYz+2LfJ/j4QCGdfpwYLOO8uHB9tZg6XgCWgyXl4Qk/J1PEC5U0vUA8/x0n1nclauaIEbiFGc9D9sS/5+YIRcOddFzceBN4H6uygPzv/ARdWvK1BAdflpMsNYouzmzM1kLLRDB1ApsXLJlhWkv0qFZ3k4v9tStY4WFio/jju6G32pgtKjYkneNoN//AFlZVYCwsSp0Cd4NZPYfAwzgNAfoDSpt+XcepBIruZiTd7aUI/OgBBPM/dEofg/O+SfchsZejRymeCxAwWPdMEijqZ0JXewDiTsgf43Gl9tE1His05ovUEBnyxri6ewNDSG0RJm4CzzQKNdQU7uNkXCHA1wsQpRf9fqmDgGknutn0RAmi1y4G1V4HGeIZDedPtLQ0bWo/XT//tUwAdhPENrTXtWf4zm8YnltLgJl7wmPkUCJFIqWaarp3aluPP3P1Au6frp9GjYn4VEKRPrOJqyntG0ePbsbsXdHqSoDVJTBdr9XMSSkwwphvoHEwf1HNK5+S+Fbgsa3dPv6Sp7sawPoqS6sOr32EVnCeOvRleSXtNL7Y/OuwDMnJaXstkgvMZEh6RrMpcvuums8XUQ5mzPQVIPJpRvJuYT0+XwFUgH9fVyvCwmgQyywuRnLH+wGHJxx/43bIvBfeq1HDAzFokSttwzHWxlQpCYSvkATLOJwNIfwmFdgv9w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(451199015)(6486002)(2906002)(478600001)(6512007)(9686003)(26005)(6506007)(966005)(8936002)(41300700001)(316002)(38100700002)(6916009)(76116006)(122000001)(91956017)(38070700005)(7416002)(66476007)(66946007)(66556008)(66446008)(4326008)(64756008)(8676002)(71200400001)(86362001)(33716001)(5660300002)(54906003)(44832011)(83380400001)(1076003)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RZRx3bDR11CeuYhjBBNtgymULvgCewwNcnNCXBYw9SVdIfFDP7VLWlZJnOxL?=
 =?us-ascii?Q?5MpXnJ9R0bYguTrxR28nnu9jh8FIcFVY1QMDaN873wgILsaGDfz/kTi78nVz?=
 =?us-ascii?Q?AUICxsoFgaMS8uWlzgVurX7LeWfFDN8NmkxsEtaRivI8w7VojgBWImErO8D+?=
 =?us-ascii?Q?vcTe4fsIOc/0csyiS5xbpLfs55zU+8S+ydat+Si5pCisqzSTZi/3kSyCiaLR?=
 =?us-ascii?Q?lASksCW5r0b8CORWDCQFwXJPI0EoIlbRJFBaDbO9jGlq47PnXxKKi20wyl2C?=
 =?us-ascii?Q?zbeyKhaS4ep8rbaUdRpkkf3cfoTQd/t3s5elHnYLQSEMjln8PRILunjkPt9K?=
 =?us-ascii?Q?nrQT/Nh1WIHxas5zT1oUxTNRMn3M7xa4NIKPmIyHJ50KTs3UKoE3NmrNHs7u?=
 =?us-ascii?Q?tyHVjfYrVgy2jJj0CF6si0ZaB8r07or6zk+c72MuYM3Jqwd2Go4hCdfEh8+D?=
 =?us-ascii?Q?JleeaZ+IahyHSpsFSdMqfXnXV3/pXeztNSS810uuGUuAr+RqtigqwN+wgAB1?=
 =?us-ascii?Q?CD7Qr1fxJipEpDECWDF18Ciz6g4zKtaLm7X9rl6ihsd8gXmysVMPf7p4HAg0?=
 =?us-ascii?Q?3rmCBezY5XemaHM2wFPTI2egdSm49XDOZKY3ACbH+WCyUkPDJgNoHX/21au4?=
 =?us-ascii?Q?nUn1U50wcAHg8v7V2LQ7LoRZLEKF84GAO7Du2FJWTh5mrIakMfQSoMG/rfaU?=
 =?us-ascii?Q?zmY6Yi+tL6yNhp2Zo/M2u1HMwlPkBwAAIhL66EQfrhn3lPDn/tuPF4PddmAz?=
 =?us-ascii?Q?rZnAechi2rSeINeDMXe4xyv+0E6r7tqxn5JU2TZcxVcP3OqVb8nShR9yWhSq?=
 =?us-ascii?Q?eapfacbh+WLQQ0xN7tz9UoOj7v0Cj+KDrf9jtzwMqq5tWOTM1cSN5YOr/xlJ?=
 =?us-ascii?Q?PzV5wyPkm3FSxXyd0a/9tR8hYR1vStylALuzK8VjCi2ii/RMgAEWBP9ih//o?=
 =?us-ascii?Q?SVkK1kttZPsmXL6p8dfrxAgMLHBeBPOdMS1Ej/nuLzVqPDaPHNyxXAsHU/eG?=
 =?us-ascii?Q?kSeNpmr7lAbB3qxZqvNEk8fLLLkU35FRe7IfjblBfDc78DP0VWgkDiOyncKh?=
 =?us-ascii?Q?FY08LjftetDEw2R2bCWb2IxcYiVB9ncCftrFVlmgWylxn3qmsB3kvHRriTse?=
 =?us-ascii?Q?SDA43MTfWwazOJOYikQ9StKIEwfWxxiO7mqwCBUS1I+e6awV6EzRMr1n03Jw?=
 =?us-ascii?Q?082gDwioS2qEHzeYHPA9spUpsrwLgv2N/5lVliYUW3uwK5iGOEiMz5vvh5+L?=
 =?us-ascii?Q?lPllFAjSDk1C8e82shxsiluTfgu1eF/FKEe3QDKtUukMDeJryqPjB7173IcR?=
 =?us-ascii?Q?xkA/BXEDgYhJ6cpNmo6rU2QuJ3myBg+1bf0ZdsUmydYSkddWRuH75q61pa4g?=
 =?us-ascii?Q?MWN2/69J7c4pQ8yIQ5LxnBunIuadKwaaC0Qs+0fKENg/P9Oh6jewwC2DlSHy?=
 =?us-ascii?Q?BACoEpiTKzN8M8LKSFPI6JC8Md04OrEq8gxPHe7nU7o9J2D/19be0KRqbx7D?=
 =?us-ascii?Q?xmLmksnH2gRMSU2HisfajDp+yrJsG5C9CPx1eVfb+DHVIJDSfdjUWc251hV2?=
 =?us-ascii?Q?3J3l6CGlmxDu10/4rRNlz670causb+Xbr/kHCSqntO4+n0FROw7pj+oHmqgf?=
 =?us-ascii?Q?Aw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8012C7D01477B54E82FB7EC29A44AB46@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f80f46e0-5a39-4e92-542e-08dac0fbb9f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2022 20:07:41.5049
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sSmbRcmfEPnvHXHAdWOiT/8fhpPm65xx3bBfJ24C9C7OMEFcVSZSIDl8y5gpuuMIfNTFVD++knJpyWpXVJDZkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7488
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 07, 2022 at 10:24:40AM -0800, Jakub Kicinski wrote:
> IIRC the skb extensions were initially proposed as a way to handle rare
> exception packets (e.g. first packet of a connection-tracked flow in OvS
> offloads). Also MPTCP but that's also edge / slow path (sorry MPTCP).
>
> Now the usage is spreading and I have to keep fighting to keep them out
> of the datacenter production kernel I co-maintain.
>
> So, yeah, I hate them :)

To be fair, most people see CPU-terminated traffic on a DSA switch
(i.e. what you see in net/dsa/tag_*.c) as slow path which needs no
optimization. It's not that I condone this, but it's factually true.
If it wasn't the case, then out of the drivers I maintain, a control
packet wouldn't be delivered via SPI on SJA1105, and flow control
wouldn't be broken on the CPU port of switches from the Ocelot family.
And more importantly, software bridging between a switchdev and a
non-switchdev port wouldn't be such an oversight for more than 3/4 of
all switch drivers.

Also, I didn't really get *why* you hate them, just that you do.
Seems circular: slow =3D> hate; hate =3D> slow?

I don't think that skb->_skb_refdst is the hallmark of clean or simple
designs either, a pointer and a refcount bit squashed into a single
sk_buff field that is also in a union with 2 other things, and which is
reused in other network layers for purposes that have nothing to do with
L3 routing. Nope, sorry, this is highly optimized design at its finest,
true, but I have no interest in doing mental gymnastics in order to
maintain such a thing, just because some hardware manufacturer thought
that it would be a smart idea to split up device ownership in this way,
and neither build a 'switch with rings' nor a 'switch with tags', but
rather 'a switch with somebody else's rings'. The people who built this
monstrosity should step in and maintain the software architecture that's
a direct consequence of their design choices. Otherwise I'm going to opt
for the simplest thing to maintain that works. It's unfair to not care
about software support for your own hardware enough to study frameworks
beforehand, *and* to complain about performance.

> > > > The latter are more general; AFAIK they can be used between any lay=
er
> > > > and any other layer, like for example between RX and TX in the
> > > > forwarding path.
> > >
> > > You can't be using lower-dev / upper-dev metadata across forwarding,
> > > how would that ever work?
> >
> > What makes metadata dst's preferable to skb extensions?
> >            ~~~~~~~~~~~~                 ~~~~~~~~~~~~~~
> >            former                       latter
> >
> > I said: "The latter [aka skb extensions, not metadata dst's] are more g=
eneral".
> > I did not say that you can use metadata dst's across forwarding, quite
> > the opposite.
>
> No, no, I'm asking how you'd use either. I'm questioning the entire
> flow, not whether either mechanism can be used to fulfill it.

Well, we are probably talking about different things. I said that skb
extensions are a more general concept which *allows* you to pass metadata
from the iif to the oif. Metadata dst's don't. So what is the need for
metadata dst's, if skb extensions can do what those can do, and more.
Not that this use case is particularly relevant to DSA OOB. Just that I
think a reasonable expectation would have been to make skb extensions
more performant, than to introduce a parallel mechanism.

> TBH I mostly have experience on the Tx side, given that on the Rx side
> there is no queuing so the entire abstraction of tag implementation
> being separate is not strictly necessary. But if you find that the Rx
> doesn't work, and you really want the skb extensions - then, well,
> I acquiesce. And hope the Meta prod kernel never needs OOB DSA :)

I would never enable this feature, either. I would love not having to
see it.

> > > > More importantly, what happens if a DSA switch is used together wit=
h a
> > > > SRIOV-capable DSA master which already uses METADATA_HW_PORT_MUX fo=
r
> > > > PF-VF communication? (if I understood the commit message of 3fcece1=
2bc1b
> > > > ("net: store port/representator id in metadata_dst") correctly)
> > >
> > > Let's be clear that the OOB metadata model only works if both upper a=
nd
> > > lower are aware of the metadata. In fact they are pretty tightly boun=
d.
> > > So chances of a mismatch are extremely low and theorizing about them =
is
> > > academic.
> >
> > Legally I'm not allowed to say too much, but let's say I've heard about
> > something which makes the above not theoretical. Anyway, let's assume
> > it's not a concern.
>
> But in that case the same vendor designs both ends, right?

Yes.

> So there should be no conflict between the metadata assigned for reprs
> vs dsa ports.

Can't say more, sorry.

> > > In general, I'm not sure if pretending this is DSA is not an unnecess=
ary
> > > complication which will end up hurting both ends of the equation.
> >
> > This is a valid point. We've refused wacky "not DSA, not switchdev"
> > hardware before:
> > https://lore.kernel.org/netdev/20201125232459.378-1-lukma@denx.de/
> > There's also the option of doing what I did with ocelot/felix: a common
> > switch lib and 2 distinct front-ends, one switchdev and one DSA.
>
> Exactly.
>
> > Not a lot of people seem to be willing to put that effort in, though.
> > The imx28 patch set was eventually abandoned. I though I'd try a
> > different approach this time. Idk, maybe it's a waste of time.
>
> Yeah, it's a balancing act. Please explore the metadata option, I think
> most people jump to the skb extension because they don't know about
> metadata. If you still want skb extension after, I'll look away.

Well, I guess I'm still not really convinced about metadata_dst, you're
still not really convinced about skb extensions, but what we have in
common is that "one switch lib, two front ends" is an alternative worth
exploring as a design that's both clean and efficient? :)=
