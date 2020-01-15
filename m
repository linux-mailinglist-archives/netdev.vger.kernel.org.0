Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6AE013C08D
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730395AbgAOMM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:12:27 -0500
Received: from mail-bn7nam10on2050.outbound.protection.outlook.com ([40.107.92.50]:24527
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730191AbgAOMMX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FW7txK/+GpNqYiW2hnxnejNqUMOha/s1CGY2VEtJSzAr05W9jEOKb8Wlx1U1r5VtQR64XakDdc+h2yFqLosP3N9PvHcwW1cUmDl5hryCWzr7TEcvPiHmiHIHV40a5wqcZgJJMaXKVbQtvqF3YV2mqzP5wbf/KRuNXVsNcW4FCfHBIGpu8gCdYeDnrXQ9EbzOTYkdxYjveuSZP/jdNCVpCk691Z3vzMG90eETUMysKdu7VkMfoKiYAytad9koxyCP9zWumDnxYKo4N8tUMtBu/YqzA8Tp99Ci13I6la2awL3a/ORFISltyo6kadEeSEOVpeaW0EH072w7owpAhpihZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tz6rRPqYovKmS4+0y3NaPK/jPsF16HaTkAo8p/CyYzE=;
 b=ZJE90e8AXRxNQLrAn3igRoXE8LwQMGOMtAUCmSLRtqFEytzlGOe5+CARUAJrigQ8xF428e7c7jaVbxvDYq2aTPHRlbHjEDciDfgQW0TsezQZ5hmK/Tecxlf9p8r8tubNZn6K8fWUHuP87WVPe7UqgTrK17S5tX3ADVlO7k+Pv9Uca7kQmTi/3eCmFj/xvhuycIsjmHt9NBiWQ0Tmrf37pkOy6EK7//G0+qw6ru+iaAst5oRGdxcc0FttVkeWHpWC0uofLS8/VcSY/+U1ZOY1FD+gkEhZEGChsQGia3OxophICGUQ0W3koSDlqxmkvqPChjGwuhMzRuhP56Fr0g9rQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tz6rRPqYovKmS4+0y3NaPK/jPsF16HaTkAo8p/CyYzE=;
 b=pRjVAmzyQnBiwOPZgQFYfN6K873kbqhKL5E5GAPJHOgn07CkQ2fyZ/4phg3yoq68PGS4K1R40bLbpfEhSKr8J7S8wY28Fic8p8BvhqQbPlg1KgVl0/+k9WU0tTOhjXar8aPVIeaGzXzvv5WWTiPzWcHXttm5Fnuc90p/AneWG3o=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4096.namprd11.prod.outlook.com (20.179.150.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Wed, 15 Jan 2020 12:12:20 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:20 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:19 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 09/65] staging: wfx: simplify hif_start() usage
Thread-Topic: [PATCH 09/65] staging: wfx: simplify hif_start() usage
Thread-Index: AQHVy50JgE81QsoikkK+Xtsk9e+c0w==
Date:   Wed, 15 Jan 2020 12:12:20 +0000
Message-ID: <20200115121041.10863-10-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: e46af8c4-756d-4195-2804-08d799b42bcc
x-ms-traffictypediagnostic: MN2PR11MB4096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4096D9FD5439F7BC21CA5DDD93370@MN2PR11MB4096.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(376002)(136003)(199004)(189003)(85202003)(66946007)(66446008)(66476007)(2906002)(107886003)(66556008)(1076003)(66574012)(64756008)(5660300002)(8936002)(6486002)(186003)(26005)(8676002)(316002)(81156014)(36756003)(52116002)(2616005)(7696005)(478600001)(16526019)(956004)(6666004)(54906003)(110136005)(86362001)(71200400001)(85182001)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4096;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cR1uc2CpUJTaOc0Hvs9gQP4UsoGVOr+7+bV+Qihum89BpI8DTwbD7AAWLCFcvmgZ0Zcwv/d9yFsfuNLYToHhMhS8zwrn/Tie5pQlDiJKt+i7kV0sRNzKApVee7djwFxuIDBfgZLBgrPjoCRRGML+tFFLyskNaLM+XrCGWYpppwWky8UddLgfUFet4vYSUHrtVKRj85hiZoY479uUyABkbyZneNMlC8gW1r/yzEh+wF7ndRzyC9maKJDPMp10jcbT92HxVj6pxOwXKPX2JF+83KYwEguWkEWK0njMe60OM9Iu3JxN/S3qB1fzDsi3be0DIogJY3gK3NaEqBZY+6B6L5NorHJn4XPEk3Bk1Pz8YAQ4y5A5HRdUTmSQqzSDgsLN/fLAzMcBeqOBGmlJUv8JhcmafrSpFbYojDs2hg4xNovtpw+DjFOq6Y5zhHalhbga
Content-Type: text/plain; charset="utf-8"
Content-ID: <E6C64CB6AAD91D43BE024258F41D8873@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e46af8c4-756d-4195-2804-08d799b42bcc
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:20.5896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ElLLv8P1mBsGibfbIJ7QOJmgVF8K7qWQAm/AqkWZplXdAr6NTl+grmF2JasIWFjHfJgMv3A0NVO14jn5br/G7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4096
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN0cnVjdHVyZSBoaWZfcmVxX3N0YXJ0IGNvbWUgZnJvbSBoYXJkd2FyZSBBUEkuIEl0IGlzIG5v
dCBpbnRlbmRlZAp0byBiZSBtYW5pcHVsYXRlZCBpbiB1cHBlciBsYXllcnMgb2YgdGhlIGRyaXZl
ci4KCkluIGFkZCwgY3VycmVudCBjb2RlIGZvciBoaWZfc3RhcnQoKSBpcyB0b28gZHVtYi4gSXQg
c2hvdWxkIHBhY2sgZGF0YQp3aXRoIGhhcmR3YXJlIHJlcHJlc2VudGF0aW9uIGluc3RlYWQgb2Yg
bGVhdmluZyBhbGwgd29yayB0byB0aGUgY2FsbGVyLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUg
UG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX3R4LmMgfCAxNyArKysrKysrKysrLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX3R4LmggfCAgNSArKysrLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyAgICB8IDQwICsr
KysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMyBmaWxlcyBjaGFuZ2VkLCAyOSBp
bnNlcnRpb25zKCspLCAzMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl90eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYwppbmRleCBkOGUx
NTk2NzBlYWUuLmJlMzEzODU5MGE0ZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9o
aWZfdHguYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCkBAIC00MDksMTYgKzQw
OSwyMyBAQCBpbnQgaGlmX3NldF9wbShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgYm9vbCBwcywgaW50
IGR5bmFtaWNfcHNfdGltZW91dCkKIAlyZXR1cm4gcmV0OwogfQogCi1pbnQgaGlmX3N0YXJ0KHN0
cnVjdCB3ZnhfdmlmICp3dmlmLCBjb25zdCBzdHJ1Y3QgaGlmX3JlcV9zdGFydCAqYXJnKQoraW50
IGhpZl9zdGFydChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgY29uc3Qgc3RydWN0IGllZWU4MDIxMV9i
c3NfY29uZiAqY29uZiwKKwkgICAgICBjb25zdCBzdHJ1Y3QgaWVlZTgwMjExX2NoYW5uZWwgKmNo
YW5uZWwpCiB7CiAJaW50IHJldDsKIAlzdHJ1Y3QgaGlmX21zZyAqaGlmOwogCXN0cnVjdCBoaWZf
cmVxX3N0YXJ0ICpib2R5ID0gd2Z4X2FsbG9jX2hpZihzaXplb2YoKmJvZHkpLCAmaGlmKTsKIAot
CW1lbWNweShib2R5LCBhcmcsIHNpemVvZigqYm9keSkpOwotCWNwdV90b19sZTE2cygmYm9keS0+
Y2hhbm5lbF9udW1iZXIpOwotCWNwdV90b19sZTMycygmYm9keS0+YmVhY29uX2ludGVydmFsKTsK
LQljcHVfdG9fbGUzMnMoJmJvZHktPmJhc2ljX3JhdGVfc2V0KTsKKwlib2R5LT5kdGltX3Blcmlv
ZCA9IGNvbmYtPmR0aW1fcGVyaW9kLAorCWJvZHktPnNob3J0X3ByZWFtYmxlID0gY29uZi0+dXNl
X3Nob3J0X3ByZWFtYmxlLAorCWJvZHktPmNoYW5uZWxfbnVtYmVyID0gY3B1X3RvX2xlMTYoY2hh
bm5lbC0+aHdfdmFsdWUpLAorCWJvZHktPmJlYWNvbl9pbnRlcnZhbCA9IGNwdV90b19sZTMyKGNv
bmYtPmJlYWNvbl9pbnQpOworCWJvZHktPmJhc2ljX3JhdGVfc2V0ID0KKwkJY3B1X3RvX2xlMzIo
d2Z4X3JhdGVfbWFza190b19odyh3dmlmLT53ZGV2LCBjb25mLT5iYXNpY19yYXRlcykpOworCWlm
ICghY29uZi0+aGlkZGVuX3NzaWQpIHsKKwkJYm9keS0+c3NpZF9sZW5ndGggPSBjb25mLT5zc2lk
X2xlbjsKKwkJbWVtY3B5KGJvZHktPnNzaWQsIGNvbmYtPnNzaWQsIGNvbmYtPnNzaWRfbGVuKTsK
Kwl9CiAJd2Z4X2ZpbGxfaGVhZGVyKGhpZiwgd3ZpZi0+aWQsIEhJRl9SRVFfSURfU1RBUlQsIHNp
emVvZigqYm9keSkpOwogCXJldCA9IHdmeF9jbWRfc2VuZCh3dmlmLT53ZGV2LCBoaWYsIE5VTEws
IDAsIGZhbHNlKTsKIAlrZnJlZShoaWYpOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9oaWZfdHguaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmgKaW5kZXggZTg4NTVlYWQz
YTE4Li5mYmFlZDk5MWIxMTIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4
LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguaApAQCAtMTIsNiArMTIsOCBAQAog
CiAjaW5jbHVkZSAiaGlmX2FwaV9jbWQuaCIKIAorc3RydWN0IGllZWU4MDIxMV9jaGFubmVsOwor
c3RydWN0IGllZWU4MDIxMV9ic3NfY29uZjsKIHN0cnVjdCBpZWVlODAyMTFfdHhfcXVldWVfcGFy
YW1zOwogc3RydWN0IGNmZzgwMjExX3NjYW5fcmVxdWVzdDsKIHN0cnVjdCB3ZnhfZGV2OwpAQCAt
NTEsNyArNTMsOCBAQCBpbnQgaGlmX2FkZF9rZXkoc3RydWN0IHdmeF9kZXYgKndkZXYsIGNvbnN0
IHN0cnVjdCBoaWZfcmVxX2FkZF9rZXkgKmFyZyk7CiBpbnQgaGlmX3JlbW92ZV9rZXkoc3RydWN0
IHdmeF9kZXYgKndkZXYsIGludCBpZHgpOwogaW50IGhpZl9zZXRfZWRjYV9xdWV1ZV9wYXJhbXMo
c3RydWN0IHdmeF92aWYgKnd2aWYsIHUxNiBxdWV1ZSwKIAkJCSAgICAgIGNvbnN0IHN0cnVjdCBp
ZWVlODAyMTFfdHhfcXVldWVfcGFyYW1zICphcmcpOwotaW50IGhpZl9zdGFydChzdHJ1Y3Qgd2Z4
X3ZpZiAqd3ZpZiwgY29uc3Qgc3RydWN0IGhpZl9yZXFfc3RhcnQgKmFyZyk7CitpbnQgaGlmX3N0
YXJ0KHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBjb25zdCBzdHJ1Y3QgaWVlZTgwMjExX2Jzc19jb25m
ICpjb25mLAorCSAgICAgIGNvbnN0IHN0cnVjdCBpZWVlODAyMTFfY2hhbm5lbCAqY2hhbm5lbCk7
CiBpbnQgaGlmX2JlYWNvbl90cmFuc21pdChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgYm9vbCBlbmFi
bGUpOwogaW50IGhpZl9tYXBfbGluayhzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgdTggKm1hY19hZGRy
LCBpbnQgZmxhZ3MsIGludCBzdGFfaWQpOwogaW50IGhpZl91cGRhdGVfaWUoc3RydWN0IHdmeF92
aWYgKnd2aWYsIGNvbnN0IHN0cnVjdCBoaWZfaWVfZmxhZ3MgKnRhcmdldF9mcmFtZSwKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0
YS5jCmluZGV4IDhjNTUwODliMWVhNC4uNjYwYTc1MDI0ZjRiIDEwMDY0NAotLS0gYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTc0
MCwzOCArNzQwLDI0IEBAIHN0YXRpYyB2b2lkIHdmeF9zZXRfY3RzX3dvcmsoc3RydWN0IHdvcmtf
c3RydWN0ICp3b3JrKQogc3RhdGljIGludCB3Znhfc3RhcnRfYXAoc3RydWN0IHdmeF92aWYgKnd2
aWYpCiB7CiAJaW50IHJldDsKLQlzdHJ1Y3QgaWVlZTgwMjExX2Jzc19jb25mICpjb25mID0gJnd2
aWYtPnZpZi0+YnNzX2NvbmY7Ci0Jc3RydWN0IGhpZl9yZXFfc3RhcnQgc3RhcnQgPSB7Ci0JCS5j
aGFubmVsX251bWJlciA9IHd2aWYtPmNoYW5uZWwtPmh3X3ZhbHVlLAotCQkuYmVhY29uX2ludGVy
dmFsID0gY29uZi0+YmVhY29uX2ludCwKLQkJLmR0aW1fcGVyaW9kID0gY29uZi0+ZHRpbV9wZXJp
b2QsCi0JCS5zaG9ydF9wcmVhbWJsZSA9IGNvbmYtPnVzZV9zaG9ydF9wcmVhbWJsZSwKLQkJLmJh
c2ljX3JhdGVfc2V0ID0gd2Z4X3JhdGVfbWFza190b19odyh3dmlmLT53ZGV2LAotCQkJCQkJICAg
ICAgY29uZi0+YmFzaWNfcmF0ZXMpLAotCX07CiAKLQltZW1zZXQoc3RhcnQuc3NpZCwgMCwgc2l6
ZW9mKHN0YXJ0LnNzaWQpKTsKLQlpZiAoIWNvbmYtPmhpZGRlbl9zc2lkKSB7Ci0JCXN0YXJ0LnNz
aWRfbGVuZ3RoID0gY29uZi0+c3NpZF9sZW47Ci0JCW1lbWNweShzdGFydC5zc2lkLCBjb25mLT5z
c2lkLCBzdGFydC5zc2lkX2xlbmd0aCk7Ci0JfQotCi0Jd3ZpZi0+YmVhY29uX2ludCA9IGNvbmYt
PmJlYWNvbl9pbnQ7Ci0Jd3ZpZi0+ZHRpbV9wZXJpb2QgPSBjb25mLT5kdGltX3BlcmlvZDsKKwl3
dmlmLT5iZWFjb25faW50ID0gd3ZpZi0+dmlmLT5ic3NfY29uZi5iZWFjb25faW50OworCXd2aWYt
PmR0aW1fcGVyaW9kID0gd3ZpZi0+dmlmLT5ic3NfY29uZi5kdGltX3BlcmlvZDsKIAogCW1lbXNl
dCgmd3ZpZi0+bGlua19pZF9kYiwgMCwgc2l6ZW9mKHd2aWYtPmxpbmtfaWRfZGIpKTsKIAogCXd2
aWYtPndkZXYtPnR4X2J1cnN0X2lkeCA9IC0xOwotCXJldCA9IGhpZl9zdGFydCh3dmlmLCAmc3Rh
cnQpOwotCWlmICghcmV0KQotCQlyZXQgPSB3ZnhfdXBsb2FkX2tleXMod3ZpZik7Ci0JaWYgKCFy
ZXQpIHsKLQkJaWYgKHd2aWZfY291bnQod3ZpZi0+d2RldikgPD0gMSkKLQkJCWhpZl9zZXRfYmxv
Y2tfYWNrX3BvbGljeSh3dmlmLCAweEZGLCAweEZGKTsKLQkJd3ZpZi0+c3RhdGUgPSBXRlhfU1RB
VEVfQVA7Ci0JCXdmeF91cGRhdGVfZmlsdGVyaW5nKHd2aWYpOwotCX0KLQlyZXR1cm4gcmV0Owor
CXJldCA9IGhpZl9zdGFydCh3dmlmLCAmd3ZpZi0+dmlmLT5ic3NfY29uZiwgd3ZpZi0+Y2hhbm5l
bCk7CisJaWYgKHJldCkKKwkJcmV0dXJuIHJldDsKKwlyZXQgPSB3ZnhfdXBsb2FkX2tleXMod3Zp
Zik7CisJaWYgKHJldCkKKwkJcmV0dXJuIHJldDsKKwlpZiAod3ZpZl9jb3VudCh3dmlmLT53ZGV2
KSA8PSAxKQorCQloaWZfc2V0X2Jsb2NrX2Fja19wb2xpY3kod3ZpZiwgMHhGRiwgMHhGRik7CisJ
d3ZpZi0+c3RhdGUgPSBXRlhfU1RBVEVfQVA7CisJd2Z4X3VwZGF0ZV9maWx0ZXJpbmcod3ZpZik7
CisJcmV0dXJuIDA7CiB9CiAKIHN0YXRpYyBpbnQgd2Z4X3VwZGF0ZV9iZWFjb25pbmcoc3RydWN0
IHdmeF92aWYgKnd2aWYpCi0tIAoyLjI1LjAKCg==
