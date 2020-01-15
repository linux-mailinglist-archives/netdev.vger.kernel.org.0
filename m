Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C88E13BF5C
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731020AbgAOMNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:13:04 -0500
Received: from mail-bn7nam10on2047.outbound.protection.outlook.com ([40.107.92.47]:27390
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730909AbgAOMMy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOfvYWqLe3RYbVxRB3aCNpKXsxc7srhoU6qER8pC4MEaMwmgSB37gkoJNgtJKPgdvx2TQUq+QIjLKEdaxcQX0SMgsLJdgtZ6e48MVRGfKiru2/Iijsryi9KPf4X4yW+axcEYdSjuXdKiMcFiE9LyS6C6AFSJny8WY2wiQbHquSFz2SE2QeRhhx3FOFjM4zTFmKO3i/kJZ2IFGQ8p+kmJ6PeS5uxiMjKtDIu31sT63++EIi9Dne7cDjLEKDWYmj7mO3Vd1D9g7+IyorxCwW5pwUZv/8jptTSTYLUZtupK/Uhz8U8hSjUqv8roaEq5Nt/0IoAxo0abIvXDxCo5f4RmEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lh4Sgj/UN1E/Qd8hmHGGL7HIEuTRhUu+NasuAtyaxyw=;
 b=ClC2R0B1Y4NTspszJaKIQB6TBdVvSs5nXMgxP+tdgHweL108zrbn8ocYcnTjzXEvVfX7lu3+0x1LsgDNtKUcVj6S+5SvwuVx+666HEfoJtRmQwqfscKG2jLeeXugTYU4cv8Gy8J5+V/nHkLTDqXWOo8FMo517lwFIKze5O3a5z3fZOu8PP5qwMCW459DXY6eDCWvicR9kwxaO2ZbX600o7sD+2SKKnr78H3/mChuHOc0/bA0AIqvtCDzXUhWFfrG09tQADCJ9IPrW7Z9jqviDHPT8vEykCBz/FhG+cB40sQj755mJj/81eC9ewNZaYe5fyt4PWdKVGOgiWRa43tAEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lh4Sgj/UN1E/Qd8hmHGGL7HIEuTRhUu+NasuAtyaxyw=;
 b=AFpXz8FT5txLxDzJ63zBNh5MqIg6nQksSMY+Mt0AZzrxc9FuP+C0YG2TxbKOyw91VIvecgUI2wgrW/CTye+f/as24xF7IsDZ0f29sC+VVj7czi75aUsTeqlDwkV7M7kjo84MZXRgSsi+NDZX9lCtT7BzHBTxdNL4ADb4jro9gi4=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4096.namprd11.prod.outlook.com (20.179.150.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Wed, 15 Jan 2020 12:12:48 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:48 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:46 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 29/65] staging: wfx: simplify hif_join()
Thread-Topic: [PATCH 29/65] staging: wfx: simplify hif_join()
Thread-Index: AQHVy50Zs0mNUkjhK0qvoyD02QNuJw==
Date:   Wed, 15 Jan 2020 12:12:47 +0000
Message-ID: <20200115121041.10863-30-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 833d5f0c-9616-423b-8eee-08d799b43c0f
x-ms-traffictypediagnostic: MN2PR11MB4096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB409649CAD8541BE5DE92AFAB93370@MN2PR11MB4096.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(376002)(136003)(199004)(189003)(85202003)(66946007)(66446008)(66476007)(2906002)(107886003)(66556008)(1076003)(66574012)(64756008)(5660300002)(8936002)(6486002)(186003)(26005)(8676002)(316002)(81156014)(36756003)(52116002)(2616005)(7696005)(478600001)(16526019)(956004)(54906003)(110136005)(86362001)(71200400001)(85182001)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4096;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JDr1x/pOs94axCuPEgKl52vpYBWLCjKQCjeTrqtwkXlCLifJW4T0+DaBLGVxdRiXaGjZDb1gDeJVxWLy2WCH7ILJTBhqLAjRTiTOgN5jDu228YGSr5Fxz0oDDTmMGKWK0VrQ3ppLKhtiAdmy/MYKL69IAN+FruV5zqRgHwfbuCd05c5igSpZOXAB0VvK+9tQG9GRa40ZMqJ3gyxGl5lQDkH90W1xq4H2MTWkNvhmpU9P+7QDmDcDMpG5V/Fe10sL5FX6ri6JDSG+j8JkfHagdiU3Qf4euoJ+h5z9Nl7sXVitr6S5glvgjUeC8AEHgcZunYblEwNvbMfEkR4HjaXYpQTWH3fH9KAbME0S9fbpPiXEfwUr+XPA7cXgllFEEkCOdFWTpZTJMVHn6sJWJcT+jhmQ8xus11KssBLDD+54USk485FkeIAlN7MA1U+Ry1+v
Content-Type: text/plain; charset="utf-8"
Content-ID: <28619855DCD0364BAEBE9BABCB52E6AE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 833d5f0c-9616-423b-8eee-08d799b43c0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:47.8739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RKhoGkWLKE1C5k3wt0yVbiX5d0tkxe2hbTs6WqDiUdl4+BopVKuGGZVe28N9rN38d4n/iXEX1cakEAEm5GNyFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4096
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN0cnVjdHVyZSBoaWZfcmVxX2pvaW4gY29tZSBmcm9tIGhhcmR3YXJlIEFQSS4gSXQgaXMgbm90
IGludGVuZGVkCnRvIGJlIG1hbmlwdWxhdGVkIGluIHVwcGVyIGxheWVycyBvZiB0aGUgZHJpdmVy
LgoKSW4gYWRkLCBjdXJyZW50IGNvZGUgZm9yIGhpZl9qb2luKCkgaXMgdG9vIGR1bWIuIEl0IHNo
b3VsZCBwYWNrIGRhdGEKd2l0aCBoYXJkd2FyZSByZXByZXNlbnRhdGlvbiBpbnN0ZWFkIG9mIGxl
YXZpbmcgYWxsIHdvcmsgdG8gdGhlIGNhbGxlci4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBv
dWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcv
d2Z4L2hpZl90eC5jIHwgMjUgKysrKysrKysrKysrKystLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93
ZngvaGlmX3R4LmggfCAgMyArKy0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgICAgfCA0NSAr
KysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIDMgZmlsZXMgY2hhbmdlZCwgMzAg
aW5zZXJ0aW9ucygrKSwgNDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9oaWZfdHguYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKaW5kZXggMzJl
ZWJhMmZjYTQ3Li4yNDI4MzYzMzcxZmEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX3R4LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYwpAQCAtMjg4LDE4ICsy
ODgsMjkgQEAgaW50IGhpZl9zdG9wX3NjYW4oc3RydWN0IHdmeF92aWYgKnd2aWYpCiAJcmV0dXJu
IHJldDsKIH0KIAotaW50IGhpZl9qb2luKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBjb25zdCBzdHJ1
Y3QgaGlmX3JlcV9qb2luICphcmcpCitpbnQgaGlmX2pvaW4oc3RydWN0IHdmeF92aWYgKnd2aWYs
IGNvbnN0IHN0cnVjdCBpZWVlODAyMTFfYnNzX2NvbmYgKmNvbmYsCisJICAgICBjb25zdCBzdHJ1
Y3QgaWVlZTgwMjExX2NoYW5uZWwgKmNoYW5uZWwsIGNvbnN0IHU4ICpzc2lkaWUpCiB7CiAJaW50
IHJldDsKIAlzdHJ1Y3QgaGlmX21zZyAqaGlmOwogCXN0cnVjdCBoaWZfcmVxX2pvaW4gKmJvZHkg
PSB3ZnhfYWxsb2NfaGlmKHNpemVvZigqYm9keSksICZoaWYpOwogCi0JbWVtY3B5KGJvZHksIGFy
Zywgc2l6ZW9mKHN0cnVjdCBoaWZfcmVxX2pvaW4pKTsKLQljcHVfdG9fbGUxNnMoJmJvZHktPmNo
YW5uZWxfbnVtYmVyKTsKLQljcHVfdG9fbGUxNnMoJmJvZHktPmF0aW1fd2luZG93KTsKLQljcHVf
dG9fbGUzMnMoJmJvZHktPnNzaWRfbGVuZ3RoKTsKLQljcHVfdG9fbGUzMnMoJmJvZHktPmJlYWNv
bl9pbnRlcnZhbCk7Ci0JY3B1X3RvX2xlMzJzKCZib2R5LT5iYXNpY19yYXRlX3NldCk7CisJV0FS
Tl9PTighY29uZi0+YmFzaWNfcmF0ZXMpOworCWJvZHktPmluZnJhc3RydWN0dXJlX2Jzc19tb2Rl
ID0gIWNvbmYtPmlic3Nfam9pbmVkOworCWJvZHktPnNob3J0X3ByZWFtYmxlID0gY29uZi0+dXNl
X3Nob3J0X3ByZWFtYmxlOworCWlmIChjaGFubmVsICYmIGNoYW5uZWwtPmZsYWdzICYgSUVFRTgw
MjExX0NIQU5fTk9fSVIpCisJCWJvZHktPnByb2JlX2Zvcl9qb2luID0gMDsKKwllbHNlCisJCWJv
ZHktPnByb2JlX2Zvcl9qb2luID0gMTsKKwlib2R5LT5jaGFubmVsX251bWJlciA9IGNwdV90b19s
ZTE2KGNoYW5uZWwtPmh3X3ZhbHVlKTsKKwlib2R5LT5iZWFjb25faW50ZXJ2YWwgPSBjcHVfdG9f
bGUzMihjb25mLT5iZWFjb25faW50KTsKKwlib2R5LT5iYXNpY19yYXRlX3NldCA9CisJCWNwdV90
b19sZTMyKHdmeF9yYXRlX21hc2tfdG9faHcod3ZpZi0+d2RldiwgY29uZi0+YmFzaWNfcmF0ZXMp
KTsKKwltZW1jcHkoYm9keS0+YnNzaWQsIGNvbmYtPmJzc2lkLCBzaXplb2YoYm9keS0+YnNzaWQp
KTsKKwlpZiAoIWNvbmYtPmlic3Nfam9pbmVkICYmIHNzaWRpZSkgeworCQlib2R5LT5zc2lkX2xl
bmd0aCA9IGNwdV90b19sZTMyKHNzaWRpZVsxXSk7CisJCW1lbWNweShib2R5LT5zc2lkLCAmc3Np
ZGllWzJdLCBzc2lkaWVbMV0pOworCX0KIAl3ZnhfZmlsbF9oZWFkZXIoaGlmLCB3dmlmLT5pZCwg
SElGX1JFUV9JRF9KT0lOLCBzaXplb2YoKmJvZHkpKTsKIAlyZXQgPSB3ZnhfY21kX3NlbmQod3Zp
Zi0+d2RldiwgaGlmLCBOVUxMLCAwLCBmYWxzZSk7CiAJa2ZyZWUoaGlmKTsKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90
eC5oCmluZGV4IDkyNGI4ODljYWQwYS4uMjA5NzdlNDYxNzE4IDEwMDY0NAotLS0gYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2hpZl90eC5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmgK
QEAgLTQ1LDcgKzQ1LDggQEAgaW50IGhpZl93cml0ZV9taWIoc3RydWN0IHdmeF9kZXYgKndkZXYs
IGludCB2aWZfaWQsIHUxNiBtaWJfaWQsCiBpbnQgaGlmX3NjYW4oc3RydWN0IHdmeF92aWYgKnd2
aWYsIHN0cnVjdCBjZmc4MDIxMV9zY2FuX3JlcXVlc3QgKnJlcTgwMjExLAogCSAgICAgaW50IGNo
YW5fc3RhcnQsIGludCBjaGFuX251bSk7CiBpbnQgaGlmX3N0b3Bfc2NhbihzdHJ1Y3Qgd2Z4X3Zp
ZiAqd3ZpZik7Ci1pbnQgaGlmX2pvaW4oc3RydWN0IHdmeF92aWYgKnd2aWYsIGNvbnN0IHN0cnVj
dCBoaWZfcmVxX2pvaW4gKmFyZyk7CitpbnQgaGlmX2pvaW4oc3RydWN0IHdmeF92aWYgKnd2aWYs
IGNvbnN0IHN0cnVjdCBpZWVlODAyMTFfYnNzX2NvbmYgKmNvbmYsCisJICAgICBjb25zdCBzdHJ1
Y3QgaWVlZTgwMjExX2NoYW5uZWwgKmNoYW5uZWwsIGNvbnN0IHU4ICpzc2lkaWUpOwogaW50IGhp
Zl9zZXRfcG0oc3RydWN0IHdmeF92aWYgKnd2aWYsIGJvb2wgcHMsIGludCBkeW5hbWljX3BzX3Rp
bWVvdXQpOwogaW50IGhpZl9zZXRfYnNzX3BhcmFtcyhzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAkJ
ICAgICAgIGNvbnN0IHN0cnVjdCBoaWZfcmVxX3NldF9ic3NfcGFyYW1zICphcmcpOwpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3Rh
LmMKaW5kZXggMzk1YTI4MjM0NmIxLi4zMGM2MmUzYjM3MTYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtNTEy
LDMyICs1MTIsMTkgQEAgc3RhdGljIHZvaWQgd2Z4X3NldF9tZnAoc3RydWN0IHdmeF92aWYgKnd2
aWYsCiAKIHN0YXRpYyB2b2lkIHdmeF9kb19qb2luKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQogewot
CWNvbnN0IHU4ICpic3NpZDsKKwlpbnQgcmV0OworCWNvbnN0IHU4ICpzc2lkaWU7CiAJc3RydWN0
IGllZWU4MDIxMV9ic3NfY29uZiAqY29uZiA9ICZ3dmlmLT52aWYtPmJzc19jb25mOwogCXN0cnVj
dCBjZmc4MDIxMV9ic3MgKmJzcyA9IE5VTEw7Ci0Jc3RydWN0IGhpZl9yZXFfam9pbiBqb2luID0g
ewotCQkuaW5mcmFzdHJ1Y3R1cmVfYnNzX21vZGUgPSAhY29uZi0+aWJzc19qb2luZWQsCi0JCS5z
aG9ydF9wcmVhbWJsZSA9IGNvbmYtPnVzZV9zaG9ydF9wcmVhbWJsZSwKLQkJLnByb2JlX2Zvcl9q
b2luID0gMSwKLQkJLmF0aW1fd2luZG93ID0gMCwKLQkJLmJhc2ljX3JhdGVfc2V0ID0gd2Z4X3Jh
dGVfbWFza190b19odyh3dmlmLT53ZGV2LAotCQkJCQkJICAgICAgY29uZi0+YmFzaWNfcmF0ZXMp
LAotCX07CiAKIAl3ZnhfdHhfbG9ja19mbHVzaCh3dmlmLT53ZGV2KTsKIAotCWlmICh3dmlmLT5j
aGFubmVsLT5mbGFncyAmIElFRUU4MDIxMV9DSEFOX05PX0lSKQotCQlqb2luLnByb2JlX2Zvcl9q
b2luID0gMDsKLQogCWlmICh3dmlmLT5zdGF0ZSkKIAkJd2Z4X2RvX3Vuam9pbih3dmlmKTsKIAot
CWJzc2lkID0gd3ZpZi0+dmlmLT5ic3NfY29uZi5ic3NpZDsKLQogCWJzcyA9IGNmZzgwMjExX2dl
dF9ic3Mod3ZpZi0+d2Rldi0+aHctPndpcGh5LCB3dmlmLT5jaGFubmVsLAotCQkJICAgICAgIGJz
c2lkLCBOVUxMLCAwLAorCQkJICAgICAgIGNvbmYtPmJzc2lkLCBOVUxMLCAwLAogCQkJICAgICAg
IElFRUU4MDIxMV9CU1NfVFlQRV9BTlksIElFRUU4MDIxMV9QUklWQUNZX0FOWSk7Ci0KIAlpZiAo
IWJzcyAmJiAhY29uZi0+aWJzc19qb2luZWQpIHsKIAkJd2Z4X3R4X3VubG9jayh3dmlmLT53ZGV2
KTsKIAkJcmV0dXJuOwpAQCAtNTQ1LDI5ICs1MzIsMTUgQEAgc3RhdGljIHZvaWQgd2Z4X2RvX2pv
aW4oc3RydWN0IHdmeF92aWYgKnd2aWYpCiAKIAltdXRleF9sb2NrKCZ3dmlmLT53ZGV2LT5jb25m
X211dGV4KTsKIAotCS8qIFNhbml0eSBjaGVjayBiYXNpYyByYXRlcyAqLwotCWlmICgham9pbi5i
YXNpY19yYXRlX3NldCkKLQkJam9pbi5iYXNpY19yYXRlX3NldCA9IDc7Ci0KIAkvKiBTYW5pdHkg
Y2hlY2sgYmVhY29uIGludGVydmFsICovCiAJaWYgKCF3dmlmLT5iZWFjb25faW50KQogCQl3dmlm
LT5iZWFjb25faW50ID0gMTsKIAotCWpvaW4uYmVhY29uX2ludGVydmFsID0gd3ZpZi0+YmVhY29u
X2ludDsKLQlqb2luLmNoYW5uZWxfbnVtYmVyID0gd3ZpZi0+Y2hhbm5lbC0+aHdfdmFsdWU7Ci0J
bWVtY3B5KGpvaW4uYnNzaWQsIGJzc2lkLCBzaXplb2Yoam9pbi5ic3NpZCkpOwotCi0JaWYgKCFj
b25mLT5pYnNzX2pvaW5lZCkgewotCQljb25zdCB1OCAqc3NpZGllOwotCi0JCXJjdV9yZWFkX2xv
Y2soKTsKKwlyY3VfcmVhZF9sb2NrKCk7CisJaWYgKCFjb25mLT5pYnNzX2pvaW5lZCkKIAkJc3Np
ZGllID0gaWVlZTgwMjExX2Jzc19nZXRfaWUoYnNzLCBXTEFOX0VJRF9TU0lEKTsKLQkJaWYgKHNz
aWRpZSkgewotCQkJam9pbi5zc2lkX2xlbmd0aCA9IHNzaWRpZVsxXTsKLQkJCW1lbWNweShqb2lu
LnNzaWQsICZzc2lkaWVbMl0sIGpvaW4uc3NpZF9sZW5ndGgpOwotCQl9Ci0JCXJjdV9yZWFkX3Vu
bG9jaygpOwotCX0KKwllbHNlCisJCXNzaWRpZSA9IE5VTEw7CiAKIAl3ZnhfdHhfZmx1c2god3Zp
Zi0+d2Rldik7CiAKQEAgLTU3OCw3ICs1NTEsOSBAQCBzdGF0aWMgdm9pZCB3ZnhfZG9fam9pbihz
dHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIAogCS8qIFBlcmZvcm0gYWN0dWFsIGpvaW4gKi8KIAl3dmlm
LT53ZGV2LT50eF9idXJzdF9pZHggPSAtMTsKLQlpZiAoaGlmX2pvaW4od3ZpZiwgJmpvaW4pKSB7
CisJcmV0ID0gaGlmX2pvaW4od3ZpZiwgY29uZiwgd3ZpZi0+Y2hhbm5lbCwgc3NpZGllKTsKKwly
Y3VfcmVhZF91bmxvY2soKTsKKwlpZiAocmV0KSB7CiAJCWllZWU4MDIxMV9jb25uZWN0aW9uX2xv
c3Mod3ZpZi0+dmlmKTsKIAkJd3ZpZi0+am9pbl9jb21wbGV0ZV9zdGF0dXMgPSAtMTsKIAkJLyog
VHggbG9jayBzdGlsbCBoZWxkLCB1bmpvaW4gd2lsbCBjbGVhciBpdC4gKi8KLS0gCjIuMjUuMAoK
