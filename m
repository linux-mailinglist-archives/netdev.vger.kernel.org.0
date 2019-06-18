Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84A4B4A9C2
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730197AbfFRSZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:25:50 -0400
Received: from mail-eopbgr30052.outbound.protection.outlook.com ([40.107.3.52]:35707
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727616AbfFRSZu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 14:25:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G1vbh2K593EGktkzPOJe05CCnv8JZbwF+VLdvrk2bcU=;
 b=Dy34YpZqCBNhY/9JNdZCGCtM4926K+1W+5+B/SHUrrIqeYkp7k3rzAIDPUahr9oYQqYQ315bsU9Or4qw/F06h6tCgA/mUrgNrzjPng68RDsVoiI/kXN6yc5yxUfCRiv9hkvQpHRdOpVfE8DRM0U0kj6rEWOjz6uRfs+9O9ImldQ=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2390.eurprd05.prod.outlook.com (10.168.75.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Tue, 18 Jun 2019 18:25:46 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 18:25:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Parav Pandit <parav@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     Mark Bloch <markb@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Bodong Wang <bodong@mellanox.com>
Subject: Re: [PATCH mlx5-next 14/15] {IB, net}/mlx5: E-Switch, Use index of
 rep for vport to IB port mapping
Thread-Topic: [PATCH mlx5-next 14/15] {IB, net}/mlx5: E-Switch, Use index of
 rep for vport to IB port mapping
Thread-Index: AQHVJUIpGI7fvdRK1U+ZsqwPxYsEnKahOoGAgAABfQCAAH/3gA==
Date:   Tue, 18 Jun 2019 18:25:46 +0000
Message-ID: <7b098b42a51e5b96eca99c024719eebafa775f7a.camel@mellanox.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
         <20190617192247.25107-15-saeedm@mellanox.com>
         <20190618104220.GH4690@mtr-leonro.mtl.com>
         <AM0PR05MB4866DF63BB7D80483630F0A9D1EA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
In-Reply-To: <AM0PR05MB4866DF63BB7D80483630F0A9D1EA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92900457-cfd7-4caf-c805-08d6f41a61ad
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2390;
x-ms-traffictypediagnostic: DB6PR0501MB2390:
x-microsoft-antispam-prvs: <DB6PR0501MB2390A5FEC57CE7BEAAC9F371BEEA0@DB6PR0501MB2390.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(366004)(396003)(376002)(39860400002)(199004)(189003)(13464003)(64756008)(86362001)(81166006)(478600001)(53546011)(5660300002)(486006)(6506007)(6636002)(76176011)(118296001)(54906003)(3846002)(68736007)(14454004)(53936002)(81156014)(8936002)(316002)(110136005)(2906002)(6116002)(229853002)(6486002)(58126008)(8676002)(6246003)(7736002)(476003)(66556008)(66476007)(71190400001)(446003)(102836004)(66446008)(186003)(6512007)(26005)(25786009)(305945005)(6436002)(11346002)(66946007)(76116006)(73956011)(91956017)(66066001)(2616005)(99286004)(4326008)(71200400001)(450100002)(107886003)(256004)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2390;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: I7K8KybzyhaeDKRCpk9b/GbXYW74Qbqcnqxnb9MuC5f+zne8Bs/gOVinVWB4do123c6eT3M9JQFE6f7kA/rXPCWlhcbXhBRbF5JydiHhvQOlQioesNuK4foen5eyu8/b16R7dDKErZUQOA9XYgdAIuwTsMSXGmli46tWiYxXP6OfSWY77RHTvY/bQPwFK9fxVUQHmWZBtJdc0alkPzL53gY6/P6J5VBp+BNf/urdGeNK9sUeB4tiP1vEjR3oi1yy+F9DvfutpJhWAoWVxNdC3cya+krCLUKeYvk75HJN3aRAsdV8ihLsAeg+LCxqVSEo6AXYEgCTuAvjL5PO7wSbMylu8Ux36lYuKdN27DfoX5q4PvZo5DrA06hWKfZFdUtwR+0gQKosWYwARuO26lnXhf4FCGYV6c1GITyuRqi/upk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <09BE78105BB32A4781F89EF5AA17F0AD@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92900457-cfd7-4caf-c805-08d6f41a61ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 18:25:46.3288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2390
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA2LTE4IGF0IDEwOjQ3ICswMDAwLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+
IEhpIExlb24sDQo+IA0KPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTog
TGVvbiBSb21hbm92c2t5DQo+ID4gU2VudDogVHVlc2RheSwgSnVuZSAxOCwgMjAxOSA0OjEyIFBN
DQo+ID4gVG86IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiA+IENjOiBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1yZG1hQHZnZXIua2VybmVsLm9yZzsgQm9kb25n
IFdhbmcNCj4gPiA8Ym9kb25nQG1lbGxhbm94LmNvbT47IFBhcmF2IFBhbmRpdCA8cGFyYXZAbWVs
bGFub3guY29tPjsgTWFyaw0KPiA+IEJsb2NoDQo+ID4gPG1hcmtiQG1lbGxhbm94LmNvbT4NCj4g
PiBTdWJqZWN0OiBSZTogW1BBVENIIG1seDUtbmV4dCAxNC8xNV0ge0lCLCBuZXR9L21seDU6IEUt
U3dpdGNoLCBVc2UNCj4gPiBpbmRleCBvZiByZXANCj4gPiBmb3IgdnBvcnQgdG8gSUIgcG9ydCBt
YXBwaW5nDQo+ID4gDQo+ID4gT24gTW9uLCBKdW4gMTcsIDIwMTkgYXQgMDc6MjM6MzdQTSArMDAw
MCwgU2FlZWQgTWFoYW1lZWQgd3JvdGU6DQo+ID4gPiBGcm9tOiBCb2RvbmcgV2FuZyA8Ym9kb25n
QG1lbGxhbm94LmNvbT4NCj4gPiA+IA0KPiA+ID4gSW4gdGhlIHNpbmdsZSBJQiBkZXZpY2UgbW9k
ZSwgdGhlIG1hcHBpbmcgYmV0d2VlbiB2cG9ydCBudW1iZXINCj4gPiA+IGFuZCByZXANCj4gPiA+
IHJlbGllcyBvbiBhIGNvdW50ZXIuIEhvd2V2ZXIgZm9yIGR5bmFtaWMgdnBvcnQgYWxsb2NhdGlv
biwgaXQgaXMNCj4gPiA+IGRlc2lyZWQgdG8ga2VlcCBjb25zaXN0ZW50IG1hcCBvZiBlc3dpdGNo
IHZwb3J0IGFuZCBJQiBwb3J0Lg0KPiA+ID4gDQo+ID4gPiBIZW5jZSwgc2ltcGxpZnkgY29kZSB0
byByZW1vdmUgdGhlIGZyZWUgcnVubmluZyBjb3VudGVyIGFuZA0KPiA+ID4gaW5zdGVhZA0KPiA+
ID4gdXNlIHRoZSBhdmFpbGFibGUgdnBvcnQgaW5kZXggZHVyaW5nIGxvYWQvdW5sb2FkIHNlcXVl
bmNlIGZyb20NCj4gPiA+IHRoZQ0KPiA+ID4gZXN3aXRjaC4NCj4gPiA+IA0KPiA+ID4gU2lnbmVk
LW9mZi1ieTogQm9kb25nIFdhbmcgPGJvZG9uZ0BtZWxsYW5veC5jb20+DQo+ID4gPiBTdWdnZXN0
ZWQtYnk6IFBhcmF2IFBhbmRpdCA8cGFyYXZAbWVsbGFub3guY29tPg0KPiA+ID4gUmV2aWV3ZWQt
Ynk6IFBhcmF2IFBhbmRpdCA8cGFyYXZAbWVsbGFub3guY29tPg0KPiA+IA0KPiA+IFdlIGFyZSBu
b3QgYWRkaW5nIG11bHRpcGxlICIqLWJ5IiBmb3Igc2FtZSB1c2VyLCBwbGVhc2UgY2hvb3NlIG9u
ZS4NCj4gPiANCj4gU3VnZ2VzdGVkLWJ5IHdhcyBhZGRlZCBieSBCb2RvbmcgZHVyaW5nIG91ciBk
aXNjdXNzaW9uLiBMYXRlciBvbiB3aGVuDQo+IEkgZGlkIGdlcnJpdCArMSwgUkIgdGFnIGdvdCBh
ZGRlZC4NCj4gDQoNCklzIHRoZXJlIGEgcnVsZSBhZ2FpbnN0IGhhdmluZyBtdWx0aXBsZSAiKi1i
eSIgPyBpIGRvbid0IHRoaW5rIHNvICBhbmQNCnRoZXJlIHNob3VsZG4ndCBiZSwgdXNlcnMgbmVl
ZCB0byBnZXQgdGhlIGV4YWN0IGFtb3VudCBvZiByZWNvZ25pdGlvbg0KYXMgdGhlIGFtb3VudCBv
ZiB3b3JrIHRoZXkgcHV0IGludG8gdGhpcyBwYXRjaCwgaWYgdGhleSByZXZpZXdlZCBhbmQNCnRl
c3RlZCBhIHBhdGNoIHRoZXkgZGVzZXJ2ZSB0d28gdGFncyAuLiANCg0KDQo=
