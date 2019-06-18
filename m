Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8DD449FFA
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 14:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfFRMAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 08:00:15 -0400
Received: from mail-eopbgr140080.outbound.protection.outlook.com ([40.107.14.80]:27719
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725913AbfFRMAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 08:00:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D59t3SXNUy0gp5PHz3tXJz7O9IjfOj7D51vl5LxP0tE=;
 b=fqlGAXbir82gWkttku9+MOA7+9eui/5tn+PPpSPQXLDGC7dKGR7zkHGy2YfdAn1jg8Sbt70K3++qdPbSAw0GzdZGvYBpvY9CqN2l7+/oEGWcXLQpDLO7REJH5/y4HchC3rK5RM0iErFRhTXRBE9XwLjaux/yMfEWZ28uL8kp17g=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5333.eurprd05.prod.outlook.com (20.177.197.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Tue, 18 Jun 2019 12:00:03 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 12:00:02 +0000
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
Thread-Index: AQHVITdu7fpr20kECE+M200+kOAnM6aYc0WAgAErPoCAADoyAIABTg2AgADNigCABWP3gA==
Date:   Tue, 18 Jun 2019 12:00:02 +0000
Message-ID: <5abe3603-65e4-7f3c-71f9-8866db116369@mellanox.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
 <20190612155605.22450-6-maximmi@mellanox.com>
 <20190612131017.766b4e82@cakuba.netronome.com>
 <b7217210-1ce6-4b27-9964-b4daa4929e8b@mellanox.com>
 <20190613102936.2c8979ed@cakuba.netronome.com>
 <161cec62-103f-c87c-52b7-8a627940622b@mellanox.com>
 <20190614184052.7de9471b@cakuba.netronome.com>
In-Reply-To: <20190614184052.7de9471b@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P190CA0030.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:52::19)
 To AM6PR05MB5879.eurprd05.prod.outlook.com (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.67.35.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ae81911-6be4-4127-ede0-08d6f3e47e95
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5333;
x-ms-traffictypediagnostic: AM6PR05MB5333:
x-microsoft-antispam-prvs: <AM6PR05MB5333C70FB96C449FF6CB038ED1EA0@AM6PR05MB5333.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(346002)(39860400002)(136003)(396003)(199004)(189003)(305945005)(66556008)(476003)(11346002)(66476007)(386003)(68736007)(478600001)(2616005)(6916009)(66066001)(66946007)(73956011)(86362001)(6436002)(66446008)(25786009)(26005)(81156014)(6486002)(64756008)(446003)(6506007)(4326008)(316002)(81166006)(8676002)(102836004)(8936002)(54906003)(486006)(186003)(53546011)(229853002)(6512007)(7416002)(31686004)(53936002)(71200400001)(76176011)(71190400001)(52116002)(36756003)(256004)(31696002)(14454004)(6246003)(6116002)(3846002)(5660300002)(7736002)(99286004)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5333;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +5pqzp8f8TDtS782QAbUS5+L6ZXV2cI2P3yFat++OkJvfYqTv3RAKUt+OSJleSvPKKhmQFmKAOvtsyTH/hNMxtlzEVD4V7Kwktd/yqW8WaMprL+/tnOYIlf4w+sN7C1reRYcgRfiXmHofhsTTWFfZ3FuxaWafO2qPNSN2V9zYBzP+zf/EcOzCGHJkiSswUKckSsUCDFEyyWcwAWAuIul5KVcXJp9sOdxSvUrhUyrStgX92XFeUGXWf3nV6b8SKCr89iONgAU13zdRHg+X0xa4VLq6vrQ0OSn62ePE0oWRa22HodK94++9FW9xFVKJ3hF+FjA7Q9vPn2p3jInXwohfqTZUknpGdy7JNb08D2m3/wILIsMDWnQj5HrqBxSDdkXYipeq5fVB7NLmT1XT62KatYR9AYm6wGdPIMbMt65+U4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BFB71E9B9196344F8D9962B77CA012AE@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ae81911-6be4-4127-ede0-08d6f3e47e95
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 12:00:02.7998
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5333
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wNi0xNSAwNDo0MCwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIEZyaSwgMTQg
SnVuIDIwMTkgMTM6MjU6MjggKzAwMDAsIE1heGltIE1pa2l0eWFuc2tpeSB3cm90ZToNCj4+IE9u
IDIwMTktMDYtMTMgMjA6MjksIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPj4+IE9uIFRodSwgMTMg
SnVuIDIwMTkgMTQ6MDE6MzkgKzAwMDAsIE1heGltIE1pa2l0eWFuc2tpeSB3cm90ZToNCj4+Pg0K
Pj4+IFllcywgb2theSwgSSBnZXQgdGhhdC4gIEJ1dCBJIHN0aWxsIGRvbid0IGtub3cgd2hhdCdz
IHRoZSBleGFjdCB1c2UgeW91DQo+Pj4gaGF2ZSBmb3IgQUZfWERQIGJ1ZmZlcnMgYmVpbmcgNGsu
LiAgQ291bGQgeW91IHBvaW50IHVzIGluIHRoZSBjb2RlIHRvDQo+Pj4gdGhlIHBsYWNlIHdoaWNo
IHJlbGllcyBvbiBhbGwgYnVmZmVycyBiZWluZyA0ayBpbiBhbnkgWERQIHNjZW5hcmlvPw0KPiAN
Cj4gT2theSwgSSBzdGlsbCBkb24ndCBnZXQgaXQsIGJ1dCB0aGF0J3MgZm9yIGV4cGxhaW5pbmcg
OikgIFBlcmhhcHMgaXQNCj4gd2lsbCBiZWNvbWUgY2xlYXJlciB3aGVuIHlvdSByZXNwaW5nIHdp
dGggcGF0Y2ggMTcgc3BsaXQgaW50bw0KPiByZXZpZXdhYmxlIGNodW5rcyA6KQ0KDQpJJ20gc29y
cnksIGFzIEkgc2FpZCBhYm92ZSwgSSBkb24ndCB0aGluayBzcGxpdHRpbmcgaXQgaXMgbmVjZXNz
YXJ5IG9yIA0KaXMgYSBnb29kIHRoaW5nIHRvIGRvLiBJIHVzZWQgdG8gaGF2ZSBpdCBzZXBhcmF0
ZWQsIGJ1dCBJIHNxdWFzaGVkIHRoZW0gDQp0byBzaG9ydGVuIHRoZSBzZXJpZXMgYW5kIHRvIGF2
b2lkIGhhdmluZyBzdHVwaWQgLyogVE9ETzogaW1wbGVtZW50ICovIA0KY29tbWVudHMgaW4gZW1w
dHkgZnVuY3Rpb25zIHRoYXQgYXJlIGltcGxlbWVudGVkIGluIHRoZSBuZXh0IHBhdGNoLiANClVu
c3F1YXNoaW5nIHRoZW0gaXMgZ29pbmcgdG8gdGFrZSBtb3JlIHRpbWUsIHdoaWNoIEkgdW5mb3J0
dW5hdGVseSBkb24ndCANCmhhdmUgYXMgSSdtIGZseWluZyB0byBOZXRjb25mIHRvbW9ycm93IGFu
ZCB0aGVuIGdvaW5nIG9uIHZhY2F0aW9uLiBTbywgSSANCndvdWxkIHJlYWxseSBsaWtlIHRvIGF2
b2lkIGl0IHVubGVzcyBhYnNvbHV0ZWx5IG5lY2Vzc2FyeS4gTW9yZW92ZXIsIGl0IA0Kd29uJ3Qg
aW5jcmVhc2UgcmVhZGFiaWxpdHkgLSB5b3UnbGwgaGF2ZSB0byBqdW1wIGJldHdlZW4gdGhlIHBh
dGNoZXMgdG8gDQpzZWUgdGhlIGNvbXBsZXRlIGltcGxlbWVudGF0aW9uIG9mIGEgc2luZ2xlIGZ1
bmN0aW9uIC0gaXQncyBhIHNpbmdsZSANCmZlYXR1cmUsIGFmdGVyIGFsbC4NCg0KPj4gMS4gQW4g
WERQIHByb2dyYW0gaXMgc2V0IG9uIGFsbCBxdWV1ZXMsIHNvIHRvIHN1cHBvcnQgbm9uLTRrIEFG
X1hEUA0KPj4gZnJhbWVzLCB3ZSB3b3VsZCBhbHNvIG5lZWQgdG8gc3VwcG9ydCBtdWx0aXBsZS1w
YWNrZXQtcGVyLXBhZ2UgWERQIGZvcg0KPj4gcmVndWxhciBxdWV1ZXMuDQo+IA0KPiBNbS4uIGRv
IHlvdSBoYXZlIHNvbWUgbWF0ZXJpYWxzIG9mIGhvdyB0aGUgbWx4NSBETUEvUlggd29ya3M/ICBJ
J2QgdGhpbmsNCj4gdGhhdCBpZiB5b3UgZG8gc2luZ2xlIHBhY2tldCBwZXIgYnVmZmVyIGFzIGxv
bmcgYXMgYWxsIHBhY2tldHMgYXJlDQo+IGd1YXJhbnRlZWQgdG8gZml0IGluIHRoZSBidWZmZXIg
KGJhc2VkIG9uIE1SVSkgdGhlIEhXIHNob3VsZG4ndCBjYXJlDQo+IHdoYXQgdGhlIHNpemUgb2Yg
dGhlIGJ1ZmZlciBpcy4NCg0KSXQncyBub3QgcmVsYXRlZCB0byBoYXJkd2FyZSwgaXQgaGVscHMg
Z2V0IGJldHRlciBwZXJmb3JtYW5jZSBieSANCnV0aWxpemluZyBwYWdlIHBvb2wgaW4gdGhlIG9w
dGltYWwgd2F5ICh3aXRob3V0IGhhdmluZyByZWZjbnQgPT0gMiBvbiANCnBhZ2VzKS4gTWF5YmUg
VGFyaXEgb3IgU2FlZWQgY291bGQgZXhwbGFpbiBpdCBtb3JlIGNsZWFybHkuDQoNCj4+IDIuIFBh
Z2UgYWxsb2NhdGlvbiBpbiBtbHg1ZSBwZXJmZWN0bHkgZml0cyBwYWdlLXNpemVkIFhEUCBmcmFt
ZXMuIFNvbWUNCj4+IGV4YW1wbGVzIGluIHRoZSBjb2RlIGFyZToNCj4+DQo+PiAyLjEuIG1seDVl
X2ZyZWVfcnhfbXB3cWUgY2FsbHMgYSBnZW5lcmljIG1seDVlX3BhZ2VfcmVsZWFzZSB0byByZWxl
YXNlDQo+PiB0aGUgcGFnZXMgb2YgYSBNUFdRRSAobXVsdGktcGFja2V0IHdvcmsgcXVldWUgZWxl
bWVudCksIHdoaWNoIGlzDQo+PiBpbXBsZW1lbnRlZCBhcyB4c2tfdW1lbV9mcV9yZXVzZSBmb3Ig
dGhlIGNhc2Ugb2YgWFNLLiBXZSBhdm9pZCBleHRyYQ0KPj4gb3ZlcmhlYWQgYnkgdXNpbmcgdGhl
IGZhY3QgdGhhdCBwYWNrZXQgPT0gcGFnZS4NCj4+DQo+PiAyLjIuIG1seDVlX2ZyZWVfeGRwc3Ff
ZGVzYyBwZXJmb3JtcyBjbGVhbnVwIGFmdGVyIFhEUCB0cmFuc21pdHMuIEluIGNhc2UNCj4+IG9m
IFhEUF9UWCwgd2UgY2FuIGZyZWUvcmVjeWNsZSB0aGUgcGFnZXMgd2l0aG91dCBoYXZpbmcgYSBy
ZWZjb3VudA0KPj4gb3ZlcmhlYWQsIGJ5IHVzaW5nIHRoZSBmYWN0IHRoYXQgcGFja2V0ID09IHBh
Z2UuDQoNCg==
