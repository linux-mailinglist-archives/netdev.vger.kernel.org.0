Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 069CE45E13
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 15:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbfFNNZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 09:25:30 -0400
Received: from mail-eopbgr50070.outbound.protection.outlook.com ([40.107.5.70]:9278
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727612AbfFNNZ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 09:25:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uRZRu8czy+Uo8ZMsam3jlseX45EI7XE2M9xTX4mAmaE=;
 b=ZkiFWOR2FIqod8j9ujwDk/MNblFNDU6xE/bLnd3Ei6aTtLC+nrEkiArWPBHqZn5xC3aUE9MFcA8R25CtfVG5Qu3JorbwUwZBcnQnVSdD5iBHKpq0GbRJct4rA1hrnZLmr3S10wBuS/h5YxSuI5v6eCbIPublgXe1d0PmLWNBx1o=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB4359.eurprd05.prod.outlook.com (52.135.162.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Fri, 14 Jun 2019 13:25:24 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.010; Fri, 14 Jun 2019
 13:25:24 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v4 07/17] libbpf: Support drivers with
 non-combined channels
Thread-Topic: [PATCH bpf-next v4 07/17] libbpf: Support drivers with
 non-combined channels
Thread-Index: AQHVITdxVC+hU8LhkUKnNDgy7zjLlaaYdxEAgAEneoCAAAxZgIABe9mA
Date:   Fri, 14 Jun 2019 13:25:24 +0000
Message-ID: <eb175575-1ab4-4d29-1dc9-28d85cddd842@mellanox.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
 <20190612155605.22450-8-maximmi@mellanox.com>
 <20190612132352.7ee27bf3@cakuba.netronome.com>
 <0afd3ef2-d0e3-192b-095e-0f8ae8e6fb5d@mellanox.com>
 <20190613164514.00002f66@gmail.com>
In-Reply-To: <20190613164514.00002f66@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0108.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::49) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [159.224.90.213]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b5b4e66-68d1-4f45-ab87-08d6f0cbc212
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB4359;
x-ms-traffictypediagnostic: AM6PR05MB4359:
x-microsoft-antispam-prvs: <AM6PR05MB435975E237D6A26FCA081686D1EE0@AM6PR05MB4359.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(366004)(376002)(39860400002)(199004)(189003)(53936002)(305945005)(14454004)(25786009)(8676002)(8936002)(6116002)(54906003)(7736002)(3846002)(6436002)(4326008)(2906002)(6246003)(6486002)(81166006)(229853002)(81156014)(64756008)(478600001)(68736007)(66446008)(71190400001)(14444005)(316002)(486006)(6512007)(55236004)(6506007)(386003)(186003)(31686004)(53546011)(446003)(102836004)(11346002)(73956011)(31696002)(26005)(71200400001)(5024004)(66946007)(66476007)(66556008)(99286004)(2616005)(86362001)(476003)(256004)(1411001)(7416002)(76176011)(6916009)(36756003)(66066001)(5660300002)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4359;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Tn3K9bW0/4yF9EIo/R0hnUv31Sx/rjAesyCytykN20R6Lmj1d8I0fJl9Yak3ZKwrwA4+Dqx+IYRfZT4GaUZTYgYivmugWj7E4lP1i6Z/nUTomtxcP1xzH1jAZvxGj15A0Gc9Fo1MvrlNBWeLAjeA++sWgy2SR2vvJfN7piaky9q8/n14Bky9xore9XuK9pg0GJwVw6MgtspcYGhCWs27KQot9Ni210OJGyM0FIHBf4xWq2J42szAZl6WWX/XPz0okj/g8ANwBHf7Qz7fVkQJg/s5WK2HSTYRNxKEIYRBN8cZuybt9jLhkwko0LP9pxw0S9ySGVAF/gcs2S3ms/YoMTBlZfR9E6V5IBCdW+oHnHNl7beDBVLeeal1KnxZ9LVjjP5D0ChKNj+Rvy4jSRq+70lPf8/fxPipPqnaS5rJnGs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD26408D31C86A469E6663DE3FD9BE44@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b5b4e66-68d1-4f45-ab87-08d6f0cbc212
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 13:25:24.7962
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4359
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wNi0xMyAxNzo0NSwgTWFjaWVqIEZpamFsa293c2tpIHdyb3RlOg0KPiBPbiBUaHUs
IDEzIEp1biAyMDE5IDE0OjAxOjM5ICswMDAwDQo+IE1heGltIE1pa2l0eWFuc2tpeSA8bWF4aW1t
aUBtZWxsYW5veC5jb20+IHdyb3RlOg0KPiANCj4+IE9uIDIwMTktMDYtMTIgMjM6MjMsIEpha3Vi
IEtpY2luc2tpIHdyb3RlOg0KPj4+IE9uIFdlZCwgMTIgSnVuIDIwMTkgMTU6NTY6NDggKzAwMDAs
IE1heGltIE1pa2l0eWFuc2tpeSB3cm90ZToNCj4+Pj4gQ3VycmVudGx5LCBsaWJicGYgdXNlcyB0
aGUgbnVtYmVyIG9mIGNvbWJpbmVkIGNoYW5uZWxzIGFzIHRoZSBtYXhpbXVtDQo+Pj4+IHF1ZXVl
IG51bWJlci4gSG93ZXZlciwgdGhlIGtlcm5lbCBoYXMgYSBkaWZmZXJlbnQgbGltaXRhdGlvbjoN
Cj4+Pj4NCj4+Pj4gLSB4ZHBfcmVnX3VtZW1fYXRfcWlkKCkgYWxsb3dzIHVwIHRvIG1heChSWCBx
dWV1ZXMsIFRYIHF1ZXVlcykuDQo+Pj4+DQo+Pj4+IC0gZXRodG9vbF9zZXRfY2hhbm5lbHMoKSBj
aGVja3MgZm9yIFVNRU1zIGluIHF1ZXVlcyB1cCB0bw0KPj4+PiAgICAgY29tYmluZWRfY291bnQg
KyBtYXgocnhfY291bnQsIHR4X2NvdW50KS4NCj4+Pj4NCj4+Pj4gbGliYnBmIHNob3VsZG4ndCBs
aW1pdCBhcHBsaWNhdGlvbnMgdG8gYSBsb3dlciBtYXggcXVldWUgbnVtYmVyLiBBY2NvdW50DQo+
Pj4+IGZvciBub24tY29tYmluZWQgUlggYW5kIFRYIGNoYW5uZWxzIHdoZW4gY2FsY3VsYXRpbmcg
dGhlIG1heCBxdWV1ZQ0KPj4+PiBudW1iZXIuIFVzZSB0aGUgc2FtZSBmb3JtdWxhIHRoYXQgaXMg
dXNlZCBpbiBldGh0b29sLg0KPj4+Pg0KPj4+PiBTaWduZWQtb2ZmLWJ5OiBNYXhpbSBNaWtpdHlh
bnNraXkgPG1heGltbWlAbWVsbGFub3guY29tPg0KPj4+PiBSZXZpZXdlZC1ieTogVGFyaXEgVG91
a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0KPj4+PiBBY2tlZC1ieTogU2FlZWQgTWFoYW1lZWQg
PHNhZWVkbUBtZWxsYW5veC5jb20+DQo+Pj4NCj4+PiBJIGRvbid0IHRoaW5rIHRoaXMgaXMgY29y
cmVjdC4gIG1heF90eCB0ZWxscyB5b3UgaG93IG1hbnkgVFggY2hhbm5lbHMNCj4+PiB0aGVyZSBj
YW4gYmUsIHlvdSBjYW4ndCBhZGQgdGhhdCB0byBjb21iaW5lZC4gIENvcnJlY3QgY2FsY3VsYXRp
b25zIGlzOg0KPj4+DQo+Pj4gbWF4X251bV9jaGFucyA9IG1heChtYXhfY29tYmluZWQsIG1heCht
YXhfcngsIG1heF90eCkpDQo+Pg0KPj4gRmlyc3Qgb2YgYWxsLCBJJ20gYWxpZ25pbmcgd2l0aCB0
aGUgZm9ybXVsYSBpbiB0aGUga2VybmVsLCB3aGljaCBpczoNCj4+DQo+PiAgICAgICBjdXJyLmNv
bWJpbmVkX2NvdW50ICsgbWF4KGN1cnIucnhfY291bnQsIGN1cnIudHhfY291bnQpOw0KPj4NCj4+
IChzZWUgbmV0L2NvcmUvZXRodG9vbC5jLCBldGh0b29sX3NldF9jaGFubmVscygpKS4NCj4+DQo+
PiBUaGUgZm9ybXVsYSBpbiBsaWJicGYgc2hvdWxkIG1hdGNoIGl0Lg0KPj4NCj4+IFNlY29uZCwg
dGhlIGV4aXN0aW5nIGRyaXZlcnMgaGF2ZSBlaXRoZXIgY29tYmluZWQgY2hhbm5lbHMgb3Igc2Vw
YXJhdGUNCj4+IHJ4IGFuZCB0eCBjaGFubmVscy4gU28sIGZvciB0aGUgZmlyc3Qga2luZCBvZiBk
cml2ZXJzLCBtYXhfdHggZG9lc24ndA0KPj4gdGVsbCBob3cgbWFueSBUWCBjaGFubmVscyB0aGVy
ZSBjYW4gYmUsIGl0IGp1c3Qgc2F5cyAwLCBhbmQgbWF4X2NvbWJpbmVkDQo+PiB0ZWxscyBob3cg
bWFueSBUWCBhbmQgUlggY2hhbm5lbHMgYXJlIHN1cHBvcnRlZC4gQXMgbWF4X3R4IGRvZXNuJ3QN
Cj4+IGluY2x1ZGUgbWF4X2NvbWJpbmVkIChhbmQgdmljZSB2ZXJzYSksIHdlIHNob3VsZCBhZGQg
dGhlbSB1cC4NCj4+DQo+Pj4+ICAgIHRvb2xzL2xpYi9icGYveHNrLmMgfCA2ICsrKy0tLQ0KPj4+
PiAgICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPj4+
Pg0KPj4+PiBkaWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi94c2suYyBiL3Rvb2xzL2xpYi9icGYv
eHNrLmMNCj4+Pj4gaW5kZXggYmYxNWE4MGEzN2MyLi44NjEwNzg1N2UxZjAgMTAwNjQ0DQo+Pj4+
IC0tLSBhL3Rvb2xzL2xpYi9icGYveHNrLmMNCj4+Pj4gKysrIGIvdG9vbHMvbGliL2JwZi94c2su
Yw0KPj4+PiBAQCAtMzM0LDEzICszMzQsMTMgQEAgc3RhdGljIGludCB4c2tfZ2V0X21heF9xdWV1
ZXMoc3RydWN0IHhza19zb2NrZXQgKnhzaykNCj4+Pj4gICAgCQlnb3RvIG91dDsNCj4+Pj4gICAg
CX0NCj4+Pj4gICAgDQo+Pj4+IC0JaWYgKGNoYW5uZWxzLm1heF9jb21iaW5lZCA9PSAwIHx8IGVy
cm5vID09IEVPUE5PVFNVUFApDQo+Pj4+ICsJcmV0ID0gY2hhbm5lbHMubWF4X2NvbWJpbmVkICsg
bWF4KGNoYW5uZWxzLm1heF9yeCwgY2hhbm5lbHMubWF4X3R4KTsNCj4gDQo+IFNvIGluIGNhc2Ug
b2YgMzIgSFcgcXVldWVzIHlvdSdkIGxpa2UgdG8gZ2V0IDY0IGVudHJpZXMgaW4geHNrbWFwPw0K
DQoiMzIgSFcgcXVldWVzIiBpcyBub3QgcXVpdGUgY29ycmVjdC4gSXQgd2lsbCBiZSAzMiBjb21i
aW5lZCBjaGFubmVscywgDQplYWNoIHdpdGggb25lIHJlZ3VsYXIgUlggcXVldWUgYW5kIG9uZSBY
U0sgUlggcXVldWUgKHJlZ3VsYXIgUlggcXVldWVzIA0KYXJlIHBhcnQgb2YgUlNTKS4gSW4gdGhp
cyBjYXNlLCBJJ2xsIGhhdmUgNjQgWFNLTUFQIGVudHJpZXMuDQoNCj4gRG8geW91IHN0aWxsDQo+
IGhhdmUgYSBuZWVkIGZvciBhdHRhY2hpbmcgdGhlIHhza3NvY2tzIHRvIHRoZSBSU1MgcXVldWVz
Pw0KDQpZb3UgY2FuIGF0dGFjaCBhbiBYU0sgdG8gYSByZWd1bGFyIFJYIHF1ZXVlLCBidXQgbm90
IGluIHplcm8tY29weSBtb2RlLiANClRoZSBpbnRlbmRlZCB1c2UgaXMsIG9mIGNvdXJzZSwgdG8g
YXR0YWNoIFhTS3MgdG8gWFNLIFJYIHF1ZXVlcyBpbiANCnplcm8tY29weSBtb2RlLg0KDQo+IEkg
dGhvdWdodCB5b3Ugd2FudA0KPiB0aGVtIHRvIGJlIHNlcGFyYXRlZC4gU28gaWYgSSdtIHJlYWRp
bmcgdGhpcyByaWdodCwgWzAsIDMxXSB4c2ttYXAgZW50cmllcw0KPiB3b3VsZCBiZSB1bnVzZWQg
Zm9yIHRoZSBtb3N0IG9mIHRoZSB0aW1lLCBubz8NCg0KVGhpcyBpcyBjb3JyZWN0LCBidXQgdGhl
c2UgZW50cmllcyBhcmUgc3RpbGwgbmVlZGVkIGlmIG9uZSBkZWNpZGVzIHRvIA0KcnVuIGNvbXBh
dGliaWxpdHkgbW9kZSB3aXRob3V0IHplcm8tY29weSBvbiBxdWV1ZXMgMC4uMzEuDQoNCj4gDQo+
Pj4+ICsNCj4+Pj4gKwlpZiAocmV0ID09IDAgfHwgZXJybm8gPT0gRU9QTk9UU1VQUCkNCj4+Pj4g
ICAgCQkvKiBJZiB0aGUgZGV2aWNlIHNheXMgaXQgaGFzIG5vIGNoYW5uZWxzLCB0aGVuIGFsbCB0
cmFmZmljDQo+Pj4+ICAgIAkJICogaXMgc2VudCB0byBhIHNpbmdsZSBzdHJlYW0sIHNvIG1heCBx
dWV1ZXMgPSAxLg0KPj4+PiAgICAJCSAqLw0KPj4+PiAgICAJCXJldCA9IDE7DQo+Pj4+IC0JZWxz
ZQ0KPj4+PiAtCQlyZXQgPSBjaGFubmVscy5tYXhfY29tYmluZWQ7DQo+Pj4+ICAgIA0KPj4+PiAg
ICBvdXQ6DQo+Pj4+ICAgIAljbG9zZShmZCk7DQo+Pj4gICAgDQo+Pg0KPiANCg0K
