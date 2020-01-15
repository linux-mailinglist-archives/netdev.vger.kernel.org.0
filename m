Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFC0A13C49E
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 15:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbgAOOA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 09:00:27 -0500
Received: from mail-eopbgr770053.outbound.protection.outlook.com ([40.107.77.53]:11386
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729378AbgAONyp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:54:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJJBgE/qa6i5aSZlyPZmEbjEncWQcNHZdBhB+Q46gEsm8slVWtiejB/c895K8BI0ej+tOaZiQTg9al/AItKMTVNFqbPJkspolGs17a2MYBB6TrJt8wRh4cY9llX9uqTMspQ9QIz7KoWhaoE2QEiT8NX5IuWMZF835LrxD1WND/ROdB7yas06A7wrrzBUkhYk4/vkUGQgUt2qZt6iJlhueEBkrNl7hWtlS9cFUSuuVAOX3nNPSvvMn3DsICqX+6wx7/5Z6jO6eIe5JlEJI7p1owh9YyqxZjtzcvSdJwprLnleCAZHzYnl5PDuMLW8II+7F9lPltlfAsMo1NG+C5aVGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Z6eY3YKLacQ9BswNsaslS7+IH+navlKtJGAw9pK9io=;
 b=nWciybK1nguhLKz21Q0hgBeKv1fORPszGL8LJnSdPgxnmth023czAPNsc9E3SqnCN/6W0VcNVx+fPKP3FFlwMmbcoBXeYzoGkY6VAUIqTtpU/9tNHPiNUvdWj4iI05ppdkOE/6/8wig8pXIbQKuAHJIq5oVbhL8tWhE2wtKNwF8C0htJxLoUBLV2mxs6Tf7yRu9RMDcVvpVvZG2JN/Znn4EbLstujiymmMkT+8fZslw/F/5KeWNsIjJ2RA3uZUTSmGtguFKBljlrjCcZKbCzcbweqSpSi6HmKgbLH7Am0rMBXN4ILCGsf6mPUQ7m1TaEF8cL1AOpeES0M19SPVe7nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Z6eY3YKLacQ9BswNsaslS7+IH+navlKtJGAw9pK9io=;
 b=UBn0tgCoRrnnIj7QCZd85XGjhGbmzHLWY4vuv8jMLAhzsqzg34yeJDizAWvCtisMG3UE9HATKTfVDMGSwydr9Wtsw2wiFBVQl/1zU2dWqc+0nCv16TeUj9+WyJ9B1nTgM8tK0g/qvcVv1wSqEPV22x06x+sF2HrCLXF176qFnME=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:54:43 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:54:43 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:42 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 28/65] staging: wfx: simplify hif_update_ie()
Thread-Topic: [PATCH v2 28/65] staging: wfx: simplify hif_update_ie()
Thread-Index: AQHVy6tWByjDNbiG4UW4fbzDa/d9XA==
Date:   Wed, 15 Jan 2020 13:54:43 +0000
Message-ID: <20200115135338.14374-29-Jerome.Pouiller@silabs.com>
References: <20200115135338.14374-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20200115135338.14374-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20)
 To MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.25.0
x-originating-ip: [2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ee889111-fc7c-44ec-5f22-08d799c2792c
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3661AF1665DD3748FE619E0893370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(86362001)(2616005)(4326008)(66574012)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7Xr622aJJpDtlwa/Lg91j6JSj09JpQHvpg3lmnobuPey48tpdnr4tAYC+NCk45pis2tMe7Kw3ybRou20wn2cPHt9UrW4WRvm1YIG5rs0Qw8Zsw5Iek+qBd/yLPV7rfkjBKJVtxoJMxowYkoTlw/Iz1OiSOKf4ww7WrsrvmemjVJbQHy5Pu1IAiQcU4a60/gVvFJNj1isbOJHNfsyeJripmvP1eUKEqIRNZe/RIgp13lwiZ5BVC3bMPozeEvMMYAiK4RE5bIBBLNBMPZ8bwTAyautWXdQUnc2m9aGqRe1H5MiCKl1FNx7qKoERNMAq4kCAiFfWhTuvlsjgXEm9XZkXGJd4VV0CSUamQ6ZBB+o8F+GpWCLpXIW3Hl9U7vfXQJbrD7CtV9EiIK/QIAVyRpk0yDZvlUd/KGG5BG/QKaXx8R8b59/4NVSBi2RqBJPXLsS
Content-Type: text/plain; charset="utf-8"
Content-ID: <C4CAE31142119440A2BEB8C91674779F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee889111-fc7c-44ec-5f22-08d799c2792c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:43.4479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HJTNoE8vXmr4kLSuENvYGzkUj5u8TbKIHzkDqRNv396w8MjO6rxz7lt3bA6JfEDoeaFKkmXvHKiSxaMWZUOPzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKaGlm
X3VwZGF0ZV9pZSgpIGlzIG9ubHkgY2FsbGVkIHRvIGNoYW5nZSB0aGUgYmVhY29uIHRlbXBsYXRl
LiBTbywKc3BlY2lhbGl6ZSB0aGlzIGZ1bmN0aW9uIGFuZCBzaW1wbGlmeSB0aGUgd2F5IHRvIGNh
bGwgaXQuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVy
QHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYyB8ICA1ICsrLS0t
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5oIHwgIDMgKy0tCiBkcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jICAgIHwgMTAgKystLS0tLS0tLQogMyBmaWxlcyBjaGFuZ2VkLCA1IGluc2VydGlv
bnMoKyksIDEzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCmluZGV4IDhkZjZlNDNmZTc0
Mi4uMzJlZWJhMmZjYTQ3IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5j
CisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKQEAgLTQ2MSwxNSArNDYxLDE0IEBA
IGludCBoaWZfbWFwX2xpbmsoc3RydWN0IHdmeF92aWYgKnd2aWYsIHU4ICptYWNfYWRkciwgaW50
IGZsYWdzLCBpbnQgc3RhX2lkKQogCXJldHVybiByZXQ7CiB9CiAKLWludCBoaWZfdXBkYXRlX2ll
KHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBjb25zdCBzdHJ1Y3QgaGlmX2llX2ZsYWdzICp0YXJnZXRf
ZnJhbWUsCi0JCSAgY29uc3QgdTggKmllcywgc2l6ZV90IGllc19sZW4pCitpbnQgaGlmX3VwZGF0
ZV9pZV9iZWFjb24oc3RydWN0IHdmeF92aWYgKnd2aWYsIGNvbnN0IHU4ICppZXMsIHNpemVfdCBp
ZXNfbGVuKQogewogCWludCByZXQ7CiAJc3RydWN0IGhpZl9tc2cgKmhpZjsKIAlpbnQgYnVmX2xl
biA9IHNpemVvZihzdHJ1Y3QgaGlmX3JlcV91cGRhdGVfaWUpICsgaWVzX2xlbjsKIAlzdHJ1Y3Qg
aGlmX3JlcV91cGRhdGVfaWUgKmJvZHkgPSB3ZnhfYWxsb2NfaGlmKGJ1Zl9sZW4sICZoaWYpOwog
Ci0JbWVtY3B5KCZib2R5LT5pZV9mbGFncywgdGFyZ2V0X2ZyYW1lLCBzaXplb2Yoc3RydWN0IGhp
Zl9pZV9mbGFncykpOworCWJvZHktPmllX2ZsYWdzLmJlYWNvbiA9IDE7CiAJYm9keS0+bnVtX2ll
cyA9IGNwdV90b19sZTE2KDEpOwogCW1lbWNweShib2R5LT5pZSwgaWVzLCBpZXNfbGVuKTsKIAl3
ZnhfZmlsbF9oZWFkZXIoaGlmLCB3dmlmLT5pZCwgSElGX1JFUV9JRF9VUERBVEVfSUUsIGJ1Zl9s
ZW4pOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguaCBiL2RyaXZlcnMv
c3RhZ2luZy93ZngvaGlmX3R4LmgKaW5kZXggZmJhZWQ5OTFiMTEyLi45MjRiODg5Y2FkMGEgMTAw
NjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmgKKysrIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9oaWZfdHguaApAQCAtNTcsOCArNTcsNyBAQCBpbnQgaGlmX3N0YXJ0KHN0cnVjdCB3
ZnhfdmlmICp3dmlmLCBjb25zdCBzdHJ1Y3QgaWVlZTgwMjExX2Jzc19jb25mICpjb25mLAogCSAg
ICAgIGNvbnN0IHN0cnVjdCBpZWVlODAyMTFfY2hhbm5lbCAqY2hhbm5lbCk7CiBpbnQgaGlmX2Jl
YWNvbl90cmFuc21pdChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgYm9vbCBlbmFibGUpOwogaW50IGhp
Zl9tYXBfbGluayhzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgdTggKm1hY19hZGRyLCBpbnQgZmxhZ3Ms
IGludCBzdGFfaWQpOwotaW50IGhpZl91cGRhdGVfaWUoc3RydWN0IHdmeF92aWYgKnd2aWYsIGNv
bnN0IHN0cnVjdCBoaWZfaWVfZmxhZ3MgKnRhcmdldF9mcmFtZSwKLQkJICBjb25zdCB1OCAqaWVz
LCBzaXplX3QgaWVzX2xlbik7CitpbnQgaGlmX3VwZGF0ZV9pZV9iZWFjb24oc3RydWN0IHdmeF92
aWYgKnd2aWYsIGNvbnN0IHU4ICppZXMsIHNpemVfdCBpZXNfbGVuKTsKIGludCBoaWZfc2xfc2V0
X21hY19rZXkoc3RydWN0IHdmeF9kZXYgKndkZXYsIGNvbnN0IHU4ICpzbGtfa2V5LAogCQkgICAg
ICAgaW50IGRlc3RpbmF0aW9uKTsKIGludCBoaWZfc2xfY29uZmlnKHN0cnVjdCB3ZnhfZGV2ICp3
ZGV2LCBjb25zdCB1bnNpZ25lZCBsb25nICpiaXRtYXApOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggZTAyZWJj
MzllZDQxLi4zOTVhMjgyMzQ2YjEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3Rh
LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtODgxLDkgKzg4MSw2IEBAIHZv
aWQgd2Z4X2Jzc19pbmZvX2NoYW5nZWQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsCiAJaWYgKGNo
YW5nZWQgJiBCU1NfQ0hBTkdFRF9BU1NPQyB8fAogCSAgICBjaGFuZ2VkICYgQlNTX0NIQU5HRURf
RVJQX0NUU19QUk9UIHx8CiAJICAgIGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9FUlBfUFJFQU1CTEUp
IHsKLQkJc3RydWN0IGhpZl9pZV9mbGFncyB0YXJnZXRfZnJhbWUgPSB7Ci0JCQkuYmVhY29uID0g
MSwKLQkJfTsKIAkJdTggZXJwX2llWzNdID0geyBXTEFOX0VJRF9FUlBfSU5GTywgMSwgMCB9Owog
CiAJCWhpZl9lcnBfdXNlX3Byb3RlY3Rpb24od3ZpZiwgaW5mby0+dXNlX2N0c19wcm90KTsKQEAg
LTg5Miw3ICs4ODksNyBAQCB2b2lkIHdmeF9ic3NfaW5mb19jaGFuZ2VkKHN0cnVjdCBpZWVlODAy
MTFfaHcgKmh3LAogCQlpZiAoaW5mby0+dXNlX3Nob3J0X3ByZWFtYmxlKQogCQkJZXJwX2llWzJd
IHw9IFdMQU5fRVJQX0JBUktFUl9QUkVBTUJMRTsKIAkJaWYgKHd2aWYtPnZpZi0+dHlwZSAhPSBO
TDgwMjExX0lGVFlQRV9TVEFUSU9OKQotCQkJaGlmX3VwZGF0ZV9pZSh3dmlmLCAmdGFyZ2V0X2Zy
YW1lLCBlcnBfaWUsIHNpemVvZihlcnBfaWUpKTsKKwkJCWhpZl91cGRhdGVfaWVfYmVhY29uKHd2
aWYsIGVycF9pZSwgc2l6ZW9mKGVycF9pZSkpOwogCX0KIAogCWlmIChjaGFuZ2VkICYgQlNTX0NI
QU5HRURfQVNTT0MgfHwgY2hhbmdlZCAmIEJTU19DSEFOR0VEX0VSUF9TTE9UKQpAQCAtOTYwLDkg
Kzk1Nyw2IEBAIHZvaWQgd2Z4X3N0YV9ub3RpZnkoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0
cnVjdCBpZWVlODAyMTFfdmlmICp2aWYsCiBzdGF0aWMgaW50IHdmeF9zZXRfdGltX2ltcGwoc3Ry
dWN0IHdmeF92aWYgKnd2aWYsIGJvb2wgYWlkMF9iaXRfc2V0KQogewogCXN0cnVjdCBza19idWZm
ICpza2I7Ci0Jc3RydWN0IGhpZl9pZV9mbGFncyB0YXJnZXRfZnJhbWUgPSB7Ci0JCS5iZWFjb24g
PSAxLAotCX07CiAJdTE2IHRpbV9vZmZzZXQsIHRpbV9sZW5ndGg7CiAJdTggKnRpbV9wdHI7CiAK
QEAgLTk4Nyw3ICs5ODEsNyBAQCBzdGF0aWMgaW50IHdmeF9zZXRfdGltX2ltcGwoc3RydWN0IHdm
eF92aWYgKnd2aWYsIGJvb2wgYWlkMF9iaXRfc2V0KQogCQkJdGltX3B0cls0XSAmPSB+MTsKIAl9
CiAKLQloaWZfdXBkYXRlX2llKHd2aWYsICZ0YXJnZXRfZnJhbWUsIHRpbV9wdHIsIHRpbV9sZW5n
dGgpOworCWhpZl91cGRhdGVfaWVfYmVhY29uKHd2aWYsIHRpbV9wdHIsIHRpbV9sZW5ndGgpOwog
CWRldl9rZnJlZV9za2Ioc2tiKTsKIAogCXJldHVybiAwOwotLSAKMi4yNS4wCgo=
