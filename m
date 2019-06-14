Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7CE45E16
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 15:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbfFNN0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 09:26:15 -0400
Received: from mail-eopbgr50085.outbound.protection.outlook.com ([40.107.5.85]:23970
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727612AbfFNN0P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 09:26:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Sv1htaGl/hr0T10yFGYh6ZQhUNjz0H3LznmgCfSNwQ=;
 b=ZKNv769QWYcj4rf+F3D/sMGdeQbkgsP/AQqnvSu9O6YPnTo59caJc8kuS1/PxM/md/4wWQE0M2uPCSWwQDqPbp8QnDgK5Tw60MHeSOv4FfWpKs2E3Q6NohxS07IGSj0eFQInPV0XQFArLSn84P2EAl9Krxk40JodsjXPUmC7cIA=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB4359.eurprd05.prod.outlook.com (52.135.162.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Fri, 14 Jun 2019 13:25:29 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.010; Fri, 14 Jun 2019
 13:25:29 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Jesper Dangaard Brouer <brouer@redhat.com>,
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
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Subject: Re: [PATCH bpf-next v4 05/17] xsk: Change the default frame size to
 4096 and allow controlling it
Thread-Topic: [PATCH bpf-next v4 05/17] xsk: Change the default frame size to
 4096 and allow controlling it
Thread-Index: AQHVITdu7fpr20kECE+M200+kOAnM6aYc0WAgAErPoCAADoyAIABTg2A
Date:   Fri, 14 Jun 2019 13:25:28 +0000
Message-ID: <161cec62-103f-c87c-52b7-8a627940622b@mellanox.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
 <20190612155605.22450-6-maximmi@mellanox.com>
 <20190612131017.766b4e82@cakuba.netronome.com>
 <b7217210-1ce6-4b27-9964-b4daa4929e8b@mellanox.com>
 <20190613102936.2c8979ed@cakuba.netronome.com>
In-Reply-To: <20190613102936.2c8979ed@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR02CA0062.namprd02.prod.outlook.com
 (2603:10b6:a03:54::39) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [159.224.90.213]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d31895c2-e3aa-4c91-6c94-08d6f0cbc465
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB4359;
x-ms-traffictypediagnostic: AM6PR05MB4359:
x-microsoft-antispam-prvs: <AM6PR05MB4359464E7C88CEEC37562FC8D1EE0@AM6PR05MB4359.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(366004)(376002)(39860400002)(199004)(189003)(53936002)(305945005)(14454004)(25786009)(8676002)(8936002)(6116002)(54906003)(7736002)(3846002)(6436002)(4326008)(2906002)(6246003)(6486002)(81166006)(229853002)(81156014)(64756008)(478600001)(68736007)(66446008)(71190400001)(14444005)(316002)(486006)(6512007)(55236004)(6506007)(386003)(186003)(31686004)(53546011)(446003)(102836004)(11346002)(73956011)(31696002)(26005)(71200400001)(66946007)(66476007)(66556008)(99286004)(2616005)(86362001)(476003)(256004)(7416002)(76176011)(6916009)(36756003)(66066001)(5660300002)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4359;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nyviKKOozn+/vYgWnVhkddKwQ+eNEMa8cIVO2HQWP8MZsWegYEtK1NLXj7qY102Q1GBxCNZtYgqYm3JHMVANwbDdUbeH0nKJfyQ8B3gO4cxE1woc3RMRMpzj64JWT36Zl2qvp1aSkczCDDE3cQe5dFy7Z/LaR/ClYg1+AyMiv553aO2lBgjMnml7J2ygHIQk71JbvZWe7B56np+KAnpwpMIzNQe43FbCmZErs6vSOSUyrCYz+vVTIgYrCknRfT1sZVrt1zdSmsOp2X6ZLhAjLMSyvPieeaiPlUIcERNCDTTFVLfGZQB1ik0xwUU3RMwu/DIKDqueZtYt6rA8AaMDut2AtCljBIhWpGd8tP1mS1U1UAnfxiJp1SDOiVBZj7nBSbSDgN1CA6rpN6x0c7FZTKICGpAog8bWcG1AwKYI7rI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7C03539CDE535A409EC61E124C2A9DDD@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d31895c2-e3aa-4c91-6c94-08d6f0cbc465
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 13:25:28.8779
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

T24gMjAxOS0wNi0xMyAyMDoyOSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIFRodSwgMTMg
SnVuIDIwMTkgMTQ6MDE6MzkgKzAwMDAsIE1heGltIE1pa2l0eWFuc2tpeSB3cm90ZToNCj4+IE9u
IDIwMTktMDYtMTIgMjM6MTAsIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPj4+IE9uIFdlZCwgMTIg
SnVuIDIwMTkgMTU6NTY6NDMgKzAwMDAsIE1heGltIE1pa2l0eWFuc2tpeSB3cm90ZToNCj4+Pj4g
VGhlIHR5cGljYWwgWERQIG1lbW9yeSBzY2hlbWUgaXMgb25lIHBhY2tldCBwZXIgcGFnZS4gQ2hh
bmdlIHRoZSBBRl9YRFANCj4+Pj4gZnJhbWUgc2l6ZSBpbiBsaWJicGYgdG8gNDA5Niwgd2hpY2gg
aXMgdGhlIHBhZ2Ugc2l6ZSBvbiB4ODYsIHRvIGFsbG93DQo+Pj4+IGxpYmJwZiB0byBiZSB1c2Vk
IHdpdGggdGhlIGRyaXZlcnMgd2l0aCB0aGUgcGFja2V0LXBlci1wYWdlIHNjaGVtZS4NCj4+Pg0K
Pj4+IFRoaXMgaXMgc2xpZ2h0bHkgc3VycHJpc2luZy4gIFdoeSBkb2VzIHRoZSBkcml2ZXIgY2Fy
ZSBhYm91dCB0aGUgYnVmc3o/DQo+Pg0KPj4gVGhlIGNsYXNzaWMgWERQIGltcGxlbWVudGF0aW9u
IHN1cHBvcnRzIG9ubHkgdGhlIHBhY2tldC1wZXItcGFnZSBzY2hlbWUuDQo+PiBtbHg1ZSBpbXBs
ZW1lbnRzIHRoaXMgc2NoZW1lLCBiZWNhdXNlIGl0IHBlcmZlY3RseSBmaXRzIHdpdGggeGRwX3Jl
dHVybg0KPj4gYW5kIHBhZ2UgcG9vbCBBUElzLiBBRl9YRFAgcmVsaWVzIG9uIFhEUCwgYW5kIGV2
ZW4gdGhvdWdoIEFGX1hEUCBkb2Vzbid0DQo+PiByZWFsbHkgYWxsb2NhdGUgb3IgcmVsZWFzZSBw
YWdlcywgaXQgd29ya3Mgb24gdG9wIG9mIFhEUCwgYW5kIFhEUA0KPj4gaW1wbGVtZW50YXRpb24g
aW4gbWx4NWUgZG9lcyBhbGxvY2F0ZSBhbmQgcmVsZWFzZSBwYWdlcyAoaW4gZ2VuZXJhbA0KPj4g
Y2FzZSkgYW5kIHdvcmtzIHdpdGggdGhlIHBhY2tldC1wZXItcGFnZSBzY2hlbWUuDQo+IA0KPiBZ
ZXMsIG9rYXksIEkgZ2V0IHRoYXQuICBCdXQgSSBzdGlsbCBkb24ndCBrbm93IHdoYXQncyB0aGUg
ZXhhY3QgdXNlIHlvdQ0KPiBoYXZlIGZvciBBRl9YRFAgYnVmZmVycyBiZWluZyA0ay4uICBDb3Vs
ZCB5b3UgcG9pbnQgdXMgaW4gdGhlIGNvZGUgdG8NCj4gdGhlIHBsYWNlIHdoaWNoIHJlbGllcyBv
biBhbGwgYnVmZmVycyBiZWluZyA0ayBpbiBhbnkgWERQIHNjZW5hcmlvPw0KDQoxLiBBbiBYRFAg
cHJvZ3JhbSBpcyBzZXQgb24gYWxsIHF1ZXVlcywgc28gdG8gc3VwcG9ydCBub24tNGsgQUZfWERQ
IA0KZnJhbWVzLCB3ZSB3b3VsZCBhbHNvIG5lZWQgdG8gc3VwcG9ydCBtdWx0aXBsZS1wYWNrZXQt
cGVyLXBhZ2UgWERQIGZvciANCnJlZ3VsYXIgcXVldWVzLg0KDQoyLiBQYWdlIGFsbG9jYXRpb24g
aW4gbWx4NWUgcGVyZmVjdGx5IGZpdHMgcGFnZS1zaXplZCBYRFAgZnJhbWVzLiBTb21lIA0KZXhh
bXBsZXMgaW4gdGhlIGNvZGUgYXJlOg0KDQoyLjEuIG1seDVlX2ZyZWVfcnhfbXB3cWUgY2FsbHMg
YSBnZW5lcmljIG1seDVlX3BhZ2VfcmVsZWFzZSB0byByZWxlYXNlIA0KdGhlIHBhZ2VzIG9mIGEg
TVBXUUUgKG11bHRpLXBhY2tldCB3b3JrIHF1ZXVlIGVsZW1lbnQpLCB3aGljaCBpcyANCmltcGxl
bWVudGVkIGFzIHhza191bWVtX2ZxX3JldXNlIGZvciB0aGUgY2FzZSBvZiBYU0suIFdlIGF2b2lk
IGV4dHJhIA0Kb3ZlcmhlYWQgYnkgdXNpbmcgdGhlIGZhY3QgdGhhdCBwYWNrZXQgPT0gcGFnZS4N
Cg0KMi4yLiBtbHg1ZV9mcmVlX3hkcHNxX2Rlc2MgcGVyZm9ybXMgY2xlYW51cCBhZnRlciBYRFAg
dHJhbnNtaXRzLiBJbiBjYXNlIA0Kb2YgWERQX1RYLCB3ZSBjYW4gZnJlZS9yZWN5Y2xlIHRoZSBw
YWdlcyB3aXRob3V0IGhhdmluZyBhIHJlZmNvdW50IA0Kb3ZlcmhlYWQsIGJ5IHVzaW5nIHRoZSBm
YWN0IHRoYXQgcGFja2V0ID09IHBhZ2UuDQoNCj4+PiBZb3UncmUgbm90IHN1cHBvc2VkIHRvIHNv
IHBhZ2Ugb3BlcmF0aW9ucyBvbiBVTUVNIHBhZ2VzLCBhbnl3YXkuDQo+Pj4gQW5kIHRoZSBSWCBz
aXplIGZpbHRlciBzaG91bGQgYmUgY29uZmlndXJlZCBhY2NvcmRpbmcgdG8gTVRVIHJlZ2FyZGxl
c3MNCj4+PiBvZiBYRFAgc3RhdGUuDQo+Pg0KPj4gWWVzLCBvZiBjb3Vyc2UsIE1UVSBpcyB0YWtl
biBpbnRvIGFjY291bnQuDQo+Pg0KPj4+IENhbiB5b3UgZXhwbGFpbj8NCj4+PiAgICANCj4+Pj4g
QWRkIGEgY29tbWFuZCBsaW5lIG9wdGlvbiAtZiB0byB4ZHBzb2NrIHRvIGFsbG93IHRvIHNwZWNp
ZnkgYSBjdXN0b20NCj4+Pj4gZnJhbWUgc2l6ZS4NCj4+Pj4NCj4+Pj4gU2lnbmVkLW9mZi1ieTog
TWF4aW0gTWlraXR5YW5za2l5IDxtYXhpbW1pQG1lbGxhbm94LmNvbT4NCj4+Pj4gUmV2aWV3ZWQt
Ynk6IFRhcmlxIFRvdWthbiA8dGFyaXF0QG1lbGxhbm94LmNvbT4NCj4+Pj4gQWNrZWQtYnk6IFNh
ZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KDQo=
