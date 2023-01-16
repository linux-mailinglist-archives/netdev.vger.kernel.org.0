Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28ECF66B94D
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 09:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbjAPIvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 03:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232358AbjAPIvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 03:51:48 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2044.outbound.protection.outlook.com [40.107.6.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D144013522;
        Mon, 16 Jan 2023 00:51:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gEjOonEWCoJIslvL/bGbUjBxSPlJglwYBQpHAsFC9rR5R81uZbZC73kIVkXBoqkE/LEkLoJoJZtNTJ0x8DrypMj8rjrwDWk34vEi7RP1fEuQx2068Ncg/VSi8TqxeKAX6ZKk86gFg/sqNf6dIsK0Vqr0BOedzZCeZ5hKxdNlzrhpB6gCcqtGE+5Rj7CnNTvkcUL/yDzuCRzN5IvZAzZdn6KcE+QkFO7jhIPaceLAU7sLK5bWpHpZrtveA84OddymG4zDXaLR9LDyh9lOU2gQRDwpT7BYI+0vCrzhflQYtOXvhxn3PzSpSA93mgndItOi+3g8x6XLSb0KWv+z0A1PCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qCD1vI92AGTnpunwzG/mlQ4kLBplv7O+BImZEGFQk20=;
 b=XQVwp4CNwC4PTSYcYrgX8qiUS8yBvUG2VVhvLTKpYnJDeKxcXTkREBk+K/Y/mlP/3+xnxhLC2/KUZHMSbWK5qEOWKFsP818pjmH5dR7v+0tT2PGiUC7BrztaFzDVrlWFzFhundqWW/s6sUSlpnhfDwZ9tvpLMXad14o4DWvephHkkCrUz4XXmi0WaUmUsxaiqxrfBitbhsAqq20f85yQmkNX9OV5u1lhLm/YM24fkEHva3UxtvBVNbczCvbg1QcULaB/41VsseylOnQZr+qRF1lqr0coNVZRn/33IpsJ0+XgvD3VKKpjB4kgg9P9uUILI24X1eU8pVOpXgUBUrvqXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qCD1vI92AGTnpunwzG/mlQ4kLBplv7O+BImZEGFQk20=;
 b=SSstsWQyFb8sHN1hC0SSiAjMAtC9sMJGyA3p3OtuzB8poWBv3T/lz4uJaXTHnZoH2ni9eVZLV0nZMV4etkwOHKMUmirDekYKA5XdklDRO+ePhO/6Rr3bgjOa+Eg7RO8Eq9raTHtY4pYy4vHDGsjxFN6uuVMFQvZhkqTfppA/O1ektD2nsyy5Q8IOzN+EcXuL8OFcwwz2L54Ah1YaxSrbbur55KUUxwOkqRrTZItAYHqvfG0qeswlYszMe7PRyq3Ici9Wc/jaT2U9c6udFlHKS/r8WwLpx0RM23tkUQKc90ssXb5nAs6GNCJ1ClIdLLoY2HgTHQxDIQJlFQ242/cg+Q==
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by AS8PR08MB9017.eurprd08.prod.outlook.com (2603:10a6:20b:5b1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Mon, 16 Jan
 2023 08:51:44 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::4e5b:51c8:1237:1fee%5]) with mapi id 15.20.6002.012; Mon, 16 Jan 2023
 08:51:44 +0000
From:   Pierluigi Passaro <pierluigi.p@variscite.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Pierluigi Passaro <pierluigi.passaro@gmail.com>
CC:     "wei.fang@nxp.com" <wei.fang@nxp.com>,
        "shenwei.wang@nxp.com" <shenwei.wang@nxp.com>,
        "xiaoning.wang@nxp.com" <xiaoning.wang@nxp.com>,
        "linux-imx@nxp.com" <linux-imx@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Matityahu <eran.m@variscite.com>,
        Nate Drude <Nate.D@variscite.com>,
        Francesco Ferraro <francesco.f@variscite.com>
Subject: Re: [PATCH v2] net: fec: manage corner deferred probe condition
Thread-Topic: [PATCH v2] net: fec: manage corner deferred probe condition
Thread-Index: AQHZKSmr1PIgZgy/I0G8u4g9Yr5d7K6gBiKAgAAHoYCAABs7gIAAlBIc
Date:   Mon, 16 Jan 2023 08:51:44 +0000
Message-ID: <AM6PR08MB43761CFA825A9B4A2E68D29EFFC19@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20230115213804.26650-1-pierluigi.p@variscite.com>
 <Y8R2kQMwgdgE6Qlp@lunn.ch>
 <CAJ=UCjXvcpV9gAfXv8An-pp=CK8J=sGE_adAoKeNFG1C-sMgJA@mail.gmail.com>
 <Y8STz5eOoSPfkMbU@lunn.ch>
In-Reply-To: <Y8STz5eOoSPfkMbU@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR08MB4376:EE_|AS8PR08MB9017:EE_
x-ms-office365-filtering-correlation-id: b5066749-ad6a-4280-4823-08daf79ee50b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eOBkfVi3rQPpRN9uIGdf2Jqn+7iqx0asNc9Yj4mognIObDtA3RzBvvAgZRqbFmWD9YSeFm2QaEjBRmK0bmcwo1Gf1XFggzRdUaKoB7Tqek6+2+4O9A1MmSvxWgkrE55/GYIwUfK8OohkqMqdU9JTPstz82SByEwHiB1vHt29mGSTYNovpjKlOPXyqysvFj4A8Bwzo3Kd+mADf8UCprt7anOsBQp763bmO6lXpQkyRIGu8v9BL1pmyd/oV023hgaOCiFYb+hAFzUT55/y9ehydjUtG7z5Jz+4RPepHF4wlKWlEi/Abb3JVB35P6cQvbi/SSWE4YLTrahyvI5uRtuesTL9Loftn5YSNvRkLJDfTcKZ0NIQJ7HgrtflsvLyjXL0tz8GeExYPUgMrErBSnDH3q2BDWCwqEFPNhvDee4+rJ9EtUiKmRH31BBgJA5Hei3S9JWT7gkUujQ8+ymHkAFP3il/xwzUU1j+mOVKHsxEtZvYa6K0lyLirB2100a68zDY8Nq2QslwfDHWr0vYQ8upRJyaYI+MoFtik/bH4gJE/TU7UslDp5EcXoZbuZuYM8iVydBMPw3howV7VxrYBcpFcI7geUNRShoPhZdHbPRXEMBR1/R15M7fkOPEOGkSaiszvY4/WGfxXF8C6ZhyXxz4+bCLVUKb4j3Q2uhxb/wTwRrxKGsLTPoryzd2TSuOCgi5mZfyPmmMiXPIZLQzkWPOqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39840400004)(136003)(376002)(346002)(396003)(366004)(451199015)(316002)(38100700002)(122000001)(53546011)(83380400001)(86362001)(55016003)(52536014)(91956017)(7416002)(5660300002)(41300700001)(66476007)(66946007)(8676002)(4326008)(66446008)(64756008)(76116006)(66556008)(2906002)(107886003)(6506007)(8936002)(9686003)(38070700005)(26005)(186003)(478600001)(7696005)(71200400001)(110136005)(54906003)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?6vpqVQBk2kpGawaKY9K6VIqfD8MqwQws9+Zg81KBVgncm7yO73JfQxEJ2F?=
 =?iso-8859-1?Q?Ku4gD7aafAB66KgrWe/xiYOucR574tNvg0PZCTpLFFheCimq4ri5IziCKp?=
 =?iso-8859-1?Q?tqjE3SOPPELaJFhRZB2VbGrLRDkNhlb7NPctG8VKdxndHFgkpQFrk5PcSY?=
 =?iso-8859-1?Q?RCsg+X4DbGCMzqohCSk5UeMRWhhiA42KRU3LeDnKgFPxWgGBzQllDfycRW?=
 =?iso-8859-1?Q?yFyg+DOLWLjVpAHE3g4hTcsHwGPf6DBBjpQO/hAKBk7gLfeFzZeV+CBYRU?=
 =?iso-8859-1?Q?XOD1dpNtmHdpze9yLXipU9zbl1GtcpQu6ngL5fijwsF8zPZhRyk6OopcvX?=
 =?iso-8859-1?Q?RS/u4e7AfSsx/b4rgISL3uhB/DqwhSNysPQxPcqoEVX6yxG+fh8/Dv2u1b?=
 =?iso-8859-1?Q?/+KdTX/UcYcrBQ/mj+qTCDTbm72boT1WP1LPPATVGnbXr6beuMdFydFGzk?=
 =?iso-8859-1?Q?NQhT03MHlPbMW7LP0QCV0ed2PZi+JwEnTu2C9iBX+trvZ5XEIuarIGErwt?=
 =?iso-8859-1?Q?IVHy5QJAOrCLk/DkQaOTEnUsN+yLpfcFWAewgsQFFFCXNitdh7U3uA8tNP?=
 =?iso-8859-1?Q?gsoeO9p+z4RoGb4pKTpMU8Erp53eUng9OiStCfoKBD1gpZwxMKdLF4LATB?=
 =?iso-8859-1?Q?qWq5JKlPNiTWXfFJqVIoEBcvGevmKhtSWD9BNwa8GjG9u1R7y6WviBeFnh?=
 =?iso-8859-1?Q?R8KprykKXGUthyhdipnu6+NH4mpHqoWwKUW0amsrok+BjOEqSymCiJPwC2?=
 =?iso-8859-1?Q?HPXk5SjSlQvuwPY7MzsbaeR8vJwqPcfxH/SItxg6u5EDw/DjrFTpEsOMtN?=
 =?iso-8859-1?Q?cP2ahuBNTXTSLOOAUTOqFriXRNss/9NPhRV/sKPbRMReC54LKQny5IF2RM?=
 =?iso-8859-1?Q?a57NK66NFcsfJTvAu2AjNhK2K5WBNSzE+AOWG8aTAY8jDBXcG/Ccl8z9Z0?=
 =?iso-8859-1?Q?aSo6jW5FoyohXQTAhqBHIa+pdOtNysRIaO02Q06Ox/zH3q9cp9q4OeN85Z?=
 =?iso-8859-1?Q?6IqPGpNSH+tblbBCzxQOOV34R1Wu7rh+vKNdzXL8ZBJj9tyYZ2DXROiy4d?=
 =?iso-8859-1?Q?JuccNP/I9f+e5oiN5WCqUhmJlcIRsNccJsdz9pGmNfU4RJsaJRPvJ03HHT?=
 =?iso-8859-1?Q?8vXDRHYtU1lbUvKYtPoH9/njmIj3sBItWLagjMuswvTZsJiKkWHN1xfxAA?=
 =?iso-8859-1?Q?wd0ykJq+R8nAXZ5RRr1p7BA91bu96Flp8VX5anj0sQU1aA19MICHpVGqC3?=
 =?iso-8859-1?Q?V01LTL9kMQnT8Z8GCRF1lrj4l6Mj0b1nNzPqykk3VzMOs5OjjbqGjLT9KK?=
 =?iso-8859-1?Q?ffsVvxQR7CWuyOy2J8AOk6mkvkQjP88/trIEUBYG9LUYqiebEO57kYmsJm?=
 =?iso-8859-1?Q?mt4v+ZRJBV3ALlxZkV1p8vbqO0w83QnV/8+bybJmCJumeWXgvcIfMzzW0j?=
 =?iso-8859-1?Q?bYkJy7KGRoBYI5DX9hEnIEkGl7kmVGvPpXJIxoWZ4y4ibF4jBit/H1dh2x?=
 =?iso-8859-1?Q?dupFwGIfUV7L6JFX/O1xDuZDKgblP+xDMYkj4XX175GZnfwROEAlovm7lF?=
 =?iso-8859-1?Q?N3P876iGRfIVwWUDTXwutI2wlTPqHesEG8adxOfiW/EXDwK5XkG2naZZBi?=
 =?iso-8859-1?Q?Zw9sGlK6NZa9UVHpRMQCfe3B6Cn8aLKJdt?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4376.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5066749-ad6a-4280-4823-08daf79ee50b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 08:51:44.5805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +KU62kUZmMWRhsdq2EjO68SsML9Qiu9AqYwiGMsH+5CBfeMvvqHbfktyYhf8DWiLswaH1WVegDwVAJPheyDQvKgzFzpEND4wHCTPW4w9z5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9017
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 1:01 AM Andrew Lunn <andrew@lunn.ch> wrote:=0A=
> On Sun, Jan 15, 2023 at 11:23:51PM +0100, Pierluigi Passaro wrote:=0A=
> > On Sun, Jan 15, 2023 at 10:56 PM Andrew Lunn <andrew@lunn.ch> wrote:=0A=
> > > On Sun, Jan 15, 2023 at 10:38:04PM +0100, Pierluigi Passaro wrote:=0A=
> > > > For dual fec interfaces, external phys can only be configured by fe=
c0.=0A=
> > > > When the function of_mdiobus_register return -EPROBE_DEFER, the dri=
ver=0A=
> > > > is lately called to manage fec1, which wrongly register its mii_bus=
 as=0A=
> > > > fec0_mii_bus.=0A=
> > > > When fec0 retry the probe, the previous assignement prevent the MDI=
O bus=0A=
> > > > registration.=0A=
> > > > Use a static boolean to trace the orginal MDIO bus deferred probe a=
nd=0A=
> > > > prevent further registrations until the fec0 registration completed=
=0A=
> > > > succesfully.=0A=
> > >=0A=
> > > The real problem here seems to be that fep->dev_id is not=0A=
> > > deterministic. I think a better fix would be to make the mdio bus nam=
e=0A=
> > > deterministic. Use pdev->id instead of fep->dev_id + 1. That is what=
=0A=
> > > most mdiobus drivers use.=0A=
> > >=0A=
> > Actually, the sequence is deterministic, fec0 and then fec1,=0A=
> > but sometimes the GPIO of fec0 is not yet available.=0A=
> > The EPROBE_DEFER does not prevent the second instance from being probed=
.=0A=
> > This is the origin of the problem.=0A=
>=0A=
> Maybe I understood you wrongly, but it sounds like the second instance=0A=
> takes the namespace of the first? And when the first probes for the=0A=
> second time, the name space is taken and the registration fails? To=0A=
> me, this is indeterminate behaviour, the name fec0_mii_bus is not=0A=
> determinate.=0A=
>=0A=
> =A0 =A0 =A0 =A0 Andrew=0A=
This is the setup of the corner case:=0A=
- FEC0 is the owner of MDIO bus, but its own PHY rely on a "delayed" GPIO=
=0A=
- FEC1 rely on FEC0 for MDIO communications=0A=
The sequence is something like this=0A=
- FEC0 probe start, but being the reset GPIO "delayed" it return EPROBE_DEF=
ERRED=0A=
- FEC1 is successfully probed: being the MDIO bus still not owned, the driv=
er assume=0A=
=A0 that the ownership must be assigned to the 1st one successfully probed,=
 but no=0A=
=A0 MDIO node is actually present and no communication takes place.=0A=
- FEC0 is successfully probed, but MDIO bus is now assigned to FEC1 and can=
not=A0 and no communication takes place=
