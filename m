Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B96CC13C433
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730092AbgAON5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:57:05 -0500
Received: from mail-eopbgr770088.outbound.protection.outlook.com ([40.107.77.88]:50046
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730234AbgAON4q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:56:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ExLuEw+2TlRz8j/b528rDctYLrl3YcokjgQL/OI9SrYT8c71NzlMKzw4EDLHkmQbqtTV5T/QHpt8/d3EtxEZ/DV841Rtjky29FOCnPczKzr6PN/I69fYCe9n8kPU4/JdglBjtZzzyNNSM66sC9LElyqBqQSsqrXXV/rhYBwMNk3yXqxIG1Oij95Kh9fkFpw8PcX8sghDZe2D8pPJHgPPgAIh14QUYpo9XsB9Dft2nxv33bJ5kl7wonBY17E1bqxBw6qPqBMWaohcJoT0fuKrl80sXPBYaIbyYtsV52HCGWNgHFDBKzC3xtn0o8XCpzmFHVNbhyKz3udsEBMy1h7rtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+/BAwuFw3oM+BjgaBfIk2/+u4QYUxQhfRyJJYfrKBY=;
 b=YSXjLl6aq1cGMCbi+mk9BwVNaVi6GpUbtLShZnvqhEB8M7vZ6e9LObuUgyXb6Z1n+mQjt0mMTO+0kGXZ9kSBEt/Jblv3NVllMKs6VNP1YGGMM3k29x4Nw6Z9IVb5ufmf9F6Ph1ECPBE5oP0WICFZtreYNMp6I7HTdGq5f45nslS8R3a9zttO87wyOTPY1f+Rd9VxvtynJB0Vjr0ikR2L4oLtYGuLNb1EeRzSeOFaq+ArJQvk7jor00TOPAb246NJrFu2C7uD6Nvwx3Kqt5f+tyHJf/WYoHiuNxE5G3NDmD3BJSDGbp9/KqypAdDTzAn0ugTAdS2202raeWswsIMIeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+/BAwuFw3oM+BjgaBfIk2/+u4QYUxQhfRyJJYfrKBY=;
 b=K6GqlOutUkOFuyhCqGMOKMGVYH3+KDBNT71yx7YgVAO909vv9rO48JP0OY1ZXF2G8FyQ/El08CHmntLlCbWQWTjeR4D2HX+58RfU+vK/7b3SiZ/+wHsWn7+1bqDGGeKKIlX3yclKReUQ16Ax1udc4T0cSLS9UL71ixytUpfnXoE=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:56:03 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:56:03 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:55:30 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 61/65] staging: wfx: remove check for interface state
Thread-Topic: [PATCH v2 61/65] staging: wfx: remove check for interface state
Thread-Index: AQHVy6tzXJTFixt9U06ldCRLTp9o5Q==
Date:   Wed, 15 Jan 2020 13:55:31 +0000
Message-ID: <20200115135338.14374-62-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: b7861af3-8326-4d50-40d0-08d799c29621
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3661E08E20F00B64CE3306E593370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(86362001)(2616005)(4326008)(66574012)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t4H8QimaO20ythzfnxTckLYlpxFfVc4HT9Qwvu205kxvYpHHIGa8ltcKHIdaF3VQB0m7tVWf/fUGKzEX9bDKEgeKZr3MK8mvJ8v6iZ9D6UhYE0VcGqle6NGFHrqKl8992Y8ihLFZmRmMgta0EhjwfEupNgfPw+5mWY+5DABw0Qt6isZuzV9/NApfBR3IQfItkOj5tFDNjn226j8/+4gjEoBueBpLA+C2818XzvR3A90u6+9K15ZT0rCMEYr1j9XNGjhq+i9o7bZC+r4j4VF3x/qVHX3MDApqwdDgmpOZNF49sRiKuGSVmTfU/nSvDYTGxR5ItClzeCKeblEyOfPw0Y2sbYmHP7TwM4F9RI+bNT8Y12x3owfdagZ33ZWdZpP5dr6QcmbogYKtLamw4+X1bzpbafyxz2v5PV3vLgOiHTfiAw9mNH92iuzlwtUcJd0t
Content-Type: text/plain; charset="utf-8"
Content-ID: <14972A9EE59FC0498A2088F05E9CEB3C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7861af3-8326-4d50-40d0-08d799c29621
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:55:31.9570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FDBvEQInh/ujdToX+ppvszbMYv8XbbIx5He3WsKciVTM3GMzYTvnkgSqQSJXzZFW6zqO0cBzxQBGA8dz0jSZUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
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
