Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8223F21BF7A
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgGJV5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:57:25 -0400
Received: from mail-am6eur05on2064.outbound.protection.outlook.com ([40.107.22.64]:49249
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726582AbgGJV5Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 17:57:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GHul1P1YYvxlZk1bd9/VBkzqid7C+iiiGYtLPgLpp4YnidrI+Op1g3PKPp9rb3JBaQAtWxcaRPqcSMDunszaiNTpFTHdUk1/b7yinM+dM//znvq99OqAb4qVoSA24MmzOVXE4GjNJ1vMOo71uIXHGtMtjB5Namu0IV8icZslCBOsf1Z+EUcZozmqpmGF0hCBr2taW09Y7Ma6vcmkA5NhItJIq4jbpFOKUzhYcQuIs2RCJnFONWrhqZJet6ujN7jcgDBbQKOx0bCD551QlZPvpyBSSr8i4liOG/ZkglUY8EqBvfbQUkvWQPRovK5pxD6ajJdAc0MQ5PhlY5Nspvt/YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iNWz5KW9UAs06u7qtLAri2yoNE+YxT5VAG2vhIv2A+Y=;
 b=h4Yn5ScLLhds/nGZUCTjsRITeOeU4/WvReO05q8m/fImtXADydhPTSOuf628nUmkqxVw+ide8pjXTKS3cC8Nu2wXMhFyLffyfC9dWJECs1Vcha9hn7yUgVD2tZhvX2xJ/we9XwPrrW5K94482C65VrMmbWmRmBeDChbqcM+9jvvM3KITnqgIpt9yHNd9kMvAnCY1UYPE0gbDbrDrP/SjAx3roFg/+FPgKBXH0f+YEw6unod5TiP4z4VShJXt8TxKQ24yEennD+El18pbg0928BacZ8eFpslazkf+WYxyg1l/iUpgiFKmdjAevYgxfmz/7zOpDbSCuvFxGyIdT8jJ6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iNWz5KW9UAs06u7qtLAri2yoNE+YxT5VAG2vhIv2A+Y=;
 b=cG8y6T6SY0mjVewbTA/e+Xtn5PBBO+CyVKIu25Vzj98tTRdPq7SdL9arr85wpdj47AP0SeZALuZjRkCYGWjNs5vnd7gG0AaL2h0E2iC5jO8VxqvA/UUf1OANjmTKsXG9eSDcnuLHsTXG8eYeSdtr3751aQ38wqXqhDM+wXWE39g=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3354.eurprd05.prod.outlook.com (2603:10a6:7:35::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.20; Fri, 10 Jul 2020 21:57:10 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 21:57:10 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
        kuba@kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, michael.chan@broadcom.com, saeedm@mellanox.com,
        leon@kernel.org, kadlec@netfilter.org, fw@strlen.de,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 13/13] selftests: mlxsw: RED: Test offload of mirror on RED early_drop qevent
Date:   Sat, 11 Jul 2020 00:55:15 +0300
Message-Id: <da6685a467076ad2881fec341649ece09f314ff9.1594416408.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1594416408.git.petrm@mellanox.com>
References: <cover.1594416408.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0116.eurprd07.prod.outlook.com
 (2603:10a6:207:7::26) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM3PR07CA0116.eurprd07.prod.outlook.com (2603:10a6:207:7::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.8 via Frontend Transport; Fri, 10 Jul 2020 21:57:08 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5043ef0f-312b-42d6-5445-08d8251c3234
X-MS-TrafficTypeDiagnostic: HE1PR05MB3354:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3354474EE45900D0CB176849DB650@HE1PR05MB3354.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HAIP608Dce9JkVbwAX5Kmm9xzlUCpju8DWta9OAGH21pzA7p/ig6OnB2ku6bim2NRNcH0dyDryDT0Jkng3ak+UCML4LjlBbQXCPADTD/me13G1pATE9HB77wNhWmCjLnVHyRHg9Rchmo2hH2merscpwZnWDGWAiIw2Zmqw11QAWD/mPSLASKODjYUuKcQOUWTErUu7cmS6ovt7iawyKlFvrreJdOo2wh3H6QaL5OIEo8Ozxow/3WBXrgEv/90zV/LXUZPDXfVHeubcasFsGiBbfPh1f5OlJl1xxE5lFp0TnKc2cLw06QhpcYKkb+qjMD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(956004)(86362001)(2906002)(6916009)(5660300002)(2616005)(83380400001)(54906003)(7416002)(6512007)(8676002)(107886003)(26005)(52116002)(6506007)(36756003)(66556008)(66476007)(316002)(8936002)(4326008)(478600001)(16526019)(6486002)(6666004)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 7ea97Q9Mel2Erd44IHfxyTysl7EPSG9KXyk9ZzBQDXuCgdrSYBOwcsaBdNjwCuPzmQwMRR7ycKp+Xl0n9BpJ7ZCAV6kjCzEqxpl+ph8NCm2oGoBkx4a4/mBB2mAuPUw5ftEbWCpATDM4971aq6MyWSxtUaI9+n+UN2wl7TKzIx04qZ2W3TEYTCscNAg4e/FK5uUu02Q414CK9b/Lxk8IYGry10Y6+LOEqz8CulVzn1h+sc5QnOJozv4rs8lhpM985UzhueA6VGz0Nguyk0guU9lFMwAtdcQmrYulhbKOj0kZhX/88cmjTEgckwAuH52wl8ryVsgcrmONlqXmDN8phPgblXS+nEblSoktk3Ht56enY4c4wtBrdlcsuOZGIb7F4nXS1DstaO1JjZ9fb95ESs4keKNcyaMZJ1fBzkC6HQRwdV8yvJpLEU1aSqy8pRmn67Ncw9Rdr8aVsIY+paBdoUx7BCBOTtg324qC/bAQ/uI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5043ef0f-312b-42d6-5445-08d8251c3234
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 21:57:10.7285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S3y52leSBHUqhDJd7pX1ZsqPaNT7ThAkTaRIrvDTNjT88VIBXWvX726wuVmh61rm4s2fERK8NmBz7UD7u52wuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3354
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a selftest for offloading a mirror action attached to the block
associated with RED early_drop qevent.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 .../drivers/net/mlxsw/sch_red_core.sh         | 106 +++++++++++++++++-
 .../drivers/net/mlxsw/sch_red_ets.sh          |  11 ++
 .../drivers/net/mlxsw/sch_red_root.sh         |   8 ++
 3 files changed, 122 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
index 0d347d48c112..45042105ead7 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_core.sh
@@ -121,6 +121,7 @@ h1_destroy()
 h2_create()
 {
 	host_create $h2 2
+	tc qdisc add dev $h2 clsact
 
 	# Some of the tests in this suite use multicast traffic. As this traffic
 	# enters BR2_10 resp. BR2_11, it is flooded to all other ports. Thus
@@ -141,6 +142,7 @@ h2_create()
 h2_destroy()
 {
 	ethtool -s $h2 autoneg on
+	tc qdisc del dev $h2 clsact
 	host_destroy $h2
 }
 
@@ -336,6 +338,17 @@ get_qdisc_npackets()
 		qdisc_stats_get $swp3 $(get_qdisc_handle $vlan) .packets
 }
 
+send_packets()
+{
+	local vlan=$1; shift
+	local proto=$1; shift
+	local pkts=$1; shift
+
+	$MZ $h2.$vlan -p 8000 -a own -b $h3_mac \
+	    -A $(ipaddr 2 $vlan) -B $(ipaddr 3 $vlan) \
+	    -t $proto -q -c $pkts "$@"
+}
+
 # This sends traffic in an attempt to build a backlog of $size. Returns 0 on
 # success. After 10 failed attempts it bails out and returns 1. It dumps the
 # backlog size to stdout.
@@ -364,9 +377,7 @@ build_backlog()
 			return 1
 		fi
 
-		$MZ $h2.$vlan -p 8000 -a own -b $h3_mac \
-		    -A $(ipaddr 2 $vlan) -B $(ipaddr 3 $vlan) \
-		    -t $proto -q -c $pkts "$@"
+		send_packets $vlan $proto $pkts "$@"
 	done
 }
 
@@ -531,3 +542,92 @@ do_mc_backlog_test()
 
 	log_test "TC $((vlan - 10)): Qdisc reports MC backlog"
 }
+
+do_drop_test()
+{
+	local vlan=$1; shift
+	local limit=$1; shift
+	local trigger=$1; shift
+	local subtest=$1; shift
+	local fetch_counter=$1; shift
+	local backlog
+	local base
+	local now
+	local pct
+
+	RET=0
+
+	start_traffic $h1.$vlan $(ipaddr 1 $vlan) $(ipaddr 3 $vlan) $h3_mac
+
+	# Create a bit of a backlog and observe no mirroring due to drops.
+	qevent_rule_install_$subtest
+	base=$($fetch_counter)
+
+	build_backlog $vlan $((2 * limit / 3)) udp >/dev/null
+
+	busywait 1100 until_counter_is ">= $((base + 1))" $fetch_counter >/dev/null
+	check_fail $? "Spurious packets observed without buffer pressure"
+
+	qevent_rule_uninstall_$subtest
+
+	# Push to the queue until it's at the limit. The configured limit is
+	# rounded by the qdisc and then by the driver, so this is the best we
+	# can do to get to the real limit of the system. Do this with the rules
+	# uninstalled so that the inevitable drops don't get counted.
+	build_backlog $vlan $((3 * limit / 2)) udp >/dev/null
+
+	qevent_rule_install_$subtest
+	base=$($fetch_counter)
+
+	send_packets $vlan udp 11
+
+	now=$(busywait 1100 until_counter_is ">= $((base + 10))" $fetch_counter)
+	check_err $? "Dropped packets not observed: 11 expected, $((now - base)) seen"
+
+	# When no extra traffic is injected, there should be no mirroring.
+	busywait 1100 until_counter_is ">= $((base + 20))" $fetch_counter >/dev/null
+	check_fail $? "Spurious packets observed"
+
+	# When the rule is uninstalled, there should be no mirroring.
+	qevent_rule_uninstall_$subtest
+	send_packets $vlan udp 11
+	busywait 1100 until_counter_is ">= $((base + 20))" $fetch_counter >/dev/null
+	check_fail $? "Spurious packets observed after uninstall"
+
+	log_test "TC $((vlan - 10)): ${trigger}ped packets $subtest'd"
+
+	stop_traffic
+	sleep 1
+}
+
+qevent_rule_install_mirror()
+{
+	tc filter add block 10 pref 1234 handle 102 matchall skip_sw \
+	   action mirred egress mirror dev $swp2 hw_stats disabled
+}
+
+qevent_rule_uninstall_mirror()
+{
+	tc filter del block 10 pref 1234 handle 102 matchall
+}
+
+qevent_counter_fetch_mirror()
+{
+	tc_rule_handle_stats_get "dev $h2 ingress" 101
+}
+
+do_drop_mirror_test()
+{
+	local vlan=$1; shift
+	local limit=$1; shift
+	local qevent_name=$1; shift
+
+	tc filter add dev $h2 ingress pref 1 handle 101 prot ip \
+	   flower skip_sw ip_proto udp \
+	   action drop
+
+	do_drop_test "$vlan" "$limit" "$qevent_name" mirror \
+		     qevent_counter_fetch_mirror
+
+	tc filter del dev $h2 ingress pref 1 handle 101 flower
+}
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
index 1c36c576613b..c8968b041bea 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_ets.sh
@@ -7,6 +7,7 @@ ALL_TESTS="
 	ecn_nodrop_test
 	red_test
 	mc_backlog_test
+	red_mirror_test
 "
 : ${QDISC:=ets}
 source sch_red_core.sh
@@ -83,6 +84,16 @@ mc_backlog_test()
 	uninstall_qdisc
 }
 
+red_mirror_test()
+{
+	install_qdisc qevent early_drop block 10
+
+	do_drop_mirror_test 10 $BACKLOG1 early_drop
+	do_drop_mirror_test 11 $BACKLOG2 early_drop
+
+	uninstall_qdisc
+}
+
 trap cleanup EXIT
 
 setup_prepare
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
index 558667ea11ec..ede9c38d3eff 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_red_root.sh
@@ -7,6 +7,7 @@ ALL_TESTS="
 	ecn_nodrop_test
 	red_test
 	mc_backlog_test
+	red_mirror_test
 "
 source sch_red_core.sh
 
@@ -57,6 +58,13 @@ mc_backlog_test()
 	uninstall_qdisc
 }
 
+red_mirror_test()
+{
+	install_qdisc qevent early_drop block 10
+	do_drop_mirror_test 10 $BACKLOG
+	uninstall_qdisc
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.20.1

