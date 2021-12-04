Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA47468492
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 12:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384817AbhLDLz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 06:55:27 -0500
Received: from mail-eopbgr80048.outbound.protection.outlook.com ([40.107.8.48]:48982
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229551AbhLDLz0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 06:55:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1SWd2JRx6/gxHDCor8MYF1SAEnAg9wpt3vDQVypRhibPyMfTKW+SoIPLqr90yli5TZOnJYAbStSg6PxUlYGqp924iLhZs+UpToJzZP3Umg9F5eI9T6aK/B9LhwfYSwFxAuekbyPemECDP7/UO+i5pGhxtISOWapx2jL9/bXcxKcfTGlwS9agdkWpMxDVui8skc+QM+x8aLawcDMb9nqyA0uVAUhr+J2vYclGwD7XVXzzaPhKRlppVKRN50oo9SdOGHtV/UaeecE0qA/HL1tEQiUjmGSsGek8de1b+T3GCTLkFV9zPrLWg8fa6tBzZk1PLwbW2V2rl+KJYzqV03wHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f7VnX2Bv7TorzJc2YFgWc7gy/41xE6RR2YsPPfJbjs8=;
 b=JRBeTK/0h6og7y4lZp3atJPuynq1UhK4QaFRYkFLuZYj+niY98aQQDVv9ECqjAEHtn47kL1fuynlbTDk5sgXQBiligUtn/c+PRIvWRZhureAPjM3BekRsNdVbu/1lvrWN9ecRg7Vi6aMNoBgZxUFe6WeBmmfz4tedSFty1CPQbe5dBYuTHeYI6ZftLeY45ftSH6/YzABvfVNmujckx2meTKkfsgi+3RikH1LXmrFWBY9Xg42lDdU6fofbYfHgSC8EJVOYaUNdHnQ8HOMzW3YNnZAe5kDV8HTt/huiA2zPtu0buZTvyaJ+J5/ZPoGoKEx2Mw/CkpMzTppwuYeExp/aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f7VnX2Bv7TorzJc2YFgWc7gy/41xE6RR2YsPPfJbjs8=;
 b=rwMaVznB1aSToQPMAOSzw0tW+V7Ud8Bl43DR0QOK/w29mwLdFC5zmDYETYY9HpUegukLi/EBgR1hlSznZihqUWbMU5Y+UWhk22BlizKW3+k08VNu1mftoQNRdN4aoidVW37b/JUKgNHMMJBi60yVEwsIUV27VKeFGUsrBepVaxk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2864.eurprd04.prod.outlook.com (2603:10a6:800:b7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Sat, 4 Dec
 2021 11:51:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 11:51:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: Re: [PATCH net-next v4 4/4] net: ocelot: add FDMA support
Thread-Topic: [PATCH net-next v4 4/4] net: ocelot: add FDMA support
Thread-Index: AQHX6GoBQOKMK7t4rE2bRf8FEkqhQ6wh5hIAgABTwIA=
Date:   Sat, 4 Dec 2021 11:51:52 +0000
Message-ID: <20211204115151.6na4cb3tspxbtt36@skbuf>
References: <20211203171916.378735-1-clement.leger@bootlin.com>
 <20211203171916.378735-5-clement.leger@bootlin.com>
 <20211204075206.0f942fb1@fixe.home>
In-Reply-To: <20211204075206.0f942fb1@fixe.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b3dd6bf0-9ef8-4bb3-a340-08d9b71c769a
x-ms-traffictypediagnostic: VI1PR0402MB2864:
x-microsoft-antispam-prvs: <VI1PR0402MB2864223CA13E2757343B4875E06B9@VI1PR0402MB2864.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w/0Dzxeqg2o0tPxX9j/yF8qWIfHszYozWafXRG4yPjinPg0Ywbvt9OZSFuaex4A/pWxdJB9igIlsf/eBNgjJyGP8NXawgj89bYmcAQx79rWsE+Fbl6s3jmhwY8+npNTogkH/Xk7V7KuNW7b6gQwdQphG0hrkwNNwh9rVmlIPCRWdt4quytRzPefRj/X0qKHhFFg2EF3grG0t76m3yiOeKY6L/SJ8TLstKb0FPMKnVExs1cnsriJ8Tc0cH83Xaov445xuI8cd5Ri3Vr1bnjt0B4aJuIEdgFxdeUBlCEJvHH3zXsdutseetY8IiHF8EHbGbuaFGSAxTTNlPWGgV+H7PFXUTShL4S+aMsrEiRixB64KLW9K1mJt/YGdLpXAj2RVGEREXyC6ucjWNqr/uwyYt2FhU4J14t4BmjAkcyUmVJGpmDsbYvvDRW1kzadKFcuMEsY1SNRva32xU456bDB57GkNo5o8EX5Tby5bB5KTotebfzcG9cKj8JBIDl0FxnoAnDYx39PKojbAdiZh5si59MeoEJxqF2lPKGGttuFpGb+jRt/At8hmIGMHzDkuGYcD3nE2qF7T+6YrrQnYteak4gdmGy521V+UjRBy+QmL58REsV/WT1iTfrELXMwpJONF33RET8JhdnhgyMDjqsV0qgkosJh0sPQpm00y3/kOM0oiu58/YIZ4wVN7R52Sa8YoPJEW2mqoo5ccS1/l9ZK5NA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(33716001)(76116006)(66946007)(316002)(91956017)(9686003)(66476007)(66446008)(64756008)(66556008)(26005)(83380400001)(6506007)(6512007)(44832011)(186003)(8936002)(8676002)(6486002)(508600001)(54906003)(1076003)(6916009)(5660300002)(71200400001)(2906002)(4326008)(122000001)(86362001)(7416002)(38100700002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?lVbocNXY99RT6qtjuvJ4iARUNFy4QmtYADlYKE6lAWwhfkAUKd6vUzj4eT?=
 =?iso-8859-1?Q?R9vHPGVH/dhkik/PKYoPnN8ezqqd+BM4WS/YhQHKS78vaCFR53kOhD1WT/?=
 =?iso-8859-1?Q?RvzCUrxkZowdA9TyI47Bx2f4j23L0dsdP7G8fo0THMdTN5sSJA2mcA3mwo?=
 =?iso-8859-1?Q?ux/z+hx+B1aHT7lmHx68550iR2nI8a2cnFuLrt5c9posADRorOMv/uIDXQ?=
 =?iso-8859-1?Q?Ktu+mLC2tQF7R7qZyIzReqGvW1q9xBt5dRxIEsTomPyDaCf/hsWRRiNbmw?=
 =?iso-8859-1?Q?nAX2gv97LCTR94c20vbw/M2xudsxxNiroYdVkZ4uEw00j3FnmbKExdX8cW?=
 =?iso-8859-1?Q?dE61033kaSAY+rxCuxEmHk+0N2NXoM5CKhW+tkOMX+F34qyItBkKbg/MWR?=
 =?iso-8859-1?Q?8X7v2WpFAAQ8Qu2Krn6u9G+3Vn+DGqvMdnJhKUpiPu24AuKHBcE404zm+j?=
 =?iso-8859-1?Q?+i0ekJzcMRjrbuj/A9JuDQNpP5xIl5AGaGwjxQNVQrgeFC6COaFH9gwkPr?=
 =?iso-8859-1?Q?FIyNMTJ6+DDHxUULgdvnau3aXAurVyv5QChBw7RUjheZ0fkC7nwVpDb2P5?=
 =?iso-8859-1?Q?8+qz0MgzEhchtB1oiJoRn3uRsAExPo75LAX2x6NdplVL/iwSQFb9LDScsn?=
 =?iso-8859-1?Q?O20ASvrxprU6l0+LC8XpI3od0xIydBv5mBqCjpWUyg+94S6eGa6x89roid?=
 =?iso-8859-1?Q?DjDwgnxkFQ7pNY0EJQ4yb0AlU5vhy3KHQfPskNK/lzzkKUC4mv29tXuC0u?=
 =?iso-8859-1?Q?PZ+HKphJPeEUenVDqC9Rkzss55ndrcTOvNQC99DdVdz5IHyP6vMDkLslnM?=
 =?iso-8859-1?Q?TfUpQ2FcOpBLQZJlShoRsSjKBqUKJILVru+my7x+JkyAzCB9DcnNT5H4Gy?=
 =?iso-8859-1?Q?83OhbX/zVbISndxVJP8Wbv82935krui7YhJ5njq2BahYigmjJuJJFQbnre?=
 =?iso-8859-1?Q?feK4UJVtttP5QWMvGUALTZS8I+heTk773ucPrbgC8CcmrJi05ag1TWmi4r?=
 =?iso-8859-1?Q?oxHKeKspXbxP//5gNnqOYg3nXEwhqmu/dsDUDq7Bf0NvhGrt4nRr25yQOP?=
 =?iso-8859-1?Q?qF3mMfK60AL5uTYqCWUv30akS7Wqta/9c3YUI7xc2y5Y8sx5hlVoPXESwu?=
 =?iso-8859-1?Q?28vdvxxYZw7seJAIVpvAIUGxccLH8JCTVlyKLoxHUNMTQqBY7pxpHKwwpu?=
 =?iso-8859-1?Q?opbfBqD3FAJE7KAAYBZLkvaFxg7zR1cjGMc4ds8YyaIk6QE0mxsee/QLR8?=
 =?iso-8859-1?Q?U8KRW5tBrbN5BXxJaJn/rrBmM33Izlmq5zWZIGb452tf4zsxAE4eH8d2Qf?=
 =?iso-8859-1?Q?Hx09zISYo76qondJbOQ3MZ3fpEHg7RJfWenDxnJNooRiJAFUdCixnV44fJ?=
 =?iso-8859-1?Q?kFi2XK1BzB0coIQHLw1omYTSaj3XCg/W+jBgWilPmifOnKcs4G2dNSJ/Sd?=
 =?iso-8859-1?Q?/5hM6x0Fc6UjsEWdJpap2ewkx2ewQmE4Hn092BGgu0Djcf8JDH41zyb3iC?=
 =?iso-8859-1?Q?wxVUHmt8x2utLcxGO7bYyifNJ2n0fTFFcYo68i8weN0GhPutvfwWrAACu9?=
 =?iso-8859-1?Q?+dXL9TIzYxlZ503BAE+7WmuNgXHLFEwdDhy3RlG4aXoo1EgirG8IK96Dni?=
 =?iso-8859-1?Q?sXNi4+IL82zPtRGMAmN/LBADqVjCRLbeJYuSJPiiKuAtoqL0quiDe5O77W?=
 =?iso-8859-1?Q?zu1QnMYQ2DAtl5PhF4k=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <9055667298C0DF46B03C9573DBF324D6@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3dd6bf0-9ef8-4bb3-a340-08d9b71c769a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2021 11:51:52.5042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UoIx5lV8H/zoMBQZlO6rGPKfKHIuxDN3CD5oLOpUJv9wkIMTWkOHeFBVBsV/BF2bbdr59Cq6LTN9Ls9VsdgG9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2864
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 04, 2021 at 07:52:06AM +0100, Cl=E9ment L=E9ger wrote:
> > +void ocelot_fdma_netdev_init(struct ocelot *ocelot, struct net_device =
*dev)
> > +{
> > +	struct ocelot_fdma *fdma =3D ocelot->fdma;
> > +
> > +	dev->needed_headroom =3D OCELOT_TAG_LEN;
> > +	dev->needed_tailroom =3D ETH_FCS_LEN;
> > +
> > +	if (fdma->napi_init)
> > +		return;
> > +
> > +	fdma->napi_init =3D true;
> > +	netif_napi_add(dev, &ocelot->napi, ocelot_fdma_napi_poll,
> > +		       OCELOT_FDMA_WEIGHT);
> > +}
> > +
> > +void ocelot_fdma_netdev_deinit(struct ocelot *ocelot, struct net_devic=
e *dev)
> > +{
> > +	struct ocelot_fdma *fdma =3D ocelot->fdma;
> > +
> > +	if (fdma->napi_init) {
> > +		netif_napi_del(&ocelot->napi);
> > +		fdma->napi_init =3D false;
> > +	}
>=20
> Using a boolean  is acutally a bad idea, if the last netdev
> registration fails in ocelot, then the napi context will be deleted.
> The net_device should actually be used.

I think that you could try to call netif_napi_del() only if dev =3D=3D napi=
->dev.
Because, as you say, if the NAPI structure has been added to the first
net device, and the registration of subsequent net devices fails, that
NAPI might actually even be in use by now, we should not disturb it.=
