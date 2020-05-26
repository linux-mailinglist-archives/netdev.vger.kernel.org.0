Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023131E2853
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbgEZRSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:18:52 -0400
Received: from mail-bn8nam11on2083.outbound.protection.outlook.com ([40.107.236.83]:48578
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728581AbgEZRSt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 13:18:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/fVUOfaAYyGP67N8t9LwsYgeHiaLUOd8S1YO91Ks+9qniDqEEdnxe+Ed+6ptiHXi5VS+U0GL3d5GKBAc0ujuNFpKKAs0HMdbS47EUoS4SbtZxtfTteJcj3p16/c6pPA6/sYw1l+OPxJxYBLyC/uhMlwdqumylCy8b9selmyi74/yXriw/4l0eNDujw08gIP1krWA5h8MbX7PynfGz4jvjufXAQK0+vqHzUJTsDfaYroawKwA5nlWkOPkHpsuBpd/Xn0cxcZfk7KFUP0YdDPRMZ2M8/ttuchWxL1/qClDX3g/lCNuFaiYzs+FoZu0BiPrRCmVYjyf9/qSOHD3Wqm8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hXgidvw+Mz7TSwBqmvcHr3PzNIIvZQCjk1Ly0ofk6rU=;
 b=iJV3ULEQ3EjckzSSa65TJpJPJJ9NXZfOVkyMzt9ojRaGkIlBoJU+Zx2At6Gv1Bz0W5Jl+x3pHg+AKhJZhwR+oM6E5iMV2cXJ2m9j0Hur4c72dyfDf6izOfXJ4bOJ1e8Y6GeVWD/SwQqnNbE8Iyi20R+WBjoWvxVLNrbiM1JJfxD+eN+Iq4kT4OAF9HYOU8LkASpo9g0gOfklr4ti8sSiejYnBc0InkaYP8Ua72zEZu3HImmaWvg3YkhaH+k1ULNh+PEvzY+uFRPH4uL1hWfthRjNdHZVdJGy8Y+rLiOsATfTSPZnaJ+RfQPPZ/1L91CDV9k99GOa/+bMbvyE+PF2wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hXgidvw+Mz7TSwBqmvcHr3PzNIIvZQCjk1Ly0ofk6rU=;
 b=i25SRKtqqTYZKjgBWH4Z+d+o/4eY0hamn/ZK/Oc3bcZcPUwkKplRmlCUjCRZmJnojW9IUfBd1FwElSXd1yu8n/J6jukwXy6Vzc3/ARKR9vPDGIafH7T9nnfawBi06Am3GOdLcf0pWUP3g52VFitONyMgiORVS0XAtXMH9rm/sYM=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2750.namprd11.prod.outlook.com (2603:10b6:805:54::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.25; Tue, 26 May
 2020 17:18:44 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 17:18:44 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 02/10] staging: wfx: do not declare variables inside loops
Date:   Tue, 26 May 2020 19:18:13 +0200
Message-Id: <20200526171821.934581-3-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526171821.934581-1-Jerome.Pouiller@silabs.com>
References: <20200526171821.934581-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR1PR01CA0007.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::20) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR1PR01CA0007.eurprd01.prod.exchangelabs.com (2603:10a6:102::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Tue, 26 May 2020 17:18:42 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57bf857b-c6ad-4dfb-4a0c-08d80198d7ac
X-MS-TrafficTypeDiagnostic: SN6PR11MB2750:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB27504D480EB8CB0F5B92609493B00@SN6PR11MB2750.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rXHihTSqJShZmm9/Xpuc6WFdm9Md96uDFxnm9bEb6bCizHmmbcV56iMLhAft8e7YLZCTs6izLJHnQdiu7fsE0FYGhX55vRT51kwU+SGnlaJEdoSwj8bVLGnHF2KLBlK117cWlNjYdXejoNUHc8cbaBxrSq1FhMB2TbBeToYtsdwIzDyjsynISE1rnlaGE03iG6sRQPN4ZK7HMJCJEUZySC8A13PcMqKS73DXDHgShfe+cEgWlnRXlrtSIf72vwCLIFR6FHYwHzMjygGC9aYCwv5Zxwebv36QN4b4A1St+wle0wYCAsGISMXl1YqTPWm39G/mLaTKBhBNyH1SXGCRGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(376002)(366004)(39860400002)(136003)(346002)(4326008)(6512007)(316002)(8676002)(8936002)(2616005)(6486002)(2906002)(107886003)(1076003)(86362001)(6666004)(4744005)(186003)(16526019)(5660300002)(36756003)(54906003)(66556008)(478600001)(8886007)(6506007)(66946007)(66476007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: goLoIE31bZ2/c6NfW14prxmKv/4nc+578q5XVoJFtTROyOJtYD5B5x3ph8PYAvix/txF71T8NQkK89PGqCVfquH/fLYqXwpW13UP3IV0L98wvIq58noM/HU4cr0OaL4aEIBY6c8XC8bjHAFmmiQUegnf42UtgnGG/ocl/K/x4YIXOPzqZ4ju8hhy0ZBRjsj8dGwtIRFlFseJkXsT2CgYxFIp5DP0rQ2wQ3UV0YBjftmfUXWlRMhCRkNzJj74wsnAQYCTLVbu+C/aEo6aenMdCRkCFPUt8wt8zLo8jOMT0mJXtE447VQFffF9dt8lW6+BPpc2wfE98mzTc5bOQbVV4q3qEgODZeGeaP+F27F32LuPV70+tpDFRuX44az2NwIC1iTTVG5e+9ggxKlTaCbRhFANrskoFdzDhfQBQOvSWD+hCd/CVrYgAoLJ6e6HdshLMcnmsraAvPsseBsAdF/1YOm9/Y1PYV9gsCOrj1EJ7MH5bjw4BSxtsFU0Ldj/8yXs/bJ7H0cxfrRdr1jCPfYCUImVXhodXH+XblCAVCgWg1U=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57bf857b-c6ad-4dfb-4a0c-08d80198d7ac
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 17:18:44.0772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vOzqGX1mQmYwNcN5zBLqgcz1ze2BjTfUBD9amBojjyhIwdRdfAyW/CcZnATcoWtVAOl2n9twzW85WkSKHisFJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2750
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGxvY2FsIHZhcmlhYmxlcyBzaG91bGQgYmUgZGVjbGFyZWQgYXQgYmVnaW5uaW5nIG9mIHRoZSBm
dW5jdGlvbnMuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWls
bGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMgfCA2ICsr
LS0tLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYyBiL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvZGF0YV90eC5jCmluZGV4IGE5ZWRkZDZkYjJiNWQuLmYwNDJlZjM2YjQwOGUgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvZGF0YV90eC5jCkBAIC00MiwxNSArNDIsMTMgQEAgc3RhdGljIGludCB3ZnhfZ2V0X2h3
X3JhdGUoc3RydWN0IHdmeF9kZXYgKndkZXYsCiBzdGF0aWMgdm9pZCB3ZnhfdHhfcG9saWN5X2J1
aWxkKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBzdHJ1Y3QgdHhfcG9saWN5ICpwb2xpY3ksCiAJCQkJ
c3RydWN0IGllZWU4MDIxMV90eF9yYXRlICpyYXRlcykKIHsKLQlpbnQgaTsKIAlzdHJ1Y3Qgd2Z4
X2RldiAqd2RldiA9IHd2aWYtPndkZXY7CisJaW50IGksIHJhdGVpZDsKKwl1OCBjb3VudDsKIAog
CVdBUk4ocmF0ZXNbMF0uaWR4IDwgMCwgImludmFsaWQgcmF0ZSBwb2xpY3kiKTsKIAltZW1zZXQo
cG9saWN5LCAwLCBzaXplb2YoKnBvbGljeSkpOwogCWZvciAoaSA9IDA7IGkgPCBJRUVFODAyMTFf
VFhfTUFYX1JBVEVTOyArK2kpIHsKLQkJaW50IHJhdGVpZDsKLQkJdTggY291bnQ7Ci0KIAkJaWYg
KHJhdGVzW2ldLmlkeCA8IDApCiAJCQlicmVhazsKIAkJV0FSTl9PTihyYXRlc1tpXS5jb3VudCA+
IDE1KTsKLS0gCjIuMjYuMgoK
