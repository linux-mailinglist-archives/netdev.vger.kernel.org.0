Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC4D1B10ED
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 18:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729468AbgDTQDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 12:03:54 -0400
Received: from mail-mw2nam10on2061.outbound.protection.outlook.com ([40.107.94.61]:6055
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729267AbgDTQDx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 12:03:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XyetVRWuofgzcrRiYqHXaw62tgBJmMQM95tdqUvF6CpwATdyMF5kiPTMn8jEvvepnf+rGGX0h84Epaxr2zaGgp3HiRaw2z6UKaIH2RYXnqNbctNCJbLel88A33Xsa8Y3Fdge/ri57ByyG+HKDhFdn2Nb8Cxaz9V8X1JeYC5sMuqVpRYdglfvQhftID/CPEcE0NulLrcEX/FhFbR2w701k+xEZPzaZJsrF+fxfXTryHGwyGwDbnT0AErUsZSEnQgD1qkyULsZVc01cUi66aaPLYdiVJZZJpw+PU9DSJOfvjv5PlE8lYMzpMo4XpY9PKopzminRrpUhN7lNTZwKd7L6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mGvnorlYE9ZsxTJifkNI4/HN+oeVN93qgbGMLoSMjNw=;
 b=iYPl4udYJ6l2pBE3+Pjn0S6Oh8AZpGcqExNIovwijd9AQ884J71X7t4bMrK3GDB8J9+p3pm042lqBZewWjooMge6FR/QI/xESn+RIFykmIP249h75TVONjYGK/RnLlSMjlq5z+07uuWkOoklmpF5SVchd9w/uIwavcgkIoF9h75aXNFLC+SpqRWPFwcE4S4WnZO5PMNvdlZLFUoWTZuarv9bb7PJl4wdgsIpMptaTof9f2sI8O6hKbGERWvJOcnJgbB4YGLWIZamODqi1fUoAn4W71EsI6tXhQCg6oa/0lCkp3+mF1j7RumvKO5nPgH5W2eYdDvyxz5lCqUz6PIUCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mGvnorlYE9ZsxTJifkNI4/HN+oeVN93qgbGMLoSMjNw=;
 b=WUdE18ZiOx0T/BV01tvZbsQsKPoUUXSqvZauQ5g2Y5SgS9Bhuzug1x/kG0VYAhYoapTPckV3whAh1eh9v0FjEWjA/qrd9fdQCSKfoDBw7/59ExvZPr+uE8OdnFTUNpfWXByawAyxeT7i9lcCyxjrQIrvcN9nf6LDEzHYkNA115Q=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHSPR00MB249.namprd11.prod.outlook.com (2603:10b6:300:68::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Mon, 20 Apr
 2020 16:03:47 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.030; Mon, 20 Apr
 2020 16:03:47 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 09/16] staging: wfx: drop useless update of field basic_rate_set
Date:   Mon, 20 Apr 2020 18:03:04 +0200
Message-Id: <20200420160311.57323-10-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420160311.57323-1-Jerome.Pouiller@silabs.com>
References: <20200420160311.57323-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM6PR07CA0065.namprd07.prod.outlook.com
 (2603:10b6:5:74::42) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM6PR07CA0065.namprd07.prod.outlook.com (2603:10b6:5:74::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.26 via Frontend Transport; Mon, 20 Apr 2020 16:03:45 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 031582d9-bceb-4665-c5a6-08d7e54468b9
X-MS-TrafficTypeDiagnostic: MWHSPR00MB249:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHSPR00MB2495F13C61BACD87852057393D40@MWHSPR00MB249.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(376002)(396003)(39850400004)(346002)(8676002)(7696005)(52116002)(6666004)(4326008)(8936002)(81156014)(66556008)(66476007)(66946007)(36756003)(186003)(54906003)(16526019)(107886003)(478600001)(2906002)(316002)(66574012)(1076003)(86362001)(6486002)(2616005)(5660300002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SAOHjXph3AhglfHUpXrbGYofNK9gmrTZ5vv9xkYeXwUNB9uv+/ABBt/dQuTwwG5uby1XP3Xrh9yEmGue+rVUy0ZbkF9TUrSdJ0vQtRLZUvhpBHef72sUTm+e7UU/23vCrIzNaXnWyaLstocg0bt6lwdghZgU0BavUYhUcY/lrvsvn3L9OTEc5o5XDJzv6X37vsfSeI6Ce0vuC58IurUwI8ElnJfPsd3n6XPnZ2mEZEkgC8wR5PpxAEuv9XYA1tnQyVEYtM4DqiYku7YcNVw05AT0/7/feRRYR92X8zMJSN7CdXbsvhk7ICRr5ytI7ggBNWbCILYWAYvpWrayd/qNKMQ6Smn0uB+laCevpJbvcxi/NFg/Q5QbQBLweZUCWfQk2Prh3204lWNLcFK9XjB1Goo3GvBl1UFTyWYANjKO8KKh3daUkhQc/BtcAVvvi6Fe
X-MS-Exchange-AntiSpam-MessageData: PRYDL4SLP4ykVUzUv8UY3lLuMXecRehdS05uc8qiksnTZwP/lBSqeWSAGKTIR/xdUaLEeXPSsFlHlva7vFUdHRPf7wT8Z/77LeWvUobtzmEVjefqrmJClepyMnjBP2q1DSu4q5ThD8qdjS3oMNsnMpXhx0r/bEYeXsfX4TvsBMharQWgn9nmbwmOZvzpewFvBkDOIACWvX5GRTGJ/M6x0IS0uWiirgdOEbWNNFjRuD7/RHxZ/FtPa+4WMlVQPdJQg67CF/GS1mRnVoyDKxI1BGosbtWDjqcCDbKV1XdJZowuJV4RAyPTMADAq/sgGMc/J9k7AEFhKhrm3iiKXfDW0VVRiRLwOm5ebxrGh9n6URSw5qmUSjK9Ug0c78i29fTVCEem6ZTQE0BbVK6qnY86IMhMumHNYqA/VCHsslHRLkuxu3wjwtIyHlxp5ZiSH79UcRTNVCTySio/GYVzYVmLmoCV6bMGEtgmX7tsbfbbA4Cg8tUQgTdu/A8fDK+rlbOkXWep6sYWWT+Ao1iJJ6eZjftpFg8Sz2rVMqb/FusZNy388L9lWwpnF3IaKtYeJgXYcEcmM+ua0n8RiVTbbBa14eOZPsHNYcqgOb2IqA4onoL7NyVU0Rnkvu4WdldmLrrsdQBHXmkNgF/X8aA5IUqbpkm2hta0BuL6zLoA0TBQxRK8P5G/Xn2SwTCVm5qCxiuNgwu/iz4fOPyDf3qg25p2rMWPE0yErVXHkQ4Eh+F4XeE0pb7ZMLrldmvKcZ02gkqgi6z6/zQe6VtssP9UWx1566oTFcBxod3eLNsRqG0g/TpZOCDxexCUj9xYUnEq+r6MHE3sAy2ESpIMcQIKAnJT2FatF6yLU+v0kYLPo3T5Fm4=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 031582d9-bceb-4665-c5a6-08d7e54468b9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 16:03:47.7314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JIGAafLx6ICQnNwvRS4+OkjDZAa1R93YiBMNSc8VxczeaLBzzK+1gvUEs4fOtOkWDzhT5dKI7yPRY8i/4Q2fOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHSPR00MB249
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQmFz
aWMgUmF0ZXMgYXJlIGFscmVhZHkgc2V0IGJ5IGhpZl9qb2luKCkuIGhpZl9qb2luKCkgaXMgYWxz
byBhYmxlIHRvCm1hbmFnZSBwb3NzaWJsZSBjaGFuZ2VzIGFmdGVyIGFzc29jaWF0aW9uLgoKRmly
bXdhcmUgYWxzbyBhbGxvd3MgdG8gY2hhbmdlIHRoZSBCYXNpYyBSYXRlcyB3aXRoCmhpZl9zZXRf
YXNzb2NpYXRpb25fbW9kZSgpIGJ1dCBpdCBkb2VzIG5vdCBicmluZyBhbnl0aGluZyBpbiBvdXIg
Y2FzZS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJA
c2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuYyB8IDMgLS0t
CiAxIGZpbGUgY2hhbmdlZCwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2hpZl90eF9taWIuYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5j
CmluZGV4IGYwNDExNmVjYjM3My4uMTZmNDkwODA1NWFmIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2hpZl90eF9taWIuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9t
aWIuYwpAQCAtMTkwLDE1ICsxOTAsMTIgQEAgaW50IGhpZl9zZXRfYmxvY2tfYWNrX3BvbGljeShz
dHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIGludCBoaWZfc2V0X2Fzc29jaWF0aW9uX21vZGUoc3RydWN0
IHdmeF92aWYgKnd2aWYsCiAJCQkgICAgIHN0cnVjdCBpZWVlODAyMTFfYnNzX2NvbmYgKmluZm8p
CiB7Ci0JaW50IGJhc2ljX3JhdGVzID0gd2Z4X3JhdGVfbWFza190b19odyh3dmlmLT53ZGV2LCBp
bmZvLT5iYXNpY19yYXRlcyk7CiAJc3RydWN0IGllZWU4MDIxMV9zdGEgKnN0YSA9IE5VTEw7CiAJ
c3RydWN0IGhpZl9taWJfc2V0X2Fzc29jaWF0aW9uX21vZGUgdmFsID0gewogCQkucHJlYW1idHlw
ZV91c2UgPSAxLAogCQkubW9kZSA9IDEsCi0JCS5yYXRlc2V0ID0gMSwKIAkJLnNwYWNpbmcgPSAx
LAogCQkuc2hvcnRfcHJlYW1ibGUgPSBpbmZvLT51c2Vfc2hvcnRfcHJlYW1ibGUsCi0JCS5iYXNp
Y19yYXRlX3NldCA9IGNwdV90b19sZTMyKGJhc2ljX3JhdGVzKQogCX07CiAKIAlyY3VfcmVhZF9s
b2NrKCk7IC8vIHByb3RlY3Qgc3RhCi0tIAoyLjI2LjEKCg==
