Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1B1649887
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 07:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725970AbfFRFDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 01:03:37 -0400
Received: from mail-eopbgr60058.outbound.protection.outlook.com ([40.107.6.58]:46078
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725883AbfFRFDh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 01:03:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wotSX+6HYHuA7RkLY5OZHzf50FhUtgkF114Qn2KHBxs=;
 b=JuS+2ogTHlVUNlzyBqWtzfZMnvsmCgPcQRG80Ye9U6ueks29R1kzxQavs4WiIlkHnRlyIHPak3K12mDmG0/NGsEhshudRh/J5omF/pm8+BE4Pohrt9lwFDzoEj3kita+5dvyc+u0kQUXxjej1AYI5inBE6Duda2+k+3UD+y9AEQ=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.138.152) by
 DB7PR04MB5148.eurprd04.prod.outlook.com (20.176.235.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Tue, 18 Jun 2019 05:02:54 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::58d4:6713:ac7d:83d2]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::58d4:6713:ac7d:83d2%3]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 05:02:54 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH V2] can: flexcan: fix stop mode acknowledgment
Thread-Topic: [PATCH V2] can: flexcan: fix stop mode acknowledgment
Thread-Index: AQHVJZMW1dgBn+JwZkuGgslM2Nq8NA==
Date:   Tue, 18 Jun 2019 05:02:53 +0000
Message-ID: <20190618050046.4966-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR06CA0202.apcprd06.prod.outlook.com (2603:1096:4:1::34)
 To DB7PR04MB4618.eurprd04.prod.outlook.com (2603:10a6:5:36::24)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b58cfd81-7640-456a-b1f7-08d6f3aa385e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB5148;
x-ms-traffictypediagnostic: DB7PR04MB5148:
x-microsoft-antispam-prvs: <DB7PR04MB5148D5E44563CCF6F63D6683E6EA0@DB7PR04MB5148.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(39860400002)(136003)(376002)(346002)(189003)(199004)(54534003)(2906002)(25786009)(14454004)(71200400001)(4326008)(36756003)(6486002)(8936002)(8676002)(81156014)(81166006)(110136005)(14444005)(6116002)(486006)(386003)(6506007)(86362001)(52116002)(54906003)(3846002)(256004)(71190400001)(66066001)(316002)(102836004)(186003)(5660300002)(2616005)(476003)(50226002)(53936002)(26005)(66556008)(66476007)(66946007)(64756008)(2501003)(1076003)(66446008)(305945005)(6436002)(99286004)(7736002)(6512007)(68736007)(73956011)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5148;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: e2dji0rkqOke2RCRWzN8Pr9fYbaTuVgk2MC8nYdVzt7FjZOTQ7ruJ6DiEgmAg3HrI9dHwS06i3U4LXpZWqZP3GlV/6fRZ/MyR21j6mtnrK0Cvk1UhEw5Yy7QOx8VE1H0sLjUm4MVWI28zGz5dfH41C0p454aTwik7CMTejEXVH4OXuYH+Fa5D92W/xSzuimwDjBrWARwdZVApZAjAimbPWNiSV3JRqI6VKxICKhWfVrORwD+Cpat6URH15O1rbOXu8mxLByK6x9lfkziuf8BoMn8YugbdhoAfhubSoEc7XrBJSPTcIP2rhpCrYSAWePriLmAxo2RtN0Km3Iv3/4rFcR+deDA2GuZeXUa6fr8RVik2OF2LyE9AEXdUzKLXF2Qp/U0ju2qJH1iyqJwSFPlOba+mpPpiAlypxxaZK7QPZ0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b58cfd81-7640-456a-b1f7-08d6f3aa385e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 05:02:53.9801
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qiangqing.zhang@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5148
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
ZCgpLS0+cmVnbWFwX3JlYWRfcG9sbF90aW1lb3V0KCkNCi0tLQ0KIGRyaXZlcnMvbmV0L2Nhbi9m
bGV4Y2FuLmMgfCAzNSArKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLQ0KIDEgZmls
ZSBjaGFuZ2VkLCAyNyBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYyBiL2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMN
CmluZGV4IGUzNTA4M2ZmMzFlZS4uNDMyNDVhNTY1NWM3IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9u
ZXQvY2FuL2ZsZXhjYW4uYw0KKysrIGIvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYw0KQEAgLTQw
NCw5ICs0MDQsMTAgQEAgc3RhdGljIHZvaWQgZmxleGNhbl9lbmFibGVfd2FrZXVwX2lycShzdHJ1
Y3QgZmxleGNhbl9wcml2ICpwcml2LCBib29sIGVuYWJsZSkNCiAJcHJpdi0+d3JpdGUocmVnX21j
ciwgJnJlZ3MtPm1jcik7DQogfQ0KIA0KLXN0YXRpYyBpbmxpbmUgdm9pZCBmbGV4Y2FuX2VudGVy
X3N0b3BfbW9kZShzdHJ1Y3QgZmxleGNhbl9wcml2ICpwcml2KQ0KK3N0YXRpYyBpbmxpbmUgaW50
IGZsZXhjYW5fZW50ZXJfc3RvcF9tb2RlKHN0cnVjdCBmbGV4Y2FuX3ByaXYgKnByaXYpDQogew0K
IAlzdHJ1Y3QgZmxleGNhbl9yZWdzIF9faW9tZW0gKnJlZ3MgPSBwcml2LT5yZWdzOw0KKwl1bnNp
Z25lZCBpbnQgYWNrdmFsOw0KIAl1MzIgcmVnX21jcjsNCiANCiAJcmVnX21jciA9IHByaXYtPnJl
YWQoJnJlZ3MtPm1jcik7DQpAQCAtNDE2LDIwICs0MTcsMzcgQEAgc3RhdGljIGlubGluZSB2b2lk
IGZsZXhjYW5fZW50ZXJfc3RvcF9tb2RlKHN0cnVjdCBmbGV4Y2FuX3ByaXYgKnByaXYpDQogCS8q
IGVuYWJsZSBzdG9wIHJlcXVlc3QgKi8NCiAJcmVnbWFwX3VwZGF0ZV9iaXRzKHByaXYtPnN0bS5n
cHIsIHByaXYtPnN0bS5yZXFfZ3ByLA0KIAkJCSAgIDEgPDwgcHJpdi0+c3RtLnJlcV9iaXQsIDEg
PDwgcHJpdi0+c3RtLnJlcV9iaXQpOw0KKw0KKwkvKiBnZXQgc3RvcCBhY2tub3dsZWRnbWVudCAq
Lw0KKwlpZiAocmVnbWFwX3JlYWRfcG9sbF90aW1lb3V0KHByaXYtPnN0bS5ncHIsIHByaXYtPnN0
bS5hY2tfZ3ByLA0KKwkJCQkgICAgIGFja3ZhbCwgYWNrdmFsICYgKDEgPDwgcHJpdi0+c3RtLmFj
a19iaXQpLA0KKwkJCQkgICAgIDAsIEZMRVhDQU5fVElNRU9VVF9VUykpDQorCQlyZXR1cm4gLUVU
SU1FRE9VVDsNCisNCisJcmV0dXJuIDA7DQogfQ0KIA0KLXN0YXRpYyBpbmxpbmUgdm9pZCBmbGV4
Y2FuX2V4aXRfc3RvcF9tb2RlKHN0cnVjdCBmbGV4Y2FuX3ByaXYgKnByaXYpDQorc3RhdGljIGlu
bGluZSBpbnQgZmxleGNhbl9leGl0X3N0b3BfbW9kZShzdHJ1Y3QgZmxleGNhbl9wcml2ICpwcml2
KQ0KIHsNCiAJc3RydWN0IGZsZXhjYW5fcmVncyBfX2lvbWVtICpyZWdzID0gcHJpdi0+cmVnczsN
CisJdW5zaWduZWQgaW50IGFja3ZhbDsNCiAJdTMyIHJlZ19tY3I7DQogDQorCXJlZ19tY3IgPSBw
cml2LT5yZWFkKCZyZWdzLT5tY3IpOw0KKwlyZWdfbWNyICY9IH5GTEVYQ0FOX01DUl9TTEZfV0FL
Ow0KKwlwcml2LT53cml0ZShyZWdfbWNyLCAmcmVncy0+bWNyKTsNCisNCiAJLyogcmVtb3ZlIHN0
b3AgcmVxdWVzdCAqLw0KIAlyZWdtYXBfdXBkYXRlX2JpdHMocHJpdi0+c3RtLmdwciwgcHJpdi0+
c3RtLnJlcV9ncHIsDQogCQkJICAgMSA8PCBwcml2LT5zdG0ucmVxX2JpdCwgMCk7DQogDQotCXJl
Z19tY3IgPSBwcml2LT5yZWFkKCZyZWdzLT5tY3IpOw0KLQlyZWdfbWNyICY9IH5GTEVYQ0FOX01D
Ul9TTEZfV0FLOw0KLQlwcml2LT53cml0ZShyZWdfbWNyLCAmcmVncy0+bWNyKTsNCisJLyogZ2V0
IHN0b3AgYWNrbm93bGVkZ21lbnQgKi8NCisJaWYgKHJlZ21hcF9yZWFkX3BvbGxfdGltZW91dChw
cml2LT5zdG0uZ3ByLCBwcml2LT5zdG0uYWNrX2dwciwNCisJCQkJICAgICBhY2t2YWwsICEoYWNr
dmFsICYgKDEgPDwgcHJpdi0+c3RtLmFja19iaXQpKSwNCisJCQkJICAgICAwLCBGTEVYQ0FOX1RJ
TUVPVVRfVVMpKQ0KKwkJcmV0dXJuIC1FVElNRURPVVQ7DQorDQorCXJldHVybiAwOw0KIH0NCiAN
CiBzdGF0aWMgaW5saW5lIHZvaWQgZmxleGNhbl9lcnJvcl9pcnFfZW5hYmxlKGNvbnN0IHN0cnVj
dCBmbGV4Y2FuX3ByaXYgKnByaXYpDQpAQCAtMTY1Miw3ICsxNjcwLDcgQEAgc3RhdGljIGludCBf
X21heWJlX3VudXNlZCBmbGV4Y2FuX3N1c3BlbmQoc3RydWN0IGRldmljZSAqZGV2aWNlKQ0KIAkJ
ICovDQogCQlpZiAoZGV2aWNlX21heV93YWtldXAoZGV2aWNlKSkgew0KIAkJCWVuYWJsZV9pcnFf
d2FrZShkZXYtPmlycSk7DQotCQkJZmxleGNhbl9lbnRlcl9zdG9wX21vZGUocHJpdik7DQorCQkJ
ZXJyID0gZmxleGNhbl9lbnRlcl9zdG9wX21vZGUocHJpdik7DQogCQl9IGVsc2Ugew0KIAkJCWVy
ciA9IGZsZXhjYW5fY2hpcF9kaXNhYmxlKHByaXYpOw0KIAkJCWlmIChlcnIpDQpAQCAtMTcyNSwx
MyArMTc0MywxNCBAQCBzdGF0aWMgaW50IF9fbWF5YmVfdW51c2VkIGZsZXhjYW5fbm9pcnFfcmVz
dW1lKHN0cnVjdCBkZXZpY2UgKmRldmljZSkNCiB7DQogCXN0cnVjdCBuZXRfZGV2aWNlICpkZXYg
PSBkZXZfZ2V0X2RydmRhdGEoZGV2aWNlKTsNCiAJc3RydWN0IGZsZXhjYW5fcHJpdiAqcHJpdiA9
IG5ldGRldl9wcml2KGRldik7DQorCWludCBlcnIgPSAwOw0KIA0KIAlpZiAobmV0aWZfcnVubmlu
ZyhkZXYpICYmIGRldmljZV9tYXlfd2FrZXVwKGRldmljZSkpIHsNCiAJCWZsZXhjYW5fZW5hYmxl
X3dha2V1cF9pcnEocHJpdiwgZmFsc2UpOw0KLQkJZmxleGNhbl9leGl0X3N0b3BfbW9kZShwcml2
KTsNCisJCWVyciA9IGZsZXhjYW5fZXhpdF9zdG9wX21vZGUocHJpdik7DQogCX0NCiANCi0JcmV0
dXJuIDA7DQorCXJldHVybiBlcnI7DQogfQ0KIA0KIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZGV2X3Bt
X29wcyBmbGV4Y2FuX3BtX29wcyA9IHsNCi0tIA0KMi4xNy4xDQoNCg==
