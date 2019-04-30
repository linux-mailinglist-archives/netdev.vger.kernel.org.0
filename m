Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A56810100
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 22:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbfD3Ujw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 16:39:52 -0400
Received: from mail-eopbgr10048.outbound.protection.outlook.com ([40.107.1.48]:9176
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726372AbfD3Ujv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 16:39:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qMPo+bS+AbaWnM7Zd+kCPuFvwO0XCkXRIOl+xJpTDk=;
 b=keg2UubAbttMjpptZlUO6PVvFvIRpdxADyeBWauOya1iNRSCI4OHCqmIE/HiVLKY7dQ+vrGCLkZU6c1BrS5fAzsIq6lMz6VXK+HvO/CvRC8i9w9LbvlGn+/H1AiNtumm53Iu8VZEA41+OWFvWOlgNBOo0Q1Bg0MySy0RukCVYuY=
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com (20.178.125.223) by
 VI1PR05MB6542.eurprd05.prod.outlook.com (20.179.27.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Tue, 30 Apr 2019 20:39:47 +0000
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::1d74:be4b:cfe9:59a2]) by VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::1d74:be4b:cfe9:59a2%5]) with mapi id 15.20.1835.018; Tue, 30 Apr 2019
 20:39:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/15] net/mlx5e: Take common TIR context settings into a
 function
Thread-Topic: [net-next 01/15] net/mlx5e: Take common TIR context settings
 into a function
Thread-Index: AQHU/5TZr0GtsK3QAUubU0zFkHUpiQ==
Date:   Tue, 30 Apr 2019 20:39:47 +0000
Message-ID: <20190430203926.19284-2-saeedm@mellanox.com>
References: <20190430203926.19284-1-saeedm@mellanox.com>
In-Reply-To: <20190430203926.19284-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0055.namprd02.prod.outlook.com
 (2603:10b6:a03:54::32) To VI1PR05MB5902.eurprd05.prod.outlook.com
 (2603:10a6:803:df::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68cbe2b9-31bb-4740-261a-08d6cdabfbb4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB6542;
x-ms-traffictypediagnostic: VI1PR05MB6542:
x-microsoft-antispam-prvs: <VI1PR05MB654226A272092825B8291C9DBE3A0@VI1PR05MB6542.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:129;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(396003)(366004)(39860400002)(189003)(199004)(99286004)(25786009)(102836004)(53936002)(36756003)(386003)(478600001)(186003)(6506007)(7736002)(26005)(2616005)(476003)(446003)(52116002)(6436002)(4326008)(305945005)(5660300002)(76176011)(486006)(66066001)(11346002)(14454004)(107886003)(6512007)(6486002)(68736007)(71200400001)(2906002)(6916009)(81166006)(316002)(1076003)(97736004)(81156014)(66446008)(64756008)(66556008)(50226002)(66476007)(66946007)(73956011)(8936002)(54906003)(256004)(8676002)(3846002)(86362001)(6116002)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6542;H:VI1PR05MB5902.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fTnzeQWVVUx5BktaKXravlJ4z8tUdA2CrakUM3vGQAeLoneWjudOH88/soYvPe2YW4Ntgw0ZH4DIXfK0wRqMFkxGnitvi4LCeA0cS2CVibQBh+jL/DG2XIeDIHSi3hIkE+NONc7Mxr+nBgWPn7llxX08uklYU7CKFEc97yXd3BEXtqref+NJNVbdtyNRC9H97o8GKLfVSViaVmGXVzh95UqfPem58J8LaU0HK5ad0MArHRe2IzNBsEDmbJiYn/8Ldcr7xPIncnyKcvw+D8qYA+Dyj/hi91aLM/OoS96K2i7fnOeFuM52VibFKxEiRaTRxldhghuguZ4EuOvbUJmlOtuSXY4qQ+mCk3LX2I+L/oqJbMZwcBO0WoEIfiKOMmWGgyGVWMdkt3wUYLFABEag2unHLQJXkqYIIZHtGz4dxFM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68cbe2b9-31bb-4740-261a-08d6cdabfbb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 20:39:47.0426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6542
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVGFyaXEgVG91a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0KDQpNYW55IFRJUiBjb250
ZXh0IHNldHRpbmdzIGFyZSBjb21tb24gdG8gZGlmZmVyZW50IFRJUiB0eXBlcywNCnRha2UgdGhl
bSBpbnRvIGEgY29tbW9uIGZ1bmN0aW9uLg0KDQpTaWduZWQtb2ZmLWJ5OiBUYXJpcSBUb3VrYW4g
PHRhcmlxdEBtZWxsYW5veC5jb20+DQpSZXZpZXdlZC1ieTogQXlhIExldmluIDxheWFsQG1lbGxh
bm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3gu
Y29tPg0KLS0tDQogLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5j
IHwgNDkgKysrKysrKystLS0tLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAyMSBpbnNlcnRpb25z
KCspLCAyOCBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lbl9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jDQppbmRleCAyMzZjY2U1OTE4MWQuLmQ3MTNhYjJlN2Ey
ZCAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
bl9tYWluLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
bl9tYWluLmMNCkBAIC0yNjc0LDIyICsyNjc0LDYgQEAgc3RhdGljIGludCBtbHg1ZV9tb2RpZnlf
dGlyc19scm8oc3RydWN0IG1seDVlX3ByaXYgKnByaXYpDQogCXJldHVybiBlcnI7DQogfQ0KIA0K
LXN0YXRpYyB2b2lkIG1seDVlX2J1aWxkX2lubmVyX2luZGlyX3Rpcl9jdHgoc3RydWN0IG1seDVl
X3ByaXYgKnByaXYsDQotCQkJCQkgICAgZW51bSBtbHg1ZV90cmFmZmljX3R5cGVzIHR0LA0KLQkJ
CQkJICAgIHUzMiAqdGlyYykNCi17DQotCU1MWDVfU0VUKHRpcmMsIHRpcmMsIHRyYW5zcG9ydF9k
b21haW4sIHByaXYtPm1kZXYtPm1seDVlX3Jlcy50ZC50ZG4pOw0KLQ0KLQltbHg1ZV9idWlsZF90
aXJfY3R4X2xybygmcHJpdi0+Y2hhbm5lbHMucGFyYW1zLCB0aXJjKTsNCi0NCi0JTUxYNV9TRVQo
dGlyYywgdGlyYywgZGlzcF90eXBlLCBNTFg1X1RJUkNfRElTUF9UWVBFX0lORElSRUNUKTsNCi0J
TUxYNV9TRVQodGlyYywgdGlyYywgaW5kaXJlY3RfdGFibGUsIHByaXYtPmluZGlyX3JxdC5ycXRu
KTsNCi0JTUxYNV9TRVQodGlyYywgdGlyYywgdHVubmVsZWRfb2ZmbG9hZF9lbiwgMHgxKTsNCi0N
Ci0JbWx4NWVfYnVpbGRfaW5kaXJfdGlyX2N0eF9oYXNoKCZwcml2LT5yc3NfcGFyYW1zLA0KLQkJ
CQkgICAgICAgJnRpcmNfZGVmYXVsdF9jb25maWdbdHRdLCB0aXJjLCB0cnVlKTsNCi19DQotDQog
c3RhdGljIGludCBtbHg1ZV9zZXRfbXR1KHN0cnVjdCBtbHg1X2NvcmVfZGV2ICptZGV2LA0KIAkJ
CSBzdHJ1Y3QgbWx4NWVfcGFyYW1zICpwYXJhbXMsIHUxNiBtdHUpDQogew0KQEAgLTMxMTAsMzIg
KzMwOTQsNDEgQEAgc3RhdGljIHZvaWQgbWx4NWVfY2xlYW51cF9uaWNfdHgoc3RydWN0IG1seDVl
X3ByaXYgKnByaXYpDQogCQltbHg1ZV9kZXN0cm95X3Rpcyhwcml2LT5tZGV2LCBwcml2LT50aXNu
W3RjXSk7DQogfQ0KIA0KLXN0YXRpYyB2b2lkIG1seDVlX2J1aWxkX2luZGlyX3Rpcl9jdHgoc3Ry
dWN0IG1seDVlX3ByaXYgKnByaXYsDQotCQkJCSAgICAgIGVudW0gbWx4NWVfdHJhZmZpY190eXBl
cyB0dCwNCi0JCQkJICAgICAgdTMyICp0aXJjKQ0KK3N0YXRpYyB2b2lkIG1seDVlX2J1aWxkX2lu
ZGlyX3Rpcl9jdHhfY29tbW9uKHN0cnVjdCBtbHg1ZV9wcml2ICpwcml2LA0KKwkJCQkJICAgICB1
MzIgcnF0biwgdTMyICp0aXJjKQ0KIHsNCiAJTUxYNV9TRVQodGlyYywgdGlyYywgdHJhbnNwb3J0
X2RvbWFpbiwgcHJpdi0+bWRldi0+bWx4NWVfcmVzLnRkLnRkbik7DQorCU1MWDVfU0VUKHRpcmMs
IHRpcmMsIGRpc3BfdHlwZSwgTUxYNV9USVJDX0RJU1BfVFlQRV9JTkRJUkVDVCk7DQorCU1MWDVf
U0VUKHRpcmMsIHRpcmMsIGluZGlyZWN0X3RhYmxlLCBycXRuKTsNCiANCiAJbWx4NWVfYnVpbGRf
dGlyX2N0eF9scm8oJnByaXYtPmNoYW5uZWxzLnBhcmFtcywgdGlyYyk7DQorfQ0KIA0KLQlNTFg1
X1NFVCh0aXJjLCB0aXJjLCBkaXNwX3R5cGUsIE1MWDVfVElSQ19ESVNQX1RZUEVfSU5ESVJFQ1Qp
Ow0KLQlNTFg1X1NFVCh0aXJjLCB0aXJjLCBpbmRpcmVjdF90YWJsZSwgcHJpdi0+aW5kaXJfcnF0
LnJxdG4pOw0KLQ0KK3N0YXRpYyB2b2lkIG1seDVlX2J1aWxkX2luZGlyX3Rpcl9jdHgoc3RydWN0
IG1seDVlX3ByaXYgKnByaXYsDQorCQkJCSAgICAgIGVudW0gbWx4NWVfdHJhZmZpY190eXBlcyB0
dCwNCisJCQkJICAgICAgdTMyICp0aXJjKQ0KK3sNCisJbWx4NWVfYnVpbGRfaW5kaXJfdGlyX2N0
eF9jb21tb24ocHJpdiwgcHJpdi0+aW5kaXJfcnF0LnJxdG4sIHRpcmMpOw0KIAltbHg1ZV9idWls
ZF9pbmRpcl90aXJfY3R4X2hhc2goJnByaXYtPnJzc19wYXJhbXMsDQogCQkJCSAgICAgICAmdGly
Y19kZWZhdWx0X2NvbmZpZ1t0dF0sIHRpcmMsIGZhbHNlKTsNCiB9DQogDQogc3RhdGljIHZvaWQg
bWx4NWVfYnVpbGRfZGlyZWN0X3Rpcl9jdHgoc3RydWN0IG1seDVlX3ByaXYgKnByaXYsIHUzMiBy
cXRuLCB1MzIgKnRpcmMpDQogew0KLQlNTFg1X1NFVCh0aXJjLCB0aXJjLCB0cmFuc3BvcnRfZG9t
YWluLCBwcml2LT5tZGV2LT5tbHg1ZV9yZXMudGQudGRuKTsNCi0NCi0JbWx4NWVfYnVpbGRfdGly
X2N0eF9scm8oJnByaXYtPmNoYW5uZWxzLnBhcmFtcywgdGlyYyk7DQotDQotCU1MWDVfU0VUKHRp
cmMsIHRpcmMsIGRpc3BfdHlwZSwgTUxYNV9USVJDX0RJU1BfVFlQRV9JTkRJUkVDVCk7DQotCU1M
WDVfU0VUKHRpcmMsIHRpcmMsIGluZGlyZWN0X3RhYmxlLCBycXRuKTsNCisJbWx4NWVfYnVpbGRf
aW5kaXJfdGlyX2N0eF9jb21tb24ocHJpdiwgcnF0biwgdGlyYyk7DQogCU1MWDVfU0VUKHRpcmMs
IHRpcmMsIHJ4X2hhc2hfZm4sIE1MWDVfUlhfSEFTSF9GTl9JTlZFUlRFRF9YT1I4KTsNCiB9DQog
DQorc3RhdGljIHZvaWQgbWx4NWVfYnVpbGRfaW5uZXJfaW5kaXJfdGlyX2N0eChzdHJ1Y3QgbWx4
NWVfcHJpdiAqcHJpdiwNCisJCQkJCSAgICBlbnVtIG1seDVlX3RyYWZmaWNfdHlwZXMgdHQsDQor
CQkJCQkgICAgdTMyICp0aXJjKQ0KK3sNCisJbWx4NWVfYnVpbGRfaW5kaXJfdGlyX2N0eF9jb21t
b24ocHJpdiwgcHJpdi0+aW5kaXJfcnF0LnJxdG4sIHRpcmMpOw0KKwltbHg1ZV9idWlsZF9pbmRp
cl90aXJfY3R4X2hhc2goJnByaXYtPnJzc19wYXJhbXMsDQorCQkJCSAgICAgICAmdGlyY19kZWZh
dWx0X2NvbmZpZ1t0dF0sIHRpcmMsIHRydWUpOw0KKwlNTFg1X1NFVCh0aXJjLCB0aXJjLCB0dW5u
ZWxlZF9vZmZsb2FkX2VuLCAweDEpOw0KK30NCisNCiBpbnQgbWx4NWVfY3JlYXRlX2luZGlyZWN0
X3RpcnMoc3RydWN0IG1seDVlX3ByaXYgKnByaXYsIGJvb2wgaW5uZXJfdHRjKQ0KIHsNCiAJc3Ry
dWN0IG1seDVlX3RpciAqdGlyOw0KLS0gDQoyLjIwLjENCg0K
