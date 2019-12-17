Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC6C12322C
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbfLQQOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:14:44 -0500
Received: from mail-eopbgr680046.outbound.protection.outlook.com ([40.107.68.46]:59543
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728419AbfLQQOk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:14:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dPZXVAmDtp4MUAgnt+hI7+Y55sx29UDw3sE8FE45HJ5sHA0QCafp4eF1kDJwTsw1UPqjwoInWXJgeALfnr8IdeLjvPKIV8Tpf28PekE7xpkzx3/6WLeAAIm05K6NCj9TAGDCtCQol4AEc0q3WThg9ycKZdTY/TRydYufElwwQEbSBbo7HUSW0e56wM+v3iOSovEInF/rCTckV6vGgT+fR/75WmYGAKn/27n3kqjF9jcz6K6w2mya2zT8ybUudzoxF4rnsQfmG1yprHRnpuWEqJTRrJ0eXShsaqd7BdCEakSP3Hms2cXRW0gicRlIxLgoo+jEovTXjwenOjMHsZNX3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iAWqkFdigmw4vHi00yhGVa3Yk42MHGcrKV2JTpUIO70=;
 b=dn6DWWCjPvTJ1qO04N5WNAonV5tp4vXzLmdefy0BAStrQxiK4662NzmcSSETKpdNuIhfrWURkZGBAI0INVvGEw8hZc1A84LajJ93+5/nVZM+uouuW2nNG7N26b7n73h4MiPP+YR8j+Z3Am/CjA2EgXeK8H1Ny+yKpFyVQ1lQDxIA1xO92VYi56g4Ir9bgB4JjdSH0Tdawxi3y8uHUObjBXqqmD40QLIMuMAxiGTz75jBbsa+TNO9aVHrqRnEXF1qyLKlHoS+ItAOCm/NXQlygGvLHiSOfVuZ+z1s8wfNFSLkMXvAyhBsmJVzvDoA3gPwhZWpynGPrn77giS6e2JcjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iAWqkFdigmw4vHi00yhGVa3Yk42MHGcrKV2JTpUIO70=;
 b=h+3IXTKK4QvkTCDry+qkYqil0uUq6vvT4vMDYYlsUK/yrAwzR6ezqwdyxzKgtjRe9eSeLmXE3SWGfmtAHAHAZvJZXBiOCQtsSxWLwR/4Wj1lg9XYC8kbESgy9Fp3/TvMe5uci6ZgkCczcHlPj+OsH8MVqTnd08bOhN5xE/4KEts=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3791.namprd11.prod.outlook.com (20.178.254.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 16:14:36 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:14:36 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 07/55] staging: wfx: ensure that retry policy always
 fallbacks to MCS0 / 1Mbps
Thread-Topic: [PATCH v2 07/55] staging: wfx: ensure that retry policy always
 fallbacks to MCS0 / 1Mbps
Thread-Index: AQHVtPUT+yUvhYCIm0KyGJu97eaKNA==
Date:   Tue, 17 Dec 2019 16:14:36 +0000
Message-ID: <20191217161318.31402-8-Jerome.Pouiller@silabs.com>
References: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0174.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.24.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc678263-495c-4532-b880-08d7830c35a4
x-ms-traffictypediagnostic: MN2PR11MB3791:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB37911A75BD8A4DC35D2A9F0593500@MN2PR11MB3791.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(366004)(346002)(136003)(39860400002)(189003)(199004)(2906002)(52116002)(107886003)(2616005)(86362001)(478600001)(6486002)(4326008)(64756008)(66556008)(66476007)(81156014)(66946007)(6506007)(1076003)(316002)(66446008)(8936002)(71200400001)(81166006)(5660300002)(36756003)(26005)(186003)(8676002)(85202003)(85182001)(110136005)(54906003)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3791;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: leZLjiVrzJfidGWQITFSyNjWBRCkCBfIiITNV2890hNPHJKwqxBpfUqNdTau0q7wIkN8Qhf1sY5+I4pztaz1OorVffkmULM9mpkGbIcDyd4dxD6d+vtIMIbJCZr8ZTRdnvQ0sU7tuwmpuZi5imaKOGbQCT378vZetxu6u+RNY+Ef7o3GqdXhY9xgEXQJp6Ok6iPnMu/ds1Er9BAcjnouI6aCMJ8Uo388iaeM17woHblu3J1dkfgI2H0vf13cd5HEwug4w1tvlmfpKoeZY3TLzo1pBbxRBsBLQWR+7pTcRx1oKvWRzZE/ackJnyhD/J8NsACRLXbuxwiGSvSJ6wZacwh3dLwJu6QOrfhtaW43+Rln7FiVCWkGarZgs7FI7Pgh2SZyKJlLcfimv9ybbB7o7I2WfsajS6spHLSpnrKZqU3qejy8UbK3Vt3JD/MvqufZ
Content-Type: text/plain; charset="utf-8"
Content-ID: <9D60EB79FDE4ED4DA3DE161AAD87AE13@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc678263-495c-4532-b880-08d7830c35a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:14:36.0547
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +6LO3KIpEs+uh+fi0grOjai9/n4fzk3hqgymL5TLWYY0smfn+nWoO4ExYbXaFCMIuEQ1/MeZnWrfuyZAaMXjuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3791
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2hl
biBub3QgdXNpbmcgSFQgbW9kZSwgbWluc3RyZWwgYWx3YXlzIGluY2x1ZGVzIDFNYnBzIGFzIGZh
bGxiYWNrIHJhdGUuCkJ1dCwgd2hlbiB1c2luZyBIVCBtb2RlLCB0aGlzIGZhbGxiYWNrIGlzIG5v
dCBpbmNsdWRlZC4gWWV0LCBpdCBzZWVtcwp0aGF0IGl0IGNvdWxkIHNhdmUgc29tZSBmcmFtZXMu
IFNvLCB0aGlzIHBhdGNoIGFkZCBpdCB1bmNvbmRpdGlvbmFsbHkuCgpTaWduZWQtb2ZmLWJ5OiBK
w6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVy
cy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMgfCAxMSArKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQs
IDExIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFf
dHguYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCmluZGV4IDQ2YWQ4M2I5NWY1Mi4u
NzM4YTZjYTVlZGFkIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYwor
KysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYwpAQCAtNTM4LDYgKzUzOCwxNyBAQCBz
dGF0aWMgdm9pZCB3ZnhfdHhfZml4dXBfcmF0ZXMoc3RydWN0IGllZWU4MDIxMV90eF9yYXRlICpy
YXRlcykKIAkJCX0KIAkJfQogCX0gd2hpbGUgKCFmaW5pc2hlZCk7CisJLy8gRW5zdXJlIHRoYXQg
TUNTMCBvciAxTWJwcyBpcyBwcmVzZW50IGF0IHRoZSBlbmQgb2YgdGhlIHJldHJ5IGxpc3QKKwlm
b3IgKGkgPSAwOyBpIDwgSUVFRTgwMjExX1RYX01BWF9SQVRFUzsgaSsrKSB7CisJCWlmIChyYXRl
c1tpXS5pZHggPT0gMCkKKwkJCWJyZWFrOworCQlpZiAocmF0ZXNbaV0uaWR4ID09IC0xKSB7CisJ
CQlyYXRlc1tpXS5pZHggPSAwOworCQkJcmF0ZXNbaV0uY291bnQgPSA4OyAvLyA9PSBody0+bWF4
X3JhdGVfdHJpZXMKKwkJCXJhdGVzW2ldLmZsYWdzID0gcmF0ZXNbaSAtIDFdLmZsYWdzICYgSUVF
RTgwMjExX1RYX1JDX01DUzsKKwkJCWJyZWFrOworCQl9CisJfQogCS8vIEFsbCByZXRyaWVzIHVz
ZSBsb25nIEdJCiAJZm9yIChpID0gMTsgaSA8IElFRUU4MDIxMV9UWF9NQVhfUkFURVM7IGkrKykK
IAkJcmF0ZXNbaV0uZmxhZ3MgJj0gfklFRUU4MDIxMV9UWF9SQ19TSE9SVF9HSTsKLS0gCjIuMjQu
MAoK
