Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5603113BFBC
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732267AbgAOMP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:15:59 -0500
Received: from mail-bn7nam10on2041.outbound.protection.outlook.com ([40.107.92.41]:41024
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731461AbgAOMNj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:13:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=es03BDidJGJIWzYK4zM/xqndsYAPL3cyk/xvGuyt0oTq3mtA7O+gA1e4Bqpm+kbSzfd/30QCDp8N8Jjk9Fv0lPC/YkWti+N7wHXQdouE1QEWK3PZmAEk7XfetLCVrXwGw0bxeJZXRyzeYB4DdkhpxJl10N+ZaBk0KIRV9Bvof9U3cDuQ6o07pLomFGJojtTU599+grWwFe59J7wxuZ/3HYm6T0qOFT+tLrXKASo6K6MI5n4h1DQo9DNnuvid0M7zHHanguElyx2zNX7KTzoP1lqptfP/1hn5CYdq+8e4S8p9cG8GjHMQtTqiTJMfqsfH6tOsJ9qsd+goBEWRulIf5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5kV1mbBs0jOG7Or6aTX90C/te15BM0ZpZCx4HAP9Y5w=;
 b=echtPNL5TTI44qk50A90nlGn4NOep9XiQ4CusmUwyOs4b1YYTocSj4kIu0NvE9cv+f4vBQbupE/bg9DeHeFMMdsb8Gjd+T4JSfhR7xm+ewmkiO4iOsxppPWQ3brT5+gGeeLgyatxvTW68Vj42hLhFq5myryFJmLa32DGRYhajY6KIrQ/JmmBsamXmHFJQfY7FsNMsKug3fujVVxAN3sZ2LWEdZYgJo1biolHhZ3W8OQDMBnBeJ0eCfdU97qg52KuD6VK/Lxy1O02ZTvzC+Yb3u/6rZ/Zdv3UZiOBR+3+dDR449vMP78vXOPHxbDy77s38NKcwcIGfY/B56+zFK0pLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5kV1mbBs0jOG7Or6aTX90C/te15BM0ZpZCx4HAP9Y5w=;
 b=Gu89VLCw/mzo8x2MO0/KfzEZfcGr6Q9lK1BjdkxM1DYOXhbanUSa+mS2j8p9C5otWJZpI0ni4A9/Euu90ojjRL+QXJDtu797IapxkZVgkE+PTd6+YR+vn2+4sgqdqhZ7CmNE38TvzwRhgRqxpHfOU9rW6sgcvBjoXVutE2GXEtQ=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4096.namprd11.prod.outlook.com (20.179.150.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Wed, 15 Jan 2020 12:13:35 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:35 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:13:22 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 56/65] staging: wfx: simplify wfx_suspend_resume_mc()
Thread-Topic: [PATCH 56/65] staging: wfx: simplify wfx_suspend_resume_mc()
Thread-Index: AQHVy50v4qDMzV+kQkmNjY0FuosDNA==
Date:   Wed, 15 Jan 2020 12:13:23 +0000
Message-ID: <20200115121041.10863-57-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 4af61dcb-ed44-41ca-94c1-08d799b4516d
x-ms-traffictypediagnostic: MN2PR11MB4096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4096C79D2C3B6266A2CC4E5293370@MN2PR11MB4096.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(376002)(136003)(199004)(189003)(85202003)(66946007)(66446008)(66476007)(2906002)(107886003)(66556008)(1076003)(66574012)(64756008)(5660300002)(8936002)(6486002)(186003)(26005)(8676002)(316002)(81156014)(36756003)(52116002)(2616005)(7696005)(478600001)(16526019)(956004)(54906003)(110136005)(86362001)(71200400001)(85182001)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4096;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +YVbE2n5rnoyRPLKDwlSZdZ3DsyIJf7hWi9muntGcxmgHG/cy+sa2e7fxoQgt6xxhzew9tqMQfcV6OPYhWUc+czUPz7nHnZETuGREqA+Ec+/fVwbOXW39clydXEpkGDk3NCqV1i4Mk4BWck2qydFInSoP+AeOpwflY0edK/o2VrUBfZO/0y6gpYBxMSbL6pNUpU1Bi/pjrLT4asgTEyGMiyne5dbGmx1h2ClbMec5RhQpTd4LRUKXL+GOHdDKMsZPSWYCRlCYcBLydjjMOjRBHP4VZFooAZ6KD3V0pfZ8tTTDg6IvUma3HO9A6U3kJgGWMaTRURDBmDiBDLLGUqpl5ibimlTvErisvas7Hq0Gt0JiSgMkRrWoYydnS/BIE4ijmeTUflUH8bbkxisUmD6zWdMv9fxj0drE1Iaq9Dh/QY+9WBKYQ5tXOttRbE8fkuf
Content-Type: text/plain; charset="utf-8"
Content-ID: <0590BED78D148B4DB4866472D22F022B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4af61dcb-ed44-41ca-94c1-08d799b4516d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:13:23.7562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j25C4Viz+OAR8APZLIGhrUkYG2sNH2VHc8AJVOvYXEgjigI2Fo2q+KZR1dGYoNNaAYN8dHzB67NUptuzuefqtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4096
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW5k
ZWVkLCBpdCBpcyBub3QgbmVjZXNzYXJ5IHRvIHBhc3Mgd2hvbGUgaGlmX2luZF9zdXNwZW5kX3Jl
c3VtZV90eCB0bwp3Znhfc3VzcGVuZF9yZXN1bWVfbWMoKS4KCkluIGFkZCwgdGhlIHN0cnVjdHVy
ZSBoaWZfaW5kX3N1c3BlbmRfcmVzdW1lX3R4IGNvbWUgZnJvbSBoYXJkd2FyZSBBUEkuCkl0IGlz
IG5vdCBpbnRlbmRlZCB0byBiZSBtYW5pcHVsYXRlZCBpbiB1cHBlciBsYXllcnMgb2YgdGhlIGRy
aXZlci4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJA
c2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYyB8ICA3ICstLS0t
LS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMgIHwgIDYgKysrKystCiBkcml2ZXJzL3N0
YWdpbmcvd2Z4L3N0YS5jICAgICB8IDEwICsrLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngv
c3RhLmggICAgIHwgIDMgKy0tCiA0IGZpbGVzIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMTcg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYwppbmRleCA3OTE0YzA2NTc4YWEuLjg3MTAz
ODNmNjZlNSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKKysrIGIv
ZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKQEAgLTYwMCwxMyArNjAwLDggQEAgdm9pZCB3
ZnhfdHhfY29uZmlybV9jYihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgY29uc3Qgc3RydWN0IGhpZl9j
bmZfdHggKmFyZykKIAkJCXR4X2luZm8tPmZsYWdzIHw9IElFRUU4MDIxMV9UWF9TVEFUX0FDSzsK
IAl9IGVsc2UgaWYgKGFyZy0+c3RhdHVzID09IEhJRl9SRVFVRVVFKSB7CiAJCS8qICJSRVFVRVVF
IiBtZWFucyAiaW1wbGljaXQgc3VzcGVuZCIgKi8KLQkJc3RydWN0IGhpZl9pbmRfc3VzcGVuZF9y
ZXN1bWVfdHggc3VzcGVuZCA9IHsKLQkJCS5zdXNwZW5kX3Jlc3VtZV9mbGFncy5yZXN1bWUgPSAw
LAotCQkJLnN1c3BlbmRfcmVzdW1lX2ZsYWdzLmJjX21jX29ubHkgPSAxLAotCQl9OwotCiAJCVdB
Uk4oIWFyZy0+dHhfcmVzdWx0X2ZsYWdzLnJlcXVldWUsICJpbmNvaGVyZW50IHN0YXR1cyBhbmQg
cmVzdWx0X2ZsYWdzIik7Ci0JCXdmeF9zdXNwZW5kX3Jlc3VtZSh3dmlmLCAmc3VzcGVuZCk7CisJ
CXdmeF9zdXNwZW5kX3Jlc3VtZV9tYyh3dmlmLCBTVEFfTk9USUZZX1NMRUVQKTsKIAkJdHhfaW5m
by0+ZmxhZ3MgfD0gSUVFRTgwMjExX1RYX1NUQVRfVFhfRklMVEVSRUQ7CiAJfSBlbHNlIHsKIAkJ
aWYgKHd2aWYtPmJzc19sb3NzX3N0YXRlICYmCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcv
d2Z4L2hpZl9yeC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfcnguYwppbmRleCBmMDRhZmM2
ZGI5YTUuLmY3OThjZDY5NzNiNiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZf
cnguYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jCkBAIC0yMzAsNyArMjMwLDEx
IEBAIHN0YXRpYyBpbnQgaGlmX3N1c3BlbmRfcmVzdW1lX2luZGljYXRpb24oc3RydWN0IHdmeF9k
ZXYgKndkZXYsCiAJY29uc3Qgc3RydWN0IGhpZl9pbmRfc3VzcGVuZF9yZXN1bWVfdHggKmJvZHkg
PSBidWY7CiAKIAlXQVJOX09OKCF3dmlmKTsKLQl3Znhfc3VzcGVuZF9yZXN1bWUod3ZpZiwgYm9k
eSk7CisJV0FSTighYm9keS0+c3VzcGVuZF9yZXN1bWVfZmxhZ3MuYmNfbWNfb25seSwgInVuc3Vw
cG9ydGVkIHN1c3BlbmQvcmVzdW1lIG5vdGlmaWNhdGlvbiIpOworCWlmIChib2R5LT5zdXNwZW5k
X3Jlc3VtZV9mbGFncy5yZXN1bWUpCisJCXdmeF9zdXNwZW5kX3Jlc3VtZV9tYyh3dmlmLCBTVEFf
Tk9USUZZX0FXQUtFKTsKKwllbHNlCisJCXdmeF9zdXNwZW5kX3Jlc3VtZV9tYyh3dmlmLCBTVEFf
Tk9USUZZX1NMRUVQKTsKIAogCXJldHVybiAwOwogfQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggY2U4M2E1NzM5
N2M4Li5kNjQ3ZGZmNDY2NzMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMK
KysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtOTg1LDE4ICs5ODUsMTIgQEAgaW50
IHdmeF9hbXBkdV9hY3Rpb24oc3RydWN0IGllZWU4MDIxMV9odyAqaHcsCiAJcmV0dXJuIC1FTk9U
U1VQUDsKIH0KIAotdm9pZCB3Znhfc3VzcGVuZF9yZXN1bWUoc3RydWN0IHdmeF92aWYgKnd2aWYs
Ci0JCQljb25zdCBzdHJ1Y3QgaGlmX2luZF9zdXNwZW5kX3Jlc3VtZV90eCAqYXJnKQordm9pZCB3
Znhfc3VzcGVuZF9yZXN1bWVfbWMoc3RydWN0IHdmeF92aWYgKnd2aWYsIGVudW0gc3RhX25vdGlm
eV9jbWQgbm90aWZ5X2NtZCkKIHsKIAlib29sIGNhbmNlbF90bW8gPSBmYWxzZTsKIAotCWlmICgh
YXJnLT5zdXNwZW5kX3Jlc3VtZV9mbGFncy5iY19tY19vbmx5KSB7Ci0JCWRldl93YXJuKHd2aWYt
PndkZXYtPmRldiwgInVuc3VwcG9ydGVkIHN1c3BlbmQvcmVzdW1lIG5vdGlmaWNhdGlvblxuIik7
Ci0JCXJldHVybjsKLQl9Ci0KIAlzcGluX2xvY2tfYmgoJnd2aWYtPnBzX3N0YXRlX2xvY2spOwot
CWlmICghYXJnLT5zdXNwZW5kX3Jlc3VtZV9mbGFncy5yZXN1bWUpCisJaWYgKG5vdGlmeV9jbWQg
PT0gU1RBX05PVElGWV9TTEVFUCkKIAkJd3ZpZi0+bWNhc3RfdHggPSBmYWxzZTsKIAllbHNlCiAJ
CXd2aWYtPm1jYXN0X3R4ID0gd3ZpZi0+YWlkMF9iaXRfc2V0ICYmCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaAppbmRleCBl
ODMyNDA1ZDYwNGUuLmNmOTlhOGE3NGE4MSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oCkBAIC04Miw4ICs4Miw3IEBA
IHZvaWQgd2Z4X3VuYXNzaWduX3ZpZl9jaGFuY3R4KHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LAog
CQkJICAgICAgc3RydWN0IGllZWU4MDIxMV9jaGFuY3R4X2NvbmYgKmNvbmYpOwogCiAvLyBXU00g
Q2FsbGJhY2tzCi12b2lkIHdmeF9zdXNwZW5kX3Jlc3VtZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwK
LQkJCWNvbnN0IHN0cnVjdCBoaWZfaW5kX3N1c3BlbmRfcmVzdW1lX3R4ICphcmcpOwordm9pZCB3
Znhfc3VzcGVuZF9yZXN1bWVfbWMoc3RydWN0IHdmeF92aWYgKnd2aWYsIGVudW0gc3RhX25vdGlm
eV9jbWQgY21kKTsKIAogLy8gT3RoZXIgSGVscGVycwogdm9pZCB3ZnhfY3FtX2Jzc2xvc3Nfc20o
c3RydWN0IHdmeF92aWYgKnd2aWYsIGludCBpbml0LCBpbnQgZ29vZCwgaW50IGJhZCk7Ci0tIAoy
LjI1LjAKCg==
