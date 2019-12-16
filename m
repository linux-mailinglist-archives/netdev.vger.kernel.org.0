Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0DE4121130
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbfLPRJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:09:19 -0500
Received: from mail-eopbgr690078.outbound.protection.outlook.com ([40.107.69.78]:42057
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727728AbfLPRGt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:06:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fN/6dq9TwPWQxeueS8eTdaia6z89P7b5Ycqd7+KE/pFcV+DPATVJ8ohheoZY9X7ov8PL6TPeC2stT9aAZ66i8otDnoyrGf0VpW13uvIy9a6Qi64Cmd8JIm1C8JARibqoKqJ4uLXOfww+Izc2k6cRnHHy70jVMet2vZvT7cMJLlfj4/g+gZntPU86cmupQ+n5gdgxyAxsy7tDNpCIWy2bMBgxDQPKqHI80HAcr+1gGu7R+wtHB6uMHBuLyOlLP8Ce3fIPjkBpVII3yMgqMz8jFDMcjzkkT3eJz6wPYA+Sht8rxtEOdPqh00oJRY9GBhJzne/n4uXKjCr9Buvku4plwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sM61b92OPxGmjcWr1AxMMl0z1ItLjdelNcVFZWLu2fE=;
 b=fEkdBcbuS588TZGyw/IGI3wZ3oOO19g/LdNkUnD+BjYWeUQ1I3L49TizWZScG+BZ+mJ/m7tqorbSudmjjRZpx3SX83HXk0NflthFtfdLmN20z76FZJEnAPLTXEctzLd8N5N4u+nK04VbjVOSLJN1B7FjBrBO9PnnwIs+6+AoZfcnnCgfFK2fTyv+TpJkFrC2Lbpx+VUaYWkulrUzls3wQW9UFk5+2YjV1uhqRUE7oMn9mcpqgYiO8yJrj/cWGm6ES0GeQO9rkjfmJxriNXFn5qkp5RrMDB77PmHT+u+kxoU+i47rZtj8S6g84cL2FiBV+AexlACUJPn0K5+hO1xO+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sM61b92OPxGmjcWr1AxMMl0z1ItLjdelNcVFZWLu2fE=;
 b=QFR0TRKV3G8texZJ0kgl6LkA2dJ11XzdPUaxHHwWafS2Mu/ZY4PHtCjE19uBzpCFTOddXOrawwngD2Lsr17CAR6HXbA3G5JNwHn/l4hL0mISy7+YnrZgUG4sLuSVddP7PWJsySig9CeQ8VgwHu91M8hjB0vWk1sbZkvk+mNGMWU=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4142.namprd11.prod.outlook.com (20.179.149.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Mon, 16 Dec 2019 17:06:42 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:06:42 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 39/55] staging: wfx: simplify hif_set_uapsd_info() usage
Thread-Topic: [PATCH 39/55] staging: wfx: simplify hif_set_uapsd_info() usage
Thread-Index: AQHVtDLL7zAYEpOGhEKGtVfikRLAXw==
Date:   Mon, 16 Dec 2019 17:03:53 +0000
Message-ID: <20191216170302.29543-40-Jerome.Pouiller@silabs.com>
References: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8e30fee-336a-4eda-6909-08d7824a5292
x-ms-traffictypediagnostic: MN2PR11MB4142:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB414267C6C485638EA374CE5693510@MN2PR11MB4142.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:632;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(346002)(136003)(376002)(39850400004)(199004)(189003)(6512007)(71200400001)(91956017)(6486002)(8676002)(2906002)(54906003)(81166006)(81156014)(186003)(76116006)(478600001)(36756003)(85182001)(85202003)(6666004)(66556008)(66476007)(66446008)(64756008)(1076003)(66574012)(316002)(2616005)(4326008)(6506007)(26005)(8936002)(110136005)(5660300002)(107886003)(66946007)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4142;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lK0YuHgwDNFBZqZlPSkg3ZUW9Ey0T59A/03utE37stNASEysJqvNZPsGJGx+73WFnhNuRt+uL77hzsAFrGoCuHi0F5FV46/nk31k6SdeyuPdjMDeOOSHKT1iQz09bBO72IO3dqYR2r2QKhxCNH2Zn8Mk+Y5CJJOo+NLuVqdobeKBZl1SdFj36CJ69peT2chuvGXgB95o8zRUtJXrChmj3GJKJ0yJyYYbj2a5e9JqqlAYUoTH0OPL8XJxy53r0r1QnotQeD0mCbsdQGKfWtg84IFZQgfgiRhPWvt9XbmQpA2OA5LG6nrx3tfXwsManQ0ZzgRRilsNuurQJEWSKIdfwVYPiooJ/yE1GBWNy2wtOAzZaf3Qb1kmNQSkyFih1pAD016DMz2hIcqp3dkCj+F7FsqwOFl3sMfUkThPg45hI3ld67WE9bE4W0kW3Hq5akOc
Content-Type: text/plain; charset="utf-8"
Content-ID: <0CE0342D34D9A74F9CF1533D3BBA36B3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8e30fee-336a-4eda-6909-08d7824a5292
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:53.4817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h9UbzK5GZsGIMw3e+UfVjg8mpKCitlsbv/mwww6rQXvE7ma0RhSUvoFqDw/a98gk2LS2oz9CIhQ+D4w0Qd9uBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4142
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpJ
dCBpcyB1c2VsZXNzIHRvIGtlZXAgdWFwc2RfaW5mbyBpbiBzdHJ1Y3Qgd2Z4X3ZpZi4gVGhpcyBz
dHJ1Y3R1cmUgY2FuDQpiZSByZWJ1aWx0IGp1c3QgYmVmb3JlIHRvIGJlIHNlbnQuDQoNCkluIGFk
ZCwgdGhlIHN0cnVjdCBoaWZfbWliX3NldF91YXBzZF9pbmZvcm1hdGlvbiBjb21lcyBmcm9tIGhh
cmR3YXJlDQpBUEkuIEl0IGlzIG5vdCBpbnRlbmRlZCB0byBiZSBtYW5pcHVsYXRlZCBpbiB1cHBl
ciBsYXllcnMgb2YgdGhlIGRyaXZlci4NClNvLCB0aGlzIHBhdGNoIHJlbG9jYXRlcyB0aGUgaGFu
ZGxpbmcgb2YgdGhpcyBzdHJ1Y3QgdG8NCmhpZl9zZXRfdWFwc2RfaW5mbygpICh0aGUgbG93IGxl
dmVsIGZ1bmN0aW9uKS4NCg0KU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9t
ZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KLS0tDQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhf
bWliLmggfCAxNSArKysrKysrKystLS0NCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICAgICAg
ICB8IDQyICsrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQogZHJpdmVycy9zdGFnaW5n
L3dmeC93ZnguaCAgICAgICAgfCAgMSAtDQogMyBmaWxlcyBjaGFuZ2VkLCAxNCBpbnNlcnRpb25z
KCspLCA0NCBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX3R4X21pYi5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmgNCmluZGV4IDli
ZTc0ODgxYzU2Yy4uZDc3NzY1Zjc1ZjEwIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9oaWZfdHhfbWliLmgNCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oDQpA
QCAtMjM4LDEyICsyMzgsMjEgQEAgc3RhdGljIGlubGluZSBpbnQgaGlmX3VzZV9tdWx0aV90eF9j
b25mKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LA0KIAkJCSAgICAgJmFyZywgc2l6ZW9mKGFyZykpOw0K
IH0NCiANCi1zdGF0aWMgaW5saW5lIGludCBoaWZfc2V0X3VhcHNkX2luZm8oc3RydWN0IHdmeF92
aWYgKnd2aWYsDQotCQkJCSAgICAgc3RydWN0IGhpZl9taWJfc2V0X3VhcHNkX2luZm9ybWF0aW9u
ICphcmcpDQorc3RhdGljIGlubGluZSBpbnQgaGlmX3NldF91YXBzZF9pbmZvKHN0cnVjdCB3Znhf
dmlmICp3dmlmLCB1bnNpZ25lZCBsb25nIHZhbCkNCiB7DQorCXN0cnVjdCBoaWZfbWliX3NldF91
YXBzZF9pbmZvcm1hdGlvbiBhcmcgPSB7IH07DQorDQorCWlmICh2YWwgJiBCSVQoSUVFRTgwMjEx
X0FDX1ZPKSkNCisJCWFyZy50cmlnX3ZvaWNlID0gMTsNCisJaWYgKHZhbCAmIEJJVChJRUVFODAy
MTFfQUNfVkkpKQ0KKwkJYXJnLnRyaWdfdmlkZW8gPSAxOw0KKwlpZiAodmFsICYgQklUKElFRUU4
MDIxMV9BQ19CRSkpDQorCQlhcmcudHJpZ19iZSA9IDE7DQorCWlmICh2YWwgJiBCSVQoSUVFRTgw
MjExX0FDX0JLKSkNCisJCWFyZy50cmlnX2Jja2dybmQgPSAxOw0KIAlyZXR1cm4gaGlmX3dyaXRl
X21pYih3dmlmLT53ZGV2LCB3dmlmLT5pZCwNCiAJCQkgICAgIEhJRl9NSUJfSURfU0VUX1VBUFNE
X0lORk9STUFUSU9OLA0KLQkJCSAgICAgYXJnLCBzaXplb2YoKmFyZykpOw0KKwkJCSAgICAgJmFy
Zywgc2l6ZW9mKGFyZykpOw0KIH0NCiANCiBzdGF0aWMgaW5saW5lIGludCBoaWZfZXJwX3VzZV9w
cm90ZWN0aW9uKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBib29sIGVuYWJsZSkNCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYw0K
aW5kZXggZTU5NTYwZjQ5OWVhLi45ZWNhMzVkOTFhZDMgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3N0YS5jDQorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jDQpAQCAtMTEy
LDQ0ICsxMTIsNiBAQCB2b2lkIHdmeF9jcW1fYnNzbG9zc19zbShzdHJ1Y3Qgd2Z4X3ZpZiAqd3Zp
ZiwgaW50IGluaXQsIGludCBnb29kLCBpbnQgYmFkKQ0KIAltdXRleF91bmxvY2soJnd2aWYtPmJz
c19sb3NzX2xvY2spOw0KIH0NCiANCi1zdGF0aWMgaW50IHdmeF9zZXRfdWFwc2RfcGFyYW0oc3Ry
dWN0IHdmeF92aWYgKnd2aWYsDQotCQkJICAgY29uc3Qgc3RydWN0IHdmeF9lZGNhX3BhcmFtcyAq
YXJnKQ0KLXsNCi0JLyogSGVyZSdzIHRoZSBtYXBwaW5nIEFDIFtxdWV1ZSwgYml0XQ0KLQkgKiAg
Vk8gWzAsM10sIFZJIFsxLCAyXSwgQkUgWzIsIDFdLCBCSyBbMywgMF0NCi0JICovDQotDQotCWlm
IChhcmctPnVhcHNkX21hc2sgJiBCSVQoSUVFRTgwMjExX0FDX1ZPKSkNCi0JCXd2aWYtPnVhcHNk
X2luZm8udHJpZ192b2ljZSA9IDE7DQotCWVsc2UNCi0JCXd2aWYtPnVhcHNkX2luZm8udHJpZ192
b2ljZSA9IDA7DQotDQotCWlmIChhcmctPnVhcHNkX21hc2sgJiBCSVQoSUVFRTgwMjExX0FDX1ZJ
KSkNCi0JCXd2aWYtPnVhcHNkX2luZm8udHJpZ192aWRlbyA9IDE7DQotCWVsc2UNCi0JCXd2aWYt
PnVhcHNkX2luZm8udHJpZ192aWRlbyA9IDA7DQotDQotCWlmIChhcmctPnVhcHNkX21hc2sgJiBC
SVQoSUVFRTgwMjExX0FDX0JFKSkNCi0JCXd2aWYtPnVhcHNkX2luZm8udHJpZ19iZSA9IDE7DQot
CWVsc2UNCi0JCXd2aWYtPnVhcHNkX2luZm8udHJpZ19iZSA9IDA7DQotDQotCWlmIChhcmctPnVh
cHNkX21hc2sgJiBCSVQoSUVFRTgwMjExX0FDX0JLKSkNCi0JCXd2aWYtPnVhcHNkX2luZm8udHJp
Z19iY2tncm5kID0gMTsNCi0JZWxzZQ0KLQkJd3ZpZi0+dWFwc2RfaW5mby50cmlnX2Jja2dybmQg
PSAwOw0KLQ0KLQkvKiBDdXJyZW50bHkgcHNldWRvIFUtQVBTRCBvcGVyYXRpb24gaXMgbm90IHN1
cHBvcnRlZCwgc28gc2V0dGluZw0KLQkgKiBNaW5BdXRvVHJpZ2dlckludGVydmFsLCBNYXhBdXRv
VHJpZ2dlckludGVydmFsIGFuZA0KLQkgKiBBdXRvVHJpZ2dlclN0ZXAgdG8gMA0KLQkgKi8NCi0J
d3ZpZi0+dWFwc2RfaW5mby5taW5fYXV0b190cmlnZ2VyX2ludGVydmFsID0gMDsNCi0Jd3ZpZi0+
dWFwc2RfaW5mby5tYXhfYXV0b190cmlnZ2VyX2ludGVydmFsID0gMDsNCi0Jd3ZpZi0+dWFwc2Rf
aW5mby5hdXRvX3RyaWdnZXJfc3RlcCA9IDA7DQotDQotCXJldHVybiBoaWZfc2V0X3VhcHNkX2lu
Zm8od3ZpZiwgJnd2aWYtPnVhcHNkX2luZm8pOw0KLX0NCi0NCiBpbnQgd2Z4X2Z3ZF9wcm9iZV9y
ZXEoc3RydWN0IHdmeF92aWYgKnd2aWYsIGJvb2wgZW5hYmxlKQ0KIHsNCiAJd3ZpZi0+ZndkX3By
b2JlX3JlcSA9IGVuYWJsZTsNCkBAIC0zODIsNyArMzQ0LDcgQEAgaW50IHdmeF9jb25mX3R4KHN0
cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLA0KIAloaWZf
c2V0X2VkY2FfcXVldWVfcGFyYW1zKHd2aWYsIGVkY2EpOw0KIA0KIAlpZiAod3ZpZi0+dmlmLT50
eXBlID09IE5MODAyMTFfSUZUWVBFX1NUQVRJT04pIHsNCi0JCXdmeF9zZXRfdWFwc2RfcGFyYW0o
d3ZpZiwgJnd2aWYtPmVkY2EpOw0KKwkJaGlmX3NldF91YXBzZF9pbmZvKHd2aWYsIHd2aWYtPmVk
Y2EudWFwc2RfbWFzayk7DQogCQlpZiAod3ZpZi0+c2V0YnNzcGFyYW1zX2RvbmUgJiYgd3ZpZi0+
c3RhdGUgPT0gV0ZYX1NUQVRFX1NUQSkNCiAJCQl3ZnhfdXBkYXRlX3BtKHd2aWYpOw0KIAl9DQpA
QCAtMTU1Miw3ICsxNTE0LDcgQEAgaW50IHdmeF9hZGRfaW50ZXJmYWNlKHN0cnVjdCBpZWVlODAy
MTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmKQ0KIAkJaGlmX3NldF9lZGNhX3F1
ZXVlX3BhcmFtcyh3dmlmLCAmd3ZpZi0+ZWRjYS5wYXJhbXNbaV0pOw0KIAl9DQogCXd2aWYtPmVk
Y2EudWFwc2RfbWFzayA9IDA7DQotCXdmeF9zZXRfdWFwc2RfcGFyYW0od3ZpZiwgJnd2aWYtPmVk
Y2EpOw0KKwloaWZfc2V0X3VhcHNkX2luZm8od3ZpZiwgd3ZpZi0+ZWRjYS51YXBzZF9tYXNrKTsN
CiANCiAJd2Z4X3R4X3BvbGljeV9pbml0KHd2aWYpOw0KIAl3dmlmID0gTlVMTDsNCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93Zngu
aA0KaW5kZXggYzgyZDI5NzY0ZDY2Li5mZjI5MTYzNDM2YjYgMTAwNjQ0DQotLS0gYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3dmeC5oDQorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oDQpAQCAt
MTE0LDcgKzExNCw2IEBAIHN0cnVjdCB3ZnhfdmlmIHsNCiAJYm9vbAkJCXNldGJzc3BhcmFtc19k
b25lOw0KIAlzdHJ1Y3Qgd2Z4X2h0X2luZm8JaHRfaW5mbzsNCiAJc3RydWN0IHdmeF9lZGNhX3Bh
cmFtcwllZGNhOw0KLQlzdHJ1Y3QgaGlmX21pYl9zZXRfdWFwc2RfaW5mb3JtYXRpb24gdWFwc2Rf
aW5mbzsNCiAJc3RydWN0IGhpZl9yZXFfc2V0X2Jzc19wYXJhbXMgYnNzX3BhcmFtczsNCiAJc3Ry
dWN0IHdvcmtfc3RydWN0CWJzc19wYXJhbXNfd29yazsNCiAJc3RydWN0IHdvcmtfc3RydWN0CXNl
dF9jdHNfd29yazsNCi0tIA0KMi4yMC4xDQo=
