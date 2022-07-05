Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A12D567A70
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 00:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbiGEW4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 18:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiGEW4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 18:56:30 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2085.outbound.protection.outlook.com [40.107.20.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278FF10CF;
        Tue,  5 Jul 2022 15:56:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZTTa5XES5ebIa0g5wmGyi+H3R1n0Rs9SKkQRoRpVlcUQACkTRGY0i14C4ZA0FDptCNfnFcPRSgsrNjeQkKtoAfJkZWqn+4t+4vCCxw9artClA1kCm9SdLNissxlM03vYRnS+30CSRa3UUrO0Fum+lzWKbzvLC2NXB4DyupLDQJsYQUAZ9+TDJG6RMW6ehiBGPXi2BsGbi07OudTrAN5V+qoaYNzU2Uw3URx3hLTghdJDMXQIlAZt0AuFU9/TI4m+rlntx3hM4fU9Y23TkH/lEKjcDICko2z8yQN1hI2fLhzHuYRPRMWjKLr3LoH02RMaBi2O/PAHx+oP0/4dyEzyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aBDQdhaVRJ5OMCq8BuL2RzXXCrsrgKWgOuhcXv8VfZc=;
 b=QSWqqIXKvYvn/WgrZhr6RaqK6jlbWQO4f4Z/uAvq1qzk2/UkAGP8XWpS/z/Z+I4UC0VwhZ9GlonFpAOSWHTDgaFmnOzfRl8afnrlBzUdCviQyyPIwgSszsBlVg2G3r6l8fsnihRTie2VrYnXhx6/u+AkrUPxJsNtWPatjnzHFRmV4a096L9hE16C60mqnudJj/sZRyorIJNFvTykv8Y6Vi3/xbVr+VkIsbYqMC0chleAnA+C/zU1P2EpKyV1Y3LtN6eG1SVeefIIXO577n+RxHC6OQ7+bABaQnfo8mXLnL4EMX2jqXVHxjurEYnqobbSZdjl2uiXHGebBCRbPp7T+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aBDQdhaVRJ5OMCq8BuL2RzXXCrsrgKWgOuhcXv8VfZc=;
 b=dAZtEkib8rWu0VOGGmxOtCfXEpoG/Sf51F+PiVldxURE6KM2nDVyN7MCb0xNaVtE2ZUkc1ozM1SRgv/Nf/LcFhZnW+QAbqszoO3aaVxh1QPCY/zNCN8zPNuStyMoqzbt7zMlo2FZ0+rSDwMeSrp+1NMGt+noiJ7ZmMEW2o9f5ic=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU0PR04MB9251.eurprd04.prod.outlook.com (2603:10a6:10:352::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Tue, 5 Jul
 2022 22:56:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 22:56:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     Rob Herring <robh@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [PATCH v12 net-next 0/9] add support for VSC7512 control over SPI
Thread-Topic: [PATCH v12 net-next 0/9] add support for VSC7512 control over
 SPI
Thread-Index: AQHYjYB07kRKEY0yCEKC0I+GdNLs2q1wP2sAgAABpYCAABpXAIAADn+A
Date:   Tue, 5 Jul 2022 22:56:26 +0000
Message-ID: <20220705225625.k42jjsdusf7ivaot@skbuf>
References: <20220701192609.3970317-1-colin.foster@in-advantage.com>
 <20220705202422.GA2546662-robh@kernel.org> <20220705203015.GA2830056@euler>
 <20220705220432.4mgtqeuu3civvn5l@skbuf>
In-Reply-To: <20220705220432.4mgtqeuu3civvn5l@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2eaaca8d-f2af-43f4-7055-08da5ed99785
x-ms-traffictypediagnostic: DU0PR04MB9251:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lrkJvAjbxzCA7i6iMwbsjO5D6vGNeSsmuB8gerzYK/JkCJn60Ejjzr16hItOinMn0XAnmjMnsrSBlW+R39+L5PZQBVCrEMoVckfVQ6dMO203kT1ud/sDqbAUTkIPoRpMFOlaffgy7E+Ss3gDdE79H/joyrpsOjs7iYwkDtQ/4srGRcXO+KU5vpoBLr/cbdKHIX9EuILvczkD10aYBw2prB8bDEyPueQMAxB+sgXodD8u0bFPDpJXE+NanRxK/XwHT9rLo95BISnV/AJL60OZ9EUI+Bgfdnq8q8nvRwnUsupLFP1SVykn4UkAdKCAestMEBBxA8xVB/GluHPY0pFao5o23xRKKhIONu7naeIBwWWgUHmd4/nbYO2rG5vOMpAbFD5wXejNS3T84CIz8SNyOusfJQ4DVaSk9vu7jVBYKnQ2PC+6ragG5kdSSHK43FRbC2kne+ro1kYn/d091B2OJYNZJMwHX3sYC1jaf/rtqLeUVW3BNN6Y5Ov7CMsCBjf9u2HbDCMBJM1/sPm+VgNWjJNmxN1l2YSow17fz3Oqayq9LbHKzraWDGsYzjUdVzkQ0gYkzh4oItOkUgvXG8nMZ+2F/yJ76eDf7m1QMFwYr4FzhtI6r8zc2EcOfVeNczQquAJ5H+T9zRtLpppQNgnRh8z3g7cfIpzfwh81eTQsuyomiIjFIAwrsg6gFVrX2lvST/eu/YToQIknaN7Ej7EK4WHJS/V8ABpIOFxGbwifAl3/9ep8dxgrXFDWEimNIYxu8dX3eyPpeGq9QxvNHYXzbB6jukB78oXgoUUVQ7Z1mm5HK2Nnxbb3Rrzl3+Rltn8f
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(44832011)(478600001)(7416002)(5660300002)(54906003)(122000001)(76116006)(6916009)(8936002)(38070700005)(316002)(66946007)(66446008)(86362001)(66556008)(91956017)(8676002)(6486002)(71200400001)(4326008)(66476007)(33716001)(1076003)(9686003)(6512007)(26005)(186003)(41300700001)(38100700002)(6506007)(2906002)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?J+50mmFGmo1IvkedvcBAeGDgCgqEF5wDkYYFtzDmLBRU63b1wy7Vw2krvlQq?=
 =?us-ascii?Q?/zaSaGvAYn76SptC6O63Uludfetwn4FpY+oJGFaiIe1q0XUSZ55ZjQ3Gzgm3?=
 =?us-ascii?Q?GIibsZQZVqZDdFS4WpVMj4bFs1g5MIDaEmxsdANiE6rS4QOWZJYYthnkosT9?=
 =?us-ascii?Q?psf5ZURhkBGvDn3N996t9deF5YdmPH93XueKHJYySQ7yOM9SOEXwj4JGvBgN?=
 =?us-ascii?Q?h/J1Bx/uLbLECm22R9KvLpevx3u7Px2uwdiRcr4sTat5QIu29AfycaJ4ajmk?=
 =?us-ascii?Q?6Au2ZsN2NHNRWGjUnjzzlH5fG5ppZ/wybhRnRlAkN/a2HQAAsR1pN1utG00k?=
 =?us-ascii?Q?PVsYsV7pgRlCTj6U2e2jjRXzljPVhHKDGFrG6/yV/wfZXiuIV8gMSbPxHdtO?=
 =?us-ascii?Q?qoxJrXMGIhElH4dZ2EPUvh2pJSPJLqNX8xR9xh1BtSuVK0mG6y5UgFC5Ds8r?=
 =?us-ascii?Q?YM7nw0x+uA6rL2Y0Vl+egkmB369TsZmIeXvC2VM3QRt7Q4Pi9824srbwoo6c?=
 =?us-ascii?Q?nEvEWSObcm8BYdDDaFHD5VloefblK9AjX0srxcSDF6tv4Kf69z9Zqg0Ntd0l?=
 =?us-ascii?Q?A0CADEt/hy5AKtttkOc6BPiT+UD3rTCo8roCGYYNGoxFEPxBC4b7lSdVyIYS?=
 =?us-ascii?Q?RxvcG9ysulvda1pGSRAW9qpkYBk1oL0n2MYY8/vNPekHBMGAE3Tj6dGyisuF?=
 =?us-ascii?Q?02p+AYlA3M1KobF6GNJPBx6Zt5q6rRa2rYlIepYzueZgNqyN8AoHtyEulnek?=
 =?us-ascii?Q?a/i8OWstmN7y9FGx0AZ+eiWvXsC0G2Wzvc5LxeFDeX/IW4g64AMPamfy3AHC?=
 =?us-ascii?Q?bVJVVVdigm1xLn4D8pk8iIN3/wDeY9kHcNh8l1bkzrDKHIPGZxLjqYHQIzaz?=
 =?us-ascii?Q?jutrvKv/4uIkGIhpgbyX0pzorB7TLX0QRkZ7gm1LrdFbLcGRqibws7mBHs2x?=
 =?us-ascii?Q?glVuW2aOx399Ep0C/XUpnmbYkRnFO87DVVCZ22fcBdrGPT8xW7DUoCPzYvNa?=
 =?us-ascii?Q?I6XuWfXOMfPBEhQawk1WftlBaH4XbzKf599ek6iItBeG+AGKk99hJlGWd2Vd?=
 =?us-ascii?Q?91iNMN5lvld2WQwchiR6+JRfkn70zGc5BnpUQNc6wohAbQ5Ykwz4UxrEup4q?=
 =?us-ascii?Q?J+cGp52X2xyM71iWnfERfP4NtX8PB+/jjGLjdSygH6HyU6iyB58q8zAzY9hZ?=
 =?us-ascii?Q?qiYQCxbjYOJ+F9v/G/Hh/iwNsH5Q7QJneg2dvE9MEeiTwkrSbqORoRWP9Ci6?=
 =?us-ascii?Q?2NUt3WNxJ3/W35XHPKf/D20r1Dtxe4hfcR3Ymwk2J9Z0O2kuTS+YexNUVJ5f?=
 =?us-ascii?Q?LpLIuNVzbqkOf8lNRCc3QsenU03ZnIISmZKbhkWTTNLLbD8bwEa8ytYwJSm5?=
 =?us-ascii?Q?2yVBOEQaDt8d7LWJAunHC6I9LikDgBpC4lmHya0V9j72PP8/RXo221a86/sZ?=
 =?us-ascii?Q?C/f17nMt94ZqIIFtdEceQwU4Amf+MYQFF91h9KWuxE046LK8MnStyN1j+TT2?=
 =?us-ascii?Q?sc2GkH5a9vLOYnxDDGOwYySI85ohwV14v9ouFEQdkyl7lCT7Oq6VT8u8qwKQ?=
 =?us-ascii?Q?UVnpXo+qpdWulg77Nn7cbPyIed1U1DOlyUO3t3KEdOviNiCLbPwp2/8vH1lQ?=
 =?us-ascii?Q?Pw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1522159ECFF19D4791B408923E3CD2AD@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eaaca8d-f2af-43f4-7055-08da5ed99785
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 22:56:26.8896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4p0b6yqPW88RWMZHqtlQ+5nUtxNnn7tQ3ndurbWcK39hNYYPDaEMmLlpKq3GUDYJbmpBO0YNBM9nOzUAm6vCZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9251
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 06, 2022 at 01:04:32AM +0300, Vladimir Oltean wrote:
> You got some feedback at v11 (I believe) from Jakub about reposting too
> soon. The phrasing was relatively rude and I'm not sure that you got the
> central idea right. Large patch sets are generally less welcome when
> submitted back to back compared to small ones, but they still need to be
> posted frequent enough to not lose reviewers' attention. And small
> fixups to fix a build as module are not going to make a huge difference
> when reviewing, so it's best not to dig your own grave by gratuitously
> bumping the version number just for a compilation fix. Again, replying
> to your own patch saying "X was supposed to be Y, otherwise please go on
> reviewing", may help.

I hope I'm not coming off as a know-it-all by saying this, and I didn't
intend to make you feel bad. Ask me how do I know, and the answer will
be by making the same mistakes, of course.

Not sure if he's already on your radar, but you can watch and analyze
the patches submitted by Russell King. For example the recent patch set
for making phylink accept DSA CPU port OF nodes with no fixed-link or
phy-handle. Perfect timing in resubmitting a new series when one was
due, even when the previous one got no feedback whatsoever (which seems
to be the hardest situation to deal with). You need to be able to take
decisions even when you're doing so on your own, and much of that comes
with experience.=
