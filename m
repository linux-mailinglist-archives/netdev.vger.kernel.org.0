Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30C2B4B333
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 09:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731063AbfFSHml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 03:42:41 -0400
Received: from mail-eopbgr150075.outbound.protection.outlook.com ([40.107.15.75]:12014
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726246AbfFSHml (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 03:42:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nBUXxiB4oM/QtdTdO7ky4S7FllbCleCiTUws+Lx8hps=;
 b=jjfgw8COQGca5QIXzzYgu3cDM85Ngnw5FTneA6UYJz1NO/Q3EQxLYWbnWP9nClc8WecutX/RlemBp1lN3zSy23Jwc8Kz8raCz3pORTinOXXf3tCat40DVnnpYXr5zOmd2qT3Ye0KaKezJzFd0QWOlSd21a8HrUF5igR8bnet1kE=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.138.152) by
 DB7PR04MB5322.eurprd04.prod.outlook.com (20.176.236.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Wed, 19 Jun 2019 07:42:36 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::58d4:6713:ac7d:83d2]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::58d4:6713:ac7d:83d2%3]) with mapi id 15.20.1987.014; Wed, 19 Jun 2019
 07:42:36 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V3] can: flexcan: fix stop mode acknowledgment
Thread-Topic: [PATCH V3] can: flexcan: fix stop mode acknowledgment
Thread-Index: AQHVJnKQuxoZ97QaAkO9vmxzAv8tqg==
Date:   Wed, 19 Jun 2019 07:42:36 +0000
Message-ID: <20190619074035.25719-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:3:18::36) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:36::24)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca5149e6-dcf8-4588-e46d-08d6f489b294
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB5322;
x-ms-traffictypediagnostic: DB7PR04MB5322:
x-microsoft-antispam-prvs: <DB7PR04MB53222DD870CB41A3BAADDAC2E6E50@DB7PR04MB5322.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 0073BFEF03
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(346002)(366004)(39860400002)(396003)(199004)(189003)(54534003)(8676002)(14454004)(6506007)(99286004)(52116002)(68736007)(1076003)(386003)(3846002)(6116002)(6486002)(102836004)(110136005)(256004)(2501003)(2616005)(305945005)(8936002)(478600001)(81166006)(14444005)(81156014)(54906003)(486006)(71190400001)(71200400001)(316002)(66556008)(476003)(66446008)(25786009)(66476007)(36756003)(4326008)(64756008)(66946007)(5660300002)(50226002)(6436002)(86362001)(7736002)(66066001)(73956011)(26005)(2906002)(186003)(53936002)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5322;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yhl8b6PmFBGucJuI3BkafRxrkg70D7qOI5IHN1pEyG2C9q9yVXvaF+M62jFDuzF44t6IFYTujZ3QshD8Oprdj7K/WAG4NVK7WM3mygrpn2jVBjUlvmRS0sZIRPzruOAQpITff4FYQyUcMB+AesDbHHunHwL0xpiQtgrbPv887gGfZB+dSfhU1/auPXL1MhB1wotJW5Fs1tHNeKwhaWFowbXcDhaIbbfGK6iuThmD6g3rP99tGJsll6jr8Ks9TijoxTJjAB1ig/l5A7ezZv7h2YNZhMIMbmDSZz9dSITfCtDjPYamOeNKqdK/36ejvr1J37U9tw7/GEguBiSVSBzQmitdwR3bLEVK29AM3Eol0TAq0gFYBnkxtEB/dw5QinKmviA8Yf4fBunKIoRPk8B6Gd2QtCzNKlnj8ioMI9kZEFI=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca5149e6-dcf8-4588-e46d-08d6f489b294
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2019 07:42:36.8520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qiangqing.zhang@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5322
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
cWluZy56aGFuZ0BueHAuY29tPg0KDQpDaGFuZ2VMb2c6DQpWMS0+VjI6DQoJKiByZWdtYXBfcmVh
ZCgpLS0+cmVnbWFwX3JlYWRfcG9sbF90aW1lb3V0KCkNClYyLT5WMzoNCgkqIGNoYW5nZSB0aGUg
d2F5IG9mIGVycm9yIHJldHVybiwgaXQgd2lsbCBtYWtlIGVhc3kgZm9yIGZ1bmN0aW9uDQoJZXh0
ZW5zaW9uLg0KLS0tDQogZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYyB8IDQzICsrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKystLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAzNSBpbnNlcnRp
b25zKCspLCA4IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvY2FuL2Zs
ZXhjYW4uYyBiL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMNCmluZGV4IGUzNTA4M2ZmMzFlZS4u
MDUyYzE5ODFmMjdiIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYw0KKysr
IGIvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYw0KQEAgLTQwNCw5ICs0MDQsMTAgQEAgc3RhdGlj
IHZvaWQgZmxleGNhbl9lbmFibGVfd2FrZXVwX2lycShzdHJ1Y3QgZmxleGNhbl9wcml2ICpwcml2
LCBib29sIGVuYWJsZSkNCiAJcHJpdi0+d3JpdGUocmVnX21jciwgJnJlZ3MtPm1jcik7DQogfQ0K
IA0KLXN0YXRpYyBpbmxpbmUgdm9pZCBmbGV4Y2FuX2VudGVyX3N0b3BfbW9kZShzdHJ1Y3QgZmxl
eGNhbl9wcml2ICpwcml2KQ0KK3N0YXRpYyBpbmxpbmUgaW50IGZsZXhjYW5fZW50ZXJfc3RvcF9t
b2RlKHN0cnVjdCBmbGV4Y2FuX3ByaXYgKnByaXYpDQogew0KIAlzdHJ1Y3QgZmxleGNhbl9yZWdz
IF9faW9tZW0gKnJlZ3MgPSBwcml2LT5yZWdzOw0KKwl1bnNpZ25lZCBpbnQgYWNrdmFsOw0KIAl1
MzIgcmVnX21jcjsNCiANCiAJcmVnX21jciA9IHByaXYtPnJlYWQoJnJlZ3MtPm1jcik7DQpAQCAt
NDE2LDIwICs0MTcsMzcgQEAgc3RhdGljIGlubGluZSB2b2lkIGZsZXhjYW5fZW50ZXJfc3RvcF9t
b2RlKHN0cnVjdCBmbGV4Y2FuX3ByaXYgKnByaXYpDQogCS8qIGVuYWJsZSBzdG9wIHJlcXVlc3Qg
Ki8NCiAJcmVnbWFwX3VwZGF0ZV9iaXRzKHByaXYtPnN0bS5ncHIsIHByaXYtPnN0bS5yZXFfZ3By
LA0KIAkJCSAgIDEgPDwgcHJpdi0+c3RtLnJlcV9iaXQsIDEgPDwgcHJpdi0+c3RtLnJlcV9iaXQp
Ow0KKw0KKwkvKiBnZXQgc3RvcCBhY2tub3dsZWRnbWVudCAqLw0KKwlpZiAocmVnbWFwX3JlYWRf
cG9sbF90aW1lb3V0KHByaXYtPnN0bS5ncHIsIHByaXYtPnN0bS5hY2tfZ3ByLA0KKwkJCQkgICAg
IGFja3ZhbCwgYWNrdmFsICYgKDEgPDwgcHJpdi0+c3RtLmFja19iaXQpLA0KKwkJCQkgICAgIDAs
IEZMRVhDQU5fVElNRU9VVF9VUykpDQorCQlyZXR1cm4gLUVUSU1FRE9VVDsNCisNCisJcmV0dXJu
IDA7DQogfQ0KIA0KLXN0YXRpYyBpbmxpbmUgdm9pZCBmbGV4Y2FuX2V4aXRfc3RvcF9tb2RlKHN0
cnVjdCBmbGV4Y2FuX3ByaXYgKnByaXYpDQorc3RhdGljIGlubGluZSBpbnQgZmxleGNhbl9leGl0
X3N0b3BfbW9kZShzdHJ1Y3QgZmxleGNhbl9wcml2ICpwcml2KQ0KIHsNCiAJc3RydWN0IGZsZXhj
YW5fcmVncyBfX2lvbWVtICpyZWdzID0gcHJpdi0+cmVnczsNCisJdW5zaWduZWQgaW50IGFja3Zh
bDsNCiAJdTMyIHJlZ19tY3I7DQogDQogCS8qIHJlbW92ZSBzdG9wIHJlcXVlc3QgKi8NCiAJcmVn
bWFwX3VwZGF0ZV9iaXRzKHByaXYtPnN0bS5ncHIsIHByaXYtPnN0bS5yZXFfZ3ByLA0KIAkJCSAg
IDEgPDwgcHJpdi0+c3RtLnJlcV9iaXQsIDApOw0KIA0KKwkvKiBnZXQgc3RvcCBhY2tub3dsZWRn
bWVudCAqLw0KKwlpZiAocmVnbWFwX3JlYWRfcG9sbF90aW1lb3V0KHByaXYtPnN0bS5ncHIsIHBy
aXYtPnN0bS5hY2tfZ3ByLA0KKwkJCQkgICAgIGFja3ZhbCwgIShhY2t2YWwgJiAoMSA8PCBwcml2
LT5zdG0uYWNrX2JpdCkpLA0KKwkJCQkgICAgIDAsIEZMRVhDQU5fVElNRU9VVF9VUykpDQorCQly
ZXR1cm4gLUVUSU1FRE9VVDsNCisNCiAJcmVnX21jciA9IHByaXYtPnJlYWQoJnJlZ3MtPm1jcik7
DQogCXJlZ19tY3IgJj0gfkZMRVhDQU5fTUNSX1NMRl9XQUs7DQogCXByaXYtPndyaXRlKHJlZ19t
Y3IsICZyZWdzLT5tY3IpOw0KKw0KKwlyZXR1cm4gMDsNCiB9DQogDQogc3RhdGljIGlubGluZSB2
b2lkIGZsZXhjYW5fZXJyb3JfaXJxX2VuYWJsZShjb25zdCBzdHJ1Y3QgZmxleGNhbl9wcml2ICpw
cml2KQ0KQEAgLTE2NDQsNyArMTY2Miw3IEBAIHN0YXRpYyBpbnQgX19tYXliZV91bnVzZWQgZmxl
eGNhbl9zdXNwZW5kKHN0cnVjdCBkZXZpY2UgKmRldmljZSkNCiB7DQogCXN0cnVjdCBuZXRfZGV2
aWNlICpkZXYgPSBkZXZfZ2V0X2RydmRhdGEoZGV2aWNlKTsNCiAJc3RydWN0IGZsZXhjYW5fcHJp
diAqcHJpdiA9IG5ldGRldl9wcml2KGRldik7DQotCWludCBlcnIgPSAwOw0KKwlpbnQgZXJyOw0K
IA0KIAlpZiAobmV0aWZfcnVubmluZyhkZXYpKSB7DQogCQkvKiBpZiB3YWtldXAgaXMgZW5hYmxl
ZCwgZW50ZXIgc3RvcCBtb2RlDQpAQCAtMTY1MiwyNyArMTY3MCwzMSBAQCBzdGF0aWMgaW50IF9f
bWF5YmVfdW51c2VkIGZsZXhjYW5fc3VzcGVuZChzdHJ1Y3QgZGV2aWNlICpkZXZpY2UpDQogCQkg
Ki8NCiAJCWlmIChkZXZpY2VfbWF5X3dha2V1cChkZXZpY2UpKSB7DQogCQkJZW5hYmxlX2lycV93
YWtlKGRldi0+aXJxKTsNCi0JCQlmbGV4Y2FuX2VudGVyX3N0b3BfbW9kZShwcml2KTsNCisJCQll
cnIgPSBmbGV4Y2FuX2VudGVyX3N0b3BfbW9kZShwcml2KTsNCisJCQlpZiAoZXJyKQ0KKwkJCQly
ZXR1cm4gZXJyOw0KIAkJfSBlbHNlIHsNCiAJCQllcnIgPSBmbGV4Y2FuX2NoaXBfZGlzYWJsZShw
cml2KTsNCiAJCQlpZiAoZXJyKQ0KIAkJCQlyZXR1cm4gZXJyOw0KIA0KIAkJCWVyciA9IHBtX3J1
bnRpbWVfZm9yY2Vfc3VzcGVuZChkZXZpY2UpOw0KKwkJCWlmIChlcnIpDQorCQkJCXJldHVybiBl
cnI7DQogCQl9DQogCQluZXRpZl9zdG9wX3F1ZXVlKGRldik7DQogCQluZXRpZl9kZXZpY2VfZGV0
YWNoKGRldik7DQogCX0NCiAJcHJpdi0+Y2FuLnN0YXRlID0gQ0FOX1NUQVRFX1NMRUVQSU5HOw0K
IA0KLQlyZXR1cm4gZXJyOw0KKwlyZXR1cm4gMDsNCiB9DQogDQogc3RhdGljIGludCBfX21heWJl
X3VudXNlZCBmbGV4Y2FuX3Jlc3VtZShzdHJ1Y3QgZGV2aWNlICpkZXZpY2UpDQogew0KIAlzdHJ1
Y3QgbmV0X2RldmljZSAqZGV2ID0gZGV2X2dldF9kcnZkYXRhKGRldmljZSk7DQogCXN0cnVjdCBm
bGV4Y2FuX3ByaXYgKnByaXYgPSBuZXRkZXZfcHJpdihkZXYpOw0KLQlpbnQgZXJyID0gMDsNCisJ
aW50IGVycjsNCiANCiAJcHJpdi0+Y2FuLnN0YXRlID0gQ0FOX1NUQVRFX0VSUk9SX0FDVElWRTsN
CiAJaWYgKG5ldGlmX3J1bm5pbmcoZGV2KSkgew0KQEAgLTE2ODYsMTAgKzE3MDgsMTIgQEAgc3Rh
dGljIGludCBfX21heWJlX3VudXNlZCBmbGV4Y2FuX3Jlc3VtZShzdHJ1Y3QgZGV2aWNlICpkZXZp
Y2UpDQogCQkJCXJldHVybiBlcnI7DQogDQogCQkJZXJyID0gZmxleGNhbl9jaGlwX2VuYWJsZShw
cml2KTsNCisJCQlpZiAoZXJyKQ0KKwkJCQlyZXR1cm4gZXJyOw0KIAkJfQ0KIAl9DQogDQotCXJl
dHVybiBlcnI7DQorCXJldHVybiAwOw0KIH0NCiANCiBzdGF0aWMgaW50IF9fbWF5YmVfdW51c2Vk
IGZsZXhjYW5fcnVudGltZV9zdXNwZW5kKHN0cnVjdCBkZXZpY2UgKmRldmljZSkNCkBAIC0xNzI1
LDEwICsxNzQ5LDEzIEBAIHN0YXRpYyBpbnQgX19tYXliZV91bnVzZWQgZmxleGNhbl9ub2lycV9y
ZXN1bWUoc3RydWN0IGRldmljZSAqZGV2aWNlKQ0KIHsNCiAJc3RydWN0IG5ldF9kZXZpY2UgKmRl
diA9IGRldl9nZXRfZHJ2ZGF0YShkZXZpY2UpOw0KIAlzdHJ1Y3QgZmxleGNhbl9wcml2ICpwcml2
ID0gbmV0ZGV2X3ByaXYoZGV2KTsNCisJaW50IGVycjsNCiANCiAJaWYgKG5ldGlmX3J1bm5pbmco
ZGV2KSAmJiBkZXZpY2VfbWF5X3dha2V1cChkZXZpY2UpKSB7DQogCQlmbGV4Y2FuX2VuYWJsZV93
YWtldXBfaXJxKHByaXYsIGZhbHNlKTsNCi0JCWZsZXhjYW5fZXhpdF9zdG9wX21vZGUocHJpdik7
DQorCQllcnIgPSBmbGV4Y2FuX2V4aXRfc3RvcF9tb2RlKHByaXYpOw0KKwkJaWYgKGVycikNCisJ
CQlyZXR1cm4gZXJyOw0KIAl9DQogDQogCXJldHVybiAwOw0KLS0gDQoyLjE3LjENCg0K
