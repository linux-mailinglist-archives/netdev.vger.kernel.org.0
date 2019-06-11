Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 246F13C472
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 08:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403997AbfFKGr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 02:47:27 -0400
Received: from mail-eopbgr20075.outbound.protection.outlook.com ([40.107.2.75]:12867
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390485AbfFKGr0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 02:47:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7m4g49CZvQQj31wdW4V6QUQoWUtjQ6yxAJ4rleU5KAo=;
 b=O70NLqJdbTP34daQIZ8vJZi6GlcHxTF+cfu0R5atpLeCmPaWKkvn8OSvhwBTDlPO5pmSlw+4lQ5KrlTezfWY8e/NPRnuEoxb3LMcmFuZQE56n6yrs8h7enzKQYhZeOyMoavYiMbQfFYk9qHimdP1bF3NzMVyJrzu5AxcsXo9Z/o=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.138.152) by
 DB7PR04MB4761.eurprd04.prod.outlook.com (20.176.233.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Tue, 11 Jun 2019 06:47:19 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::d020:ef8f:cfd0:2c1c]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::d020:ef8f:cfd0:2c1c%6]) with mapi id 15.20.1987.010; Tue, 11 Jun 2019
 06:47:19 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH] can: flexcan: fix stop mode acknowledgment
Thread-Topic: [PATCH] can: flexcan: fix stop mode acknowledgment
Thread-Index: AQHVICGDb/IDX734hU+A1k7o57NTbQ==
Date:   Tue, 11 Jun 2019 06:47:19 +0000
Message-ID: <20190611064458.1477-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR02CA0003.apcprd02.prod.outlook.com
 (2603:1096:3:17::15) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:36::24)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 50695b81-9e06-4640-5180-08d6ee38a5db
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB7PR04MB4761;
x-ms-traffictypediagnostic: DB7PR04MB4761:
x-microsoft-antispam-prvs: <DB7PR04MB47618367C754173267373495E6ED0@DB7PR04MB4761.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 006546F32A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(136003)(396003)(366004)(39860400002)(346002)(199004)(189003)(256004)(2616005)(476003)(14444005)(54906003)(6436002)(6486002)(99286004)(110136005)(486006)(305945005)(66446008)(81156014)(36756003)(8676002)(26005)(64756008)(66066001)(7736002)(66476007)(50226002)(53936002)(2501003)(66556008)(68736007)(66946007)(81166006)(2906002)(186003)(73956011)(14454004)(8936002)(1076003)(5660300002)(86362001)(102836004)(6506007)(386003)(52116002)(3846002)(6116002)(25786009)(71200400001)(71190400001)(478600001)(4326008)(316002)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4761;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0gnT7GR4P0GpT4YT8cZGiv92XltFdQh9vRyjqUNJsYC22nCme2DgXfkvMCe82tGnSl80TFGRpqcIVxhx+NT6kMhvfPqZmsv9BW3yfY17UriNkqz9H5vETZ2OSX/BQJfZwEyO2ooVCjclK6gyYBMQlDbxflNMetOXr4sp4oMGMFgCf8TqCuLbGDwapxVRPpjJaX/BSP2IOor6MpoPjDfmvEMuXL09OgMGcucHL40xlN51WaWuKwr7JpW1bxa9rsHHvhxI0L29Inx8UoOw7RHockSR2UKYIXW0bd8BNZLUMugTBPCVkIjZfuTBhWLtqjGorMYnscfvwxjj17MLVeTOGcEmfsBh2yk3cbNBwBoy08SY/MoD+YN3gn5mtyhBQGNOmj9h5WNmwT6aJSL5ejCqYXFE+9ourfJpDUpXGYYPMjY=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50695b81-9e06-4640-5180-08d6ee38a5db
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2019 06:47:19.4483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qiangqing.zhang@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4761
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VG8gZW50ZXIgc3RvcCBtb2RlLCB0aGUgQ1BVIHNob3VsZCBtYW51YWxseSBhc3NlcnQgYSBnbG9i
YWwgU3RvcCBNb2RlDQpyZXF1ZXN0IGFuZCBjaGVjayB0aGUgYWNrbm93bGVkZ21lbnQgYXNzZXJ0
ZWQgYnkgRmxleENBTi4gVGhlIENQVSBtdXN0DQpvbmx5IGNvbnNpZGVyIHRoZSBGbGV4Q0FOIGlu
IHN0b3AgbW9kZSB3aGVuIGJvdGggcmVxdWVzdCBhbmQNCmFja25vd2xlZGdtZW50IGNvbmRpdGlv
bnMgYXJlIHNhdGlzZmllZC4NCg0KRml4ZXM6IGRlMzU3OGMxOThjNiAoImNhbjogZmxleGNhbjog
YWRkIHNlbGYgd2FrZXVwIHN1cHBvcnQiKQ0KUmVwb3J0ZWQtYnk6IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQpTaWduZWQtb2ZmLWJ5OiBKb2FraW0gWmhhbmcgPHFpYW5n
cWluZy56aGFuZ0BueHAuY29tPg0KLS0tDQogZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYyB8IDQ3
ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2Vk
LCAzOSBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvY2FuL2ZsZXhjYW4uYyBiL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMNCmluZGV4IGUz
NTA4M2ZmMzFlZS4uMjgyZGFjMWQ4ZjVjIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvY2FuL2Zs
ZXhjYW4uYw0KKysrIGIvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYw0KQEAgLTQwNCw5ICs0MDQs
MTEgQEAgc3RhdGljIHZvaWQgZmxleGNhbl9lbmFibGVfd2FrZXVwX2lycShzdHJ1Y3QgZmxleGNh
bl9wcml2ICpwcml2LCBib29sIGVuYWJsZSkNCiAJcHJpdi0+d3JpdGUocmVnX21jciwgJnJlZ3Mt
Pm1jcik7DQogfQ0KIA0KLXN0YXRpYyBpbmxpbmUgdm9pZCBmbGV4Y2FuX2VudGVyX3N0b3BfbW9k
ZShzdHJ1Y3QgZmxleGNhbl9wcml2ICpwcml2KQ0KK3N0YXRpYyBpbmxpbmUgaW50IGZsZXhjYW5f
ZW50ZXJfc3RvcF9tb2RlKHN0cnVjdCBmbGV4Y2FuX3ByaXYgKnByaXYpDQogew0KIAlzdHJ1Y3Qg
ZmxleGNhbl9yZWdzIF9faW9tZW0gKnJlZ3MgPSBwcml2LT5yZWdzOw0KKwl1bnNpZ25lZCBpbnQg
dGltZW91dCA9IEZMRVhDQU5fVElNRU9VVF9VUyAvIDEwOw0KKwl1bnNpZ25lZCBpbnQgYWNrdmFs
Ow0KIAl1MzIgcmVnX21jcjsNCiANCiAJcmVnX21jciA9IHByaXYtPnJlYWQoJnJlZ3MtPm1jcik7
DQpAQCAtNDE2LDIwICs0MTgsNDggQEAgc3RhdGljIGlubGluZSB2b2lkIGZsZXhjYW5fZW50ZXJf
c3RvcF9tb2RlKHN0cnVjdCBmbGV4Y2FuX3ByaXYgKnByaXYpDQogCS8qIGVuYWJsZSBzdG9wIHJl
cXVlc3QgKi8NCiAJcmVnbWFwX3VwZGF0ZV9iaXRzKHByaXYtPnN0bS5ncHIsIHByaXYtPnN0bS5y
ZXFfZ3ByLA0KIAkJCSAgIDEgPDwgcHJpdi0+c3RtLnJlcV9iaXQsIDEgPDwgcHJpdi0+c3RtLnJl
cV9iaXQpOw0KKw0KKwkvKiBnZXQgc3RvcCBhY2tub3dsZWRnbWVudCAqLw0KKwlyZWdtYXBfcmVh
ZChwcml2LT5zdG0uZ3ByLCBwcml2LT5zdG0uYWNrX2dwciwgJmFja3ZhbCk7DQorDQorCXdoaWxl
ICh0aW1lb3V0LS0gJiYgIShhY2t2YWwgJiAoMSA8PCBwcml2LT5zdG0uYWNrX2JpdCkpKSB7DQor
CQl1ZGVsYXkoMTApOw0KKwkJcmVnbWFwX3JlYWQocHJpdi0+c3RtLmdwciwgcHJpdi0+c3RtLmFj
a19ncHIsICZhY2t2YWwpOw0KKwl9DQorDQorCWlmICghKGFja3ZhbCAmICgxIDw8IHByaXYtPnN0
bS5hY2tfYml0KSkpDQorCQlyZXR1cm4gLUVUSU1FRE9VVDsNCisNCisJcmV0dXJuIDA7DQogfQ0K
IA0KLXN0YXRpYyBpbmxpbmUgdm9pZCBmbGV4Y2FuX2V4aXRfc3RvcF9tb2RlKHN0cnVjdCBmbGV4
Y2FuX3ByaXYgKnByaXYpDQorc3RhdGljIGlubGluZSBpbnQgZmxleGNhbl9leGl0X3N0b3BfbW9k
ZShzdHJ1Y3QgZmxleGNhbl9wcml2ICpwcml2KQ0KIHsNCiAJc3RydWN0IGZsZXhjYW5fcmVncyBf
X2lvbWVtICpyZWdzID0gcHJpdi0+cmVnczsNCisJdW5zaWduZWQgaW50IHRpbWVvdXQgPSBGTEVY
Q0FOX1RJTUVPVVRfVVMgLyAxMDsNCisJdW5zaWduZWQgaW50IGFja3ZhbDsNCiAJdTMyIHJlZ19t
Y3I7DQogDQorCXJlZ19tY3IgPSBwcml2LT5yZWFkKCZyZWdzLT5tY3IpOw0KKwlyZWdfbWNyICY9
IH5GTEVYQ0FOX01DUl9TTEZfV0FLOw0KKwlwcml2LT53cml0ZShyZWdfbWNyLCAmcmVncy0+bWNy
KTsNCisNCiAJLyogcmVtb3ZlIHN0b3AgcmVxdWVzdCAqLw0KIAlyZWdtYXBfdXBkYXRlX2JpdHMo
cHJpdi0+c3RtLmdwciwgcHJpdi0+c3RtLnJlcV9ncHIsDQogCQkJICAgMSA8PCBwcml2LT5zdG0u
cmVxX2JpdCwgMCk7DQogDQotCXJlZ19tY3IgPSBwcml2LT5yZWFkKCZyZWdzLT5tY3IpOw0KLQly
ZWdfbWNyICY9IH5GTEVYQ0FOX01DUl9TTEZfV0FLOw0KLQlwcml2LT53cml0ZShyZWdfbWNyLCAm
cmVncy0+bWNyKTsNCisJLyogZ2V0IHN0b3AgYWNrbm93bGVkZ21lbnQgKi8NCisJcmVnbWFwX3Jl
YWQocHJpdi0+c3RtLmdwciwgcHJpdi0+c3RtLmFja19ncHIsICZhY2t2YWwpOw0KKw0KKwl3aGls
ZSAodGltZW91dC0tICYmIChhY2t2YWwgJiAoMSA8PCBwcml2LT5zdG0uYWNrX2JpdCkpKSB7DQor
CQl1ZGVsYXkoMTApOw0KKwkJcmVnbWFwX3JlYWQocHJpdi0+c3RtLmdwciwgcHJpdi0+c3RtLmFj
a19ncHIsICZhY2t2YWwpOw0KKwl9DQorDQorCWlmIChhY2t2YWwgJiAoMSA8PCBwcml2LT5zdG0u
YWNrX2JpdCkpDQorCQlyZXR1cm4gLUVUSU1FRE9VVDsNCisNCisJcmV0dXJuIDA7DQogfQ0KIA0K
IHN0YXRpYyBpbmxpbmUgdm9pZCBmbGV4Y2FuX2Vycm9yX2lycV9lbmFibGUoY29uc3Qgc3RydWN0
IGZsZXhjYW5fcHJpdiAqcHJpdikNCkBAIC0xNjUyLDcgKzE2ODIsNyBAQCBzdGF0aWMgaW50IF9f
bWF5YmVfdW51c2VkIGZsZXhjYW5fc3VzcGVuZChzdHJ1Y3QgZGV2aWNlICpkZXZpY2UpDQogCQkg
Ki8NCiAJCWlmIChkZXZpY2VfbWF5X3dha2V1cChkZXZpY2UpKSB7DQogCQkJZW5hYmxlX2lycV93
YWtlKGRldi0+aXJxKTsNCi0JCQlmbGV4Y2FuX2VudGVyX3N0b3BfbW9kZShwcml2KTsNCisJCQll
cnIgPSBmbGV4Y2FuX2VudGVyX3N0b3BfbW9kZShwcml2KTsNCiAJCX0gZWxzZSB7DQogCQkJZXJy
ID0gZmxleGNhbl9jaGlwX2Rpc2FibGUocHJpdik7DQogCQkJaWYgKGVycikNCkBAIC0xNzI1LDEz
ICsxNzU1LDE0IEBAIHN0YXRpYyBpbnQgX19tYXliZV91bnVzZWQgZmxleGNhbl9ub2lycV9yZXN1
bWUoc3RydWN0IGRldmljZSAqZGV2aWNlKQ0KIHsNCiAJc3RydWN0IG5ldF9kZXZpY2UgKmRldiA9
IGRldl9nZXRfZHJ2ZGF0YShkZXZpY2UpOw0KIAlzdHJ1Y3QgZmxleGNhbl9wcml2ICpwcml2ID0g
bmV0ZGV2X3ByaXYoZGV2KTsNCisJaW50IGVyciA9IDA7DQogDQogCWlmIChuZXRpZl9ydW5uaW5n
KGRldikgJiYgZGV2aWNlX21heV93YWtldXAoZGV2aWNlKSkgew0KIAkJZmxleGNhbl9lbmFibGVf
d2FrZXVwX2lycShwcml2LCBmYWxzZSk7DQotCQlmbGV4Y2FuX2V4aXRfc3RvcF9tb2RlKHByaXYp
Ow0KKwkJZXJyID0gZmxleGNhbl9leGl0X3N0b3BfbW9kZShwcml2KTsNCiAJfQ0KIA0KLQlyZXR1
cm4gMDsNCisJcmV0dXJuIGVycjsNCiB9DQogDQogc3RhdGljIGNvbnN0IHN0cnVjdCBkZXZfcG1f
b3BzIGZsZXhjYW5fcG1fb3BzID0gew0KLS0gDQoyLjE3LjENCg0K
