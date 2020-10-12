Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7671628B2C0
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 12:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388020AbgJLKsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 06:48:39 -0400
Received: from mail-dm6nam11on2077.outbound.protection.outlook.com ([40.107.223.77]:59904
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387969AbgJLKsc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 06:48:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iyMfNmZpY+TiTrfEkxXlFpBupaq9fSbVOm7pTOfiFJDoeXuAfSAmKJr6pJ649D26+igOAUOLY3iGTZNCLag8CfFtZbZ2CedqsWb0qNciJsulp1gR0OBR5LVJChNZ3fIGp8tkpiD20GyKYPJJNO1/i7eVzulgoP4eplZkoMK7reeokhSQUjtuheLiXPaDClB2LPrXEM9YEZnWKLMphVw5YiM/DeARq5oFxXvR9uE1J8eYDKwoWndlzgRe5L1k2ZAOZ+BlOSCURsiZyN94X0a7v/QQ0o4CnJnL8OuDdWMYNS7QeEbq6xS0s6yHxAiOYre9j3Th42l23ZfrJV2UjIHmAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=edc12fpY37LlQK8Q6v4oXf+Qq4aIaiABOQkqEIdKP7k=;
 b=WoLK402aXIJvlMYaR06ughF9j2txSglnynULeR/sJk4cSsfgwnbM6HMeYrg7UL4+lPQVGoZ+WQjXO4ie9ZaqslcptpFfTrs8o+f5EsyfzR1Jj2LKTCaGlHe7/ZRlbENnMnpg5NAtooYcr+K76tifA8iQn1RQFEcC1Qe4HWwDeg7yIDFw0QhNIH0U9rYTjOVCAChxVVJFQkykN1AmwzIXTGm8IubVMKUSy6xQekVLuE1N7zz6sdmWpEbP5uch1aNLBYIwpaidGcEG2hqfdwmM8GoAp4fhoqK3GH91BTCvlXD4/Vi3drKxVcagYBmmUblGTZOkEYkb72Q5lXOIyOFQyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=edc12fpY37LlQK8Q6v4oXf+Qq4aIaiABOQkqEIdKP7k=;
 b=MlJR5BmamVzQ6Nkl2XeeUM0rt5+8QBuoPsknqYyWh8emuy+lcbxBTUqLptqsS38ENCX2pGOCkhXZ2YOYXIk3kf8UI/k8Lq97xGUCPvjsiJ/un/Jc6DH4Pzo0Wt8odPltnh9+otkr5os1TSmjSoSLdrBV15nIAU/Ciqk4EMWhxX8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4734.namprd11.prod.outlook.com (2603:10b6:806:99::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Mon, 12 Oct
 2020 10:47:34 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3455.029; Mon, 12 Oct 2020
 10:47:34 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 15/23] wfx: add data_rx.c/data_rx.h
Date:   Mon, 12 Oct 2020 12:46:40 +0200
Message-Id: <20201012104648.985256-16-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012104648.985256-1-Jerome.Pouiller@silabs.com>
References: <20201012104648.985256-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: PR3P189CA0005.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:52::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (82.67.86.106) by PR3P189CA0005.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:52::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend Transport; Mon, 12 Oct 2020 10:47:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7757ba4a-4a89-4711-8710-08d86e9c39e6
X-MS-TrafficTypeDiagnostic: SA0PR11MB4734:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB4734D547B2F57BF872642F8293070@SA0PR11MB4734.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YEvCtLBoSgyTr0QMAnXwuagjrxIGlVs5aUyTjR9iBAUfzsrbXaFkHCMEMT9ehfJ3YjzKsVictahcWcU52bpS/dmPCzM8UjIMXo80x1dnXsMlMBOXizvne/Ax0sf+yck3hxUy/iTgy6Uk97M9BtGVFSZfTkLRZ5LYwr6yZvw09wfhIYzYQ0AoXgQGgBxxSzfvwK89HDqb1m2OxlIkOXaAVLh7Gup4fvAqhK+Ru5oU4prf363AlScP+/diVCGhzsOep7m5pBgurBiKcQrOnrO3thVRE3lnza8mQvnL/WXmzewIspV69SWP5w9cSgH/B4hnycHi0bx7gY4Y0IyE+OeM2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(396003)(366004)(136003)(346002)(376002)(66556008)(66476007)(6512007)(26005)(36756003)(66946007)(16526019)(186003)(316002)(4326008)(2616005)(956004)(1076003)(5660300002)(107886003)(6486002)(54906003)(86362001)(8676002)(83380400001)(8936002)(52116002)(2906002)(6506007)(8886007)(6666004)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ig+8pMWl/BqN/PV9LqpAgTM1n6onOPYMROUvYn3Tp2FlE4o7LTfSX3WBb+653S8fDFmYoZtGUYYaajGjunbyVpuLtI+RLL05dc0kdRpmXi64eBcGe5xqvrVxVDK3/RqphOnGNdRZ5MCzf0i2D1CExLGfp3flGPZNj1wBgU3XpCNcssQtQXdO6juecsOXVhDaxu5uC6Y7Ykf22V2WURn0gD3ZrXKdu/M1aqV2L6ToTiQV2fZx+E1oSF4hcmgBMXFXYxdCt2COCfn4e3EiJakKcOISARAajMbul+qqeA7l34ksqE6Pc5xgHG6CIHuxWiyxpnedOX8uCFXVijHndxwQ3yhFzQ3sbJYlG3yl+kqQYOm9brWnmravTZeVqWCxd0555MlPEevzGiI9WShSL3HpTvqEa8UwnR/Hku/Eji2NU7UQ0bUlQqY6mgk4QPdfts52t8oZtbbcyy9/ktUJeYyIIAFkszstaH8RWBchOX8Z1u3mXCPUX0RVOGy99fjqAYInq8dftTjvWLAPSAZq2P6MLsKUxDpvnZLMzwnNmM568rOpXJV0BAHdvMzyhTduKPunijFZJYETmLxYmVABc+sOTz82VfR7Cn82BouFxvi9dT/bpq0FhwF+Q6oBYE/ZJ/1ObHnwkKU1k4E3W8k8Q8gtow==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7757ba4a-4a89-4711-8710-08d86e9c39e6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2020 10:47:34.0106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dz86ik5/aPVcQTC3462RopsSwrqYcL6RgRe5Y8QpSjSUW6ovRKml5UZxQOfxsLSFh7koKclVZYx2XECJPTA+zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4734
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2ln
bmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29t
PgotLS0KIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0YV9yeC5jIHwgOTMgKysr
KysrKysrKysrKysrKysrKysrKysKIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0
YV9yeC5oIHwgMTggKysrKysKIDIgZmlsZXMgY2hhbmdlZCwgMTExIGluc2VydGlvbnMoKykKIGNy
ZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L2RhdGFfcngu
YwogY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0
YV9yeC5oCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mvc2lsYWJzL3dmeC9kYXRh
X3J4LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9zaWxhYnMvd2Z4L2RhdGFfcnguYwpuZXcgZmls
ZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwMDAwMDAuLjM4NWYyZDQyYTBlMgotLS0gL2Rldi9u
dWxsCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0YV9yeC5jCkBAIC0w
LDAgKzEsOTMgQEAKKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkKKy8q
CisgKiBEYXRhcGF0aCBpbXBsZW1lbnRhdGlvbi4KKyAqCisgKiBDb3B5cmlnaHQgKGMpIDIwMTct
MjAyMCwgU2lsaWNvbiBMYWJvcmF0b3JpZXMsIEluYy4KKyAqIENvcHlyaWdodCAoYykgMjAxMCwg
U1QtRXJpY3Nzb24KKyAqLworI2luY2x1ZGUgPGxpbnV4L2V0aGVyZGV2aWNlLmg+CisjaW5jbHVk
ZSA8bmV0L21hYzgwMjExLmg+CisKKyNpbmNsdWRlICJkYXRhX3J4LmgiCisjaW5jbHVkZSAid2Z4
LmgiCisjaW5jbHVkZSAiYmguaCIKKyNpbmNsdWRlICJzdGEuaCIKKworc3RhdGljIHZvaWQgd2Z4
X3J4X2hhbmRsZV9iYShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0IGllZWU4MDIxMV9tZ210
ICptZ210KQoreworCWludCBwYXJhbXMsIHRpZDsKKworCWlmICh3ZnhfYXBpX29sZGVyX3RoYW4o
d3ZpZi0+d2RldiwgMywgNikpCisJCXJldHVybjsKKworCXN3aXRjaCAobWdtdC0+dS5hY3Rpb24u
dS5hZGRiYV9yZXEuYWN0aW9uX2NvZGUpIHsKKwljYXNlIFdMQU5fQUNUSU9OX0FEREJBX1JFUToK
KwkJcGFyYW1zID0gbGUxNl90b19jcHUobWdtdC0+dS5hY3Rpb24udS5hZGRiYV9yZXEuY2FwYWIp
OworCQl0aWQgPSAocGFyYW1zICYgSUVFRTgwMjExX0FEREJBX1BBUkFNX1RJRF9NQVNLKSA+PiAy
OworCQlpZWVlODAyMTFfc3RhcnRfcnhfYmFfc2Vzc2lvbl9vZmZsKHd2aWYtPnZpZiwgbWdtdC0+
c2EsIHRpZCk7CisJCWJyZWFrOworCWNhc2UgV0xBTl9BQ1RJT05fREVMQkE6CisJCXBhcmFtcyA9
IGxlMTZfdG9fY3B1KG1nbXQtPnUuYWN0aW9uLnUuZGVsYmEucGFyYW1zKTsKKwkJdGlkID0gKHBh
cmFtcyAmICBJRUVFODAyMTFfREVMQkFfUEFSQU1fVElEX01BU0spID4+IDEyOworCQlpZWVlODAy
MTFfc3RvcF9yeF9iYV9zZXNzaW9uX29mZmwod3ZpZi0+dmlmLCBtZ210LT5zYSwgdGlkKTsKKwkJ
YnJlYWs7CisJfQorfQorCit2b2lkIHdmeF9yeF9jYihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKKwkg
ICAgICAgY29uc3Qgc3RydWN0IGhpZl9pbmRfcnggKmFyZywgc3RydWN0IHNrX2J1ZmYgKnNrYikK
K3sKKwlzdHJ1Y3QgaWVlZTgwMjExX3J4X3N0YXR1cyAqaGRyID0gSUVFRTgwMjExX1NLQl9SWENC
KHNrYik7CisJc3RydWN0IGllZWU4MDIxMV9oZHIgKmZyYW1lID0gKHN0cnVjdCBpZWVlODAyMTFf
aGRyICopc2tiLT5kYXRhOworCXN0cnVjdCBpZWVlODAyMTFfbWdtdCAqbWdtdCA9IChzdHJ1Y3Qg
aWVlZTgwMjExX21nbXQgKilza2ItPmRhdGE7CisKKwltZW1zZXQoaGRyLCAwLCBzaXplb2YoKmhk
cikpOworCisJaWYgKGFyZy0+c3RhdHVzID09IEhJRl9TVEFUVVNfUlhfRkFJTF9NSUMpCisJCWhk
ci0+ZmxhZyB8PSBSWF9GTEFHX01NSUNfRVJST1IgfCBSWF9GTEFHX0lWX1NUUklQUEVEOworCWVs
c2UgaWYgKGFyZy0+c3RhdHVzKQorCQlnb3RvIGRyb3A7CisKKwlpZiAoc2tiLT5sZW4gPCBzaXpl
b2Yoc3RydWN0IGllZWU4MDIxMV9wc3BvbGwpKSB7CisJCWRldl93YXJuKHd2aWYtPndkZXYtPmRl
diwgIm1hbGZvcm1lZCBTRFUgcmVjZWl2ZWRcbiIpOworCQlnb3RvIGRyb3A7CisJfQorCisJaGRy
LT5iYW5kID0gTkw4MDIxMV9CQU5EXzJHSFo7CisJaGRyLT5mcmVxID0gaWVlZTgwMjExX2NoYW5u
ZWxfdG9fZnJlcXVlbmN5KGFyZy0+Y2hhbm5lbF9udW1iZXIsCisJCQkJCQkgICBoZHItPmJhbmQp
OworCisJaWYgKGFyZy0+cnhlZF9yYXRlID49IDE0KSB7CisJCWhkci0+ZW5jb2RpbmcgPSBSWF9F
TkNfSFQ7CisJCWhkci0+cmF0ZV9pZHggPSBhcmctPnJ4ZWRfcmF0ZSAtIDE0OworCX0gZWxzZSBp
ZiAoYXJnLT5yeGVkX3JhdGUgPj0gNCkgeworCQloZHItPnJhdGVfaWR4ID0gYXJnLT5yeGVkX3Jh
dGUgLSAyOworCX0gZWxzZSB7CisJCWhkci0+cmF0ZV9pZHggPSBhcmctPnJ4ZWRfcmF0ZTsKKwl9
CisKKwlpZiAoIWFyZy0+cmNwaV9yc3NpKSB7CisJCWhkci0+ZmxhZyB8PSBSWF9GTEFHX05PX1NJ
R05BTF9WQUw7CisJCWRldl9pbmZvKHd2aWYtPndkZXYtPmRldiwgInJlY2VpdmVkIGZyYW1lIHdp
dGhvdXQgUlNTSSBkYXRhXG4iKTsKKwl9CisJaGRyLT5zaWduYWwgPSBhcmctPnJjcGlfcnNzaSAv
IDIgLSAxMTA7CisJaGRyLT5hbnRlbm5hID0gMDsKKworCWlmIChhcmctPmVuY3J5cCkKKwkJaGRy
LT5mbGFnIHw9IFJYX0ZMQUdfREVDUllQVEVEOworCisJLy8gQmxvY2sgYWNrIG5lZ290aWF0aW9u
IGlzIG9mZmxvYWRlZCBieSB0aGUgZmlybXdhcmUuIEhvd2V2ZXIsCisJLy8gcmUtb3JkZXJpbmcg
bXVzdCBiZSBkb25lIGJ5IHRoZSBtYWM4MDIxMS4KKwlpZiAoaWVlZTgwMjExX2lzX2FjdGlvbihm
cmFtZS0+ZnJhbWVfY29udHJvbCkgJiYKKwkgICAgbWdtdC0+dS5hY3Rpb24uY2F0ZWdvcnkgPT0g
V0xBTl9DQVRFR09SWV9CQUNLICYmCisJICAgIHNrYi0+bGVuID4gSUVFRTgwMjExX01JTl9BQ1RJ
T05fU0laRSkgeworCQl3ZnhfcnhfaGFuZGxlX2JhKHd2aWYsIG1nbXQpOworCQlnb3RvIGRyb3A7
CisJfQorCisJaWVlZTgwMjExX3J4X2lycXNhZmUod3ZpZi0+d2Rldi0+aHcsIHNrYik7CisJcmV0
dXJuOworCitkcm9wOgorCWRldl9rZnJlZV9za2Ioc2tiKTsKK30KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL3NpbGFicy93ZngvZGF0YV9yeC5oIGIvZHJpdmVycy9uZXQvd2lyZWxl
c3Mvc2lsYWJzL3dmeC9kYXRhX3J4LmgKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAw
MDAwMDAwLi40YzBkYTM3ZjIwODQKLS0tIC9kZXYvbnVsbAorKysgYi9kcml2ZXJzL25ldC93aXJl
bGVzcy9zaWxhYnMvd2Z4L2RhdGFfcnguaApAQCAtMCwwICsxLDE4IEBACisvKiBTUERYLUxpY2Vu
c2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5ICovCisvKgorICogRGF0YXBhdGggaW1wbGVtZW50
YXRpb24uCisgKgorICogQ29weXJpZ2h0IChjKSAyMDE3LTIwMjAsIFNpbGljb24gTGFib3JhdG9y
aWVzLCBJbmMuCisgKiBDb3B5cmlnaHQgKGMpIDIwMTAsIFNULUVyaWNzc29uCisgKi8KKyNpZm5k
ZWYgV0ZYX0RBVEFfUlhfSAorI2RlZmluZSBXRlhfREFUQV9SWF9ICisKK3N0cnVjdCB3Znhfdmlm
Oworc3RydWN0IHNrX2J1ZmY7CitzdHJ1Y3QgaGlmX2luZF9yeDsKKwordm9pZCB3ZnhfcnhfY2Io
c3RydWN0IHdmeF92aWYgKnd2aWYsCisJICAgICAgIGNvbnN0IHN0cnVjdCBoaWZfaW5kX3J4ICph
cmcsIHN0cnVjdCBza19idWZmICpza2IpOworCisjZW5kaWYgLyogV0ZYX0RBVEFfUlhfSCAqLwot
LSAKMi4yOC4wCgo=
