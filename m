Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9121D1B67D
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 14:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730049AbfEMMyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 08:54:43 -0400
Received: from mail-eopbgr60048.outbound.protection.outlook.com ([40.107.6.48]:3719
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727462AbfEMMym (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 08:54:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WT98cQkuNu6zAOUkI7wn1nw3fM5CNIHLK/vDTExEIU8=;
 b=OzbbkiK1kubxBtDZfnlwaYDNU93e74xRcIBQffJty0N36JKtTuC6EqIhiD/fQRMgs+kksQRFwPkZwNNVE3fmu/GJV/4TO1JTQqN/b4Dto59TM5FL6lBAM8sEPi+gJYLlqRUfxd1msHRbmTQv68sOo7He+iQNsGBj0LTpYK3w1S0=
Received: from VI1PR05MB6255.eurprd05.prod.outlook.com (20.178.205.93) by
 VI1PR05MB4192.eurprd05.prod.outlook.com (10.171.183.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.21; Mon, 13 May 2019 12:54:38 +0000
Received: from VI1PR05MB6255.eurprd05.prod.outlook.com
 ([fe80::fc74:5e94:48e2:9018]) by VI1PR05MB6255.eurprd05.prod.outlook.com
 ([fe80::fc74:5e94:48e2:9018%3]) with mapi id 15.20.1878.024; Mon, 13 May 2019
 12:54:38 +0000
From:   Jianbo Liu <jianbol@mellanox.com>
To:     Edward Cree <ecree@solarflare.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Anjali Singhai Jain <anjali.singhai@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [RFC PATCH net-next 3/3] flow_offload: support CVLAN match
Thread-Topic: [RFC PATCH net-next 3/3] flow_offload: support CVLAN match
Thread-Index: AQHVAcIXXutRDZ7JxkeCZkw7jainaKZpEloA
Date:   Mon, 13 May 2019 12:54:37 +0000
Message-ID: <20190513125400.GB22355@mellanox.com>
References: <alpine.LFD.2.21.1905031607170.11823@ehc-opti7040.uk.solarflarecom.com>
In-Reply-To: <alpine.LFD.2.21.1905031607170.11823@ehc-opti7040.uk.solarflarecom.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0272.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a1::20) To VI1PR05MB6255.eurprd05.prod.outlook.com
 (2603:10a6:803:ed::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jianbol@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c057aca4-3cf0-4b69-ef1d-08d6d7a22800
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB4192;
x-ms-traffictypediagnostic: VI1PR05MB4192:
x-microsoft-antispam-prvs: <VI1PR05MB4192C6E12561A358A441349EC80F0@VI1PR05MB4192.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0036736630
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(396003)(366004)(136003)(376002)(189003)(199004)(186003)(2906002)(66946007)(478600001)(229853002)(68736007)(73956011)(25786009)(102836004)(6486002)(446003)(36756003)(316002)(33656002)(4326008)(11346002)(256004)(1076003)(66476007)(486006)(66446008)(64756008)(6436002)(2616005)(6916009)(66556008)(71190400001)(476003)(71200400001)(54906003)(386003)(6506007)(305945005)(86362001)(6246003)(8936002)(14454004)(7416002)(8676002)(6512007)(76176011)(81156014)(81166006)(99286004)(52116002)(53936002)(66066001)(5660300002)(26005)(7736002)(3846002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4192;H:VI1PR05MB6255.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Rfpp7YzuCJssXAmRRw8AJK0ZPMWrxv00xFRJgpvInmDYlIBcssNRPtiNU0Aovp/U5kxa2BrV7rarlbS/YDQcy2aNOtltukhgtY/5hZqBW/X1DEZSoipx8hu0slcgPVhlt9xN/vNXfls+MByMUhPxy5+Y5p0y3TnhOGQs1WxmMInPvlCIzxJpjG58eMWgpC+SbjsKTR5UDmhOZ599PRWjE8rufUsv0AiwWttDghmnkHxbKdT/Jzu45h1SBK4AlgOnZ/LJMuCuCxu6fXtrJwC9wk/xh9+OsbTxyHbXUshf5TE/PMCAfcewJYs7fKjoHU9uExMNlt0G1d3CpIuZlRM6l9+rfIFvy/J5Bvki4YgvH5eH7Hd2jAproDWNxUkcaZAQv9JclyjZs9sBzGNaGWATeJGDAnTiHAoC7cBlwkH4/eo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <34FD16FF5BC64140A7549F32CD44F807@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c057aca4-3cf0-4b69-ef1d-08d6d7a22800
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2019 12:54:37.9470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4192
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIDA1LzAzLzIwMTkgMTY6MDgsIEVkd2FyZCBDcmVlIHdyb3RlOg0KPiBQbHVtYiBpdCB0aHJv
dWdoIGZyb20gdGhlIGZsb3dfZGlzc2VjdG9yLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRWR3YXJk
IENyZWUgPGVjcmVlQHNvbGFyZmxhcmUuY29tPg0KPiAtLS0NCj4gIGluY2x1ZGUvbmV0L2Zsb3df
b2ZmbG9hZC5oIHwgMiArKw0KPiAgbmV0L2NvcmUvZmxvd19vZmZsb2FkLmMgICAgfCA3ICsrKysr
KysNCj4gIDIgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0
IGEvaW5jbHVkZS9uZXQvZmxvd19vZmZsb2FkLmggYi9pbmNsdWRlL25ldC9mbG93X29mZmxvYWQu
aA0KPiBpbmRleCA2ZjU5Y2RhZjZlYjYuLjQ4ODQ3ZWU3YWEzYSAxMDA2NDQNCj4gLS0tIGEvaW5j
bHVkZS9uZXQvZmxvd19vZmZsb2FkLmgNCj4gKysrIGIvaW5jbHVkZS9uZXQvZmxvd19vZmZsb2Fk
LmgNCj4gQEAgLTcxLDYgKzcxLDggQEAgdm9pZCBmbG93X3J1bGVfbWF0Y2hfZXRoX2FkZHJzKGNv
bnN0IHN0cnVjdCBmbG93X3J1bGUgKnJ1bGUsDQo+ICAJCQkgICAgICAgc3RydWN0IGZsb3dfbWF0
Y2hfZXRoX2FkZHJzICpvdXQpOw0KPiAgdm9pZCBmbG93X3J1bGVfbWF0Y2hfdmxhbihjb25zdCBz
dHJ1Y3QgZmxvd19ydWxlICpydWxlLA0KPiAgCQkJICBzdHJ1Y3QgZmxvd19tYXRjaF92bGFuICpv
dXQpOw0KPiArdm9pZCBmbG93X3J1bGVfbWF0Y2hfY3ZsYW4oY29uc3Qgc3RydWN0IGZsb3dfcnVs
ZSAqcnVsZSwNCj4gKwkJCSAgIHN0cnVjdCBmbG93X21hdGNoX3ZsYW4gKm91dCk7DQo+ICB2b2lk
IGZsb3dfcnVsZV9tYXRjaF9pcHY0X2FkZHJzKGNvbnN0IHN0cnVjdCBmbG93X3J1bGUgKnJ1bGUs
DQo+ICAJCQkJc3RydWN0IGZsb3dfbWF0Y2hfaXB2NF9hZGRycyAqb3V0KTsNCj4gIHZvaWQgZmxv
d19ydWxlX21hdGNoX2lwdjZfYWRkcnMoY29uc3Qgc3RydWN0IGZsb3dfcnVsZSAqcnVsZSwNCj4g
ZGlmZiAtLWdpdCBhL25ldC9jb3JlL2Zsb3dfb2ZmbG9hZC5jIGIvbmV0L2NvcmUvZmxvd19vZmZs
b2FkLmMNCj4gaW5kZXggYzNhMDBlYWM0ODA0Li41Y2U3ZDQ3YTk2MGUgMTAwNjQ0DQo+IC0tLSBh
L25ldC9jb3JlL2Zsb3dfb2ZmbG9hZC5jDQo+ICsrKyBiL25ldC9jb3JlL2Zsb3dfb2ZmbG9hZC5j
DQo+IEBAIC01NCw2ICs1NCwxMyBAQCB2b2lkIGZsb3dfcnVsZV9tYXRjaF92bGFuKGNvbnN0IHN0
cnVjdCBmbG93X3J1bGUgKnJ1bGUsDQo+ICB9DQo+ICBFWFBPUlRfU1lNQk9MKGZsb3dfcnVsZV9t
YXRjaF92bGFuKTsNCj4gIA0KPiArdm9pZCBmbG93X3J1bGVfbWF0Y2hfY3ZsYW4oY29uc3Qgc3Ry
dWN0IGZsb3dfcnVsZSAqcnVsZSwNCj4gKwkJCSAgIHN0cnVjdCBmbG93X21hdGNoX3ZsYW4gKm91
dCkNCj4gK3sNCj4gKwlGTE9XX0RJU1NFQ1RPUl9NQVRDSChydWxlLCBGTE9XX0RJU1NFQ1RPUl9L
RVlfQ1ZMQU4sIG91dCk7DQo+ICt9DQo+ICtFWFBPUlRfU1lNQk9MKGZsb3dfcnVsZV9tYXRjaF9j
dmxhbik7DQo+ICsNCj4gIHZvaWQgZmxvd19ydWxlX21hdGNoX2lwdjRfYWRkcnMoY29uc3Qgc3Ry
dWN0IGZsb3dfcnVsZSAqcnVsZSwNCj4gIAkJCQlzdHJ1Y3QgZmxvd19tYXRjaF9pcHY0X2FkZHJz
ICpvdXQpDQo+ICB7DQoNCkNvdWxkIHlvdSBwbGVhc2UgcHVzaCB0byA1LjEgYW5kIDUuMC1zdGFi
bGU/IFRoZSBvcmlnaW5hbCBwYXRjaCBicm91Z2h0IGEgYnVnDQppbiBtbHg1X2NvcmUgZHJpdmVy
LiBOZWVkIHlvdXIgcGF0Y2ggdG8gZml4Lg0KDQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYw0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2VuX3RjLmMNCkBAIC0xNjE1LDcgKzE2MTUsNyBAQCBzdGF0aWMgaW50
IF9fcGFyc2VfY2xzX2Zsb3dlcihzdHJ1Y3QgbWx4NWVfcHJpdiAqcHJpdiwNCiAgICAgICAgaWYg
KGZsb3dfcnVsZV9tYXRjaF9rZXkocnVsZSwgRkxPV19ESVNTRUNUT1JfS0VZX0NWTEFOKSkgew0K
ICAgICAgICAgICAgICAgIHN0cnVjdCBmbG93X21hdGNoX3ZsYW4gbWF0Y2g7DQoNCi0gICAgICAg
ICAgICAgICBmbG93X3J1bGVfbWF0Y2hfdmxhbihydWxlLCAmbWF0Y2gpOw0KKyAgICAgICAgICAg
ICAgIGZsb3dfcnVsZV9tYXRjaF9jdmxhbihydWxlLCAmbWF0Y2gpOw0KICAgICAgICAgICAgICAg
IGlmIChtYXRjaC5tYXNrLT52bGFuX2lkIHx8DQogICAgICAgICAgICAgICAgICAgIG1hdGNoLm1h
c2stPnZsYW5fcHJpb3JpdHkgfHwNCiAgICAgICAgICAgICAgICAgICAgbWF0Y2gubWFzay0+dmxh
bl90cGlkKSB7DQoNClRoYW5rcyENCg==
