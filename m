Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B108A47DF99
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 08:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242569AbhLWHa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 02:30:28 -0500
Received: from mail-mw2nam10on2073.outbound.protection.outlook.com ([40.107.94.73]:6837
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231742AbhLWHa1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Dec 2021 02:30:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JO/g9x74bCI/LMoGEA8mmsyhCwIYeK4f8QsbCtG5FoFjQZMzxcntcurdAhDpkREDv5LzmQAHEGtpVkKKG1NeCBGkn3Q3hflZenNzhyCICzxY5Ot64TY3im7JO8B2XCN1rVq+evtJtd5RqkKd8YG2KrtscRDTzJv2n1EzFYVt8HulDBUN1cdfog7EoGaY8L9RRnaf3NhBq+FrUSjl4XffmKZknpV8FZt5A7mKEvhyqr/5KzCxQAtSUL6bM3tZsCpn6lPeNw/K+hpZlNC3Q4IN/9ruwbXHcjdpHVx5X1t+EjfJauSjYYGqTZZJdKbj/ivs48vUDXLlhbC3yBbjS32iLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N+v4Xib/AEYtDl55U/Aj8NpHIT05KfWNEie0X5OE3bE=;
 b=YMXxT9Gzh7F2/z/5c3e47tujhMryY+4kgl15zI878rUW0HCX1EVZziqbWntcCJeV4gAFZLhzfk2F3iK6xiwRGA4GM7J+oMIgH7k4jPZYvqQj9TDQ/VOy+qONlEhUF/OUr9DqhRJ1u5rlRozRR24J0D4LVCQFkPuR79MGIyLZ+qj8N0o7Nsp9uXHNXEfJq+OXfMVJY3lfnpUNQI+o7Fj35wRAtfmi0ls745Ho7cuydDukf5z25dmqwHnuBTGmpjDsXO6oH+asy8/6Liy2WKKSCHBYq6d7I9uEEf2SKRTbkIYv3K4NlmPbPuN3qlcdFG3iJbPPV/M9IdvVSrpZuMHIuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N+v4Xib/AEYtDl55U/Aj8NpHIT05KfWNEie0X5OE3bE=;
 b=Esi4Pfi527WHGya4PYiqN1DgkJ8In/KmeHBFuKn/o+C3QQMovbe7ODnNnUiw+/yIFNJMFu8zsRD3RHnmJwSvwPJAT0Q30tRVKK3t4/SIGTNqqTfP0SaLItiZHM+h80gRuBudFa05FNMiDG6+o3OCRhuZNl6kFwKog0btinttUKpRSJWDniwCJor2qCfs7v4eApz1GT6pWpse6NcVDBqLBcG9qmul87VIJ2ctR3s0VusryHXuiS9ihBDdl4a/7qe5vgzIAB3ijddkh2AwOKb/qehhvLvpzA5oN2ORyPmAQ3PTzU9bhtlwQf6SFwZmEfoZblL4zehL6l2KFWuk91NW6w==
Received: from DM6PR02CA0141.namprd02.prod.outlook.com (2603:10b6:5:332::8) by
 BY5PR12MB4307.namprd12.prod.outlook.com (2603:10b6:a03:20c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.16; Thu, 23 Dec
 2021 07:30:23 +0000
Received: from DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::9c) by DM6PR02CA0141.outlook.office365.com
 (2603:10b6:5:332::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19 via Frontend
 Transport; Thu, 23 Dec 2021 07:30:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT018.mail.protection.outlook.com (10.13.172.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4823.18 via Frontend Transport; Thu, 23 Dec 2021 07:30:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Dec
 2021 07:30:22 +0000
Received: from dev-r-vrt-155.mtr.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Wed, 22 Dec 2021 23:30:20 -0800
From:   Amit Cohen <amcohen@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mlxsw@nvidia.com>,
        <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 2/8] selftests: mlxsw: Add VxLAN configuration test for IPv6
Date:   Thu, 23 Dec 2021 09:29:56 +0200
Message-ID: <20211223073002.3733510-3-amcohen@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: a510dab2-48bd-44d6-c859-08d9c5e61526
X-MS-TrafficTypeDiagnostic: BY5PR12MB4307:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4307218B49E5EEF3BE40D3D2CB7E9@BY5PR12MB4307.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nq+iDai6dbro7RBmkktXWjrM0PK1jVxWVr9mdlee779/MnFSI8BPEeyZ1hgQmBnMbQ6/0SxtYO8b5jeFBdPGsZs0n/hCmT9ZXgyuQHnr7ICz6utyVepWt7mMMmajb0ZHXVbdPvCfP4gZMcepXNDBDiCJjQQIEFVlispkCNF0z8/cPf0mCZsML8LS7BjsmgkmGAoHrzdcCiLnxMa1oGvgFvBQUThFecBwSKQdxsWgGqTd//jcGjb2zfUjD39Vm90dKEtb2y4y9UfvsGM2Aj+1X1xVRT1gjOIs08U5uQNJ70Iz5r1BVWKpdf0+QVKZm5Y1y2MDZ7c8Rq0WD/lRZNdN2NjxpHIRSLsGACm8tVGcdbIT544cS8/FB+glTxfD9srM3MQgZLBpkHZdUx1R780WIIXQfma6GCSD4su8GXM/BMi5j0fXqQzOhv2QnB6LPO/th+JbwoGX1Pm024S5TqrwZgyFCsD0bnGFhGyrXx+1dk1QS59J62d8ofyETFkCXLIHcWEiKND9nbaI3sZMSbv13KNhOp0zeoz3OKUIsq0Cs4gqR7dSKuPN5aqqexOUnGaZz6hIVejau5MdgLJzulBuWHB77R29BJ/Ch3OcfEF9Jf+rJ0DIqDYfeo5YPuJTCgKhgCOv5MkdJhEk0NfQ3IQwreIJ0mRf4uyE96+aHOHCva2rSSJsCuibjHjUJI/zcPkavvjxOhPIqahSqPE+q99Jd50FZxvOv2OoeO555HyDYDMNfGkpdtdRwhPQO6hCGQPrvoziCqsojEPKUzUPE8s10UbsQMzIeXBFpcufCMbxCx0=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(40470700002)(46966006)(36860700001)(82310400004)(4326008)(86362001)(6916009)(6666004)(2906002)(83380400001)(316002)(508600001)(16526019)(2616005)(70586007)(8676002)(40460700001)(70206006)(36756003)(8936002)(54906003)(81166007)(426003)(107886003)(26005)(5660300002)(1076003)(47076005)(186003)(356005)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 07:30:23.6242
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a510dab2-48bd-44d6-c859-08d9c5e61526
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4307
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add test to verify configuration of VxLAN with IPv6 underlay.
Use the existing test which checks IPv4.

Add separated test cases for learning which is not supported for IPv6
and for UDP checksum flags which are different from IPv4 flags.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/vxlan_ipv6.sh | 65 +++++++++++++++++++
 1 file changed, 65 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/vxlan_ipv6.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/vxlan_ipv6.sh b/tools/testing/selftests/drivers/net/mlxsw/vxlan_ipv6.sh
new file mode 100755
index 000000000000..f2ea0163ddea
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/vxlan_ipv6.sh
@@ -0,0 +1,65 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# A wrapper to run VXLAN test for IPv6.
+
+ADDR_FAMILY=ipv6
+LOCAL_IP_1=2001:db8:1::1
+LOCAL_IP_2=2001:db8:1::2
+PREFIX_LEN=128
+UDPCSUM_FLAFS="udp6zerocsumrx udp6zerocsumtx"
+MC_IP=FF02::2
+IP_FLAG="-6"
+
+ALL_TESTS="
+	sanitization_test
+	offload_indication_test
+	sanitization_vlan_aware_test
+	offload_indication_vlan_aware_test
+"
+
+sanitization_single_dev_learning_enabled_ipv6_test()
+{
+	RET=0
+
+	ip link add dev br0 type bridge mcast_snooping 0
+
+	ip link add name vxlan0 up type vxlan id 10 learning $UDPCSUM_FLAFS \
+		ttl 20 tos inherit local $LOCAL_IP_1 dstport 4789
+
+	sanitization_single_dev_test_fail
+
+	ip link del dev vxlan0
+	ip link del dev br0
+
+	log_test "vxlan device with learning enabled"
+}
+
+sanitization_single_dev_udp_checksum_ipv6_test()
+{
+	RET=0
+
+	ip link add dev br0 type bridge mcast_snooping 0
+
+	ip link add name vxlan0 up type vxlan id 10 nolearning \
+		noudp6zerocsumrx udp6zerocsumtx ttl 20 tos inherit \
+		local $LOCAL_IP_1 dstport 4789
+
+	sanitization_single_dev_test_fail
+	log_test "vxlan device without zero udp checksum at RX"
+
+	ip link del dev vxlan0
+
+	ip link add name vxlan0 up type vxlan id 10 nolearning \
+		udp6zerocsumrx noudp6zerocsumtx ttl 20 tos inherit \
+		local $LOCAL_IP_1 dstport 4789
+
+	sanitization_single_dev_test_fail
+	log_test "vxlan device without zero udp checksum at TX"
+
+	ip link del dev vxlan0
+	ip link del dev br0
+
+}
+
+source vxlan.sh
-- 
2.31.1

