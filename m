Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237316236D4
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 23:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbiKIWzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 17:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiKIWzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 17:55:14 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150053.outbound.protection.outlook.com [40.107.15.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69171D335;
        Wed,  9 Nov 2022 14:55:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UDrlRaOz5NmDZ+x1G9O6CNdfzBINumifHNJ7dqjsSKeLo5PSMDOsGj15aoat6pKstXCDZxlqtkO5btxEH9wNX9UTS3ggZ+PUHUhKv4s+Heqz3qk9iIpYNC5b3GI3JIqy6D1OkLrz36mV1LgPLbwcpWERwxQGEiqIT2OFQt43VA+I/7W7o2f7D7enRNYzekbwin5fnsA6o27byA8Q1VOr1UmuYx5ZkSwc9m8EeZQEL9o6YFV9f3tn+QZjvLMHHsMIJrWhfw1gJxBy9aZS/dMwxOVQi7gYWkieAB+Wyry24RxcqGiw3bJexEQICMwxupKM/Rxb9aJJ6q9VuRAZgAQmiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6EwhJs81x5WwtMtZqUgHRG8U9C82OTOl+h5OZ065Gng=;
 b=DYgofbm4l3pZW31j5U8xNR3P4FR/yrymhKnJYyMQGEZkBGTdVuTE37oo1lwpHNdsOHMlxy1GbK9rzkBjJAaZCqCNrSYHYrtq10k8IJwcev4a/RSvDLMksPEqw8PuYkZXSslKzLyXFCNyVXQngI449sVzhipKykBagZuieEpkHg/cmbC3lYmK5MWk65J1pnKLLx1xbqqpZapkrQl6UnVR7xJC46vHpu7NlShe45s3AMXlvEmyngtR6lNlK8kOTT6te5VHTVA7/65ZolMqQabBN4hOjfaSegfzhd5N0j2l3635J7/hvdwvdZ/f6zRPb8P0l92ZVk0eRUahgHoUINqkZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6EwhJs81x5WwtMtZqUgHRG8U9C82OTOl+h5OZ065Gng=;
 b=HD4Jao/c48I296XLBvJlCUbpQ0V3q3pJCyGCLn/tAZdSq6v092LlOEOfoUxbuadR2cQW88SHrsQRa4R4FyBeFVEFU7hOPnzfnDUM+xmA48noaJHEQCJtVSFf966rhgZaUmDUI+qo+q9gdrXdmTr/0N82TalLTNyjfN7W9cXBpUg=
Received: from AM9PR04MB8506.eurprd04.prod.outlook.com (2603:10a6:20b:431::16)
 by PAXPR04MB9518.eurprd04.prod.outlook.com (2603:10a6:102:22d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.24; Wed, 9 Nov
 2022 22:55:11 +0000
Received: from AM9PR04MB8506.eurprd04.prod.outlook.com
 ([fe80::5ff6:2440:a56:6b45]) by AM9PR04MB8506.eurprd04.prod.outlook.com
 ([fe80::5ff6:2440:a56:6b45%5]) with mapi id 15.20.5791.027; Wed, 9 Nov 2022
 22:55:11 +0000
From:   Jan Petrous <jan.petrous@nxp.com>
To:     Chester Lin <clin@suse.com>, Andrew Lunn <andrew@lunn.ch>
CC:     =?iso-8859-1?Q?Andreas_F=E4rber?= <afaerber@suse.de>,
        Rob Herring <robh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-S32 <S32@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Matthias Brugger <mbrugger@suse.com>
Subject: RE: [EXT] Re: [PATCH 2/5] dt-bindings: net: add schema for NXP S32CC
 dwmac glue driver
Thread-Topic: [EXT] Re: [PATCH 2/5] dt-bindings: net: add schema for NXP S32CC
 dwmac glue driver
Thread-Index: AQHY7tOAA/zZjStEYkyi6JcYkhk32q4r3zqAgAHj5ACAAON+gIAIlgXQ
Date:   Wed, 9 Nov 2022 22:55:11 +0000
Message-ID: <AM9PR04MB85066636DE2D99C8F2A9F4CDE23E9@AM9PR04MB8506.eurprd04.prod.outlook.com>
References: <20221031101052.14956-1-clin@suse.com>
 <20221031101052.14956-3-clin@suse.com>
 <20221102155515.GA3959603-robh@kernel.org>
 <2a7ebef4-77cc-1c26-ec6d-86db5ee5a94b@suse.de> <Y2Q7KtYkvpRz76tn@lunn.ch>
 <Y2T5/w8CvZH5ZlE2@linux-8mug>
In-Reply-To: <Y2T5/w8CvZH5ZlE2@linux-8mug>
Accept-Language: cs-CZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8506:EE_|PAXPR04MB9518:EE_
x-ms-office365-filtering-correlation-id: c53369fe-0881-4637-008e-08dac2a574fe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KOjCUU5NR5HBBlY1EaeTEDwI6RZSfzRixLhuO2dwZO4G/aLI10at0ekXKBXaDr6KeTsLKIrSJpYKvHVJUHc3NKE3eqZlbGSsc+JrIKVh30lHmJiHRA5QqTyMIYbh55ZSIDaHKawL5hvb3odvhhvCdt6xq/zYSPhwMLL+u72OH21zFwqOxTCJP5dNJuQc7A2QkFkCohVssqFrbwIRsLW7K6bfx9xShQWHXZzBNLfHFk/MRjPPPtHY4/IlbIsK8wAALU1AzzU5xSr7vSn1OtIlWEZXO0PGBisO3PByQwrl62e2OGq5xVwG0wEsjNUWG7t2SPhgyx2CeSnfawB87FIinWHXWAGGtOfrSS3VcrxwH+opdmtKVzgq4KrJiTDC0EMM0eWEjINRP0eHTauFmhJU8UmdAWlM+AoT3JlSDBxkiMwOnFQkFD3K3urIryaQ/IBkOhd97XQkqASomR8EYREPUtpE6/A1AesAxlwF0Xzpycy9sDLBk1JCy9Hk/q4NYPJe9URWA87p7z3SgtLACTFIvSOoyhIs+IvFFnA80RVi4bzZ6Qx5zudtvCi+KKszeFYT49TpTRhhRNSI3KwFJD8X1D2faMJwV2G7TmWyGG43z3zyeUKf0G+BNFgxEuJRRzoI8EQ+aXzyCBvyONCZ7K9dYEN28pd1VjxwvxASIoOdw2bBFoyHJbNDuD6VTbYsAVYZRXGWE3pb9uI5zmLwisR+/KbBvTflY0iLIPFbkzDDjbx3aK34pc1N1RvzKn4hMatD6IidNITmlrWCew3/ebNgrg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8506.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(396003)(376002)(346002)(136003)(451199015)(71200400001)(76116006)(478600001)(316002)(7696005)(8936002)(2906002)(41300700001)(54906003)(86362001)(186003)(26005)(33656002)(6506007)(38100700002)(110136005)(9686003)(38070700005)(8676002)(83380400001)(55016003)(4326008)(7416002)(5660300002)(66446008)(66556008)(64756008)(44832011)(66946007)(122000001)(52536014)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?sBP9qXOIvcoJSinozj/YUUN2oNOd+M+ckuY6/62WPivh3/65bP6JfO5dme?=
 =?iso-8859-1?Q?Z/f2FBeCzUEiJ0rvvhAA8Eh0S5h5gM5cFiGF22aPPIYCh18wvg2naFk7G5?=
 =?iso-8859-1?Q?Zr+kA476xxkNbiYeg/eWJOznjwgMPQXt4vdurwBDMo77PB2D/Jy46kac7h?=
 =?iso-8859-1?Q?In0Cr4Rn6Dz44B+7vY3O6ZIfjf0e9ljcZMEPuRkBypBoqH5J2MRYTOgtOG?=
 =?iso-8859-1?Q?ff/gbSSh+yqR2k/T2PnS5Cl7Pci8VWk06IOHXJMttoxqfoIUz6M+7S0Z3Z?=
 =?iso-8859-1?Q?g79BTOArpNUIGAyrS6Iy9sVmIyTWC9UVQ+C3cKn4UYmAmM47MFcDcTSJnp?=
 =?iso-8859-1?Q?0UN1vdXQUyVz0w0tb93DL0GRAo47M7v06PtaFxwWmnpERR4qe6d3PyCvBz?=
 =?iso-8859-1?Q?j6KS3zyWm3poVBabMgO3oowxzv/I3GJuS/A7gFNLngt/mAjdDcLK15v8wF?=
 =?iso-8859-1?Q?cE9ZvMcDWddTkKVIgWVZCA+5XD7vyuQ6EiD9EFY4meZolMlqfodTsxQGzq?=
 =?iso-8859-1?Q?q1KY8axEzHFLidZb/1kWG3twzzHDFChF8UvtUs0+VXlBAbFqkImHUE9wdz?=
 =?iso-8859-1?Q?9q45ddhwFSz0FcgNcQmz1WL+UvJToBNEZiZRzdKdT8KNNhmqAClw8J87vt?=
 =?iso-8859-1?Q?5CrGeXKiLumyVVqaDfbSbpL0rhLZyr8zzZXfz3TRi5MZyKL1B20/1TG4Oq?=
 =?iso-8859-1?Q?2rTJ0Xf7SUUWMMRTRGuMLvC0SAXSUGXVz8OCjdrOXgAkNfdW7uac85fkVj?=
 =?iso-8859-1?Q?FO6HvkmptC9QrkoNS3VaTuJUgoamxbKtJ2cQLejBJWbl8rdUARARSiV1vn?=
 =?iso-8859-1?Q?UNerDkZ/3KtfwLPPYEzRFcFHoKGHIh5/eL67+TNjr0qdtYGMgDHEOdywKY?=
 =?iso-8859-1?Q?IEqz6DbGGhetkxyWgwEcx+nENMiIxF4xJny6oewROePXC5wVlIGNciz8JY?=
 =?iso-8859-1?Q?R93F0k6qpUCQUEYehXaNwjr3PZV43zQ2qVK0I2+myd0xuJV0xMWNXmYrdU?=
 =?iso-8859-1?Q?8Hj1qfnj/kelILlfVw6AHHierjI2PVXW3l6PCaq7zeGX6J+MYNeB0Owf07?=
 =?iso-8859-1?Q?BrbCHqRp/med9zFcNXRZmK2AG4RrMuLpNGuAmg0+pEiBlQgUD4d09QXwNK?=
 =?iso-8859-1?Q?949YJGqHNMc+DRKUb96EOV5LIZCjwdxbOHnHPJ43bgR30EhFBCfSsMCaSq?=
 =?iso-8859-1?Q?H0d8BPjx9HNKciNLUr7gVQbwdQJoT/Cqpc83a+IQcR7E8tUX8d5/+6Vpkj?=
 =?iso-8859-1?Q?t4rcOxrQNIQgqPFmfiy+NV3u0NkCF9+g6qCLVg2p8eM8lMwryZD5vfe3Ca?=
 =?iso-8859-1?Q?lzFWF3LNzIKTrMvIFKr3ETkUc6BmBjfQ8EAxhfYonga7mqZ4/oeqdXfq04?=
 =?iso-8859-1?Q?Gsr7uVSuU43rb9sfkcGVh3ZL/R1G92n/ObLn/k8BtQkkotDmulvgivH+is?=
 =?iso-8859-1?Q?c+yZDorUC6BFzJ9sSfbmEp3uJlW3iUO/N91oN4rFyypyd7WgayXiundoso?=
 =?iso-8859-1?Q?IkrhHDIs7apPZO+2C0vln3xtgAFIEx5fTqbQ2aRRm6zgQtffgMkuQBMkZy?=
 =?iso-8859-1?Q?tGrqZ5nh93mtIaM3GMrSSq3frqoYxQPppjZCJXJNN3dTBWf2qP7hEztNpC?=
 =?iso-8859-1?Q?OrrRWW7l5D5My2os0osAjcwY+QOscGg7Ub?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8506.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c53369fe-0881-4637-008e-08dac2a574fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2022 22:55:11.4073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m/jsQr8jTxHaVgJA3nCa4kPGu37uUmDgkoDClNCy0vZKTOhDuKmqC6KKtvLBbMY/vKMTCYP5lRoLodM66tR97w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9518
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chester,
=20
> Hi Andrew and Andreas,
>=20
> On Thu, Nov 03, 2022 at 11:05:30PM +0100, Andrew Lunn wrote:
> > > > > +      - description: Main GMAC clock
> > > > > +      - description: Peripheral registers clock
> > > > > +      - description: Transmit SGMII clock
> > > > > +      - description: Transmit RGMII clock
> > > > > +      - description: Transmit RMII clock
> > > > > +      - description: Transmit MII clock
> > > > > +      - description: Receive SGMII clock
> > > > > +      - description: Receive RGMII clock
> > > > > +      - description: Receive RMII clock
> > > > > +      - description: Receive MII clock
> > > > > +      - description:
> > > > > +          PTP reference clock. This clock is used for programmin=
g the
> > > > > +          Timestamp Addend Register. If not passed then the syst=
em
> > > > > +          clock will be used.
> >
> > > Not clear to me has been whether the PHY mode can be switched at
> runtime
> > > (like DPAA2 on Layerscape allows for SFPs) or whether this is fixed b=
y
> board
> > > design.
> >
> > Does the hardware support 1000BaseX? Often the hardware implementing
> > SGMII can also do 1000BaseX, since SGMII is an extended/hacked up
> > 1000BaseX.
> >
> > If you have an SFP connected to the SERDES, a fibre module will want
> > 1000BaseX and a copper module will want SGMII. phylink will tell you
> > what phy-mode you need to use depending on what module is in the
> > socket. This however might be a mute point, since both of these are
> > probably using the SGMII clocks.
> >
> > Of the other MII modes listed, it is very unlikely a runtime swap will
> > occur.
> >
> >       Andrew
>=20
> Here I just focus on GMAC since there are other LAN interfaces that S32
> family
> uses [e.g. PFE]. According to the public GMACSUBSYS ref manual rev2[1]
> provided
> on NXP website, theoretically GMAC can run SGMII in 1000Mbps and
> 2500Mbps so I
> assume that supporting 1000BASE-X could be achievable. I'm not sure if an=
y
> S32
> board variant might have SFP ports but RJ-45 [1000BASE-T] should be the
> major
> type used on S32G-EVB and S32G-RDB2.
>=20
> @NXP, please feel free to correct me if anything wrong.
>=20

NXP eval boards (EVB or RDB) have also 2.5G PHYs, so together with SerDes
driver we support 100M/1G/2.5G on such copper PHYs.=20

/Jan

--
NXP Czechia, AP Ethernet

