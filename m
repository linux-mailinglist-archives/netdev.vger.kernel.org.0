Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E56C13C3E0
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbgAONzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:55:21 -0500
Received: from mail-eopbgr770084.outbound.protection.outlook.com ([40.107.77.84]:58049
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729406AbgAONzU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:55:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BzzccLf8qHj2zxB5YJAfKk3THBcNExTSOuPO0SVlDT9ShBZ36Cbcp3BWhfpdVGOT+AoyJ6BqA+vmMcqig89tWOFevZFP+pdlXebOyIXYdmMWqsVTKst3inaQPimWjJztzpUdOh9EI9HojS1/wQBvFXk3d+VCqGNdORsEJF6FC0R9+U+G9KU8TL+Su6sspc2RXmrxvI7ZJB7+RyzhgftmqDTtXa9GbgmmbJIBlN1Er/So1F9n1W9GbvjmaWScA5yOU+LU5NRTuPs5mkp9p8sSOJgudBUJ2We47yY2kxdJcXeJtTWvJ9gy5uQDq00lTS0a7NsfF8CUl83Hq3hu/e1SZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t7WXVyk7UNsnby0BTFvK7nM6kwOYLUjSDsqtkvRlZTw=;
 b=B76B0bDQpmhgPj5bUdh5iQ9XwxJZZuK2FVOekty7PHQr/jaNR2oc6lCiFp7iukHO6NGHKL8DfslGp+zD6n7buBouJ3IMbsGcxZM+XbJ8rjUHDlb6o8Axr3lZ3q4wJFZ/EKRvAXNaLLZcCvy0s0hFv5/F6FOkyQbAvM3NJ6pHXLD6z1Av90tBQCfr6RpyMEZX7QImw6Jh2JU9kUlFkuo033UC6W4XLxo7V96wdn+LTK81KGfH/JzC9+KbUEBl/7cZixaY1X9Lu5eFxetVQpoeTALc+W+Dzq+DzGGaxj0n1N0ozF5y7R7TNHIK3K7jtrmZgghd4h9+DxzBdt9dVHJwTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t7WXVyk7UNsnby0BTFvK7nM6kwOYLUjSDsqtkvRlZTw=;
 b=bjXSpV+PiB5pRif2fRvNEY86liMKisdSa4Pcv3WF7cY3BolYHRvAblUU4NqL7Q0kUmKiQPl5wRI8AT74HfYJHkZ2SFZnx7Dza1DmNPZbd3Q1hWSknIUZN89wvrI1CRhdqBXvUSoCMwqZqxJqGuQqiN9UYtXhmaFb9AvaiLcwh1Q=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:55:17 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:55:17 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:47 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 31/65] staging: wfx: simplify hif_set_uc_mc_bc_condition()
Thread-Topic: [PATCH v2 31/65] staging: wfx: simplify
 hif_set_uc_mc_bc_condition()
Thread-Index: AQHVy6tZfV6OMRg3xkujGLdYN50CKw==
Date:   Wed, 15 Jan 2020 13:54:48 +0000
Message-ID: <20200115135338.14374-32-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 6b9d42bb-7508-4a19-ccd2-08d799c27c37
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB36613584169427C19DD9421F93370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(86362001)(2616005)(4326008)(66574012)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: negmMEw4i6Jq1gWvn1FPRcnjXwlH4izv4qnumnY6INLNrVtNSPIgKhA5y4NNrWF/FERtoM8o5bUlG6lJ+WOy2jlomt2MmKF9tsTpghTvX67kaNI/YMCtFmTBkUPvIoTrgbSmGRL77nyDKzY49FkgVZ+Je6FoVRgLJedRp/SYmVvd6f84jysJc5dT/iF6gXsXZPn7TBqmkmtiD+8KYrwysFu/rj3wiR5Iw4ixqjRuda/EPacVjGxz10cON6giLJsrHopiosHtT6vz8mM4SHiJgSclW3HUM/9s/6uPJLpCIfN/v80KMpwQfcRCEUR9zicOVrgyCTI7nqgpMkxOALaS6PS90e6FdLZLsDYh6I0wTxBcrTfc7+6YCbjmc3zNVv6CXiJDgaUPxwbTfxNWlFHkvjOHQEbQEWYDkYr1cdqvpDwj7gsKEiHexi5f/Lkso5d2
Content-Type: text/plain; charset="utf-8"
Content-ID: <853FF0B7B01C864C9319ABC0F7678133@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b9d42bb-7508-4a19-ccd2-08d799c27c37
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:48.4630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mCTDeaaLj2qtHfSrns4pIk3heSPgYQu81dFk+Vwjih8s/g2/e4dMA/MFiweN9MGYrXww+UFt7VLKqkfGQxLJBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN0cnVjdHVyZSBoaWZfbWliX3VjX21jX2JjX2RhdGFfZnJhbWVfY29uZGl0aW9uIGNvbWUgZnJv
bSBoYXJkd2FyZQpBUEkuIEl0IGlzIG5vdCBpbnRlbmRlZCB0byBiZSBtYW5pcHVsYXRlZCBpbiB1
cHBlciBsYXllcnMgb2YgdGhlIGRyaXZlci4KCkluIGFkZCwgY3VycmVudCBjb2RlIGZvciBoaWZf
c2V0X3VjX21jX2JjX2NvbmRpdGlvbigpIGlzIHRvbyBkdW1iLiBJdApzaG91bGQgcGFjayBkYXRh
IHdpdGggaGFyZHdhcmUgcmVwcmVzZW50YXRpb24gaW5zdGVhZCBvZiBsZWF2aW5nIGFsbAp3b3Jr
IHRvIHRoZSBjYWxsZXIuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21l
LnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWli
LmggfCAxNCArKysrKysrKysrKy0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyAgICAgICAg
fCAgNiArLS0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaCBiL2Ry
aXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oCmluZGV4IGVlYzZmNDE1N2U2MC4uNGQxNzFl
NmNmYzlhIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaAorKysg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaApAQCAtMjQ2LDEyICsyNDYsMjAgQEAg
c3RhdGljIGlubGluZSBpbnQgaGlmX3NldF9tYWNfYWRkcl9jb25kaXRpb24oc3RydWN0IHdmeF92
aWYgKnd2aWYsCiAJCQkgICAgIGFyZywgc2l6ZW9mKCphcmcpKTsKIH0KIAotc3RhdGljIGlubGlu
ZSBpbnQgaGlmX3NldF91Y19tY19iY19jb25kaXRpb24oc3RydWN0IHdmeF92aWYgKnd2aWYsCi0J
CQkJCSAgICAgc3RydWN0IGhpZl9taWJfdWNfbWNfYmNfZGF0YV9mcmFtZV9jb25kaXRpb24gKmFy
ZykKKy8vIEZJWE1FOiB1c2UgYSBiaXRmaWVsZCBpbnN0ZWFkIG9mIDMgYm9vbGVhbiB2YWx1ZXMK
K3N0YXRpYyBpbmxpbmUgaW50IGhpZl9zZXRfdWNfbWNfYmNfY29uZGl0aW9uKHN0cnVjdCB3Znhf
dmlmICp3dmlmLCBpbnQgaWR4LAorCQkJCQkgICAgIGJvb2wgdW5pYywgYm9vbCBtdWx0aWMsIGJv
b2wgYnJvYWRjKQogeworCXN0cnVjdCBoaWZfbWliX3VjX21jX2JjX2RhdGFfZnJhbWVfY29uZGl0
aW9uIHZhbCA9IHsKKwkJLmNvbmRpdGlvbl9pZHggPSBpZHgsCisJCS5wYXJhbS5iaXRzLnR5cGVf
dW5pY2FzdCA9IHVuaWMsCisJCS5wYXJhbS5iaXRzLnR5cGVfbXVsdGljYXN0ID0gbXVsdGljLAor
CQkucGFyYW0uYml0cy50eXBlX2Jyb2FkY2FzdCA9IGJyb2FkYywKKwl9OworCiAJcmV0dXJuIGhp
Zl93cml0ZV9taWIod3ZpZi0+d2Rldiwgd3ZpZi0+aWQsCiAJCQkgICAgIEhJRl9NSUJfSURfVUNf
TUNfQkNfREFUQUZSQU1FX0NPTkRJVElPTiwKLQkJCSAgICAgYXJnLCBzaXplb2YoKmFyZykpOwor
CQkJICAgICAmdmFsLCBzaXplb2YodmFsKSk7CiB9CiAKIHN0YXRpYyBpbmxpbmUgaW50IGhpZl9z
ZXRfY29uZmlnX2RhdGFfZmlsdGVyKHN0cnVjdCB3ZnhfdmlmICp3dmlmLApkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5k
ZXggOTAzMDY4MTg1OGJiLi43OTI4NTkyN2M3YmYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2lu
Zy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtMTIwLDcgKzEy
MCw2IEBAIHN0YXRpYyBpbnQgd2Z4X3NldF9tY2FzdF9maWx0ZXIoc3RydWN0IHdmeF92aWYgKnd2
aWYsCiAJc3RydWN0IGhpZl9taWJfY29uZmlnX2RhdGFfZmlsdGVyIGNvbmZpZyA9IHsgfTsKIAlz
dHJ1Y3QgaGlmX21pYl9zZXRfZGF0YV9maWx0ZXJpbmcgZmlsdGVyX2RhdGEgPSB7IH07CiAJc3Ry
dWN0IGhpZl9taWJfbWFjX2FkZHJfZGF0YV9mcmFtZV9jb25kaXRpb24gZmlsdGVyX2FkZHJfdmFs
ID0geyB9OwotCXN0cnVjdCBoaWZfbWliX3VjX21jX2JjX2RhdGFfZnJhbWVfY29uZGl0aW9uIGZp
bHRlcl9hZGRyX3R5cGUgPSB7IH07CiAKIAkvLyBUZW1wb3Jhcnkgd29ya2Fyb3VuZCBmb3IgZmls
dGVycwogCXJldHVybiBoaWZfc2V0X2RhdGFfZmlsdGVyaW5nKHd2aWYsICZmaWx0ZXJfZGF0YSk7
CkBAIC0xNDQsMTAgKzE0Myw3IEBAIHN0YXRpYyBpbnQgd2Z4X3NldF9tY2FzdF9maWx0ZXIoc3Ry
dWN0IHdmeF92aWYgKnd2aWYsCiAJfQogCiAJLy8gQWNjZXB0IHVuaWNhc3QgYW5kIGJyb2FkY2Fz
dAotCWZpbHRlcl9hZGRyX3R5cGUuY29uZGl0aW9uX2lkeCA9IDA7Ci0JZmlsdGVyX2FkZHJfdHlw
ZS5wYXJhbS5iaXRzLnR5cGVfdW5pY2FzdCA9IDE7Ci0JZmlsdGVyX2FkZHJfdHlwZS5wYXJhbS5i
aXRzLnR5cGVfYnJvYWRjYXN0ID0gMTsKLQlyZXQgPSBoaWZfc2V0X3VjX21jX2JjX2NvbmRpdGlv
bih3dmlmLCAmZmlsdGVyX2FkZHJfdHlwZSk7CisJcmV0ID0gaGlmX3NldF91Y19tY19iY19jb25k
aXRpb24od3ZpZiwgMCwgdHJ1ZSwgZmFsc2UsIHRydWUpOwogCWlmIChyZXQpCiAJCXJldHVybiBy
ZXQ7CiAKLS0gCjIuMjUuMAoK
