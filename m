Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A019E25F7C7
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbgIGKT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:19:57 -0400
Received: from mail-mw2nam10on2056.outbound.protection.outlook.com ([40.107.94.56]:42336
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728810AbgIGKRb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:17:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EyARK1iV6h1BfrVt/OslR1YuAMJWe1VIEsM/vFjmOfwOp3zUd9jRLIPiIMIw+tYmmGFIVXsS+uE1YDbV2EG/fM9S/aYG67r19u7zxWmnHBDPaNFSBBPozQVApL7rYX1dKE+rkcarBaQHfwEsSwNxAH4/4UoXnobobbiZCMv3E69qTDbxlQIddZdRuisiQz/5b1HPPwncNdekZuvWvRFtXWSz0o9l/y7ZTJ4m+FB3K6yS8KWKxJ1XduX/12UnbK7duymuMYeoJLav7MkC2oMbEvLDcQAYCfSEbwE3/Rkt0EahReYolXIZotkfI2+tS6yeeaaDj+CYoVWeYuwzftYwHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+k+GleFu0J19YsGZFLjhCsk1dC2X1vLIC78Wjtzf3hM=;
 b=eOBGPmg5E1yRGN0S4bZourW8Rt2lkq8Si5WApQJk6PdhRRJFHI9d7pKM5bZI5x5BDRPoH/9PNW/9x9WbXlCXuS9K1vedKBKOd9KOLokESVTh0+Q9wf3qohDhlS1QHwU+m1XCE4d7iIAPiS9acO+vLLnW2GND8r9UEtU9T47Qn3Di4ZF6JTu0e2dHZsS2ICh6mveVzv09DLUgA0jKH+18ZiwZgyCxSbInHZc1VenpD8EjVZwFvvNXlMlU7Ny9FX6g4NtviBp5zm1OoxNOBJGW7M+3i21pVNtpBSp4to8ChkKHeNhTMLYjQRoduQyiTqTOFxSSpjKM4jjM6aDYAcBQoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+k+GleFu0J19YsGZFLjhCsk1dC2X1vLIC78Wjtzf3hM=;
 b=bcItqjYd9+uioGEW6NUQMe/XA1O/QHNVYHmjJhtnmgmYbWBiIJ/dSvM9bEY+Ke3xlV6YDiecgMkJYyf9rhjrxFc4097vk9Cuid4LvLfTMfXnnCCPFJDvc0KiSXjsGpH1l41qDC/73OzpBvk/i7ZAsnNC7PrJgz6JhLmOtMX/VD0=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2720.namprd11.prod.outlook.com (2603:10b6:805:56::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 10:16:27 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:16:27 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 26/31] staging: wfx: drop macro API_SSID_SIZE
Date:   Mon,  7 Sep 2020 12:15:16 +0200
Message-Id: <20200907101521.66082-27-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907101521.66082-1-Jerome.Pouiller@silabs.com>
References: <20200907101521.66082-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::25) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:16:26 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cd601d4-1f14-4980-966e-08d8531714df
X-MS-TrafficTypeDiagnostic: SN6PR11MB2720:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2720F548342E9817391E714193280@SN6PR11MB2720.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:403;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7bs+Nfw/wKZablRzXN38jKv6/NeKWBuaihGr/HkFSKwx/uXyHOLYiyiV9ZJ+GJe7n9JDnhkh17NNdAeEoDphiazJXsU38VrDoQOfhI9rAUhdHkxY4FnwOPR3FtE1NBnlTpkCgfbBDFY1Giw4WN1k3CTFF65MJ1lFI8mqkMu9SQf+ydSYfq6jggwFb1XHA+WtMfEM/McPOHNwLEUcVsupWaJPtLqKnxPhV2TCZMTmw0CkpKr4kg6ZOPK6frZ2XUS6EBZ4E7YwkCgi3fBu64haPIy0aks6iTJ2zHZZZ9fyQX+BlFaiqMey6doeihnGIXtB0Xy3vd7DkOf5aNU72gOkXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39850400004)(136003)(346002)(396003)(66946007)(66556008)(66476007)(54906003)(26005)(186003)(16526019)(66574015)(83380400001)(107886003)(6486002)(8676002)(956004)(2616005)(2906002)(316002)(86362001)(8936002)(478600001)(4326008)(7696005)(36756003)(52116002)(6666004)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: STTfU3/IN0a0X6I1kt1W9nx4+bFwl1U3r8256Q0bEgH37hQAcRJRn61KvdmgS3qNUUIfoL7m7BilR5qyBtKV1X9VGK07eTUKG9kXr/7EOHguhUM5cGeP/jn9bONXfP6PyMNUeEo8z/ud7Pg7NyGfXaXdTeROE/LA/utTUyVWZafVM4lNbsjf9YfJL+HL0b8CbS2IAjIvpH9a8BZwzFSbaxK79L6dAQvwV62wV2dNrQT0u6Pl52qcFV5I3D915BjWKfHT1hoB1bdAoxtx2lbLLOyPNW3gC+9Phx3wBJP0kGFgwFJ4KOnRT/ES3gkQBZ9yd3kyvZsD3sPBogMEOH6A96f/2Ebo1d9MZfWyrBhJfYyGj7Dm+oZvVInBpxE1lTMHSXReXlKL/slOrmOpndPoUTzc/63ec4oIplcVePo2WtwGPDUCZ7KUKi89l98Dwz+Kthu9X30p2eKFZTjEFZUXkQ82DN1itsxE4PfheCVHdLAPJyOvO7T0gRu0uPaiO93ILb4wCWCGXdjOfzrH+JpsYnHp2IOaw+paFxifS/7pBCFQ/rg3JyMD9K51Ly9t9mEzPYOlCV9o4BcKOOPKdYXWrOQzk8Rweu0+LgcDQVFN2OMqavv4blDOyIcQwfrfXhvpuZFKV858JjwfQErAvY6VTw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cd601d4-1f14-4980-966e-08d8531714df
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:16:27.4094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uAHL6GicdwvM8sVsVonh6bA4PC3Lro9fvvmOowS6g/jVJsKPuL5Stsqvd6+4qDU3e6khc+fOgXZ/+1AR7n8P1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2720
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IG1heGltdW0gbGVuZ3RoIG9mIGEgU1NJRCBpcyBkZWZpbmVkIGJ5IDgwMi4xMSBzcGVjaWZpY2F0
aW9uLiBJdCBpcwphbHJlYWR5IGRlZmluZWQgaW4gbWFjODAyMTE6IElFRUU4MDIxMV9NQVhfU1NJ
RF9MRU4uIFRoZXJlZm9yZSwgdXNlIHRoaXMKZ2VuZXJpYyBkZWZpbml0aW9uLgoKU2lnbmVkLW9m
Zi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0K
IGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaCAgICAgfCA4ICsrKy0tLS0tCiBkcml2
ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfZ2VuZXJhbC5oIHwgMiAtLQogZHJpdmVycy9zdGFnaW5n
L3dmeC9oaWZfdHguYyAgICAgICAgICB8IDIgLS0KIDMgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRp
b25zKCspLCA5IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX2FwaV9jbWQuaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaAppbmRleCBl
ZjU0ODM2MDlkY2IuLjdiMzY1YmQwMWI4MSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9oaWZfYXBpX2NtZC5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaApA
QCAtMTIsOCArMTIsNiBAQAogCiAjaW5jbHVkZSAiaGlmX2FwaV9nZW5lcmFsLmgiCiAKLSNkZWZp
bmUgSElGX0FQSV9TU0lEX1NJWkUgICAgICAgICAgICAgICAgICAgICAgQVBJX1NTSURfU0laRQot
CiBlbnVtIGhpZl9yZXF1ZXN0c19pZHMgewogCUhJRl9SRVFfSURfUkVTRVQgICAgICAgICAgICAg
ICAgPSAweDBhLAogCUhJRl9SRVFfSURfUkVBRF9NSUIgICAgICAgICAgICAgPSAweDA1LApAQCAt
MTExLDcgKzEwOSw3IEBAIHN0cnVjdCBoaWZfY25mX3VwZGF0ZV9pZSB7CiAKIHN0cnVjdCBoaWZf
c3NpZF9kZWYgewogCV9fbGUzMiBzc2lkX2xlbmd0aDsKLQl1OCAgICAgc3NpZFtISUZfQVBJX1NT
SURfU0laRV07CisJdTggICAgIHNzaWRbSUVFRTgwMjExX01BWF9TU0lEX0xFTl07CiB9IF9fcGFj
a2VkOwogCiAjZGVmaW5lIEhJRl9BUElfTUFYX05CX1NTSURTICAgICAgICAgICAgICAgICAgICAg
ICAgICAgMgpAQCAtMzA3LDcgKzMwNSw3IEBAIHN0cnVjdCBoaWZfcmVxX2pvaW4gewogCXU4ICAg
ICBmb3JjZV93aXRoX2luZDoxOwogCXU4ICAgICByZXNlcnZlZDY6NDsKIAlfX2xlMzIgc3NpZF9s
ZW5ndGg7Ci0JdTggICAgIHNzaWRbSElGX0FQSV9TU0lEX1NJWkVdOworCXU4ICAgICBzc2lkW0lF
RUU4MDIxMV9NQVhfU1NJRF9MRU5dOwogCV9fbGUzMiBiZWFjb25faW50ZXJ2YWw7CiAJX19sZTMy
IGJhc2ljX3JhdGVfc2V0OwogfSBfX3BhY2tlZDsKQEAgLTM2NCw3ICszNjIsNyBAQCBzdHJ1Y3Qg
aGlmX3JlcV9zdGFydCB7CiAJdTggICAgIHJlc2VydmVkMzo3OwogCXU4ICAgICByZXNlcnZlZDQ7
CiAJdTggICAgIHNzaWRfbGVuZ3RoOwotCXU4ICAgICBzc2lkW0hJRl9BUElfU1NJRF9TSVpFXTsK
Kwl1OCAgICAgc3NpZFtJRUVFODAyMTFfTUFYX1NTSURfTEVOXTsKIAlfX2xlMzIgYmFzaWNfcmF0
ZV9zZXQ7CiB9IF9fcGFja2VkOwogCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hp
Zl9hcGlfZ2VuZXJhbC5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2dlbmVyYWwuaApp
bmRleCBkYTYzYmE2ZjUxNDguLmM5ZTNjMGY3NThjOCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9oaWZfYXBpX2dlbmVyYWwuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9h
cGlfZ2VuZXJhbC5oCkBAIC0xNyw4ICsxNyw2IEBACiAjZGVmaW5lIF9fcGFja2VkIF9fYXR0cmli
dXRlX18oKF9fcGFja2VkX18pKQogI2VuZGlmCiAKLSNkZWZpbmUgQVBJX1NTSURfU0laRSAgICAg
ICAgICAgICAzMgotCiAjZGVmaW5lIEhJRl9JRF9JU19JTkRJQ0FUSU9OICAgICAgMHg4MAogI2Rl
ZmluZSBISUZfQ09VTlRFUl9NQVggICAgICAgICAgIDcKIApkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
dGFnaW5nL3dmeC9oaWZfdHguYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKaW5kZXgg
MDU1M2U3OTU5NWE2Li5hNzVjNmI5ODA0YmEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93
ZngvaGlmX3R4LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYwpAQCAtMjQ1LDgg
KzI0NSw2IEBAIGludCBoaWZfc2NhbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0IGNmZzgw
MjExX3NjYW5fcmVxdWVzdCAqcmVxLAogCVdBUk4oY2hhbl9udW0gPiBISUZfQVBJX01BWF9OQl9D
SEFOTkVMUywgImludmFsaWQgcGFyYW1zIik7CiAJV0FSTihyZXEtPm5fc3NpZHMgPiBISUZfQVBJ
X01BWF9OQl9TU0lEUywgImludmFsaWQgcGFyYW1zIik7CiAKLQljb21waWxldGltZV9hc3NlcnQo
SUVFRTgwMjExX01BWF9TU0lEX0xFTiA9PSBISUZfQVBJX1NTSURfU0laRSwKLQkJCSAgICJBUEkg
aW5jb25zaXN0ZW5jeSIpOwogCWlmICghaGlmKQogCQlyZXR1cm4gLUVOT01FTTsKIAlmb3IgKGkg
PSAwOyBpIDwgcmVxLT5uX3NzaWRzOyBpKyspIHsKLS0gCjIuMjguMAoK
