Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29DFD716DC
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 13:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389311AbfGWLVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 07:21:50 -0400
Received: from mail-eopbgr140058.outbound.protection.outlook.com ([40.107.14.58]:60899
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726709AbfGWLVu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 07:21:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vhq3bfKVSCXvGFaGMlAlcstL609rCUQaRklE0cmv4YUgU1HEYKZBzanMXRYUUo415v5S19N9JYxp7onWxIR41ag/POKlDRnhc/sw0y8S5HrGAl2bSS6oc25KlDI5dp8ERi7Jqn7nZFbgwNDgtdRG2eaZcfGoK9zStVa15s4tvp+YYPuBb+xArFzHBWq8VKPV6kIt94IGZMoevIo+k6ShA6GEI5HR0pb0KiPvwYDxvgZk3tccB30nGNxpcGDZ4Mq5A/0eFtKBP8hfOvyGaY1cdeMq8oDlRR1WhgzaGH7gFMAQ9CDJLogZY7kenmeSU3U2/RmyhSUDKwIgp3Pv+EYp3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AhVGkxJ5cxbWROktfi06/b14iV9pFaAg/pHaU+f4o5w=;
 b=dSqR75QrhYXgVngu3aXP9OwEe+J7BZaIrMDF2zBTEG5MX175HzkpmmfxY+0/qrleXpXYNQcigsLVDHKUTfVc6I0zrp+9EJ7CMGzmUWXSPATRkTmD4N9hQKhqhO7NKd5g5X9YkKbblzOxgag200b4sCxRu+Dw0aqnLJYYBUdKQD7Yg5UxFmEcL1OIcQbbN7Bm3DqVXIQXbLViK0QjhAeUDOJDojsEi5xAB+92Zk1TmOhXAkIiXJMp7lirI2ZwafiH4OZwuQrxVqSPjUonDn6sLFcPFr6UEHuZamNLZiFGPOHIaCKmlYWwK0ir8SLJupfXGOujmf7Tn8/GZgtQMXhxzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AhVGkxJ5cxbWROktfi06/b14iV9pFaAg/pHaU+f4o5w=;
 b=lZZsco8vI+n1NUTpvh4EsC5+or8eSvRrqasf7LMcJLuWzNbue70ObkLXB3Yv3YMXXFOmpb7eso84A8ij1KM4z6NiuzPfG0hg1s89m/7txqB0RNq93BBWcTNxPH1mDACx1OhJCBWaC877WJZCMIfkOa960QZ5e92dTX/AiKXOGbw=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB4933.eurprd05.prod.outlook.com (20.177.35.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Tue, 23 Jul 2019 11:21:45 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::f9d8:38bc:4a18:f7a7]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::f9d8:38bc:4a18:f7a7%5]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 11:21:45 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Arnd Bergmann <arnd@arndb.de>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH] [net-next] net/mlx5e: xsk: dynamically allocate
 mlx5e_channel_param
Thread-Topic: [PATCH] [net-next] net/mlx5e: xsk: dynamically allocate
 mlx5e_channel_param
Thread-Index: AQHVNYx/Ypx2Y7+f3k6VGsR33x4yYqbBB2OAgBcfHYA=
Date:   Tue, 23 Jul 2019 11:21:45 +0000
Message-ID: <535ebf16-c523-0799-3ffe-6cfbeee3ac57@mellanox.com>
References: <20190708125554.3863901-1-arnd@arndb.de>
 <543fa599-8ea1-dbc8-d94a-f90af2069edd@mellanox.com>
In-Reply-To: <543fa599-8ea1-dbc8-d94a-f90af2069edd@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0356.eurprd05.prod.outlook.com
 (2603:10a6:7:94::15) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.67.35.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f262864-2d22-4062-9061-08d70f5ff206
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB4933;
x-ms-traffictypediagnostic: AM6PR05MB4933:
x-microsoft-antispam-prvs: <AM6PR05MB4933CBB548DDAACED8E22B5ED1C70@AM6PR05MB4933.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(52314003)(189003)(199004)(76176011)(486006)(14454004)(305945005)(102836004)(8676002)(3846002)(53546011)(81156014)(6506007)(386003)(52116002)(26005)(476003)(6916009)(8936002)(6116002)(14444005)(478600001)(446003)(2616005)(256004)(316002)(186003)(68736007)(4326008)(54906003)(11346002)(2906002)(5660300002)(6486002)(6512007)(66066001)(53936002)(71190400001)(6246003)(66946007)(64756008)(66476007)(7736002)(66446008)(66556008)(31686004)(71200400001)(6436002)(7416002)(31696002)(36756003)(81166006)(25786009)(99286004)(86362001)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4933;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0VsLoKxS7KmFXUViiYkh11BuFbxfhhHLbT8ReFKs+O6MR5h/MuIejvi8NHLPPJJ27zMpOxfvx5LAVqNIsclDHeMzdSjtpFJd2PUW+rKXYyOxHlnkkdy/wZec4ExpAhqzi8YStfHne3S9mfbAT5hyAMv3gRYkDnnoEZP7ncjLj9H6WpecQEIDcj56401N2HOdh1khgv2OK48OmPAXWtn9HpV5CNS98wbPUib9eweIIrqsAZdFvq+B+7ik0adzhFX+vf3k0PBMLqnySrxTwQzj6FDVO41FGH4yqrhb4mpyKiCt1blt8X568l+0cQhaENhc1JIQPz9scY6L+hUZcsobyzg3yFyBmZfVH0QyjyHEdr37G6F66UB9xldbD9nh4hJagvoV599LnIuHrs3rRRCnCJzmxt1tHbd31jEUxMrhLLs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B63C6DA5B42A7848A8663B1C887CCD32@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f262864-2d22-4062-9061-08d70f5ff206
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 11:21:45.5029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4933
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wNy0wOCAxODoxNiwgTWF4aW0gTWlraXR5YW5za2l5IHdyb3RlOg0KPiBPbiAyMDE5
LTA3LTA4IDE1OjU1LCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0KPj4gLQltbHg1ZV9idWlsZF94c2tf
Y3BhcmFtKHByaXYsIHBhcmFtcywgeHNrLCAmY3BhcmFtKTsNCj4+ICsJY3BhcmFtID0ga3phbGxv
YyhzaXplb2YoKmNwYXJhbSksIEdGUF9LRVJORUwpOw0KPiANCj4gU2ltaWxhciBjb2RlIGluIG1s
eDVlX29wZW5fY2hhbm5lbHMgKGVuX21haW4uYykgdXNlcyBrdnphbGxvYy4gQWx0aG91Z2gNCj4g
dGhlIHN0cnVjdCBpcyBjdXJyZW50bHkgc21hbGxlciB0aGFuIGEgcGFnZSBhbnl3YXksIGFuZCB0
aGVyZSBzaG91bGQgYmUNCj4gbm8gZGlmZmVyZW5jZSBpbiBiZWhhdmlvciBub3csIEkgc3VnZ2Vz
dCB1c2luZyB0aGUgc2FtZSBhbGxvYyBmdW5jdGlvbg0KPiB0byBrZWVwIGNvZGUgdW5pZm9ybS4N
Cj4gDQo+PiAgICAJLyogQ3JlYXRlIGEgZGVkaWNhdGVkIFNRIGZvciBwb3N0aW5nIE5PUHMgd2hl
bmV2ZXIgd2UgbmVlZCBhbiBJUlEgdG8gYmUNCj4+ICAgIAkgKiB0cmlnZ2VyZWQgYW5kIE5BUEkg
dG8gYmUgY2FsbGVkIG9uIHRoZSBjb3JyZWN0IENQVS4NCj4+ICAgIAkgKi8NCj4+IC0JZXJyID0g
bWx4NWVfb3Blbl9pY29zcShjLCBwYXJhbXMsICZjcGFyYW0uaWNvc3EsICZjLT54c2tpY29zcSk7
DQo+PiArCWVyciA9IG1seDVlX29wZW5faWNvc3EoYywgcGFyYW1zLCAmY3BhcmFtLT5pY29zcSwg
JmMtPnhza2ljb3NxKTsNCj4+ICAgIAlpZiAodW5saWtlbHkoZXJyKSkNCj4+ICAgIAkJZ290byBl
cnJfY2xvc2VfaWNvY3E7DQo+PiAgICANCj4gDQo+IEhlcmUgaXMga2ZyZWUgbWlzc2luZy4gSXQn
cyBhIG1lbW9yeSBsZWFrIGluIHRoZSBnb29kIHBhdGguDQoNCkFybmQsIEknbSBnb2luZyB0byB0
YWtlIG92ZXIgeW91ciBwYXRjaCBhbmQgcmVzcGluIGl0LCBhZGRyZXNzaW5nIG15IG93biANCmNv
bW1lbnRzLCBiZWNhdXNlIGl0J3MgYmVlbiBxdWl0ZSBhIHdoaWxlLCBhbmQgd2Ugd2FudCB0byBo
YXZlIHRoaXMgZml4Lg0KDQpUaGFua3MgZm9yIHNwb3R0aW5nIGl0Lg0K
