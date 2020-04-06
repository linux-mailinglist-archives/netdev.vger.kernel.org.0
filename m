Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1665919F459
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 13:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgDFLS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 07:18:57 -0400
Received: from mail-dm6nam11on2071.outbound.protection.outlook.com ([40.107.223.71]:6126
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727913AbgDFLS4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 07:18:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C3aN1hmtQoIhqPsbAEedR1sawE3hJWmc1d/vdDTKf9aMzht/PDExYMC91ZzsgMkLvTjXeXtc+KoXGdh0TV7hj6m9B0QkAcTqxw2J/ZPsfDVvB9y0Zc9cTDfy07R+jMFnmp9KTdtJmJBJWZnMo6B+poyUGWlXb++07lOoRVghglhSBUqYpplROF1A2V4cK4np4nKzRnbOQNxXB1o24XGAalxAdSxJhXIRvENcAUdOB32ZVTbPCEEvfIv9BkdrpykVEDE3NzQUvE19L4iXtUr2luzSPS7oig+ledFUXmnbKV7kNZmRGDWDNz5o7uI0V2EofxP6pi7n6nPuYCYQpxbjAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=elWSuYBOgwonggNoaNuodrNnEMLkPTpW8aEoCYGVEdo=;
 b=R3zRWLvmTZL9eIrq0Ruv8OQNoWgSqARXOfTv0hQuqZNqw0+yBJSbzZIYflbnKAfFSH4YWXr9ujWG4NErco3achFArXwafOptAsslj8hOLMDckOdLd675avcGlhMI4IwHZYcEFSH3K6oBVyWXdQfvuMi7ExsMayjb8PHx1Vv0NF0L5pReDiyqIPJ/BuRxS7l8jLbUqxURpG2ctIMk1K1UXMhPH45bKJoVWCq7Yc279P8pV8LHM1o9RCqK0i5DkCJ80rGiy5BSRnXt0/Jk3Noo5Z3wsh2kZX2t4T+lQhh+oOlrGv8I00VcCj5h4i6lMYkEId055W8YGhSJx6svvIRf8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=elWSuYBOgwonggNoaNuodrNnEMLkPTpW8aEoCYGVEdo=;
 b=LOuD2gmVcfcVpGGlJD7imMn3cQYOFquySkS/rFbLG8qWitU63+PeSuUmZ6W2076K51kzcQz4ycKteIcWO9e/EONeIbG3368reKCzDFjeQQ4pK9XRmRcZ8p4EwbbTbP5eBvfjcWLPN45wbuPE3CbpmaN1rH4/c053QNUqigQiy00=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from BN6PR11MB4052.namprd11.prod.outlook.com (2603:10b6:405:7a::37)
 by BN6PR11MB3860.namprd11.prod.outlook.com (2603:10b6:405:77::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15; Mon, 6 Apr
 2020 11:18:34 +0000
Received: from BN6PR11MB4052.namprd11.prod.outlook.com
 ([fe80::e0af:e9de:ffce:7376]) by BN6PR11MB4052.namprd11.prod.outlook.com
 ([fe80::e0af:e9de:ffce:7376%3]) with mapi id 15.20.2878.018; Mon, 6 Apr 2020
 11:18:34 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 10/11] staging: wfx: make hif_ie_table_entry const
Date:   Mon,  6 Apr 2020 13:17:55 +0200
Message-Id: <20200406111756.154086-11-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM5PR05CA0010.namprd05.prod.outlook.com (2603:10b6:3:d4::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.13 via Frontend Transport; Mon, 6 Apr 2020 11:18:32 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d13fdabe-3178-4e5b-de34-08d7da1c3ec0
X-MS-TrafficTypeDiagnostic: BN6PR11MB3860:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR11MB386031843A355EB8D8AD4BA993C20@BN6PR11MB3860.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:449;
X-Forefront-PRVS: 0365C0E14B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4052.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(396003)(39850400004)(346002)(366004)(136003)(376002)(186003)(16526019)(7696005)(52116002)(36756003)(5660300002)(107886003)(316002)(54906003)(66946007)(66476007)(4326008)(2616005)(66556008)(1076003)(66574012)(81166006)(6666004)(6486002)(8936002)(2906002)(86362001)(81156014)(8676002)(478600001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 315xKUnHMHJOVze15UgM4RVO37eOddj2IaIeYoXlGcePTcsVvoB/8FLQlY2XgpDyE+eDhfGhtS82Ny9mJrs/lCFebjmkeqh/aEbHr3tLUAj1RWFmGXqVFjz/g9XYwuHhZucktOlU4iAfIgdpShOeHmoKcYJPStT5rTMYZXL3HpEIL4YGksgKUsmG4M9xGVdl6HSpNrncRgWpuhS/+CaaYmmyOd7RRzAoZvEOHUOCBOiBwzC4/801LZC5vdCP8FtxDOPal8ZJ8HxLgX0mbWO1VK7S1/8i8K5+P/WuRmb1FpguFBM3dO5Xc9xMTkFsF8isG1Bx0NWvGaFGFvoj3nK5ZzGfrhvlEyDFEI7ib++p9hbqtrzEs7CDqku+AmPqULUp8ZdXPBhCLBWaqybc94vV7hclcDyYljKchciC0h+/ina/ZVeon6wChgmlQCVZeupS
X-MS-Exchange-AntiSpam-MessageData: zDQWJ+RLSxSo9LpogKEVPsFqh9FdNp5f5dqor+gTO2l+UreebpkE1QI2YIF+a2K6aGiwKITBkoX0vTZIgpsk9ohUK9SYCvWsf6HZyNUCn2/srgSqg6MoFAJZxTGDrGPr3WXY/D30Kk8I/pDeczV+6EDVbOSz0icA+P1KFaCmNHkKr3NZzDsPqSJIdvbVCVyRMO4VBxGfFtjx7lbjatsrcQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d13fdabe-3178-4e5b-de34-08d7da1c3ec0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2020 11:18:34.5949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fB35TiumVJRehIa9Miof3aCvUtWzt5hrYjnw1G3KIERx6xgnH8EE2Z4ESKPzJXzjXHwjFYUJc9MXCjTp0+RF0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3860
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW4g
d2Z4X3VwZGF0ZV9maWx0ZXJpbmcoKSwgZmlsdGVyX2llcyBpcyBuZXZlciBtb2RpZmllZC4gU28s
IG1ha2UgaXQKY29uc3RhbnQuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVy
b21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhf
bWliLmMgfCA0ICsrLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oIHwgNCArKy0t
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICAgICAgICB8IDIgKy0KIDMgZmlsZXMgY2hhbmdl
ZCwgNSBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c3RhZ2luZy93ZngvaGlmX3R4X21pYi5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWli
LmMKaW5kZXggNWJjYTFlMDY5OTVmLi5hYzUzNDQwNjE0NGMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
c3RhZ2luZy93ZngvaGlmX3R4X21pYi5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4
X21pYi5jCkBAIC0xMDIsOCArMTAyLDggQEAgaW50IGhpZl9zZXRfcnhfZmlsdGVyKHN0cnVjdCB3
ZnhfdmlmICp3dmlmLAogCQkJICAgICAmdmFsLCBzaXplb2YodmFsKSk7CiB9CiAKLWludCBoaWZf
c2V0X2JlYWNvbl9maWx0ZXJfdGFibGUoc3RydWN0IHdmeF92aWYgKnd2aWYsCi0JCQkJaW50IHRi
bF9sZW4sIHN0cnVjdCBoaWZfaWVfdGFibGVfZW50cnkgKnRibCkKK2ludCBoaWZfc2V0X2JlYWNv
bl9maWx0ZXJfdGFibGUoc3RydWN0IHdmeF92aWYgKnd2aWYsIGludCB0YmxfbGVuLAorCQkJCWNv
bnN0IHN0cnVjdCBoaWZfaWVfdGFibGVfZW50cnkgKnRibCkKIHsKIAlpbnQgcmV0OwogCXN0cnVj
dCBoaWZfbWliX2Jjbl9maWx0ZXJfdGFibGUgKnZhbDsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3Rh
Z2luZy93ZngvaGlmX3R4X21pYi5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmgK
aW5kZXggNzdkZWRkYTA0NjVlLi4wZjhiM2JkOWYxNGUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3Rh
Z2luZy93ZngvaGlmX3R4X21pYi5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21p
Yi5oCkBAIC0yNSw4ICsyNSw4IEBAIGludCBoaWZfZ2V0X2NvdW50ZXJzX3RhYmxlKHN0cnVjdCB3
ZnhfZGV2ICp3ZGV2LAogaW50IGhpZl9zZXRfbWFjYWRkcihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwg
dTggKm1hYyk7CiBpbnQgaGlmX3NldF9yeF9maWx0ZXIoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJ
CSAgICAgIGJvb2wgZmlsdGVyX2Jzc2lkLCBib29sIGZ3ZF9wcm9iZV9yZXEpOwotaW50IGhpZl9z
ZXRfYmVhY29uX2ZpbHRlcl90YWJsZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKLQkJCQlpbnQgdGJs
X2xlbiwgc3RydWN0IGhpZl9pZV90YWJsZV9lbnRyeSAqdGJsKTsKK2ludCBoaWZfc2V0X2JlYWNv
bl9maWx0ZXJfdGFibGUoc3RydWN0IHdmeF92aWYgKnd2aWYsIGludCB0YmxfbGVuLAorCQkJCWNv
bnN0IHN0cnVjdCBoaWZfaWVfdGFibGVfZW50cnkgKnRibCk7CiBpbnQgaGlmX2JlYWNvbl9maWx0
ZXJfY29udHJvbChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAkJCSAgICAgIGludCBlbmFibGUsIGlu
dCBiZWFjb25fY291bnQpOwogaW50IGhpZl9zZXRfb3BlcmF0aW9uYWxfbW9kZShzdHJ1Y3Qgd2Z4
X2RldiAqd2RldiwgZW51bSBoaWZfb3BfcG93ZXJfbW9kZSBtb2RlKTsKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4
IGMyNTBiMTE3YTEzOC4uNGQ1ZGJmYzI0ZjUyIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTE0OCw3ICsxNDgs
NyBAQCB2b2lkIHdmeF91cGRhdGVfZmlsdGVyaW5nKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQogCWlu
dCBiZl9lbmFibGU7CiAJaW50IGJmX2NvdW50OwogCWludCBuX2ZpbHRlcl9pZXM7Ci0Jc3RydWN0
IGhpZl9pZV90YWJsZV9lbnRyeSBmaWx0ZXJfaWVzW10gPSB7CisJY29uc3Qgc3RydWN0IGhpZl9p
ZV90YWJsZV9lbnRyeSBmaWx0ZXJfaWVzW10gPSB7CiAJCXsKIAkJCS5pZV9pZCAgICAgICAgPSBX
TEFOX0VJRF9WRU5ET1JfU1BFQ0lGSUMsCiAJCQkuaGFzX2NoYW5nZWQgID0gMSwKLS0gCjIuMjUu
MQoK
