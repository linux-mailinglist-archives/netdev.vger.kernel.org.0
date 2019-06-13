Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 069B44393F
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387746AbfFMPMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:12:37 -0400
Received: from mail-eopbgr20044.outbound.protection.outlook.com ([40.107.2.44]:17659
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732281AbfFMNqf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 09:46:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C635XuN979G4I8UZ5uWWx6qYEzVoEuo2Jvx9YIRQwA4=;
 b=UBpiflv+e3sU0VDBqQViH/dsZyqGDPytXLqSQzQwW4hXVFFVlrC0N4H6c1bTq8PAmhDYgcIpVs+9O/g8Xoemk+DuPDb5XpY3/cRWq4QWF/h9BwUd0JC1bfl5VReS0UACQzqWWRsLAiuZSwilNRAlnunSL7vp1vcHtHXs3AZq8MU=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3187.eurprd05.prod.outlook.com (10.171.186.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Thu, 13 Jun 2019 13:46:30 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::1180:59ab:b53a:a27f]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::1180:59ab:b53a:a27f%3]) with mapi id 15.20.1965.017; Thu, 13 Jun 2019
 13:46:29 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>,
        "nst-kernel@redhat.com" <nst-kernel@redhat.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>,
        Kevin Darbyshire-Bryant <kevin@darbyshire-bryant.me.uk>
Subject: Re: [PATCH net-next 1/3] net/sched: Introduce action ct
Thread-Topic: [PATCH net-next 1/3] net/sched: Introduce action ct
Thread-Index: AQHVIFmsY/4/azwa5kOjF2Jw4P/H36aWexsAgAAEYgCAABY5AIAABU8AgABLRICAArXMgA==
Date:   Thu, 13 Jun 2019 13:46:29 +0000
Message-ID: <4b2dfcb1-47b2-647f-a2d9-a6722f1af9b3@mellanox.com>
References: <1560259713-25603-1-git-send-email-paulb@mellanox.com>
 <1560259713-25603-2-git-send-email-paulb@mellanox.com>
 <87d0jkgr3r.fsf@toke.dk> <da87a939-9000-8371-672a-a949f834caea@mellanox.com>
 <877e9sgmp1.fsf@toke.dk> <20190611155350.GC3436@localhost.localdomain>
 <87pnnjg9ce.fsf@toke.dk>
In-Reply-To: <87pnnjg9ce.fsf@toke.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P193CA0130.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::35) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 262a61a8-fb01-4aaa-3b04-08d6f0058999
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3187;
x-ms-traffictypediagnostic: AM4PR05MB3187:
x-microsoft-antispam-prvs: <AM4PR05MB31877D4587649E413D5522FFCFEF0@AM4PR05MB3187.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(136003)(39860400002)(396003)(346002)(189003)(199004)(8676002)(4326008)(81166006)(8936002)(81156014)(186003)(86362001)(26005)(31686004)(316002)(52116002)(36756003)(256004)(31696002)(99286004)(71190400001)(71200400001)(14454004)(6436002)(386003)(6506007)(25786009)(6486002)(53546011)(6512007)(305945005)(7736002)(76176011)(54906003)(110136005)(68736007)(478600001)(6246003)(64756008)(53936002)(7416002)(2906002)(476003)(11346002)(446003)(2616005)(5660300002)(66066001)(486006)(6116002)(229853002)(73956011)(102836004)(3846002)(66946007)(66556008)(66476007)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3187;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 32HxD8gsJtZFppL3qgFkUS3YfpSJ3ycPL2utpoG88bw0pF5UPyEXYNHFb7rV4n4QwhNb2+gAyr5FqYIJgT3TcntNQajTF6v9X5fepXFu5o+/CMRggwQa+oQezH0A5stb9SaYuGga8YL+scLM7lDTkhWPTRh6UQlYWghUq3LUfn2qF3Il8Q3HP/pFf7XEnGVBapL+0VJK9+NdB4B7Gu1BPHrAbe8WIQTFin+5+pAltUETcbGyMabG9XWeTZXa2hS3gpZFWAM7ichvl00dxNLVE5LR3xdOU7vYlIwIyjMXpLwElXkE7mhLeCF1o6iC0v3NJh93Y3/xs8pLHXpZBBSrZY6GVZ2YbGD0pj1+M3CdUBbWIV/KdIfNFSNrZ/zfH0r821B+OlksemfkeC12fO0DU0SasJ4dkzCv8l54RTgjwbY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E450A8C94538A45B4C689666F146E1D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 262a61a8-fb01-4aaa-3b04-08d6f0058999
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 13:46:29.8384
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: paulb@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3187
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA2LzExLzIwMTkgMTE6MjMgUE0sIFRva2UgSMO4aWxhbmQtSsO4cmdlbnNlbiB3cm90ZToN
Cj4gTWFyY2VsbyBSaWNhcmRvIExlaXRuZXIgPG1hcmNlbG8ubGVpdG5lckBnbWFpbC5jb20+IHdy
aXRlczoNCj4NCj4+IE9uIFR1ZSwgSnVuIDExLCAyMDE5IGF0IDA1OjM0OjUwUE0gKzAyMDAsIFRv
a2UgSMO4aWxhbmQtSsO4cmdlbnNlbiB3cm90ZToNCj4+PiBQYXVsIEJsYWtleSA8cGF1bGJAbWVs
bGFub3guY29tPiB3cml0ZXM6DQo+Pj4NCj4+Pj4gT24gNi8xMS8yMDE5IDQ6NTkgUE0sIFRva2Ug
SMO4aWxhbmQtSsO4cmdlbnNlbiB3cm90ZToNCj4+Pj4+IFBhdWwgQmxha2V5IDxwYXVsYkBtZWxs
YW5veC5jb20+IHdyaXRlczoNCj4+Pj4+DQo+Pj4+Pj4gQWxsb3cgc2VuZGluZyBhIHBhY2tldCB0
byBjb25udHJhY2sgYW5kIHNldCBjb25udHJhY2sgem9uZSwgbWFyaywNCj4+Pj4+PiBsYWJlbHMg
YW5kIG5hdCBwYXJhbWV0ZXJzLg0KPj4+Pj4gSG93IGlzIHRoaXMgZGlmZmVyZW50IGZyb20gdGhl
IG5ld2x5IG1lcmdlZCBjdGluZm8gYWN0aW9uPw0KPj4+Pj4NCj4+Pj4+IC1Ub2tlDQo+Pj4+IEhp
LA0KPj4+Pg0KPj4+PiBjdGluZm8gZG9lcyBvbmUgb2YgdHdvIHZlcnkgc3BlY2lmaWMgdGhpbmdz
LA0KPj4+Pg0KPj4+PiAxKSBjb3BpZXMgRFNDUCB2YWx1ZXMgdGhhdCBoYXZlIGJlZW4gcGxhY2Vk
IGluIHRoZSBmaXJld2FsbCBjb25udHJhY2sNCj4+Pj4gbWFyayBiYWNrIGludG8gdGhlIElQdjQv
djYgZGlmZnNlcnYgZmllbGQNCj4+Pj4NCj4+Pj4gMikgY29waWVzIHRoZSBmaXJld2FsbCBjb25u
dHJhY2sgbWFyayB0byB0aGUgc2tiJ3MgbWFyayBmaWVsZCAobGlrZQ0KPj4+PiBhY3RfY29ubm1h
cmspDQo+Pj4+DQo+Pj4+IE9yaWdpbmFsbHkgY3RpbmZvIGFjdGlvbiB3YXMgbmFtZWQgY29ubmRz
Y3AgKHRoZW4gY29ubnRyYWNrLCB3aGljaCBpcw0KPj4+PiB3aGF0IG91ciBjdCBzaG9ydGhhbmQg
c3RhbmRzIGZvcikuDQo+Pj4+DQo+Pj4+IFdlIGFsc28gdGFsa2VkIGFib3V0IG1lcmdpbmcgYm90
aCBhdCBzb21lIHBvaW50LCBidXQgdGhleSBzZWVtIG9ubHkNCj4+Pj4gY29pbmNpZGVudGFsbHkg
cmVsYXRlZC4NCj4+PiBXZWxsLCBJJ20gcHJlZGljdGluZyBpdCB3aWxsIGNyZWF0ZSBzb21lIGNv
bmZ1c2lvbiB0byBoYXZlIHRoZW0gc28NCj4+PiBjbG9zZWx5IG5hbWVkLi4uIE5vdCBzdXJlIHdo
YXQgdGhlIGJlc3Qgd2F5IHRvIGZpeCB0aGF0IGlzLCB0aG91Z2guLi4/DQo+PiBJIGhhZCBzdWdn
ZXN0ZWQgdG8gbGV0IGFjdF9jdCBoYW5kbGUgdGhlIGFib3ZlIGFzIHdlbGwsIGFzIHRoZXJlIGlz
IGENCj4+IGJpZyBjaHVuayBvZiBjb2RlIG9uIGJvdGggdGhhdCBpcyBwcmV0dHkgc2ltaWxhci4g
VGhlcmUgaXMgcXVpdGUgc29tZQ0KPj4gYm9pbGVycGxhdGUgZm9yIGludGVyZmFjaW5nIHdpdGgg
Y29ubnRyYWNrIHdoaWNoIGlzIGR1cGxpY2F0ZWQuDQo+PiBCdXQgaXQgd2FzIGNvbnNpZGVyZWQg
dGhhdCB0aGUgZW5kIGFjdGlvbnMgYXJlIHVucmVsYXRlZCwgYW5kIGN0aW5mbw0KPj4gd2VudCBh
aGVhZC4gKEknbSBzdGlsbCBub3QgY29udmluY2VkIG9mIHRoYXQsIGJ0dykNCj4+DQo+PiBPdGhl
ciB0aGFuIHRoaXMsIHdoaWNoIGlzIG5vdCBhbiBvcHRpb24gYW55bW9yZSwgSSBkb24ndCBzZWUg
YSB3YXkgdG8NCj4+IGF2b2lkIGNvbmZ1c2lvbiBoZXJlLiBTZWVtcyBhbnl0aGluZyB3ZSBwaWNr
IG5vdyB3aWxsIGJlIGNvbmZ1c2luZw0KPj4gYmVjYXVzZSBjdGluZm8gaXMgYSBnZW5lcmljIG5h
bWUsIGFuZCB3ZSBhbHNvIG5lZWQgb25lIGhlcmUuDQo+IEhtbSwgeWVhaCwgZHVubm8gaWYgSSBo
YXZlIGFueSBiZXR0ZXIgaWRlYXMgZm9yIG5hbWluZyB0aGF0IHdvdWxkIGF2b2lkDQo+IHRoaXMu
IGFjdF9ydW5jdCA/IE1laC4uLg0KPg0KPiAtVG9rZQ0KDQoNCklmIGl0J3MgZmluZSB3aXRoIHlv
dSBndXlzLCBjYW4gd2Uga2VlcCB0aGUgbmFtZSBhY3RfY3QgPyA6KQ0KDQo=
