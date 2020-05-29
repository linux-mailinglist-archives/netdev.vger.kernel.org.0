Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323A51E7CED
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 14:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgE2MQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 08:16:24 -0400
Received: from mail-co1nam11on2066.outbound.protection.outlook.com ([40.107.220.66]:32481
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726467AbgE2MQW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 08:16:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ojbcsufxtbn1d/eCL4rfY4tBdh1IfHYmn67suBSMrm/fBgvBfJTHr6KSVdxoebivmyHvV/eSjuyG1XJ85taf4FauU0XR5KjLu7bvbfIXyA+iDIgQve73SAz1JjUL2EQm9rkS3CSRdd8Ox4CXcZrvRVVolAH2QBaBBzBM/aq5aNe6tfik4l/90txYnDX8t0zIh9WZPvRmYy+Gjt27Lq1Qs11PK7LisOzOP64aQ+ospADPsEvqC2bvW3N7Nq67SJT01cA09QkWP8wuqzDyxL2WxQZq892ZeHvRM63Z00VzURKTMmOpr0GV5v591w68AiyWQNl4k68wwXAXulYJzVBJPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ncc4rr4btJgO8hnZufKIQBuXetY6zG5M1KWBLZTNeqA=;
 b=drDtDrTtI9V5mixvpC48wE88CxURUyyHBIw4blvfUcCG9G7dQtX0IX2JO2zSGTBwBiWpR5roaXzvrRt2Y66ss6zsGgnFTvD5iPcgOAl4v6DYq+7fqKaS1Ip+AtEraEOMjygWcDNz7x+mVEMApYFlrUT2W1fGFg79LrPwUNnssLCtuQ7HJ5Hd12b6OvcSgKQB7nIFWdNNLW13v2lkENHbkOfYzkDvDtu053v0LXOX+i9o4Eu0OKQW0tguGzTjbzsAJpkJI4OnZihfqK3SwSHYbcgPR43L47KahAL/Y5+2lAAIH90fL+1w6MHm11Bzo6l/LHzyf9+yLm1vrNWlFcU8Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ncc4rr4btJgO8hnZufKIQBuXetY6zG5M1KWBLZTNeqA=;
 b=dsSfl8Kpj6aHkJdSu6VcVxlN9WpehiMXQRqnVf7e40qVyaZjAfnxdGrUDEBO1DHErGFUCt0Iji+egF39J3QnuGropWKt9j9Eb+PQSoJKqcN6CTom0D5Yne4IXqCMjzyZv2GxbHwRev3g2kICEXGy2QF7rvfKQq9p6yDPZM6EQlU=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2781.namprd11.prod.outlook.com (2603:10b6:805:62::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 12:16:20 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336%7]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 12:16:19 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 2/2] staging: wfx: drop useless loop
Date:   Fri, 29 May 2020 14:16:03 +0200
Message-Id: <20200529121603.1050891-2-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529121603.1050891-1-Jerome.Pouiller@silabs.com>
References: <20200529121603.1050891-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM6PR06CA0051.namprd06.prod.outlook.com
 (2603:10b6:5:54::28) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM6PR06CA0051.namprd06.prod.outlook.com (2603:10b6:5:54::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19 via Frontend Transport; Fri, 29 May 2020 12:16:18 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80edc95c-0eea-42a6-45fb-08d803ca1822
X-MS-TrafficTypeDiagnostic: SN6PR11MB2781:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2781542E49561D38717674D4938F0@SN6PR11MB2781.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hT2korUCUsNxtROMM/jOqBihZOQqm0ylpa9vZazXhDaL17RMstvFFJmdUIWb2LA/5SMEk50n2UaMYjveXLPMu6uuiN/wjKY5KNAoirgdWkuTKfzwkJLmjHsyXBYLCfpg3KphbstzZgnHXTOTRakVzCFjWQM7pJW+XJEM5WZ9BwSEagq3DTpLnVoBPKCA75vqGQ05PettjIM2Nzz3wmiEJIje7PjmUAU+1cFHhtQllpzIh4fgvNHCggL5xzTBysyvZOP+6rfT/TXYVpIYGskAib+OIhm7ljZG2GYL6yGp75EOQVnh15m3bpqJt5I3MIE2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(346002)(39850400004)(366004)(376002)(478600001)(186003)(5660300002)(8936002)(7696005)(16526019)(52116002)(2616005)(8676002)(1076003)(86362001)(6486002)(66476007)(66556008)(66946007)(316002)(66574014)(83380400001)(6666004)(107886003)(54906003)(2906002)(4326008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6Z518fM5lZW0PY5+WkN9Nhw5JSoGM96tltzIBXB8mrzLgjepWVOHu8PZUW7PQXMmMPmMFvxgDBboAr7Pob/WBx3BsCSrZyH7g2S/wtloC/E2nlkj5uo7rjA1Wd8icYHZ7X0UXnZdi2AikxLXFOImyhFP5RzcfgFC67/ojnADTfqAQYS5Z488nTCE+0wi7dDup4OUYnbXsBjetvl0nrpJD13VzeCmiWPbU+XGDjjKJxMPFatmrBtoO+6o9N5eKYsRP57ddEqq1Fhmf7lZjBTz2X+1SJfPFSOXSRgbZLVymUiIYC7Lw35iZEe1sMjgknM82YlriXpIxsU1F2tV03eRorvRDE7zTboZfjc/hTb5C0cBfdn0Iol7vRXmCc6MEq+G6wgyHX1v+wGz3as3vDJFSX9WDsH7/FbsDqlCa2H6eI4pB2LFXWJe/Rc6k5ffnGNf8L67iMFHv43qCjBRMJHKZ08K8RxPeidpRgiTROfC2Jy41/0rfKYLWHbHPrMDUpvbuGM+DBXt8w8lf3pRB82m8E8iwKRuqOmTZlAHsveO+j8=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80edc95c-0eea-42a6-45fb-08d803ca1822
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 12:16:19.8780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NmgdZoO7XC6hCnmzzOWpDpoVmTR0Jw+0v+RgKKmpVECj4Sr8wiLOXqLMQAiENglcYqFFC9a4xx056l9v2xiDhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2781
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSXQg
aXMgZ3VhcmFudGVlIHRoYXQgdGhlIGxvb3Agd2lsbCBzdG9wIGF0IGZpcnN0IGl0ZXJhdGlvbi4g
U28gZHJvcCB0aGUKbG9vcC4KCkZpeGVzOiA2YmY0MThjNTBmOThhICgic3RhZ2luZzogd2Z4OiBj
aGFuZ2UgdGhlIHdheSB0byBjaG9vc2UgZnJhbWUgdG8gc2VuZCIpClNpZ25lZC1vZmYtYnk6IErD
qXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJz
L3N0YWdpbmcvd2Z4L3F1ZXVlLmMgfCAxOSArKysrKysrKy0tLS0tLS0tLS0tCiAxIGZpbGUgY2hh
bmdlZCwgOCBpbnNlcnRpb25zKCspLCAxMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMKaW5k
ZXggNzVkZjRhY2EyOWFjMy4uOTNlYTJiNzJmZWJkMCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9xdWV1ZS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYwpAQCAtMjkx
LDE1ICsyOTEsMTIgQEAgc3RydWN0IGhpZl9tc2cgKndmeF90eF9xdWV1ZXNfZ2V0KHN0cnVjdCB3
ZnhfZGV2ICp3ZGV2KQogCiAJaWYgKGF0b21pY19yZWFkKCZ3ZGV2LT50eF9sb2NrKSkKIAkJcmV0
dXJuIE5VTEw7Ci0KLQlmb3IgKDs7KSB7Ci0JCXNrYiA9IHdmeF90eF9xdWV1ZXNfZ2V0X3NrYih3
ZGV2KTsKLQkJaWYgKCFza2IpCi0JCQlyZXR1cm4gTlVMTDsKLQkJc2tiX3F1ZXVlX3RhaWwoJndk
ZXYtPnR4X3BlbmRpbmcsIHNrYik7Ci0JCXdha2VfdXAoJndkZXYtPnR4X2RlcXVldWUpOwotCQl0
eF9wcml2ID0gd2Z4X3NrYl90eF9wcml2KHNrYik7Ci0JCXR4X3ByaXYtPnhtaXRfdGltZXN0YW1w
ID0ga3RpbWVfZ2V0KCk7Ci0JCXJldHVybiAoc3RydWN0IGhpZl9tc2cgKilza2ItPmRhdGE7Ci0J
fQorCXNrYiA9IHdmeF90eF9xdWV1ZXNfZ2V0X3NrYih3ZGV2KTsKKwlpZiAoIXNrYikKKwkJcmV0
dXJuIE5VTEw7CisJc2tiX3F1ZXVlX3RhaWwoJndkZXYtPnR4X3BlbmRpbmcsIHNrYik7CisJd2Fr
ZV91cCgmd2Rldi0+dHhfZGVxdWV1ZSk7CisJdHhfcHJpdiA9IHdmeF9za2JfdHhfcHJpdihza2Ip
OworCXR4X3ByaXYtPnhtaXRfdGltZXN0YW1wID0ga3RpbWVfZ2V0KCk7CisJcmV0dXJuIChzdHJ1
Y3QgaGlmX21zZyAqKXNrYi0+ZGF0YTsKIH0KLS0gCjIuMjYuMgoK
