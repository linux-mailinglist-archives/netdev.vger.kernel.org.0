Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7816B13C446
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730325AbgAON4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:56:39 -0500
Received: from mail-eopbgr770047.outbound.protection.outlook.com ([40.107.77.47]:48566
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730070AbgAONzh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:55:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZiS2jNiwEz7W3N0WpprgGqc9O007RNQQjmfM5Ijkq7wA9wylJ53PgU2mlpopF+JCAriVgYxfFFXpeTcId8EkbasGWx7QNyeFHr6zYy3DrulXaAsmE0pP+vdQnp2cW0tga1wfLiMOS3bcgjyI1Nm56v4rj5VhU/xcDMXFcNUuTXqA0SnyVRTdlduj6W5tkDkQ+S5gBNW44A3OOecGAPkw0IGSPAUheTXlDFqmDe6512HtsgVcspaycXZkiZna2XfUbzZPrfMyQNthZWtBSAHS+n5ZmtMBCpXz9Qppz2fXtwkbOlTMQxmhYOfo1N3LfQoaF7AiL+9rSwX+0y/sJE3R5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UmO/Yds+wQjxAoNJsYyBWB9PInk2QVNVFM+uU35jfto=;
 b=FbJDq0dRGuxHVObp+nRo+9Z0wgTAK6+gYHe+dHKlPXNK1EtMOK09DAz/TaBqOurmth96DQLsgXfLAtV1s3uCHUAULZFWHfmCVOGnfAetH2vRpJA4gXEIMFpcuqOZu6yoP9J6URwAY4LTx5LbLbU7IpssIj/Zn43yxy6KwbbZRuaQODw7yc43lPAi8Eo5lSy9XjpAH3p57VDQEPYMCpecAR/qBP8+3kJmVHXZvCwsmVqUwNXtSjDxOXoJvCCoJ8KtY2gofQaw8tNkKe0oQZ1UVhBOzX205jZhC4YZVhbeOyOST9uucsw4Tm6Ond4nUTvUw7wyGwZccdqJb2Ys8tVXRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UmO/Yds+wQjxAoNJsYyBWB9PInk2QVNVFM+uU35jfto=;
 b=d58TlG5gTXl8mSy9TelM7LrWhTfXISIvBGi26SZ1hH04m9/fYekVtCPV1N8jj1Avls2H5EeWZ5CU1Fx9edE9dks1EMyFnSdqejKn/kAxs61TcamaObd0jKldMxXkzZT+eCF3mD5CazJGhcxqGPqnX4O13nZOuiFp9EaVO55jaQU=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:55:32 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:55:32 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:55:26 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 58/65] staging: wfx: simplify wfx_ps_notify_sta()
Thread-Topic: [PATCH v2 58/65] staging: wfx: simplify wfx_ps_notify_sta()
Thread-Index: AQHVy6twu/uvcTvD8kGM/YMWHj3tKA==
Date:   Wed, 15 Jan 2020 13:55:27 +0000
Message-ID: <20200115135338.14374-59-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 572f887c-7fc1-4501-1d62-08d799c2934c
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB36613092F3225079F1E9B38093370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1051;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(86362001)(2616005)(4326008)(66574012)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j86quizXNKF7fUtbUivewxCFMe/EhdLhQfVpNYRhOhlbC0n/ZQHXmbhdxb2G4HUPONiYQKLhRnrBT89aU9ui2LGcKaRZSe+Ks+iBvdsN4dGKNtbj12Jgtlktl5lfDqjRcV5B2qp5X6Hq7VIA9B5CASaeYRiceyEgPacMZS8qK9FEqObKDFu7TMzjK8I9i7IPoGrpmRnLrfpsaJcXC873pEtlNgUa68Do1MkppYrLMMnWH+4DLJ8gyNJG8Wgp0OHkwVH/SlSUojcRwc+p6K/ycPSLGF9Kbdhvgojm/1fQhO7jUB0J2FSrAS2N/GkyVbDvziXvaajwSKOjCpxjAHQMcFWixm5mmXqfLIUmT4Pc1SPTnUdmSAayJIyqA8vJAa/MIPltzsVMWwo6nX3xzEoXXFsi/MoLzCnhDkaBfhdB7SzViMzlACnJt+7yWV73P0qE
Content-Type: text/plain; charset="utf-8"
Content-ID: <2098BA4DEE2CD0498B80935CEDCCE4FF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 572f887c-7fc1-4501-1d62-08d799c2934c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:55:27.2347
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uzG50XLkoCMId1zN6P8GUCZRqSCFT4YlmHKQH9sEQSZ9wO8vK9abNaKhPxGxpHolHUlquvUWtHRdpwQp2drz7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X3BzX25vdGlmeV9zdGEoKSBpcyB0b28gY29tcGxleCBjb21wYXJlZCB0byB0aGUgdGFzayBpdCBk
by4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2ls
YWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIHwgMjQgKysrKysrLS0tLS0t
LS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAxOCBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYwppbmRleCBhOWI1OGU0YTlmYTMuLjAzZDBmMjI0ZmZkYiAxMDA2NDQK
LS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3N0YS5jCkBAIC04NDIsMjYgKzg0MiwxNCBAQCB2b2lkIHdmeF9ic3NfaW5mb19jaGFuZ2VkKHN0
cnVjdCBpZWVlODAyMTFfaHcgKmh3LAogc3RhdGljIHZvaWQgd2Z4X3BzX25vdGlmeV9zdGEoc3Ry
dWN0IHdmeF92aWYgKnd2aWYsCiAJCQkgICAgICBlbnVtIHN0YV9ub3RpZnlfY21kIG5vdGlmeV9j
bWQsIGludCBsaW5rX2lkKQogewotCXUzMiBiaXQsIHByZXY7Ci0KIAlzcGluX2xvY2tfYmgoJnd2
aWYtPnBzX3N0YXRlX2xvY2spOwotCWJpdCA9IEJJVChsaW5rX2lkKTsKLQlwcmV2ID0gd3ZpZi0+
c3RhX2FzbGVlcF9tYXNrICYgYml0OwotCi0Jc3dpdGNoIChub3RpZnlfY21kKSB7Ci0JY2FzZSBT
VEFfTk9USUZZX1NMRUVQOgotCQlpZiAoIXByZXYpIHsKLQkJCXd2aWYtPnN0YV9hc2xlZXBfbWFz
ayB8PSBiaXQ7Ci0JCX0KLQkJYnJlYWs7Ci0JY2FzZSBTVEFfTk9USUZZX0FXQUtFOgotCQlpZiAo
cHJldikgewotCQkJd3ZpZi0+c3RhX2FzbGVlcF9tYXNrICY9IH5iaXQ7Ci0JCQl3ZnhfYmhfcmVx
dWVzdF90eCh3dmlmLT53ZGV2KTsKLQkJfQotCQlicmVhazsKLQl9CisJaWYgKG5vdGlmeV9jbWQg
PT0gU1RBX05PVElGWV9TTEVFUCkKKwkJd3ZpZi0+c3RhX2FzbGVlcF9tYXNrIHw9IEJJVChsaW5r
X2lkKTsKKwllbHNlIC8vIG5vdGlmeV9jbWQgPT0gU1RBX05PVElGWV9BV0FLRQorCQl3dmlmLT5z
dGFfYXNsZWVwX21hc2sgJj0gfkJJVChsaW5rX2lkKTsKIAlzcGluX3VubG9ja19iaCgmd3ZpZi0+
cHNfc3RhdGVfbG9jayk7CisJaWYgKG5vdGlmeV9jbWQgPT0gU1RBX05PVElGWV9BV0FLRSkKKwkJ
d2Z4X2JoX3JlcXVlc3RfdHgod3ZpZi0+d2Rldik7CiB9CiAKIHZvaWQgd2Z4X3N0YV9ub3RpZnko
c3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYsCi0tIAoy
LjI1LjAKCg==
