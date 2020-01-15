Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6DF013C3B3
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729288AbgAONyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:54:31 -0500
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:14113
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726132AbgAONya (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:54:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b8n1bWbiLN/i/SPN8a1Ir38ooRWypl/NFvJH5J/s8ydWr+LBmaPwcPVDwF9HDDWiemGQ1rj8i5TpxV9qGgSSMOq2ENWhzWQpGldK5nc8JsnGNsVa9QyowQcY+FRCLGHjw1Gp+vcbcIFBRfzcVrALa+3DfShBiNtMtfQj5f7pSsKAo7VZ8lzlY3+r0tdIS7RAdO3xm9fFVoH6vNB9z0lPd23FS2hsDKvH7OGSvb5Pny62Ug2VBgAH3YQYuk3+KCHDFvqWClIEhNQrn6CYHXIYPkr3ZMYPQTw5vQKth+VgSuxp6WN5+AHiHRztZJJQpS7UHr6Zure4ea5Ts52PJHrQSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gq5Umz4L0UlsXSSwPFNYQaPHeYPTP/zJciKYxMzYSus=;
 b=lKTgUjcY50apjdeWmFbHo9zAuvpOQ767iycDA6aBkGSg2x4yTfxpeAB0PtFiYDxV+5QqqmSfYLBl+Lkb9QrS5BDnaYPsGdCSpKznm/ATgQW2yOVlCyoksK6J52oL7XK3ZnQ6+ZbR+2Yw42Q0Q+k1o92/a6Zo3oirmJwvOp78WWi/LYvucf4ZdqzlaHOC/XQEEoQA9IBRke8KA4utF0ytNF4uFz9RczeTedEGTmHzSpe6R5gy9FFrHZHaP3t490lcI7MZPOrzNU+eJQ6PFC5jwLqg8k5FOKfABRGwzuqpDc3hXRzqz9cw+939Q03Phn1SKyXsTchuKnem3y35A/8Onw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gq5Umz4L0UlsXSSwPFNYQaPHeYPTP/zJciKYxMzYSus=;
 b=LrJrHfZlD6icf+ghekWIpHqS2sGmPC6uxRPKW/qdxieUORD7i3cghC4V2nnFbir+kz8XiWPY32pJHdH5wzhDdCsYVi80E4ApL+9/VCP+lfKyo01rr9wWTKREN9vC12WuvzoS+ZX3ungIKQmZuHl3f3nS8Vx9EqEPY4jUWk+MgBc=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4094.namprd11.prod.outlook.com (10.255.180.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 13:54:08 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:54:07 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:06 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 04/65] staging: wfx: send rate policies one by one
Thread-Topic: [PATCH v2 04/65] staging: wfx: send rate policies one by one
Thread-Index: AQHVy6tBNYloxuW2g0u7z8Y0M1pzeQ==
Date:   Wed, 15 Jan 2020 13:54:07 +0000
Message-ID: <20200115135338.14374-5-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 7c04c141-eeff-4233-7ff9-08d799c263f9
x-ms-traffictypediagnostic: MN2PR11MB4094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4094C5B23DFA8A5FCD633E9E93370@MN2PR11MB4094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(396003)(346002)(136003)(376002)(189003)(199004)(316002)(110136005)(54906003)(85202003)(81156014)(5660300002)(8676002)(71200400001)(8936002)(81166006)(186003)(6506007)(86362001)(66946007)(66446008)(66476007)(66556008)(2906002)(64756008)(478600001)(6512007)(52116002)(66574012)(6486002)(1076003)(16526019)(4326008)(85182001)(107886003)(36756003)(8886007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4094;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NZn5rv8acWB6vOa2v61ehRPCz2Te75RYCXrVJl5JueQtn9NcQvmsh/WCweUUOJdb9S3Cn9Ekz1pAkeQLkGxY+lwU6VgkQA4Nf1fZLFJKBQ1g3AverqYLAPHR61Nlw7+AWar1bq0bQbBQ79nzAoVfTtPkOk0z6zn987w3QSRRBEY7QX++0qHhIYCYakXTPGEBar82zoCHZkVVmAOAnqUhZrhdM7IJfoHje9Ymnf8DQH+kKu7ySaw/47jWSUp1NfMdiXRXRXkVc1moueIka6BsR9ZZpDwnEDZsDsL9r91y+Hho/+MMig0IotBh7hejjnkfu0MH/BhuJEx0R3mtShBaqyiL+AmZF54DI1dtaGY+jY8kIrtA5amdYK8NCvLP2SkA1bkPgJe8UXznczedQwBUyV9V1lnHfgkfuQg+bs8y2GBMqqM+poPmdlrbtxikYHST
Content-Type: text/plain; charset="utf-8"
Content-ID: <FCB33FA3ADF0DF45910F13182257DF71@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c04c141-eeff-4233-7ff9-08d799c263f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:07.8194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sgsntgN+GNn3wAtv1tKPdEJKdojwnfMXZwdbrpzhhYl63JEk/Yf6nsOCh2+Nn8/LsjXpEUgUe6KoFQCP3dvMwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4094
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
