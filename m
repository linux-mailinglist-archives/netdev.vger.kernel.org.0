Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4AA4117E35
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 04:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfLJDhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 22:37:05 -0500
Received: from mail-eopbgr680134.outbound.protection.outlook.com ([40.107.68.134]:57472
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726631AbfLJDhF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 22:37:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MpqVGUYW0c+tkICQ0WKyg7NXrJRnrG/Vi5H6vjvWpe8ZtK9Lu2IrT7IJEUsR+Ypo1zAl0v0LCHZPlbhM0Er1yzDbPVoQ21qYKfVak0IP+/HdDITh123Oj141VbiSjYs4+ihaCnLA9ljCVNPoSyiJY9OwLEL1/G3ho+4ib0V4PZNxroBciAxCaXLuXdV8V5ogxOKjEWu1uIcpz7+3G+EPq2npEWrLNTQSLYwy3xHVgYxdij81V4Wo1IhEDnvqCls287IWSI2ip2QttbCWMcJqzC5Q/87WmBPOcMvSUk8WbSbsIXF2fVrMg9vb0tf9jY9ry4ns5DafLmdc8p7wzQjGxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JCEyDoZN8Ye4ldjJauUdJCxPc1mDgdamjKVtTztz0d8=;
 b=GUBnB9qwp1ECd5/3S/NwohMHlep+YMTkDwlL+xGktGCOBx8FSSizWsYehNSumORJnaTCFF50+rY+B63f1rKSSNqYZQwF1nU4JXAf3XHkjJN6r9KP8IOIW7saGNxABrVQOe3wdZvXWXEMQ3wFH/sVHyuFo59Nj0W+f0niWWVs0PhgR+DSQ6H08WBwDqwEUz7M0GdAma61kJUYPeTJl11U3gA3UJAO13PUW+XM7JKVa0JPclp9h6QiM232dovb29bRAxxjotOrfldUfO1TxpJKe0PWtxUbjqwCIyusrkO7G17QmgUeJnHDQdtV+m8ErVE3NYJ9VU5YprFpXsuLqe8iUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cypress.com; dmarc=pass action=none header.from=cypress.com;
 dkim=pass header.d=cypress.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JCEyDoZN8Ye4ldjJauUdJCxPc1mDgdamjKVtTztz0d8=;
 b=EtJmj+E1vg383+DacYRYjUqzGDrBJNJZ0SFVenObVr7VBmX7m8a5PBTdC324+PxnQB7p3AfO/AE6bw1vUFo4DxFr5NMybyhBV2T1byismFpJ72+LLn3qR2q8mRFnEWVvbyXtiL0wHoZ2xXJcl+DOzsEWaCxPhS/rswWtL7TrtjE=
Received: from CY4PR06MB2342.namprd06.prod.outlook.com (10.169.185.149) by
 CY4PR06MB2646.namprd06.prod.outlook.com (10.173.39.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Tue, 10 Dec 2019 03:36:59 +0000
Received: from CY4PR06MB2342.namprd06.prod.outlook.com
 ([fe80::4930:d9e2:2f15:868d]) by CY4PR06MB2342.namprd06.prod.outlook.com
 ([fe80::4930:d9e2:2f15:868d%3]) with mapi id 15.20.2538.012; Tue, 10 Dec 2019
 03:36:59 +0000
From:   Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
To:     Soeren Moch <smoch@web.de>, Kalle Valo <kvalo@codeaurora.org>
CC:     Wright Feng <Wright.Feng@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] brcmfmac: reset two D11 cores if chip has two D11
 cores
Thread-Topic: [PATCH 1/8] brcmfmac: reset two D11 cores if chip has two D11
 cores
Thread-Index: AQHVruFivdF3yg8HLUiWyyb8GU6mkqeyuF2A
Date:   Tue, 10 Dec 2019 03:36:59 +0000
Message-ID: <198521ec-cb41-701c-06d7-0432564dd0d2@cypress.com>
References: <20191209223822.27236-1-smoch@web.de>
In-Reply-To: <20191209223822.27236-1-smoch@web.de>
Reply-To: Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [61.222.14.99]
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
x-clientproxiedby: BYAPR06CA0034.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::47) To CY4PR06MB2342.namprd06.prod.outlook.com
 (2603:10b6:903:13::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chi-Hsien.Lin@cypress.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1d47be61-533a-4fa0-9f72-08d77d22366c
x-ms-traffictypediagnostic: CY4PR06MB2646:|CY4PR06MB2646:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR06MB26463AC3E62CD9B52911C6CEBB5B0@CY4PR06MB2646.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(376002)(39860400002)(136003)(189003)(199004)(8936002)(36756003)(6512007)(316002)(2906002)(2616005)(3450700001)(305945005)(31696002)(81166006)(4326008)(81156014)(66446008)(186003)(31686004)(8676002)(64756008)(53546011)(66556008)(66476007)(66946007)(6506007)(478600001)(54906003)(52116002)(26005)(110136005)(229853002)(86362001)(6486002)(5660300002)(71200400001)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR06MB2646;H:CY4PR06MB2342.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cypress.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: grtbSM7AFKV6mFFpw0p/CT6LOQ/9EUa2Hat/kUIF80XHH8ai5lFv6iVVzmDxkwPkTgZTym5EsfSo4i6s2lMv6M9btFPHZRGrHVsfV/sWlfeBpIH9lPKZmzG0nCcMdITmyGuXK8Jm3M/EvZTkqJCHCW6/W8TcJgZG3HqjkVwQbOMIfrsXkMDfgVt2KRkrvuOAHTfsZBHFLyZTivmIwrozk3ZsPH+Yknbl1e7IMX/Lmsrlhem5VZR2Gr88fmYFIG6u3h0rJlt3yyrxja3ng0uD6rgwRTEYKz9Ce82J/0F9CEpZygUDCbHUV1z7G3ho7vHlrk58aavLJz/6wT9ystzHyzND7yT+GvHbfgpubq2/9gdqvzqeQxCC4KHesUuHp0AH2klXzW3HKjsbKWcxI/3s/ypU/YK4R3ovM3saHmSesx5Lv5xFT7AhafEVEsBnA0N1
Content-Type: text/plain; charset="utf-8"
Content-ID: <72EDCE6390132B49BDD42471533E670F@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d47be61-533a-4fa0-9f72-08d77d22366c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 03:36:59.5561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d5T1dSwbBlzAzVJp6/yh7GCnVrlo6/CHR5i1+zL5EVwP93UYw7PLz3n7sc/1O//1azEZGWgx1ebFyXr82g3vEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR06MB2646
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzEwLzIwMTkgNjozOCwgU29lcmVuIE1vY2ggd3JvdGU6DQo+IEZyb206IFdyaWdo
dCBGZW5nIDx3cmlnaHQuZmVuZ0BjeXByZXNzLmNvbT4NCj4gDQo+IFRoZXJlIGFyZSB0d28gRDEx
IGNvcmVzIGluIFJTREIgY2hpcHMgbGlrZSA0MzU5LiBXZSBoYXZlIHRvIHJlc2V0IHR3bw0KPiBE
MTEgY29yZXMgc2ltdXRhbmVvdXNseSBiZWZvcmUgZmlybXdhcmUgZG93bmxvYWQsIG9yIHRoZSBm
aXJtd2FyZSBtYXkNCj4gbm90IGJlIGluaXRpYWxpemVkIGNvcnJlY3RseSBhbmQgY2F1c2UgImZ3
IGluaXRpYWxpemVkIGZhaWxlZCIgZXJyb3IuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBXcmlnaHQg
RmVuZyA8d3JpZ2h0LmZlbmdAY3lwcmVzcy5jb20+DQpSZXZpZXdlZC1ieTogQ2hpLUhzaWVuIExp
biA8Y2hpLWhzaWVuLmxpbkBjeXByZXNzLmNvbT4NCg0KPiAtLS0NCj4gQ2M6IEthbGxlIFZhbG8g
PGt2YWxvQGNvZGVhdXJvcmEub3JnPg0KPiBDYzogQXJlbmQgdmFuIFNwcmllbCA8YXJlbmQudmFu
c3ByaWVsQGJyb2FkY29tLmNvbT4NCj4gQ2M6IEZyYW5reSBMaW4gPGZyYW5reS5saW5AYnJvYWRj
b20uY29tPg0KPiBDYzogSGFudGUgTWV1bGVtYW4gPGhhbnRlLm1ldWxlbWFuQGJyb2FkY29tLmNv
bT4NCj4gQ2M6IENoaS1Ic2llbiBMaW4gPGNoaS1oc2llbi5saW5AY3lwcmVzcy5jb20+DQo+IENj
OiBXcmlnaHQgRmVuZyA8d3JpZ2h0LmZlbmdAY3lwcmVzcy5jb20+DQo+IENjOiBsaW51eC13aXJl
bGVzc0B2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGJyY204MDIxMS1kZXYtbGlzdC5wZGxAYnJvYWRj
b20uY29tDQo+IENjOiBicmNtODAyMTEtZGV2LWxpc3RAY3lwcmVzcy5jb20NCj4gQ2M6IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4g
LS0tDQo+ICAgLi4uL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9jaGlwLmMgICAgICAgIHwg
NTAgKysrKysrKysrKysrKysrKysrKw0KPiAgIC4uLi9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZt
YWMvY2hpcC5oICAgICAgICB8ICAxICsNCj4gICAuLi4vYnJvYWRjb20vYnJjbTgwMjExL2JyY21m
bWFjL3BjaWUuYyAgICAgICAgfCAgMiArLQ0KPiAgIDMgZmlsZXMgY2hhbmdlZCwgNTIgaW5zZXJ0
aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9jaGlwLmMgYi9kcml2ZXJzL25ldC93
aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY2hpcC5jDQo+IGluZGV4IGE3OTVk
NzgxYjRjNS4uMGI1ZmJlNWQ4MjcwIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVz
cy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY2hpcC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1hYy9jaGlwLmMNCj4gQEAgLTQzMywx
MSArNDMzLDI1IEBAIHN0YXRpYyB2b2lkIGJyY21mX2NoaXBfYWlfcmVzZXRjb3JlKHN0cnVjdCBi
cmNtZl9jb3JlX3ByaXYgKmNvcmUsIHUzMiBwcmVyZXNldCwNCj4gICB7DQo+ICAgCXN0cnVjdCBi
cmNtZl9jaGlwX3ByaXYgKmNpOw0KPiAgIAlpbnQgY291bnQ7DQo+ICsJc3RydWN0IGJyY21mX2Nv
cmUgKmQxMWNvcmUyID0gTlVMTDsNCj4gKwlzdHJ1Y3QgYnJjbWZfY29yZV9wcml2ICpkMTFwcml2
MiA9IE5VTEw7DQo+IA0KPiAgIAljaSA9IGNvcmUtPmNoaXA7DQo+IA0KPiArCS8qIHNwZWNpYWwg
aGFuZGxlIHR3byBEMTEgY29yZXMgcmVzZXQgKi8NCj4gKwlpZiAoY29yZS0+cHViLmlkID09IEJD
TUFfQ09SRV84MDIxMSkgew0KPiArCQlkMTFjb3JlMiA9IGJyY21mX2NoaXBfZ2V0X2QxMWNvcmUo
JmNpLT5wdWIsIDEpOw0KPiArCQlpZiAoZDExY29yZTIpIHsNCj4gKwkJCWJyY21mX2RiZyhJTkZP
LCAiZm91bmQgdHdvIGQxMSBjb3JlcywgcmVzZXQgYm90aFxuIik7DQo+ICsJCQlkMTFwcml2MiA9
IGNvbnRhaW5lcl9vZihkMTFjb3JlMiwNCj4gKwkJCQkJCXN0cnVjdCBicmNtZl9jb3JlX3ByaXYs
IHB1Yik7DQo+ICsJCX0NCj4gKwl9DQo+ICsNCj4gICAJLyogbXVzdCBkaXNhYmxlIGZpcnN0IHRv
IHdvcmsgZm9yIGFyYml0cmFyeSBjdXJyZW50IGNvcmUgc3RhdGUgKi8NCj4gICAJYnJjbWZfY2hp
cF9haV9jb3JlZGlzYWJsZShjb3JlLCBwcmVyZXNldCwgcmVzZXQpOw0KPiArCWlmIChkMTFwcml2
MikNCj4gKwkJYnJjbWZfY2hpcF9haV9jb3JlZGlzYWJsZShkMTFwcml2MiwgcHJlcmVzZXQsIHJl
c2V0KTsNCj4gDQo+ICAgCWNvdW50ID0gMDsNCj4gICAJd2hpbGUgKGNpLT5vcHMtPnJlYWQzMihj
aS0+Y3R4LCBjb3JlLT53cmFwYmFzZSArIEJDTUFfUkVTRVRfQ1RMKSAmDQo+IEBAIC00NDksOSAr
NDYzLDMwIEBAIHN0YXRpYyB2b2lkIGJyY21mX2NoaXBfYWlfcmVzZXRjb3JlKHN0cnVjdCBicmNt
Zl9jb3JlX3ByaXYgKmNvcmUsIHUzMiBwcmVyZXNldCwNCj4gICAJCXVzbGVlcF9yYW5nZSg0MCwg
NjApOw0KPiAgIAl9DQo+IA0KPiArCWlmIChkMTFwcml2Mikgew0KPiArCQljb3VudCA9IDA7DQo+
ICsJCXdoaWxlIChjaS0+b3BzLT5yZWFkMzIoY2ktPmN0eCwNCj4gKwkJCQkgICAgICAgZDExcHJp
djItPndyYXBiYXNlICsgQkNNQV9SRVNFVF9DVEwpICYNCj4gKwkJCQkgICAgICAgQkNNQV9SRVNF
VF9DVExfUkVTRVQpIHsNCj4gKwkJCWNpLT5vcHMtPndyaXRlMzIoY2ktPmN0eCwNCj4gKwkJCQkJ
IGQxMXByaXYyLT53cmFwYmFzZSArIEJDTUFfUkVTRVRfQ1RMLA0KPiArCQkJCQkgMCk7DQo+ICsJ
CQljb3VudCsrOw0KPiArCQkJaWYgKGNvdW50ID4gNTApDQo+ICsJCQkJYnJlYWs7DQo+ICsJCQl1
c2xlZXBfcmFuZ2UoNDAsIDYwKTsNCj4gKwkJfQ0KPiArCX0NCj4gKw0KPiAgIAljaS0+b3BzLT53
cml0ZTMyKGNpLT5jdHgsIGNvcmUtPndyYXBiYXNlICsgQkNNQV9JT0NUTCwNCj4gICAJCQkgcG9z
dHJlc2V0IHwgQkNNQV9JT0NUTF9DTEspOw0KPiAgIAljaS0+b3BzLT5yZWFkMzIoY2ktPmN0eCwg
Y29yZS0+d3JhcGJhc2UgKyBCQ01BX0lPQ1RMKTsNCj4gKw0KPiArCWlmIChkMTFwcml2Mikgew0K
PiArCQljaS0+b3BzLT53cml0ZTMyKGNpLT5jdHgsIGQxMXByaXYyLT53cmFwYmFzZSArIEJDTUFf
SU9DVEwsDQo+ICsJCQkJIHBvc3RyZXNldCB8IEJDTUFfSU9DVExfQ0xLKTsNCj4gKwkJY2ktPm9w
cy0+cmVhZDMyKGNpLT5jdHgsIGQxMXByaXYyLT53cmFwYmFzZSArIEJDTUFfSU9DVEwpOw0KPiAr
CX0NCj4gICB9DQo+IA0KPiAgIGNoYXIgKmJyY21mX2NoaXBfbmFtZSh1MzIgaWQsIHUzMiByZXYs
IGNoYXIgKmJ1ZiwgdWludCBsZW4pDQo+IEBAIC0xMTA5LDYgKzExNDQsMjEgQEAgdm9pZCBicmNt
Zl9jaGlwX2RldGFjaChzdHJ1Y3QgYnJjbWZfY2hpcCAqcHViKQ0KPiAgIAlrZnJlZShjaGlwKTsN
Cj4gICB9DQo+IA0KPiArc3RydWN0IGJyY21mX2NvcmUgKmJyY21mX2NoaXBfZ2V0X2QxMWNvcmUo
c3RydWN0IGJyY21mX2NoaXAgKnB1YiwgdTggdW5pdCkNCj4gK3sNCj4gKwlzdHJ1Y3QgYnJjbWZf
Y2hpcF9wcml2ICpjaGlwOw0KPiArCXN0cnVjdCBicmNtZl9jb3JlX3ByaXYgKmNvcmU7DQo+ICsN
Cj4gKwljaGlwID0gY29udGFpbmVyX29mKHB1Yiwgc3RydWN0IGJyY21mX2NoaXBfcHJpdiwgcHVi
KTsNCj4gKwlsaXN0X2Zvcl9lYWNoX2VudHJ5KGNvcmUsICZjaGlwLT5jb3JlcywgbGlzdCkgew0K
PiArCQlpZiAoY29yZS0+cHViLmlkID09IEJDTUFfQ09SRV84MDIxMSkgew0KPiArCQkJaWYgKHVu
aXQtLSA9PSAwKQ0KPiArCQkJCXJldHVybiAmY29yZS0+cHViOw0KPiArCQl9DQo+ICsJfQ0KPiAr
CXJldHVybiBOVUxMOw0KPiArfQ0KPiArDQo+ICAgc3RydWN0IGJyY21mX2NvcmUgKmJyY21mX2No
aXBfZ2V0X2NvcmUoc3RydWN0IGJyY21mX2NoaXAgKnB1YiwgdTE2IGNvcmVpZCkNCj4gICB7DQo+
ICAgCXN0cnVjdCBicmNtZl9jaGlwX3ByaXYgKmNoaXA7DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY2hpcC5oIGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2NoaXAuaA0KPiBpbmRl
eCA3YjAwZjZhNTllODkuLjhmYTM4NjU4ZTcyNyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQv
d2lyZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL2NoaXAuaA0KPiArKysgYi9kcml2
ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvY2hpcC5oDQo+IEBA
IC03NCw2ICs3NCw3IEBAIHN0cnVjdCBicmNtZl9jaGlwICpicmNtZl9jaGlwX2F0dGFjaCh2b2lk
ICpjdHgsDQo+ICAgCQkJCSAgICAgY29uc3Qgc3RydWN0IGJyY21mX2J1c2NvcmVfb3BzICpvcHMp
Ow0KPiAgIHZvaWQgYnJjbWZfY2hpcF9kZXRhY2goc3RydWN0IGJyY21mX2NoaXAgKmNoaXApOw0K
PiAgIHN0cnVjdCBicmNtZl9jb3JlICpicmNtZl9jaGlwX2dldF9jb3JlKHN0cnVjdCBicmNtZl9j
aGlwICpjaGlwLCB1MTYgY29yZWlkKTsNCj4gK3N0cnVjdCBicmNtZl9jb3JlICpicmNtZl9jaGlw
X2dldF9kMTFjb3JlKHN0cnVjdCBicmNtZl9jaGlwICpwdWIsIHU4IHVuaXQpOw0KPiAgIHN0cnVj
dCBicmNtZl9jb3JlICpicmNtZl9jaGlwX2dldF9jaGlwY29tbW9uKHN0cnVjdCBicmNtZl9jaGlw
ICpjaGlwKTsNCj4gICBzdHJ1Y3QgYnJjbWZfY29yZSAqYnJjbWZfY2hpcF9nZXRfcG11KHN0cnVj
dCBicmNtZl9jaGlwICpwdWIpOw0KPiAgIGJvb2wgYnJjbWZfY2hpcF9pc2NvcmV1cChzdHJ1Y3Qg
YnJjbWZfY29yZSAqY29yZSk7DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9i
cm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvcGNpZS5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
YnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL3BjaWUuYw0KPiBpbmRleCBmNjRjZTUwNzRhNTUu
LjdhYzcyODA0ZTI4NSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRj
b20vYnJjbTgwMjExL2JyY21mbWFjL3BjaWUuYw0KPiArKysgYi9kcml2ZXJzL25ldC93aXJlbGVz
cy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvcGNpZS5jDQo+IEBAIC03OCw3ICs3OCw3IEBA
IHN0YXRpYyBjb25zdCBzdHJ1Y3QgYnJjbWZfZmlybXdhcmVfbWFwcGluZyBicmNtZl9wY2llX2Z3
bmFtZXNbXSA9IHsNCj4gICAJQlJDTUZfRldfRU5UUlkoQlJDTV9DQ180MzcxX0NISVBfSUQsIDB4
RkZGRkZGRkYsIDQzNzEpLA0KPiAgIH07DQo+IA0KPiAtI2RlZmluZSBCUkNNRl9QQ0lFX0ZXX1VQ
X1RJTUVPVVQJCTIwMDAgLyogbXNlYyAqLw0KPiArI2RlZmluZSBCUkNNRl9QQ0lFX0ZXX1VQX1RJ
TUVPVVQJCTUwMDAgLyogbXNlYyAqLw0KPiANCj4gICAjZGVmaW5lIEJSQ01GX1BDSUVfUkVHX01B
UF9TSVpFCQkJKDMyICogMTAyNCkNCj4gDQo+IC0tDQo+IDIuMTcuMQ0KPiANCj4gLg0KPiANCg==
