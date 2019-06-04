Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42B4034058
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 09:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfFDHfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 03:35:47 -0400
Received: from mail-eopbgr00119.outbound.protection.outlook.com ([40.107.0.119]:36579
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726653AbfFDHeb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 03:34:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pp/dhgIGGRrJSaubDwgBgPhhsuJiYOxJoT1TY+emooU=;
 b=dnfYJp7EC3TtvuM4hvBbBI5Fp4grRDNXd9wlnW9Vc/ClSpIsIfe7wxbsRg2UrsAij3gUcr95aHeDT0S7dKI0YJtJKEZbEnVJyaIOSN1mnfoQUiV/KecoUWKocDmCpNksIdlPlbwsYce0fh7m8itkINCbQI9ctGS2UI25NfNJ+K4=
Received: from DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM (20.179.10.220) by
 DB8PR10MB3068.EURPRD10.PROD.OUTLOOK.COM (10.255.19.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Tue, 4 Jun 2019 07:34:26 +0000
Received: from DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::a0b0:f05d:f1e:2d5b]) by DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::a0b0:f05d:f1e:2d5b%4]) with mapi id 15.20.1943.018; Tue, 4 Jun 2019
 07:34:26 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v4 03/10] net: dsa: mv88e6xxx: prepare
 mv88e6xxx_g1_atu_op() for the mv88e6250
Thread-Topic: [PATCH net-next v4 03/10] net: dsa: mv88e6xxx: prepare
 mv88e6xxx_g1_atu_op() for the mv88e6250
Thread-Index: AQHVGqfvR846ZAzYMUy+9ND66HvHwA==
Date:   Tue, 4 Jun 2019 07:34:25 +0000
Message-ID: <20190604073412.21743-4-rasmus.villemoes@prevas.dk>
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
x-ms-office365-filtering-correlation-id: 43465980-d178-4cc8-a7cc-08d6e8bf11f9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DB8PR10MB3068;
x-ms-traffictypediagnostic: DB8PR10MB3068:
x-microsoft-antispam-prvs: <DB8PR10MB3068224134C1DDCBC363FC098A150@DB8PR10MB3068.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0058ABBBC7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39850400004)(136003)(376002)(396003)(346002)(189003)(199004)(4326008)(8976002)(8936002)(71200400001)(71190400001)(6436002)(6486002)(68736007)(446003)(486006)(2616005)(11346002)(81156014)(8676002)(66066001)(50226002)(36756003)(81166006)(42882007)(476003)(53936002)(186003)(52116002)(73956011)(76176011)(66946007)(66476007)(66556008)(64756008)(66446008)(99286004)(7736002)(44832011)(25786009)(72206003)(305945005)(478600001)(74482002)(1076003)(256004)(14444005)(6512007)(102836004)(3846002)(26005)(6116002)(386003)(6506007)(316002)(14454004)(54906003)(5660300002)(2906002)(110136005)(138113003);DIR:OUT;SFP:1102;SCL:1;SRVR:DB8PR10MB3068;H:DB8PR10MB2634.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7SNFNDV3w6U3Lo7nkE/aCfyOaRX98MLUEDKpsj42hh0VIzPmQuVLMT7+l1L9ugyUC0UkNtiS43azP8VCvB2M5aBAvNtQp3JVLOujzlyN7s3RaTRRVdNtqrRCJUjvEVRU5FkvYaGRGjw38frbsRthAsWLscKniEyul0vfMQ+OlAQ9dddzN6oEr+3vTauOceFpkzgJhL1BHRzjN0WFYhobAwcLcgdu1vijxt+5JMW41KI9rQzx6pxahViwRy6ewEQB8JD8XwL1URsNjzcJCby33RwrXceB2sgan5NAvx2SY3SuJDSOfprfO925IqRR+FQNtxBkiaHr7PlWXBu2XsKqFh3Ibi/FHo44GT3kkx3I44OD/FhgZ9VW6/y7q02mz7DzU77zoF8ZVl1IzbM/gF9pH3tIMQiFkh7HBHIUvY26K+8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 43465980-d178-4cc8-a7cc-08d6e8bf11f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2019 07:34:25.9884
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB3068
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QWxsIHRoZSBjdXJyZW50bHkgc3VwcG9ydGVkIGNoaXBzIGhhdmUgLm51bV9kYXRhYmFzZXMgZWl0
aGVyIDI1NiBvcg0KNDA5Niwgc28gdGhpcyBwYXRjaCBkb2VzIG5vdCBjaGFuZ2UgYmVoYXZpb3Vy
IGZvciBhbnkgb2YgdGhvc2UuIFRoZQ0KbXY4OGU2MjUwLCBob3dldmVyLCBoYXMgLm51bV9kYXRh
YmFzZXMgPT0gNjQsIGFuZCBpdCBkb2VzIG5vdCBwdXQgdGhlDQp1cHBlciB0d28gYml0cyBpbiBB
VFUgY29udHJvbCAxMzoxMiwgYnV0IHJhdGhlciBpbiBBVFUgT3BlcmF0aW9uDQo5OjguIFNvIGNo
YW5nZSB0aGUgbG9naWMgdG8gcHJlcGFyZSBmb3Igc3VwcG9ydGluZyBtdjg4ZTYyNTAuDQoNClJl
dmlld2VkLWJ5OiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+DQpSZXZpZXdlZC1ieTogVml2
aWVuIERpZGVsb3QgPHZpdmllbi5kaWRlbG90QGdtYWlsLmNvbT4NClNpZ25lZC1vZmYtYnk6IFJh
c211cyBWaWxsZW1vZXMgPHJhc211cy52aWxsZW1vZXNAcHJldmFzLmRrPg0KLS0tDQogZHJpdmVy
cy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwxX2F0dS5jIHwgNSArKysrLQ0KIDEgZmlsZSBjaGFu
Z2VkLCA0IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMV9hdHUuYyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4
ZTZ4eHgvZ2xvYmFsMV9hdHUuYw0KaW5kZXggZWEyNDM4NDBlZTBmLi4xYWU2ODBiYzBlZmYgMTAw
NjQ0DQotLS0gYS9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2JhbDFfYXR1LmMNCisrKyBi
L2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMV9hdHUuYw0KQEAgLTk0LDcgKzk0LDcg
QEAgc3RhdGljIGludCBtdjg4ZTZ4eHhfZzFfYXR1X29wKHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAq
Y2hpcCwgdTE2IGZpZCwgdTE2IG9wKQ0KIAkJaWYgKGVycikNCiAJCQlyZXR1cm4gZXJyOw0KIAl9
IGVsc2Ugew0KLQkJaWYgKG12ODhlNnh4eF9udW1fZGF0YWJhc2VzKGNoaXApID4gMTYpIHsNCisJ
CWlmIChtdjg4ZTZ4eHhfbnVtX2RhdGFiYXNlcyhjaGlwKSA+IDY0KSB7DQogCQkJLyogQVRVIERC
TnVtWzc6NF0gYXJlIGxvY2F0ZWQgaW4gQVRVIENvbnRyb2wgMTU6MTIgKi8NCiAJCQllcnIgPSBt
djg4ZTZ4eHhfZzFfcmVhZChjaGlwLCBNVjg4RTZYWFhfRzFfQVRVX0NUTCwNCiAJCQkJCQkmdmFs
KTsNCkBAIC0xMDYsNiArMTA2LDkgQEAgc3RhdGljIGludCBtdjg4ZTZ4eHhfZzFfYXR1X29wKHN0
cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwgdTE2IGZpZCwgdTE2IG9wKQ0KIAkJCQkJCSB2YWwp
Ow0KIAkJCWlmIChlcnIpDQogCQkJCXJldHVybiBlcnI7DQorCQl9IGVsc2UgaWYgKG12ODhlNnh4
eF9udW1fZGF0YWJhc2VzKGNoaXApID4gMTYpIHsNCisJCQkvKiBBVFUgREJOdW1bNTo0XSBhcmUg
bG9jYXRlZCBpbiBBVFUgT3BlcmF0aW9uIDk6OCAqLw0KKwkJCW9wIHw9IChmaWQgJiAweDMwKSA8
PCA0Ow0KIAkJfQ0KIA0KIAkJLyogQVRVIERCTnVtWzM6MF0gYXJlIGxvY2F0ZWQgaW4gQVRVIE9w
ZXJhdGlvbiAzOjAgKi8NCi0tIA0KMi4yMC4xDQoNCg==
