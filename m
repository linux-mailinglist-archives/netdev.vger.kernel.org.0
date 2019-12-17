Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D94521231E2
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbfLQQSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:18:20 -0500
Received: from mail-bn8nam11on2041.outbound.protection.outlook.com ([40.107.236.41]:6164
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729005AbfLQQPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:15:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZzV1dLT/F1eftNJPtdY7VhvRxFpQoJhaNU4AByz3vQ60ohgJ30nM1xf5JYgXsqLIQYzHdIyU+IU0tNxNnYGpiRDbt4lwKm26Fm2zYTN07fGljZUTffW9hvVuAWOhkqLBhd1inO/EKyC9qYlnb7P/ahbWohe9EUY36e675XB3EEm6rlTH7f0d7yiShpSaIZFVX9ypRTVSLHvxnG78kygpalfau6ZpeTdqbgJGY0F7LM17wkC/sT2QHSzpT42euuVgINmJi6i/0MxOizEbvKsA9O98c8kn93NSWxtgV2eVzCjF24r9+aPrbfYihQcYxdsFDJ1EN4V9R8nnAnJkqQ9fgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbUIsP1n4dfYyvrZwB6Ai7//eAfTyJx2yF6/EgTbM1M=;
 b=aaMkLCRrdlCTHV7k9ObRxSp9JylWjIcmKfuAilgE2j1laY01CQUHHeteqEuEe9bLFj7kV/0uhWDhvBqIlGDsJtjavC1TLjnFxE6a5349xzhLpU1AjuGgvTYb1JzRIIY0gWfkEmSQdit54BAAILEqqzu3lQuc8dhhLHn3NoW65kT1tYB0d2WCwTP/pnYhWCHiwWvLjZvCh+ftdtKH8+B8qsKtLhScIfNu51U3lEl/qhHPBu0LrYdWlvtb+Bx6JeJ76PRx5Iuf5R6w2u2d8FGG5TC4QlA6AyKlr8T4/qkXSJjDxH5BcdVBNg79bPKkOrV1EkuzA4DHfJ82Pwh+USHWwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbUIsP1n4dfYyvrZwB6Ai7//eAfTyJx2yF6/EgTbM1M=;
 b=mffPEm99GFEshKnW3lR/so8ERPD2XnEOz3hjHjNM4mPzOFI42VW74Fk8zkFvc3tERBXnoQhLkqob6Bz0hrEoxdG6WTNiOrELa9h1f0BBIo9hPcZgfp6jnbTmVxJaTzopkejoUjPkiO7pmZAQIONS5bE88lRs1lbtqLIp7EM1ARw=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4208.namprd11.prod.outlook.com (52.135.36.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Tue, 17 Dec 2019 16:15:44 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:15:44 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 39/55] staging: wfx: simplify hif_set_uapsd_info() usage
Thread-Topic: [PATCH v2 39/55] staging: wfx: simplify hif_set_uapsd_info()
 usage
Thread-Index: AQHVtPUutvY+bqzUVUGYHrCZRp8FwA==
Date:   Tue, 17 Dec 2019 16:15:21 +0000
Message-ID: <20191217161318.31402-40-Jerome.Pouiller@silabs.com>
References: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0174.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.24.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c9b3e30-aaa8-41b1-4627-08d7830c50e9
x-ms-traffictypediagnostic: MN2PR11MB4208:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB420894D170CC7F66C6DF922D93500@MN2PR11MB4208.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:632;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(366004)(136003)(376002)(346002)(199004)(189003)(5660300002)(316002)(6506007)(85182001)(478600001)(71200400001)(2906002)(36756003)(186003)(26005)(81166006)(54906003)(1076003)(110136005)(66574012)(4326008)(8676002)(86362001)(6486002)(6666004)(52116002)(6512007)(64756008)(85202003)(66946007)(66476007)(66446008)(66556008)(8936002)(107886003)(2616005)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4208;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PImR3VkIR02XhwzJJEHwUsndUlzeIV3Ant0xrCmIt4etF6R2qg1uVhHCgHXUgXByGd5nH/RBcwVjCClFFSm+pTFJe+WvMQPU/ecPaf+E0PWvVB0d18tufYvz8A/2CQO+vubGwU8J77Vs45YTUge+GNUbNMygGqWsydLQd9oc/UIwRO98NQvK4EaAPPq8I/vWAQW3mEu/Z+L2TLD7kVz67lx10I5lWamj6njGZtSl4UjAFaPq9qA2Gc+P9maceLSvryIERY/HtX9pWEYCSwEr/z5mjTjs9i1pTSG2I8ZuMVxTPigrCiTu+kKCIdkjElITFtRRIvY/4iER2Y1FKYUv9kfVjsEW7D2eud43GL0+DN0tbJ3XJfq+VVCIY9lE7wj0GWyYYkOw6s5m1R/Z+xjHSrhz6t3dWr/h6InpGg3TCkSjEzg0BqrerDqbQh0+hv0C
Content-Type: text/plain; charset="utf-8"
Content-ID: <A472F4FCA7B0694A8570F7AF64514EC3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c9b3e30-aaa8-41b1-4627-08d7830c50e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:21.8554
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ebV6/DXg1VZSNx70BbbAsStO2NfsDnMiZWWAt5tr8v4UQ2y/2/b/DiR40T8EKIeRV86PI/xrtVgoIVb9rXqBHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4208
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSXQg
aXMgdXNlbGVzcyB0byBrZWVwIHVhcHNkX2luZm8gaW4gc3RydWN0IHdmeF92aWYuIFRoaXMgc3Ry
dWN0dXJlIGNhbgpiZSByZWJ1aWx0IGp1c3QgYmVmb3JlIHRvIGJlIHNlbnQuCgpJbiBhZGQsIHRo
ZSBzdHJ1Y3QgaGlmX21pYl9zZXRfdWFwc2RfaW5mb3JtYXRpb24gY29tZXMgZnJvbSBoYXJkd2Fy
ZQpBUEkuIEl0IGlzIG5vdCBpbnRlbmRlZCB0byBiZSBtYW5pcHVsYXRlZCBpbiB1cHBlciBsYXll
cnMgb2YgdGhlIGRyaXZlci4KU28sIHRoaXMgcGF0Y2ggcmVsb2NhdGVzIHRoZSBoYW5kbGluZyBv
ZiB0aGlzIHN0cnVjdCB0bwpoaWZfc2V0X3VhcHNkX2luZm8oKSAodGhlIGxvdyBsZXZlbCBmdW5j
dGlvbikuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVy
QHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmggfCAxNSAr
KysrKysrKystLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgICAgICAgIHwgNDIgKystLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmggICAg
ICAgIHwgIDEgLQogMyBmaWxlcyBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCA0NCBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaCBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oCmluZGV4IDliZTc0ODgxYzU2Yy4uZDc3NzY1
Zjc1ZjEwIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaAorKysg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaApAQCAtMjM4LDEyICsyMzgsMjEgQEAg
c3RhdGljIGlubGluZSBpbnQgaGlmX3VzZV9tdWx0aV90eF9jb25mKHN0cnVjdCB3ZnhfZGV2ICp3
ZGV2LAogCQkJICAgICAmYXJnLCBzaXplb2YoYXJnKSk7CiB9CiAKLXN0YXRpYyBpbmxpbmUgaW50
IGhpZl9zZXRfdWFwc2RfaW5mbyhzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKLQkJCQkgICAgIHN0cnVj
dCBoaWZfbWliX3NldF91YXBzZF9pbmZvcm1hdGlvbiAqYXJnKQorc3RhdGljIGlubGluZSBpbnQg
aGlmX3NldF91YXBzZF9pbmZvKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCB1bnNpZ25lZCBsb25nIHZh
bCkKIHsKKwlzdHJ1Y3QgaGlmX21pYl9zZXRfdWFwc2RfaW5mb3JtYXRpb24gYXJnID0geyB9Owor
CisJaWYgKHZhbCAmIEJJVChJRUVFODAyMTFfQUNfVk8pKQorCQlhcmcudHJpZ192b2ljZSA9IDE7
CisJaWYgKHZhbCAmIEJJVChJRUVFODAyMTFfQUNfVkkpKQorCQlhcmcudHJpZ192aWRlbyA9IDE7
CisJaWYgKHZhbCAmIEJJVChJRUVFODAyMTFfQUNfQkUpKQorCQlhcmcudHJpZ19iZSA9IDE7CisJ
aWYgKHZhbCAmIEJJVChJRUVFODAyMTFfQUNfQkspKQorCQlhcmcudHJpZ19iY2tncm5kID0gMTsK
IAlyZXR1cm4gaGlmX3dyaXRlX21pYih3dmlmLT53ZGV2LCB3dmlmLT5pZCwKIAkJCSAgICAgSElG
X01JQl9JRF9TRVRfVUFQU0RfSU5GT1JNQVRJT04sCi0JCQkgICAgIGFyZywgc2l6ZW9mKCphcmcp
KTsKKwkJCSAgICAgJmFyZywgc2l6ZW9mKGFyZykpOwogfQogCiBzdGF0aWMgaW5saW5lIGludCBo
aWZfZXJwX3VzZV9wcm90ZWN0aW9uKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBib29sIGVuYWJsZSkK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jCmluZGV4IGU1OTU2MGY0OTllYS4uOWVjYTM1ZDkxYWQzIDEwMDY0NAotLS0gYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMK
QEAgLTExMiw0NCArMTEyLDYgQEAgdm9pZCB3ZnhfY3FtX2Jzc2xvc3Nfc20oc3RydWN0IHdmeF92
aWYgKnd2aWYsIGludCBpbml0LCBpbnQgZ29vZCwgaW50IGJhZCkKIAltdXRleF91bmxvY2soJnd2
aWYtPmJzc19sb3NzX2xvY2spOwogfQogCi1zdGF0aWMgaW50IHdmeF9zZXRfdWFwc2RfcGFyYW0o
c3RydWN0IHdmeF92aWYgKnd2aWYsCi0JCQkgICBjb25zdCBzdHJ1Y3Qgd2Z4X2VkY2FfcGFyYW1z
ICphcmcpCi17Ci0JLyogSGVyZSdzIHRoZSBtYXBwaW5nIEFDIFtxdWV1ZSwgYml0XQotCSAqICBW
TyBbMCwzXSwgVkkgWzEsIDJdLCBCRSBbMiwgMV0sIEJLIFszLCAwXQotCSAqLwotCi0JaWYgKGFy
Zy0+dWFwc2RfbWFzayAmIEJJVChJRUVFODAyMTFfQUNfVk8pKQotCQl3dmlmLT51YXBzZF9pbmZv
LnRyaWdfdm9pY2UgPSAxOwotCWVsc2UKLQkJd3ZpZi0+dWFwc2RfaW5mby50cmlnX3ZvaWNlID0g
MDsKLQotCWlmIChhcmctPnVhcHNkX21hc2sgJiBCSVQoSUVFRTgwMjExX0FDX1ZJKSkKLQkJd3Zp
Zi0+dWFwc2RfaW5mby50cmlnX3ZpZGVvID0gMTsKLQllbHNlCi0JCXd2aWYtPnVhcHNkX2luZm8u
dHJpZ192aWRlbyA9IDA7Ci0KLQlpZiAoYXJnLT51YXBzZF9tYXNrICYgQklUKElFRUU4MDIxMV9B
Q19CRSkpCi0JCXd2aWYtPnVhcHNkX2luZm8udHJpZ19iZSA9IDE7Ci0JZWxzZQotCQl3dmlmLT51
YXBzZF9pbmZvLnRyaWdfYmUgPSAwOwotCi0JaWYgKGFyZy0+dWFwc2RfbWFzayAmIEJJVChJRUVF
ODAyMTFfQUNfQkspKQotCQl3dmlmLT51YXBzZF9pbmZvLnRyaWdfYmNrZ3JuZCA9IDE7Ci0JZWxz
ZQotCQl3dmlmLT51YXBzZF9pbmZvLnRyaWdfYmNrZ3JuZCA9IDA7Ci0KLQkvKiBDdXJyZW50bHkg
cHNldWRvIFUtQVBTRCBvcGVyYXRpb24gaXMgbm90IHN1cHBvcnRlZCwgc28gc2V0dGluZwotCSAq
IE1pbkF1dG9UcmlnZ2VySW50ZXJ2YWwsIE1heEF1dG9UcmlnZ2VySW50ZXJ2YWwgYW5kCi0JICog
QXV0b1RyaWdnZXJTdGVwIHRvIDAKLQkgKi8KLQl3dmlmLT51YXBzZF9pbmZvLm1pbl9hdXRvX3Ry
aWdnZXJfaW50ZXJ2YWwgPSAwOwotCXd2aWYtPnVhcHNkX2luZm8ubWF4X2F1dG9fdHJpZ2dlcl9p
bnRlcnZhbCA9IDA7Ci0Jd3ZpZi0+dWFwc2RfaW5mby5hdXRvX3RyaWdnZXJfc3RlcCA9IDA7Ci0K
LQlyZXR1cm4gaGlmX3NldF91YXBzZF9pbmZvKHd2aWYsICZ3dmlmLT51YXBzZF9pbmZvKTsKLX0K
LQogaW50IHdmeF9md2RfcHJvYmVfcmVxKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBib29sIGVuYWJs
ZSkKIHsKIAl3dmlmLT5md2RfcHJvYmVfcmVxID0gZW5hYmxlOwpAQCAtMzgyLDcgKzM0NCw3IEBA
IGludCB3ZnhfY29uZl90eChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIx
MV92aWYgKnZpZiwKIAloaWZfc2V0X2VkY2FfcXVldWVfcGFyYW1zKHd2aWYsIGVkY2EpOwogCiAJ
aWYgKHd2aWYtPnZpZi0+dHlwZSA9PSBOTDgwMjExX0lGVFlQRV9TVEFUSU9OKSB7Ci0JCXdmeF9z
ZXRfdWFwc2RfcGFyYW0od3ZpZiwgJnd2aWYtPmVkY2EpOworCQloaWZfc2V0X3VhcHNkX2luZm8o
d3ZpZiwgd3ZpZi0+ZWRjYS51YXBzZF9tYXNrKTsKIAkJaWYgKHd2aWYtPnNldGJzc3BhcmFtc19k
b25lICYmIHd2aWYtPnN0YXRlID09IFdGWF9TVEFURV9TVEEpCiAJCQl3ZnhfdXBkYXRlX3BtKHd2
aWYpOwogCX0KQEAgLTE1NTIsNyArMTUxNCw3IEBAIGludCB3ZnhfYWRkX2ludGVyZmFjZShzdHJ1
Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZikKIAkJaGlmX3Nl
dF9lZGNhX3F1ZXVlX3BhcmFtcyh3dmlmLCAmd3ZpZi0+ZWRjYS5wYXJhbXNbaV0pOwogCX0KIAl3
dmlmLT5lZGNhLnVhcHNkX21hc2sgPSAwOwotCXdmeF9zZXRfdWFwc2RfcGFyYW0od3ZpZiwgJnd2
aWYtPmVkY2EpOworCWhpZl9zZXRfdWFwc2RfaW5mbyh3dmlmLCB3dmlmLT5lZGNhLnVhcHNkX21h
c2spOwogCiAJd2Z4X3R4X3BvbGljeV9pbml0KHd2aWYpOwogCXd2aWYgPSBOVUxMOwpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaCBiL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4
LmgKaW5kZXggYzgyZDI5NzY0ZDY2Li5mZjI5MTYzNDM2YjYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
c3RhZ2luZy93Zngvd2Z4LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaApAQCAtMTE0
LDcgKzExNCw2IEBAIHN0cnVjdCB3ZnhfdmlmIHsKIAlib29sCQkJc2V0YnNzcGFyYW1zX2RvbmU7
CiAJc3RydWN0IHdmeF9odF9pbmZvCWh0X2luZm87CiAJc3RydWN0IHdmeF9lZGNhX3BhcmFtcwll
ZGNhOwotCXN0cnVjdCBoaWZfbWliX3NldF91YXBzZF9pbmZvcm1hdGlvbiB1YXBzZF9pbmZvOwog
CXN0cnVjdCBoaWZfcmVxX3NldF9ic3NfcGFyYW1zIGJzc19wYXJhbXM7CiAJc3RydWN0IHdvcmtf
c3RydWN0CWJzc19wYXJhbXNfd29yazsKIAlzdHJ1Y3Qgd29ya19zdHJ1Y3QJc2V0X2N0c193b3Jr
OwotLSAKMi4yNC4wCgo=
