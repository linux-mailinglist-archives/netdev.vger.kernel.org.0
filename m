Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6CF3570C0
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 17:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353757AbhDGPrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 11:47:12 -0400
Received: from mail-bn7nam10on2057.outbound.protection.outlook.com ([40.107.92.57]:45792
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344222AbhDGPrH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 11:47:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NCVmSlezJpr6G6G3TxqVohpC9MnWV18zYe9H+hgcZImZBmDRin3HwZjfnTP4mBa+3ewqCrsw+bOv/1B0IpU9Xzw4RdJyzxAQ6Vy2eYMJ8ycKceOLA+pdQG6sqZnPOHEId1H8Et/2PJQQRo/dwHy6SkkypJ7UzSmWZxqdka1ZAZUScY3VPCwFb753nbL9Z8D/yKrjkb2debdyijG+pgN38ttDLegvpDRibt5udvoaUzScxIac9CvvJEzNksvRTrBkHoy7waOpBtd0/xKW7qRzsDIGIhvaB2Ba8+R/s/k5UAsWijtUoDFrZgTUA0V63PWJxv4jT0+p5HHkj9PjzjLqBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/hSpk5OTts9XZ1ORj9EMNCow1/QgYPqT31tlaTjAUg=;
 b=hs0zp4k+Net/XJloP5pB9irsK7ZmPiyaXuydGhxMBtVG33TFoQIC9RtwC2pA4IUhDr+ZsrN5M3MpGEKhRYpstWc3UEq8DGiNZkgxmowitG1SCNdRtNm1iseyjsX7cVivh/d2mGBKJbB9OtRjWqoMXJ1x6grdaHCuRfh8Dp7I9q/Z1R5IVvFto07zLVPmJrBN0R5p6jAHb6XWXxAiECnaPiX5iEjbK6dYR2u6mK7NYNZgPjrZfV+5BENIr+nXuKULgAyJJiRkjYQshFMhuddzV4I7iEyZlV01x/UjjMsv5h8MAAsiTC6fp8fz5ZtEZ3dxpFntPmqbRxorXhG9Sc9aXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/hSpk5OTts9XZ1ORj9EMNCow1/QgYPqT31tlaTjAUg=;
 b=DjITRADtkXia8XuknSy/npUUbGeijl+8fpMxyk85mAjhoU1uziL8QKYHA6/k2xy4V2yJxWtpKVG0SckPbv4M7y3JfKfK9YYqO5oXTrmVw35drdG1QkTYtyOC0puQlBTITs6bUlQvfM1rP8hhbIWmzBmL6wN+EuLO+ZXXNCkyqWhE+UyjaqNPg9iWj9RrfcxJ76Sp5RSf86So2kYjdYcGrekxhJPGsrMvGmu17z1HF6nLNzvFpyeNl/Q1mMKoZB4Lb/TY/yI5IsX9jZx+aK0B68HFULCa3Ch7LRw55mSYjCVN/XZDP6fWpKFqAsGztaTKnGVI0Y8penRZ6m/xoJdlpg==
Received: from DM5PR16CA0017.namprd16.prod.outlook.com (2603:10b6:3:c0::27) by
 DM6PR12MB3004.namprd12.prod.outlook.com (2603:10b6:5:11b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.32; Wed, 7 Apr 2021 15:46:56 +0000
Received: from DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:c0:cafe::ec) by DM5PR16CA0017.outlook.office365.com
 (2603:10b6:3:c0::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Wed, 7 Apr 2021 15:46:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT023.mail.protection.outlook.com (10.13.173.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 15:46:56 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Apr
 2021 15:46:56 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 7 Apr 2021 15:46:53 +0000
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <memxor@gmail.com>, <xiyou.wangcong@gmail.com>,
        <davem@davemloft.net>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <kuba@kernel.org>, <toke@redhat.com>, <marcelo.leitner@gmail.com>,
        <dcaratti@redhat.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next 1/2] tc-testing: add simple action test to verify batch add cleanup
Date:   Wed, 7 Apr 2021 18:46:42 +0300
Message-ID: <20210407154643.1690050-2-vladbu@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210407154643.1690050-1-vladbu@nvidia.com>
References: <20210407154643.1690050-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4096e913-7721-46c4-581e-08d8f9dc5fba
X-MS-TrafficTypeDiagnostic: DM6PR12MB3004:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3004D85A9645C1ACA5DB523CA0759@DM6PR12MB3004.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fVust5meDQZxJkqqrIXYrbpyxcrd9bhKvCMPW05b2ymwk4bD4nIuQi0v05/UTdPDmMei17K9XOw29OI/VwdM8NSaQpt/oKZVZ1A3Zwb0PSwsxdwHNh6lytExPZUnF0ixd+XwxYK8H8Z/dNpi9erUoejuEEfLncJfFcwc2xZj/+BIp093VVzfzDpcA5Ay4sPexhQDRk2tQK03XrFcAxMRrQozGUQdxjFvOo0FZs/EK43kSZwe8wC1IeOlBHs0miSHbTsk7fBqOAAeoAGM9MVoQXPHFdIKFi0GeHue7DJeAUprjlTWH4Hfi0IFPfh+DQS8w2K766Ja+ddmgIXMLk+vzNbwCwLkoLi3Ie0YF+hbHxdQADitG1na/98Z5+Wik0bTUc4wg60EuS+mmpxL6EvDtEzK//hAJG2FnfHDmQoyWyJyaDZOi1Hy4EDmHwcvcc83P0dCqFPHGnAb3JJb3bBmXYXo92IjvzJ7zbMHOQB6HS9ZhOL+BsE1Fvp8W1e1NU3KOjyVegcvnNua+28M+YsgII8/JJcmcDU9d8YedyTVf0x3DGI866XULLa2ElYawWJGuheNvTpMOLxSkkRVlQjIWPXB61pccCUt4uLgNP0gBXtKavSezKM4DZlV8vFVJN7ly4HB7Wsav3t5Agn1DfOToMBjCB1yCENDf+JZYZ0CT0Y=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(39860400002)(36840700001)(46966006)(6666004)(6916009)(70586007)(36860700001)(82740400003)(83380400001)(7636003)(70206006)(336012)(1076003)(478600001)(356005)(2616005)(2906002)(8936002)(36756003)(47076005)(4326008)(26005)(15650500001)(8676002)(426003)(82310400003)(7696005)(86362001)(7416002)(316002)(107886003)(5660300002)(54906003)(36906005)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 15:46:56.6124
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4096e913-7721-46c4-581e-08d8f9dc5fba
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3004
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

