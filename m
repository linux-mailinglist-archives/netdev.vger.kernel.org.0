Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDA6AFF70
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 20:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfD3SLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 14:11:47 -0400
Received: from mail-eopbgr30084.outbound.protection.outlook.com ([40.107.3.84]:32839
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725950AbfD3SLq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 14:11:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j8qGBnfO9q8D+y/3iGAoSrigekyBgN8MuzOQTn+71Nw=;
 b=Ysnzt61bowNNZt/IZGm1emh71U01amht+vBijnmN/D3ICbtFC6376YHK0bK5O3358GcDVZwaS6/80bUmnJz3lCVwdCE+4YZunbhqkbaERpKN55ErBzFa5uX5wnDLlAs0brQtEpYyrBsoFUMUjuD8yxh+tRWwSi347bSLDN69sE4=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5553.eurprd05.prod.outlook.com (20.177.119.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Tue, 30 Apr 2019 18:11:42 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::cc18:150a:7740:1e2f]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::cc18:150a:7740:1e2f%2]) with mapi id 15.20.1856.008; Tue, 30 Apr 2019
 18:11:42 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH net-next 4/6] xsk: Extend channels to support combined
 XSK/non-XSK traffic
Thread-Topic: [PATCH net-next 4/6] xsk: Extend channels to support combined
 XSK/non-XSK traffic
Thread-Index: AQHU/CUldh5izAMluEaPJixgdWw0JqZOz4wAgAY4eYA=
Date:   Tue, 30 Apr 2019 18:11:41 +0000
Message-ID: <ee1b4e93-eab1-9010-df17-ee093aac6e01@mellanox.com>
References: <20190426114156.8297-1-maximmi@mellanox.com>
 <20190426114156.8297-5-maximmi@mellanox.com>
 <20190426121158.47c14fb8@cakuba.netronome.com>
In-Reply-To: <20190426121158.47c14fb8@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR08CA0074.eurprd08.prod.outlook.com
 (2603:10a6:205:2::45) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.67.35.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f88c21e-3365-4052-7e77-08d6cd974be2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5553;
x-ms-traffictypediagnostic: AM6PR05MB5553:
x-microsoft-antispam-prvs: <AM6PR05MB55533CD895C332F9489D2F8ED13A0@AM6PR05MB5553.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(346002)(376002)(39860400002)(189003)(199004)(6506007)(3846002)(26005)(6916009)(478600001)(316002)(97736004)(6116002)(446003)(76176011)(4326008)(476003)(486006)(8676002)(52116002)(81166006)(6436002)(54906003)(8936002)(99286004)(11346002)(81156014)(2616005)(31686004)(66946007)(66556008)(256004)(66476007)(64756008)(66446008)(73956011)(36756003)(305945005)(71200400001)(71190400001)(14444005)(107886003)(102836004)(53546011)(68736007)(86362001)(7736002)(229853002)(186003)(66066001)(6486002)(386003)(5660300002)(53936002)(31696002)(25786009)(6512007)(14454004)(2906002)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5553;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZlSBityuR9bUgVyJxPmIpa3PuLhhdvB0vfIG7TJjVB7HJn+xZ6oY3eDJYYOxz0H4xBxTseP7E1yaW1ltK5DarSPQmqx9bTzITWdGIKotOH8rcmvPWG2dm/3QhrUskVVPiZtGYWmI7NIz4I+XCg3FAOQGDWOxWKCjtJJtaIz14BTAJMlDuvxMtusVNIJjLNEAS4myl9dqB5R2CwRUi+MU5utTQCBO4gLPF2kDg7Fn8Mp9LZrxRBP0OAcTqb81xjqwJOWizLQtbAUaXS+PWXW53807aUjCSO0dzXTXvmB+mtyBymuDqy2PHvXDRjy4bmuGT/GYm1Tdwci4jCm4N7veOROaKquEwiW2IvmKye3nBfYfWSeMKt1Zhqc0N2gOjCijRafklS8bxVzW05Kah+zxzTMd0FboOsyDDQEcbqhHN8Q=
Content-Type: text/plain; charset="utf-8"
Content-ID: <75BC68EFB5A5474DBA47D829EB15B2F9@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f88c21e-3365-4052-7e77-08d6cd974be2
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 18:11:41.9176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5553
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wNC0yNiAyMjoxMSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIEZyaSwgMjYg
QXByIDIwMTkgMTE6NDI6MzcgKzAwMDAsIE1heGltIE1pa2l0eWFuc2tpeSB3cm90ZToNCj4+IEN1
cnJlbnRseSwgdGhlIGRyaXZlcnMgdGhhdCBpbXBsZW1lbnQgQUZfWERQIHplcm8tY29weSBzdXBw
b3J0IChlLmcuLA0KPj4gaTQwZSkgc3dpdGNoIHRoZSBjaGFubmVsIGludG8gYSBkaWZmZXJlbnQg
bW9kZSB3aGVuIGFuIFhTSyBpcyBvcGVuZWQuIEl0DQo+PiBjYXVzZXMgc29tZSBpc3N1ZXMgdGhh
dCBoYXZlIHRvIGJlIHRha2VuIGludG8gYWNjb3VudC4gRm9yIGV4YW1wbGUsIFJTUw0KPj4gbmVl
ZHMgdG8gYmUgcmVjb25maWd1cmVkIHRvIHNraXAgdGhlIFhTSy1lbmFibGVkIGNoYW5uZWxzLCBv
ciB0aGUgWERQDQo+PiBwcm9ncmFtIHNob3VsZCBmaWx0ZXIgb3V0IHRyYWZmaWMgbm90IGludGVu
ZGVkIGZvciB0aGF0IHNvY2tldCBhbmQNCj4+IFhEUF9QQVNTIGl0IHdpdGggYW4gYWRkaXRpb25h
bCBjb3B5LiBBcyBub3RoaW5nIHZhbGlkYXRlcyBvciBmb3JjZXMgdGhlDQo+PiBwcm9wZXIgY29u
ZmlndXJhdGlvbiwgaXQncyBlYXN5IHRvIGhhdmUgcGFja2V0cyBkcm9wcywgd2hlbiB0aGV5IGdl
dA0KPj4gaW50byBhbiBYU0sgYnkgbWlzdGFrZSwgYW5kLCBpbiBmYWN0LCBpdCdzIHRoZSBkZWZh
dWx0IGNvbmZpZ3VyYXRpb24uDQo+PiBUaGVyZSBoYXMgdG8gYmUgc29tZSB0b29sIHRvIGhhdmUg
UlNTIHJlY29uZmlndXJlZCBvbiBlYWNoIHNvY2tldCBvcGVuDQo+PiBhbmQgY2xvc2UgZXZlbnQs
IGJ1dCBzdWNoIGEgdG9vbCBpcyBwcm9ibGVtYXRpYyB0byBpbXBsZW1lbnQsIGJlY2F1c2Ugbm8N
Cj4+IG9uZSByZXBvcnRzIHRoZXNlIGV2ZW50cywgYW5kIGl0J3MgcmFjZS1wcm9uZS4NCj4+DQo+
PiBUaGlzIGNvbW1pdCBleHRlbmRzIFhTSyB0byBzdXBwb3J0IGJvdGgga2luZHMgb2YgdHJhZmZp
YyAoWFNLIGFuZA0KPj4gbm9uLVhTSykgaW4gdGhlIHNhbWUgY2hhbm5lbC4gSXQgaW1wbGllcyBo
YXZpbmcgdHdvIFJYIHF1ZXVlcyBpbg0KPj4gWFNLLWVuYWJsZWQgY2hhbm5lbHM6IG9uZSBmb3Ig
dGhlIHJlZ3VsYXIgdHJhZmZpYywgYW5kIHRoZSBvdGhlciBmb3INCj4+IFhTSy4gSXQgc29sdmVz
IHRoZSBwcm9ibGVtIHdpdGggUlNTOiB0aGUgZGVmYXVsdCBjb25maWd1cmF0aW9uIGp1c3QNCj4+
IHdvcmtzIHdpdGhvdXQgdGhlIG5lZWQgdG8gbWFudWFsbHkgcmVjb25maWd1cmUgUlNTIG9yIHRv
IHBlcmZvcm0gc29tZQ0KPj4gcG9zc2libHkgY29tcGxpY2F0ZWQgZmlsdGVyaW5nIGluIHRoZSBY
RFAgbGF5ZXIuIEl0IG1ha2VzIGl0IGVhc3kgdG8gcnVuDQo+PiBib3RoIEFGX1hEUCBhbmQgcmVn
dWxhciBzb2NrZXRzIG9uIHRoZSBzYW1lIG1hY2hpbmUuIEluIHRoZSBYRFAgcHJvZ3JhbSwNCj4+
IHRoZSBRSUQncyBtb3N0IHNpZ25pZmljYW50IGJpdCB3aWxsIHNlcnZlIGFzIGEgZmxhZyB0byBp
bmRpY2F0ZSB3aGV0aGVyDQo+PiBpdCdzIHRoZSBYU0sgcXVldWUgb3Igbm90LiBUaGUgZXh0ZW5z
aW9uIGlzIGNvbXBhdGlibGUgd2l0aCB0aGUgbGVnYWN5DQo+PiBjb25maWd1cmF0aW9uLCBzbyBp
ZiBvbmUgd2FudHMgdG8gcnVuIHRoZSBsZWdhY3kgbW9kZSwgdGhleSBjYW4NCj4+IHJlY29uZmln
dXJlIFJTUyBhbmQgaWdub3JlIHRoZSBmbGFnIGluIHRoZSBYRFAgcHJvZ3JhbSAoaW1wbGVtZW50
ZWQgaW4NCj4+IHRoZSByZWZlcmVuY2UgWERQIHByb2dyYW0gaW4gbGliYnBmKS4gbWx4NWUgd2ls
bCBzdXBwb3J0IHRoaXMgZXh0ZW5zaW9uLg0KPj4NCj4+IEEgc2luZ2xlIFhEUCBwcm9ncmFtIGNh
biBydW4gYm90aCB3aXRoIGRyaXZlcnMgc3VwcG9ydGluZyBvciBub3QNCj4+IHN1cHBvcnRpbmcg
dGhpcyBleHRlbnNpb24uIFRoZSB4ZHBzb2NrIHNhbXBsZSBhbmQgbGliYnBmIGFyZSB1cGRhdGVk
DQo+PiBhY2NvcmRpbmdseS4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBNYXhpbSBNaWtpdHlhbnNr
aXkgPG1heGltbWlAbWVsbGFub3guY29tPg0KPiANCj4gSXQncyBiZWVuIGEgd2hpbGUgYnV0IHRo
aXMgcGF0Y2ggbWFrZXMgdmVyeSBsaXR0bGUgc2Vuc2UgdG8gbWUuDQo+IA0KPiBVc2VyIGluc3Rh
bGxzIGEgVU1FTSBvbiBhIHF1ZXVlLCBhbGwgcGFja2V0cyBhcmUgZGVsaXZlcmVkIHRvIHRoYXQN
Cj4gVU1FTSwgaWYgWERQIHByb2dyYW0gZG9lc24ndCByZWRpcmVjdCB0aGUgcGFja2V0IHRvIGEg
WFNLIHNvY2tldCB0aGUNCj4gZHJpdmVyIHNob3VsZCBjb3B5IGl0IHRvIGEgbm9ybWFsIGtlcm5l
bCBwYWdlIGFuZCBwcm9jZWVkLiAgTm8gZHJvcHMNCj4gc2hvdWxkIGhhcHBlbi4NCg0KVGhlIHRo
aW5nIGlzIHRoYXQgdGhlIHJlZmVyZW5jZSBYRFAgcHJvZ3JhbSAoaW5jbHVkZWQgaW4gbGliYnBm
KSANCnJlZGlyZWN0cyBldmVyeXRoaW5nIHRvIHRoZSBYU0suIEl0IGRvZXNuJ3QgZG8gYW55IGZp
bHRlcmluZy4gU28sIHRoZSANCnBhY2tldHMgc3RlZXJlZCB0byB0aGUgcXVldWUgYnkgUlNTIGFs
c28gZ2V0IGludG8gdGhlIFhTSyB3aGVuIHRoZXkgDQpzaG91bGRuJ3QgLSBoZXJlIGlzIHdoZXJl
IGRyb3BzIGFwcGVhci4gTW9yZW92ZXIsIGlmIHRoZSBYRFAgcHJvZ3JhbSBkaWQgDQp0aGUgZmls
dGVyaW5nLCB5b3Ugd291bGQgaGF2ZSB0byBzZXR1cCB0aGUgc2FtZSBydWxlcyBib3RoIHZpYSBl
dGh0b29sIA0KYW5kIGluIHRoZSBYRFAgcHJvZ3JhbSwgYW5kIHRoaXMgaGFzIGEgbG90IG9mIGRp
c2FkdmFudGFnZXMgY29tcGFyaW5nIHRvIA0KanVzdCBub3QgaGF2aW5nIHN0cmF5IHBhY2tldHMg
aW4gdGhlIHF1ZXVlLg0KDQo+IEhhdmluZyB0d28gcXVldWVzIHdoaWNoIHByZXRlbmQgdG8gc2hh
cmUgYW4gSUQgYnV0IHJlYWxseSBvbmUgb2YgdGhlbQ0KPiBoYXMgYSBtYWdpYyBlbmNvZGluZyBk
b2VzIG5vdCBoZWxwIElNTy4NCj4gDQo+IEkgZGVmaW5pdGVseSBhZ3JlZSB3aXRoIHlvdSB0aGF0
IHRoZSB3YXkgcXVldWVzIGFyZSB0YWtlbiBvdXQgb2YgdGhlDQo+IHN0YWNrJ3MgSUQgc3BhY2Ug
YW5kIHRoZSBmYWN0IHRoZXkgYXJlbid0IGF1dG9tYXRpY2FsbHkgZXhjbHVkZWQgZnJvbQ0KPiBS
U1MgZXRjIGlzIHF1aXRlIHN1Ym9wdGltYWwuLg0KPiANCg0K
