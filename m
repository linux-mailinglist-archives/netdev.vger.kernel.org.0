Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA3E14D4E44
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 17:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241143AbiCJQOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 11:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241054AbiCJQOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 11:14:35 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20D0EB16D
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 08:13:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NMy6WeRItOctB+9yRW5zlXh9ZDhk/wK/damzleWHtqxMYqh+kdNJj8s2QrhjckTjPZZon80GYK52a3fU8JRcQXwmSBl6pZTw/3aDdAwwCa/YXnCJFywfx3S3EVOwC/wUxLakut/b46JtxwAT0WpKz+jnbbtrzbLzP3dMdLp4rRp2n3hC/7dBuwewt7U/ByRvJmowh5o9onQ6hYpwc8XFLYh1lOmwiSaN2gBWuvLNNYt26WupKixQ6pGRAbaBWfKxrgc7B9XUw0AuPo4WHmGtA19zmBObxIzspJmd4zbcG7d976NfWfSAuMHOm3zF8NBUpIvbYDzXXqMucL8lbInZdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w4P45vVr9CRRhKdkQmVGGVRjnr6vBabhL6PCAEtrcBk=;
 b=FzflMrA791pPWB4ndv7XxVHHQEd18Eq+gCm5MdJpl5/CmFuftdniA7t1eojRE/BKkU76Z6CcUyiLXzg/o9z1eFCk8N1bxegLjpcE8k7qQzT4yaMSA1NVs8y/MdcMONefP3HbuefwNdyhHHDMBAdZ8/EEVKvj+Lc5xP2dZ1ItWyLQ53DknR+ROd7PHjmkY29g2S2YTBRMxNJzDcplCsmHDQtwSPzRLgl9vm5ndyT/03SP84eSzQSrJg2BNsfnKaR4j1ogdP+smYvvVdfnYwHz0WlLXHKYngOV7+4TPgBU4/XKaXnKL8Vi58cPMwoFXF8qXwKxcwY3zmifipd6zBlSOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.12) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4P45vVr9CRRhKdkQmVGGVRjnr6vBabhL6PCAEtrcBk=;
 b=nC+SGp+dEWsf4k80QYGMN66aS7mLrUj/2mFmeLNqoqnO+5E+XLGhGdhJs0Ioz3XcZDY9yrb8ftA6kh8voXf33SYmJXMoxCeUx/nW/qA3RxxddCgMZyZ73y/gPv8NtzLO0qrkHbsL5G8Lacq5kynBokOAOLUe25q50+Yx48jlOgOmrPY7cka/QjMVmGpIjPfH9kOil+rStUVomJqL0xVgtdpVjcJYHXBjPOyYT1C2Abz30iVdNzY2HilqYEYiFZvtr++SB+KP4tWcAK5yqh4X2d8HoI9h3i+vixkQrAH4XX+JXmyMuKOL5RFy9qgR8AltLQSuIRqWqF3a43FlcjVBlA==
Received: from DM3PR12CA0085.namprd12.prod.outlook.com (2603:10b6:0:57::29) by
 DM6PR12MB3914.namprd12.prod.outlook.com (2603:10b6:5:1c9::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.17; Thu, 10 Mar 2022 16:13:26 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:57:cafe::8c) by DM3PR12CA0085.outlook.office365.com
 (2603:10b6:0:57::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22 via Frontend
 Transport; Thu, 10 Mar 2022 16:13:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.12)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.12 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.12; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.12) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Thu, 10 Mar 2022 16:13:26 +0000
Received: from DRHQMAIL105.nvidia.com (10.27.9.14) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 10 Mar
 2022 16:13:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 10 Mar
 2022 16:13:21 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 10 Mar
 2022 08:13:19 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 2/3] selftests: netdevsim: hw_stats_l3: Add a new test
Date:   Thu, 10 Mar 2022 17:12:23 +0100
Message-ID: <6467e2e9b4065952a9473504a2f855024e0b698a.1646928340.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1646928340.git.petrm@nvidia.com>
References: <cover.1646928340.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 632fccc5-6ca9-4cf3-2476-08da02b0e8b3
X-MS-TrafficTypeDiagnostic: DM6PR12MB3914:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB39142AFBC039CC4F9DCF7AAFD60B9@DM6PR12MB3914.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4HrzasaGx/ZCEoo1RxjbgTFHP1Yvtx6fwlw4H9IJ8ASoCmrFiES/K5ibJ5n7fqAo70TFefT2VaLJ/84drRCmEZBStvC0zZ/MM/tpcep4mqokL9wEgqUgdyuPifv+h2aFHdfRbJ3/lt4ja/XGR/Itr405ijalcS/Wo8VCEpYwArXCKA2B6BNLKLtuDR4r8KyzgjiuGAsLJzbQJha7XSj/kXaVoGtCo2F3yDsesQY8kFy+DHAJm7RWN9SoRiCBdkuVOdO6VavhssyMQ/lzLYiYCwtgJKvqS+YHeO7NMFIwSAAIj9cd6kf0N4b+cxzWpe/r+luEKKnVkG2s2gnbrTUtQpAVB2vEfIzGEVT7uzIUP6eQPToobqirBMp0FaUOnMEcy6pEome+bcbXdRwWBsF3o6JJ96Ypznb8zcoomF+JgAfMCCHbXzK/osWE7fFNXXkICnjYPt3mVaQ109ZqKu0a3bSJDBDxUuw+1n474pBCHjpn2Ue37jb9e4l9EKxEf2W8mOwVjRjz/Cz/xRHIImjVhTQcVHVmU5jjVXaEQs6R68CGlGqXBzJQgL8bqwM7bQcvao3tQU+Zo3ceWhAGDjgjDu6ZNLH/tCCdfWebU/B+ZUNQlrfv75r4YkUP0AFUfF40E7igcdPnO/73J4p60weu8AdbAP/iA9Qkf3YJqsnV9p9NSnpqy1Axs5HrKDM5xOoy
X-Forefront-Antispam-Report: CIP:203.18.50.12;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid01.nvidia.com;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(186003)(86362001)(508600001)(36756003)(40460700003)(2616005)(83380400001)(336012)(426003)(16526019)(107886003)(6666004)(47076005)(26005)(30864003)(2906002)(4326008)(5660300002)(70586007)(70206006)(8676002)(36860700001)(54906003)(316002)(7636003)(356005)(82310400004)(6916009)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 16:13:26.3682
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 632fccc5-6ca9-4cf3-2476-08da02b0e8b3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.12];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3914
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test that verifies basic UAPI contracts, netdevsim operation,
rollbacks after partial enablement in core, and UAPI notifications.

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../drivers/net/netdevsim/hw_stats_l3.sh      | 421 ++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |  60 +++
 2 files changed, 481 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/hw_stats_l3.sh

diff --git a/tools/testing/selftests/drivers/net/netdevsim/hw_stats_l3.sh b/tools/testing/selftests/drivers/net/netdevsim/hw_stats_l3.sh
new file mode 100755
index 000000000000..fe1898402987
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/netdevsim/hw_stats_l3.sh
@@ -0,0 +1,421 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	l3_reporting_test
+	l3_fail_next_test
+	l3_counter_test
+	l3_rollback_test
+	l3_monitor_test
+"
+
+NETDEVSIM_PATH=/sys/bus/netdevsim/
+DEV_ADDR_1=1337
+DEV_ADDR_2=1057
+DEV_ADDR_3=5417
+NUM_NETIFS=0
+source $lib_dir/lib.sh
+
+DUMMY_IFINDEX=
+
+DEV_ADDR()
+{
+	local n=$1; shift
+	local var=DEV_ADDR_$n
+
+	echo ${!var}
+}
+
+DEV()
+{
+	echo netdevsim$(DEV_ADDR $1)
+}
+
+DEVLINK_DEV()
+{
+	echo netdevsim/$(DEV $1)
+}
+
+SYSFS_NET_DIR()
+{
+	echo /sys/bus/netdevsim/devices/$(DEV $1)/net/
+}
+
+DEBUGFS_DIR()
+{
+	echo /sys/kernel/debug/netdevsim/$(DEV $1)/
+}
+
+nsim_add()
+{
+	local n=$1; shift
+
+	echo "$(DEV_ADDR $n) 1" > ${NETDEVSIM_PATH}/new_device
+	while [ ! -d $(SYSFS_NET_DIR $n) ] ; do :; done
+}
+
+nsim_reload()
+{
+	local n=$1; shift
+	local ns=$1; shift
+
+	devlink dev reload $(DEVLINK_DEV $n) netns $ns
+
+	if [ $? -ne 0 ]; then
+		echo "Failed to reload $(DEV $n) into netns \"testns1\""
+		exit 1
+	fi
+
+}
+
+nsim_del()
+{
+	local n=$1; shift
+
+	echo "$(DEV_ADDR $n)" > ${NETDEVSIM_PATH}/del_device
+}
+
+nsim_hwstats_toggle()
+{
+	local action=$1; shift
+	local instance=$1; shift
+	local netdev=$1; shift
+	local type=$1; shift
+
+	local ifindex=$($IP -j link show dev $netdev | jq '.[].ifindex')
+
+	echo $ifindex > $(DEBUGFS_DIR $instance)/hwstats/$type/$action
+}
+
+nsim_hwstats_enable()
+{
+	nsim_hwstats_toggle enable_ifindex "$@"
+}
+
+nsim_hwstats_disable()
+{
+	nsim_hwstats_toggle disable_ifindex "$@"
+}
+
+nsim_hwstats_fail_next_enable()
+{
+	nsim_hwstats_toggle fail_next_enable "$@"
+}
+
+setup_prepare()
+{
+	modprobe netdevsim &> /dev/null
+	nsim_add 1
+	nsim_add 2
+	nsim_add 3
+
+	ip netns add testns1
+
+	if [ $? -ne 0 ]; then
+		echo "Failed to add netns \"testns1\""
+		exit 1
+	fi
+
+	nsim_reload 1 testns1
+	nsim_reload 2 testns1
+	nsim_reload 3 testns1
+
+	IP="ip -n testns1"
+
+	$IP link add name dummy1 type dummy
+	$IP link set dev dummy1 up
+	DUMMY_IFINDEX=$($IP -j link show dev dummy1 | jq '.[].ifindex')
+}
+
+cleanup()
+{
+	pre_cleanup
+
+	$IP link del name dummy1
+	ip netns del testns1
+	nsim_del 3
+	nsim_del 2
+	nsim_del 1
+	modprobe -r netdevsim &> /dev/null
+}
+
+netdev_hwstats_used()
+{
+	local netdev=$1; shift
+	local type=$1; shift
+
+	$IP -j stats show dev "$netdev" group offload subgroup hw_stats_info |
+	    jq '.[].info.l3_stats.used'
+}
+
+netdev_check_used()
+{
+	local netdev=$1; shift
+	local type=$1; shift
+
+	[[ $(netdev_hwstats_used $netdev $type) == "true" ]]
+}
+
+netdev_check_unused()
+{
+	local netdev=$1; shift
+	local type=$1; shift
+
+	[[ $(netdev_hwstats_used $netdev $type) == "false" ]]
+}
+
+netdev_hwstats_request()
+{
+	local netdev=$1; shift
+	local type=$1; shift
+
+	$IP -j stats show dev "$netdev" group offload subgroup hw_stats_info |
+	    jq ".[].info.${type}_stats.request"
+}
+
+netdev_check_requested()
+{
+	local netdev=$1; shift
+	local type=$1; shift
+
+	[[ $(netdev_hwstats_request $netdev $type) == "true" ]]
+}
+
+netdev_check_unrequested()
+{
+	local netdev=$1; shift
+	local type=$1; shift
+
+	[[ $(netdev_hwstats_request $netdev $type) == "false" ]]
+}
+
+reporting_test()
+{
+	local type=$1; shift
+	local instance=1
+
+	RET=0
+
+	[[ -n $(netdev_hwstats_used dummy1 $type) ]]
+	check_err $? "$type stats not reported"
+
+	netdev_check_unused dummy1 $type
+	check_err $? "$type stats reported as used before either device or netdevsim request"
+
+	nsim_hwstats_enable $instance dummy1 $type
+	netdev_check_unused dummy1 $type
+	check_err $? "$type stats reported as used before device request"
+	netdev_check_unrequested dummy1 $type
+	check_err $? "$type stats reported as requested before device request"
+
+	$IP stats set dev dummy1 ${type}_stats on
+	netdev_check_used dummy1 $type
+	check_err $? "$type stats reported as not used after both device and netdevsim request"
+	netdev_check_requested dummy1 $type
+	check_err $? "$type stats reported as not requested after device request"
+
+	nsim_hwstats_disable $instance dummy1 $type
+	netdev_check_unused dummy1 $type
+	check_err $? "$type stats reported as used after netdevsim request withdrawn"
+
+	nsim_hwstats_enable $instance dummy1 $type
+	netdev_check_used dummy1 $type
+	check_err $? "$type stats reported as not used after netdevsim request reenabled"
+
+	$IP stats set dev dummy1 ${type}_stats off
+	netdev_check_unused dummy1 $type
+	check_err $? "$type stats reported as used after device request withdrawn"
+	netdev_check_unrequested dummy1 $type
+	check_err $? "$type stats reported as requested after device request withdrawn"
+
+	nsim_hwstats_disable $instance dummy1 $type
+	netdev_check_unused dummy1 $type
+	check_err $? "$type stats reported as used after both requests withdrawn"
+
+	log_test "Reporting of $type stats usage"
+}
+
+l3_reporting_test()
+{
+	reporting_test l3
+}
+
+__fail_next_test()
+{
+	local instance=$1; shift
+	local type=$1; shift
+
+	RET=0
+
+	netdev_check_unused dummy1 $type
+	check_err $? "$type stats reported as used before either device or netdevsim request"
+
+	nsim_hwstats_enable $instance dummy1 $type
+	nsim_hwstats_fail_next_enable $instance dummy1 $type
+	netdev_check_unused dummy1 $type
+	check_err $? "$type stats reported as used before device request"
+	netdev_check_unrequested dummy1 $type
+	check_err $? "$type stats reported as requested before device request"
+
+	$IP stats set dev dummy1 ${type}_stats on 2>/dev/null
+	check_fail $? "$type stats request not bounced as it should have been"
+	netdev_check_unused dummy1 $type
+	check_err $? "$type stats reported as used after bounce"
+	netdev_check_unrequested dummy1 $type
+	check_err $? "$type stats reported as requested after bounce"
+
+	$IP stats set dev dummy1 ${type}_stats on
+	check_err $? "$type stats request failed when it shouldn't have"
+	netdev_check_used dummy1 $type
+	check_err $? "$type stats reported as not used after both device and netdevsim request"
+	netdev_check_requested dummy1 $type
+	check_err $? "$type stats reported as not requested after device request"
+
+	$IP stats set dev dummy1 ${type}_stats off
+	nsim_hwstats_disable $instance dummy1 $type
+
+	log_test "Injected failure of $type stats enablement (netdevsim #$instance)"
+}
+
+fail_next_test()
+{
+	__fail_next_test 1 "$@"
+	__fail_next_test 2 "$@"
+	__fail_next_test 3 "$@"
+}
+
+l3_fail_next_test()
+{
+	fail_next_test l3
+}
+
+get_hwstat()
+{
+	local netdev=$1; shift
+	local type=$1; shift
+	local selector=$1; shift
+
+	$IP -j stats show dev $netdev group offload subgroup ${type}_stats |
+		  jq ".[0].stats64.${selector}"
+}
+
+counter_test()
+{
+	local type=$1; shift
+	local instance=1
+
+	RET=0
+
+	nsim_hwstats_enable $instance dummy1 $type
+	$IP stats set dev dummy1 ${type}_stats on
+	netdev_check_used dummy1 $type
+	check_err $? "$type stats reported as not used after both device and netdevsim request"
+
+	# Netdevsim counts 10pps on ingress. We should see maybe a couple
+	# packets, unless things take a reeealy long time.
+	local pkts=$(get_hwstat dummy1 l3 rx.packets)
+	((pkts < 10))
+	check_err $? "$type stats show >= 10 packets after first enablement"
+
+	sleep 2
+
+	local pkts=$(get_hwstat dummy1 l3 rx.packets)
+	((pkts >= 20))
+	check_err $? "$type stats show < 20 packets after 2s passed"
+
+	$IP stats set dev dummy1 ${type}_stats off
+
+	sleep 2
+
+	$IP stats set dev dummy1 ${type}_stats on
+	local pkts=$(get_hwstat dummy1 l3 rx.packets)
+	((pkts < 10))
+	check_err $? "$type stats show >= 10 packets after second enablement"
+
+	$IP stats set dev dummy1 ${type}_stats off
+	nsim_hwstats_fail_next_enable $instance dummy1 $type
+	$IP stats set dev dummy1 ${type}_stats on 2>/dev/null
+	check_fail $? "$type stats request not bounced as it should have been"
+
+	sleep 2
+
+	$IP stats set dev dummy1 ${type}_stats on
+	local pkts=$(get_hwstat dummy1 l3 rx.packets)
+	((pkts < 10))
+	check_err $? "$type stats show >= 10 packets after post-fail enablement"
+
+	$IP stats set dev dummy1 ${type}_stats off
+
+	log_test "Counter values in $type stats"
+}
+
+l3_counter_test()
+{
+	counter_test l3
+}
+
+rollback_test()
+{
+	local type=$1; shift
+
+	RET=0
+
+	nsim_hwstats_enable 1 dummy1 l3
+	nsim_hwstats_enable 2 dummy1 l3
+	nsim_hwstats_enable 3 dummy1 l3
+
+	# The three netdevsim instances are registered in order of their number
+	# one after another. It is reasonable to expect that whatever
+	# notifications take place hit no. 2 in between hitting nos. 1 and 3,
+	# whatever the actual order. This allows us to test that a fail caused
+	# by no. 2 does not leave the system in a partial state, and rolls
+	# everything back.
+
+	nsim_hwstats_fail_next_enable 2 dummy1 l3
+	$IP stats set dev dummy1 ${type}_stats on 2>/dev/null
+	check_fail $? "$type stats request not bounced as it should have been"
+
+	netdev_check_unused dummy1 $type
+	check_err $? "$type stats reported as used after bounce"
+	netdev_check_unrequested dummy1 $type
+	check_err $? "$type stats reported as requested after bounce"
+
+	sleep 2
+
+	$IP stats set dev dummy1 ${type}_stats on
+	check_err $? "$type stats request not upheld as it should have been"
+
+	local pkts=$(get_hwstat dummy1 l3 rx.packets)
+	((pkts < 10))
+	check_err $? "$type stats show $pkts packets after post-fail enablement"
+
+	$IP stats set dev dummy1 ${type}_stats off
+
+	nsim_hwstats_disable 3 dummy1 l3
+	nsim_hwstats_disable 2 dummy1 l3
+	nsim_hwstats_disable 1 dummy1 l3
+
+	log_test "Failure in $type stats enablement rolled back"
+}
+
+l3_rollback_test()
+{
+	rollback_test l3
+}
+
+l3_monitor_test()
+{
+	hw_stats_monitor_test dummy1 l3		   \
+		"nsim_hwstats_enable 1 dummy1 l3"  \
+		"nsim_hwstats_disable 1 dummy1 l3" \
+		"$IP"
+}
+
+trap cleanup EXIT
+
+setup_prepare
+tests_run
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 159afc7f0979..664b9ecaf228 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1498,3 +1498,63 @@ brmcast_check_sg_state()
 		check_err_fail $should_fail $? "Entry $src has blocked flag"
 	done
 }
+
+start_ip_monitor()
+{
+	local mtype=$1; shift
+	local ip=${1-ip}; shift
+
+	# start the monitor in the background
+	tmpfile=`mktemp /var/run/nexthoptestXXX`
+	mpid=`($ip monitor $mtype > $tmpfile & echo $!) 2>/dev/null`
+	sleep 0.2
+	echo "$mpid $tmpfile"
+}
+
+stop_ip_monitor()
+{
+	local mpid=$1; shift
+	local tmpfile=$1; shift
+	local el=$1; shift
+	local what=$1; shift
+
+	sleep 0.2
+	kill $mpid
+	local lines=`grep '^\w' $tmpfile | wc -l`
+	test $lines -eq $el
+	check_err $? "$what: $lines lines of events, expected $el"
+	rm -rf $tmpfile
+}
+
+hw_stats_monitor_test()
+{
+	local dev=$1; shift
+	local type=$1; shift
+	local make_suitable=$1; shift
+	local make_unsuitable=$1; shift
+	local ip=${1-ip}; shift
+
+	RET=0
+
+	# Expect a notification about enablement.
+	local ipmout=$(start_ip_monitor stats "$ip")
+	$ip stats set dev $dev ${type}_stats on
+	stop_ip_monitor $ipmout 1 "${type}_stats enablement"
+
+	# Expect a notification about offload.
+	local ipmout=$(start_ip_monitor stats "$ip")
+	$make_suitable
+	stop_ip_monitor $ipmout 1 "${type}_stats installation"
+
+	# Expect a notification about loss of offload.
+	local ipmout=$(start_ip_monitor stats "$ip")
+	$make_unsuitable
+	stop_ip_monitor $ipmout 1 "${type}_stats deinstallation"
+
+	# Expect a notification about disablement
+	local ipmout=$(start_ip_monitor stats "$ip")
+	$ip stats set dev $dev ${type}_stats off
+	stop_ip_monitor $ipmout 1 "${type}_stats disablement"
+
+	log_test "${type}_stats notifications"
+}
-- 
2.31.1

