Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14F9B34899
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfFDNYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:24:33 -0400
Received: from mail-eopbgr780071.outbound.protection.outlook.com ([40.107.78.71]:1488
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727343AbfFDNYd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jun 2019 09:24:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hdFEHPwVWgGaWN9Po1+bqvEoahPGUHR9HonDXl18JZE=;
 b=XPvfG3IyneKHAjaT0Sn7kBqkx9vlpGGDRrbaxJ54icvsSPs0GeERhlvtojEX1noaLPKmgxcNLqSmozREsQNy78pxtGpOhWghviSxbb9YlTL2d4egyhAoveMzgdgTj1RHNFe5FtpdJn80JM3s+X/EajSWbtGxTXxg7EvVICMPZaM=
Received: from MWHPR11MB1968.namprd11.prod.outlook.com (10.175.54.143) by
 MWHPR11MB1376.namprd11.prod.outlook.com (10.169.230.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.18; Tue, 4 Jun 2019 13:23:49 +0000
Received: from MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::fd20:d79e:4027:a437]) by MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::fd20:d79e:4027:a437%3]) with mapi id 15.20.1965.011; Tue, 4 Jun 2019
 13:23:49 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>
Subject: [PATCH net] net: aquantia: fix wol configuration not applied
 sometimes
Thread-Topic: [PATCH net] net: aquantia: fix wol configuration not applied
 sometimes
Thread-Index: AQHVGti+lRAuZGmA/UGc9JbT0ALqSA==
Date:   Tue, 4 Jun 2019 13:23:49 +0000
Message-ID: <e06ec30228aac6503f9da33e411dd07a175683b0.1559571979.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0186.eurprd05.prod.outlook.com
 (2603:10a6:3:f8::34) To MWHPR11MB1968.namprd11.prod.outlook.com
 (2603:10b6:300:111::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52a02200-6dd8-4cb1-0a76-08d6e8efe109
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR11MB1376;
x-ms-traffictypediagnostic: MWHPR11MB1376:
x-microsoft-antispam-prvs: <MWHPR11MB13769AA326AF8605772D663A98150@MWHPR11MB1376.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:247;
x-forefront-prvs: 0058ABBBC7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(346002)(366004)(376002)(199004)(189003)(73956011)(66946007)(66446008)(64756008)(66476007)(66556008)(6116002)(3846002)(2906002)(316002)(71190400001)(71200400001)(81156014)(50226002)(68736007)(8676002)(8936002)(36756003)(305945005)(7736002)(4326008)(25786009)(26005)(81166006)(186003)(107886003)(53936002)(386003)(6506007)(66066001)(102836004)(54906003)(2616005)(476003)(52116002)(44832011)(486006)(99286004)(118296001)(86362001)(5660300002)(6512007)(6486002)(6916009)(6436002)(14454004)(478600001)(72206003)(14444005)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1376;H:MWHPR11MB1968.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: U61LYn2K8ANX1p4uy66ZPoZVpP9mPciwVEzy7tOM7WKJLg5YOGt4NedKC87nVimr2g+19u4lQ8ixcZinc+McWR8gjkrMF2734pOvbUrAYbUC2yQDSEkbAJoYEkz+GymTW25xnbS3yq6ARRTF03AEuFR5LWvJnVjPvGwVuUvyji1m3DhX1BLQHVsJetIZVBL7cKilTHwaHM2CaENJA4iypzOwkMPxqk8MTkq53Bcu2fJa1EXCXUyMDr0KWHGCPcUYxdPIId9mLS1dgOxWw32ydVJNUMQ2ggbWFcKgz8WlcHXrxRss9WytcKvQNMwxurKuv9FVHez2bqK+vKI/Mjb2I2W4/bxbbv2XKEbrCDGXnYjDUYMO9/cMdrtstRFdafh69v9yaXLwgNkzK5SQxSi9kj4ACwWaCZzsn7M7FRN28HE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52a02200-6dd8-4cb1-0a76-08d6e8efe109
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2019 13:23:49.6813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: irusski@aquantia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1376
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTmlraXRhIERhbmlsb3YgPG5pa2l0YS5kYW5pbG92QGFxdWFudGlhLmNvbT4NCg0KV29M
IG1hZ2ljIHBhY2tldCBjb25maWd1cmF0aW9uIHNvbWV0aW1lcyBkb2VzIG5vdCB3b3JrIGR1ZSB0
bw0KY291cGxlIG9mIGxlYWthZ2VzIGZvdW5kLg0KDQpNYWlubHkgdGhlcmUgd2FzIGEgcmVncmVz
c2lvbiBpbnRyb2R1Y2VkIGR1cmluZyByZWFkeF9wb2xsIHJlZmFjdG9yaW5nLg0KDQpOZXh0LCBm
dyByZXF1ZXN0IHdhaXRpbmcgdGltZSB3YXMgdG9vIHNtYWxsLiBTb21ldGltZXMgdGhhdA0KY2F1
c2VkIHNsZWVwIHByb3h5IGNvbmZpZyBmdW5jdGlvbiB0byByZXR1cm4gd2l0aCBhbiBlcnJvcg0K
YW5kIHRvIHNraXAgV29MIGNvbmZpZ3VyYXRpb24uDQpBdCBsYXN0LCBXb0wgZGF0YSB3ZXJlIHBh
c3NlZCB0byBGVyBmcm9tIG5vdCBjbGVhbiBidWZmZXIuDQpUaGF0IGNvdWxkIGNhdXNlIEZXIHRv
IGFjY2VwdCBnYXJiYWdlIGFzIGEgcmFuZG9tIGNvbmZpZ3VyYXRpb24gZGF0YS4NCg0KU2lnbmVk
LW9mZi1ieTogTmlraXRhIERhbmlsb3YgPG5pa2l0YS5kYW5pbG92QGFxdWFudGlhLmNvbT4NClNp
Z25lZC1vZmYtYnk6IElnb3IgUnVzc2tpa2ggPGlnb3IucnVzc2tpa2hAYXF1YW50aWEuY29tPg0K
Rml4ZXM6IDZhN2YyMjc3MzEzYiAoIm5ldDogYXF1YW50aWE6IHJlcGxhY2UgQVFfSFdfV0FJVF9G
T1Igd2l0aCByZWFkeF9wb2xsX3RpbWVvdXRfYXRvbWljIikNCi0tLQ0KIC4uLi9hcXVhbnRpYS9h
dGxhbnRpYy9od19hdGwvaHdfYXRsX3V0aWxzLmMgICAgICAgIHwgMTQgKysrKysrKy0tLS0tLS0N
CiAuLi4vYXF1YW50aWEvYXRsYW50aWMvaHdfYXRsL2h3X2F0bF91dGlsc19mdzJ4LmMgICB8ICA0
ICsrKy0NCiAyIGZpbGVzIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0p
DQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9o
d19hdGwvaHdfYXRsX3V0aWxzLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxh
bnRpYy9od19hdGwvaHdfYXRsX3V0aWxzLmMNCmluZGV4IDEyMDhmN2VjZGQ3Ni4uM2ZjNDFkYTM5
YTBhIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMv
aHdfYXRsL2h3X2F0bF91dGlscy5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRp
YS9hdGxhbnRpYy9od19hdGwvaHdfYXRsX3V0aWxzLmMNCkBAIC0zMzUsMTMgKzMzNSwxMyBAQCBz
dGF0aWMgaW50IGh3X2F0bF91dGlsc19md191cGxvYWRfZHdvcmRzKHN0cnVjdCBhcV9od19zICpz
ZWxmLCB1MzIgYSwgdTMyICpwLA0KIHsNCiAJdTMyIHZhbDsNCiAJaW50IGVyciA9IDA7DQotCWJv
b2wgaXNfbG9ja2VkOw0KIA0KLQlpc19sb2NrZWQgPSBod19hdGxfc2VtX3JhbV9nZXQoc2VsZik7
DQotCWlmICghaXNfbG9ja2VkKSB7DQotCQllcnIgPSAtRVRJTUU7DQorCWVyciA9IHJlYWR4X3Bv
bGxfdGltZW91dF9hdG9taWMoaHdfYXRsX3NlbV9yYW1fZ2V0LCBzZWxmLA0KKwkJCQkJdmFsLCB2
YWwgPT0gMVUsDQorCQkJCQkxMFUsIDEwMDAwMFUpOw0KKwlpZiAoZXJyIDwgMCkNCiAJCWdvdG8g
ZXJyX2V4aXQ7DQotCX0NCisNCiAJaWYgKElTX0NISVBfRkVBVFVSRShSRVZJU0lPTl9CMSkpIHsN
CiAJCXUzMiBvZmZzZXQgPSAwOw0KIA0KQEAgLTM1Myw4ICszNTMsOCBAQCBzdGF0aWMgaW50IGh3
X2F0bF91dGlsc19md191cGxvYWRfZHdvcmRzKHN0cnVjdCBhcV9od19zICpzZWxmLCB1MzIgYSwg
dTMyICpwLA0KIAkJCS8qIDEwMDAgdGltZXMgYnkgMTB1cyA9IDEwbXMgKi8NCiAJCQllcnIgPSBy
ZWFkeF9wb2xsX3RpbWVvdXRfYXRvbWljKGh3X2F0bF9zY3JwYWQxMl9nZXQsDQogCQkJCQkJCXNl
bGYsIHZhbCwNCi0JCQkJCQkJKHZhbCAmIDB4RjAwMDAwMDApID09DQotCQkJCQkJCSAweDgwMDAw
MDAwLA0KKwkJCQkJCQkodmFsICYgMHhGMDAwMDAwMCkgIT0NCisJCQkJCQkJMHg4MDAwMDAwMCwN
CiAJCQkJCQkJMTBVLCAxMDAwMFUpOw0KIAkJfQ0KIAl9IGVsc2Ugew0KZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2h3X2F0bC9od19hdGxfdXRpbHNf
ZncyeC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvaHdfYXRsL2h3
X2F0bF91dGlsc19mdzJ4LmMNCmluZGV4IGZiYzlkNmFjODQxZi4uOWMxNmQ4NWZiMTA0IDEwMDY0
NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvaHdfYXRsL2h3
X2F0bF91dGlsc19mdzJ4LmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0
bGFudGljL2h3X2F0bC9od19hdGxfdXRpbHNfZncyeC5jDQpAQCAtMzg0LDcgKzM4NCw3IEBAIHN0
YXRpYyBpbnQgYXFfZncyeF9zZXRfc2xlZXBfcHJveHkoc3RydWN0IGFxX2h3X3MgKnNlbGYsIHU4
ICptYWMpDQogCWVyciA9IHJlYWR4X3BvbGxfdGltZW91dF9hdG9taWMoYXFfZncyeF9zdGF0ZTJf
Z2V0LA0KIAkJCQkJc2VsZiwgdmFsLA0KIAkJCQkJdmFsICYgSFdfQVRMX0ZXMlhfQ1RSTF9TTEVF
UF9QUk9YWSwNCi0JCQkJCTFVLCAxMDAwMFUpOw0KKwkJCQkJMVUsIDEwMDAwMFUpOw0KIA0KIGVy
cl9leGl0Og0KIAlyZXR1cm4gZXJyOw0KQEAgLTQwNCw2ICs0MDQsOCBAQCBzdGF0aWMgaW50IGFx
X2Z3Mnhfc2V0X3dvbF9wYXJhbXMoc3RydWN0IGFxX2h3X3MgKnNlbGYsIHU4ICptYWMpDQogDQog
CW1zZyA9IChzdHJ1Y3QgZncyeF9tc2dfd29sICopcnBjOw0KIA0KKwltZW1zZXQobXNnLCAwLCBz
aXplb2YoKm1zZykpOw0KKw0KIAltc2ctPm1zZ19pZCA9IEhBTF9BVExBTlRJQ19VVElMU19GVzJY
X01TR19XT0w7DQogCW1zZy0+bWFnaWNfcGFja2V0X2VuYWJsZWQgPSB0cnVlOw0KIAltZW1jcHko
bXNnLT5od19hZGRyLCBtYWMsIEVUSF9BTEVOKTsNCi0tIA0KMi4xNy4xDQoNCg==
