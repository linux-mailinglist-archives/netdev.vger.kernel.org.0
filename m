Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE824C054
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 19:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfFSRwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 13:52:41 -0400
Received: from mail-eopbgr50084.outbound.protection.outlook.com ([40.107.5.84]:12673
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726047AbfFSRwl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 13:52:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6As4d5g2/r4Zliwra2ZX6HBKQczasmuFihgjZIl/EOE=;
 b=A6g6Mj6pNgTO5z69m1ytEqvEb2wlHzOKcnZcq3tTOKhNrNqoGo3TkOtaHQvc3xMURkjHliP+RNKVk4VHXYuej4RS2p4ZLnXppsyPrMrGedyiMH/aicGuVwj5SHLGf1/RB/OqickWBGmwUiSanjvM6JDjUw9lM19O0g26AAPmc7k=
Received: from AM0PR05MB4403.eurprd05.prod.outlook.com (52.134.125.139) by
 AM0PR05MB4980.eurprd05.prod.outlook.com (20.176.215.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Wed, 19 Jun 2019 17:52:35 +0000
Received: from AM0PR05MB4403.eurprd05.prod.outlook.com
 ([fe80::edf6:f68:cb6c:777f]) by AM0PR05MB4403.eurprd05.prod.outlook.com
 ([fe80::edf6:f68:cb6c:777f%7]) with mapi id 15.20.1987.014; Wed, 19 Jun 2019
 17:52:35 +0000
From:   Mark Bloch <markb@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
CC:     Jianbo Liu <jianbol@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH mlx5-next 11/15] RDMA/mlx5: Add vport metadata matching
 for IB representors
Thread-Topic: [PATCH mlx5-next 11/15] RDMA/mlx5: Add vport metadata matching
 for IB representors
Thread-Index: AQHVJUImPYK8Rls4yUKWAAzrbtRMrqahNB6AgAE0tgCAAAWJgIAAGtQAgAADIQCAAAk4AIAABV+AgAADjoCAAAR9gIAAogoA
Date:   Wed, 19 Jun 2019 17:52:35 +0000
Message-ID: <b083805e-0174-cda9-d8f8-3d453d21c811@mellanox.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
 <20190617192247.25107-12-saeedm@mellanox.com>
 <20190618101928.GE4690@mtr-leonro.mtl.com>
 <20190619044420.GA30694@mellanox.com>
 <20190619050412.GC11611@mtr-leonro.mtl.com>
 <20190619063941.GA5176@mellanox.com>
 <20190619065125.GF11611@mtr-leonro.mtl.com>
 <4e01d326-db6c-f746-acd6-06f65f311f5b@mellanox.com>
 <20190619074338.GG11611@mtr-leonro.mtl.com>
 <ac23c3ea-3ea7-2a5b-5fc6-aece0aed0b54@mellanox.com>
 <20190619081226.GI11611@mtr-leonro.mtl.com>
In-Reply-To: <20190619081226.GI11611@mtr-leonro.mtl.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR11CA0087.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::28) To AM0PR05MB4403.eurprd05.prod.outlook.com
 (2603:10a6:208:65::11)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=markb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [208.186.24.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4bdf528-be47-4914-bf6d-08d6f4dee8e3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4980;
x-ms-traffictypediagnostic: AM0PR05MB4980:
x-microsoft-antispam-prvs: <AM0PR05MB49805B3E03B9B77E8B956C22D2E50@AM0PR05MB4980.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(376002)(346002)(366004)(189003)(199004)(2906002)(14444005)(25786009)(66556008)(86362001)(31696002)(14454004)(68736007)(6636002)(36756003)(8936002)(6116002)(450100002)(3846002)(71200400001)(26005)(229853002)(478600001)(8676002)(81166006)(99286004)(81156014)(71190400001)(486006)(73956011)(4326008)(54906003)(446003)(6246003)(256004)(52116002)(66946007)(305945005)(37006003)(5660300002)(186003)(7736002)(66476007)(64756008)(76176011)(6486002)(11346002)(31686004)(66446008)(316002)(53936002)(2616005)(102836004)(6436002)(6512007)(6862004)(6506007)(386003)(53546011)(55236004)(476003)(66066001)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4980;H:AM0PR05MB4403.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5fgGwFWfoCQ97jtk7C7bIfOcs2nmtwczXElZNH8G/GPCkNaJeLNLfXGJA/RbzrrT1B/Rp+kiO5YdHph30we25wZPN7DbjNSy/EmzAu2zB/YvJ9MOWR/HzkKnKSnEkaKtBzKIXx8Qdn2NWDP6Hv6imuHvlO726BF/D9K3d+6AtM4ER7A8hxC36jor/5yRv7Dwn0yq1S1blNjWyrKPcPMfOQAuOxRDx82fpn7PZA9NDzWBLN0chyIcbsr9Q3cJOTQHPNPmP93w2wvAtBXEQMaZsRpEZZ47NucH9d26n/j48yJ2WNfGrfz4UOUDPwK6hjgTtihXwV/lDUeeAFpc7Usu/Hh7/m9spckg6W8oXPn4yH4e2NGAj7Hb4UI91s/y/IOkSHbUiwH69q5oNyAIZl/OeeP21WBKKDBRE2NxzvFN/Q8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C3B88326B2FA944F8122493BC9C42B46@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4bdf528-be47-4914-bf6d-08d6f4dee8e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 17:52:35.2687
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: markb@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4980
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDYvMTkvMTkgMToxMiBBTSwgTGVvbiBSb21hbm92c2t5IHdyb3RlOg0KPiBPbiBXZWQs
IEp1biAxOSwgMjAxOSBhdCAwNzo1ODo1MUFNICswMDAwLCBNYXJrIEJsb2NoIHdyb3RlOg0KPj4N
Cj4+DQo+PiBPbiA2LzE5LzIwMTkgMDA6NDMsIExlb24gUm9tYW5vdnNreSB3cm90ZToNCj4+PiBP
biBXZWQsIEp1biAxOSwgMjAxOSBhdCAwNzoyNjo1NEFNICswMDAwLCBNYXJrIEJsb2NoIHdyb3Rl
Og0KPj4+Pg0KPj4+Pg0KPj4+PiBPbiA2LzE4LzIwMTkgMjM6NTEsIExlb24gUm9tYW5vdnNreSB3
cm90ZToNCj4+Pj4+IE9uIFdlZCwgSnVuIDE5LCAyMDE5IGF0IDA2OjQwOjE2QU0gKzAwMDAsIEpp
YW5ibyBMaXUgd3JvdGU6DQo+Pj4+Pj4gVGhlIDA2LzE5LzIwMTkgMTM6MDQsIExlb24gUm9tYW5v
dnNreSB3cm90ZToNCj4+Pj4+Pj4gT24gV2VkLCBKdW4gMTksIDIwMTkgYXQgMDQ6NDQ6MjZBTSAr
MDAwMCwgSmlhbmJvIExpdSB3cm90ZToNCj4+Pj4+Pj4+IFRoZSAwNi8xOC8yMDE5IDE4OjE5LCBM
ZW9uIFJvbWFub3Zza3kgd3JvdGU6DQo+Pj4+Pj4+Pj4gT24gTW9uLCBKdW4gMTcsIDIwMTkgYXQg
MDc6MjM6MzBQTSArMDAwMCwgU2FlZWQgTWFoYW1lZWQgd3JvdGU6DQo+Pj4+Pj4+Pj4+IEZyb206
IEppYW5ibyBMaXUgPGppYW5ib2xAbWVsbGFub3guY29tPg0KPj4+Pj4+Pj4+Pg0KPj4+Pj4+Pj4+
PiBJZiB2cG9ydCBtZXRhZGF0YSBtYXRjaGluZyBpcyBlbmFibGVkIGluIGVzd2l0Y2gsIHRoZSBy
dWxlIGNyZWF0ZWQNCj4+Pj4+Pj4+Pj4gbXVzdCBiZSBjaGFuZ2VkIHRvIG1hdGNoIG9uIHRoZSBt
ZXRhZGF0YSwgaW5zdGVhZCBvZiBzb3VyY2UgcG9ydC4NCj4+Pj4+Pj4+Pj4NCj4+Pj4+Pj4+Pj4g
U2lnbmVkLW9mZi1ieTogSmlhbmJvIExpdSA8amlhbmJvbEBtZWxsYW5veC5jb20+DQo+Pj4+Pj4+
Pj4+IFJldmlld2VkLWJ5OiBSb2kgRGF5YW4gPHJvaWRAbWVsbGFub3guY29tPg0KPj4+Pj4+Pj4+
PiBSZXZpZXdlZC1ieTogTWFyayBCbG9jaCA8bWFya2JAbWVsbGFub3guY29tPg0KPj4+Pj4+Pj4+
PiBTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCj4+
Pj4+Pj4+Pj4gLS0tDQo+Pj4+Pj4+Pj4+ICBkcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9pYl9y
ZXAuYyB8IDExICsrKysrKysNCj4+Pj4+Pj4+Pj4gIGRyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1
L2liX3JlcC5oIHwgMTYgKysrKysrKysrKw0KPj4+Pj4+Pj4+PiAgZHJpdmVycy9pbmZpbmliYW5k
L2h3L21seDUvbWFpbi5jICAgfCA0NSArKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLQ0KPj4+
Pj4+Pj4+PiAgMyBmaWxlcyBjaGFuZ2VkLCA2MyBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygt
KQ0KPj4+Pj4+Pj4+Pg0KPj4+Pj4+Pj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmliYW5k
L2h3L21seDUvaWJfcmVwLmMgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9pYl9yZXAuYw0K
Pj4+Pj4+Pj4+PiBpbmRleCAyMmU2NTFjYjU1MzQuLmQ0ZWQ2MTFkZTM1ZCAxMDA2NDQNCj4+Pj4+
Pj4+Pj4gLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvaWJfcmVwLmMNCj4+Pj4+Pj4+
Pj4gKysrIGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvaWJfcmVwLmMNCj4+Pj4+Pj4+Pj4g
QEAgLTEzMSw2ICsxMzEsMTcgQEAgc3RydWN0IG1seDVfZXN3aXRjaF9yZXAgKm1seDVfaWJfdnBv
cnRfcmVwKHN0cnVjdCBtbHg1X2Vzd2l0Y2ggKmVzdywgaW50IHZwb3J0KQ0KPj4+Pj4+Pj4+PiAg
CXJldHVybiBtbHg1X2Vzd2l0Y2hfdnBvcnRfcmVwKGVzdywgdnBvcnQpOw0KPj4+Pj4+Pj4+PiAg
fQ0KPj4+Pj4+Pj4+Pg0KPj4+Pj4+Pj4+PiArdTMyIG1seDVfaWJfZXN3aXRjaF92cG9ydF9tYXRj
aF9tZXRhZGF0YV9lbmFibGVkKHN0cnVjdCBtbHg1X2Vzd2l0Y2ggKmVzdykNCj4+Pj4+Pj4+Pj4g
K3sNCj4+Pj4+Pj4+Pj4gKwlyZXR1cm4gbWx4NV9lc3dpdGNoX3Zwb3J0X21hdGNoX21ldGFkYXRh
X2VuYWJsZWQoZXN3KTsNCj4+Pj4+Pj4+Pj4gK30NCj4+Pj4+Pj4+Pj4gKw0KPj4+Pj4+Pj4+PiAr
dTMyIG1seDVfaWJfZXN3aXRjaF9nZXRfdnBvcnRfbWV0YWRhdGFfZm9yX21hdGNoKHN0cnVjdCBt
bHg1X2Vzd2l0Y2ggKmVzdywNCj4+Pj4+Pj4+Pj4gKwkJCQkJCSB1MTYgdnBvcnQpDQo+Pj4+Pj4+
Pj4+ICt7DQo+Pj4+Pj4+Pj4+ICsJcmV0dXJuIG1seDVfZXN3aXRjaF9nZXRfdnBvcnRfbWV0YWRh
dGFfZm9yX21hdGNoKGVzdywgdnBvcnQpOw0KPj4+Pj4+Pj4+PiArfQ0KPj4+Pj4+Pj4+DQo+Pj4+
Pj4+Pj4gMS4gVGhlcmUgaXMgbm8gbmVlZCB0byBpbnRyb2R1Y2Ugb25lIGxpbmUgZnVuY3Rpb25z
LCBjYWxsIHRvIHRoYXQgY29kZSBkaXJlY3RseS4NCj4+Pj4+Pj4+DQo+Pj4+Pj4+PiBOby4gVGhl
eSBhcmUgaW4gSUIsIGFuZCB3ZSBkb24ndCB3YW50IHRoZW0gYmUgbWl4ZWQgdXAgYnkgdGhlIG9y
aWdpbmFsDQo+Pj4+Pj4+PiBmdW5jdGlvbnMgaW4gZXN3aXRjaC4gUGxlYXNlIGFzayBNYXJrIG1v
cmUgYWJvdXQgaXQuDQo+Pj4+Pj4+DQo+Pj4+Pj4+IFBsZWFzZSBlbmxpZ2h0ZW4gbWUuDQo+Pj4+
Pj4NCj4+Pj4+PiBJdCB3YXMgc3VnZ2VzdGVkIGJ5IE1hcmsgaW4gcHJldm91aXMgcmV2aWV3Lg0K
Pj4+Pj4+IEkgdGhpbmsgaXQncyBiZWNhdXNlIHRoZXJlIGFyZSBpbiBkaWZmZXJlbnQgbW9kdWxl
cywgYW5kIGJldHRlciB0byB3aXRoDQo+Pj4+Pj4gZGlmZmVyZW50IG5hbWVzLCBzbyBpbnRyb2R1
Y2UgdGhlcmUgZXh0cmEgb25lIGxpbmUgZnVuY3Rpb25zLg0KPj4+Pj4+IFBsZWFzZSBjb3JyZWN0
IG1lIGlmIEknbSB3cm9uZywgTWFyay4uLg0KPj4+Pj4NCj4+Pj4+IG1seDVfaWIgaXMgZnVsbCBv
ZiBkaXJlY3QgZnVuY3Rpb24gY2FsbHMgdG8gbWx4NV9jb3JlIGFuZCBpdCBpcyBkb25lIG9uDQo+
Pj4+PiBwdXJwb3NlIGZvciBhdCBsZWFzdCB0d28gcmVhc29ucy4gRmlyc3QgaXMgdG8gY29udHJv
bCBpbiBvbmUgcGxhY2UNCj4+Pj4+IGFsbCBjb21waWxhdGlvbiBvcHRpb25zIGFuZCBleHBvc2Ug
cHJvcGVyIEFQSSBpbnRlcmZhY2Ugd2l0aCBhbmQgd2l0aG91dA0KPj4+Pj4gc3BlY2lmaWMga2Vy
bmVsIGNvbmZpZyBpcyBvbi4gU2Vjb25kIGlzIHRvIGVtcGhhc2l6ZSB0aGF0IHRoaXMgaXMgY29y
ZQ0KPj4+Pj4gZnVuY3Rpb24gYW5kIHNhdmUgdXMgdGltZSBpbiByZWZhY3RvcmluZyBhbmQgcmV2
aWV3aW5nLg0KPj4+Pg0KPj4+PiBUaGlzIHdhcyBkb25lIGluIG9yZGVyIHRvIGF2b2lkICNpZmRl
ZiBDT05GSUdfTUxYNV9FU1dJVENILA0KPj4+PiBJIHdhbnQgdG8gaGlkZSAoYXMgbXVjaCBhcyBw
b3NzaWJsZSkgdGhlIGludGVyYWN0aW9ucyB3aXRoIHRoZSBlc3dpdGNoIGxldmVsIGluIGliX3Jl
cC5jL2liX3JlcC5oDQo+Pj4+IHNvIGliX3JlcC5oIHdpbGwgcHJvdmlkZSB0aGUgc3R1YnMgbmVl
ZGVkIGluIGNhc2UgQ09ORklHX01MWDVfRVNXSVRDSCBpc24ndCBkZWZpbmVkLg0KPj4+PiAoVG9k
YXkgaW5jbHVkZS9saW51eC9tbHg1L2Vzd2l0Y2guaCkgZG9lc24ndCBwcm92aWRlIGFueSBzdHVi
cywgbWx4NV9lc3dpdGNoX2dldF9lbmNhcF9tb2RlKCkNCj4+Pj4gc2hvdWxkIGhhdmUgcHJvYmFi
bHkgZG9uZSB0aGUgc2FtZS4NCj4+Pg0KPj4+IFRoaXMgaXMgZXhhY3RseSB0aGUgcHJvYmxlbSwg
ZXN3aXRjaC5oIHNob3VsZCBwcm92aWRlIHN0dWJzIGZvciBhbGwNCj4+PiBleHBvcnRlZCBmdW5j
dGlvbnMsIHNvIG90aGVyIGNsaWVudHMgb2YgZXN3aXRjaCB3b24ndCBuZWVkIHRvIGRlYWwgd2l0
aA0KPj4+IHZhcmlvdXMgdW5yZWxhdGVkIGNvbmZpZyBvcHRpb25zLg0KPj4NCj4+IFRoZSB3YXkg
aXQgd29ya3MgdG9kYXksIGNvZGUgaW4gZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvbWFpbi5j
IGRvZXNuJ3QgY2FsbCBlc3dpdGNoIGxheWVyIGRpcmVjdGx5DQo+PiBidXQgdGhlIGZ1bmN0aW9u
cyBpbiBpYl9yZXAue2MsaH0gYXMgbW9zdCBvZnRlbiB0aGVyZSBpcyBhZGRpdGlvbmFsIGxvZ2lj
IHdlIG11c3QgZG8gYmVmb3JlIGNhbGxpbmcNCj4+IHRoZSBlc3dpdGNoIGxheWVyLg0KPj4NCj4+
IElmIHlvdSBsb29rIGF0IGRyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L01ha2VmaWxlIHlvdSB3
aWxsIHNlZSBpYl9yZXAgaXMgY29tcGxpZWQgb25seSB3aGVuDQo+PiBDT05GSUdfTUxYNV9FU1dJ
VENIIGlkIGRlZmluZWQuDQo+IA0KPiBUaGlzIHNpbXBsZSBwYXRjaCArIGNsZWFudXAgb2YgaWJf
cmVwLmggd2lsbCBkbyB0aGUgdHJpY2suDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZp
bmliYW5kL2h3L21seDUvbWFpbi5jIGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvbWFpbi5j
DQo+IGluZGV4IDY3YjllN2FjNTY5YS4uYjkxN2JhMjg2NTllIDEwMDY0NA0KPiAtLS0gYS9kcml2
ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9tYWluLmMNCj4gKysrIGIvZHJpdmVycy9pbmZpbmliYW5k
L2h3L21seDUvbWFpbi5jDQo+IEBAIC01OSw3ICs1OSw5IEBADQo+ICAjaW5jbHVkZSA8bGludXgv
aW4uaD4NCj4gICNpbmNsdWRlIDxsaW51eC9ldGhlcmRldmljZS5oPg0KPiAgI2luY2x1ZGUgIm1s
eDVfaWIuaCINCj4gKyNpZiBkZWZpbmVkKENPTkZJR19NTFg1X0VTV0lUQ0gpDQo+ICAjaW5jbHVk
ZSAiaWJfcmVwLmgiDQo+ICsjZW5kaWYNCj4gICNpbmNsdWRlICJjbWQuaCINCj4gICNpbmNsdWRl
ICJzcnEuaCINCj4gICNpbmNsdWRlIDxsaW51eC9tbHg1L2ZzX2hlbHBlcnMuaD4NCj4gQEAgLTY3
NjUsNiArNjc2Nyw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbWx4NV9pYl9wcm9maWxlICBwZl9w
cm9maWxlID0gew0KPiAgICAgICAgICAgICAgICAgICAgICAgICBtbHg1X2liX3N0YWdlX2RlbGF5
X2Ryb3BfY2xlYW51cCksDQo+IAkgICAgIH07DQo+IA0KPiArI2lmIGRlZmluZWQoQ09ORklHX01M
WDVfRVNXSVRDSCkNCj4gIGNvbnN0IHN0cnVjdCBtbHg1X2liX3Byb2ZpbGUgdXBsaW5rX3JlcF9w
cm9maWxlID0gew0KPiAJU1RBR0VfQ1JFQVRFKE1MWDVfSUJfU1RBR0VfSU5JVCwNCj4gCQkgICAg
IG1seDVfaWJfc3RhZ2VfaW5pdF9pbml0LA0KPiBAQCAtNjgxMiw2ICs2ODE1LDcgQEANCj4gIGNv
bnN0IHN0cnVjdCBtbHg1X2liX3Byb2ZpbGUgdXBsaW5rX3JlcF9wcm9maWxlID0gew0KPiAJCSAg
ICAgICAgICAgICAgIG1seDVfaWJfc3RhZ2VfcG9zdF9pYl9yZWdfdW1yX2luaXQsDQo+IAkJICAg
ICAgICAgICAgICAgTlVMTCksDQo+IAkJfTsNCj4NCg0KSSByZWFsbHkgZGlzbGlrZSBzZWVpbmcg
I2lmIGRlZmluZWQoQ09ORklHX01MWDVfRVNXSVRDSCkgaW5zaWRlIC5jIGZpbGVzDQphbmQgaGVy
ZSBpdCdzIGVhc2lseSBhdm9pZGVkIHNvIEkgZG9uJ3Qgc2VlIGEgcmVhc29uIGRvIGl0IGl0Lg0K
DQpDYW4gdGhpcyBjbGVhbnVwIHdhaXQgZm9yIGFmdGVyIHRoaXMgc2VyaWVzPw0KDQpNYXJrDQog
DQo+Pg0KPj4gc28gaW5zdGVhZCBvZiBoYXZpbmcgdG8gZGVhbCB3aXRoIHR3byBwbGFjZXMgdGhh
dCBjb250YWluIHN0dWJzLCB3ZSBuZWVkIHRvIGRlYWwgd2l0aCBvbmx5IG9uZSAoaWJfcmVwLmgp
Lg0KPj4gRm9yIG1lIGl0IG1ha2VzIGl0IGVhc2llciB0byBmb2xsb3csIGJ1dCBJIGNhbiBhZGVw
dCBpZiB5b3UgZG9uJ3QgbGlrZSBpdC4NCj4+DQo+PiBNYXJrDQo+Pg0KPj4+DQo+Pj4+DQo+Pj4+
IEFzIG15IGxvbmcgdGVybSBnb2FsIGlzIHRvIGJyZWFrIGRyaXZlcnMvaW5maW5pYmFuZC9ody9t
bHg1L21haW4uYyAodGhhdCBmaWxlIGlzIGFscmVhZHkgNzAwMCBMT0MpDQo+Pj4+IEkgd2FudCB0
byBncm91cCB0b2dldGhlciBzdHVmZiBpbiBzZXBhcmF0ZSBmaWxlcy4NCj4+Pg0KPj4+IFllcywg
aXQgaXMgcmlnaHQgdGhpbmcgdG8gZG8uDQo+Pj4NCj4+Pj4NCj4+Pj4gSWYgeW91IHByZWZlciBk
aXJlY3QgY2FsbHMgdGhhdCdzIG9rYXkgYXMgd2VsbC4NCj4+Pg0KPj4+IFllcywgcGxlYXNlLg0K
Pj4+DQo+Pj4+DQo+Pj4+IE1hcmsNCj4+Pj4NCj4+Pj4+DQo+Pj4+Pj4NCj4+Pj4+Pj4NCj4+Pj4+
Pj4+DQo+Pj4+Pj4+Pj4gMi4gSXQgc2hvdWxkIGJlIGJvb2wgYW5kIG5vdCB1MzIuDQo+Pj4+Pj4+
Pj4NCj4+Pj4+Pj4+PiBUaGFua3MNCj4+Pj4+Pj4+DQo+Pj4+Pj4+PiAtLQ0KPj4+Pj4+DQo+Pj4+
Pj4gLS0NCg==
