Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF5433325E
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729155AbfFCOmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:42:25 -0400
Received: from mail-eopbgr30118.outbound.protection.outlook.com ([40.107.3.118]:22244
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727650AbfFCOmW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 10:42:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pp/dhgIGGRrJSaubDwgBgPhhsuJiYOxJoT1TY+emooU=;
 b=Zuj+KW5tKUccU0F7Ams9hRJgfa8C8rtcE5jp4WEJ3+MemMHWbc9BZRSb3G3oe12zjXn1W9UcfbHwGcqMdhYsH6N44NJk51Ih9yBVP82d7wOaz0bGj6TQk3sL7WU4p5i0eB+2IJPMgYza2duMo4ugvdHH2lb7sAOCtNItS+qGB9k=
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM (20.178.126.80) by
 VI1PR10MB2574.EURPRD10.PROD.OUTLOOK.COM (20.178.125.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Mon, 3 Jun 2019 14:42:15 +0000
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5]) by VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5%6]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 14:42:15 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v3 03/10] net: dsa: mv88e6xxx: prepare
 mv88e6xxx_g1_atu_op() for the mv88e6250
Thread-Topic: [PATCH net-next v3 03/10] net: dsa: mv88e6xxx: prepare
 mv88e6xxx_g1_atu_op() for the mv88e6250
Thread-Index: AQHVGhqJQ2Bcy2GAN0mJuFM1OwGH1w==
Date:   Mon, 3 Jun 2019 14:42:15 +0000
Message-ID: <20190603144112.27713-4-rasmus.villemoes@prevas.dk>
References: <20190603144112.27713-1-rasmus.villemoes@prevas.dk>
In-Reply-To: <20190603144112.27713-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0701CA0070.eurprd07.prod.outlook.com
 (2603:10a6:3:64::14) To VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:e1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c95c4fd0-053f-4322-c78d-08d6e831ab81
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR10MB2574;
x-ms-traffictypediagnostic: VI1PR10MB2574:
x-microsoft-antispam-prvs: <VI1PR10MB257432D35CCFD6B7ADB5B5FD8A140@VI1PR10MB2574.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(366004)(346002)(376002)(396003)(136003)(189003)(199004)(42882007)(50226002)(446003)(476003)(73956011)(66556008)(64756008)(66446008)(66476007)(81156014)(11346002)(256004)(14444005)(8976002)(53936002)(72206003)(66946007)(316002)(14454004)(99286004)(8676002)(81166006)(8936002)(71190400001)(110136005)(71200400001)(102836004)(2616005)(4326008)(54906003)(25786009)(386003)(7736002)(52116002)(6506007)(26005)(486006)(2906002)(66066001)(36756003)(186003)(6512007)(68736007)(1076003)(74482002)(305945005)(76176011)(478600001)(3846002)(5660300002)(6436002)(6116002)(44832011)(6486002)(138113003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB2574;H:VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1pDu0fuYAU7KmpopQVBrA7Ubt5qLCogee7vBdK9dcK5fN7QSbCCCImZtniFsm7KUP8CamFyjFpg8ceeKZ/YTp5BN8QGabzB+/09WpGRz5zwH34DDaNx84rUNutPbu+nrcukDCmKOJkKqIFKXIO/MItuGKPJTPyAzkDuU+LpA4iDAIcG1BbYB5aeS/EQr1Wf9LuFSG1rmKqFlxT2XsKfkAIXOp3/s12qbRoXBz8U2KnQ3Q/3oChlWwiTUvbChR4Arj0BQmmM7RBT7OfiQe/i1assAgyhIei8KVo8dYySx3BueSicFw358aDYL5hxGbH3R7Y8ji1fkrs/zTDF5raG/lRb4ezqlOYOdCO8bS7SLpmk78+yPBhJ0O7DNJRdneobf9VwpUu4N8EgCET+7tmvr5NyJrhNumCUaJ2rSv40JcRo=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: c95c4fd0-053f-4322-c78d-08d6e831ab81
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 14:42:15.0573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rasmus.Villemoes@prevas.dk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB2574
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
