Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABAB5121142
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbfLPRGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:06:44 -0500
Received: from mail-dm6nam11on2042.outbound.protection.outlook.com ([40.107.223.42]:6255
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726633AbfLPRGn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:06:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HchIrFv6vBsxQEgatq4SGm9o6uyqWOxIVf4LTIBkyiPPrm0LQbcaqkW81h3+ybgeiOMSeR1pZlXROq8Vpqjs2rdfmbLPpq4thAUZ0cbLbajzQ6Lf0diVB4P6ansylg+FJVyDZe8S2WD6Ewa8OfyAgkB/sYZ6LnRBCffgFwtlNq0aXeA8QvP3nGBr3GrrAusDqvcIklSWCzElFXKVhnqUz3BbJG9Vv3kHdApoqY9u3nHd3DQs59eA2FTkSpChXl7a932t05zwVlrqTmzOc6Wl7BXlSAR//j5vXGlXBF+ge5OtA8k4wyulA3UBAeHfBVQs9LasKjjZzN74nTeACGmf7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sAM3mAFJJtCHD7pIdZPWNHEWDJbOAllU24BIuV8QVeM=;
 b=fyLptE9Txjg6Osir7pjJ2qObvSxnTMDTxPxu7leaLw7nvRuWDQ5ONoTAKYWDeixx8U/EplifXJYwgMmjFtE6amXYcKoY231CmOk6rHmWJBvwxZ14F7spkqrttAF/jkDG0u0PirOj+3cd9c45wa3BH4VgUBa5wcN3Us2vphrDFjuxIkxY7uGeDK2yxRgMUer3sxwWER/x5BVH5cqXgnPoffkKVShNEvTGJbuiq8bNvMpfB54tB9QTpu+CTjBS1JcvxA6ZFliCW9SxrAQJTKXLFIx5PKE1zRIQmNyP8Q65NgCsb5uzmKhRlvIccrKEvTM03hAIPTLWzQ3yaYlW41S4hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sAM3mAFJJtCHD7pIdZPWNHEWDJbOAllU24BIuV8QVeM=;
 b=BY8747YNnoakCAE/jCVif/cGp1X8UTCjNH0a/9kUFt70JkcClB3xrl4tnqsKHrH4U4FJrln9XXbpzLy35xC/DCPbI8yXdwn+Q6NysrPW8ILsfc6tWV0WX/fSJDrpKew3bpE5qrRyHKAVmmhtuNKyyQ3swheQLeWvgoNgaPHJ5NY=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4445.namprd11.prod.outlook.com (52.135.37.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Mon, 16 Dec 2019 17:06:37 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:06:37 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 31/55] staging: wfx: declare wfx_set_pm() static
Thread-Topic: [PATCH 31/55] staging: wfx: declare wfx_set_pm() static
Thread-Index: AQHVtDLJasMxqvHr6kuD9Db82xY32A==
Date:   Mon, 16 Dec 2019 17:03:49 +0000
Message-ID: <20191216170302.29543-32-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: b7508d64-0773-476c-cbdd-08d7824a4fc7
x-ms-traffictypediagnostic: MN2PR11MB4445:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4445B3E34CB466BEAD69C20093510@MN2PR11MB4445.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(39850400004)(396003)(136003)(189003)(199004)(110136005)(6486002)(107886003)(36756003)(186003)(316002)(66946007)(54906003)(5660300002)(66574012)(66446008)(66556008)(85182001)(66476007)(76116006)(91956017)(64756008)(2616005)(6506007)(85202003)(2906002)(26005)(71200400001)(6512007)(4326008)(8936002)(81166006)(1076003)(478600001)(86362001)(81156014)(6666004)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4445;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CE/ZNODBvQFrNwDGNfqKeyFA9BmkP7LMi3oPGxHg21SdDxdHmqSM4wMAvqNxx3aQNRCrUKrc3VByamtqPwh5U0G7QKVNYMS1Yk0S/g6RtUDO9ze/fcmby1eJKHf83n0SdPY8gmaJTppgRdnLX0FB9SvdzJyIlhUszUkCH9qIavtChywEGJ6EbUGD/6ZvthrjY03fiPX48fnn4V4YGAbt9/ZyJEmn8p1o5lV+eam8Lw+brWe9koJHeMWeXVLj/r5vKPFH75u9Re+uM8ZAFEmzWYv6s681IajyrWBH6yWCH8+ybEY1o/116E2BmBP1+iuMkgg366uAjjh5VEQYbCnjr+8ACyg1ZV0Ni3rLRidNB95uKpxCt6bZ6ZH3248sbfju22Ir8CxhkDSmU45t//7jQNRLYHQVxnCIjp237FQORHs/bBHMZOSLUwj1Rcydt1WW
Content-Type: text/plain; charset="utf-8"
Content-ID: <50CBB27566C73740B1A88418F3858BF0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7508d64-0773-476c-cbdd-08d7824a4fc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:49.9457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sxJo2UwdrRNWg5W8hUjA6bmM95C8Pq1wLHFPyLq7pDy5XHG6C/5yZUX0LOsYx5z/10huQ13+VsJevu/CLcL7ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4445
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQp3
Znhfc2V0X3BtKCkgaXMgbm93IG9ubHkgdXNlZCBieSBzdGEuYy4gSXQgY2FuIGJlIGRlY2xhcmVk
IHN0YXRpYy4NCg0KU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3Vp
bGxlckBzaWxhYnMuY29tPg0KLS0tDQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyB8IDU3ICsr
KysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLQ0KIGRyaXZlcnMvc3RhZ2luZy93
Zngvc3RhLmggfCAgMSAtDQogMiBmaWxlcyBjaGFuZ2VkLCAzMCBpbnNlcnRpb25zKCspLCAyOCBk
ZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jDQppbmRleCBmYjQ1YWE2NmZjNTYuLmViMDg3YjljODA5
NyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMNCisrKyBiL2RyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmMNCkBAIC0zMjYsNiArMzI2LDM2IEBAIHZvaWQgd2Z4X2NvbmZpZ3Vy
ZV9maWx0ZXIoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsDQogCX0NCiB9DQogDQorc3RhdGljIGlu
dCB3Znhfc2V0X3BtKHN0cnVjdCB3ZnhfdmlmICp3dmlmLA0KKwkJICAgICAgY29uc3Qgc3RydWN0
IGhpZl9yZXFfc2V0X3BtX21vZGUgKmFyZykNCit7DQorCXN0cnVjdCBoaWZfcmVxX3NldF9wbV9t
b2RlIHBtID0gKmFyZzsNCisJdTE2IHVhcHNkX2ZsYWdzOw0KKwlpbnQgcmV0Ow0KKw0KKwlpZiAo
d3ZpZi0+c3RhdGUgIT0gV0ZYX1NUQVRFX1NUQSB8fCAhd3ZpZi0+YnNzX3BhcmFtcy5haWQpDQor
CQlyZXR1cm4gMDsNCisNCisJbWVtY3B5KCZ1YXBzZF9mbGFncywgJnd2aWYtPnVhcHNkX2luZm8s
IHNpemVvZih1YXBzZF9mbGFncykpOw0KKw0KKwlpZiAodWFwc2RfZmxhZ3MgIT0gMCkNCisJCXBt
LnBtX21vZGUuZmFzdF9wc20gPSAwOw0KKw0KKwkvLyBLZXJuZWwgZGlzYWJsZSBQb3dlclNhdmUg
d2hlbiBtdWx0aXBsZSB2aWZzIGFyZSBpbiB1c2UuIEluIGNvbnRyYXJ5LA0KKwkvLyBpdCBpcyBh
YnNvbHV0bHkgbmVjZXNzYXJ5IHRvIGVuYWJsZSBQb3dlclNhdmUgZm9yIFdGMjAwDQorCS8vIEZJ
WE1FOiBvbmx5IGlmIGNoYW5uZWwgdmlmMCAhPSBjaGFubmVsIHZpZjENCisJaWYgKHd2aWZfY291
bnQod3ZpZi0+d2RldikgPiAxKSB7DQorCQlwbS5wbV9tb2RlLmVudGVyX3BzbSA9IDE7DQorCQlw
bS5wbV9tb2RlLmZhc3RfcHNtID0gMDsNCisJfQ0KKw0KKwlpZiAoIXdhaXRfZm9yX2NvbXBsZXRp
b25fdGltZW91dCgmd3ZpZi0+c2V0X3BtX21vZGVfY29tcGxldGUsDQorCQkJCQkgbXNlY3NfdG9f
amlmZmllcygzMDApKSkNCisJCWRldl93YXJuKHd2aWYtPndkZXYtPmRldiwNCisJCQkgInRpbWVv
dXQgd2hpbGUgd2FpdGluZyBvZiBzZXRfcG1fbW9kZV9jb21wbGV0ZVxuIik7DQorCXJldHVybiBo
aWZfc2V0X3BtKHd2aWYsICZwbSk7DQorfQ0KKw0KIGludCB3ZnhfY29uZl90eChzdHJ1Y3QgaWVl
ZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwNCiAJCSAgIHUxNiBxdWV1
ZSwgY29uc3Qgc3RydWN0IGllZWU4MDIxMV90eF9xdWV1ZV9wYXJhbXMgKnBhcmFtcykNCiB7DQpA
QCAtMzcxLDMzICs0MDEsNiBAQCBpbnQgd2Z4X2NvbmZfdHgoc3RydWN0IGllZWU4MDIxMV9odyAq
aHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYsDQogCXJldHVybiByZXQ7DQogfQ0KIA0KLWlu
dCB3Znhfc2V0X3BtKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBjb25zdCBzdHJ1Y3QgaGlmX3JlcV9z
ZXRfcG1fbW9kZSAqYXJnKQ0KLXsNCi0Jc3RydWN0IGhpZl9yZXFfc2V0X3BtX21vZGUgcG0gPSAq
YXJnOw0KLQl1MTYgdWFwc2RfZmxhZ3M7DQotDQotCWlmICh3dmlmLT5zdGF0ZSAhPSBXRlhfU1RB
VEVfU1RBIHx8ICF3dmlmLT5ic3NfcGFyYW1zLmFpZCkNCi0JCXJldHVybiAwOw0KLQ0KLQltZW1j
cHkoJnVhcHNkX2ZsYWdzLCAmd3ZpZi0+dWFwc2RfaW5mbywgc2l6ZW9mKHVhcHNkX2ZsYWdzKSk7
DQotDQotCWlmICh1YXBzZF9mbGFncyAhPSAwKQ0KLQkJcG0ucG1fbW9kZS5mYXN0X3BzbSA9IDA7
DQotDQotCS8vIEtlcm5lbCBkaXNhYmxlIFBvd2VyU2F2ZSB3aGVuIG11bHRpcGxlIHZpZnMgYXJl
IGluIHVzZS4gSW4gY29udHJhcnksDQotCS8vIGl0IGlzIGFic29sdXRseSBuZWNlc3NhcnkgdG8g
ZW5hYmxlIFBvd2VyU2F2ZSBmb3IgV0YyMDANCi0JaWYgKHd2aWZfY291bnQod3ZpZi0+d2Rldikg
PiAxKSB7DQotCQlwbS5wbV9tb2RlLmVudGVyX3BzbSA9IDE7DQotCQlwbS5wbV9tb2RlLmZhc3Rf
cHNtID0gMDsNCi0JfQ0KLQ0KLQlpZiAoIXdhaXRfZm9yX2NvbXBsZXRpb25fdGltZW91dCgmd3Zp
Zi0+c2V0X3BtX21vZGVfY29tcGxldGUsDQotCQkJCQkgbXNlY3NfdG9famlmZmllcygzMDApKSkN
Ci0JCWRldl93YXJuKHd2aWYtPndkZXYtPmRldiwNCi0JCQkgInRpbWVvdXQgd2hpbGUgd2FpdGlu
ZyBvZiBzZXRfcG1fbW9kZV9jb21wbGV0ZVxuIik7DQotCXJldHVybiBoaWZfc2V0X3BtKHd2aWYs
ICZwbSk7DQotfQ0KLQ0KIGludCB3Znhfc2V0X3J0c190aHJlc2hvbGQoc3RydWN0IGllZWU4MDIx
MV9odyAqaHcsIHUzMiB2YWx1ZSkNCiB7DQogCXN0cnVjdCB3ZnhfZGV2ICp3ZGV2ID0gaHctPnBy
aXY7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaCBiL2RyaXZlcnMvc3Rh
Z2luZy93Zngvc3RhLmgNCmluZGV4IDcyMWI3Y2VlOWMxMC4uNDcxOTgwN2JjMjVhIDEwMDY0NA0K
LS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaA0KKysrIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuaA0KQEAgLTk3LDcgKzk3LDYgQEAgdm9pZCB3Znhfc3VzcGVuZF9yZXN1bWUoc3RydWN0
IHdmeF92aWYgKnd2aWYsDQogLy8gT3RoZXIgSGVscGVycw0KIHZvaWQgd2Z4X2NxbV9ic3Nsb3Nz
X3NtKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBpbnQgaW5pdCwgaW50IGdvb2QsIGludCBiYWQpOw0K
IHZvaWQgd2Z4X3VwZGF0ZV9maWx0ZXJpbmcoc3RydWN0IHdmeF92aWYgKnd2aWYpOw0KLWludCB3
Znhfc2V0X3BtKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBjb25zdCBzdHJ1Y3QgaGlmX3JlcV9zZXRf
cG1fbW9kZSAqYXJnKTsNCiBpbnQgd2Z4X2Z3ZF9wcm9iZV9yZXEoc3RydWN0IHdmeF92aWYgKnd2
aWYsIGJvb2wgZW5hYmxlKTsNCiANCiAjZW5kaWYgLyogV0ZYX1NUQV9IICovDQotLSANCjIuMjAu
MQ0K
