Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A92C13C07D
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730597AbgAOMMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:12:36 -0500
Received: from mail-co1nam11on2084.outbound.protection.outlook.com ([40.107.220.84]:24056
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730514AbgAOMMc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UtjXnOTQoFtXGcJBowkj24VUUclcILk3p9DbpuApxggJVIUJVopXTMwZnt/BlotJ3cSAS0xBlNx5rPMNkbnWO86ZU8iAvuYVomuhuicjxos28CnXOJacF4+tjZH5Rckt/AMowi9XiP2MmtRl8vlFP0L7lfqFB4g0NCZ3IMkjU1tWZeiGGlkxEt03yxZVOo3iXm5x9Pw6O9n/EfOah8V91OXI3ESNkRfc4soII4tqkxIq8vFERsvU6hEg/sLsgc4ANNZVo+l5W4ZK8+3dPiCE6/oim22Igb+TYpjlJgVu8JOE0ccV8ME9KSKD2GDEPqDn8mrZEAlFRB5QK6FlCN7rpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+AJrNR5x6OaUELuP4bcANVom55NGF0XSik/Lq5n/m4E=;
 b=gw1K1ghqvUdqvK2fH5ymcgUO4ad8pzrgk4fY5HoD6PVJJJMxyg+CsSPU+0tgbSRQ/oHthEoQOEKGIxRYOOiMc1O71tmJ8kaSA8qe1keH76ON2nV33RRU91T8LX/PWzFr0zuAweeE5SZb9YogV8f2r3Pm9s79iN26jCGbGMg24SbgEPyyHYJryiXSOhcAFAV26Xd54wdVMCVof+pmMrIiNN5J7tNYidadiABA5GDJKjRgIGSf983rK7zZhy5WpnLEHscjvDQf1gOTskrUG8jEFU1ovtPTr9II/jJQeoqmWVt3vYSlwVIzzpmIkWgnK88M1VuZUYYhVFyYfqEIMUre1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+AJrNR5x6OaUELuP4bcANVom55NGF0XSik/Lq5n/m4E=;
 b=Lw8ZwO60VuF/tmMuhjPN93J3CEeIjVPq47vlKgR7iUiqXIJbplkgpnREdwOLxvGHIbDGJxqbB/+OBxPIzrmA7DlJMX4BWWJELn+i665Jf+WjgD1w36+TLURI9GUwWj6v3cTUOxInER05REGFuF/5gd2dm7OI5gRBnIEgWImkRzc=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:12:18 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:18 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:16 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 07/65] staging: wfx: simplify hif_set_rcpi_rssi_threshold()
 usage
Thread-Topic: [PATCH 07/65] staging: wfx: simplify
 hif_set_rcpi_rssi_threshold() usage
Thread-Index: AQHVy50H7H/1251ZlUKOU4Y3OcPyWQ==
Date:   Wed, 15 Jan 2020 12:12:17 +0000
Message-ID: <20200115121041.10863-8-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: f39b3520-71b1-40cf-40f4-08d799b42a30
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB39342C5E6A0D856C00B3B37293370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +1oqiJqvm/0YbLrkEZCBQGN9hSD0qUQUaPQUMas2rud6xkvNtXT+wGPi4++WUN101HRdxFL8tKozYPMaij00iSShzMmaoVMtA7p2d6VLN1MkwHNDV3b6jlufMGo9PGwiQtUrcZaRJ8qytHk2TMZJL8ImTFPX2iN9wpo5Z9YBwqu86HCc7lRUxdU674y96sOGxMtoWApQmXDKb2jtPoUS1AoWUP8ttoYqPtYWJEATVINh4G23AgaZI4EaV4GnCYdjnk8bhjIaycII4N85qxsbPRbEfaWMA5W+RAV4zz23ZSrTq1ZH/M2mmcas/GiwpvNGAbCNPTyy4+yc1MA4dSxBVQc+nNiZiiXflVmzSLQ+4nhwY/w0FCbW1I53z+QBfU/P0zVngLlTbXWPVwTo3RZn7d6nkqd2AEuIQamKorIKgFAZ80NXVS0jsO0M/19dSh7p
Content-Type: text/plain; charset="utf-8"
Content-ID: <847D589BD2517D49AE50D05C091C3662@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f39b3520-71b1-40cf-40f4-08d799b42a30
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:17.8951
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U4SjGGdD7UkGar3y3XOMX2gOjBw6j6R9Jo8vXvtQBwMXUGovOTqJWP4SCC7E5o7qccFJf12DdKwKAMipvv5jUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN0cnVjdHVyZSBoaWZfbWliX3JjcGlfcnNzaV90aHJlc2hvbGQgY29tZSBmcm9tIGhhcmR3YXJl
IEFQSS4gSXQgaXMKbm90IGludGVuZGVkIHRvIGJlIG1hbmlwdWxhdGVkIGluIHVwcGVyIGxheWVy
cyBvZiB0aGUgZHJpdmVyLgoKSW4gYWRkLCBjdXJyZW50IGNvZGUgZm9yIGhpZl9zZXRfcmNwaV9y
c3NpX3RocmVzaG9sZCgpIGlzIGR1bWIuIEl0CnNob3VsZCBwYWNrIGRhdGEgdXNpbmcgdGhlIGhh
cmR3YXJlIHJlcHJlc2VudGF0aW9uIGluc3RlYWQgb2YgbGVhdmluZwphbGwgd29yayB0byB0aGUg
Y2FsbGVyLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxl
ckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oIHwgMTkg
KysrKysrKysrKysrKysrKystLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyAgICAgICAgfCAy
NiArKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCAxOSBpbnNlcnRp
b25zKCspLCAyNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L2hpZl90eF9taWIuaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oCmluZGV4IDc0
OWRmNjcxMzFjMy4uYTgwODI1MDhmYmZkIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L2hpZl90eF9taWIuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaApAQCAt
NDQsMTAgKzQ0LDI1IEBAIHN0YXRpYyBpbmxpbmUgaW50IGhpZl9zZXRfYmVhY29uX3dha2V1cF9w
ZXJpb2Qoc3RydWN0IHdmeF92aWYgKnd2aWYsCiB9CiAKIHN0YXRpYyBpbmxpbmUgaW50IGhpZl9z
ZXRfcmNwaV9yc3NpX3RocmVzaG9sZChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKLQkJCQkJICAgICAg
c3RydWN0IGhpZl9taWJfcmNwaV9yc3NpX3RocmVzaG9sZCAqYXJnKQorCQkJCQkgICAgICBpbnQg
cnNzaV90aG9sZCwgaW50IHJzc2lfaHlzdCkKIHsKKwlzdHJ1Y3QgaGlmX21pYl9yY3BpX3Jzc2lf
dGhyZXNob2xkIGFyZyA9IHsKKwkJLnJvbGxpbmdfYXZlcmFnZV9jb3VudCA9IDgsCisJCS5kZXRl
Y3Rpb24gPSAxLAorCX07CisKKwlpZiAoIXJzc2lfdGhvbGQgJiYgIXJzc2lfaHlzdCkgeworCQlh
cmcudXBwZXJ0aHJlc2ggPSAxOworCQlhcmcubG93ZXJ0aHJlc2ggPSAxOworCX0gZWxzZSB7CisJ
CWFyZy51cHBlcl90aHJlc2hvbGQgPSByc3NpX3Rob2xkICsgcnNzaV9oeXN0OworCQlhcmcudXBw
ZXJfdGhyZXNob2xkID0gKGFyZy51cHBlcl90aHJlc2hvbGQgKyAxMTApICogMjsKKwkJYXJnLmxv
d2VyX3RocmVzaG9sZCA9IHJzc2lfdGhvbGQ7CisJCWFyZy5sb3dlcl90aHJlc2hvbGQgPSAoYXJn
Lmxvd2VyX3RocmVzaG9sZCArIDExMCkgKiAyOworCX0KKwogCXJldHVybiBoaWZfd3JpdGVfbWli
KHd2aWYtPndkZXYsIHd2aWYtPmlkLAotCQkJICAgICBISUZfTUlCX0lEX1JDUElfUlNTSV9USFJF
U0hPTEQsIGFyZywgc2l6ZW9mKCphcmcpKTsKKwkJCSAgICAgSElGX01JQl9JRF9SQ1BJX1JTU0lf
VEhSRVNIT0xELCAmYXJnLCBzaXplb2YoYXJnKSk7CiB9CiAKIHN0YXRpYyBpbmxpbmUgaW50IGhp
Zl9nZXRfY291bnRlcnNfdGFibGUoc3RydWN0IHdmeF9kZXYgKndkZXYsCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRl
eCAxMWUzM2E2ZDViYjUuLjMzOWFjYmNlOTZmYiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5n
L3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC0xMDMzLDMxICsx
MDMzLDkgQEAgdm9pZCB3ZnhfYnNzX2luZm9fY2hhbmdlZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpo
dywKIAkJaGlmX3Nsb3RfdGltZSh3dmlmLCBpbmZvLT51c2Vfc2hvcnRfc2xvdCA/IDkgOiAyMCk7
CiAKIAlpZiAoY2hhbmdlZCAmIEJTU19DSEFOR0VEX0FTU09DIHx8IGNoYW5nZWQgJiBCU1NfQ0hB
TkdFRF9DUU0pIHsKLQkJc3RydWN0IGhpZl9taWJfcmNwaV9yc3NpX3RocmVzaG9sZCB0aCA9IHsK
LQkJCS5yb2xsaW5nX2F2ZXJhZ2VfY291bnQgPSA4LAotCQkJLmRldGVjdGlvbiA9IDEsCi0JCX07
Ci0KIAkJd3ZpZi0+Y3FtX3Jzc2lfdGhvbGQgPSBpbmZvLT5jcW1fcnNzaV90aG9sZDsKLQotCQlp
ZiAoIWluZm8tPmNxbV9yc3NpX3Rob2xkICYmICFpbmZvLT5jcW1fcnNzaV9oeXN0KSB7Ci0JCQl0
aC51cHBlcnRocmVzaCA9IDE7Ci0JCQl0aC5sb3dlcnRocmVzaCA9IDE7Ci0JCX0gZWxzZSB7Ci0J
CQkvKiBGSVhNRSBJdCdzIG5vdCBhIGNvcnJlY3Qgd2F5IG9mIHNldHRpbmcgdGhyZXNob2xkLgot
CQkJICogVXBwZXIgYW5kIGxvd2VyIG11c3QgYmUgc2V0IGVxdWFsIGhlcmUgYW5kIGFkanVzdGVk
Ci0JCQkgKiBpbiBjYWxsYmFjay4gSG93ZXZlciBjdXJyZW50IGltcGxlbWVudGF0aW9uIGlzIG11
Y2gKLQkJCSAqIG1vcmUgcmVsaWFibGUgYW5kIHN0YWJsZS4KLQkJCSAqLwotCQkJLyogUlNTSTog
c2lnbmVkIFE4LjAsIFJDUEk6IHVuc2lnbmVkIFE3LjEKLQkJCSAqIFJTU0kgPSBSQ1BJIC8gMiAt
IDExMAotCQkJICovCi0JCQl0aC51cHBlcl90aHJlc2hvbGQgPSBpbmZvLT5jcW1fcnNzaV90aG9s
ZCArIGluZm8tPmNxbV9yc3NpX2h5c3Q7Ci0JCQl0aC51cHBlcl90aHJlc2hvbGQgPSAodGgudXBw
ZXJfdGhyZXNob2xkICsgMTEwKSAqIDI7Ci0JCQl0aC5sb3dlcl90aHJlc2hvbGQgPSBpbmZvLT5j
cW1fcnNzaV90aG9sZDsKLQkJCXRoLmxvd2VyX3RocmVzaG9sZCA9ICh0aC5sb3dlcl90aHJlc2hv
bGQgKyAxMTApICogMjsKLQkJfQotCQloaWZfc2V0X3JjcGlfcnNzaV90aHJlc2hvbGQod3ZpZiwg
JnRoKTsKKwkJaGlmX3NldF9yY3BpX3Jzc2lfdGhyZXNob2xkKHd2aWYsIGluZm8tPmNxbV9yc3Np
X3Rob2xkLAorCQkJCQkgICAgaW5mby0+Y3FtX3Jzc2lfaHlzdCk7CiAJfQogCiAJaWYgKGNoYW5n
ZWQgJiBCU1NfQ0hBTkdFRF9UWFBPV0VSICYmCi0tIAoyLjI1LjAKCg==
