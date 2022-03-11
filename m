Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E044D63FA
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 15:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238124AbiCKOop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 09:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350090AbiCKOnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 09:43:46 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2975CA2F2A
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 06:42:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6iPvNBhnCHLdUXrfUro8ciVpdTPdYsu9nPXwMoLEywLPL0Pq3hFQ+j4DpYuDr/yhHzQyFbpFMZSQx5ivKJIKtzDFOiHFJzjoeZaFGKk68dJ0lrcYJIWq9Ic0L4uk4rL6lEcqQy9NkjGUt+21r40XhVrrML4W9905xp1i3p0sRVts9fG9aPIlbGiozCu0sDIINZxBP5UbIgWZywPRH2J9OrEiVufs0cFvEoLszIXCCqdsTdkksWk/OPTkqaU10pW1/vAjKjmhslhk6aQD2GkHcMoH5k1G0h9BM/aTMreDt99Jf3dIK6WdjjPPwi1xI6pgKeQHGNu2Y/rL5KLbieD1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ls7aHhWLLaRG8fNNPJX7mAUuXp+TISS6XubplGdelc=;
 b=PU0EJxzNNP/VMBlJ0cBWUgVhGWd7iRePOerC2WewqiaJwnVVibQhV02YHsl3ZIprUvihL6K3fgUw2XiuHPVNwAvXeFDt2iaSVUWRT8e/AUoVAu6NgnEK4xOnHAtb/CEzcTbFXbvzIDMfe/8bor16ZlhNLbS/kXvEkKHw8uYtvTJ1K6/7MFEwXNX4cN4zBypVS0bBCVOB4DFzrym4LyLn6ZIITGDQU037IfDiDp6IrclVeOkPGk3h4lGO9AGJ/SyRflGREEchHYmhDDdptu0yRnP8ycrBCOHInOdFOD6no7TCGwq4lT9kqM7kqFfXHtJT3PvayRIwHG2FVk12FymLQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ls7aHhWLLaRG8fNNPJX7mAUuXp+TISS6XubplGdelc=;
 b=IglW8r+VZek42s/1eBhvM19p1/vb+8BhyLAsE8dmbYfLTIa/7Ja0SURa1+CrnMqmhxhPJO1QvYFckDV3UkgHh6nqCkguQCElEBzvtV2RZv2R31gzvH4u5+/TpMcfW0USyzhhp9CBrATEpzyGY2f4Vf6KbIsuMlInrkzniqGHRiPG5HZLSDvhHDw+VSJJTlyjYWUoqfLefyWobMVmPBLHkvCP2Unm/7RcRSvuVQUUqk6EtwWfAfPdYII99AakTikMbZhO6N6CQYMIdhWys7e1hoPvhIjm1IEGRUuhS9X6wRVjD/ocDxFn893YUhLpWA7j0GeNZ2oYNQZg086KKfXBIg==
Received: from DM3PR12CA0134.namprd12.prod.outlook.com (2603:10b6:0:51::30) by
 DM5PR12MB1196.namprd12.prod.outlook.com (2603:10b6:3:74::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.15; Fri, 11 Mar 2022 14:42:40 +0000
Received: from DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:51:cafe::d7) by DM3PR12CA0134.outlook.office365.com
 (2603:10b6:0:51::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22 via Frontend
 Transport; Fri, 11 Mar 2022 14:42:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT031.mail.protection.outlook.com (10.13.172.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Fri, 11 Mar 2022 14:42:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 11 Mar
 2022 14:42:39 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 11 Mar
 2022 06:42:36 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next v2 3/3] selftests: mlxsw: hw_stats_l3: Add a new test
Date:   Fri, 11 Mar 2022 15:41:24 +0100
Message-ID: <3820ab5515e0a3d14eef11323954f7fac4f0aedf.1647009587.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1647009587.git.petrm@nvidia.com>
References: <cover.1647009587.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e96c25c-426e-4074-01c5-08da036d64f7
X-MS-TrafficTypeDiagnostic: DM5PR12MB1196:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1196D028BC197C4543D804ABD60C9@DM5PR12MB1196.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hp5M8OuEDsMUNQYa0TMxYwTXh6hS5ORSC4hwAQeNG04nA7OFmuHf5cwHk7DTaIigkBsuF4ho3PS3MFeqFnxjeQA3IPoioi1O6ROWvz+Qi2dOxppA37CwLjF2DyK88q6fR3+ZJ6hiKMExnXkhvUy7xPxTS84qvSCAjUCEs2yzabjR3Cm4pi4sf8Go7ObKmNrD0g+2ltmJQP7YlpWvxOTuThaPCuQ4EFqJRK9OpX5ABWc+DibJiQ2SbXNmYaVtHNsz2+AKD5ITswLRlNuXapXh6NaH1csyg6mcGXmsJFR2aExlvElh5ShO8IxmiSVGmARlql54M0Ku5uUTIN9/gyUGNeYhOQZNgQY2p1IntxF+cMbWcPSnkS8GhVd1lf7UW+TR43OiMNIiD0U6tHgMCBNqqqWD12X6qmSKr+dKf5SXt8mM3U2kO/hStyRs0PB2XXS28NENzKYLGTcH02SMEKR96CijYkBfo9dPixhGTF+P+UdZxMU+LGWUPiC55Ah9xOnlwmYEj8KXun14Zq0cxHH50AWsGwRHEwWwJNGXD+vIoJejCXMz0cNtKs3WrsVM6u0uVscVGOywIiarAeGKBgP9XqGuiotx1sAVk4Ajtyz8p+7q0HvQ+hPUdxfyZ2va47QIH31AsCmn2r9i5f3l6orKmXPO+BmGRLHM8ff2WBlZ74XXFuLyOCHAmHp2IHez/o7yD69k4H4I5Wwg/3bS3jKPYg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(2906002)(356005)(81166007)(316002)(426003)(5660300002)(6916009)(6666004)(36756003)(54906003)(36860700001)(86362001)(107886003)(83380400001)(186003)(26005)(2616005)(40460700003)(82310400004)(8936002)(70586007)(4326008)(70206006)(8676002)(16526019)(47076005)(336012)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 14:42:40.5480
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e96c25c-426e-4074-01c5-08da036d64f7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1196
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

