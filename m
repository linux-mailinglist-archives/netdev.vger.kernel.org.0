Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7331AAD7C
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 18:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415373AbgDOQN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 12:13:59 -0400
Received: from mail-bn7nam10on2054.outbound.protection.outlook.com ([40.107.92.54]:6037
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1415233AbgDOQNA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 12:13:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zpifr6EXmg+lwEIh/Pn0dsbVK0UkMbRZ4G+YE2ANvigOzAPoewpCR5utJAtmROGEQle4W3AK/cTf1a23rVaqfDSETIJ7425ihubN4Te88c8P1tWVmyXaWt9wuj0uFBVcfbnHHCyIfDW9SFCep1ihYcBeVS0loKvbVV0L5bBN+zIjZzfNi4yjX217bMj/xJ/IdxCHeuBd4hCsfaNfURxlvyw5V0i33e9O81ClPUGy22xR4JtegXFJz7V76g/rsO7mrqf+ynqjOWhSXaaEcV+KhwE/M5J+QRbOPkcVP7T/vtriB1xHJWvUWAKshqmBXOLFj2GBC4FEn5HMHFknOSct2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QZ/rq2FsoB605jBIje5ao4v/472P9Cz2zkmYJhal3fA=;
 b=XKJWeCchgzIyZHO5qq67SwpGzn5giLZeUKgTecpTSLhlCwKy6cKTrepcscWj/LeqKiCuZ1LvH0FClAxGmtwSC5EmdkTHCcHDEDC26rcI8fBLsqxYFM8t2RtReEq2LtdxWy1H8j/Xk9j5bnxFIAfSgALMaMIhCmh9leyErM96r/pBezOyEAEiyetkkEYFi9CrNWyFuzpQ8vaNlMU9b1JPa9w0c5IZH9IfX14Gg/XK6ORRAo7m6rN7zG/iujrqTX1XZAao4WZBc8ojOfiYjvkEGnhP6aaWJJ4esxg5YQqhSxuZ58vcNu8sM6AYxiNKnjyHNv79WrbfnEy6OUjnnOvDHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QZ/rq2FsoB605jBIje5ao4v/472P9Cz2zkmYJhal3fA=;
 b=Tz8lMQ3ENPGKHXG1kY1vaqh+enb5tXst6dPgeIVsroUrFyB6HxMTDmPla0Br30OLF3Ink0HyS36y6HAW0/bMyb8sABzDrOUvohsRysMCG6bieBfPzM2S3H/TsvvqjMFSc8Qr3WyeMWjWBW1PnIPibpQ6GWtcKYkA35rDcOzrZwA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1599.namprd11.prod.outlook.com (2603:10b6:301:e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.28; Wed, 15 Apr
 2020 16:12:48 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.024; Wed, 15 Apr
 2020 16:12:48 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 14/20] staging: wfx: drop struct wfx_grp_addr_table
Date:   Wed, 15 Apr 2020 18:11:41 +0200
Message-Id: <20200415161147.69738-15-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR1PR01CA0027.eurprd01.prod.exchangelabs.com (2603:10a6:102::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Wed, 15 Apr 2020 16:12:45 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7fcd77c8-4630-46bc-ee09-08d7e157d6bc
X-MS-TrafficTypeDiagnostic: MWHPR11MB1599:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1599120CBAD31808FE5BBF7693DB0@MWHPR11MB1599.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(376002)(396003)(346002)(366004)(39850400004)(136003)(4326008)(66476007)(107886003)(81156014)(86362001)(8936002)(2616005)(6512007)(6486002)(316002)(52116002)(66556008)(66946007)(6666004)(6506007)(8886007)(2906002)(1076003)(36756003)(66574012)(5660300002)(54906003)(478600001)(16526019)(8676002)(186003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bXl2f4a2vRaXd2mGO0DziHGbc6ZfOrqpEg3P225PTmfS6DpGmeOO/umNR7XZoUW9yTocva9VzDqpY9PR1AhqNM1faSqdbUSOn8YBexHUZZkVtXXO1FVCK2ZgrCCZQkEGO9Gtz2fnQ7abKzsmnxxBPBfkJP8XZyBpgx++/WCiiHehnhvubFvvfZYbfyQgMl1HjSaFhs2MB7orjVxOjoq5FRXrZ9V6lIF5aCkQQIB1ca2GYLrem1nbflcOcza1vy51XB27gTgGLRkCmuz9nwmZzXZPsTZJBCYJU7buXq6PCCFkixiPgC3EZYyzEWZO5zl0EOvp2ARpK0sdDH/tMIOamGI8Yq3T9ofUCzQzpLWRn3F7lsp6mS6O75i4syA2+3k9LRY0EgPIOuXyQAscVWZoL43QB4oaOhfhLDyDyJPAYkrNBwkQq+ee+9Y9/Mkomfqb
X-MS-Exchange-AntiSpam-MessageData: XqOs24LIb5KM/caQ+KRm2U0o8jtUojVgrkizSO5xSyuOXuPOi44+QCnN0wUjkr6/TONsj3mZGLQFYjQGco1G2Bie3qOyai41zcH1rFs4D1xle+snWBnLCq2Cz6AVcgEW0yVnp2929TYr0u9ULP1bRdLgI6fBJ30QPkhuK/jLacuCjIYt5XDpHhpIdIRR14FABs2Of3vlB/p/FXBI1B0zrw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fcd77c8-4630-46bc-ee09-08d7e157d6bc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2020 16:12:47.8644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Op1q436WfSmuZIiLeckwH9VcTDN4xlxrl8LIOOHeyHoJ/7zJ8XPyQYuhw/ynbz+du7lHyHz4I9/Pn+Mk0j/6VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1599
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN0cnVjdCB3ZnhfZ3JwX2FkZHJfdGFibGUgaXMgb25seSBpbnN0YW50aWF0ZWQgb24gb25lIHBs
YWNlLiBUaGVyZQppcyBubyBqdXN0aWZpYXRpb24gZm9yIHRoaXMgc3RydWN0LiBNb3Jlb3Zlciwg
aXQgaXMgbm90IGNvbnNpc3RlbnQgd2l0aApvdGhlciBmaWVsZHMgcmVsYXRlZCB0byBmaWx0ZXJp
bmcgKGZpbHRlcl9ic3NpZCwgZXRjLi4uKS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWls
bGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4
L3N0YS5jIHwgMjggKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLQogZHJpdmVycy9zdGFnaW5n
L3dmeC9zdGEuaCB8ICA2IC0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaCB8ICA0ICsr
Ky0KIDMgZmlsZXMgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygrKSwgMjIgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93
Zngvc3RhLmMKaW5kZXggM2ExMDVkNDg1MjM3Li43MDM0MmJkZDlkOTYgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpA
QCAtMTQ5LDE3ICsxNDksMTYgQEAgdm9pZCB3ZnhfdXBkYXRlX2ZpbHRlcmluZyhzdHJ1Y3Qgd2Z4
X3ZpZiAqd3ZpZikKIAloaWZfc2V0X2RhdGFfZmlsdGVyaW5nKHd2aWYsIGZhbHNlLCB0cnVlKTsK
IAlyZXR1cm47CiAKLQlpZiAoIXd2aWYtPm1jYXN0X2ZpbHRlci5lbmFibGUpIHsKKwlpZiAoIXd2
aWYtPmZpbHRlcl9tY2FzdCkgewogCQloaWZfc2V0X2RhdGFfZmlsdGVyaW5nKHd2aWYsIGZhbHNl
LCB0cnVlKTsKIAkJcmV0dXJuOwogCX0KLQlmb3IgKGkgPSAwOyBpIDwgd3ZpZi0+bWNhc3RfZmls
dGVyLm51bV9hZGRyZXNzZXM7IGkrKykKLQkJaGlmX3NldF9tYWNfYWRkcl9jb25kaXRpb24od3Zp
ZiwgaSwKLQkJCQkJICAgd3ZpZi0+bWNhc3RfZmlsdGVyLmFkZHJlc3NfbGlzdFtpXSk7CisJZm9y
IChpID0gMDsgaSA8IHd2aWYtPmZpbHRlcl9tY2FzdF9jb3VudDsgaSsrKQorCQloaWZfc2V0X21h
Y19hZGRyX2NvbmRpdGlvbih3dmlmLCBpLCB3dmlmLT5maWx0ZXJfbWNhc3RfYWRkcltpXSk7CiAJ
aGlmX3NldF91Y19tY19iY19jb25kaXRpb24od3ZpZiwgMCwKIAkJCQkgICBISUZfRklMVEVSX1VO
SUNBU1QgfCBISUZfRklMVEVSX0JST0FEQ0FTVCk7CiAJaGlmX3NldF9jb25maWdfZGF0YV9maWx0
ZXIod3ZpZiwgdHJ1ZSwgMCwgQklUKDEpLAotCQkJCSAgIEJJVCh3dmlmLT5tY2FzdF9maWx0ZXIu
bnVtX2FkZHJlc3NlcykgLSAxKTsKKwkJCQkgICBCSVQod3ZpZi0+ZmlsdGVyX21jYXN0X2NvdW50
KSAtIDEpOwogCWhpZl9zZXRfZGF0YV9maWx0ZXJpbmcod3ZpZiwgdHJ1ZSwgdHJ1ZSk7CiB9CiAK
QEAgLTE3MywxOCArMTcyLDE3IEBAIHU2NCB3ZnhfcHJlcGFyZV9tdWx0aWNhc3Qoc3RydWN0IGll
ZWU4MDIxMV9odyAqaHcsCiAJaW50IGNvdW50ID0gbmV0ZGV2X2h3X2FkZHJfbGlzdF9jb3VudCht
Y19saXN0KTsKIAogCXdoaWxlICgod3ZpZiA9IHd2aWZfaXRlcmF0ZSh3ZGV2LCB3dmlmKSkgIT0g
TlVMTCkgewotCQltZW1zZXQoJnd2aWYtPm1jYXN0X2ZpbHRlciwgMHgwMCwgc2l6ZW9mKHd2aWYt
Pm1jYXN0X2ZpbHRlcikpOwotCQlpZiAoIWNvdW50IHx8Ci0JCSAgICBjb3VudCA+IEFSUkFZX1NJ
WkUod3ZpZi0+bWNhc3RfZmlsdGVyLmFkZHJlc3NfbGlzdCkpCisJCWlmIChjb3VudCA+IEFSUkFZ
X1NJWkUod3ZpZi0+ZmlsdGVyX21jYXN0X2FkZHIpKSB7CisJCQl3dmlmLT5maWx0ZXJfbWNhc3Rf
Y291bnQgPSAwOwogCQkJY29udGludWU7CisJCX0KKwkJd3ZpZi0+ZmlsdGVyX21jYXN0X2NvdW50
ID0gY291bnQ7CiAKIAkJaSA9IDA7CiAJCW5ldGRldl9od19hZGRyX2xpc3RfZm9yX2VhY2goaGEs
IG1jX2xpc3QpIHsKLQkJCWV0aGVyX2FkZHJfY29weSh3dmlmLT5tY2FzdF9maWx0ZXIuYWRkcmVz
c19saXN0W2ldLAotCQkJCQloYS0+YWRkcik7CisJCQlldGhlcl9hZGRyX2NvcHkod3ZpZi0+Zmls
dGVyX21jYXN0X2FkZHJbaV0sIGhhLT5hZGRyKTsKIAkJCWkrKzsKIAkJfQotCQl3dmlmLT5tY2Fz
dF9maWx0ZXIubnVtX2FkZHJlc3NlcyA9IGNvdW50OwogCX0KIAogCXJldHVybiAwOwpAQCAtMjIw
LDEyICsyMTgsMTIgQEAgdm9pZCB3ZnhfY29uZmlndXJlX2ZpbHRlcihzdHJ1Y3QgaWVlZTgwMjEx
X2h3ICpodywKIAkJCXd2aWYtPmZpbHRlcl9iZWFjb24gPSB0cnVlOwogCiAJCWlmICgqdG90YWxf
ZmxhZ3MgJiBGSUZfQUxMTVVMVEkpIHsKLQkJCXd2aWYtPm1jYXN0X2ZpbHRlci5lbmFibGUgPSBm
YWxzZTsKLQkJfSBlbHNlIGlmICghd3ZpZi0+bWNhc3RfZmlsdGVyLm51bV9hZGRyZXNzZXMpIHsK
KwkJCXd2aWYtPmZpbHRlcl9tY2FzdCA9IGZhbHNlOworCQl9IGVsc2UgaWYgKCF3dmlmLT5maWx0
ZXJfbWNhc3RfY291bnQpIHsKIAkJCWRldl9kYmcod2Rldi0+ZGV2LCAiZGlzYWJsaW5nIHVuY29u
ZmlndXJlZCBtdWx0aWNhc3QgZmlsdGVyIik7Ci0JCQl3dmlmLT5tY2FzdF9maWx0ZXIuZW5hYmxl
ID0gZmFsc2U7CisJCQl3dmlmLT5maWx0ZXJfbWNhc3QgPSBmYWxzZTsKIAkJfSBlbHNlIHsKLQkJ
CXd2aWYtPm1jYXN0X2ZpbHRlci5lbmFibGUgPSB0cnVlOworCQkJd3ZpZi0+ZmlsdGVyX21jYXN0
ID0gdHJ1ZTsKIAkJfQogCQl3ZnhfdXBkYXRlX2ZpbHRlcmluZyh3dmlmKTsKIApkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaCBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmgK
aW5kZXggYTkwZWFmNTA0M2E4Li4zMTA5NzA1NzU2M2EgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3Rh
Z2luZy93Zngvc3RhLmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaApAQCAtMjgsMTIg
KzI4LDYgQEAgc3RydWN0IHdmeF9oaWZfZXZlbnQgewogCXN0cnVjdCBoaWZfaW5kX2V2ZW50IGV2
dDsKIH07CiAKLXN0cnVjdCB3ZnhfZ3JwX2FkZHJfdGFibGUgewotCWJvb2wgZW5hYmxlOwotCWlu
dCBudW1fYWRkcmVzc2VzOwotCXU4IGFkZHJlc3NfbGlzdFs4XVtFVEhfQUxFTl07Ci19OwotCiBz
dHJ1Y3Qgd2Z4X3N0YV9wcml2IHsKIAlpbnQgbGlua19pZDsKIAlpbnQgdmlmX2lkOwpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaCBiL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4
LmgKaW5kZXggMzk0MTQ2MjA5N2E0Li41MzE4NGZlMmRhNGIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
c3RhZ2luZy93Zngvd2Z4LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaApAQCAtNzcs
NyArNzcsNiBAQCBzdHJ1Y3Qgd2Z4X3ZpZiB7CiAJdTMyCQkJbGlua19pZF9tYXA7CiAKIAlib29s
CQkJYWZ0ZXJfZHRpbV90eF9hbGxvd2VkOwotCXN0cnVjdCB3ZnhfZ3JwX2FkZHJfdGFibGUgbWNh
c3RfZmlsdGVyOwogCiAJczgJCQl3ZXBfZGVmYXVsdF9rZXlfaWQ7CiAJc3RydWN0IHNrX2J1ZmYJ
CSp3ZXBfcGVuZGluZ19za2I7CkBAIC04OCw2ICs4Nyw5IEBAIHN0cnVjdCB3ZnhfdmlmIHsKIAog
CXN0cnVjdCB3b3JrX3N0cnVjdAl1cGRhdGVfdGltX3dvcms7CiAKKwlpbnQJCQlmaWx0ZXJfbWNh
c3RfY291bnQ7CisJdTgJCQlmaWx0ZXJfbWNhc3RfYWRkcls4XVtFVEhfQUxFTl07CisJYm9vbAkJ
CWZpbHRlcl9tY2FzdDsKIAlib29sCQkJZmlsdGVyX2Jzc2lkOwogCWJvb2wJCQlmaWx0ZXJfcHJi
cmVxOwogCWJvb2wJCQlmaWx0ZXJfYmVhY29uOwotLSAKMi4yNS4xCgo=
