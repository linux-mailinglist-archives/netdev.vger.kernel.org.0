Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF4B610D3D
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 21:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfEATcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 15:32:41 -0400
Received: from mail-eopbgr30097.outbound.protection.outlook.com ([40.107.3.97]:30801
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726125AbfEATcU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 15:32:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sBKqL9V+7Vuttyl37UyU5UgLChoRAnE2ZgCqyqk2eTM=;
 b=XZTxLBG729cNtqg9yZqn6Hj5CCncGsTk2pK5JFLb/A1moV15/Ucb20/EbPNRj0Y1PHWpLUlRWeaZR548s4mqYrtaFvbWXF+M+IvjMO5jQOMJ3tGZqGCP23BcSYkSGBElNRNoFGlU6h0nfR6CdzKsql2Son0ykZvsB1ZIfv5/qII=
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM (20.178.126.212) by
 VI1PR10MB2382.EURPRD10.PROD.OUTLOOK.COM (20.177.62.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.15; Wed, 1 May 2019 19:32:12 +0000
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::48b8:9cff:182:f3d8]) by VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::48b8:9cff:182:f3d8%2]) with mapi id 15.20.1856.008; Wed, 1 May 2019
 19:32:12 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>
Subject: [RFC PATCH 3/5] net: dsa: prepare mv88e6xxx_g1_atu_op() for the
 mv88e6250
Thread-Topic: [RFC PATCH 3/5] net: dsa: prepare mv88e6xxx_g1_atu_op() for the
 mv88e6250
Thread-Index: AQHVAFSTqeMZc2WSd0uygZJJkg+pag==
Date:   Wed, 1 May 2019 19:32:12 +0000
Message-ID: <20190501193126.19196-4-rasmus.villemoes@prevas.dk>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
In-Reply-To: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0902CA0005.eurprd09.prod.outlook.com
 (2603:10a6:3:e5::15) To VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:e3::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [5.186.118.63]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e83b58d7-08e1-4ede-5d69-08d6ce6bb587
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:VI1PR10MB2382;
x-ms-traffictypediagnostic: VI1PR10MB2382:
x-microsoft-antispam-prvs: <VI1PR10MB2382FEFC04FB193B0201B1448A3B0@VI1PR10MB2382.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00246AB517
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39850400004)(396003)(136003)(346002)(376002)(189003)(199004)(81166006)(6512007)(14454004)(186003)(50226002)(8676002)(107886003)(66066001)(3846002)(71190400001)(4326008)(6116002)(8976002)(478600001)(54906003)(81156014)(1076003)(8936002)(25786009)(71446004)(72206003)(316002)(73956011)(71200400001)(305945005)(74482002)(68736007)(66476007)(76176011)(44832011)(486006)(64756008)(53936002)(66446008)(66556008)(14444005)(256004)(99286004)(110136005)(6436002)(446003)(386003)(476003)(11346002)(6486002)(7736002)(26005)(6506007)(42882007)(2906002)(66946007)(2616005)(36756003)(52116002)(102836004)(5660300002)(138113003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB2382;H:VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /cljk+8T86ZmRKgJYv7UEAWnmYi4cIy0/yeTqAXChLqgTH5ThILF93Zp6FAyTjlvf4c/7170dNZEwLNcdn7zOIuieCkSj85BVC6vo44GcGK3q2DWtUgw2tPvpLuNJSjgHBW7Aip3ikMoFVH6u+ycOFZbHI+82BvozeNhvkOdV1KRnKXwRbqZNLiHgeU46aV58YeyTWLF/HRsSnGXO+LFOXEOKiOPN7K5ZxJPFJBWYRi2GuJvUTXJMGOpLiFGiwoffiyvxUzJm1Z7KKjyX9fvLCfMhM7ovDdWlYNC9aCRqZ8D44Li5StRKFlmQ5vOarOm4fap8ORO5pkdHLNMDf668d1THQuHNErNylwJJ7o3pWa1341z+C/oygYYa/lfHxz5nj0yLnxcnmHrniZf22/HWO2L4uH4SkPSHBWacJNoUh4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: e83b58d7-08e1-4ede-5d69-08d6ce6bb587
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2019 19:32:12.4705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB2382
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QWxsIHRoZSBjdXJyZW50bHkgc3VwcG9ydGVkIGNoaXBzIGhhdmUgLm51bV9kYXRhYmFzZXMgZWl0
aGVyIDI1NiBvcg0KNDA5Niwgc28gdGhpcyBwYXRjaCBkb2VzIG5vdCBjaGFuZ2UgYmVoYXZpb3Vy
IGZvciBhbnkgb2YgdGhvc2UuIFRoZQ0KbXY4OGU2MjUwLCBob3dldmVyLCBoYXMgLm51bV9kYXRh
YmFzZXMgPT0gNjQsIGFuZCBpdCBkb2VzIG5vdCBwdXQgdGhlDQp1cHBlciB0d28gYml0cyBpbiBB
VFUgY29udHJvbCAxMzoxMiwgYnV0IHJhdGhlciBpbiBBVFUgT3BlcmF0aW9uDQo5OjguIFNvIGNo
YW5nZSB0aGUgbG9naWMgdG8gcHJlcGFyZSBmb3Igc3VwcG9ydGluZyBtdjg4ZTYyNTAuDQoNClNp
Z25lZC1vZmYtYnk6IFJhc211cyBWaWxsZW1vZXMgPHJhc211cy52aWxsZW1vZXNAcHJldmFzLmRr
Pg0KLS0tDQogZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwxX2F0dS5jIHwgNSArKysr
LQ0KIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMV9hdHUuYyBiL2RyaXZl
cnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMV9hdHUuYw0KaW5kZXggZWEyNDM4NDBlZTBmLi4x
YWU2ODBiYzBlZmYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2Jh
bDFfYXR1LmMNCisrKyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMV9hdHUuYw0K
QEAgLTk0LDcgKzk0LDcgQEAgc3RhdGljIGludCBtdjg4ZTZ4eHhfZzFfYXR1X29wKHN0cnVjdCBt
djg4ZTZ4eHhfY2hpcCAqY2hpcCwgdTE2IGZpZCwgdTE2IG9wKQ0KIAkJaWYgKGVycikNCiAJCQly
ZXR1cm4gZXJyOw0KIAl9IGVsc2Ugew0KLQkJaWYgKG12ODhlNnh4eF9udW1fZGF0YWJhc2VzKGNo
aXApID4gMTYpIHsNCisJCWlmIChtdjg4ZTZ4eHhfbnVtX2RhdGFiYXNlcyhjaGlwKSA+IDY0KSB7
DQogCQkJLyogQVRVIERCTnVtWzc6NF0gYXJlIGxvY2F0ZWQgaW4gQVRVIENvbnRyb2wgMTU6MTIg
Ki8NCiAJCQllcnIgPSBtdjg4ZTZ4eHhfZzFfcmVhZChjaGlwLCBNVjg4RTZYWFhfRzFfQVRVX0NU
TCwNCiAJCQkJCQkmdmFsKTsNCkBAIC0xMDYsNiArMTA2LDkgQEAgc3RhdGljIGludCBtdjg4ZTZ4
eHhfZzFfYXR1X29wKHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwgdTE2IGZpZCwgdTE2IG9w
KQ0KIAkJCQkJCSB2YWwpOw0KIAkJCWlmIChlcnIpDQogCQkJCXJldHVybiBlcnI7DQorCQl9IGVs
c2UgaWYgKG12ODhlNnh4eF9udW1fZGF0YWJhc2VzKGNoaXApID4gMTYpIHsNCisJCQkvKiBBVFUg
REJOdW1bNTo0XSBhcmUgbG9jYXRlZCBpbiBBVFUgT3BlcmF0aW9uIDk6OCAqLw0KKwkJCW9wIHw9
IChmaWQgJiAweDMwKSA8PCA0Ow0KIAkJfQ0KIA0KIAkJLyogQVRVIERCTnVtWzM6MF0gYXJlIGxv
Y2F0ZWQgaW4gQVRVIE9wZXJhdGlvbiAzOjAgKi8NCi0tIA0KMi4yMC4xDQoNCg==
