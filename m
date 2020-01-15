Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A31B13C4BD
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 15:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgAONyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:54:22 -0500
Received: from mail-bn7nam10on2043.outbound.protection.outlook.com ([40.107.92.43]:8538
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729078AbgAONyW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:54:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ipeex1GFqyZBNyQ4NyWJ0YMXat4i22S5ECbRYpur8m2b7CvgIod/+IUo6Xtlf7Jba2gdM7fYwPTkQXLp12fsLwOiOfi/w4bYZvMAVDTrZCikocxAdym1qYMrbGr/ArUUaXDoeL6H0T+GfdPEMXTQd9N4DCce67ZGjG+I7oMyNzY3/TDl4essQxcSCn7DXCBhGHPbIUEjdo1tS0ISisWJXXgjIk50Az4nDETY40duHTKYvCaUBGp/Vtk10KTcUIC7uc20Fv/FaLmroFSSI26snV2cd1U2MiDwvUkUCgkFB63ZRtPWfE9+51a2Z5pnS37Xg05rMV6K/x/O1NZ5Oezrfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXjwnQ3yvU8lyBSO2Sod3uaseaRMamnlynrVm+tTnXQ=;
 b=lVJpiOn/4hLiwYAH21EHgwDYGd/xrtDXqwjrdjpVsEYND2zRplNtxEvtcDlzq/B27x20Bj90COW2/VIIccw2Pem87vuYkGHP7mb9SN4omtzfd8QOkshUD3ok8NBD95zI6YoeNrT9aciEtyXAcm/D5pORw2hnafV2G9B8Y0JAx8NsYmgOld9v8VI8wW7FbBOgilbwtowhzjbdtWANONTZnwNFdiPZvUl6bgeZhreuTk0uMylUC7or0R47j0W6+JGQYIczC5CFtKf45gaMksHDAW5aAAT9oOu3dn0ESIejaiqtP/cZXAgh9doBJnHmFYUtGsrFQNN/ARBYENlXifjgpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXjwnQ3yvU8lyBSO2Sod3uaseaRMamnlynrVm+tTnXQ=;
 b=cOvbzPb2qFGqABA9IoXAfJkESIIXl/tBemMwIYMEuuI1lHtL2AQOGIYEzTc6BDe61mv4fObc5iKwBLqz2fF7ygeR2IuLqLMDre1+wMrDa3NBSx7YJJetZWbo10uGBe4bfo5lxa/fZxqJz/nvSy56Qex7q2J88wr2PXJVBCbAcsU=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:54:19 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:54:19 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:18 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 12/65] staging: wfx: retrieve greenfield mode from
 sta->ht_cap and bss_conf
Thread-Topic: [PATCH v2 12/65] staging: wfx: retrieve greenfield mode from
 sta->ht_cap and bss_conf
Thread-Index: AQHVy6tIGUmVoP+xv0yARbwZJ9m6wQ==
Date:   Wed, 15 Jan 2020 13:54:19 +0000
Message-ID: <20200115135338.14374-13-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: d8d8706e-241c-4e92-945f-08d799c26abf
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3661ADCC694FB00DE526873A93370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:341;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(86362001)(2616005)(4326008)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jTr/NNEA0dJWg+KFlabysrU0QpKZKKxs4y3QsJDJKch9fXE9F3GYBr1pKBZOh/L2+AyVLefeKUMJtL7ktsoG6uCRyX/wPpakXYLht8iVRP6nTLyL8+KkNVfQO85PRjaDoqkMMbEUcQJwVjq55iPZcdzvnh/oRdWjdWwy8C12HcQqTxwFIIrO+0785Nrni4vCbaeWUF7XtLMyydmOQ4rv6TtmK/rdYbex2Gps4xiSsoYMpIZLecYv6MVw3XVlODicIlv8DPZ2tJ2sqDqTzh+I8rtgT9wqgEogD35nl/+9BqIT02mTIRuV5eQIFmObCQ9LBwlJq+58ad1XPRufRYM1EYvzUuviKLOvEQ/9JmEEdiH6gzP0D2BNkgPBMjaIQC7wmgnAeXt/qDC8bEMwSca2QKTdWkQeCUCnmmju0VzKYItEwdH8QMzew6XR5kPE1pSN
Content-Type: text/plain; charset="utf-8"
Content-ID: <27482D458E0F914484DE79DE23638CB8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8d8706e-241c-4e92-945f-08d799c26abf
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:19.1788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QFR1sMxPhou9QReCLJ6QA4nVAvcmjaVyupBYJBakNnl2ZbsmGXd6AQr4vDr934eDA4NJInpRiOaW1wQumzMbLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd3Zp
Zi0+aHRfaW5mbyBjb250YWlucyB1c2VsZXNzIGNvcGllcyBvZiBzdGEtPmh0X2NhcCBhbmQKYnNz
X2NvbmYtPmh0X29wZXJhdGlvbl9tb2RlLiBQcmVmZXIgdG8gcmV0cmlldmUgaW5mb3JtYXRpb24g
ZnJvbSB0aGUKb3JpZ2luYWwgc3RydWN0cyBpbnN0ZWFkIG9mIHJlbHkgb24gd3ZpZi0+aHRfaW5m
by4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2ls
YWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIHwgMTggKysrKysrLS0tLS0t
LS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAxMiBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9zdGEuYwppbmRleCBmMTNhNWI0MTczNWMuLmZjZDlmZTY2ZTQxNyAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5j
CkBAIC04MTcsMTQgKzgxNyw2IEBAIHN0YXRpYyBpbnQgd2Z4X2lzX2h0KGNvbnN0IHN0cnVjdCB3
ZnhfaHRfaW5mbyAqaHRfaW5mbykKIAlyZXR1cm4gaHRfaW5mby0+Y2hhbm5lbF90eXBlICE9IE5M
ODAyMTFfQ0hBTl9OT19IVDsKIH0KIAotc3RhdGljIGludCB3ZnhfaHRfZ3JlZW5maWVsZChjb25z
dCBzdHJ1Y3Qgd2Z4X2h0X2luZm8gKmh0X2luZm8pCi17Ci0JcmV0dXJuIHdmeF9pc19odChodF9p
bmZvKSAmJgotCQkoaHRfaW5mby0+aHRfY2FwLmNhcCAmIElFRUU4MDIxMV9IVF9DQVBfR1JOX0ZM
RCkgJiYKLQkJIShodF9pbmZvLT5vcGVyYXRpb25fbW9kZSAmCi0JCSAgSUVFRTgwMjExX0hUX09Q
X01PREVfTk9OX0dGX1NUQV9QUlNOVCk7Ci19Ci0KIHN0YXRpYyB2b2lkIHdmeF9qb2luX2ZpbmFs
aXplKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCQkJICAgICAgc3RydWN0IGllZWU4MDIxMV9ic3Nf
Y29uZiAqaW5mbykKIHsKQEAgLTg0OSw5ICs4NDEsOCBAQCBzdGF0aWMgdm9pZCB3Znhfam9pbl9m
aW5hbGl6ZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAl9CiAJcmN1X3JlYWRfdW5sb2NrKCk7CiAK
LQkvKiBOb24gR3JlZW5maWVsZCBzdGF0aW9ucyBwcmVzZW50ICovCi0JaWYgKHd2aWYtPmh0X2lu
Zm8ub3BlcmF0aW9uX21vZGUgJgotCSAgICBJRUVFODAyMTFfSFRfT1BfTU9ERV9OT05fR0ZfU1RB
X1BSU05UKQorCWlmIChzdGEgJiYKKwkgICAgaW5mby0+aHRfb3BlcmF0aW9uX21vZGUgJiBJRUVF
ODAyMTFfSFRfT1BfTU9ERV9OT05fR0ZfU1RBX1BSU05UKQogCQloaWZfZHVhbF9jdHNfcHJvdGVj
dGlvbih3dmlmLCB0cnVlKTsKIAllbHNlCiAJCWhpZl9kdWFsX2N0c19wcm90ZWN0aW9uKHd2aWYs
IGZhbHNlKTsKQEAgLTg2Miw3ICs4NTMsMTAgQEAgc3RhdGljIHZvaWQgd2Z4X2pvaW5fZmluYWxp
emUoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJYXNzb2NpYXRpb25fbW9kZS5zcGFjaW5nID0gMTsK
IAlhc3NvY2lhdGlvbl9tb2RlLnNob3J0X3ByZWFtYmxlID0gaW5mby0+dXNlX3Nob3J0X3ByZWFt
YmxlOwogCWFzc29jaWF0aW9uX21vZGUuYmFzaWNfcmF0ZV9zZXQgPSBjcHVfdG9fbGUzMih3Znhf
cmF0ZV9tYXNrX3RvX2h3KHd2aWYtPndkZXYsIGluZm8tPmJhc2ljX3JhdGVzKSk7Ci0JYXNzb2Np
YXRpb25fbW9kZS5ncmVlbmZpZWxkID0gd2Z4X2h0X2dyZWVuZmllbGQoJnd2aWYtPmh0X2luZm8p
OworCWlmIChzdGEgJiYgc3RhLT5odF9jYXAuaHRfc3VwcG9ydGVkICYmCisJICAgICEoaW5mby0+
aHRfb3BlcmF0aW9uX21vZGUgJiBJRUVFODAyMTFfSFRfT1BfTU9ERV9OT05fR0ZfU1RBX1BSU05U
KSkKKwkJYXNzb2NpYXRpb25fbW9kZS5ncmVlbmZpZWxkID0KKwkJCSEhKHN0YS0+aHRfY2FwLmNh
cCAmIElFRUU4MDIxMV9IVF9DQVBfR1JOX0ZMRCk7CiAJaWYgKHN0YSAmJiBzdGEtPmh0X2NhcC5o
dF9zdXBwb3J0ZWQpCiAJCWFzc29jaWF0aW9uX21vZGUubXBkdV9zdGFydF9zcGFjaW5nID0gc3Rh
LT5odF9jYXAuYW1wZHVfZGVuc2l0eTsKIAotLSAKMi4yNS4wCgo=
