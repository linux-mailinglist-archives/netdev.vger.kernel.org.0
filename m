Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4662A6865
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 16:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731176AbgKDPxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 10:53:38 -0500
Received: from mail-dm6nam11on2049.outbound.protection.outlook.com ([40.107.223.49]:54240
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731157AbgKDPxc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 10:53:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKIyd5D8QMZfnKOnpqxDtkVCC6yn4Xig9U8j3eDd6gp29F4BWChBHXnuMutszE4r2U+xvMPXC7n/vie12Zmgn7Ez9CeZPohAX87HoKRQf3ZnRsDtga3wKmhypNqqej93Ct05ab0h4d8zDAQmDPCWj5IkaRbKl85ZnhLSD7dPAsbE8NuZnN6h9bcVHKavZoYfZzzeLKnxZ4IFD9kWp6Act17SgFHvfO9HkP6H3mV0RKuul+i2o/IArcCmk088WxysKIfXAqef5HF3SxD2gl3gJpeh5BKPvAPL6BU/glKxgOIeE98Ieek7+X/EyPju3jFVWeDxcfXWOUAYZqqSaHi7Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=edc12fpY37LlQK8Q6v4oXf+Qq4aIaiABOQkqEIdKP7k=;
 b=EuNO1QrFviy6EBsQ4UPIyTBOBQMD4NGZd5WOUv+o65NN/6YgrBiutW4fD3jjy/WlH59fsV6hVP6RzrqwkvLa/yL7lSODZGQE/RvkC4FOw5Ryb1oji+sFijlNgWeVCX2uFPdyFrBEE0gygTD0oOecbzUc820367zIYXVm6u8vMhWrB8YNROViY8/wc2bfh2edSb6D+ytCdFcEC/cZY0icPPIBbkhykV/57p7CK8n3L3u7WceqQRDqS8z+FkfIOFF62Qsilq7/o4c6oVe+FIRxChoIm1Ov0T4fZDKrw3ybJjlUnHp6yDgnLm/G+YQuVz8c2DqCAHTv+j5gg/Ja4YlSow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=edc12fpY37LlQK8Q6v4oXf+Qq4aIaiABOQkqEIdKP7k=;
 b=NU4G6brZGlHW/YlXhBZ2ZpgJRdqwrPQBJ1C934dgMAhvrwI5ShA7vkTgjHPnwCIkCeQlQT41aMXSmiu13JivGJiByISi6v1TTmgTDYqNiLL7cDXwu80kqx4Bgg9vsh9FTPwn8QogNcs3k2MyCLjL8UiiyIER+GiZM3UEXM6u/78=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.32; Wed, 4 Nov
 2020 15:52:58 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3499.032; Wed, 4 Nov 2020
 15:52:58 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 16/24] wfx: add data_rx.c/data_rx.h
Date:   Wed,  4 Nov 2020 16:51:59 +0100
Message-Id: <20201104155207.128076-17-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201104155207.128076-1-Jerome.Pouiller@silabs.com>
References: <20201104155207.128076-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: SN6PR01CA0032.prod.exchangelabs.com (2603:10b6:805:b6::45)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by SN6PR01CA0032.prod.exchangelabs.com (2603:10b6:805:b6::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Wed, 4 Nov 2020 15:52:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe335203-f6d5-4569-7efb-08d880d9b376
X-MS-TrafficTypeDiagnostic: SN6PR11MB2718:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2718F7BBDA5EAE98A316F90593EF0@SN6PR11MB2718.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i2w8E+hxMjX2n3lheXGYRSi2rznFHJBPnQnf5paEmV0CSiNBkpawJ1oixXW7hhpQiOdNv+N2TOokF0zxJoZ9si6DwKLlYcd+m6hOUeBdjP6pSlnE3VrSZlxcSlbmCgLFtWX6aDfFuhx6I0Wnt8VOlx2RQi8WEu7vXAMkgXePALnso5WciSMDrHjdDOOOVwWJrtGtxoLBPoP45iYWQke/XkWk/WPuAWETfby2q/1ME/HMH51p8S4jECUQLUNAY8N/VP1MYhhIVDRlrb/M9vaA9lf920XXS8ScyBDc3tGCfZ1pbl6a0tR+TOPEiN0MfIV4CmroraeQluZv91u7TVBUjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39850400004)(136003)(396003)(8936002)(478600001)(186003)(16526019)(956004)(2616005)(6486002)(8676002)(66476007)(66556008)(66946007)(316002)(7696005)(83380400001)(26005)(54906003)(107886003)(36756003)(52116002)(7416002)(4326008)(5660300002)(86362001)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Yep4i03Y0QE87M6SMtecMAlrJCF2Cdu8VjCGkshXO4X7rzD1mfNQwpZvC7LsSioX/f2AJRh1OGIUhJS8PM4obx5PgWIz/Et5gPGWI4XoC0Hzpm5wha3IwOGBXtokDTBUsPVn6sybkvGH3NK6vX5Pefi8Ljxbqq6az01cKQIOPoHiPbcu/aeBr8UsGl6SMFYcPeZrCo2ELc42KPTZtae5zJTShu2b5aOCdpeVgRWhjdyWMN4jd2k/QytcBEAFDREgjb0k8vxNG2OYJc/Io6zqPi3b1NpJu3BnBC9O6gYD9WtFpjBjTZ2fI5zszkB5Z/3ADYYO2jmwn3uG6QIoZFQTxNbfNDvjTvtstQnPg91P6d2/uDQjgFCOM61OnxkNBHPbiEcjoBOHajKnvrxgVtKvvbL/H5DSjub47SeNfZ02VoA/U0ZLE7hzPoeOpSok1COEPB5PhUWteLUN8OLf3uNVb+B/ITy5uYZqqPH+0Z+/77Tm/nPPk2Y3yyxQEaP7gl7TWb5gguvhSzwumLGNwpEXK2+hyJbCnVaUt3/sGAXjKFDhzM6NqUupxtk24Zd0lZgkP12+kgdW/Xu1kGd7K0pakvxrkiQI4c8qLG5zWRiO2ReJioSlzp9mr0S2hRLz+x70qrkAO6rbXEPWwhxIJZ4eTQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe335203-f6d5-4569-7efb-08d880d9b376
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2020 15:52:58.2469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6qBBtD3ghiYlR9t2MNq/Xk3PXc503UKx3rsuldHFHvsT8+5Mn4jARXOhu3sg8cl9D63r1XeyzBcDaqZLJv0Jmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2718
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
