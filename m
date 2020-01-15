Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFB613BF7D
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731887AbgAOMN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:13:56 -0500
Received: from mail-bn7nam10on2064.outbound.protection.outlook.com ([40.107.92.64]:33252
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731736AbgAOMNt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:13:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SkAph8WeGD/jFYrP/74XIq9c3cdFOa47TK8VNxJ9NQ0pPS7JbpWApn3c2yHsYBd5ZyQiolj0u2O50F+muaZW+Rel7V8/pw3WzjORHC4a4Bc3aZo4wsSMtOHCsHHlBReUgLx4SdmUmzW5rMatm7YbhHnfG2EBAFezxk1BnO/KUBOBi5hlDfbcFc/jhkRySH7aLVkATfUi0JJXccCbhG6Xca3FydocH9XY6OSZLenuHz0iXBn3pj7g958OjpGrpl4r/O9mBC7wR+BB7c+Xz58DE2nPGN05uW/zvct0Mb1wwiktEnSN9JA3g3WLK3XwMu0R88oShYvoQZOp9pLNJ3RDLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KdY34f6/5pVjPW8ktmpJGZ8wwaxZNv+zB55DXZmEGhY=;
 b=b888WijhZhKliOhj/Qbh8oXL2QXkiWZVVW57j+0587T644L8SDcYLCfSyMYtC6MXTZOTJS+tGoMYtpdS3DIHWFNJ35Vx2592VUgJ6rI8TWKOqozUBPqOJoVzyGAvdngkXZwRJ+JxD+HWi6i9N2/A8gDqCs2FEMbDlnTta/E9vxy90jvQ8aCcqqg6xuslf8YmaxPri6py0vsvl5b36ZrQEFbfZCeVYdlyGUqj2qPS4Mt2HBIAb24hn/0OWQAs2k7SwC1bYOXI3oxhd56b2bGZe5OT+XSzi7Qv9Nj1Ddf7eJeIZyGiyoDrTq0uJwzq0O1dYomd1ytX6/3Ol1tjyCyvpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KdY34f6/5pVjPW8ktmpJGZ8wwaxZNv+zB55DXZmEGhY=;
 b=Lbo3DgIAbqmtTTuD7u+FpTv5kbiAmAjah08gd2TrmH/84aI87703NfpDa58V3QeFBCWCjApyWF2Fh//WWWiZeT+1EgpV9oyJf3YnvAHFjr446pJI4GJsy1xwqAyj8wvqq8hoDUBQVE90Nn/D1kzYFCfYKsDZb7+ZD+Foder5o1Y=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:13:36 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:36 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:13:25 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 58/65] staging: wfx: simplify wfx_ps_notify_sta()
Thread-Topic: [PATCH 58/65] staging: wfx: simplify wfx_ps_notify_sta()
Thread-Index: AQHVy50w6TEiPc00BUGEr/tp+4T/ew==
Date:   Wed, 15 Jan 2020 12:13:26 +0000
Message-ID: <20200115121041.10863-59-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 810c92fb-a78c-46ac-e74f-08d799b45316
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3934F866E92F1AF7045A25DB93370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1051;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1o3AqzSkuwd3sVk/94c9kPZQLlZn/jaNlyNm8yMA019UzRlHciWykY6coaKVmFKMJBGEMvVtOpMj/mgDb4BgEz3d/4qFG44KADM1wXEFZ4BzGvt963Mey6EtTShvMgeLqHgpQqeb6p5vQdtzj4IhQyPVlUbWJg9k9YS4tXRAjOrztsxZRdWockAwez2kyFCxi9A+QbNjdDr203M36mtoj1AnaOveC2HjnM0wUQ5KhM6quHOLEpvHT0+4sIzya3zluhiwaHaa2GyTXhHDTz8izQdUYusFwKAj7Z/8Xq9rZfgjQjaAcF/gJCPS+wqZezwNO1D7sKMnS8bHp9xEmoKSbUCElYIzgEsHafsZ/I91iC5smIVZrQu5W9JaeoWko55NU3Nq5lFcQvdrW/03ATfdzJQ/tFCbmKInSHPQDuWOK8RRJ5xTZ87Zf+ZpaLL9LDmQ
Content-Type: text/plain; charset="utf-8"
Content-ID: <465800C37CFC0E4DABCD93C50CD4D0B8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 810c92fb-a78c-46ac-e74f-08d799b45316
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:13:26.5506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4O42KUlctC+cQN+TYEFimTvRYOGjLIkRW1fyPjxO7hfOi2anwphmUeqzjDeMHDXM1AtHs7fjQSYtiqwMvi0g4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
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
dGFnaW5nL3dmeC9zdGEuYwppbmRleCAwMWVlZTA2YTFlZjQuLjcyNjg4NDA5MTcwNiAxMDA2NDQK
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
