Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144253504D6
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 18:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234189AbhCaQla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 12:41:30 -0400
Received: from mail-bn7nam10on2046.outbound.protection.outlook.com ([40.107.92.46]:22866
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229486AbhCaQlI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 12:41:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6bsM6Jk43zmdNJYpe+nfeyql8aOTSw/X7P/0MqleP+2OQggx4NMMacEbkQT/TkjT9Gpwm1WCCuhTd0v0H3ScYiHLVg+edTUTXqgb/apSiA62JsQ4wLVBlTajzSYi5ZFC03tB6rN8AqGaTIkYQ5hDoHShglg+hDoAs8liJcMBjy+ukIYeqerGxWKzj//lNTUAiPg32lmtfSi7yJld4zBu+bP+VUWaCEMuFvHJuZlj/TU+veBtWigcpgAzaghIUQQ+6gAumBtsIitGPhtO/7NCsYNCbgmRXcurhIs8uSRP7DjZdjlJG5DswPdo5TdThzfgm9XOmaGxFiBrxSK/VtdqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lx7mwgv63X0PmOqcC32SIl3tWfloAfdePU0fXb5mG1w=;
 b=Ccg3R1Zov4/vuDFZyQ/d47WlWgJ665ev76HmdDilda+0dr8/iQA0Z0x3sP/3Ey3cNnS9lHCe/K9POhIwrb4k2+0nYrDRh3U1lWa7l6t0+gs/m1kYim8W+zSNLV5r486juW260pfGF/VsufD8JaDURzuUzQufabvUVoz8ivchsgfsJn3izHxuKLqcfhHaCRXZoImzoOmNaoqnBU0tvJCj1A/hXJMHAuV7XkUowPK7QeRnigV2LX6HfOTUBGZW74KJ93+aCeymkObe2ZbCVcxw1LIzRbnc2JLw6I0I1TkI05C6ZIFMhffUOZ7M9GHHndDznNU6nc3hDZuokj168ZKxzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=resnulli.us smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lx7mwgv63X0PmOqcC32SIl3tWfloAfdePU0fXb5mG1w=;
 b=uJGBLJQOnIfvBs9H+WAcM1hnAwMMjVRCvVF31krfO8pzXmGq91mgk7ip7x18bPk7lFMAeRU48LnWv7tW8Td8VzkWs51iDYLSVnljNkrygMXOgK5fuROmS1q9/QmfXArD5kZOIDCQCbwQc9go20BEDKADldMDS0FDX1LlWNVY7vZ5CO7BuxS3cKirIoHgJMWzFTLDIVhf/dEvAFqOHGDvMtjccoBx0XcDxXLWypB1AAMgMDV1pKaoZ98e7TRmKLrqFISmhBYh+0wCDMyAVs/+O5Ji9/XtvkOkz6kpimys9Sh7PXo5b3EJVFl5Mltdb2r+vjBprA33zg4G5gVSOU+7lw==
Received: from BN9PR03CA0478.namprd03.prod.outlook.com (2603:10b6:408:139::33)
 by BL0PR12MB4740.namprd12.prod.outlook.com (2603:10b6:208:84::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 31 Mar
 2021 16:41:06 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::24) by BN9PR03CA0478.outlook.office365.com
 (2603:10b6:408:139::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend
 Transport; Wed, 31 Mar 2021 16:41:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 31 Mar 2021 16:41:05 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 31 Mar
 2021 16:41:04 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 31 Mar 2021 16:41:02 +0000
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <memxor@gmail.com>, <xiyou.wangcong@gmail.com>,
        <davem@davemloft.net>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <kuba@kernel.org>, <toke@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH RFC 4/4] tc-testing: add simple action test to verify batch change cleanup
Date:   Wed, 31 Mar 2021 19:40:12 +0300
Message-ID: <20210331164012.28653-5-vladbu@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210331164012.28653-1-vladbu@nvidia.com>
References: <20210331164012.28653-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d182b281-bd7b-4820-3192-08d8f463c793
X-MS-TrafficTypeDiagnostic: BL0PR12MB4740:
X-Microsoft-Antispam-PRVS: <BL0PR12MB4740B24F625DFB9BDA46DFB1A07C9@BL0PR12MB4740.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yUUFr/Hmz6PjFyXc74/fU+89ruQsQrWQcqaNnmb/OZ07FCfKvjcMEuR3QPPZkXSfkPlp1GU8OfF1Wh1YyhqLm/nDLZvdb+SqLPU6+ZVz86XnS0d1E/DIeHhWL5Ju3tRaawiZRgbDItDg15WkNUbtpZddgwy+TW9MelQl7d3IXJq6YTNxigQXs4tg7R3O9IgqEsP4mlWeaFAEqDkZEZhpCB8tTbhMzbkz8bBwsLkqfrRIjhjclU6+8GhaHH+vnZXN/lftSs/kThmx1jZcPXQxBTAunAslSU2glrRBC1/Cpy+TEVZgBFzRoGAa/QJM1ODWu+KZjlGwOLas8ieXBVizx0fiQBa+OnGi48xOP7gJ336tC235CAZDrJRuYmO4/sL+of2WTcLHc6ctMSBnrZyUY4qM+s1ek/dbQDs1AnShf4uqUzifhAFPSDokIHIzX6/oQSnJNmt7IiYdZTvjxe8STR/JUs9MqIFNsNxDgwZZBdVebjCbhUnSTtboWhEi+iJvaxoa4h/Jq4MPuIiT3btl/VksLoGS8CWAbQGUS53ue2v1gKYGYoKBBn8oDYBGPGQcH3ce5tRkxPBc+agz7GxQ/B2Ghh6QntpdP7HJdTKwcGZ0URoMEkgEq95ofBAuUw+aC/mokywazOTkuoCZ62NnR5YvfPKjJJv66jgRdOIViTY=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(376002)(136003)(46966006)(36840700001)(8936002)(5660300002)(36860700001)(426003)(336012)(8676002)(54906003)(7696005)(316002)(86362001)(36906005)(356005)(47076005)(70206006)(2906002)(70586007)(6916009)(186003)(82740400003)(7636003)(1076003)(82310400003)(478600001)(2616005)(36756003)(107886003)(6666004)(4326008)(15650500001)(83380400001)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 16:41:05.8558
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d182b281-bd7b-4820-3192-08d8f463c793
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4740
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

