Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D608019F46D
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 13:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgDFLTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 07:19:11 -0400
Received: from mail-eopbgr690076.outbound.protection.outlook.com ([40.107.69.76]:20110
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726873AbgDFLS4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 07:18:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQv7aJVxoI6LjWYBHMVcVfrO/O6hg2vgVr8IgWcy+m5LOAwGoeRm/SxFe/yUdLJ9k9OrmzESNZQQEgAUVH6a6wvnXjapg2sdywggTYV7Ko4EB3ZV2hJCHwZzUpBEMbBiv3ixfzIQBhYuIsGubU6LW9m+DovRjZl3HTGz1Drd7NaEJgmgCwVFY81nipA3KMqLdkQizLLJ7stnlQf5M94alDIzl7F5bLiFEoT7yE1Va/W34xCV98OeLaB6bYGq3uGq/IpTZSBYucDc2wLehfv/ABPfGXdXHI3a6yzRwsU1fGodGHQ6aRjs4fUyoO5R1No+fmaQog0IA58Nb5U4w87NiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCfg3DeG9nVcwyxoXOblYQwsAn9E/l2Q6VO1zJZcd4w=;
 b=Ce2QKLojCSadVJidtt6GyHAZulYQMq2HtyKXuzUQguNad+8lKLavr9dpPyH363VpycAgx3qPRARuZeoPN3xpJUdDgXbNZuNovLnMjWS+YzkFYJd8tC3an8OwgbztkJ7bNiQh9IcYnd5jjavRhnfo7IMAXgAbk5DDaPBu5fbgB3mrcv9RwJWbXOwSgG9UchLTxxsO3YmAdsLuo7+BkZLX9HKonc6IUbmxhzLDOm+QhPPCKb7NmJsoRHGQtXot+apzrQi/5ebL5mLTWWG8FUlwL7F5qynwhH5oCyREfeUccIw40tr2DZtxD+qQ6fRys95EMALnIIYA3DTQhz6ycY6XXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCfg3DeG9nVcwyxoXOblYQwsAn9E/l2Q6VO1zJZcd4w=;
 b=E6AzDXSN93xRlIP4LA8/3AxY34vp60Jsy+xhDPN4dX5ovA4txTy/htLDWscqqKwMRysLugImoWAly5zdSNys/iBKW1vHFC0SzASTG4U5KLMLKomj8eXFxYUovj0dmfweqnaO3t5Ti+p0Ab5oTT3iRJVEutf36AuMF0bE51s4Zts=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from BN6PR11MB4052.namprd11.prod.outlook.com (2603:10b6:405:7a::37)
 by BN6PR11MB3860.namprd11.prod.outlook.com (2603:10b6:405:77::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15; Mon, 6 Apr
 2020 11:18:13 +0000
Received: from BN6PR11MB4052.namprd11.prod.outlook.com
 ([fe80::e0af:e9de:ffce:7376]) by BN6PR11MB4052.namprd11.prod.outlook.com
 ([fe80::e0af:e9de:ffce:7376%3]) with mapi id 15.20.2878.018; Mon, 6 Apr 2020
 11:18:13 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 00/11] staging: wfx: clean up HIF API
Date:   Mon,  6 Apr 2020 13:17:45 +0200
Message-Id: <20200406111756.154086-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:3:d4::20) To BN6PR11MB4052.namprd11.prod.outlook.com
 (2603:10b6:405:7a::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM5PR05CA0010.namprd05.prod.outlook.com (2603:10b6:3:d4::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.13 via Frontend Transport; Mon, 6 Apr 2020 11:18:11 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6e2bc58-1cf5-41e3-71ea-08d7da1c321a
X-MS-TrafficTypeDiagnostic: BN6PR11MB3860:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR11MB38602A2E895F8D18385A91A693C20@BN6PR11MB3860.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-Forefront-PRVS: 0365C0E14B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4052.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(396003)(39850400004)(346002)(366004)(136003)(376002)(186003)(16526019)(7696005)(52116002)(36756003)(5660300002)(107886003)(316002)(54906003)(66946007)(66476007)(4326008)(2616005)(66556008)(1076003)(66574012)(81166006)(6666004)(6486002)(8936002)(2906002)(86362001)(81156014)(8676002)(478600001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dnu3Doaw4wceTVYieOvg19ClMhb2sb2P04SepSzpM6CHmtO7O4TbbZMbN1YaiuUgNNZWuQCymHtBfxW9h/zDK4ZTVWvGPD9GL5/wPuXLJE2mqPqeRabNxtkTc+hMdmqpCDKrSTVO+nfNmoQ/SnqYGDiHu+M8beIC48Bss2JOjjjLc+FKEMtFXMTT9ElUEWpv7skkDhNKqlBitkd+pmA+dCBxFtFFvoEOHCU/3F+6G7xz8R+/4U8WWwzSxE3SG41IVAiaU6SSNSAaDvFT+7HkHeObi+au1JyTolBehAZS8HzfhMaDpH3ye5uGPHJ0uiyvU4bXPrdFniAnA2YTglHrdAKfRSA77OU9qL3CKbWXzlolx2q4QNVkf+kBrOB0ngjwk2agd4CcK4zuxVv+WjTxlj7mF7fm51EcJLt69Q9ZxCMuepZ64RusghADRbQ+WrrQ
X-MS-Exchange-AntiSpam-MessageData: 9fB274sGGN8tVHqcPC25WqntnvTJggXjcNBTYbuL0jqHkhHE9FjQkSrcnUa86890hrkyjvdUlXrrTA6SNlEhZulCv2/GKEVF+83ArLkAJm2rQmyq0dZHPuOvg8vb0vESaH6JL7pAB3+r/FrLU4l9eGDy6y/hWq0RPMkRdlLvQV2r1On898iNfS4ysykj/viAxTBLH5myH0Y4SW1jcTzpuA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6e2bc58-1cf5-41e3-71ea-08d7da1c321a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2020 11:18:13.6154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ptHsPmEyn+PAR5l4M6LbIVnBW7VpKKnYXzvsPO0PR9epHXOGycO4b9ON0Rowb2o9VhAD0NKThkotagaz/jTqiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3860
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSGVs
bG8gYWxsLAoKVGhpcyBzZXJpZXMgdHJ5IHRvIGNsZWFuIHVwIHRoZSBIYXJkd2FyZSBJbnRlckZh
Y2UgKEhJRikgQVBJIG9mIHRoZQp3ZnggZHJpdmVyLgoKTm90aWNlIGl0IGludGVuZGVkIHRvIGJl
IGFwcGxpZWQgb24gdG9wIG9mIFB1bGwtUmVxdWVzdCBuYW1lZAoic3RhZ2luZzogd2Z4OiByZXdv
cmsgdGhlIFR4IHF1ZXVlIi4KCkrDqXLDtG1lIFBvdWlsbGVyICgxMSk6CiAgc3RhZ2luZzogd2Z4
OiBkcm9wIHVudXNlZCBXRlhfTElOS19JRF9HQ19USU1FT1VUCiAgc3RhZ2luZzogd2Z4OiByZWxv
Y2F0ZSBMSU5LX0lEX05PX0FTU09DIGFuZCBNQVhfU1RBX0lOX0FQX01PREUgdG8gaGlmCiAgICBB
UEkKICBzdGFnaW5nOiB3Zng6IHJlbG9jYXRlIFRYX1JFVFJZX1BPTElDWV9NQVggYW5kIFRYX1JF
VFJZX1BPTElDWV9JTlZBTElECiAgICB0byBoaWYgQVBJCiAgc3RhZ2luZzogd2Z4OiByZW1vdmUg
dW51c2VkIGRlZmluaXRpb25zIGZyb20gdGhlIGhpZiBBUEkKICBzdGFnaW5nOiB3Zng6IHJlbW92
ZSB1c2VsZXNzIGRlZmluZXMKICBzdGFnaW5nOiB3Zng6IGZpeCBlbmRpYW5uZXNzIG9mIGhpZiBB
UEkKICBzdGFnaW5nOiB3Zng6IGFsaWduIG1lbWJlcnMgZGVjbGFyYXRpb25zIGluIGhpZiBBUEkK
ICBzdGFnaW5nOiB3Zng6IHBsYWNlIGhpZl90eF9taWIgZnVuY3Rpb25zIGludG8gYSAuYyBmaWxl
CiAgc3RhZ2luZzogd2Z4OiBhbGxvdyB0byBjb25uZWN0IGFuIElCU1Mgd2l0aCBhbiBleGlzdGlu
ZyBTU0lECiAgc3RhZ2luZzogd2Z4OiBtYWtlIGhpZl9pZV90YWJsZV9lbnRyeSBjb25zdAogIHN0
YWdpbmc6IHdmeDogc2VuZCBqdXN0IG5lY2Vzc2FyeSBieXRlcwoKIGRyaXZlcnMvc3RhZ2luZy93
ZngvTWFrZWZpbGUgICAgICAgICAgfCAgIDEgKwogZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4
LmMgICAgICAgICB8ICAyMCArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmggICAgICAg
ICB8ICAgMiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2NtZC5oICAgICB8IDYyNSAr
KysrKysrKysrKystLS0tLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9nZW5l
cmFsLmggfCA0MjkgKysrKysrKy0tLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBp
X21pYi5oICAgICB8IDY3MSArKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLQogZHJpdmVycy9zdGFn
aW5nL3dmeC9oaWZfdHguYyAgICAgICAgICB8ICAgMiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9o
aWZfdHhfbWliLmMgICAgICB8IDM5NyArKysrKysrKysrKysrKysKIGRyaXZlcnMvc3RhZ2luZy93
ZngvaGlmX3R4X21pYi5oICAgICAgfCA0MzUgKystLS0tLS0tLS0tLS0tLS0KIGRyaXZlcnMvc3Rh
Z2luZy93Zngva2V5LmMgICAgICAgICAgICAgfCAgIDEgKwogZHJpdmVycy9zdGFnaW5nL3dmeC9t
YWluLmMgICAgICAgICAgICB8ICAgMiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oICAg
ICAgICAgICB8ICAgMyAtCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICAgICAgICAgICAgIHwg
ICA1ICstCiAxMyBmaWxlcyBjaGFuZ2VkLCAxMTg1IGluc2VydGlvbnMoKyksIDE0MDggZGVsZXRp
b25zKC0pCiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWli
LmMKCi0tIAoyLjI1LjEKCg==
