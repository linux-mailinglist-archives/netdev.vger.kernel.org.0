Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B366789176
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 12:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfHKKq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 06:46:59 -0400
Received: from mail-eopbgr60071.outbound.protection.outlook.com ([40.107.6.71]:40566
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725813AbfHKKq6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Aug 2019 06:46:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CfRjmJFsxkv2MI3OdndB5NaeGhtcxNhOE4WaXhr3zkvKXfAPPM1NkdBrLhze+A63jSGOsTSZ3yEe4YGnAQsa7kIU3Q4V7mb2VSXJrCf1+o1x5D3AXcfUa4Dhz3ZLjFGLU1veV7AVDnrtLmJnByjIM6TEwF9AfmNHSDp7AcPiLIow/oECgH9ffcLp9L1dh0I7P671cn4OMTaPCAiBiRfHuCVDl1LYPGaV/kOWwYMTbfGd3RNTWxNA7n0sxwuJXtFUoOkQ9Hxm4AUx2TDh6ITwDFfvcxfnlG+zYjQEawCyY0x7BJ0wgcqmgP6aTxbjIJ90mIb1yZ3ICbJwtPw1lu3sWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZVPBfRvgzhMW9qpMFY8EOb6J+QDFiKhQ+3fYcHP1Wbo=;
 b=LU4JVlNEqwa4vmA1Q4Vg2jBnC+bETyJDOL7HSa35JDOxOQhkhA6F7lkHVvtxZa8Wof7F+GcggvgvdcCNLZcPs44Aj3q3mHYzf3Y11jxktrFNRauk9k37DDEWatf6KkY83gD1zdmb7JEg8Ojon4Xgfy00w34t9OSu+oHbpjmUMFdbaxaGILS86oMnyz4RRgCfq6FZEM9cL/hgEGJ4/gWItiCADXcdT3AngrxEgnB7QmOfIEgqSDwVo+w9fzZM1LESnmDn1HUyi7jIybhPwuQrdG+AKoUkoSDGvA6wG9BBI/Qvmm7tX6+5kC03pjSOuYahEqcgTdZqmGRGiTTy9fX7Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZVPBfRvgzhMW9qpMFY8EOb6J+QDFiKhQ+3fYcHP1Wbo=;
 b=EgS1rBsq/L99N4PemBxR+EfgZmhCc4N445SKTtUxeC6EaddGwtOJyWaT2hyUP263tQ4FAhX4VqsWuKHZ920wNhfrghk8X1BJt9xTNCHfd4tBlNtlE8WslaTehgNb/f1KJtdFHLsIOblCXIV9AsP9bR2BQWvaT460mOI/zJj+i8U=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3396.eurprd05.prod.outlook.com (10.171.187.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.23; Sun, 11 Aug 2019 10:46:49 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::d027:14a2:95db:6f1f]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::d027:14a2:95db:6f1f%7]) with mapi id 15.20.2157.022; Sun, 11 Aug 2019
 10:46:49 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Pravin Shelar <pshelar@ovn.org>
CC:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Justin Pettit <jpettit@nicira.com>,
        Simon Horman <simon.horman@netronome.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
Subject: Re: [PATCH net-next] net: openvswitch: Set OvS recirc_id from tc
 chain index
Thread-Topic: [PATCH net-next] net: openvswitch: Set OvS recirc_id from tc
 chain index
Thread-Index: AQHVTRjlJ4rvN3xFsU2F7hr1t29bFqbxvIIAgAQNcAA=
Date:   Sun, 11 Aug 2019 10:46:49 +0000
Message-ID: <b5342e56-4baa-97ab-8694-2f48d012afca@mellanox.com>
References: <1565179722-22488-1-git-send-email-paulb@mellanox.com>
 <CAOrHB_DhfiQy8RwTiwgn9ZXgsd5j2f0ynZPUP4wf-xzhjwo8kg@mail.gmail.com>
In-Reply-To: <CAOrHB_DhfiQy8RwTiwgn9ZXgsd5j2f0ynZPUP4wf-xzhjwo8kg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR1PR01CA0031.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::44) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5ef3c846-2ae0-4908-baa2-08d71e493678
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3396;
x-ms-traffictypediagnostic: AM4PR05MB3396:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB33967F765363F2F008203D31CFD00@AM4PR05MB3396.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0126A32F74
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(396003)(346002)(39850400004)(199004)(189003)(4326008)(229853002)(14454004)(6486002)(6436002)(107886003)(6246003)(6512007)(14444005)(31686004)(25786009)(6916009)(256004)(64756008)(5660300002)(66446008)(66946007)(66476007)(66556008)(66066001)(71200400001)(71190400001)(8936002)(7736002)(52116002)(305945005)(86362001)(31696002)(54906003)(316002)(81156014)(81166006)(2906002)(8676002)(99286004)(53936002)(36756003)(3846002)(6116002)(478600001)(186003)(26005)(6506007)(386003)(102836004)(76176011)(11346002)(446003)(53546011)(486006)(476003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3396;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FpYisAgYo6lS7/UkkQbGu18KIBAd0JqMrOaWsda5cuPIPD6NzwcuNZLWjM+7gfLhP0UR49YOD2FUrr8bDaIA7mnZ9E32RsMpCr5YZuOkmlr1fhrmkw49aDp910CA3/4j+e1K/9Yl+zorYjivre+lMJyBrNOuky5V7zb1n43KlnI62MQaEfdKy07OXvt9t2azlEJ3JE57O7oRnLYTgP5v0z3PNMRGHrclw4vbloDwDnE3ZONB+OdfJI6BpndJndkyORIoWpNLDOHncsnFlBicXz29cf7ceQkpiKjdhV5uKmZ/4tXVyn+yD1OCOT5VgcchHSxp9cHKs9ncYCZwEXnrFUiurAIdfCFCToJdqbjs2JU+4Z8aqsU6QamwIWjHytTAPkdUW+9G/WywQSDScQh/x9EIyWgTUeoyy48pmKkHuN0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E2C608D19419244A9BD23532E90DFC20@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ef3c846-2ae0-4908-baa2-08d71e493678
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2019 10:46:49.3291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OHP9m11/HWDr8OsJDH3j1Hp1fkwLHyrXKHKwQyC9oAeDfQAHtE6zC8WUsV9o+u2+s93giY4kjV2YaClzWbfmYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3396
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA4LzgvMjAxOSAxMTo1MyBQTSwgUHJhdmluIFNoZWxhciB3cm90ZToNCj4gT24gV2VkLCBB
dWcgNywgMjAxOSBhdCA1OjA4IEFNIFBhdWwgQmxha2V5IDxwYXVsYkBtZWxsYW5veC5jb20+IHdy
b3RlOg0KPj4gT2ZmbG9hZGVkIE92UyBkYXRhcGF0aCBydWxlcyBhcmUgdHJhbnNsYXRlZCBvbmUg
dG8gb25lIHRvIHRjIHJ1bGVzLA0KPj4gZm9yIGV4YW1wbGUgdGhlIGZvbGxvd2luZyBzaW1wbGlm
aWVkIE92UyBydWxlOg0KPj4NCj4+IHJlY2lyY19pZCgwKSxpbl9wb3J0KGRldjEpLGV0aF90eXBl
KDB4MDgwMCksY3Rfc3RhdGUoLXRyaykgYWN0aW9uczpjdCgpLHJlY2lyYygyKQ0KPj4NCj4+IFdp
bGwgYmUgdHJhbnNsYXRlZCB0byB0aGUgZm9sbG93aW5nIHRjIHJ1bGU6DQo+Pg0KPj4gJCB0YyBm
aWx0ZXIgYWRkIGRldiBkZXYxIGluZ3Jlc3MgXA0KPj4gICAgICAgICAgICAgIHByaW8gMSBjaGFp
biAwIHByb3RvIGlwIFwNCj4+ICAgICAgICAgICAgICAgICAgZmxvd2VyIHRjcCBjdF9zdGF0ZSAt
dHJrIFwNCj4+ICAgICAgICAgICAgICAgICAgYWN0aW9uIGN0IHBpcGUgXA0KPj4gICAgICAgICAg
ICAgICAgICBhY3Rpb24gZ290byBjaGFpbiAyDQo+Pg0KPj4gUmVjZWl2ZWQgcGFja2V0cyB3aWxs
IGZpcnN0IHRyYXZlbCB0aG91Z2ggdGMsIGFuZCBpZiB0aGV5IGFyZW4ndCBzdG9sZW4NCj4+IGJ5
IGl0LCBsaWtlIGluIHRoZSBhYm92ZSBydWxlLCB0aGV5IHdpbGwgY29udGludWUgdG8gT3ZTIGRh
dGFwYXRoLg0KPj4gU2luY2Ugd2UgYWxyZWFkeSBkaWQgc29tZSBhY3Rpb25zIChhY3Rpb24gY3Qg
aW4gdGhpcyBjYXNlKSB3aGljaCBtaWdodA0KPj4gbW9kaWZ5IHRoZSBwYWNrZXRzLCBhbmQgdXBk
YXRlZCBhY3Rpb24gc3RhdHMsIHdlIHdvdWxkIGxpa2UgdG8gY29udGludWUNCj4+IHRoZSBwcm9j
Y2Vzc2luZyB3aXRoIHRoZSBjb3JyZWN0IHJlY2lyY19pZCBpbiBPdlMgKGhlcmUgcmVjaXJjX2lk
KDIpKQ0KPj4gd2hlcmUgd2UgbGVmdCBvZmYuDQo+Pg0KPj4gVG8gc3VwcG9ydCB0aGlzLCBpbnRy
b2R1Y2UgYSBuZXcgc2tiIGV4dGVuc2lvbiBmb3IgdGMsIHdoaWNoDQo+PiB3aWxsIGJlIHVzZWQg
Zm9yIHRyYW5zbGF0aW5nIHRjIGNoYWluIHRvIG92cyByZWNpcmNfaWQgdG8NCj4+IGhhbmRsZSB0
aGVzZSBtaXNzIGNhc2VzLiBMYXN0IHRjIGNoYWluIGluZGV4IHdpbGwgYmUgc2V0DQo+PiBieSB0
YyBnb3RvIGNoYWluIGFjdGlvbiBhbmQgcmVhZCBieSBPdlMgZGF0YXBhdGguDQo+Pg0KPj4gU2ln
bmVkLW9mZi1ieTogUGF1bCBCbGFrZXkgPHBhdWxiQG1lbGxhbm94LmNvbT4NCj4+IFNpZ25lZC1v
ZmYtYnk6IFZsYWQgQnVzbG92IDx2bGFkYnVAbWVsbGFub3guY29tPg0KPj4gQWNrZWQtYnk6IEpp
cmkgUGlya28gPGppcmlAbWVsbGFub3guY29tPg0KPj4gLS0tDQo+PiAgIGluY2x1ZGUvbGludXgv
c2tidWZmLmggICAgfCAxMyArKysrKysrKysrKysrDQo+PiAgIGluY2x1ZGUvbmV0L3NjaF9nZW5l
cmljLmggfCAgNSArKysrLQ0KPj4gICBuZXQvY29yZS9za2J1ZmYuYyAgICAgICAgIHwgIDYgKysr
KysrDQo+PiAgIG5ldC9vcGVudnN3aXRjaC9mbG93LmMgICAgfCAgOSArKysrKysrKysNCj4+ICAg
bmV0L3NjaGVkL0tjb25maWcgICAgICAgICB8IDEzICsrKysrKysrKysrKysNCj4+ICAgbmV0L3Nj
aGVkL2FjdF9hcGkuYyAgICAgICB8ICAxICsNCj4+ICAgbmV0L3NjaGVkL2Nsc19hcGkuYyAgICAg
ICB8IDEyICsrKysrKysrKysrKw0KPj4gICA3IGZpbGVzIGNoYW5nZWQsIDU4IGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb24oLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9za2J1
ZmYuaCBiL2luY2x1ZGUvbGludXgvc2tidWZmLmgNCj4+IGluZGV4IDNhZWY4ZDguLmZiMmE3OTIg
MTAwNjQ0DQo+PiAtLS0gYS9pbmNsdWRlL2xpbnV4L3NrYnVmZi5oDQo+PiArKysgYi9pbmNsdWRl
L2xpbnV4L3NrYnVmZi5oDQo+PiBAQCAtMjc5LDYgKzI3OSwxNiBAQCBzdHJ1Y3QgbmZfYnJpZGdl
X2luZm8gew0KPj4gICB9Ow0KPj4gICAjZW5kaWYNCj4+DQo+PiArI2lmIElTX0VOQUJMRUQoQ09O
RklHX05FVF9UQ19TS0JfRVhUKQ0KPj4gKy8qIENoYWluIGluIHRjX3NrYl9leHQgd2lsbCBiZSB1
c2VkIHRvIHNoYXJlIHRoZSB0YyBjaGFpbiB3aXRoDQo+PiArICogb3ZzIHJlY2lyY19pZC4gSXQg
d2lsbCBiZSBzZXQgdG8gdGhlIGN1cnJlbnQgY2hhaW4gYnkgdGMNCj4+ICsgKiBhbmQgcmVhZCBi
eSBvdnMgdG8gcmVjaXJjX2lkLg0KPj4gKyAqLw0KPj4gK3N0cnVjdCB0Y19za2JfZXh0IHsNCj4+
ICsgICAgICAgX191MzIgY2hhaW47DQo+PiArfTsNCj4+ICsjZW5kaWYNCj4+ICsNCj4+ICAgc3Ry
dWN0IHNrX2J1ZmZfaGVhZCB7DQo+PiAgICAgICAgICAvKiBUaGVzZSB0d28gbWVtYmVycyBtdXN0
IGJlIGZpcnN0LiAqLw0KPj4gICAgICAgICAgc3RydWN0IHNrX2J1ZmYgICpuZXh0Ow0KPj4gQEAg
LTQwNTAsNiArNDA2MCw5IEBAIGVudW0gc2tiX2V4dF9pZCB7DQo+PiAgICNpZmRlZiBDT05GSUdf
WEZSTQ0KPj4gICAgICAgICAgU0tCX0VYVF9TRUNfUEFUSCwNCj4+ICAgI2VuZGlmDQo+PiArI2lm
IElTX0VOQUJMRUQoQ09ORklHX05FVF9UQ19TS0JfRVhUKQ0KPj4gKyAgICAgICBUQ19TS0JfRVhU
LA0KPj4gKyNlbmRpZg0KPj4gICAgICAgICAgU0tCX0VYVF9OVU0sIC8qIG11c3QgYmUgbGFzdCAq
Lw0KPj4gICB9Ow0KPj4NCj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9zY2hfZ2VuZXJpYy5o
IGIvaW5jbHVkZS9uZXQvc2NoX2dlbmVyaWMuaA0KPj4gaW5kZXggNmI2YjAxMi4uODcxZmVlYSAx
MDA2NDQNCj4+IC0tLSBhL2luY2x1ZGUvbmV0L3NjaF9nZW5lcmljLmgNCj4+ICsrKyBiL2luY2x1
ZGUvbmV0L3NjaF9nZW5lcmljLmgNCj4+IEBAIC0yNzUsNyArMjc1LDEwIEBAIHN0cnVjdCB0Y2Zf
cmVzdWx0IHsNCj4+ICAgICAgICAgICAgICAgICAgICAgICAgICB1bnNpZ25lZCBsb25nICAgY2xh
c3M7DQo+PiAgICAgICAgICAgICAgICAgICAgICAgICAgdTMyICAgICAgICAgICAgIGNsYXNzaWQ7
DQo+PiAgICAgICAgICAgICAgICAgIH07DQo+PiAtICAgICAgICAgICAgICAgY29uc3Qgc3RydWN0
IHRjZl9wcm90byAqZ290b190cDsNCj4+ICsgICAgICAgICAgICAgICBzdHJ1Y3Qgew0KPj4gKyAg
ICAgICAgICAgICAgICAgICAgICAgY29uc3Qgc3RydWN0IHRjZl9wcm90byAqZ290b190cDsNCj4+
ICsgICAgICAgICAgICAgICAgICAgICAgIHUzMiBnb3RvX2luZGV4Ow0KPj4gKyAgICAgICAgICAg
ICAgIH07DQo+Pg0KPj4gICAgICAgICAgICAgICAgICAvKiB1c2VkIGluIHRoZSBza2JfdGNfcmVp
bnNlcnQgZnVuY3Rpb24gKi8NCj4+ICAgICAgICAgICAgICAgICAgc3RydWN0IHsNCj4+IGRpZmYg
LS1naXQgYS9uZXQvY29yZS9za2J1ZmYuYyBiL25ldC9jb3JlL3NrYnVmZi5jDQo+PiBpbmRleCBl
YThlOGQzLi4yYjQwYjVhIDEwMDY0NA0KPj4gLS0tIGEvbmV0L2NvcmUvc2tidWZmLmMNCj4+ICsr
KyBiL25ldC9jb3JlL3NrYnVmZi5jDQo+PiBAQCAtNDA4Nyw2ICs0MDg3LDkgQEAgaW50IHNrYl9n
cm9fcmVjZWl2ZShzdHJ1Y3Qgc2tfYnVmZiAqcCwgc3RydWN0IHNrX2J1ZmYgKnNrYikNCj4+ICAg
I2lmZGVmIENPTkZJR19YRlJNDQo+PiAgICAgICAgICBbU0tCX0VYVF9TRUNfUEFUSF0gPSBTS0Jf
RVhUX0NIVU5LU0laRU9GKHN0cnVjdCBzZWNfcGF0aCksDQo+PiAgICNlbmRpZg0KPj4gKyNpZiBJ
U19FTkFCTEVEKENPTkZJR19ORVRfVENfU0tCX0VYVCkNCj4+ICsgICAgICAgW1RDX1NLQl9FWFRd
ID0gU0tCX0VYVF9DSFVOS1NJWkVPRihzdHJ1Y3QgdGNfc2tiX2V4dCksDQo+PiArI2VuZGlmDQo+
PiAgIH07DQo+Pg0KPj4gICBzdGF0aWMgX19hbHdheXNfaW5saW5lIHVuc2lnbmVkIGludCBza2Jf
ZXh0X3RvdGFsX2xlbmd0aCh2b2lkKQ0KPj4gQEAgLTQwOTgsNiArNDEwMSw5IEBAIHN0YXRpYyBf
X2Fsd2F5c19pbmxpbmUgdW5zaWduZWQgaW50IHNrYl9leHRfdG90YWxfbGVuZ3RoKHZvaWQpDQo+
PiAgICNpZmRlZiBDT05GSUdfWEZSTQ0KPj4gICAgICAgICAgICAgICAgICBza2JfZXh0X3R5cGVf
bGVuW1NLQl9FWFRfU0VDX1BBVEhdICsNCj4+ICAgI2VuZGlmDQo+PiArI2lmIElTX0VOQUJMRUQo
Q09ORklHX05FVF9UQ19TS0JfRVhUKQ0KPj4gKyAgICAgICAgICAgICAgIHNrYl9leHRfdHlwZV9s
ZW5bVENfU0tCX0VYVF0gKw0KPj4gKyNlbmRpZg0KPj4gICAgICAgICAgICAgICAgICAwOw0KPj4g
ICB9DQo+Pg0KPj4gZGlmZiAtLWdpdCBhL25ldC9vcGVudnN3aXRjaC9mbG93LmMgYi9uZXQvb3Bl
bnZzd2l0Y2gvZmxvdy5jDQo+PiBpbmRleCBiYzg5ZTE2Li4wMjg3ZWFkIDEwMDY0NA0KPj4gLS0t
IGEvbmV0L29wZW52c3dpdGNoL2Zsb3cuYw0KPj4gKysrIGIvbmV0L29wZW52c3dpdGNoL2Zsb3cu
Yw0KPj4gQEAgLTgxNiw2ICs4MTYsOSBAQCBzdGF0aWMgaW50IGtleV9leHRyYWN0X21hY19wcm90
byhzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KPj4gICBpbnQgb3ZzX2Zsb3dfa2V5X2V4dHJhY3QoY29u
c3Qgc3RydWN0IGlwX3R1bm5lbF9pbmZvICp0dW5faW5mbywNCj4+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IHN3X2Zsb3dfa2V5ICprZXkpDQo+
PiAgIHsNCj4+ICsjaWYgSVNfRU5BQkxFRChDT05GSUdfTkVUX1RDX1NLQl9FWFQpDQo+PiArICAg
ICAgIHN0cnVjdCB0Y19za2JfZXh0ICp0Y19leHQ7DQo+PiArI2VuZGlmDQo+PiAgICAgICAgICBp
bnQgcmVzLCBlcnI7DQo+Pg0KPj4gICAgICAgICAgLyogRXh0cmFjdCBtZXRhZGF0YSBmcm9tIHBh
Y2tldC4gKi8NCj4+IEBAIC04NDgsNyArODUxLDEzIEBAIGludCBvdnNfZmxvd19rZXlfZXh0cmFj
dChjb25zdCBzdHJ1Y3QgaXBfdHVubmVsX2luZm8gKnR1bl9pbmZvLA0KPj4gICAgICAgICAgaWYg
KHJlcyA8IDApDQo+PiAgICAgICAgICAgICAgICAgIHJldHVybiByZXM7DQo+PiAgICAgICAgICBr
ZXktPm1hY19wcm90byA9IHJlczsNCj4+ICsNCj4+ICsjaWYgSVNfRU5BQkxFRChDT05GSUdfTkVU
X1RDX1NLQl9FWFQpDQo+PiArICAgICAgIHRjX2V4dCA9IHNrYl9leHRfZmluZChza2IsIFRDX1NL
Ql9FWFQpOw0KPj4gKyAgICAgICBrZXktPnJlY2lyY19pZCA9IHRjX2V4dCA/IHRjX2V4dC0+Y2hh
aW4gOiAwOw0KPj4gKyNlbHNlDQo+PiAgICAgICAgICBrZXktPnJlY2lyY19pZCA9IDA7DQo+PiAr
I2VuZGlmDQo+Pg0KPiBNb3N0IG9mIGNhc2VzIHRoZSBjb25maWcgd291bGQgYmUgdHVybmVkIG9u
LCBzbyB0aGUgaWZkZWYgaXMgbm90IHRoYXQNCj4gdXNlZnVsLiBDYW4geW91IGFkZCBzdGF0aWMg
a2V5IHRvIGF2b2lkIHNlYXJjaGluZyB0aGUgc2tiLWV4dCBpbiBub24NCj4gb2ZmbG9hZCBjYXNl
cy4NCg0KSGksDQoNCldoYXQgZG8geW91IG1lYW4gYnkgYSBzdGF0aWMga2V5Pw0KDQo=
