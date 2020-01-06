Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23FB2131AFF
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 23:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgAFWFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 17:05:09 -0500
Received: from mail-db8eur05on2060.outbound.protection.outlook.com ([40.107.20.60]:6124
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726735AbgAFWFJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 17:05:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZacladXpOQ63jkTMHUZmKWO/g982zPnOUaT0vBhVQbCh05LxFgW1lDv3H8Hkjg6dm23eM8QpKQq/sdQtJ/7ZPiRFIkp1GoxdV4Rj9QSP/TG1Ajhm7z3TM7wmjMdeIAPmycREuj0TqaNYmD9C2gSh61qU7gLKkHKgwP4PsiPHwC0TrQE+55udeKy5P3FcffkRArcPIHZmnL3uW5VKjSj8VXuKgtbhXyECYFzuUv6MAxGZk9xfBjhwvr74QMymvAOD5LEpzzmjTNArqrJlHqE5wa7sKX0H+1E7DGBZnfopIKmfK2c7i+jS+LF3vsedu2ZzNJdObwDK/vK4Fvw95viznQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=36G0r+CltsEXMuTT+K9mE7mycFAsb2fbMQdDKRv5rsk=;
 b=Ypq4e+d97SqszyEcoCS9tTc4Mj5o5QMD1fmZ3TUn1f9G8s8gLBPuTiI4MGgSnCzLe45V1+XSCSmwBk7XP7nw7gROttc8GfTaOqZoafyJo5r1ZbBXtb6kQVUBupNJNBPRvUdJb2wDcWf9CeUG9M+Fsj6NAsgEqBzf0zqdJO2MqVJvwoAtg87KcCuWjWLhWUfKYusNAVqAKYamzumz+R/NhyxbrgkI6KGO6xh8kEmntc8fwGcuDWyQT4vCxVL/WCGGw7Q6/Dxeo/zXuEejcPi37pq/Snc5FDJsNEq0prKOpX6OmMD1onmvmIi9EKId85tJQGioSeloKdKzB5ronIRLwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=36G0r+CltsEXMuTT+K9mE7mycFAsb2fbMQdDKRv5rsk=;
 b=YgLHNH7Zk1oNymufCz3KcjLyJ9+q4PTYgLyfOphFnYdIVEihpySbrlK3HHZnY1BTrq17pTbTXa0eDNnw5NP4VtfG2X7bIe2S/czEioUGBAL9hXQ9t4j9xgslJbMg5NQR/lChv+BsNoB/wREmd9ADmEhjbWSnUEBAJqwX+jhqkDU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5055.eurprd05.prod.outlook.com (20.177.52.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11; Mon, 6 Jan 2020 22:05:05 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2602.015; Mon, 6 Jan 2020
 22:05:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Eran Ben Elisha <eranbe@mellanox.com>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        Tal Gilboa <talgi@mellanox.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
        Moshe Shemesh <moshe@mellanox.com>
CC:     Eli Cohen <eli@mellanox.com>,
        "haakon.bugge@oracle.com" <haakon.bugge@oracle.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        Daniel Marcovitch <danielm@mellanox.com>
Subject: Re: [PATCH v2] net: mlx5: Use iowriteXbe() to ring doorbell and
 remove reduntant wmb()
Thread-Topic: [PATCH v2] net: mlx5: Use iowriteXbe() to ring doorbell and
 remove reduntant wmb()
Thread-Index: AQHVwl6TDCqVnwLE9Em6QjKilPWutafZUDyAgAA1TQCABLBpAA==
Date:   Mon, 6 Jan 2020 22:05:04 +0000
Message-ID: <85a3248490ac15403dfc9fc5b0cdb10d8b5ac69c.camel@mellanox.com>
References: <20200103175207.72655-1-liran.alon@oracle.com>
         <20200103191749.GE9706@ziepe.ca>
         <11EBB1F4-6D5A-4047-99A1-D339B7C8A697@oracle.com>
In-Reply-To: <11EBB1F4-6D5A-4047-99A1-D339B7C8A697@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.2 (3.34.2-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f90c5b46-098e-44a3-b241-08d792f47c31
x-ms-traffictypediagnostic: VI1PR05MB5055:|VI1PR05MB5055:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB50552E1AB8AB85F11A7E8B92BE3C0@VI1PR05MB5055.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(189003)(199004)(186003)(2906002)(71200400001)(66476007)(64756008)(5660300002)(8676002)(81166006)(81156014)(76116006)(91956017)(8936002)(6506007)(53546011)(26005)(66946007)(66556008)(66446008)(107886003)(478600001)(6512007)(54906003)(36756003)(6636002)(2616005)(6486002)(110136005)(316002)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5055;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PHP2MsvbyXQUy9OGHTLr9Wxuq4Al6XMFG8ycwNjnLnVuWqylUf2orBMLbzncTHnvb960LPii5Xng938L3XH7XizjSDO/ZmwASZm/u9t6lq7XXQ+Bkxepu/CHcJIAiKjsPVATdm+zZwBX2LFiDBVEZsd/v1fBYU669IRm19kcnwVLNA5X3vSBCwDmVdoi0W3CR7AXQ3aARwfKQYkA1VVYWkmwfUQFxIR2e6dvQuyEtUAVGtYioDR8hp3KtoMO6g5peLRQGKBXSIXQCPOoN0/KNzidapcuyyEnVvWQrsfTFeTVH9RrukaC07VDsTSwXMW/lihVvEXjbZfOsxph+aiM4Bq9I+MV91fHI+hgiTQY0WzgnvNJgrH2pGjEOUaZ8403O/dPWvY3IvrTLy61UXa7WoW+y+9dlacpmI0EGvoIW7gi5ajfDQcvQWAu2tCdz9ZA
Content-Type: text/plain; charset="utf-8"
Content-ID: <91C5B03B65DD8B4E87D0381C69ABDBDF@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f90c5b46-098e-44a3-b241-08d792f47c31
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2020 22:05:04.8142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nMCXpjzy+ozH2zVoKuUwzB7nvNzyWfIQnklKt2aJAMEYOFlmV3O7t5MiCFOEwAWEf4KYnHxpeHuFZx3t8Fs1bA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5055
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIwLTAxLTA0IGF0IDAwOjI4ICswMjAwLCBMaXJhbiBBbG9uIHdyb3RlOg0KPiA+
IE9uIDMgSmFuIDIwMjAsIGF0IDIxOjE3LCBKYXNvbiBHdW50aG9ycGUgPGpnZ0B6aWVwZS5jYT4g
d3JvdGU6DQo+ID4gDQo+ID4gT24gRnJpLCBKYW4gMDMsIDIwMjAgYXQgMDc6NTI6MDdQTSArMDIw
MCwgTGlyYW4gQWxvbiB3cm90ZToNCj4gPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L21s
eDUvY3EuaCBiL2luY2x1ZGUvbGludXgvbWx4NS9jcS5oDQo+ID4gPiBpbmRleCA0MDc0OGZjMWIx
MWIuLjQ2MzFhZDM1ZGE1MyAxMDA2NDQNCj4gPiA+ICsrKyBiL2luY2x1ZGUvbGludXgvbWx4NS9j
cS5oDQo+ID4gPiBAQCAtMTYyLDEzICsxNjIsOCBAQCBzdGF0aWMgaW5saW5lIHZvaWQgbWx4NV9j
cV9hcm0oc3RydWN0DQo+ID4gPiBtbHg1X2NvcmVfY3EgKmNxLCB1MzIgY21kLA0KPiA+ID4gDQo+
ID4gPiAJKmNxLT5hcm1fZGIgPSBjcHVfdG9fYmUzMihzbiA8PCAyOCB8IGNtZCB8IGNpKTsNCj4g
PiA+IA0KPiA+ID4gLQkvKiBNYWtlIHN1cmUgdGhhdCB0aGUgZG9vcmJlbGwgcmVjb3JkIGluIGhv
c3QgbWVtb3J5IGlzDQo+ID4gPiAtCSAqIHdyaXR0ZW4gYmVmb3JlIHJpbmdpbmcgdGhlIGRvb3Ji
ZWxsIHZpYSBQQ0kgTU1JTy4NCj4gPiA+IC0JICovDQo+ID4gPiAtCXdtYigpOw0KPiA+ID4gLQ0K
PiA+ID4gLQlkb29yYmVsbFswXSA9IGNwdV90b19iZTMyKHNuIDw8IDI4IHwgY21kIHwgY2kpOw0K
PiA+ID4gLQlkb29yYmVsbFsxXSA9IGNwdV90b19iZTMyKGNxLT5jcW4pOw0KPiA+ID4gKwlkb29y
YmVsbFswXSA9IHNuIDw8IDI4IHwgY21kIHwgY2k7DQo+ID4gPiArCWRvb3JiZWxsWzFdID0gY3Et
PmNxbjsNCj4gPiANCj4gPiBUaGlzIGRvZXMgYWN0dWFsbHkgaGF2ZSB0byBjaGFuZ2UgdG8gYSB1
NjQgb3RoZXJ3aXNlIGl0IGlzIG5vdCB0aGUNCj4gPiBzYW1lLg0KPiA+IA0KPiA+IE9uIHg4NiBM
RSwgaXQgd2FzDQo+ID4gZGJbMF0gPSBzd2FiKGEpDQo+ID4gZGJbMV0gPSBzd2FiKGIpDQo+ID4g
X19yYXdfd3JpdGVsKGRiKQ0KPiA+IA0KPiA+IE5vdyBpdCBpcw0KPiA+IGRiWzBdID0gYQ0KPiA+
IGRiWzFdID0gYg0KPiA+IF9fcmF3X3dyaXRlbChzd2FiKGRiKSkNCj4gPiANCj4gPiBQdXR0aW5n
IHRoZSBzd2FiIGFyb3VuZCB0aGUgdTY0IHN3YXBzIHRoZSBvcmRlciBvZiBhL2IgaW4gdGhlIFRM
UC4NCj4gPiANCj4gPiBJdCBtaWdodCBiZSB0ZW1wdGluZyB0byBzd2FwIGRiWzBdL2RiWzFdIGJ1
dCBJSVJDIHRoaXMgbWVzc2VkIGl0IHVwDQo+ID4gb24NCj4gPiBCRS4NCj4gDQo+IE9vcHMuIFlv
dSBhcmUgcmlnaHQuLi4NCj4gDQo+ID4gVGhlIHNhbmVzdCwgc2ltcGxlc3Qgc29sdXRpb24gaXMg
dG8gdXNlIGEgdTY0IG5hdGl2ZWx5LCBhcyB0aGUNCj4gPiBleGFtcGxlDQo+ID4gSSBnYXZlIGRp
ZC4NCj4gDQo+IEkgYWdyZWUuDQo+IA0KPiA+IFRoZXJlIGlzIGFsc28gdGhlIGlzc3VlIG9mIGNh
c3RpbmcgYSB1MzIgdG8gYSB1NjQgYW5kIHBvc3NpYmx5DQo+ID4gdHJpZ2dlcmluZyBhIHVuYWxp
Z25lZCBrZXJuZWwgYWNjZXNzLCBwcmVzdW1hYmx5IHRoaXMgZG9lc24ndA0KPiA+IGhhcHBlbg0K
PiA+IHRvZGF5IG9ubHkgYnkgc29tZSBsdWNreSBjaGFuY2UuLg0KPiA+IA0KPiA+ID4gCW1seDVf
d3JpdGU2NChkb29yYmVsbCwgdWFyX3BhZ2UgKyBNTFg1X0NRX0RPT1JCRUxMKTsNCj4gPiA+IH0N
Cj4gPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L21seDUvZG9vcmJlbGwuaA0KPiA+ID4g
Yi9pbmNsdWRlL2xpbnV4L21seDUvZG9vcmJlbGwuaA0KPiA+ID4gaW5kZXggNWMyNjc3MDdlMWRm
Li45YzFkMzU3NzczMjMgMTAwNjQ0DQo+ID4gPiArKysgYi9pbmNsdWRlL2xpbnV4L21seDUvZG9v
cmJlbGwuaA0KPiA+ID4gQEAgLTQzLDE3ICs0MywxNSBAQA0KPiA+ID4gICogTm90ZSB0aGF0IHRo
ZSB3cml0ZSBpcyBub3QgYXRvbWljIG9uIDMyLWJpdCBzeXN0ZW1zISBJbg0KPiA+ID4gY29udHJh
c3QgdG8gNjQtYml0DQo+ID4gPiAgKiBvbmVzLCBpdCByZXF1aXJlcyBwcm9wZXIgbG9ja2luZy4g
bWx4NV93cml0ZTY0IGRvZXNuJ3QgZG8gYW55DQo+ID4gPiBsb2NraW5nLCBzbyB1c2UNCj4gPiA+
ICAqIGl0IGF0IHlvdXIgb3duIGRpc2NyZXRpb24sIHByb3RlY3RlZCBieSBzb21lIGtpbmQgb2Yg
bG9jayBvbg0KPiA+ID4gMzIgYml0cy4NCj4gPiA+IC0gKg0KPiA+ID4gLSAqIFRPRE86IHVzZSB3
cml0ZXtxLGx9X3JlbGF4ZWQoKQ0KPiA+ID4gICovDQo+ID4gPiANCj4gPiA+IC1zdGF0aWMgaW5s
aW5lIHZvaWQgbWx4NV93cml0ZTY0KF9fYmUzMiB2YWxbMl0sIHZvaWQgX19pb21lbQ0KPiA+ID4g
KmRlc3QpDQo+ID4gPiArc3RhdGljIGlubGluZSB2b2lkIG1seDVfd3JpdGU2NCh1MzIgdmFsWzJd
LCB2b2lkIF9faW9tZW0gKmRlc3QpDQo+ID4gPiB7DQo+ID4gDQo+ID4gU28gdGhpcyBzaG91bGQg
YWNjZXB0IGEgc3RyYWlnaHQgdTY0LCB0aGUgZ29vZnkgYXJyYXlzIGhhdmUgdG8gZ28NCj4gPiBh
d2F5DQo+IA0KPiBJIGFncmVlLg0KPiANCj4gPiA+ICNpZiBCSVRTX1BFUl9MT05HID09IDY0DQo+
ID4gPiAtCV9fcmF3X3dyaXRlcSgqKHU2NCAqKXZhbCwgZGVzdCk7DQo+ID4gPiArCWlvd3JpdGU2
NGJlKCoodTY0ICopdmFsLCBkZXN0KTsNCj4gPiA+ICNlbHNlDQo+ID4gPiAtCV9fcmF3X3dyaXRl
bCgoX19mb3JjZSB1MzIpIHZhbFswXSwgZGVzdCk7DQo+ID4gPiAtCV9fcmF3X3dyaXRlbCgoX19m
b3JjZSB1MzIpIHZhbFsxXSwgZGVzdCArIDQpOw0KPiA+ID4gKwlpb3dyaXRlMzJiZSh2YWxbMF0s
IGRlc3QpOw0KPiA+ID4gKwlpb3dyaXRlMzJiZSh2YWxbMV0sIGRlc3QgKyA0KTsNCj4gPiANCj4g
PiBXaXRoIGEgdTY0IGlucHV0IHRoaXMgZmFsbGJhY2sgaXMgd3JpdHRlbiBhcw0KPiA+IA0KPiA+
ICBpb3dyaXRlMzJiZSh2YWwgPj4gMzIsIGRlc3QpDQo+ID4gIGlvd3JpdGUzMmJlKCh1MzIpdmFs
LCBkZXN0ICsgNCkNCj4gPiANCj4gPiBXaGljaCBtYXRjaGVzIHRoZSBkZWZpbml0aW9uIGZvciBo
b3cgd3JpdGU2NCBtdXN0IGNvbnN0cnVjdCBhIFRMUC4NCj4gPiANCj4gPiBBbmQgYXJndWFibHkg
dGhlIGZpcnN0IG9uZSBzaG91bGQgYmUgX3JlbGF4ZWQgKGJ1dCBub2JvZHkgY2FyZXMNCj4gPiBh
Ym91dA0KPiA+IHRoaXMgY29kZSBwYXRoKQ0KPiANCj4gSSBhZ3JlZSB3aXRoIGV2ZXJ5dGhpbmcu
IFdpbGwgZml4IG9uIHYzLg0KPiANCg0KSGkgTGlyYW4sDQoNCkFzIGFncmVlZCBpbiBhIHNlcGFy
YXRlIGVtYWlsIHRocmVhZCwgd2Ugd2lsbCBydW4gcGVyZm9ybWFuY2UNCnJlZ3Jlc3Npb24sIGJl
Zm9yZSBpIGNhbiBtZXJnZSB0aGlzIHBhdGNoLCBDQ2VkIE1vc2hlIGFuZCBUYWwgZm9yDQpwZXJv
Zm1hbmNlIGZlZWRiYWNrLg0KDQpUaGFua3MsDQpTYWVlZC4NCg0K
