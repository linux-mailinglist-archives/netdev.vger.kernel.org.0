Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD7C64B307
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 09:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730756AbfFSH1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 03:27:01 -0400
Received: from mail-eopbgr50070.outbound.protection.outlook.com ([40.107.5.70]:23272
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725854AbfFSH1A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 03:27:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOWJ2k3S9PtFg5rFQBenjWH8B8Ov5BTXQcEIwEDY84U=;
 b=St8n3R6TRsGzjaMPb5N124eIlh6+IvIY1w7S/NSAF/eGEM78CC4mRJWiOxDgyxW9RqtWE5bt1KbZW6jSNaw8B1mdlgpZFmTXhq6kTV7YpzsY7f76qvLcEi0XvOlTw+R4D9ghzsmV7INBm/ns3oBzaY0wuxuWmbje2igMku56s10=
Received: from AM0PR05MB4403.eurprd05.prod.outlook.com (52.134.125.139) by
 AM0PR05MB6516.eurprd05.prod.outlook.com (20.179.35.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Wed, 19 Jun 2019 07:26:54 +0000
Received: from AM0PR05MB4403.eurprd05.prod.outlook.com
 ([fe80::edf6:f68:cb6c:777f]) by AM0PR05MB4403.eurprd05.prod.outlook.com
 ([fe80::edf6:f68:cb6c:777f%7]) with mapi id 15.20.1987.014; Wed, 19 Jun 2019
 07:26:54 +0000
From:   Mark Bloch <markb@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH mlx5-next 11/15] RDMA/mlx5: Add vport metadata matching
 for IB representors
Thread-Topic: [PATCH mlx5-next 11/15] RDMA/mlx5: Add vport metadata matching
 for IB representors
Thread-Index: AQHVJUImPYK8Rls4yUKWAAzrbtRMrqahNB6AgAE0tgCAAAWJgIAAGtQAgAADIQCAAAk4AA==
Date:   Wed, 19 Jun 2019 07:26:54 +0000
Message-ID: <4e01d326-db6c-f746-acd6-06f65f311f5b@mellanox.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
 <20190617192247.25107-12-saeedm@mellanox.com>
 <20190618101928.GE4690@mtr-leonro.mtl.com>
 <20190619044420.GA30694@mellanox.com>
 <20190619050412.GC11611@mtr-leonro.mtl.com>
 <20190619063941.GA5176@mellanox.com>
 <20190619065125.GF11611@mtr-leonro.mtl.com>
In-Reply-To: <20190619065125.GF11611@mtr-leonro.mtl.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR11CA0067.namprd11.prod.outlook.com
 (2603:10b6:a03:80::44) To AM0PR05MB4403.eurprd05.prod.outlook.com
 (2603:10a6:208:65::11)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=markb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [104.156.100.52]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6378b85f-db75-43fb-e030-08d6f4878111
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6516;
x-ms-traffictypediagnostic: AM0PR05MB6516:
x-microsoft-antispam-prvs: <AM0PR05MB65168B6AE6CF07B557CED219D2E50@AM0PR05MB6516.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(396003)(366004)(346002)(39860400002)(199004)(189003)(71190400001)(53936002)(64756008)(450100002)(66446008)(86362001)(26005)(11346002)(316002)(2906002)(486006)(14454004)(102836004)(99286004)(66946007)(386003)(53546011)(31696002)(2616005)(6246003)(68736007)(8936002)(446003)(476003)(6506007)(52116002)(66066001)(36756003)(73956011)(8676002)(66476007)(5660300002)(31686004)(7736002)(6636002)(6436002)(25786009)(186003)(66556008)(81166006)(6486002)(76176011)(81156014)(107886003)(71200400001)(6512007)(4326008)(6116002)(3846002)(478600001)(229853002)(110136005)(54906003)(14444005)(256004)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6516;H:AM0PR05MB4403.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2Le1bghO9B/VDCr4DiFlKJX3yXssyqHKb+DtKQ75/r1101O6sRVRqFaJPUncp4866cyMn7PWDbQ2dgH3bQ9Zme//GJeVK4C2zu2ozWg4+1kwa2SF6gSVLlSiaEf0IAYbBtsu5gh0lJymXyYvmt6jsCwZKLn5tKIIv8R5OVkOjCxMMctDBGOdo7fcfcSj/hRJeEkK+2zoDBOoa1LLUPSkgZHg7m04xOWVVeYMT0zTheGdovtgRZO+cxseXHj+SCr5n2V3byd54R96bh5URlfUs+HWmdr0APbp4V2BPNTcbbSwJqK2y61AkR9cKC+abROHVkucBFknrorUuf8HyTk5+3g5Yxjdv8e3aDK1c6S8SrEvJ+TuK1+1decFFnz+o9qda/IaLv6rgmNrJ5diGBRaOXsa1xwnmvxxoltIQdjLjws=
Content-Type: text/plain; charset="utf-8"
Content-ID: <28E3ED0E5AB7434A903E60D1F930C815@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6378b85f-db75-43fb-e030-08d6f4878111
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 07:26:54.5866
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: markb@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6516
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDYvMTgvMjAxOSAyMzo1MSwgTGVvbiBSb21hbm92c2t5IHdyb3RlOg0KPiBPbiBXZWQs
IEp1biAxOSwgMjAxOSBhdCAwNjo0MDoxNkFNICswMDAwLCBKaWFuYm8gTGl1IHdyb3RlOg0KPj4g
VGhlIDA2LzE5LzIwMTkgMTM6MDQsIExlb24gUm9tYW5vdnNreSB3cm90ZToNCj4+PiBPbiBXZWQs
IEp1biAxOSwgMjAxOSBhdCAwNDo0NDoyNkFNICswMDAwLCBKaWFuYm8gTGl1IHdyb3RlOg0KPj4+
PiBUaGUgMDYvMTgvMjAxOSAxODoxOSwgTGVvbiBSb21hbm92c2t5IHdyb3RlOg0KPj4+Pj4gT24g
TW9uLCBKdW4gMTcsIDIwMTkgYXQgMDc6MjM6MzBQTSArMDAwMCwgU2FlZWQgTWFoYW1lZWQgd3Jv
dGU6DQo+Pj4+Pj4gRnJvbTogSmlhbmJvIExpdSA8amlhbmJvbEBtZWxsYW5veC5jb20+DQo+Pj4+
Pj4NCj4+Pj4+PiBJZiB2cG9ydCBtZXRhZGF0YSBtYXRjaGluZyBpcyBlbmFibGVkIGluIGVzd2l0
Y2gsIHRoZSBydWxlIGNyZWF0ZWQNCj4+Pj4+PiBtdXN0IGJlIGNoYW5nZWQgdG8gbWF0Y2ggb24g
dGhlIG1ldGFkYXRhLCBpbnN0ZWFkIG9mIHNvdXJjZSBwb3J0Lg0KPj4+Pj4+DQo+Pj4+Pj4gU2ln
bmVkLW9mZi1ieTogSmlhbmJvIExpdSA8amlhbmJvbEBtZWxsYW5veC5jb20+DQo+Pj4+Pj4gUmV2
aWV3ZWQtYnk6IFJvaSBEYXlhbiA8cm9pZEBtZWxsYW5veC5jb20+DQo+Pj4+Pj4gUmV2aWV3ZWQt
Ynk6IE1hcmsgQmxvY2ggPG1hcmtiQG1lbGxhbm94LmNvbT4NCj4+Pj4+PiBTaWduZWQtb2ZmLWJ5
OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCj4+Pj4+PiAtLS0NCj4+Pj4+
PiAgZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvaWJfcmVwLmMgfCAxMSArKysrKysrDQo+Pj4+
Pj4gIGRyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L2liX3JlcC5oIHwgMTYgKysrKysrKysrKw0K
Pj4+Pj4+ICBkcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9tYWluLmMgICB8IDQ1ICsrKysrKysr
KysrKysrKysrKysrKysrLS0tLS0tDQo+Pj4+Pj4gIDMgZmlsZXMgY2hhbmdlZCwgNjMgaW5zZXJ0
aW9ucygrKSwgOSBkZWxldGlvbnMoLSkNCj4+Pj4+Pg0KPj4+Pj4+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9pYl9yZXAuYyBiL2RyaXZlcnMvaW5maW5pYmFuZC9ody9t
bHg1L2liX3JlcC5jDQo+Pj4+Pj4gaW5kZXggMjJlNjUxY2I1NTM0Li5kNGVkNjExZGUzNWQgMTAw
NjQ0DQo+Pj4+Pj4gLS0tIGEvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvaWJfcmVwLmMNCj4+
Pj4+PiArKysgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9pYl9yZXAuYw0KPj4+Pj4+IEBA
IC0xMzEsNiArMTMxLDE3IEBAIHN0cnVjdCBtbHg1X2Vzd2l0Y2hfcmVwICptbHg1X2liX3Zwb3J0
X3JlcChzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3csIGludCB2cG9ydCkNCj4+Pj4+PiAgCXJldHVy
biBtbHg1X2Vzd2l0Y2hfdnBvcnRfcmVwKGVzdywgdnBvcnQpOw0KPj4+Pj4+ICB9DQo+Pj4+Pj4N
Cj4+Pj4+PiArdTMyIG1seDVfaWJfZXN3aXRjaF92cG9ydF9tYXRjaF9tZXRhZGF0YV9lbmFibGVk
KHN0cnVjdCBtbHg1X2Vzd2l0Y2ggKmVzdykNCj4+Pj4+PiArew0KPj4+Pj4+ICsJcmV0dXJuIG1s
eDVfZXN3aXRjaF92cG9ydF9tYXRjaF9tZXRhZGF0YV9lbmFibGVkKGVzdyk7DQo+Pj4+Pj4gK30N
Cj4+Pj4+PiArDQo+Pj4+Pj4gK3UzMiBtbHg1X2liX2Vzd2l0Y2hfZ2V0X3Zwb3J0X21ldGFkYXRh
X2Zvcl9tYXRjaChzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3csDQo+Pj4+Pj4gKwkJCQkJCSB1MTYg
dnBvcnQpDQo+Pj4+Pj4gK3sNCj4+Pj4+PiArCXJldHVybiBtbHg1X2Vzd2l0Y2hfZ2V0X3Zwb3J0
X21ldGFkYXRhX2Zvcl9tYXRjaChlc3csIHZwb3J0KTsNCj4+Pj4+PiArfQ0KPj4+Pj4NCj4+Pj4+
IDEuIFRoZXJlIGlzIG5vIG5lZWQgdG8gaW50cm9kdWNlIG9uZSBsaW5lIGZ1bmN0aW9ucywgY2Fs
bCB0byB0aGF0IGNvZGUgZGlyZWN0bHkuDQo+Pj4+DQo+Pj4+IE5vLiBUaGV5IGFyZSBpbiBJQiwg
YW5kIHdlIGRvbid0IHdhbnQgdGhlbSBiZSBtaXhlZCB1cCBieSB0aGUgb3JpZ2luYWwNCj4+Pj4g
ZnVuY3Rpb25zIGluIGVzd2l0Y2guIFBsZWFzZSBhc2sgTWFyayBtb3JlIGFib3V0IGl0Lg0KPj4+
DQo+Pj4gUGxlYXNlIGVubGlnaHRlbiBtZS4NCj4+DQo+PiBJdCB3YXMgc3VnZ2VzdGVkIGJ5IE1h
cmsgaW4gcHJldm91aXMgcmV2aWV3Lg0KPj4gSSB0aGluayBpdCdzIGJlY2F1c2UgdGhlcmUgYXJl
IGluIGRpZmZlcmVudCBtb2R1bGVzLCBhbmQgYmV0dGVyIHRvIHdpdGgNCj4+IGRpZmZlcmVudCBu
YW1lcywgc28gaW50cm9kdWNlIHRoZXJlIGV4dHJhIG9uZSBsaW5lIGZ1bmN0aW9ucy4NCj4+IFBs
ZWFzZSBjb3JyZWN0IG1lIGlmIEknbSB3cm9uZywgTWFyay4uLg0KPiANCj4gbWx4NV9pYiBpcyBm
dWxsIG9mIGRpcmVjdCBmdW5jdGlvbiBjYWxscyB0byBtbHg1X2NvcmUgYW5kIGl0IGlzIGRvbmUg
b24NCj4gcHVycG9zZSBmb3IgYXQgbGVhc3QgdHdvIHJlYXNvbnMuIEZpcnN0IGlzIHRvIGNvbnRy
b2wgaW4gb25lIHBsYWNlDQo+IGFsbCBjb21waWxhdGlvbiBvcHRpb25zIGFuZCBleHBvc2UgcHJv
cGVyIEFQSSBpbnRlcmZhY2Ugd2l0aCBhbmQgd2l0aG91dA0KPiBzcGVjaWZpYyBrZXJuZWwgY29u
ZmlnIGlzIG9uLiBTZWNvbmQgaXMgdG8gZW1waGFzaXplIHRoYXQgdGhpcyBpcyBjb3JlDQo+IGZ1
bmN0aW9uIGFuZCBzYXZlIHVzIHRpbWUgaW4gcmVmYWN0b3JpbmcgYW5kIHJldmlld2luZy4NCg0K
VGhpcyB3YXMgZG9uZSBpbiBvcmRlciB0byBhdm9pZCAjaWZkZWYgQ09ORklHX01MWDVfRVNXSVRD
SCwNCkkgd2FudCB0byBoaWRlIChhcyBtdWNoIGFzIHBvc3NpYmxlKSB0aGUgaW50ZXJhY3Rpb25z
IHdpdGggdGhlIGVzd2l0Y2ggbGV2ZWwgaW4gaWJfcmVwLmMvaWJfcmVwLmgNCnNvIGliX3JlcC5o
IHdpbGwgcHJvdmlkZSB0aGUgc3R1YnMgbmVlZGVkIGluIGNhc2UgQ09ORklHX01MWDVfRVNXSVRD
SCBpc24ndCBkZWZpbmVkLg0KKFRvZGF5IGluY2x1ZGUvbGludXgvbWx4NS9lc3dpdGNoLmgpIGRv
ZXNuJ3QgcHJvdmlkZSBhbnkgc3R1YnMsIG1seDVfZXN3aXRjaF9nZXRfZW5jYXBfbW9kZSgpDQpz
aG91bGQgaGF2ZSBwcm9iYWJseSBkb25lIHRoZSBzYW1lLg0KDQpBcyBteSBsb25nIHRlcm0gZ29h
bCBpcyB0byBicmVhayBkcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9tYWluLmMgKHRoYXQgZmls
ZSBpcyBhbHJlYWR5IDcwMDAgTE9DKQ0KSSB3YW50IHRvIGdyb3VwIHRvZ2V0aGVyIHN0dWZmIGlu
IHNlcGFyYXRlIGZpbGVzLg0KDQpJZiB5b3UgcHJlZmVyIGRpcmVjdCBjYWxscyB0aGF0J3Mgb2th
eSBhcyB3ZWxsLg0KDQpNYXJrDQoNCj4gDQo+Pg0KPj4+DQo+Pj4+DQo+Pj4+PiAyLiBJdCBzaG91
bGQgYmUgYm9vbCBhbmQgbm90IHUzMi4NCj4+Pj4+DQo+Pj4+PiBUaGFua3MNCj4+Pj4NCj4+Pj4g
LS0NCj4+DQo+PiAtLQ0K
