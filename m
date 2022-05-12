Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B41F524DF5
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 15:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350023AbiELNM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 09:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348430AbiELNM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 09:12:27 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634A22108BC
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 06:12:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f4NQNRulfxp58dHyolQBCK+YL/6ZKEoMRxd1CGIg5nO2okqOOT+9tUp4z8gtiXVwXkA04jcCcYT6n45QoJXUJdSUbVQgvNfxFQh01xoupB6qz9/um1EYjZHv+isHPjqapQvERphSwCTx+X6Q72D7WXJeJV+GgENCtmYo/TfhHl/soRt8gu6pOXd8eiE/9gIyQMWRz7yp0IUwIoeDd/D7yYNBupHuYE5BuOC49h6fxzbwG+p+nXWuBMKyuDcrBAZ/dULa1Ksn8eKkqU0SyCkr97YyJRw+DGoXQzWYeBQ4pOUlVG2FNeTsUQOxGmT4Uf4faRcMnV6CPjz/Xsu6HSOENg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ruI9lVOOW8LjKcMuqq8dmD5Z3W0lUbgZrZvlk/kav0A=;
 b=lb4sKcdGoi9665WEbN2x1yr3Qya/noE2WBzHdJ+FcWvdB4F1kVJWll8MCco4QXT52grjVoHF2N094ufjP8AWoluIPBDx8fd7jbGHLY4FHq25ZAmplTtxme48fRHYv6TRxrt6csuX/E2mhnZRk7q6+g/x6rrXT9ciz6H0r2NIoEMirTi/y+Dpax+eKgTkdZ2X4Wle6mmmawHci+J2WlDZgAF5N1oKi9jvvzyorEAvb+oYC+pPkOcKoR8gcdz51A8+N+Rvof6bUE4f8bD7Y75G9EFC9EfOBIpjq2wh8PYDoDXFxXf6/3fVsjcM+rZ4P9q1eikqoOab85GoJskkLhh/CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ruI9lVOOW8LjKcMuqq8dmD5Z3W0lUbgZrZvlk/kav0A=;
 b=G5Xg4RKRrLDlynY//WtU+ptXTDtF4bbzRCi39Y8CEmsa6QqwDhWq2XkxBJYUJOUzySJ1SOKdSG5tvyYWpim0haSzPcRXCIS13An9m4J+olGB1VSzpaI6ZZrpKJjWQu7yFIYIMPWnVXz1/Ozq2xOpo41zKT+pvBddUVc5ck/UYwoyUhbadfuJz5SjW/CpUacgCfVJxDbSTUL/v4GswDpRlgz5ooAJb6Kovh+wudaJ+nNQkwgiu/DWJ85m/pj2yuUCM35/eqb7/7KAbOTiR186O8arSiut87SIgQ7GKwr+Jr6rngcaHquaeUVw+aLx8zvhmCpK2vXev2ioW5Dq/ePNBQ==
Received: from MW4PR04CA0232.namprd04.prod.outlook.com (2603:10b6:303:87::27)
 by MN2PR12MB3728.namprd12.prod.outlook.com (2603:10b6:208:167::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Thu, 12 May
 2022 13:12:24 +0000
Received: from CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::da) by MW4PR04CA0232.outlook.office365.com
 (2603:10b6:303:87::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14 via Frontend
 Transport; Thu, 12 May 2022 13:12:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT009.mail.protection.outlook.com (10.13.175.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Thu, 12 May 2022 13:12:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 12 May
 2022 13:12:23 +0000
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 12 May 2022 06:12:20 -0700
From:   Amit Cohen <amcohen@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <shuah@kernel.org>, <mlxsw@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>
Subject: [PATCH net-next] selftests: fib_nexthops: Make the test more robust
Date:   Thu, 12 May 2022 16:12:07 +0300
Message-ID: <20220512131207.2617437-1-amcohen@nvidia.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42987747-e4c1-44b1-1bba-08da34190e1a
X-MS-TrafficTypeDiagnostic: MN2PR12MB3728:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB37288FC25DD045E32D34F2F7CBCB9@MN2PR12MB3728.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KV4WeocxkXtZDnO+NO4igrXBwZKNCpilvxhIYNPV5t5vACQkXaM69nnOw0/TYB1HCbDL2DmYKe6jTVIbRqpah4OXGzOSfPqLO/fLYXg1R9om8/+2tqZULPwGgCZDLBmoDANArhqWLPn/lzBj5Gar5pOj6HKChqXMAvlT8pe90lnt0vuzzLTnX98aYVtJ2f5APFDPzFqd1HOTsN008VsY2lYpA/P1jEEJIbUr9ebzVXpX+3BYC7DZSw9nBCcD0syYJ1lwq6tKGNyh/r8IWrNFW/6uARLf5VMO7nnh+PnY82ci+OMi74BTLmsq/ttW39cmcCQTEtUHFSkxe9c1QDUb+MGSqSCOtExCC18MwDRPQXyEX4p6sjKGixjIrKUQu75Nhtm12cG06zpspwbschD/kaK1NS9BvVRZ3W3S+1hLq4Rb4cFYhsOu0aY79Xy8uEGCnoLd3i7JJVQlMfrkREhBYfz0qB8a6UZXEEBt8HaOioef9OF6ybomPktFS1mwEuG1dDtK/RzyJIZajlVWHKpXCnfwBkRCcQF8AEn5+qqgrzogHUIR6SRos3QRrX6qV8yqe5kEmklFA8RVOWNlxaXBFlzuKGNO/Jpa4f8tga384MXefNZUPwROYQBIvTp8R3dyUJVzOZFt7GIGrXXsWDLAHfNNVAgrDUzYfRhMrIpb7N5k+BEpGwc5D0whxRbrAT/ZM4vovVA1GGthtjC+1I8+RQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(83380400001)(6666004)(26005)(5660300002)(8676002)(70206006)(4326008)(2906002)(70586007)(47076005)(8936002)(426003)(186003)(36756003)(16526019)(336012)(82310400005)(1076003)(2616005)(107886003)(508600001)(36860700001)(86362001)(81166007)(54906003)(6916009)(316002)(356005)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 13:12:24.0827
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42987747-e4c1-44b1-1bba-08da34190e1a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3728
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rarely some of the test cases fail. Make the test more robust by increasing
the timeout of ping commands to 5 seconds.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 48 ++++++++++-----------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index b3bf5319bb0e..a99ee3fb2e13 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -882,13 +882,13 @@ ipv6_fcnal_runtime()
 	log_test $? 0 "Route delete"
 
 	run_cmd "$IP ro add 2001:db8:101::1/128 nhid 81"
-	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
+	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
 	log_test $? 0 "Ping with nexthop"
 
 	run_cmd "$IP nexthop add id 82 via 2001:db8:92::2 dev veth3"
 	run_cmd "$IP nexthop add id 122 group 81/82"
 	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 122"
-	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
+	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
 	log_test $? 0 "Ping - multipath"
 
 	#
@@ -896,26 +896,26 @@ ipv6_fcnal_runtime()
 	#
 	run_cmd "$IP -6 nexthop add id 83 blackhole"
 	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 83"
-	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
+	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
 	log_test $? 2 "Ping - blackhole"
 
 	run_cmd "$IP nexthop replace id 83 via 2001:db8:91::2 dev veth1"
-	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
+	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
 	log_test $? 0 "Ping - blackhole replaced with gateway"
 
 	run_cmd "$IP -6 nexthop replace id 83 blackhole"
-	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
+	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
 	log_test $? 2 "Ping - gateway replaced by blackhole"
 
 	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 122"
-	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
+	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
 	if [ $? -eq 0 ]; then
 		run_cmd "$IP nexthop replace id 122 group 83"
-		run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
+		run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
 		log_test $? 2 "Ping - group with blackhole"
 
 		run_cmd "$IP nexthop replace id 122 group 81/82"
-		run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
+		run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
 		log_test $? 0 "Ping - group blackhole replaced with gateways"
 	else
 		log_test 2 0 "Ping - multipath failed"
@@ -1003,10 +1003,10 @@ ipv6_fcnal_runtime()
 	run_cmd "$IP nexthop add id 92 via 2001:db8:92::2 dev veth3"
 	run_cmd "$IP nexthop add id 93 group 91/92"
 	run_cmd "$IP -6 ro add default nhid 91"
-	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
+	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
 	log_test $? 0 "Nexthop with default route and rpfilter"
 	run_cmd "$IP -6 ro replace default nhid 93"
-	run_cmd "ip netns exec me ping -c1 -w1 2001:db8:101::1"
+	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
 	log_test $? 0 "Nexthop with multipath default route and rpfilter"
 
 	# TO-DO:
@@ -1460,13 +1460,13 @@ ipv4_fcnal_runtime()
 	#
 	run_cmd "$IP nexthop replace id 21 via 172.16.1.2 dev veth1"
 	run_cmd "$IP ro replace 172.16.101.1/32 nhid 21"
-	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
+	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
 	log_test $? 0 "Basic ping"
 
 	run_cmd "$IP nexthop replace id 22 via 172.16.2.2 dev veth3"
 	run_cmd "$IP nexthop add id 122 group 21/22"
 	run_cmd "$IP ro replace 172.16.101.1/32 nhid 122"
-	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
+	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
 	log_test $? 0 "Ping - multipath"
 
 	run_cmd "$IP ro delete 172.16.101.1/32 nhid 122"
@@ -1477,7 +1477,7 @@ ipv4_fcnal_runtime()
 	run_cmd "$IP nexthop add id 501 via 172.16.1.2 dev veth1"
 	run_cmd "$IP ro add default nhid 501"
 	run_cmd "$IP ro add default via 172.16.1.3 dev veth1 metric 20"
-	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
+	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
 	log_test $? 0 "Ping - multiple default routes, nh first"
 
 	# flip the order
@@ -1486,7 +1486,7 @@ ipv4_fcnal_runtime()
 	run_cmd "$IP ro add default via 172.16.1.2 dev veth1 metric 20"
 	run_cmd "$IP nexthop replace id 501 via 172.16.1.3 dev veth1"
 	run_cmd "$IP ro add default nhid 501 metric 20"
-	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
+	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
 	log_test $? 0 "Ping - multiple default routes, nh second"
 
 	run_cmd "$IP nexthop delete nhid 501"
@@ -1497,26 +1497,26 @@ ipv4_fcnal_runtime()
 	#
 	run_cmd "$IP nexthop add id 23 blackhole"
 	run_cmd "$IP ro replace 172.16.101.1/32 nhid 23"
-	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
+	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
 	log_test $? 2 "Ping - blackhole"
 
 	run_cmd "$IP nexthop replace id 23 via 172.16.1.2 dev veth1"
-	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
+	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
 	log_test $? 0 "Ping - blackhole replaced with gateway"
 
 	run_cmd "$IP nexthop replace id 23 blackhole"
-	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
+	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
 	log_test $? 2 "Ping - gateway replaced by blackhole"
 
 	run_cmd "$IP ro replace 172.16.101.1/32 nhid 122"
-	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
+	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
 	if [ $? -eq 0 ]; then
 		run_cmd "$IP nexthop replace id 122 group 23"
-		run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
+		run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
 		log_test $? 2 "Ping - group with blackhole"
 
 		run_cmd "$IP nexthop replace id 122 group 21/22"
-		run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
+		run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
 		log_test $? 0 "Ping - group blackhole replaced with gateways"
 	else
 		log_test 2 0 "Ping - multipath failed"
@@ -1543,7 +1543,7 @@ ipv4_fcnal_runtime()
 	run_cmd "$IP nexthop add id 24 via ${lladdr} dev veth1"
 	set +e
 	run_cmd "$IP ro replace 172.16.101.1/32 nhid 24"
-	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
+	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
 	log_test $? 0 "IPv6 nexthop with IPv4 route"
 
 	$IP neigh sh | grep -q "${lladdr} dev veth1"
@@ -1567,11 +1567,11 @@ ipv4_fcnal_runtime()
 
 	check_route "172.16.101.1" "172.16.101.1 nhid 101 nexthop via inet6 ${lladdr} dev veth1 weight 1 nexthop via 172.16.1.2 dev veth1 weight 1"
 
-	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
+	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
 	log_test $? 0 "IPv6 nexthop with IPv4 route"
 
 	run_cmd "$IP ro replace 172.16.101.1/32 via inet6 ${lladdr} dev veth1"
-	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
+	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
 	log_test $? 0 "IPv4 route with IPv6 gateway"
 
 	$IP neigh sh | grep -q "${lladdr} dev veth1"
@@ -1588,7 +1588,7 @@ ipv4_fcnal_runtime()
 
 	run_cmd "$IP ro del 172.16.101.1/32 via inet6 ${lladdr} dev veth1"
 	run_cmd "$IP -4 ro add default via inet6 ${lladdr} dev veth1"
-	run_cmd "ip netns exec me ping -c1 -w1 172.16.101.1"
+	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
 	log_test $? 0 "IPv4 default route with IPv6 gateway"
 
 	#
-- 
2.35.1

