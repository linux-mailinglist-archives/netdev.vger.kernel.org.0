Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACCA05F228A
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 12:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiJBKYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 06:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiJBKYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 06:24:53 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2063.outbound.protection.outlook.com [40.107.100.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1F61AF28
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 03:24:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X5oe6bLIifwnNNSSfdVwoT16XdBaDpKJSORnmlNZNVBtfLpN6ffw2SsgbE8JIdZE4muF7VWalRSsevlz7psBo0xYmjrkQl4UD0j52AMYzLQCx+iRfx02WeeYPlajmnGQ0TScuT6SdZseXsflcSHwbp0DpkWllPiBNZ+mxFF/7wnCdkil0RMt2rFfi4wn9SvqfWI1RQA74h6rdXJltlwLqeMiQ0LscmUCBtqT54DFSW0QCZIfbSdLr/0He3wvm3dOGjWlEBN01VB/nQXfUHF+yiqb/2MfxOy958z8Rio/0359jpvglMWrpw/JD5oCO+++sEhvfwBgfUHETtkYHwNpUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YUp3RbE89Zptvm5X5qYXoXON0J6E+8GT81Eq36gKd/8=;
 b=ghxRMWADi6U3yrz5utCz7mBuJObvBXT8OgqBafR2H/M3fDgMQ2L2KYIoL52zkQE3Q7q2Q61NScLUxzOX1eQ+RoMsXvlvNxvF+9RoTutbwUwGN1gTmI0Pzq59z+gsP9kId0Q3ak5KRwnIVrkawUbNdhh7qkzd0GcqiJNc38U0cBvf//HNxPrRXStXzTGUpZVEWyCx9ym8W8MAtqGo+aMuayEjYj1TWutCLWg6TpkZJjfWYp4URwR0gxwt29BlVDLgXdmMvjCxFpWyqA6UySIoqLZ1nVZ6M5GRD2wo9N5+IAASNM0odCGPZlK66K1lL9GacSsHLyTpXWMaId0yl/GICg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=iogearbox.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YUp3RbE89Zptvm5X5qYXoXON0J6E+8GT81Eq36gKd/8=;
 b=fmVQZ24CC7Hi6jJCTUe29NVxJE6EGxUItHJcZmx62m8DHe7r6SCHa8SU2cM5CociiprCdsObh+iCkT8Veh2Vn1kUn7py/HWBTZqg7mqr4+UepKrv4ItPBfveZ+l/Us86XdDJjwOGKWfFP4z8lartkm0OKIi5Fh+EkKKA1gvpk8qoeIeJ2u1sqBe57HuXVI6xIbZlAy0h9pSq2QtMJDNTm0uLRd1stOEC71e8MjPzMGuf8V4tPfdCElqTHARlYE6ILZ8JMCf7lDRzNcbknxCUeYSOSRcilNq2ok2Qq7dvxOfJsUok4q8jbxQoWLhAZMmdHpfbmd6Dn/YhQyp7empItQ==
Received: from DM6PR02CA0049.namprd02.prod.outlook.com (2603:10b6:5:177::26)
 by MN2PR12MB4438.namprd12.prod.outlook.com (2603:10b6:208:267::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Sun, 2 Oct
 2022 10:24:49 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::ad) by DM6PR02CA0049.outlook.office365.com
 (2603:10b6:5:177::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28 via Frontend
 Transport; Sun, 2 Oct 2022 10:24:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17 via Frontend Transport; Sun, 2 Oct 2022 10:24:48 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 2 Oct 2022
 03:24:45 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 2 Oct 2022
 03:24:45 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via
 Frontend Transport; Sun, 2 Oct 2022 03:24:42 -0700
From:   Paul Blakey <paulb@nvidia.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
CC:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net v3 2/2] selftests: add selftest for chaining of tc ingress handling to egress
Date:   Sun, 2 Oct 2022 13:24:32 +0300
Message-ID: <1664706272-10164-3-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1664706272-10164-1-git-send-email-paulb@nvidia.com>
References: <1664706272-10164-1-git-send-email-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT022:EE_|MN2PR12MB4438:EE_
X-MS-Office365-Filtering-Correlation-Id: 647e1d14-71a6-4976-23b1-08daa460559d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wu6lOQ8dmxt/fkZTg+fnqQdliuBqW8UmwckfqC6IKH0pZLQAQydPo6K9kwCZSX8zL4ciA2s/M9Bmf8+PEqK39Nc6XD3uEQCs8lOH8HIprCzTrKh4sfnho7JSdxD5RnIubIWfFq1a5/CBByzCXNnX3PnYhdRejf7VHh1vQkzVInroBq23uIXiSmGjXza2A0bYQs5anRRkkCIfsN05TnLz25n78Z6+etu8CwmYYJYQQL8HX4KHNhYoOSEsbj1HwX0YzvR+9OLv/mQtna00Nts6on4E3u5l67Mp9eouOZK2iyAcRmDuL3UHvMfW90JVpgbZxvmQPYQ1uuHch122bb6d8BOB83Jq0Cx+a890VPeBXp+EH0hrzCqB4QqrrMecNrWKT8ALzW/8s0L0B3OysoBOjNPuPsNOFTcoFIhFGGVFVSXdM+lOiqwVoy4nnLKnoC4n4htg2lmKXx2ntZ4MxZQqSq4GZBss9ETDbvypSILsqZzQmk3z0wdAtZZ8yhpum4OI/zCV2jsszMkA+nGJUQu+ZPTnQ985tEIZCcly+1fO9C/0maK7Gu7gtIaI6QqlByPA2mUVbI3Zp1mC8vQwBntH6VE4Jv4LCoGVuYIkYFdseTphtU8QX2J8IzsrbaogrP5FxtA3H/hwJx+uZdO7Ez9xxgeGbOUgVA48PPZBdOStf8rTpBmP5VzSIiXy1R8N/ORT2YDDh2BUjzMe6HxzB9hKSpmWfgTqbWHLcpB9ogtkSlvodsOFKZYnib9ue+3OAknXL+gnWN89YsAAEfYnetxSpQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(376002)(39860400002)(451199015)(36840700001)(46966006)(40470700004)(2616005)(26005)(6666004)(316002)(6636002)(54906003)(4326008)(8676002)(70586007)(70206006)(36756003)(478600001)(82310400005)(110136005)(82740400003)(40480700001)(86362001)(356005)(7636003)(40460700003)(336012)(186003)(47076005)(426003)(36860700001)(5660300002)(8936002)(41300700001)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2022 10:24:48.5117
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 647e1d14-71a6-4976-23b1-08daa460559d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4438
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test runs a simple ingress tc setup between two veth pairs,
then adds a egress->ingress rule to test the chaining of tc ingress
pipeline to tc egress piepline.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 .../net/test_ingress_egress_chaining.sh       | 81 +++++++++++++++++++
 1 file changed, 81 insertions(+)
 create mode 100644 tools/testing/selftests/net/test_ingress_egress_chaining.sh

diff --git a/tools/testing/selftests/net/test_ingress_egress_chaining.sh b/tools/testing/selftests/net/test_ingress_egress_chaining.sh
new file mode 100644
index 000000000000..4775f5657e68
--- /dev/null
+++ b/tools/testing/selftests/net/test_ingress_egress_chaining.sh
@@ -0,0 +1,81 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# This test runs a simple ingress tc setup between two veth pairs,
+# and chains a single egress rule to test ingress chaining to egress.
+#
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+if [ "$(id -u)" -ne 0 ];then
+	echo "SKIP: Need root privileges"
+	exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v iperf)" ]; then
+	echo "SKIP: Could not run test without iperf tool"
+	exit $ksft_skip
+fi
+
+needed_mods="act_mirred cls_flower sch_ingress"
+for mod in $needed_mods; do
+	modinfo $mod &>/dev/null || { echo "SKIP: Need act_mirred module"; exit $ksft_skip; }
+done
+
+ns="ns$((RANDOM%899+100))"
+veth1="veth1$((RANDOM%899+100))"
+veth2="veth2$((RANDOM%899+100))"
+peer1="peer1$((RANDOM%899+100))"
+peer2="peer2$((RANDOM%899+100))"
+
+function fail() {
+	echo "FAIL: $@" >> /dev/stderr
+	exit 1
+}
+
+function cleanup() {
+	killall -q -9 iperf
+	ip link del $veth1 &> /dev/null
+	ip link del $veth2 &> /dev/null
+	ip netns del $ns &> /dev/null
+}
+trap cleanup EXIT
+
+function config() {
+	echo "Setup veth pairs [$veth1, $peer1], and veth pair [$veth2, $peer2]"
+	ip link add $veth1 type veth peer name $peer1
+	ip link add $veth2 type veth peer name $peer2
+	ifconfig $peer1 5.5.5.6/24 up
+	ip netns add $ns
+	ip link set dev $peer2 netns $ns
+	ip netns exec $ns ifconfig $peer2 5.5.5.5/24 up
+	ifconfig $veth2 0 up
+	ifconfig $veth1 0 up
+
+	echo "Add tc filter ingress->egress forwarding $veth1 <-> $veth2"
+	tc qdisc add dev $veth2 ingress
+	tc qdisc add dev $veth1 ingress
+	tc filter add dev $veth2 ingress prio 1 proto all flower \
+		action mirred egress redirect dev $veth1
+	tc filter add dev $veth1 ingress prio 1 proto all flower \
+		action mirred egress redirect dev $veth2
+
+	echo "Add tc filter egress->ingress forwarding $peer1 -> $veth1, bypassing the veth pipe"
+	tc qdisc add dev $peer1 clsact
+	tc filter add dev $peer1 egress prio 20 proto ip flower \
+		action mirred ingress redirect dev $veth1
+}
+
+function test_run() {
+	echo "Run iperf"
+	iperf -s -D
+	timeout -k 2 10 ip netns exec $ns iperf -c 5.5.5.6 -i 1 -t 2 || fail "iperf failed"
+	echo "Test passed"
+}
+
+config
+test_run
+trap - EXIT
+cleanup
+
+
-- 
2.30.1

