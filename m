Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADAB2623DED
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 09:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbiKJIvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 03:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiKJIvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 03:51:47 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2052.outbound.protection.outlook.com [40.107.22.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F3964C5;
        Thu, 10 Nov 2022 00:51:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e5ThLcWVY3JhO+Ua0+wB1QBmO7KrNtNKnYluE6Fg2PBhhuTbu+biOnJc6SSUMfVYOdyLhDl9BDk1Fqj50kFj8nY7dW1q9ryjUBhmlt0snsYccdhf+QwniEhy9iNsrL0vi20ljfJ3prd+P8QhdSJuql4itSVj2ykgdQBwiaVW0PDvrQ74EoXV36M9/Q+xkpcrFXmB2vwUTpklarHIwfAdILlIhC16T5PtVdt7h3IXR9Qzbbp9xohV+PKQouK8OjoLPaMjuBLNzrgXYkSkJ3pSI3MLdPGuMXPAlODerB7f3GEuVnQXbh3vm+kFhVXXBP8JABjUxMrsii1Z6GVfQx0c4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W4iJYHOBtB/4200F+5GNYNN0VShPXkOYdtuppTjdI+g=;
 b=l+RFwId0Z+BxKK3lHvnuhIdmC1+9AFsneZufUd84fHcMVDAxgSSixlZbT5iaN6N3ORbBEbRgd/QVNRQSntbSOAUjZVwDE+gCO/lDXUeBcm7GgONDkeP3L4nGZ2ImWi6Wyq3/wiFwZJvWF6qqYP8AGPn6JnzT54j2l9dHt0mHT2rat1cCi6mC2VDuNif2gZvj6r+S31jU5U05Okz9UvsJbkcWP6xwaAn/DvlLJJE8uJlrND/T6oVgqT7WoldpKNCjv5n4kx+8ND+fekEZaoDuz6YgUeE+G1foLq1PCnG7V8EwTaQHRLjEhqX1HSoog8bZdkajbsUQ8/a/q9tqgHAE9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W4iJYHOBtB/4200F+5GNYNN0VShPXkOYdtuppTjdI+g=;
 b=LUVk4jyeXLRjHKJoKlJAyGW1TM1slmttQjg0vOksZzDs+g/pLiezsBbeoMiOx235H6ikT5M63cJgntFVACqIFpLgGsEB9soVYY6kttwzGtgVFHtex8WCOX0e23IjswcT+S2HrMavXKcnhOQOQlcc+PC6Ilu/vxeC4yzEw5EPWeg=
Received: from AM9PR04MB8506.eurprd04.prod.outlook.com (2603:10a6:20b:431::16)
 by AM8PR04MB7313.eurprd04.prod.outlook.com (2603:10a6:20b:1c5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 08:51:44 +0000
Received: from AM9PR04MB8506.eurprd04.prod.outlook.com
 ([fe80::5ff6:2440:a56:6b45]) by AM9PR04MB8506.eurprd04.prod.outlook.com
 ([fe80::5ff6:2440:a56:6b45%5]) with mapi id 15.20.5791.027; Thu, 10 Nov 2022
 08:51:44 +0000
From:   Jan Petrous <jan.petrous@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Chester Lin <clin@suse.com>,
        =?iso-8859-1?Q?Andreas_F=E4rber?= <afaerber@suse.de>,
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
Thread-Index: AQHY7tOAA/zZjStEYkyi6JcYkhk32q4r3zqAgAHj5ACAAON+gIAIlgXQgAAD14CAAJKUkA==
Date:   Thu, 10 Nov 2022 08:51:43 +0000
Message-ID: <AM9PR04MB8506F52B7E88ED1FE64554A1E2019@AM9PR04MB8506.eurprd04.prod.outlook.com>
References: <20221031101052.14956-1-clin@suse.com>
 <20221031101052.14956-3-clin@suse.com>
 <20221102155515.GA3959603-robh@kernel.org>
 <2a7ebef4-77cc-1c26-ec6d-86db5ee5a94b@suse.de> <Y2Q7KtYkvpRz76tn@lunn.ch>
 <Y2T5/w8CvZH5ZlE2@linux-8mug>
 <AM9PR04MB85066636DE2D99C8F2A9F4CDE23E9@AM9PR04MB8506.eurprd04.prod.outlook.com>
 <Y2wxDc8i4cspaFnx@lunn.ch>
In-Reply-To: <Y2wxDc8i4cspaFnx@lunn.ch>
Accept-Language: cs-CZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8506:EE_|AM8PR04MB7313:EE_
x-ms-office365-filtering-correlation-id: 9916c540-0972-4916-c407-08dac2f8cb08
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4hP4tRDURYkugcQlu1UG1OhubA6DWkToveFKusgDrRbc2j2K0eqQc0i4VJAViwd2DP9wVhaEKx7BILWTjC/MMuy0wD04lrKI0A4/AG5/KxlAinsshV6uoTjH4mHwTkWK+Z1oN4YLJlcv12BXH/AECgzHr3TZ4S86KUanFEU6TvgtPpqD/klPAlFQNmkCRqYpMBBgOVQHzUSB4qSPBmEASZFL9pobt5z4jOhPqD5nuBdgplMTSN4+ypoO15fNKou8rmHpPI6qP6N+fPsmGSSoaFSr8YkPLUDW3xaXx+FMWnlrYZDQuFMsKXOIDdWEBYIGV44yNToO6wfeR/l3VPNGH8a4Rn/bZa187BkTk+E4VsnidLQSA/t9+rwwQrUWMQowcjnVA6AsR50KrpFsH2nkhd8tdTMKx9bmUclqX73jCTO1/+THYeC1VUVa7GwaT2NYjY2GnTNWHyGK6QqXxej4O/FvCaoZgrXBpOjleEknNAxGyMEZCBb4ZKDhn522T6b5y6RCubqQw++x/wZVg7bk9MgCO0MsSUBIpNK6rtjW4QtAF3E0RNQU6+IEhSVYYW8iTXAomc6v6NgGzRgMwQ/Ms/Vtf6Ldd0xBwznPu4y5Yj1A5qSAo3e+WWJ5Uar+o1xZlaet/7RgPxupBxddMYLgm7N9z+EHjV9EH3gAlbTgp92ISCap8ZMKLmkaleM8paLiF1iwHLqchaQyi5ZHj3DBuxNapcLtd1SFrn0GhCVJn/EkeDOnyULIxDRgB2N7aKTLxIleAhV6hU8Xv+6Bg2APsw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8506.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(451199015)(186003)(83380400001)(86362001)(122000001)(38100700002)(38070700005)(2906002)(44832011)(52536014)(41300700001)(5660300002)(7416002)(8936002)(55016003)(478600001)(6506007)(9686003)(55236004)(8676002)(26005)(76116006)(66446008)(66946007)(4326008)(64756008)(66476007)(66556008)(316002)(7696005)(6916009)(71200400001)(54906003)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?kt340XFzflQhINFY0O+tvIuiWumFVycjcRKdIQrcceAJYcLRF8DlskNtsG?=
 =?iso-8859-1?Q?7rHjF4QmQzB0TezVPxSJ4XWld5UEgVHVHXJpml+JLdODvWa3kmz/F+wl5k?=
 =?iso-8859-1?Q?pOmLc6N6zUYSRLffhPaE/R4T6O3XMsKnvr2b2BMnIf1ritS4rv8C6Midbs?=
 =?iso-8859-1?Q?vvu4l1lHPJU7v49yr9xOcGSMD0M8fyPmOc4KuZZqHsWaUyJ3DwDtlwz0+a?=
 =?iso-8859-1?Q?xQU8QBnoYURSiUzdu8bbquN7bw7Xy+SxZ/ruqkEHyt4hP4XL7vpkNQ0G4S?=
 =?iso-8859-1?Q?dT1Hy2reDzMg2bA+LB19RVFYsxnguivEu5x+30DulKscFW0FcziBnkacan?=
 =?iso-8859-1?Q?ERn2r10eogTDMGPhG6SqQYKh1byEuqKdNKwxWJ2zpIxJpix/s5L9jUj4fV?=
 =?iso-8859-1?Q?4FmHUzXNmqQRnEMkfqZX5Zaszt7Or2EpHNmue/7LdVm6plqu10xHYIfim6?=
 =?iso-8859-1?Q?+L9kcSjjYIW1kidT4ST9tkevFMRKr2iT9WLqO4PI19nYo7WGSF8dWLqp0B?=
 =?iso-8859-1?Q?lbhgzD4LUk55AuSocx4GF+Kiq+zYOsimgdxFovfDkcI6xIh5ogvPfwe6d2?=
 =?iso-8859-1?Q?R9OexoLQc9s+J1rBCke+LFGT4lMJJq9CPduZAIOIH5hjqwrCeis/mG0qJ/?=
 =?iso-8859-1?Q?nxhTT/jAo+/jzK2CVg5dmX0hkTlE8QY4KkLRgqtIUFRHhOUhv/h+fLYVR2?=
 =?iso-8859-1?Q?Ckc/S+5A0GirHdtUNrX/MxrpWK68pU7SUUet+6rYFFcEUcAs1LhwScPfD+?=
 =?iso-8859-1?Q?+hAG87b6/yBTDNCIrtJkLiGciGGEn1yKGld6AdL/nBzq1Ewc30zsWRgS2A?=
 =?iso-8859-1?Q?OdUB+hQU/zEH1jEOPXdaeQeLd9+9o+CFf24W8L6McH359SWkLIvpGmC95Y?=
 =?iso-8859-1?Q?xqFme4TBrac0n6yVMB5FFrmLbJoEaPWD+OsvY2kgbU+VNu76BFPWTF8wtJ?=
 =?iso-8859-1?Q?kscCanGpuDedtV1Mi+kWQ6uE0jXKm1PzbEc2biuJMmnsScGYysQrGxfCS5?=
 =?iso-8859-1?Q?evNEkdxw+jaV7Z5F/XoHKyL+m6y6wysf7LStHiSZVXv9ZCpl6KgU8qv4yA?=
 =?iso-8859-1?Q?j3jyDfEoQTIvghSFNWZOJuhRzePA978KdgCJNeCyCWXG9KeyStgCvo/Lbc?=
 =?iso-8859-1?Q?ytJmrEEy1SlQ+4grZIhGde06yjihyc1J0co7Eoqkb/p+tiImA+Ajghjd4r?=
 =?iso-8859-1?Q?KHkDFpGhcDBSht1tQdDw8NmMQySf5DdVoSl5Bb0QcuBK1FGCJVCT34D9YJ?=
 =?iso-8859-1?Q?5RyZZQiQT8Mp2yukF9Gt0Sz4r7SytKjvbcCI2Bb9Qh1+Jf8C/R7Xj3tdCA?=
 =?iso-8859-1?Q?a35+6Fnu6p1zcRQXj5hmVW5dT6TtYagu7rZutkv0bR396lUQbtl1tLmBlx?=
 =?iso-8859-1?Q?/TNyLd1et8F5dnFnqHpQH0Hhcd1iu41BEkqcShReDSt73hkaWlFSAHouQF?=
 =?iso-8859-1?Q?tXqAfSoYmONlrtLwLQEWQUwPgEcefYDdjdSx9qlqfE8wENBAGM5T2KOkqM?=
 =?iso-8859-1?Q?Xo/TwyTYdR01g1FKqal0R8ra3uPjVp32v8nUTsFPdUJskHSMEPaZxZltdP?=
 =?iso-8859-1?Q?XfDcEjlt+rWWI1T7b3pPKZ+GZvi0GyUIpONEDJdeRaTdD0BLoXL8gYI5uO?=
 =?iso-8859-1?Q?YBfX+5QHgNpc5h/mMlxl3Wyb2wIO45kzWK?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8506.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9916c540-0972-4916-c407-08dac2f8cb08
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 08:51:43.9905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3iJYPnn/E+eyVhBiUyDEkwOK1thxPfgUApP5IbLenX/xG9l0ZXY11o8FLMEwkFCsMeQsuMCRYy1ZjR/VhfJyHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7313
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

> > > Here I just focus on GMAC since there are other LAN interfaces that S=
32
> > > family
> > > uses [e.g. PFE]. According to the public GMACSUBSYS ref manual rev2[1=
]
> > > provided
> > > on NXP website, theoretically GMAC can run SGMII in 1000Mbps and
> > > 2500Mbps so I
> > > assume that supporting 1000BASE-X could be achievable. I'm not sure i=
f
> any
> > > S32
> > > board variant might have SFP ports but RJ-45 [1000BASE-T] should be t=
he
> > > major
> > > type used on S32G-EVB and S32G-RDB2.
> > >
> > > @NXP, please feel free to correct me if anything wrong.
> > >
> >
> > NXP eval boards (EVB or RDB) have also 2.5G PHYs, so together with SerD=
es
> > driver we support 100M/1G/2.5G on such copper PHYs.
>=20
> Hi Jan
>=20
> Does the SERDES clock need to change when going between 1000BaseX and
> 2500BaseX?
>=20
> If so, it sounds like Linux not having control of that clock is going
> to limit what can be supported.

No, the SerDes clock remains the same, the change is done internally, witho=
ut
any necessity of clock change intervention by GMAC driver.

/Jan
