Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3274C644C
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 09:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbiB1IFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 03:05:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiB1IFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 03:05:34 -0500
Received: from APC01-HK2-obe.outbound.protection.outlook.com (mail-eopbgr1300093.outbound.protection.outlook.com [40.107.130.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A629153B41;
        Mon, 28 Feb 2022 00:04:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K2QGttyDJxlhAT5TiVT73nTHkl78dZBRqnVVyz0v23LLil0SsoPpqA4WMqZiD0CYtX63/bZTTwKH0vYiaztjAXAGi6b3H4QJDlKLCmPO+tKpCMKhim3TLz5MoBtKL4VEawVFy7blBfBgYt1Xq99FW/Jnw2vPSjS/qMe7l2K/093gyIq3rZ8JU/0w+2Dz0mvB+azaaC8F7YJaSk60rB/xp1+A0mnODRX25FvcDL+YiFx/Kr5k9JoAJkyXsaIlq59j4NZ3+JVaJIdPZ636XHWZU9ThQJ8O+xqUF9I6CPNCdbvwHLbrm8UZG4Z45bOmN6JDkat9IeilFzBm0aTqrWF0Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9YI7WCiNbsRtSYf/fQVhygZxOoLR7O4di0+j4EqPOW0=;
 b=fx1jxC2F2wzd7di2j4SwTooRIEJYmQZFyZN6Qofq0Uzm+LiwczlYfJg7j+rELVtreoCvVyqG5Br7iBRBHdQB/zrxsLbV92sJotFDlkT/JX5YLpMHWfq3ZFtnYPNB4kXALZ8JSHjRDl3PdBDjnCgiyqfVzsxJ9azpWj/5/iXjOA6iyA5RnwYsyVAS+rdvw3yZgLXMMqxBs0aR5UYShO4bV/VyC1H+G0oS3INunEI8zJO3O+ccqkqoD9jLzqrxilkye8KXe4IZXTMwKesKfkOBKDlJ0VFd4yuBT73f0BtZOA2Wc3qKnfNS/zr9diDjUuAxrl6tVU2MAkukLEq0k5/hBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9YI7WCiNbsRtSYf/fQVhygZxOoLR7O4di0+j4EqPOW0=;
 b=M/+wqwrdAOwN+jJrg1atifk7P0pcM2FlXQFu/zXNTLsergBlQyI4wqEOsVhHoxV0VupOv8bhHfMhGIc2SwM+cMleJQN1AtB2F48A3elGdOXylyIyePT9jNb+WtZPVIIWGgAKFQ7lkr6YlEXGFQFSgvSgKffER1acHkKp4Np6FnY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 PS1PR0601MB3658.apcprd06.prod.outlook.com (2603:1096:300:78::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 08:04:48 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::9d3f:ff3b:1948:d732]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::9d3f:ff3b:1948:d732%4]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 08:04:47 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     jiabing.wan@qq.com, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] bpf, docs: add a missing colon in verifier.rst
Date:   Mon, 28 Feb 2022 16:04:16 +0800
Message-Id: <20220228080416.1689327-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0156.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::36) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce515081-621f-45cc-8f0d-08d9fa90fc75
X-MS-TrafficTypeDiagnostic: PS1PR0601MB3658:EE_
X-Microsoft-Antispam-PRVS: <PS1PR0601MB3658FCEB4ABE66A87DC6D4EEAB019@PS1PR0601MB3658.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sGx7RK33riBhY2dK7wiiMyjGLv7FjNOJDhJzAuUGnm1e14lngTQkIHZU3OhiJM/7PIFzol0P7UaBUvqsHDDg3TV2o2U9HgpI55bLvMyQITWg95yn8dGo/WDA2/3gXunva3xi8fspO2ehsV3ARWarAT0NqBOHzsSeE6k0eORpZUvfbwx4jVBuJOnMfnFlg2to1dc8oP4ueHx0CxUqPSKEf0m0/L2oW8Nt4bv/iHyx30aJhpFdX8Jv3OC0JJQeMLLKL+UNf9oOOLm+BdT2rIfNV891NV79wRuU5oX2fzDac0MXOO+FJj0C/r+F9+sWT4LBEn4lMHhpLLdwsvCGrKU6I6oc2PTDshvA5egKyfwBe7CAoSB7KpTSwyORVR5IuQYvMehU3Z9kIvvwHWQsT76evu6mZCOLgFo+TxUIeVw9xahT7snSUawvAjGLXqIbn4C4kBSMOtLNp+9ObdFCUpQSyeypEHpVhSw1Dm0pS5cL+C+cqkCBwF/KWBWDyVb2NsN7B4q3C+O5+Xzlm0oDCF6ZZDAa7/2za1b0+WCHtgN8aPO/5yQrNAzN9KlvfnK4UjcaGwlCiyJIvEmXYfKAyQGmOzLPQQEFws0K7kRp1wXjVKNenNuNHe1Q48ElqdZdfyphRsej1e8x+kJaJ2o/pezdqHXwDYpl29hKhAdEB/hQLcXviY8YxjydYJvX0qx8j8BGZA+MWvA85ccLd8b5FVj7r3+dtdlL0oMHdPV5KyZqm4M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(110136005)(38100700002)(6506007)(186003)(26005)(316002)(5660300002)(6666004)(38350700002)(508600001)(7416002)(2906002)(36756003)(1076003)(107886003)(83380400001)(921005)(6512007)(8936002)(2616005)(4744005)(6486002)(8676002)(66946007)(66556008)(86362001)(4326008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e8QKb/IhECQ6NTUh39KlC9Xt+UnEy8EvwHpSYT9A0Fl4YMYfJ/qDLH3fjDTp?=
 =?us-ascii?Q?mbQznJRpkakm1abFSVsGDxQyfCSD98paPwWSiKuZFFv0ffthlNZFOfrkInSO?=
 =?us-ascii?Q?V2wN91rpyX2kI7arVjGOWQJpXOtI2hG6ZvLE4UpLusPPZB6iorqqbcKuPQDn?=
 =?us-ascii?Q?G4wWlGqv3t4R0eq6kqoO75usta49ASZEehFmYUtoV26FzusIK57wSInYWWU5?=
 =?us-ascii?Q?Gr5SlWvk/h1TROZyL/7XRp9ZL/ZGMnby7A/P1nEWkDA4zNkeWbArrRNxtelU?=
 =?us-ascii?Q?+cUuFFnxnXb/34PFhQFHWPP9qbqO1bh0C71K4mZH0TJ8Jt5LYEZsqony7E+9?=
 =?us-ascii?Q?8hGu1YNhToYvRcS1TUYtGVHkdF9++lBEbShGWZCg0/YOw26SswGk9kPZ1Au3?=
 =?us-ascii?Q?RxJUvFGYdWDwJWb791mrvSFRWnGmxS/I5jEWGxa9ajOvvmmRQS0DdFpdnMHU?=
 =?us-ascii?Q?TreIm5n6B92cuWDQ4UBoA8dDO+e9CoodFvThKysWY4iJkBMLv1c1NrZw5QCH?=
 =?us-ascii?Q?mRzrcDrzzGzuJiDHqK1y7VJ2yzkpYCEOEFvs+Y5OXhcQaoj4k5BlSaIPNxPY?=
 =?us-ascii?Q?SRV908UdPxFpo/dmG899/Z7NysBYlhDBcntjJ/tNs3tvlTAeqhqSL5Q+fOfv?=
 =?us-ascii?Q?rMAOdQPYnaIyWctRYWEw5blYMP2awoQrW5IjcWFtxl1w3/ov4Ei1c2DCcBK8?=
 =?us-ascii?Q?WdCpdR6SVnXylP5pUv0DKRL4P2tuxnAP6995H34Sra3VmAiar2w+GrSLYKQk?=
 =?us-ascii?Q?BYtsJ9kczlCkOjdpME2CXCJvqjpIzZDRgJTAeEZqZIEmYUzZqb7hpMhPqyyp?=
 =?us-ascii?Q?6jD1JWN+DvB7TzWe6hSrWTRihocj/K5s9H8+ECUVwt+JL6PuM03QeUDWzGRK?=
 =?us-ascii?Q?wuwt4CppFOznIeqmUZBSNn8cGnVpbCIw4tSRo71ITAUV8/Rs+QyPSThdEqwR?=
 =?us-ascii?Q?Wxt84/4841LNJT5ZQxy0DjaozO2XE6+rfkmXq3h4bjKQYrb1Tamo2b3ssSjE?=
 =?us-ascii?Q?heo+zeDAOqEyIMjBO6GP5ax6+TNljJR0pnusprDB+7jPqlSUYzsH8tg8txFC?=
 =?us-ascii?Q?xKSj664zKgFBjnM89sY3s4twkzERAjAcTKePSxwcbdnAw64T0vcAotF5qAXt?=
 =?us-ascii?Q?Iczv91WJHt24FbJbFqUdz0wdW0Tp7KWQoXCZdzNXyDgRztGc2vzr4hnkPHQy?=
 =?us-ascii?Q?mbwmGPq9A2UhufWiXYNFdsZI5NvcgKKo0sKLnC2O1p+rvf83mdZ4RTnFi432?=
 =?us-ascii?Q?DYUi45OaT8NslrZsqkc9u+DMFZ4oLc2L3vMnvKtgrV7EIJ+JMtl4TWBbcbw2?=
 =?us-ascii?Q?C15pvaQIWnLgvnivBwrfnVLGzzbqk6s65dEuJEJ0iln0QPGiq4lzJJvIpvek?=
 =?us-ascii?Q?Ib85k47t83M1zeUqI9bngIGqUQmzphHwRIXwXp90JKDT4nP4r4oiPgfIFIj/?=
 =?us-ascii?Q?0tDoM2PvwciH2Z1MJK2mEqZJqKC7opS/07q2OrXduhp3v9nBBre4mUWBE6pf?=
 =?us-ascii?Q?nGu22MH4cBI0pC43oXiiMIoB1Uvo7C2pW3HgRK3DhMHKGLDpw082uZbDB6aS?=
 =?us-ascii?Q?/w3liofB2d56t7rJXKcqsmsRszVyhQ/etG9GtxHvQyzv943lGqCdWpNssaX5?=
 =?us-ascii?Q?eY6dlm8PhPx0c8DJyqnGZnM=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce515081-621f-45cc-8f0d-08d9fa90fc75
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 08:04:46.9620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lK13IF+SwuiBfqeedAU3QvJkY2v410oqqXzx1MyxYfxDp6dNLmkoCO/tL2nJmp3kDFxyFbR16etSQcmbt6w20Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS1PR0601MB3658
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a missing colon to fix the document style.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 Documentation/bpf/verifier.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/bpf/verifier.rst b/Documentation/bpf/verifier.rst
index fae5f6273bac..d4326caf01f9 100644
--- a/Documentation/bpf/verifier.rst
+++ b/Documentation/bpf/verifier.rst
@@ -329,7 +329,7 @@ Program with unreachable instructions::
   BPF_EXIT_INSN(),
   };
 
-Error:
+Error::
 
   unreachable insn 1
 
-- 
2.35.1

