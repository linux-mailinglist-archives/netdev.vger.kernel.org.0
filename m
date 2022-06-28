Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C5D55DBBC
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344990AbiF1Kik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 06:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343767AbiF1Kij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 06:38:39 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8714510546;
        Tue, 28 Jun 2022 03:38:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fd9Jr2Lw8h8j5Y7fp5/zfe3LkOA5fy4h1uh+eMj7otu4nztGgCE+i6zC0l+W+wOoL+xYkHymqGGNoBsydXXcfb6G1ptxUldcykh0H+D2w+5JwN9UUIzl49aE44KTfgazX++jiS8YafuIqcr9W6DdxplPpY0GqAVqR1KA2vq4FNcqaJrF1UMbUUTrzMtYD0f9MQXSyoVQBJA3EiCMzbyU7pz5QZwo8ysmaD6OUMLCCjaVCXMBvoY6iP15XB7TYLDZIJ3g6ZBeOVLXZ71iKlSHOoapUI/iyqUcO0maWVt67+NtyS4Se4U5+xxq88AXvFIXyYFXNW3BqgH5txDrsXK13w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vrzsN/IbPGs0RyNyU7wBMc4OxtCdSfJiP46j5mrJ7dQ=;
 b=UgTwbTDY1Xj8zziUnwZsXGug2iTwOKPrfzS26PJub0v8PAvxKZ7pepqC+U+xtoR2HOzHw57PJKc+14GpcAKfmwSg0acsGeTk8NuUI6p9vFRirWPUdBg1N+bWzhOxiB0BkrhQiQcDCS+vB6Kq372qYsSw7uo92zzpzNXWLHIQs84/SziOvK02GOSmWAM3e5yEXDs7JRLJYfcj501S+B+2er9NlrFjbZ4fSkL6M7ovulv8ZAhgx4y5WrwtBUJXv4uiVU0LmLKFkVFxKZBtP2z3hn8ngjagKz9Gq9pKOCAEoEP9WzyiEFebIGFwp+MFkMz2emz7ZODitjW1qgiWPYHp6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vrzsN/IbPGs0RyNyU7wBMc4OxtCdSfJiP46j5mrJ7dQ=;
 b=KjANjbVIsia47KhrPZ93DXvyVtgJatdJZIXtinGU8D3/Ht91HTvMN0bmWyaMHxKmLqquw+kfs1EQ/kteh6hchj1O07HFd6kmD9cG0LOJoQg4JhTKeISwWevODrVfCWd1f+xEtLAsI0ndXDco8MpwEuokNb/B/4VntJqXY8hURv3uRuGNWIG+xs97pFy+GqIt16AdxW5FL9ZJBCtGOTUqpTQ/f2F2hCDyJ+finbO2eR+MPds/S+F0FTcS776FFw58BmjOIgxtqMK0EwjMGiwXLxo/MEaFuyPn/KxCeVzkhkfWLs5mS79x9iyMRFgVDYqTzLzK2EbnN5l6m0CfmNmRrQ==
Received: from BN8PR04CA0059.namprd04.prod.outlook.com (2603:10b6:408:d4::33)
 by BYAPR12MB4759.namprd12.prod.outlook.com (2603:10b6:a03:9d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 10:38:32 +0000
Received: from BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::20) by BN8PR04CA0059.outlook.office365.com
 (2603:10b6:408:d4::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16 via Frontend
 Transport; Tue, 28 Jun 2022 10:38:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT016.mail.protection.outlook.com (10.13.176.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Tue, 28 Jun 2022 10:38:31 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 28 Jun
 2022 10:38:30 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 28 Jun
 2022 03:38:27 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
CC:     <mlxsw@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <shuah@kernel.org>,
        Amit Cohen <amcohen@nvidia.com>
Subject: [PATCH net-next] selftests: forwarding: ethtool_extended_state: Convert to busywait
Date:   Tue, 28 Jun 2022 12:37:44 +0200
Message-ID: <b3f4a264c0270f3e4e22e291ee843fbf72d3fc7f.1656412324.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd083c5a-dfa9-49c9-f569-08da58f25882
X-MS-TrafficTypeDiagnostic: BYAPR12MB4759:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0d6WZgLVO3k/rpS3/+mZBJS3k4Fc+c2Vx5wDSh6+Vkv7vOIkxw/r7fslIOH8LrPZi8m+B90Z+MJazKydzHlg3stoOEfRcEALxu8oPKJ26PlF0Qrl7Fx7iKkOT7JK0VomYmkR19W/EK3jGRbNVWpfFHo1jhSeSDLMv5p4tH3PF4GlhLu2jMGUGZSaycpJHR/Ad9isa9IKZH+5G8tH+0gARIddQWte/uU07vWasZKtyhV4FOCXYrAJjMVsj2La5n7ouNnlJuv4R8xU1BNHHgOVW24Oc5Figu1VNl8QjCsAwZDk0JNaxyC5NTNrDLFGQK0SFgpEb83kOR/nGXTw0EggV3NxzsH5P2uEhG2hzhxLntvbRnKKhW3j6sm+VP8tGNPt7AZaPZsf2W+8h/kMhOx7L4ccHjGSl28OZdiYUQfP0yVPnnSuKS8y6CPXFpTTsycJg13HCdZO06qP3tqsh9uOSWtfk0T2lhYC8OJ0Tnz5bRPeGzPN/EHymWvcgMTiJahszxJPz2W2383C+7pGWjGPb/kKV1ZGlkkvVTgLmh8hn8EtXXekhKFTTjLpJUXAtioNuo6I7vzS41nZyuiRnu60+qgHzpxwCLMkzOQmi251jpcsqCXerXKDuiAjet/h1uPOoviIO5yvChL+hgmA7MEJzDPbhmcq2cWkg+V/VnyhdH+Od+jytscTAgmmLimqva/gF8i8kFezsft6DIhw/9z8v8ZvcZKT4O5woILDWqJF5Ze92MIbN442NnUyCf0ZO9+T8Ac7bmmdoXBgIMuadSOfOIHuy0XtProtcVKoQnuy/Ec/NChxZ0sVX/HknIadjVTEDVXSaQKsEmeOklcc8ZJWwA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(39860400002)(136003)(396003)(46966006)(40470700004)(36840700001)(186003)(83380400001)(336012)(41300700001)(8676002)(16526019)(6666004)(107886003)(26005)(426003)(47076005)(2616005)(54906003)(70586007)(36860700001)(81166007)(356005)(82740400003)(4326008)(36756003)(82310400005)(2906002)(5660300002)(86362001)(478600001)(110136005)(40480700001)(8936002)(70206006)(316002)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 10:38:31.4935
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd083c5a-dfa9-49c9-f569-08da58f25882
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4759
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, this script sets up the test scenario, which is supposed to end
in an inability of the system to negotiate a link. It then waits for a bit,
and verifies that the system can diagnose why the link was not established.

The wait time for the scenario where different link speeds are forced on
the two ends of a loopback cable, was set to 4 seconds, which exactly
covered it. As of a recent mlxsw firmware update, this time gets longer,
and this test starts failing.

The time that selftests currently wait for links to be established is
currently $WAIT_TIMEOUT, or 20 seconds. It seems reasonable that if this is
the time necessary to establish and bring up a link, it should also be
enough to determine that a link cannot be established and why.

Therefore in this patch, convert the sleeps to busywaits, so that if a
failure is established sooner (as is expected), the test runs quicker. And
use $WAIT_TIMEOUT as the time to wait.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 .../net/forwarding/ethtool_extended_state.sh  | 43 ++++++++++++-------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/ethtool_extended_state.sh b/tools/testing/selftests/net/forwarding/ethtool_extended_state.sh
index 4b42dfd4efd1..072faa77f53b 100755
--- a/tools/testing/selftests/net/forwarding/ethtool_extended_state.sh
+++ b/tools/testing/selftests/net/forwarding/ethtool_extended_state.sh
@@ -11,6 +11,8 @@ NUM_NETIFS=2
 source lib.sh
 source ethtool_lib.sh
 
+TIMEOUT=$((WAIT_TIMEOUT * 1000)) # ms
+
 setup_prepare()
 {
 	swp1=${NETIFS[p1]}
@@ -18,7 +20,7 @@ setup_prepare()
 	swp3=$NETIF_NO_CABLE
 }
 
-ethtool_extended_state_check()
+ethtool_ext_state()
 {
 	local dev=$1; shift
 	local expected_ext_state=$1; shift
@@ -30,21 +32,27 @@ ethtool_extended_state_check()
 		| sed -e 's/^[[:space:]]*//')
 	ext_state=$(echo $ext_state | cut -d "," -f1)
 
-	[[ $ext_state == $expected_ext_state ]]
-	check_err $? "Expected \"$expected_ext_state\", got \"$ext_state\""
-
-	[[ $ext_substate == $expected_ext_substate ]]
-	check_err $? "Expected \"$expected_ext_substate\", got \"$ext_substate\""
+	if [[ $ext_state != $expected_ext_state ]]; then
+		echo "Expected \"$expected_ext_state\", got \"$ext_state\""
+		return 1
+	fi
+	if [[ $ext_substate != $expected_ext_substate ]]; then
+		echo "Expected \"$expected_ext_substate\", got \"$ext_substate\""
+		return 1
+	fi
 }
 
 autoneg()
 {
+	local msg
+
 	RET=0
 
 	ip link set dev $swp1 up
 
-	sleep 4
-	ethtool_extended_state_check $swp1 "Autoneg" "No partner detected"
+	msg=$(busywait $TIMEOUT ethtool_ext_state $swp1 \
+			"Autoneg" "No partner detected")
+	check_err $? "$msg"
 
 	log_test "Autoneg, No partner detected"
 
@@ -53,6 +61,8 @@ autoneg()
 
 autoneg_force_mode()
 {
+	local msg
+
 	RET=0
 
 	ip link set dev $swp1 up
@@ -65,12 +75,13 @@ autoneg_force_mode()
 	ethtool_set $swp1 speed $speed1 autoneg off
 	ethtool_set $swp2 speed $speed2 autoneg off
 
-	sleep 4
-	ethtool_extended_state_check $swp1 "Autoneg" \
-		"No partner detected during force mode"
+	msg=$(busywait $TIMEOUT ethtool_ext_state $swp1 \
+			"Autoneg" "No partner detected during force mode")
+	check_err $? "$msg"
 
-	ethtool_extended_state_check $swp2 "Autoneg" \
-		"No partner detected during force mode"
+	msg=$(busywait $TIMEOUT ethtool_ext_state $swp2 \
+			"Autoneg" "No partner detected during force mode")
+	check_err $? "$msg"
 
 	log_test "Autoneg, No partner detected during force mode"
 
@@ -83,12 +94,14 @@ autoneg_force_mode()
 
 no_cable()
 {
+	local msg
+
 	RET=0
 
 	ip link set dev $swp3 up
 
-	sleep 1
-	ethtool_extended_state_check $swp3 "No cable"
+	msg=$(busywait $TIMEOUT ethtool_ext_state $swp3 "No cable")
+	check_err $? "$msg"
 
 	log_test "No cable"
 
-- 
2.35.3

