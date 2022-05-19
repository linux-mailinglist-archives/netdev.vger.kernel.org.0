Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C51252CC93
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 09:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234682AbiESHKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 03:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234661AbiESHJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 03:09:57 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40924B8BFC
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 00:09:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gTnmAWGyu/N7AV+x3oGorqe/gvjxhnmL0sMy9j+5O2TriOAx3EP8fNuz1SHz8Cg3GMyDKW4+ZwvlDaHFwlXk8OgqJwDTmn6PJT6bEJgQqtAaesuG0U6Ah0XB78e0waXxCoCzhyTyVCd5dcMN1F7f+/APhmq8jbkgULvCYDDlUchFv1zHnAOCCag9UARDN6vlVPf4JqorBfqxccQhEbCC4O0rs+Hc28Nh4X9hqAuOXWE4s+ls4NZRUa0RsmivzXpdryJ8f8HMh1s/hjTL8krAu/mnnawsYhbdubiVQbsS9hCuWI/1OVl4Fz1xG1QlZLNEsnOxyDhPbtXrUGdl1SJlLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DMJVDs/9nXjs/m8Gk/s/DtH9IKxqE6lLSiH1yqw8C/A=;
 b=bYWFOCjgDFHvqInHoYKfXcqc8A0ZbAwwrlp/Q8oRnRXVbJiisZ080dEf7o6+gucbYJ62HgOFqDc5MWhjxm2atY4L6GEJBK7v9k/Vy1zTNILw9UU0X5As1IUNgJdqH6f+l3woF3eCj+bdcKhYaQRioZ/SiLUm4nMphjVAIo0ScplQPzGeO+t/1Wdvy+2xrZYs53/b12u3ZyOuYw1EOzXVsn5J0uFtzRzCy6nwQ6OEQVX4gikojyFWs6VJYSugIk2YRzvDGTbE2J0a8moj41hQyTmo7Yem6FBNjJb4L8WzEWpS3cW/g+u1qJD7r2eTOQZMmqXy5jBZgnT/blrubex75g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DMJVDs/9nXjs/m8Gk/s/DtH9IKxqE6lLSiH1yqw8C/A=;
 b=Y3sk4aREpLpLlwOitbmO8nSfxUZHxPUcZkEpsCaw1mlVJJTtBviD7ldDQX5nHa3e/qfObWa71fV+DlGfV3SBrTzY0wJZTcRZXM5VYXlkwFZLF9Lg9uNmH10idE4nn7JiEH1OKbFQklLtm6wsteB6O30JNQbTulf2/1hmHfWffhfq3+2qJAagu/AfkXHGgtibMlUIaRtBzh2ZC09GXKFH8zyIPekU6uPPy5iLUaDnEYhn6V5/YfebpByFMcD/F8wFTdNB7F+hPBw8laNKlTHV4fOpEkv8apawRnTCC6MuMt4OZM1xWHLFvanNLOafrBKdBrfZkr4/uOyYq/1fZMG62Q==
Received: from DS7PR03CA0272.namprd03.prod.outlook.com (2603:10b6:5:3ad::7) by
 CY5PR12MB6083.namprd12.prod.outlook.com (2603:10b6:930:29::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Thu, 19 May 2022 07:09:47 +0000
Received: from DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::36) by DS7PR03CA0272.outlook.office365.com
 (2603:10b6:5:3ad::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18 via Frontend
 Transport; Thu, 19 May 2022 07:09:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT067.mail.protection.outlook.com (10.13.172.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5273.14 via Frontend Transport; Thu, 19 May 2022 07:09:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 19 May
 2022 07:09:46 +0000
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 19 May 2022 00:09:43 -0700
From:   Amit Cohen <amcohen@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <shuah@kernel.org>, <dsahern@gmail.com>,
        <mlxsw@nvidia.com>, Amit Cohen <amcohen@nvidia.com>
Subject: [PATCH net-next] selftests: fib_nexthops: Make ping timeout configurable
Date:   Thu, 19 May 2022 10:09:21 +0300
Message-ID: <20220519070921.3559701-1-amcohen@nvidia.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28d8b1cc-c566-444b-4ed0-08da39668f0e
X-MS-TrafficTypeDiagnostic: CY5PR12MB6083:EE_
X-Microsoft-Antispam-PRVS: <CY5PR12MB60832AC0A276934413B3AA88CBD09@CY5PR12MB6083.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DlOSkFjAwLTUKWYxQtzls3aZ7KtKTFX+u4E6YZjVhqio2AuLpw58LJ0xcFcN6hdWT/ZCg3thRLaBhG9h82Fzd1+qcgI+dEZ6v1DPkjJWQqPmwuKxeW7cdBgHrQ3Ml2juQWOox4tGoVclSMzcjXlwV+ZOlVX8Q6r/hcfHDN4oWpPCkMcXdzdTgk8PYAGIPHDZ0wXXd4LPQpsn6/csTlphkO3Mec1JHh+BFQUwfVtAE3W2QFdTAcQI6ZegQ52VQ5EY8EtLTTokR3qceGarDeXsNZBxmEt6bIZ6nghHIvWIrJ7kaaQs7iIX69PKCVQe/6ocGRuEzWbZYI69Tvlmk6O8bYRIgoXs5bBHtk3Ckc8ztclFwASZT2kayA/A7F53ZV5Xyx5qWRLLEEJBLhG7XDIJ+odsSlxyRZhW6XjrClm3LaaFg0U2Rit0//wZFJxNQEu+92d5QfBAzX5hu21oqha3JXR1Dx4X0jbCHhSweNxLezVMhBRoG5PHD/R1RG0QLvhDEI76EerfCjKnWhUutA6EbsVY1JT+1avvVzfdH8gReC/C7QObcVeR3CyFDJQlaL2hFT8UrKf4fqzrrEYSVQKMtJ9JIEImYfjxmhcEctWMNvDqMVGze9qJmg6bWgJOQPPyIz1MQ00OEqrVQePZwEjWsWXs/Nf53s8kE1ajL7O6d+CLwKkqluK9E2OgqTFrPIlHyIqyDSliY+FPr3uc+JxIRg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(70586007)(36756003)(4326008)(70206006)(86362001)(356005)(8676002)(316002)(6916009)(54906003)(508600001)(82310400005)(5660300002)(81166007)(8936002)(6666004)(107886003)(26005)(16526019)(186003)(1076003)(2906002)(83380400001)(36860700001)(426003)(336012)(47076005)(2616005)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 07:09:47.3686
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28d8b1cc-c566-444b-4ed0-08da39668f0e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6083
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 49bb39bddad2 ("selftests: fib_nexthops: Make the test more robust")
increased the timeout of ping commands to 5 seconds, to make the test
more robust. Make the timeout configurable using '-w' argument to allow
user to change it depending on the system that runs the test. Some systems
suffer from slow forwarding performance, so they may need to change the
timeout.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 53 +++++++++++----------
 1 file changed, 28 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index a99ee3fb2e13..d5a0dd548989 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -56,6 +56,7 @@ TESTS="${ALL_TESTS}"
 VERBOSE=0
 PAUSE_ON_FAIL=no
 PAUSE=no
+PING_TIMEOUT=5
 
 nsid=100
 
@@ -882,13 +883,13 @@ ipv6_fcnal_runtime()
 	log_test $? 0 "Route delete"
 
 	run_cmd "$IP ro add 2001:db8:101::1/128 nhid 81"
-	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
+	run_cmd "ip netns exec me ping -c1 -w$PING_TIMEOUT 2001:db8:101::1"
 	log_test $? 0 "Ping with nexthop"
 
 	run_cmd "$IP nexthop add id 82 via 2001:db8:92::2 dev veth3"
 	run_cmd "$IP nexthop add id 122 group 81/82"
 	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 122"
-	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
+	run_cmd "ip netns exec me ping -c1 -w$PING_TIMEOUT 2001:db8:101::1"
 	log_test $? 0 "Ping - multipath"
 
 	#
@@ -896,26 +897,26 @@ ipv6_fcnal_runtime()
 	#
 	run_cmd "$IP -6 nexthop add id 83 blackhole"
 	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 83"
-	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
+	run_cmd "ip netns exec me ping -c1 -w$PING_TIMEOUT 2001:db8:101::1"
 	log_test $? 2 "Ping - blackhole"
 
 	run_cmd "$IP nexthop replace id 83 via 2001:db8:91::2 dev veth1"
-	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
+	run_cmd "ip netns exec me ping -c1 -w$PING_TIMEOUT 2001:db8:101::1"
 	log_test $? 0 "Ping - blackhole replaced with gateway"
 
 	run_cmd "$IP -6 nexthop replace id 83 blackhole"
-	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
+	run_cmd "ip netns exec me ping -c1 -w$PING_TIMEOUT 2001:db8:101::1"
 	log_test $? 2 "Ping - gateway replaced by blackhole"
 
 	run_cmd "$IP ro replace 2001:db8:101::1/128 nhid 122"
-	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
+	run_cmd "ip netns exec me ping -c1 -w$PING_TIMEOUT 2001:db8:101::1"
 	if [ $? -eq 0 ]; then
 		run_cmd "$IP nexthop replace id 122 group 83"
-		run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
+		run_cmd "ip netns exec me ping -c1 -w$PING_TIMEOUT 2001:db8:101::1"
 		log_test $? 2 "Ping - group with blackhole"
 
 		run_cmd "$IP nexthop replace id 122 group 81/82"
-		run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
+		run_cmd "ip netns exec me ping -c1 -w$PING_TIMEOUT 2001:db8:101::1"
 		log_test $? 0 "Ping - group blackhole replaced with gateways"
 	else
 		log_test 2 0 "Ping - multipath failed"
@@ -1003,10 +1004,10 @@ ipv6_fcnal_runtime()
 	run_cmd "$IP nexthop add id 92 via 2001:db8:92::2 dev veth3"
 	run_cmd "$IP nexthop add id 93 group 91/92"
 	run_cmd "$IP -6 ro add default nhid 91"
-	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
+	run_cmd "ip netns exec me ping -c1 -w$PING_TIMEOUT 2001:db8:101::1"
 	log_test $? 0 "Nexthop with default route and rpfilter"
 	run_cmd "$IP -6 ro replace default nhid 93"
-	run_cmd "ip netns exec me ping -c1 -w5 2001:db8:101::1"
+	run_cmd "ip netns exec me ping -c1 -w$PING_TIMEOUT 2001:db8:101::1"
 	log_test $? 0 "Nexthop with multipath default route and rpfilter"
 
 	# TO-DO:
@@ -1460,13 +1461,13 @@ ipv4_fcnal_runtime()
 	#
 	run_cmd "$IP nexthop replace id 21 via 172.16.1.2 dev veth1"
 	run_cmd "$IP ro replace 172.16.101.1/32 nhid 21"
-	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
+	run_cmd "ip netns exec me ping -c1 -w$PING_TIMEOUT 172.16.101.1"
 	log_test $? 0 "Basic ping"
 
 	run_cmd "$IP nexthop replace id 22 via 172.16.2.2 dev veth3"
 	run_cmd "$IP nexthop add id 122 group 21/22"
 	run_cmd "$IP ro replace 172.16.101.1/32 nhid 122"
-	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
+	run_cmd "ip netns exec me ping -c1 -w$PING_TIMEOUT 172.16.101.1"
 	log_test $? 0 "Ping - multipath"
 
 	run_cmd "$IP ro delete 172.16.101.1/32 nhid 122"
@@ -1477,7 +1478,7 @@ ipv4_fcnal_runtime()
 	run_cmd "$IP nexthop add id 501 via 172.16.1.2 dev veth1"
 	run_cmd "$IP ro add default nhid 501"
 	run_cmd "$IP ro add default via 172.16.1.3 dev veth1 metric 20"
-	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
+	run_cmd "ip netns exec me ping -c1 -w$PING_TIMEOUT 172.16.101.1"
 	log_test $? 0 "Ping - multiple default routes, nh first"
 
 	# flip the order
@@ -1486,7 +1487,7 @@ ipv4_fcnal_runtime()
 	run_cmd "$IP ro add default via 172.16.1.2 dev veth1 metric 20"
 	run_cmd "$IP nexthop replace id 501 via 172.16.1.3 dev veth1"
 	run_cmd "$IP ro add default nhid 501 metric 20"
-	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
+	run_cmd "ip netns exec me ping -c1 -w$PING_TIMEOUT 172.16.101.1"
 	log_test $? 0 "Ping - multiple default routes, nh second"
 
 	run_cmd "$IP nexthop delete nhid 501"
@@ -1497,26 +1498,26 @@ ipv4_fcnal_runtime()
 	#
 	run_cmd "$IP nexthop add id 23 blackhole"
 	run_cmd "$IP ro replace 172.16.101.1/32 nhid 23"
-	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
+	run_cmd "ip netns exec me ping -c1 -w$PING_TIMEOUT 172.16.101.1"
 	log_test $? 2 "Ping - blackhole"
 
 	run_cmd "$IP nexthop replace id 23 via 172.16.1.2 dev veth1"
-	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
+	run_cmd "ip netns exec me ping -c1 -w$PING_TIMEOUT 172.16.101.1"
 	log_test $? 0 "Ping - blackhole replaced with gateway"
 
 	run_cmd "$IP nexthop replace id 23 blackhole"
-	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
+	run_cmd "ip netns exec me ping -c1 -w$PING_TIMEOUT 172.16.101.1"
 	log_test $? 2 "Ping - gateway replaced by blackhole"
 
 	run_cmd "$IP ro replace 172.16.101.1/32 nhid 122"
-	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
+	run_cmd "ip netns exec me ping -c1 -w$PING_TIMEOUT 172.16.101.1"
 	if [ $? -eq 0 ]; then
 		run_cmd "$IP nexthop replace id 122 group 23"
-		run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
+		run_cmd "ip netns exec me ping -c1 -w$PING_TIMEOUT 172.16.101.1"
 		log_test $? 2 "Ping - group with blackhole"
 
 		run_cmd "$IP nexthop replace id 122 group 21/22"
-		run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
+		run_cmd "ip netns exec me ping -c1 -w$PING_TIMEOUT 172.16.101.1"
 		log_test $? 0 "Ping - group blackhole replaced with gateways"
 	else
 		log_test 2 0 "Ping - multipath failed"
@@ -1543,7 +1544,7 @@ ipv4_fcnal_runtime()
 	run_cmd "$IP nexthop add id 24 via ${lladdr} dev veth1"
 	set +e
 	run_cmd "$IP ro replace 172.16.101.1/32 nhid 24"
-	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
+	run_cmd "ip netns exec me ping -c1 -w$PING_TIMEOUT 172.16.101.1"
 	log_test $? 0 "IPv6 nexthop with IPv4 route"
 
 	$IP neigh sh | grep -q "${lladdr} dev veth1"
@@ -1567,11 +1568,11 @@ ipv4_fcnal_runtime()
 
 	check_route "172.16.101.1" "172.16.101.1 nhid 101 nexthop via inet6 ${lladdr} dev veth1 weight 1 nexthop via 172.16.1.2 dev veth1 weight 1"
 
-	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
+	run_cmd "ip netns exec me ping -c1 -w$PING_TIMEOUT 172.16.101.1"
 	log_test $? 0 "IPv6 nexthop with IPv4 route"
 
 	run_cmd "$IP ro replace 172.16.101.1/32 via inet6 ${lladdr} dev veth1"
-	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
+	run_cmd "ip netns exec me ping -c1 -w$PING_TIMEOUT 172.16.101.1"
 	log_test $? 0 "IPv4 route with IPv6 gateway"
 
 	$IP neigh sh | grep -q "${lladdr} dev veth1"
@@ -1588,7 +1589,7 @@ ipv4_fcnal_runtime()
 
 	run_cmd "$IP ro del 172.16.101.1/32 via inet6 ${lladdr} dev veth1"
 	run_cmd "$IP -4 ro add default via inet6 ${lladdr} dev veth1"
-	run_cmd "ip netns exec me ping -c1 -w5 172.16.101.1"
+	run_cmd "ip netns exec me ping -c1 -w$PING_TIMEOUT 172.16.101.1"
 	log_test $? 0 "IPv4 default route with IPv6 gateway"
 
 	#
@@ -2253,6 +2254,7 @@ usage: ${0##*/} OPTS
         -p          Pause on fail
         -P          Pause after each test before cleanup
         -v          verbose mode (show commands and output)
+	-w	    Timeout for ping
 
     Runtime test
 	-n num	    Number of nexthops to target
@@ -2265,7 +2267,7 @@ EOF
 ################################################################################
 # main
 
-while getopts :t:pP46hv o
+while getopts :t:pP46hv:w: o
 do
 	case $o in
 		t) TESTS=$OPTARG;;
@@ -2274,6 +2276,7 @@ do
 		p) PAUSE_ON_FAIL=yes;;
 		P) PAUSE=yes;;
 		v) VERBOSE=$(($VERBOSE + 1));;
+		w) PING_TIMEOUT=$OPTARG;;
 		h) usage; exit 0;;
 		*) usage; exit 1;;
 	esac
-- 
2.35.1

