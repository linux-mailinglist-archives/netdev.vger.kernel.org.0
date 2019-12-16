Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 236CE12110C
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbfLPRG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:06:58 -0500
Received: from mail-eopbgr690050.outbound.protection.outlook.com ([40.107.69.50]:60371
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727774AbfLPRG4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:06:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mIylNfA9W0enxysUhvGnGeIObo+cxvmU5hCsnngSZECdlkdborgOzQvpUoCxWlsG0vbJqNo9AggQiL1lkTHzJ/pozR29DQeXRGyOh+poqd9y4MKs3NlUN2Boj5tty/gt6g018PHXfyB12fXTxQj1+CJDFYaSpEPyMRh0gTJojNDUNIkQMDgn8w5bCFO0s1oQ5EC7w7Uo+AVtLugaDnwQ9O119oAfTz3tvYAEBM1xXk9kl60SbObPBFUvuttHWjrVzbxdnA+9NLiyADb3JwAYl2fcJl8DvvR972RTcIgnKLu3TeYcQw+UB9Mmctx8m0GjqOdiqITJwayGsWq3UlgXwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2osYXM3Y9A9fpoiGejPayy+vna5q00UyahRps2uw60=;
 b=EEr/F35tQ+lsNw2at4Sjj+yQFBDBcG/1+RLVZZ7hhIt/0j2xP30w2oxL1pQ6iGVZnUYPAIvsZ7oBSEo7xds32c1bv+RulFpFLcXPAzu5DnJAoHmS67+Ryh1z7tuO5WiA2jncKMvLQkv9ispslm7XobPyl7HaQC9PjQZQauhcfCxNlwrld7s7jdGVue4lfVMdkiuoLwPX60cT4n78N7ycDxLMk7cGojnbiN/V/Kpy57YMxXHT9u3uxoqxv6bixyEdQu9/eMWBd0/+bXtNqX8ndDgIqhAS3TG2G2l5dGNFbNVyJU3zrsahpMbud2wEMT0iYtZh6+TnSWa06GoADgQ6sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2osYXM3Y9A9fpoiGejPayy+vna5q00UyahRps2uw60=;
 b=EMrdFqYPrMZAoWXZ4iiezSuZsWSnqZCwR1bw7Zlf/IZB/JtJjM1O/PVtPsXRJY6K+pseImPY5i5I3Zzwg1bKm8IRpDhOWJGDUWlrufJGLrvqQnZ1VPZYo0yD0pBgeUBBj3KtYQ9o4zBrVzW8aTkJnwNM8rt75RkPAEb5sKqDZGU=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4142.namprd11.prod.outlook.com (20.179.149.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Mon, 16 Dec 2019 17:06:42 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:06:42 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 40/55] staging: wfx: simplify hif_set_pm() usage
Thread-Topic: [PATCH 40/55] staging: wfx: simplify hif_set_pm() usage
Thread-Index: AQHVtDLLKj0eVOD3Z0e3Cl4CiRrkvA==
Date:   Mon, 16 Dec 2019 17:03:54 +0000
Message-ID: <20191216170302.29543-41-Jerome.Pouiller@silabs.com>
References: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc67edd7-b838-4a6c-2f6d-08d7824a52e0
x-ms-traffictypediagnostic: MN2PR11MB4142:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4142CB86AD620BD054C00CCA93510@MN2PR11MB4142.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(346002)(136003)(376002)(39850400004)(199004)(189003)(6512007)(71200400001)(91956017)(6486002)(8676002)(2906002)(54906003)(81166006)(81156014)(186003)(76116006)(478600001)(36756003)(85182001)(85202003)(6666004)(66556008)(66476007)(66446008)(64756008)(1076003)(66574012)(316002)(2616005)(4326008)(6506007)(26005)(8936002)(110136005)(5660300002)(107886003)(66946007)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4142;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wg4iPSDU5XPcGREJEYpDuyvGL5njPwOKtzZhKyWfKGLNtuOX7mxeFYASxHgoHRHYOaKMcEWMFVJFqcBVqpTiz/nwVFE3d+DAuHxIMWnDOTALf56d8bLteHKU1Jtlu510SjckjrBqHUzKVQnoPxotcDS2ccG1Yr9T/RSZ4AXlnZe++qfVUFsV37S7kD06kDJWuUgMJ5whkYH2f/v2jyqVtiS+w+2CwzUKcTplA2Axw2M/QRSlRNaHYh4p7R99rRB3n12RHUoxSZZVN+iKrxrm4mmZYC3tt+d7lG/q+ZNr6sn9pXCzEBq4nQcDJOVpYlEUi1P84g0xc8AkSU3Xm5nYvpi57ugc6/NrTdE4tFPZpiIa5PLznAPmOuK9V6DlFMZt32m65GRvudFHugriAPc4HUfzBCRaoKvXjiyQKYYEOoTDmr802y7R9JItSAjAADKh
Content-Type: text/plain; charset="utf-8"
Content-ID: <74F8233353A04642A0C23A172A04380B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc67edd7-b838-4a6c-2f6d-08d7824a52e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:54.1093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hu6dm+0GRb5s61aEnG53Q8jLsd45gE+Sr9eK0KWAG0Ow2KVHA9HEgulkC6UDVcNfWBlGZJEAuiICTfaaVlkoRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4142
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpU
aGUgc3RydWN0IGhpZl9yZXFfc2V0X3BtX21vZGUgY29tZXMgZnJvbSBoYXJkd2FyZSBBUEkuIEl0
IGlzIG5vdA0KaW50ZW5kZWQgdG8gYmUgbWFuaXB1bGF0ZWQgaW4gdXBwZXIgbGF5ZXJzIG9mIHRo
ZSBkcml2ZXIuIFNvLCB0aGlzIHBhdGNoDQpyZWxvY2F0ZSB0aGUgaGFuZGxpbmcgb2YgdGhpcyBz
dHJ1Y3QgdG8gaGlmX3NldF9wbSgpICh0aGUgbG93IGxldmVsDQpmdW5jdGlvbikuDQoNClNpZ25l
ZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4N
Ci0tLQ0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMgfCAxMCArKysrKysrKy0tDQogZHJp
dmVycy9zdGFnaW5nL3dmeC9oaWZfdHguaCB8ICAyICstDQogZHJpdmVycy9zdGFnaW5nL3dmeC9z
dGEuYyAgICB8IDI1ICsrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0NCiAzIGZpbGVzIGNoYW5nZWQs
IDE4IGluc2VydGlvbnMoKyksIDE5IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zdGFnaW5nL3dmeC9oaWZfdHguYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMNCmlu
ZGV4IDZmYjk4ZGRiYzBlMi4uOWNiZjlkOTE2ZjVmIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9oaWZfdHguYw0KKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYw0KQEAg
LTM2MCwxMyArMzYwLDE5IEBAIGludCBoaWZfc2V0X2VkY2FfcXVldWVfcGFyYW1zKHN0cnVjdCB3
ZnhfdmlmICp3dmlmLA0KIAlyZXR1cm4gcmV0Ow0KIH0NCiANCi1pbnQgaGlmX3NldF9wbShzdHJ1
Y3Qgd2Z4X3ZpZiAqd3ZpZiwgY29uc3Qgc3RydWN0IGhpZl9yZXFfc2V0X3BtX21vZGUgKmFyZykN
CitpbnQgaGlmX3NldF9wbShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgYm9vbCBwcywgaW50IGR5bmFt
aWNfcHNfdGltZW91dCkNCiB7DQogCWludCByZXQ7DQogCXN0cnVjdCBoaWZfbXNnICpoaWY7DQog
CXN0cnVjdCBoaWZfcmVxX3NldF9wbV9tb2RlICpib2R5ID0gd2Z4X2FsbG9jX2hpZihzaXplb2Yo
KmJvZHkpLCAmaGlmKTsNCiANCi0JbWVtY3B5KGJvZHksIGFyZywgc2l6ZW9mKCpib2R5KSk7DQor
CWlmIChwcykgew0KKwkJYm9keS0+cG1fbW9kZS5lbnRlcl9wc20gPSAxOw0KKwkJLy8gRmlybXdh
cmUgZG9lcyBub3Qgc3VwcG9ydCBtb3JlIHRoYW4gMTI4bXMNCisJCWJvZHktPmZhc3RfcHNtX2lk
bGVfcGVyaW9kID0gbWluKGR5bmFtaWNfcHNfdGltZW91dCAqIDIsIDI1NSk7DQorCQlpZiAoYm9k
eS0+ZmFzdF9wc21faWRsZV9wZXJpb2QpDQorCQkJYm9keS0+cG1fbW9kZS5mYXN0X3BzbSA9IDE7
DQorCX0NCiAJd2Z4X2ZpbGxfaGVhZGVyKGhpZiwgd3ZpZi0+aWQsIEhJRl9SRVFfSURfU0VUX1BN
X01PREUsIHNpemVvZigqYm9keSkpOw0KIAlyZXQgPSB3ZnhfY21kX3NlbmQod3ZpZi0+d2Rldiwg
aGlmLCBOVUxMLCAwLCBmYWxzZSk7DQogCWtmcmVlKGhpZik7DQpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zdGFnaW5nL3dmeC9oaWZfdHguaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmgNCmlu
ZGV4IGY2MWFlN2IwZDQxYy4uYmI1ODYwZWU2NTQyIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9oaWZfdHguaA0KKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguaA0KQEAg
LTQ3LDcgKzQ3LDcgQEAgaW50IGhpZl93cml0ZV9taWIoc3RydWN0IHdmeF9kZXYgKndkZXYsIGlu
dCB2aWZfaWQsIHUxNiBtaWJfaWQsDQogaW50IGhpZl9zY2FuKHN0cnVjdCB3ZnhfdmlmICp3dmlm
LCBjb25zdCBzdHJ1Y3Qgd2Z4X3NjYW5fcGFyYW1zICphcmcpOw0KIGludCBoaWZfc3RvcF9zY2Fu
KHN0cnVjdCB3ZnhfdmlmICp3dmlmKTsNCiBpbnQgaGlmX2pvaW4oc3RydWN0IHdmeF92aWYgKnd2
aWYsIGNvbnN0IHN0cnVjdCBoaWZfcmVxX2pvaW4gKmFyZyk7DQotaW50IGhpZl9zZXRfcG0oc3Ry
dWN0IHdmeF92aWYgKnd2aWYsIGNvbnN0IHN0cnVjdCBoaWZfcmVxX3NldF9wbV9tb2RlICphcmcp
Ow0KK2ludCBoaWZfc2V0X3BtKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBib29sIHBzLCBpbnQgZHlu
YW1pY19wc190aW1lb3V0KTsNCiBpbnQgaGlmX3NldF9ic3NfcGFyYW1zKHN0cnVjdCB3Znhfdmlm
ICp3dmlmLA0KIAkJICAgICAgIGNvbnN0IHN0cnVjdCBoaWZfcmVxX3NldF9ic3NfcGFyYW1zICph
cmcpOw0KIGludCBoaWZfYWRkX2tleShzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwgY29uc3Qgc3RydWN0
IGhpZl9yZXFfYWRkX2tleSAqYXJnKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYw0KaW5kZXggOWVjYTM1ZDkxYWQzLi5i
NDAwN2FmY2QwYzYgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jDQorKysg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jDQpAQCAtMjkxLDM3ICsyOTEsMzAgQEAgdm9pZCB3
ZnhfY29uZmlndXJlX2ZpbHRlcihzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywNCiBzdGF0aWMgaW50
IHdmeF91cGRhdGVfcG0oc3RydWN0IHdmeF92aWYgKnd2aWYpDQogew0KIAlzdHJ1Y3QgaWVlZTgw
MjExX2NvbmYgKmNvbmYgPSAmd3ZpZi0+d2Rldi0+aHctPmNvbmY7DQotCXN0cnVjdCBoaWZfcmVx
X3NldF9wbV9tb2RlIHBtOw0KKwlib29sIHBzID0gY29uZi0+ZmxhZ3MgJiBJRUVFODAyMTFfQ09O
Rl9QUzsNCisJaW50IHBzX3RpbWVvdXQgPSBjb25mLT5keW5hbWljX3BzX3RpbWVvdXQ7DQogDQor
CVdBUk5fT04oY29uZi0+ZHluYW1pY19wc190aW1lb3V0IDwgMCk7DQogCWlmICh3dmlmLT5zdGF0
ZSAhPSBXRlhfU1RBVEVfU1RBIHx8ICF3dmlmLT5ic3NfcGFyYW1zLmFpZCkNCiAJCXJldHVybiAw
Ow0KLQ0KLQltZW1zZXQoJnBtLCAwLCBzaXplb2YocG0pKTsNCi0JaWYgKGNvbmYtPmZsYWdzICYg
SUVFRTgwMjExX0NPTkZfUFMpIHsNCi0JCXBtLnBtX21vZGUuZW50ZXJfcHNtID0gMTsNCi0JCS8v
IEZpcm13YXJlIGRvZXMgbm90IHN1cHBvcnQgbW9yZSB0aGFuIDEyOG1zDQotCQlwbS5mYXN0X3Bz
bV9pZGxlX3BlcmlvZCA9DQotCQkJbWluKGNvbmYtPmR5bmFtaWNfcHNfdGltZW91dCAqIDIsIDI1
NSk7DQotCQlpZiAocG0uZmFzdF9wc21faWRsZV9wZXJpb2QpDQotCQkJcG0ucG1fbW9kZS5mYXN0
X3BzbSA9IDE7DQotCX0NCi0NCisJaWYgKCFwcykNCisJCXBzX3RpbWVvdXQgPSAwOw0KIAlpZiAo
d3ZpZi0+ZWRjYS51YXBzZF9tYXNrKQ0KLQkJcG0ucG1fbW9kZS5mYXN0X3BzbSA9IDA7DQorCQlw
c190aW1lb3V0ID0gMDsNCiANCiAJLy8gS2VybmVsIGRpc2FibGUgUG93ZXJTYXZlIHdoZW4gbXVs
dGlwbGUgdmlmcyBhcmUgaW4gdXNlLiBJbiBjb250cmFyeSwNCiAJLy8gaXQgaXMgYWJzb2x1dGx5
IG5lY2Vzc2FyeSB0byBlbmFibGUgUG93ZXJTYXZlIGZvciBXRjIwMA0KIAkvLyBGSVhNRTogb25s
eSBpZiBjaGFubmVsIHZpZjAgIT0gY2hhbm5lbCB2aWYxDQogCWlmICh3dmlmX2NvdW50KHd2aWYt
PndkZXYpID4gMSkgew0KLQkJcG0ucG1fbW9kZS5lbnRlcl9wc20gPSAxOw0KLQkJcG0ucG1fbW9k
ZS5mYXN0X3BzbSA9IDA7DQorCQlwcyA9IHRydWU7DQorCQlwc190aW1lb3V0ID0gMDsNCiAJfQ0K
IA0KIAlpZiAoIXdhaXRfZm9yX2NvbXBsZXRpb25fdGltZW91dCgmd3ZpZi0+c2V0X3BtX21vZGVf
Y29tcGxldGUsDQogCQkJCQkgVFVfVE9fSklGRklFUyg1MTIpKSkNCiAJCWRldl93YXJuKHd2aWYt
PndkZXYtPmRldiwNCiAJCQkgInRpbWVvdXQgd2hpbGUgd2FpdGluZyBvZiBzZXRfcG1fbW9kZV9j
b21wbGV0ZVxuIik7DQotCXJldHVybiBoaWZfc2V0X3BtKHd2aWYsICZwbSk7DQorCXJldHVybiBo
aWZfc2V0X3BtKHd2aWYsIHBzLCBwc190aW1lb3V0KTsNCiB9DQogDQogaW50IHdmeF9jb25mX3R4
KHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLA0KLS0g
DQoyLjIwLjENCg==
