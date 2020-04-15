Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6E61AAD83
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 18:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415405AbgDOQOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 12:14:34 -0400
Received: from mail-bn7nam10on2054.outbound.protection.outlook.com ([40.107.92.54]:6037
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2410266AbgDOQMt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 12:12:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmdcbN2X22IRIYvAaFD6rV8G77/wY/mw9hAZhc/yVAjD6w7YeTrJL67E1+vU7ZUFMseSN5MdInsjwTPuotko2lI8HhTllLN9Po65fzAw7D8KmLwQcvJKTxLeieS9kwQwFGIPNPu8kKBryihDUz5FVBnBdQ3YQkMxOL+yUy1CCvYnjFjd2BD/qnRCHBESzM9gYTEn12yAkIiN4O0IGs/jPoVMmG8Jvh157Ee32lSvXDH8yWqg0W1t8M0ecFg9zKtJOQyPldNpj1/njJ4Cg9VTzQuE6tfIitH3AzLZCjKkhM6nfS5h3KqpfKVNizN1dxamKzCLknYKAGfFlwoouwmEyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rK17iCaJqdfonxdRRm6js7bY5I5PDEuTiddcxTRb2M0=;
 b=VPTMlIlDv/RT73xFW/HaqKklDNdJnOAIvFxfddpG5cEQ7Zgb8FNEXhjC4rz0GdqAQz+NKXn27l/753eL3fIQQYAtvYPjsZQuJH5RuClrYPROePsXAfZA+1wgfwULMiGcOtHVwVOM+TCRLiPaqV3e//xmlbQJlSiTlsKQCZoVlwJBgK87V7fVIdr/Ixjze3yePEhCiDJQk2Ie76uKtq3+xVSQZoQYaIsy2cYnYVxxkaAcITo8ODxzD3PoUb+BLcPw2+486qwZciwHQidOlOTC7xfjk8H1bT47vNm3MQMqWYmiG2J7CH98NPG090og8YmAxo5xzdr2xFPwA7mkpC1t6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rK17iCaJqdfonxdRRm6js7bY5I5PDEuTiddcxTRb2M0=;
 b=T9oG9EHAxuL4p4zYhVzzJFtetK9vgnunZSGVrGQnU1VLLBmCpnaEGCHEa3CamAo3HDNldZ3m7ShCH7QR7r4GaJ/T3A0PqXB63fF6KcrL2W35pLv7c5XnzNf02LiDj5et2u+e8+Swatk2JjzONyV4LWDVtdVv9XBF2TNoKfiIBr8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1599.namprd11.prod.outlook.com (2603:10b6:301:e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.28; Wed, 15 Apr
 2020 16:12:42 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.024; Wed, 15 Apr
 2020 16:12:42 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 12/20] staging: wfx: align semantic of beacon filter with other filters
Date:   Wed, 15 Apr 2020 18:11:39 +0200
Message-Id: <20200415161147.69738-13-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200415161147.69738-1-Jerome.Pouiller@silabs.com>
References: <20200415161147.69738-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR1PR01CA0027.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::40) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR1PR01CA0027.eurprd01.prod.exchangelabs.com (2603:10a6:102::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Wed, 15 Apr 2020 16:12:40 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12467678-01af-404a-bc48-08d7e157d382
X-MS-TrafficTypeDiagnostic: MWHPR11MB1599:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1599A42A626AD663F1673AB993DB0@MWHPR11MB1599.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(376002)(396003)(346002)(366004)(39850400004)(136003)(4326008)(66476007)(107886003)(81156014)(86362001)(8936002)(2616005)(6512007)(6486002)(316002)(52116002)(66556008)(66946007)(6506007)(8886007)(2906002)(1076003)(36756003)(66574012)(5660300002)(54906003)(478600001)(16526019)(8676002)(186003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2ZIlRigiESqv+m513K7CPYI0ZnrwEVmbqyCH34GWjVTBX0yJ/bsKFZ1k5+ObIgkpnFPN7thCDGIS2TvXMlqlYYQO6ApxKqMe+/hMVfA1yivc7kiLTWoTAYEBENvkpyAIKr/xGf4msni7AOeYDpLGQZrI6onZydQt83xFR7MF7to7oQd0mbO2gZR37EhMUPWX/NBKQF1ANZYKno7cXFbiOkMugUpfgtbjPuGEblsRIurrxa6hIJ6TiUWXOmSRnz1uUXWnz7CKBdTRU+BG+L7OchIk0DSjT+9qNdaKZ403gK2Fcm3f3UqkVdMhjABtmBEw+CmOjUWH+BJeZm9AB53lhyuOly2ljDATaFPDhlQDDI1sarYid0lL5q5PbBa1pGBXe3cy3uA7WTO3R4y6ERZFMEGe0lvf4pUv0qZL6JJX+7eJ2dQdEufksN5eXkPRdWzJ
X-MS-Exchange-AntiSpam-MessageData: ac/QGJl7KmYU+ofPP0aahHv+oiGZULvwnNqjmTLwPXz0qg19D6lr4PzM/9YcQVgDI6jiLG2OQi3OaZjqJkLwxk/Itb5bybdym7Yn4UAOJwP5z3qrN5GoAqRwLtqAntzwrqsoNGy5RrbrOD7754dQ/hhYrq8rgTWaSbDI7EEGWeE4t2Lp2anvBMqWfHKlyIf1aMf47RA+TwB2LZTIlPMcFw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12467678-01af-404a-bc48-08d7e157d382
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2020 16:12:42.5408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YBnkrC0+Q5B8vYxmxecoec5Ua1ko7ULrDI16NlIx6jM9NzIcC5fP4fLHjBbKCxwqmxI9QFz/wnfqEr9mTH7qUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1599
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRmls
dGVycyBwcm92aWRlZCBieSBISUYgQVBJIGFyZSBzb21ldGltZSBpbmNsdXNpdmUsIHNvbWV0aW1l
IGV4Y2x1c2l2ZS4KClRoaXMgcGF0Y2ggYWxpZ24gdGhlIGJlaGF2aW9yIGFuZCBuYW1lIG9mIHRo
ZSBiZWFjb24gZmlsdGVyIHdpdGggdGhlCm90aGVyIGZpbHRlcnMuIEFsc28gYXZvaWQgZG91Ymxl
IG5lZ2F0aW9uOiAiZGlzYWJsZSBmaWx0ZXIiCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3Vp
bGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuYyB8IDEwICsrKysrLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmggfCAgMiAr
LQogMiBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
c3RhLmMKaW5kZXggOGQyMzY1YTJlMzViLi45NjNjYWM4M2I2YTggMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAt
MTM3LDcgKzEzNyw3IEBAIHZvaWQgd2Z4X3VwZGF0ZV9maWx0ZXJpbmcoc3RydWN0IHdmeF92aWYg
Knd2aWYpCiAJfTsKIAogCWhpZl9zZXRfcnhfZmlsdGVyKHd2aWYsIHd2aWYtPmZpbHRlcl9ic3Np
ZCwgd3ZpZi0+ZndkX3Byb2JlX3JlcSk7Ci0JaWYgKHd2aWYtPmRpc2FibGVfYmVhY29uX2ZpbHRl
cikgeworCWlmICghd3ZpZi0+ZmlsdGVyX2JlYWNvbikgewogCQloaWZfc2V0X2JlYWNvbl9maWx0
ZXJfdGFibGUod3ZpZiwgMCwgTlVMTCk7CiAJCWhpZl9iZWFjb25fZmlsdGVyX2NvbnRyb2wod3Zp
ZiwgMCwgMSk7CiAJfSBlbHNlIHsKQEAgLTIxNSw5ICsyMTUsOSBAQCB2b2lkIHdmeF9jb25maWd1
cmVfZmlsdGVyKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LAogCQkvLyBOb3RlOiBGSUZfQkNOX1BS
QlJFU1BfUFJPTUlTQyBjb3ZlcnMgcHJvYmUgcmVzcG9uc2UgYW5kCiAJCS8vIGJlYWNvbnMgZnJv
bSBvdGhlciBCU1MKIAkJaWYgKCp0b3RhbF9mbGFncyAmIEZJRl9CQ05fUFJCUkVTUF9QUk9NSVND
KQotCQkJd3ZpZi0+ZGlzYWJsZV9iZWFjb25fZmlsdGVyID0gdHJ1ZTsKKwkJCXd2aWYtPmZpbHRl
cl9iZWFjb24gPSBmYWxzZTsKIAkJZWxzZQotCQkJd3ZpZi0+ZGlzYWJsZV9iZWFjb25fZmlsdGVy
ID0gZmFsc2U7CisJCQl3dmlmLT5maWx0ZXJfYmVhY29uID0gdHJ1ZTsKIAogCQlpZiAoKnRvdGFs
X2ZsYWdzICYgRklGX0FMTE1VTFRJKSB7CiAJCQl3dmlmLT5tY2FzdF9maWx0ZXIuZW5hYmxlID0g
ZmFsc2U7CkBAIC01MDQsNyArNTA0LDcgQEAgc3RhdGljIHZvaWQgd2Z4X2RvX2pvaW4oc3RydWN0
IHdmeF92aWYgKnd2aWYpCiAJCSAqIERpc2FibGUgZmlsdGVyaW5nIHRlbXBvcmFyeSB0byBtYWtl
IHN1cmUgdGhlIHN0YWNrCiAJCSAqIHJlY2VpdmVzIGF0IGxlYXN0IG9uZQogCQkgKi8KLQkJd3Zp
Zi0+ZGlzYWJsZV9iZWFjb25fZmlsdGVyID0gdHJ1ZTsKKwkJd3ZpZi0+ZmlsdGVyX2JlYWNvbiA9
IGZhbHNlOwogCQl3ZnhfdXBkYXRlX2ZpbHRlcmluZyh3dmlmKTsKIAl9CiAJd2Z4X3R4X3VubG9j
ayh3dmlmLT53ZGV2KTsKQEAgLTcwNiw3ICs3MDYsNyBAQCB2b2lkIHdmeF9ic3NfaW5mb19jaGFu
Z2VkKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LAogCQkJCQkgICAgIGluZm8tPmR0aW1fcGVyaW9k
KTsKIAkJLy8gV2UgdGVtcG9yYXJ5IGZvcndhcmRlZCBiZWFjb24gZm9yIGpvaW4gcHJvY2Vzcy4g
SXQgaXMgbm93IG5vCiAJCS8vIG1vcmUgbmVjZXNzYXJ5LgotCQl3dmlmLT5kaXNhYmxlX2JlYWNv
bl9maWx0ZXIgPSBmYWxzZTsKKwkJd3ZpZi0+ZmlsdGVyX2JlYWNvbiA9IHRydWU7CiAJCXdmeF91
cGRhdGVfZmlsdGVyaW5nKHd2aWYpOwogCX0KIApkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5n
L3dmeC93ZnguaCBiL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgKaW5kZXggYTY5ZDljOWMzN2I2
Li41M2VkNGMxMzdiMTkgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgKKysr
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaApAQCAtOTAsNyArOTAsNyBAQCBzdHJ1Y3Qgd2Z4
X3ZpZiB7CiAKIAlib29sCQkJZmlsdGVyX2Jzc2lkOwogCWJvb2wJCQlmd2RfcHJvYmVfcmVxOwot
CWJvb2wJCQlkaXNhYmxlX2JlYWNvbl9maWx0ZXI7CisJYm9vbAkJCWZpbHRlcl9iZWFjb247CiAK
IAl1bnNpZ25lZCBsb25nCQl1YXBzZF9tYXNrOwogCXN0cnVjdCBoaWZfcmVxX3NldF9ic3NfcGFy
YW1zIGJzc19wYXJhbXM7Ci0tIAoyLjI1LjEKCg==
