Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BADF29419
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 11:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389865AbfEXJAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 05:00:36 -0400
Received: from mail-eopbgr30131.outbound.protection.outlook.com ([40.107.3.131]:58510
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389880AbfEXJAf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 05:00:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TzhYvaIsn+Om1w3zqpH8R9dBqL2SJ2l5zhIE/MQvgc8=;
 b=AJXE5Aqm+RSKfNUUTP14rl3+2sXGRhAKE78j+NpWZLrUjwOJF4r1eLzRqylQ+C5BJJzHgt+mFbXqR8gBhXoIT2rlxY7BDrgUM/0dN4Lvh/DDvtaJTsNRMRpgu9d+Ln7ZYWBopw9awwhjzTFuPxXsZEvWOcv9xkECjV9JRkft4Z0=
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM (20.178.126.212) by
 VI1PR10MB1535.EURPRD10.PROD.OUTLOOK.COM (10.166.146.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Fri, 24 May 2019 09:00:26 +0000
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::c81b:1b10:f6ab:fee5]) by VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::c81b:1b10:f6ab:fee5%3]) with mapi id 15.20.1922.016; Fri, 24 May 2019
 09:00:26 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/5] net: dsa: prepare mv88e6xxx_g1_atu_op() for the
 mv88e6250
Thread-Topic: [PATCH v2 2/5] net: dsa: prepare mv88e6xxx_g1_atu_op() for the
 mv88e6250
Thread-Index: AQHVEg8gux76wvKz70esnAhliSeVsg==
Date:   Fri, 24 May 2019 09:00:26 +0000
Message-ID: <20190524085921.11108-3-rasmus.villemoes@prevas.dk>
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
x-ms-office365-filtering-correlation-id: 39bb0032-3e6e-4b1e-cef7-08d6e026432b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:VI1PR10MB1535;
x-ms-traffictypediagnostic: VI1PR10MB1535:
x-microsoft-antispam-prvs: <VI1PR10MB153504B6658E497247F82D528A020@VI1PR10MB1535.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(136003)(366004)(396003)(376002)(346002)(189003)(199004)(42882007)(66946007)(73956011)(81166006)(102836004)(66066001)(6116002)(76176011)(1076003)(25786009)(52116002)(478600001)(386003)(6512007)(6506007)(186003)(3846002)(74482002)(72206003)(4326008)(66556008)(64756008)(66446008)(66476007)(316002)(26005)(36756003)(68736007)(50226002)(305945005)(5660300002)(7736002)(6436002)(44832011)(256004)(14444005)(486006)(53936002)(8676002)(81156014)(8976002)(110136005)(476003)(6486002)(8936002)(446003)(2906002)(11346002)(54906003)(2616005)(99286004)(71190400001)(71200400001)(14454004)(138113003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB1535;H:VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: m2EjyjF09cuvq9skqNZj/N1ooht6Bb9ZJ2GSuPVGDPJAEmSBAoGQ4dcHbx2czK3Tp8zjBxhN9QPcDMB7CebbFzgIIdbqJpILOE+ZAp9vHTAwsy9Y/eI08Biwe+dOKPgIeWEPJ1Ju2IyQhGEDFhV0QLUxoLex6BYqzioutitDKds3+V7JQeSC+g6HyrRu7JjSokU+VcPHoaaknqFqRL8Vqk20BeBmYFGTnYtLTDFB5K0TxOukNisqB9iLSQC9LkBMz9KgLwpPS1fgXMdAVMav2pUe8sgJ6sfgCi/Ips+/Yk8PLIlP9iez1yysINjdWrQwtLbUIt6W49QLbmEUlEyCRNG+ASYW2ioaeYQl9XV72G9EISQpfD+UnEGIJA2QRlyxqOmXgqy8d7gVuljR21N0EzK+AwM6qKtZKLCiBXPtn4Q=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 39bb0032-3e6e-4b1e-cef7-08d6e026432b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 09:00:26.5004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB1535
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
dmlld2VkLWJ5OiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+DQpTaWduZWQtb2ZmLWJ5OiBS
YXNtdXMgVmlsbGVtb2VzIDxyYXNtdXMudmlsbGVtb2VzQHByZXZhcy5kaz4NCi0tLQ0KIGRyaXZl
cnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMV9hdHUuYyB8IDUgKysrKy0NCiAxIGZpbGUgY2hh
bmdlZCwgNCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2JhbDFfYXR1LmMgYi9kcml2ZXJzL25ldC9kc2EvbXY4
OGU2eHh4L2dsb2JhbDFfYXR1LmMNCmluZGV4IGVhMjQzODQwZWUwZi4uMWFlNjgwYmMwZWZmIDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwxX2F0dS5jDQorKysg
Yi9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2JhbDFfYXR1LmMNCkBAIC05NCw3ICs5NCw3
IEBAIHN0YXRpYyBpbnQgbXY4OGU2eHh4X2cxX2F0dV9vcChzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAg
KmNoaXAsIHUxNiBmaWQsIHUxNiBvcCkNCiAJCWlmIChlcnIpDQogCQkJcmV0dXJuIGVycjsNCiAJ
fSBlbHNlIHsNCi0JCWlmIChtdjg4ZTZ4eHhfbnVtX2RhdGFiYXNlcyhjaGlwKSA+IDE2KSB7DQor
CQlpZiAobXY4OGU2eHh4X251bV9kYXRhYmFzZXMoY2hpcCkgPiA2NCkgew0KIAkJCS8qIEFUVSBE
Qk51bVs3OjRdIGFyZSBsb2NhdGVkIGluIEFUVSBDb250cm9sIDE1OjEyICovDQogCQkJZXJyID0g
bXY4OGU2eHh4X2cxX3JlYWQoY2hpcCwgTVY4OEU2WFhYX0cxX0FUVV9DVEwsDQogCQkJCQkJJnZh
bCk7DQpAQCAtMTA2LDYgKzEwNiw5IEBAIHN0YXRpYyBpbnQgbXY4OGU2eHh4X2cxX2F0dV9vcChz
dHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXAsIHUxNiBmaWQsIHUxNiBvcCkNCiAJCQkJCQkgdmFs
KTsNCiAJCQlpZiAoZXJyKQ0KIAkJCQlyZXR1cm4gZXJyOw0KKwkJfSBlbHNlIGlmIChtdjg4ZTZ4
eHhfbnVtX2RhdGFiYXNlcyhjaGlwKSA+IDE2KSB7DQorCQkJLyogQVRVIERCTnVtWzU6NF0gYXJl
IGxvY2F0ZWQgaW4gQVRVIE9wZXJhdGlvbiA5OjggKi8NCisJCQlvcCB8PSAoZmlkICYgMHgzMCkg
PDwgNDsNCiAJCX0NCiANCiAJCS8qIEFUVSBEQk51bVszOjBdIGFyZSBsb2NhdGVkIGluIEFUVSBP
cGVyYXRpb24gMzowICovDQotLSANCjIuMjAuMQ0KDQo=
