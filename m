Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E228416FE4
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 12:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245522AbhIXKGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 06:06:34 -0400
Received: from mail-dm6nam12on2089.outbound.protection.outlook.com ([40.107.243.89]:26081
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245408AbhIXKGd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 06:06:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j4T2U5RcEZ3AAQXcrbrdmKQqBCY4nyIdSWbZ0DXYMLg9BquYi/j3XgPEq85KS61I+gO18lH9n0OF/nW2CElVHvcqjxdKdPjqYhmKRPKsB3yxUBJUXCxqr27xNV3qx+MP1aDHopyaWYAyQuCmZ5iv3cu5PQUcmYnZS6dPCM4ee4J5HRPGJV+W9oynS9Zk5J6QkGq4j7izMolTU8GbURPkNcReJ6XRKPMq7HsrG+jH1YJIP89xx/EO409C0zKBmubTZ5EwulMiSwOCysmdAsVpMyQ+rkn9tgzFhRwuc4Yna1NG6fgtVNIo6ugwZ4/QasMmUp/Jj1iQfyKzzO8nvRB00w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=mu377Hq44MgPX25Fx0P4mwBixr0Dmx6ED7fkoGU5pFU=;
 b=DJ1Qn2fFvpNTyAx/cV87efGjaxhIrP0r27XBNE/ovCwlfLq0uIj7E64oE7eyloGkTM/4ibE7NrguNNtCaRpmnMZoEVM5hfYYBi8cvdPMRPV72mItIwfq0Z7U4HqIEi07z/8gSgh4qYu8ThPWed6dMRSpO3EFXDwqpnkorinWaD5kp1WRUEJQqpwgMolokl/UTj1W1qgek1BrY1AcmPxSISnzT5rmanlUZHP7FOuyY2vxZ9KkQZPTybZOEh6eCIU12nxZjkOvLvj4CiHHQgHT97SjphgiYrn/jflhtlPb0Z7wbopo7WkpjVE2eo3LGcYWP7el0fT4xf2+wHd0+AH33A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mu377Hq44MgPX25Fx0P4mwBixr0Dmx6ED7fkoGU5pFU=;
 b=mu3plDm8UNb3Ty4/RyhlRTN1VxlvxYha4ubWpPAKBvrPqkCiJ7mp4W65gabBKZjZmY6fGlSTQYumhsMFUhuwKSa2QalktpUYSrCYiptsqfZkMvX1bZDxTJa8nSz8vFFdPl8IjGE+g6nxR4d/SZyTleHsN6QLzYR86ClJzgrDJScSk4h9rYm14k3Ad+E/73lUrpwzsKQoZH/1N6Y8q2RsWeY3nLVkwXY10r48JQGPxhtEiU2h41PeydyGVFvIH038dIwt0SuzOTYfdfIaa2ML6RjF8UuMu8h4Eb/iwQTEjlTENj1ZdGCtoOLdj07kJHrGfklEQMcLoplb8k+zf+zUNw==
Received: from DM5PR21CA0005.namprd21.prod.outlook.com (2603:10b6:3:ac::15) by
 CH2PR12MB4134.namprd12.prod.outlook.com (2603:10b6:610:a7::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.13; Fri, 24 Sep 2021 10:05:00 +0000
Received: from DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ac:cafe::6) by DM5PR21CA0005.outlook.office365.com
 (2603:10b6:3:ac::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.4 via Frontend
 Transport; Fri, 24 Sep 2021 10:05:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT003.mail.protection.outlook.com (10.13.173.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Fri, 24 Sep 2021 10:04:59 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 24 Sep
 2021 10:04:59 +0000
Received: from localhost.localdomain (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 24 Sep
 2021 10:04:57 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next] selftests: net: fib_nexthops: Wait before checking reported idle time
Date:   Fri, 24 Sep 2021 12:04:27 +0200
Message-ID: <7e30b8e01fdfb76ff6f4e071348829e2f56767e8.1632477544.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5002a4c1-6003-48d3-8c9b-08d97f42c4d5
X-MS-TrafficTypeDiagnostic: CH2PR12MB4134:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4134A4EB01BD433C2BFA242DD6A49@CH2PR12MB4134.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sl4OJ4q3tVKCwPL3XmWx+wbMHX7cqiHb44DOrkoCqr/+clPKxYfuuKSfBKM5fcXKGPdIPHWecABUPuZLe7X+34yVjHb2HjFc7Z0WdU+/CzV1AGe/UnuiX3G6gd0/zslb32NWzejxJ/RMgOhfgxyg1ngOIyn3T0vU2cFTkrqGBc6p6By8TZsdcNIP/DKX7Gp0ZDlGVG+8nIyZI3rIpnOGCrGSNTpM5krnSOhsXArPqhkp88t5bkBQnKZpLJ2pFFFwHaPZAYAdZmiWyPybfUpDMzzkwLmLkGgSHzsnEWIZF5F3Zm+U77Skqe77Q/s96oRTOmlXRQ4HH/YT8lY90KlOtIGaLkM2VB+GvFlr0K4L2FLPUbYXQtL+liGpXmxFPc69lA7PHvC/RlhBY4FopIIs/VqHR0qmjYoV9RbFj4A/NCuk2I4JlbO54U1j2AuNh+OzhChXEmn011CnUkpcscsdhIemCtnCiyK3k55BJvcDRWIOkJeEtTBF1OFBsIAdl60CdK1ACpRAWMQ2hGFh9H8txQ6F8m8xG86GOMeVxYymc9z/g0qP/zlns61BN015xNnU02k0nCQ6JLHl4cIEkayCP8mAfw2g2GAqE7y8IX/d+uLEWmEVH4sIuf1htCUzaPci8SslsPSMRWXH1dqClqyazF92BCyzwdDhWo1FbK+4FThSsT676gQ6dgIlDKXmgJ2ySDHB5zJjuoNDcPrsgqD3Sg==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(26005)(16526019)(186003)(5660300002)(8936002)(316002)(36906005)(4326008)(54906003)(7636003)(36756003)(6666004)(2906002)(47076005)(83380400001)(107886003)(426003)(36860700001)(508600001)(8676002)(82310400003)(2616005)(6916009)(336012)(70206006)(356005)(70586007)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2021 10:04:59.5524
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5002a4c1-6003-48d3-8c9b-08d97f42c4d5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4134
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this test is to verify that after a short activity passes,
the reported time is reasonable: not zero (which could be reported by
mistake), and not something outrageous (which would be indicative of an
issue in used units).

However, the idle time is reported in units of clock_t, or hundredths of
second. If the initial sequence of commands is very quick, it is possible
that the idle time is reported as just flat-out zero. When this test was
recently enabled in our nightly regression, we started seeing spurious
failures for exactly this reason.

Therefore buffer the delay leading up to the test with a sleep, to make
sure there is no legitimate way of reporting 0.

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 0d293391e9a4..b5a69ad191b0 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -2078,6 +2078,7 @@ basic_res()
 		"id 101 index 0 nhid 2 id 101 index 1 nhid 2 id 101 index 2 nhid 1 id 101 index 3 nhid 1"
 	log_test $? 0 "Dump all nexthop buckets in a group"
 
+	sleep 0.1
 	(( $($IP -j nexthop bucket list id 101 |
 	     jq '[.[] | select(.bucket.idle_time > 0 and
 	                       .bucket.idle_time < 2)] | length') == 4 ))
-- 
2.31.1

