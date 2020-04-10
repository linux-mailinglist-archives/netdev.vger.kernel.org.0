Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5E81A46F3
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 15:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbgDJNeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 09:34:23 -0400
Received: from mail-dm6nam12on2082.outbound.protection.outlook.com ([40.107.243.82]:31903
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726878AbgDJNdd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Apr 2020 09:33:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjcVnDgT/kpUY9C443We4/V1Bh+tqS3ZJm8dGR/q3PSUXGRHQ77G3mWzuBijqOCysEkcVu1rKOfgdfJe6H773LGdxa553n0W0uu0sW8IlcyQlbh9/7qBNDk/bbx0UPjTwGLuV5ya5d9TTObDn5rWvXhzh0Bqr8Kd0jgv1ysDVD2R7i9rlWvpzTT0S/QkQoNqppM8sN6gZ+Wf47zG+s7ydhk/ZcKKfRSyRAG7lhkUzrepz/zxHXyNj3dCwjC43X+SSB7W3hNVqCM9v/Mf14g3CN3r/mZKNom2+RN0JSJbhUHxtLI56Z3cCu0H/KKX6kKdgg3Ep8eBw4beIeKyztn0og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sYn8EeJqHkBzXGtW91SPJndcamQP1AoszTMhx31mvTg=;
 b=irggwoTcbN+1jQPy4CDk0tvMPSEWK492izA9vFAZMywsNCSRFp9lfebux9mofzobhOBRZIMA5W+B2tZSsgFpmvFmrFW1jIfWp4l+HLHolvB8zgEPPwc5yDtbXkyMJkUppsfrMgfdQqAh3oMyF3b3qZi35K9VnT6URoWiExm2eWLML7ffP/y1/F/Ez13/F7HnSHUjLa7hsSoqkGUln5im69DuK+mHsW/2CA+dQYupXN82dB9LccXlbtzyEyBIItCUDzE7mTZKuVUm9xo5Eq9LCL8pDfi1gZdf1xyAaPE/xpE7lBjFvNehnMWCg3vvKyU5YriedfF0LSp+BNRkpZBJeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sYn8EeJqHkBzXGtW91SPJndcamQP1AoszTMhx31mvTg=;
 b=nl5nd+6morrG06AXrNaIGSlGnHdi7E7AswbZ+w7LDDdMjnlw4mQiG1q8NYD3TFtghw4O9+86z7pfO9vh+M0BKx1sgwc289EVbCbX1Mzfoe7yVNf3C32F7cp9iLC4pRY9LmaN2gM1D7ycvRKViohX3EZI5TN/Z7BVCpvcGvqjzE4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4398.namprd11.prod.outlook.com (2603:10b6:208:18b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Fri, 10 Apr
 2020 13:33:22 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::3d0a:d9ac:3df4:8b1%6]) with mapi id 15.20.2878.021; Fri, 10 Apr 2020
 13:33:22 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 12/19] staging: wfx: remove unnecessary conditions in wfx_bss_info_changed()
Date:   Fri, 10 Apr 2020 15:32:32 +0200
Message-Id: <20200410133239.438347-13-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200410133239.438347-1-Jerome.Pouiller@silabs.com>
References: <20200410133239.438347-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR15CA0056.namprd15.prod.outlook.com
 (2603:10b6:3:ae::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by DM5PR15CA0056.namprd15.prod.outlook.com (2603:10b6:3:ae::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Fri, 10 Apr 2020 13:33:20 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df234838-656e-487a-9dbc-08d7dd53bccc
X-MS-TrafficTypeDiagnostic: MN2PR11MB4398:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB43985D285243F4B16DC1E2F493DE0@MN2PR11MB4398.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(366004)(346002)(396003)(136003)(39850400004)(376002)(107886003)(81156014)(54906003)(8676002)(86362001)(1076003)(6666004)(8936002)(4326008)(52116002)(66574012)(7696005)(316002)(66556008)(66946007)(186003)(478600001)(2906002)(6486002)(2616005)(66476007)(16526019)(5660300002)(36756003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w1exqkQ5OPIBN7mVCGzw5gZGjmiiRkrmY6sZoNLKY4qvRww6t7EocahJBsfGO7f5vgLO9xwz7MZKq4AkJ0Rb4H3LB02D1xornNi4Ng8Y6/d4t+kHmYioNFXmwoMHU1o00pqMds+34Cg4BgWvGIPndBNUhXBsLZ8htA+Q1SvfDFJJMG3i+18dYaqi+91S6SbclIzkMJmI89hdQJW6+JltMBz152dIe6K0NyEZf/QTtpdcvwNR4524h3dtPRb73aXKdlVkWkXEOmjYw5jQ8I7HKqh1ZxSeFfhvqWPLaqiIHzBUAOLbcTgbBu6uPlkEqB7A50wNDtYBSDtzwJeTdFl2bIBOvt38LzHDZFwGVEAR/VgJ9u+/v8uGcXAmv8z8apCSZfsdJSb1zHc9tfvF5xDhv/zaRrokWn1o0WBFF194H6DC6A3lD2St90xZEACAof2l
X-MS-Exchange-AntiSpam-MessageData: 3wV1dZaWkdXRCil3cA/YqKtJ40rQekQTmF5FPezzyFIAuZramoHFq51wr9GuYaEbWLC7xXEdfZcUqWL9lf3R8u4pEnVcNA9zhdDxvYfZvvIY2qm+dnz6eHvFykyUjzJcem/stH48Ne7e3IEAXue3fPzP0qOdlqJMC8GuL4ko0iJJOSfbgyNAQMM6Y6ZxpZRXRrfB4Fxb5oLBq1lWeb1DBQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df234838-656e-487a-9dbc-08d7dd53bccc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 13:33:21.8643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cv2jPwoHeYD3ECL7LmenIamPGAmQt5fldtZOMvaLPdErDreL65GSYKKUP8QaAngmSERhMPJd+I0HW6Vs2gYk8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4398
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X2Jzc19pbmZvX2NoYW5nZWQoKSB1cGRhdGUgRVJQIGFuZCBDUU0gcmVsYXRlZCBzdHVmZi4gVGh1
cywgaXQgY2hlY2sKdGhlIGZsYWdzIEJTU19DSEFOR0VEX0VSUF8qIGFuZCBCU1NfQ0hBTkdFRF9D
UU0uCgpJdCBhbHNvIHVwZGF0ZSBFUlAgYW5kIENRTSBvbiBqb2luIGFuZCBsZWF2ZSBieSBjaGVj
a2luZyB0aGUgZmxhZwpCU1NfQ0hBTkdFRF9BU1NPQy4gVGhpcyBjaGVjayBpcyB1c2VsZXNzLiBN
YWM4MDIxMSBhbHJlYWR5IGRvIHRoYXQgam9iCmFuZCBzZXQgbmVjZXNzYXJ5IGZsYWdzIGFzIGV4
cGVjdGVkLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxl
ckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgfCA3ICsrKy0tLS0K
IDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3Rh
LmMKaW5kZXggMzUxMmU1OWYwOTY4Li4xMWQ2MmRlNTMxZTcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtNzI1
LDggKzcyNSw3IEBAIHZvaWQgd2Z4X2Jzc19pbmZvX2NoYW5nZWQoc3RydWN0IGllZWU4MDIxMV9o
dyAqaHcsCiAJCWhpZl9rZWVwX2FsaXZlX3BlcmlvZCh3dmlmLCBpbmZvLT5tYXhfaWRsZV9wZXJp
b2QgKgogCQkJCQkgICAgVVNFQ19QRVJfVFUgLyBVU0VDX1BFUl9NU0VDKTsKIAotCWlmIChjaGFu
Z2VkICYgQlNTX0NIQU5HRURfQVNTT0MgfHwKLQkgICAgY2hhbmdlZCAmIEJTU19DSEFOR0VEX0VS
UF9DVFNfUFJPVCB8fAorCWlmIChjaGFuZ2VkICYgQlNTX0NIQU5HRURfRVJQX0NUU19QUk9UIHx8
CiAJICAgIGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9FUlBfUFJFQU1CTEUpIHsKIAkJdTggZXJwX2ll
WzNdID0geyBXTEFOX0VJRF9FUlBfSU5GTywgMSwgMCB9OwogCkBAIC03MzksMTAgKzczOCwxMCBA
QCB2b2lkIHdmeF9ic3NfaW5mb19jaGFuZ2VkKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LAogCQkJ
aGlmX3VwZGF0ZV9pZV9iZWFjb24od3ZpZiwgZXJwX2llLCBzaXplb2YoZXJwX2llKSk7CiAJfQog
Ci0JaWYgKGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9BU1NPQyB8fCBjaGFuZ2VkICYgQlNTX0NIQU5H
RURfRVJQX1NMT1QpCisJaWYgKGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9FUlBfU0xPVCkKIAkJaGlm
X3Nsb3RfdGltZSh3dmlmLCBpbmZvLT51c2Vfc2hvcnRfc2xvdCA/IDkgOiAyMCk7CiAKLQlpZiAo
Y2hhbmdlZCAmIEJTU19DSEFOR0VEX0FTU09DIHx8IGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9DUU0p
CisJaWYgKGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9DUU0pCiAJCWhpZl9zZXRfcmNwaV9yc3NpX3Ro
cmVzaG9sZCh3dmlmLCBpbmZvLT5jcW1fcnNzaV90aG9sZCwKIAkJCQkJICAgIGluZm8tPmNxbV9y
c3NpX2h5c3QpOwogCi0tIAoyLjI1LjEKCg==
