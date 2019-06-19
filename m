Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95BAA4B37F
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 09:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731262AbfFSH67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 03:58:59 -0400
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:37437
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731248AbfFSH67 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 03:58:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VJ8fDmOaRBnwb46PFs/tcpPIuTNcFbP3ySIgieeOYxs=;
 b=IF7FNh7dyFk2/WtEc1n/xNvFAfBlN6R7fhg+cFDUpM46c1OkqTzV/mD8Rbgpr0lAYlnaO9TJjEQH+uA4y1ZtM5cyQ5TipBm+yt68TlftOLcQCDgDy8vVPevvOFOhCiwQSHIjiSLozuKLO98Np5mv1nanj/KntPKRC6zpkFEh2a4=
Received: from AM0PR05MB4403.eurprd05.prod.outlook.com (52.134.125.139) by
 AM0PR05MB5873.eurprd05.prod.outlook.com (20.178.117.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Wed, 19 Jun 2019 07:58:51 +0000
Received: from AM0PR05MB4403.eurprd05.prod.outlook.com
 ([fe80::edf6:f68:cb6c:777f]) by AM0PR05MB4403.eurprd05.prod.outlook.com
 ([fe80::edf6:f68:cb6c:777f%7]) with mapi id 15.20.1987.014; Wed, 19 Jun 2019
 07:58:51 +0000
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
Thread-Index: AQHVJUImPYK8Rls4yUKWAAzrbtRMrqahNB6AgAE0tgCAAAWJgIAAGtQAgAADIQCAAAk4AIAABV+AgAADjoA=
Date:   Wed, 19 Jun 2019 07:58:51 +0000
Message-ID: <ac23c3ea-3ea7-2a5b-5fc6-aece0aed0b54@mellanox.com>
References: <20190617192247.25107-1-saeedm@mellanox.com>
 <20190617192247.25107-12-saeedm@mellanox.com>
 <20190618101928.GE4690@mtr-leonro.mtl.com>
 <20190619044420.GA30694@mellanox.com>
 <20190619050412.GC11611@mtr-leonro.mtl.com>
 <20190619063941.GA5176@mellanox.com>
 <20190619065125.GF11611@mtr-leonro.mtl.com>
 <4e01d326-db6c-f746-acd6-06f65f311f5b@mellanox.com>
 <20190619074338.GG11611@mtr-leonro.mtl.com>
In-Reply-To: <20190619074338.GG11611@mtr-leonro.mtl.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0089.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::30) To AM0PR05MB4403.eurprd05.prod.outlook.com
 (2603:10a6:208:65::11)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=markb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [104.156.100.52]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37e14854-db97-4bed-4eff-08d6f48bf7c1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB5873;
x-ms-traffictypediagnostic: AM0PR05MB5873:
x-microsoft-antispam-prvs: <AM0PR05MB5873D265C5D2F480927278A2D2E50@AM0PR05MB5873.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(376002)(136003)(346002)(39860400002)(189003)(199004)(6862004)(68736007)(102836004)(186003)(26005)(66476007)(305945005)(2906002)(6116002)(76176011)(486006)(3846002)(256004)(86362001)(6512007)(14444005)(71200400001)(6636002)(6506007)(53546011)(386003)(14454004)(99286004)(66066001)(71190400001)(64756008)(66446008)(73956011)(54906003)(81156014)(53936002)(2616005)(11346002)(6246003)(31696002)(52116002)(36756003)(229853002)(8676002)(6486002)(6436002)(37006003)(478600001)(5660300002)(4326008)(25786009)(7736002)(476003)(450100002)(31686004)(81166006)(66556008)(8936002)(316002)(107886003)(66946007)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5873;H:AM0PR05MB4403.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5eNfNFfc0WVLiSETvvLFrUM5DBz6MjtUJ7Tcy7ou8ixaVtX2vbosCK3dirbL0rrl9nlS7jp/3KVba9jugCuSKDGl3ZItwxaBCo/C78eIlIA+aS86ZLJoc0u/SuDa+XwK68p5M875LfEctOkJ27rOkPOz0rf6OWMUnDW/Fm5kEYHWdlQBFrsoCl9cxMhLxDVWDCUKbtBYK1I1Zae1DGBYVT/FWqR4aPa0aoHlTgUnlyIrdg5JoJ0aPB/zxb8KMPyGtTYL4DLINMeiF3zFnlK48kkk4TWAn8GXWrJTOsRBF7VQ/um8bQCszo9tUMV+oRux2xRLuCe41nt7ZKMli/5wSijwTnnN4dv+e+YhjiYsGeDM0wn6z2Q6t8ZnYL+a1G6czeHnXUltZjDre9QfiAE78pZd/u9iVWo4rlX3wK6Q4TE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC50D6893262F44DB0A15F7AF061F0F8@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37e14854-db97-4bed-4eff-08d6f48bf7c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 07:58:51.7084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: markb@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5873
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDYvMTkvMjAxOSAwMDo0MywgTGVvbiBSb21hbm92c2t5IHdyb3RlOg0KPiBPbiBXZWQs
IEp1biAxOSwgMjAxOSBhdCAwNzoyNjo1NEFNICswMDAwLCBNYXJrIEJsb2NoIHdyb3RlOg0KPj4N
Cj4+DQo+PiBPbiA2LzE4LzIwMTkgMjM6NTEsIExlb24gUm9tYW5vdnNreSB3cm90ZToNCj4+PiBP
biBXZWQsIEp1biAxOSwgMjAxOSBhdCAwNjo0MDoxNkFNICswMDAwLCBKaWFuYm8gTGl1IHdyb3Rl
Og0KPj4+PiBUaGUgMDYvMTkvMjAxOSAxMzowNCwgTGVvbiBSb21hbm92c2t5IHdyb3RlOg0KPj4+
Pj4gT24gV2VkLCBKdW4gMTksIDIwMTkgYXQgMDQ6NDQ6MjZBTSArMDAwMCwgSmlhbmJvIExpdSB3
cm90ZToNCj4+Pj4+PiBUaGUgMDYvMTgvMjAxOSAxODoxOSwgTGVvbiBSb21hbm92c2t5IHdyb3Rl
Og0KPj4+Pj4+PiBPbiBNb24sIEp1biAxNywgMjAxOSBhdCAwNzoyMzozMFBNICswMDAwLCBTYWVl
ZCBNYWhhbWVlZCB3cm90ZToNCj4+Pj4+Pj4+IEZyb206IEppYW5ibyBMaXUgPGppYW5ib2xAbWVs
bGFub3guY29tPg0KPj4+Pj4+Pj4NCj4+Pj4+Pj4+IElmIHZwb3J0IG1ldGFkYXRhIG1hdGNoaW5n
IGlzIGVuYWJsZWQgaW4gZXN3aXRjaCwgdGhlIHJ1bGUgY3JlYXRlZA0KPj4+Pj4+Pj4gbXVzdCBi
ZSBjaGFuZ2VkIHRvIG1hdGNoIG9uIHRoZSBtZXRhZGF0YSwgaW5zdGVhZCBvZiBzb3VyY2UgcG9y
dC4NCj4+Pj4+Pj4+DQo+Pj4+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBKaWFuYm8gTGl1IDxqaWFuYm9s
QG1lbGxhbm94LmNvbT4NCj4+Pj4+Pj4+IFJldmlld2VkLWJ5OiBSb2kgRGF5YW4gPHJvaWRAbWVs
bGFub3guY29tPg0KPj4+Pj4+Pj4gUmV2aWV3ZWQtYnk6IE1hcmsgQmxvY2ggPG1hcmtiQG1lbGxh
bm94LmNvbT4NCj4+Pj4+Pj4+IFNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1A
bWVsbGFub3guY29tPg0KPj4+Pj4+Pj4gLS0tDQo+Pj4+Pj4+PiAgZHJpdmVycy9pbmZpbmliYW5k
L2h3L21seDUvaWJfcmVwLmMgfCAxMSArKysrKysrDQo+Pj4+Pj4+PiAgZHJpdmVycy9pbmZpbmli
YW5kL2h3L21seDUvaWJfcmVwLmggfCAxNiArKysrKysrKysrDQo+Pj4+Pj4+PiAgZHJpdmVycy9p
bmZpbmliYW5kL2h3L21seDUvbWFpbi5jICAgfCA0NSArKysrKysrKysrKysrKysrKysrKysrKy0t
LS0tLQ0KPj4+Pj4+Pj4gIDMgZmlsZXMgY2hhbmdlZCwgNjMgaW5zZXJ0aW9ucygrKSwgOSBkZWxl
dGlvbnMoLSkNCj4+Pj4+Pj4+DQo+Pj4+Pj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pbmZpbmli
YW5kL2h3L21seDUvaWJfcmVwLmMgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9pYl9yZXAu
Yw0KPj4+Pj4+Pj4gaW5kZXggMjJlNjUxY2I1NTM0Li5kNGVkNjExZGUzNWQgMTAwNjQ0DQo+Pj4+
Pj4+PiAtLS0gYS9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9pYl9yZXAuYw0KPj4+Pj4+Pj4g
KysrIGIvZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvaWJfcmVwLmMNCj4+Pj4+Pj4+IEBAIC0x
MzEsNiArMTMxLDE3IEBAIHN0cnVjdCBtbHg1X2Vzd2l0Y2hfcmVwICptbHg1X2liX3Zwb3J0X3Jl
cChzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3csIGludCB2cG9ydCkNCj4+Pj4+Pj4+ICAJcmV0dXJu
IG1seDVfZXN3aXRjaF92cG9ydF9yZXAoZXN3LCB2cG9ydCk7DQo+Pj4+Pj4+PiAgfQ0KPj4+Pj4+
Pj4NCj4+Pj4+Pj4+ICt1MzIgbWx4NV9pYl9lc3dpdGNoX3Zwb3J0X21hdGNoX21ldGFkYXRhX2Vu
YWJsZWQoc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3KQ0KPj4+Pj4+Pj4gK3sNCj4+Pj4+Pj4+ICsJ
cmV0dXJuIG1seDVfZXN3aXRjaF92cG9ydF9tYXRjaF9tZXRhZGF0YV9lbmFibGVkKGVzdyk7DQo+
Pj4+Pj4+PiArfQ0KPj4+Pj4+Pj4gKw0KPj4+Pj4+Pj4gK3UzMiBtbHg1X2liX2Vzd2l0Y2hfZ2V0
X3Zwb3J0X21ldGFkYXRhX2Zvcl9tYXRjaChzdHJ1Y3QgbWx4NV9lc3dpdGNoICplc3csDQo+Pj4+
Pj4+PiArCQkJCQkJIHUxNiB2cG9ydCkNCj4+Pj4+Pj4+ICt7DQo+Pj4+Pj4+PiArCXJldHVybiBt
bHg1X2Vzd2l0Y2hfZ2V0X3Zwb3J0X21ldGFkYXRhX2Zvcl9tYXRjaChlc3csIHZwb3J0KTsNCj4+
Pj4+Pj4+ICt9DQo+Pj4+Pj4+DQo+Pj4+Pj4+IDEuIFRoZXJlIGlzIG5vIG5lZWQgdG8gaW50cm9k
dWNlIG9uZSBsaW5lIGZ1bmN0aW9ucywgY2FsbCB0byB0aGF0IGNvZGUgZGlyZWN0bHkuDQo+Pj4+
Pj4NCj4+Pj4+PiBOby4gVGhleSBhcmUgaW4gSUIsIGFuZCB3ZSBkb24ndCB3YW50IHRoZW0gYmUg
bWl4ZWQgdXAgYnkgdGhlIG9yaWdpbmFsDQo+Pj4+Pj4gZnVuY3Rpb25zIGluIGVzd2l0Y2guIFBs
ZWFzZSBhc2sgTWFyayBtb3JlIGFib3V0IGl0Lg0KPj4+Pj4NCj4+Pj4+IFBsZWFzZSBlbmxpZ2h0
ZW4gbWUuDQo+Pj4+DQo+Pj4+IEl0IHdhcyBzdWdnZXN0ZWQgYnkgTWFyayBpbiBwcmV2b3VpcyBy
ZXZpZXcuDQo+Pj4+IEkgdGhpbmsgaXQncyBiZWNhdXNlIHRoZXJlIGFyZSBpbiBkaWZmZXJlbnQg
bW9kdWxlcywgYW5kIGJldHRlciB0byB3aXRoDQo+Pj4+IGRpZmZlcmVudCBuYW1lcywgc28gaW50
cm9kdWNlIHRoZXJlIGV4dHJhIG9uZSBsaW5lIGZ1bmN0aW9ucy4NCj4+Pj4gUGxlYXNlIGNvcnJl
Y3QgbWUgaWYgSSdtIHdyb25nLCBNYXJrLi4uDQo+Pj4NCj4+PiBtbHg1X2liIGlzIGZ1bGwgb2Yg
ZGlyZWN0IGZ1bmN0aW9uIGNhbGxzIHRvIG1seDVfY29yZSBhbmQgaXQgaXMgZG9uZSBvbg0KPj4+
IHB1cnBvc2UgZm9yIGF0IGxlYXN0IHR3byByZWFzb25zLiBGaXJzdCBpcyB0byBjb250cm9sIGlu
IG9uZSBwbGFjZQ0KPj4+IGFsbCBjb21waWxhdGlvbiBvcHRpb25zIGFuZCBleHBvc2UgcHJvcGVy
IEFQSSBpbnRlcmZhY2Ugd2l0aCBhbmQgd2l0aG91dA0KPj4+IHNwZWNpZmljIGtlcm5lbCBjb25m
aWcgaXMgb24uIFNlY29uZCBpcyB0byBlbXBoYXNpemUgdGhhdCB0aGlzIGlzIGNvcmUNCj4+PiBm
dW5jdGlvbiBhbmQgc2F2ZSB1cyB0aW1lIGluIHJlZmFjdG9yaW5nIGFuZCByZXZpZXdpbmcuDQo+
Pg0KPj4gVGhpcyB3YXMgZG9uZSBpbiBvcmRlciB0byBhdm9pZCAjaWZkZWYgQ09ORklHX01MWDVf
RVNXSVRDSCwNCj4+IEkgd2FudCB0byBoaWRlIChhcyBtdWNoIGFzIHBvc3NpYmxlKSB0aGUgaW50
ZXJhY3Rpb25zIHdpdGggdGhlIGVzd2l0Y2ggbGV2ZWwgaW4gaWJfcmVwLmMvaWJfcmVwLmgNCj4+
IHNvIGliX3JlcC5oIHdpbGwgcHJvdmlkZSB0aGUgc3R1YnMgbmVlZGVkIGluIGNhc2UgQ09ORklH
X01MWDVfRVNXSVRDSCBpc24ndCBkZWZpbmVkLg0KPj4gKFRvZGF5IGluY2x1ZGUvbGludXgvbWx4
NS9lc3dpdGNoLmgpIGRvZXNuJ3QgcHJvdmlkZSBhbnkgc3R1YnMsIG1seDVfZXN3aXRjaF9nZXRf
ZW5jYXBfbW9kZSgpDQo+PiBzaG91bGQgaGF2ZSBwcm9iYWJseSBkb25lIHRoZSBzYW1lLg0KPiAN
Cj4gVGhpcyBpcyBleGFjdGx5IHRoZSBwcm9ibGVtLCBlc3dpdGNoLmggc2hvdWxkIHByb3ZpZGUg
c3R1YnMgZm9yIGFsbA0KPiBleHBvcnRlZCBmdW5jdGlvbnMsIHNvIG90aGVyIGNsaWVudHMgb2Yg
ZXN3aXRjaCB3b24ndCBuZWVkIHRvIGRlYWwgd2l0aA0KPiB2YXJpb3VzIHVucmVsYXRlZCBjb25m
aWcgb3B0aW9ucy4NCg0KVGhlIHdheSBpdCB3b3JrcyB0b2RheSwgY29kZSBpbiBkcml2ZXJzL2lu
ZmluaWJhbmQvaHcvbWx4NS9tYWluLmMgZG9lc24ndCBjYWxsIGVzd2l0Y2ggbGF5ZXIgZGlyZWN0
bHkNCmJ1dCB0aGUgZnVuY3Rpb25zIGluIGliX3JlcC57YyxofSBhcyBtb3N0IG9mdGVuIHRoZXJl
IGlzIGFkZGl0aW9uYWwgbG9naWMgd2UgbXVzdCBkbyBiZWZvcmUgY2FsbGluZw0KdGhlIGVzd2l0
Y2ggbGF5ZXIuDQoNCklmIHlvdSBsb29rIGF0IGRyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L01h
a2VmaWxlIHlvdSB3aWxsIHNlZSBpYl9yZXAgaXMgY29tcGxpZWQgb25seSB3aGVuDQpDT05GSUdf
TUxYNV9FU1dJVENIIGlkIGRlZmluZWQuDQoNCnNvIGluc3RlYWQgb2YgaGF2aW5nIHRvIGRlYWwg
d2l0aCB0d28gcGxhY2VzIHRoYXQgY29udGFpbiBzdHVicywgd2UgbmVlZCB0byBkZWFsIHdpdGgg
b25seSBvbmUgKGliX3JlcC5oKS4NCkZvciBtZSBpdCBtYWtlcyBpdCBlYXNpZXIgdG8gZm9sbG93
LCBidXQgSSBjYW4gYWRlcHQgaWYgeW91IGRvbid0IGxpa2UgaXQuDQoNCk1hcmsNCg0KPiANCj4+
DQo+PiBBcyBteSBsb25nIHRlcm0gZ29hbCBpcyB0byBicmVhayBkcml2ZXJzL2luZmluaWJhbmQv
aHcvbWx4NS9tYWluLmMgKHRoYXQgZmlsZSBpcyBhbHJlYWR5IDcwMDAgTE9DKQ0KPj4gSSB3YW50
IHRvIGdyb3VwIHRvZ2V0aGVyIHN0dWZmIGluIHNlcGFyYXRlIGZpbGVzLg0KPiANCj4gWWVzLCBp
dCBpcyByaWdodCB0aGluZyB0byBkby4NCj4gDQo+Pg0KPj4gSWYgeW91IHByZWZlciBkaXJlY3Qg
Y2FsbHMgdGhhdCdzIG9rYXkgYXMgd2VsbC4NCj4gDQo+IFllcywgcGxlYXNlLg0KPiANCj4+DQo+
PiBNYXJrDQo+Pg0KPj4+DQo+Pj4+DQo+Pj4+Pg0KPj4+Pj4+DQo+Pj4+Pj4+IDIuIEl0IHNob3Vs
ZCBiZSBib29sIGFuZCBub3QgdTMyLg0KPj4+Pj4+Pg0KPj4+Pj4+PiBUaGFua3MNCj4+Pj4+Pg0K
Pj4+Pj4+IC0tDQo+Pj4+DQo+Pj4+IC0tDQo=
