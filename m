Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5033B13BF8B
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732375AbgAOMOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:14:22 -0500
Received: from mail-bn7nam10on2041.outbound.protection.outlook.com ([40.107.92.41]:26034
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731673AbgAOMOV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:14:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGBmIEVWJI59VB40LyVj6Cg8QJYwopBJQSmF6fuv2LRt6arcIY/YyLnlxgTlg2fI3psUJaeT6cHba6vWKu9x7oOUoJf1JTJH2oTe5snrRxRSiHI0SR29oHD6irYbVz+aCBi6bp35i+LwaEU//tsQJZImx4x4X4WAJttLNMKbo5yYn/WVf65oIsmB+H6XInJlKhUSJU+o4N/IUCEluXy290VvpKQc0jtT3Llu9L1aECdVv7allKUg4wDMSRYtnOvpOLe0Dt8Zoei5EZ8iDLuGxmc8gJZJ43JUXG7psnJNy6WX48aWOYjwO0GLzERJzR/9um7Qv00sur5k+MZpsmZmYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+/BAwuFw3oM+BjgaBfIk2/+u4QYUxQhfRyJJYfrKBY=;
 b=YDpu+bDyxbsYbyPHjR//KOdfIDECL9gVkJG/WFINStllXuDBnmVW4+D9TnVTFFYoZcPZ7w2+85dR6+sKKMrFpF80/WTOYizNiOyvS3DiI5clEPRT/5XNFqg4dW0mD+Uhlt9ADhWq0XQA2IUmSUu/Jczo6AM/qmzZWfM8VgMNQQIKFbPkFw3kf2ATh0Z0UwcxhZqS47wgU8RZ+tlcj0oDkJnYCKxp2ZJWWRMpsybzxjqDphoYB8vC6GnI+LOz0BK7cEzCb3tEYGpBTnibXXFvrQ/Ts35Q/cz8qENxBqlHKJW/Qy45IyOFh7OXX9cmWGFrT9MXLRU786s7EZ4tINRHqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+/BAwuFw3oM+BjgaBfIk2/+u4QYUxQhfRyJJYfrKBY=;
 b=o1g9Ccf5TuWZteQeY5vpXNXtf7FuKu6IIq1KK8HRpE77GlvhKhyvlX9zzfabE9NnR3/m8adnlMPxWadp0sPWdvtjPqYB9U7oDO0/LtfPiJt/cMridDfO3Qc19g0tqruWawseLSp3JZVOXihal7NR4WcIzYXNd7DS9ZjB61KjRE8=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:14:08 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:14:08 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:13:29 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 61/65] staging: wfx: remove check for interface state
Thread-Topic: [PATCH 61/65] staging: wfx: remove check for interface state
Thread-Index: AQHVy50z6uIySu6Zi0W6oWxHuh7ezg==
Date:   Wed, 15 Jan 2020 12:13:30 +0000
Message-ID: <20200115121041.10863-62-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: fe8279a2-fbba-4dbf-2313-08d799b4559c
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3934B6399E07BB719242B40D93370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(6666004)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fS4QVqhQPFN2N6pyRLaMh3vGuN6wKkjn+DK0Ojoadblqwh+oIYH2MO28pCR7dMlKYfcr/6O3F5F6HOwQZz4EtSkBwVuwfkgYqeV93hUCKgA4wGTkQ2OSvs3PbFj2FlxgpGs2DXSKHaXFaOoya3nlQVobcTCL0qaF/6Mn9QkS/67hVEvaC9cUjE1zDYr+UMlzcC6BCqkmL3vzA6yOfZq5PYNs75OwZfiBUJu/INSTZcFC6DJmhxmKonD19v2BD6+YvuzN423ozeaAPqDZs8MEcj7fRujYVhg6MHFHJ1o7/pQQaeF6pmnabn9D9fm0rimeV25OMytgYGGVNwoOfwhvGdIwqynH/Oh+kJ/6ZeDWBwZS3NgYDZHWv2cIwKQTk4qGZ6X+IfgPwAGGGqznSCkH36vovkWO66I9ZeW9rk8ZgsZ8WybtLnA1suOSTR1khqSm
Content-Type: text/plain; charset="utf-8"
Content-ID: <AF6FDA8A7E09634B8EB1BC607C20CCAF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe8279a2-fbba-4dbf-2313-08d799b4559c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:13:30.7892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FDdIAR9iUq9JV5ZCSgp5XN9odbAGzeW+/9+dD8Sl1X5BdKRNuJoQbzrFgLnRK5MhxYHvpP4UNfim3V/thgujrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKT2J2
aW91c2x5LCB0aGUgdmFsdWUgb2Ygd3ZpZi0+c3RhdGUgYXMgbm8gcmVhc29uIHRvIGJlIHdyb25n
LiBBdCBsZWFzdCwKaWYgaXQgdGhlIGNhc2UsIGRyb3BwaW5nIHRoZSBmcmFtZSBpcyBwcm9iYWJs
eSBub3QgdGhlIGJhc3QgdGhpbmcgdG8gZG8uCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3Vp
bGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9xdWV1ZS5jIHwgNTAgKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMSBm
aWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDM4IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVl
dWUuYwppbmRleCBjODdkNjRmYmI4OGYuLmUwYzYwOWMzNWE3YiAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9zdGFnaW5nL3dmeC9xdWV1ZS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYwpA
QCAtMzY1LDUyICszNjUsMjYgQEAgc3RhdGljIGJvb2wgaGlmX2hhbmRsZV90eF9kYXRhKHN0cnVj
dCB3ZnhfdmlmICp3dmlmLCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLAogCXN0cnVjdCBpZWVlODAyMTFf
aGRyICpmcmFtZSA9IChzdHJ1Y3QgaWVlZTgwMjExX2hkciAqKSAocmVxLT5mcmFtZSArIHJlcS0+
ZGF0YV9mbGFncy5mY19vZmZzZXQpOwogCiAJZW51bSB7Ci0JCWRvX2Ryb3AsCiAJCWRvX3dlcCwK
IAkJZG9fdHgsCiAJfSBhY3Rpb24gPSBkb190eDsKIAotCXN3aXRjaCAod3ZpZi0+dmlmLT50eXBl
KSB7Ci0JY2FzZSBOTDgwMjExX0lGVFlQRV9TVEFUSU9OOgotCQlpZiAod3ZpZi0+c3RhdGUgPCBX
RlhfU1RBVEVfUFJFX1NUQSkKLQkJCWFjdGlvbiA9IGRvX2Ryb3A7Ci0JCWJyZWFrOwotCWNhc2Ug
Tkw4MDIxMV9JRlRZUEVfQVA6Ci0JCWlmICghd3ZpZi0+c3RhdGUpCi0JCQlhY3Rpb24gPSBkb19k
cm9wOwotCQlicmVhazsKLQljYXNlIE5MODAyMTFfSUZUWVBFX0FESE9DOgotCQlpZiAod3ZpZi0+
c3RhdGUgIT0gV0ZYX1NUQVRFX0lCU1MpCi0JCQlhY3Rpb24gPSBkb19kcm9wOwotCQlicmVhazsK
LQljYXNlIE5MODAyMTFfSUZUWVBFX01PTklUT1I6Ci0JZGVmYXVsdDoKLQkJYWN0aW9uID0gZG9f
ZHJvcDsKLQkJYnJlYWs7Ci0JfQotCi0JaWYgKGFjdGlvbiA9PSBkb190eCkgewotCQlpZiAoaWVl
ZTgwMjExX2lzX251bGxmdW5jKGZyYW1lLT5mcmFtZV9jb250cm9sKSkgewotCQkJbXV0ZXhfbG9j
aygmd3ZpZi0+YnNzX2xvc3NfbG9jayk7Ci0JCQlpZiAod3ZpZi0+YnNzX2xvc3Nfc3RhdGUpIHsK
LQkJCQl3dmlmLT5ic3NfbG9zc19jb25maXJtX2lkID0gcmVxLT5wYWNrZXRfaWQ7Ci0JCQkJcmVx
LT5xdWV1ZV9pZC5xdWV1ZV9pZCA9IEhJRl9RVUVVRV9JRF9WT0lDRTsKLQkJCX0KLQkJCW11dGV4
X3VubG9jaygmd3ZpZi0+YnNzX2xvc3NfbG9jayk7Ci0JCX0gZWxzZSBpZiAoaWVlZTgwMjExX2hh
c19wcm90ZWN0ZWQoZnJhbWUtPmZyYW1lX2NvbnRyb2wpICYmCi0JCQkgICB0eF9wcml2LT5od19r
ZXkgJiYKLQkJCSAgIHR4X3ByaXYtPmh3X2tleS0+a2V5aWR4ICE9IHd2aWYtPndlcF9kZWZhdWx0
X2tleV9pZCAmJgotCQkJICAgKHR4X3ByaXYtPmh3X2tleS0+Y2lwaGVyID09IFdMQU5fQ0lQSEVS
X1NVSVRFX1dFUDQwIHx8Ci0JCQkgICAgdHhfcHJpdi0+aHdfa2V5LT5jaXBoZXIgPT0gV0xBTl9D
SVBIRVJfU1VJVEVfV0VQMTA0KSkgewotCQkJYWN0aW9uID0gZG9fd2VwOworCWlmIChpZWVlODAy
MTFfaXNfbnVsbGZ1bmMoZnJhbWUtPmZyYW1lX2NvbnRyb2wpKSB7CisJCW11dGV4X2xvY2soJnd2
aWYtPmJzc19sb3NzX2xvY2spOworCQlpZiAod3ZpZi0+YnNzX2xvc3Nfc3RhdGUpIHsKKwkJCXd2
aWYtPmJzc19sb3NzX2NvbmZpcm1faWQgPSByZXEtPnBhY2tldF9pZDsKKwkJCXJlcS0+cXVldWVf
aWQucXVldWVfaWQgPSBISUZfUVVFVUVfSURfVk9JQ0U7CiAJCX0KKwkJbXV0ZXhfdW5sb2NrKCZ3
dmlmLT5ic3NfbG9zc19sb2NrKTsKKwl9IGVsc2UgaWYgKGllZWU4MDIxMV9oYXNfcHJvdGVjdGVk
KGZyYW1lLT5mcmFtZV9jb250cm9sKSAmJgorCQkgICB0eF9wcml2LT5od19rZXkgJiYKKwkJICAg
dHhfcHJpdi0+aHdfa2V5LT5rZXlpZHggIT0gd3ZpZi0+d2VwX2RlZmF1bHRfa2V5X2lkICYmCisJ
CSAgICh0eF9wcml2LT5od19rZXktPmNpcGhlciA9PSBXTEFOX0NJUEhFUl9TVUlURV9XRVA0MCB8
fAorCQkgICAgdHhfcHJpdi0+aHdfa2V5LT5jaXBoZXIgPT0gV0xBTl9DSVBIRVJfU1VJVEVfV0VQ
MTA0KSkgeworCQlhY3Rpb24gPSBkb193ZXA7CiAJfQogCiAJc3dpdGNoIChhY3Rpb24pIHsKLQlj
YXNlIGRvX2Ryb3A6Ci0JCXdmeF9wZW5kaW5nX3JlbW92ZSh3dmlmLT53ZGV2LCBza2IpOwotCQlo
YW5kbGVkID0gdHJ1ZTsKLQkJYnJlYWs7CiAJY2FzZSBkb193ZXA6CiAJCXdmeF90eF9sb2NrKHd2
aWYtPndkZXYpOwogCQlXQVJOX09OKHd2aWYtPndlcF9wZW5kaW5nX3NrYik7Ci0tIAoyLjI1LjAK
Cg==
