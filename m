Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C526413C484
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 15:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729826AbgAON7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:59:41 -0500
Received: from mail-dm6nam11on2047.outbound.protection.outlook.com ([40.107.223.47]:4897
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729094AbgAONzZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:55:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KCMVSh/0QubU+a+Dwu00HMpBHE/nwCBnFfBWPpMxHllPr4kHM/IorzXUdW1OAOTHh3ucC0s1Yp5lmhEXhwIJCKJR2XcS9LzYeJ2y4EcfCIZHZ3Wknxb1mgVWzqwOmNjqWoxGE4EB4P4Ljlw1pXOkBsUkf6zrt5XHdWH+O142JUEuaZ9J6eeFAyfc64m1gc49ezGyYDS9YwLNMQFbPxJVrUZ55Xp8DlJX/V/jbRQ+9MBg6AqiYWawA+0PxaUp4B4qbzlnWFdRYyEPRQxoS63dF4vUM3RrIljNZonrCPPAmi3+ujVvBGDCVc1whEp8c8dmqBSI0cVNKvql2Kf5woVveg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+r+hH6i8d3N1IAb/CKSuC2M9LsNeoz8vnFD1h6dEiDg=;
 b=msVx5qw+W+LVqb9yy8/e80n57ObGemuagj4XuCpN8idmzEAGe7O8RsC1OVDo7ZlVCIQaXy62+9DbTCFRAZRBBwFhNJ1YNm+XU/xCLzUbAhRgLUmTADr8+R/9Arri8Rs3IdWa+t+C3M+57HJEGBoUKs+zJpsSP2s5uU85Cz2RsZAYcahmzw9dP3YRfT4DKPL8cp6+Qnp2gQUPDAYtJ8Mkzx0lHGhl+zMqy8pu5sFBIiXjgj6Fn2iTvSqn6epewsvWZEGw+kWuuFWc3W+BTXn1P1mKYsE9lqEG3bKM0uys7xnzkOI0003tNBaY9RlSN8x+wIt92yIVQxt5IJX4eJ85RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+r+hH6i8d3N1IAb/CKSuC2M9LsNeoz8vnFD1h6dEiDg=;
 b=ihQxyinT5GCuANc4wTn5hhoPM7+ojBqeQ2DT6/BKKGcV3J+QEFyysDjnz7FgP9+hvCoeRmQUcegy1YnCr8Com8L6jp85a7XAK2n59V9XPd7CJSi9Wxno9I/odywXnf8INl8FhfmFNMpew2ehDibUBBp1DkpL0zOp491qMC2F3WI=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4094.namprd11.prod.outlook.com (10.255.180.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 13:55:20 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:55:20 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:57 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 38/65] staging: wfx: simplify wfx_update_filtering()
Thread-Topic: [PATCH v2 38/65] staging: wfx: simplify wfx_update_filtering()
Thread-Index: AQHVy6tfngHVt8U6GUCny0hqIaFlXQ==
Date:   Wed, 15 Jan 2020 13:54:58 +0000
Message-ID: <20200115135338.14374-39-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 9bdc3c1d-fa54-4082-2e92-08d799c28213
x-ms-traffictypediagnostic: MN2PR11MB4094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB40940AFBCBCB015D732177BC93370@MN2PR11MB4094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1051;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(396003)(346002)(136003)(376002)(189003)(199004)(316002)(110136005)(54906003)(85202003)(81156014)(5660300002)(8676002)(71200400001)(8936002)(81166006)(186003)(6506007)(86362001)(66946007)(66446008)(66476007)(66556008)(2906002)(64756008)(478600001)(6512007)(52116002)(66574012)(6486002)(1076003)(16526019)(4326008)(85182001)(107886003)(36756003)(8886007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4094;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sMhPG2Na9Bjv3m+MKKLzbzxraZmqo7HKw+RU6H9FkH8sRysShj3V9ZIWcrUS8YoWD2babPsmCsrJfBfhL6ln2UzEW9ZHmFGEwNQHZgj6fXr5egJhzAdBPInSEDfuO98iOdNY5WfbdQSsU6SlEIzsK7o536/Ol+5ow6QRJsN0OwisBFA0h3DmI2JQtQgZU0uHdU6YhdKmjBPkAOq6Zu2dJNBuPixZ/s6j7An0A82/3a2iDLFI091/cGWgd282+JKNlQQ56LhvkALuRltW2BU5+BLfvrJsdbyJ3TcHZsri8CEG+NG3CPmXdtmoId8RQkaQXQaWyh34j6Y7jMCaZVw9QbJkOc6Kx062WC5+/aC3QibsQrjgMjBcpYWVTs+0jEpgqb+R0oUmAamhxvBTxsjwMDXMsxJ9N9fONcO82QqtTteI2VJLeQW9BUWVxqi/NaI5
Content-Type: text/plain; charset="utf-8"
Content-ID: <D426B87D4261354E8C0D167D74EE0493@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bdc3c1d-fa54-4082-2e92-08d799c28213
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:58.2983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z6B2m58fbrnGoyN+JyotBmbajF8jP4GH2cJavooqiKerxAZXsTm46YOKoLL+Jio83U7jEQg6AQn5IyVcldvJRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X3VwZGF0ZV9maWx0ZXJpbmcoKSBoYXMgbm8gcmVhc29uIHRvIGluc3RhbnRpYXRlIGEgc3RydWN0
CmhpZl9taWJfYmNuX2ZpbHRlcl9lbmFibGUuIERyb3AgaXQgYW5kIHNpbXBsaWZ5IHRoZSBjb2Rl
LgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxh
YnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgfCAzMSArKysrKysrKysrKysr
LS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKSwgMTgg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggYTkzNGY2NmYzYTRjLi4wYzMxNTBhOTRjN2Mg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9zdGEuYwpAQCAtMTM4LDEwICsxMzgsOSBAQCBzdGF0aWMgaW50IHdmeF9zZXRfbWNh
c3RfZmlsdGVyKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogdm9pZCB3ZnhfdXBkYXRlX2ZpbHRlcmlu
ZyhzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIHsKIAlpbnQgcmV0OwotCWJvb2wgaXNfc3RhID0gd3Zp
Zi0+dmlmICYmIE5MODAyMTFfSUZUWVBFX1NUQVRJT04gPT0gd3ZpZi0+dmlmLT50eXBlOwotCWJv
b2wgZmlsdGVyX2Jzc2lkID0gd3ZpZi0+ZmlsdGVyX2Jzc2lkOwotCWJvb2wgZndkX3Byb2JlX3Jl
cSA9IHd2aWYtPmZ3ZF9wcm9iZV9yZXE7Ci0Jc3RydWN0IGhpZl9taWJfYmNuX2ZpbHRlcl9lbmFi
bGUgYmZfY3RybDsKKwlpbnQgYmZfZW5hYmxlOworCWludCBiZl9jb3VudDsKKwlpbnQgbl9maWx0
ZXJfaWVzOwogCXN0cnVjdCBoaWZfaWVfdGFibGVfZW50cnkgZmlsdGVyX2llc1tdID0gewogCQl7
CiAJCQkuaWVfaWQgICAgICAgID0gV0xBTl9FSURfVkVORE9SX1NQRUNJRklDLApAQCAtMTYxLDMz
ICsxNjAsMjkgQEAgdm9pZCB3ZnhfdXBkYXRlX2ZpbHRlcmluZyhzdHJ1Y3Qgd2Z4X3ZpZiAqd3Zp
ZikKIAkJCS5oYXNfYXBwZWFyZWQgPSAxLAogCQl9CiAJfTsKLQlpbnQgbl9maWx0ZXJfaWVzOwog
CiAJaWYgKHd2aWYtPnN0YXRlID09IFdGWF9TVEFURV9QQVNTSVZFKQogCQlyZXR1cm47CiAKIAlp
ZiAod3ZpZi0+ZGlzYWJsZV9iZWFjb25fZmlsdGVyKSB7Ci0JCWJmX2N0cmwuZW5hYmxlID0gMDsK
LQkJYmZfY3RybC5iY25fY291bnQgPSAxOworCQliZl9lbmFibGUgPSAwOworCQliZl9jb3VudCA9
IDE7CiAJCW5fZmlsdGVyX2llcyA9IDA7Ci0JfSBlbHNlIGlmICghaXNfc3RhKSB7Ci0JCWJmX2N0
cmwuZW5hYmxlID0gSElGX0JFQUNPTl9GSUxURVJfRU5BQkxFIHwKLQkJCQkgSElGX0JFQUNPTl9G
SUxURVJfQVVUT19FUlA7Ci0JCWJmX2N0cmwuYmNuX2NvdW50ID0gMDsKKwl9IGVsc2UgaWYgKHd2
aWYtPnZpZi0+dHlwZSAhPSBOTDgwMjExX0lGVFlQRV9TVEFUSU9OKSB7CisJCWJmX2VuYWJsZSA9
IEhJRl9CRUFDT05fRklMVEVSX0VOQUJMRSB8IEhJRl9CRUFDT05fRklMVEVSX0FVVE9fRVJQOwor
CQliZl9jb3VudCA9IDA7CiAJCW5fZmlsdGVyX2llcyA9IDI7CiAJfSBlbHNlIHsKLQkJYmZfY3Ry
bC5lbmFibGUgPSBISUZfQkVBQ09OX0ZJTFRFUl9FTkFCTEU7Ci0JCWJmX2N0cmwuYmNuX2NvdW50
ID0gMDsKKwkJYmZfZW5hYmxlID0gSElGX0JFQUNPTl9GSUxURVJfRU5BQkxFOworCQliZl9jb3Vu
dCA9IDA7CiAJCW5fZmlsdGVyX2llcyA9IDM7CiAJfQogCi0JcmV0ID0gaGlmX3NldF9yeF9maWx0
ZXIod3ZpZiwgZmlsdGVyX2Jzc2lkLCBmd2RfcHJvYmVfcmVxKTsKKwlyZXQgPSBoaWZfc2V0X3J4
X2ZpbHRlcih3dmlmLCB3dmlmLT5maWx0ZXJfYnNzaWQsIHd2aWYtPmZ3ZF9wcm9iZV9yZXEpOwog
CWlmICghcmV0KQotCQlyZXQgPSBoaWZfc2V0X2JlYWNvbl9maWx0ZXJfdGFibGUod3ZpZiwgbl9m
aWx0ZXJfaWVzLAotCQkJCQkJICBmaWx0ZXJfaWVzKTsKKwkJcmV0ID0gaGlmX3NldF9iZWFjb25f
ZmlsdGVyX3RhYmxlKHd2aWYsIG5fZmlsdGVyX2llcywgZmlsdGVyX2llcyk7CiAJaWYgKCFyZXQp
Ci0JCXJldCA9IGhpZl9iZWFjb25fZmlsdGVyX2NvbnRyb2wod3ZpZiwgYmZfY3RybC5lbmFibGUs
Ci0JCQkJCQliZl9jdHJsLmJjbl9jb3VudCk7CisJCXJldCA9IGhpZl9iZWFjb25fZmlsdGVyX2Nv
bnRyb2wod3ZpZiwgYmZfZW5hYmxlLCBiZl9jb3VudCk7CiAJaWYgKCFyZXQpCiAJCXJldCA9IHdm
eF9zZXRfbWNhc3RfZmlsdGVyKHd2aWYsICZ3dmlmLT5tY2FzdF9maWx0ZXIpOwogCWlmIChyZXQp
Ci0tIAoyLjI1LjAKCg==
