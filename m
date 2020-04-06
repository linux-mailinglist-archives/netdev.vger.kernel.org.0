Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0417919F45F
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 13:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbgDFLSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 07:18:34 -0400
Received: from mail-dm6nam11on2071.outbound.protection.outlook.com ([40.107.223.71]:6126
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727125AbgDFLSc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 07:18:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lkhwnJYimYKxLrdhVU7Kbs+ZVkUWjYgBi3V6HehT73iJx8zPVsLD2xlnsTdZfrUOe8UTvW5jBJOqMtJJhlCMrpM+VOjBotcG9inpkIsuVHiVqNYZxRUS4U+y43n4igAPVLMkMVL3nRYsbLYRVTJWaObDUg5f8e3Uk4sJKldfV/g+gjbJ5l32NGmxiqvo7H+HRRe2ZPlEysOs508pe0QeS+Dif7yO1nKCGq5mrVEeeqTZKiR54wXC3mHBM39pSijrmrLw6a7EgZNyZcInuqv0faLsJGXMEzy5+/46V4cA2Sgl/IOucCkdF+NFdeqmsHkPpHR3xS34ifDVT+L1EY+jMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=epV5OE2uRpefDLHUseHqf8jRskPj/AAkhm53GUx3fGA=;
 b=Fu44F45isGvOyci/rknDxt4Gat2Jfh7BhOQawf2NAcnmkWp1BLnBg0Co2sTS8tWHmaP38LVehJ9N6QYqYs0ALM2+OFrBYGHlGCLqpvF+GtVE3QjY2Vg4XF9OZX5ekWq0H9/7I0kQp4tqjyfVH4rPKwK4rUNDxkFmg2NALW17QTmoH1z0EZbgecuuN5PVFyOcyG8QPPUeZx+RU0HoOx8mpQd/fIiPHqFbHMe5ecXmlXwPJ9n1Go5MkD57Rz49g7Vmacw02/6v4VtJeVPZwZRpY4tirwsSDmyUih/sjbD4ARZB7VcWEKy4ZBNwrI//vrD6lNncVvtyE5iSTm1Dn0CJ8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=epV5OE2uRpefDLHUseHqf8jRskPj/AAkhm53GUx3fGA=;
 b=VG5vcKRmxZqnC4ymbhfPy6ILsX3NyNTJeJt4eh0MtQA0bwjNue7ckIFdJoSjR1lE9umHertZ4kwTsc4CVAGizIgSffOyJZYXt1qcerp+Eg0FMNXv7bJU5QK6rIdnBYeuHTPlMEH3Fi0QoAdX1qNnY3Ct4gPvxYrgHBT0PcVXTTQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from BN6PR11MB4052.namprd11.prod.outlook.com (2603:10b6:405:7a::37)
 by BN6PR11MB3860.namprd11.prod.outlook.com (2603:10b6:405:77::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15; Mon, 6 Apr
 2020 11:18:20 +0000
Received: from BN6PR11MB4052.namprd11.prod.outlook.com
 ([fe80::e0af:e9de:ffce:7376]) by BN6PR11MB4052.namprd11.prod.outlook.com
 ([fe80::e0af:e9de:ffce:7376%3]) with mapi id 15.20.2878.018; Mon, 6 Apr 2020
 11:18:20 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 03/11] staging: wfx: relocate TX_RETRY_POLICY_MAX and TX_RETRY_POLICY_INVALID to hif API
Date:   Mon,  6 Apr 2020 13:17:48 +0200
Message-Id: <20200406111756.154086-4-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200406111756.154086-1-Jerome.Pouiller@silabs.com>
References: <20200406111756.154086-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:3:d4::20) To BN6PR11MB4052.namprd11.prod.outlook.com
 (2603:10b6:405:7a::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM5PR05CA0010.namprd05.prod.outlook.com (2603:10b6:3:d4::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.13 via Frontend Transport; Mon, 6 Apr 2020 11:18:18 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52b18c32-aeca-4802-8428-08d7da1c3645
X-MS-TrafficTypeDiagnostic: BN6PR11MB3860:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR11MB3860DD5B0EDC98664295E77893C20@BN6PR11MB3860.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-Forefront-PRVS: 0365C0E14B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4052.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(396003)(39850400004)(346002)(366004)(136003)(376002)(186003)(16526019)(7696005)(52116002)(36756003)(5660300002)(107886003)(316002)(54906003)(66946007)(66476007)(4326008)(2616005)(66556008)(1076003)(66574012)(81166006)(6666004)(6486002)(8936002)(2906002)(86362001)(81156014)(8676002)(478600001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yBiG+2DwAznJMg4JwcgoRKRYqfHALRFkv/rJYCA+cotJuwPLPBRhqABlk0glOMT6iT4yCShT2FTyC4p+dsnvHJqXVmGukrmpShNcJyXOziiXheUkFegZrHLRZS22Xa7bFbs9Eo0WWnlSTZYQXhgNNyMv1GqV060R7Cb0smuNhhP0iihlhIBSbHTW07dGjJbxTvc0FjyvmpxFbAQUsAvkPrR700s7EFp7NfRja7jUKDYO4zygMioa0UJ0ECWMeby8gAafEsgtsWBryLC10KlMQ03AXarfEiFkvCNjvp28uE75BROVAkBvXzTY5XKr125q7af4lGeI1MPhiflJ887xOe1xkuyqasLOFtSalHcsjQEHZ4NMxFkS5ltoSGcI/6BnuPcbc7Fj1SV9zAYNZelMnxwUs+3fGWkJx/xcZq56D3rEf1yDrFpnfAxFMHm0NVjY
X-MS-Exchange-AntiSpam-MessageData: hgoKtisI+FU/YsYh3vUv1tCIPWhUGwWIq+paIoIqMV+QvP2IBscabQJyS1WXwThcqBeT7jRcRCM2RLCdd/zyFJqFSVRgf9kIkFs35qr1xE/IX1FxPXeDIFgceFToP9nXfvMWujQfPyg9mNdfQosqClgGQEiGYbZ3jD1kbw4Al8eHsqKsb8Zp/VIFt0PWXmJ0lrLHslbzC6oYO+weunIuOA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52b18c32-aeca-4802-8428-08d7da1c3645
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2020 11:18:20.3917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q9TDWmFhpjmGPKQMRHnvXzTjj5YoiDQ7csdFP1RMzF+7o6Sw1JJDblZf4rqj3OXgFZnOnQrr8C1TyZL6CQlP5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3860
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGRlZmluaXRpb25zIFRYX1JFVFJZX1BPTElDWV9NQVggYW5kIFRYX1JFVFJZX1BPTElDWV9JTlZB
TElEIGFyZQppbXBvc2VkIGJ5IHRoZSBoYXJkd2FyZS4gVGhlcmVmb3JlLCB0aGV5IHNob3VsZCBi
ZSBsb2NhdGVkIGluIHRoZQpoYXJkd2FyZSBpbnRlcmZhY2UgQVBJLgoKU2lnbmVkLW9mZi1ieTog
SsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZl
cnMvc3RhZ2luZy93ZngvZGF0YV90eC5jICAgICB8IDE2ICsrKysrKystLS0tLS0tLS0KIGRyaXZl
cnMvc3RhZ2luZy93ZngvZGF0YV90eC5oICAgICB8ICAyICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4
L2hpZl9hcGlfbWliLmggfCAgMyArKy0KIDMgZmlsZXMgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygr
KSwgMTEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRh
X3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYwppbmRleCA3NTdlMzc0NTQzOTEu
LmEzNGY2MjMxYjg3OCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMK
KysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKQEAgLTE2LDggKzE2LDYgQEAKICNp
bmNsdWRlICJ0cmFjZXMuaCIKICNpbmNsdWRlICJoaWZfdHhfbWliLmgiCiAKLSNkZWZpbmUgV0ZY
X0lOVkFMSURfUkFURV9JRCAgICAxNQotCiBzdGF0aWMgaW50IHdmeF9nZXRfaHdfcmF0ZShzdHJ1
Y3Qgd2Z4X2RldiAqd2RldiwKIAkJCSAgIGNvbnN0IHN0cnVjdCBpZWVlODAyMTFfdHhfcmF0ZSAq
cmF0ZSkKIHsKQEAgLTExNyw3ICsxMTUsNyBAQCBzdGF0aWMgaW50IHdmeF90eF9wb2xpY3lfZ2V0
KHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCWlmIChsaXN0X2VtcHR5KCZjYWNoZS0+ZnJlZSkpIHsK
IAkJV0FSTigxLCAidW5hYmxlIHRvIGdldCBhIHZhbGlkIFR4IHBvbGljeSIpOwogCQlzcGluX3Vu
bG9ja19iaCgmY2FjaGUtPmxvY2spOwotCQlyZXR1cm4gV0ZYX0lOVkFMSURfUkFURV9JRDsKKwkJ
cmV0dXJuIEhJRl9UWF9SRVRSWV9QT0xJQ1lfSU5WQUxJRDsKIAl9CiAJaWR4ID0gd2Z4X3R4X3Bv
bGljeV9maW5kKGNhY2hlLCAmd2FudGVkKTsKIAlpZiAoaWR4ID49IDApIHsKQEAgLTE0Niw3ICsx
NDQsNyBAQCBzdGF0aWMgdm9pZCB3ZnhfdHhfcG9saWN5X3B1dChzdHJ1Y3Qgd2Z4X3ZpZiAqd3Zp
ZiwgaW50IGlkeCkKIAlpbnQgdXNhZ2UsIGxvY2tlZDsKIAlzdHJ1Y3QgdHhfcG9saWN5X2NhY2hl
ICpjYWNoZSA9ICZ3dmlmLT50eF9wb2xpY3lfY2FjaGU7CiAKLQlpZiAoaWR4ID09IFdGWF9JTlZB
TElEX1JBVEVfSUQpCisJaWYgKGlkeCA9PSBISUZfVFhfUkVUUllfUE9MSUNZX0lOVkFMSUQpCiAJ
CXJldHVybjsKIAlzcGluX2xvY2tfYmgoJmNhY2hlLT5sb2NrKTsKIAlsb2NrZWQgPSBsaXN0X2Vt
cHR5KCZjYWNoZS0+ZnJlZSk7CkBAIC0xNjQsMTEgKzE2MiwxMSBAQCBzdGF0aWMgaW50IHdmeF90
eF9wb2xpY3lfdXBsb2FkKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQogCiAJZG8gewogCQlzcGluX2xv
Y2tfYmgoJnd2aWYtPnR4X3BvbGljeV9jYWNoZS5sb2NrKTsKLQkJZm9yIChpID0gMDsgaSA8IEhJ
Rl9NSUJfTlVNX1RYX1JBVEVfUkVUUllfUE9MSUNJRVM7ICsraSkKKwkJZm9yIChpID0gMDsgaSA8
IEhJRl9UWF9SRVRSWV9QT0xJQ1lfTUFYOyArK2kpCiAJCQlpZiAoIXBvbGljaWVzW2ldLnVwbG9h
ZGVkICYmCiAJCQkgICAgbWVtemNtcChwb2xpY2llc1tpXS5yYXRlcywgc2l6ZW9mKHBvbGljaWVz
W2ldLnJhdGVzKSkpCiAJCQkJYnJlYWs7Ci0JCWlmIChpIDwgSElGX01JQl9OVU1fVFhfUkFURV9S
RVRSWV9QT0xJQ0lFUykgeworCQlpZiAoaSA8IEhJRl9UWF9SRVRSWV9QT0xJQ1lfTUFYKSB7CiAJ
CQlwb2xpY2llc1tpXS51cGxvYWRlZCA9IHRydWU7CiAJCQltZW1jcHkodG1wX3JhdGVzLCBwb2xp
Y2llc1tpXS5yYXRlcywgc2l6ZW9mKHRtcF9yYXRlcykpOwogCQkJc3Bpbl91bmxvY2tfYmgoJnd2
aWYtPnR4X3BvbGljeV9jYWNoZS5sb2NrKTsKQEAgLTE3Niw3ICsxNzQsNyBAQCBzdGF0aWMgaW50
IHdmeF90eF9wb2xpY3lfdXBsb2FkKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQogCQl9IGVsc2Ugewog
CQkJc3Bpbl91bmxvY2tfYmgoJnd2aWYtPnR4X3BvbGljeV9jYWNoZS5sb2NrKTsKIAkJfQotCX0g
d2hpbGUgKGkgPCBISUZfTUlCX05VTV9UWF9SQVRFX1JFVFJZX1BPTElDSUVTKTsKKwl9IHdoaWxl
IChpIDwgSElGX1RYX1JFVFJZX1BPTElDWV9NQVgpOwogCXJldHVybiAwOwogfQogCkBAIC0yMDAs
NyArMTk4LDcgQEAgdm9pZCB3ZnhfdHhfcG9saWN5X2luaXQoc3RydWN0IHdmeF92aWYgKnd2aWYp
CiAJSU5JVF9MSVNUX0hFQUQoJmNhY2hlLT51c2VkKTsKIAlJTklUX0xJU1RfSEVBRCgmY2FjaGUt
PmZyZWUpOwogCi0JZm9yIChpID0gMDsgaSA8IEhJRl9NSUJfTlVNX1RYX1JBVEVfUkVUUllfUE9M
SUNJRVM7ICsraSkKKwlmb3IgKGkgPSAwOyBpIDwgSElGX1RYX1JFVFJZX1BPTElDWV9NQVg7ICsr
aSkKIAkJbGlzdF9hZGQoJmNhY2hlLT5jYWNoZVtpXS5saW5rLCAmY2FjaGUtPmZyZWUpOwogfQog
CkBAIC0zMDgsNyArMzA2LDcgQEAgc3RhdGljIHU4IHdmeF90eF9nZXRfcmF0ZV9pZChzdHJ1Y3Qg
d2Z4X3ZpZiAqd3ZpZiwKIAogCXJhdGVfaWQgPSB3ZnhfdHhfcG9saWN5X2dldCh3dmlmLAogCQkJ
CSAgICB0eF9pbmZvLT5kcml2ZXJfcmF0ZXMsICZ0eF9wb2xpY3lfcmVuZXcpOwotCWlmIChyYXRl
X2lkID09IFdGWF9JTlZBTElEX1JBVEVfSUQpCisJaWYgKHJhdGVfaWQgPT0gSElGX1RYX1JFVFJZ
X1BPTElDWV9JTlZBTElEKQogCQlkZXZfd2Fybih3dmlmLT53ZGV2LT5kZXYsICJ1bmFibGUgdG8g
Z2V0IGEgdmFsaWQgVHggcG9saWN5Iik7CiAKIAlpZiAodHhfcG9saWN5X3JlbmV3KSB7CmRpZmYg
LS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguaCBiL2RyaXZlcnMvc3RhZ2luZy93
ZngvZGF0YV90eC5oCmluZGV4IDdmMjAxZjYyNjQxMC4uYTMwOGFmM2Q2OGFkIDEwMDY0NAotLS0g
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L2RhdGFfdHguaApAQCAtMjYsNyArMjYsNyBAQCBzdHJ1Y3QgdHhfcG9saWN5IHsKIH07CiAKIHN0
cnVjdCB0eF9wb2xpY3lfY2FjaGUgewotCXN0cnVjdCB0eF9wb2xpY3kgY2FjaGVbSElGX01JQl9O
VU1fVFhfUkFURV9SRVRSWV9QT0xJQ0lFU107CisJc3RydWN0IHR4X3BvbGljeSBjYWNoZVtISUZf
VFhfUkVUUllfUE9MSUNZX01BWF07CiAJLy8gRklYTUU6IHVzZSBhIHRyZWVzIGFuZCBkcm9wIGhh
c2ggZnJvbSB0eF9wb2xpY3kKIAlzdHJ1Y3QgbGlzdF9oZWFkIHVzZWQ7CiAJc3RydWN0IGxpc3Rf
aGVhZCBmcmVlOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX21pYi5o
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX21pYi5oCmluZGV4IDBjNjdjZDRjMTU5My4u
MzZjOTE1Mjc4NWM0IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfbWli
LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX21pYi5oCkBAIC01MDAsNyArNTAw
LDggQEAgc3RydWN0IGhpZl9taWJfdHhfcmF0ZV9yZXRyeV9wb2xpY3kgewogCXU4ICAgIHJhdGVz
WzEyXTsKIH0gX19wYWNrZWQ7CiAKLSNkZWZpbmUgSElGX01JQl9OVU1fVFhfUkFURV9SRVRSWV9Q
T0xJQ0lFUyAgICAxNQorI2RlZmluZSBISUZfVFhfUkVUUllfUE9MSUNZX01BWCAgICAgICAgMTUK
KyNkZWZpbmUgSElGX1RYX1JFVFJZX1BPTElDWV9JTlZBTElEICAgIEhJRl9UWF9SRVRSWV9QT0xJ
Q1lfTUFYCiAKIHN0cnVjdCBoaWZfbWliX3NldF90eF9yYXRlX3JldHJ5X3BvbGljeSB7CiAJdTgg
ICAgbnVtX3R4X3JhdGVfcG9saWNpZXM7Ci0tIAoyLjI1LjEKCg==
