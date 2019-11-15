Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08C01FD1CB
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 01:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfKOADV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 19:03:21 -0500
Received: from mail-eopbgr70084.outbound.protection.outlook.com ([40.107.7.84]:6462
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726767AbfKOADV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 19:03:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QUAdLuXYQgDPWx9gfOiXlYvZDXCDZMCgSydc2JsglgRISsQHnoTfYRomRBxbZAbcwUQqDqbtHWxD/q/miU3LguiLXJX6NjjS5UYgyEYI8vFzBnrRP5JZucYNrsxyvqAs4lcengPhVGzoBTq3mIbTsALd/0cx4yz7/s5LovpY2LeU6TXr4avFxL2FzJs79rXZnYIehp1uI+3KURMLX5fG6in+QfzAw9xW0fMnD9uGCJjlcuVkvk1NtBtTWh676uLt+8AMi3fdAVVjEqHKzwvCsNi9TtewtG8z/skPtwm1Osf7OcJt9uj3lOnAtYWPMRFlaDLS2DGofdsVq/G0v8+e7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IzpcbkzsVCAmdpHhOQhUJXyhq0a6A59kREyi/s+4QHk=;
 b=MY4RnAxVnFYmMl2lrGZSNUFXxmD9QkHcxw5N253uNDIxYyy3yWfm0ura7dsQ1NTUkPOISC4VbI5j8dZ3Kng9iQLcRQ5/NUrcJ7ma61fhNSDuwJuNSRVCkjl+NaPSpivdg+DFx5T/FYZc6HYrH6lPpwh5qjaQbI94Ehurbw+EtRyJDYPDR3toQvsHPFyn+DFXQq6CgJRI/iBgbdQ+CytPaliW3TUSefnzmvqKjcuVF/+3vZTzWlAcL0vvd5bmc5q/YmOjnG4Ia46eBXsg1XwVtN+o3MYZkQDW6wtlnKhzK2UL6XB1zu09RQK6VR/nPzdCE9n1eRXKMkbNRRa4sQBLZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IzpcbkzsVCAmdpHhOQhUJXyhq0a6A59kREyi/s+4QHk=;
 b=BvHBs+edS78Ox3FZw5H6i0pNk/UYFO2uhOoJ7geTqHsQ6ABhgbIFk7qFPFumrbDbintiAa6uIgy97207jch8jZtA5CFQstPiWusWAmqxjhaXUvdzz3BIE49bQ8wK9k56hNVeCGVl2x285lr0hv/klidwS1ur39QtIwjWKAQ7Fls=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5776.eurprd05.prod.outlook.com (20.178.122.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.22; Fri, 15 Nov 2019 00:03:14 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.028; Fri, 15 Nov 2019
 00:03:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Ariel Levkovich <lariel@mellanox.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "christopher.s.hall@intel.com" <christopher.s.hall@intel.com>,
        Eugenia Emantayev <eugenia@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>,
        Feras Daoud <ferasda@mellanox.com>,
        "stefan.sorensen@spectralink.com" <stefan.sorensen@spectralink.com>,
        "brandon.streiff@ni.com" <brandon.streiff@ni.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "felipe.balbi@linux.intel.com" <felipe.balbi@linux.intel.com>
Subject: Re: [PATCH net 06/13] mlx5: reject unsupported external timestamp
 flags
Thread-Topic: [PATCH net 06/13] mlx5: reject unsupported external timestamp
 flags
Thread-Index: AQHVmxuuaGhUBoj4KkqsB9Kgi1dgk6eLWewA
Date:   Fri, 15 Nov 2019 00:03:14 +0000
Message-ID: <c90050bd6a63ef3a6f0c7ea999f44ec51c07e917.camel@mellanox.com>
References: <20191114184507.18937-7-richardcochran@gmail.com>
In-Reply-To: <20191114184507.18937-7-richardcochran@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 26646fb6-96b7-40fc-d765-08d7695f3609
x-ms-traffictypediagnostic: VI1PR05MB5776:|VI1PR05MB5776:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB577642EEC70842B268FEA06DBE700@VI1PR05MB5776.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02229A4115
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(189003)(199004)(71190400001)(2906002)(4326008)(6512007)(91956017)(58126008)(66946007)(110136005)(4001150100001)(66066001)(54906003)(76116006)(118296001)(2201001)(305945005)(7416002)(14454004)(7736002)(6246003)(36756003)(6436002)(2501003)(478600001)(76176011)(6486002)(486006)(66446008)(64756008)(66556008)(66476007)(71200400001)(446003)(14444005)(316002)(81166006)(81156014)(229853002)(5660300002)(6506007)(476003)(8936002)(2616005)(25786009)(26005)(102836004)(186003)(99286004)(256004)(8676002)(6116002)(3846002)(86362001)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5776;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: renHeudv9fZylJ35221lAPHozMYShYjRGMNABwy+TWbBIK+RfD7qr0kUIV/DwgVUrL9c0hxORgq9YLvsNQGkeip3vY5vPkb2Vrem3/Lk7A+rnbO4vJpLlztqa4JSzsIK8UYuo2+ad0rjLMv4oMFFTgiyVPIqh7dhnUjBNwFY/XkleI/1RX5ovV/G9IxGyTHsYQP6RyKNSr0nUmzp0BIgqtY0X8hgOFVM70yUvfyWRcs4kO19shOQn5VA+xz5E80T6IaTk2iAmUdKnrgI4qwCFByPFJQJ1x2PXUhv5ycqq+iZaIuU6YuOjFTyzhN4svBc+AnzbO/PD2I7tgo7ijuVyXG9BYU8XPo0TuSOnlLKdH567HNAxDTqd9oGUJvx+NEqVchnuvFma2N8Qw8aVezQXtAlHyhNFKnM/4veGT7cJ9/RWPpGUCAVkx8zUedNTNKO
Content-Type: text/plain; charset="utf-8"
Content-ID: <F6EF8D089C657F42958C0577D64776CD@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26646fb6-96b7-40fc-d765-08d7695f3609
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2019 00:03:14.3699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4ReJHbcueESdIo+YTSbuMTvK3PAAM0Hyp6NchM8cVTNr+rAQkguDlnMqb5JJOMkA2tARRAv4WMAfciG7p8rDKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5776
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTExLTE0IGF0IDEwOjQ1IC0wODAwLCBSaWNoYXJkIENvY2hyYW4gd3JvdGU6
DQo+IEZyb206IEphY29iIEtlbGxlciA8amFjb2IuZS5rZWxsZXJAaW50ZWwuY29tPg0KPiANCj4g
Rml4IHRoZSBtbHg1IGNvcmUgUFRQIHN1cHBvcnQgdG8gZXhwbGljaXRseSByZWplY3QgYW55IGZ1
dHVyZSBmbGFncw0KPiB0aGF0DQo+IGdldCBhZGRlZCB0byB0aGUgZXh0ZXJuYWwgdGltZXN0YW1w
IHJlcXVlc3QgaW9jdGwuDQo+IA0KPiBJbiBvcmRlciB0byBtYWludGFpbiBjdXJyZW50bHkgZnVu
Y3Rpb25pbmcgY29kZSwgdGhpcyBwYXRjaCBhY2NlcHRzDQo+IGFsbA0KPiB0aHJlZSBjdXJyZW50
IGZsYWdzLiBUaGlzIGlzIGJlY2F1c2UgdGhlIFBUUF9SSVNJTkdfRURHRSBhbmQNCj4gUFRQX0ZB
TExJTkdfRURHRSBmbGFncyBoYXZlIHVuY2xlYXIgc2VtYW50aWNzIGFuZCBlYWNoIGRyaXZlciBz
ZWVtcw0KPiB0bw0KPiBoYXZlIGludGVycHJldGVkIHRoZW0gc2xpZ2h0bHkgZGlmZmVyZW50bHku
DQo+IA0KPiBbIFJDOiBJJ20gbm90IDEwMCUgc3VyZSB3aGF0IHRoaXMgZHJpdmVyIGRvZXMsIGJ1
dCBpZiBJJ20gbm90IHdyb25nDQo+IGl0DQo+ICAgICAgIGZvbGxvd3MgdGhlIGRwODM2NDA6DQo+
IA0KDQpUaGUgZHJpdmVyIHdpbGwgY2hlY2sgaWYgdGhlIFBUUF9GQUxMSU5HX0VER0UgZmxhZyB3
YXMgc2V0IHRoZW4gaXQgd2lsbA0Kc2V0IGl0IGluIEhXLCBpZiBub3QgdGhlbiBpdCBpcyBnb2lu
ZyB0byBkZWZhdWx0IHRvIFBUUF9SSVNJTkdfRURHRSwgc28NCkxHVE0uDQoNClJldmlld2VkLWJ5
OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCg0KQnV0IHNhbWUgc3Rvcnkg
aGVyZSwgb2xkIHRvb2xzIHRoYXQgbGF6aWx5IHNldCAweGZmZmYgb3IgMHgwMDAwIGFuZA0KZXhw
ZWN0ZWQgZXZlcnkgdGhpbmcgdG8gd29yay4uIGFnYWluIG5vdCBzdXJlIGlmIHRoZXkgZG8gZXhp
c3QuDQoNCkFyaWVsIHBsZWFzZSBoYXZlIGEgbG9vayBhdCB0aGlzIHBhdGNoLg0KDQo+ICAgZmxh
Z3MgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgTWVhbmlu
Zw0KPiAgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0gIC0tLS0tLS0tLS0tLS0NCj4gLS0tLS0tLS0tLS0tLQ0KPiAgIFBUUF9FTkFCTEVfRkVBVFVS
RSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFRpbWUgc3RhbXANCj4gcmlzaW5n
IGVkZ2UNCj4gICBQVFBfRU5BQkxFX0ZFQVRVUkV8UFRQX1JJU0lOR19FREdFICAgICAgICAgICAg
ICAgICAgICBUaW1lIHN0YW1wDQo+IHJpc2luZyBlZGdlDQo+ICAgUFRQX0VOQUJMRV9GRUFUVVJF
fFBUUF9GQUxMSU5HX0VER0UgICAgICAgICAgICAgICAgICAgVGltZSBzdGFtcA0KPiBmYWxsaW5n
IGVkZ2UNCj4gICBQVFBfRU5BQkxFX0ZFQVRVUkV8UFRQX1JJU0lOR19FREdFfFBUUF9GQUxMSU5H
X0VER0UgICBUaW1lIHN0YW1wDQo+IGZhbGxpbmcgZWRnZQ0KPiBdDQo+IA0KPiBDYzogRmVyYXMg
RGFvdWQgPGZlcmFzZGFAbWVsbGFub3guY29tPg0KPiBDYzogRXVnZW5pYSBFbWFudGF5ZXYgPGV1
Z2VuaWFAbWVsbGFub3guY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBKYWNvYiBLZWxsZXIgPGphY29i
LmUua2VsbGVyQGludGVsLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IFJpY2hhcmQgQ29jaHJhbiA8cmlj
aGFyZGNvY2hyYW5AZ21haWwuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9saWIvY2xvY2suYyB8IDYgKysrKysrDQo+ICAxIGZpbGUgY2hhbmdl
ZCwgNiBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xpYi9jbG9jay5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xpYi9jbG9jay5jDQo+IGluZGV4IGNmZjZiNjBkZTMwNC4u
OWE0MGYyNGUzMTkzIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvbGliL2Nsb2NrLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2xpYi9jbG9jay5jDQo+IEBAIC0yMzYsNiArMjM2LDEyIEBAIHN0YXRp
YyBpbnQgbWx4NV9leHR0c19jb25maWd1cmUoc3RydWN0DQo+IHB0cF9jbG9ja19pbmZvICpwdHAs
DQo+ICAJaWYgKCFNTFg1X1BQU19DQVAobWRldikpDQo+ICAJCXJldHVybiAtRU9QTk9UU1VQUDsN
Cj4gIA0KPiArCS8qIFJlamVjdCByZXF1ZXN0cyB3aXRoIHVuc3VwcG9ydGVkIGZsYWdzICovDQo+
ICsJaWYgKHJxLT5leHR0cy5mbGFncyAmIH4oUFRQX0VOQUJMRV9GRUFUVVJFIHwNCj4gKwkJCQlQ
VFBfUklTSU5HX0VER0UgfA0KPiArCQkJCVBUUF9GQUxMSU5HX0VER0UpKQ0KPiArCQlyZXR1cm4g
LUVPUE5PVFNVUFA7DQo+ICsNCj4gIAlpZiAocnEtPmV4dHRzLmluZGV4ID49IGNsb2NrLT5wdHBf
aW5mby5uX3BpbnMpDQo+ICAJCXJldHVybiAtRUlOVkFMOw0KPiAgDQo=
