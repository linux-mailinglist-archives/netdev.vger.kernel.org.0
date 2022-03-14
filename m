Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437384D8659
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 15:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242064AbiCNODD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 10:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233883AbiCNODB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 10:03:01 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2041.outbound.protection.outlook.com [40.107.237.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D94201B9
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 07:01:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LozxIi5ImivclbchVakV/5fiaMKgkn6AU3UBXWf+lwBHjl8nQi8KoeFYpQRmgFT9XGdqbk03rAEIyGjY44/WTLiGN4HjJIxvGIXqSUWIb0XuEXWogzDIUUcW1wDCqrIzDK+MWL7fRAgisp8m7w/jG6Nm+A/6m5w5GLot4jbjMukcXPJQI0CWXKEBuYwO3R0BexUblIiataly2Z1PjyGnK/1eiQkRXfOcihfft0E0xQgWyKMgn66g2H7yLP3H1YLyTCDJ8ZnI7BzFR37TECpwV+Rgyqrpb4/CSoflW+RWcRTVlda9PijYQKdtxSC3+1zelwalITgmkezrsrZmqtxHPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ls7aHhWLLaRG8fNNPJX7mAUuXp+TISS6XubplGdelc=;
 b=LINlzJ/gjv2pqEHfZ4x39Xpze7jZYULFMzTj0VKMGqxnaMvgvHnJDW9ACFHNjMPy/zoamOjWLnyPkJ4nRpJ63mJS1pRAT9SsDImSoLsfzdNSrR686or7dYx2GJHVBUOyoP/oMg+esZkJDqivhxmFIwA6afZOhXuZ24Wl7kFgK7lk1iG+tT1n07a+DCMxhD6+85xdUwS4z6yiNd+Yo98L8IkrE6Wi4H2ZVXc/o+PoZoBHejI3lPQ0MoFU6X5JUfrg8++4rNufHuts0Fpq46Ai6mCYPnVu5l9BUJwHrIjGcNjmM+osl4BWItOXAFdNHSNSHrwBurvvoQBnV9NCTvbHhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ls7aHhWLLaRG8fNNPJX7mAUuXp+TISS6XubplGdelc=;
 b=Nw9cHaynGlJZGi8SjHKdW3HV8HJJBgurSFXjy0pajIKNOozFsB62nZJfEHxirh+D8JX0yFx9S6ScEZGD+A1eApfWYdFHICsyCsJRQYBAL1t4Ayf8XGVRWSQE3OhBiQL0YjDEPxqmipzKEQNFSZySOT626RtcC13aoBCdNe0tiiW8zLWte+dZDwj+BvyfCYMdcXEpf8/4gljcFbG7hR3wAiRsHxgfniIhmdnz/Vds7RIciOO+CFLZsAQfgfFuhBLU3VVMWVo4oGspMV0kW6Fp0e/0+Ud1tULZKz0/gdKPLq/64LTeBQFZA0UEgAX99J8xU1ZGkA7r5+gb8cjj9aE1JA==
Received: from MWHPR17CA0078.namprd17.prod.outlook.com (2603:10b6:300:c2::16)
 by SN1PR12MB2573.namprd12.prod.outlook.com (2603:10b6:802:2b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.21; Mon, 14 Mar
 2022 14:01:49 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:c2:cafe::68) by MWHPR17CA0078.outlook.office365.com
 (2603:10b6:300:c2::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.28 via Frontend
 Transport; Mon, 14 Mar 2022 14:01:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Mon, 14 Mar 2022 14:01:49 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 14 Mar
 2022 14:01:46 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 14 Mar
 2022 07:01:43 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next v3 3/3] selftests: mlxsw: hw_stats_l3: Add a new test
Date:   Mon, 14 Mar 2022 15:01:17 +0100
Message-ID: <07823fa75b0c862c674618234bf13510f40f5285.1647265833.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1647265833.git.petrm@nvidia.com>
References: <cover.1647265833.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f042cd71-255d-438c-9b38-08da05c32f04
X-MS-TrafficTypeDiagnostic: SN1PR12MB2573:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB25732089FC8FDB7903A6B959D60F9@SN1PR12MB2573.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sQ5BpBE3/Y6IVX3NBVECJn7Wm+L1QaIC2HC4d2itNTkq4EqQ8zO6mC4c9S7dCuVdx0wtXGkCjUOFD+Qb4Kwj1jWZO6bJUwzm7nIehfMU9GoxgOReRhJAgHEgOjLIKtXcsU0f5sk34WnDoJ9uDFk8vqCH1LB0Vf25Vu9sFqXPAd/N8uT0y6l7qtC4Kzfgbmk4ze3uRhYoJu4J63kBv9rijOlF0Hha1r5FO3DYwvIUpiowqA7Vv5BBEf02dVQfY3EjsHvgFoffVY8idJUcjsrygVvtemAmhg7cJYj0mJiFf8IJCcFOXq4Qny4mkO5Cwio7fIIZZuxYjPKJgRIEhly/U//Gw8LMOZwPPmc4x0NAAcYzyEggCDOSp/pR7li6s0J7R/XVMEYIdFJowXbGUVnFOBA1iDkw1/UKTto/bzbEdS4n8ZSc51Nhxr0R+mOXLiqIya9bQJTRsfWVgdaHnyeKQEX7KbxBW/oXceg8rXol3rG1euZHp9/nVH+Zs7+RG9BczxViMEkN4+VlBvlB+jgut9jKgf7V7fjUshhYesu7TQnYBkuJm0ppSKqSVrapF/o1JGErjz/etWC0hQOtefomEraemgxG6hle755YpX6BXMRRdFyI+7BkdMuV4cuQZ3ONTiggnEAxRB8eoLOmuox92xIotvQDL7Fy887Ff92jkOHoJOr0KoyLNUu9fLNlbR3XU3qaqZ2iMwEemHywpcGfTg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(26005)(186003)(81166007)(356005)(2616005)(82310400004)(426003)(336012)(16526019)(86362001)(6666004)(2906002)(107886003)(508600001)(47076005)(36756003)(4326008)(8676002)(70206006)(70586007)(5660300002)(36860700001)(8936002)(83380400001)(54906003)(6916009)(40460700003)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2022 14:01:49.1314
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f042cd71-255d-438c-9b38-08da05c32f04
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2573
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test that verifies that UAPI notifications are emitted, as mlxsw
installs and deinstalls HW counters for the L3 offload xstats.

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../drivers/net/mlxsw/hw_stats_l3.sh          | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/hw_stats_l3.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/hw_stats_l3.sh b/tools/testing/selftests/drivers/net/mlxsw/hw_stats_l3.sh
new file mode 100755
index 000000000000..941ba4c485c9
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/hw_stats_l3.sh
@@ -0,0 +1,31 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	l3_monitor_test
+"
+NUM_NETIFS=0
+source $lib_dir/lib.sh
+
+swp=$NETIF_NO_CABLE
+
+cleanup()
+{
+	pre_cleanup
+}
+
+l3_monitor_test()
+{
+	hw_stats_monitor_test $swp l3		    \
+		"ip addr add dev $swp 192.0.2.1/28" \
+		"ip addr del dev $swp 192.0.2.1/28"
+}
+
+trap cleanup EXIT
+
+setup_wait
+tests_run
+
+exit $EXIT_STATUS
-- 
2.31.1

