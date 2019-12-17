Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1AB12317B
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbfLQQPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:15:44 -0500
Received: from mail-bn7nam10on2081.outbound.protection.outlook.com ([40.107.92.81]:6496
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728057AbfLQQPn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:15:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q65AsRvBPtHhIbxYf0ITjjrkcw8jBQqK4uS6rYBRZbEw1wxVuHIM7H//Udv0g+V38u0vPKZCL8scVuQnW3kFPiM5CmDuLttf3bohoXK0CV1kawZoCnxyLmyhMCtVpi98DAyMe1K8RkrxtkmB2sdcSuYInXf8ixSdhyMEP4fG2C9rgnLTlZ3RMYSHtw4nLyNHAYQJbLwNSGILT5TyE7sN+7BVV0s+smiQmJI++fRNFJ7jJQP3o2eji2zf9doLgmA73wM6uj1IT3K8JAtUKHjcurn+DOzpSHel4fXYCX5Uw0Y0ONfWxvr7/o5EhBQwEZXIRsYNKqBxVQEBzg24FyTEWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xjTf9a7HgmIEmVRpuLTL6kfHHNpjEbqX1VGUrVeMHzA=;
 b=W+Q4x8OJ/ELoVS+6UNZM8u/CZ4vG+wXnB39wqLAI/Q1RmQVoBDBQ68J4xjL6TitAlPbpfQH3n6LNDLxnzTm8rZBYgTSX3gtyS+vA35MzuEEQeKcbLxbKvmH5sH9eYa5hsjNxBsa00fHb/nZaRkOzQEm1M8qGvbIk4wHPnvt4shDqyMh0Ut5sxG/dj7s/XWyBDyRUTSL5BEz8Bss3bOQ/8B4LSOhQtKMMt3QMiuenp4usMfkgxqQPAMOzv86ro+DheD1gr/H58lzOVpGgO3dY83Whl1aee/a9BREoRRWaojMNTH9MIPUfIfcZWNz2IE+4mcf8Qmg1x/WR9Z1q36Jv2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xjTf9a7HgmIEmVRpuLTL6kfHHNpjEbqX1VGUrVeMHzA=;
 b=ju80BinXqwpevRgES9UM48RzDqT2xI0dukxaIcrjtzytPMk7tO7gqrRJZef+QX6ycHvwXeAIYVeETp50Twu9KgAMCboJdGVGtuNkpl6DTczh2DV8RT369dtSjfijDDT9NWPqg/XyYPFlfjRQ2Bxqo0G2P40L3vP2xR2onSXmKD4=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4208.namprd11.prod.outlook.com (52.135.36.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Tue, 17 Dec 2019 16:15:40 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:15:39 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 30/55] staging: wfx: firmware already handle powersave mode
 during scan
Thread-Topic: [PATCH v2 30/55] staging: wfx: firmware already handle powersave
 mode during scan
Thread-Index: AQHVtPUnTzH8bJzKeEKSffREJQG94w==
Date:   Tue, 17 Dec 2019 16:15:09 +0000
Message-ID: <20191217161318.31402-31-Jerome.Pouiller@silabs.com>
References: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0174.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.24.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e13c1a73-c823-4df5-96d2-08d7830c49bd
x-ms-traffictypediagnostic: MN2PR11MB4208:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB42088626C8AA595E0122A07893500@MN2PR11MB4208.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(366004)(136003)(376002)(346002)(199004)(189003)(5660300002)(316002)(6506007)(85182001)(478600001)(71200400001)(2906002)(36756003)(186003)(26005)(81166006)(54906003)(1076003)(110136005)(66574012)(4326008)(8676002)(86362001)(6486002)(6666004)(52116002)(6512007)(64756008)(85202003)(66946007)(66476007)(66446008)(66556008)(8936002)(107886003)(2616005)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4208;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uJzShR5v9zv4c5Nfr9JIvGyH4/4ex22v/+LLg3VoD/P2hdpV6iwAmvOZ7RzogPTwfzyCKyZ00p1EvN1oLXAlP3xkTcHPudp6n90ewmrZdFqKbb+zIxRjUZrOb5ZUyj4+a7rOCkBQevirL+b/xx5+BaY81B3KkEh/DpvML2j76pvqOsfjKddcrxLMh3HmxLUu4rded/+WpgVE+UTL111qQb/ZYMAoq81cd1wMGHGJsRxWl84bDky9DSCVruUSR75jg+b3VIKScR+3n0wq3jwaJti8w+BraadxDJPk30tTdXy3xwXa5VFIAVMR0vm6+jZde94rZDwbCv8DlMNZrKPp/iU7+XqXAtcXqM5sKMiRPNxt6n2mFdXiRRwFYkPJSht2pi6UbHIe1y0Z8vl65pw5bzPVikigOTc+yBrHzlY+5PePN5jG9zHheyDlwT0BkSIc
Content-Type: text/plain; charset="utf-8"
Content-ID: <9CC1FFE48CE545439E19B6ED967463F9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e13c1a73-c823-4df5-96d2-08d7830c49bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:09.7801
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xJZSA2eF0LZ5ihSbyG/YYQWPBM4C5KWhF0E6D3D0x0MvHXZMYGe4PLFAxKUNF/PBUyZbbubgPHrGPkVKEgNnOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4208
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2hl
biB1c2VyIHRyeSB0byBsYXVuY2ggc2NhbiB3aGlsZSBjb25uZWN0ZWQsIGl0IGlzIG5lY2Vzc2Fy
eSB0byBub3RpZnkKdGhlIEFQIHRoYXQgd2UgY2Fubm90IHJlY2VpdmUgZGF0YSAodXNpbmcgcG93
ZXIgc2F2ZSBtb2RlKS4KCkZpcm13YXJlIGFscmVhZHkgaGFuZGxlcyB0aGlzIGF1dG9tYXRpY2Fs
bHkgc28gdGhlIGNvZGUgaW4gdGhlIGRyaXZlciBpcwpyZWR1bmRhbnQgYW5kIGNhbiBiZSBkcm9w
cGVkLgoKQnkgZWRnZSBlZmZlY3QsIGhhY2sgb2Ygc2NhbiBzdGF0dXMgaW4gd2Z4X3NldF9wbSgp
IGlzIG5vdyB1c2VsZXNzLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9t
ZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jIHwg
MTQgLS0tLS0tLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgIHwgIDcgKy0tLS0t
LQogMiBmaWxlcyBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMjAgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3NjYW4uYwppbmRleCBjYjdhMWZkZDAwMDEuLjRiOTVlNmE5N2RmNyAxMDA2NDQKLS0tIGEvZHJp
dmVycy9zdGFnaW5nL3dmeC9zY2FuLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMK
QEAgLTE0MSwyMiArMTQxLDExIEBAIHZvaWQgd2Z4X3NjYW5fd29yayhzdHJ1Y3Qgd29ya19zdHJ1
Y3QgKndvcmspCiAJCS5zY2FuX3JlcS5zY2FuX3R5cGUudHlwZSA9IDAsICAgIC8qIEZvcmVncm91
bmQgKi8KIAl9OwogCXN0cnVjdCBpZWVlODAyMTFfY2hhbm5lbCAqZmlyc3Q7Ci0JYm9vbCBmaXJz
dF9ydW4gPSAod3ZpZi0+c2Nhbi5iZWdpbiA9PSB3dmlmLT5zY2FuLmN1cnIgJiYKLQkJCSAgd3Zp
Zi0+c2Nhbi5iZWdpbiAhPSB3dmlmLT5zY2FuLmVuZCk7CiAJaW50IGk7CiAKIAlkb3duKCZ3dmlm
LT5zY2FuLmxvY2spOwogCW11dGV4X2xvY2soJnd2aWYtPndkZXYtPmNvbmZfbXV0ZXgpOwogCi0J
aWYgKGZpcnN0X3J1bikgewotCQlpZiAod3ZpZi0+c3RhdGUgPT0gV0ZYX1NUQVRFX1NUQSAmJgot
CQkgICAgISh3dmlmLT5wb3dlcnNhdmVfbW9kZS5wbV9tb2RlLmVudGVyX3BzbSkpIHsKLQkJCXN0
cnVjdCBoaWZfcmVxX3NldF9wbV9tb2RlIHBtID0gd3ZpZi0+cG93ZXJzYXZlX21vZGU7Ci0KLQkJ
CXBtLnBtX21vZGUuZW50ZXJfcHNtID0gMTsKLQkJCXdmeF9zZXRfcG0od3ZpZiwgJnBtKTsKLQkJ
fQotCX0KIAogCWlmICghd3ZpZi0+c2Nhbi5yZXEgfHwgd3ZpZi0+c2Nhbi5jdXJyID09IHd2aWYt
PnNjYW4uZW5kKSB7CiAJCWlmICh3dmlmLT5zY2FuLm91dHB1dF9wb3dlciAhPSB3dmlmLT53ZGV2
LT5vdXRwdXRfcG93ZXIpCkBAIC0xNzcsOSArMTY2LDYgQEAgdm9pZCB3Znhfc2Nhbl93b3JrKHN0
cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIAkJX19pZWVlODAyMTFfc2Nhbl9jb21wbGV0ZWRfY29t
cGF0KHd2aWYtPndkZXYtPmh3LAogCQkJCQkJICB3dmlmLT5zY2FuLnN0YXR1cyA/IDEgOiAwKTsK
IAkJdXAoJnd2aWYtPnNjYW4ubG9jayk7Ci0JCWlmICh3dmlmLT5zdGF0ZSA9PSBXRlhfU1RBVEVf
U1RBICYmCi0JCSAgICAhKHd2aWYtPnBvd2Vyc2F2ZV9tb2RlLnBtX21vZGUuZW50ZXJfcHNtKSkK
LQkJCXdmeF9zZXRfcG0od3ZpZiwgJnd2aWYtPnBvd2Vyc2F2ZV9tb2RlKTsKIAkJcmV0dXJuOwog
CX0KIAlmaXJzdCA9ICp3dmlmLT5zY2FuLmN1cnI7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCA2MmU2NTQ5M2E0
ZmUuLmZiNDVhYTY2ZmM1NiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwor
KysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC0zNzUsNyArMzc1LDYgQEAgaW50IHdm
eF9zZXRfcG0oc3RydWN0IHdmeF92aWYgKnd2aWYsIGNvbnN0IHN0cnVjdCBoaWZfcmVxX3NldF9w
bV9tb2RlICphcmcpCiB7CiAJc3RydWN0IGhpZl9yZXFfc2V0X3BtX21vZGUgcG0gPSAqYXJnOwog
CXUxNiB1YXBzZF9mbGFnczsKLQlpbnQgcmV0OwogCiAJaWYgKHd2aWYtPnN0YXRlICE9IFdGWF9T
VEFURV9TVEEgfHwgIXd2aWYtPmJzc19wYXJhbXMuYWlkKQogCQlyZXR1cm4gMDsKQEAgLTM5Niwx
MSArMzk1LDcgQEAgaW50IHdmeF9zZXRfcG0oc3RydWN0IHdmeF92aWYgKnd2aWYsIGNvbnN0IHN0
cnVjdCBoaWZfcmVxX3NldF9wbV9tb2RlICphcmcpCiAJCQkJCSBtc2Vjc190b19qaWZmaWVzKDMw
MCkpKQogCQlkZXZfd2Fybih3dmlmLT53ZGV2LT5kZXYsCiAJCQkgInRpbWVvdXQgd2hpbGUgd2Fp
dGluZyBvZiBzZXRfcG1fbW9kZV9jb21wbGV0ZVxuIik7Ci0JcmV0ID0gaGlmX3NldF9wbSh3dmlm
LCAmcG0pOwotCS8vIEZJWE1FOiB3aHkgPwotCWlmICgtRVRJTUVET1VUID09IHd2aWYtPnNjYW4u
c3RhdHVzKQotCQl3dmlmLT5zY2FuLnN0YXR1cyA9IDE7Ci0JcmV0dXJuIHJldDsKKwlyZXR1cm4g
aGlmX3NldF9wbSh3dmlmLCAmcG0pOwogfQogCiBpbnQgd2Z4X3NldF9ydHNfdGhyZXNob2xkKHN0
cnVjdCBpZWVlODAyMTFfaHcgKmh3LCB1MzIgdmFsdWUpCi0tIAoyLjI0LjAKCg==
