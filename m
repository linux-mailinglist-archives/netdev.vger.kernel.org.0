Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7A534047
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 09:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbfFDHfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 03:35:04 -0400
Received: from mail-eopbgr50096.outbound.protection.outlook.com ([40.107.5.96]:32250
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727047AbfFDHfD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 03:35:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nKUKY2OpAqry2zX9Ld0n5DAnVgZwbnwz9pDNoXfgSg=;
 b=jpQ4m3r2eVFCxPtju68cGQD4pdZ2SoXynzmOD4JgVjdGPSRGwgadSq+t+rmap9icpgifscPzDubeREh6DYn0ijTOpzXNWK3WpYMneBrXPlTzPO1zVPkX7Vtf7RCdxq6HEqcxKOwALMJVPm/yJmlgKmFT/eJGKNM1gxLiAM49qJE=
Received: from DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM (20.179.10.220) by
 DB8PR10MB3435.EURPRD10.PROD.OUTLOOK.COM (10.255.17.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Tue, 4 Jun 2019 07:34:25 +0000
Received: from DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::a0b0:f05d:f1e:2d5b]) by DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::a0b0:f05d:f1e:2d5b%4]) with mapi id 15.20.1943.018; Tue, 4 Jun 2019
 07:34:25 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v4 02/10] net: dsa: mv88e6xxx: introduce support for
 two chips using direct smi addressing
Thread-Topic: [PATCH net-next v4 02/10] net: dsa: mv88e6xxx: introduce support
 for two chips using direct smi addressing
Thread-Index: AQHVGqfuLRXGvwmqnEyJAdatwSQaVw==
Date:   Tue, 4 Jun 2019 07:34:24 +0000
Message-ID: <20190604073412.21743-3-rasmus.villemoes@prevas.dk>
References: <20190604073412.21743-1-rasmus.villemoes@prevas.dk>
In-Reply-To: <20190604073412.21743-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR03CA0030.eurprd03.prod.outlook.com (2603:10a6:20b::43)
 To DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:ab::28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9cc708f9-0abe-4fdf-590e-08d6e8bf114b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB8PR10MB3435;
x-ms-traffictypediagnostic: DB8PR10MB3435:
x-microsoft-antispam-prvs: <DB8PR10MB34357EB596F52470209B69068A150@DB8PR10MB3435.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0058ABBBC7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(376002)(136003)(39850400004)(396003)(189003)(199004)(5660300002)(66446008)(73956011)(76176011)(66476007)(66556008)(66946007)(64756008)(99286004)(66066001)(386003)(6506007)(54906003)(8976002)(52116002)(110136005)(316002)(7736002)(305945005)(81166006)(81156014)(8676002)(8936002)(476003)(74482002)(486006)(446003)(11346002)(2616005)(256004)(44832011)(14444005)(186003)(42882007)(71190400001)(1076003)(102836004)(71200400001)(50226002)(6436002)(26005)(36756003)(478600001)(25786009)(6486002)(68736007)(6116002)(3846002)(53936002)(2906002)(6512007)(72206003)(14454004)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:DB8PR10MB3435;H:DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: k3osqOfx3Fy/8oArnmX2q68lnV65A1vhAjHcqKNHvjjYzLkjmX72sqgusa+6VN5AO+ADf2/9143912bFqiBPbganCuBYw6Wn62iUrn+ZBr6cTWh16mvBl1bYZIuAJYoW8h3zLDlamkLLEE+lz5Nd3dlnbslJWCXf/ShrsLRulk3eFFGeQj0T/M5Qw+w2gPwrAXAQETY1BEr+LYntKQh6dDv+kUWzYFIlIEFychVlVy0vpSvb0GCEDcAocjUHN1AWQU/+h0dhLnDf6m0IfMtVtnhQOyrjVTbORKPj7i0zZYJARGEqoL1Y3BqWsMJEHgvuUMqZuvS9OuiypBZIA34nRXSuL/oJM6+OpBJOvI/IM+E0nyt9oEPt7SGUaN40DWxBYkX275l8vMk40h4yjOqeqZ24BrridGN1YV5CcKzwSLc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cc708f9-0abe-4fdf-590e-08d6e8bf114b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2019 07:34:24.8710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB3435
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIDg4ZTYyNTAgKGFzIHdlbGwgYXMgNjIyMCwgNjA3MSwgNjA3MCwgNjAyMCkgZG8gbm90IHN1
cHBvcnQNCm11bHRpLWNoaXAgKGluZGlyZWN0KSBhZGRyZXNzaW5nLiBIb3dldmVyLCBvbmUgY2Fu
IHN0aWxsIGhhdmUgdHdvIG9mDQp0aGVtIG9uIHRoZSBzYW1lIG1kaW8gYnVzLCBzaW5jZSB0aGUg
ZGV2aWNlIG9ubHkgdXNlcyAxNiBvZiB0aGUgMzINCnBvc3NpYmxlIGFkZHJlc3NlcywgZWl0aGVy
IGFkZHJlc3NlcyAweDAwLTB4MEYgb3IgMHgxMC0weDFGIGRlcGVuZGluZw0Kb24gdGhlIEFERFI0
IHBpbiBhdCByZXNldCBbc2luY2UgQUREUjQgaXMgaW50ZXJuYWxseSBwdWxsZWQgaGlnaCwgdGhl
DQpsYXR0ZXIgaXMgdGhlIGRlZmF1bHRdLg0KDQpJbiBvcmRlciB0byBwcmVwYXJlIGZvciBzdXBw
b3J0aW5nIHRoZSA4OGU2MjUwIGFuZCBmcmllbmRzLCBpbnRyb2R1Y2UNCm12ODhlNnh4eF9pbmZv
OjpkdWFsX2NoaXAgdG8gYWxsb3cgaGF2aW5nIGEgbm9uLXplcm8gc3dfYWRkciB3aGlsZQ0Kc3Rp
bGwgdXNpbmcgZGlyZWN0IGFkZHJlc3NpbmcuDQoNClJldmlld2VkLWJ5OiBWaXZpZW4gRGlkZWxv
dCA8dml2aWVuLmRpZGVsb3RAZ21haWwuY29tPg0KUmV2aWV3ZWQtYnk6IEFuZHJldyBMdW5uIDxh
bmRyZXdAbHVubi5jaD4NClNpZ25lZC1vZmYtYnk6IFJhc211cyBWaWxsZW1vZXMgPHJhc211cy52
aWxsZW1vZXNAcHJldmFzLmRrPg0KLS0tDQogZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9jaGlw
LmggfCAgNiArKysrKysNCiBkcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L3NtaS5jICB8IDI1ICsr
KysrKysrKysrKysrKysrKysrKysrKy0NCiAyIGZpbGVzIGNoYW5nZWQsIDMwIGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4
eHgvY2hpcC5oIGIvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9jaGlwLmgNCmluZGV4IGZhYTNm
YTg4OWYxOS4uNzQ3NzdjM2JjMzEzIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZHNhL212ODhl
Nnh4eC9jaGlwLmgNCisrKyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvY2hpcC5oDQpAQCAt
MTEyLDYgKzExMiwxMiBAQCBzdHJ1Y3QgbXY4OGU2eHh4X2luZm8gew0KIAkgKiB3aGVuIGl0IGlz
IG5vbi16ZXJvLCBhbmQgdXNlIGluZGlyZWN0IGFjY2VzcyB0byBpbnRlcm5hbCByZWdpc3RlcnMu
DQogCSAqLw0KIAlib29sIG11bHRpX2NoaXA7DQorCS8qIER1YWwtY2hpcCBBZGRyZXNzaW5nIE1v
ZGUNCisJICogU29tZSBjaGlwcyByZXNwb25kIHRvIG9ubHkgaGFsZiBvZiB0aGUgMzIgU01JIGFk
ZHJlc3NlcywNCisJICogYWxsb3dpbmcgdHdvIHRvIGNvZXhpc3Qgb24gdGhlIHNhbWUgU01JIGlu
dGVyZmFjZS4NCisJICovDQorCWJvb2wgZHVhbF9jaGlwOw0KKw0KIAllbnVtIGRzYV90YWdfcHJv
dG9jb2wgdGFnX3Byb3RvY29sOw0KIA0KIAkvKiBNYXNrIGZvciBGcm9tUG9ydCBhbmQgVG9Qb3J0
IHZhbHVlIG9mIFBvcnRWZWMgdXNlZCBpbiBBVFUgTW92ZQ0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2RzYS9tdjg4ZTZ4eHgvc21pLmMgYi9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L3NtaS5j
DQppbmRleCA5NmY3ZDI2ODViZGMuLjc3NWY4ZDU1YTk2MiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMv
bmV0L2RzYS9tdjg4ZTZ4eHgvc21pLmMNCisrKyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgv
c21pLmMNCkBAIC0yNCw2ICsyNCwxMCBAQA0KICAqIFdoZW4gQUREUiBpcyBub24temVybywgdGhl
IGNoaXAgdXNlcyBNdWx0aS1jaGlwIEFkZHJlc3NpbmcgTW9kZSwgYWxsb3dpbmcNCiAgKiBtdWx0
aXBsZSBkZXZpY2VzIHRvIHNoYXJlIHRoZSBTTUkgaW50ZXJmYWNlLiBJbiB0aGlzIG1vZGUgaXQg
cmVzcG9uZHMgdG8gb25seQ0KICAqIDIgcmVnaXN0ZXJzLCB1c2VkIHRvIGluZGlyZWN0bHkgYWNj
ZXNzIHRoZSBpbnRlcm5hbCBTTUkgZGV2aWNlcy4NCisgKg0KKyAqIFNvbWUgY2hpcHMgdXNlIGEg
ZGlmZmVyZW50IHNjaGVtZTogT25seSB0aGUgQUREUjQgcGluIGlzIHVzZWQgZm9yDQorICogY29u
ZmlndXJhdGlvbiwgYW5kIHRoZSBkZXZpY2UgcmVzcG9uZHMgdG8gMTYgb2YgdGhlIDMyIFNNSQ0K
KyAqIGFkZHJlc3NlcywgYWxsb3dpbmcgdHdvIHRvIGNvZXhpc3Qgb24gdGhlIHNhbWUgU01JIGlu
dGVyZmFjZS4NCiAgKi8NCiANCiBzdGF0aWMgaW50IG12ODhlNnh4eF9zbWlfZGlyZWN0X3JlYWQo
c3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLA0KQEAgLTc2LDYgKzgwLDIzIEBAIHN0YXRpYyBj
b25zdCBzdHJ1Y3QgbXY4OGU2eHh4X2J1c19vcHMgbXY4OGU2eHh4X3NtaV9kaXJlY3Rfb3BzID0g
ew0KIAkud3JpdGUgPSBtdjg4ZTZ4eHhfc21pX2RpcmVjdF93cml0ZSwNCiB9Ow0KIA0KK3N0YXRp
YyBpbnQgbXY4OGU2eHh4X3NtaV9kdWFsX2RpcmVjdF9yZWFkKHN0cnVjdCBtdjg4ZTZ4eHhfY2hp
cCAqY2hpcCwNCisJCQkJCSAgaW50IGRldiwgaW50IHJlZywgdTE2ICpkYXRhKQ0KK3sNCisJcmV0
dXJuIG12ODhlNnh4eF9zbWlfZGlyZWN0X3JlYWQoY2hpcCwgY2hpcC0+c3dfYWRkciArIGRldiwg
cmVnLCBkYXRhKTsNCit9DQorDQorc3RhdGljIGludCBtdjg4ZTZ4eHhfc21pX2R1YWxfZGlyZWN0
X3dyaXRlKHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwNCisJCQkJCSAgIGludCBkZXYsIGlu
dCByZWcsIHUxNiBkYXRhKQ0KK3sNCisJcmV0dXJuIG12ODhlNnh4eF9zbWlfZGlyZWN0X3dyaXRl
KGNoaXAsIGNoaXAtPnN3X2FkZHIgKyBkZXYsIHJlZywgZGF0YSk7DQorfQ0KKw0KK3N0YXRpYyBj
b25zdCBzdHJ1Y3QgbXY4OGU2eHh4X2J1c19vcHMgbXY4OGU2eHh4X3NtaV9kdWFsX2RpcmVjdF9v
cHMgPSB7DQorCS5yZWFkID0gbXY4OGU2eHh4X3NtaV9kdWFsX2RpcmVjdF9yZWFkLA0KKwkud3Jp
dGUgPSBtdjg4ZTZ4eHhfc21pX2R1YWxfZGlyZWN0X3dyaXRlLA0KK307DQorDQogLyogT2Zmc2V0
IDB4MDA6IFNNSSBDb21tYW5kIFJlZ2lzdGVyDQogICogT2Zmc2V0IDB4MDE6IFNNSSBEYXRhIFJl
Z2lzdGVyDQogICovDQpAQCAtMTQ0LDcgKzE2NSw5IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbXY4
OGU2eHh4X2J1c19vcHMgbXY4OGU2eHh4X3NtaV9pbmRpcmVjdF9vcHMgPSB7DQogaW50IG12ODhl
Nnh4eF9zbWlfaW5pdChzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXAsDQogCQkgICAgICAgc3Ry
dWN0IG1paV9idXMgKmJ1cywgaW50IHN3X2FkZHIpDQogew0KLQlpZiAoc3dfYWRkciA9PSAwKQ0K
KwlpZiAoY2hpcC0+aW5mby0+ZHVhbF9jaGlwKQ0KKwkJY2hpcC0+c21pX29wcyA9ICZtdjg4ZTZ4
eHhfc21pX2R1YWxfZGlyZWN0X29wczsNCisJZWxzZSBpZiAoc3dfYWRkciA9PSAwKQ0KIAkJY2hp
cC0+c21pX29wcyA9ICZtdjg4ZTZ4eHhfc21pX2RpcmVjdF9vcHM7DQogCWVsc2UgaWYgKGNoaXAt
PmluZm8tPm11bHRpX2NoaXApDQogCQljaGlwLT5zbWlfb3BzID0gJm12ODhlNnh4eF9zbWlfaW5k
aXJlY3Rfb3BzOw0KLS0gDQoyLjIwLjENCg0K
