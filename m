Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5A1513BFFC
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731887AbgAOMRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:17:24 -0500
Received: from mail-bn7nam10on2085.outbound.protection.outlook.com ([40.107.92.85]:6101
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731173AbgAOMN2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:13:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LfQ3RMOqVT8LtW0sbsf5gAt9+OmNVhlr+DCaqYqbbL4n2hLmW2nVerqI0Si2TjbM9Z27zMkNwcsAWKJ3VL5ym2/BDO7X2GLkk0VBq8XonW+VjgSGgiCXJZ4pWdihoiDPCk914GFYzfUo1OI+qiRhD5t/J9MCa/zM3eILPpKcPSUHaAZIUMqN7ptfCf2hTCsRGbePpy7D1g4o5htwifNIraBau1/eeTQrzxJVw8x0wgqzYs29yfoIESjY7pzbRmd2pUn5ViRmOn+tQtKXW+p2F2TJjjiYtK+krEGeFYBy5ipnNVATGbwqrks/dPMm0mf82KyJAuAlYY/tp8BS+yIZ4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p7xw4WCj2d15OmRXMql5kVmIrhFJ5wVO8llOWfUVcAg=;
 b=NJdHTD4xtMtbXGiSsFSl8PMeofohy8TOKCTVBJIe9nysip+TwqRxeX69XIXUzrxdqWnueHLMqesimksfDdD+YpOQRfVDYODg0YisEcEogTitleOHkykM7tPrr2HGfcIhU3v8x86iDgJECa5c5almeAyEtHuyfwNnm2JJk8YXBmbzlP7xcS1bb7rib7KjwXYegtY80mm6vwlyYU2f+DjhG+RuWwzmXD1MoWVOx61ZFfqaYhjDV4u2JPt59o51mWu+aovENuHh1q469eC1ftK9S4dnC5sc6oz0B1BzgpRHb5AO73iEVzB1L/9I0ghHgnnZyrpZNZR0UJhImfLjilVhnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p7xw4WCj2d15OmRXMql5kVmIrhFJ5wVO8llOWfUVcAg=;
 b=BZzYWldJPihUjNluNMOcIHFgKycHDtb2avJnuof30NMxFpuxOFn0UfX/Uxl6MPyuJZBIKCwzwki5qISfn7uROqGEEqG96+Va4LoNl17Odkzq7b9UmNWf7EjdOn1Ymfv9NiBak4MlgJT7y8quYE0r8Jq8VLb1X8/ElJiW5H6wbf4=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:13:25 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:25 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:59 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 39/65] staging: wfx: simplify wfx_scan_complete()
Thread-Topic: [PATCH 39/65] staging: wfx: simplify wfx_scan_complete()
Thread-Index: AQHVy50hZQc7OdNZT0aVGeI+gFYOqA==
Date:   Wed, 15 Jan 2020 12:13:01 +0000
Message-ID: <20200115121041.10863-40-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 2d915965-17be-42d1-45f7-08d799b443e1
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB39344512AE77F3F5F5B8A54993370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(6666004)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M5UdNjyepYUXD5RottGyfoJ/k2yIxuZ0Bt+cagp+L7y+X25XC7DEmMHVkRlT2a3ZFqH0Tjcz7TOyzVg7VhM3Oc1WX+B7vaRynWr8KE/3lIsTIyGnpax7DZ/Dfr84tf+QE6wHKO0J15igctNFuV0BOTtSD9fF2cYYDFmybAqqedtqL+Avt17H13G9s4jErRhtfqjv6v7OGaUgla5/UOPv6jYq037iPxtFwVsUQMzM63qhKAiZ3bdt5jUgF1dL6V+o+gJ3eNevh+84aZlYJqpj9G3IONrNZBh7W8sU556xCj8B3bQhAUY47Sk3u11VAHLwXTW51UtqOKM39z8PnNh/zNYGEhZHVPyzxAcCm7vRRFXV4NWOEgWbfq8u5ooGNTIajF4tsimLx4tWzBtKrAerPJ/+A6UtntEPtlM8xHQ2hMvxE1basl8wuSW2e2/mqq2t
Content-Type: text/plain; charset="utf-8"
Content-ID: <921C9397FCAF7F4585AF0A224DE77616@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d915965-17be-42d1-45f7-08d799b443e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:13:01.0103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N7nJc6Tq3DCt3mx4c9YFuq/v701tQiYKQgasTm7t/tGWYFjQml/LoQqD3UUa17Hs1RLU2MdJY2md/Cm+qinz2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X3NjYW5fY29tcGxldGUoKSBkbyBub3RoaW5nIHdpdGggYXJndW1lbnQgaGlmX2luZF9zY2FuX2Nt
cGwuIEluIGFkZCwKaGlmX2luZF9zY2FuX2NtcGwgY29tZSBmcm9tIGhhcmR3YXJlIEFQSSBhbmQg
aXMgbm90IGV4cGVjdGVkIHRvIGJlIHVzZWQKd2l0aCB1cHBlciBsYXllcnMgb2YgdGhlIGRyaXZl
ci4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2ls
YWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jIHwgMyArLS0KIGRyaXZl
cnMvc3RhZ2luZy93Zngvc2Nhbi5jICAgfCAzICstLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zY2Fu
LmggICB8IDUgKy0tLS0KIDMgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCA4IGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMgYi9kcml2
ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jCmluZGV4IDQwODk2N2E0YzQ1Ny4uZjA0YWZjNmRiOWE1
IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jCisrKyBiL2RyaXZlcnMv
c3RhZ2luZy93ZngvaGlmX3J4LmMKQEAgLTIwMywxMCArMjAzLDkgQEAgc3RhdGljIGludCBoaWZf
c2Nhbl9jb21wbGV0ZV9pbmRpY2F0aW9uKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LAogCQkJCQljb25z
dCB2b2lkICpidWYpCiB7CiAJc3RydWN0IHdmeF92aWYgKnd2aWYgPSB3ZGV2X3RvX3d2aWYod2Rl
diwgaGlmLT5pbnRlcmZhY2UpOwotCWNvbnN0IHN0cnVjdCBoaWZfaW5kX3NjYW5fY21wbCAqYm9k
eSA9IGJ1ZjsKIAogCVdBUk5fT04oIXd2aWYpOwotCXdmeF9zY2FuX2NvbXBsZXRlKHd2aWYsIGJv
ZHkpOworCXdmeF9zY2FuX2NvbXBsZXRlKHd2aWYpOwogCiAJcmV0dXJuIDA7CiB9CmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nh
bi5jCmluZGV4IDVjYzlkZjVlYjZhMS4uNmUxZTUwMDQ4NjUxIDEwMDY0NAotLS0gYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3NjYW4uYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYwpAQCAt
MTI3LDggKzEyNyw3IEBAIHZvaWQgd2Z4X2NhbmNlbF9od19zY2FuKHN0cnVjdCBpZWVlODAyMTFf
aHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmKQogCWhpZl9zdG9wX3NjYW4od3ZpZik7
CiB9CiAKLXZvaWQgd2Z4X3NjYW5fY29tcGxldGUoc3RydWN0IHdmeF92aWYgKnd2aWYsCi0JCSAg
ICAgICBjb25zdCBzdHJ1Y3QgaGlmX2luZF9zY2FuX2NtcGwgKmFyZykKK3ZvaWQgd2Z4X3NjYW5f
Y29tcGxldGUoc3RydWN0IHdmeF92aWYgKnd2aWYpCiB7CiAJY29tcGxldGUoJnd2aWYtPnNjYW5f
Y29tcGxldGUpOwogfQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmggYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uaAppbmRleCBiYmE5ZjE1YTlmZjUuLjJlYjc4NmM5NTcy
YyAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmgKKysrIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9zY2FuLmgKQEAgLTEwLDggKzEwLDYgQEAKIAogI2luY2x1ZGUgPG5ldC9tYWM4
MDIxMS5oPgogCi0jaW5jbHVkZSAiaGlmX2FwaV9jbWQuaCIKLQogc3RydWN0IHdmeF9kZXY7CiBz
dHJ1Y3Qgd2Z4X3ZpZjsKIApAQCAtMTksNyArMTcsNiBAQCB2b2lkIHdmeF9od19zY2FuX3dvcmso
c3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKTsKIGludCB3ZnhfaHdfc2NhbihzdHJ1Y3QgaWVlZTgw
MjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwKIAkJc3RydWN0IGllZWU4MDIx
MV9zY2FuX3JlcXVlc3QgKnJlcSk7CiB2b2lkIHdmeF9jYW5jZWxfaHdfc2NhbihzdHJ1Y3QgaWVl
ZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZik7Ci12b2lkIHdmeF9zY2Fu
X2NvbXBsZXRlKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAotCQkgICAgICAgY29uc3Qgc3RydWN0IGhp
Zl9pbmRfc2Nhbl9jbXBsICppbmQpOwordm9pZCB3Znhfc2Nhbl9jb21wbGV0ZShzdHJ1Y3Qgd2Z4
X3ZpZiAqd3ZpZik7CiAKICNlbmRpZiAvKiBXRlhfU0NBTl9IICovCi0tIAoyLjI1LjAKCg==
