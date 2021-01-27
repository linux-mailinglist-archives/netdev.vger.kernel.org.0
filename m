Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17281305D49
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 14:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238473AbhA0Nc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 08:32:56 -0500
Received: from mail-am6eur05on2119.outbound.protection.outlook.com ([40.107.22.119]:1505
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238426AbhA0Nay (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 08:30:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z9Y/ZYfBwf0YMtDTINuEVz8PLHIZun6l7s3qY2VI1QqG0toHrNkUF8gNIU2xTs9nmkpJ9ecj4hkRQzZFwoBDho2tsEJkgYe9bUhJ8C5YCf7EvpQxLoYdgkLiwLbegAZOWEke9/1U/hkMW8MQL6QK1zhGlD6Cd0wsrCpIqSwjNviBk8H56spq6NZgE67U24akEhQI/9+LtC6EAbdRpe+U2EjtQUEAH4J54TeqdIKDObKKJZL62JFfSUHMGgfgBgoNpXGx5Im5NhaKaSTSKKEb2yllNRx+5vl9cAm6lac3xkOSiZGNm6r6i2pe1f0m9+HBDlxWjKbBUjVgw3KyXQZ1gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k7u9Gs5xlxLwkiDl1K9U+ldqxqTng/OGxRL6xUYapBk=;
 b=G6hsTaY3nCqr9HsOFLbHl/qbsyR0NZCHE8tK3eIZ2mYdeg9R86Y1KZcbt1UZd/lxUuEwCaPf2RyMArCNMqUm4h5zzvI1WHscC19Prq6aF12ECaNpBuOz5VfGPSw8FdH0qQMQGZXSda5JLoPJWSEasfN7VKXHukcHnqy6jIQeGQw9hk/cNDMoUv/Sg5qdKFqlFSj3vncVc+IRgTB6qi2o0LsDmRB69MNH7SBeJ8f7L7B+v9T4WsHFM73eoAYwJxC+uzar0yvZQPOSEznscU4AkHTFQ2UQrgg3a4ysYC6VqAfbZ3aW+8Gdb5GfBiVR5oo2WlNQj9K7JDVeH4Itkhaxww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k7u9Gs5xlxLwkiDl1K9U+ldqxqTng/OGxRL6xUYapBk=;
 b=bhXpbJ4jplsB8kOYXUNAfxJWaV512dyd21lEy3/lIObUk9mmKSv9fzKR868616kBdI9gryBp5Do7j726/TnZoHY5e8oiBPbT+UMN6GfNxa5oVqXEI1Ke344vC+nIuw7Uaa/ffnQQZYWf66O1x/rOEdjR2vZXVinosc74xbywxww=
Received: from (2603:10a6:7:2c::17) by
 HE1PR0702MB3706.eurprd07.prod.outlook.com (2603:10a6:7:8d::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.15; Wed, 27 Jan 2021 13:30:04 +0000
Received: from HE1PR07MB3450.eurprd07.prod.outlook.com
 ([fe80::49eb:b0ff:cbe4:a199]) by HE1PR07MB3450.eurprd07.prod.outlook.com
 ([fe80::49eb:b0ff:cbe4:a199%2]) with mapi id 15.20.3805.014; Wed, 27 Jan 2021
 13:30:04 +0000
From:   "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "dsahern@kernel.org" <dsahern@kernel.org>
Subject: Re: [PATCH iproute2] ss: do not emit warn while dumping MPTCP on old
 kernels
Thread-Topic: [PATCH iproute2] ss: do not emit warn while dumping MPTCP on old
 kernels
Thread-Index: AQHW8zOHV4pyEtGhF0WIJAEoF2dMKKo7eqKA
Date:   Wed, 27 Jan 2021 13:30:04 +0000
Message-ID: <d533e38ca3a3497df3303ed06719076bcc5c5ce5.camel@nokia.com>
References: <89e5acb6c86bb10675697dabbefafad7088dc0f6.1611590423.git.pabeni@redhat.com>
In-Reply-To: <89e5acb6c86bb10675697dabbefafad7088dc0f6.1611590423.git.pabeni@redhat.com>
Accept-Language: en-150, fi-FI, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nokia.com;
x-originating-ip: [131.228.2.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 285c9fd3-2891-4d43-a7ea-08d8c2c7a7de
x-ms-traffictypediagnostic: HE1PR0702MB3706:
x-microsoft-antispam-prvs: <HE1PR0702MB37065BE393A08DA9FE102152B4BB0@HE1PR0702MB3706.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:849;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MP6NofNd4dqZO8McWSvat8oE2YXCIG+jQyaoIhdgYzMxh+hu++Xk2owKeX8XqJ9+HRdQ5CW1MEj5pNptf8u242CvjlUvzdWNcXrkt4Xf2NugLdFx5ez5I45M3v8o/0QTG7Ssj2QtGc26cEht+07a0y3Hf8z2VeVL8ClQKUxxLUd5PJtGweVFP9278IBDuMJGwNDYTBb5bsKBPK9gvmbByZzFgu7S3j/RIQka2xH8u4Mx6envI6TwBa376OsEv0tN0CeK3OY209pZk2ETM6QMW3k9uIhi6F8ZZ0kG0CZoeBP9hbG72rbUZMRCBlsRfSsXaoqcLVl+Gz/qLw1RfU4wt9hZq1XoXVMQ9AsXullGdadiEaNNWOtZQ8cMMH6HLBpI3oxcrMIYH17CveT0bimNROSJlkiYF8nQkjxpCOyunYXMYeMgNYqKDz5zoNX3ToJg5lRu7BsPU2juMFR5enoB1OFC7iTTJRNrCxi7tSRkAuD08uihK42o21S2f+1IuhKwZC7+nvYUaGIADOCNHqOtoQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR07MB3450.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(376002)(346002)(366004)(6512007)(186003)(5660300002)(6486002)(36756003)(110136005)(6506007)(83380400001)(26005)(478600001)(2906002)(316002)(86362001)(8936002)(4326008)(66946007)(66556008)(66476007)(76116006)(66446008)(2616005)(8676002)(71200400001)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?dEwvbmd0Mjl4SXJTVHQ0dUdDaU50ZVFETFZ6UTVUZG9aRW5HdDJXV1N2TDR0?=
 =?utf-8?B?Qy80SCtsZW02ckFjYzRIS3ljZi9sWXhycHoyN21PVnRjaFpCV2VhWGcza2lJ?=
 =?utf-8?B?dVNOS2JHQk5MeFZvVFpaOHpjNWJUK1VyWU1FYlNaT0EzQ0ttOUp0V0VyZ2xG?=
 =?utf-8?B?a2ppcFl5Y3V2YlUvaUdDV2dZYlNTcEFhWTFVNTVsZWppZU5vL0ZCOG0wZlBw?=
 =?utf-8?B?dyttQkNPK1A4UnRwbk9lU3hkcE9OOUUyNFlwclY3MFFPWFRDalY5M3N1eGRa?=
 =?utf-8?B?c3ArVFc1Z3BsOHVsN0pwL3g4S1NHMjZURTVxOS8waUV2NytJc1d4Sjl1YmZW?=
 =?utf-8?B?R0ZmSTRWZ01pUU1UcmVvTmJiaXhhNUdjY045ZVhXaDd5WWY4dXpCVjQ3dm1w?=
 =?utf-8?B?bW8yQ1RHS0tRTzB4TWhuZTljQURjREsvR1hBYUttQ21CWmg3UitYRkx1Ykdu?=
 =?utf-8?B?ZStzSEMyOGVvbVFOaGpWL24rUUhHbVFsMnZVN3pNU0hRTXBBZ0toOGJ3NUls?=
 =?utf-8?B?QUtwNHo4K0NSMnI5VU1idHlOSGh2aC84TytISlhkT1Z5MTVJQkJMdisrNXla?=
 =?utf-8?B?Uy80TE1rTXlUeWQ2UmV4SGppWVBHVU5Xam5vSkk3VU1Ud1ptVmt1eEFRYkdL?=
 =?utf-8?B?eXVocDJtRDR3OHpveEpveGNsQlJFK0xpeURsdWVYdE9obE5pTnFTQ2k5TUc3?=
 =?utf-8?B?UXFWeTM5dlRERlB3aEc3UmhNZkF4SER3U2liTy9panh2dW9KTFZuWHdpTU5Q?=
 =?utf-8?B?dVNCTmJ1VldrN3g2dVArbDFkUWlqREFtd283dG1CeDR5dTU2Ry9LWC9GRzlt?=
 =?utf-8?B?K3ByQ2dINmJncmNYUWVPdTJHcDZNb2YyYXZLUUkvNEp4OURUS2xYZGM5eTRi?=
 =?utf-8?B?TlA1REQyMXBBMGE5RG9BeDVQalpqSHc0R2tNKy9GNzZCYTZkM0xxYUVMa2dT?=
 =?utf-8?B?T3pwejJrV1gzU2hESkpPVjdEMUd4bUVNS3V5UWFnM3BuWit5b2tXSkgwWmZO?=
 =?utf-8?B?cGdSWitORkdFb25pN0hlK1NKTTBjeXd3UElVU0s1YXlGbG8yNU9KUm52eGhW?=
 =?utf-8?B?bXFoQTkzaVBmcnlycHNqdmp1elNocG5MMHFFaGE4a2kyUHFoY1lLNWQ5WFYx?=
 =?utf-8?B?a2REM1JCZ0pmZyt2cW5GUnc4VUhKUldia2VJNkl4dTZNa01CY3VtMzROZU9y?=
 =?utf-8?B?RWgwR0ZxY2NSbFBiWlVNR2VmY2hka0syMHIxWFZIeTRZb0Zid3NkVzhDc2o2?=
 =?utf-8?B?dEJ1VURFZGRia3BwaENoem93ZmZxcU9SeXRucko4SVYvR1FVakQ5NDM4a09a?=
 =?utf-8?B?QlJtZzY3QWJQZGhoUDdxUW5HVlEyUDMyYkxXMlBUTUtOQUtsdmQ3dXNVQ1NQ?=
 =?utf-8?B?UXFvcU1kRWlYcUpzS1FxQUZRazNvNlhEUU1yeEZ0UGNhcThteUZZUmUvUHZL?=
 =?utf-8?Q?wM8s8T5h?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D65EB1669C923408869D8770B0CE5E0@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR07MB3450.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 285c9fd3-2891-4d43-a7ea-08d8c2c7a7de
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 13:30:04.2453
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XVThMkkyIUmG7QzQMl0C852ksESLJHX72NJ6B3Z4NvzgUyBFbsn8mt/vrUF8CajFMVDYkPBdeq1YXJTKrtrMDHaLf3KwBsSoHBB474OO1OM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0702MB3706
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTAxLTI1IGF0IDE3OjAyICswMTAwLCBQYW9sbyBBYmVuaSB3cm90ZToNCj4g
UHJpb3IgdG8gdGhpcyBjb21taXQsIHJ1bm5pbmcgJ3NzJyBvbiBhIGtlcm5lbCBvbGRlciB0aGFu
IHY1LjkNCj4gYnVtcHMgYW4gZXJyb3IgbWVzc2FnZToNCj4gDQo+IFJUTkVUTElOSyBhbnN3ZXJz
OiBJbnZhbGlkIGFyZ3VtZW50DQoNClRoYW5rcywgd29ya3MgcGVyZmVjdGx5IGZvciBtZS4NCi1U
b21taQ0KDQo+IFdoZW4gYXNrZWQgdG8gZHVtcCBwcm90b2NvbCBudW1iZXIgPiAyNTUgLSB0aGF0
IGlzOiBNUFRDUCAtICdzcycNCj4gYWRkcyBhbiBJTkVUX0RJQUdfUkVRX1BST1RPQ09MIGF0dHJp
YnV0ZSwgdW5zdXBwb3J0ZWQgYnkgdGhlIG9sZGVyDQo+IGtlcm5lbC4NCj4gDQo+IEF2b2lkIHRo
ZSB3YXJuaW5nIGlnbm9yaW5nIGZpbHRlciBpc3N1ZXMgd2hlbiBJTkVUX0RJQUdfUkVRX1BST1RP
Q09MDQo+IGlzIHVzZWQuDQo+IA0KPiBBZGRpdGlvbmFsbHkgb2xkZXIga2VybmVsIGVuZC11cCBp
bnZva2luZyB0Y3BkaWFnX3NlbmQoKSwgd2hpY2gNCj4gaW4gdHVybiB3aWxsIHRyeSB0byBkdW1w
IERDQ1Agc29ja3MuIEJhaWwgZWFybHkgaW4gc3VjaCBmdW5jdGlvbiwNCj4gYXMgdGhlIGtlcm5l
bCBkb2VzIG5vdCBpbXBsZW1lbnQgYW4gTVBUQ1BESUFHX0dFVCByZXF1ZXN0Lg0KPiANCj4gUmVw
b3J0ZWQtYnk6ICJSYW50YWxhLCBUb21taSBULiAoTm9raWEgLSBGSS9Fc3BvbykiIDwNCj4gdG9t
bWkudC5yYW50YWxhQG5va2lhLmNvbT4NCj4gRml4ZXM6IDljM2JlMmMwZWVlMCAoInNzOiBtcHRj
cDogYWRkIG1zayBkaWFnIGludGVyZmFjZSBzdXBwb3J0IikNCj4gU2lnbmVkLW9mZi1ieTogUGFv
bG8gQWJlbmkgPHBhYmVuaUByZWRoYXQuY29tPg0KPiAtLS0NCj4gIG1pc2Mvc3MuYyB8IDEwICsr
KysrKysrKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24o
LSkNCj4gDQo+IGRpZmYgLS1naXQgYS9taXNjL3NzLmMgYi9taXNjL3NzLmMNCj4gaW5kZXggMDU5
MzYyN2IuLmFkNDZmOWRiIDEwMDY0NA0KPiAtLS0gYS9taXNjL3NzLmMNCj4gKysrIGIvbWlzYy9z
cy5jDQo+IEBAIC0zNDA0LDcgKzM0MDQsNyBAQCBzdGF0aWMgaW50IHRjcGRpYWdfc2VuZChpbnQg
ZmQsIGludCBwcm90b2NvbCwgc3RydWN0DQo+IGZpbHRlciAqZikNCj4gIAlzdHJ1Y3QgaW92ZWMg
aW92WzNdOw0KPiAgCWludCBpb3ZsZW4gPSAxOw0KPiAgDQo+IC0JaWYgKHByb3RvY29sID09IElQ
UFJPVE9fVURQKQ0KPiArCWlmIChwcm90b2NvbCA9PSBJUFBST1RPX1VEUCB8fCBwcm90b2NvbCA9
PSBJUFBST1RPX01QVENQKQ0KPiAgCQlyZXR1cm4gLTE7DQo+ICANCj4gIAlpZiAocHJvdG9jb2wg
PT0gSVBQUk9UT19UQ1ApDQo+IEBAIC0zNjIzLDYgKzM2MjMsMTQgQEAgc3RhdGljIGludCBpbmV0
X3Nob3dfbmV0bGluayhzdHJ1Y3QgZmlsdGVyICpmLCBGSUxFDQo+ICpkdW1wX2ZwLCBpbnQgcHJv
dG9jb2wpDQo+ICAJaWYgKHByZWZlcnJlZF9mYW1pbHkgPT0gUEZfSU5FVDYpDQo+ICAJCWZhbWls
eSA9IFBGX0lORVQ2Ow0KPiAgDQo+ICsJLyogZXh0ZW5kZWQgcHJvdG9jb2wgd2lsbCB1c2UgSU5F
VF9ESUFHX1JFUV9QUk9UT0NPTCwNCj4gKwkgKiBub3Qgc3VwcG9ydGVkIGJ5IG9sZGVyIGtlcm5l
bHMuIE9uIHN1Y2gga2VybmVsDQo+ICsJICogcnRubF9kdW1wIHdpbGwgYmFpbCB3aXRoIHJ0bmxf
ZHVtcF9lcnJvcigpLg0KPiArCSAqIFN1cHByZXNzIHRoZSBlcnJvciB0byBhdm9pZCBjb25mdXNp
bmcgdGhlIHVzZXINCj4gKwkgKi8NCj4gKwlpZiAocHJvdG9jb2wgPiAyNTUpDQo+ICsJCXJ0aC5m
bGFncyB8PSBSVE5MX0hBTkRMRV9GX1NVUFBSRVNTX05MRVJSOw0KPiArDQo+ICBhZ2FpbjoNCj4g
IAlpZiAoKGVyciA9IHNvY2tkaWFnX3NlbmQoZmFtaWx5LCBydGguZmQsIHByb3RvY29sLCBmKSkp
DQo+ICAJCWdvdG8gRXhpdDsNCg0K
