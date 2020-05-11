Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937101CDF7F
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730677AbgEKPuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:50:19 -0400
Received: from mail-mw2nam12on2062.outbound.protection.outlook.com ([40.107.244.62]:10442
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730648AbgEKPuO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 11:50:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9iPaf0cevTYGFsIEZ9mxBPevuzUjZ3/7ogYekWyJZRxrZHdpIW/PhiNPjFEAkPGAMbK8DRgu1UzFyxbM5p24hb4v2+CqqYDemvD2PHUh/k0onK5zNOMT5GXnZJ3nQV/wFXEQnXqRQU761MEO2wCJNBM42AsKMa+4kBEyWr9Jaq8gY7dWV0H5qNKka4pjFte7KmiBjWSj5+mFl4mCtUcO+RzlBYY2xQDkziRIVjSv6bHmcBGdF80T9vwW2pw8BLIQoj1jU79hl+4MSbA203WJL89bnUkOuyTZk/cgIipUXPuTEx22vM74A740IUINaRxJVQB5teukLe8JfkSOLWRGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMU9prHPQ5lHqZN+StG88B7rwQkzvC3y06Aj7lGDv00=;
 b=iPGIV2+LYqhxlkdDKUC5sEEFCIFOz3wTonvaISrwwEftlaMzY+TylF1YDEKOQ5/M8tR68W0JplrlC32SsBFhFqxWTjunJdWtajnDqmKWo7BI8TtxLQVgkxsdVWl/KQqsoQCiKzoU3XFBz0pghpc+y8eNKIVS+cwPVsnfx3ULoEn6pAniaRMb5PFyrGB+1LEn4Aro/ovXUWMJweKXeGpBiFG02xSUUatiHnbYT44W3D5up7l7HMECribTL5ahQiU8mT7/cFLWy4wuXn4WBTCSk3r37dQJ6GJlC469mBhUfUrAKDRe3IX16pwrAkhcoHaBqCA2WkBTrD8zqLzg+7L2zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMU9prHPQ5lHqZN+StG88B7rwQkzvC3y06Aj7lGDv00=;
 b=SXAtrsTdtvQ2Fo4h/G/jOxqaHmhFBHHkU2jhk+J1QVeZFGd/OQLBFdWFRIHVjvMqDPbMztTyMpM+p5aIBMVnB92aNP9zBk7ohiMpxwkkBIZpw8YYqplINPq9RWUvAMV09xNm9VCqDYWKKpKgqFuQBwXnLEMi29IY4TMZJQiB9EU=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1968.namprd11.prod.outlook.com (2603:10b6:300:113::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Mon, 11 May
 2020 15:50:08 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 15:50:08 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 11/17] staging: wfx: declare the field 'packet_id' with native byte order
Date:   Mon, 11 May 2020 17:49:24 +0200
Message-Id: <20200511154930.190212-12-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200511154930.190212-1-Jerome.Pouiller@silabs.com>
References: <20200511154930.190212-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN6PR2101CA0026.namprd21.prod.outlook.com
 (2603:10b6:805:106::36) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (82.67.86.106) by SN6PR2101CA0026.namprd21.prod.outlook.com (2603:10b6:805:106::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.2 via Frontend Transport; Mon, 11 May 2020 15:50:06 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0a933d4a-8e47-44b0-dc03-08d7f5c2fad5
X-MS-TrafficTypeDiagnostic: MWHPR11MB1968:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1968BB2A451ADE16FF9FF61593A10@MWHPR11MB1968.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DDnYAjkdSwaLWMJj82Gl3JqDQBMukebqdFsaZsQm600YlpXkhsNF5N3uNiwm0E3lNYuOrt/zUlyL3FIaz7R4qI+Q6Lw56dE8U7m5yBREeExEZbZptzrqr9Jr7fqfAVPGHToFeGGEshVzoCE2/tTcCh7GfvS218eeF5iOfAiJTqCU6PYq5eEQGAzP6pSDLv9OEO3CRbHnobpTOSBhZD0K+GZEfKT8c/NKAHMoNZRkb4k/fwjj2c4M78x+Oi1SIgvpo9HtFmHYdhjQy6k1uXppv2DmBeffmLTD2aJyqMSiGsFX7IrPcvOej2EwGgTStZMbwvpZFGg6MZJIN3QuDMdImuNUhPyrJErXDs1q9depwJrbR7r6iiGPqT/dG+WMhBCGtMLjyFIC0PUtlT1PaCEglwS3YiBBGMvdEFjekz3IE3wVSCWdOXsqoyCHJXZ/kr4f74L9p6UfRQKMpHBn1g9DuaTWWHxezNHcsHRVR2YSI1HVSB+OlWZ1yrOXd+bmYF87TAD5eP9/hL0RJd2rwzM4ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(346002)(136003)(396003)(376002)(366004)(33430700001)(186003)(52116002)(86362001)(316002)(5660300002)(7696005)(6486002)(33440700001)(478600001)(54906003)(6666004)(4326008)(107886003)(36756003)(16526019)(26005)(8936002)(956004)(2616005)(8676002)(1076003)(66476007)(66946007)(66556008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /Z6AIN8exZ/4tQUQvmzjrFoU/rad7JZQIONqw+7EMK3Ckwp5J8M87BSgH0/N+ptkBxNua06YCEDC69zY7eHSvsLMvsXvNI39jYlpw1J5cdFbthtEa3w3ZfnryoF4MyF8YBzpGrlXQT4OzCa8mLV+8NqwKdWWXNCuw1BZMuoLtzBlBd273kHPfZ8hI9PioxX2rLMo8PqZVfDh5oM7AXAWD9glC+REvboN922WqkRcT9rEiDbmOFl1aU1rmi9Mp3EiN4u5FpDgPR+THxU/NcqEtGrEOf8ZwU11XFkc0XnMSSH98RiPZxrferwyf7RecmEE4/q6Y9JPu32I1gJnyPi+jmuRO49xQsWtia5KpEwDP3N3xqfy82ZsVwwKF3cF5LbzN4mbQiIVxe1bpfPVQ4s39Fq+RHKMtDMa6i5wsdgbJs4wNy+hL2FJ0vFhvuJvXktBVIZFpa33Vt5XObmKhu9s/pd3KKcjOLyi9VkL7iRYYnc=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a933d4a-8e47-44b0-dc03-08d7f5c2fad5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 15:50:07.9983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I58X0vx6YRGDOGVrvzgeYTbhRnl0rUtnDzCqTRU37pP9nIvGwYFLgJY39T6EDF+1m/c+hb9jz7SwBhXsjWlxeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1968
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZpZWxkIHBhY2tldF9pZCBpcyBub3QgaW50ZXJwcmV0ZWQgYnkgdGhlIGRldmljZS4gSXQgaXMg
b25seSB1c2VkIGFzCmlkZW50aWZpZXIgZm9yIHRoZSBkZXZpY2UgYW5zd2VyLiBTbyBpdCBpcyBu
b3QgbmVjZXNzYXJ5IHRvIGRlY2xhcmUgaXQKbGl0dGxlIGVuZGlhbi4gSXQgZml4ZXMgc29tZSB3
YXJuaW5ncyByYWlzZWQgYnkgU3BhcnNlIHdpdGhvdXQKY29tcGxleGlmeWluZyB0aGUgY29kZS4K
ClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJz
LmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmggfCA4ICsrKysrKy0t
CiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaCBiL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX2FwaV9jbWQuaAppbmRleCA2ZjcwODAxOTQ5YmIuLmJiOGM1NzI5MWY3NCAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2NtZC5oCisrKyBiL2RyaXZlcnMv
c3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaApAQCAtMjU0LDcgKzI1NCw5IEBAIHN0cnVjdCBoaWZf
aHRfdHhfcGFyYW1ldGVycyB7CiB9IF9fcGFja2VkOwogCiBzdHJ1Y3QgaGlmX3JlcV90eCB7Ci0J
X19sZTMyIHBhY2tldF9pZDsKKwkvLyBwYWNrZXRfaWQgaXMgbm90IGludGVycHJldGVkIGJ5IHRo
ZSBkZXZpY2UsIHNvIGl0IGlzIG5vdCBuZWNlc3NhcnkgdG8KKwkvLyBkZWNsYXJlIGl0IGxpdHRs
ZSBlbmRpYW4KKwl1MzIgICAgcGFja2V0X2lkOwogCXU4ICAgICBtYXhfdHhfcmF0ZTsKIAlzdHJ1
Y3QgaGlmX3F1ZXVlIHF1ZXVlX2lkOwogCXN0cnVjdCBoaWZfZGF0YV9mbGFncyBkYXRhX2ZsYWdz
OwpAQCAtMjgzLDcgKzI4NSw5IEBAIHN0cnVjdCBoaWZfdHhfcmVzdWx0X2ZsYWdzIHsKIAogc3Ry
dWN0IGhpZl9jbmZfdHggewogCV9fbGUzMiBzdGF0dXM7Ci0JX19sZTMyIHBhY2tldF9pZDsKKwkv
LyBwYWNrZXRfaWQgaXMgY29waWVkIGZyb20gc3RydWN0IGhpZl9yZXFfdHggd2l0aG91dCBiZWVu
IGludGVycHJldGVkCisJLy8gYnkgdGhlIGRldmljZSwgc28gaXQgaXMgbm90IG5lY2Vzc2FyeSB0
byBkZWNsYXJlIGl0IGxpdHRsZSBlbmRpYW4KKwl1MzIgICAgcGFja2V0X2lkOwogCXU4ICAgICB0
eGVkX3JhdGU7CiAJdTggICAgIGFja19mYWlsdXJlczsKIAlzdHJ1Y3QgaGlmX3R4X3Jlc3VsdF9m
bGFncyB0eF9yZXN1bHRfZmxhZ3M7Ci0tIAoyLjI2LjIKCg==
