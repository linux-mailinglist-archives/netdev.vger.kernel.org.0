Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716B3285CC7
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgJGKUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:20:21 -0400
Received: from mail-bn8nam12on2066.outbound.protection.outlook.com ([40.107.237.66]:19424
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727623AbgJGKUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 06:20:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TK3hzUFMV6SS+JA8ar4yKYOln8KnVu9TNiSTLEZqBYi7mVmjMkhv0ydGKiGnfYAsPhkJyfk0+opbh+nWW7mph2tA5ymuwBUAAy0sv8M2q69KLaOe2jiRAlHHWTl4RtSSmeGZA38B+LZ0itffdVOC5y+9SyDUQSikbW16WbRZRCfUGUGV4Btv/IJgpBgFQfMULfV5UoqVQcHVkPQao8LpymBNgYVQ6HhB5WgFv4j7dlX1ovpzNmXburoOJ3a+94Dxyqe4ypHLVZ/yh8l+rBIJI6oovubuuagUpNBuZ5AWCgM/rpTGlwXc45rAEgKDKt5tcs4mhiEypt/j0aw/fgaGeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rh8rU3iw4pr91IwT9End/AcLY2Vp/Cx2fpEvjXsBWfM=;
 b=BfbqJsgZSAxOpYvwjI6HF8Qq2x2J2OBZRKYHMhlRxHwt7CRTrNZAQSYw6BhOYWrEsB06E6M28ZnQl1ge+c6K8Gm5W1oFv9EhFDZ1MiObtfKCNzijlf9xDXGkoet2OCl0qS4nyJF8xht67XDg7+6JDBXD+L5HCO1DEXKlZh9QnsPIvuV1xLWjnvuxIpwIIBMGuZH2hGL7yf0pYXVk0616RvjJM0yHizoQC1cSIDftTzAfNDJewfkwuUPekFl+4Zh/xXzQIhIuWinyNC68FUO78BKQy/VblWk21Wx1qSJ0as6v07SAff+sFQ/2ggYlmAJu4n8QjCYPHSses5i3S1Bqhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rh8rU3iw4pr91IwT9End/AcLY2Vp/Cx2fpEvjXsBWfM=;
 b=JIjqI6/+ycsNz0QnofDP4qt8M6mJEQ/LZvHHeDQ4jW8cI2A3JnkgN+gx076of8dyLcbKL6tezlCtYHvi4SdEAyLYEo321L0rAlM9000AcjH+FyD4ku1DHhi9oN+2rHJO1pGl1iyTBfDRsK1xYIwO1I0cuSPrx62MtlFKNSyKeW8=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4670.namprd11.prod.outlook.com (2603:10b6:806:9a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Wed, 7 Oct
 2020 10:20:06 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::4f5:fbe5:44a7:cb8a%5]) with mapi id 15.20.3433.044; Wed, 7 Oct 2020
 10:20:06 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 2/7] staging: wfx: remove remaining code of 'secure link' feature
Date:   Wed,  7 Oct 2020 12:19:38 +0200
Message-Id: <20201007101943.749898-3-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201007101943.749898-1-Jerome.Pouiller@silabs.com>
References: <20201007101943.749898-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: PR0P264CA0111.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::27) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (82.67.86.106) by PR0P264CA0111.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23 via Frontend Transport; Wed, 7 Oct 2020 10:20:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f240aa9c-03dd-4d4c-4894-08d86aaa8fd1
X-MS-TrafficTypeDiagnostic: SA0PR11MB4670:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB4670E5B1A8E1E029320529A6930A0@SA0PR11MB4670.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DhWTB4XO3ph8XFWRLCJhMEdCRRA/3SvxfqypFq8JmUFhsx4Y5p3aiEqI1qz/uCRa/I/ZbhTAxjOpF4L8x4oONgZrvqn/ANJHAs7uH9CEycHa0DPT7zwSiY5xkoy/t1JMi3ldK35zkSoNbSeMTiG3WezA+KusLqKzOTccC9iFI409mGHbK4MmtQbD3dTHt8uixnuVaFSUUSyE0U+EtoBaeh1BJrLkT1LjZ6buDpKutJd5IQ+IlLjB2qEG6FpEKcOaWYiSu/IwJviohyrUDTw4qTioBiEQtNZCNHSNNbcTmFXpFbEt5bUprx2zVoE0DSBWBvL1L4RcrPaoHPywplCNNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(346002)(136003)(376002)(366004)(396003)(66556008)(66476007)(6486002)(66946007)(316002)(54906003)(4326008)(478600001)(2906002)(1076003)(5660300002)(186003)(8936002)(8676002)(16526019)(52116002)(83380400001)(26005)(6506007)(2616005)(86362001)(956004)(107886003)(8886007)(36756003)(6666004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: caHlJ/MCCGmz4QR2rZEyRJq6TRzrV6lJiAotWgJop6zfqw8Gx4INGPSwkiLh7BqKychAf27BXEZBQSrUCLBibvd+xE7K/bTBpYnGFG9WRUnnS2e3tSlk3tdXrxwJF1y6g0/zrwt+teC7x6aQqeK41ywrkVrhx6AbJBJelhwl9Z2ZIyBW1or0fIkyTvAYp2goX8SPFdDFImgGhrEL2tG2mJ0ZkbV1ThJft6oRY5bVmaqE5S3ePjPrATRZNwcj7aTp9//Nitfgq7dWzrLfdIFCzNq48VLsTSTwbhkGxyG4j/Wy6jsv/6QorBk5mtHceusOe4GsMfoDHdHsNM4Ns0lr7X84E66kHeRiO2em4Jdcfgc+2ukXczxuPBYvneGVA3G77qUwJjHu+qs/F9Alxd7Quy7sbB2BHLf6PFsOlAWBCjGzMF00ni+IHBja4kPptK9tM5TKRztnqatR7iLLEhTLepLbKj0UVKNDLkPY1egc8cKmxngOesbBDfs15bZSWB/D9oAc/gWws9NhT/lIx1ayWQLbE2a4x5udEaJ+x3ogeLWIu4SBbyHaN6PRn4znF/ByY/SoTFWgl+d3a5t0+dpS1V3mVZl/wz0VjnBCiFLNiYkacaOSSEp9V7CxGwwuMHeWShmlruxg2hk3/bA2KDgLng==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f240aa9c-03dd-4d4c-4894-08d86aaa8fd1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2020 10:20:06.7224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8WuwOOFQveMC2KuX0FSbN74GGcXDZNybpWlD3QpJkJundD12/oFNc5G5AInAJ3wTc+laHz6LEWeyYeITQUbuDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4670
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQ29t
bWl0IGU4ZDYwN2NlMGM4MSAoInN0YWdpbmc6IHdmeDogZHJvcCAnc2VjdXJlIGxpbmsnIGZlYXR1
cmUiKSBoYWQKcmVtb3ZlZCB0aGUgJ3NlY3VyZSBsaW5rJyBmZWF0dXJlLiBIb3dldmVyLCBhIGZl
dyBsaW5lcyBvZiBjb2RlcyB3ZXJlCnlldCBoZXJlLgoKRml4ZXM6IGU4ZDYwN2NlMGM4MSAoInN0
YWdpbmc6IHdmeDogZHJvcCAnc2VjdXJlIGxpbmsnIGZlYXR1cmUiKQpTaWduZWQtb2ZmLWJ5OiBK
w6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogLi4uL2Jp
bmRpbmdzL25ldC93aXJlbGVzcy9zaWxpYWJzLHdmeC50eHQgICAgICAgfCAgMiAtLQogZHJpdmVy
cy9zdGFnaW5nL3dmeC9kZWJ1Zy5jICAgICAgICAgICAgICAgICAgICAgfCAxNyAtLS0tLS0tLS0t
LS0tLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCAxOSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3N0YWdpbmcvd2Z4L0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQv
d2lyZWxlc3Mvc2lsaWFicyx3ZngudHh0IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9Eb2N1bWVudGF0
aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3dpcmVsZXNzL3NpbGlhYnMsd2Z4LnR4dAppbmRl
eCAxN2RiNjc1NTlmNWUuLmRiOGQwNmZjNGJhYSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5n
L3dmeC9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3dpcmVsZXNzL3NpbGlh
YnMsd2Z4LnR4dAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L0RvY3VtZW50YXRpb24vZGV2aWNl
dHJlZS9iaW5kaW5ncy9uZXQvd2lyZWxlc3Mvc2lsaWFicyx3ZngudHh0CkBAIC05MCw4ICs5MCw2
IEBAIFNvbWUgcHJvcGVydGllcyBhcmUgcmVjb2duaXplZCBlaXRoZXIgYnkgU1BJIGFuZCBTRElP
IHZlcnNpb25zOgogICAgdGhpcyBwcm9wZXJ0eSwgZHJpdmVyIHdpbGwgZGlzYWJsZSBtb3N0IG9m
IHBvd2VyIHNhdmluZyBmZWF0dXJlcy4KICAtIGNvbmZpZy1maWxlOiBVc2UgYW4gYWx0ZXJuYXRp
dmUgZmlsZSBhcyBQRFMuIERlZmF1bHQgaXMgYHdmMjAwLnBkc2AuIE9ubHkKICAgIG5lY2Vzc2Fy
eSBmb3IgZGV2ZWxvcG1lbnQvZGVidWcgcHVycG9zZS4KLSAtIHNsa19rZXk6IFN0cmluZyByZXBy
ZXNlbnRpbmcgaGV4YWRlY2ltYWwgdmFsdWUgb2Ygc2VjdXJlIGxpbmsga2V5IHRvIHVzZS4KLSAg
IE11c3QgY29udGFpbnMgNjQgaGV4YWRlY2ltYWwgZGlnaXRzLiBOb3Qgc3VwcG9ydGVkIGluIGN1
cnJlbnQgdmVyc2lvbi4KIAogV0Z4IGRyaXZlciBhbHNvIHN1cHBvcnRzIGBtYWMtYWRkcmVzc2Ag
YW5kIGBsb2NhbC1tYWMtYWRkcmVzc2AgYXMgZGVzY3JpYmVkIGluCiBEb2N1bWVudGF0aW9uL2Rl
dmljZXRyZWUvYmluZGluZ3MvbmV0L2V0aGVybmV0LnR4dApkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
dGFnaW5nL3dmeC9kZWJ1Zy5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kZWJ1Zy5jCmluZGV4IGFl
NDRmZmI2NmUzNC4uNGJkNWY5ZmEyMWExIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L2RlYnVnLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kZWJ1Zy5jCkBAIC0yMzAsMjEgKzIz
MCw2IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25zIHdmeF9zZW5kX3Bkc19m
b3BzID0gewogCS53cml0ZSA9IHdmeF9zZW5kX3Bkc193cml0ZSwKIH07CiAKLXN0YXRpYyBzc2l6
ZV90IHdmeF9idXJuX3Nsa19rZXlfd3JpdGUoc3RydWN0IGZpbGUgKmZpbGUsCi0JCQkJICAgICAg
Y29uc3QgY2hhciBfX3VzZXIgKnVzZXJfYnVmLAotCQkJCSAgICAgIHNpemVfdCBjb3VudCwgbG9m
Zl90ICpwcG9zKQotewotCXN0cnVjdCB3ZnhfZGV2ICp3ZGV2ID0gZmlsZS0+cHJpdmF0ZV9kYXRh
OwotCi0JZGV2X2luZm8od2Rldi0+ZGV2LCAidGhpcyBkcml2ZXIgZG9lcyBub3Qgc3VwcG9ydCBz
ZWN1cmUgbGlua1xuIik7Ci0JcmV0dXJuIC1FSU5WQUw7Ci19Ci0KLXN0YXRpYyBjb25zdCBzdHJ1
Y3QgZmlsZV9vcGVyYXRpb25zIHdmeF9idXJuX3Nsa19rZXlfZm9wcyA9IHsKLQkub3BlbiA9IHNp
bXBsZV9vcGVuLAotCS53cml0ZSA9IHdmeF9idXJuX3Nsa19rZXlfd3JpdGUsCi19OwotCiBzdHJ1
Y3QgZGJnZnNfaGlmX21zZyB7CiAJc3RydWN0IHdmeF9kZXYgKndkZXY7CiAJc3RydWN0IGNvbXBs
ZXRpb24gY29tcGxldGU7CkBAIC0zNjYsOCArMzUxLDYgQEAgaW50IHdmeF9kZWJ1Z19pbml0KHN0
cnVjdCB3ZnhfZGV2ICp3ZGV2KQogCWRlYnVnZnNfY3JlYXRlX2ZpbGUoInR4X3Bvd2VyX2xvb3Ai
LCAwNDQ0LCBkLCB3ZGV2LAogCQkJICAgICZ3ZnhfdHhfcG93ZXJfbG9vcF9mb3BzKTsKIAlkZWJ1
Z2ZzX2NyZWF0ZV9maWxlKCJzZW5kX3BkcyIsIDAyMDAsIGQsIHdkZXYsICZ3Znhfc2VuZF9wZHNf
Zm9wcyk7Ci0JZGVidWdmc19jcmVhdGVfZmlsZSgiYnVybl9zbGtfa2V5IiwgMDIwMCwgZCwgd2Rl
diwKLQkJCSAgICAmd2Z4X2J1cm5fc2xrX2tleV9mb3BzKTsKIAlkZWJ1Z2ZzX2NyZWF0ZV9maWxl
KCJzZW5kX2hpZl9tc2ciLCAwNjAwLCBkLCB3ZGV2LAogCQkJICAgICZ3Znhfc2VuZF9oaWZfbXNn
X2ZvcHMpOwogCWRlYnVnZnNfY3JlYXRlX2ZpbGUoInBzX3RpbWVvdXQiLCAwNjAwLCBkLCB3ZGV2
LCAmd2Z4X3BzX3RpbWVvdXRfZm9wcyk7Ci0tIAoyLjI4LjAKCg==
