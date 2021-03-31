Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F50F3504D4
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 18:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234169AbhCaQla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 12:41:30 -0400
Received: from mail-mw2nam12on2073.outbound.protection.outlook.com ([40.107.244.73]:61921
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233914AbhCaQlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 12:41:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SJfoDPZfA0MR9z9uQlfjdB0ieuHXIwBP9Kn6a+v0RdKla0F0t4fcNfIfzA6YfJXUPLFqDV+5PrOuOw3OsOp4t3X+uSN6LPFgN8nV3wrDQBVQHr+mcOxBcrTIJgBYpvOagyaotlzXuhE4jNk5KfhGd1NRf+oeBh8nqXDX3sbC3tR2UX3EdiPW+Y6P1v7VmWaS5I14b9QcROsyTV6HPvl1RX4Yw8sHC18fg5NCSCtytrKshg7+/sMXsFhuSnthrMNnK3xWTz8VVDfIWsNW3GyU8k6qFP4Wfaiy6BS8H7Vy/JY/DHiQp/Jcg0FILytAlWynqiByRRA8IAQtJXiIFN7daQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/hSpk5OTts9XZ1ORj9EMNCow1/QgYPqT31tlaTjAUg=;
 b=MxwZmFM0Pde/PtFVehDBbxg0SxttHLhBe3R5xwCG+Y/zJpzTv66JuR7R09hDiGpvOUp95tBa91zTDKMiqf8bVVyMOeyN4ScZ60ios47nWYSr6QcvDDt37mv1Fns9V9Z0V6dCcCZZulXEbhsA3XEUFxQ1W6MYbMzMd+Cm//yqo9coSINLYeouynSeqQHxSh7i2zpOXikvmCuSC6SvJu5GbpWtfs1yu9qS+soNs4miKcReZdjdtnWsOvQinszju7KVUfQYblYFHrIT6IbROuyj+gRTQMxjVYLgWUhwUX9T5RCHSAlu5fbYFDTx6bPsC3/0FTBcoyv1Ly3NJM1/h4mmrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=resnulli.us smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/hSpk5OTts9XZ1ORj9EMNCow1/QgYPqT31tlaTjAUg=;
 b=sckEbo0BcRlpUNjNe+2T38LM3Wfoan7GidsCxpjV6bScpxNULasXFPrIJchEkn5fFntLoRTRfQeGKCB0HgQV6pVlBXVpVAaLS6mreZObfO+qQiwy5Q39GU8AJLSIxkVdvqpEAnUgvA82vTUKhsn7ykcVIIpvvQ7yLz6UbsheOFBtOv+VYxX3ucrkYGpRYpmtHLWxQ6UyIKC64hAUjC26Yp0u+8Fy7WKlgU5UMnyi+L+iqctOuwSwtMRDikSun9uwBuwohy7aWMz2HFhzWOVfF06uNanRCRKK0MJOPe7YjibRyz8DVG/fCluKmXlxg6Ir+H5tgdQad26W5iY48+Px2Q==
Received: from BN0PR02CA0006.namprd02.prod.outlook.com (2603:10b6:408:e4::11)
 by BYAPR12MB3544.namprd12.prod.outlook.com (2603:10b6:a03:131::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.31; Wed, 31 Mar
 2021 16:41:03 +0000
Received: from BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e4:cafe::39) by BN0PR02CA0006.outlook.office365.com
 (2603:10b6:408:e4::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend
 Transport; Wed, 31 Mar 2021 16:41:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT046.mail.protection.outlook.com (10.13.177.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 31 Mar 2021 16:41:02 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 31 Mar
 2021 16:41:02 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 31 Mar 2021 16:40:59 +0000
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <memxor@gmail.com>, <xiyou.wangcong@gmail.com>,
        <davem@davemloft.net>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <kuba@kernel.org>, <toke@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH RFC 3/4] tc-testing: add simple action test to verify batch add cleanup
Date:   Wed, 31 Mar 2021 19:40:11 +0300
Message-ID: <20210331164012.28653-4-vladbu@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210331164012.28653-1-vladbu@nvidia.com>
References: <20210331164012.28653-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 238bbe7a-95db-47d1-3be5-08d8f463c5a7
X-MS-TrafficTypeDiagnostic: BYAPR12MB3544:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3544116E5FBD8BB4BCA92F89A07C9@BYAPR12MB3544.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1cEWLSWReHUHRCEmBwRtPlCYJGUK+DsBmOYUGoUTpSxgCfTlAVstgrOrugyVp8NAcBdM0b/3SotsBlBM1MJfqgOZAuUsn1FE+psS7NiG38ECUlwhysEMw3XyCaawKhn8HopYzQYehkWvprmHHrY4g+1GpEw8c5I7x0OqeOQwkmAI3bM523tUJz+m+C7iTkAtmi1CBtH21MRcOvhddPSSUHXNvCywjAF102JRzy6vQ5QMm7GwUJkoFVPDYzYUPhI13nXtTQAGKz9WS4P3RJ49dYoLGJmt9yMuNx544aK0tx88zbZ/vVOKBSJJ5HSj4hV4xxdujxlQ/QeWrQl5RodhACndLEbPLbMNSxRu+VpyAT7h6XqRwB8/f2DDynaTe1WXNUi8nPH1am33FUblfsWYd9uLL0W/8XLXXS6igCNTbU2kVXhjUH5yfJ5iLuPtcqKKI3DR0z9gH5KsGEdlPtmLwo5/4o5K4XWj+3ijZW6EFA5eFBxQsOSKCsRrtfNks+EBnbVSmpJXBMyaUfiaZBEP2+hC8hU2cT24av9hP4U15EGfrSROCiRa1nKFIxArcerCOtpJcyiFxWrljn4Qwq8oB2HmBKfLVg/0cey7d155Yurd1B7TTUTKu9gv0Zp32DjtKQAYOA2gULPWP1xK6WM+59QV9+AueNQuotkcqHIe30w=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(39860400002)(46966006)(36840700001)(7696005)(6666004)(5660300002)(426003)(6916009)(7636003)(15650500001)(36906005)(1076003)(4326008)(316002)(83380400001)(54906003)(82740400003)(336012)(70586007)(26005)(478600001)(47076005)(70206006)(36756003)(8936002)(36860700001)(2616005)(107886003)(2906002)(82310400003)(86362001)(8676002)(356005)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 16:41:02.6417
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 238bbe7a-95db-47d1-3be5-08d8f463c5a7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3544
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Verify cleanup of failed actions batch add where second action in batch
fails after successful init of first action.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 .../tc-testing/tc-tests/actions/simple.json   | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/simple.json b/tools/testing/selftests/tc-testing/tc-tests/actions/simple.json
index e15f708b0fa4..d5bcbb919dcc 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/simple.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/simple.json
@@ -175,5 +175,35 @@
         "teardown": [
             "$TC actions flush action simple"
         ]
+    },
+    {
+        "id": "8d07",
+        "name": "Verify cleanup of failed actions batch add",
+        "category": [
+            "actions",
+            "simple"
+        ],
+        "setup": [
+            [
+                "$TC actions flush action simple",
+                0,
+                1,
+                255
+            ],
+            "$TC actions add action simple sdata \"2\" index 2",
+            [
+                "$TC actions add action simple sdata \"1\" index 1 action simple sdata \"2\" index 2",
+                255
+            ],
+            "$TC actions flush action simple"
+        ],
+        "cmdUnderTest": "$TC actions add action simple sdata \"2\" index 2",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action simple",
+        "matchPattern": "action order [0-9]*: Simple <2>.*index 2 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action simple"
+        ]
     }
 ]
-- 
2.29.2

