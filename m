Return-Path: <netdev+bounces-6173-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7EF4715072
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 22:21:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DA481C20895
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 20:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58F29107AF;
	Mon, 29 May 2023 20:20:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D88D309
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 20:20:22 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20609.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::609])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF193DB;
	Mon, 29 May 2023 13:20:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MHB7f4jd/b2qzicK9wgW04dNXCOTP1LEihSdiGjrkE3sysrlUg9KbbV9HnVHS6VM7muk0NMwdfe98EFzePABq5G1iN3UStb7JOeHr9dr7hzMxZZJtUJCJo6Ulo46ae7vWJlC7pTBRxBCA1JnWm7XsB142KDzNZynTFvSBqXWbMPehsAHEmFFDwsjD/u63mEdWXB5AUHwV+DWT5U1MYozgKU2ox4IU/i/ylj+M8GGE/hhKfASg25Pd9AYwNUgIA0yvkbcRWl8IpuExgpp9/MStybDpPXmFo3K0Eb8llpjOgT1zXrznRehjga+2woJd4c3PBFVOLTM+juMHA242kJEgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=846ABl4UnKETUsxN51otHM/2IY5JB2z67k5XvXod2vQ=;
 b=JM3CM4ez4E/kvPXGN7RUKaYHxuGMrXRL/vP2PnoA85kN9fFlMT9ywM+OAjZMRsM/G5YsvIEOWSyoRsTtzVZ0qr8pOBNMaXz8ZU7xQQc7O8h6XJ0UVnFE8IrhPYF6YAuPUivUO/7m4O9bhoDgYIrLCTUVwWkMACxySXZ/hUoP1cAHNOGbo+ZHQuJ+V2XV8Z18peIHHfg/D/jurO9P027sP7hAHoqfNL5uxsdTGahOEYngyHRYh1TlsSrFlCqL/s4uN3buK1OAHx/jYDh1/7/iI6El+7Dv3jFQkoxokTLUFkMV3w2pvWIeCnoda48mI3iY03dL23A9Y1A38EOyVrWhog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=846ABl4UnKETUsxN51otHM/2IY5JB2z67k5XvXod2vQ=;
 b=LSyporxoNNoMRj9mhbfdIDP0SA5gG4A0XysyaaWdwN0q+J7U2I8xeIllay/8lc6NoxE2tzkk7YgErj32ia9mMifzpLp0tge0D50AF2qll8Y08XZq1weOwpgv86gmXNzxE9Uds+oNQp9Z4XAKigZltwUY8zo6Pd4mlKt7wyD3m0NTTbaa+cwXJfCpn0cRhomdgO3hjrB4AChxsZP1pJXAQzTF6kVJ8laQTFK7K3g8BWn6U2KDJWLz7BxLNcDeGZ/FG17/TemulGDOxya+QvwkrQRYp1ClzlBdJYFBfS9D2M4tm1u4L58PrEk0DBcMPMgXzCLf+7qB3NSgne7eC2O6Hw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by IA0PR12MB8254.namprd12.prod.outlook.com (2603:10b6:208:408::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Mon, 29 May
 2023 20:20:17 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::96fe:2d5b:98bf:e1da]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::96fe:2d5b:98bf:e1da%5]) with mapi id 15.20.6433.022; Mon, 29 May 2023
 20:20:17 +0000
From: Benjamin Poirier <bpoirier@nvidia.com>
To: netdev@vger.kernel.org
Cc: David Ahern <dsahern@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/4] selftests: net: Add test cases for nexthop groups with invalid neighbors
Date: Mon, 29 May 2023 16:19:14 -0400
Message-Id: <20230529201914.69828-5-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230529201914.69828-1-bpoirier@nvidia.com>
References: <20230529201914.69828-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0149.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::22) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4373:EE_|IA0PR12MB8254:EE_
X-MS-Office365-Filtering-Correlation-Id: e11dfc89-d1f1-4464-de4e-08db60821e37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ZLa2r2Ruql+FbtOKY873uu/fcGC/m8ux77BdWeNiB7h154bmTe+GJycw8zuUw6chKgVw5ize2kHU45925fGkU9U1h9OKmvmMUlldt0JCTwa953+Sudbayx8g9vh/lRHozae6J5xp7bJ6QuXsNP/93NQ+Hf5cOZtmzdcKYOhqawZL7+lOSGH7gksqcS5O+fP0oUo+l3mfm0RM4uVOMb3Jetye4+qjr99owybruAHWIYQTdosT0ym4jbA0O1rKj0vtIV8W1E5m/QmQFGujnxyIznwVfrN26hzd1hHt2N+yMCV8k43njTqdhZ88MLL0etA4jcgX/apAw3NLStTQ5WpWT5W4uuTXtZCb90w4w/Z4ta+b2ucn8oVoLCj72ZoWsY/5s3vKcy4n/NenEEdosdNmVtUkMAkH8umpe7oRUvdBqtnf9klriTYanvljmDSHIb0iMqMQcKGtm1zmGtLlbp8MgPIsMoIY1xUxplWMWbBsWzFusJusUni4TGSoMFP4lifeUMPDxxnmnbui14c2k/8xNPe7X49x0zFGzWPLtHRnh5WTbWN0GUcJSbCoWgiuYSrn
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(451199021)(38100700002)(478600001)(2616005)(66556008)(83380400001)(66476007)(66946007)(54906003)(86362001)(4326008)(6916009)(2906002)(6666004)(6512007)(6506007)(186003)(6486002)(26005)(1076003)(316002)(41300700001)(36756003)(5660300002)(107886003)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bTGcPgpeWtcyxQk/yG5HcuudZd8hfTOUQejJvWAFJIMFIrNffYyhJdA5P1q0?=
 =?us-ascii?Q?9yzQL5T53azgcuffI+EPfEOldqnoi3kqPqWURi3KUELvxfmqqMS20dcTTNbI?=
 =?us-ascii?Q?YnUuJqizgSx63RznkHnSve4O5n7d0A9nvAeIGxxrSlh/g39mbN+OVm/hp2dU?=
 =?us-ascii?Q?zAjv5yedLLUh15zCrbhTFjGaOftRNHOo1atY1Qt8QshLvT71oPRQjJW2W1JE?=
 =?us-ascii?Q?lwpi/xqSmUUwIekOTz/FwUq+03rvXU7uAaPUXvNBuajExlhAGPIwUTY/UXAd?=
 =?us-ascii?Q?pFFlLyNAJ7tHHFdNGrw7ezjP5Helmps4iBft4nYxOzzaEFcnCOUZuZzhLwGj?=
 =?us-ascii?Q?B9+AS8wnZDPryZl1ej3miaT5ibZTcHb7dOKq4jLPQ8v5tKop3LHwI7sl2BQ1?=
 =?us-ascii?Q?348g/lJNiwPvE/K7wUc4Evf7catg6C+mWuyxKthf1jApBukhqfs1fXK3Qu8E?=
 =?us-ascii?Q?oVoGiaS9Sxsy2H+OSXEwfJPcTH+Lpym4gonHaywSCpAFB/JEWPafVwBdDKBt?=
 =?us-ascii?Q?+a5icxoCzaxvd1XPXMdj2u+w37ndgE+9Mn/pyqyGByahqE8j07GE1wGF3wwt?=
 =?us-ascii?Q?isVF1TSjWbPc4xNxTIRop0LrreH/Io8pGgj/INcNcfDcHmaw9G3sF4Zfqfah?=
 =?us-ascii?Q?OkKMVSF9d16fgfpUArj7VECTO5oCekTTdURoHJU26qPVsLzb17EOI8sqSeTS?=
 =?us-ascii?Q?WQBEmVwpIrXQGmDCbGQ43GHkGdt8B4dm9+Vve6wGxDb6Knf0TSwJ/ATFyQra?=
 =?us-ascii?Q?cFIgiwLwoWVCvDXdk5ydU/hQF/yY6vuY5TT7Z2PLnu/4FR2D8Fav0p+B8bui?=
 =?us-ascii?Q?xbtie29X4XoG2tUP5vGE90qfW4wyUcO/xeZLgIgNk5Cd7SoSGO5v/O650sp3?=
 =?us-ascii?Q?ED3z9oQtNSdhbiOkX8mJ3jVXWK+OwHBJX2+mUsrd5y0LkZAmnvDK9RQGUxyj?=
 =?us-ascii?Q?N0WxvFJVuLMpxQFbYkCxc+GotaQ6k7gnRZWCmfZCICLbqfarTP3Qf1nq2GLb?=
 =?us-ascii?Q?DgcLBo18xPqMvWPDKwwhZfPNzWMxb/XistHzg2FX47THAyPKo70XEDQcFEAK?=
 =?us-ascii?Q?fZY7J7Ap3B75+/VvXaqE8sWFGqXGESVWV+YuM7ZsuKBpoiijrbGUySpp8XK6?=
 =?us-ascii?Q?UhaTKCGq1IUlLZOTl3NkhA5BVFWXdO5130GXZMiAZ7JRPIsEFH6knKMS3AXf?=
 =?us-ascii?Q?Knofjkeynk7sYxtD5dNoliptSFJRo+V5vBpFAstuXmbfh/bG2tOdGFRyEvEk?=
 =?us-ascii?Q?0/wFj79tlxeoZ0nJPSo7nemNh7g897OyZr2UyucCpllE+5DeBbdizIdxzSLl?=
 =?us-ascii?Q?NbHd3h/qJt8bGGpvVoUp33N2uo4kRMzF0DGr+dnpwCEw0IUG9xwdcRgXyFhF?=
 =?us-ascii?Q?w/X5SN8mwvsKOSu7X2pKj7IyXXqFQCb3HoR0oMyea9ibA7bPEKCX3viPb7fK?=
 =?us-ascii?Q?14SL4IbDHpiMO7GUktrs8JHhiqGy35CsEU8FTZUSfRWVD1XFDbNCDFGdKso8?=
 =?us-ascii?Q?4XXClEDP+nhMdt3CGVc8R1wJ0yZUmDt4he724Bw0K9YQrVYDO373mRLpgE1M?=
 =?us-ascii?Q?qUBJ6nERHLkqX1/nYgRoCnokHA+ThGUmhJn0fCnp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e11dfc89-d1f1-4464-de4e-08db60821e37
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 20:20:17.3315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OXEeqT7slUq/Mi2p9YZstQ0y9OCWq5P7Xwlbq+rR+NCG6PREhk/ratP/C6zuOndkU13LJujR51AJN68OqfmrOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8254
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add test cases for hash threshold (multipath) nexthop groups with invalid
neighbors. Check that a nexthop with invalid neighbor is not selected when
there is another nexthop with a valid neighbor. Check that there is no
crash when there is no nexthop with a valid neighbor.

The first test fails before the previous commit in this series.

Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 tools/testing/selftests/net/fib_nexthops.sh | 129 ++++++++++++++++++++
 1 file changed, 129 insertions(+)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 0f5e88c8f4ff..54ec2b7b7b8c 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -29,6 +29,7 @@ IPV4_TESTS="
 	ipv4_large_res_grp
 	ipv4_compat_mode
 	ipv4_fdb_grp_fcnal
+	ipv4_mpath_select
 	ipv4_torture
 	ipv4_res_torture
 "
@@ -42,6 +43,7 @@ IPV6_TESTS="
 	ipv6_large_res_grp
 	ipv6_compat_mode
 	ipv6_fdb_grp_fcnal
+	ipv6_mpath_select
 	ipv6_torture
 	ipv6_res_torture
 "
@@ -370,6 +372,27 @@ check_large_res_grp()
 	log_test $? 0 "Dump large (x$buckets) nexthop buckets"
 }
 
+get_route_dev()
+{
+	local pfx="$1"
+	local out
+
+	if out=$($IP -j route get "$pfx" | jq -re ".[0].dev"); then
+		echo "$out"
+	fi
+}
+
+check_route_dev()
+{
+	local pfx="$1"
+	local expected="$2"
+	local out
+
+	out=$(get_route_dev "$pfx")
+
+	check_output "$out" "$expected"
+}
+
 start_ip_monitor()
 {
 	local mtype=$1
@@ -575,6 +598,112 @@ ipv4_fdb_grp_fcnal()
 	$IP link del dev vx10
 }
 
+ipv4_mpath_select()
+{
+	local rc dev match h addr
+
+	echo
+	echo "IPv4 multipath selection"
+	echo "------------------------"
+	if [ ! -x "$(command -v jq)" ]; then
+		echo "SKIP: Could not run test; need jq tool"
+		return $ksft_skip
+	fi
+
+	# Use status of existing neighbor entry when determining nexthop for
+	# multipath routes.
+	local -A gws
+	gws=([veth1]=172.16.1.2 [veth3]=172.16.2.2)
+	local -A other_dev
+	other_dev=([veth1]=veth3 [veth3]=veth1)
+
+	run_cmd "$IP nexthop add id 1 via ${gws["veth1"]} dev veth1"
+	run_cmd "$IP nexthop add id 2 via ${gws["veth3"]} dev veth3"
+	run_cmd "$IP nexthop add id 1001 group 1/2"
+	run_cmd "$IP ro add 172.16.101.0/24 nhid 1001"
+	rc=0
+	for dev in veth1 veth3; do
+		match=0
+		for h in {1..254}; do
+			addr="172.16.101.$h"
+			if [ "$(get_route_dev "$addr")" = "$dev" ]; then
+				match=1
+				break
+			fi
+		done
+		if (( match == 0 )); then
+			echo "SKIP: Did not find a route using device $dev"
+			return $ksft_skip
+		fi
+		run_cmd "$IP neigh add ${gws[$dev]} dev $dev nud failed"
+		if ! check_route_dev "$addr" "${other_dev[$dev]}"; then
+			rc=1
+			break
+		fi
+		run_cmd "$IP neigh del ${gws[$dev]} dev $dev"
+	done
+	log_test $rc 0 "Use valid neighbor during multipath selection"
+
+	run_cmd "$IP neigh add 172.16.1.2 dev veth1 nud incomplete"
+	run_cmd "$IP neigh add 172.16.2.2 dev veth3 nud incomplete"
+	run_cmd "$IP route get 172.16.101.1"
+	# if we did not crash, success
+	log_test $rc 0 "Multipath selection with no valid neighbor"
+}
+
+ipv6_mpath_select()
+{
+	local rc dev match h addr
+
+	echo
+	echo "IPv6 multipath selection"
+	echo "------------------------"
+	if [ ! -x "$(command -v jq)" ]; then
+		echo "SKIP: Could not run test; need jq tool"
+		return $ksft_skip
+	fi
+
+	# Use status of existing neighbor entry when determining nexthop for
+	# multipath routes.
+	local -A gws
+	gws=([veth1]=2001:db8:91::2 [veth3]=2001:db8:92::2)
+	local -A other_dev
+	other_dev=([veth1]=veth3 [veth3]=veth1)
+
+	run_cmd "$IP nexthop add id 1 via ${gws["veth1"]} dev veth1"
+	run_cmd "$IP nexthop add id 2 via ${gws["veth3"]} dev veth3"
+	run_cmd "$IP nexthop add id 1001 group 1/2"
+	run_cmd "$IP ro add 2001:db8:101::/64 nhid 1001"
+	rc=0
+	for dev in veth1 veth3; do
+		match=0
+		for h in {1..65535}; do
+			addr=$(printf "2001:db8:101::%x" $h)
+			if [ "$(get_route_dev "$addr")" = "$dev" ]; then
+				match=1
+				break
+			fi
+		done
+		if (( match == 0 )); then
+			echo "SKIP: Did not find a route using device $dev"
+			return $ksft_skip
+		fi
+		run_cmd "$IP neigh add ${gws[$dev]} dev $dev nud failed"
+		if ! check_route_dev "$addr" "${other_dev[$dev]}"; then
+			rc=1
+			break
+		fi
+		run_cmd "$IP neigh del ${gws[$dev]} dev $dev"
+	done
+	log_test $rc 0 "Use valid neighbor during multipath selection"
+
+	run_cmd "$IP neigh add 2001:db8:91::2 dev veth1 nud incomplete"
+	run_cmd "$IP neigh add 2001:db8:92::2 dev veth3 nud incomplete"
+	run_cmd "$IP route get 2001:db8:101::1"
+	# if we did not crash, success
+	log_test $rc 0 "Multipath selection with no valid neighbor"
+}
+
 ################################################################################
 # basic operations (add, delete, replace) on nexthops and nexthop groups
 #
-- 
2.40.1


