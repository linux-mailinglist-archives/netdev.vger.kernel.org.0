Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC84E181F94
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 18:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730576AbgCKReo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 13:34:44 -0400
Received: from mail-eopbgr60070.outbound.protection.outlook.com ([40.107.6.70]:25761
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730522AbgCKReo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 13:34:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kz4rtRUZcX+vRWCOD+E8/+79leCkyahIy3oUr+x83TjaTNFQNi7lP+Cm6d48LOFrm2owvxNQ7Rwe9AZ/RvZ/phH9xU1wFTw6M64RliLhNX68tTfI36jGYedpKcc5z4svne+5IUjZr9zduVReajhialWLIn1ZHmoe/2sUnnf624H3SvN8kI/yJuYH7UYgo5KfvPwe3jr5TB/64wG565tW8FbiFeED3t1lkXoTN+As99y5V9Do6UG8lziQbS+Z34iEEcWn/eKlYnc4NantfXJ588hCbMoEd3F3FvyW586OPo5jH9lRh1RgSd78zUNosCpdIjvW1BSLVgJXSxkPV8bGxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jgn+DdE8uGiPdRK5CydHxH89NE5L0FKGBWRNdjFDouA=;
 b=j06wO7j53jCb0KSpy1RdN4+Qm3jULTBD8f9N7FR/+IbcjN9B389vR9k48aXadsM4i3Fz5hlZg7bAponU3pMLSrLYzeM8ckWRMBT/j3Yg2KU+AWCsWOfwMFlMl925Q43qoVLT9klghC4eA/KYnTs3usU4jo888vwpNAKIGUkzuYY949NT/o6q08z1MCSwQgJy2upR/Hcs8iHDV8ZzLZb7XUIYo7SXoT0wbzV5DP01sGus0Wc+pbikiGes81TtXbU22P0q0MeHuhFbHzOLzOGUrPtmw0bYHtRiN36wLILTFHlU69ajpZOSuMK6TYApUXbolfuiM+f3vKtg20VEjwpNGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jgn+DdE8uGiPdRK5CydHxH89NE5L0FKGBWRNdjFDouA=;
 b=iKzxmCsxlQQMzUp8UULQWW1rKivVwD/VRkHK9JCwZFxouQSiqkAwtBbb/0YlEt1/z7LkXUqAUsjzatGTnDdfgNAhpMV+Apsr95jM9MZfW8V+zFyXYXI19Fw0fDChBVVZjI9iJzRtnPWva7Vu0DYJuzamgFN3WxPh6zjpC5K/ggg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3449.eurprd05.prod.outlook.com (10.170.248.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Wed, 11 Mar 2020 17:34:36 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Wed, 11 Mar 2020
 17:34:36 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 6/6] selftests: mlxsw: RED: Test RED ECN taildrop offload
Date:   Wed, 11 Mar 2020 19:33:56 +0200
Message-Id: <20200311173356.38181-7-petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200311173356.38181-1-petrm@mellanox.com>
References: <20200311173356.38181-1-petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0197.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::17) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR0P264CA0197.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Wed, 11 Mar 2020 17:34:35 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0511b397-46b5-4c52-307c-08d7c5e27817
X-MS-TrafficTypeDiagnostic: HE1PR05MB3449:|HE1PR05MB3449:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB34494CDEA82F40F34831A824DBFC0@HE1PR05MB3449.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(199004)(6506007)(186003)(107886003)(6666004)(81156014)(4326008)(81166006)(26005)(16526019)(8936002)(8676002)(2616005)(2906002)(86362001)(956004)(36756003)(6512007)(66476007)(66556008)(6486002)(6916009)(316002)(478600001)(1076003)(54906003)(52116002)(5660300002)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3449;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F81V2YtHjHFCw6mXUHAWdEo5B4FYmVqgRtiv7FWi2MmoEBbLn4qKBlPmvOCzp5l7Aw3139O/gewEAEgxPwb6R4gf/WD3W3SxVDG4lZVvT07DfixG6tFkZPvTChOEap6HQdFW9rm7W/6q0W+/s7oM3EmvzM2VC+tcGrCAm+MknDGVIA82SNtfhWtOruZamzZQnK2vZOJ1k0jhonX3nhHdB3EjrfF3H2P+SWncuYC62cnF1c827exXliCXfMGS7S7LeIXbft0zbLd423CHkS04p2Xx4okWhPtn66aY2ZZckwGGXPcAZe/z85rMjj16ye6Ylni5z2H4EFFjEZKd5306zYE+kFGkZNXaIDW376nrNMykFZNfP77t0gCBw5A1lgnaq3I3pVWJ6TJBcQDNXpAkPsKhHLpkeLaD3P8W+PIN6PGbGgvFsVf/mw7zV9XCy6VU
X-MS-Exchange-AntiSpam-MessageData: MX+9VPzdpPHbV5T5Rv/iTXXyzyIWchei4wrYNoiiXm1BbqH6NbVDpC4dRWxElP2PgfGl+/Ddweb0pc2GEf7qPaeCB7B3U6fWFupIopSxhHOKxGQwGHkKFcusLawD2aAcbtXxWeKwBBmTb1yMlamwOw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0511b397-46b5-4c52-307c-08d7c5e27817
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2020 17:34:36.6069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oFBPetOE0vK6t9AOnK8XX8QHTVOn/vThSibeju82fZQTEe5L8iFAakQhnxDdkeGPonLSu1k/E+2NZdquXsCOQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3449
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend RED testsuite to cover the new "taildropping" mode of RED-ECN. This
test is really similar to ECN test, diverging only in the last step, where
UDP traffic should go to backlog instead of being dropped. Thus extract a
common helper, ecn_test_common(), make do_ecn_test() into a relatively
simple wrapper, and add another one, do_ecn_taildrop_test().

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
---
 .../drivers/net/mlxsw/sch_red_core.sh         | 50 ++++++++++++++++---
 .../drivers/net/mlxsw/sch_red_ets.sh          | 11 ++++
 .../drivers/net/mlxsw/sch_red_root.sh         |  8 +++
 3 files changed, 61 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
index 8f833678ac4d..fc7986db3fe0 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
@@ -389,17 +389,14 @@ check_marking()
 	((pct $cond))
 }
 
-do_ecn_test()
+ecn_test_common()
 {
+	local name=$1; shift
 	local vlan=$1; shift
 	local limit=$1; shift
 	local backlog
 	local pct
 
-	# Main stream.
-	start_tcp_traffic $h1.$vlan $(ipaddr 1 $vlan) $(ipaddr 3 $vlan) \
-			  $h3_mac tos=0x01
-
 	# Build the below-the-limit backlog using UDP. We could use TCP just
 	# fine, but this way we get a proof that UDP is accepted when queue
 	# length is below the limit. The main stream is using TCP, and if the
@@ -409,7 +406,7 @@ do_ecn_test()
 	check_err $? "Could not build the requested backlog"
 	pct=$(check_marking $vlan "== 0")
 	check_err $? "backlog $backlog / $limit Got $pct% marked packets, expected == 0."
-	log_test "TC $((vlan - 10)): ECN backlog < limit"
+	log_test "TC $((vlan - 10)): $name backlog < limit"
 
 	# Now push TCP, because non-TCP traffic would be early-dropped after the
 	# backlog crosses the limit, and we want to make sure that the backlog
@@ -419,7 +416,20 @@ do_ecn_test()
 	check_err $? "Could not build the requested backlog"
 	pct=$(check_marking $vlan ">= 95")
 	check_err $? "backlog $backlog / $limit Got $pct% marked packets, expected >= 95."
-	log_test "TC $((vlan - 10)): ECN backlog > limit"
+	log_test "TC $((vlan - 10)): $name backlog > limit"
+}
+
+do_ecn_test()
+{
+	local vlan=$1; shift
+	local limit=$1; shift
+	local name=ECN
+
+	start_tcp_traffic $h1.$vlan $(ipaddr 1 $vlan) $(ipaddr 3 $vlan) \
+			  $h3_mac tos=0x01
+	sleep 1
+
+	ecn_test_common "$name" $vlan $limit
 
 	# Up there we saw that UDP gets accepted when backlog is below the
 	# limit. Now that it is above, it should all get dropped, and backlog
@@ -427,7 +437,31 @@ do_ecn_test()
 	RET=0
 	build_backlog $vlan $((2 * limit)) udp >/dev/null
 	check_fail $? "UDP traffic went into backlog instead of being early-dropped"
-	log_test "TC $((vlan - 10)): ECN backlog > limit: UDP early-dropped"
+	log_test "TC $((vlan - 10)): $name backlog > limit: UDP early-dropped"
+
+	stop_traffic
+	sleep 1
+}
+
+do_ecn_taildrop_test()
+{
+	local vlan=$1; shift
+	local limit=$1; shift
+	local name="ECN taildrop"
+
+	start_tcp_traffic $h1.$vlan $(ipaddr 1 $vlan) $(ipaddr 3 $vlan) \
+			  $h3_mac tos=0x01
+	sleep 1
+
+	ecn_test_common "$name" $vlan $limit
+
+	# Up there we saw that UDP gets accepted when backlog is below the
+	# limit. Now that it is above, in taildrop mode, make sure it goes to
+	# backlog as well.
+	RET=0
+	build_backlog $vlan $((2 * limit)) udp >/dev/null
+	check_err $? "UDP traffic was early-dropped instead of getting into backlog"
+	log_test "TC $((vlan - 10)): $name backlog > limit: UDP tail-dropped"
 
 	stop_traffic
 	sleep 1
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
index af83efe9ccf1..042a33cc13f4 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
@@ -4,6 +4,7 @@
 ALL_TESTS="
 	ping_ipv4
 	ecn_test
+	ecn_taildrop_test
 	red_test
 	mc_backlog_test
 "
@@ -50,6 +51,16 @@ ecn_test()
 	uninstall_qdisc
 }
 
+ecn_taildrop_test()
+{
+	install_qdisc ecn taildrop
+
+	do_ecn_taildrop_test 10 $BACKLOG1
+	do_ecn_taildrop_test 11 $BACKLOG2
+
+	uninstall_qdisc
+}
+
 red_test()
 {
 	install_qdisc
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
index b2217493a88e..af55672dc335 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
@@ -4,6 +4,7 @@
 ALL_TESTS="
 	ping_ipv4
 	ecn_test
+	ecn_taildrop_test
 	red_test
 	mc_backlog_test
 "
@@ -33,6 +34,13 @@ ecn_test()
 	uninstall_qdisc
 }
 
+ecn_taildrop_test()
+{
+	install_qdisc ecn taildrop
+	do_ecn_taildrop_test 10 $BACKLOG
+	uninstall_qdisc
+}
+
 red_test()
 {
 	install_qdisc
-- 
2.20.1

