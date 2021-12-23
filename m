Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA43C47DF9B
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 08:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346850AbhLWHb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 02:31:58 -0500
Received: from mail-dm6nam12on2056.outbound.protection.outlook.com ([40.107.243.56]:28000
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242556AbhLWHb5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Dec 2021 02:31:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mSQYA8Slm1GPfKXOjpHRh0mir418TmzTLjOiQEYZ49TjJ2DhZ0BCGE0L1/jChqwHqSZhwiN0jAu+Gt1XrYXbEa7+AuPKEg1W1220mcNisXalwR4fyfmUAosVSB+dLbtWSLp5b15JgB/qesL/2X3R/LQKITuIMPoepKODjhGUXpmYunlPw3DoHonYCaXqwrPlu0o6aXnn78Z6fW32k+YjzbVWgiTykD4RWlGfuYprRSoxDc3iESnjvEABZGyH2Hi5214gOJ5cMe4fwJH5+5qrFoZypTGJPGd9qDFxzAM4zKpxTcyX2mSpVp3EjycuqQdoYaqIgufruMprZHbYkoS37g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tN8TQZnfvawZ3tXRwhZzXRm6qECE2RwxCkZE7YdDQzg=;
 b=mN3mMlTXf9tMTyB8N7t3j4/2iyykrqb8Qy+lqF35lOXEC0SLHz95Low8592caew0t/ToKXS+8LFSeSWB+nkDdgcE3j+CTDI4q7yXQLZ2NBh/IImFu2qSfMQVaXzllEvJH1j5kGRdN+GbMpGn/1tRYCgSICakYe6GY6VidB2uKzlm+9cE9fBwCPFECXYib9Wa6dtPxeVEKKyqnoy23f8LuOjyy5vvj3XMrROI0D+EfEMjkCSs7VGw4D7C1HCyZRmi8uQMCJP7JRpXj5C9dTwCIgeHivfMaMCoZxzfc70OBKhIbpB2MijJtUoFJtefgpqQUSvmPRShPdn/dISTj90BOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tN8TQZnfvawZ3tXRwhZzXRm6qECE2RwxCkZE7YdDQzg=;
 b=Jci1Svgq7eVq/KUooanQo8f3pNzpMfogbFc99VUKGhM5z4iKHzH28jFlBO924AR3tN8RDHV5C2Wvj3gHAntje7F4ao3LokELov8kAzcVGCSHiAbwmULIXYUOO+BXjqGO8yTEx5Z6jIsnirW3u7AOucQUIpIivrcSnRiZGGC5H5SW8HQZddNIZH/IsFEcPpk4KU3MlXL2TsbiG1mDBWtxx6kSkX0Z8iPpVtXPUPcWCt8+S+lccfVTnCSVQg8nTQcNEFCeKyYT0KFou0IvqnyxL/SIcIewr82uDrpZtVxRcCSrbKwweW5p571f3Zh1jdTl5tewu5qJFzsM6GpncHlMsg==
Received: from MWHPR13CA0014.namprd13.prod.outlook.com (2603:10b6:300:16::24)
 by DM5PR12MB1724.namprd12.prod.outlook.com (2603:10b6:3:10f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Thu, 23 Dec
 2021 07:31:56 +0000
Received: from CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:16:cafe::29) by MWHPR13CA0014.outlook.office365.com
 (2603:10b6:300:16::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.6 via Frontend
 Transport; Thu, 23 Dec 2021 07:31:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT028.mail.protection.outlook.com (10.13.175.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4823.18 via Frontend Transport; Thu, 23 Dec 2021 07:31:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Dec
 2021 07:31:55 +0000
Received: from dev-r-vrt-155.mtr.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Wed, 22 Dec 2021 23:31:53 -0800
From:   Amit Cohen <amcohen@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mlxsw@nvidia.com>,
        <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 4/8] selftests: mlxsw: Add VxLAN FDB veto test for IPv6
Date:   Thu, 23 Dec 2021 09:29:58 +0200
Message-ID: <20211223073002.3733510-5-amcohen@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211223073002.3733510-1-amcohen@nvidia.com>
References: <20211223073002.3733510-1-amcohen@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7fdf29a-5137-4de0-230e-08d9c5e64c58
X-MS-TrafficTypeDiagnostic: DM5PR12MB1724:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB172442A1472AACDD0254CD1DCB7E9@DM5PR12MB1724.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VayJyUlxrNEt08pqra0oFlPKuYzXPvubX0vBUVGVa4+joPeIEYntJp40Y7BW6PPH12wTHzxsjiuoAnc7CgcRQ3En9rLSF/bmu4CU66teclKu7mX8caLrNFTA8VIgIj8H/GoHPDAyFaMZ8zyR9etYrD8s1pbQDiPatY2yudi7qtWeGNE+TMkGexkcTDJv47fXGRoLqMMbsZf6gfbbtEhAskfpTCiJq6YSvM86wAuYmV4Pgw4WN4knAVsw3WevMoXQNZPGd15l3rR4phIhZ95U8Jlzl1U3OS67J2/cpixbn8RiRZmsn/EO3+2dif0RoGReVVClkuwDh3/UwGw0vmHNCkCRs1kAmK3TSkwr7D6E0DD2p+P01+/kMKAH/pxzS6pUVEZ2BFPl7vgovhEu7CNVxZ6vsKns12oA0hZ6zRdOM/lOGZ0ZD5yL4LIJC7r/OFhUezsK0wuab6l6vbGhYGtUA3buA1+QBQbb1zfN/LnxfSeDeaXDhSuSh0hsvtRbD+XIjTVwNQYUlyQfqf5yHc4hxPQQgsV1RDKA/N2IqjJWvoS/EE55mYyKdyVMuVXRcBbGyBxgIyKJ9n1D4l+bUzoeywm4TmWcgnVH62tXgWds1K0e6xuQ/R0ixzsA2rlICzWKbdC9XMzIR8ONMMjThoi27H9d3VSS0fMSVHoJBtVy4zdZknc8NmXLKtdhm5AEAhP03+Q6l04GUKccV/i0yOdfBnrj+aKDa1aPmgzNFlCxIGfheDlHr7aS1vXag0kUHYFSYUJrjntVlVIZepg5OTnFl0c1upzc8fpb0cB8nXAaJPk=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(46966006)(36840700001)(2616005)(4744005)(4326008)(8676002)(336012)(83380400001)(426003)(186003)(8936002)(1076003)(54906003)(70586007)(5660300002)(508600001)(316002)(107886003)(70206006)(36860700001)(6916009)(16526019)(26005)(86362001)(2906002)(81166007)(356005)(40460700001)(82310400004)(47076005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 07:31:56.2536
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7fdf29a-5137-4de0-230e-08d9c5e64c58
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1724
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add test to verify FDB vetos of VxLAN with IPv6 underlay.
Use the existing test which checks IPv4.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../drivers/net/mlxsw/vxlan_fdb_veto_ipv6.sh         | 12 ++++++++++++
 1 file changed, 12 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/vxlan_fdb_veto_ipv6.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/vxlan_fdb_veto_ipv6.sh b/tools/testing/selftests/drivers/net/mlxsw/vxlan_fdb_veto_ipv6.sh
new file mode 100755
index 000000000000..66c87aab86f6
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/vxlan_fdb_veto_ipv6.sh
@@ -0,0 +1,12 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# A wrapper to run VXLAN test for IPv6.
+
+LOCAL_IP=2001:db8:1::1
+REMOTE_IP_1=2001:db8:2::1
+REMOTE_IP_2=2001:db8:3::1
+UDPCSUM_FLAFS="udp6zerocsumrx udp6zerocsumtx"
+MC_IP=FF02::2
+
+source vxlan_fdb_veto.sh
-- 
2.31.1

