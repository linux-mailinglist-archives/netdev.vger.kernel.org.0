Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5BD12109D
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbfLPREk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:04:40 -0500
Received: from mail-eopbgr700081.outbound.protection.outlook.com ([40.107.70.81]:14720
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727121AbfLPREA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:04:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZRDCFr0mmT3lpZL8ONOR7ONGAjB/F3fOkbh6gbva1PyXh0hvuzK36YClex0tztT7ovkg+ChvVdZw29rUPkLPIt5/nyehdpRN8XhAQ+KKmSrZ3gcFkVe8yE4h2b3iCwg9fldi/8gozOcIrkq6TirzQXWg1WmjFbdgIuTXpWVBVAOOvKYBllvvW1+i2Gn2+b26nVHB6bi+nO1D/7ZbbZhQSTGUFepN3SHygF+0YGuI1cw2J8EUVt5vwdQOgjKSq7Dt5GVr1T3XdcDTPzfSToswMe4GXKIezxcN2Zh82Svr6kAcwx8BCJZusyIsyhUDoltJa19pvCPsKlKOlAbnaovkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5s57VCF+uOi4jlkrrQQm+biyaNEI2GnE+tCssPOeVU=;
 b=HA0QAycrUawS7vcojssKBGxQ+YJ99PX9Fxo0NK/3iYEZDtn26DFhF9+m3z6FimfuTezcK2+vRFUwkJE9K1RYGFXlnsn7cgsyeXp1ojwO2lhh4q1USA/J00L3tOK/EjdtmpYLHX1Qz+L736L3nqM+Yn7zuYUFUIQT/uPMGlTEOZWQw5pm5rBmp42y6KefpSM4nfiUasaREW09i9UrS+5Abb5NHioMuxuWlHGA7nBerYysQTYto8BvIdts61wGGeocpY62jJDpBMFLnd/9zWruVDhRykDolWlPUpxceNqH/Cnlkm5fP4GoQ0nob4zqGtJ88Dbd3ODzyfQjk2pMPTUikQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5s57VCF+uOi4jlkrrQQm+biyaNEI2GnE+tCssPOeVU=;
 b=JKzi5YMKJChOh8rPp4p7DJrJeqT/vRPb2cjyypwrIyMAS0nQRPKUJY5KTuacUUAxoRSPy6I192NifBtHgETuzdILqHY9JvI0FD5+/wpjs/GRzO1komTRbf/x6ywuDmTKnRIj9KbZOFQ9P7EFQoA3FGv3S9cNpSIlnDLn0RUR3Qc=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4351.namprd11.prod.outlook.com (52.135.39.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.19; Mon, 16 Dec 2019 17:03:52 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:03:52 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 21/55] staging: wfx: ensure that traces never modify arguments
Thread-Topic: [PATCH 21/55] staging: wfx: ensure that traces never modify
 arguments
Thread-Index: AQHVtDLGXmTa6susIkOhtozAcdaGFQ==
Date:   Mon, 16 Dec 2019 17:03:44 +0000
Message-ID: <20191216170302.29543-22-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 3831f18e-4cc6-498e-6dc3-08d78249ed48
x-ms-traffictypediagnostic: MN2PR11MB4351:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4351C66B6BAEC11250D1B60B93510@MN2PR11MB4351.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(396003)(39860400002)(199004)(189003)(66556008)(66446008)(64756008)(66476007)(76116006)(85202003)(91956017)(66946007)(54906003)(107886003)(4326008)(478600001)(110136005)(71200400001)(6512007)(81156014)(8676002)(81166006)(186003)(36756003)(2906002)(85182001)(6666004)(1076003)(316002)(6506007)(5660300002)(86362001)(26005)(2616005)(6486002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4351;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ujHkyviufRPMN69d1+0ITOg3EPa+0HY6RtGpD1dIDc/PJjKJKc9fHMqQKV8MPr9WaqXWmzLi8AylWDo6PfhAyHGkfM9F40n5XH10WfRbqXIZnUFDAncjGOcDDGO+FGmDqFXL4OGFgA3p5PPOksNQsqXxT4G21UQX7xYqGMsNgAlKtKJks5WNcif0U5hXSXvwSZSRf2WYQDOohf3SzzScLVivVRXDx1N8u4qOIhA+B5vGy8xwpjziAiv2xNtkuShtPrsf92sY4BFGJV6SKlcbb26DG9xM8DHJV1BooYfJHdNWCn83DVRSXSRaznETFbVckNInr5dLV9+ZIr9yW2IxtUAfv0ryd4ARUwpUNHOK0UwfzsoJs5cHMaU49f7uZ9o3lOF3rJbtAhst9/IHLTgKStmJYj9XXXzPw5KFJFZafi8a/XQHln3cacAVOYDSQQrc
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D4922AB94FA09419E9BCBF1DBA6FC93@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3831f18e-4cc6-498e-6dc3-08d78249ed48
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:44.3149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AN1/ne4Sqg+51dmFL8tHFOyoSXepKjYtHstS/Px/P+K2hRRkezDUQtYzem9Qk9F2HVj7lnNg6Xpp+rgYlLK1Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4351
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpU
aGVyZSBpcyBubyByZWFzb24gZm9yIGEgdHJhY2UgdG8gY2hhbmdlIGFueSBiaXQgb2YgdGhlIGFy
Z3VtZW50LiBTbywNCmxldCdzIG1ha2Ugc3VyZSB0aGF0IGlzIHRoZSBjYXNlIGJ5IGRlY2xhcmlu
ZyB0aGUgYXJndW1lbnRzIGNvbnN0YW50Lg0KDQpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3Vp
bGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+DQotLS0NCiBkcml2ZXJzL3N0YWdpbmcv
d2Z4L3RyYWNlcy5oIHwgMTQgKysrKysrKystLS0tLS0NCiAxIGZpbGUgY2hhbmdlZCwgOCBpbnNl
cnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5n
L3dmeC90cmFjZXMuaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvdHJhY2VzLmgNCmluZGV4IDNmNjE5
OGFiMjIzNS4uMzBjNmExM2YwZTIyIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC90
cmFjZXMuaA0KKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC90cmFjZXMuaA0KQEAgLTE1Myw3ICsx
NTMsNyBAQCBoaWZfbWliX2xpc3RfZW51bQ0KICNkZWZpbmUgaGlmX21pYl9saXN0IGhpZl9taWJf
bGlzdF9lbnVtIHsgLTEsIE5VTEwgfQ0KIA0KIERFQ0xBUkVfRVZFTlRfQ0xBU1MoaGlmX2RhdGEs
DQotCVRQX1BST1RPKHN0cnVjdCBoaWZfbXNnICpoaWYsIGludCB0eF9maWxsX2xldmVsLCBib29s
IGlzX3JlY3YpLA0KKwlUUF9QUk9UTyhjb25zdCBzdHJ1Y3QgaGlmX21zZyAqaGlmLCBpbnQgdHhf
ZmlsbF9sZXZlbCwgYm9vbCBpc19yZWN2KSwNCiAJVFBfQVJHUyhoaWYsIHR4X2ZpbGxfbGV2ZWws
IGlzX3JlY3YpLA0KIAlUUF9TVFJVQ1RfX2VudHJ5KA0KIAkJX19maWVsZChpbnQsIHR4X2ZpbGxf
bGV2ZWwpDQpAQCAtMjAzLDEyICsyMDMsMTIgQEAgREVDTEFSRV9FVkVOVF9DTEFTUyhoaWZfZGF0
YSwNCiAJKQ0KICk7DQogREVGSU5FX0VWRU5UKGhpZl9kYXRhLCBoaWZfc2VuZCwNCi0JVFBfUFJP
VE8oc3RydWN0IGhpZl9tc2cgKmhpZiwgaW50IHR4X2ZpbGxfbGV2ZWwsIGJvb2wgaXNfcmVjdiks
DQorCVRQX1BST1RPKGNvbnN0IHN0cnVjdCBoaWZfbXNnICpoaWYsIGludCB0eF9maWxsX2xldmVs
LCBib29sIGlzX3JlY3YpLA0KIAlUUF9BUkdTKGhpZiwgdHhfZmlsbF9sZXZlbCwgaXNfcmVjdikp
Ow0KICNkZWZpbmUgX3RyYWNlX2hpZl9zZW5kKGhpZiwgdHhfZmlsbF9sZXZlbClcDQogCXRyYWNl
X2hpZl9zZW5kKGhpZiwgdHhfZmlsbF9sZXZlbCwgZmFsc2UpDQogREVGSU5FX0VWRU5UKGhpZl9k
YXRhLCBoaWZfcmVjdiwNCi0JVFBfUFJPVE8oc3RydWN0IGhpZl9tc2cgKmhpZiwgaW50IHR4X2Zp
bGxfbGV2ZWwsIGJvb2wgaXNfcmVjdiksDQorCVRQX1BST1RPKGNvbnN0IHN0cnVjdCBoaWZfbXNn
ICpoaWYsIGludCB0eF9maWxsX2xldmVsLCBib29sIGlzX3JlY3YpLA0KIAlUUF9BUkdTKGhpZiwg
dHhfZmlsbF9sZXZlbCwgaXNfcmVjdikpOw0KICNkZWZpbmUgX3RyYWNlX2hpZl9yZWN2KGhpZiwg
dHhfZmlsbF9sZXZlbClcDQogCXRyYWNlX2hpZl9yZWN2KGhpZiwgdHhfZmlsbF9sZXZlbCwgdHJ1
ZSkNCkBAIC0zNTksNyArMzU5LDggQEAgVFJBQ0VfRVZFTlQoYmhfc3RhdHMsDQogCXRyYWNlX2Jo
X3N0YXRzKGluZCwgcmVxLCBjbmYsIGJ1c3ksIHJlbGVhc2UpDQogDQogVFJBQ0VfRVZFTlQodHhf
c3RhdHMsDQotCVRQX1BST1RPKHN0cnVjdCBoaWZfY25mX3R4ICp0eF9jbmYsIHN0cnVjdCBza19i
dWZmICpza2IsIGludCBkZWxheSksDQorCVRQX1BST1RPKGNvbnN0IHN0cnVjdCBoaWZfY25mX3R4
ICp0eF9jbmYsIGNvbnN0IHN0cnVjdCBza19idWZmICpza2IsDQorCQkgaW50IGRlbGF5KSwNCiAJ
VFBfQVJHUyh0eF9jbmYsIHNrYiwgZGVsYXkpLA0KIAlUUF9TVFJVQ1RfX2VudHJ5KA0KIAkJX19m
aWVsZChpbnQsIHBrdF9pZCkNCkBAIC0zNzUsOCArMzc2LDkgQEAgVFJBQ0VfRVZFTlQodHhfc3Rh
dHMsDQogCQkvLyBLZWVwIHN5bmMgd2l0aCB3ZnhfcmF0ZXMgZGVmaW5pdGlvbiBpbiBtYWluLmMN
CiAJCXN0YXRpYyBjb25zdCBpbnQgaHdfcmF0ZVtdID0geyAwLCAxLCAyLCAzLCA2LCA3LCA4LCA5
LA0KIAkJCQkJICAgICAgIDEwLCAxMSwgMTIsIDEzIH07DQotCQlzdHJ1Y3QgaWVlZTgwMjExX3R4
X2luZm8gKnR4X2luZm8gPSBJRUVFODAyMTFfU0tCX0NCKHNrYik7DQotCQlzdHJ1Y3QgaWVlZTgw
MjExX3R4X3JhdGUgKnJhdGVzID0gdHhfaW5mby0+ZHJpdmVyX3JhdGVzOw0KKwkJY29uc3Qgc3Ry
dWN0IGllZWU4MDIxMV90eF9pbmZvICp0eF9pbmZvID0NCisJCQkoY29uc3Qgc3RydWN0IGllZWU4
MDIxMV90eF9pbmZvICopc2tiLT5jYjsNCisJCWNvbnN0IHN0cnVjdCBpZWVlODAyMTFfdHhfcmF0
ZSAqcmF0ZXMgPSB0eF9pbmZvLT5kcml2ZXJfcmF0ZXM7DQogCQlpbnQgaTsNCiANCiAJCV9fZW50
cnktPnBrdF9pZCA9IHR4X2NuZi0+cGFja2V0X2lkOw0KLS0gDQoyLjIwLjENCg==
