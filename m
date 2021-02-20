Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947E032045E
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 09:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhBTHo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 02:44:26 -0500
Received: from mail-am6eur05on2065.outbound.protection.outlook.com ([40.107.22.65]:29921
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229470AbhBTHoY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Feb 2021 02:44:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oD5a04kVb1fO1W01FFifMSsUIA2B9vqkNxVmX2v5NC8qWuZfjWJTMrzEC9K+BjQCe32gwfasY5lP1rFsp5JVyKdRnH7MgfxjvqYqLfOrrKvoVwQUJFBXuPT578KnWORTT8ptppCZZXoobwiyaV+xS9NEY7YinOH5UsENXXLE45VBi1FNhwsKOQoHYlbMZ4Rxu/D+lBHcsHft8SM/5tI6Sl2fSZdBzHNlv50IkeKl+UW4VDqf5WFdLvrAODtDGJg8Y0k7JoOKI5kOBngADFhlsTHr7UrW9G60eF5S7V112ZtqaNtkIUJ4zp2033z85BANQfc5R0NfcFe5fgjBpJeIpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l7uHkxPJt2cWl5eUNgqjgMLRhoOkQwHsN10wp5ftRRE=;
 b=hAVvy3QVGIl8f3vaCwVdWZTzLXc84ekZMbcevNo8q2Awre7yE8TFq6Uv8zKykclGepncEyJI/97YPd/l4izmjbdBQIblz75A8ihd8pRuA4oP1AITfFrw3vZ4aT/YHi9rAjqVZZyqV3SXUdFB2YH5A4KdaIS/lZCS6Io0VfLrWivL7Y8wycBgEhFCGdQUcLyhl8tqfsWonrzQ+BS/Q9ID4+VndatTZBbSfktN9GvooY46fmHarNz3EQPbREmGcKw6q6i663nng8GCGn7XLQpwFuyUWZvWFTqRXKLhMjAE5bfJd2/ggrBlogJ2cfkQKvbpp3aVcmWFnGfec115sajQeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l7uHkxPJt2cWl5eUNgqjgMLRhoOkQwHsN10wp5ftRRE=;
 b=Y6XKv+nh7pz+8lRT0R4V714A81Rp55GF3L03GQRAeEulDKE6WfMQNyL6dMl3ESwCpSX+CfXs1iPm79Zwlwf2XipVtpOilRM0tkNOczeNkjYo2saxFjWB1bNXpNtG/s5MdnlgndMrKhApPRUMtIIi1S+baqRsxbRtUbUWfM1A3+o=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5883.eurprd04.prod.outlook.com (2603:10a6:10:b1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Sat, 20 Feb
 2021 07:43:34 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.042; Sat, 20 Feb 2021
 07:43:34 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V4 net 3/5] net: stmmac: fix dma physical address of
 descriptor when display ring
Thread-Topic: [PATCH V4 net 3/5] net: stmmac: fix dma physical address of
 descriptor when display ring
Thread-Index: AQHW+uft+uKr8xEA7U2SuzvYUkHYB6pLl6SAgBUjTZA=
Date:   Sat, 20 Feb 2021 07:43:33 +0000
Message-ID: <DB8PR04MB67956B6D0E9BCEC015E57A81E6839@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210204112144.24163-1-qiangqing.zhang@nxp.com>
        <20210204112144.24163-4-qiangqing.zhang@nxp.com>
 <20210206122911.5037db4c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210206122911.5037db4c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b35cf3e8-67b2-4487-3767-08d8d57339d8
x-ms-traffictypediagnostic: DB8PR04MB5883:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB5883BD6A8E9666D96CD9C575E6839@DB8PR04MB5883.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VGPzzNTLHqCoPjmHlAcePE9Q8bwaeGjWWCs4vCEEsxbEqEOPoPEIWWzhubl5iDDsQcFaHJFtv3jT1A8LxvaopHRyMItot02RbhR4auJJOwGc4IMO2NOxi/6orN0RGDKy5XgUs+oBwUWhXvDh9zRIs5XP/ynSrJBhWBY4NM0IKJ/VKPWXcEsOZ2eH98fl0AycFyvCcFrcyyK98/JxBuWivKeJAyAX9WKcwveJzniLefVa8la1OgfdhgsMITtG/HhYIqgpR/vyo0BBhCGhDkcOIKSdYnW0Jri6Gn26bN7X0Qt1YeBi0XUeMJcGKr8YAvANwoaKX9IAcU9NK/I6BX62FxlltWJSvsYbU+K2wre1e6t3lJ78r6bGxc4XjDsMjf0L4XIBUAE99akRPYyXHL/QT8cHhgbdvNChl+Fcp+whaTZEdMMbtdbm5RSQRx1nqEbaRvfTPS2R45rFsuHssRcapvYOXFjSs24NLYeKgKcQOGG9IpE4tNVIFwC6mfkzdX3ULWCAOnr92vMQmTULR9oUCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(376002)(366004)(346002)(86362001)(71200400001)(55016002)(9686003)(26005)(186003)(83380400001)(6506007)(478600001)(53546011)(66476007)(6916009)(4326008)(8676002)(33656002)(316002)(54906003)(66446008)(76116006)(64756008)(7696005)(52536014)(5660300002)(66556008)(66946007)(8936002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?amowc0JWR3lPYkZuTVE4R2RHM1laemZjQzF2TVFTNlJ3K3dHMnFMMnowS3Fr?=
 =?gb2312?B?bXZENm8wVGdZSHhqa1BiUEx6S3c4UFJCOVV4RVRmZDR5dlRNdloraDBJcXZq?=
 =?gb2312?B?MlJKNDdWZDloUVdvUkh2SU9tRFlJcHlGUmQ3clRGdWlLc0xEOU5UNm42dWJK?=
 =?gb2312?B?SHpMWnFMTnNtZW9rU3RndVRneFVGa2xpa0JuU2pTTndMUll4OVNpTUE4SXow?=
 =?gb2312?B?WWtyWWdENTBsbjU3VWFmRGRDbHl5V0JHZm5xbjQ2VDlSalgyVS91T0gwWFhK?=
 =?gb2312?B?SWlTUHp4M3lQbzRsQzZibXNLKzNKUFQrTGtRVjBCKzhjbWQvUGdGZG5DdEZs?=
 =?gb2312?B?V3FqSUNGemFMUFJId1FhMXdGMjIvYThFYmFkVWY0ckFPdlllK1FpQkN5TllZ?=
 =?gb2312?B?ZWRsYWtrRHFabWNsdmxrbGVUY0VBUURjdHZmKzdnQzU2dVljeitic1BJUnR5?=
 =?gb2312?B?TjdueXFxb1M4Y2xoaXZYY1dmaWlMQ05NalhicDRrUE1YcnprTXZ5ZUtxN3hI?=
 =?gb2312?B?OVAwTXFoZ0duTHBaSGtqRGFQUEdXTHlHTmxidXRocHBMQ01HTTdzQmR3U2h3?=
 =?gb2312?B?aTNrcFpuVHdPZkUrVkFFcjZlQ0ZNcVcxbWZTQUdoZlZjcXhlR0ZYVFh4ZzNp?=
 =?gb2312?B?SzBIbHo3QWF5ZmhES0IwODNWdS9JVzJ6dXJ3V0RHVWpQZ1ZDK2ZWMkFVd3oy?=
 =?gb2312?B?cjVKMWZ4bHAyVmJVUW16d2QxTzhzQUtvYllHVEhHVHRBZHF4MnduWVJoTTQ1?=
 =?gb2312?B?a25UQkFmTzJ2UUVoeVJOQjVmU0tUVlNaNEpHZlRCVSs4WTYyVTdNVDlHbVRl?=
 =?gb2312?B?SnNJMlRRdDNKcXdzWGw5WFIxc0lMZ2UyaDJBMW9oV1NrKzhRc1FUKzNaejVG?=
 =?gb2312?B?Vi8rSDZTL2syZ2xqLzNxWUt0Vk1va2U4U2Z4N28xYnMxcnhuZ1NyOU41alQ3?=
 =?gb2312?B?eDM1cWhmRmQrMkMvcVVHTklnVGRaRnVTWC81Uzl2TnFSaUJpY3NkVURZem1J?=
 =?gb2312?B?c2tpYWNrdWZITmt1WDdDK2thM3VPaC85NG5ydGFEbUpGQmdjQXdhRmZHR3Bq?=
 =?gb2312?B?b1JuNnIzRCtZeFUzNHV6QUxyRzAyTklDR2J0MWtqTDljQk1EbzEzUldJajVs?=
 =?gb2312?B?ZVFpbG0wZmpzckJibEZsL2ZqVlE1c0xYQmZNZFc1MWtRbmMvUjcyVUI5MlFa?=
 =?gb2312?B?Mmcya09rQjZJeFhJWWRaNlkvMDNWVXBrMHF0QUJ5Y29HTkJDVUhiQUpwSWxa?=
 =?gb2312?B?Z2FXUy9zRWJOMzhQbDNMZHY5U0s1aXpvMmk5a1h2V2tWV3FuZ2FIakFac3Jq?=
 =?gb2312?B?eW51blBLK2ZjV3QxN2JVRkcyMEkxdjJ1bThGdTlsMWVOaUpQbnVqcUNRNzF3?=
 =?gb2312?B?S1gvTFNiZlowbmlTZEQxcVQvdlArdzh2VHViWjZHTUgzQ2dCOHl0cnVEL1Ft?=
 =?gb2312?B?MW82YzNwaHQvenNSempVb0VBakFSbUI2ODZEVnR5Z0p1bGdTWGw3V1pnMkJ0?=
 =?gb2312?B?QXBtT0JaZ3p6NjhEdHdjdEtUY0R3dlhRWDc2TW45MlJ4eVd1OHdUNU1LSnV2?=
 =?gb2312?B?RHNXcGpqN3o1RFZjTmNnK29kcW5xRUZEVTFDWU1oWkt1bm02OEVxQnQrV0RC?=
 =?gb2312?B?SDZHNlhORlA1dXBkVUVqL21QZmNSSndrbXB1WnU2bWluUEMzWEZESkVzWmVQ?=
 =?gb2312?B?cHQ3Z0Uwc1NYOTVCdXczampQYldEMUJwYmdMQVZqa2NEM0RJU1NFS1ZXSlln?=
 =?gb2312?Q?+uou5xTtBVGAzdeyobqI5mib5WIFVgk0Gtie/PK?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b35cf3e8-67b2-4487-3767-08d8d57339d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2021 07:43:34.0286
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x2HJ0nY1btbDTZzfSQrOH16nfiB6TErQLnSUgX4Ku9CXIgA9ShHB5bhzQPbPwlnevnag4Gj+h15eg1+X0f2L0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5883
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpha3ViIEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IDIwMjHE6jLUwjfI1SA0OjI5DQo+IFRvOiBKb2FraW0g
WmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBDYzogcGVwcGUuY2F2YWxsYXJvQHN0
LmNvbTsgYWxleGFuZHJlLnRvcmd1ZUBzdC5jb207DQo+IGpvYWJyZXVAc3lub3BzeXMuY29tOyBk
YXZlbUBkYXZlbWxvZnQubmV0OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiBkbC1saW51eC1p
bXggPGxpbnV4LWlteEBueHAuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFY0IG5ldCAzLzVd
IG5ldDogc3RtbWFjOiBmaXggZG1hIHBoeXNpY2FsIGFkZHJlc3Mgb2YNCj4gZGVzY3JpcHRvciB3
aGVuIGRpc3BsYXkgcmluZw0KPiANCj4gT24gVGh1LCAgNCBGZWIgMjAyMSAxOToyMTo0MiArMDgw
MCBKb2FraW0gWmhhbmcgd3JvdGU6DQo+ID4gRHJpdmVyIHVzZXMgZG1hX2FsbG9jX2NvaGVyZW50
IHRvIGFsbG9jYXRlIGRtYSBtZW1vcnkgZm9yIGRlc2NyaXB0b3JzLA0KPiA+IGRtYV9hbGxvY19j
b2hlcmVudCB3aWxsIHJldHVybiBib3RoIHRoZSB2aXJ0dWFsIGFkZHJlc3MgYW5kIHBoeXNpY2Fs
DQo+ID4gYWRkcmVzcy4gQUZBSUssIHZpcnRfdG9fcGh5cyBjb3VsZCBub3QgY29udmVydCB2aXJ0
dWFsIGFkZHJlc3MgdG8NCj4gPiBwaHlzaWNhbCBhZGRyZXNzLCBmb3Igd2hpY2ggbWVtb3J5IGlz
IGFsbG9jYXRlZCBieSBkbWFfYWxsb2NfY29oZXJlbnQuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiANCj4gV2hhdCBkb2Vz
IHRoaXMgcGF0Y2ggZml4PyBUaGVvcmV0aWNhbGx5IGluY29ycmVjdCB2YWx1ZSBpbiBhIGRlYnVn
IGR1bXAgb3IgYXJlDQo+IHlvdSBhY3R1YWxseSBvYnNlcnZpbmcgaW5jb3JyZWN0IGJlaGF2aW9y
Pw0KDQpIaSBKYWt1YiwNCg0KU29ycnkgZm9yIGxhdGUgcmVzcG9uc2Ugc2luY2UgSSBhbSBvbiBo
b2xpZGF5LiANCkl0IGlzIGluY29ycmVjdCB2YWx1ZSBpbiBhIGRlYnVnIGR1bXAuIFdoZW4gSSBk
ZWJ1ZyBETUEgaXNzdWUsIEkgZm91bmQgdGhlIGRlc2NyaXB0b3IgYWRkcmVzcyBpcyBpbmNvcnJl
Y3QsIHdoaWNoIGNvdWxkIGJlIGluZGljYXRlZCBieSBoYXJkd2FyZSByZWdpc3Rlci4NCkNvcnJl
Y3QgZGVzY3JpcHRvciBhZGRyZXNzIGNvdWxkIGhlbHAgdXNlIGxvY2F0ZSB0aGF0IHdoaWNoIGlz
IHRoZSBpc3N1ZSBkZXNjcmlwdG9yLCBhbmQgdGhlbiBjb3VsZCBmdXJ0aGVyIGRlYnVnLg0KDQo+
ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFj
NF9kZXNjcy5jDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9kd21h
YzRfZGVzY3MuYw0KPiA+IGluZGV4IGM2NTQwYjAwM2I0My4uNmY5NTFhZGM1ZjkwIDEwMDY0NA0K
PiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjNF9kZXNj
cy5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvZHdtYWM0
X2Rlc2NzLmMNCj4gPiBAQCAtNDAyLDcgKzQwMiw4IEBAIHN0YXRpYyB2b2lkIGR3bWFjNF9yZF9z
ZXRfdHhfaWMoc3RydWN0IGRtYV9kZXNjDQo+ICpwKQ0KPiA+ICAJcC0+ZGVzMiB8PSBjcHVfdG9f
bGUzMihUREVTMl9JTlRFUlJVUFRfT05fQ09NUExFVElPTik7DQo+ID4gIH0NCj4gPg0KPiA+IC1z
dGF0aWMgdm9pZCBkd21hYzRfZGlzcGxheV9yaW5nKHZvaWQgKmhlYWQsIHVuc2lnbmVkIGludCBz
aXplLCBib29sDQo+ID4gcngpDQo+ID4gK3N0YXRpYyB2b2lkIGR3bWFjNF9kaXNwbGF5X3Jpbmco
dm9pZCAqaGVhZCwgdW5zaWduZWQgaW50IHNpemUsIGJvb2wgcngsDQo+ID4gKwkJCQlkbWFfYWRk
cl90IGRtYV9yeF9waHksIHVuc2lnbmVkIGludCBkZXNjX3NpemUpDQo+ID4gIHsNCj4gPiAgCXN0
cnVjdCBkbWFfZGVzYyAqcCA9IChzdHJ1Y3QgZG1hX2Rlc2MgKiloZWFkOw0KPiA+ICAJaW50IGk7
DQo+ID4gQEAgLTQxMCw4ICs0MTEsOCBAQCBzdGF0aWMgdm9pZCBkd21hYzRfZGlzcGxheV9yaW5n
KHZvaWQgKmhlYWQsDQo+IHVuc2lnbmVkIGludCBzaXplLCBib29sIHJ4KQ0KPiA+ICAJcHJfaW5m
bygiJXMgZGVzY3JpcHRvciByaW5nOlxuIiwgcnggPyAiUlgiIDogIlRYIik7DQo+ID4NCj4gPiAg
CWZvciAoaSA9IDA7IGkgPCBzaXplOyBpKyspIHsNCj4gPiAtCQlwcl9pbmZvKCIlMDNkIFsweCV4
XTogMHgleCAweCV4IDB4JXggMHgleFxuIiwNCj4gPiAtCQkJaSwgKHVuc2lnbmVkIGludCl2aXJ0
X3RvX3BoeXMocCksDQo+ID4gKwkJcHJfaW5mbygiJTAzZCBbMHglbGx4XTogMHgleCAweCV4IDB4
JXggMHgleFxuIiwNCj4gPiArCQkJaSwgKHVuc2lnbmVkIGxvbmcgbG9uZykoZG1hX3J4X3BoeSAr
IGkgKiBkZXNjX3NpemUpLA0KPiA+ICAJCQlsZTMyX3RvX2NwdShwLT5kZXMwKSwgbGUzMl90b19j
cHUocC0+ZGVzMSksDQo+ID4gIAkJCWxlMzJfdG9fY3B1KHAtPmRlczIpLCBsZTMyX3RvX2NwdShw
LT5kZXMzKSk7DQo+ID4gIAkJcCsrOw0KPiANCj4gV2h5IGRvIHlvdSBwYXNzIHRoZSBkZXNjX3Np
emUgaW4/IFRoZSB2aXJ0IG1lbW9yeSBwb2ludGVyIGlzIGluY3JlbWVudGVkIGJ5DQo+IHNpemVv
ZigqcCkgc3VyZWx5DQo+IA0KPiAJZG1hX2FkZHIgKyBpICogc2l6ZW9mKCpwKQ0KDQpJIHRoaW5r
IHdlIGNhbid0IHVzZSBzaXplb2YoKnApLCBhcyB3aGVuIGRpc3BsYXkgZGVzY3JpcHRvciwgb25s
eSBkbyAiIHN0cnVjdCBkbWFfZGVzYyAqcCA9IChzdHJ1Y3QgZG1hX2Rlc2MgKiloZWFkOyIsIGJ1
dCBkcml2ZXIgY2FuIHBhc3MgInN0cnVjdCBkbWFfZGVzYyIsICIgc3RydWN0IGRtYV9lZGVzYyIg
b3IgIiBzdHJ1Y3QgZG1hX2V4dGVuZGVkX2Rlc2MiLA0Kc28gaXQncyBuZWNlc3NhcnkgdG8gcGFz
cyBkZXNjX3NpemUgdG8gY29tcGF0aWJsZSBhbGwgY2FzZXMuDQogDQo+IHdvdWxkIHdvcmsgY29y
cmVjdGx5PyBBbHNvIHBsZWFzZSB1c2UgdGhlIGNvcnJlY3QgcHJpbnQgZm9ybWF0IGZvciBkbWFf
YWRkcl90LA0KPiB5b3Ugc2hvdWxkbid0IGhhdmUgdG8gY2FzdC4NCg0KT0ssIEkgd2lsbCBjaGFu
Z2UgdG8gdXNlICIlcGFkIiBmb3IgZG1hX2FkZHJfdC4NCg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2Fr
aW0gWmhhbmcNCg==
