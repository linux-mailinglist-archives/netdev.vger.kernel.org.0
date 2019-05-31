Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79DAD306E0
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 05:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfEaDIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 23:08:19 -0400
Received: from mail-eopbgr130074.outbound.protection.outlook.com ([40.107.13.74]:16475
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726418AbfEaDIT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 23:08:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qV6BWh825+eBeZdPknYdkAyzU2f1tAYWrEeLPExxz50=;
 b=MIkO+xwqqht9EbRea7XKch0czpdjyCpXAXUpO8EMlNJ6AQ6Q4u4mbU+/neZywrljqOpL6QeNi0/GGIkzLNwtPinS2J5e1Aq/tN0sG4ODzRMd5W7fxze9CBWhxuKu9q5Q0tvnwjXIOd+YvTpAQDQNBXfkpLvngQCo8v3+vJ/bSxo=
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com (10.169.134.149) by
 VI1PR0501MB2335.eurprd05.prod.outlook.com (10.169.136.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.22; Fri, 31 May 2019 03:07:32 +0000
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::a0a7:7e01:762e:58e0]) by VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::a0a7:7e01:762e:58e0%6]) with mapi id 15.20.1922.021; Fri, 31 May 2019
 03:07:32 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     David Ahern <dsahern@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: RE: [PATCH iproute2-next 1/4] rdma: Add an option to query,set net
 namespace sharing sys parameter
Thread-Topic: [PATCH iproute2-next 1/4] rdma: Add an option to query,set net
 namespace sharing sys parameter
Thread-Index: AQHVD+CxRoqMFvkFSU2leoBFW0UPVqaCUuIAgAJJLrA=
Date:   Fri, 31 May 2019 03:07:32 +0000
Message-ID: <VI1PR0501MB2271AA2F7EDDD6076D50F21AD1190@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190521142244.8452-1-parav@mellanox.com>
 <20190521142244.8452-2-parav@mellanox.com>
 <014b3e56-9aa0-4b20-158c-d4907078d224@gmail.com>
In-Reply-To: <014b3e56-9aa0-4b20-158c-d4907078d224@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [171.61.72.91]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 531a1718-2a8f-43f6-688d-08d6e5751fc8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2335;
x-ms-traffictypediagnostic: VI1PR0501MB2335:
x-microsoft-antispam-prvs: <VI1PR0501MB233519FD93BE5FD34A7D274CD1190@VI1PR0501MB2335.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:238;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(376002)(346002)(396003)(366004)(199004)(13464003)(189003)(66446008)(53936002)(73956011)(68736007)(66476007)(64756008)(76176011)(6116002)(3846002)(86362001)(446003)(14454004)(66066001)(71190400001)(71200400001)(66946007)(4326008)(7696005)(25786009)(76116006)(305945005)(478600001)(6246003)(9686003)(66556008)(6436002)(33656002)(7736002)(256004)(486006)(81156014)(55016002)(6506007)(229853002)(102836004)(1411001)(6916009)(52536014)(5660300002)(81166006)(26005)(186003)(54906003)(53546011)(99286004)(476003)(8936002)(14444005)(11346002)(107886003)(316002)(74316002)(8676002)(2906002)(142933001)(2004002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2335;H:VI1PR0501MB2271.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fGlAotbpNst0O+t8Fv7ydqlcE5SxBs8KAjWOYqMlAyRodAsK+pp9wtaEcL2kQdWtKuk9anLZzEVfkywieObGQuQCo6qqU8O1rK3moSYXWn1fUrylrV7wuogEJDnB/NI7zf70gUCXZI5sqoZc4lITcddEfLeyH8wxjvu7vxQHPqzirq8+33PGCNC0fqsh7VHPYmyMHJ4JjoNWi6y0beRFWi99l97XUvzBHbxtx43vWa24f6c/zgSXozkew+QGZnCcpDQrdmwJXP7LxwkVp5/9coXORxn19/oeOhyHPO794CbD2W8QygtKL20wN84Ngw7YqQtzls/v7fufSHq6Ge5YQCnyi4td4vv7zfNuJhhKfEgHQT66r9HEiwdM2Usfe/rbHAkT5+VPkQsG11L/HJYcJhzKfgjUehOI6iOWfsGYSG4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 531a1718-2a8f-43f6-688d-08d6e5751fc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 03:07:32.5404
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2335
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWQsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGF2aWQg
QWhlcm4gPGRzYWhlcm5AZ21haWwuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIE1heSAyOSwgMjAx
OSA5OjQzIFBNDQo+IFRvOiBQYXJhdiBQYW5kaXQgPHBhcmF2QG1lbGxhbm94LmNvbT4NCj4gQ2M6
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXJkbWFAdmdlci5rZXJuZWwub3JnOw0KPiBz
dGVwaGVuQG5ldHdvcmtwbHVtYmVyLm9yZzsgTGVvbiBSb21hbm92c2t5IDxsZW9ucm9AbWVsbGFu
b3guY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIGlwcm91dGUyLW5leHQgMS80XSByZG1hOiBB
ZGQgYW4gb3B0aW9uIHRvIHF1ZXJ5LHNldCBuZXQNCj4gbmFtZXNwYWNlIHNoYXJpbmcgc3lzIHBh
cmFtZXRlcg0KPiANCj4gT24gNS8yMS8xOSA4OjIyIEFNLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+
ID4gZGlmZiAtLWdpdCBhL3JkbWEvc3lzLmMgYi9yZG1hL3N5cy5jDQo+ID4gbmV3IGZpbGUgbW9k
ZSAxMDA2NDQNCj4gPiBpbmRleCAwMDAwMDAwMC4uNzhlNTE5OGYNCj4gPiAtLS0gL2Rldi9udWxs
DQo+ID4gKysrIGIvcmRtYS9zeXMuYw0KPiA+IEBAIC0wLDAgKzEsMTQzIEBADQo+ID4gKy8qDQo+
ID4gKyAqIHN5cy5jCVJETUEgdG9vbA0KPiA+ICsgKg0KPiA+ICsgKiAgICAgICAgICAgICAgVGhp
cyBwcm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9v
cg0KPiA+ICsgKiAgICAgICAgICAgICAgbW9kaWZ5IGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUg
R05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UNCj4gPiArICogICAgICAgICAgICAgIGFzIHB1Ymxp
c2hlZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lvbg0KPiA+
ICsgKiAgICAgICAgICAgICAgMiBvZiB0aGUgTGljZW5zZSwgb3IgKGF0IHlvdXIgb3B0aW9uKSBh
bnkgbGF0ZXIgdmVyc2lvbi4NCj4gPiArICovDQo+IA0KPiBQbGVhc2UgdXNlIHRoZSBTUERYIGxp
bmUgbGlrZSB0aGUgb3RoZXIgcmRtYSBmaWxlcy4NCj4gDQpTdXJlLiBZZXMuDQoNCj4gPiArDQo+
ID4gKyNpbmNsdWRlICJyZG1hLmgiDQo+ID4gKw0KPiA+ICtzdGF0aWMgaW50IHN5c19oZWxwKHN0
cnVjdCByZCAqcmQpDQo+ID4gK3sNCj4gPiArCXByX291dCgiVXNhZ2U6ICVzIHN5c3RlbSBzaG93
IFsgbmV0bnMgXVxuIiwgcmQtPmZpbGVuYW1lKTsNCj4gPiArCXByX291dCgiICAgICAgICVzIHN5
c3RlbSBzZXQgbmV0bnMgeyBzaGFyZWQgfCBleGNsdXNpdmUgfVxuIiwgcmQtDQo+ID5maWxlbmFt
ZSk7DQo+ID4gKwlyZXR1cm4gMDsNCj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIGNvbnN0IGNo
YXIgKm5ldG5zX21vZGVzX3N0cltdID0gew0KPiA+ICsJImV4Y2x1c2l2ZSIsDQo+ID4gKwkic2hh
cmVkIiwNCj4gPiArfTsNCj4gPiArDQo+ID4gK3N0YXRpYyBpbnQgc3lzX3Nob3dfcGFyc2VfY2Io
Y29uc3Qgc3RydWN0IG5sbXNnaGRyICpubGgsIHZvaWQgKmRhdGEpDQo+ID4gK3sNCj4gPiArCXN0
cnVjdCBubGF0dHIgKnRiW1JETUFfTkxERVZfQVRUUl9NQVhdID0ge307DQo+ID4gKwlzdHJ1Y3Qg
cmQgKnJkID0gZGF0YTsNCj4gPiArDQo+ID4gKwltbmxfYXR0cl9wYXJzZShubGgsIDAsIHJkX2F0
dHJfY2IsIHRiKTsNCj4gPiArDQo+ID4gKwlpZiAodGJbUkRNQV9OTERFVl9TWVNfQVRUUl9ORVRO
U19NT0RFXSkgew0KPiA+ICsJCWNvbnN0IGNoYXIgKm1vZGVfc3RyOw0KPiA+ICsJCXVpbnQ4X3Qg
bmV0bnNfbW9kZTsNCj4gPiArDQo+ID4gKwkJbmV0bnNfbW9kZSA9DQo+ID4gKw0KPiAJbW5sX2F0
dHJfZ2V0X3U4KHRiW1JETUFfTkxERVZfU1lTX0FUVFJfTkVUTlNfTU9ERV0pOw0KPiA+ICsNCj4g
PiArCQlpZiAobmV0bnNfbW9kZSA8PSBBUlJBWV9TSVpFKG5ldG5zX21vZGVzX3N0cikpDQo+ID4g
KwkJCW1vZGVfc3RyID0gbmV0bnNfbW9kZXNfc3RyW25ldG5zX21vZGVdOw0KPiA+ICsJCWVsc2UN
Cj4gPiArCQkJbW9kZV9zdHIgPSAidW5rbm93biI7DQo+ID4gKw0KPiA+ICsJCWlmIChyZC0+anNv
bl9vdXRwdXQpDQo+ID4gKwkJCWpzb253X3N0cmluZ19maWVsZChyZC0+ancsICJuZXRucyIsIG1v
ZGVfc3RyKTsNCj4gPiArCQllbHNlDQo+ID4gKwkJCXByX291dCgibmV0bnMgJXNcbiIsIG1vZGVf
c3RyKTsNCj4gPiArCX0NCj4gPiArCXJldHVybiBNTkxfQ0JfT0s7DQo+ID4gK30NCj4gPiArDQo+
ID4gK3N0YXRpYyBpbnQgc3lzX3Nob3dfbm9fYXJncyhzdHJ1Y3QgcmQgKnJkKSB7DQo+ID4gKwl1
aW50MzJfdCBzZXE7DQo+ID4gKwlpbnQgcmV0Ow0KPiA+ICsNCj4gPiArCXJkX3ByZXBhcmVfbXNn
KHJkLCBSRE1BX05MREVWX0NNRF9TWVNfR0VULA0KPiA+ICsJCSAgICAgICAmc2VxLCAoTkxNX0Zf
UkVRVUVTVCB8IE5MTV9GX0FDSykpOw0KPiA+ICsJcmV0ID0gcmRfc2VuZF9tc2cocmQpOw0KPiA+
ICsJaWYgKHJldCkNCj4gPiArCQlyZXR1cm4gcmV0Ow0KPiA+ICsNCj4gPiArCXJldCA9IHJkX3Jl
Y3ZfbXNnKHJkLCBzeXNfc2hvd19wYXJzZV9jYiwgcmQsIHNlcSk7DQo+ID4gKwlyZXR1cm4gcmV0
Ow0KPiANCj4gc2luY2UgeW91IGFyZSBmaXhpbmcgdGhlIGhlYWRlciwgd2h5IG5vdCBqdXN0DQo+
IAlyZXR1cm4gcmRfcmVjdl9tc2cocmQsIHN5c19zaG93X3BhcnNlX2NiLCByZCwgc2VxKTsNCj4g
DQo+IGxpa2UgdGhlIG90aGVyIGZ1bmN0aW9ucz8NCg0KWWVwLiBDaGFuZ2VkLg0KU2VuZGluZyB2
MS4NCg==
