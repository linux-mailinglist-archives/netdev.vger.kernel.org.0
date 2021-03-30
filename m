Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B2334E59D
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 12:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhC3Kl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 06:41:56 -0400
Received: from mail-bn8nam08on2064.outbound.protection.outlook.com ([40.107.100.64]:53088
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231269AbhC3Kld (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 06:41:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNomLUXKIeu5/vgeWXD3STytJ9oOA1lTxevrkN342jKi3Sl5kSE8y7zq+qsMRyhSIm4czAdAcNvFq+a/lAyZsFTQ5gHMZb8G0tZrMmCP2oG2q6fHCIa+t/zJzDqz5LdlLYv9POTPiJOud7bz7cDXlh5JB5X6qiUzhKEZhaodohce/JoSfPuitJMQCx/qSZoMbwmmRNXyLUjuDup8pU2/6zR/GCIGd/QDRNPXFu45bvCWdfxx1nrUOTIHA3/RDGuIY1mOXdeupfRKTh9pAEeKrr7FQlyITTbaO1MR20SL7q/8B0Gs10EjL8/m9kTiB/JaCG7NhsnoaS77bOlyGyptlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYtzQJYTBZ70t5XMLSNL1NsAMdI3EqDKwdNXriGaxyk=;
 b=iGMzdy0q3QggKgwsNclaolGehBT3/Lb/dm9NyczpKt+TUCun8P6QUbOciltEPm3ziHld0CKZXA6whC6YXs+d0KbmeG1S1/5eRM/+LJc2EKM03rFISKOkjoG5YFliIeAdN330dTbWORGTqucmCsXuoIZgCU+ZHbPGOpFoQbcfCAzUlohUjW9wJwREq308V8nO29M8tivA6rIV6tA6cEx2I1WKY7hwIvKvuvs4qctujybZQuw8tUIaGEQZi8/iXC2SrThbplEMXcZH8kDBBA3Scmy2+mpe4wcPB3ETeUOR+197WleAzjJeYBRz+n8PLtZYr2zq/iJ2JvhTTvLqHqBnMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYtzQJYTBZ70t5XMLSNL1NsAMdI3EqDKwdNXriGaxyk=;
 b=Atf6ZTMQbjsi0IK6lfEmmIwYoqgKykV3o2Db+rqwaQs90PtvjCpwTqmzJiuuKE0teFVDXssQXhk8nIqCQmorz3uzC3PkzyH7wHwuS9fwZBenU3gJ2P8WzKw3E+4JBKvQ4MhBPtGH93K17q8RB8n29wlqyU+hoxKb6nx5xubE5c3jJ9SScrUONf6GFjzwQ87N+PkD0oDPblapM96ZEBwmGjOMwKg+wxbsKTgIaNa80ZHGlZNWaUdEWF6g1ANTLbQ44aSFwhQ7DkPnXCCM9FjVolrVWoLSr+4BOuQVldt0KgMg42OIj5WVhlqKuElk1XwKkFRKfoHffdqeoYLf+2CHCQ==
Received: from DM5PR1401CA0012.namprd14.prod.outlook.com (2603:10b6:4:4a::22)
 by DM5PR12MB1706.namprd12.prod.outlook.com (2603:10b6:3:10f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 30 Mar
 2021 10:41:30 +0000
Received: from DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:4a:cafe::f6) by DM5PR1401CA0012.outlook.office365.com
 (2603:10b6:4:4a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend
 Transport; Tue, 30 Mar 2021 10:41:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT026.mail.protection.outlook.com (10.13.172.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Tue, 30 Mar 2021 10:41:29 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Mar
 2021 10:41:29 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 30 Mar 2021 10:41:26 +0000
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <memxor@gmail.com>
CC:     <xiyou.wangcong@gmail.com>, <davem@davemloft.net>,
        <jhs@mojatatu.com>, <jiri@resnulli.us>, <kuba@kernel.org>,
        <toke@redhat.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next] tc-testing: add simple action change test
Date:   Tue, 30 Mar 2021 13:41:10 +0300
Message-ID: <20210330104110.25360-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210329225322.143135-1-memxor@gmail.com>
References: <20210329225322.143135-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a704eb7-6712-424f-e63b-08d8f36860aa
X-MS-TrafficTypeDiagnostic: DM5PR12MB1706:
X-Microsoft-Antispam-PRVS: <DM5PR12MB170644B295283305ECC0FA68A07D9@DM5PR12MB1706.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b2lzWBTJZVuSEe1ijOGfOZyKRDh5NnDJ4MYRLpZYX7XaBT5j7lEg566MTWmdpqbcnDPLAihNUynqAH+8kRFsBKVVq2dZy3I8MeW2qghJt0X3VyOrH72l6IGjkJz5a0dDYTNX2rjsBxe1oUCEMwJIQynq8z/43UWPClPmAB6UfeXZ6W/IWFsk9O6luUsVTJNy7NYpuGS7GJX7OAQxTAOiGtzuTqU39cFYBEl9iZ+ZtJkLCsuUm4VN8JwWbLcPsT4RpHfj1SvMNSwmAG7HKWOn015pohNxvrhojFH75Ta/pRFleVo/GA1hXq3/iMpgg0KC371eLpBWkJsCvylx8HW/ywH6u5jdiEOshbujHRAVDIepqQSHpOXYpAlqaj6Tm0SUGnT/bmC1mM01iO+pMlxti1OyY3QDgURGoY8jChOfRseWvLSBPSzENTzbLbKUuRsnp5mwDx82xuZF46eP/jhfbwPrNKQF5PQ/u9y6kxvPooXQR6nj4c5PyuoTiEvPb6SHlDKJRSufsv2Gj8msTqLXpiOquTeeR4eYIZXqEeiwsCSniazBneKAOulw+GQP+umuVTbOwURzEPBye70eOKmv0QJhsjNXMCI2m6zK1GivGcM6q/K6D7my95JR7NwGD5z6NKlO2swxuv89AoF49UFE18/l+jhhh2MwTgSIaSdVgUY=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(36840700001)(46966006)(36906005)(336012)(1076003)(82310400003)(7696005)(426003)(7636003)(26005)(4326008)(83380400001)(356005)(86362001)(36860700001)(36756003)(5660300002)(70206006)(2616005)(54906003)(6666004)(6916009)(478600001)(2906002)(8936002)(8676002)(70586007)(316002)(47076005)(107886003)(82740400003)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 10:41:29.5766
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a704eb7-6712-424f-e63b-08d8f36860aa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1706
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use act_simple to verify that action created with 'tc actions change'
command exists after command returns. The goal is to verify internal action
API reference counting to ensure that the case when netlink message has
NLM_F_REPLACE flag set but action with specified index doesn't exist is
handled correctly.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 .../tc-testing/tc-tests/actions/simple.json   | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/testing/selftests/tc-testing/tc-tests/actions/simple.json b/tools/testing/selftests/tc-testing/tc-tests/actions/simple.json
index 8e8c1ae12260..e15f708b0fa4 100644
--- a/tools/testing/selftests/tc-testing/tc-tests/actions/simple.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/actions/simple.json
@@ -23,6 +23,30 @@
             "$TC actions flush action simple"
         ]
     },
+    {
+        "id": "4297",
+        "name": "Add simple action with change command",
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
+            ]
+        ],
+        "cmdUnderTest": "$TC actions change action simple sdata \"Not changed\" index 60",
+        "expExitCode": "0",
+        "verifyCmd": "$TC actions list action simple",
+        "matchPattern": "action order [0-9]*: Simple <Not changed>.*index 60 ref",
+        "matchCount": "1",
+        "teardown": [
+            "$TC actions flush action simple"
+        ]
+    },
     {
         "id": "6d4c",
         "name": "Add simple action with duplicate index",
-- 
2.29.2

