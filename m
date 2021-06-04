Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08C339B9F0
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 15:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhFDNgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 09:36:44 -0400
Received: from mail-eopbgr30048.outbound.protection.outlook.com ([40.107.3.48]:55374
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230108AbhFDNgn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 09:36:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fqTC9XTuxY7BTxUzBgiJ/kzqIvcoEMB0uCg3ycnj3gIqr94PgaIgU1wPSv91hXT9GhTWxIT2/dbHLIr8FHJ8VvqTxaf11LY5QCALbIEflXbWW/ljCY2vgOb+g1ZunLgbEgnDtAN2h1vipP++9eXbYhF+ZJ+vFXoWF9SofonX/0Obky2l/NDi/5xztPCJw/cGlOvILNbuMe8gbOCcpvu3jWGSSKpC+BV6aXShOBQJP17RvPmgO8Rp7nHcW7R5k8WFtPWPEue1XjLswuVWwn9MORCi1v++A6nZmw3VtNiFq59HACHx1O7kqkq31EbSK4gp8CtDwXlO+KSoVdqd4ySyOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XsTh4Z5TyHGcR/LWwJA3191fclzMLrB26Y8bNY0VqU0=;
 b=MdJ/m6f6gcE0vpAzQm7XEida3DWqjCV+jeWx8BSND9yWz3LJuvj62QRisFgv5oqw5MjMV93S2ke2VC0qBFoDl9CIW9S5XwMMwBmAZZAA6M7dl1F07adUv2KF6m2GBcR/NdpDwHuanvrlcn5jH8EO+p0aoJE6a0+0541XH9V1l/E/s0vjLLdMoz5CYa+p5KKqqLBh2KezdjKiERlQkbNKsr4qumo62ZxXhFmqKL9Wv/OxA88paUPHqxWDBV5r/w2v5xhoeetIYr1u79m5pUhH5U15m++3dvTtWQvextbSFOFT7AeL0RQdya0w3tQqyQeZY979bR4GhsRl4XW5ecBjKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XsTh4Z5TyHGcR/LWwJA3191fclzMLrB26Y8bNY0VqU0=;
 b=csK0b4np1ikvKLnsk31Tv1+IsgRyvsPR5hUymWEeAT+hzIkGLgTs73EQPwIEN/YAK4aUJjI069PxDG0JZUj0ay7g21xxMuLsCSmIfYsi6GLZKiDKJv77DwYWTEb/f1xSYfGx/8Fh6USDYlj4IJDqGWsxJoxU0kB9yw8tFTTTmNk=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by AM9PR04MB8323.eurprd04.prod.outlook.com (2603:10a6:20b:3e5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Fri, 4 Jun
 2021 13:34:55 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::31a4:3d80:43de:e2bf]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::31a4:3d80:43de:e2bf%7]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 13:34:55 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Michael Walle <michael@walle.cc>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: RE: [PATCH net-next] net: enetc: use get/put_unaligned() for mac
 address handling
Thread-Topic: [PATCH net-next] net: enetc: use get/put_unaligned() for mac
 address handling
Thread-Index: AQHXWT1nyFh4giODOEObJgz+mrmMgasDzDiAgAANvVA=
Date:   Fri, 4 Jun 2021 13:34:55 +0000
Message-ID: <AM9PR04MB8397C6E7F7DB30B4AD1F65D3963B9@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20210604123018.24940-1-michael@walle.cc>
 <db1964cd-df60-08a2-1a66-8a8df7f14fef@gmail.com>
In-Reply-To: <db1964cd-df60-08a2-1a66-8a8df7f14fef@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.147.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aaca9c08-8c59-4f21-c826-08d9275d8a76
x-ms-traffictypediagnostic: AM9PR04MB8323:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM9PR04MB832390F97F287D936D0AB6F5963B9@AM9PR04MB8323.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MGFla49btqGEMTVMO+LU8Xy86d67zOWLiqcyUfqqhuClc/aKkMCEpaCqkL6Aq+Lmq2nZY9k/XWKcRarEwYOmH8Quf0reXAkhwhbeyxU0VbxMiqUefrQfiKvu+IloBJGPyuKqcsst2+/AT4tDEuiapSq3raNMu5H34cMAQFozfo5o2q5/JPc6NOHWKXE3OfO6mJNRcKmKqxAhbtrit8qGRMi6z7l8iTH+Ub0Gil6KsNXOjC4bv0lp4ow6gkOVsr+BZ6ltUR1bFE0+QI5L+DuA4yuF7/f7BpfRHZhAN1YQIcB9OdJ4xu11ZjkHVNCdKiqHB/eIOxs+0RszTk5k/ZoEnXTvnIdpGpjtX/C9fM9JiZD5h8YdAMId0Wu7mQmvT0Iu6TVEjGSFjRNDUHaoeSv7vaRr22CmXqXKu4Q8IdVUVgXYYCvfqPHf5MAW2YAnKeoh6U6dD/1NnhNsSRsvKTrNnlyPI4o8olspDFi2/H3Dc6Y/AjVJpTADfMoGO7QD72smFjWNGYJW0PzHU9pk6XK7Vjiu/edvDvWMP7/ifKPuj/EDWp51xLd+P5Toe29hclcKKFB1/VwqnBA8OLOvoCHmdw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(39860400002)(136003)(396003)(8936002)(186003)(26005)(44832011)(9686003)(5660300002)(2906002)(66476007)(66946007)(64756008)(66446008)(76116006)(66556008)(55016002)(83380400001)(54906003)(122000001)(52536014)(478600001)(8676002)(86362001)(316002)(71200400001)(33656002)(6506007)(4326008)(110136005)(38100700002)(7696005)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?S085aUpka3JxQXpPRDBPajBlTjljbTBhZ29MNjlCTWM3MHlMZ0QwSFFoVTFF?=
 =?utf-8?B?RjlCcDRFYTM1RXl0UkVDai92TEttR2FSTWNpRHJKWXR0UmFBcnNZcnNTQU5J?=
 =?utf-8?B?aWlQdEdTcmQ2QXR1RkFJT2RWdDQ2UExaRGhlNSsyRmxpOC9IOWtZMlhxaEIr?=
 =?utf-8?B?THc2QmYrWDB2VDhwdUg0aExpMjJnQk1FSXp0WVMvVkZPM0ZCQWpUUzRtdHph?=
 =?utf-8?B?aklRcVZmMExKSkZmdS8yUlV0bStGaG5yNWc1RW0rdWROWmJHQ3lITXhmdTJj?=
 =?utf-8?B?bWtjQzY1R3orTkRZbUg4NElaS1o5QUdmVGk4ZE9udGdQM0J6eGtmQlRjK2Ji?=
 =?utf-8?B?K0llVW00aFp3UEkxdU1FSWRRZEtHNjlDOStCcWVwckZ5ME0vK1RhejRqQzYr?=
 =?utf-8?B?L2JzVW5uRUFhVjFoTi95WmhpZERKQXpGVU9Ic0VBR2dYV2N2MzdBTURFQmlZ?=
 =?utf-8?B?UHRDb081S3RHb3JkazgwdllOVm1mYitSdmRlcEJKL3dTaTRXWVlGMDYxeFdt?=
 =?utf-8?B?cU93RWsray9KdHliRnNVcnR2R1FaWTZRLzA3Q2RseGpucG5uUVFJdnNnOVV0?=
 =?utf-8?B?Q1gxZ2hTQ1hwT0pVUGRFTmU0eXVKb0g2OC9lci9kbjFhcGZUTEg2TWNBVklq?=
 =?utf-8?B?TmxlVzRxRWRjdlMrREoyYlcrRjExeTRvZDJMS0VOT3RpN0F4WjBDQW9LNjdy?=
 =?utf-8?B?Q3FOR24rWWN1RDUwL2dMM0puUUY1SkVGRVc2NlQ2ZjhNMEg1V2lSNUQ2VHJ6?=
 =?utf-8?B?eXhYSlJNL0tzcVIxL2hGeFVtd0dKZmRWb1ZTOEhhWDJGaFRydlJTTjdzZXlU?=
 =?utf-8?B?MVA3Z0NaVnRsVEptNkxvekNxRk5PTnJKeW1mUWdrMUNHaXNLNEtXNGdrdXB6?=
 =?utf-8?B?Tk5FalNzMUZ3RUhyRnh2ZXpQR01TNmY1eGhPcGsrb0REaGdSY1NxZFFIdGUx?=
 =?utf-8?B?cy8vSnl6czR1Q1NpWlBPQXVEWVRacksxRkhSR2xmY1BoOUlqQmNuNUFEODFm?=
 =?utf-8?B?YnU0aVgxSm1QZU96MHV2cllMMXFDbWJzdUExckljQTRwbTNpOUoycGZnTkk2?=
 =?utf-8?B?NGRPVmUvTEI0eXpReE1UME40d2tRazFtOVM0YTExWHBDNFRaUy9xSTYxdXJ0?=
 =?utf-8?B?Z3AvM210ZmRqRGtubnB4N0pLblcveFQ4elFxekF0UTEvTldWZEJVMjliZFBO?=
 =?utf-8?B?SHcwUVJMQU9pVGZsbmpDdUNmTElBLzgyOXc0QnJXNWZxL0Y2UUh1bXJ0Yk4w?=
 =?utf-8?B?S2VUZDYwaE9SSlE3MDhBeExsUDlDa251N0NaMllJOS9waVRGeWFOOVdkcFpM?=
 =?utf-8?B?TG1ra0YwSEZsekpKek5WRnBWc3djNnpuejVDYkdXTG83amVMa3NlbFJBeEdt?=
 =?utf-8?B?cGk0UWhJMDlMenZxS3Q0UVJxaUV3SVBkU1A5aERwSjdHQlY3aWtlbUpscnNN?=
 =?utf-8?B?YWR5ekpobStYU0xONWNHaUpaTUlXeE44NVpyUGpyaHdwRys4K3FEVmx2bmRt?=
 =?utf-8?B?bTRON2hrZW5RYTR2N1FTejBrYmtSeFZIbDRRYnJNdmRoL1E1VWdCTTkxNGIw?=
 =?utf-8?B?N3ZTRk9kNGNIUDhxS3Y3OFRxcGhtNDVDVFgvdW5lZlp2eW5vQUJTd3dFOG5X?=
 =?utf-8?B?WnhPM3FQUHo1Vk85ZUUxWnREQks4NHFIdEFUQ01LUG9xeDlMSVIwQU1DOVQz?=
 =?utf-8?B?amxNaFBjVzI2WmVrZFlmaHdQU3BPZCtXeWRkUUNmaXVzUWppcGUyNENWNnNQ?=
 =?utf-8?Q?MwKXYUIIGZPJXu1m4A=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaca9c08-8c59-4f21-c826-08d9275d8a76
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 13:34:55.7231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RsOQi8ekUyScg2cKH9FcoCqPNvFrvc4oJNs2u1Pq150F+4/YpO5io2GMCD3EB+H7xhzH1hP9VRTkQ+g4FTfC+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8323
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEhlaW5lciBLYWxsd2VpdCA8
aGthbGx3ZWl0MUBnbWFpbC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgSnVuZSA0LCAyMDIxIDM6NDQg
UE0NClsuLi5dDQo+IA0KPiBPbiAwNC4wNi4yMDIxIDE0OjMwLCBNaWNoYWVsIFdhbGxlIHdyb3Rl
Og0KPiA+IFRoZSBzdXBwbGllZCBidWZmZXIgZm9yIHRoZSBNQUMgYWRkcmVzcyBtaWdodCBub3Qg
YmUgYWxpZ25lZC4gVGh1cw0KPiA+IGRvaW5nIGEgMzJiaXQgKG9yIDE2Yml0KSBhY2Nlc3MgY291
bGQgYmUgb24gYW4gdW5hbGlnbmVkIGFkZHJlc3MuIEZvcg0KPiA+IG5vdywgZW5ldGMgaXMgb25s
eSB1c2VkIG9uIGFhcmNoNjQgd2hpY2ggY2FuIGRvIHVuYWxpZ25lZCBhY2Nlc3NlcywgdGh1cw0K
PiA+IHRoZXJlIGlzIG5vIGVycm9yLiBJbiBhbnkgY2FzZSwgYmUgY29ycmVjdCBhbmQgdXNlIHRo
ZSBnZXQvcHV0X3VuYWxpZ25lZCgpDQo+ID4gaGVscGVycy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYt
Ynk6IE1pY2hhZWwgV2FsbGUgPG1pY2hhZWxAd2FsbGUuY2M+DQo+ID4gLS0tDQo+ID4gIGRyaXZl
cnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Y19wZi5jIHwgOSArKysrKy0tLS0N
Cj4gPiAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4g
Pg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMv
ZW5ldGNfcGYuYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0
Y19wZi5jDQo+ID4gaW5kZXggMzEyNzQzMjUxNTlhLi5hOTZkMmFjYjVlMTEgMTAwNjQ0DQo+ID4g
LS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2VuZXRjL2VuZXRjX3BmLmMNCj4g
PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZW5ldGMvZW5ldGNfcGYuYw0K
PiA+IEBAIC0xLDYgKzEsNyBAQA0KPiA+ICAvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogKEdQ
TC0yLjArIE9SIEJTRC0zLUNsYXVzZSkNCj4gPiAgLyogQ29weXJpZ2h0IDIwMTctMjAxOSBOWFAg
Ki8NCj4gPg0KPiA+ICsjaW5jbHVkZSA8YXNtL3VuYWxpZ25lZC5oPg0KPiA+ICAjaW5jbHVkZSA8
bGludXgvbWRpby5oPg0KPiA+ICAjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+DQo+ID4gICNpbmNs
dWRlIDxsaW51eC9mc2wvZW5ldGNfbWRpby5oPg0KPiA+IEBAIC0xNywxNSArMTgsMTUgQEAgc3Rh
dGljIHZvaWQgZW5ldGNfcGZfZ2V0X3ByaW1hcnlfbWFjX2FkZHIoc3RydWN0DQo+IGVuZXRjX2h3
ICpodywgaW50IHNpLCB1OCAqYWRkcikNCj4gPiAgCXUzMiB1cHBlciA9IF9fcmF3X3JlYWRsKGh3
LT5wb3J0ICsgRU5FVENfUFNJUE1BUjAoc2kpKTsNCj4gPiAgCXUxNiBsb3dlciA9IF9fcmF3X3Jl
YWR3KGh3LT5wb3J0ICsgRU5FVENfUFNJUE1BUjEoc2kpKTsNCj4gPg0KPiA+IC0JKih1MzIgKilh
ZGRyID0gdXBwZXI7DQo+ID4gLQkqKHUxNiAqKShhZGRyICsgNCkgPSBsb3dlcjsNCj4gPiArCXB1
dF91bmFsaWduZWQodXBwZXIsICh1MzIgKilhZGRyKTsNCj4gPiArCXB1dF91bmFsaWduZWQobG93
ZXIsICh1MTYgKikoYWRkciArIDQpKTsNCj4gDQo+IEkgdGhpbmsgeW91IHdhbnQgdG8gd3JpdGUg
bGl0dGxlIGVuZGlhbiwgdGhlcmVmb3JlIG9uIGEgQkUgcGxhdGZvcm0NCj4gdGhpcyBjb2RlIG1h
eSBiZSB3cm9uZy4gQmV0dGVyIHVzZSBwdXRfdW5hbGlnbmVkX2xlMzI/DQo+IEJ5IHVzaW5nIHRo
ZXNlIHZlcnNpb25zIG9mIHRoZSB1bmFsaWduZWQgaGVscGVycyB5b3UgY291bGQgYWxzbw0KPiBy
ZW1vdmUgdGhlIHBvaW50ZXIgY2FzdC4NCj4gDQoNCisxDQo=
