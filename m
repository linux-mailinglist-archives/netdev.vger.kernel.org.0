Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E456A33260
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 16:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbfFCOme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 10:42:34 -0400
Received: from mail-eopbgr30118.outbound.protection.outlook.com ([40.107.3.118]:22244
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729146AbfFCOmY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 10:42:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=czKpFYtVAD3NAs2YBqhruVom3gfJCXBzDLLQMV4GD90=;
 b=Yfnkpop5ORSzzhB5FWJ1wDPag8xdeu4Xc2ouh2/kjc+e+sJa58qggQT70gtgtf0TFM25UVY30BOgS/b18OaKcCwIInNtJsyeFRtQKDnW3Ju1wStg+VxxEYSBklug37mMjtMNLN8DYBwuiH5CATCZ12mMJQ9S1jtC4+uq0RXrYkc=
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM (20.178.126.80) by
 VI1PR10MB2574.EURPRD10.PROD.OUTLOOK.COM (20.178.125.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Mon, 3 Jun 2019 14:42:16 +0000
Received: from VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5]) by VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::8844:426d:816b:f5d5%6]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 14:42:16 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v3 04/10] net: dsa: mv88e6xxx: implement vtu_getnext
 and vtu_loadpurge for mv88e6250
Thread-Topic: [PATCH net-next v3 04/10] net: dsa: mv88e6xxx: implement
 vtu_getnext and vtu_loadpurge for mv88e6250
Thread-Index: AQHVGhqJosBlVB9gyUOxAR2MDYNBLQ==
Date:   Mon, 3 Jun 2019 14:42:16 +0000
Message-ID: <20190603144112.27713-5-rasmus.villemoes@prevas.dk>
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
x-ms-office365-filtering-correlation-id: ca92a49a-a7b3-4fb5-0f94-08d6e831ac4d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:VI1PR10MB2574;
x-ms-traffictypediagnostic: VI1PR10MB2574:
x-microsoft-antispam-prvs: <VI1PR10MB2574C585ABDAF71A29350B1A8A140@VI1PR10MB2574.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39850400004)(366004)(346002)(376002)(396003)(136003)(189003)(199004)(42882007)(50226002)(446003)(476003)(73956011)(66556008)(64756008)(66446008)(66476007)(81156014)(11346002)(256004)(8976002)(53936002)(72206003)(66946007)(316002)(14454004)(99286004)(8676002)(81166006)(8936002)(71190400001)(110136005)(71200400001)(102836004)(2616005)(4326008)(54906003)(25786009)(386003)(7736002)(52116002)(6506007)(26005)(486006)(2906002)(66066001)(36756003)(186003)(6512007)(68736007)(1076003)(74482002)(305945005)(76176011)(478600001)(3846002)(5660300002)(6436002)(6116002)(44832011)(6486002)(138113003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB2574;H:VI1PR10MB2639.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Uuj5R8chssMomQLhUi9DTZgNHI8N/GDQZIKDvgmPkmenDTEjwCqw5adFIDkmTjUDfs1Q1sQORIYcZ3AYCwdWIIvxk0sGRK+q/iyoYt2fEfuu6RrO+t9wTyU3i6nqubVh9+Ff71REu81WL/OfOqWM9YYLwN8HaucECMJ43oQ/WDS1dRwz7kl7hAorwr3uqsGshzP8D+DQxrj4x5ZjCl65wVZSpqU266nDyiqRT+gPY1OTrJ9YWbSFCgd3KQbocBj+clWUvVHfmfSAO+iryhaf4c+sFbDCcU+PcFJdJ/TTGo5t3tgX8778Ny499FZWPMXi4WMiu8ZwA6xbhxxAyd3r2hwcDSuz/0M+oWualjWB+931hdQ425ZxqfQFlNxrFH1m7I24S6/r99yN3Jysw8gqaUCRhDmLM5I0hH5E+0QbwZk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: ca92a49a-a7b3-4fb5-0f94-08d6e831ac4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 14:42:16.3705
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

VGhlc2UgYXJlIGFsbW9zdCBpZGVudGljYWwgdG8gdGhlIDYxODUgdmFyaWFudHMsIGJ1dCBoYXZl
IGZld2VyIGJpdHMNCmZvciB0aGUgRklELg0KDQpCaXQgMTAgb2YgdGhlIFZUVV9PUCByZWdpc3Rl
ciAob2Zmc2V0IDB4MDUpIGlzIHRoZSBWaWRQb2xpY3kgYml0LA0Kd2hpY2ggb25lIHNob3VsZCBw
cm9iYWJseSBwcmVzZXJ2ZSBpbiBtdjg4ZTZ4eHhfZzFfdnR1X29wKCksIGluc3RlYWQNCm9mIGFs
d2F5cyB3cml0aW5nIGEgMC4gSG93ZXZlciwgb24gdGhlIDYzNTIgZmFtaWx5LCB0aGF0IGJpdCBp
cw0KbG9jYXRlZCBhdCBiaXQgMTIgaW4gdGhlIFZUVSBGSUQgcmVnaXN0ZXIgKG9mZnNldCAweDAy
KSwgYW5kIGlzIGFsd2F5cw0KdW5jb25kaXRpb25hbGx5IGNsZWFyZWQgYnkgdGhlIG12ODhlNnh4
eF9nMV92dHVfZmlkX3dyaXRlKCkNCmZ1bmN0aW9uLg0KDQpTaW5jZSBub3RoaW5nIGluIHRoZSBl
eGlzdGluZyBkcml2ZXIgc2VlbXMgdG8ga25vdyBvciBjYXJlIGFib3V0IHRoYXQNCmJpdCwgaXQg
c2VlbXMgcmVhc29uYWJsZSB0byBub3QgYWRkIHRoZSBib2lsZXJwbGF0ZSB0byBwcmVzZXJ2ZSBp
dCBmb3INCnRoZSA2MjUwICh3aGljaCB3b3VsZCByZXF1aXJlIGFkZGluZyBhIGNoaXAtc3BlY2lm
aWMgdnR1X29wIGZ1bmN0aW9uLA0Kb3IgYWRkaW5nIGNoaXAtcXVpcmtzIHRvIHRoZSBleGlzdGlu
ZyBvbmUpLg0KDQpSZXZpZXdlZC1ieTogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KUmV2
aWV3ZWQtYnk6IFZpdmllbiBEaWRlbG90IDx2aXZpZW4uZGlkZWxvdEBnbWFpbC5jb20+DQpTaWdu
ZWQtb2ZmLWJ5OiBSYXNtdXMgVmlsbGVtb2VzIDxyYXNtdXMudmlsbGVtb2VzQHByZXZhcy5kaz4N
Ci0tLQ0KIGRyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMS5oICAgICB8ICA0ICsrDQog
ZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwxX3Z0dS5jIHwgNTggKysrKysrKysrKysr
KysrKysrKysrKysrKw0KIDIgZmlsZXMgY2hhbmdlZCwgNjIgaW5zZXJ0aW9ucygrKQ0KDQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwxLmggYi9kcml2ZXJzL25l
dC9kc2EvbXY4OGU2eHh4L2dsb2JhbDEuaA0KaW5kZXggMmJjYmU3YzhiMjc5Li43MTFhMmM2ZDBh
MjUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2JhbDEuaA0KKysr
IGIvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9nbG9iYWwxLmgNCkBAIC0zMDYsNiArMzA2LDEw
IEBAIGludCBtdjg4ZTYxODVfZzFfdnR1X2dldG5leHQoc3RydWN0IG12ODhlNnh4eF9jaGlwICpj
aGlwLA0KIAkJCSAgICAgc3RydWN0IG12ODhlNnh4eF92dHVfZW50cnkgKmVudHJ5KTsNCiBpbnQg
bXY4OGU2MTg1X2cxX3Z0dV9sb2FkcHVyZ2Uoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLA0K
IAkJCSAgICAgICBzdHJ1Y3QgbXY4OGU2eHh4X3Z0dV9lbnRyeSAqZW50cnkpOw0KK2ludCBtdjg4
ZTYyNTBfZzFfdnR1X2dldG5leHQoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLA0KKwkJCSAg
ICAgc3RydWN0IG12ODhlNnh4eF92dHVfZW50cnkgKmVudHJ5KTsNCitpbnQgbXY4OGU2MjUwX2cx
X3Z0dV9sb2FkcHVyZ2Uoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLA0KKwkJCSAgICAgICBz
dHJ1Y3QgbXY4OGU2eHh4X3Z0dV9lbnRyeSAqZW50cnkpOw0KIGludCBtdjg4ZTYzNTJfZzFfdnR1
X2dldG5leHQoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLA0KIAkJCSAgICAgc3RydWN0IG12
ODhlNnh4eF92dHVfZW50cnkgKmVudHJ5KTsNCiBpbnQgbXY4OGU2MzUyX2cxX3Z0dV9sb2FkcHVy
Z2Uoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLA0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMV92dHUuYyBiL2RyaXZlcnMvbmV0L2RzYS9tdjg4ZTZ4eHgv
Z2xvYmFsMV92dHUuYw0KaW5kZXggMDU4MzI2OTI0ZjNlLi5hOGVmMjY4YzMyY2IgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2dsb2JhbDFfdnR1LmMNCisrKyBiL2RyaXZl
cnMvbmV0L2RzYS9tdjg4ZTZ4eHgvZ2xvYmFsMV92dHUuYw0KQEAgLTMwNyw2ICszMDcsMzUgQEAg
c3RhdGljIGludCBtdjg4ZTZ4eHhfZzFfdnR1X2dldG5leHQoc3RydWN0IG12ODhlNnh4eF9jaGlw
ICpjaGlwLA0KIAlyZXR1cm4gbXY4OGU2eHh4X2cxX3Z0dV92aWRfcmVhZChjaGlwLCBlbnRyeSk7
DQogfQ0KIA0KK2ludCBtdjg4ZTYyNTBfZzFfdnR1X2dldG5leHQoc3RydWN0IG12ODhlNnh4eF9j
aGlwICpjaGlwLA0KKwkJCSAgICAgc3RydWN0IG12ODhlNnh4eF92dHVfZW50cnkgKmVudHJ5KQ0K
K3sNCisJdTE2IHZhbDsNCisJaW50IGVycjsNCisNCisJZXJyID0gbXY4OGU2eHh4X2cxX3Z0dV9n
ZXRuZXh0KGNoaXAsIGVudHJ5KTsNCisJaWYgKGVycikNCisJCXJldHVybiBlcnI7DQorDQorCWlm
IChlbnRyeS0+dmFsaWQpIHsNCisJCWVyciA9IG12ODhlNjE4NV9nMV92dHVfZGF0YV9yZWFkKGNo
aXAsIGVudHJ5KTsNCisJCWlmIChlcnIpDQorCQkJcmV0dXJuIGVycjsNCisNCisJCS8qIFZUVSBE
Qk51bVszOjBdIGFyZSBsb2NhdGVkIGluIFZUVSBPcGVyYXRpb24gMzowDQorCQkgKiBWVFUgREJO
dW1bNTo0XSBhcmUgbG9jYXRlZCBpbiBWVFUgT3BlcmF0aW9uIDk6OA0KKwkJICovDQorCQllcnIg
PSBtdjg4ZTZ4eHhfZzFfcmVhZChjaGlwLCBNVjg4RTZYWFhfRzFfVlRVX09QLCAmdmFsKTsNCisJ
CWlmIChlcnIpDQorCQkJcmV0dXJuIGVycjsNCisNCisJCWVudHJ5LT5maWQgPSB2YWwgJiAweDAw
MGY7DQorCQllbnRyeS0+ZmlkIHw9ICh2YWwgJiAweDAzMDApID4+IDQ7DQorCX0NCisNCisJcmV0
dXJuIDA7DQorfQ0KKw0KIGludCBtdjg4ZTYxODVfZzFfdnR1X2dldG5leHQoc3RydWN0IG12ODhl
Nnh4eF9jaGlwICpjaGlwLA0KIAkJCSAgICAgc3RydWN0IG12ODhlNnh4eF92dHVfZW50cnkgKmVu
dHJ5KQ0KIHsNCkBAIC0zOTYsNiArNDI1LDM1IEBAIGludCBtdjg4ZTYzOTBfZzFfdnR1X2dldG5l
eHQoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLA0KIAlyZXR1cm4gMDsNCiB9DQogDQoraW50
IG12ODhlNjI1MF9nMV92dHVfbG9hZHB1cmdlKHN0cnVjdCBtdjg4ZTZ4eHhfY2hpcCAqY2hpcCwN
CisJCQkgICAgICAgc3RydWN0IG12ODhlNnh4eF92dHVfZW50cnkgKmVudHJ5KQ0KK3sNCisJdTE2
IG9wID0gTVY4OEU2WFhYX0cxX1ZUVV9PUF9WVFVfTE9BRF9QVVJHRTsNCisJaW50IGVycjsNCisN
CisJZXJyID0gbXY4OGU2eHh4X2cxX3Z0dV9vcF93YWl0KGNoaXApOw0KKwlpZiAoZXJyKQ0KKwkJ
cmV0dXJuIGVycjsNCisNCisJZXJyID0gbXY4OGU2eHh4X2cxX3Z0dV92aWRfd3JpdGUoY2hpcCwg
ZW50cnkpOw0KKwlpZiAoZXJyKQ0KKwkJcmV0dXJuIGVycjsNCisNCisJaWYgKGVudHJ5LT52YWxp
ZCkgew0KKwkJZXJyID0gbXY4OGU2MTg1X2cxX3Z0dV9kYXRhX3dyaXRlKGNoaXAsIGVudHJ5KTsN
CisJCWlmIChlcnIpDQorCQkJcmV0dXJuIGVycjsNCisNCisJCS8qIFZUVSBEQk51bVszOjBdIGFy
ZSBsb2NhdGVkIGluIFZUVSBPcGVyYXRpb24gMzowDQorCQkgKiBWVFUgREJOdW1bNTo0XSBhcmUg
bG9jYXRlZCBpbiBWVFUgT3BlcmF0aW9uIDk6OA0KKwkJICovDQorCQlvcCB8PSBlbnRyeS0+Zmlk
ICYgMHgwMDBmOw0KKwkJb3AgfD0gKGVudHJ5LT5maWQgJiAweDAwMzApIDw8IDg7DQorCX0NCisN
CisJcmV0dXJuIG12ODhlNnh4eF9nMV92dHVfb3AoY2hpcCwgb3ApOw0KK30NCisNCiBpbnQgbXY4
OGU2MTg1X2cxX3Z0dV9sb2FkcHVyZ2Uoc3RydWN0IG12ODhlNnh4eF9jaGlwICpjaGlwLA0KIAkJ
CSAgICAgICBzdHJ1Y3QgbXY4OGU2eHh4X3Z0dV9lbnRyeSAqZW50cnkpDQogew0KLS0gDQoyLjIw
LjENCg0K
