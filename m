Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66D78315D8
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 22:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfEaUJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 16:09:54 -0400
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:15081
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727376AbfEaUJx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 16:09:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2TmdUSDl6thDe/jaAjFdckU75oQ91lvElJXpLYVRm2k=;
 b=XwtpLR6El2vXDo9PXt6fWook5IohJNl1P6dyI1v0r7mi5f8CxVEkUpdXgEQYT0xg9+mJirW1JLmt5sXSOIRRvo3nh9zl+UYwMMq0kptOx2w7oVqIpAY9qSpak60uQeAHVa8jitrir0qiI9pZ2d0moXimdnqrVU6eW5DTV+ymUC4=
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com (20.178.125.223) by
 VI1PR05MB5600.eurprd05.prod.outlook.com (20.177.203.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Fri, 31 May 2019 20:09:24 +0000
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::dd31:2532:9adf:9b38]) by VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::dd31:2532:9adf:9b38%6]) with mapi id 15.20.1922.021; Fri, 31 May 2019
 20:09:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 2/9] net/mlx5e: Allow matching only enc_key_id/enc_dst_port
 for decapsulation action
Thread-Topic: [net-next 2/9] net/mlx5e: Allow matching only
 enc_key_id/enc_dst_port for decapsulation action
Thread-Index: AQHVF+y9bwrRcLjZsEu4Z4kK1MM8Yw==
Date:   Fri, 31 May 2019 20:09:24 +0000
Message-ID: <20190531200838.25184-3-saeedm@mellanox.com>
References: <20190531200838.25184-1-saeedm@mellanox.com>
In-Reply-To: <20190531200838.25184-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR07CA0086.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::27) To VI1PR05MB5902.eurprd05.prod.outlook.com
 (2603:10a6:803:df::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 218ccd4c-58fd-47c9-e93b-08d6e603e00e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB5600;
x-ms-traffictypediagnostic: VI1PR05MB5600:
x-microsoft-antispam-prvs: <VI1PR05MB56006C5F1A3B3B076012F5DBBE190@VI1PR05MB5600.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(366004)(136003)(396003)(346002)(189003)(199004)(99286004)(52116002)(2616005)(6116002)(6512007)(107886003)(486006)(54906003)(386003)(476003)(76176011)(186003)(26005)(3846002)(11346002)(305945005)(81166006)(66066001)(256004)(6506007)(4326008)(25786009)(6486002)(102836004)(6436002)(66946007)(8936002)(64756008)(7736002)(8676002)(53936002)(66476007)(73956011)(446003)(66556008)(81156014)(66446008)(6916009)(1076003)(68736007)(2906002)(86362001)(71190400001)(14454004)(5660300002)(316002)(508600001)(36756003)(50226002)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5600;H:VI1PR05MB5902.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 36nPnPxNj4wsgfTc7CWn3bgZ+dFdc977OL/jqNZxFyn8Yd3Rnw0HkHSeOaJCMYodSVWp9pBtOo8DAL+2D625Ek3B/BzNb/Q7Lm/LVCjZN775JnIN4bMqqIMH8gxNfv4maPJbxJ7AijRz16EJFdcO9BSiqVQLajBVmRn1uvBlNG/ySfVxLpqH8rFIPbsQhp+C14NmUPbukntUhl5yY3oG/NdJhLe8DFnPol/AH3W9I0fE18n099f+vb8v+8oOGTwIAvIATWoZz56+a5KU60NL3rXuLnoSoVLlIwZp3KGIFjQQPeYJQXrOojBbiHJNmOUJFTX9Lo3x3MQHuqIxkPHe51v3pwOaAMWqw6O5RxrnU7UuedI23aJ/j3xx1rIny8vnGoHdhpcPV8qdHxZAAYokMFR19vkYe7FCAFP3q747JYw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 218ccd4c-58fd-47c9-e93b-08d6e603e00e
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 20:09:24.2375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5600
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVG9uZ2hhbyBaaGFuZyA8eGlhbmd4aWEubS55dWVAZ21haWwuY29tPg0KDQpJbiBzb21l
IGNhc2UsIHdlIGRvbid0IGNhcmUgdGhlIGVuY19zcmNfaXAgYW5kIGVuY19kc3RfaXAsIGFuZA0K
aWYgd2UgZG9uJ3QgbWF0Y2ggdGhlIGZpZWxkIGVuY19zcmNfaXAgYW5kIGVuY19kc3RfaXAsIHdl
IGNhbiB1c2UNCmZld2VyIGZsb3dzIGluIGhhcmR3YXJlIHdoZW4gcmV2aWNlIHRoZSB0dW5uZWwg
cGFja2V0cy4gRm9yIGV4YW1wbGUsDQp0aGUgdHVubmVsIHBhY2tldHMgbWF5IGJlIHNlbnQgZnJv
bSBkaWZmZXJlbnQgaG9zdHMsIHdlIG11c3Qgb2ZmbG9hZA0Kb25lIHJ1bGUgZm9yIGVhY2ggaG9z
dC4NCg0KCSQgdGMgZmlsdGVyIGFkZCBkZXYgdnhsYW4wIHByb3RvY29sIGlwIHBhcmVudCBmZmZm
OiBwcmlvIDEgXA0KCQlmbG93ZXIgZHN0X21hYyAwMDoxMToyMjozMzo0NDowMCBcDQoJCWVuY19z
cmNfaXAgSG9zdDBfSVAgZW5jX2RzdF9pcCAyLjIuMi4xMDAgXA0KCQllbmNfZHN0X3BvcnQgNDc4
OSBlbmNfa2V5X2lkIDEwMCBcDQoJCWFjdGlvbiB0dW5uZWxfa2V5IHVuc2V0IGFjdGlvbiBtaXJy
ZWQgZWdyZXNzIHJlZGlyZWN0IGRldiBldGgwXzENCg0KCSQgdGMgZmlsdGVyIGFkZCBkZXYgdnhs
YW4wIHByb3RvY29sIGlwIHBhcmVudCBmZmZmOiBwcmlvIDEgXA0KCQlmbG93ZXIgZHN0X21hYyAw
MDoxMToyMjozMzo0NDowMCBcDQoJCWVuY19zcmNfaXAgSG9zdDFfSVAgZW5jX2RzdF9pcCAyLjIu
Mi4xMDAgXA0KCQllbmNfZHN0X3BvcnQgNDc4OSBlbmNfa2V5X2lkIDEwMCBcDQoJCWFjdGlvbiB0
dW5uZWxfa2V5IHVuc2V0IGFjdGlvbiBtaXJyZWQgZWdyZXNzIHJlZGlyZWN0IGRldiBldGgwXzEN
Cg0KSWYgd2Ugc3VwcG9ydCBmbG93cyB3aGljaCBvbmx5IG1hdGNoIHRoZSBlbmNfa2V5X2lkIGFu
ZCBlbmNfZHN0X3BvcnQsDQphIGZsb3cgY2FuIHByb2Nlc3MgdGhlIHBhY2tldHMgc2VudCB0byBW
TSB3aGljaCAobWFjIDAwOjExOjIyOjMzOjQ0OjAwKS4NCg0KCSQgdGMgZmlsdGVyIGFkZCBkZXYg
dnhsYW4wIHByb3RvY29sIGlwIHBhcmVudCBmZmZmOiBwcmlvIDEgXA0KCQlmbG93ZXIgZHN0X21h
YyAwMDoxMToyMjozMzo0NDowMCBcDQoJCWVuY19kc3RfcG9ydCA0Nzg5IGVuY19rZXlfaWQgMTAw
IFwNCgkJYWN0aW9uIHR1bm5lbF9rZXkgdW5zZXQgYWN0aW9uIG1pcnJlZCBlZ3Jlc3MgcmVkaXJl
Y3QgZGV2IGV0aDBfMQ0KDQpTaWduZWQtb2ZmLWJ5OiBUb25naGFvIFpoYW5nIDx4aWFuZ3hpYS5t
Lnl1ZUBnbWFpbC5jb20+DQpSZXZpZXdlZC1ieTogUm9pIERheWFuIDxyb2lkQG1lbGxhbm94LmNv
bT4NClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0K
LS0tDQogLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYyAgIHwgMjcg
KysrKystLS0tLS0tLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDIw
IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL2VuX3RjLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZW5fdGMuYw0KaW5kZXggMzFjZDAyZjExNDk5Li4xYzQ5Yjc0NWI1NzkgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYw0KKysr
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3RjLmMNCkBAIC0x
MzM5LDcgKzEzMzksNiBAQCBzdGF0aWMgaW50IHBhcnNlX3R1bm5lbF9hdHRyKHN0cnVjdCBtbHg1
ZV9wcml2ICpwcml2LA0KIAl2b2lkICpoZWFkZXJzX3YgPSBNTFg1X0FERFJfT0YoZnRlX21hdGNo
X3BhcmFtLCBzcGVjLT5tYXRjaF92YWx1ZSwNCiAJCQkJICAgICAgIG91dGVyX2hlYWRlcnMpOw0K
IAlzdHJ1Y3QgZmxvd19ydWxlICpydWxlID0gdGNfY2xzX2Zsb3dlcl9vZmZsb2FkX2Zsb3dfcnVs
ZShmKTsNCi0Jc3RydWN0IGZsb3dfbWF0Y2hfY29udHJvbCBlbmNfY29udHJvbDsNCiAJaW50IGVy
cjsNCiANCiAJZXJyID0gbWx4NWVfdGNfdHVuX3BhcnNlKGZpbHRlcl9kZXYsIHByaXYsIHNwZWMs
IGYsDQpAQCAtMTM1MCw5ICsxMzQ5LDcgQEAgc3RhdGljIGludCBwYXJzZV90dW5uZWxfYXR0cihz
dHJ1Y3QgbWx4NWVfcHJpdiAqcHJpdiwNCiAJCXJldHVybiBlcnI7DQogCX0NCiANCi0JZmxvd19y
dWxlX21hdGNoX2VuY19jb250cm9sKHJ1bGUsICZlbmNfY29udHJvbCk7DQotDQotCWlmIChlbmNf
Y29udHJvbC5rZXktPmFkZHJfdHlwZSA9PSBGTE9XX0RJU1NFQ1RPUl9LRVlfSVBWNF9BRERSUykg
ew0KKwlpZiAoZmxvd19ydWxlX21hdGNoX2tleShydWxlLCBGTE9XX0RJU1NFQ1RPUl9LRVlfRU5D
X0lQVjRfQUREUlMpKSB7DQogCQlzdHJ1Y3QgZmxvd19tYXRjaF9pcHY0X2FkZHJzIG1hdGNoOw0K
IA0KIAkJZmxvd19ydWxlX21hdGNoX2VuY19pcHY0X2FkZHJzKHJ1bGUsICZtYXRjaCk7DQpAQCAt
MTM3Miw3ICsxMzY5LDcgQEAgc3RhdGljIGludCBwYXJzZV90dW5uZWxfYXR0cihzdHJ1Y3QgbWx4
NWVfcHJpdiAqcHJpdiwNCiANCiAJCU1MWDVfU0VUX1RPX09ORVMoZnRlX21hdGNoX3NldF9seXJf
Ml80LCBoZWFkZXJzX2MsIGV0aGVydHlwZSk7DQogCQlNTFg1X1NFVChmdGVfbWF0Y2hfc2V0X2x5
cl8yXzQsIGhlYWRlcnNfdiwgZXRoZXJ0eXBlLCBFVEhfUF9JUCk7DQotCX0gZWxzZSBpZiAoZW5j
X2NvbnRyb2wua2V5LT5hZGRyX3R5cGUgPT0gRkxPV19ESVNTRUNUT1JfS0VZX0lQVjZfQUREUlMp
IHsNCisJfSBlbHNlIGlmIChmbG93X3J1bGVfbWF0Y2hfa2V5KHJ1bGUsIEZMT1dfRElTU0VDVE9S
X0tFWV9FTkNfSVBWNl9BRERSUykpIHsNCiAJCXN0cnVjdCBmbG93X21hdGNoX2lwdjZfYWRkcnMg
bWF0Y2g7DQogDQogCQlmbG93X3J1bGVfbWF0Y2hfZW5jX2lwdjZfYWRkcnMocnVsZSwgJm1hdGNo
KTsNCkBAIC0xNTA0LDIyICsxNTAxLDEyIEBAIHN0YXRpYyBpbnQgX19wYXJzZV9jbHNfZmxvd2Vy
KHN0cnVjdCBtbHg1ZV9wcml2ICpwcml2LA0KIAkJcmV0dXJuIC1FT1BOT1RTVVBQOw0KIAl9DQog
DQotCWlmICgoZmxvd19ydWxlX21hdGNoX2tleShydWxlLCBGTE9XX0RJU1NFQ1RPUl9LRVlfRU5D
X0lQVjRfQUREUlMpIHx8DQotCSAgICAgZmxvd19ydWxlX21hdGNoX2tleShydWxlLCBGTE9XX0RJ
U1NFQ1RPUl9LRVlfRU5DX0tFWUlEKSB8fA0KLQkgICAgIGZsb3dfcnVsZV9tYXRjaF9rZXkocnVs
ZSwgRkxPV19ESVNTRUNUT1JfS0VZX0VOQ19QT1JUUykpICYmDQotCSAgICBmbG93X3J1bGVfbWF0
Y2hfa2V5KHJ1bGUsIEZMT1dfRElTU0VDVE9SX0tFWV9FTkNfQ09OVFJPTCkpIHsNCi0JCXN0cnVj
dCBmbG93X21hdGNoX2NvbnRyb2wgbWF0Y2g7DQotDQotCQlmbG93X3J1bGVfbWF0Y2hfZW5jX2Nv
bnRyb2wocnVsZSwgJm1hdGNoKTsNCi0JCXN3aXRjaCAobWF0Y2gua2V5LT5hZGRyX3R5cGUpIHsN
Ci0JCWNhc2UgRkxPV19ESVNTRUNUT1JfS0VZX0lQVjRfQUREUlM6DQotCQljYXNlIEZMT1dfRElT
U0VDVE9SX0tFWV9JUFY2X0FERFJTOg0KLQkJCWlmIChwYXJzZV90dW5uZWxfYXR0cihwcml2LCBz
cGVjLCBmLCBmaWx0ZXJfZGV2LCB0dW5uZWxfbWF0Y2hfbGV2ZWwpKQ0KLQkJCQlyZXR1cm4gLUVP
UE5PVFNVUFA7DQotCQkJYnJlYWs7DQotCQlkZWZhdWx0Og0KKwlpZiAoZmxvd19ydWxlX21hdGNo
X2tleShydWxlLCBGTE9XX0RJU1NFQ1RPUl9LRVlfRU5DX0lQVjRfQUREUlMpIHx8DQorCSAgICBm
bG93X3J1bGVfbWF0Y2hfa2V5KHJ1bGUsIEZMT1dfRElTU0VDVE9SX0tFWV9FTkNfSVBWNl9BRERS
UykgfHwNCisJICAgIGZsb3dfcnVsZV9tYXRjaF9rZXkocnVsZSwgRkxPV19ESVNTRUNUT1JfS0VZ
X0VOQ19LRVlJRCkgfHwNCisJICAgIGZsb3dfcnVsZV9tYXRjaF9rZXkocnVsZSwgRkxPV19ESVNT
RUNUT1JfS0VZX0VOQ19QT1JUUykpIHsNCisJCWlmIChwYXJzZV90dW5uZWxfYXR0cihwcml2LCBz
cGVjLCBmLCBmaWx0ZXJfZGV2LCB0dW5uZWxfbWF0Y2hfbGV2ZWwpKQ0KIAkJCXJldHVybiAtRU9Q
Tk9UU1VQUDsNCi0JCX0NCiANCiAJCS8qIEluIGRlY2FwIGZsb3csIGhlYWRlciBwb2ludGVycyBz
aG91bGQgcG9pbnQgdG8gdGhlIGlubmVyDQogCQkgKiBoZWFkZXJzLCBvdXRlciBoZWFkZXIgd2Vy
ZSBhbHJlYWR5IHNldCBieSBwYXJzZV90dW5uZWxfYXR0cg0KLS0gDQoyLjIxLjANCg0K
