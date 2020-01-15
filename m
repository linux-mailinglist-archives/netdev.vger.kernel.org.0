Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01BE413C096
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731204AbgAOMTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:19:54 -0500
Received: from mail-co1nam11on2084.outbound.protection.outlook.com ([40.107.220.84]:24056
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730377AbgAOMM1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j9wpfxaAiOXZ91com0JRYfo2TJTc/2yr2tV09oRxTwJ+zSR763ssXOVAzhC2hI0Eq+EnPGovTH/+YgMj7C3QtDTHQzOpzcz7Q7n9rDerqcXI+/V/V9Bw+/GsHamhkWmVb/daOujzmNp/PAzlaI3rLTeucZAIS3wy+2jS8USBC/kjBbNhENf5Sr+bGFzrW+/2zBtCX4zceeEcT/SoUMt8lCNxNHcKbon+0oVroG9vcCqi8GFWW637O+apY6O92P8Yu1BKXzxJqYWCN8ef64w84gTADCWNzB7w4r0fhKl1ojHTWm8LekrjzCEl3SGK0O/hdQ7WPUF1Xya1LXrlUWRDsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gq5Umz4L0UlsXSSwPFNYQaPHeYPTP/zJciKYxMzYSus=;
 b=m7dbZqn0D7dlWLZ5GXR13YS8Y4CDCVJUN06raEjRWD+3G3figgAps5hEWDJGLOtR5fxbApZDZFNWGhd4uitCKl2rwKUXExHEQi/zPv57cT6KWnwHaSEx7YpoIqB+LlgxOp71DHalztCU96pSsVVqcjRW9XRxPClK6MHDwn0WK/Lmt91GnyQKVLgpf/UzKdrCrcPZxcq5NfQuh2r0b15S2AwBjnpeXr21IZaP6R1yumPtWCIzT9sTPoLEyoYgtUoD6prFadY/fUA8To3s8DEeVjw/IcIN5vVwny49k1soE4shbrRwvUub1Xn4NWgQCjahKTT+sDkHXU3Px/kVoeL3NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gq5Umz4L0UlsXSSwPFNYQaPHeYPTP/zJciKYxMzYSus=;
 b=T0REsEuy4t4G/THNFMEZDTBaymDOaqeW9H927EPW39hyIfmwQVBN1SP4hwlZRDav6Q4IWVQkqc8TfSjRflmRVqIZKsbbipuNqMEBJejInZb2u4mJLIz8+YDS3G/Z8WsrbmGcekvSK7t1GNxkpY2w0eI4aeTLGDr63OCWeRukl1w=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:12:13 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:13 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:12 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 04/65] staging: wfx: send rate policies one by one
Thread-Topic: [PATCH 04/65] staging: wfx: send rate policies one by one
Thread-Index: AQHVy50FiohjPBflH0qwFWQsKYtkXg==
Date:   Wed, 15 Jan 2020 12:12:13 +0000
Message-ID: <20200115121041.10863-5-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: c519b72a-dffb-433e-d577-08d799b427c0
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB39343D4B58E24DAA5D5BF3F493370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RayMog2P/VQWW2SKnNavntS+/FSFLglEakJR8/5hJde0QgIHp3ZBAS/gmiI00Nvi8DM5jevouFk+fca9ClbtcrikT22wQwaiYEcXKMAVBPFdLa6P7i76dfY2RRNDWEKY+ntVMVwnvGOItA0IAPWkn5EhOorW4SKWtFdycFMj3rA5MVSmTU6hfdAMJ9FhNAkwGZoT8WQ8evRkhDONA+oLjF8m1lyruQ9/hNB/Gc3Fz8eW98HqR7OuUVlNUFBjUP4aXSLDb/qv46JlvJUNeaN5usngLEU9ag+8lQR9BJlySG760EoOAkAzImFAZJpMYMM1laji0cQnV8+xEcp2epbx9/ONMkyIlN5JcR8JZDFGoAKhrj7Hw7kJbv3+aTReqiK1QcLP1MFHO/eXJt7dpl9ObkE9EWU68w5A36hw6Mi24rocWB8M3YkYUiuHbvaqHduv
Content-Type: text/plain; charset="utf-8"
Content-ID: <FFA1B29C3485BE489181C82B3D6C51D2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c519b72a-dffb-433e-d577-08d799b427c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:13.8345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nWCFg0ovRvWPSMB9KLB28n0p4s0f5R9J4L9xbWXdwgd/Bc1iW1Byu2ovLmWQZbjLHB3Zb/DEMKSg71AL7PX04Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKUmF0
ZSBwb2xpY2llcyAoYWthLiB0eF9yYXRlX3JldHJ5X3BvbGljeSBpbiBoYXJkd2FyZSBBUEkpIGFy
ZSBzZW50IHRvCmRldmljZSBhc3luY2hyb25vdXNseSBmcm9tIHR4IHJlcXVlc3RzLiBTbywgdGhl
IGRldmljZSBtYWludGFpbnMgYSBsaXN0Cm9mIGFjdGl2ZSByYXRlIHBvbGljaWVzIGFuZCB0aGUg
dHggcmVxdWVzdHMgb25seSByZWZlcmVuY2UgYW4gZXhpc3RlbnQKcmF0ZSBwb2xpY3kuCgpUaGUg
ZGV2aWNlIEFQSSBhbGxvd3MgdG8gc2VuZCBtdWx0aXBsZSByYXRlIHBvbGljaWVzIGF0IG9uY2Uu
IEhvd2V2ZXIsCnRoaXMgcHJvcGVydHkgaXMgdmVyeSByYXJlbHkgdXNlZC4gV2UgcHJlZmVyIHRv
IHNlbmQgcmF0ZSBwb2xpY2llcyBvbmUKYnkgb25lIGFuZCBzaW1wbGlmeSB0aGUgYXJjaGl0ZWN0
dXJlLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBz
aWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIHwgNTMgKysrKysr
KysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAyNSBpbnNlcnRp
b25zKCspLCAyOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L2RhdGFfdHguYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCmluZGV4IGIyYTMyNWM0
N2IyZC4uZmI1MWM1OTEwYWNlIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFf
dHguYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYwpAQCAtMjE3LDM3ICsyMTcs
MzQgQEAgc3RhdGljIHZvaWQgd2Z4X3R4X3BvbGljeV9wdXQoc3RydWN0IHdmeF92aWYgKnd2aWYs
IGludCBpZHgpCiAKIHN0YXRpYyBpbnQgd2Z4X3R4X3BvbGljeV91cGxvYWQoc3RydWN0IHdmeF92
aWYgKnd2aWYpCiB7Ci0JaW50IGk7Ci0Jc3RydWN0IHR4X3BvbGljeV9jYWNoZSAqY2FjaGUgPSAm
d3ZpZi0+dHhfcG9saWN5X2NhY2hlOwogCXN0cnVjdCBoaWZfbWliX3NldF90eF9yYXRlX3JldHJ5
X3BvbGljeSAqYXJnID0KLQkJa3phbGxvYyhzdHJ1Y3Rfc2l6ZShhcmcsCi0JCQkJICAgIHR4X3Jh
dGVfcmV0cnlfcG9saWN5LAotCQkJCSAgICBISUZfTUlCX05VTV9UWF9SQVRFX1JFVFJZX1BPTElD
SUVTKSwKLQkJCUdGUF9LRVJORUwpOwotCXN0cnVjdCBoaWZfbWliX3R4X3JhdGVfcmV0cnlfcG9s
aWN5ICpkc3Q7CisJCWt6YWxsb2Moc3RydWN0X3NpemUoYXJnLCB0eF9yYXRlX3JldHJ5X3BvbGlj
eSwgMSksIEdGUF9LRVJORUwpOworCXN0cnVjdCB0eF9wb2xpY3kgKnBvbGljaWVzID0gd3ZpZi0+
dHhfcG9saWN5X2NhY2hlLmNhY2hlOworCWludCBpOwogCi0Jc3Bpbl9sb2NrX2JoKCZjYWNoZS0+
bG9jayk7Ci0JLyogVXBsb2FkIG9ubHkgbW9kaWZpZWQgZW50cmllcy4gKi8KLQlmb3IgKGkgPSAw
OyBpIDwgSElGX01JQl9OVU1fVFhfUkFURV9SRVRSWV9QT0xJQ0lFUzsgKytpKSB7Ci0JCXN0cnVj
dCB0eF9wb2xpY3kgKnNyYyA9ICZjYWNoZS0+Y2FjaGVbaV07Ci0KLQkJaWYgKCFzcmMtPnVwbG9h
ZGVkICYmIG1lbXpjbXAoc3JjLT5yYXRlcywgc2l6ZW9mKHNyYy0+cmF0ZXMpKSkgewotCQkJZHN0
ID0gYXJnLT50eF9yYXRlX3JldHJ5X3BvbGljeSArCi0JCQkJYXJnLT5udW1fdHhfcmF0ZV9wb2xp
Y2llczsKLQotCQkJZHN0LT5wb2xpY3lfaW5kZXggPSBpOwotCQkJZHN0LT5zaG9ydF9yZXRyeV9j
b3VudCA9IDI1NTsKLQkJCWRzdC0+bG9uZ19yZXRyeV9jb3VudCA9IDI1NTsKLQkJCWRzdC0+Zmly
c3RfcmF0ZV9zZWwgPSAxOwotCQkJZHN0LT50ZXJtaW5hdGUgPSAxOwotCQkJZHN0LT5jb3VudF9p
bml0ID0gMTsKLQkJCW1lbWNweSgmZHN0LT5yYXRlcywgc3JjLT5yYXRlcywgc2l6ZW9mKHNyYy0+
cmF0ZXMpKTsKLQkJCXNyYy0+dXBsb2FkZWQgPSB0cnVlOwotCQkJYXJnLT5udW1fdHhfcmF0ZV9w
b2xpY2llcysrOworCWRvIHsKKwkJc3Bpbl9sb2NrX2JoKCZ3dmlmLT50eF9wb2xpY3lfY2FjaGUu
bG9jayk7CisJCWZvciAoaSA9IDA7IGkgPCBISUZfTUlCX05VTV9UWF9SQVRFX1JFVFJZX1BPTElD
SUVTOyArK2kpCisJCQlpZiAoIXBvbGljaWVzW2ldLnVwbG9hZGVkICYmCisJCQkgICAgbWVtemNt
cChwb2xpY2llc1tpXS5yYXRlcywgc2l6ZW9mKHBvbGljaWVzW2ldLnJhdGVzKSkpCisJCQkJYnJl
YWs7CisJCWlmIChpIDwgSElGX01JQl9OVU1fVFhfUkFURV9SRVRSWV9QT0xJQ0lFUykgeworCQkJ
cG9saWNpZXNbaV0udXBsb2FkZWQgPSAxOworCQkJYXJnLT5udW1fdHhfcmF0ZV9wb2xpY2llcyA9
IDE7CisJCQlhcmctPnR4X3JhdGVfcmV0cnlfcG9saWN5WzBdLnBvbGljeV9pbmRleCA9IGk7CisJ
CQlhcmctPnR4X3JhdGVfcmV0cnlfcG9saWN5WzBdLnNob3J0X3JldHJ5X2NvdW50ID0gMjU1Owor
CQkJYXJnLT50eF9yYXRlX3JldHJ5X3BvbGljeVswXS5sb25nX3JldHJ5X2NvdW50ID0gMjU1Owor
CQkJYXJnLT50eF9yYXRlX3JldHJ5X3BvbGljeVswXS5maXJzdF9yYXRlX3NlbCA9IDE7CisJCQlh
cmctPnR4X3JhdGVfcmV0cnlfcG9saWN5WzBdLnRlcm1pbmF0ZSA9IDE7CisJCQlhcmctPnR4X3Jh
dGVfcmV0cnlfcG9saWN5WzBdLmNvdW50X2luaXQgPSAxOworCQkJbWVtY3B5KCZhcmctPnR4X3Jh
dGVfcmV0cnlfcG9saWN5WzBdLnJhdGVzLAorCQkJICAgICAgIHBvbGljaWVzW2ldLnJhdGVzLCBz
aXplb2YocG9saWNpZXNbaV0ucmF0ZXMpKTsKKwkJCXNwaW5fdW5sb2NrX2JoKCZ3dmlmLT50eF9w
b2xpY3lfY2FjaGUubG9jayk7CisJCQloaWZfc2V0X3R4X3JhdGVfcmV0cnlfcG9saWN5KHd2aWYs
IGFyZyk7CisJCX0gZWxzZSB7CisJCQlzcGluX3VubG9ja19iaCgmd3ZpZi0+dHhfcG9saWN5X2Nh
Y2hlLmxvY2spOwogCQl9Ci0JfQotCXNwaW5fdW5sb2NrX2JoKCZjYWNoZS0+bG9jayk7Ci0JaGlm
X3NldF90eF9yYXRlX3JldHJ5X3BvbGljeSh3dmlmLCBhcmcpOworCX0gd2hpbGUgKGkgPCBISUZf
TUlCX05VTV9UWF9SQVRFX1JFVFJZX1BPTElDSUVTKTsKIAlrZnJlZShhcmcpOwogCXJldHVybiAw
OwogfQotLSAKMi4yNS4wCgo=
