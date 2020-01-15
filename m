Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A27613BF56
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730937AbgAOMMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:12:53 -0500
Received: from mail-bn7nam10on2047.outbound.protection.outlook.com ([40.107.92.47]:27390
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730879AbgAOMMw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f7PnEw2eJF6uGmfIgXn9RNVwgOtBzSNDEyPQM9dpoG65auZX5vUTUcIv9jsVsuG4dAqxX3d7dS53lXR05BK5W7WC0b6EF0bEee69pRW93MBDU+XBbO40qUzRF2zAPxooOVLHXbjkbN8yxUbh53ur7ledXdgsI9dnJMWzLjk1X9iRyMd2pk7NU63BJS+OJXuehr9cFE9H2EEbh1CxMAA5i81ue0CwRhEFMamflLwt6BFG2Wz0/f1UeMqdYkdtKUjWDYLocuFgOR4rS0PqqEekNM/1/vnnR96i0UjNOLdQKLdsd5xBh4gNF8DG/jQ2gAiymEwMmgbtu23qep17CBMMuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Z6eY3YKLacQ9BswNsaslS7+IH+navlKtJGAw9pK9io=;
 b=BunwQhXYN7gGpQJBlzA290AIVMuRf/BSA0ipy83JgRQVI1PmrmpJH2UgvUI/I7x9rcfIJYDMm/RE8kwQKsAfIGuj4sUVdAKqp0Ayw+HMBEMD3WFwiLELJ5m2iy2l736OcfFu/hNOVtH6m8HS/CuvEUwhqCBQcTCItKrPNgE1NUb7WL2pIKp2LQfEedxkiqe5vlsF2UJ81I+eNnKM+JaxRpn0IUu62V9W+LxP6pTZ8Rcnk2eu6Nl90cZ4vI7fy/jv0pH3kmfWyUuo/t0G7781rt/ypsujFcW4OT/JQH+kVdWv0eeX3WZIezcXCz5oJuwkuHwtSDt50Z9ksRkeGfeklw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Z6eY3YKLacQ9BswNsaslS7+IH+navlKtJGAw9pK9io=;
 b=orJWJUmxIX7Q4E4j/F0U7UeS7eL1g72FeO3D/3hLFTgo5DoaYRl1wsQLr/lgVK1Dgw0Zj8TxBggwXcH76Y0Ea2VwsTyskqc+hss2FTIPIhQaJ0AuH8OUptprVNEyldlJDRe9PeQ1pZkMIdzoWjAcr1usQdGrsF8tipg77X5HhlA=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4096.namprd11.prod.outlook.com (20.179.150.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Wed, 15 Jan 2020 12:12:46 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:46 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:45 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 28/65] staging: wfx: simplify hif_update_ie()
Thread-Topic: [PATCH 28/65] staging: wfx: simplify hif_update_ie()
Thread-Index: AQHVy50YupA1e6y6AkiqEv066abeeg==
Date:   Wed, 15 Jan 2020 12:12:46 +0000
Message-ID: <20200115121041.10863-29-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 2f31d902-a808-4da9-1f8a-08d799b43b44
x-ms-traffictypediagnostic: MN2PR11MB4096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4096EC4CE6B8763D36FD3B1893370@MN2PR11MB4096.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(376002)(136003)(199004)(189003)(85202003)(66946007)(66446008)(66476007)(2906002)(107886003)(66556008)(1076003)(66574012)(64756008)(5660300002)(8936002)(6486002)(186003)(26005)(8676002)(316002)(81156014)(36756003)(52116002)(2616005)(7696005)(478600001)(16526019)(956004)(54906003)(110136005)(86362001)(71200400001)(85182001)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4096;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Gn/Uv1P4fUIgLgT6GRpAXpVQ9jvH/Y19J3H8P0eGq+xHOjaTbTYrEuEWGpgqnAVtHTrv8Q+YiAbG74vKDnIA4aC7xSNBGNILuRk9UdKZtRNZYK7s2LkZEx5ryXJ1/iouT4mCqFSD95DNDYbxnk+DXqL054tdjCgh7L9vKDXTF5ZuQuAePKQglu7l7T/aIxM4kxrAcS6KJUyUwWypbKLBPB56OGcWHAz1r9ekb+00A8A/d7ykZJ54JHCrQzHqV7X43Zo4HRC56xDuZ4d4necYYdxLY6Docqcg9NSGTR1ItIZfzUChDJTtORIm9PudcZy2cIob/iEqm3WfmI++hQILMKCCcANlvF9XD+Sh5ep3Vzc89wQmMOOOQgisF8c96XHI5rNvzWYthtDIDNBVdRkRu1io9Vi1h3jbT+aKgOIWwAtAO3j1U5BAmJ+8WzRMPewO
Content-Type: text/plain; charset="utf-8"
Content-ID: <343652A732663245BD14DAB38F2C0534@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f31d902-a808-4da9-1f8a-08d799b43b44
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:46.5416
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gczfl82uT8m8+D2P5WYI2IdqxyD81xVaJI+P4jwSt9T1wf7YdTNGsuWnLO+dvQhZNP0uXtlOzaMpZu7oK1aNlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4096
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKaGlm
X3VwZGF0ZV9pZSgpIGlzIG9ubHkgY2FsbGVkIHRvIGNoYW5nZSB0aGUgYmVhY29uIHRlbXBsYXRl
LiBTbywKc3BlY2lhbGl6ZSB0aGlzIGZ1bmN0aW9uIGFuZCBzaW1wbGlmeSB0aGUgd2F5IHRvIGNh
bGwgaXQuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVy
QHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYyB8ICA1ICsrLS0t
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5oIHwgIDMgKy0tCiBkcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jICAgIHwgMTAgKystLS0tLS0tLQogMyBmaWxlcyBjaGFuZ2VkLCA1IGluc2VydGlv
bnMoKyksIDEzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCmluZGV4IDhkZjZlNDNmZTc0
Mi4uMzJlZWJhMmZjYTQ3IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5j
CisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKQEAgLTQ2MSwxNSArNDYxLDE0IEBA
IGludCBoaWZfbWFwX2xpbmsoc3RydWN0IHdmeF92aWYgKnd2aWYsIHU4ICptYWNfYWRkciwgaW50
IGZsYWdzLCBpbnQgc3RhX2lkKQogCXJldHVybiByZXQ7CiB9CiAKLWludCBoaWZfdXBkYXRlX2ll
KHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBjb25zdCBzdHJ1Y3QgaGlmX2llX2ZsYWdzICp0YXJnZXRf
ZnJhbWUsCi0JCSAgY29uc3QgdTggKmllcywgc2l6ZV90IGllc19sZW4pCitpbnQgaGlmX3VwZGF0
ZV9pZV9iZWFjb24oc3RydWN0IHdmeF92aWYgKnd2aWYsIGNvbnN0IHU4ICppZXMsIHNpemVfdCBp
ZXNfbGVuKQogewogCWludCByZXQ7CiAJc3RydWN0IGhpZl9tc2cgKmhpZjsKIAlpbnQgYnVmX2xl
biA9IHNpemVvZihzdHJ1Y3QgaGlmX3JlcV91cGRhdGVfaWUpICsgaWVzX2xlbjsKIAlzdHJ1Y3Qg
aGlmX3JlcV91cGRhdGVfaWUgKmJvZHkgPSB3ZnhfYWxsb2NfaGlmKGJ1Zl9sZW4sICZoaWYpOwog
Ci0JbWVtY3B5KCZib2R5LT5pZV9mbGFncywgdGFyZ2V0X2ZyYW1lLCBzaXplb2Yoc3RydWN0IGhp
Zl9pZV9mbGFncykpOworCWJvZHktPmllX2ZsYWdzLmJlYWNvbiA9IDE7CiAJYm9keS0+bnVtX2ll
cyA9IGNwdV90b19sZTE2KDEpOwogCW1lbWNweShib2R5LT5pZSwgaWVzLCBpZXNfbGVuKTsKIAl3
ZnhfZmlsbF9oZWFkZXIoaGlmLCB3dmlmLT5pZCwgSElGX1JFUV9JRF9VUERBVEVfSUUsIGJ1Zl9s
ZW4pOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguaCBiL2RyaXZlcnMv
c3RhZ2luZy93ZngvaGlmX3R4LmgKaW5kZXggZmJhZWQ5OTFiMTEyLi45MjRiODg5Y2FkMGEgMTAw
NjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmgKKysrIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9oaWZfdHguaApAQCAtNTcsOCArNTcsNyBAQCBpbnQgaGlmX3N0YXJ0KHN0cnVjdCB3
ZnhfdmlmICp3dmlmLCBjb25zdCBzdHJ1Y3QgaWVlZTgwMjExX2Jzc19jb25mICpjb25mLAogCSAg
ICAgIGNvbnN0IHN0cnVjdCBpZWVlODAyMTFfY2hhbm5lbCAqY2hhbm5lbCk7CiBpbnQgaGlmX2Jl
YWNvbl90cmFuc21pdChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgYm9vbCBlbmFibGUpOwogaW50IGhp
Zl9tYXBfbGluayhzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgdTggKm1hY19hZGRyLCBpbnQgZmxhZ3Ms
IGludCBzdGFfaWQpOwotaW50IGhpZl91cGRhdGVfaWUoc3RydWN0IHdmeF92aWYgKnd2aWYsIGNv
bnN0IHN0cnVjdCBoaWZfaWVfZmxhZ3MgKnRhcmdldF9mcmFtZSwKLQkJICBjb25zdCB1OCAqaWVz
LCBzaXplX3QgaWVzX2xlbik7CitpbnQgaGlmX3VwZGF0ZV9pZV9iZWFjb24oc3RydWN0IHdmeF92
aWYgKnd2aWYsIGNvbnN0IHU4ICppZXMsIHNpemVfdCBpZXNfbGVuKTsKIGludCBoaWZfc2xfc2V0
X21hY19rZXkoc3RydWN0IHdmeF9kZXYgKndkZXYsIGNvbnN0IHU4ICpzbGtfa2V5LAogCQkgICAg
ICAgaW50IGRlc3RpbmF0aW9uKTsKIGludCBoaWZfc2xfY29uZmlnKHN0cnVjdCB3ZnhfZGV2ICp3
ZGV2LCBjb25zdCB1bnNpZ25lZCBsb25nICpiaXRtYXApOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggZTAyZWJj
MzllZDQxLi4zOTVhMjgyMzQ2YjEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3Rh
LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtODgxLDkgKzg4MSw2IEBAIHZv
aWQgd2Z4X2Jzc19pbmZvX2NoYW5nZWQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsCiAJaWYgKGNo
YW5nZWQgJiBCU1NfQ0hBTkdFRF9BU1NPQyB8fAogCSAgICBjaGFuZ2VkICYgQlNTX0NIQU5HRURf
RVJQX0NUU19QUk9UIHx8CiAJICAgIGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9FUlBfUFJFQU1CTEUp
IHsKLQkJc3RydWN0IGhpZl9pZV9mbGFncyB0YXJnZXRfZnJhbWUgPSB7Ci0JCQkuYmVhY29uID0g
MSwKLQkJfTsKIAkJdTggZXJwX2llWzNdID0geyBXTEFOX0VJRF9FUlBfSU5GTywgMSwgMCB9Owog
CiAJCWhpZl9lcnBfdXNlX3Byb3RlY3Rpb24od3ZpZiwgaW5mby0+dXNlX2N0c19wcm90KTsKQEAg
LTg5Miw3ICs4ODksNyBAQCB2b2lkIHdmeF9ic3NfaW5mb19jaGFuZ2VkKHN0cnVjdCBpZWVlODAy
MTFfaHcgKmh3LAogCQlpZiAoaW5mby0+dXNlX3Nob3J0X3ByZWFtYmxlKQogCQkJZXJwX2llWzJd
IHw9IFdMQU5fRVJQX0JBUktFUl9QUkVBTUJMRTsKIAkJaWYgKHd2aWYtPnZpZi0+dHlwZSAhPSBO
TDgwMjExX0lGVFlQRV9TVEFUSU9OKQotCQkJaGlmX3VwZGF0ZV9pZSh3dmlmLCAmdGFyZ2V0X2Zy
YW1lLCBlcnBfaWUsIHNpemVvZihlcnBfaWUpKTsKKwkJCWhpZl91cGRhdGVfaWVfYmVhY29uKHd2
aWYsIGVycF9pZSwgc2l6ZW9mKGVycF9pZSkpOwogCX0KIAogCWlmIChjaGFuZ2VkICYgQlNTX0NI
QU5HRURfQVNTT0MgfHwgY2hhbmdlZCAmIEJTU19DSEFOR0VEX0VSUF9TTE9UKQpAQCAtOTYwLDkg
Kzk1Nyw2IEBAIHZvaWQgd2Z4X3N0YV9ub3RpZnkoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0
cnVjdCBpZWVlODAyMTFfdmlmICp2aWYsCiBzdGF0aWMgaW50IHdmeF9zZXRfdGltX2ltcGwoc3Ry
dWN0IHdmeF92aWYgKnd2aWYsIGJvb2wgYWlkMF9iaXRfc2V0KQogewogCXN0cnVjdCBza19idWZm
ICpza2I7Ci0Jc3RydWN0IGhpZl9pZV9mbGFncyB0YXJnZXRfZnJhbWUgPSB7Ci0JCS5iZWFjb24g
PSAxLAotCX07CiAJdTE2IHRpbV9vZmZzZXQsIHRpbV9sZW5ndGg7CiAJdTggKnRpbV9wdHI7CiAK
QEAgLTk4Nyw3ICs5ODEsNyBAQCBzdGF0aWMgaW50IHdmeF9zZXRfdGltX2ltcGwoc3RydWN0IHdm
eF92aWYgKnd2aWYsIGJvb2wgYWlkMF9iaXRfc2V0KQogCQkJdGltX3B0cls0XSAmPSB+MTsKIAl9
CiAKLQloaWZfdXBkYXRlX2llKHd2aWYsICZ0YXJnZXRfZnJhbWUsIHRpbV9wdHIsIHRpbV9sZW5n
dGgpOworCWhpZl91cGRhdGVfaWVfYmVhY29uKHd2aWYsIHRpbV9wdHIsIHRpbV9sZW5ndGgpOwog
CWRldl9rZnJlZV9za2Ioc2tiKTsKIAogCXJldHVybiAwOwotLSAKMi4yNS4wCgo=
