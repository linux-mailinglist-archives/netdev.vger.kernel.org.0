Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD0D1235D3
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 20:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbfLQTiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 14:38:52 -0500
Received: from mail-eopbgr20059.outbound.protection.outlook.com ([40.107.2.59]:40706
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726612AbfLQTiu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 14:38:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aKcJDACV/fYIDVBQ220HXESvS5BVKMW0hU3xyTeUB2NaQhyw9aOfmEgHH6ZgZVA8xJzMCRwBqVwrjIP+WAUWB8gvaZnqCRqlbUwLJr99UdWda+Xw+/EJrttl7iE9bHnPuHPLQHEKI80050wlRiT2YVWhtGe8oXFRaWd9cCcPdl7s6gWO13p2qlWVgNlUKSoEVB56bpsMAgOpSsN7SaGVoOL99oNFnc72+pbBBF+utQAzqmKDgX33BknEE8hw6ayg4T0it2aO0Fh11KFSsYWjBCLQBLWbk3X0a3Ynvb9tUfPRdkZEsMMZ9m0gEzTNbeA9v1t+nCPc/K5fTdgCIIR8/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPBLt6mRVuLwialzKEgbhNJit22MQPvx4U/atOJM/rs=;
 b=bscU+jiXAHTntjrMlf4GdSK/Bx4okscT+zqzAx5U8dsaVBkf6iOJRWjm/6zUcBfXzzzXBq2jmkqAOK1w5LYpObyB9qWvJdCcEP2lXkaw0EIQBqHgo96q17Fn5x2SlLV8CRadk41ZaTitDntvTalCmsEb47LaWPQBgSv/VBFC27gswdSirP1lx+6fTFB6wS4LuC7wdGMvlOt5bpxthxW7uwpHM9IYhKvb9cS+aR/BTDApY3qLwPMLJbxSf0gijJpQQhHEYn545/QuQPLHUCxQiBEgLiakRUvVty+Okn1mGu5tordBBF0+EtaWCJulnkruBhurzT4uZCVy77PihKKaIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPBLt6mRVuLwialzKEgbhNJit22MQPvx4U/atOJM/rs=;
 b=sNWS/jed5ND7pjHW2zcNYO90wcJEvkD/xtRqnPF/wMBa4qrmgW/8szoEpEx7LAiHLEOtv5LH/YLEQyvCVq04yc+8YMCcRT2zAJg81nK7lVzAvZ9ta0TzCxr2JDN9SdhE9nDP/4AS3Y5+L9J9UT7/gGPrI4SQkPKokQcQtGMwsv8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5247.eurprd05.prod.outlook.com (20.178.11.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.17; Tue, 17 Dec 2019 19:38:45 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881%5]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 19:38:45 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        Li Rongqing <lirongqing@baidu.com>
CC:     "mhocko@kernel.org" <mhocko@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>
Subject: =?utf-8?B?UmU6IOetlOWkjTogW1BBVENIXVt2Ml0gcGFnZV9wb29sOiBoYW5kbGUgcGFn?=
 =?utf-8?B?ZSByZWN5Y2xlIGZvciBOVU1BX05PX05PREUgY29uZGl0aW9u?=
Thread-Topic: =?utf-8?B?562U5aSNOiBbUEFUQ0hdW3YyXSBwYWdlX3Bvb2w6IGhhbmRsZSBwYWdlIHJl?=
 =?utf-8?B?Y3ljbGUgZm9yIE5VTUFfTk9fTk9ERSBjb25kaXRpb24=?=
Thread-Index: AQHVsZIr3214vhqJMEi479g5MULauKe8A4aAgAAkfACAAGffAIACMCiA
Date:   Tue, 17 Dec 2019 19:38:44 +0000
Message-ID: <3f2d88fdcb00b6cc2925d5a2fab38e50d43d8a52.camel@mellanox.com>
References: <20191211194933.15b53c11@carbon>
         <831ed886842c894f7b2ffe83fe34705180a86b3b.camel@mellanox.com>
         <0a252066-fdc3-a81d-7a36-8f49d2babc01@huawei.com>
         <20191212111831.2a9f05d3@carbon>
         <7c555cb1-6beb-240d-08f8-7044b9087fe4@huawei.com>
         <1d4f10f4c0f1433bae658df8972a904f@baidu.com>
         <079a0315-efea-9221-8538-47decf263684@huawei.com>
         <20191213094845.56fb42a4@carbon>
         <15be326d-1811-329c-424c-6dd22b0604a8@huawei.com>
         <a5dea60221d84886991168781361b591@baidu.com>
         <20191216101350.GA6939@apalos.home>
In-Reply-To: <20191216101350.GA6939@apalos.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.5 (3.32.5-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 41b8b6f6-d337-4112-e0b8-08d78328bad7
x-ms-traffictypediagnostic: VI1PR05MB5247:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-microsoft-antispam-prvs: <VI1PR05MB5247583E6F9256528552FABDBE500@VI1PR05MB5247.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(189003)(199004)(66574012)(478600001)(2616005)(86362001)(186003)(81156014)(6486002)(26005)(224303003)(4326008)(5660300002)(91956017)(8936002)(316002)(7416002)(76116006)(110136005)(54906003)(66946007)(4001150100001)(64756008)(66446008)(66556008)(66476007)(36756003)(6512007)(2906002)(71200400001)(6506007)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5247;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xXclbDJ2I/HUGOZpxcGT2P9GfIVCSuAi+6U3z0e86/0ClryVWCcymkgHgzxRLysEHiGcF+sSbnXUpvDQHFb0+1ajuyeRDf4I/8o3tvZ6j1Xll3PYN68PpomDFdX0y2q0KMypmqp0kH4Zckj0n2eJ4jr5pxRCZZcS2i8p1IUqEBLIDBCftL1Mps0Er8XKyfQgDCCViuYzRyQnE96Zh/QHz1x17ynr0JhKRobFYZaB32E1PawqGPsSC9B61UeWWXjh/T2E5rgyHqHLIdXv9d6I7LkSp/D6Zh2cn2DkhMa+kQ4jll3znUq74nCXyVGDAjvDaIPC6cHA0/4YYV4nJ+ogulVeWUI+UWy4QmSe3a6FpDi1OEonneiPlNnth9gmmnBIW37jfm2U1F3iqkfv+P59gQ6bGLarkbaHDmgoujErPF50zEVDw6yzzy2rV+eIg8KC
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F01564ED2C74D24487FDAFE681A3476C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41b8b6f6-d337-4112-e0b8-08d78328bad7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 19:38:44.9656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tVQ+6TleJlfiJu+TYILJUx5cbbo1aubrhmlnawkmtOrqbxQbKS5dVzrqn6BVkrfjymCEfDsgGJbM5nTCjzNmqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5247
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTEyLTE2IGF0IDEyOjEzICswMjAwLCBJbGlhcyBBcGFsb2RpbWFzIHdyb3Rl
Og0KPiBPbiBNb24sIERlYyAxNiwgMjAxOSBhdCAwNDowMjowNEFNICswMDAwLCBMaSxSb25ncWlu
ZyB3cm90ZToNCj4gPiANCj4gPiA+IC0tLS0t6YKu5Lu25Y6f5Lu2LS0tLS0NCj4gPiA+IOWPkeS7
tuS6ujogWXVuc2hlbmcgTGluIFttYWlsdG86bGlueXVuc2hlbmdAaHVhd2VpLmNvbV0NCj4gPiA+
IOWPkemAgeaXtumXtDogMjAxOeW5tDEy5pyIMTbml6UgOTo1MQ0KPiA+ID4g5pS25Lu25Lq6OiBK
ZXNwZXIgRGFuZ2FhcmQgQnJvdWVyIDxicm91ZXJAcmVkaGF0LmNvbT4NCj4gPiA+IOaKhOmAgTog
TGksUm9uZ3FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPjsgU2FlZWQgTWFoYW1lZWQNCj4gPiA+
IDxzYWVlZG1AbWVsbGFub3guY29tPjsgaWxpYXMuYXBhbG9kaW1hc0BsaW5hcm8ub3JnOw0KPiA+
ID4gam9uYXRoYW4ubGVtb25AZ21haWwuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyANCj4g
PiA+IG1ob2Nrb0BrZXJuZWwub3JnOw0KPiA+ID4gcGV0ZXJ6QGluZnJhZGVhZC5vcmc7IEdyZWcg
S3JvYWgtSGFydG1hbiA8DQo+ID4gPiBncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz47DQo+ID4g
PiBiaGVsZ2Fhc0Bnb29nbGUuY29tOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBCasO2
cm4gVMO2cGVsDQo+ID4gPiA8Ympvcm4udG9wZWxAaW50ZWwuY29tPg0KPiA+ID4g5Li76aKYOiBS
ZTogW1BBVENIXVt2Ml0gcGFnZV9wb29sOiBoYW5kbGUgcGFnZSByZWN5Y2xlIGZvcg0KPiA+ID4g
TlVNQV9OT19OT0RFDQo+ID4gPiBjb25kaXRpb24NCj4gPiA+IA0KPiA+ID4gT24gMjAxOS8xMi8x
MyAxNjo0OCwgSmVzcGVyIERhbmdhYXJkIEJyb3VlciB3cm90ZTo+IFlvdSBhcmUNCj4gPiA+IGJh
c2ljYWxseSBzYXlpbmcNCj4gPiA+IHRoYXQgdGhlIE5VTUEgY2hlY2sgc2hvdWxkIGJlIG1vdmVk
IHRvDQo+ID4gPiA+IGFsbG9jYXRpb24gdGltZSwgYXMgaXQgaXMgcnVubmluZyB0aGUgUlgtQ1BV
IChOQVBJKS4gIEFuZA0KPiA+ID4gPiBldmVudHVhbGx5DQo+ID4gPiA+IGFmdGVyIHNvbWUgdGlt
ZSB0aGUgcGFnZXMgd2lsbCBjb21lIGZyb20gY29ycmVjdCBOVU1BIG5vZGUuDQo+ID4gPiA+IA0K
PiA+ID4gPiBJIHRoaW5rIHdlIGNhbiBkbyB0aGF0LCBhbmQgb25seSBhZmZlY3QgdGhlIHNlbWkt
ZmFzdC1wYXRoLg0KPiA+ID4gPiBXZSBqdXN0IG5lZWQgdG8gaGFuZGxlIHRoYXQgcGFnZXMgaW4g
dGhlIHB0cl9yaW5nIHRoYXQgYXJlDQo+ID4gPiA+IHJlY3ljbGVkDQo+ID4gPiA+IGNhbiBiZSBm
cm9tIHRoZSB3cm9uZyBOVU1BIG5vZGUuICBJbiBfX3BhZ2VfcG9vbF9nZXRfY2FjaGVkKCkNCj4g
PiA+ID4gd2hlbg0KPiA+ID4gPiBjb25zdW1pbmcgcGFnZXMgZnJvbSB0aGUgcHRyX3JpbmcgKF9f
cHRyX3JpbmdfY29uc3VtZV9iYXRjaGVkKSwNCj4gPiA+ID4gdGhlbg0KPiA+ID4gPiB3ZSBjYW4g
ZXZpY3QgcGFnZXMgZnJvbSB3cm9uZyBOVU1BIG5vZGUuDQo+ID4gPiANCj4gPiA+IFllcywgdGhh
dCdzIHdvcmthYmxlLg0KPiA+ID4gDQo+ID4gPiA+IEZvciB0aGUgcG9vbC0+YWxsb2MuY2FjaGUg
d2UgZWl0aGVyIGFjY2VwdCwgdGhhdCBpdCB3aWxsDQo+ID4gPiA+IGV2ZW50dWFsbHkNCj4gPiA+
ID4gYWZ0ZXIgc29tZSB0aW1lIGJlIGVtcHRpZWQgKGl0IGlzIG9ubHkgaW4gYSAxMDAlIFhEUF9E
Uk9QDQo+ID4gPiA+IHdvcmtsb2FkIHRoYXQNCj4gPiA+ID4gaXQgd2lsbCBjb250aW51ZSB0byBy
ZXVzZSBzYW1lIHBhZ2VzKS4gICBPciB3ZSBzaW1wbHkgY2xlYXIgdGhlDQo+ID4gPiA+IHBvb2wt
PmFsbG9jLmNhY2hlIHdoZW4gY2FsbGluZyBwYWdlX3Bvb2xfdXBkYXRlX25pZCgpLg0KPiA+ID4g
DQo+ID4gPiBTaW1wbHkgY2xlYXJpbmcgdGhlIHBvb2wtPmFsbG9jLmNhY2hlIHdoZW4gY2FsbGlu
Zw0KPiA+ID4gcGFnZV9wb29sX3VwZGF0ZV9uaWQoKQ0KPiA+ID4gc2VlbXMgYmV0dGVyLg0KPiA+
ID4gDQo+ID4gDQo+ID4gSG93IGFib3V0IHRoZSBiZWxvdyBjb2RlcywgdGhlIGRyaXZlciBjYW4g
Y29uZmlndXJlIHAubmlkIHRvIGFueSwNCj4gPiB3aGljaCB3aWxsIGJlIGFkanVzdGVkIGluIE5B
UEkgcG9sbGluZywgaXJxIG1pZ3JhdGlvbiB3aWxsIG5vdCBiZQ0KPiA+IHByb2JsZW0sIGJ1dCBp
dCB3aWxsIGFkZCBhIGNoZWNrIGludG8gaG90IHBhdGguDQo+IA0KPiBXZSdsbCBoYXZlIHRvIGNo
ZWNrIHRoZSBpbXBhY3Qgb24gc29tZSBoaWdoIHNwZWVkIChpLmUgMTAwZ2JpdCkNCj4gaW50ZXJm
YWNlDQo+IGJldHdlZW4gZG9pbmcgYW55dGhpbmcgbGlrZSB0aGF0LiBTYWVlZCdzIGN1cnJlbnQg
cGF0Y2ggcnVucyBvbmNlIHBlcg0KPiBOQVBJLiBUaGlzDQo+IHJ1bnMgb25jZSBwZXIgcGFja2V0
LiBUaGUgbG9hZCBtaWdodCBiZSBtZWFzdXJhYmxlLiANCj4gVGhlIFJFQURfT05DRSBpcyBuZWVk
ZWQgaW4gY2FzZSBhbGwgcHJvZHVjZXJzL2NvbnN1bWVycyBydW4gb24gdGhlDQo+IHNhbWUgQ1BV
DQo+IHJpZ2h0Pw0KPiANCg0KSSBhZ3JlZSB3aXRoIElsbGlhcywgYW5kIGFzIGkgZXhwbGFpbmVk
IHRoaXMgd2lsbCBtYWtlIHRoZSBwb29sIGJpYXNlZA0KdG8gY3B1IGNsb3NlIG9ubHksIGFuZCB3
ZSB3YW50IHRvIGF2b2lkIHRoaXMsDQoNCkxpLCBjYW4geW91IHBsZWFzZSBjaGVjayBpZiB0aGlz
IGZpeGVzIHlvdXIgaXNzdWU6DQoNCmRpZmYgLS1naXQgYS9uZXQvY29yZS9wYWdlX3Bvb2wuYyBi
L25ldC9jb3JlL3BhZ2VfcG9vbC5jDQppbmRleCBhNmFlZmU5ODkwNDMuLjAwYzk5MjgyYTMwNiAx
MDA2NDQNCi0tLSBhL25ldC9jb3JlL3BhZ2VfcG9vbC5jDQorKysgYi9uZXQvY29yZS9wYWdlX3Bv
b2wuYw0KQEAgLTI4LDYgKzI4LDkgQEAgc3RhdGljIGludCBwYWdlX3Bvb2xfaW5pdChzdHJ1Y3Qg
cGFnZV9wb29sICpwb29sLA0KIA0KICAgICAgICBtZW1jcHkoJnBvb2wtPnAsIHBhcmFtcywgc2l6
ZW9mKHBvb2wtPnApKTsNCiANCisgICAgICAgLyogb3ZlcndyaXRlIHRvIGFsbG93IHJlY3ljbGlu
Zy4uICovDQorICAgICAgIGlmIChwb29sLT5wLm5pZCA9PSBOVU1BX05PX05PREUpIA0KKyAgICAg
ICAgICAgICAgIHBvb2wtPnAubmlkID0gbnVtYV9tZW1faWQoKTsgDQorDQoNCmlmIHVzZXIgd2Fu
dHMgZGV2X3RvX25vZGUoKSB0aGVuIHVzZSBjYW4gdXNlIGRldl90b19ub2RlKCkgb24gcG9vbA0K
aW5pdGlhbGl6YXRpb24gcmF0aGVyIHRoYW4gTlVNQV9OT19OT0RFLg0KDQoNCj4gVGhhbmtzDQo+
IC9JbGlhcw0KPiA+IGRpZmYgLS1naXQgYS9uZXQvY29yZS9wYWdlX3Bvb2wuYyBiL25ldC9jb3Jl
L3BhZ2VfcG9vbC5jDQo+ID4gaW5kZXggYTZhZWZlOTg5MDQzLi40Mzc0YTYyMzlkMTcgMTAwNjQ0
DQo+ID4gLS0tIGEvbmV0L2NvcmUvcGFnZV9wb29sLmMNCj4gPiArKysgYi9uZXQvY29yZS9wYWdl
X3Bvb2wuYw0KPiA+IEBAIC0xMDgsNiArMTA4LDEwIEBAIHN0YXRpYyBzdHJ1Y3QgcGFnZQ0KPiA+
ICpfX3BhZ2VfcG9vbF9nZXRfY2FjaGVkKHN0cnVjdCBwYWdlX3Bvb2wgKnBvb2wpDQo+ID4gICAg
ICAgICAgICAgICAgIGlmIChsaWtlbHkocG9vbC0+YWxsb2MuY291bnQpKSB7DQo+ID4gICAgICAg
ICAgICAgICAgICAgICAgICAgLyogRmFzdC1wYXRoICovDQo+ID4gICAgICAgICAgICAgICAgICAg
ICAgICAgcGFnZSA9IHBvb2wtPmFsbG9jLmNhY2hlWy0tcG9vbC0NCj4gPiA+YWxsb2MuY291bnRd
Ow0KPiA+ICsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBpZiAodW5saWtlbHkoUkVBRF9P
TkNFKHBvb2wtPnAubmlkKSAhPQ0KPiA+IG51bWFfbWVtX2lkKCkpKQ0KPiA+ICsgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgV1JJVEVfT05DRShwb29sLT5wLm5pZCwNCj4gPiBudW1hX21l
bV9pZCgpKTsNCj4gPiArDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIHBhZ2U7
DQo+ID4gICAgICAgICAgICAgICAgIH0NCj4gPiAgICAgICAgICAgICAgICAgcmVmaWxsID0gdHJ1
ZTsNCj4gPiBAQCAtMTU1LDYgKzE1OSwxMCBAQCBzdGF0aWMgc3RydWN0IHBhZ2UNCj4gPiAqX19w
YWdlX3Bvb2xfYWxsb2NfcGFnZXNfc2xvdyhzdHJ1Y3QgcGFnZV9wb29sICpwb29sLA0KPiA+ICAg
ICAgICAgaWYgKHBvb2wtPnAub3JkZXIpDQo+ID4gICAgICAgICAgICAgICAgIGdmcCB8PSBfX0dG
UF9DT01QOw0KPiA+ICANCj4gPiArDQo+ID4gKyAgICAgICBpZiAodW5saWtlbHkoUkVBRF9PTkNF
KHBvb2wtPnAubmlkKSAhPSBudW1hX21lbV9pZCgpKSkNCj4gPiArICAgICAgICAgICAgICAgV1JJ
VEVfT05DRShwb29sLT5wLm5pZCwgbnVtYV9tZW1faWQoKSk7DQo+ID4gKw0KPiA+ICAgICAgICAg
LyogRlVUVVJFIGRldmVsb3BtZW50Og0KPiA+ICAgICAgICAgICoNCj4gPiAgICAgICAgICAqIEN1
cnJlbnQgc2xvdy1wYXRoIGVzc2VudGlhbGx5IGZhbGxzIGJhY2sgdG8gc2luZ2xlIHBhZ2UNCj4g
PiBUaGFua3MNCj4gPiANCj4gPiAtTGkNCg==
