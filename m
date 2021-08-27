Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2433C3F9BC1
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 17:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbhH0Pe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 11:34:27 -0400
Received: from mail-eopbgr70040.outbound.protection.outlook.com ([40.107.7.40]:32071
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231327AbhH0Pe0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 11:34:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jl9Mvse/V93OO45e0X6ZLm2s/JipCAt6Tv85CrqAqiQ1Csyf7wWefb7TqtfZClx02S5C0H8es/TXqZQ8OlgTr2Mxououk0HsEUMhmpKgmKa9tIvr/gKi8ZhNBlmDZ+Qe/3S8l9HcnC3U50C51xGywKxIs9YbDP+yRkbPzAFU66x8UiQ6VkzW0kI1p2C5Q090GtlYL0i+ZxxUAEZPON0DLDoBDiSMXS2IVoHRtv82mvYD5bTrUNoEIMjCocc/POneyMzhQVqzU8RssMb2P+7DD9uFCR0QchmzN6HGT7RE04puNgI/zTefYAuNeyLzhJ5XAD8dGLO6EemSyWa0XW20Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=01WkHGhDyH1Ud1vNOgI5URz3o6kjO80k0ZIWMMUC/4M=;
 b=W6pu8QrU2ishtYXJRQHLx0zd+1M2aiguC5amtL3/toF2dpU0/EfpI57gPuE60OtSCTKBH1UPmZr8uj4ec0Li/L/KQgftOkX9/+jY5nwY5UV9fnl/+oI/JEQ1ORYGuYygdZHE5f+Om8KWIQDQsX3sBBwJwuLR8DsXQ7uCzPCyyl6sG6xCw14wwXpwtNGXcdN/TcgW1nwFm4bm+jo8NkcpTJM4FDXBlzsyPOejn6J6GJFPEA+Ts9EzRU/7FglbVbD/mEez5XSw3g0QalHBOc0S8UjngiP207lDVxQYi/d3MWLoqSfbIyEJqurwszqMu/cvZtwbbC5C1IcvPMrrRayzkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=01WkHGhDyH1Ud1vNOgI5URz3o6kjO80k0ZIWMMUC/4M=;
 b=rvgfwcaaAghWM4WWHuYeFpZLFpSCuouAwMa6LVoSeSrsfMcDdCGLyFvRqgyWSThjarHsAmsehRvSHW7Z7bQLpzbGHWfNsuxlhPm3Hi2haoEdewJC0DN46vVyxJmTIhsueLJ4kY/dek4tDlaQr9PkbicIR+QZpqL2hTh9w+p1S70=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5134.eurprd04.prod.outlook.com (2603:10a6:803:5f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20; Fri, 27 Aug
 2021 15:33:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.027; Fri, 27 Aug 2021
 15:33:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net] net: phy: marvell10g: fix broken PHY interrupts for
 anyone after us in the driver probe list
Thread-Topic: [PATCH net] net: phy: marvell10g: fix broken PHY interrupts for
 anyone after us in the driver probe list
Thread-Index: AQHXmtilHL+j+lhMrEisJEOJ/bAluKuGkRqAgADq/IA=
Date:   Fri, 27 Aug 2021 15:33:32 +0000
Message-ID: <20210827153331.njhcrsvnjsgyvyjv@skbuf>
References: <20210827001513.1756306-1-vladimir.oltean@nxp.com>
 <20210827033229.1bfcc08b@thinkpad>
In-Reply-To: <20210827033229.1bfcc08b@thinkpad>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 11969ed6-e8d5-440b-c1e9-08d96970073c
x-ms-traffictypediagnostic: VI1PR04MB5134:
x-microsoft-antispam-prvs: <VI1PR04MB5134C0E30D0CA0D3E05D24B0E0C89@VI1PR04MB5134.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jIjCASyte7ctAIgGOxAVIpBs0sS9twmYJnNzjiLu6OkaunEIKaTyiVtZfq2DIehE2/QsbpRLEw+eijVAGF22RAC0XLCjyutWDBbEQ+qy0BP1onFNf5NubGNAMlOd7GW2spya2+ws+VWJKT1YUsKGHpLq1MriHaOJBDKX4XX+0Ruu4JuCMAnVrei/2MxXkrGcrWNAPD0URpv6KX0+CcorFtXJWUKdjIUCrnubn1pI7qiPwH/NJIzbG0CKilc1RMviAIIJOlRWzCinxHsXboeAwFBIRTeIE30wdkdj847BzkJQy83skQdlHkDnirgkRgAkwbDkABISE7v++2HdCA3p6gpcqhDy4PRebbTkKKsozuj5x423LgbhRkVgB7hIKPuHJInZ7k4NtN5Ht/o7//dh3HSkSObAbIoPZxSh8pzd7pS7OKzllVSDLPa3l3dKKuSakstTMkcRs7iVsCMl11dNgvPrAtpenIxuqvs1UB9sxg6kf8AhfZxxKkUHX1u/F/eyKkE62fiIV6BLTsNbSN491smQ4yYHnIsA/npzgm8r9A5r+4dIJdRHUYbXcsncMb1JeU9WCyxLVinIVKyU0NpwxaHbyUWHklgdhTFRoHeJ/lrsZFtSxZTA8MVZRd8BADVsDhG9WtCrgPmgFTFD18N04AjDaqVt/8Yc58oJayhhGra2c/ArJqmxu0ZvkM6w97/7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(38100700002)(1076003)(3716004)(8676002)(6916009)(2906002)(66574015)(6486002)(33716001)(86362001)(122000001)(66446008)(44832011)(508600001)(76116006)(66476007)(316002)(6506007)(66556008)(186003)(66946007)(71200400001)(8936002)(38070700005)(5660300002)(26005)(4326008)(64756008)(54906003)(6512007)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Y/4EnjDyU54YnAlv3i345mBnkYfGVMuPfb5/SrextNg4vphUrdZ1cGmmko?=
 =?iso-8859-1?Q?aB2gRJ+Sxfz1CYqgnSDq23qs+ggQKUsvOKyXE65S0+iYRTLFgCv59E5wt6?=
 =?iso-8859-1?Q?1o2efDCskfuKkfYThp1VExvtzdC+ctOAmmseS94SU8R3PmGoBorLxqtaJp?=
 =?iso-8859-1?Q?ZAH1mOoHOR4S6whDLNoVH5+Lf32iTQ/1ugr/QbG0eLkhA5E3Jv5r48InM1?=
 =?iso-8859-1?Q?scyWnodBWuJkA/Vm8cu9rxJfLtkKzKVRRymbEqDTeIy+3dwtQW0w5DOI42?=
 =?iso-8859-1?Q?i2xBpnCXlOdhixIZqbRtUbKRJWrqPAvl4QRfU2u/y5KuyGjoeeBatrZMbD?=
 =?iso-8859-1?Q?tZyRyxPM3CrtFd0XO1gTjO3GqCTkP4L/ZWbDusxulnHQgcnXhOQPRXH0/9?=
 =?iso-8859-1?Q?YTkBzKav+KtfaET72Jg4CDCCtZ15yx9q9LbUZaPyvbz3wGTYZXG8zM5Zxe?=
 =?iso-8859-1?Q?L6aIcrxIF94UJk31rgE1Wx6m71DqzWY+Cz6vMyy7oW5nav0BVWccCZiBOn?=
 =?iso-8859-1?Q?KE0fTZEUI1WwSHQ3MEjqFlWeJwfD0L0prhYH3QUeMx0ddyhOfTvKT+7Q9U?=
 =?iso-8859-1?Q?qDKVqtiKnwPsgulbyivqF4MzWItJFroAYYDhzIvkitKwQapOwvgBsP56Ah?=
 =?iso-8859-1?Q?TGYpWzsso16HoIXo+blRKe6RcXRVwbEqd7KYj6t8JvMXsbwmyArv1wnWkO?=
 =?iso-8859-1?Q?khC7KI0naXF6fI6ZI0396zQvoWnlpgApkcsKd60N7cPau140kwQ1NsGcXw?=
 =?iso-8859-1?Q?vbt86WAuSHcJPO1gNTRxa6gxrXItRjc3P80lQEKjnh5TD9xaNh8zEM4wbu?=
 =?iso-8859-1?Q?RsJbA5irQuVkYjnU3yrXHuHROKCAK1g+f349Na8PCY+n/D8knoGXRpupIT?=
 =?iso-8859-1?Q?HhUacWN19FLDNyO8+GrvGJfbW2XXgwWVfkB2OXlKTWnusmVAph//9rmRoA?=
 =?iso-8859-1?Q?6TOTmNiXHsVhAopCfiTXDy6fdlqm99Su+Ou5DcYrGyhprselAvcCdnMUsy?=
 =?iso-8859-1?Q?BUvbOi5W3zIiux6K9NrqnTZR0EQ3Bw0yV8YhiGA0Bz8De7P0lryX2gES/p?=
 =?iso-8859-1?Q?tVlyGLisKsIuQz7VOAAPCaQFEypbPKvAVSIgMBvICfyiWLaXXZsQwqMqmw?=
 =?iso-8859-1?Q?ezwADRLFq8Wqp+V/PMuMesuvX21SMkjnb5ApydgYK68pYBzU0IKiXmfwhv?=
 =?iso-8859-1?Q?5+Vwucri2qwGU8gBa+/xEPRdl7rV2WI5UK6o9KfCHb+g2vmoUyv10JBPGA?=
 =?iso-8859-1?Q?ZREvUROj6r6AuWXzT9KSVztSyN64u7LajJ3C9XxsS783ChuUFra2hs1Rht?=
 =?iso-8859-1?Q?l9IjwGuJl9XRdTTuctxfh/i7Gu6eGPhhimkmICjhFXn+P6eDIjXSKCEtfo?=
 =?iso-8859-1?Q?5mU1rp3thc?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <FF68CEA0D374504FBF654C8B7E3512A8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11969ed6-e8d5-440b-c1e9-08d96970073c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2021 15:33:32.7232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DvsLH4ilLVUhl0rAXd4TCO1u4d/wie38CDlFofNQc8SNZ7O9QZyJjWFqj8Mq+7LFbqaq0T774+b3FVujxttpNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5134
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 03:32:29AM +0200, Marek Beh=FAn wrote:
> > Fixes: a5de4be0aaaa ("net: phy: marvell10g: fix differentiation of 88X3=
310 from 88X3340")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  drivers/net/phy/marvell10g.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.=
c
> > index 53a433442803..7bf35b24fd14 100644
> > --- a/drivers/net/phy/marvell10g.c
> > +++ b/drivers/net/phy/marvell10g.c
> > @@ -987,11 +987,17 @@ static int mv3310_get_number_of_ports(struct phy_=
device *phydev)
> >
> >  static int mv3310_match_phy_device(struct phy_device *phydev)
> >  {
> > +	if ((phydev->phy_id & MARVELL_PHY_ID_MASK) !=3D MARVELL_PHY_ID_88X331=
0)
> > +		return 0;
> > +
> >  	return mv3310_get_number_of_ports(phydev) =3D=3D 1;
> >  }
> >
> >  static int mv3340_match_phy_device(struct phy_device *phydev)
> >  {
> > +	if ((phydev->phy_id & MARVELL_PHY_ID_MASK) !=3D MARVELL_PHY_ID_88X331=
0)
> > +		return 0;
> > +
> >  	return mv3310_get_number_of_ports(phydev) =3D=3D 4;
> >  }
> >
>
> I fear these checks won't work, since this is a C45 PHY.
>
> You need to check phydev->c45_ids.device_ids[1], instead of
> phydev->phy_id.
>
> And even them I am not entirely sure. I will try to test it tomorrow.
>
> Marek

Thanks for testing and resending. Last night I was trying to do
something completely different, and it looks like I concentrated all my
attention on the problem and none on the solution here.=
