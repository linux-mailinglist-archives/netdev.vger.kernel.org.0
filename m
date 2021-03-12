Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30783393EB
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 17:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbhCLQvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:51:51 -0500
Received: from mail-bn8nam12on2074.outbound.protection.outlook.com ([40.107.237.74]:48417
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232229AbhCLQvc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 11:51:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MXDB2ZiOBCwI1qp41AfJV+a1bg+T2tyunFaHw8YfxfgvRUuxnlYeLjqzZ4+8PBWoC/CutL69578rp4MJ7jZd+GjBOLB8gSlB8CHWTRfNEpgVVUenNdMPxFmcFsJdL+RY1bMWQ6rvFxvBk29zJh0Rm2X0dh9xvn05SUW0ZPyh7JlVO37BFs5yj5kzvSsDxLNSDlawFWVfQXrZN1eCYO5AybEdpwoeQKreghawH/XLFSlkbhcK+fBbRf6sZ5gC0flyTDu0XZGBHtoMDz7vSUCg7NGK1N587A2sxn80jWKNkRtEZC8OcRDIp2/y+uzCEhFvxwVGERWBXaNHa7hTfsY3VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C069V/cFhD9UxVji0wLArlnbQvZiMcpYYjVkGdn/SZM=;
 b=YDnj4+Mxx+5KIXXCEOBWyej0VProDUyiqAx9VohkGfWERfhexP1jH1i7X/UgNgxWoyzm7ds6fKcPcOnyceNbk4IHAvpPstXM0340KJ1uexItTQndy64iYvq4ilLPtY3SKHttPsHlXVxmBuMSEpssi3dWFlwImg0ZXn1slNtvPq2EInOhqEKSodVIJ8irOs4AKwtUplc3msc3rPkQjEAp4wJYJVI8D2470OqlDXYlR08Ufqk8kbU8PglcHuwzBVBgJP+/d6ZUyZfh1o4lah7m4HygY72Fssfxoz9DXAXHexvIw40ZzEUU3fRWj5NP4UZf/BplaxOeDi+d5Mx7auhPpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C069V/cFhD9UxVji0wLArlnbQvZiMcpYYjVkGdn/SZM=;
 b=G43FEfUg69YEsJ4K/Lbq3okh+GmNnfjFqeVEiGE89Ii+XyE8gPlwaFUAzXNDWw1BJx+YRw2nZlG2r/YICEzbBY78EXeK6R9yJaeacZgtMSGejsCc7+NkKnA/JddUHF3jg36+lo/Z72aE7/IOtCzI6R5QgWpb6XTug5fbi4/KUIcPQhJUcbN5J7eYXK5DxzKTnYQN4a3ouslmh1bl4iJop1f6PacAC5KDBWv0BREVdbWQK24vG/LpGUNaRIzdcFKb4Xw0Ow5KrBmRi/X6jNN5omLNVe2yd1uGTgv/8mOZlVpbbFdkH/Ek+0a5O/1ctcDqYBQfO4OpUepLO2IOg9ZXDg==
Received: from DM6PR11CA0032.namprd11.prod.outlook.com (2603:10b6:5:190::45)
 by MN2PR12MB3088.namprd12.prod.outlook.com (2603:10b6:208:c4::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Fri, 12 Mar
 2021 16:51:30 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:190:cafe::10) by DM6PR11CA0032.outlook.office365.com
 (2603:10b6:5:190::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend
 Transport; Fri, 12 Mar 2021 16:51:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Fri, 12 Mar 2021 16:51:30 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Mar
 2021 16:51:27 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 05/10] selftests: fib_nexthops: Declutter test output
Date:   Fri, 12 Mar 2021 17:50:21 +0100
Message-ID: <74fabd4da36cc447239e81e60b6b0266d3d11634.1615563035.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615563035.git.petrm@nvidia.com>
References: <cover.1615563035.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb86f086-19a4-419e-d05d-08d8e57715bf
X-MS-TrafficTypeDiagnostic: MN2PR12MB3088:
X-Microsoft-Antispam-PRVS: <MN2PR12MB308859B169B81EDE2A447985D66F9@MN2PR12MB3088.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:24;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SgbBg11f+CUMipoJTR+0cEBFNsazOEHYKmLhwVc/Z4gJras3KlKlcxERa/XwP+S1L2+jldIVus1cSKgpBhXujWprgrrDPXNV1ADmyq9i2OG2H52RnC4doMEK8ETE9/+pi7uYIDfot+8jvHqcfW9qdF7AJ+uWS0k0vn8v2j3xPkQJe/UaiVunODc96+viUjwU/n6tTecEPxbtYScUpHgxe6AfMvK9HUEi5VvuS4GVZsgcxfWNTBk+hlssylda0w4NBBw/g/4Uf0C8c5QXXbKGS67tVPhB5yOAGNZawYbkVSadz8SqxWgqhqaLME4+yn/XT+ATjfrXRn7w1kfbprUmKEMpkFbcHTRjpzd51PpG7ufAYLgnu4q8kzt61IFC5ZHcv7fM+OKL5ANQDtuEqpT6i5RoIvrZf9RfMPb7G/EqN5kGw4TvHNPvbAQajWWEDHPmKJSSWAf3jlLZRMKw3drDGBada9FwDV5SN3WrzIMgm04Mt27ZMXNRL6Ja/XXL33nrRfLQGnKMfpa9srWtCPl8XEuO0L+9XivgXtMwm8GW1YOdhpAf072MGe1iNhw0f+2TBYRVFH3L0bNIRothhDNViDtPX+dTWDhL+aZ3lcTP22eAV3mzljRQ602OhMouAkvve1JmeKK66tsPfcdw9p17Noo59Kqyj4gR7XzY0s9LoDt+UYgpCnSGe61L3CjcBqN/
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(376002)(36840700001)(46966006)(36756003)(186003)(70586007)(70206006)(16526019)(2906002)(26005)(6916009)(8936002)(4326008)(478600001)(47076005)(82740400003)(107886003)(356005)(5660300002)(82310400003)(6666004)(36860700001)(2616005)(54906003)(86362001)(336012)(34020700004)(316002)(8676002)(7636003)(36906005)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 16:51:30.0666
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fb86f086-19a4-419e-d05d-08d8e57715bf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3088
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Before:

 # ./fib_nexthops.sh -t ipv4_torture

IPv4 runtime torture
--------------------
TEST: IPv4 torture test                                             [ OK ]
./fib_nexthops.sh: line 213: 19376 Killed                  ipv4_del_add_loop1
./fib_nexthops.sh: line 213: 19377 Killed                  ipv4_grp_replace_loop
./fib_nexthops.sh: line 213: 19378 Killed                  ip netns exec me ping -f 172.16.101.1 > /dev/null 2>&1
./fib_nexthops.sh: line 213: 19380 Killed                  ip netns exec me ping -f 172.16.101.2 > /dev/null 2>&1
./fib_nexthops.sh: line 213: 19381 Killed                  ip netns exec me mausezahn veth1 -B 172.16.101.2 -A 172.16.1.1 -c 0 -t tcp "dp=1-1023, flags=syn" > /dev/null 2>&1

Tests passed:   1
Tests failed:   0

 # ./fib_nexthops.sh -t ipv6_torture

IPv6 runtime torture
--------------------
TEST: IPv6 torture test                                             [ OK ]
./fib_nexthops.sh: line 213: 24453 Killed                  ipv6_del_add_loop1
./fib_nexthops.sh: line 213: 24454 Killed                  ipv6_grp_replace_loop
./fib_nexthops.sh: line 213: 24456 Killed                  ip netns exec me ping -f 2001:db8:101::1 > /dev/null 2>&1
./fib_nexthops.sh: line 213: 24457 Killed                  ip netns exec me ping -f 2001:db8:101::2 > /dev/null 2>&1
./fib_nexthops.sh: line 213: 24458 Killed                  ip netns exec me mausezahn -6 veth1 -B 2001:db8:101::2 -A 2001:db8:91::1 -c 0 -t tcp "dp=1-1023, flags=syn" > /dev/null 2>&1

Tests passed:   1
Tests failed:   0

After:

 # ./fib_nexthops.sh -t ipv4_torture

IPv4 runtime torture
--------------------
TEST: IPv4 torture test                                             [ OK ]

Tests passed:   1
Tests failed:   0

 # ./fib_nexthops.sh -t ipv6_torture

IPv6 runtime torture
--------------------
TEST: IPv6 torture test                                             [ OK ]

Tests passed:   1
Tests failed:   0

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index d98fb85e201c..91226ac50112 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -874,6 +874,7 @@ ipv6_torture()
 
 	sleep 300
 	kill -9 $pid1 $pid2 $pid3 $pid4 $pid5
+	wait $pid1 $pid2 $pid3 $pid4 $pid5 2>/dev/null
 
 	# if we did not crash, success
 	log_test 0 0 "IPv6 torture test"
@@ -1476,6 +1477,7 @@ ipv4_torture()
 
 	sleep 300
 	kill -9 $pid1 $pid2 $pid3 $pid4 $pid5
+	wait $pid1 $pid2 $pid3 $pid4 $pid5 2>/dev/null
 
 	# if we did not crash, success
 	log_test 0 0 "IPv4 torture test"
-- 
2.26.2

