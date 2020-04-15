Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 163A91AAD7A
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 18:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415355AbgDOQNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 12:13:46 -0400
Received: from mail-bn7nam10on2054.outbound.protection.outlook.com ([40.107.92.54]:6037
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1415263AbgDOQNE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 12:13:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VIOeTWnXNd5YcHMdtFUvOuVWBNOmc0hZjbaAHKhbbElh9OyvCDLNMUyYulXNRD/JhWDFXNjIWIdMzylCIgzhSVgTx74beUJrZB8B90yJWBtzhfkhJx5FbS7sQ06H7P8lqR0jWRZTQJv5IMZJKrtMjS6cWy3UKPY6lKrSOOcPupD3cjsTm975xJfzmUqSxFy3b3sKWGc1Fb1YjQULPHw881UwZFKNycSUMAewxJiieTXHUoGhu6HE0PlA6sKtIF3aJCpKgXz6l/fL/le2KplrEAr2TIhzuEX9U5/WWALdICiJDnslE54TXkX+SjQTVMRJkhf/2nuqzqT55v9EJaImVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fF1c1odyUWEdA7qk8eY48KJgo84mmGoLbVm+zHbzEg0=;
 b=UV7WcLmMko5JjLsAuCqpUWmsEujVzY9sW8vT4JQLWleMhAlhbxjxsQ8krb65O1jNm7t3+F7OzZkpOsUPOtCVmVvMERDjbVKUIKOi8z8dFqJGelrZMtefE0bTzzDYRd7RmIoM0k78hsLd6jmdVyNma2KaPens8k94JsVJOIfJ7QLPXZ4yUPIVp/O8g9OCRJqWwjpUm88C5leNxZIx0nOmLH8aktCDGEbZ+LhdVc56NOFqDFy0x5v0O1lDJh2CQt8d+h7mBRnFEJg8G+SAvlMg1d43kpy5HUxQPFQb3z3WYwlbahvqcX5G7gR+qm5o6Q1BNVJOYi+/z2B+Pw55DxL3gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fF1c1odyUWEdA7qk8eY48KJgo84mmGoLbVm+zHbzEg0=;
 b=AaWXN09pHlu6l6xrpJji8UE716iUczqLs8z1Fk/HmpA1TL9lLBunFaCfyC9L8TttFbM/JETlGn4m566s4pb/eBoOHNBc9deAbch0ETMFhNhJJWZiZBAKqLbtOyoNBg6bb2E1HXpn630BZGuGmoP1TXQZp29DwwE0O6srA8oBDp4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1599.namprd11.prod.outlook.com (2603:10b6:301:e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.28; Wed, 15 Apr
 2020 16:12:50 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.024; Wed, 15 Apr
 2020 16:12:50 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 15/20] staging: wfx: drop useless call to hif_set_rx_filter()
Date:   Wed, 15 Apr 2020 18:11:42 +0200
Message-Id: <20200415161147.69738-16-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR1PR01CA0027.eurprd01.prod.exchangelabs.com (2603:10a6:102::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Wed, 15 Apr 2020 16:12:48 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec2eb62e-35a1-4724-df1a-08d7e157d836
X-MS-TrafficTypeDiagnostic: MWHPR11MB1599:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB159915D9A62EC4910735063D93DB0@MWHPR11MB1599.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:185;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(376002)(396003)(346002)(366004)(39850400004)(136003)(4326008)(66476007)(107886003)(81156014)(86362001)(8936002)(2616005)(6512007)(6486002)(316002)(52116002)(66556008)(66946007)(6666004)(6506007)(8886007)(2906002)(1076003)(36756003)(66574012)(5660300002)(4744005)(54906003)(478600001)(16526019)(8676002)(186003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JrXIxa1sJxvXKClEqEwTMHlrTHQ358ARAoi+Yrt+cBLaxauXBz3KENGABwk5S/AzbiswvrjZiR00Gm7sYLZ2zzJJNXmKZpBG3SlZjWeT4unYGMgoZ3cpTSpN3fZGD8YZvk7vAfdpbcZiNu+QYT9WLb+5E031W9oI8dl8J3QRZvB3xbA6Zt4MM9rTfV+XVIEiCQfHvhEA84KYUFiDaI4LW9kYT9lT37AmjYro9ZuH5UQvWVkV07l7PlOnKUErk/P9JVElORO+LU9LTdLjBdCmKJ+6FUCtyW3Av8eSqwy6cX+ADL2us48VJLFhWLrum6vBSOd5COQCJdXu2Xvus2XTGWdHG88Cj9oHBfzfpCCAZA8LAOxnkW8JoRW48Zushr3RgmRwyMeq6PMVhe9mU+d3beduOCQBHZPGMyetJFmZkCBSD9wAIG/8Oy4urkv5ypI3
X-MS-Exchange-AntiSpam-MessageData: m5qFc93zg7Vu5iOVsoKjNXhPjWuFo9n1IkmLDhbYFuNv4Dq7//H2Vu3ua0qQ51sYCWwYE4dpdIDFI5W9YeESrEHBn5hyzdFP5pZjCdNwVSn9jwdHGpS2SGArj5eq+ay6fr86/XTWcrJ/KFXRA7qtx0uKDnAzKzUKP0k1zs5yHt7Hi/YASudHHnME3GPe9iRky42UOawodVEKfOS2hqgkAg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec2eb62e-35a1-4724-df1a-08d7e157d836
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2020 16:12:50.4902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xf4ZEMEV5SAcI8ozv+DGdujQPzkkDgKVg4DezjpVZS/rb40J5FQMLDb1Dyu/IeGSBOwScy+ao1e9+zNhZrZW6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1599
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKaGlm
X3NldF9yeF9maWx0ZXIoKSBhcHBseSBjaGFuZ2VzIG9uIGZpbHRlcl9wcmJyZXEgYW5kIGZpbHRl
cl9ic3NpZCB0bwp0aGUgaGFyZHdhcmUuIEVhY2ggdGltZSBmaWx0ZXJfcHJicmVxIGFuZCBmaWx0
ZXJfYnNzaWQgYXJlIGNoYW5nZWQsCmhpZl9zZXRfcnhfZmlsdGVyKCkgaXMgY2FsbGVkLgoKQ3Vy
cmVudGx5LCBvbiBleHRyYSBjYWxsIHRvIGhpZl9zZXRfcnhfZmlsdGVyKCkgaXMgbWFkZSBmcm9t
CndmeF91cGRhdGVfZmlsdGVyaW5nKCkuIFRoaXMgY2FsbCBpcyB1c2VsZXNzLiBEcm9wIGl0LgoK
U2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMu
Y29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgfCAxIC0KIDEgZmlsZSBjaGFuZ2Vk
LCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBi
L2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggNzAzNDJiZGQ5ZDk2Li5jNzUwNWI1ZDA5
NDcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYwpAQCAtMTM2LDcgKzEzNiw2IEBAIHZvaWQgd2Z4X3VwZGF0ZV9maWx0
ZXJpbmcoc3RydWN0IHdmeF92aWYgKnd2aWYpCiAJCX0KIAl9OwogCi0JaGlmX3NldF9yeF9maWx0
ZXIod3ZpZiwgd3ZpZi0+ZmlsdGVyX2Jzc2lkLCB3dmlmLT5maWx0ZXJfcHJicmVxKTsKIAlpZiAo
IXd2aWYtPmZpbHRlcl9iZWFjb24pIHsKIAkJaGlmX3NldF9iZWFjb25fZmlsdGVyX3RhYmxlKHd2
aWYsIDAsIE5VTEwpOwogCQloaWZfYmVhY29uX2ZpbHRlcl9jb250cm9sKHd2aWYsIDAsIDEpOwot
LSAKMi4yNS4xCgo=
