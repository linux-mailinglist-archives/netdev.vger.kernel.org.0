Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B36ED13BB78
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 09:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgAOIsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 03:48:21 -0500
Received: from mail-eopbgr10066.outbound.protection.outlook.com ([40.107.1.66]:47543
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726472AbgAOIsU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 03:48:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9hmSRhslR828K/oeWPKCcbebGdNAnNUUAXlZPmIkl/Oe+OhqDWWYxQxqThlWM/n7fttjBuTcKO5Kqo/3S+cIBaANdc0ngTrojQnS7Okg9iyYYMjpMyvpzGeJIpjhkiBptinUG5zszxaKQwYrMMwJZL8L7/hp3qUzqBk+dur5obHTzkUNh7JkcVUZswhvmAaJ7K1KWRr+EVoh9Zlf6pk6rETZWTuGAZwPUXSPOwUPSTWmXsQI6Z8kvbTH3Lr088PDGyTA8kEl4yORNpvLESrLUn14X2xZGf3MmH0mpPGMDKA5DNgR0g9+a9aqfWdydfcOuiHYCIUKTO/21bAqUtVZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zSYnQeV8gD/rB8+nCGictjkWTs3kFGpx/Q6Q5J8ets0=;
 b=MzAIvdoV38JjwjVdwpeWF9mG4ymLzTpDxaEFQKufteaOKAA/W/6+7mIUlvpz5QlcmEzNGugaMfn1a1e9xy1NLrdvrkQ9dfsggQOiCbU218DFuPNmkevxdTkGcZc0juVMhXuQNFAYQAP2FVVx798/DFmNu7VjS03RJvOlCY+KSzAdXU6vbQF1d6IuUmbsKgh1Eu6x7ABQnvR/OY5I822EGpfYiX8oc48/k/YqGmCEIVkVFeanm4+rlN3qpE+cuuXfEMwBVCFLNwLG8gC6aPdxaPoyG6afUOuaN4DIkeyHyPU07mIdOAimF6tcmhY8LoNj+dHdeBJ6a9mwdo4OoT5/Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zSYnQeV8gD/rB8+nCGictjkWTs3kFGpx/Q6Q5J8ets0=;
 b=DPX3KBgsp85IihXBecW0fkd3oMI+K134m7oyecgscJkzy06No+s48XimqgqfonhQ/9pVkFuJ0iBFb/y6Wy4uT4cNT/uz6fAMqf1fD0exxh0/W4yVCrpW0T3w3l9T2q+EB1HqSW6u+hcGu4fgVuqPbe4SfxIRB2DYXP3wb4278cw=
Received: from AM4PR05MB3396.eurprd05.prod.outlook.com (10.171.187.33) by
 AM4PR05MB3427.eurprd05.prod.outlook.com (10.171.187.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Wed, 15 Jan 2020 08:48:14 +0000
Received: from AM4PR05MB3396.eurprd05.prod.outlook.com
 ([fe80::4ddd:bf4e:72d0:a720]) by AM4PR05MB3396.eurprd05.prod.outlook.com
 ([fe80::4ddd:bf4e:72d0:a720%2]) with mapi id 15.20.2623.017; Wed, 15 Jan 2020
 08:48:14 +0000
Received: from [10.223.0.122] (193.47.165.251) by AM4PR0101CA0072.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.12 via Frontend Transport; Wed, 15 Jan 2020 08:48:14 +0000
From:   Roi Dayan <roid@mellanox.com>
To:     "wenxu@ucloud.cn" <wenxu@ucloud.cn>,
        Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net/mlx5e: Add mlx5e_flower_parse_meta
 support
Thread-Topic: [PATCH net-next v2] net/mlx5e: Add mlx5e_flower_parse_meta
 support
Thread-Index: AQHVxTsdBu3bf++RUEKRiOEG0pF5HafrdpMA
Date:   Wed, 15 Jan 2020 08:48:14 +0000
Message-ID: <33095557-6072-00f6-dcf3-0621fa533d83@mellanox.com>
References: <1578388566-27310-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1578388566-27310-1-git-send-email-wenxu@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
x-clientproxiedby: AM4PR0101CA0072.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::40) To AM4PR05MB3396.eurprd05.prod.outlook.com
 (2603:10a6:205:5::33)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=roid@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2a9ed151-498c-4a56-182a-08d79997a8a0
x-ms-traffictypediagnostic: AM4PR05MB3427:|AM4PR05MB3427:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB342778E9A7D990E9A3294EBAB5370@AM4PR05MB3427.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(189003)(199004)(71200400001)(8676002)(5660300002)(81156014)(66446008)(64756008)(66476007)(66946007)(66556008)(966005)(86362001)(31686004)(31696002)(8936002)(478600001)(26005)(2906002)(956004)(16576012)(6486002)(2616005)(4326008)(16526019)(52116002)(110136005)(316002)(6636002)(53546011)(81166006)(36756003)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3427;H:AM4PR05MB3396.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dl76tocg402Lm17KB9X/CtMOjeq0xwm+uGuPCRy1WBDPPK8ULkCtyCWwom3o7PLYmKfTA3QUhcOv4DUwKyNVyo5N2ydPt/wQ36MFti02CD5YiKJ8+YfdBE0g2mkegdLriuShidZYO8QJGUUVk/M/Ut1437VPdGJ9MwQifw6BwYG9Ejtx9c3GLZaNb6dz1he8MKApoRZgYwmUlUiI5cLE6ufBQiIoKIIKDyqsHah1Hb1Ra4qptbohFFX8HgmMcpYz5QRxiX15keYY7+KnRztp4h7ItLBZMoHarCgdVdUReDzbBD+3NW4z8FA/h8oODrUPdWue/2M4+G2viqJr34yayrbEA0gHmwPbuimbuWeLtvOGrOQr4J/Cz2qUEIOlI1Gv2herJwTUYOKJlPSeY488VV9y1Ql8QGk/r5pUcmYeCLnQ01WehUNo869bCyOPf3ZI4ET0TjSM3Evun+NYE9mqq1zIqr7I5W+LN8xGlumyMWY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6EAB4FEB8579EA4A97946006813722B2@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a9ed151-498c-4a56-182a-08d79997a8a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 08:48:14.6329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qFH0KfVnPFrKrkaPQrhF+yA6OQ8/nzvj5ji+FIGZC3xMf8k+9rsEmyfosqAVl4MIjvhe/TDHvWUjNLZCvzvZ2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3427
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIwMjAtMDEtMDcgMTE6MTYgQU0sIHdlbnh1QHVjbG91ZC5jbiB3cm90ZToNCj4gRnJv
bTogd2VueHUgPHdlbnh1QHVjbG91ZC5jbj4NCj4gDQo+IEluIHRoZSBmbG93dGFibGVzIG9mZmxv
YWQgYWxsIHRoZSBkZXZpY2VzIGluIHRoZSBmbG93dGFibGVzDQo+IHNoYXJlIHRoZSBzYW1lIGZs
b3dfYmxvY2suIEFuIG9mZmxvYWQgcnVsZSB3aWxsIGJlIGluc3RhbGxlZCBvbg0KPiBhbGwgdGhl
IGRldmljZXMuIFRoaXMgc2NlbmFyaW8gaXMgbm90IGNvcnJlY3QuDQo+IA0KPiBJdCBpcyBubyBw
cm9ibGVtIGlmIHRoZXJlIGFyZSBvbmx5IHR3byBkZXZpY2VzIGluIHRoZSBmbG93dGFibGUsDQo+
IFRoZSBydWxlIHdpdGggaW5ncmVzcyBhbmQgZWdyZXNzIG9uIHRoZSBzYW1lIGRldmljZSBjYW4g
YmUgcmVqZWN0DQo+IGJ5IGRyaXZlci4NCj4gDQo+IEJ1dCBtb3JlIHRoYW4gdHdvIGRldmljZXMg
aW4gdGhlIGZsb3d0YWJsZSB3aWxsIGluc3RhbGwgdGhlIHdyb25nDQo+IHJ1bGVzIG9uIGhhcmR3
YXJlLg0KPiANCj4gRm9yIGV4YW1wbGU6DQo+IFRocmVlIGRldmljZXMgaW4gYSBvZmZsb2FkIGZs
b3d0YWJsZXM6IGRldl9hLCBkZXZfYiwgZGV2X2MNCj4gDQo+IEEgcnVsZSBpbmdyZXNzIGZyb20g
ZGV2X2EgYW5kIGVncmVzcyB0byBkZXZfYjoNCj4gVGhlIHJ1bGUgd2lsbCBpbnN0YWxsIG9uIGRl
dmljZSBkZXZfYS4NCj4gVGhlIHJ1bGUgd2lsbCB0cnkgdG8gaW5zdGFsbCBvbiBkZXZfYiBidXQg
ZmFpbGVkIGZvciBpbmdyZXNzDQo+IGFuZCBlZ3Jlc3Mgb24gdGhlIHNhbWUgZGV2aWNlLg0KPiBU
aGUgcnVsZSB3aWxsIGluc3RhbGwgb24gZGV2X2MuIFRoaXMgaXMgbm90IGNvcnJlY3QuDQo+IA0K
PiBUaGUgZmxvd3RhYmxlcyBvZmZsb2FkIGF2b2lkIHRoaXMgY2FzZSB0aHJvdWdoIHJlc3RyaWN0
aW5nIHRoZSBpbmdyZXNzIGRldg0KPiB3aXRoIEZMT1dfRElTU0VDVE9SX0tFWV9NRVRBIGFzIGZv
bGxvd2luZyBwYXRjaC4NCj4gaHR0cDovL3BhdGNod29yay5vemxhYnMub3JnL3BhdGNoLzEyMTgx
MDkvDQo+IA0KPiBTbyB0aGUgbWx4NWUgZHJpdmVyIGFsc28gc2hvdWxkIHN1cHBvcnQgdGhlIEZM
T1dfRElTU0VDVE9SX0tFWV9NRVRBIHBhcnNlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogd2VueHUg
PHdlbnh1QHVjbG91ZC5jbj4NCj4gLS0tDQo+IHYyOiByZW1hcCB0aGUgcGF0Y2ggZGVzY3JpcHRp
b24NCj4gDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMu
YyB8IDM5ICsrKysrKysrKysrKysrKysrKysrKysrKysNCj4gIDEgZmlsZSBjaGFuZ2VkLCAzOSBp
bnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2VuX3RjLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZW5fdGMuYw0KPiBpbmRleCA5YjMyYTljLi4zM2QxY2U1IDEwMDY0NA0KPiAtLS0g
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYw0KPiArKysg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYw0KPiBAQCAt
MTgwNSw2ICsxODA1LDQwIEBAIHN0YXRpYyB2b2lkICpnZXRfbWF0Y2hfaGVhZGVyc192YWx1ZSh1
MzIgZmxhZ3MsDQo+ICAJCQkgICAgIG91dGVyX2hlYWRlcnMpOw0KPiAgfQ0KPiAgDQo+ICtzdGF0
aWMgaW50IG1seDVlX2Zsb3dlcl9wYXJzZV9tZXRhKHN0cnVjdCBuZXRfZGV2aWNlICpmaWx0ZXJf
ZGV2LA0KPiArCQkJCSAgIHN0cnVjdCBmbG93X2Nsc19vZmZsb2FkICpmKQ0KPiArew0KPiArCXN0
cnVjdCBmbG93X3J1bGUgKnJ1bGUgPSBmbG93X2Nsc19vZmZsb2FkX2Zsb3dfcnVsZShmKTsNCj4g
KwlzdHJ1Y3QgbmV0bGlua19leHRfYWNrICpleHRhY2sgPSBmLT5jb21tb24uZXh0YWNrOw0KPiAr
CXN0cnVjdCBuZXRfZGV2aWNlICppbmdyZXNzX2RldjsNCj4gKwlzdHJ1Y3QgZmxvd19tYXRjaF9t
ZXRhIG1hdGNoOw0KPiArDQo+ICsJaWYgKCFmbG93X3J1bGVfbWF0Y2hfa2V5KHJ1bGUsIEZMT1df
RElTU0VDVE9SX0tFWV9NRVRBKSkNCj4gKwkJcmV0dXJuIDA7DQo+ICsNCj4gKwlmbG93X3J1bGVf
bWF0Y2hfbWV0YShydWxlLCAmbWF0Y2gpOw0KPiArCWlmIChtYXRjaC5tYXNrLT5pbmdyZXNzX2lm
aW5kZXggIT0gMHhGRkZGRkZGRikgew0KPiArCQlOTF9TRVRfRVJSX01TR19NT0QoZXh0YWNrLCAi
VW5zdXBwb3J0ZWQgaW5ncmVzcyBpZmluZGV4IG1hc2siKTsNCj4gKwkJcmV0dXJuIC1FSU5WQUw7
DQo+ICsJfQ0KPiArDQo+ICsJaW5ncmVzc19kZXYgPSBfX2Rldl9nZXRfYnlfaW5kZXgoZGV2X25l
dChmaWx0ZXJfZGV2KSwNCj4gKwkJCQkJIG1hdGNoLmtleS0+aW5ncmVzc19pZmluZGV4KTsNCj4g
KwlpZiAoIWluZ3Jlc3NfZGV2KSB7DQo+ICsJCU5MX1NFVF9FUlJfTVNHX01PRChleHRhY2ssDQo+
ICsJCQkJICAgIkNhbid0IGZpbmQgdGhlIGluZ3Jlc3MgcG9ydCB0byBtYXRjaCBvbiIpOw0KPiAr
CQlyZXR1cm4gLUVJTlZBTDsNCj4gKwl9DQo+ICsNCj4gKwlpZiAoaW5ncmVzc19kZXYgIT0gZmls
dGVyX2Rldikgew0KPiArCQlOTF9TRVRfRVJSX01TR19NT0QoZXh0YWNrLA0KPiArCQkJCSAgICJD
YW4ndCBtYXRjaCBvbiB0aGUgaW5ncmVzcyBmaWx0ZXIgcG9ydCIpOw0KPiArCQlyZXR1cm4gLUVJ
TlZBTDsNCj4gKwl9DQo+ICsNCj4gKwlyZXR1cm4gMDsNCj4gK30NCj4gKw0KPiAgc3RhdGljIGlu
dCBfX3BhcnNlX2Nsc19mbG93ZXIoc3RydWN0IG1seDVlX3ByaXYgKnByaXYsDQo+ICAJCQkgICAg
ICBzdHJ1Y3QgbWx4NV9mbG93X3NwZWMgKnNwZWMsDQo+ICAJCQkgICAgICBzdHJ1Y3QgZmxvd19j
bHNfb2ZmbG9hZCAqZiwNCj4gQEAgLTE4MjUsNiArMTg1OSw3IEBAIHN0YXRpYyBpbnQgX19wYXJz
ZV9jbHNfZmxvd2VyKHN0cnVjdCBtbHg1ZV9wcml2ICpwcml2LA0KPiAgCXUxNiBhZGRyX3R5cGUg
PSAwOw0KPiAgCXU4IGlwX3Byb3RvID0gMDsNCj4gIAl1OCAqbWF0Y2hfbGV2ZWw7DQo+ICsJaW50
IGVycjsNCj4gIA0KPiAgCW1hdGNoX2xldmVsID0gb3V0ZXJfbWF0Y2hfbGV2ZWw7DQo+ICANCj4g
QEAgLTE4NjgsNiArMTkwMywxMCBAQCBzdGF0aWMgaW50IF9fcGFyc2VfY2xzX2Zsb3dlcihzdHJ1
Y3QgbWx4NWVfcHJpdiAqcHJpdiwNCj4gIAkJCQkJCSAgICBzcGVjKTsNCj4gIAl9DQo+ICANCj4g
KwllcnIgPSBtbHg1ZV9mbG93ZXJfcGFyc2VfbWV0YShmaWx0ZXJfZGV2LCBmKTsNCj4gKwlpZiAo
ZXJyKQ0KPiArCQlyZXR1cm4gZXJyOw0KPiArDQo+ICAJaWYgKGZsb3dfcnVsZV9tYXRjaF9rZXko
cnVsZSwgRkxPV19ESVNTRUNUT1JfS0VZX0JBU0lDKSkgew0KPiAgCQlzdHJ1Y3QgZmxvd19tYXRj
aF9iYXNpYyBtYXRjaDsNCj4gIA0KPiANCg0KQWNrZWQtYnk6IFJvaSBEYXlhbiA8cm9pZEBtZWxs
YW5veC5jb20+DQo=
