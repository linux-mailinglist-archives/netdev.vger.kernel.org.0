Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3853D13BF64
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731225AbgAOMN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:13:27 -0500
Received: from mail-bn7nam10on2048.outbound.protection.outlook.com ([40.107.92.48]:31808
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731112AbgAOMN0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:13:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DyYhSTvdnekMJuF5ZCvhk7WitoLpoaO2HnGXjtmL7gGVXXYOZ/MFkDvQ93EAKWP8XniId7ybCiaSK6X/AAY4ArtIxQZEy3hH+D9J12/DlGxWKUhp27WzBgadHGHMbCEKRiYDguSYo90L2t9CS17rLak8Yo7+H+S3+WcmLMQp52KlqlcWbhcyN4O44NGId8fPZqofxqMv9zJCfRRfwON0nuZt0x2Tpr7lOwBSlQkFiNHauNi3rrTPEdktwilzVnXeRyEit2SmB07a9fIi3rKmQIN9tcBHZEo02N38daz0FAXzajXY2kFKZGFgt5R+MVIEowrDafm9SLU2jVIfoivAOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ld8qSg592xPJar90gdpyQ+05JoxcTxmYOxSxOuYqNVc=;
 b=avu3Q0QioLjspWFV5ggQmuG4OupHSiZ260EM8HPXtDwi1eYm2/0TDNxwb+YPno1DeOUUbBb/RIYkjMATou7O4thbAJmVbauHpWdQm3sFUwq1LeW1zEW8o7bYqDIB+lmG9ffqD833Ze+xOBKQuwqSpX0COg7blLlM8Yv42HHOkiPI7bA/0/GFQWEJ3hQXyNBEp3qo0fPRVCtwe03vIfy/f37gFwuv/Zf+i4Z92htECOw8Rkhh2duBLu5BlUgPuIYA5dY62cHbYWz0BEZTg+51NqS30aU7suMXRFUmahTaT/xLtiPf2InMdWXDe/f9lzW/89ztAXJNzv7uJjc5CrxrCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ld8qSg592xPJar90gdpyQ+05JoxcTxmYOxSxOuYqNVc=;
 b=kjCQ4RsGAznGIibmTV7lCm0UvYFqXJsAs92IBAVyg8aPSjLum1L5q2JFfYIpNzwA/u8zUdq1w/RFLZbstcvhTor4ZBZBJPdl1MqgGLT36Hsr9FjpxVu9VjfjtwuuvTCNGhw7yM23vW8lNJuJhbANX1BoEDRgdKhMCuBT6ltC8b0=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4096.namprd11.prod.outlook.com (20.179.150.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Wed, 15 Jan 2020 12:13:20 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:20 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:50 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 32/65] staging: wfx: simplify
 hif_mib_uc_mc_bc_data_frame_condition
Thread-Topic: [PATCH 32/65] staging: wfx: simplify
 hif_mib_uc_mc_bc_data_frame_condition
Thread-Index: AQHVy50cmuDmA1KnS0eIgGEIxVm8ZA==
Date:   Wed, 15 Jan 2020 12:12:51 +0000
Message-ID: <20200115121041.10863-33-Jerome.Pouiller@silabs.com>
References: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0009.eurprd09.prod.outlook.com
 (2603:10a6:101:16::21) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.25.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 692cab7d-cfcf-4c7f-5eee-08d799b43e75
x-ms-traffictypediagnostic: MN2PR11MB4096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4096D2408DA54B5F6DC7AA2893370@MN2PR11MB4096.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:843;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(376002)(136003)(199004)(189003)(85202003)(66946007)(66446008)(66476007)(2906002)(107886003)(66556008)(1076003)(64756008)(5660300002)(8936002)(6486002)(186003)(26005)(8676002)(316002)(81156014)(36756003)(52116002)(2616005)(7696005)(478600001)(16526019)(956004)(54906003)(110136005)(86362001)(71200400001)(85182001)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4096;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M1PIrSe9+DUy3G0KP8tGnSTeZEWCSW5JzRiSio96udWMkj25qkR5Q9uHvdZJQNWh4LQmXYN6n2jMXry6DExT/UxRd9Ez/AC4XkY74cR5wZx8Vodx1FGLkzLr6zfknp+t03k697z3QamK910AwaoM1YUUrY1cMuyVr4q8+kmWjivoM+FX8w6c5E8Sx31snQkESuihh/wcyfgBHUozGG42dtB4tU+h6Bb3gSRfIksrZ5bzsXFDInjhQoOPulsaRcKnzqhJK3GOtp/oSuFZx9lYgm9Gg1AieWP3B7KVQtf/K/ZriQnZkeG0LYJbxsn302AD4bLeLGaaR1WEhmKj1i/LE1U26t/i4abH5WSUzP5+wksPfGE3iGsyEWFSvKE0ogMjIYTfum/SouR2+ADaoeSKx631pc+XuKAHbtKqMdMQ6wUdbUfRCB7VvZNNH1WiyEX7
Content-Type: text/plain; charset="utf-8"
Content-ID: <2BC6496AC88B394E9866E9042B56764D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 692cab7d-cfcf-4c7f-5eee-08d799b43e75
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:51.8895
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PqWLFjCEoesWBCprIo8wd7dEMrbHGaeKSEXvXsC5lfiDa6yKME9wqiNHKG3oa//T9er+isx0/qp9hQ7M7nYRkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4096
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGN1cnJlbnQgQVBJIGRlZmluZXMgYml0ZmllbGRzLiBJdCBpcyBub3QgdmVyeSBjb252ZW5pZW50
LiBQcmVmZXIgdG8KdXNlIGJpdG1hc2tzLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxs
ZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX2FwaV9taWIuaCB8IDE0ICsrKystLS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hp
Zl90eF9taWIuaCAgfCAgOSArKystLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgICAg
ICAgICB8ICA0ICsrLS0KIDMgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAxOCBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfbWliLmgg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfbWliLmgKaW5kZXggMTYwM2IzMDc0YmY3Li5l
MGVmMDMzN2UwMWMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9taWIu
aAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfbWliLmgKQEAgLTE4MSwxOSArMTgx
LDEzIEBAIHN0cnVjdCBoaWZfbWliX2lwdjZfYWRkcl9kYXRhX2ZyYW1lX2NvbmRpdGlvbiB7CiAJ
dTggICAgaV9wdjZfYWRkcmVzc1tISUZfQVBJX0lQVjZfQUREUkVTU19TSVpFXTsKIH0gX19wYWNr
ZWQ7CiAKLXVuaW9uIGhpZl9hZGRyX3R5cGUgewotCXU4IHZhbHVlOwotCXN0cnVjdCB7Ci0JCXU4
ICAgIHR5cGVfdW5pY2FzdDoxOwotCQl1OCAgICB0eXBlX211bHRpY2FzdDoxOwotCQl1OCAgICB0
eXBlX2Jyb2FkY2FzdDoxOwotCQl1OCAgICByZXNlcnZlZDo1OwotCX0gYml0czsKLX07CisjZGVm
aW5lIEhJRl9GSUxURVJfVU5JQ0FTVCAgIDB4MQorI2RlZmluZSBISUZfRklMVEVSX01VTFRJQ0FT
VCAweDIKKyNkZWZpbmUgSElGX0ZJTFRFUl9CUk9BRENBU1QgMHg0CiAKIHN0cnVjdCBoaWZfbWli
X3VjX21jX2JjX2RhdGFfZnJhbWVfY29uZGl0aW9uIHsKIAl1OCAgICBjb25kaXRpb25faWR4Owot
CXVuaW9uIGhpZl9hZGRyX3R5cGUgcGFyYW07CisJdTggICAgYWxsb3dlZF9mcmFtZXM7CiAJdTgg
ICAgcmVzZXJ2ZWRbMl07CiB9IF9fcGFja2VkOwogCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl90eF9taWIuaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oCmlu
ZGV4IDRkMTcxZTZjZmM5YS4uNmU4YjA1MGNiYzI1IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl90eF9taWIuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIu
aApAQCAtMjQ2LDE1ICsyNDYsMTIgQEAgc3RhdGljIGlubGluZSBpbnQgaGlmX3NldF9tYWNfYWRk
cl9jb25kaXRpb24oc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJCQkgICAgIGFyZywgc2l6ZW9mKCph
cmcpKTsKIH0KIAotLy8gRklYTUU6IHVzZSBhIGJpdGZpZWxkIGluc3RlYWQgb2YgMyBib29sZWFu
IHZhbHVlcwotc3RhdGljIGlubGluZSBpbnQgaGlmX3NldF91Y19tY19iY19jb25kaXRpb24oc3Ry
dWN0IHdmeF92aWYgKnd2aWYsIGludCBpZHgsCi0JCQkJCSAgICAgYm9vbCB1bmljLCBib29sIG11
bHRpYywgYm9vbCBicm9hZGMpCitzdGF0aWMgaW5saW5lIGludCBoaWZfc2V0X3VjX21jX2JjX2Nv
bmRpdGlvbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKKwkJCQkJICAgICBpbnQgaWR4LCB1OCBhbGxv
d2VkX2ZyYW1lcykKIHsKIAlzdHJ1Y3QgaGlmX21pYl91Y19tY19iY19kYXRhX2ZyYW1lX2NvbmRp
dGlvbiB2YWwgPSB7CiAJCS5jb25kaXRpb25faWR4ID0gaWR4LAotCQkucGFyYW0uYml0cy50eXBl
X3VuaWNhc3QgPSB1bmljLAotCQkucGFyYW0uYml0cy50eXBlX211bHRpY2FzdCA9IG11bHRpYywK
LQkJLnBhcmFtLmJpdHMudHlwZV9icm9hZGNhc3QgPSBicm9hZGMsCisJCS5hbGxvd2VkX2ZyYW1l
cyA9IGFsbG93ZWRfZnJhbWVzLAogCX07CiAKIAlyZXR1cm4gaGlmX3dyaXRlX21pYih3dmlmLT53
ZGV2LCB3dmlmLT5pZCwKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDc5Mjg1OTI3YzdiZi4uMWMxYjVhNmMyNDc0
IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3Rh
Z2luZy93Zngvc3RhLmMKQEAgLTE0Miw4ICsxNDIsOCBAQCBzdGF0aWMgaW50IHdmeF9zZXRfbWNh
c3RfZmlsdGVyKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCQljb25maWcubWFjX2NvbmQgfD0gMSA8
PCBpOwogCX0KIAotCS8vIEFjY2VwdCB1bmljYXN0IGFuZCBicm9hZGNhc3QKLQlyZXQgPSBoaWZf
c2V0X3VjX21jX2JjX2NvbmRpdGlvbih3dmlmLCAwLCB0cnVlLCBmYWxzZSwgdHJ1ZSk7CisJcmV0
ID0gaGlmX3NldF91Y19tY19iY19jb25kaXRpb24od3ZpZiwgMCwgSElGX0ZJTFRFUl9VTklDQVNU
IHwKKwkJCQkJCSAgSElGX0ZJTFRFUl9CUk9BRENBU1QpOwogCWlmIChyZXQpCiAJCXJldHVybiBy
ZXQ7CiAKLS0gCjIuMjUuMAoK
