Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78D4413C408
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbgAONzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:55:46 -0500
Received: from mail-dm6nam11on2065.outbound.protection.outlook.com ([40.107.223.65]:2785
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730129AbgAONzo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:55:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QKePuv7e+/aOzu2qWOWzsP3E9K0AQhAia48Gvr2c0DUxejYp91O7rPA5u9OttGh3SQY2tz8dt2qqecuTXN0zuVV3PDYpkqTK5n8whphLdXP/hNKA/cw1a2aRLP+uV0i6rIgWmt4BHaO7LaO0M25TuwjpxEjg2e2cfW53RvkD2v1ywmrALXgWdiYl5IE02RqFJ/nsV1uadYKYHziB+aGvi/OY/HSnBSYPZA+TxzJMXbVGPjiMWW6J8wmbqHwF7XIeIvqNfYzwGpe4LErDVqnY6K04mEhgPMnoet7SnCEqPYFhv1RSysgMh/uAUzBbV5TY3wA3yqOlq4iuieRXUw3zWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5K9w45B1VHrUT1UfLVIXweCnZYK/uhq6jS7oIVIkSQ=;
 b=ZEDNVDWaxRUlros8cwa3qP3PybQESL4trEinHkqld7Qb9/U4rtt91iNUDmWhT3M0AVht+rvglZopzVZQCkXbp40tX6MjwBfTqvYZfTjJZZAt9WMo73+fahY9a/CyLl72KUpVjf460o/qJGyCnlJNq9vjRlBPKnkPwlD/X8dhAwct92PD+7zX9Qqk7ycDTUUU2+DGzk3j55f326puNzva4Xn/65G/z2yPhvZEaJfG6YTyRNQBXhJnvZiZZFqpf11htbDO6UNzIoUeVe1pSPOhfIrlGoxMHRMb4bxLzMV1soh4R8IzzV80GO5Hg9VWcrUd5a7w5cIt3EcLK44YTFXaGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5K9w45B1VHrUT1UfLVIXweCnZYK/uhq6jS7oIVIkSQ=;
 b=FoJF+AgnxoW+CrhH3ndV6BXW4zK6bArAYo/husVFYaSjfJ9xI1R6jvh00daNs/AZ/z0YRfNm+Sb9PiTEVqHf9KU1/RxVG3+eKJByq1VYYv7Q1i6fQFPwp6VUsCB7Vrt7G/oNychvl8L52j6EYK97aMo2bePSknPIwRAU+2sYXos=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4094.namprd11.prod.outlook.com (10.255.180.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 13:55:29 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:55:29 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:55:18 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 53/65] staging: wfx: pspoll_mask make no sense
Thread-Topic: [PATCH v2 53/65] staging: wfx: pspoll_mask make no sense
Thread-Index: AQHVy6tsLRV1oAKf9EqATnkab+b5Ow==
Date:   Wed, 15 Jan 2020 13:55:19 +0000
Message-ID: <20200115135338.14374-54-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 311eed33-88eb-498a-60e0-08d799c28edb
x-ms-traffictypediagnostic: MN2PR11MB4094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB40941F169F4A502AA01F4CB093370@MN2PR11MB4094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:283;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(396003)(346002)(136003)(376002)(189003)(199004)(316002)(110136005)(54906003)(85202003)(81156014)(5660300002)(8676002)(71200400001)(8936002)(81166006)(186003)(6506007)(86362001)(66946007)(66446008)(66476007)(66556008)(2906002)(64756008)(478600001)(6512007)(52116002)(66574012)(6486002)(1076003)(16526019)(4326008)(85182001)(107886003)(36756003)(8886007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4094;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BuJh4nrD4mumfH54OAqNLPKs9W4MC9llg7gCWZ70qXlF+OYd3bnfuTKa3RsDbV7EJ9pWfm0DJ1Kqp07YRnN4Vity7GQcAt3YFYWXmXYgfBJZYiWth0elyokgPiBe3CJHhFBjBhZnNvrDazgIfHMW8TzwdbvVcQ5DJu87QgxwaOcgDDUp74MY4H5dV4LNFFaZWZCbfkkQFNP/bgfJ7a8ibaZQHmv0Lg01L1ChUvccKljlvJFFc4N/VcG5G2h1qq3C9OobCvckqUOQwE/FPccnH5/LCg6ddMbbWN+fRwK8qxau/f88HOGRPSVdb3RkvlizVpMeT0w/yzdn+mw+9hS1UsAQ8xgg9CofYH3wCPvE72+FcYrMHyUJ58eUHanajU89A9JSezHoXYlgnW7n1IPR9gqtyIpUXLg+vhTl5EXv2q7skHKmq1LtivXSu+zKbDvJ
Content-Type: text/plain; charset="utf-8"
Content-ID: <C59386EABB085642B73A1137DFC4C13C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 311eed33-88eb-498a-60e0-08d799c28edb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:55:19.7490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hYsGyMTql1R6LUskabFuu1ValU0tAeQpN3Tl2uP5jTVjzCPDhaFSVm/vLwyjmwDH60ru0N1+K4VPHQvPuaE81w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKcHNw
b2xsX21hc2sgaXMgaGVyZSB0byBzZW5kIGRhdGEgYnVmZmVyZWQgaW4gZHJpdmVyLiBCdXQgc2lu
Y2Ugc3RhdGlvbgppcyBtYXJrZWQgYnVmZmVyZWQsIFRJTSBmb3IgdGhpcyBzdGF0aW9uIGlzIDEg
YW5kIG1hYzgwMjExIHdpbGwgY2FsbApzdGFfbm90aWZ5IHdoZW4gYSBwcy1wb2xsIGlzIHJlY2Vp
dmVkLiBTbyBwc3BvbGxfbWFzayBpcyB1c2VsZXNzIGFuZApzdGFfYWxzZWVwX21hc2sgaXMgc3Vm
ZmljaWVudC4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxs
ZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfcnguYyB8IDM5IC0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2Rh
dGFfdHguYyB8ICA0ICstLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYyAgIHwgIDggKyst
LS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyAgICAgfCAgMiAtLQogZHJpdmVycy9zdGFn
aW5nL3dmeC93ZnguaCAgICAgfCAgMSAtCiA1IGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygr
KSwgNTEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRh
X3J4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfcnguYwppbmRleCA2OTllMmQ2MGZhODku
LjVkMTk4NDU3YzZjZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3J4LmMK
KysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3J4LmMKQEAgLTEzLDQxICsxMyw2IEBACiAj
aW5jbHVkZSAiYmguaCIKICNpbmNsdWRlICJzdGEuaCIKIAotc3RhdGljIGludCB3ZnhfaGFuZGxl
X3BzcG9sbChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0IHNrX2J1ZmYgKnNrYikKLXsKLQlz
dHJ1Y3QgaWVlZTgwMjExX3N0YSAqc3RhOwotCXN0cnVjdCBpZWVlODAyMTFfcHNwb2xsICpwc3Bv
bGwgPSAoc3RydWN0IGllZWU4MDIxMV9wc3BvbGwgKilza2ItPmRhdGE7Ci0JaW50IGxpbmtfaWQg
PSAwOwotCXUzMiBwc3BvbGxfbWFzayA9IDA7Ci0JaW50IGk7Ci0KLQlpZiAod3ZpZi0+c3RhdGUg
IT0gV0ZYX1NUQVRFX0FQKQotCQlyZXR1cm4gMTsKLQlpZiAoIWV0aGVyX2FkZHJfZXF1YWwod3Zp
Zi0+dmlmLT5hZGRyLCBwc3BvbGwtPmJzc2lkKSkKLQkJcmV0dXJuIDE7Ci0KLQlyY3VfcmVhZF9s
b2NrKCk7Ci0Jc3RhID0gaWVlZTgwMjExX2ZpbmRfc3RhKHd2aWYtPnZpZiwgcHNwb2xsLT50YSk7
Ci0JaWYgKHN0YSkKLQkJbGlua19pZCA9ICgoc3RydWN0IHdmeF9zdGFfcHJpdiAqKSZzdGEtPmRy
dl9wcml2KS0+bGlua19pZDsKLQlyY3VfcmVhZF91bmxvY2soKTsKLQlpZiAobGlua19pZCkKLQkJ
cHNwb2xsX21hc2sgPSBCSVQobGlua19pZCk7Ci0JZWxzZQotCQlyZXR1cm4gMTsKLQotCXd2aWYt
PnBzcG9sbF9tYXNrIHw9IHBzcG9sbF9tYXNrOwotCS8qIERvIG5vdCByZXBvcnQgcHNwb2xzIGlm
IGRhdGEgZm9yIGdpdmVuIGxpbmsgaWQgaXMgcXVldWVkIGFscmVhZHkuICovCi0JZm9yIChpID0g
MDsgaSA8IElFRUU4MDIxMV9OVU1fQUNTOyArK2kpIHsKLQkJaWYgKHdmeF90eF9xdWV1ZV9nZXRf
bnVtX3F1ZXVlZCgmd3ZpZi0+d2Rldi0+dHhfcXVldWVbaV0sCi0JCQkJCQlwc3BvbGxfbWFzaykp
IHsKLQkJCXdmeF9iaF9yZXF1ZXN0X3R4KHd2aWYtPndkZXYpOwotCQkJcmV0dXJuIDE7Ci0JCX0K
LQl9Ci0JcmV0dXJuIDA7Ci19Ci0KIHN0YXRpYyBpbnQgd2Z4X2Ryb3BfZW5jcnlwdF9kYXRhKHN0
cnVjdCB3ZnhfZGV2ICp3ZGV2LAogCQkJCSBjb25zdCBzdHJ1Y3QgaGlmX2luZF9yeCAqYXJnLAog
CQkJCSBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQpAQCAtMTI1LDEwICs5MCw2IEBAIHZvaWQgd2Z4X3J4
X2NiKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCQlnb3RvIGRyb3A7CiAJfQogCi0JaWYgKGllZWU4
MDIxMV9pc19wc3BvbGwoZnJhbWUtPmZyYW1lX2NvbnRyb2wpKQotCQlpZiAod2Z4X2hhbmRsZV9w
c3BvbGwod3ZpZiwgc2tiKSkKLQkJCWdvdG8gZHJvcDsKLQogCWhkci0+YmFuZCA9IE5MODAyMTFf
QkFORF8yR0haOwogCWhkci0+ZnJlcSA9IGllZWU4MDIxMV9jaGFubmVsX3RvX2ZyZXF1ZW5jeShh
cmctPmNoYW5uZWxfbnVtYmVyLAogCQkJCQkJICAgaGRyLT5iYW5kKTsKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4
LmMKaW5kZXggN2RhMWFmZDZlOWI1Li43OTE0YzA2NTc4YWEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
c3RhZ2luZy93ZngvZGF0YV90eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5j
CkBAIC0yODYsMTAgKzI4Niw4IEBAIHN0YXRpYyB2b2lkIHdmeF90eF9tYW5hZ2VfcG0oc3RydWN0
IHdmeF92aWYgKnd2aWYsIHN0cnVjdCBpZWVlODAyMTFfaGRyICpoZHIsCiAJaW50IHRpZCA9IGll
ZWU4MDIxMV9nZXRfdGlkKGhkcik7CiAKIAlzcGluX2xvY2tfYmgoJnd2aWYtPnBzX3N0YXRlX2xv
Y2spOwotCWlmIChpZWVlODAyMTFfaXNfYXV0aChoZHItPmZyYW1lX2NvbnRyb2wpKSB7CisJaWYg
KGllZWU4MDIxMV9pc19hdXRoKGhkci0+ZnJhbWVfY29udHJvbCkpCiAJCXd2aWYtPnN0YV9hc2xl
ZXBfbWFzayAmPSBtYXNrOwotCQl3dmlmLT5wc3BvbGxfbWFzayAmPSBtYXNrOwotCX0KIAogCWlm
ICh0eF9wcml2LT5saW5rX2lkID09IFdGWF9MSU5LX0lEX0FGVEVSX0RUSU0gJiYKIAkgICAgIXd2
aWYtPm1jYXN0X2J1ZmZlcmVkKSB7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1
ZXVlLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMKaW5kZXggM2Q0MDM4ODczOWUzLi40
MmQ2NDUzNGM5MmMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYworKysg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMKQEAgLTQ5MywxMiArNDkzLDEwIEBAIHN0YXRp
YyBpbnQgd2Z4X3R4X3F1ZXVlX21hc2tfZ2V0KHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCS8qIFNl
YXJjaCBmb3IgdW5pY2FzdCB0cmFmZmljICovCiAJdHhfYWxsb3dlZF9tYXNrID0gfnd2aWYtPnN0
YV9hc2xlZXBfbWFzazsKIAl0eF9hbGxvd2VkX21hc2sgfD0gQklUKFdGWF9MSU5LX0lEX1VBUFNE
KTsKLQlpZiAod3ZpZi0+c3RhX2FzbGVlcF9tYXNrKSB7Ci0JCXR4X2FsbG93ZWRfbWFzayB8PSB3
dmlmLT5wc3BvbGxfbWFzazsKKwlpZiAod3ZpZi0+c3RhX2FzbGVlcF9tYXNrKQogCQl0eF9hbGxv
d2VkX21hc2sgJj0gfkJJVChXRlhfTElOS19JRF9BRlRFUl9EVElNKTsKLQl9IGVsc2UgeworCWVs
c2UKIAkJdHhfYWxsb3dlZF9tYXNrIHw9IEJJVChXRlhfTElOS19JRF9BRlRFUl9EVElNKTsKLQl9
CiAJaWR4ID0gd2Z4X2dldF9wcmlvX3F1ZXVlKHd2aWYsIHR4X2FsbG93ZWRfbWFzaywgJnRvdGFs
KTsKIAlpZiAoaWR4IDwgMCkKIAkJcmV0dXJuIC1FTk9FTlQ7CkBAIC01ODUsOCArNTgzLDYgQEAg
c3RydWN0IGhpZl9tc2cgKndmeF90eF9xdWV1ZXNfZ2V0KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQog
CQlpZiAoaGlmX2hhbmRsZV90eF9kYXRhKHd2aWYsIHNrYiwgcXVldWUpKQogCQkJY29udGludWU7
ICAvKiBIYW5kbGVkIGJ5IFdTTSAqLwogCi0JCXd2aWYtPnBzcG9sbF9tYXNrICY9IH5CSVQodHhf
cHJpdi0+cmF3X2xpbmtfaWQpOwotCiAJCS8qIGFsbG93IGJ1cnN0aW5nIGlmIHR4b3AgaXMgc2V0
ICovCiAJCWlmICh3dmlmLT5lZGNhX3BhcmFtc1txdWV1ZV9udW1dLnR4b3ApCiAJCQlidXJzdCA9
IChpbnQpd2Z4X3R4X3F1ZXVlX2dldF9udW1fcXVldWVkKHF1ZXVlLCB0eF9hbGxvd2VkX21hc2sp
ICsgMTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3N0YS5jCmluZGV4IGFhMWE2OGI2MWFjNS4uYzI0OWEyOTUzYmIwIDEwMDY0NAot
LS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
c3RhLmMKQEAgLTg2Nyw3ICs4NjcsNiBAQCBzdGF0aWMgdm9pZCB3ZnhfcHNfbm90aWZ5KHN0cnVj
dCB3ZnhfdmlmICp3dmlmLCBlbnVtIHN0YV9ub3RpZnlfY21kIG5vdGlmeV9jbWQsCiAJY2FzZSBT
VEFfTk9USUZZX0FXQUtFOgogCQlpZiAocHJldikgewogCQkJd3ZpZi0+c3RhX2FzbGVlcF9tYXNr
ICY9IH5iaXQ7Ci0JCQl3dmlmLT5wc3BvbGxfbWFzayAmPSB+Yml0OwogCQkJaWYgKGxpbmtfaWQg
JiYgIXd2aWYtPnN0YV9hc2xlZXBfbWFzaykKIAkJCQlzY2hlZHVsZV93b3JrKCZ3dmlmLT5tY2Fz
dF9zdG9wX3dvcmspOwogCQkJd2Z4X2JoX3JlcXVlc3RfdHgod3ZpZi0+d2Rldik7CkBAIC0xMTc4
LDcgKzExNzcsNiBAQCB2b2lkIHdmeF9yZW1vdmVfaW50ZXJmYWNlKHN0cnVjdCBpZWVlODAyMTFf
aHcgKmh3LAogCQl3dmlmLT5tY2FzdF90eCA9IGZhbHNlOwogCQl3dmlmLT5haWQwX2JpdF9zZXQg
PSBmYWxzZTsKIAkJd3ZpZi0+bWNhc3RfYnVmZmVyZWQgPSBmYWxzZTsKLQkJd3ZpZi0+cHNwb2xs
X21hc2sgPSAwOwogCQkvKiByZXNldC5saW5rX2lkID0gMDsgKi8KIAkJaGlmX3Jlc2V0KHd2aWYs
IGZhbHNlKTsKIAkJYnJlYWs7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5o
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaAppbmRleCAzNjVhYWNjMDczZmIuLjg0OTFmMDUw
NDc4ZCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaAorKysgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3dmeC5oCkBAIC05MSw3ICs5MSw2IEBAIHN0cnVjdCB3ZnhfdmlmIHsKIAlz
dHJ1Y3Qgd29ya19zdHJ1Y3QJdHhfcG9saWN5X3VwbG9hZF93b3JrOwogCiAJdTMyCQkJc3RhX2Fz
bGVlcF9tYXNrOwotCXUzMgkJCXBzcG9sbF9tYXNrOwogCXNwaW5sb2NrX3QJCXBzX3N0YXRlX2xv
Y2s7CiAJc3RydWN0IHdvcmtfc3RydWN0CXVwZGF0ZV90aW1fd29yazsKIAotLSAKMi4yNS4wCgo=
