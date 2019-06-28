Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3FB65A6EC
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbfF1Wfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:35:52 -0400
Received: from mail-eopbgr70049.outbound.protection.outlook.com ([40.107.7.49]:23750
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726563AbfF1Wfv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 18:35:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=uKTkZT3aEPUsdBUkG21cEqAlHmNkZMdEk9lG88Q60x1gXkZh+b12kpqkXzqqPVS/B+ylt2CiFfT7aFGqUeKJtfL6a7JPfpKugRcg4hDZa7pNAhx7cuQTYzbNLTV3ivJmXoojjAS2yXgaXMUu9rX7NNGUXZ/TEwv1SShbtabhHBc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O02QSOhjzcH13hGPUSRgDeQmGExAnfifaSPxJ7MpgQ0=;
 b=nTqahErw2QWKfKFWRtceKO0zHHRx6nMJdwX5ezOjY5rahT97FUwlKafA078XvlJLNiyShqhKVC/d5AN8MLYkjLuUQQw/ZTlRvKA4DzOtRmdRNppD6fDOCW88BpflM9kx8hBaD8FScIgrWXqVwG0zSXf01NoqQFQEQzR9d6EnhFE=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O02QSOhjzcH13hGPUSRgDeQmGExAnfifaSPxJ7MpgQ0=;
 b=JEfwc5torkTClOXq1/6N0LHBKj+EXxAHt7CglOgXs71jcGv84CxUIipyAH/06Vpuvph/ynkAC8r797Pt3K3KqCLjnHVE4XwbxAb0qDX8EcWyRNL2KAk1UaWOP9oMrLl3Lw4gtpkuPIrkLCybNRjGXjS5u+i7hCio1U5zzLxRvFI=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2357.eurprd05.prod.outlook.com (10.168.56.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.17; Fri, 28 Jun 2019 22:35:46 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 22:35:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: [PATCH mlx5-next 00/18] Mellanox, mlx5 E-Switch and low level updates
Thread-Topic: [PATCH mlx5-next 00/18] Mellanox, mlx5 E-Switch and low level
 updates
Thread-Index: AQHVLgHTW0uU5afEVkKEOy1vM16gTA==
Date:   Fri, 28 Jun 2019 22:35:46 +0000
Message-ID: <20190628223516.9368-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:a03:180::48) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 382ee878-a0df-4e15-8368-08d6fc18f651
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2357;
x-ms-traffictypediagnostic: DB6PR0501MB2357:
x-microsoft-antispam-prvs: <DB6PR0501MB2357A0CD2A0E7C01293360E9BEFC0@DB6PR0501MB2357.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(189003)(199004)(53754006)(6436002)(1076003)(3846002)(6116002)(256004)(66446008)(50226002)(6636002)(15650500001)(66066001)(53936002)(36756003)(71200400001)(71190400001)(186003)(8676002)(52116002)(4326008)(5660300002)(14444005)(26005)(6506007)(305945005)(450100002)(478600001)(64756008)(99286004)(386003)(102836004)(6512007)(110136005)(2906002)(316002)(66476007)(68736007)(14454004)(81166006)(486006)(86362001)(81156014)(73956011)(66946007)(2616005)(6486002)(476003)(66556008)(8936002)(25786009)(54906003)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2357;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cZ7wBWrop23duknfLv9Hb/Hr9/zjiqSv/sGkRn9GN6VxiTzTw+HburuRJ7Be5maHtn0no6Y/f3vntINGu+bJIluxiB/ybCD9cDtLt9XU6p/hiGEocCNREvy9hfHzue8pwGB7Pt5ZaTl0u48Ra9NMhUEMG2AMTVQFsbnlDQa2R4GhB3AKvKp+3rXa+71ddDC3KhcHiZBWKyGCQ9YEC5bWD3VJelAR7fpHwXgyrr9kmZoL6HLwFG54rG+rq5uPNg8Hu68DUOSEmspdel01ywJAynwWVLIUDfGoKvbSjcugT76lm8Z6PqN+m+GFEUjbv3Ugur/JykZWH/yXb4P6gOJzTBq6d1W1oTbj6d5a4bwwc16LlDmUgo8ZWqRmCnhADOpdHRBcIDmiq1DLocxoX0+9msYH+lPe4uiDYyec/BcjLjY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 382ee878-a0df-4e15-8368-08d6fc18f651
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 22:35:46.4257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2357
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWxsLA0KDQpUaGlzIHNlcmllcyBpbmNsdWRlcyBzb21lIGxvdyBsZXZlbCB1cGRhdGVzIG1h
aW5seSBpbiB0aGUgRS1Td2l0Y2gNCm5ldGRldiBhbmQgcmRtYSB2cG9ydCByZXByZXNlbnRvcnMg
YXJlYXMuDQoNCkZyb20gUGFyYXYgYW5kIEh1eToNCiAxKSBBZGRlZCBoYXJkd2FyZSBiaXRzIGFu
ZCBzdHJ1Y3R1cmVzIGRlZmluaXRpb25zIGZvciBzdWItZnVuY3Rpb25zDQogMikgU21hbGwgY29k
ZSBjbGVhbnVwIGFuZCBpbXByb3ZlbWVudCBmb3IgUEYgcGNpIGRyaXZlci4NCg0KRnJvbSBCb2Rv
bmc6DQogMykgVXNlIHRoZSBjb3JyZWN0IG5hbWUgc2VtYW50aWNzIG9mIHZwb3J0IGluZGV4IGFu
ZCB2cG9ydCBudW1iZXINCiA0KSBDbGVhbnVwIHRoZSByZXAgYW5kIG5ldGRldiByZWZlcmVuY2Ug
d2hlbiB1bmxvYWRpbmcgSUIgcmVwLg0KIDUpIEJsdWVmaWVsZCAoRUNQRikgdXBkYXRlcyBhbmQg
cmVmYWN0b3JpbmcgZm9yIGJldHRlciBFLVN3aXRjaCANCiAgICBtYW5hZ2VtZW50IG9uIEVDUEYg
ZW1iZWRkZWQgQ1BVIE5JQzoNCiAgICA1LjEpIENvbnNvbGlkYXRlIHF1ZXJ5aW5nIGVzd2l0Y2gg
bnVtYmVyIG9mIFZGcw0KICAgIDUuMikgUmVnaXN0ZXIgZXZlbnQgaGFuZGxlciBhdCB0aGUgY29y
cmVjdCBFLVN3aXRjaCBpbml0IHN0YWdlDQogICAgNS4zKSBTZXR1cCBQRidzIGlubGluZSBtb2Rl
IGFuZCB2bGFuIHBvcCB3aGVuIHRoZSBFQ1BGIGlzIHRoZQ0KICAgICAgICAgRS1Td3RpY2ggbWFu
YWdlciAoIHRoZSBob3N0IFBGIGlzIGJhc2ljYWxseSBhIFZGICkuDQogICAgNS40KSBIYW5kbGUg
VnBvcnQgVUMgYWRkcmVzcyBjaGFuZ2VzIGluIHN3aXRjaGRldiBtb2RlLg0KDQpGcm9tIFNoYXk6
DQogNikgQWRkIHN1cHBvcnQgZm9yIE1DUUkgYW5kIE1DUVMgaGFyZHdhcmUgcmVnaXN0ZXJzLg0K
DQpJbiBjYXNlIG9mIG5vIG9iamVjdGlvbnMgdGhlc2UgcGF0Y2hlcyB3aWxsIGJlIGFwcGxpZWQg
dG8gbWx4NS1uZXh0IGFuZA0Kd2lsbCBiZSBzZW50IGxhdGVyIGFzIHB1bGwgcmVxdWVzdCB0byBi
b3RoIHJkbWEtbmV4dCBhbmQgbmV0LW5leHQgdHJlZXMuDQoNClRoYW5rcywNClNhZWVkLg0KDQot
LS0NCg0KQm9kb25nIFdhbmcgKDEyKToNCiAgbmV0L21seDU6IEUtU3dpdGNoLCBVc2UgdnBvcnQg
aW5kZXggd2hlbiBpbml0IHJlcA0KICB7SUIsIG5ldH0vbWx4NTogRS1Td2l0Y2gsIFVzZSBpbmRl
eCBvZiByZXAgZm9yIHZwb3J0IHRvIElCIHBvcnQNCiAgICBtYXBwaW5nDQogIFJETUEvbWx4NTog
Q2xlYW51cCByZXAgd2hlbiBkb2luZyB1bmxvYWQNCiAgbmV0L21seDU6IERvbid0IGhhbmRsZSBW
RiBmdW5jIGNoYW5nZSBpZiBob3N0IFBGIGlzIGRpc2FibGVkDQogIG5ldC9tbHg1OiBFLVN3aXRj
aCwgVXNlIGNvcnJlY3QgZmxhZ3Mgd2hlbiBjb25maWd1cmluZyB2bGFuDQogIG5ldC9tbHg1OiBI
YW5kbGUgaG9zdCBQRiB2cG9ydCBtYWMvZ3VpZCBmb3IgRUNQRg0KICBuZXQvbWx4NTogRS1Td2l0
Y2gsIFJlZmFjdG9yIGVzd2l0Y2ggU1ItSU9WIGludGVyZmFjZQ0KICBuZXQvbWx4NTogRS1Td2l0
Y2gsIENvbnNvbGlkYXRlIGVzd2l0Y2ggZnVuY3Rpb24gbnVtYmVyIG9mIFZGcw0KICBuZXQvbWx4
NTogRS1Td2l0Y2gsIFJlZy91bnJlZyBmdW5jdGlvbiBjaGFuZ2VkIGV2ZW50IGF0IGNvcnJlY3Qg
c3RhZ2UNCiAgbmV0L21seDU6IEUtU3dpdGNoLCBVc2UgaXRlcmF0b3IgZm9yIHZsYW4gYW5kIG1p
bi1pbmxpbmUgc2V0dXBzDQogIG5ldC9tbHg1OiBFLVN3aXRjaCwgQ29uc2lkZXIgaG9zdCBQRiBm
b3IgaW5saW5lIG1vZGUgYW5kIHZsYW4gcG9wDQogIG5ldC9tbHg1OiBFLVN3aXRjaCwgSGFuZGxl
IFVDIGFkZHJlc3MgY2hhbmdlIGluIHN3aXRjaGRldiBtb2RlDQoNCkh1eSBOZ3V5ZW4gKDEpOg0K
ICBuZXQvbWx4NTogUmVuYW1lIG1seDVfcGNpX2Rldl90eXBlIHRvIG1seDVfY29yZWRldl90eXBl
DQoNClBhcmF2IFBhbmRpdCAoNCk6DQogIG5ldC9tbHg1OiBBZGQgaGFyZHdhcmUgZGVmaW5pdGlv
bnMgZm9yIHN1YiBmdW5jdGlvbnMNCiAgbmV0L21seDU6IE1vdmUgcGNpIHN0YXR1cyByZWcgYWNj
ZXNzIG11dGV4IHRvIG1seDVfcGNpX2luaXQNCiAgbmV0L21seDU6IExpbWl0IHNjb3BlIG9mIG1s
eDVfZ2V0X25leHRfcGh5c19kZXYoKSB0byBQQ0kgUEYgZGV2aWNlcw0KICBuZXQvbWx4NTogUmVk
dWNlIGRlcGVuZGVuY3kgb24gZW5hYmxlZF92ZnMgY291bnRlciBhbmQgbnVtX3Zmcw0KDQpTaGF5
IEFncm9za2luICgxKToNCiAgbmV0L21seDU6IEFkZGVkIE1DUUkgYW5kIE1DUVMgcmVnaXN0ZXJz
JyBkZXNjcmlwdGlvbiB0byBpZmMNCg0KIGRyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L2liX3Jl
cC5jICAgICAgICAgICB8ICAyMiArLQ0KIGRyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L2liX3Jl
cC5oICAgICAgICAgICB8ICAgMiArLQ0KIGRyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L21haW4u
YyAgICAgICAgICAgICB8ICAgMiArLQ0KIGRyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L21seDVf
aWIuaCAgICAgICAgICB8ICAgMSAtDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL2Rldi5jIHwgICA5ICstDQogLi4uL2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
bl9kY2JubC5jICAgIHwgICAyICstDQogLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZW5fbWFpbi5jIHwgICA0ICstDQogLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZW5fcmVwLmMgIHwgICA4ICstDQogLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZW5fdGMuYyAgIHwgICAyICstDQogLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2Nv
cmUvZXN3aXRjaC5jIHwgMTUxICsrKysrKysrLS0tLS0tDQogLi4uL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZXN3aXRjaC5oIHwgIDQ0ICsrKy0NCiAuLi4vbWVsbGFub3gvbWx4NS9j
b3JlL2Vzd2l0Y2hfb2ZmbG9hZHMuYyAgICAgfCAxOTYgKysrKysrKystLS0tLS0tLS0tDQogLi4u
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9mcGdhL2Nvbm4uYyAgIHwgICAyICstDQogZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xhZy5jIHwgICA0ICstDQogLi4u
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFpbi5jICAgIHwgICA3ICstDQogLi4u
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvcmRtYS5jICAgIHwgICAyICstDQogLi4u
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvc3Jpb3YuYyAgIHwgIDI3ICstLQ0KIC4u
Li9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL3Zwb3J0LmMgICB8ICAyOCArKy0NCiBp
bmNsdWRlL2xpbnV4L21seDUvZHJpdmVyLmggICAgICAgICAgICAgICAgICAgfCAgMTMgKy0NCiBp
bmNsdWRlL2xpbnV4L21seDUvZXN3aXRjaC5oICAgICAgICAgICAgICAgICAgfCAgIDggKy0NCiBp
bmNsdWRlL2xpbnV4L21seDUvbWx4NV9pZmMuaCAgICAgICAgICAgICAgICAgfCAxNjEgKysrKysr
KysrKysrKy0NCiBpbmNsdWRlL2xpbnV4L21seDUvdnBvcnQuaCAgICAgICAgICAgICAgICAgICAg
fCAgIDQgKy0NCiAyMiBmaWxlcyBjaGFuZ2VkLCA0NDYgaW5zZXJ0aW9ucygrKSwgMjUzIGRlbGV0
aW9ucygtKQ0KDQotLSANCjIuMjEuMA0KDQo=
