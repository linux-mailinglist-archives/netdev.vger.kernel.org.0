Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9722EECC6
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 00:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729608AbfD2Wal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 18:30:41 -0400
Received: from mail-eopbgr50066.outbound.protection.outlook.com ([40.107.5.66]:58948
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729481AbfD2Wak (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 18:30:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IFLu2rs2dR6JHeApaL59onKAqkTjAVk0lXWA4pW7UXE=;
 b=ZgxP7ZTfJt7r3HP2+JcXbERP2pfsTlXUgKj1mUgDju5WIE40Ck3G1BKRj8g1dfqyJROYTnupZ9YRBElKVmjWKxWQshNWVNZR4gRWgsql5XCg18Jv7ER7/TcNKQv5/lHksv7I8Ik0zOyxEKIEFFrfcd0iUbw2/DtwQ66u5tA/c/U=
Received: from AM0PR05MB4403.eurprd05.prod.outlook.com (52.134.125.139) by
 AM0PR05MB4161.eurprd05.prod.outlook.com (52.134.91.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.16; Mon, 29 Apr 2019 22:30:36 +0000
Received: from AM0PR05MB4403.eurprd05.prod.outlook.com
 ([fe80::98:126b:8dff:a304]) by AM0PR05MB4403.eurprd05.prod.outlook.com
 ([fe80::98:126b:8dff:a304%2]) with mapi id 15.20.1835.018; Mon, 29 Apr 2019
 22:30:36 +0000
From:   Mark Bloch <markb@mellanox.com>
To:     Parav Pandit <parav@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
CC:     Jason Gunthorpe <jgg@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>
Subject: Re: [PATCH V2 mlx5-next 09/11] net/mlx5: Eswitch, enable RoCE
 loopback traffic
Thread-Topic: [PATCH V2 mlx5-next 09/11] net/mlx5: Eswitch, enable RoCE
 loopback traffic
Thread-Index: AQHU/rdb3xYS6QvHhU6QR10xVu74XaZTeNaAgAABTYCAAD63gA==
Date:   Mon, 29 Apr 2019 22:30:36 +0000
Message-ID: <e08a2f83-03ac-61cf-322f-652f4549e074@mellanox.com>
References: <20190429181326.6262-1-saeedm@mellanox.com>
 <20190429181326.6262-10-saeedm@mellanox.com>
 <20190429184116.GB6705@mtr-leonro.mtl.com>
 <VI1PR0501MB22712A3E3743FE283308771ED1390@VI1PR0501MB2271.eurprd05.prod.outlook.com>
In-Reply-To: <VI1PR0501MB22712A3E3743FE283308771ED1390@VI1PR0501MB2271.eurprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR08CA0029.namprd08.prod.outlook.com
 (2603:10b6:a03:100::42) To AM0PR05MB4403.eurprd05.prod.outlook.com
 (2603:10a6:208:65::11)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=markb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [208.186.24.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3110398-9b96-4b6f-8eac-08d6ccf24cc7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4161;
x-ms-traffictypediagnostic: AM0PR05MB4161:
x-microsoft-antispam-prvs: <AM0PR05MB416132F9DAC35785764B6AB0D2390@AM0PR05MB4161.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(376002)(366004)(39860400002)(136003)(199004)(189003)(13464003)(68736007)(476003)(81166006)(66556008)(66946007)(66446008)(73956011)(64756008)(66476007)(5660300002)(93886005)(8936002)(2616005)(36756003)(86362001)(53936002)(11346002)(6512007)(6636002)(486006)(107886003)(71190400001)(446003)(229853002)(31696002)(6436002)(97736004)(71200400001)(31686004)(6486002)(25786009)(6246003)(7736002)(450100002)(305945005)(76176011)(186003)(6506007)(256004)(54906003)(55236004)(53546011)(66066001)(3846002)(26005)(6116002)(52116002)(14444005)(2906002)(110136005)(478600001)(316002)(14454004)(99286004)(8676002)(81156014)(102836004)(386003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4161;H:AM0PR05MB4403.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GV8oJBOnL2eM6PQyGOkZ5vOaMRrDOZ4w+iZYVY9N/hsxfMU2Vp+wfIPSl3AXCjhDf3Gd9dNyMhnfLB8sG9Ac8VDgquWmON27prF1mX61ZL0tlrrYjr0uE+flScmas1GoiWJ5DdoguG5iw3Z13O1Gt1Qg7x7dyz3Qv32As5IXjUXptXNC/Atrhoyu6vmLfeh6jyRVZqHpNwp1mXEtvuW7sbeSg8y5EMOLeNvXDaubn99mjYCH1WPw7s7QcDx6l1HOYgJLW1kO88e747+AAI72JIu15JVRywxnpgIZjhUkKlckIwE+2qCKPIUiHgYr67GrzJnbSMJ1xDTJm0Wad9DIuYXCMCP6F4BGy1wi8PFGqF9V+MUKVcyYaYDCqtvYiZnNopC+109notib6JS4sccVBybFnWO6axAi9m8YOuJBnVs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <41041E1F57FA0D49947933CC6DC24E9E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3110398-9b96-4b6f-8eac-08d6ccf24cc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 22:30:36.4744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4161
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDQvMjkvMTkgMTE6NDUgQU0sIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gDQo+IA0KPj4g
LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4+IEZyb206IG5ldGRldi1vd25lckB2Z2VyLmtl
cm5lbC5vcmcgPG5ldGRldi1vd25lckB2Z2VyLmtlcm5lbC5vcmc+IE9uDQo+PiBCZWhhbGYgT2Yg
TGVvbiBSb21hbm92c2t5DQo+PiBTZW50OiBNb25kYXksIEFwcmlsIDI5LCAyMDE5IDE6NDEgUE0N
Cj4+IFRvOiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCj4+IENjOiBKYXNv
biBHdW50aG9ycGUgPGpnZ0BtZWxsYW5veC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBs
aW51eC0NCj4+IHJkbWFAdmdlci5rZXJuZWwub3JnOyBNYW9yIEdvdHRsaWViIDxtYW9yZ0BtZWxs
YW5veC5jb20+OyBNYXJrIEJsb2NoDQo+PiA8bWFya2JAbWVsbGFub3guY29tPg0KPj4gU3ViamVj
dDogUmU6IFtQQVRDSCBWMiBtbHg1LW5leHQgMDkvMTFdIG5ldC9tbHg1OiBFc3dpdGNoLCBlbmFi
bGUgUm9DRQ0KPj4gbG9vcGJhY2sgdHJhZmZpYw0KPj4NCj4+IE9uIE1vbiwgQXByIDI5LCAyMDE5
IGF0IDA2OjE0OjE2UE0gKzAwMDAsIFNhZWVkIE1haGFtZWVkIHdyb3RlOg0KPj4+IEZyb206IE1h
b3IgR290dGxpZWIgPG1hb3JnQG1lbGxhbm94LmNvbT4NCj4+Pg0KPj4+IFdoZW4gaW4gc3dpdGNo
ZGV2IG1vZGUsIHdlIHdvdWxkIGxpa2UgdG8gdHJlYXQgbG9vcGJhY2sgUm9DRSB0cmFmZmljDQo+
Pj4gKG9uIGVzd2l0Y2ggbWFuYWdlcikgYXMgUkRNQSBhbmQgbm90IGFzIHJlZ3VsYXIgRXRoZXJu
ZXQgdHJhZmZpYyBJbg0KPj4+IG9yZGVyIHRvIGVuYWJsZSBpdCB3ZSBhZGQgZmxvdyBzdGVlcmlu
ZyBydWxlIHRoYXQgZm9yd2FyZCBSb0NFDQo+Pj4gbG9vcGJhY2sgdHJhZmZpYyB0byB0aGUgSFcg
Um9DRSBmaWx0ZXIgKGJ5IGFkZGluZyBhbGxvdyBydWxlKS4NCj4+PiBJbiBhZGRpdGlvbiB3ZSBh
ZGQgUm9DRSBhZGRyZXNzIGluIEdJRCBpbmRleCAwLCB3aGljaCB3aWxsIGJlIHNldCBpbg0KPj4+
IHRoZSBSb0NFIGxvb3BiYWNrIHBhY2tldC4NCj4+Pg0KPiBJIGxpa2VseSBkb24ndCB1bmRlcnN0
YW5kIG5vciBJIHJldmlld2VkIHRoZSBwYXRjaGVzLg0KPiBQYXJ0IHRoYXQgSSBkb24ndCB1bmRl
cnN0YW5kIGlzIEdJRCBpbmRleCAwIGZvciBSb0NFLg0KPiBSb0NFIHRyYWZmaWMgcnVucyBvdmVy
IGFsbCB0aGUgR0lEIGVudHJpZXMgYW5kIGZvciBhbGwgcHJhY3RpY2FsIHB1cnBvc2VzIGZyb20g
bm9uX3plcm8gaW5kZXguDQo+IEhvdyB3aWxsIGl0IHdvcms/DQoNCkN1cnJlbnRseSBpbiBzd2l0
Y2hkZXYgbW9kZSB3ZSBvbmx5IHN1cHBvcnQgUkFXIEV0aGVybmV0IFFQIGFuZCBubyBSb0NFIGNh
cGFiaWxpdGllcyBhcmUgcmVwb3J0ZWQgdG8gaWJfY29yZS4NCldoaWNoIG1lYW5zIG5vIEdJRHMg
YXJlIGluc2VydGVkIHRvIHRoZSBIVydzIEdJRCB0YWJsZSBhbmQgUm9DRSBpc24ndCBlbmFibGVk
IG9uIHRoZSB2cG9ydC4NCg0KSG93ZXZlciwgdGhlcmUgYXJlIGNhc2VzIHdoZXJlIGFuIGludGVy
bmFsIFJDIFFQIG1pZ2h0IGJlIG5lZWRlZCwgYW5kIGZvciB0aGF0IHdlIG5lZWQgYSBHSUQuDQpU
aGUgcGF0Y2hlcyBmcm9tIE1hb3IgbWFrZSBzdXJlIGEgR0lEIGVudHJ5IGF0IGluZGV4IDAgaXMg
dmFsaWQgKGFuZCB3ZSBkbyB0aGF0IG9ubHkgaW4gc3dpdGNoZGV2IG1vZGUpLA0KYW5kIHdpdGgg
c3RlZXJpbmcgd2UgbWFrZSBzdXJlIHN1Y2ggdHJhZmZpYyBpcyBvbmx5IHVzZWQgZm9yIGxvb3Bi
YWNrIHB1cnBvc2VzLg0KDQpNYXJrDQogDQo+IEl0IGlzIGJldHRlciBpZiB5b3UgZXhwbGFpbiBp
dCBpbiB0aGUgY29tbWl0IGxvZywgd2h5IGl0cyBkb25lIHRoaXMgd2F5LCAnd2hhdCcgcGFydCBp
cyBhbHJlYWR5IHByZXNlbnQgdGhlIHBhdGNoLg0KPiANCj4gDQo+Pj4gU2lnbmVkLW9mZi1ieTog
TWFvciBHb3R0bGllYiA8bWFvcmdAbWVsbGFub3guY29tPg0KPj4+IFJldmlld2VkLWJ5OiBNYXJr
IEJsb2NoIDxtYXJrYkBtZWxsYW5veC5jb20+DQo+Pj4gU2lnbmVkLW9mZi1ieTogU2FlZWQgTWFo
YW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo+Pj4gLS0tDQo+Pj4gIC4uLi9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL01ha2VmaWxlICB8ICAgMiArLQ0KPj4+ICAuLi4vbWVsbGFu
b3gvbWx4NS9jb3JlL2Vzd2l0Y2hfb2ZmbG9hZHMuYyAgICAgfCAgIDQgKw0KPj4+ICAuLi4vbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9yZG1hLmMgICAgfCAxODIgKysrKysrKysrKysr
KysrKysrDQo+Pj4gIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL3JkbWEuaCAg
ICB8ICAyMCArKw0KPj4+ICBpbmNsdWRlL2xpbnV4L21seDUvZHJpdmVyLmggICAgICAgICAgICAg
ICAgICAgfCAgIDcgKw0KPj4+ICA1IGZpbGVzIGNoYW5nZWQsIDIxNCBpbnNlcnRpb25zKCspLCAx
IGRlbGV0aW9uKC0pICBjcmVhdGUgbW9kZSAxMDA2NDQNCj4+PiBkcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvcmRtYS5jDQo+Pj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvcmRtYS5oDQo+Pj4NCj4+DQo+PiBU
aGFua3MsDQo+PiBBY2tlZC1ieTogTGVvbiBSb21hbm92c2t5IDxsZW9ucm9AbWVsbGFub3guY29t
Pg0K
