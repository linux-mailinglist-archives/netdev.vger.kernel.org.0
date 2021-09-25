Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F09418386
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 19:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbhIYRTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 13:19:48 -0400
Received: from mail-db8eur05on2108.outbound.protection.outlook.com ([40.107.20.108]:33613
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229542AbhIYRTq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 13:19:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DuG289doUmMudEMzAq+uSCZrmFJT1DH03XLleu6yJAZsjnFWRsijI8zCPSAIHlJNhxlnzzlI1Ayb2A6YSQeY7LmLx7icEtQP+sNGfnz3D7KMZG+cPc/YhM94Cw10TH57EigRbStBLyAAXoRSoGgc/demE/WLI3RxX0jHTnABaL8z0l4I/Og2fU7WBnbkAMD8LT1bwpIOQGB1avsK8JtP7FMFae8+FwWKReZFncEvi0ppnj1Td/tkLSAQIbDfxZPlI2a4NRJfGOl9ARIuAxS8FByxvpq/MA8Qi6AGeKIA6DNg/aVTh2+rAvShadv7t0Sqtgje9k+pbxKxP5ssYYXDnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=1/uhcdbV783m0KxXr1L3acFgBooK5NqZPSA7X7aNrX8=;
 b=BpLZFMPEUEBKAsZa0Jz3D8y1pPj4F8X2t1SIXmaCwJ981CGmH192ASGsqUgdYYZW15xUdiM10yAS+WgCCTlfveXNhRbNsx5UZfi9dXhqx3FcQlUct757j3j9TDGAxTjwLpELnaxP9oz1uukefpE8pWJfInd/cZR/ZFAu+8GaBbVIq+Q+uNmaLqB9pQS5TgQe/rNTc0tGU3ktPpsN5pzW4xH0bDzMfl3g5/RrSw7WZv33Owo2isGHVmwuaeqjsbL2sOf8msEAUAuYmloX5kCU8aX0Sk3x6CFdkXlL/ysM38Q8h1Ulcw274VKaWfISHncRzM4/QzT7jlY8D/5bPnTFMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1/uhcdbV783m0KxXr1L3acFgBooK5NqZPSA7X7aNrX8=;
 b=OomGyqrRMzPOcvz4NhvAiTzZssdNSIrYT8oElf5HSZaQYljkCZ4SjFjHq0MFw+//Dr6inJSNIffG6zVxUNdWb7fp1+t4NkuHmIhvk1PBHFvL0lJ3efXUVFw6HtZ6va3Olui+aTKgvab3F584RhkoMudgdAU6wcyL+Hv8EKi7XeM=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0301MB2139.eurprd03.prod.outlook.com (2603:10a6:3:1d::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.15; Sat, 25 Sep 2021 17:18:09 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d550:ffc2:ab2e:8167]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d550:ffc2:ab2e:8167%6]) with mapi id 15.20.4523.018; Sat, 25 Sep 2021
 17:18:08 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 5/6 v6] net: dsa: rtl8366: Fix a bug in deleting
 VLANs
Thread-Topic: [PATCH net-next 5/6 v6] net: dsa: rtl8366: Fix a bug in deleting
 VLANs
Thread-Index: AQHXshDUWb+kWTdpxEKqDaUX+IAJYKu0/nwA
Date:   Sat, 25 Sep 2021 17:18:08 +0000
Message-ID: <ad877696-2086-4798-4577-6469a54897f6@bang-olufsen.dk>
References: <20210925132311.2040272-1-linus.walleij@linaro.org>
 <20210925132311.2040272-6-linus.walleij@linaro.org>
In-Reply-To: <20210925132311.2040272-6-linus.walleij@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fe9541a8-4e43-4c2e-57d8-08d980487219
x-ms-traffictypediagnostic: HE1PR0301MB2139:
x-microsoft-antispam-prvs: <HE1PR0301MB213905D330A00144D603F7A783A59@HE1PR0301MB2139.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8/M2lCnF5ZC5igrPiVEftQhcPZNeaFZrS7aWQphxNrDfXgCNQXyAgZVrgO3CYm74JITkKbIOPt1Zb9KdnaV2SZ5ZxdJOZTn1uEIVwx1QBtq/NsfWSg84DmNT/ao/HfMZIeHJDTazLpe9uYG1vjNkin4AgjH856fjMeVdjQF78BrRei/OYEa5Q2m83Ncy8qvCkbCwPzRSXQfll0aB/e8smp01kbMhb0XAvINFu3I/ZwkSU/zJLHGSWfTQwGq1FuFH7BnXSjIlt8XmTlZGfJxe3xdFi/0KxZx0yvPQK1ScMLveisRNXMuWCPRHX78AzS5d+aNcUxT8r5MW+yll0VQr/iOeWAbaDXISa9YphbAp1/IoKH4hcTzTuvr4yAVXS7csZunqc7Ksxbo6EA/Gwn8XN5EJsaBbkAnCqqJmvEnU4Nh/UsnO9TDwR0Tpg08ZTzj4WpiqY1r72dszox9Z5oHfpGpCZzKFVafgncZXtn1p6+4jPxyjME6lgs5mVobjl6mE1NJb8MSANee4S5trI1Z2+Y8gz1Ny4DsGSw7huHO0NuzucaQh/K1V9DeuKXDEVXbjBNiQzvjQbXcSqDkWqhiiXpvnJ2Szie2u1DDz1rQiAU7Sr9otnuH9nsUQD8WjVTtzREzDaXDHzuhvgemQkTw/B3kqk581UI1nqdwPorLtkzfZgthhnNFr9kKZ9jArMwUfoOXdHmV+Psidgd/IYpUcwQVC7UropwvcowbUTYYo54c6idO5ts2C0CSA3CZ76ECqif9rLa5m47N6NuvbWh2tXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(53546011)(6512007)(66476007)(6486002)(8936002)(76116006)(64756008)(31686004)(4326008)(26005)(54906003)(110136005)(8976002)(8676002)(66556008)(66446008)(5660300002)(2906002)(38070700005)(66946007)(2616005)(38100700002)(85202003)(7416002)(6506007)(36756003)(86362001)(508600001)(186003)(71200400001)(31696002)(85182001)(83380400001)(122000001)(66574015)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SGVUb3BDQjJ6L3FtekNZQ0hTd0dFd1hIUDNQeHFvTXptd2JNRjJmWENRUExw?=
 =?utf-8?B?QWdpNXhBUE93QmVncEEzYlU0Wmo4aVI3ckVuazBCN1NwYzgySk03cEpTd3NI?=
 =?utf-8?B?SWZIT0pOaFRPbkdrRmZyYmxCam5GU2YrMXFtSFRjTWZ0Z0ZBSlJmS3BZZURR?=
 =?utf-8?B?T2FoVnN4a2d0NVJ6eVRIRUxjdWE1czVaS3ZNajdwK2x6YkR0Z3ZYc0RqZ3lP?=
 =?utf-8?B?V1UzZ3ZsUjM0V0lNTWxDQ1NPVjNacDl1M3pCR21TMlNOWFhRR0ZpUVVRTDQ1?=
 =?utf-8?B?RHNGNmV5QUVVWGVZNW9DTHA3WjlpWkkxRUUraFlKa0ZiZFlja1FBSFNWcUx0?=
 =?utf-8?B?WmxON0k3eEVFbXgyYW9PczN1d3ZHMjJOM2Fjc1JSV1JuU3Z3Umw0ZlJ3K2RL?=
 =?utf-8?B?dFBsZ2NXeXNvNStJY3JtdVdXVEYxdjRPZ1ZidjJrQzhtYlg1WFpQeGhrZVlM?=
 =?utf-8?B?V09JalJLeFMyb1FkVFpwZDlSdW52LzRwNnBSeWpiYkFPQ1JCQTh6UjM0Z2g0?=
 =?utf-8?B?ZnBlOUNBRVZrOVdic2M0Tkt3NGhNZjZDdCsrdmY4T1hHeXRHWGo1R242MjE0?=
 =?utf-8?B?Snc3Y3E0WWxFbUVaT3RJMlBVUXVMQ2VqTDJzTEM3c0NUMFFaVjM4MG1HVWVt?=
 =?utf-8?B?SStwcWo1RkZuUWhsOFhLMVgxcERjSXlnRGttUC9zbTdqVlkwN2wvWXhTMVJu?=
 =?utf-8?B?Y3dmb0RtUmQvOU9oVWZZL25QenZIUDREeGNKNDQzSURSMWtFb1pVRm9zQkZG?=
 =?utf-8?B?Y2dPaVJXZUdoelM2TlRsUjg5VWhmU2FpUnYyalhDOUNLc0p3LzZ4OWwrZ2di?=
 =?utf-8?B?WU9rb3dDZEJ6YTZSS0tlUjdxZU9qVlZRcVpRa3dlS21sbHNFR085S0pRL1BO?=
 =?utf-8?B?YVdNTnZYcnQ2SjB1QnhlUHNGdDlnY1E5TC9PMWpwazQ5aEs2dFJIMndZcDA3?=
 =?utf-8?B?WDZ5ejVhbVRGQXBBdDdLb0tyVmJOTEgyNDBvUWJrYVpEamZtOGZ3ZEt1bGFI?=
 =?utf-8?B?RlFzdzhvbHVCcjVzSkpQZXFoc0hpaTgvWExqZGw3ZWlKU01LQldzL1dGUkRC?=
 =?utf-8?B?czI2M2ZUQmNHTUxSRUY1RVdHaEoySUExclMzU1hwNERWaUt2NGF2MDdZRVNZ?=
 =?utf-8?B?K3hJMTFhMmh3aGZvT3BkNXh0SW1ycElzdzhMZUxoU3lERHoxYlYxRTZ5RVBv?=
 =?utf-8?B?VE45eHhnRXE4TmQ3S2FieWlrS1RFYUxmWHNZTTZFMjRuQ2dnL3V6K1pSMUhj?=
 =?utf-8?B?b3BJeWVwMjlsQmR0RkI5UlBpVHpjREQ1cGwzK3d4alZHL2tHUWdwci9DZk9L?=
 =?utf-8?B?L1ZCR0lBRE9vSlFFOVdhaDg0QWNQdUhOb3hzTEQ0cklVaFdURUFGMjFhMjZp?=
 =?utf-8?B?d2pRZmN6LzdibHMzWEVoRnhrTjJHTUhLZVB2Y1F1TlAwQ09XdzZ2S1J4dXlq?=
 =?utf-8?B?MVF5WFNpU1pWVDVnWGhGQ2VNcHVObnJsbUhCd1NVNWIvbFdBRmxRUFY2UlpZ?=
 =?utf-8?B?Vy9RRlF1OHo0R2UzK0pCUVY0S1oyNU0vTDk1OEFObXV5dmFhWEptcmhWRFJy?=
 =?utf-8?B?TGFsSTErcURpdFFRRVY4L21IV0tUU0NqVkJxWndlOXJWSnFJVGhnbFhUcFMw?=
 =?utf-8?B?Y2dIamtncUlSeTh4Y0NBUlFtajZEWTNwcjJnNzFwVjdDVlBxblFqY2YwL28r?=
 =?utf-8?B?L2VVQ3E3REVmVDErdnJ4d0JacjFpck9rd0FwSWtYNW04YlV1Wm5xcEpvRHo5?=
 =?utf-8?B?Wk5tamovS3Q3YU9UNWFJMWkveUFjL1RGZzYzS1J6WEdLNWI2UHFHUDVYd2tj?=
 =?utf-8?B?aFIrZmh6c2pQNDg3dWppQT09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <142A984F2C19DC4C9CE2C9F7A939B3BA@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe9541a8-4e43-4c2e-57d8-08d980487219
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2021 17:18:08.8270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3blwx+5lCLfmdJuYyy9PFlJW14WcMWxONBDYUXX+MrXNizvqIfMcuwg4ACPnsXcjqEb8z1Ld8i4WBfLESdZYGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2139
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOS8yNS8yMSAzOjIzIFBNLCBMaW51cyBXYWxsZWlqIHdyb3RlOg0KPiBXZSB3ZXJlIGNoZWNr
aW5nIHRoYXQgdGhlIE1DIChtZW1iZXIgY29uZmlnKSB3YXMgIT0gMA0KDQpNaW5vciBuaXRwaWNr
OiBhY3R1YWxseSB3ZSB3ZXJlIGNoZWNraW5nIHRoZSB1bnRhZyBtYXNrICE9IDAsIHJpZ2h0Pw0K
DQpUaGUgY2hhbmdlIGl0c2VsZiBzZWVtcyBmaW5lIHRob3VnaDoNCg0KUmV2aWV3ZWQtYnk6IEFs
dmluIMWgaXByYWdhIDxhbHNpQGJhbmctb2x1ZnNlbi5kaz4NCg0KPiBmb3Igc29tZSByZWFzb24s
IGFsbCB3ZSBuZWVkIHRvIGNoZWNrIGlzIHRoYXQgdGhlIGNvbmZpZw0KPiBoYXMgbm8gcG9ydHMs
IGkuZS4gbm8gbWVtYmVycy4gVGhlbiBpdCBjYW4gYmUgcmVjeWNsZWQuDQo+IFRoaXMgbXVzdCBi
ZSBzb21lIG1pc3VuZGVyc3RhbmRpbmcuDQo+IA0KPiBGaXhlczogNGRkY2FmMWViYjVlICgibmV0
OiBkc2E6IHJ0bDgzNjY6IFByb3Blcmx5IGNsZWFyIG1lbWJlciBjb25maWciKQ0KPiBDYzogVmxh
ZGltaXIgT2x0ZWFuIDxvbHRlYW52QGdtYWlsLmNvbT4NCj4gQ2M6IE1hdXJpIFNhbmRiZXJnIDxz
YW5kYmVyZ0BtYWlsZmVuY2UuY29tPg0KPiBDYzogQWx2aW4gxaBpcHJhZ2EgPGFsc2lAYmFuZy1v
bHVmc2VuLmRrPg0KPiBDYzogRmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+
DQo+IENjOiBERU5HIFFpbmdmYW5nIDxkcWZleHRAZ21haWwuY29tPg0KPiBSZXZpZXdlZC1ieTog
RmxvcmlhbiBGYWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6
IExpbnVzIFdhbGxlaWogPGxpbnVzLndhbGxlaWpAbGluYXJvLm9yZz4NCj4gLS0tDQo+IENoYW5n
ZUxvZyB2NS0+djY6DQo+IC0gTm8gY2hhbmdlcyBqdXN0IHJlc2VuZGluZyB3aXRoIHRoZSByZXN0
IG9mIHRoZQ0KPiAgICBwYXRjaGVzLg0KPiBDaGFuZ2VMb2cgdjQtPnY1Og0KPiAtIENvbGxlY3Qg
RmxvcmlhbnMgcmV2aWV3IHRhZw0KPiAtIEFkZCBGaXhlcyB0YWcNCj4gQ2hhbmdlTG9nIHYxLT52
NDoNCj4gLSBOZXcgcGF0Y2ggZm9yIGEgYnVnIGZvdW5kIHdoaWxlIGZpeGluZyB0aGUgb3RoZXIg
aXNzdWVzLg0KPiAtLS0NCj4gICBkcml2ZXJzL25ldC9kc2EvcnRsODM2Ni5jIHwgMiArLQ0KPiAg
IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9ydGw4MzY2LmMgYi9kcml2ZXJzL25ldC9kc2EvcnRs
ODM2Ni5jDQo+IGluZGV4IDA2NzJkZDU2YzY5OC4uZjgxNWNkMTZhZDQ4IDEwMDY0NA0KPiAtLS0g
YS9kcml2ZXJzL25ldC9kc2EvcnRsODM2Ni5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9ydGw4
MzY2LmMNCj4gQEAgLTM3NCw3ICszNzQsNyBAQCBpbnQgcnRsODM2Nl92bGFuX2RlbChzdHJ1Y3Qg
ZHNhX3N3aXRjaCAqZHMsIGludCBwb3J0LA0KPiAgIAkJCSAqIGFueW1vcmUgdGhlbiBjbGVhciB0
aGUgd2hvbGUgbWVtYmVyDQo+ICAgCQkJICogY29uZmlnIHNvIGl0IGNhbiBiZSByZXVzZWQuDQo+
ICAgCQkJICovDQo+IC0JCQlpZiAoIXZsYW5tYy5tZW1iZXIgJiYgdmxhbm1jLnVudGFnKSB7DQo+
ICsJCQlpZiAoIXZsYW5tYy5tZW1iZXIpIHsNCj4gICAJCQkJdmxhbm1jLnZpZCA9IDA7DQo+ICAg
CQkJCXZsYW5tYy5wcmlvcml0eSA9IDA7DQo+ICAgCQkJCXZsYW5tYy5maWQgPSAwOw0KPiANCg0K
