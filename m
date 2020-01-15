Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA57813BFC4
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731675AbgAOMQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:16:15 -0500
Received: from mail-bn7nam10on2041.outbound.protection.outlook.com ([40.107.92.41]:26034
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730891AbgAOMQO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:16:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iLponxSJEF6br/h/swea5p/IrRFOY/YHO2SHQ6/7RT6tdHsmX7seasBXpZF7GoTI/AkqNoBOkAXXjICgt594ioT5HR87h7LwnpMfA+4OBzBgR9j34/4In1i5Lp8e+chKUr6IEAcpN37EwJj/TlhtHPR3MjkhXu7VQBZDXnA/dmJaXazDwfxKwdVg5HoHNiWAWxal2l0gEuj3QqUL0PYAk8joVerxuBjlS6T7mYKevLRamJgV+Y1Ig2PCBk7If41aJeQeRX7XZcFO9EO9JPaR1nFZVdnXDio9yw1Ze5PdykPMdOdIv0ipVmuJrQtlQRfpkadRfr4i46Es1eTzZHfwPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BRdkCaupn/fgxCt3IoUfgFaos2qDQtkFasABJ9hW8nY=;
 b=knuzKRsx6nNJhin67XXHeIwlLKgAFsccVGf/M+z0Q1bQmsE2gl3q3atDokNMa+v8ogM9HygcIOmdOET/wKnQV8UVBz2VGxKCGKPpbJQ6c4mOsDyWjYu+ACBga1fUsBT/ZWk5oPvrKrDQPnuTkGwyiKWoL7hAlIU4jegNNK4NVRFakqzqS5PUhMiJ4PzV+Hdjb+BKiUUzAXASvZPjFIPWK3STWgZ4ikRykmEEEHVcgzhfdKlnl0hjmiOKcBX0uvAC46VMorf23gG/It7bz0Vsrzsh0QZtG6KV8pSGotw8vgG0dycwLyo+KGaCLzdQ0GF96Y/82TUaJxDgL8+f7JUHWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BRdkCaupn/fgxCt3IoUfgFaos2qDQtkFasABJ9hW8nY=;
 b=UNPs+pWL9vTakTDtIrIwEO6237OvRp+zUb83lO56RV9IKlP3MUBH0tjYvzdNvtM48IBB0dCffa6eRQlRMnJsG6mmFSUJD1UXufxD1exKdkcz9hhK90UQEg9x0fB69MInDgnpVgAEBKjT/UfgObjGLwkQda83xL1JdiKOgNsQoZo=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:14:10 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:14:10 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:13:31 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 62/65] staging: wfx: simplify hif_handle_tx_data()
Thread-Topic: [PATCH 62/65] staging: wfx: simplify hif_handle_tx_data()
Thread-Index: AQHVy500ydyKh/6ySEmSAtr/gZ90xg==
Date:   Wed, 15 Jan 2020 12:13:32 +0000
Message-ID: <20200115121041.10863-63-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 39480ecd-140c-4fc6-70a7-08d799b4566e
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3934CC8BC06A10A54AC8BEFE93370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pn1YoRD5L/3Ot1vGA4Dn2Zwp1h5jnthg1iP42Hw6f2a/EFz/81AwkdcBfkSwuw10Elj7QVNjy5aLQL6MrDAfZs8b8ZVOrKJLYdpDIv7pIglB9A5jr4x36es5fWAzxxCJ6yQHjWBv4jkK6id0jLOZqmCGRnH0KGWvGy8wDNzNexUXvVkKoDQgwTYWro3T1i6LKDMh1jQQvUiDuzCQg8K9e0zUVZPuZy2E/f2xYD76cGcQw/fWV3dlWsVEoI3mQXjYFvzOQ20dnnUGnUgZ2j4GayMJgLOPxRQQizfjIbGrmuTfY4ZlPXmqjgRebIKC6Ghkrw0Hs8hYGuKxw+qWX391L3txtKipxC0/GyUAEEv5HsbwumOAKu1OjJDVPPnBEFKsurDaZsR0T75CozmlvusAKx0MsXsWQ33gCdJmLWM/LYDKWIrYMR92uaH8fLQIh958
Content-Type: text/plain; charset="utf-8"
Content-ID: <271E883533FEAC44A75DD4C9AE41E05C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39480ecd-140c-4fc6-70a7-08d799b4566e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:13:32.1794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6C3JbunodojFvMqmYFUVBvrd8+JagsSNDKyrOeR/4ftJEt9H8IqNQhzQO3vD149L8QRpI2YaGrGDHcN6PKxKrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2lu
Y2UgZW51bSBhY3Rpb24gaGFzIG5vdyBvbmx5IHR3byBjYXNlcywgaXQgY2FuIGJlIGRyb3BwZWQu
IFRoZW4KaGlmX2hhbmRsZV90eF9kYXRhKCkgY2FuIGJlIHNpbXBsaWZpZWQuCgpTaWduZWQtb2Zm
LWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQog
ZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jIHwgNDAgKysrKysrKysrKysrKystLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyksIDI1IGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYyBiL2RyaXZl
cnMvc3RhZ2luZy93ZngvcXVldWUuYwppbmRleCBlMGM2MDljMzVhN2IuLjAyNDQ5N2ViMTlhYyAx
MDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCisrKyBiL2RyaXZlcnMvc3Rh
Z2luZy93ZngvcXVldWUuYwpAQCAtMzU5LDE2ICszNTksMTMgQEAgYm9vbCB3ZnhfdHhfcXVldWVz
X2lzX2VtcHR5KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQogc3RhdGljIGJvb2wgaGlmX2hhbmRsZV90
eF9kYXRhKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLAogCQkJICAg
ICAgIHN0cnVjdCB3ZnhfcXVldWUgKnF1ZXVlKQogewotCWJvb2wgaGFuZGxlZCA9IGZhbHNlOwot
CXN0cnVjdCB3ZnhfdHhfcHJpdiAqdHhfcHJpdiA9IHdmeF9za2JfdHhfcHJpdihza2IpOwogCXN0
cnVjdCBoaWZfcmVxX3R4ICpyZXEgPSB3Znhfc2tiX3R4cmVxKHNrYik7Ci0Jc3RydWN0IGllZWU4
MDIxMV9oZHIgKmZyYW1lID0gKHN0cnVjdCBpZWVlODAyMTFfaGRyICopIChyZXEtPmZyYW1lICsg
cmVxLT5kYXRhX2ZsYWdzLmZjX29mZnNldCk7Ci0KLQllbnVtIHsKLQkJZG9fd2VwLAotCQlkb190
eCwKLQl9IGFjdGlvbiA9IGRvX3R4OworCXN0cnVjdCBpZWVlODAyMTFfa2V5X2NvbmYgKmh3X2tl
eSA9IHdmeF9za2JfdHhfcHJpdihza2IpLT5od19rZXk7CisJc3RydWN0IGllZWU4MDIxMV9oZHIg
KmZyYW1lID0KKwkJKHN0cnVjdCBpZWVlODAyMTFfaGRyICopKHJlcS0+ZnJhbWUgKyByZXEtPmRh
dGFfZmxhZ3MuZmNfb2Zmc2V0KTsKIAorCS8vIEZJWE1FOiBtYWM4MDIxMSBpcyBzbWFydCBlbm91
Z2ggdG8gaGFuZGxlIEJTUyBsb3NzLiBEcml2ZXIgc2hvdWxkIG5vdAorCS8vIHRyeSB0byBkbyBh
bnl0aGluZyBhYm91dCB0aGF0LgogCWlmIChpZWVlODAyMTFfaXNfbnVsbGZ1bmMoZnJhbWUtPmZy
YW1lX2NvbnRyb2wpKSB7CiAJCW11dGV4X2xvY2soJnd2aWYtPmJzc19sb3NzX2xvY2spOwogCQlp
ZiAod3ZpZi0+YnNzX2xvc3Nfc3RhdGUpIHsKQEAgLTM3NiwzMSArMzczLDI0IEBAIHN0YXRpYyBi
b29sIGhpZl9oYW5kbGVfdHhfZGF0YShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0IHNrX2J1
ZmYgKnNrYiwKIAkJCXJlcS0+cXVldWVfaWQucXVldWVfaWQgPSBISUZfUVVFVUVfSURfVk9JQ0U7
CiAJCX0KIAkJbXV0ZXhfdW5sb2NrKCZ3dmlmLT5ic3NfbG9zc19sb2NrKTsKLQl9IGVsc2UgaWYg
KGllZWU4MDIxMV9oYXNfcHJvdGVjdGVkKGZyYW1lLT5mcmFtZV9jb250cm9sKSAmJgotCQkgICB0
eF9wcml2LT5od19rZXkgJiYKLQkJICAgdHhfcHJpdi0+aHdfa2V5LT5rZXlpZHggIT0gd3ZpZi0+
d2VwX2RlZmF1bHRfa2V5X2lkICYmCi0JCSAgICh0eF9wcml2LT5od19rZXktPmNpcGhlciA9PSBX
TEFOX0NJUEhFUl9TVUlURV9XRVA0MCB8fAotCQkgICAgdHhfcHJpdi0+aHdfa2V5LT5jaXBoZXIg
PT0gV0xBTl9DSVBIRVJfU1VJVEVfV0VQMTA0KSkgewotCQlhY3Rpb24gPSBkb193ZXA7CiAJfQog
Ci0Jc3dpdGNoIChhY3Rpb24pIHsKLQljYXNlIGRvX3dlcDoKKwkvLyBGSVhNRTogaWRlbnRpZnkg
dGhlIGV4YWN0IHNjZW5hcmlvIG1hdGNoZWQgYnkgdGhpcyBjb25kaXRpb24uIERvZXMgaXQKKwkv
LyBoYXBwZW4geWV0PworCWlmIChpZWVlODAyMTFfaGFzX3Byb3RlY3RlZChmcmFtZS0+ZnJhbWVf
Y29udHJvbCkgJiYKKwkgICAgaHdfa2V5ICYmIGh3X2tleS0+a2V5aWR4ICE9IHd2aWYtPndlcF9k
ZWZhdWx0X2tleV9pZCAmJgorCSAgICAoaHdfa2V5LT5jaXBoZXIgPT0gV0xBTl9DSVBIRVJfU1VJ
VEVfV0VQNDAgfHwKKwkgICAgIGh3X2tleS0+Y2lwaGVyID09IFdMQU5fQ0lQSEVSX1NVSVRFX1dF
UDEwNCkpIHsKIAkJd2Z4X3R4X2xvY2sod3ZpZi0+d2Rldik7CiAJCVdBUk5fT04od3ZpZi0+d2Vw
X3BlbmRpbmdfc2tiKTsKLQkJd3ZpZi0+d2VwX2RlZmF1bHRfa2V5X2lkID0gdHhfcHJpdi0+aHdf
a2V5LT5rZXlpZHg7CisJCXd2aWYtPndlcF9kZWZhdWx0X2tleV9pZCA9IGh3X2tleS0+a2V5aWR4
OwogCQl3dmlmLT53ZXBfcGVuZGluZ19za2IgPSBza2I7CiAJCWlmICghc2NoZWR1bGVfd29yaygm
d3ZpZi0+d2VwX2tleV93b3JrKSkKIAkJCXdmeF90eF91bmxvY2sod3ZpZi0+d2Rldik7Ci0JCWhh
bmRsZWQgPSB0cnVlOwotCQlicmVhazsKLQljYXNlIGRvX3R4OgotCQlicmVhazsKLQlkZWZhdWx0
OgotCQkvKiBEbyBub3RoaW5nICovCi0JCWJyZWFrOworCQlyZXR1cm4gdHJ1ZTsKKwl9IGVsc2Ug
eworCQlyZXR1cm4gZmFsc2U7CiAJfQotCXJldHVybiBoYW5kbGVkOwogfQogCiBzdGF0aWMgaW50
IHdmeF9nZXRfcHJpb19xdWV1ZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKLS0gCjIuMjUuMAoK
