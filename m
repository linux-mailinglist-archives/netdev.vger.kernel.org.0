Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 957353570C6
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 17:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353773AbhDGPrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 11:47:20 -0400
Received: from mail-dm6nam12on2066.outbound.protection.outlook.com ([40.107.243.66]:2612
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353752AbhDGPrL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 11:47:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A/Fx8MZhUK0LTCqheWtw73DueNGRK647C92lXrlfxOU/fs+cXWqjC5j+8+TqH+utPIrtTrYQNbduRbeQxmBP18qkpfd0pOVxJtwQyaZTXynxPwA5M8JqqP8McVGnAqX76k/pPKWOIUOP89/qiDE9Sdyt+vCOZpn3sd4G4p72Ux2oeqL0+u8ifGj6/mv7dcSWTvtfYXSdHyUwpKw32LknJiD+DyjOs+2o7Tg1ruc/kgjcvpBu5v88cO7pffco83GHxtbU3jHMzTk2e6vHXF/aMTtBP8gSXoGRxvtqikf+pTFotPjADbdkNkf1pTy3Pae5iSdqYq3STJL3mMxDcWwkJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lx7mwgv63X0PmOqcC32SIl3tWfloAfdePU0fXb5mG1w=;
 b=ZyNuD2NRqIsvjDTkMiFR2MAeKIzr5jxVPKFYBjPe5X1w9WAkFC38UdBDNPyAkxvXSVdxqoT9mERJLGKjNxDOULvdqnO01mDcTbzzqhPAthuXoMdESYf0gdHiBfjrao4IsKk0vJzTvIWBK/9R1aexiVZnJ6AzVLK+xA2vHxCYEFVLLBun/4PKgJMa9MTjAMZlgE0pKRdNFiefKAOdZzFop8iXXQ/IaV4qhOakaAtZwc403VM2byQQYrUMYL0XLKKLMSUohbQX09bikWUwokgc1xr2qUvr+kDVcq+mcovMSPl4FiwiWkR13Uk7zdUwMoWRJEvEgrONNkJk06JWZTZPUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lx7mwgv63X0PmOqcC32SIl3tWfloAfdePU0fXb5mG1w=;
 b=m30PaUYKD6NH3vuV0Pk9A2mTUmItFWVjK6BtE7FCSOot9t2tevlt8e1Bez0uo8Drjk/I6JF8gyymJID61oFyqo2s5snzg7oXvhnGGhA44hRKWQYNd18hDDW3wIfUK4Q3zH6bm8x+enhNzCs+ekxUJQ1QtYVD3JGvdXCiu0X6/vSNWMm2RyzGtUwh0sGYvig8p9xWr1M0w/87pK56sLvgaNxKU5+J/prTRe1daVsTZLlPXfIZSWPyqKv0ukAxIC5h+hoSljd46gMgHXLG8zPJK3MRVCGpmrB9li8gtRmsYQc8W/yTdYI5yOJYClU/zpxv8PiroLSZgm+xfkuVWfN3Tg==
Received: from BN6PR1201CA0007.namprd12.prod.outlook.com
 (2603:10b6:405:4c::17) by DM6PR12MB3580.namprd12.prod.outlook.com
 (2603:10b6:5:11e::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Wed, 7 Apr
 2021 15:47:00 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:4c:cafe::bd) by BN6PR1201CA0007.outlook.office365.com
 (2603:10b6:405:4c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Wed, 7 Apr 2021 15:47:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 15:47:00 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Apr
 2021 08:46:59 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 7 Apr 2021 15:46:56 +0000
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <memxor@gmail.com>, <xiyou.wangcong@gmail.com>,
        <davem@davemloft.net>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <kuba@kernel.org>, <toke@redhat.com>, <marcelo.leitner@gmail.com>,
        <dcaratti@redhat.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next 2/2] tc-testing: add simple action test to verify batch change cleanup
Date:   Wed, 7 Apr 2021 18:46:43 +0300
Message-ID: <20210407154643.1690050-3-vladbu@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210407154643.1690050-1-vladbu@nvidia.com>
References: <20210407154643.1690050-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb9ed1ec-deac-4750-d308-08d8f9dc61e1
X-MS-TrafficTypeDiagnostic: DM6PR12MB3580:
X-Microsoft-Antispam-PRVS: <DM6PR12MB358017E185339926F2B15329A0759@DM6PR12MB3580.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4C65QyeYcgMSyfivT/ywiDp8ECrUDBcLTcRDUjdlh0wLde9txQwZsKd30R0/YlhWjwfNOiR3MTPRQP4nkQE9rLfq8XYbDd6vOBIgZ5yIQb2kUCywo2Yq0bm89Yj4otnv+6/ZFo2RH8LTAnAGaDXXgMb8l3HWHalVNkcWjXQN/jbnHNGG3fnSuHIK4MnUHfPS18MNmsi2CrRA9Jo6mhvZPTIg645EHS5lblBB24OdUU1rYv0fhgRPilgOvZCLe231W7L5U4mK6bHJojIdqGtz6WM7zvh/XWN9Q2/CgVjX+491bN6GAjcu7jKkOLP/ZDs8TIGOYnNenfbkLItO0LzfW6vfSZIY2KdHLi5QBafW9k/xF0ng7815/srRpaH+rqHGAHpIM210O5qJgvxgoEMpdHlkeVKpYGLfDfHiP8jhL+mbyO4rJQ5UYILpzxG7VGQ/oSEwy2gf1GC7D60b/EJASsDVbi8ck2DOB6nNvNbItw+ujUrEGTQDqNnYtuC5z+OUk6ILqIKh29NrPr+YV/FRjDOT0QS4MtIER2uQkkZPOz1Ggz8seurFIAhRZtLnXvaCZukawA11upPdC7kaZ5FWk/qYbdPAtjjPabSN/50SeLGoCd4BfJul6+TjhogRqZB5efMcq9LJPPQ2KsuYn7grj1NnwISU0AlicG04lXRp8QU=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(396003)(39860400002)(36840700001)(46966006)(426003)(15650500001)(356005)(6916009)(478600001)(47076005)(1076003)(7636003)(8936002)(82310400003)(82740400003)(6666004)(2616005)(107886003)(8676002)(86362001)(54906003)(336012)(186003)(7696005)(70206006)(70586007)(36756003)(26005)(83380400001)(316002)(7416002)(36860700001)(4326008)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 15:47:00.1517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb9ed1ec-deac-4750-d308-08d8f9dc61e1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3580
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Verify cleanup of failed actions batch change where second action in batch
fails after successful init of first action.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 .../tc-testing/tc-tests/actions/simple.json   | 29 +++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/simple.json b/tools/testing/selftests/tc-testing/tc-tests/actions/simple.json
index d5bcbb919dcc..e0c5f060ccb9 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/simple.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/simple.json
@@ -205,5 +205,34 @@
         "teardown": [
             "$TC actions flush action simple"
         ]
+    },
+    {
+        "id": "a68a",
+        "name": "Verify cleanup of failed actions batch change",
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
+            [
+                "$TC actions change action simple sdata \"1\" index 1 action simple sdata \"2\" goto chain 42 index 2",
+                255
+            ],
+            "$TC actions flush action simple"
+        ],
+        "cmdUnderTest": "$TC actions add action simple sdata \"1\" index 1",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action simple",
+        "matchPattern": "action order [0-9]*: Simple <1>.*index 1 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action simple"
+        ]
     }
 ]
-- 
2.29.2

