Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5AD89177
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 12:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfHKKsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 06:48:30 -0400
Received: from mail-eopbgr40049.outbound.protection.outlook.com ([40.107.4.49]:64850
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725813AbfHKKsa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Aug 2019 06:48:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nMHuVVxAeLVbVRPL5Cdakji7kpJ3qP9+3B0vGxBq1LEnT+1bODFEm0mj1ZslohkIzVZiUnfPowoVE55z3R5vTb5QwGrLTNPGUQoWay6LDxapRno/Y/KPQQebreldVYkr6BE+LYFMwni6wrun8zkaXLzY32V/megSbB30VRvS1ofhrx/jx6E9Oild+joKWJ3FFPqZuDfPagr+6oMUPkvNyIVOfldLgv5mLgaWBdFRzh38i3UF0W2Hd4v8zE0LdA8ZhmBKCMok9Pm5cAQwvYxuxHJJY2Nbgq/gehBBfw/t3WesR5BWN6yyFeIr3JmuEK4tbtlvHTSsGtpFeabzPy+iLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r9m/TjUSAeVQUVbBbzh5fb0z8irzgCcN4gUXk3iWj/c=;
 b=fJbMrOA6i1JfLEwBh+IbNXIqBkx1ML7KsODdjWTCKXXB2ETKXO7h4dtbemVDB2lDyaeGUHkUT8iL0nCOylCbPsvBzGcM4HJ+rjaSthKye7geFPwDwyMjAVVVz9j0XRXfU+WFlJjvmB35/80MxJU2LY4PxMsOWgEahRIzq299iy5fAoimeHS69T5lcDiTWO8iWTGczumzqvvvcKAbBjZise8bt0FFCklRJiLe9SsUfoG0BCm8s71anybX7y7vQLxziWvDVNdKa1Q5vpHdzxWlbgoEasZvd0GTCSsIz+w6i/VyYma+qChBQW0ZviFPFFL22hSAnra8KvCr6Qmk658egw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r9m/TjUSAeVQUVbBbzh5fb0z8irzgCcN4gUXk3iWj/c=;
 b=FTh/FUU2uTr0iVegb1esylo+YWEL0yzHOjexRoaPaXt4eaKEryCOWGB8ynqDkhaulqZujOTYYfOyTFRl6br4wT9uGX3aihI5BhXaWjOSUXzD/KHB8lZTvfR56edK8blhVfZYGcyviCr/zuOslaziUc3qIA8ChxCDFHTwKQdp0cU=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3249.eurprd05.prod.outlook.com (10.171.188.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.13; Sun, 11 Aug 2019 10:48:23 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::d027:14a2:95db:6f1f]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::d027:14a2:95db:6f1f%7]) with mapi id 15.20.2157.022; Sun, 11 Aug 2019
 10:48:23 +0000
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
Thread-Index: AQHVTRjlJ4rvN3xFsU2F7hr1t29bFqbxvIIAgAQN4AA=
Date:   Sun, 11 Aug 2019 10:48:23 +0000
Message-ID: <84f65441-fd4f-cbe8-3b14-7aed8953ed8e@mellanox.com>
References: <1565179722-22488-1-git-send-email-paulb@mellanox.com>
 <CAOrHB_DhfiQy8RwTiwgn9ZXgsd5j2f0ynZPUP4wf-xzhjwo8kg@mail.gmail.com>
In-Reply-To: <CAOrHB_DhfiQy8RwTiwgn9ZXgsd5j2f0ynZPUP4wf-xzhjwo8kg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR1PR01CA0016.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::29) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51ee0618-069e-4c19-6e2d-08d71e496eb5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR05MB3249;
x-ms-traffictypediagnostic: AM4PR05MB3249:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB3249B618EAB9E81E08D4A975CFD00@AM4PR05MB3249.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0126A32F74
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39850400004)(396003)(376002)(346002)(199004)(189003)(54906003)(7736002)(305945005)(8676002)(316002)(66066001)(6436002)(71200400001)(71190400001)(229853002)(25786009)(107886003)(6486002)(6916009)(53936002)(4326008)(31696002)(5660300002)(6246003)(86362001)(52116002)(446003)(386003)(99286004)(76176011)(14444005)(66556008)(66476007)(26005)(102836004)(186003)(6512007)(3846002)(6116002)(66946007)(256004)(11346002)(2616005)(476003)(14454004)(478600001)(53546011)(6506007)(486006)(8936002)(81166006)(2906002)(64756008)(36756003)(66446008)(81156014)(31686004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3249;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: bKQy85ahfPTRTQFFAd5tP7eqHEJPYQNe1M0x8FOBGKonjigeDk0V/AD46XETYkAE3vXKayceKEWwAfjg3fvd2GvOEiSTBaqI0opnUhNNVDE48x0xXF/9c6VXp4HZNsHIp+Stzogj9DdmlSfNBHPz5lqfqglQyL9tedNvS7noONN2YcfsrXqgSGV13R+4CcVTGDAkaRbbwMEg+Kwb3Gr3o/X2FMFpX46br/bdzYvkepl6wludF9Fes2Chz5w2VBPgydmSZ9SSE0R9yCONdIkZgAk2IX2dpxW3nvax6IJrrowdGrsbNlOks2MZsxHAqL7edpMciAEQ8uN5M5gq6Pr1s4xlHRVtY0UeNxgpm8w3zb1dccuSpNi9vpWV724KXhrxe0pBxYJY/XvJK3pXagrgx+ccENlz4ae5M0sMt6TioBs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <18BCAFBB491DC14BB89D8F2706BD2743@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51ee0618-069e-4c19-6e2d-08d71e496eb5
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2019 10:48:23.6893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FfCFtoT54hl+WTsgrAGUTI0WaSpQ2dm7F0Sqn9qQNz9hpO/h5HiKYrP/aKRM/Ze+dkCQWMVK/iQQ0tlaD47S0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3249
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
cy4NCg0KDQpBbHNvIHJlZ2FyZGluZyB0aGUgaWZkZWZzLCB5ZWFoICwgSSBuZWVkIHRoZW0gdW5s
ZXNzIEkgYWx3YXlzIGRlZmluZSB0aGUgDQplbnVtLCB3aGljaCBvdGhlciBleHRlbnNpb24gZG9u
J3QgZG8uDQoNCg0K
