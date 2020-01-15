Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D29713C3BA
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgAONyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:54:41 -0500
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:14113
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729335AbgAONyl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:54:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBsIqiBiA82e762SDIMcmxCafiZWADlND/nZvAMpIFLYGxfyH8NNQyFO6e8Rt6pmpUpiyXCKTAR05ovPZU/KwC3BcMhIh8iY1spMakqdrxPGT9Vx7NJARgMPKKKJgQsocNGsT/kmQIQXx6M9A/KRTk2FniLdK7rSaDFO9fB8omEdipXZm+bCJKsAYQJ6z249Be0Sx/BnyRF+cA0BsxY0pm8J7OhjOSLaf+lRqQmM+DqBcLie97zA/TXyn7aFiJ1Vr28BaSf7vVOtq+VAEPvEb+H64B+0bp33oKLOzDmGwhiZWhEw5uuXZJ44mBepawAJRa9zBZVDtDdBbf5ArDyfgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JtJ2THuxCUky/HiJ4NGgOwKReUaawaehfR0nk8oPx4=;
 b=gQW09Fdgf4ycuKE/j4AlTq50sPUEMQVUegotTUsC9R8vIztS+3ZcJ6oNGDymOMWbK8f+ZOtEfNOm73tM2KcYudmMMqBGDAVk/6ktFI65cOPVXvYfXUP/E0K7xWi0SFazDVCZlFYdEhqBFklnrPdAwhU86NAZb1BbaLwRJdsmbxyKqv+/pd8Bctdam3CKNhbam8uNM5FBQ26HDTP4wxUNrJRMBAAThQXk2EpilZGy+IiQncczrkg1SOXnER0GMmgxfpdP8kFjqTClAjhzSdH+hZbMcePN9xf2YEX6zeRR64u8s+7H9DliAK910grNf+ppjm1B2hZ9IpZ5qHmyjG8/Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JtJ2THuxCUky/HiJ4NGgOwKReUaawaehfR0nk8oPx4=;
 b=camq1mFNEHGWzFf0+1PIeKKfAxG7AmtDENznJOAX9l8i+vNrHSmGjK61vJHnMQFdIFBAATAiicYIzKhE/lA8xkm4DH585GJ6IWATSoRc8R3kbRQ9RTlHkEFpxYDIU97YwTjx1UTK1mB9shlxNNqbnhuSfvn0leVt6PyoJwtgV+A=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4094.namprd11.prod.outlook.com (10.255.180.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 13:54:25 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:54:25 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:23 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 16/65] staging: wfx: rename wfx_upload_beacon()
Thread-Topic: [PATCH v2 16/65] staging: wfx: rename wfx_upload_beacon()
Thread-Index: AQHVy6tLV6TNFz6aKUGZU44vHfJ7Lg==
Date:   Wed, 15 Jan 2020 13:54:24 +0000
Message-ID: <20200115135338.14374-17-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 9ff9ee08-318e-4102-70ce-08d799c26e25
x-ms-traffictypediagnostic: MN2PR11MB4094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4094659B92ABE61BB408C5A593370@MN2PR11MB4094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(396003)(346002)(136003)(376002)(189003)(199004)(316002)(110136005)(54906003)(85202003)(81156014)(5660300002)(8676002)(71200400001)(8936002)(81166006)(186003)(6506007)(86362001)(66946007)(66446008)(66476007)(66556008)(2906002)(64756008)(478600001)(6512007)(52116002)(66574012)(6486002)(1076003)(16526019)(4326008)(85182001)(107886003)(36756003)(8886007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4094;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PHyyUWc/7HCNwLQXISJNp6Y39oF8BptRC9Jhiy92nOWNpI13MWpO28wZX5y5b4Mvw5aQ7bbl6K6LWBqANaW3lVOd0U4rW1xmX4YthbtLX8LnnzflgQiYwx/kKxt/Ta2jc/RPkYlhZ0zis561BnQaCs5fWo/v5orp0H4d17gaZfi977EneTEbRJV71j90gjSYceW/dNV36TGLxLyKmbqvYR+J3csToFb88jHk22ef1DJh6htQsLoMN3Gvi7x/9SuG/2SVn5e/ZTj8baDmnsMUfIu7mQUS8mqDLmpDL5ow0ve9Vt5720K6wolG2RDk38uJHidqE7U9AaJdykFHpaxrPUy1W2Rj3RyLIJbj0He9keKNaWEOE5EpQIUHaK3rN1Hql8l3oIwQ3Gw4Qhwm+c8yPvRJtuNUNDDtSSi2VMJa1/A67gPUgeII2M7D0l/IZPJA
Content-Type: text/plain; charset="utf-8"
Content-ID: <7B7267F6236A404F93A77C3555A1C471@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ff9ee08-318e-4102-70ce-08d799c26e25
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:24.8756
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BZHDlFPv2q78CBTC8m1L0A4jHoCGXehlsdREa16gm3u+vM8OLJihEC4T//3Ly3rmYWgfWUy4TKzpBky433ArIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW4g
ZmFjdCwgd2Z4X3VwbG9hZF9iZWFjb24oKSB1cGxvYWRzIGJlYWNvbiBhbmQgcHJvYmUgcmVzcG9u
c2UuIFNvLApyZW5hbWUgaXQgaW4gd2Z4X3VwbG9hZF9hcF90ZW1wbGF0ZXMoKS4KClRoZSBjYWxs
IHRvIHdmeF9md2RfcHJvYmVfcmVxKCkgaGFzIG5vdGhpbmcgdG8gZG8gd2l0aCB0ZW1wbGF0ZQp1
cGxvYWRpbmcsIHNvIHJlbG9jYXRlIGl0LgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxs
ZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngv
c3RhLmMgfCA2ICsrKy0tLQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVy
cy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCA0NTFkMDEwOGExYjAuLmZkZGU3YWI5MjMwMiAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jCkBAIC03ODAsNyArNzgwLDcgQEAgc3RhdGljIGludCB3ZnhfdXBkYXRlX2JlYWNv
bmluZyhzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIAlyZXR1cm4gMDsKIH0KIAotc3RhdGljIGludCB3
ZnhfdXBsb2FkX2JlYWNvbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKK3N0YXRpYyBpbnQgd2Z4X3Vw
bG9hZF9hcF90ZW1wbGF0ZXMoc3RydWN0IHdmeF92aWYgKnd2aWYpCiB7CiAJc3RydWN0IHNrX2J1
ZmYgKnNrYjsKIAlzdHJ1Y3QgaWVlZTgwMjExX21nbXQgKm1nbXQ7CkBAIC04MDUsNyArODA1LDYg
QEAgc3RhdGljIGludCB3ZnhfdXBsb2FkX2JlYWNvbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIAog
CWhpZl9zZXRfdGVtcGxhdGVfZnJhbWUod3ZpZiwgc2tiLCBISUZfVE1QTFRfUFJCUkVTLAogCQkJ
ICAgICAgIEFQSV9SQVRFX0lOREVYX0JfMU1CUFMpOwotCXdmeF9md2RfcHJvYmVfcmVxKHd2aWYs
IGZhbHNlKTsKIAlkZXZfa2ZyZWVfc2tiKHNrYik7CiAJcmV0dXJuIDA7CiB9CkBAIC05MDAsNyAr
ODk5LDggQEAgdm9pZCB3ZnhfYnNzX2luZm9fY2hhbmdlZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpo
dywKIAkgICAgY2hhbmdlZCAmIEJTU19DSEFOR0VEX0lCU1MpIHsKIAkJd3ZpZi0+YmVhY29uX2lu
dCA9IGluZm8tPmJlYWNvbl9pbnQ7CiAJCXdmeF91cGRhdGVfYmVhY29uaW5nKHd2aWYpOwotCQl3
ZnhfdXBsb2FkX2JlYWNvbih3dmlmKTsKKwkJd2Z4X3VwbG9hZF9hcF90ZW1wbGF0ZXMod3ZpZik7
CisJCXdmeF9md2RfcHJvYmVfcmVxKHd2aWYsIGZhbHNlKTsKIAl9CiAKIAlpZiAoY2hhbmdlZCAm
IEJTU19DSEFOR0VEX0JFQUNPTl9FTkFCTEVEICYmCi0tIAoyLjI1LjAKCg==
