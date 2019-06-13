Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA7FC4394A
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732277AbfFMPMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:12:54 -0400
Received: from mail-eopbgr30077.outbound.protection.outlook.com ([40.107.3.77]:27566
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732273AbfFMNjp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 09:39:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A007ruWKS7OeMFW+0pOAZRTRQmzy5lmFAi00O2n9kwc=;
 b=nYh5SjiLdkJcuUJylTcCBEecFqg7kVZYJJJQ1/uX5l8bkQ2Mpx/o+Y0EufE87j3brgbFSvt9Um7nm+mTeajxIpd8Xcmi/weI/lDrlY134HW9x4pBoK9py0ighR35gAQWln0k4xtZjkg1eeLlPyOUzUnmaqB/KAXlRwpSJyjoHCY=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3444.eurprd05.prod.outlook.com (10.171.187.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Thu, 13 Jun 2019 13:39:39 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::1180:59ab:b53a:a27f]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::1180:59ab:b53a:a27f%3]) with mapi id 15.20.1965.017; Thu, 13 Jun 2019
 13:39:39 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Florian Westphal <fw@strlen.de>
CC:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>,
        "nst-kernel@redhat.com" <nst-kernel@redhat.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>
Subject: Re: [PATCH net-next 1/3] net/sched: Introduce action ct
Thread-Topic: [PATCH net-next 1/3] net/sched: Introduce action ct
Thread-Index: AQHVIFmsY/4/azwa5kOjF2Jw4P/H36aYcPAAgAEpPIA=
Date:   Thu, 13 Jun 2019 13:39:39 +0000
Message-ID: <82dc3cd1-15e3-927a-4203-88071fecda75@mellanox.com>
References: <1560259713-25603-1-git-send-email-paulb@mellanox.com>
 <1560259713-25603-2-git-send-email-paulb@mellanox.com>
 <20190612195544.zouhfq7xd56fqyhm@breakpoint.cc>
In-Reply-To: <20190612195544.zouhfq7xd56fqyhm@breakpoint.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR06CA0022.eurprd06.prod.outlook.com
 (2603:10a6:20b:14::35) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: efc5b1ad-fcad-4186-660d-08d6f00494d5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3444;
x-ms-traffictypediagnostic: AM4PR05MB3444:
x-microsoft-antispam-prvs: <AM4PR05MB34441B1B96EA58580D4CB309CFEF0@AM4PR05MB3444.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(136003)(346002)(376002)(39860400002)(189003)(199004)(71190400001)(53936002)(6916009)(71200400001)(7416002)(26005)(446003)(7736002)(31696002)(476003)(2616005)(36756003)(11346002)(316002)(256004)(14444005)(86362001)(8936002)(2906002)(73956011)(305945005)(81166006)(81156014)(8676002)(31686004)(186003)(66066001)(66946007)(486006)(64756008)(66556008)(66446008)(66476007)(478600001)(6436002)(52116002)(76176011)(99286004)(229853002)(54906003)(6486002)(6246003)(14454004)(3846002)(68736007)(102836004)(6116002)(5660300002)(25786009)(4326008)(53546011)(386003)(6512007)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3444;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +d27lDp98m6YPBvm3wSbAKf5RRf3r7FwOukvrdjcLdYfg9aOxdEoZ4mTbjczKal3I7Fy03lE9uSkFXAOoGNCBqRhMH9o3C0/xcoixKRg5vIdx3fyyz7o2ruDm4W+tgp2N5TVrc7kDTvK2smnkwrm1pvDmZ8jae3SHJS2APrrm9MOuTd2r16ltc/dYsJneknDJqE6BkUjBVmD4KbBX2FkVVMx0dqDPDwdjCkwE04fZBy5Z3hukCT4UCXRwJ/y4xTiqC+bJl4Y+P21/vkiuL2P7RELc6lzCELwYP3m5nuU8irViW6MyJE3ghf9F6ORHjU0nIN+ltge3ExFT5V4u+bLaI3m9WkTRQVnhZLtWsTGM6XojrKQQidtYWB4ldFjJ1zxM562wsAak5eKQmEP34snHjz6O98Ajw3vRhfw/dpVWPk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A075A6E8EC92C84C98E6FE3E6878FE4C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efc5b1ad-fcad-4186-660d-08d6f00494d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 13:39:39.1919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: paulb@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3444
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA2LzEyLzIwMTkgMTA6NTUgUE0sIEZsb3JpYW4gV2VzdHBoYWwgd3JvdGU6DQo+IFBhdWwg
Qmxha2V5IDxwYXVsYkBtZWxsYW5veC5jb20+IHdyb3RlOg0KPj4gKwkvKiBUaGUgY29ubnRyYWNr
IG1vZHVsZSBleHBlY3RzIHRvIGJlIHdvcmtpbmcgYXQgTDMuICovDQo+IEl0IGFsc28gZXhwZWN0
cyB0aGF0IElQIHN0YWNrIGhhcyB2YWxpZGF0ZWQgaXAodjYpDQo+IGhlYWRlcnMgYW5kIGhhcyBw
dWxsZWQgdGhlIGlwIGhlYWRlciBpbnRvIGxpbmVhciBhcmVhLg0KPg0KPiBXaGF0IGFyZSB5b3Vy
IHBsYW5zIHdydC4gSVAgZnJhZ21lbnRzPyBBRkFJQ1MgcmlnaHQgbm93IHRoZXkgd2lsbA0KPiBu
b3QgbWF0Y2ggd2hpY2ggbWVhbnMgdGhleSB3b24ndCBiZSBOQVRlZCBlaXRoZXIuICBJcyB0aGF0
IG9rPw0KDQpSaWdodCwgSSdsbCBhZGQgZGVmcmFnbWVudCB2aWEgbmZfY3RfaXB2NF9nYXRoZXJf
ZnJhZ3MgYW5kIA0KbmZfY3RfZnJhZzZfZ2F0aGVyLCB3aGljaA0KDQppcyBiYXNpY2FsbHkgd2hh
dCBjb25udHJhY2tfYnJpZGdlIGFuZCBvcGVudnN3aXRjaC9jb25udHJhY2suYyBkb2VzIHdpdGgg
DQppdCdzIGNhbGxzLg0KDQo+IEZvciBvZmZsb2FkaW5nIGNvbm5lY3Rpb24gdHJhY2tpbmcgYW5k
IE5BVCwgSSB0aGluayB0aGUgZmxvd3RhYmxlDQo+IGluZnJhc3RydWN0dXJlIGlzIG11Y2ggYmV0
dGVyOiBpdCB3aWxsIGFsbG93IGFueSBkZXZpY2UgdG8gcHVzaCBwYWNrZXRzDQo+IHRoYXQgaXQg
Y2FuJ3QgZGVhbCB3aXRoIChmcmFnbWVudGVkLCB0b28gbGFyZ2UgbXR1LCBjaGFuZ2VkIHJvdXRl
LCBldGMpDQo+IHRvIHRoZSBzb2Z0d2FyZSBwYXRoIGFuZCBjb25udHJhY2sgd2lsbCBiZSBhd2Fy
ZSBpdHMgZGVhbGluZyB3aXRoIGEgZmxvdw0KPiB0aGF0IHdhcyBvZmZsb2FkZWQsIGUuZy4gaXQg
d2lsbCBlbGlkZSBzZXF1ZW5jZSBudW1iZXIgY2hlY2tzLg0KDQpUaGF0IHN0aWxsIGJlIHRoZSBj
YXNlLCBMYXRlciwgaGFyZHdhcmUgb2ZmbG9hZCBmb3IgdGhpcyB0YyBydWxlcyB3aWxsIA0Kbm90
IG9mZmxvYWQgZnJhZ21lbnRlZCBwYWNrZXRzICh1bmxlc3MgdGhleSBzb21laG93IHN1cHBvcnQg
aXQpDQoNCmFuZCB0aGV5IHdpbGwgYmUgZGVmcmFnbWVudGVkIGluIGFjdF9jdC5jIGFuZCBvbmx5
IHRoZW4gd2lsbCBwYXNzIHRoaXMgDQphY3Rpb24uDQoNClN1Y2ggb2ZmbG9hZGVkIGNvbm5lY3Rp
b25zIHdpbGwgYmUgbWFya2VkIGFzIHN1Y2ggYW5kIHNvIG5ldGZpbHRlciBjYW4gDQpza2lwIHNl
cSBudW1iZXIgY2hlY2tpbmcuDQoNCj4gRm9yIGNvbm5lY3Rpb24gdHJhY2tpbmcgb24gTDIsIFBh
YmxvIHJlY2VudGx5IGFkZGVkIGNvbm50cmFjayBmb3INCj4gY2xhc3NpYyBicmlkZ2UgKHdpdGhv
dXQgdGhlICdjYWxsLWlwdGFibGVzJyBpbmZyYXN0cnVjdHVyZSksIHNlZQ0KPiBuZXQvYnJpZGdl
L25ldGZpbHRlci9uZl9jb25udHJhY2tfYnJpZGdlLmMgKGVzcGVjaWFsbHkgdGhlIGRlZnJhZy9y
ZWZyYWcNCj4gYW5kIGhlYWRlciB2YWxpZGF0aW9uIGl0cyBkb2luZykuDQo+DQo+IEkgc3VzcGVj
dCBwYXJ0cyBvZiB0aGF0IGFyZSBhbHNvIG5lZWRlZCBpbiB0aGUgY29ubnRyYWNrIGFjdGlvbiAo
eW91DQo+IG1pZ2h0IGJlIGFibGUgdG8gcmV1c2UvZXhwb3J0IHNvbWUgb2YgdGhlIGZ1bmN0aW9u
YWxpdHkgSSB0aGluaykuDQo=
