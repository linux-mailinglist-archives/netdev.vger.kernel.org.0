Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331453050E6
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238967AbhA0EaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:30:06 -0500
Received: from mail-eopbgr140080.outbound.protection.outlook.com ([40.107.14.80]:5525
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405026AbhA0BcA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 20:32:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZcsE+icsrnFl8LET6wvYlQtANT/D9fsWJFXvBfHiZpSPgEsDSotizFsd2/tcOe74B+1AksLcgQLFRe9c8xVnmjmZN3usBDwaBGaWGsxHxbZctwVmGQiAYr8JpfEEmxZVeEnvZJyX/Gy35wGAEoiIpO5wlhU9FX6jiJFgyJigf1trFcyCF4ojcOkvrng2rwmUqHhCgTfGeMAelyncAK7hzB9sDwbd+YNzmqOkoWdemVeMld3jeLnCPVShjhhSYIRPHhkLXGJ7636WV6HXc/9n17CeKRwYVcf0l8s3ssfzGNEgWoRcR8jOn3CZGfSuLBGmaGaycG3xZIfeXEgtaFluQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FEf54uQeWqsJv2yhaYLAJCn4Qib4I++CAdZJFCbqLL8=;
 b=Gv3g+Oe1Np3bJ9uBHfpS3Di7OTx+3Jj/0dxbaGP5wrA70JfcvkYGErhjmK1NEUneEbENvxxFMQsVHKjj/M//RKIybs8vZFILRdNyn6dbfOMk7bDxdGequ14RpMnrw2I9joLJEjTe2THI3DAQRYbC5h/wPgEDRkR+65jqQ0kdL/8AYePFPEHz/I45Eb8FxorGirjWiASQBADDtjgEReauoHJ7RJ7pCUl36JSS/LlpJDZIN1woFdkddsnOuml5bj0RQs2VcZrT1nEYOGCHpyHkmMjLSnAAkzbKINr144ad7L7b0ZLJOZDihsKgDfd2pCUHS4358IT068SIXAsLWPbQyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FEf54uQeWqsJv2yhaYLAJCn4Qib4I++CAdZJFCbqLL8=;
 b=pPwitF1hH/PU8Cy5evr+w4Z+vK1LFKuzMpu7MSeRsVt+UY5iZORXdd4RY/OkfijPZ/pCCdPaP/d+Rx5c3900pKojCkIcesbNxlndfQoGkF9vUWnApdCvhG7pABG+Nli6kfs9Q74/W5y7p1YaQPKz6R/jOxttRVgmTaMQJL7qqwc=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6346.eurprd04.prod.outlook.com (2603:10a6:10:10c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Wed, 27 Jan
 2021 01:30:59 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920%3]) with mapi id 15.20.3805.017; Wed, 27 Jan 2021
 01:30:59 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: RE: [PATCH V3 1/6] net: stmmac: remove redundant null check for ptp
 clock
Thread-Topic: [PATCH V3 1/6] net: stmmac: remove redundant null check for ptp
 clock
Thread-Index: AQHW89q4ejRyIZ/fz0O9/wDN0TPK2Ko6gnIAgAArb9A=
Date:   Wed, 27 Jan 2021 01:30:58 +0000
Message-ID: <DB8PR04MB67953865C100029E0088CE69E6BB0@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210126115854.2530-1-qiangqing.zhang@nxp.com>
 <20210126115854.2530-2-qiangqing.zhang@nxp.com>
 <CAF=yD-J-WDY6GPP-4B-9v78wJf3yj6vrqhHnbyhg1kx6Wc1yHg@mail.gmail.com>
In-Reply-To: <CAF=yD-J-WDY6GPP-4B-9v78wJf3yj6vrqhHnbyhg1kx6Wc1yHg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9eac10d9-a1c8-4ecc-21c3-08d8c2633341
x-ms-traffictypediagnostic: DB8PR04MB6346:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB6346455E1876F2CD1F54958DE6BB0@DB8PR04MB6346.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 416AkQcxzg2dZClQKWrDM5Z3J7BOM9QJKwxaELQ7QP1e5uVUXQcy2SLGc0hHCXpCOWBFADmJz8S5xZt3I+BohF+te9zWKAsdOBX7nMLydxdcA5pbUu/u/b5WjlYoeyF9pf2Uw6D7L0AbMtz6XaZMKpjRoOxSelBZfMUMEs7w56dt8BeojQ124RzWcFdJ2L0+42QN9hDY8gAO1+URoS0PJrVidUAqdtTNeskYBi654aWGt4v4EUSBzWYHY2Oi0ICdZtA7iS7J2oGfivxofY1G77fex75Soa4Ri4sg+5vDe6x2BTvO0aNUZyFRSWZoNBAdfIJ2jZcZQrq4tfUXjsv9PUmLwixgmxsGHeJWbXj23i6LYiYGWo3NUnxcIk4HarioKxJxXq3PqGMWH5sYctwYdBNY0WyqdHrcQL6Absadgs9mb8wGUjBwj8+SVriMRD/OWxI52N9pgfoUQxRF4/tiyn2B3gVE9aee6bt7HkOn4zgjT0i0bQfPILu/IaxEeQ7PIDlxv7BMoPPKavjhHaupzQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(6916009)(64756008)(66446008)(66556008)(66946007)(7696005)(8936002)(26005)(4326008)(66476007)(9686003)(52536014)(6506007)(76116006)(71200400001)(186003)(33656002)(53546011)(86362001)(83380400001)(5660300002)(316002)(54906003)(2906002)(478600001)(55016002)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?b1pEejlOTW44Y1UwWjcwV2lPcnROdWwzVnZBUlMyZ3crTzMvcm96WTd6UUhT?=
 =?utf-8?B?WVUwR2hMVmFuK2xNU1NoNE5BVEg3b21EWmNaeFkzSmUrRXJ1N2FTS285UW82?=
 =?utf-8?B?dndBU0JCNGJrQW0xS2J4UkZ4dVB5NnJCQ1ZPc0Ezclh1eDJZME04WUY2SFdx?=
 =?utf-8?B?VVJtU29sV3VOdW9lWGRZNkpLYVVwL3dRWjdKdDA3dm11b3p4SGhDN2xEbUdm?=
 =?utf-8?B?OXhVK29BZVdkK21seGtlemhEM0VMN2s1eW9nR01ISXhqemxlK1lueG1icHFO?=
 =?utf-8?B?NEZSQjRxM1RwT1ZuUTU5L09iUlp4bjJ4aEgyZVEvSnFDTmQ4SitpcXFHUUph?=
 =?utf-8?B?OEJNaTNVekhrU2o1eERrU2hhSXp0SXNoYVlZVEVMZWJmZnlBUWQ4Y2xLR3lP?=
 =?utf-8?B?WDRkbGFXTDlJelZtN0pKZ3M2M2VCNDZ5QytyZEZ6d3FuQ3NCT0lOdDlXVnZ3?=
 =?utf-8?B?dlJyV0FPcVBNREp0MkRaUHhZK2YxTnl1c212YXBFeEs3VGRZeGsyTVdHbSsv?=
 =?utf-8?B?eC9EMWZrL3NEZ0thVDIvTUVqcGhaQ25iaUMralZrbHZoTGNKNWI4VHNTR2dI?=
 =?utf-8?B?WUx6TkF2Z0tXV09Tb25IeEFlR3pISWdNSWhDY2pFaUwxS1E5NzBNMmtKK1d2?=
 =?utf-8?B?ZEVPRCt0ZG9pTW5YSGdUUUxPc3JwYmplL3V1NExXR0Z4bXBGYjZvY0gyNjl2?=
 =?utf-8?B?aFh1QnFjNVdjUUVuRk1LLzdNeUU4a2ZOUm42MG1OSXVOd0Y0RDZSaGkwRExm?=
 =?utf-8?B?ZHVyeTFCOVVyMFJ5U2pid1lteVVVNWpoYjdSNXhoYVZ5NHhYeEVoclNhRk44?=
 =?utf-8?B?dzg2VksrejlVZDJWN2dRWDBYSk9oUlFjUFpNOHh4cGpuUzJUcE9oVjh2ZWda?=
 =?utf-8?B?bkZmRVk2dDB4U0dPdDB5Z29aZE44bDRrZU5xUzRoaVRnWHBuR2E3VXNKaFMr?=
 =?utf-8?B?S2R4RVQ1NWZCSDF5U2h3WXZZa0FaT3pUcU1ZQXVZWUtVbStIK1gweXExRXRz?=
 =?utf-8?B?eG9LS21BUUdEeW12T3dubjlMa08rbzhndUlxVnRaQVJkZ0VvN25wZkxxekVq?=
 =?utf-8?B?ZHptc2Z6OXIzQ2hQcU1xZTFMWldJOFhHTDI1OFlXYXMxTERnOFpoR3VuY0N5?=
 =?utf-8?B?WWVvVFpQSHhZeVZNMEZGdldFb0l6eTBLK3RXUC9zTklwT3Zwa1FQUzU5WnZv?=
 =?utf-8?B?SUVZblJCcUhxRldJRnVHdXRNd2xtTE5VWFFyWWhkN3R1cnFWemtkRkNBbTR6?=
 =?utf-8?B?cmFicEp0eDZ1RFF0KzhxT1ZQcklaWkhYRlVtV2FidjgxV1NQR3RoR215Ykcr?=
 =?utf-8?B?M0lIQTk0ZXJ4ei9PSGp0OHlzcDBtMEllQkhBVDRuNFJNYXREY2x0T25jK3pG?=
 =?utf-8?B?R0NBRlFFNXUzMExzbjdKYUs1S2hHa2pvMkVmWFFUVFFaRFJ6OXlYUzRwdjhR?=
 =?utf-8?Q?5jAEwjFa?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eac10d9-a1c8-4ecc-21c3-08d8c2633341
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 01:30:58.9317
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t5J6F3nNZgGVX6UarNdzeWCB5+fZ/9Bh5YvmWWQvwMVZ/boHs56vqMbk9Et6rprtdrZO9vnZ3rD1Y5//9zUAtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6346
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFdpbGxlbSBkZSBCcnVpam4g
PHdpbGxlbWRlYnJ1aWpuLmtlcm5lbEBnbWFpbC5jb20+DQo+IFNlbnQ6IDIwMjHlubQx5pyIMjfm
l6UgNjo0Ng0KPiBUbzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4g
Q2M6IEdpdXNlcHBlIENhdmFsbGFybyA8cGVwcGUuY2F2YWxsYXJvQHN0LmNvbT47IEFsZXhhbmRy
ZSBUb3JndWUNCj4gPGFsZXhhbmRyZS50b3JndWVAc3QuY29tPjsgSm9zZSBBYnJldSA8am9hYnJl
dUBzeW5vcHN5cy5jb20+OyBEYXZpZA0KPiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBK
YWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgTmV0d29yaw0KPiBEZXZlbG9wbWVudCA8
bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+
Ow0KPiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+OyBGbG9yaWFuIEZhaW5lbGxpIDxmLmZh
aW5lbGxpQGdtYWlsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBWMyAxLzZdIG5ldDogc3Rt
bWFjOiByZW1vdmUgcmVkdW5kYW50IG51bGwgY2hlY2sgZm9yIHB0cA0KPiBjbG9jaw0KPiANCj4g
T24gVHVlLCBKYW4gMjYsIDIwMjEgYXQgNzowNSBBTSBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56
aGFuZ0BueHAuY29tPg0KPiB3cm90ZToNCj4gPg0KPiA+IFJlbW92ZSByZWR1bmRhbnQgbnVsbCBj
aGVjayBmb3IgcHRwIGNsb2NrLg0KPiA+DQo+ID4gRml4ZXM6IDFjMzVjYzljZjZhMCAoIm5ldDog
c3RtbWFjOiByZW1vdmUgcmVkdW5kYW50IG51bGwgY2hlY2sgYmVmb3JlDQo+ID4gY2xrX2Rpc2Fi
bGVfdW5wcmVwYXJlKCkiKQ0KPiANCj4gVGhpcyBkb2VzIG5vdCBsb29rIGxpa2UgYSBmaXggdG8g
dGhhdCBwYXRjaCwgYnV0IGFub3RoZXIgaW5zdGFuY2Ugb2YgYSBjbGVhbnVwLg0KPiANCj4gVGhl
IHBhdGNoc2V0IGFsc28gZG9lcyBub3QgZXhwbGljaXRseSB0YXJnZXQgbmV0IChmb3IgZml4ZXMp
IG9yIG5ldC1uZXh0IChmb3IgbmV3DQo+IGltcHJvdmVtZW50cykuIEkgc3VwcG9zZSB0aGlzIHBh
dGNoIHRhcmdldHMgbmV0LW5leHQuDQoNCkkgZm9yZ290IHRvIGV4cGxpY2l0bHkgdGFyZ2V0IGFz
IG5ldCB3aGVuIGZvcm1hdCB0aGUgcGF0Y2ggc2V0IGFnYWluLiBUaGlzIGNvdWxkIGJlIGEgZml4
IGV2ZW4gb3JpZ2luYWwgcGF0Y2goMWMzNWNjOWNmNmEwKSBkb2Vzbid0IGJyZWFrIGFueXRoaW5n
LCBidXQgaXQgZGlkbid0IGRvIGFsbCB0aGUgd29yayBhcyBjb21taXQgbWVzc2FnZSBjb21taXQu
DQpUaGlzIHBhdGNoIHRhcmdldHMgbmV0IG9yIG5ldC1uZXh0LCB0aGlzIG1hdHRlciBkb2Vzbid0
IHNlZW0gdG8gYmUgdGhhdCBpbXBvcnRhbnQuIElmIGl0IGlzIG5lY2Vzc2FyeSwgSSBjYW4gcmVw
b3N0IGl0IG5leHQgdGltZSBhcyBhIHNlcGFyYXRlIHBhdGNoIGZvciBuZXQtbmV4dC4gVGhhbmtz
Lg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gPiBSZXZpZXdlZC1ieTogQW5kcmV3
IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEpvYWtpbSBaaGFuZyA8
cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMgfCAzICstLQ0KPiA+ICAxIGZpbGUgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKyksIDIgZGVsZXRpb25zKC0pDQo+ID4NCj4gPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX21haW4uYw0KPiA+
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX21haW4uYw0KPiA+
IGluZGV4IDI2Yjk3MWNkNGRhNS4uMTFlMGIzMGIyZTAxIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMNCj4gPiArKysgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jDQo+ID4gQEAg
LTUyOTEsOCArNTI5MSw3IEBAIGludCBzdG1tYWNfcmVzdW1lKHN0cnVjdCBkZXZpY2UgKmRldikN
Cj4gPiAgICAgICAgICAgICAgICAgLyogZW5hYmxlIHRoZSBjbGsgcHJldmlvdXNseSBkaXNhYmxl
ZCAqLw0KPiA+ICAgICAgICAgICAgICAgICBjbGtfcHJlcGFyZV9lbmFibGUocHJpdi0+cGxhdC0+
c3RtbWFjX2Nsayk7DQo+ID4gICAgICAgICAgICAgICAgIGNsa19wcmVwYXJlX2VuYWJsZShwcml2
LT5wbGF0LT5wY2xrKTsNCj4gPiAtICAgICAgICAgICAgICAgaWYgKHByaXYtPnBsYXQtPmNsa19w
dHBfcmVmKQ0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgIGNsa19wcmVwYXJlX2VuYWJsZShw
cml2LT5wbGF0LT5jbGtfcHRwX3JlZik7DQo+ID4gKyAgICAgICAgICAgICAgIGNsa19wcmVwYXJl
X2VuYWJsZShwcml2LT5wbGF0LT5jbGtfcHRwX3JlZik7DQo+ID4gICAgICAgICAgICAgICAgIC8q
IHJlc2V0IHRoZSBwaHkgc28gdGhhdCBpdCdzIHJlYWR5ICovDQo+ID4gICAgICAgICAgICAgICAg
IGlmIChwcml2LT5taWkpDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgc3RtbWFjX21kaW9f
cmVzZXQocHJpdi0+bWlpKTsNCj4gPiAtLQ0KPiA+IDIuMTcuMQ0KPiA+DQo=
