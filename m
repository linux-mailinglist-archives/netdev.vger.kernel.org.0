Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A1729418
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 11:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390020AbfEXJAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 05:00:33 -0400
Received: from mail-eopbgr30131.outbound.protection.outlook.com ([40.107.3.131]:58510
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389978AbfEXJAd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 05:00:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RLiLQBk6mDR68tMSmLAgJhpBYj0D6jIpmn5Wbu5fPwg=;
 b=nYnke4C+VohsMtQkB75tmO4Byv/8O91Tgx8gRbJLCoYy7n7dBgE+MXCGHQ8HH6Hddy1Ryvs4PURA/wj3x4ECK/YxjtoXL8YldVC1tJiHOHFD2lZZ9JwxKUnjXEKCHNDVjzMD3zvdYjw6zo21jxt2arjDkcvTSPfGV0o0PsGg+ks=
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM (20.178.126.212) by
 VI1PR10MB1535.EURPRD10.PROD.OUTLOOK.COM (10.166.146.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Fri, 24 May 2019 09:00:25 +0000
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::c81b:1b10:f6ab:fee5]) by VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::c81b:1b10:f6ab:fee5%3]) with mapi id 15.20.1922.016; Fri, 24 May 2019
 09:00:25 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/5] net: dsa: mv88e6xxx: introduce support for two chips
 using direct smi addressing
Thread-Topic: [PATCH v2 1/5] net: dsa: mv88e6xxx: introduce support for two
 chips using direct smi addressing
Thread-Index: AQHVEg8gIIPPVrFduEy/8gKcIhsUQw==
Date:   Fri, 24 May 2019 09:00:24 +0000
Message-ID: <20190524085921.11108-2-rasmus.villemoes@prevas.dk>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
 <20190524085921.11108-1-rasmus.villemoes@prevas.dk>
In-Reply-To: <20190524085921.11108-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0802CA0015.eurprd08.prod.outlook.com
 (2603:10a6:3:bd::25) To VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:e3::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 01e361a9-4280-4dc5-a012-08d6e026425d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:VI1PR10MB1535;
x-ms-traffictypediagnostic: VI1PR10MB1535:
x-microsoft-antispam-prvs: <VI1PR10MB15357897347ED1C571850DC18A020@VI1PR10MB1535.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(136003)(366004)(396003)(376002)(346002)(189003)(199004)(42882007)(66946007)(73956011)(81166006)(102836004)(66066001)(6116002)(76176011)(1076003)(25786009)(52116002)(478600001)(386003)(6512007)(6506007)(186003)(3846002)(74482002)(72206003)(4326008)(66556008)(64756008)(66446008)(66476007)(316002)(26005)(36756003)(68736007)(50226002)(305945005)(5660300002)(7736002)(6436002)(44832011)(256004)(14444005)(486006)(53936002)(8676002)(81156014)(8976002)(110136005)(476003)(6486002)(8936002)(446003)(2906002)(11346002)(54906003)(2616005)(99286004)(71190400001)(71200400001)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB1535;H:VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: CqKyIdnNQvk3vFBG7Qydx1nhQ0XSiX4QKsbKv8DreqdyrVH50PQ+PlaYOGF8x56g+p4wH7KaHLXPykFtvPoaCyiJgxWtUr4dkhZvYCJqkDRPDDj78Kh0CW9V3rGMZUVH9N9r9KAe0ZFFq1QqZ6CEqvE4C2ID2kajctPu8QlHDNf/1qMQzX8RccDveG6JdXgJcvUdzMuxg93WntHOXmXQx/TOzUaSigFrithyh8GnUyfd9rUFOOzzpW4rdjQM6eCRtF1Inkcer5O4a2kWorSjCip2CSf6PnPP6vtJ0igAfocdy7eCT2TxvG33+jwQpAEH+T/qCEfQa9OigN2AF+L+eXpspmjd7ht5l1uPtZ7ukzIhEibbE9jjS/rY9PZt6IS82rkqHGFT2wgSGX2HYVXLwbVch9ikcHbzuesDrbw9zh8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 01e361a9-4280-4dc5-a012-08d6e026425d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 09:00:24.9573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB1535
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
bGwgdXNpbmcgZGlyZWN0IGFkZHJlc3NpbmcuDQoNClNpZ25lZC1vZmYtYnk6IFJhc211cyBWaWxs
ZW1vZXMgPHJhc211cy52aWxsZW1vZXNAcHJldmFzLmRrPg0KLS0tDQogZHJpdmVycy9uZXQvZHNh
L212ODhlNnh4eC9jaGlwLmggfCAgNiArKysrKysNCiBkcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4
L3NtaS5jICB8IDI1ICsrKysrKysrKysrKysrKysrKysrKysrKy0NCiAyIGZpbGVzIGNoYW5nZWQs
IDMwIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2RzYS9tdjg4ZTZ4eHgvY2hpcC5oIGIvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9jaGlw
LmgNCmluZGV4IGZhYTNmYTg4OWYxOS4uNzQ3NzdjM2JjMzEzIDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9uZXQvZHNhL212ODhlNnh4eC9jaGlwLmgNCisrKyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4
eHgvY2hpcC5oDQpAQCAtMTEyLDYgKzExMiwxMiBAQCBzdHJ1Y3QgbXY4OGU2eHh4X2luZm8gew0K
IAkgKiB3aGVuIGl0IGlzIG5vbi16ZXJvLCBhbmQgdXNlIGluZGlyZWN0IGFjY2VzcyB0byBpbnRl
cm5hbCByZWdpc3RlcnMuDQogCSAqLw0KIAlib29sIG11bHRpX2NoaXA7DQorCS8qIER1YWwtY2hp
cCBBZGRyZXNzaW5nIE1vZGUNCisJICogU29tZSBjaGlwcyByZXNwb25kIHRvIG9ubHkgaGFsZiBv
ZiB0aGUgMzIgU01JIGFkZHJlc3NlcywNCisJICogYWxsb3dpbmcgdHdvIHRvIGNvZXhpc3Qgb24g
dGhlIHNhbWUgU01JIGludGVyZmFjZS4NCisJICovDQorCWJvb2wgZHVhbF9jaGlwOw0KKw0KIAll
bnVtIGRzYV90YWdfcHJvdG9jb2wgdGFnX3Byb3RvY29sOw0KIA0KIAkvKiBNYXNrIGZvciBGcm9t
UG9ydCBhbmQgVG9Qb3J0IHZhbHVlIG9mIFBvcnRWZWMgdXNlZCBpbiBBVFUgTW92ZQ0KZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvc21pLmMgYi9kcml2ZXJzL25ldC9kc2Ev
bXY4OGU2eHh4L3NtaS5jDQppbmRleCA5NmY3ZDI2ODViZGMuLjExNTFiNWI0OTNlYSAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvc21pLmMNCisrKyBiL2RyaXZlcnMvbmV0
L2RzYS9tdjg4ZTZ4eHgvc21pLmMNCkBAIC0yNCw2ICsyNCwxMCBAQA0KICAqIFdoZW4gQUREUiBp
cyBub24temVybywgdGhlIGNoaXAgdXNlcyBNdWx0aS1jaGlwIEFkZHJlc3NpbmcgTW9kZSwgYWxs
b3dpbmcNCiAgKiBtdWx0aXBsZSBkZXZpY2VzIHRvIHNoYXJlIHRoZSBTTUkgaW50ZXJmYWNlLiBJ
biB0aGlzIG1vZGUgaXQgcmVzcG9uZHMgdG8gb25seQ0KICAqIDIgcmVnaXN0ZXJzLCB1c2VkIHRv
IGluZGlyZWN0bHkgYWNjZXNzIHRoZSBpbnRlcm5hbCBTTUkgZGV2aWNlcy4NCisgKg0KKyAqIFNv
bWUgY2hpcHMgdXNlIGEgZGlmZmVyZW50IHNjaGVtZTogT25seSB0aGUgQUREUjQgcGluIGlzIHVz
ZWQgZm9yDQorICogY29uZmlndXJhdGlvbiwgYW5kIHRoZSBkZXZpY2UgcmVzcG9uZHMgdG8gMTYg
b2YgdGhlIDMyIFNNSQ0KKyAqIGFkZHJlc3NlcywgYWxsb3dpbmcgdHdvIHRvIGNvZXhpc3Qgb24g
dGhlIHNhbWUgU01JIGludGVyZmFjZS4NCiAgKi8NCiANCiBzdGF0aWMgaW50IG12ODhlNnh4eF9z
bWlfZGlyZWN0X3JlYWQoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLA0KQEAgLTc2LDYgKzgw
LDIzIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbXY4OGU2eHh4X2J1c19vcHMgbXY4OGU2eHh4X3Nt
aV9kaXJlY3Rfb3BzID0gew0KIAkud3JpdGUgPSBtdjg4ZTZ4eHhfc21pX2RpcmVjdF93cml0ZSwN
CiB9Ow0KIA0KK3N0YXRpYyBpbnQgbXY4OGU2eHh4X3NtaV9kdWFsX2RpcmVjdF9yZWFkKHN0cnVj
dCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwNCisJCQkJCSAgaW50IGRldiwgaW50IHJlZywgdTE2ICpk
YXRhKQ0KK3sNCisJcmV0dXJuIG12ODhlNnh4eF9zbWlfZGlyZWN0X3JlYWQoY2hpcCwgZGV2ICsg
Y2hpcC0+c3dfYWRkciwgcmVnLCBkYXRhKTsNCit9DQorDQorc3RhdGljIGludCBtdjg4ZTZ4eHhf
c21pX2R1YWxfZGlyZWN0X3dyaXRlKHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwNCisJCQkJ
CSAgIGludCBkZXYsIGludCByZWcsIHUxNiBkYXRhKQ0KK3sNCisJcmV0dXJuIG12ODhlNnh4eF9z
bWlfZGlyZWN0X3dyaXRlKGNoaXAsIGRldiArIGNoaXAtPnN3X2FkZHIsIHJlZywgZGF0YSk7DQor
fQ0KKw0KK3N0YXRpYyBjb25zdCBzdHJ1Y3QgbXY4OGU2eHh4X2J1c19vcHMgbXY4OGU2eHh4X3Nt
aV9kdWFsX2RpcmVjdF9vcHMgPSB7DQorCS5yZWFkID0gbXY4OGU2eHh4X3NtaV9kdWFsX2RpcmVj
dF9yZWFkLA0KKwkud3JpdGUgPSBtdjg4ZTZ4eHhfc21pX2R1YWxfZGlyZWN0X3dyaXRlLA0KK307
DQorDQogLyogT2Zmc2V0IDB4MDA6IFNNSSBDb21tYW5kIFJlZ2lzdGVyDQogICogT2Zmc2V0IDB4
MDE6IFNNSSBEYXRhIFJlZ2lzdGVyDQogICovDQpAQCAtMTQ0LDcgKzE2NSw5IEBAIHN0YXRpYyBj
b25zdCBzdHJ1Y3QgbXY4OGU2eHh4X2J1c19vcHMgbXY4OGU2eHh4X3NtaV9pbmRpcmVjdF9vcHMg
PSB7DQogaW50IG12ODhlNnh4eF9zbWlfaW5pdChzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXAs
DQogCQkgICAgICAgc3RydWN0IG1paV9idXMgKmJ1cywgaW50IHN3X2FkZHIpDQogew0KLQlpZiAo
c3dfYWRkciA9PSAwKQ0KKwlpZiAoY2hpcC0+aW5mby0+ZHVhbF9jaGlwKQ0KKwkJY2hpcC0+c21p
X29wcyA9ICZtdjg4ZTZ4eHhfc21pX2R1YWxfZGlyZWN0X29wczsNCisJZWxzZSBpZiAoc3dfYWRk
ciA9PSAwKQ0KIAkJY2hpcC0+c21pX29wcyA9ICZtdjg4ZTZ4eHhfc21pX2RpcmVjdF9vcHM7DQog
CWVsc2UgaWYgKGNoaXAtPmluZm8tPm11bHRpX2NoaXApDQogCQljaGlwLT5zbWlfb3BzID0gJm12
ODhlNnh4eF9zbWlfaW5kaXJlY3Rfb3BzOw0KLS0gDQoyLjIwLjENCg0K
