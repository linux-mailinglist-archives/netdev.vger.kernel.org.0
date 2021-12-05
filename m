Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F528468B05
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 14:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231906AbhLENWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 08:22:35 -0500
Received: from mail-dm6nam10on2043.outbound.protection.outlook.com ([40.107.93.43]:14529
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233486AbhLENWe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Dec 2021 08:22:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Adtf1vVxqXgPbXxA9gY2D5fpiL04r0sPXjJQDkMY8xCfD50F3t49VqIiYsrNJWWC2u8safh0qG1U4EpiBExLRtcxUKx4OeXYvgqRHFaEX3yVhumsbe3PWPTidH3vDk1ettvmJ02tpK6Ob4Artsz32+ZZzXuySeGJ2nk07Yx8Os/YSJGbaK1Zv66qUpmN8Zb20pw12MD9KzLbG83dLS9n1f/UdfmGi4FwrONvyB6gR6HbQdc2VnUIRWSUR+Lsjx4Fx/yYRPz4S7jLi0isqqoFn1yjJZ/dUBaFkUJ1iH8zce/BSYhwcuIy3CqrX7m/5SbDsOWNk5R5NDzuz3vq06kohA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NV12cvh9Mq5zGzexol47u0+a4eZQgw/oDcGXjggMCgA=;
 b=TpnLwImoD80wkcPvFQDr9xwCjrdYbaNFMCmGEC2XUQ2T3ifZmwk1VplQyuIWBQdCXsMlX/umEqOG7jVf1ponh6bdcudwylTcFmxebixxykdJDJ5iOb2UCbxHe5huWFhiv4eUh7V99AoFOqDIIQV/v3MVpkwJGJPVYIesmFMhwXnYPxO1DXhtj1WJUEp5LUCWmDGq37fuHxwcDc5dBtfK0d9GK4HZ4KnnadSQ/eh5TfGsEGABDx+HKFtJo11xj2YvCWL+bRpiw+w0lRWV1+wjFInkdf9VbDIdqerzug4n0/dj3RwhdK0MGGpSpVe4IPO9Vjz4CwZ+jhqw3CzT51b42w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=netronome.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NV12cvh9Mq5zGzexol47u0+a4eZQgw/oDcGXjggMCgA=;
 b=llNRGRO6NZviEyRdwYhqwson0xdOkdu14QJj9cP//0lyi4dv1nJLJJ8D9mk3ESk6RjSkoWSJ1Mcp9yLMoIWcVWge8MhOwk2JPN8B3x1Lvt4U98QleFbu80gglUlIP/VRgU9JqXWeJh/IPXu70hwqcXEiFrRzpZ5nUotC+y3+28tQgvAlMkNl0nUIMrfrWaZCLwI7nPDOTY94hr7kAwieK9uRBm03kPOEe7uydVu0VAmGHBAF5xQGWSczBY0HMOru3BIX6Pm753Pi7/ZJViNIRH0KsyTQ+Pnd+IRJQngVsVW12QOulMvUcdKyOewl/GScGQ+v7UoQERLthCaCKIXp7w==
Received: from MW4PR03CA0164.namprd03.prod.outlook.com (2603:10b6:303:8d::19)
 by CH2PR12MB4213.namprd12.prod.outlook.com (2603:10b6:610:a4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14; Sun, 5 Dec
 2021 13:19:03 +0000
Received: from CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::23) by MW4PR03CA0164.outlook.office365.com
 (2603:10b6:303:8d::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.14 via Frontend
 Transport; Sun, 5 Dec 2021 13:19:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT021.mail.protection.outlook.com (10.13.175.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Sun, 5 Dec 2021 13:19:03 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 5 Dec
 2021 13:18:39 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 5 Dec
 2021 13:18:38 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.6) by
 mail.nvidia.com (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Sun, 5 Dec 2021 05:18:37 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
CC:     Simon Horman <simon.horman@netronome.com>
Subject: [PATCH iproute2 1/1] tc: flower: Fix buffer overflow on large labels
Date:   Sun, 5 Dec 2021 15:18:34 +0200
Message-ID: <20211205131834.15430-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ebf38553-47f6-4037-fac1-08d9b7f1cece
X-MS-TrafficTypeDiagnostic: CH2PR12MB4213:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4213625A9265D7C27598916EC26C9@CH2PR12MB4213.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kik2FINQ0mOEZR0RVKeVjaANsSRNt8X4a7L24AfPSIlVJQt5Bo8hKpqF/bbOywVblG3OsEceQSlldVnstgIgQyAFtbtvgdnvOjnyE7FX4rDo4IEuqFZYObxdq4sMUzAPq09N5+nUZzqO92HUY7lHHcsfwjbDXlwuS3XO4/c2VF3tZ7L91Oh80Uv6EuWPPoIVqu7H1z+wMy41w2iyJcqu3f2ln1eSL0t1y0gECUn3/snDrap5dsRwHq3VunDiEsZ33TeqDDBuGAKVSFdOeIPp4bJOpe2i4AI7Ld0qvcmEagVZ7IW8TDG86b41q+duRJKYZxn0d3AFiVnqCQuzramEj1sjPZry2iDW9GP5qDUidmOotaBmhIPGlTyE7cP9BrOtE1j2+fCFvuqRecjPWyXZpOiJWi0pKq649OQydWCWNSzRa8zvm28J8is/9PkSgFslpUbxeUwGoFLWoNNxtLB7iu6gGkPI1HiUmuD9JgghgKf4bfg7/Ra1JQXAYA2YQBUA6Wlgwlq+LrKkafzd7TceWvGDmDNZX+z3Ah+ja0kxS4tIGLpsRjXiz7DzOyzY/9CFLjS84rK66QMUgA+O1BE9qJlYc9P1LizMLIKzbPh2NjR4k1DyyhFKAtaFbpzrYWarqpW5uQsfQiVEsiBzHtuCF3mw9DVptPWm/Nys2gFNCs+ezXAc2P4jgZM3vjgQgsCJh079PwjdzqPAEXBLUtJkDWRsnRhNwnkGsTHIhwRzPCFQXzyxfBKV0Qj6KFG1/NBczZhLdXBWgtGB5nQPuik1/A==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(356005)(83380400001)(4744005)(47076005)(2906002)(82310400004)(6666004)(8676002)(186003)(7636003)(26005)(5660300002)(508600001)(70586007)(2616005)(1076003)(70206006)(336012)(40460700001)(8936002)(316002)(426003)(110136005)(4326008)(86362001)(36860700001)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2021 13:19:03.1219
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ebf38553-47f6-4037-fac1-08d9b7f1cece
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4213
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Buffer is 64bytes, but label printing can take 66bytes printing
in hex, and will overflow when setting the string delimiter ('\0').

Fix that by increasing the print buffer size.

Example of overflowing ct_label:
ct_label 11111111111111111111111111111111/11111111111111111111111111111111

Fixes: 2fffb1c03056 ("tc: flower: Add matching on conntrack info")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 tc/f_flower.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index 7f78195f..6d70b92a 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -2195,7 +2195,7 @@ static void flower_print_ct_label(struct rtattr *attr,
 	const unsigned char *str;
 	bool print_mask = false;
 	int data_len, i;
-	SPRINT_BUF(out);
+	char out[128];
 	char *p;
 
 	if (!attr)
-- 
2.30.1

