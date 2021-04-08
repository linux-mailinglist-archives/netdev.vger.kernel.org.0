Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED29D357C7D
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 08:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhDHGVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 02:21:49 -0400
Received: from mail-db8eur05on2065.outbound.protection.outlook.com ([40.107.20.65]:10241
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229687AbhDHGVs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 02:21:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6+iBYzqbvQ00AFSaY1iiaAPl0Tm5/X2mHF4yGRrzxYp3cRcIhDZ2SbJMJ9XjOw+9+8qdqBwQlAZDaPLV50ctHguwSIaoVgTP8LY9dCoCMykFobnp8aa+xzJOPWUUJE/TQc+c3I/h33XxYDkt0L+ifbglWrsaqDzhZURS/pe4eGF05KyLs7pomnPWG01s0HQS1oXvi3sBzoeRHUDMYmjgu755FGnKHNBKFm1mc2Bf+CWvOLlSBnrsJj2ariuqGzP/QE4MKCFXxZq5SkRKTcDsZgcu6sO4ghMNF8RBKOHNMvhHra3lKnDzjqaq+V88MzIjsIWfKGpDy8p9kzzNY04pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EkNjcQ9GHBoHnk75IS6eNDi/K8zT9+OBh0A+XF0jAfI=;
 b=HWYv4eKFGupbPYNw2V3M/tSm/dEycTCPmJzq6lxHj0G5uNhNiEqc48f0S+ROuL1w0uwxaGsURTslS1roH4EWZ+U38NHAJKqx5wTIixKDVWgY5HOVh0uriWoyIL8fXKRLv2Ns9VMKWxtz4Uu1v+LHbjnjDY78BGkcFwIX3fhPC6vR3yAfMLMjlx/fk7HDwb1RSOIlfEjHSc2aFL8vmzyYXOPcBzuo/XlqUzq0ofd2apK24WNivHIzAtNCZ1FwkM1TsOYZwCwtAmgCoWeIbf2WdtZ47pXPXcFEA/l90EFqYU3ufqFEj8ZofWLbsXjfTvDigdxQtiAAwDB2UXBBeuBtRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EkNjcQ9GHBoHnk75IS6eNDi/K8zT9+OBh0A+XF0jAfI=;
 b=FQCjP1ZO7wfAcSjAHZW52djYPY/ncfiLn+lHdZdRG33zwdhgP/W4xF+Zty+dfXxTVOE/9C7soK1I+C2NRSwLzLHTJ+uJEVGjBLCS2MSL65UyqFUKOs8ocqmW3TD9EcUNuI/abi3dVsAveIbHMsMWhw8ACnRj5BXsB6FjS5BpuIM=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2726.eurprd04.prod.outlook.com (2603:10a6:4:94::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Thu, 8 Apr
 2021 06:21:35 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.4020.017; Thu, 8 Apr 2021
 06:21:35 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Fugang Duan <fugang.duan@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 2/3] net: fec: use mac-managed PHY PM
Thread-Topic: [PATCH net-next 2/3] net: fec: use mac-managed PHY PM
Thread-Index: AQHXK8Y/eghzBz30zU6atrIS44hsGqqqHHfAgAAEqgCAAARLYA==
Date:   Thu, 8 Apr 2021 06:21:35 +0000
Message-ID: <DB8PR04MB679538D39673F03F399F8F20E6749@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <9e695411-ab1d-34fe-8b90-3e8192ab84f6@gmail.com>
 <a34e3ad6-21a8-5151-7beb-5080f4ac102a@gmail.com>
 <DB8PR04MB679540FF95A7B05931830A30E6749@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <d47a3d9f-a9cf-4765-9ee8-19ebb9155150@gmail.com>
In-Reply-To: <d47a3d9f-a9cf-4765-9ee8-19ebb9155150@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1817164f-cba6-402c-0f83-08d8fa568fae
x-ms-traffictypediagnostic: DB6PR0402MB2726:
x-microsoft-antispam-prvs: <DB6PR0402MB2726E3DB89A08CFC88BC0C44E6749@DB6PR0402MB2726.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E0/IHQPwaXgBo0yxxGbHoUSABCQWyzjK62y0qzuxd0JXZKH2Lmj/0+s+HS67cYkXbXGh+JlCy2ai/m9E5VCaZdMMjnvlAxChZkf9ds3Lg6GRDLnArCrf+j4psVekSUIkDFQ+qxOcVC9gJAU0U1e0iaqzh6w20yF0zidBo9Ql8lw4LfmX5lYrenI8fGJKioiMsaKG3Wcx1d+qO5tJt5EBtFI5CGPoUQgw84zhNIVa0jejf3hX8jxBMejx+bXL9pct4ObrotB5Qj3PI9NR/gNusquP6fvfOhmW2T9j8Ebj0y1GjXP0y7vnOKXXrfUQxfi498mFS0vJMXAs8kh8am+kDt2Ah8NCLl6JtgPfbJ9iFHfNQonJMDLj41+rI/0j95aYzdg4RIKyCOMxdB8nG5DCZN+/0AJz+/ftYtyb1U3wt1wz3dSnEoqmE8LoprfBO5Jq1BveZjDOBISixzlUfsZsUjIvWKjFsFRqtV0x/ygxJ4xm7znp8C61ITGWIzhDn1EOVhbcWnjpXX04Z6ICYpu4pFQ1MpIgGa6kTAkBEzyIJjZZ3KmuN8Zh7Ao5hV+9oKq3PwYJEIWEQdcxgOb6294sQUZELygj12apmlCLWiFTXnYnUXuuiwMukoA/JYXAGH998FymstN5QSgGOdSwn0vRttBUq0W0cMfKQH/0mB2XzVo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(39860400002)(366004)(136003)(5660300002)(71200400001)(7696005)(26005)(52536014)(4326008)(8676002)(110136005)(9686003)(8936002)(53546011)(186003)(316002)(6506007)(6636002)(478600001)(55016002)(66446008)(38100700001)(66946007)(66476007)(66556008)(83380400001)(33656002)(76116006)(86362001)(2906002)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?RG5TOFRCTm9TTHM3T2htVzN0LzdsTjlqSW1HbTkrWnpRbVBmc0U1dG9EbGZk?=
 =?utf-8?B?WU9WcE10MlhwY1l0TytpQ3NobGxLd0sxME5WN1dOUFJRcTZSMzFBK1RJdTI2?=
 =?utf-8?B?dUt6T0FJZ1pIN0QwT2dCcTZzdld2cmhLamp0aXZuQlZLR1dOSHRoTytPRktO?=
 =?utf-8?B?eUM3S3NWWXVrVy9udU9OTWQ3RUsvVUJHWHdyaVRpajJ2Y2ZqZ3FRS24yUDFt?=
 =?utf-8?B?cEVGWFdrNjV0VmtMVWdOdEllbHh2YkJKcVJpTW9ZZEhxYithM3JIdjZxdVdY?=
 =?utf-8?B?KzFLVThNSUtJQmMxSDZSQ0x5ZUJRdzBVSkhKbDJPMW9SL2dqYWgwQXZkNCs5?=
 =?utf-8?B?Y29lM05zNmRyeHdBMk5rVWpXazFrUTlZcndMdytmTVc1ekhZMDNoN3MvNDVJ?=
 =?utf-8?B?cDE5SXAzV3c5ajkxUTYvOFBHVHdOZDdkMTk5cE1vK0hhRnlHSUtLRG9UZmE3?=
 =?utf-8?B?cG5xbEFxaDVVSHdOTVpjMGV2SDBkSzJEbFpUbE1hckZzMU8xYTZwN3oxZUM5?=
 =?utf-8?B?Tk8zMU5KNW9rTzZoNk9RRjJFN0tRV2lwRGxOdkVGTHdUZVZnem0yYzEvMlZs?=
 =?utf-8?B?Z1NsZjZZYW9lUGRIcWxZU0ZHbHFEU3EyOTV0SkxZOHExS0w5aHNFdFA3Lzlm?=
 =?utf-8?B?VnJjanZHYi9GNW44QkF2dFV2UFFrNzNrKzVHeUl2MG5ncHNKaUI3Y2IwMUdq?=
 =?utf-8?B?OStWcEZJQTlsODUyM1REL2k5dFBQRWNpWkU1MUs2dFU2Tm1OTXVNZDVVNG0r?=
 =?utf-8?B?MU8rK3pYc3AxTk5CbGNWMG1ISEJOZ3VYaFVTbVErKzV3ZjlqWXJndkRwd3dM?=
 =?utf-8?B?Q3g2akw3T2NyR1RGZXRwSTYzWDZmZ2p6VW1ES2g1RnhLaTVIcDBKUDZqMFp0?=
 =?utf-8?B?OEU3WVNRZW0wQlJodm1oTHhJSTdwMmFZTDJwOW5LMHZBWVVibk54S1QvSC8y?=
 =?utf-8?B?R0YxcmhuU2kyM3BuVzYrZkZRKzZQSFo2NkJPYm92alF1RWpMeDc3RDlveFNY?=
 =?utf-8?B?WmFsM3QrK2RrQTZCUUdIb0JmRjJNd3BWQUh5WkdwN1JxdlNOOW50TmNYa1ZS?=
 =?utf-8?B?ZzBBa3pUUmFJUVFJUDBzUDZBaHJ6STZYY2NpSzhZYWlKaVBIOWFvRzVkS2c0?=
 =?utf-8?B?YTJ0SnFKRkY2OHdmZVlFZ2d5WURMU0YvQnRoYzBkZzNQTXhuUXBGc3pURGdh?=
 =?utf-8?B?WXBaR0kreTd5d2lXSlFhTm13L3R6dEVRdDFReHlRYUNFSjAxdGY0Smxtems3?=
 =?utf-8?B?K1hJZzJZVmRrTFhKdExZQ0wwWWlHODZpVVltK2VzWGN4T3hoTzBNVys4Tjkx?=
 =?utf-8?B?UzNGRkVZUGZSSFQ3dWtYbjc2dTN4ckxhOTVKaHd3U0x2elBGQzU1UzBqc2hK?=
 =?utf-8?B?R0hGaklKbWJRR2xESUtuNmlzbGcxTDZWQWhYNk4zZVUySUxKT25oa1lGL05Z?=
 =?utf-8?B?TTJXa0FJUG9WVTBvekdKdDRlb0ZXU0RTQStGbjNGbGJEeHkrYUZoWmcrdkdF?=
 =?utf-8?B?M2h5ZndHVjZWbjZiYUc4SlQyYllSdmFHTUxjTWY3NmtteEh1cFgzWU9Cb1I1?=
 =?utf-8?B?MlVrT3kya1FEV2g4aUZUQiszYmd6WjY5VEhualZIcG1vNXlWQ2RZZUw5MVB6?=
 =?utf-8?B?dU1jMUJuMW9SY1FvVXdCTXlXVyticVBLM0xFMEl6RS80ZEJiU3htRmRSSzVY?=
 =?utf-8?B?UzY2UCtCRHBOaFdZM0dCNXl1WnJXN2M0aDcvVVlOQWdRODVTK0VBaXA1NnlZ?=
 =?utf-8?Q?+03DCQovIeX/YkueGpgBKt5m0h8gHRS9HlgC8WV?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1817164f-cba6-402c-0f83-08d8fa568fae
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2021 06:21:35.6978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cx4i91vT8Qtnr7YAt1bg8Nt4VkivOGGddodu5/HbcGhuLhTLi6EZqknDJIG8vo+X0qPwORWR6001lrnmmCI1wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2726
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEhlaW5lciBLYWxsd2VpdCA8
aGthbGx3ZWl0MUBnbWFpbC5jb20+DQo+IFNlbnQ6IDIwMjHlubQ05pyIOOaXpSAxNDowMA0KPiBU
bzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT47IEFuZHJldyBMdW5uDQo+
IDxhbmRyZXdAbHVubi5jaD47IFJ1c3NlbGwgS2luZyAtIEFSTSBMaW51eCA8bGludXhAYXJtbGlu
dXgub3JnLnVrPjsgSmFrdWINCj4gS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IERhdmlkIE1p
bGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEZ1Z2FuZw0KPiBEdWFuIDxmdWdhbmcuZHVhbkBu
eHAuY29tPg0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BB
VENIIG5ldC1uZXh0IDIvM10gbmV0OiBmZWM6IHVzZSBtYWMtbWFuYWdlZCBQSFkgUE0NCj4gDQo+
IE9uIDA4LjA0LjIwMjEgMDc6NDUsIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPg0KPiA+PiAtLS0t
LU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBIZWluZXIgS2FsbHdlaXQgPGhrYWxs
d2VpdDFAZ21haWwuY29tPg0KPiA+PiBTZW50OiAyMDIx5bm0NOaciDfml6UgMjM6NTMNCj4gPj4g
VG86IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IFJ1c3NlbGwgS2luZyAtIEFSTSBMaW51
eA0KPiA+PiA8bGludXhAYXJtbGludXgub3JnLnVrPjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2Vy
bmVsLm9yZz47IERhdmlkDQo+ID4+IE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEZ1Z2Fu
ZyBEdWFuIDxmdWdhbmcuZHVhbkBueHAuY29tPg0KPiA+PiBDYzogbmV0ZGV2QHZnZXIua2VybmVs
Lm9yZzsgSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gPj4gU3ViamVj
dDogW1BBVENIIG5ldC1uZXh0IDIvM10gbmV0OiBmZWM6IHVzZSBtYWMtbWFuYWdlZCBQSFkgUE0N
Cj4gPj4NCj4gPj4gVXNlIHRoZSBuZXcgbWFjX21hbmFnZWRfcG0gZmxhZyB0byB3b3JrIGFyb3Vu
ZCBhbiBpc3N1ZSB3aXRoIEtTWjgwODENCj4gPj4gUEhZIHRoYXQgYmVjb21lcyB1bnN0YWJsZSB3
aGVuIGEgc29mdCByZXNldCBpcyB0cmlnZ2VyZWQgZHVyaW5nIGFuZWcuDQo+ID4+DQo+ID4+IFJl
cG9ydGVkLWJ5OiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiA+PiBU
ZXN0ZWQtYnk6IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+ID4+IFNp
Z25lZC1vZmYtYnk6IEhlaW5lciBLYWxsd2VpdCA8aGthbGx3ZWl0MUBnbWFpbC5jb20+DQo+ID4+
IC0tLQ0KPiA+PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMgfCAz
ICsrKw0KPiA+PiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKQ0KPiA+Pg0KPiA+PiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMNCj4g
Pj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0KPiA+PiBpbmRl
eCAzZGI4ODIzMjIuLjcwYWVhOWMyNyAxMDA2NDQNCj4gPj4gLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMNCj4gPj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMNCj4gPj4gQEAgLTIwNDgsNiArMjA0OCw4IEBAIHN0YXRp
YyBpbnQgZmVjX2VuZXRfbWlpX3Byb2JlKHN0cnVjdCBuZXRfZGV2aWNlDQo+ID4+ICpuZGV2KQ0K
PiA+PiAgCWZlcC0+bGluayA9IDA7DQo+ID4+ICAJZmVwLT5mdWxsX2R1cGxleCA9IDA7DQo+ID4+
DQo+ID4+ICsJcGh5X2Rldi0+bWFjX21hbmFnZWRfcG0gPSAxOw0KPiA+PiArDQo+ID4+ICAJcGh5
X2F0dGFjaGVkX2luZm8ocGh5X2Rldik7DQo+ID4+DQo+ID4+ICAJcmV0dXJuIDA7DQo+ID4+IEBA
IC0zODY0LDYgKzM4NjYsNyBAQCBzdGF0aWMgaW50IF9fbWF5YmVfdW51c2VkIGZlY19yZXN1bWUo
c3RydWN0DQo+ID4+IGRldmljZSAqZGV2KQ0KPiA+PiAgCQluZXRpZl9kZXZpY2VfYXR0YWNoKG5k
ZXYpOw0KPiA+PiAgCQluZXRpZl90eF91bmxvY2tfYmgobmRldik7DQo+ID4+ICAJCW5hcGlfZW5h
YmxlKCZmZXAtPm5hcGkpOw0KPiA+PiArCQlwaHlfaW5pdF9odyhuZGV2LT5waHlkZXYpOw0KPiA+
DQo+ID4NCj4gPiBGb3Igbm93LCBJIHRoaW5rIHdlIGRvZXNuJ3QgbmVlZCB0byByZS1pbml0aWFs
aXplIFBIWSBhZnRlciBNQUMgcmVzdW1lIGJhY2ssDQo+IGl0IGFsc28gY2FuIGJlIGRvbmUgYnkg
UEhZIGRyaXZlciBpZiBpdCBuZWVkZWQuDQo+ID4NCj4gVGhlIFBIWSBQTSByZXN1bWUgY2FsbGJh
Y2sgKHRoYXQgdXNlZCB0byBjYWxsIHBoeV9pbml0X2h3KSBpcyBhIG5vLW9wIG5vdy4NCj4gU28g
d2UgaGF2ZSB0byBjYWxsIGl0IGZyb20gdGhlIE1BQyByZXN1bWUgY2FsbGJhY2suIFBvd2VyIHRv
IHRoZSBQSFkgbWF5IGJlDQo+IG9mZiBkdXJpbmcgc3lzdGVtIHN1c3BlbmQsIHRoZXJlZm9yZSBp
dCBtYXkgYmUgcmVzZXQgdG8gcG93ZXItb24gZGVmYXVsdHMuDQo+IFRoYXQncyB3aHkgcGh5X2lu
aXRfaHcoKSBzaG91bGQgYmUgY2FsbGVkLCB0aGF0IGluY2x1ZGVzIGNhbGxpbmcgdGhlIFBIWSBk
cml2ZXJzDQo+IGNvbmZpZ19pbml0IGNhbGxiYWNrLg0KDQpZZXMsIGl0IGlzIHJlYXNvbmFibGUg
dG8gaW52b2tlIHBoeV9pbml0X2h3KCkgaGVyZSB0byBjb3ZlciBtb3JlIGNhc2VzLiBXaGF0IEkg
d2FudCB0byBkZXNjcmliZSwgd2UgaGF2ZSBub3QgcnVuIGludG8gc3VjaCBjYXNlIGZvciBGRUMg
ZHJpdmVyIGJlZm9yZS4NCkF0IGxlYXN0IG5vIG9uZSBjb21wbGFpbiBpdCBiZWZvcmUgYXMgSSBr
bm93LiBBbnl3YXksIHJlLWluaXRpYWxpemUgUEhZIGhlcmUgaW5kZWVkIGNhbiBiZW5lZml0IG1v
cmUgc2NlbmFyaW9zLg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gPiBCZXN0IFJl
Z2FyZHMsDQo+ID4gSm9ha2ltIFpoYW5nDQo+ID4+ICAJCXBoeV9zdGFydChuZGV2LT5waHlkZXYp
Ow0KPiA+PiAgCX0NCj4gPj4gIAlydG5sX3VubG9jaygpOw0KPiA+PiAtLQ0KPiA+PiAyLjMxLjEN
Cj4gPj4NCj4gPg0KDQo=
