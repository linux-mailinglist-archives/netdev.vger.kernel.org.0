Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7021913C074
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730692AbgAOMMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:12:41 -0500
Received: from mail-co1nam11on2084.outbound.protection.outlook.com ([40.107.220.84]:24056
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730667AbgAOMMj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CLcXEH/zSiNuU9B5w5J1iM/Ius5BvdDN45Nr8zGQLpyqbXPhmo4AoY4CTP4gOarYb54JjqzgTDA3w+i+f7Vutr524fSEFCKFcMkOkFW6hziDKyMKyTtMz9jiOgCXo/9I1tCl4hloVovE5TQD2wVl0c2dLqTAndbKoWEwNKagqKNRSa71v8+we3grQx614gsge1Zd/7YiR8yu2jNTD/nvr4Pdxe9+CAiUTTeCzNPGaMuEJvpknyF+dtjr0YiJhWuPAgIS/ueQLb+yMxOValV67U1gRiCCDQWb7tosa3v51r/OCtXzrYMZEg3ZSa4CA6Rz4JepchnhC9N66+4cpyXofw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMWYso2kX8M/LHUfsTraTHNa5REJyaaYdjFoAPnNI5Q=;
 b=P8zW3f9A4KwyB5uFYclpq4PSloFykOPDNVvijgp54zYq/jNTLiPEA3VHhlJRPn/j5jAO5vCAJOw4e1H1agEdNoNpgVdEdNSF20TBqDAyQGKhrN1JSnQRypciKj2e1abIEN2hlcSUaBySq/BDMtIGivTFHGRFP1mJ0j6c3N5WPxm7iUZCtNTj6AP/YzvwESYP3FJSndJMAKOw/NEgg3wgUHKvaFPgHpNJsMu4YkfeUxarHMRVYX//QiDKtgr5Bm/xNNvJJeEeiYg9P5RYeivPYT961iTQ932g56j16XTejCqsSclzkWLzy9QyvfcWOOqV0UT9fLqNyaDRmpdsIlX2Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMWYso2kX8M/LHUfsTraTHNa5REJyaaYdjFoAPnNI5Q=;
 b=VK3jC2GOzuvt4WSgzvVJw4YyMMJesLC5efgOlnKtMmQKk8z+MX663FE7pAg2fIyL3Z7ny8eOEFXlD6zMKSKgZ6gTXTNh1PfaXOVeCQimHqWzIJwvppBWq69Jg8r1GCbKErt6rhgMXT482YXlsPljobPdYggNDMBtt5eKGEqQCf0=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:12:29 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:29 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:28 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 15/65] staging: wfx: simplify wfx_config()
Thread-Topic: [PATCH 15/65] staging: wfx: simplify wfx_config()
Thread-Index: AQHVy50O4xaOBsjVYU+xG4wx4XJeDg==
Date:   Wed, 15 Jan 2020 12:12:29 +0000
Message-ID: <20200115121041.10863-16-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 8837c3d2-bc35-4e14-c0e2-08d799b430fa
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3934D4F86469A7BFF7C46BEC93370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jIe7Jt4wN3GifHGqGBJZJJATusXENXbTwabQLGNy2JU2CxcYv3AryoghVyXlma2x+61LwIhYOyA4QwGpOF5sjSgzJwTDlknzt1pHcjyKhtcsdQL+2ieobt6f+4/zzh2BXKSBXLy2LcNJdL3Fh0+IxHjUtYmK1lOP2mQenhh2e0QmxLxeUjGSUbFnjgnqGoXT5XC6OXc8SemmVk8Ggd7u3wSmfBpzgagi4kzW7eAjnQ3yRtGV4ZoGucYWxE/EvWDBSRfp7IeSfn4g88drUHT4MD7Jvtts00a8IBmwDf+g/61jpIzk9HdYM+eOBV9F6QIOt05YDy3I1pxiVJhOa5Z291rYwmXHbkUqF/iAkcrKxukJRowRdS7s8UUtiABGu5wIxK8lBEje1c3s4Qp113Lcs0rfu94Caf/Q53UNjYD7u7TZMlzAXDo3Nzhg2zEgcJps
Content-Type: text/plain; charset="utf-8"
Content-ID: <B43688B6C0F9E4419F32199BCDF431B3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8837c3d2-bc35-4e14-c0e2-08d799b430fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:29.2946
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XLeTU/V2R9RNWhpW5ZEMFKpJw4GFOYLUUbtluf2p+t6AtEqrJzNpHZmdlW5fd1wZQoQhPkQjt8B9AhF8J6QlVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKTm93
IHRoYXQgd2Z4X2NvbmZpZygpIG9ubHkgaGFuZGxlcyBJRUVFODAyMTFfQ09ORl9DSEFOR0VfUFMs
IGl0IGNhbiBiZQpzaW1wbGlmaWVkLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIg
PGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3Rh
LmMgfCAxMyArKy0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAx
MSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIv
ZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCBhMGYxOWQzM2U5NzIuLjQ1MWQwMTA4YTFi
MCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3N0YS5jCkBAIC0xMjMwLDIyICsxMjMwLDEzIEBAIGludCB3ZnhfY29uZmlnKHN0
cnVjdCBpZWVlODAyMTFfaHcgKmh3LCB1MzIgY2hhbmdlZCkKIAlzdHJ1Y3Qgd2Z4X2RldiAqd2Rl
diA9IGh3LT5wcml2OwogCXN0cnVjdCB3ZnhfdmlmICp3dmlmOwogCi0JLy8gRklYTUU6IEludGVy
ZmFjZSBpZCBzaG91bGQgbm90IGJlZW4gaGFyZGNvZGVkCi0Jd3ZpZiA9IHdkZXZfdG9fd3ZpZih3
ZGV2LCAwKTsKLQlpZiAoIXd2aWYpIHsKLQkJV0FSTigxLCAiaW50ZXJmYWNlIDAgZG9lcyBub3Qg
ZXhpc3QgYW55bW9yZSIpOwotCQlyZXR1cm4gMDsKLQl9Ci0KLQltdXRleF9sb2NrKCZ3ZGV2LT5j
b25mX211dGV4KTsKIAlpZiAoY2hhbmdlZCAmIElFRUU4MDIxMV9DT05GX0NIQU5HRV9QUykgewor
CQltdXRleF9sb2NrKCZ3ZGV2LT5jb25mX211dGV4KTsKIAkJd3ZpZiA9IE5VTEw7CiAJCXdoaWxl
ICgod3ZpZiA9IHd2aWZfaXRlcmF0ZSh3ZGV2LCB3dmlmKSkgIT0gTlVMTCkKIAkJCXJldCA9IHdm
eF91cGRhdGVfcG0od3ZpZik7Ci0JCXd2aWYgPSB3ZGV2X3RvX3d2aWYod2RldiwgMCk7CisJCW11
dGV4X3VubG9jaygmd2Rldi0+Y29uZl9tdXRleCk7CiAJfQotCi0JbXV0ZXhfdW5sb2NrKCZ3ZGV2
LT5jb25mX211dGV4KTsKIAlyZXR1cm4gcmV0OwogfQogCi0tIAoyLjI1LjAKCg==
