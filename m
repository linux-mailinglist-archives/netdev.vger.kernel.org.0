Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD9D71E14
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 19:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388530AbfGWRzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 13:55:03 -0400
Received: from mail-eopbgr30051.outbound.protection.outlook.com ([40.107.3.51]:4834
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731661AbfGWRzD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 13:55:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EXr+E9mkGuDJKAZB1E5UFw4chKCFe++mnfJTcdjbG8M0vcFzjP6CBxrfq5ykPzIhjH8/ZnUoi3lOLuozPkFQd71gV3L4ySw7RiKhg5g2vWC6YS0XlQz42JzLMSzCzvHtUSew/GciPAVXPpyc0kQgG8J66wfyGM94OvLg9XHg+qYPc2a99TAsUiN6B0H1ow+kTFgzdz9isBgpAFIhSJl0Z55AR+oMiuY/qir6slKOePNpNjt34bunFccRpWPGH/e2PbWs/Uqhu6yVPS5RQZMVIVZ8036kveacDZQ6oyuWg2IbJ+GUXC5/qi1CxGfS2VALNH0P89Is/bquC7+LPtob2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbzZNHsdMKHxCwWUqV5BR8ZkAYDJVZgGbS7AXrfZx+o=;
 b=oSvdb0ZMqr5UxXDDIrNFVRNIIZkhgx20js/5OGKOBtLhG5pAgNMRzCyJemx69leMr0thoi+Z+3s0BVn6P/AmfbmQ2PAn69okgoC7JBaGu5G45VF+cSCqEc42L1XchGsJfh+d370YdcIJYTDrJyNh3fgZG+WsrsYRsLu249AslT+IM7bHGS9D6P44jwbrFhCxfSO5FXaCBNomB7fYqIU+cCB2mN8FUngNCZJrx3lYuegm0LNGzUhlX0FaDBvfwqXgGlOt6T7VqJ0nkRmr+ElVaGxpT40G3Bl0J9Hxtv6pdmo6JINBcCk84GI9Jcw6osIXFDUfKt+bEYRlk610/Xp1kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbzZNHsdMKHxCwWUqV5BR8ZkAYDJVZgGbS7AXrfZx+o=;
 b=NFdlR8tiKVOId4bq/BuXaxvWmwIfJFILihE8m5IfhpLHw2hUpC2qE9/9PHRtd4HyhRyHmYFm2WzZ4/Ki6s2C+W1GUAZ5/5bQ8D76I/Vfjr3d4VwyyPqz0oSTKD2NJBNudS+PUrIngnTs6c473jrUPCafQHRyeDf8K0/fdUSxgak=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2246.eurprd05.prod.outlook.com (10.168.55.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Tue, 23 Jul 2019 17:54:57 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Tue, 23 Jul 2019
 17:54:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "ruxandra.radulescu@nxp.com" <ruxandra.radulescu@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "ioana.ciornei@nxp.com" <ioana.ciornei@nxp.com>,
        "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next] dpaa2-eth: Don't use netif_receive_skb_list for
 TCP frames
Thread-Topic: [PATCH net-next] dpaa2-eth: Don't use netif_receive_skb_list for
 TCP frames
Thread-Index: AQHVQXwX1tu7q3y3jk+mll0MgLUz0qbYe1iA
Date:   Tue, 23 Jul 2019 17:54:57 +0000
Message-ID: <f4b4ddbbb9e3e40442e73dd1869723f246c8f785.camel@mellanox.com>
References: <1563902923-26178-1-git-send-email-ruxandra.radulescu@nxp.com>
In-Reply-To: <1563902923-26178-1-git-send-email-ruxandra.radulescu@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 723c9ff2-df3a-4de2-5c55-08d70f96e00c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2246;
x-ms-traffictypediagnostic: DB6PR0501MB2246:
x-microsoft-antispam-prvs: <DB6PR0501MB22467D209C9F6FE6578782B7BEC70@DB6PR0501MB2246.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(199004)(189003)(66946007)(66556008)(91956017)(81166006)(76116006)(81156014)(14454004)(5660300002)(8676002)(66446008)(71190400001)(4326008)(8936002)(66476007)(64756008)(3846002)(53936002)(71200400001)(6246003)(68736007)(6512007)(229853002)(305945005)(6486002)(86362001)(2501003)(316002)(2906002)(110136005)(7736002)(36756003)(118296001)(54906003)(2201001)(256004)(6436002)(102836004)(66066001)(6116002)(14444005)(6506007)(486006)(58126008)(25786009)(446003)(186003)(11346002)(26005)(99286004)(478600001)(476003)(2616005)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2246;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: f2D4s0QL3lGu9psVmh9rwtvJmqleWTL8kLrAvvklb4vkf77LKzNOaDqE0aQMDfHRgN/qjkMDiOE34l1Wo665iHb+GYDIUdRrNhPQIxoD+r8F3nZU7QRVAxizh94WVT+YT+vUy5tIK2oqRwJlv28yKmGjJXYejv/V5P4BheBMEfzhSgh35L/mb+ua7erxt9UlEgu6/5+hM8RDHDFx6sZyZMXxehEQFFDtkc+MXiWQM1a/2A36LoKMqzSs38UDG2wxj0kprzc1rCEOhTMQDhBayTqUIBUIJ8ZMQZyMhixNUAd90fEkriKlfKhm87TuUkl9FH/MiGju8ZFFvv6Dg7JOENmIrOelbzuXELFKHwUBw8qcmV57j+cGaR2nWrUoDIH5wXUn3Cmf+QjRxfzArvez9Uw3v3UKNHz+Cv4ViNTm+uQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D376C9AAC93D74C83F1AD254E58A63A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 723c9ff2-df3a-4de2-5c55-08d70f96e00c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 17:54:57.2862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2246
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA3LTIzIGF0IDIwOjI4ICswMzAwLCBJb2FuYSBSYWR1bGVzY3Ugd3JvdGU6
DQo+IFVzaW5nIFJ4IHNrYiBidWxraW5nIGZvciBhbGwgZnJhbWVzIG1heSBuZWdhdGl2ZWx5IGlt
cGFjdCB0aGUNCj4gcGVyZm9ybWFuY2UgaW4gc29tZSBUQ1AgdGVybWluYXRpb24gc2NlbmFyaW9z
LCBhcyBpdCBlZmZlY3RpdmVseQ0KPiBieXBhc3NlcyBHUk8uDQo+IA0KPiBMb29rIGF0IHRoZSBo
YXJkd2FyZSBwYXJzZSByZXN1bHRzIG9mIGVhY2ggaW5ncmVzcyBmcmFtZSB0byBzZWUNCj4gaWYg
YSBUQ1AgaGVhZGVyIGlzIHByZXNlbnQgb3Igbm90OyBmb3IgVENQIGZyYW1lcyBmYWxsIGJhY2sg
dG8NCj4gdGhlIG9sZCBpbXBsZW1lbnRhdGlvbi4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IElvYW5h
IFJhZHVsZXNjdSA8cnV4YW5kcmEucmFkdWxlc2N1QG54cC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6
IFZsYWRpbWlyIE9sdGVhbiA8dmxhZGltaXIub2x0ZWFuQG54cC5jb20+DQo+IC0tLQ0KPiAgZHJp
dmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEyL2RwYWEyLWV0aC5jIHwgMTUgKysrKysr
LQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEyL2RwYWEyLWV0aC5oIHwg
NTENCj4gKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDY1IGlu
c2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9mcmVlc2NhbGUvZHBhYTIvZHBhYTItZXRoLmMNCj4gYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9mcmVlc2NhbGUvZHBhYTIvZHBhYTItZXRoLmMNCj4gaW5kZXggMGFjYjExNS4uNDEy
Zjg3ZiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEy
L2RwYWEyLWV0aC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9kcGFh
Mi9kcGFhMi1ldGguYw0KPiBAQCAtMzQ4LDYgKzM0OCwxNiBAQCBzdGF0aWMgdTMyIHJ1bl94ZHAo
c3RydWN0IGRwYWEyX2V0aF9wcml2ICpwcml2LA0KPiAgCXJldHVybiB4ZHBfYWN0Ow0KPiAgfQ0K
PiAgDQo+ICtzdGF0aWMgYm9vbCBmcmFtZV9pc190Y3AoY29uc3Qgc3RydWN0IGRwYWEyX2ZkICpm
ZCwgc3RydWN0IGRwYWEyX2Zhcw0KPiAqZmFzKQ0KPiArew0KPiArCXN0cnVjdCBkcGFhMl9mYXBy
ICpmYXByID0gZHBhYTJfZ2V0X2ZhcHIoZmFzLCBmYWxzZSk7DQo+ICsNCj4gKwlpZiAoIShkcGFh
Ml9mZF9nZXRfZnJjKGZkKSAmIERQQUEyX0ZEX0ZSQ19GQVBSVikpDQo+ICsJCXJldHVybiBmYWxz
ZTsNCj4gKw0KPiArCXJldHVybiAhIShmYXByLT5mYWZfaGkgJiBEUEFBMl9GQUZfSElfVENQX1BS
RVNFTlQpOw0KPiArfQ0KPiArDQo+ICAvKiBNYWluIFJ4IGZyYW1lIHByb2Nlc3Npbmcgcm91dGlu
ZSAqLw0KPiAgc3RhdGljIHZvaWQgZHBhYTJfZXRoX3J4KHN0cnVjdCBkcGFhMl9ldGhfcHJpdiAq
cHJpdiwNCj4gIAkJCSBzdHJ1Y3QgZHBhYTJfZXRoX2NoYW5uZWwgKmNoLA0KPiBAQCAtNDM1LDcg
KzQ0NSwxMCBAQCBzdGF0aWMgdm9pZCBkcGFhMl9ldGhfcngoc3RydWN0IGRwYWEyX2V0aF9wcml2
DQo+ICpwcml2LA0KPiAgCXBlcmNwdV9zdGF0cy0+cnhfcGFja2V0cysrOw0KPiAgCXBlcmNwdV9z
dGF0cy0+cnhfYnl0ZXMgKz0gZHBhYTJfZmRfZ2V0X2xlbihmZCk7DQo+ICANCj4gLQlsaXN0X2Fk
ZF90YWlsKCZza2ItPmxpc3QsIGNoLT5yeF9saXN0KTsNCj4gKwlpZiAoZnJhbWVfaXNfdGNwKGZk
LCBmYXMpKQ0KPiArCQluYXBpX2dyb19yZWNlaXZlKCZjaC0+bmFwaSwgc2tiKTsNCj4gKwllbHNl
DQo+ICsJCWxpc3RfYWRkX3RhaWwoJnNrYi0+bGlzdCwgY2gtPnJ4X2xpc3QpOw0KPiAgDQoNCk1h
eWJlIGl0IGlzIGJldHRlciBpZiB3ZSBpbnRyb2R1Y2UgbmFwaV9ncm9fcmVjZWl2ZV9saXN0KCkg
DQphbmQgbGV0IG5hcGkgZGVjaWRlIHdoZW4gdG8gZG8gbmFwaV9ncm9fcmVjZWl2ZSBvciBsaXN0
X2FkZF90YWlsLCBncm8NCnN0YWNrIGFscmVhZHkga25vd3MgaG93IHRvIG1ha2UgdGhlIGRlY2lz
aW9uLCAobm8gbmVlZCB0byBoYXZlIGENCnNwZWNpYWxpemVkIGh3IHBhcnNlciBmb3IgVENQIGZy
YW1lcykgc28gYWxsIGRyaXZlcnMgd2lsbCBiZW5lZml0IGZyb20NCnRoaXMgYW5kIHdlIHdpbGwg
bm90IHJlcGVhdCB0aGUgc2FtZSB0aGluZyB5b3UgZGlkIGhlcmUgaW4gYWxsDQpkcml2ZXJzLiAN
Cg0KYWxzbyBpbiBzdWNoIGNhc2UgbmFwaS9uYXBpX2dybyB3aWxsIG1haW50YWluIHRoZSB0ZW1w
b3Jhcnkgcnggc2tiDQpsaXN0LCB3aGljaCBzZWVtcyBtb3JlIG5hdHVyYWwgdGhhbiBpbXBsZW1l
bnRpbmcgaXQgcGVyIGRyaXZlci4NCg0KT24gbmFwaV9ncm9fcmVjZWl2ZV9saXN0Og0KIDEpIFRy
eSBncm8NCiAyKSBpZiB0aGUgcmVzdWx0IGlzIEdST19OT1JNQUwsIHRoZW4gYWRkIHRoZSBza2Ig
dG8gbGlzdA0KIDMpIG9uIG5hcGlfY29tcGxldGUgb3Igd2hlbiBsaXN0IGJ1ZGdldCBpcyBjb25z
dW1lZCBmbHVzaCBza2IgbGlzdCBieQ0KY2FsbGluZyBuZXRpZl9yZWNlaXZlX3NrYl9saXN0Lg0K
DQo+ICAJcmV0dXJuOw0KPiAgDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9m
cmVlc2NhbGUvZHBhYTIvZHBhYTItZXRoLmgNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVl
c2NhbGUvZHBhYTIvZHBhYTItZXRoLmgNCj4gaW5kZXggOWFmMThjMi4uZDcyM2FlNyAxMDA2NDQN
Cj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEyL2RwYWEyLWV0aC5o
DQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9kcGFhMi9kcGFhMi1ldGgu
aA0KPiBAQCAtMTU1LDYgKzE1NSw0OSBAQCBzdHJ1Y3QgZHBhYTJfZmFzIHsNCj4gICAqLw0KPiAg
I2RlZmluZSBEUEFBMl9UU19PRkZTRVQJCQkweDgNCj4gIA0KPiArLyogRnJhbWUgYW5ub3RhdGlv
biBwYXJzZSByZXN1bHRzICovDQo+ICtzdHJ1Y3QgZHBhYTJfZmFwciB7DQo+ICsJLyogNjQtYml0
IHdvcmQgMSAqLw0KPiArCV9fbGUzMiBmYWZfbG87DQo+ICsJX19sZTE2IGZhZl9leHQ7DQo+ICsJ
X19sZTE2IG54dF9oZHI7DQo+ICsJLyogNjQtYml0IHdvcmQgMiAqLw0KPiArCV9fbGU2NCBmYWZf
aGk7DQo+ICsJLyogNjQtYml0IHdvcmQgMyAqLw0KPiArCXU4IGxhc3RfZXRoZXJ0eXBlX29mZnNl
dDsNCj4gKwl1OCB2bGFuX3RjaV9vZmZzZXRfbjsNCj4gKwl1OCB2bGFuX3RjaV9vZmZzZXRfMTsN
Cj4gKwl1OCBsbGNfc25hcF9vZmZzZXQ7DQo+ICsJdTggZXRoX29mZnNldDsNCj4gKwl1OCBpcDFf
cGlkX29mZnNldDsNCj4gKwl1OCBzaGltX29mZnNldF8yOw0KPiArCXU4IHNoaW1fb2Zmc2V0XzE7
DQo+ICsJLyogNjQtYml0IHdvcmQgNCAqLw0KPiArCXU4IGw1X29mZnNldDsNCj4gKwl1OCBsNF9v
ZmZzZXQ7DQo+ICsJdTggZ3JlX29mZnNldDsNCj4gKwl1OCBsM19vZmZzZXRfbjsNCj4gKwl1OCBs
M19vZmZzZXRfMTsNCj4gKwl1OCBtcGxzX29mZnNldF9uOw0KPiArCXU4IG1wbHNfb2Zmc2V0XzE7
DQo+ICsJdTggcHBwb2Vfb2Zmc2V0Ow0KPiArCS8qIDY0LWJpdCB3b3JkIDUgKi8NCj4gKwlfX2xl
MTYgcnVubmluZ19zdW07DQo+ICsJX19sZTE2IGdyb3NzX3J1bm5pbmdfc3VtOw0KPiArCXU4IGlw
djZfZnJhZ19vZmZzZXQ7DQo+ICsJdTggbnh0X2hkcl9vZmZzZXQ7DQo+ICsJdTggcm91dGluZ19o
ZHJfb2Zmc2V0XzI7DQo+ICsJdTggcm91dGluZ19oZHJfb2Zmc2V0XzE7DQo+ICsJLyogNjQtYml0
IHdvcmQgNiAqLw0KPiArCXU4IHJlc2VydmVkWzVdOyAvKiBTb2Z0LXBhcnNpbmcgY29udGV4dCAq
Lw0KPiArCXU4IGlwX3Byb3RvX29mZnNldF9uOw0KPiArCXU4IG54dF9oZHJfZnJhZ19vZmZzZXQ7
DQo+ICsJdTggcGFyc2VfZXJyb3JfY29kZTsNCj4gK307DQo+ICsNCj4gKyNkZWZpbmUgRFBBQTJf
RkFQUl9PRkZTRVQJCTB4MTANCj4gKyNkZWZpbmUgRFBBQTJfRkFQUl9TSVpFCQkJc2l6ZW9mKChz
dHJ1Y3QNCj4gZHBhYTJfZmFwcikpDQo+ICsNCj4gIC8qIEZyYW1lIGFubm90YXRpb24gZWdyZXNz
IGFjdGlvbiBkZXNjcmlwdG9yICovDQo+ICAjZGVmaW5lIERQQUEyX0ZBRUFEX09GRlNFVAkJMHg1
OA0KPiAgDQo+IEBAIC0xODUsNiArMjI4LDExIEBAIHN0YXRpYyBpbmxpbmUgX19sZTY0ICpkcGFh
Ml9nZXRfdHModm9pZA0KPiAqYnVmX2FkZHIsIGJvb2wgc3dhKQ0KPiAgCXJldHVybiBkcGFhMl9n
ZXRfaHdhKGJ1Zl9hZGRyLCBzd2EpICsgRFBBQTJfVFNfT0ZGU0VUOw0KPiAgfQ0KPiAgDQo+ICtz
dGF0aWMgaW5saW5lIHN0cnVjdCBkcGFhMl9mYXByICpkcGFhMl9nZXRfZmFwcih2b2lkICpidWZf
YWRkciwgYm9vbA0KPiBzd2EpDQo+ICt7DQo+ICsJcmV0dXJuIGRwYWEyX2dldF9od2EoYnVmX2Fk
ZHIsIHN3YSkgKyBEUEFBMl9GQVBSX09GRlNFVDsNCj4gK30NCj4gKw0KPiAgc3RhdGljIGlubGlu
ZSBzdHJ1Y3QgZHBhYTJfZmFlYWQgKmRwYWEyX2dldF9mYWVhZCh2b2lkICpidWZfYWRkciwNCj4g
Ym9vbCBzd2EpDQo+ICB7DQo+ICAJcmV0dXJuIGRwYWEyX2dldF9od2EoYnVmX2FkZHIsIHN3YSkg
KyBEUEFBMl9GQUVBRF9PRkZTRVQ7DQo+IEBAIC0yMzYsNiArMjg0LDkgQEAgc3RhdGljIGlubGlu
ZSBzdHJ1Y3QgZHBhYTJfZmFlYWQNCj4gKmRwYWEyX2dldF9mYWVhZCh2b2lkICpidWZfYWRkciwg
Ym9vbCBzd2EpDQo+ICAJCQkJCSBEUEFBMl9GQVNfTDNDRQkJfCBcDQo+ICAJCQkJCSBEUEFBMl9G
QVNfTDRDRSkNCj4gIA0KPiArLyogVENQIGluZGljYXRpb24gaW4gRnJhbWUgQW5ub3RhdGlvbiBQ
YXJzZSBSZXN1bHRzICovDQo+ICsjZGVmaW5lIERQQUEyX0ZBRl9ISV9UQ1BfUFJFU0VOVAlCSVQo
MjMpDQo+ICsNCj4gIC8qIFRpbWUgaW4gbWlsbGlzZWNvbmRzIGJldHdlZW4gbGluayBzdGF0ZSB1
cGRhdGVzICovDQo+ICAjZGVmaW5lIERQQUEyX0VUSF9MSU5LX1NUQVRFX1JFRlJFU0gJMTAwMA0K
PiAgDQo=
