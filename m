Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 435B33393F0
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 17:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbhCLQw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:52:29 -0500
Received: from mail-bn8nam12on2082.outbound.protection.outlook.com ([40.107.237.82]:22913
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232666AbhCLQvu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 11:51:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uq5AlKPs6ahEYQ2ooMno6gceK5I3YkFbZoajABxSlM1Jxa2vtVfVm1XoVKLMH+khJeDKrgkvLtECXTL0xU9kR0opRnSP+Dms/zFPh+peaBChEepJX/VOg8MYVcjp6qFkxPugVUbs3P0eNMUZ7ZxBOYr0b8Z+rjQtMkmVnsrwY34aCG9MBTgTQfRW6hPdtUmWL9CiSWACLDYTCT0zvWTXWum0kNqBLCMY3KO62nFMFn6i+8S0vusUS+CMpYvBj8RRbyscnmCrNLz8kE4fk0me5xYfr/0G88YDR2XmCJGCujZze0T80pd2+StglV7qlJ2FRTwhF9Tw6RSiLEBB45/LTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RDwJ/nY47edYHe0KDOtAEiqHJboO5e+d36PkGw1+738=;
 b=dI6kD59H1uh90+GQola7IKrz90fmX2rhr2L+3zeLFOBjl4P8rn5R+WLjIZorwvlrWmEH98wWEsQEvS6w1bArrIaGxSFlkM+sijADEtXig6aZhZfUPdtDafB6MxJoJbTcMaCtg3I6AfT7MLxa8KSptCwffulTmdbQdfvgbyHzdsqsQGUt/R2lcBgmY5STLKjaIh4EufLWhoicma9ZeGO2rIfn9iVKnAgFtetXQCg4SF2c8dNqbZOu3befUJXFgz94YOTT33z+Z4RA7XQvOLumP9mMKLU+M0Q4P3QLyGKfIcmwqvjw02O3+TwZB7d7FHwUt2VTz8yhFiowE7vWCXLEDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RDwJ/nY47edYHe0KDOtAEiqHJboO5e+d36PkGw1+738=;
 b=rqEkCV8kJ3CqoqkdNSY88WiMDY4YlMqElslj22gmHyhUkdR9gxCeeQNqOSRLCz/W9HMKcjomhmq8KP/pAIp+qBXY4nGEPszHLk4x9Gb/PDF/Zp/hp+8I7gKmbPqGQEXc6Cmrw/jwo78RMmrS16p7O50MfZcTLj6hTBeehHeR6pZ7oVKIIew5kWjVV9YhTPUbgoPLEz/gypouw885MraEViXXBg8bPueiSmrw0+gTeDVcwfsCrHYZMyluNbIhFdBMoWPtFiiPN98zovNX/BPqgWgcmjR+QDjnSr2Yvc9GLBn5aZ9E2BLeJ34eyGJt/mJ6yP2MPEguJKd/TIQNNGAHAg==
Received: from DM3PR12CA0045.namprd12.prod.outlook.com (2603:10b6:0:56::13) by
 SN1PR12MB2558.namprd12.prod.outlook.com (2603:10b6:802:2b::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Fri, 12 Mar 2021 16:51:47 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:56:cafe::b8) by DM3PR12CA0045.outlook.office365.com
 (2603:10b6:0:56::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Fri, 12 Mar 2021 16:51:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Fri, 12 Mar 2021 16:51:46 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Mar
 2021 16:51:41 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 10/10] selftests: netdevsim: Add test for resilient nexthop groups offload API
Date:   Fri, 12 Mar 2021 17:50:26 +0100
Message-ID: <a195b3615166768daac20ce8fd4bd7b8887ab777.1615563035.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2073038d-8e6b-480b-0e20-08d8e5771fcb
X-MS-TrafficTypeDiagnostic: SN1PR12MB2558:
X-Microsoft-Antispam-PRVS: <SN1PR12MB2558AC906577774A0D756947D66F9@SN1PR12MB2558.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9eGZHY/QKNk1jpS2Y8xgwtrzSIWUqMpqBB6GX9cTQxunBWdp87vM7bU1RQBBLRnaaBtUJO+Ttgp2XghcN3cjIyMGnr0bRwshU0L/A1hqzg1KJUxWIir3Q2pE0Z4jfvBYuyVqVhU964XDXjXfNFAJ4gsVrFrVGhsDLWhv1PNxgVll0ecVM7jWdFyhPncFMQ/0p2Ks+5IM3juP5VeVo5CsqIG4SCInFVnQSMsAS13Mzt1vLhf0B6VuvCB2pE4UlDj8AWt0iErdU8sD3z1L39feSXeOVUgFFqn671W45khy9ogpd9WeuPnMMNv1ZXbn5rx1vmGBQh5hjM25pB7HGlqAl5IDxbwe1HMeOzN0MR0S98iuaGMBxXZ5KU6S9+nib5qy9CWP9sgShgV5NRDuGTvdwAAY+eE+H/nBre+FZKqa1gnfTXyZCEqxcH6qJ8/1fxo0byNyIfpYjOlQ6yyO9KDrt9SKvTOtLzWoWXrOQoPqF0DPp5Pi0rg1mFIF+hbvFdrll7Qz6G7jn2318KUzdFfKD9emZ7OH4GncX4RdkwtaG0S0oJB6N0sb8q77s7Drs+nQuB5z+iEU4DeYS2/EluE0X3FeyT47+fEJhvJc0bpgpnJzAnSZ72lU/R4jllk/fb/EK+B20u+8pn/yaWt8YnPPqYN+fWh8qjHrQvuZl8adDSzEvtvSIvayb6fZm/CoWEf/
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(39860400002)(36840700001)(46966006)(36906005)(426003)(316002)(54906003)(30864003)(6666004)(7636003)(34020700004)(8676002)(82310400003)(2616005)(478600001)(356005)(8936002)(36756003)(36860700001)(82740400003)(47076005)(86362001)(186003)(16526019)(26005)(5660300002)(2906002)(6916009)(336012)(83380400001)(107886003)(70586007)(70206006)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 16:51:46.9065
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2073038d-8e6b-480b-0e20-08d8e5771fcb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2558
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Test various aspects of the resilient nexthop group offload API on top
of the netdevsim implementation. Both good and bad flows are tested.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Co-developed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../drivers/net/netdevsim/nexthop.sh          | 620 ++++++++++++++++++
 1 file changed, 620 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/nexthop.sh b/tools/testing/selftests/drivers/net/netdevsim/nexthop.sh
index be0c1b5ee6b8..ba75c81cda91 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/nexthop.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/nexthop.sh
@@ -11,14 +11,33 @@ ALL_TESTS="
 	nexthop_single_add_err_test
 	nexthop_group_add_test
 	nexthop_group_add_err_test
+	nexthop_res_group_add_test
+	nexthop_res_group_add_err_test
 	nexthop_group_replace_test
 	nexthop_group_replace_err_test
+	nexthop_res_group_replace_test
+	nexthop_res_group_replace_err_test
+	nexthop_res_group_idle_timer_test
+	nexthop_res_group_idle_timer_del_test
+	nexthop_res_group_increase_idle_timer_test
+	nexthop_res_group_decrease_idle_timer_test
+	nexthop_res_group_unbalanced_timer_test
+	nexthop_res_group_unbalanced_timer_del_test
+	nexthop_res_group_no_unbalanced_timer_test
+	nexthop_res_group_short_unbalanced_timer_test
+	nexthop_res_group_increase_unbalanced_timer_test
+	nexthop_res_group_decrease_unbalanced_timer_test
+	nexthop_res_group_force_migrate_busy_test
 	nexthop_single_replace_test
 	nexthop_single_replace_err_test
 	nexthop_single_in_group_replace_test
 	nexthop_single_in_group_replace_err_test
+	nexthop_single_in_res_group_replace_test
+	nexthop_single_in_res_group_replace_err_test
 	nexthop_single_in_group_delete_test
 	nexthop_single_in_group_delete_err_test
+	nexthop_single_in_res_group_delete_test
+	nexthop_single_in_res_group_delete_err_test
 	nexthop_replay_test
 	nexthop_replay_err_test
 "
@@ -27,6 +46,7 @@ DEV_ADDR=1337
 DEV=netdevsim${DEV_ADDR}
 DEVLINK_DEV=netdevsim/${DEV}
 SYSFS_NET_DIR=/sys/bus/netdevsim/devices/$DEV/net/
+DEBUGFS_NET_DIR=/sys/kernel/debug/netdevsim/$DEV/
 NUM_NETIFS=0
 source $lib_dir/lib.sh
 source $lib_dir/devlink_lib.sh
@@ -44,6 +64,28 @@ nexthop_check()
 	return 0
 }
 
+nexthop_bucket_nhid_count_check()
+{
+	local group_id=$1; shift
+	local expected
+	local count
+	local nhid
+	local ret
+
+	while (($# > 0)); do
+		nhid=$1; shift
+		expected=$1; shift
+
+		count=$($IP nexthop bucket show id $group_id nhid $nhid |
+			grep "trap" | wc -l)
+		if ((expected != count)); then
+			return 1
+		fi
+	done
+
+	return 0
+}
+
 nexthop_resource_check()
 {
 	local expected_occ=$1; shift
@@ -159,6 +201,71 @@ nexthop_group_add_err_test()
 	nexthop_resource_set 9999
 }
 
+nexthop_res_group_add_test()
+{
+	RET=0
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+
+	$IP nexthop add id 10 group 1/2 type resilient buckets 4
+	nexthop_check "id 10" "id 10 group 1/2 type resilient buckets 4 idle_timer 120 unbalanced_timer 0 unbalanced_time 0 trap"
+	check_err $? "Unexpected nexthop group entry"
+
+	nexthop_bucket_nhid_count_check 10 1 2
+	check_err $? "Wrong nexthop buckets count"
+	nexthop_bucket_nhid_count_check 10 2 2
+	check_err $? "Wrong nexthop buckets count"
+
+	nexthop_resource_check 6
+	check_err $? "Wrong nexthop occupancy"
+
+	$IP nexthop del id 10
+	nexthop_resource_check 2
+	check_err $? "Wrong nexthop occupancy after delete"
+
+	$IP nexthop add id 10 group 1,3/2,2 type resilient buckets 5
+	nexthop_check "id 10" "id 10 group 1,3/2,2 type resilient buckets 5 idle_timer 120 unbalanced_timer 0 unbalanced_time 0 trap"
+	check_err $? "Unexpected weighted nexthop group entry"
+
+	nexthop_bucket_nhid_count_check 10 1 3
+	check_err $? "Wrong nexthop buckets count"
+	nexthop_bucket_nhid_count_check 10 2 2
+	check_err $? "Wrong nexthop buckets count"
+
+	nexthop_resource_check 7
+	check_err $? "Wrong weighted nexthop occupancy"
+
+	$IP nexthop del id 10
+	nexthop_resource_check 2
+	check_err $? "Wrong nexthop occupancy after delete"
+
+	log_test "Resilient nexthop group add and delete"
+
+	$IP nexthop flush &> /dev/null
+}
+
+nexthop_res_group_add_err_test()
+{
+	RET=0
+
+	nexthop_resource_set 2
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+
+	$IP nexthop add id 10 group 1/2 type resilient buckets 4 &> /dev/null
+	check_fail $? "Nexthop group addition succeeded when should fail"
+
+	nexthop_resource_check 2
+	check_err $? "Wrong nexthop occupancy"
+
+	log_test "Resilient nexthop group add failure"
+
+	$IP nexthop flush &> /dev/null
+	nexthop_resource_set 9999
+}
+
 nexthop_group_replace_test()
 {
 	RET=0
@@ -206,6 +313,411 @@ nexthop_group_replace_err_test()
 	nexthop_resource_set 9999
 }
 
+nexthop_res_group_replace_test()
+{
+	RET=0
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+	$IP nexthop add id 3 via 192.0.2.4 dev dummy1
+	$IP nexthop add id 10 group 1/2 type resilient buckets 6
+
+	$IP nexthop replace id 10 group 1/2/3 type resilient
+	nexthop_check "id 10" "id 10 group 1/2/3 type resilient buckets 6 idle_timer 120 unbalanced_timer 0 unbalanced_time 0 trap"
+	check_err $? "Unexpected nexthop group entry"
+
+	nexthop_bucket_nhid_count_check 10 1 2
+	check_err $? "Wrong nexthop buckets count"
+	nexthop_bucket_nhid_count_check 10 2 2
+	check_err $? "Wrong nexthop buckets count"
+	nexthop_bucket_nhid_count_check 10 3 2
+	check_err $? "Wrong nexthop buckets count"
+
+	nexthop_resource_check 9
+	check_err $? "Wrong nexthop occupancy"
+
+	log_test "Resilient nexthop group replace"
+
+	$IP nexthop flush &> /dev/null
+}
+
+nexthop_res_group_replace_err_test()
+{
+	RET=0
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+	$IP nexthop add id 3 via 192.0.2.4 dev dummy1
+	$IP nexthop add id 10 group 1/2 type resilient buckets 6
+
+	ip netns exec testns1 \
+		echo 1 > $DEBUGFS_NET_DIR/fib/fail_res_nexthop_group_replace
+	$IP nexthop replace id 10 group 1/2/3 type resilient &> /dev/null
+	check_fail $? "Nexthop group replacement succeeded when should fail"
+
+	nexthop_check "id 10" "id 10 group 1/2 type resilient buckets 6 idle_timer 120 unbalanced_timer 0 unbalanced_time 0 trap"
+	check_err $? "Unexpected nexthop group entry after failure"
+
+	nexthop_bucket_nhid_count_check 10 1 3
+	check_err $? "Wrong nexthop buckets count"
+	nexthop_bucket_nhid_count_check 10 2 3
+	check_err $? "Wrong nexthop buckets count"
+
+	nexthop_resource_check 9
+	check_err $? "Wrong nexthop occupancy after failure"
+
+	log_test "Resilient nexthop group replace failure"
+
+	$IP nexthop flush &> /dev/null
+	ip netns exec testns1 \
+		echo 0 > $DEBUGFS_NET_DIR/fib/fail_res_nexthop_group_replace
+}
+
+nexthop_res_mark_buckets_busy()
+{
+	local group_id=$1; shift
+	local nhid=$1; shift
+	local count=$1; shift
+	local index
+
+	for index in $($IP -j nexthop bucket show id $group_id nhid $nhid |
+		       jq '.[].bucket.index' | head -n ${count:--0})
+	do
+		echo $group_id $index \
+			> $DEBUGFS_NET_DIR/fib/nexthop_bucket_activity
+	done
+}
+
+nexthop_res_num_nhid_buckets()
+{
+	local group_id=$1; shift
+	local nhid=$1; shift
+
+	$IP -j nexthop bucket show id $group_id nhid $nhid | jq length
+}
+
+nexthop_res_group_idle_timer_test()
+{
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+
+	RET=0
+
+	$IP nexthop add id 10 group 1/2 type resilient buckets 8 idle_timer 4
+	nexthop_res_mark_buckets_busy 10 1
+	$IP nexthop replace id 10 group 1/2,3 type resilient
+
+	nexthop_bucket_nhid_count_check 10  1 4  2 4
+	check_err $? "Group expected to be unbalanced"
+
+	sleep 6
+
+	nexthop_bucket_nhid_count_check 10  1 2  2 6
+	check_err $? "Group expected to be balanced"
+
+	log_test "Bucket migration after idle timer"
+
+	$IP nexthop flush &> /dev/null
+}
+
+nexthop_res_group_idle_timer_del_test()
+{
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+	$IP nexthop add id 3 via 192.0.2.3 dev dummy1
+
+	RET=0
+
+	$IP nexthop add id 10 group 1,50/2,50/3,1 \
+	    type resilient buckets 8 idle_timer 6
+	nexthop_res_mark_buckets_busy 10 1
+	$IP nexthop replace id 10 group 1,50/2,150/3,1 type resilient
+
+	nexthop_bucket_nhid_count_check 10  1 4  2 4  3 0
+	check_err $? "Group expected to be unbalanced"
+
+	sleep 4
+
+	# Deletion prompts group replacement. Check that the bucket timers
+	# are kept.
+	$IP nexthop delete id 3
+
+	nexthop_bucket_nhid_count_check 10  1 4  2 4
+	check_err $? "Group expected to still be unbalanced"
+
+	sleep 4
+
+	nexthop_bucket_nhid_count_check 10  1 2  2 6
+	check_err $? "Group expected to be balanced"
+
+	log_test "Bucket migration after idle timer (with delete)"
+
+	$IP nexthop flush &> /dev/null
+}
+
+__nexthop_res_group_increase_timer_test()
+{
+	local timer=$1; shift
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+
+	RET=0
+
+	$IP nexthop add id 10 group 1/2 type resilient buckets 8 $timer 4
+	nexthop_res_mark_buckets_busy 10 1
+	$IP nexthop replace id 10 group 1/2,3 type resilient
+
+	nexthop_bucket_nhid_count_check 10 2 6
+	check_fail $? "Group expected to be unbalanced"
+
+	sleep 2
+	$IP nexthop replace id 10 group 1/2,3 type resilient $timer 8
+	sleep 4
+
+	# 6 seconds, past the original timer.
+	nexthop_bucket_nhid_count_check 10 2 6
+	check_fail $? "Group still expected to be unbalanced"
+
+	sleep 4
+
+	# 10 seconds, past the new timer.
+	nexthop_bucket_nhid_count_check 10 2 6
+	check_err $? "Group expected to be balanced"
+
+	log_test "Bucket migration after $timer increase"
+
+	$IP nexthop flush &> /dev/null
+}
+
+__nexthop_res_group_decrease_timer_test()
+{
+	local timer=$1; shift
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+
+	RET=0
+
+	$IP nexthop add id 10 group 1/2 type resilient buckets 8 $timer 8
+	nexthop_res_mark_buckets_busy 10 1
+	$IP nexthop replace id 10 group 1/2,3 type resilient
+
+	nexthop_bucket_nhid_count_check 10 2 6
+	check_fail $? "Group expected to be unbalanced"
+
+	sleep 2
+	$IP nexthop replace id 10 group 1/2,3 type resilient $timer 4
+	sleep 4
+
+	# 6 seconds, past the new timer, before the old timer.
+	nexthop_bucket_nhid_count_check 10 2 6
+	check_err $? "Group expected to be balanced"
+
+	log_test "Bucket migration after $timer decrease"
+
+	$IP nexthop flush &> /dev/null
+}
+
+__nexthop_res_group_increase_timer_del_test()
+{
+	local timer=$1; shift
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+	$IP nexthop add id 3 via 192.0.2.3 dev dummy1
+
+	RET=0
+
+	$IP nexthop add id 10 group 1,100/2,100/3,1 \
+	    type resilient buckets 8 $timer 4
+	nexthop_res_mark_buckets_busy 10 1
+	$IP nexthop replace id 10 group 1,100/2,300/3,1 type resilient
+
+	nexthop_bucket_nhid_count_check 10 2 6
+	check_fail $? "Group expected to be unbalanced"
+
+	sleep 2
+	$IP nexthop replace id 10 group 1/2,3 type resilient $timer 8
+	sleep 4
+
+	# 6 seconds, past the original timer.
+	nexthop_bucket_nhid_count_check 10 2 6
+	check_fail $? "Group still expected to be unbalanced"
+
+	sleep 4
+
+	# 10 seconds, past the new timer.
+	nexthop_bucket_nhid_count_check 10 2 6
+	check_err $? "Group expected to be balanced"
+
+	log_test "Bucket migration after $timer increase"
+
+	$IP nexthop flush &> /dev/null
+}
+
+nexthop_res_group_increase_idle_timer_test()
+{
+	__nexthop_res_group_increase_timer_test idle_timer
+}
+
+nexthop_res_group_decrease_idle_timer_test()
+{
+	__nexthop_res_group_decrease_timer_test idle_timer
+}
+
+nexthop_res_group_unbalanced_timer_test()
+{
+	local i
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+
+	RET=0
+
+	$IP nexthop add id 10 group 1/2 type resilient \
+	    buckets 8 idle_timer 6 unbalanced_timer 10
+	nexthop_res_mark_buckets_busy 10 1
+	$IP nexthop replace id 10 group 1/2,3 type resilient
+
+	for i in 1 2; do
+		sleep 4
+		nexthop_bucket_nhid_count_check 10  1 4  2 4
+		check_err $? "$i: Group expected to be unbalanced"
+		nexthop_res_mark_buckets_busy 10 1
+	done
+
+	# 3 x sleep 4 > unbalanced timer 10
+	sleep 4
+	nexthop_bucket_nhid_count_check 10  1 2  2 6
+	check_err $? "Group expected to be balanced"
+
+	log_test "Bucket migration after unbalanced timer"
+
+	$IP nexthop flush &> /dev/null
+}
+
+nexthop_res_group_unbalanced_timer_del_test()
+{
+	local i
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+	$IP nexthop add id 3 via 192.0.2.3 dev dummy1
+
+	RET=0
+
+	$IP nexthop add id 10 group 1,50/2,50/3,1 type resilient \
+	    buckets 8 idle_timer 6 unbalanced_timer 10
+	nexthop_res_mark_buckets_busy 10 1
+	$IP nexthop replace id 10 group 1,50/2,150/3,1 type resilient
+
+	# Check that NH delete does not reset unbalanced time.
+	sleep 4
+	$IP nexthop delete id 3
+	nexthop_bucket_nhid_count_check 10  1 4  2 4
+	check_err $? "1: Group expected to be unbalanced"
+	nexthop_res_mark_buckets_busy 10 1
+
+	sleep 4
+	nexthop_bucket_nhid_count_check 10  1 4  2 4
+	check_err $? "2: Group expected to be unbalanced"
+	nexthop_res_mark_buckets_busy 10 1
+
+	# 3 x sleep 4 > unbalanced timer 10
+	sleep 4
+	nexthop_bucket_nhid_count_check 10  1 2  2 6
+	check_err $? "Group expected to be balanced"
+
+	log_test "Bucket migration after unbalanced timer (with delete)"
+
+	$IP nexthop flush &> /dev/null
+}
+
+nexthop_res_group_no_unbalanced_timer_test()
+{
+	local i
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+
+	RET=0
+
+	$IP nexthop add id 10 group 1/2 type resilient buckets 8
+	nexthop_res_mark_buckets_busy 10 1
+	$IP nexthop replace id 10 group 1/2,3 type resilient
+
+	for i in $(seq 3); do
+		sleep 60
+		nexthop_bucket_nhid_count_check 10 2 6
+		check_fail $? "$i: Group expected to be unbalanced"
+		nexthop_res_mark_buckets_busy 10 1
+	done
+
+	log_test "Buckets never force-migrated without unbalanced timer"
+
+	$IP nexthop flush &> /dev/null
+}
+
+nexthop_res_group_short_unbalanced_timer_test()
+{
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+
+	RET=0
+
+	$IP nexthop add id 10 group 1/2 type resilient \
+	    buckets 8 idle_timer 120 unbalanced_timer 4
+	nexthop_res_mark_buckets_busy 10 1
+	$IP nexthop replace id 10 group 1/2,3 type resilient
+
+	nexthop_bucket_nhid_count_check 10 2 6
+	check_fail $? "Group expected to be unbalanced"
+
+	sleep 5
+
+	nexthop_bucket_nhid_count_check 10 2 6
+	check_err $? "Group expected to be balanced"
+
+	log_test "Bucket migration after unbalanced < idle timer"
+
+	$IP nexthop flush &> /dev/null
+}
+
+nexthop_res_group_increase_unbalanced_timer_test()
+{
+	__nexthop_res_group_increase_timer_test unbalanced_timer
+}
+
+nexthop_res_group_decrease_unbalanced_timer_test()
+{
+	__nexthop_res_group_decrease_timer_test unbalanced_timer
+}
+
+nexthop_res_group_force_migrate_busy_test()
+{
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+
+	RET=0
+
+	$IP nexthop add id 10 group 1/2 type resilient \
+	    buckets 8 idle_timer 120
+	nexthop_res_mark_buckets_busy 10 1
+	$IP nexthop replace id 10 group 1/2,3 type resilient
+
+	nexthop_bucket_nhid_count_check 10 2 6
+	check_fail $? "Group expected to be unbalanced"
+
+	$IP nexthop replace id 10 group 2 type resilient
+	nexthop_bucket_nhid_count_check 10 2 8
+	check_err $? "All buckets expected to have migrated"
+
+	log_test "Busy buckets force-migrated when NH removed"
+
+	$IP nexthop flush &> /dev/null
+}
+
 nexthop_single_replace_test()
 {
 	RET=0
@@ -299,6 +811,63 @@ nexthop_single_in_group_replace_err_test()
 	nexthop_resource_set 9999
 }
 
+nexthop_single_in_res_group_replace_test()
+{
+	RET=0
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+	$IP nexthop add id 10 group 1/2 type resilient buckets 4
+
+	$IP nexthop replace id 1 via 192.0.2.4 dev dummy1
+	check_err $? "Failed to replace nexthop when should not"
+
+	nexthop_check "id 10" "id 10 group 1/2 type resilient buckets 4 idle_timer 120 unbalanced_timer 0 unbalanced_time 0 trap"
+	check_err $? "Unexpected nexthop group entry"
+
+	nexthop_bucket_nhid_count_check 10  1 2  2 2
+	check_err $? "Wrong nexthop buckets count"
+
+	nexthop_resource_check 6
+	check_err $? "Wrong nexthop occupancy"
+
+	log_test "Single nexthop replace while in resilient group"
+
+	$IP nexthop flush &> /dev/null
+}
+
+nexthop_single_in_res_group_replace_err_test()
+{
+	RET=0
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+	$IP nexthop add id 10 group 1/2 type resilient buckets 4
+
+	ip netns exec testns1 \
+		echo 1 > $DEBUGFS_NET_DIR/fib/fail_nexthop_bucket_replace
+	$IP nexthop replace id 1 via 192.0.2.4 dev dummy1 &> /dev/null
+	check_fail $? "Nexthop replacement succeeded when should fail"
+
+	nexthop_check "id 1" "id 1 via 192.0.2.2 dev dummy1 scope link trap"
+	check_err $? "Unexpected nexthop entry after failure"
+
+	nexthop_check "id 10" "id 10 group 1/2 type resilient buckets 4 idle_timer 120 unbalanced_timer 0 unbalanced_time 0 trap"
+	check_err $? "Unexpected nexthop group entry after failure"
+
+	nexthop_bucket_nhid_count_check 10  1 2  2 2
+	check_err $? "Wrong nexthop buckets count"
+
+	nexthop_resource_check 6
+	check_err $? "Wrong nexthop occupancy"
+
+	log_test "Single nexthop replace while in resilient group failure"
+
+	$IP nexthop flush &> /dev/null
+	ip netns exec testns1 \
+		echo 0 > $DEBUGFS_NET_DIR/fib/fail_nexthop_bucket_replace
+}
+
 nexthop_single_in_group_delete_test()
 {
 	RET=0
@@ -346,6 +915,57 @@ nexthop_single_in_group_delete_err_test()
 	nexthop_resource_set 9999
 }
 
+nexthop_single_in_res_group_delete_test()
+{
+	RET=0
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+	$IP nexthop add id 10 group 1/2 type resilient buckets 4
+
+	$IP nexthop del id 1
+	nexthop_check "id 10" "id 10 group 2 type resilient buckets 4 idle_timer 120 unbalanced_timer 0 unbalanced_time 0 trap"
+	check_err $? "Unexpected nexthop group entry"
+
+	nexthop_bucket_nhid_count_check 10 2 4
+	check_err $? "Wrong nexthop buckets count"
+
+	nexthop_resource_check 5
+	check_err $? "Wrong nexthop occupancy"
+
+	log_test "Single nexthop delete while in resilient group"
+
+	$IP nexthop flush &> /dev/null
+}
+
+nexthop_single_in_res_group_delete_err_test()
+{
+	RET=0
+
+	$IP nexthop add id 1 via 192.0.2.2 dev dummy1
+	$IP nexthop add id 2 via 192.0.2.3 dev dummy1
+	$IP nexthop add id 3 via 192.0.2.4 dev dummy1
+	$IP nexthop add id 10 group 1/2/3 type resilient buckets 6
+
+	ip netns exec testns1 \
+		echo 1 > $DEBUGFS_NET_DIR/fib/fail_nexthop_bucket_replace
+	$IP nexthop del id 1
+
+	# We failed to replace the two nexthop buckets that were originally
+	# assigned to nhid 1.
+	nexthop_bucket_nhid_count_check 10  2 2  3 2
+	check_err $? "Wrong nexthop buckets count"
+
+	nexthop_resource_check 8
+	check_err $? "Wrong nexthop occupancy"
+
+	log_test "Single nexthop delete while in resilient group failure"
+
+	$IP nexthop flush &> /dev/null
+	ip netns exec testns1 \
+		echo 0 > $DEBUGFS_NET_DIR/fib/fail_nexthop_bucket_replace
+}
+
 nexthop_replay_test()
 {
 	RET=0
-- 
2.26.2

