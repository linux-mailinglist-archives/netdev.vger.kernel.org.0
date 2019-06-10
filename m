Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC6B3BF6B
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 00:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389164AbfFJWUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 18:20:06 -0400
Received: from mail-eopbgr80073.outbound.protection.outlook.com ([40.107.8.73]:31906
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388328AbfFJWUF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 18:20:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nz7chkbauTdQNdvltmRrRXPnBlSZKJVQITZ8vCNqgOs=;
 b=lBtWShZC3HrfVIgF53+GzpeQHFkGomd8ebgX6xrinp+oMGhQTuWtEdoTCUtoH2yn+Zw/iGpxxge/sIUx10lGkKjQlrf2HXSXUf91BBF3XyoO1/ZTymIa604v40YRSee0qKDqOYPbnkSdsofFwamzHZTaTb9Xac2Zxp3sp/1KzdM=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2710.eurprd05.prod.outlook.com (10.172.226.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Mon, 10 Jun 2019 22:20:00 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3b:cb20:88ed:30bf]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3b:cb20:88ed:30bf%5]) with mapi id 15.20.1965.017; Mon, 10 Jun 2019
 22:20:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH net-next v2 3/3] net/mlx5e: use indirect calls wrapper for
 the rx packet handler
Thread-Topic: [PATCH net-next v2 3/3] net/mlx5e: use indirect calls wrapper
 for the rx packet handler
Thread-Index: AQHVHLLUj1lczUcwlEuE/49mSxqZEaaQfsmAgAQY1QCAAORBgA==
Date:   Mon, 10 Jun 2019 22:20:00 +0000
Message-ID: <2c89a62bd4f153e7efdb92be61adc2ec40309850.camel@mellanox.com>
References: <cover.1559857734.git.pabeni@redhat.com>
         <fe1dffe13521e0b89969301f7b34fdb19964dbdb.1559857734.git.pabeni@redhat.com>
         <248c85579656054de478ea29154aa40c7542009e.camel@mellanox.com>
         <60228c06200778cd214e9e7448906a7fdaf16df5.camel@redhat.com>
In-Reply-To: <60228c06200778cd214e9e7448906a7fdaf16df5.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62da908e-5029-4ad0-0282-08d6edf1c74e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB6PR0501MB2710;
x-ms-traffictypediagnostic: DB6PR0501MB2710:
x-microsoft-antispam-prvs: <DB6PR0501MB27107DD30E9FCF9E4CF61F46BE130@DB6PR0501MB2710.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(136003)(366004)(39860400002)(346002)(199004)(189003)(186003)(64756008)(66066001)(26005)(8936002)(71190400001)(71200400001)(66556008)(11346002)(6506007)(66446008)(73956011)(91956017)(76116006)(66476007)(446003)(66946007)(2616005)(486006)(476003)(5660300002)(2501003)(36756003)(54906003)(58126008)(68736007)(110136005)(76176011)(102836004)(99286004)(6116002)(14454004)(3846002)(118296001)(14444005)(256004)(6436002)(86362001)(316002)(7736002)(8676002)(25786009)(305945005)(81156014)(4326008)(478600001)(6246003)(53936002)(6486002)(6512007)(81166006)(2906002)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2710;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zG8WEc2Betc4ayMhujEe314wnuQOWbFxrjc9XqERSJi6/DoeVM0doWf7FoDFJ1yKKRaAdRSpeaxstP2+DP6rYAQ1md0JhLq2XMo8D+K6cOpumMUPnSx9EWSwPiq6Zxzzsp1fGV/IuktACgwyJREfIAwU++km+PPtX1xtW6HHpPM8/BNMlC9Hz3luI82AeVOwGJESRdjjlEpQJ+m0JMnqsQQwgTbwZsgubbOCT8rE41Q8CD9mVcPy1GcbZbkWRhb41JT8jnGs+1ESY1BVPmRpCwo3llZIOpZhCLMlN73/eB547o8QIQK573knAiDVd4Rf7UMDWp0Hm1jZeQTocYws0dZ9hE+XWqFhtKSizrRemI7G+J84mJzF1LurN4V4Xwz1S2VWe608e2IiEQIxrYdfsS1XyF/Fb6O+85Ere2M+Gp4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <41871AC09301FA439A50BF4929C548AA@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62da908e-5029-4ad0-0282-08d6edf1c74e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 22:20:00.4562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2710
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA2LTEwIGF0IDEwOjQzICswMjAwLCBQYW9sbyBBYmVuaSB3cm90ZToNCj4g
SGksDQo+IA0KPiBPbiBGcmksIDIwMTktMDYtMDcgYXQgMTg6MDkgKzAwMDAsIFNhZWVkIE1haGFt
ZWVkIHdyb3RlOg0KPiA+IE9uIFRodSwgMjAxOS0wNi0wNiBhdCAyMzo1NiArMDIwMCwgUGFvbG8g
QWJlbmkgd3JvdGU6DQo+ID4gPiBXZSBjYW4gYXZvaWQgYW5vdGhlciBpbmRpcmVjdCBjYWxsIHBl
ciBwYWNrZXQgd3JhcHBpbmcgdGhlIHJ4DQo+ID4gPiBoYW5kbGVyIGNhbGwgd2l0aCB0aGUgcHJv
cGVyIGhlbHBlci4NCj4gPiA+IA0KPiA+ID4gVG8gZW5zdXJlIHRoYXQgZXZlbiB0aGUgbGFzdCBs
aXN0ZWQgZGlyZWN0IGNhbGwgZXhwZXJpZW5jZQ0KPiA+ID4gbWVhc3VyYWJsZSBnYWluLCBkZXNw
aXRlIHRoZSBhZGRpdGlvbmFsIGNvbmRpdGlvbmFscyB3ZSBtdXN0DQo+ID4gPiB0cmF2ZXJzZSBi
ZWZvcmUgcmVhY2hpbmcgaXQsIEkgdGVzdGVkIHJldmVyc2luZyB0aGUgb3JkZXIgb2YgdGhlDQo+
ID4gPiBsaXN0ZWQgb3B0aW9ucywgd2l0aCBwZXJmb3JtYW5jZSBkaWZmZXJlbmNlcyBiZWxvdyBu
b2lzZSBsZXZlbC4NCj4gPiA+IA0KPiA+ID4gVG9nZXRoZXIgd2l0aCB0aGUgcHJldmlvdXMgaW5k
aXJlY3QgY2FsbCBwYXRjaCwgdGhpcyBnaXZlcw0KPiA+ID4gfjYlIHBlcmZvcm1hbmNlIGltcHJv
dmVtZW50IGluIHJhdyBVRFAgdHB1dC4NCj4gPiA+IA0KPiA+ID4gdjEgLT4gdjI6DQo+ID4gPiAg
LSB1cGRhdGUgdGhlIGRpcmVjdCBjYWxsIGxpc3QgYW5kIHVzZSBhIG1hY3JvIHRvIGRlZmluZSBp
dCwNCj4gPiA+ICAgIGFzIHBlciBTYWVlZCBzdWdnZXN0aW9uLiBBbiBpbnRlcm1lZGlhdGVkIGFk
ZGl0aW9uYWwNCj4gPiA+ICAgIG1hY3JvIGlzIG5lZWRlZCB0byBhbGxvdyBhcmcgbGlzdCBleHBh
bnNpb24NCj4gPiA+IA0KPiA+ID4gU2lnbmVkLW9mZi1ieTogUGFvbG8gQWJlbmkgPHBhYmVuaUBy
ZWRoYXQuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL2VuLmggICAgfCA0ICsrKysNCj4gPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcnguYyB8IDUgKysrKy0NCj4gPiA+ICAyIGZpbGVzIGNo
YW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+ID4gDQo+ID4gPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuLmgNCj4g
PiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuLmgNCj4gPiA+
IGluZGV4IDNhMTgzZDY5MGUyMy4uNTJiY2RjODdjYmUyIDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuLmgNCj4gPiA+ICsrKyBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi5oDQo+ID4gPiBAQCAtMTQ4
LDYgKzE0OCwxMCBAQCBzdHJ1Y3QgcGFnZV9wb29sOw0KPiA+ID4gIA0KPiA+ID4gICNkZWZpbmUg
TUxYNUVfTVNHX0xFVkVMCQkJTkVUSUZfTVNHX0xJTksNCj4gPiA+ICANCj4gPiA+ICsjZGVmaW5l
IE1MWDVfUlhfSU5ESVJFQ1RfQ0FMTF9MSVNUIFwNCj4gPiA+ICsJbWx4NWVfaGFuZGxlX3J4X2Nx
ZV9tcHdycSwgbWx4NWVfaGFuZGxlX3J4X2NxZSwNCj4gPiA+IG1seDVpX2hhbmRsZV9yeF9jcWUs
IFwNCj4gPiA+ICsJbWx4NWVfaXBzZWNfaGFuZGxlX3J4X2NxZQ0KPiA+ID4gKw0KPiA+ID4gICNk
ZWZpbmUgbWx4NWVfZGJnKG1sZXZlbCwgcHJpdiwgZm9ybWF0LA0KPiA+ID4gLi4uKSAgICAgICAg
ICAgICAgICAgICAgXA0KPiA+ID4gIGRvDQo+ID4gPiB7ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPiA+ID4gIAlpZiAoTkVUSUZf
TVNHXyMjbWxldmVsICYgKHByaXYpLT5tc2dsZXZlbCkgICAgICAgICAgICAgIFwNCj4gPiA+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcngu
Yw0KPiA+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcngu
Yw0KPiA+ID4gaW5kZXggMGZlNWYxM2QwN2NjLi43ZmFmNjQzZWIxYjkgMTAwNjQ0DQo+ID4gPiAt
LS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcnguYw0KPiA+
ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3J4LmMN
Cj4gPiA+IEBAIC0xMzAzLDYgKzEzMDMsOCBAQCB2b2lkIG1seDVlX2hhbmRsZV9yeF9jcWVfbXB3
cnEoc3RydWN0DQo+ID4gPiBtbHg1ZV9ycQ0KPiA+ID4gKnJxLCBzdHJ1Y3QgbWx4NV9jcWU2NCAq
Y3FlKQ0KPiA+ID4gIAltbHg1X3dxX2xsX3BvcCh3cSwgY3FlLT53cWVfaWQsICZ3cWUtPm5leHQu
bmV4dF93cWVfaW5kZXgpOw0KPiA+ID4gIH0NCj4gPiA+ICANCj4gPiA+ICsjZGVmaW5lIElORElS
RUNUX0NBTExfTElTVChmLCBsaXN0LCAuLi4pIElORElSRUNUX0NBTExfNChmLA0KPiA+ID4gbGlz
dCwNCj4gPiA+IF9fVkFfQVJHU19fKQ0KPiA+ID4gKw0KPiA+IA0KPiA+IEhpIFBhb2xvLCANCj4g
PiANCj4gPiBUaGlzIHBhdGNoIHByb2R1Y2VzIHNvbWUgY29tcGlsZXIgZXJyb3JzOg0KPiA+IA0K
PiA+IFBsZWFzZSBub3RlIHRoYXQgbWx4NWVfaXBzZWNfaGFuZGxlX3J4X2NxZSBpcyBvbmx5IGRl
ZmluZWQgd2hlbg0KPiA+IENPTkZJR19NTFg1X0VOX0lQU0VDIGlzIGVuYWJsZWQuDQo+IA0KPiBJ
J20gc29ycnksIEkgZHVtYmx5IGRpZCBub3QgZnV6eiB2cyBtbHg1IGJ1aWxkIG9wdGlvbnMuDQo+
IA0KPiBJdCBsb29rcyBsaWtlIHRoYXQsIHRvIGNvcGUgd2l0aCBhbGwgdGhlIHBvc3NpYmxlIG1p
eGVzLCBhIG5vdC1zby0NCj4gbmljZQ0KPiBtYWNybyBtYXplIGlzIHJlcXVpcmVkOyBzb21ldGhp
bmcgYWxpa2UgdGhlIGZvbGxvd2luZzoNCj4gDQo+ICNpZiBkZWZpbmVkKENPTkZJR19NTFg1X0VO
X0lQU0VDKSAmJiBkZWZpbmVkIChDT05GSUdfTUxYNV9DT1JFX0lQT0lCKQ0KPiANCj4gI2RlZmlu
ZSBNTFg1X1JYX0lORElSRUNUX0NBTExfTElTVCBcDQo+IAltbHg1ZV9oYW5kbGVfcnhfY3FlX21w
d3JxLCBtbHg1ZV9oYW5kbGVfcnhfY3FlLA0KPiBtbHg1aV9oYW5kbGVfcnhfY3FlLCBcDQo+IAlt
bHg1ZV9pcHNlY19oYW5kbGVfcnhfY3FlDQo+ICNkZWZpbmUgSU5ESVJFQ1RfQ0FMTF9MSVNUKGYs
IGxpc3QsIC4uLikgSU5ESVJFQ1RfQ0FMTF80KGYsIGxpc3QsDQo+IF9fVkFfQVJHU19fKQ0KPiAN
Cj4gI2VsaWYgZGVmaW5lZChDT05GSUdfTUxYNV9FTl9JUFNFQykNCj4gDQo+ICNkZWZpbmUgTUxY
NV9SWF9JTkRJUkVDVF9DQUxMX0xJU1QgXA0KPiAJbWx4NWVfaGFuZGxlX3J4X2NxZV9tcHdycSwg
bWx4NWVfaGFuZGxlX3J4X2NxZSwgXA0KPiAJbWx4NWVfaXBzZWNfaGFuZGxlX3J4X2NxZQ0KPiAj
ZGVmaW5lIElORElSRUNUX0NBTExfTElTVChmLCBsaXN0LCAuLi4pIElORElSRUNUX0NBTExfMyhm
LCBsaXN0LA0KPiBfX1ZBX0FSR1NfXykNCj4gDQo+ICNlbGlmIGRlZmluZWQoQ09ORklHX01MWDVf
Q09SRV9JUE9JQikNCj4gDQo+ICNkZWZpbmUgTUxYNV9SWF9JTkRJUkVDVF9DQUxMX0xJU1QgXA0K
PiAJbWx4NWVfaGFuZGxlX3J4X2NxZV9tcHdycSwgbWx4NWVfaGFuZGxlX3J4X2NxZSwNCj4gbWx4
NWlfaGFuZGxlX3J4X2NxZQ0KPiAjZGVmaW5lIElORElSRUNUX0NBTExfTElTVChmLCBsaXN0LCAu
Li4pIElORElSRUNUX0NBTExfMyhmLCBsaXN0LA0KPiBfX1ZBX0FSR1NfXykNCj4gDQo+ICNlbHNl
DQo+IA0KPiAjZGVmaW5lIE1MWDVfUlhfSU5ESVJFQ1RfQ0FMTF9MSVNUIFwNCj4gCW1seDVlX2hh
bmRsZV9yeF9jcWVfbXB3cnEsIG1seDVlX2hhbmRsZV9yeF9jcWUNCj4gI2RlZmluZSBJTkRJUkVD
VF9DQUxMX0xJU1QoZiwgbGlzdCwgLi4uKSBJTkRJUkVDVF9DQUxMXzIoZiwgbGlzdCwNCj4gX19W
QV9BUkdTX18pDQo+IA0KPiAjZW5kaWYNCj4gDQo+IElmIHlvdSBhcmUgb2sgd2l0aCB0aGUgYWJv
dmUsIEkgY2FuIGluY2x1ZGUgaXQgaW4gdjMsIG90aGVyd2lzZSBJIGNhbg0KPiBlaXRoZXI6DQo+
IA0KPiAqIGRyb3AgcGF0Y2ggMi8zIGFuZCB1c2Ugb25seSB0aGUgMiBhbHRlcm5hdGl2ZXMNCj4g
KG1seDVlX2hhbmRsZV9yeF9jcWVfbXB3cnEsIG1seDVlX2hhbmRsZV9yeF9jcWUpIHRoYXQgYXJl
IGF2YWlsYWJsZQ0KPiByZWdhcmRsZXNzIG9mIHRoZSBkcml2ZXIgYnVpbGQgb3B0aW9ucw0KPiAN
Cg0KeWVhLCB0aGUgYWJvdmUgaXMgdG9vIG11Y2gsIG1heWJlIHdlIGNhbiBzaW1wbGlmeSwgSSB3
aWxsIHJldmlzaXQgaXQNCmxhdGVyLCBmb3Igbm93LCBsZXQncyBoYXZlIHRoZSAyIGZ1bmN0aW9u
cyB0aGF0IGFyZSBhbHdheXMgYXZhaWxhYmxlLA0KYWZ0ZXIgYWxsIHRoZXkgYXJlIHRoZSBvbmVz
IHRoYXQgcmVhbGx5IG1hdHRlci4NCg0KPiAqIGRyb3AgYm90aCBwYXRjaGVzIDIvMyBhbmQgMy8z
DQo+IA0KPiBBbnkgZmVlZGJhY2sgd2VsY29tZSwgdGhhbmtzIQ0KPiANCj4gUGFvbG8NCj4gDQo=
