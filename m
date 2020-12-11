Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CABC12D7268
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 09:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437224AbgLKI5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 03:57:33 -0500
Received: from mail-eopbgr1300045.outbound.protection.outlook.com ([40.107.130.45]:47665
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2393169AbgLKI5Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 03:57:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jQeRcw7QR3aIF9HLv585iKMa64cgml4NFar91FH45LbIfGzf94HF7NCZ8DSdHWF6XkZYKlBPnHRJEoXAxky+rd0J8Mxtt++A5t+1a5K8OPl13QkckqFuRVs4DiojqvMZpXTaa64j69lZ9N+LilS72M3ZmM2Onsw/WI1SltGiSTV7IakuiycTUnWTo86RMyJRfKAqGjDFFn/DoDcmcAJYJvwdlAfUDYmbeDUPQCHhEqNABf0xuthRipbAWM0vDn25QKRU17rcpoasGEZQas/BQJHw/wHQANZfebCEGdhaNvc2hRSPEnngglXpdMxuDKVDQrwhsJQFfmcv5louopz9uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jB1rOoWtPmtxOHpjxzAhp5qeSOVeDuJCQP7f/KmqgsI=;
 b=RMhS37gfULfA99D/cBZp52b6f04cjkSrgeyKqWivA087HSx34SnUvVkmWYVHad7ikfT2lQR12mtfrT/As5JShCFpJrY9DK9vsmnY3EkKrGgH/jRfl8yQlO5Oz09IlsVvsuWdIVQPTPCo2hnFgkpyrstOpVp9QWDHwAGIkdVqTME0fq/NoE7iEaB9+bdcScZ/i82NoYjoyAo1FQZwETlectVQuROv1CsrqL8y8hvno404wxGm4bTsXEnRaoMHfthpyUV2c1KSXjsUJLePn8UExLXyaT3mmSYrJZZidrqUr7eKbdUa2YIQMmSMvFtBXSANjKPhikEflwSe6o7QoDn+iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quectel.com; dmarc=pass action=none header.from=quectel.com;
 dkim=pass header.d=quectel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quectel.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jB1rOoWtPmtxOHpjxzAhp5qeSOVeDuJCQP7f/KmqgsI=;
 b=Yh3hGJzArbEXqxj2/qBJ4MmXgNJfX8iIqh2Sl89j61rMQOiR6wwzypDf8khwszldn42/KKF4fVvmSzj8HVdLsQxy3O6Guqm7n/JMeGbfC3OmYj8Zquk4J6a0nVopSG8lr2YxTQWaBWBODJy80siP3tOMHur0tCcwbpRPhHLHUo4=
Received: from HK2PR06MB3507.apcprd06.prod.outlook.com (2603:1096:202:3e::14)
 by HK0PR06MB2227.apcprd06.prod.outlook.com (2603:1096:203:43::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Fri, 11 Dec
 2020 08:55:53 +0000
Received: from HK2PR06MB3507.apcprd06.prod.outlook.com
 ([fe80::fd58:e808:de10:27df]) by HK2PR06MB3507.apcprd06.prod.outlook.com
 ([fe80::fd58:e808:de10:27df%4]) with mapi id 15.20.3654.017; Fri, 11 Dec 2020
 08:55:53 +0000
From:   =?gb2312?B?Q2FybCBZaW4o0vPVxbPJKQ==?= <carl.yin@quectel.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "hemantk@codeaurora.org" <hemantk@codeaurora.org>
CC:     "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jhugo@codeaurora.org" <jhugo@codeaurora.org>,
        "bbhatt@codeaurora.org" <bbhatt@codeaurora.org>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH v17 3/3] bus: mhi: Add userspace client interface driver
Thread-Topic: [PATCH v17 3/3] bus: mhi: Add userspace client interface driver
Thread-Index: AdbPmF3XQ8tWi+EKQaS64XgwRz9edA==
Date:   Fri, 11 Dec 2020 08:55:53 +0000
Message-ID: <HK2PR06MB3507DC780B2049EDF3D7254186CA0@HK2PR06MB3507.apcprd06.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=quectel.com;
x-originating-ip: [203.93.254.83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 42118f5f-ed47-4b6c-192b-08d89db290e1
x-ms-traffictypediagnostic: HK0PR06MB2227:
x-microsoft-antispam-prvs: <HK0PR06MB2227DAB7B5EA4A05EC17456586CA0@HK0PR06MB2227.apcprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IiGaRvPj1o9hDQt1o4AajatEZqdTHxQqRmzgeF6MSZ134GyCK70GhEHZp2++rKAz7zj2UFnVpczdf8KdBcr7cZTsFoYHNfZ1TG2oNmFWuuhlQBD7eLi/9omKfKSKUZJ0eV1p8FhS57+32kXExSG0Z4/Mod6Td85786UhEOuzjE9UfWEbkU5qh4d+zZmCzfOySAgbug3t1r4pFQARqSKKveDE4jaHd4FD54mqRr5BhHP7a5Ay0+SABMTT7lBqTJ1By3M8TKp229zP5seTPLqzE9z+XKJOpAn0uJNkAkbto81Yv21atdyoPJSaMnH9Ee9sWZeZ4IXRPrx4OShGyCaKibeVTUEq0Zj3m83zOogfCGU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3507.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(366004)(396003)(39860400002)(53546011)(8676002)(7696005)(33656002)(64756008)(66946007)(71200400001)(76116006)(5660300002)(316002)(9686003)(66446008)(66476007)(66556008)(478600001)(55016002)(110136005)(54906003)(966005)(8936002)(2906002)(86362001)(4326008)(85182001)(26005)(186003)(6506007)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?b2pDOGdkUHFWaUpuRW1oalJMSS9XbTRQMUJ0T09QK2JSalRWWnh3alo0SmUy?=
 =?gb2312?B?REFod2F6Rnp2Z2FxemJLMzVZUGM1M2l0UjVlb0E5Z3BsMUFRQ1VWKzBEa2tl?=
 =?gb2312?B?V2ptYjltYk1ZamJoN3B1OE9mWWwrQnA1dnRxTEwrK0kzd242UFhHR3hzTGIw?=
 =?gb2312?B?aUw2d0Q3K0xZQkNzdHhMQ1Y5SUtkWVRqMCs2UjFBVUZSTHRseURUM3FUUzVQ?=
 =?gb2312?B?YVR2Kzl3bEowakRXM1NrVTZzN1VLSE40VWJTekpFWDIyV3VRdE44bkRWTCtV?=
 =?gb2312?B?VWVzcHd2TXZiZWY3Vk5GVVJEM3R0cUtyRXcvTDAwcURjdHJ4OVV3YlU2Q3Vk?=
 =?gb2312?B?a2NCQUUzRGt3d1VLOENxRWVrd0pYeDJlNFZldmZuS1NKYTNrLzFtWTB4L05n?=
 =?gb2312?B?cGE2R01hYlBqeWl3WXdMa0FKejNaQ2R5OTd2TFc1VzdJaHRNZTY5MlcvbG5l?=
 =?gb2312?B?SzZNQUpENnhlUzc5b1Y1SUFJakdLT2hWQW9yd0E5VGFzVTVmeSt0NkdvcmI5?=
 =?gb2312?B?V3d1dDB6eWlvb2N3ZHlKMWR1K1lUNHhORVlTejQzQVdFNElJTmpwZWVsdEJk?=
 =?gb2312?B?azcyNStwcHd1ZmszT3B0ZXhubXY3cUJ3UHVCNWYvMHpXZEU2VXNLalp2NEh4?=
 =?gb2312?B?aFVaRG42Z1IxTWs5SWdWMXcwb1BCL1RldkRqc1BtMEFDcGR4SHhWaDBoay9J?=
 =?gb2312?B?b3Y3Z0IrYkFkMEM1TTdGU0NMS212d2FGaWhJZ1prSHBUb3Z5NVRwZ2xOemsy?=
 =?gb2312?B?MmFKM21SRnZJSytMZVhKUFZBL1BQcitWbjU2WTc5Sno4bmtsUDdRZVlHOElk?=
 =?gb2312?B?SE1QcS8wWC9rNTBnVXZuMjI3OHphM3h4enB0Um56SlM1UHJwNFVDVjd4SWlm?=
 =?gb2312?B?SXMxVmVLWmI1U2ZhMys0S3N1amUxblJibGFFT3hnbnRScnJTaTF5RnF4Y1E2?=
 =?gb2312?B?VnB6bUdMaGRCWGRWYmxqYXI4Rms2UEZIQkRIZVBqSmJlek43NURhK0JsVnhQ?=
 =?gb2312?B?R0tBWks3eExyTU50eXJvaWcrYkxMaUo4R3ZXVHQ1Y2V1czU2VFJibGNrMlpk?=
 =?gb2312?B?NzlubWMxWFhUNWZ1YUVjUzlBL1lTZEhGZWhRRitwbHBzTFROUWZKK2xYajV0?=
 =?gb2312?B?c3BkN3dVY3Q3TEtUbWJQZysvN3JzcERNczRnRnQyY2xqMGVicGxFNEJZcWZv?=
 =?gb2312?B?OVFRd2lDMXBEWEp2U3RwVng3dWprMmdFM2N1REcyNXU5YkRmWHNpbWw2ZVA2?=
 =?gb2312?B?NlpEWWoxL29ob000cnJSL1loRis1K1U0dWRwU3JpdDFNOUNrMUZsaGNkMzgv?=
 =?gb2312?Q?Ekl2BQLfT08zg=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: quectel.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3507.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42118f5f-ed47-4b6c-192b-08d89db290e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Dec 2020 08:55:53.2266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7730d043-e129-480c-b1ba-e5b6a9f476aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CR0B+3qaQH5VxCXbEArKEeMiKVAPOMrs24qIs0ubyo9kJTpjxjAPLCvgmilIT+Qke8f1RM5FHPzSElxcpqNrdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2227
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoJTWF5YmUgaXQgaXMgYSBnb29kIGlkZWEgdG8gdGFrZSBRTUkgYXMgZXhhbXBsZS4gUU1J
IGlzIFFVQUxDT01NIHByaXZhdGUgcHJvdG9jb2wsIG1heWJlIGxvdHMgb2YgcGVvcGxlIGRvIG5v
dCBrbm93IHdoYXQgaXMgUU1JPw0KCU1ISSBkZXZpY2UgY2FuIGJlIFdJRkkgZGV2aWNlIG9yIFdX
QU4gZGV2aWNlLCBpZiBpdCBpcyBXSUZJIGRldmljZSwgaXQgaXMgYSBwdXJlIG5ldHdvcmsgZGV2
aWNlLCBhbmQgbWF5YmUgZG8gbm90IG5lZWQgdGhpcyBkcml2ZXIuDQoJQnV0IGZvciBXV0FOIGRl
dmljZXMsIGl0IHN1cHBvcnQgQVQvTk1FQS9RTUkvTUJJTSBldGMuIHByb3RvY29sLiBBbmQgdGhp
cyBkcml2ZXIgaXMgd29yayBmb3IgdGhlc2UgZnVuY3Rpb25zLg0KCQ0KCVRoZXJlIGFyZSBzaW1p
bGFyIGRyaXZlcnMgaW4gdGhlIGtlcm5lbCBmb3IgV1dBTiBkZXZpY2VzIGJhc2Ugb24gVVNCIGlu
dGVyZmFjZS4NCglMaWtlIGRyaXZlcnMvdXNiL2NsYXNzL2NkYy13ZG0uYyAoZm9yIFFNSSAmIE1C
SU0pLCBhbmQgZHJpdmVycy91c2Ivc2VyaWFsL3VzYl93d2FuLmMgKGZvciBBVC9OTUVBKQ0KCUZv
ciBVU0IgV1dBTiBkZXZpY2VzLCBvcGVuIHNvdXJjZSBzb2Z0d2FyZXMgbGlicW1pL2xpYm1iaW0v
TW9kZW1NYW5hZ2VyL0xWRlMgd2FudCB0byBjb21tdXRhdGUgd2l0aCBXV0FOIGRldmljZXMgdmlh
IGFib3ZlIDIgZHJpdmVycy4NCglGb3IgTUhJIFdXQU4gZGV2aWNlcywgdGhlc2Ugb3BlbiBzb3Vy
Y2Ugc29mdHdhcmUgYWxzbyBuZWVkIHN1Y2ggZHJpdmVyLg0KDQoNCk9uIDExIERlYyAyMDIwIDA4
OjQ0OjI5LCBHcmVnIEtIIHdyb3RlOg0KDQo+IE9uIFRodSwgRGVjIDEwLCAyMDIwIGF0IDExOjA0
OjExUE0gLTA4MDAsIEhlbWFudCBLdW1hciB3cm90ZToNCj4gPiBUaGlzIE1ISSBjbGllbnQgZHJp
dmVyIGFsbG93cyB1c2Vyc3BhY2UgY2xpZW50cyB0byB0cmFuc2ZlciByYXcgZGF0YQ0KPiA+IGJl
dHdlZW4gTUhJIGRldmljZSBhbmQgaG9zdCB1c2luZyBzdGFuZGFyZCBmaWxlIG9wZXJhdGlvbnMu
DQo+ID4gRHJpdmVyIGluc3RhbnRpYXRlcyBVQ0kgZGV2aWNlIG9iamVjdCB3aGljaCBpcyBhc3Nv
Y2lhdGVkIHRvIGRldmljZQ0KPiA+IGZpbGUgbm9kZS4gVUNJIGRldmljZSBvYmplY3QgaW5zdGFu
dGlhdGVzIFVDSSBjaGFubmVsIG9iamVjdCB3aGVuDQo+ID4gZGV2aWNlIGZpbGUgbm9kZSBpcyBv
cGVuZWQuIFVDSSBjaGFubmVsIG9iamVjdCBpcyB1c2VkIHRvIG1hbmFnZSBNSEkNCj4gPiBjaGFu
bmVscyBieSBjYWxsaW5nIE1ISSBjb3JlIEFQSXMgZm9yIHJlYWQgYW5kIHdyaXRlIG9wZXJhdGlv
bnMuIE1ISQ0KPiA+IGNoYW5uZWxzIGFyZSBzdGFydGVkIGFzIHBhcnQgb2YgZGV2aWNlIG9wZW4o
KS4gTUhJIGNoYW5uZWxzIHJlbWFpbiBpbg0KPiA+IHN0YXJ0IHN0YXRlIHVudGlsIGxhc3QgcmVs
ZWFzZSgpIGlzIGNhbGxlZCBvbiBVQ0kgZGV2aWNlIGZpbGUgbm9kZS4NCj4gPiBEZXZpY2UgZmls
ZSBub2RlIGlzIGNyZWF0ZWQgd2l0aCBmb3JtYXQNCj4gPg0KPiA+IC9kZXYvPG1oaV9kZXZpY2Vf
bmFtZT4NCj4gPg0KPiA+IEN1cnJlbnRseSBpdCBzdXBwb3J0cyBRTUkgY2hhbm5lbC4gbGlicW1p
IGlzIHVzZXJzcGFjZSBNSEkgY2xpZW50DQo+ID4gd2hpY2ggY29tbXVuaWNhdGVzIHRvIGEgUU1J
IHNlcnZpY2UgdXNpbmcgUU1JIGNoYW5uZWwuIGxpYnFtaSBpcyBhDQo+ID4gZ2xpYi1iYXNlZCBs
aWJyYXJ5IGZvciB0YWxraW5nIHRvIFdXQU4gbW9kZW1zIGFuZCBkZXZpY2VzIHdoaWNoIHNwZWFr
cyBRTUkNCj4gcHJvdG9jb2wuDQo+ID4gRm9yIG1vcmUgaW5mb3JtYXRpb24gYWJvdXQgbGlicW1p
IHBsZWFzZSByZWZlcg0KPiA+IGh0dHBzOi8vd3d3LmZyZWVkZXNrdG9wLm9yZy93aWtpL1NvZnR3
YXJlL2xpYnFtaS8NCj4gDQo+IFRoaXMgc2F5cyBfd2hhdF8gdGhpcyBpcyBkb2luZywgYnV0IG5v
dCBfd2h5Xy4NCj4gDQo+IFdoeSBkbyB5b3Ugd2FudCB0byBjaXJjdW12ZW50IHRoZSBub3JtYWwg
dXNlci9rZXJuZWwgYXBpcyBmb3IgdGhpcyB0eXBlIG9mDQo+IGRldmljZSBhbmQgbW92ZSB0aGUg
bm9ybWFsIG5ldHdvcmsgaGFuZGxpbmcgbG9naWMgb3V0IHRvIHVzZXJzcGFjZT8NCj4gV2hhdCBk
b2VzIHRoYXQgaGVscCB3aXRoPyAgV2hhdCBkb2VzIHRoZSBjdXJyZW50IGluLWtlcm5lbCBhcGkg
bGFjayB0aGF0IHRoaXMNCj4gdXNlcnNwYWNlIGludGVyZmFjZSBpcyBnb2luZyB0byBzb2x2ZSwg
YW5kIHdoeSBjYW4ndCB0aGUgaW4ta2VybmVsIGFwaSBzb2x2ZSBpdA0KPiBpbnN0ZWFkPw0KPiAN
Cj4gWW91IGFyZSBwdXNoaW5nIGEgY29tbW9uIHVzZXIva2VybmVsIGFwaSBvdXQgb2YgdGhlIGtl
cm5lbCBoZXJlLCB0byBiZWNvbWUNCj4gdmVyeSBkZXZpY2Utc3BlY2lmaWMsIHdpdGggbm8gYXBw
YXJlbnQganVzdGlmaWNhdGlvbiBhcyB0byB3aHkgdGhpcyBpcyBoYXBwZW5pbmcuDQo+IA0KPiBB
bHNvLCBiZWNhdXNlIHlvdSBhcmUgZ29pbmcgYXJvdW5kIHRoZSBleGlzdGluZyBuZXR3b3JrIGFw
aSwgSSB3aWxsIG5lZWQgdGhlDQo+IG5ldHdvcmtpbmcgbWFpbnRhaW5lcnMgdG8gYWNrIHRoaXMg
dHlwZSBvZiBwYXRjaC4NCj4gDQo+IHRoYW5rcywNCj4gDQo+IGdyZWcgay1oDQo+IA0KPiANCj4N
Cg==
