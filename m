Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5C03123229
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbfLQQUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:20:47 -0500
Received: from mail-eopbgr150048.outbound.protection.outlook.com ([40.107.15.48]:52522
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729109AbfLQQUq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:20:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bwxlc+9ER5Tkszp9XCtqXlfdcDYxc20GprQiZcQxkIPS6MZZtxp48ywTRw0D8agR9lCBJTHYuwkw6LkIp8fFgAMmxy484UynZywynN2/CEPnGIMYw3Pr1Iq+ZNKLsOHCAJAbaq2OjbtZAQvYXE+PlomQWROZ3IsW1bD2vqO11IM+0btLoFJae+DiiWNK4ORclscSybxPXmld8Q58W4NKglxR44q3cxkXbchsqYWUEVv//iT9yxk3kDd+RCQGNIKeqVIBIwtjE+TMLf2B1LZDYBCIp6Ac0VZkVlKPBNbkiKYEYbL8QUwBl0tEgNThVxpikrPVBoY6ADwJLPk1+EvPYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=96I45c20mkD4SX6JJqFavapUsva0+UyUBcwzlHEgMJ0=;
 b=OwzPBA2QcfQrJ6k2m2liz/S/1bLsug8oSDdN2HGX/OI6STXSfQreGtG2buZNJ80ndB9Rr2PEjgOohkW60O4pCxQci2lEIvGGyy7yIm2KijoDnNZ5OAZrUj6/6wpibOzBMbI3jcK9rknggwA7AWdhlxLupn9YGUO9fvivfop8gicT+om2+lO7aWQMj2HKDXfaN+vnUHZmLlGmMhJAWdngDDuRFxY5QkbUu1A/uNkDkbGHDSazN7afOfr2qsxyGpAMQAuRLn9WhKTT7W9wXln12CrUuyFv/TYbPyBtVknQmcXCwqTyFWH9NLVqtYnPAyRc1pwkpOHFN5jV0nafqQQgtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=96I45c20mkD4SX6JJqFavapUsva0+UyUBcwzlHEgMJ0=;
 b=g1FU2BykuA6UoIf1B0tv2wZKuqzxvogg6GEPHd8/VN1Hl5Xny07lxRdytCGoLpus6ErVZ9HXsP+KN1NgrJ5Jdg/ZhuCu0fCecZxpS8JwlgK+oi80dR+2ZFfOs+uwnJwWRoLqpr12DK0pBK40CnwggqyY2E5fdwnqJcPs4wcj70w=
Received: from AM0PR05MB5875.eurprd05.prod.outlook.com (20.178.119.159) by
 AM0PR05MB4259.eurprd05.prod.outlook.com (52.134.126.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 16:20:42 +0000
Received: from AM0PR05MB5875.eurprd05.prod.outlook.com
 ([fe80::259f:70b4:dab1:8f2]) by AM0PR05MB5875.eurprd05.prod.outlook.com
 ([fe80::259f:70b4:dab1:8f2%5]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:20:42 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH bpf v2 1/4] xsk: Add rcu_read_lock around the XSK wakeup
Thread-Topic: [PATCH bpf v2 1/4] xsk: Add rcu_read_lock around the XSK wakeup
Thread-Index: AQHVtPXtaoctvxImXEqJg/j0DO4nLQ==
Date:   Tue, 17 Dec 2019 16:20:42 +0000
Message-ID: <20191217162023.16011-2-maximmi@mellanox.com>
References: <20191217162023.16011-1-maximmi@mellanox.com>
In-Reply-To: <20191217162023.16011-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR02CA0106.eurprd02.prod.outlook.com
 (2603:10a6:208:154::47) To AM0PR05MB5875.eurprd05.prod.outlook.com
 (2603:10a6:208:12d::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [94.188.199.18]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 832d8f35-92d3-46c5-7fb2-08d7830d101a
x-ms-traffictypediagnostic: AM0PR05MB4259:|AM0PR05MB4259:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB4259D4940143E905673C1743D1500@AM0PR05MB4259.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(346002)(396003)(39860400002)(199004)(189003)(54906003)(26005)(66556008)(6506007)(110136005)(66476007)(2906002)(7416002)(64756008)(186003)(5660300002)(66446008)(36756003)(52116002)(1076003)(8676002)(81166006)(71200400001)(86362001)(81156014)(6486002)(107886003)(2616005)(478600001)(316002)(66946007)(6512007)(66574012)(8936002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4259;H:AM0PR05MB5875.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oNh+qrDpKxkPXpyzf1HFaYR9K1MpEl/evuC6n1k9R5i/LlJjG792XNNIzr1RqTGsqOIG3jrg1VNlo6c1kAQFaEJYPfeirSUcYD4avto1V8aE7mlQuCK2lAhCmC++0fYkCLZZ2dFr3nDTQwWPn4PDPioesmC7WcpCcSdiNY6LY0B10ajjPZjMDligp7S3qVUMD5KTWwX0XIX+QW3aukEdr2Mt/1J07E5k0O7UX3dji/cVVZv3MFGQm3HD1xFSpj85MsId5oFt6h14VcckejEv+hGwd3qEQ6brChL/kRlmOMoO4acPFdtniOMjE+iZ/ngvqJIKFkwThmdAVxTPY/jScjKJ+dIlseXB5Ilqfjtqu9mb5oshlX3olLLE5IGrwTFhBd6GQNEU7mbSPUJ0EU20Ar217LqFPzGmucC90CcWYMcn9HEvzXTz7GKKCETAwLeo
Content-Type: text/plain; charset="utf-8"
Content-ID: <739D416719AFBA4FB74A2C4EFF9D89E8@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 832d8f35-92d3-46c5-7fb2-08d7830d101a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:20:42.5919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tNClFnBUELSjSG2Pz4Y6wpq2xRBUgcHboljY/0TwFvAXGS/9NucKuWGQoIfybWZDvJzg4M72PW5xueuZ9xLYKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4259
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIFhTSyB3YWtldXAgY2FsbGJhY2sgaW4gZHJpdmVycyBtYWtlcyBzb21lIHNhbml0eSBjaGVj
a3MgYmVmb3JlDQp0cmlnZ2VyaW5nIE5BUEkuIEhvd2V2ZXIsIHNvbWUgY29uZmlndXJhdGlvbiBj
aGFuZ2VzIG1heSBvY2N1ciBkdXJpbmcNCnRoaXMgZnVuY3Rpb24gdGhhdCBhZmZlY3QgdGhlIHJl
c3VsdCBvZiB0aG9zZSBjaGVja3MuIEZvciBleGFtcGxlLCB0aGUNCmludGVyZmFjZSBjYW4gZ28g
ZG93biwgYW5kIGFsbCB0aGUgcmVzb3VyY2VzIHdpbGwgYmUgZGVzdHJveWVkIGFmdGVyIHRoZQ0K
Y2hlY2tzIGluIHRoZSB3YWtldXAgZnVuY3Rpb24sIGJ1dCBiZWZvcmUgaXQgYXR0ZW1wdHMgdG8g
dXNlIHRoZXNlDQpyZXNvdXJjZXMuIFdyYXAgdGhpcyBjYWxsYmFjayBpbiByY3VfcmVhZF9sb2Nr
IHRvIGFsbG93IGRyaXZlciB0bw0Kc3luY2hyb25pemVfcmN1IGJlZm9yZSBhY3R1YWxseSBkZXN0
cm95aW5nIHRoZSByZXNvdXJjZXMuDQoNCnhza193YWtldXAgaXMgYSBuZXcgZnVuY3Rpb24gdGhh
dCBlbmNhcHN1bGF0ZXMgY2FsbGluZyBuZG9feHNrX3dha2V1cA0Kd3JhcHBlZCBpbnRvIHRoZSBS
Q1UgbG9jay4gQWZ0ZXIgdGhpcyBjb21taXQsIHhza19wb2xsIHN0YXJ0cyB1c2luZw0KeHNrX3dh
a2V1cCBhbmQgY2hlY2tzIHhzLT56YyBpbnN0ZWFkIG9mIG5kb194c2tfd2FrZXVwICE9IE5VTEwg
dG8gZGVjaWRlDQpuZG9feHNrX3dha2V1cCBzaG91bGQgYmUgY2FsbGVkLiBJdCBhbHNvIGZpeGVz
IGEgYnVnIGludHJvZHVjZWQgd2l0aCB0aGUNCm5lZWRfd2FrZXVwIGZlYXR1cmU6IGEgbm9uLXpl
cm8tY29weSBzb2NrZXQgbWF5IGJlIHVzZWQgd2l0aCBhIGRyaXZlcg0Kc3VwcG9ydGluZyB6ZXJv
LWNvcHksIGFuZCBpbiB0aGlzIGNhc2UgbmRvX3hza193YWtldXAgc2hvdWxkIG5vdCBiZQ0KY2Fs
bGVkLCBzbyB0aGUgeHMtPnpjIGNoZWNrIGlzIHRoZSBjb3JyZWN0IG9uZS4NCg0KRml4ZXM6IDc3
Y2QwZDdiM2YyNSAoInhzazogYWRkIHN1cHBvcnQgZm9yIG5lZWRfd2FrZXVwIGZsYWcgaW4gQUZf
WERQIHJpbmdzIikNClNpZ25lZC1vZmYtYnk6IE1heGltIE1pa2l0eWFuc2tpeSA8bWF4aW1taUBt
ZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBCasO2cm4gVMO2cGVsIDxiam9ybi50b3BlbEBp
bnRlbC5jb20+DQotLS0NCiBuZXQveGRwL3hzay5jIHwgMjIgKysrKysrKysrKysrKystLS0tLS0t
LQ0KIDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0KDQpk
aWZmIC0tZ2l0IGEvbmV0L3hkcC94c2suYyBiL25ldC94ZHAveHNrLmMNCmluZGV4IDk1Njc5Mzg5
M2M5ZC4uMzI4ZjY2MWI4M2IyIDEwMDY0NA0KLS0tIGEvbmV0L3hkcC94c2suYw0KKysrIGIvbmV0
L3hkcC94c2suYw0KQEAgLTMzNCwxMiArMzM0LDIxIEBAIGJvb2wgeHNrX3VtZW1fY29uc3VtZV90
eChzdHJ1Y3QgeGRwX3VtZW0gKnVtZW0sIHN0cnVjdCB4ZHBfZGVzYyAqZGVzYykNCiB9DQogRVhQ
T1JUX1NZTUJPTCh4c2tfdW1lbV9jb25zdW1lX3R4KTsNCiANCi1zdGF0aWMgaW50IHhza196Y194
bWl0KHN0cnVjdCB4ZHBfc29jayAqeHMpDQorc3RhdGljIGludCB4c2tfd2FrZXVwKHN0cnVjdCB4
ZHBfc29jayAqeHMsIHU4IGZsYWdzKQ0KIHsNCiAJc3RydWN0IG5ldF9kZXZpY2UgKmRldiA9IHhz
LT5kZXY7DQorCWludCBlcnI7DQorDQorCXJjdV9yZWFkX2xvY2soKTsNCisJZXJyID0gZGV2LT5u
ZXRkZXZfb3BzLT5uZG9feHNrX3dha2V1cChkZXYsIHhzLT5xdWV1ZV9pZCwgZmxhZ3MpOw0KKwly
Y3VfcmVhZF91bmxvY2soKTsNCisNCisJcmV0dXJuIGVycjsNCit9DQogDQotCXJldHVybiBkZXYt
Pm5ldGRldl9vcHMtPm5kb194c2tfd2FrZXVwKGRldiwgeHMtPnF1ZXVlX2lkLA0KLQkJCQkJICAg
ICAgIFhEUF9XQUtFVVBfVFgpOw0KK3N0YXRpYyBpbnQgeHNrX3pjX3htaXQoc3RydWN0IHhkcF9z
b2NrICp4cykNCit7DQorCXJldHVybiB4c2tfd2FrZXVwKHhzLCBYRFBfV0FLRVVQX1RYKTsNCiB9
DQogDQogc3RhdGljIHZvaWQgeHNrX2Rlc3RydWN0X3NrYihzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0K
QEAgLTQ1MywxOSArNDYyLDE2IEBAIHN0YXRpYyBfX3BvbGxfdCB4c2tfcG9sbChzdHJ1Y3QgZmls
ZSAqZmlsZSwgc3RydWN0IHNvY2tldCAqc29jaywNCiAJX19wb2xsX3QgbWFzayA9IGRhdGFncmFt
X3BvbGwoZmlsZSwgc29jaywgd2FpdCk7DQogCXN0cnVjdCBzb2NrICpzayA9IHNvY2stPnNrOw0K
IAlzdHJ1Y3QgeGRwX3NvY2sgKnhzID0geGRwX3NrKHNrKTsNCi0Jc3RydWN0IG5ldF9kZXZpY2Ug
KmRldjsNCiAJc3RydWN0IHhkcF91bWVtICp1bWVtOw0KIA0KIAlpZiAodW5saWtlbHkoIXhza19p
c19ib3VuZCh4cykpKQ0KIAkJcmV0dXJuIG1hc2s7DQogDQotCWRldiA9IHhzLT5kZXY7DQogCXVt
ZW0gPSB4cy0+dW1lbTsNCiANCiAJaWYgKHVtZW0tPm5lZWRfd2FrZXVwKSB7DQotCQlpZiAoZGV2
LT5uZXRkZXZfb3BzLT5uZG9feHNrX3dha2V1cCkNCi0JCQlkZXYtPm5ldGRldl9vcHMtPm5kb194
c2tfd2FrZXVwKGRldiwgeHMtPnF1ZXVlX2lkLA0KLQkJCQkJCQl1bWVtLT5uZWVkX3dha2V1cCk7
DQorCQlpZiAoeHMtPnpjKQ0KKwkJCXhza193YWtldXAoeHMsIHVtZW0tPm5lZWRfd2FrZXVwKTsN
CiAJCWVsc2UNCiAJCQkvKiBQb2xsIG5lZWRzIHRvIGRyaXZlIFR4IGFsc28gaW4gY29weSBtb2Rl
ICovDQogCQkJX194c2tfc2VuZG1zZyhzayk7DQotLSANCjIuMjAuMQ0KDQo=
