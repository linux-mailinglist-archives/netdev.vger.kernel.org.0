Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3209B6025DD
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 09:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbiJRHfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 03:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbiJRHfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 03:35:06 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2041.outbound.protection.outlook.com [40.107.212.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEDB2E9D8
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 00:35:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7ZmoCKDUYyrtu2iaFKx0vxbZd/fG8Jlmxv//sjjkcA697IJDCzJfse4mL6Oqd3jYcLaop8x+r7dRk4s9yGXUejnyHif8BMewAvT7qbP5FtNvLcWeHTHsLELdRX987PwU1BXF13+rUARqGGBLBRsy4HPgL4ZUr+pK9O78DDINYoYjHhUs6LlTezdujk/JyGAkCaAo65U4GmrQsz9Ikr7s1SJi6OXT/d19p6HGoGVU8BsdB6pH6RvL6gmjb0W/kY1uMIWEY7uybW9kPt84Z4Jd5FbodpVFI0IHjHdO9BeeglTl4q73omcbzH0xHCLK7qRtiZglpY4Mq9Lop6QWG2yEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nSywI2L6LWSiifBRkvAstQvN/bvIchH4WuI/ZOrWp5M=;
 b=brPB8d8z8/2zj4ZLoT0znS4i7GrAW180ENhFbP8CAKbMMhW2h4DIxL2/QVXm/BVBFTgr8L39qM/UBTvw+xggBnvZpBQ31aJBo3CPSh2YMNGMO2sDZeGEFfLkAyDWs/HMEw1GIBLk9A/KuyOITMlp++GMVXBa/r1dpBj1YC8GiJhOMF+lUM/CkTlM9czzS6NFBuIFHVFv0ZHV3kfRL4LGSNiA++GfL4OtzKAe17ucWgrtdhk79YaXWM0c2TQMihOVryJeSaNlgQdYTsawz2q6Shf8/UAXDdvVxJMMB+Q9RSbbDJ9LHK9bM3nTsjIRBpqf2B7xMSV+JykWhwAomrakew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=iogearbox.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nSywI2L6LWSiifBRkvAstQvN/bvIchH4WuI/ZOrWp5M=;
 b=rIvJ7J4OoFyVaGrw126wTycr7/wzWRbWklDGmxxa9BR88qdCmGe98YEnxu3HTQYC9YxAMfTq+cKMgnslX6+9BQoi4KuojkILvwcs0q1w5O9WYlRBrDjhPJdNSLCAW9S5cG0z7QgAjNEmZLzX9oMoSJ4u3/9gT+L9HvZ8tizlVTpW3lqfehav25cWXWcqVDZqJeeQA8ydMg93KlnoDoNdhzb6ks6IlE1QxgagvqeBtQlukaJcCUP4Uj0FXhGH7X8eyXEvKAP85mexB9YmtbTMfUzdL/1e0iPaQPTRovHFdhXOV44BamZScsavQxdw8qRqgH4NAETwoQ0kkcjuUMyzqw==
Received: from MW4PR04CA0286.namprd04.prod.outlook.com (2603:10b6:303:89::21)
 by MW4PR12MB6876.namprd12.prod.outlook.com (2603:10b6:303:208::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Tue, 18 Oct
 2022 07:35:02 +0000
Received: from CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::73) by MW4PR04CA0286.outlook.office365.com
 (2603:10b6:303:89::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30 via Frontend
 Transport; Tue, 18 Oct 2022 07:35:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1NAM11FT050.mail.protection.outlook.com (10.13.174.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.20 via Frontend Transport; Tue, 18 Oct 2022 07:35:01 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 18 Oct
 2022 00:34:51 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Tue, 18 Oct 2022 00:34:51 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.29
 via Frontend Transport; Tue, 18 Oct 2022 00:34:48 -0700
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
Subject: [PATCH net v4 2/2] selftests: add selftest for chaining of tc ingress handling to egress
Date:   Tue, 18 Oct 2022 10:34:39 +0300
Message-ID: <1666078479-11437-3-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1666078479-11437-1-git-send-email-paulb@nvidia.com>
References: <1666078479-11437-1-git-send-email-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT050:EE_|MW4PR12MB6876:EE_
X-MS-Office365-Filtering-Correlation-Id: f5cd2e19-2011-4d24-72d3-08dab0db4454
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: As/oVENdo78pCmZgpPUdpFRsOnnOp6hoJLj5FRTg1HCZiwzM0BkTCwqLrE2n/e6YOvaeXN8ZlX8EIVl8sPehXiuqx3frQOiAuzWRzIkvUj8DzLouVVDU6UB6HnziccidH6vGwraZfep35a3XSLUpFEYpa9M4hGGuQqdHDr0JhweYoA7noLObD8vOCwTUViTITMgqHuL03I4uLB+ovMCrR2DRRnTPRh+bVmiJd1tsxSuY5I0sxx3E+VnQAA8ltUmGJ2vSzcZp5NMNVU146C2TGeY7QplrKGOwJnrtT/vMdHvkpvojCxYfKia3y9inUoM/onNBzQW/9dLmL8QWKeiIdgu0/4DiHy1bYyeaExjLhDkh1WFHuuU6WrYh1gF3fOrS55rUcj1cjE5l4P1H+KIJjvVDZmCGbdPThnu8EmHZenho5ksBpq/8cAAdio0Lf2m6Wy4+E89Ul/YjFVc0Y6vIcUUPk7YOlB6wlPR4RWz4oS/Vw6mva//xxWnNEpuENpqiKeT3iOgzjQgr5tsCZj9MMzQv8pfv5Tm32yijghN8mGGJzgfVfZPXO4IOH3XCRQfSJ7zxY7cxQbB4bTWswO4xe5WpftVfat6jhTrjr+fwYu3ypYji4acQLzVFaSCdadDzEqcuw1C/8sYv0xGiGxUIK3bd7IjL3AevaTaxlLq8ab7yq+4ldkscG2qMaSGkHpjs1QWEfEKuwY9PxfAQcVvkXjXZucrQ+x1ZRNw6+xPA8gf8/uHGggSv2vCKTKTCYQS0PMrI/QlV4AlceVBTkqv3Tw==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(396003)(136003)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(316002)(2906002)(426003)(47076005)(336012)(186003)(82310400005)(82740400003)(7636003)(40480700001)(40460700003)(86362001)(356005)(36756003)(36860700001)(478600001)(54906003)(110136005)(6636002)(5660300002)(41300700001)(8936002)(2616005)(26005)(70206006)(8676002)(6666004)(4326008)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 07:35:01.6120
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5cd2e19-2011-4d24-72d3-08dab0db4454
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6876
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 tools/testing/selftests/net/Makefile          |  1 +
 .../net/test_ingress_egress_chaining.sh       | 79 +++++++++++++++++++
 2 files changed, 80 insertions(+)
 create mode 100644 tools/testing/selftests/net/test_ingress_egress_chaining.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 2a6b0bc648c4..69c58362c0ed 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -70,6 +70,7 @@ TEST_PROGS += io_uring_zerocopy_tx.sh
 TEST_GEN_FILES += bind_bhash
 TEST_GEN_PROGS += sk_bind_sendto_listen
 TEST_GEN_PROGS += sk_connect_zero_addr
+TEST_PROGS += test_ingress_egress_chaining.sh
 
 TEST_FILES := settings
 
diff --git a/tools/testing/selftests/net/test_ingress_egress_chaining.sh b/tools/testing/selftests/net/test_ingress_egress_chaining.sh
new file mode 100644
index 000000000000..08adff6bb3b6
--- /dev/null
+++ b/tools/testing/selftests/net/test_ingress_egress_chaining.sh
@@ -0,0 +1,79 @@
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
+ip_peer1=198.51.100.5
+ip_peer2=198.51.100.6
+
+function fail() {
+	echo "FAIL: $@" >> /dev/stderr
+	exit 1
+}
+
+function cleanup() {
+	killall -q -9 udpgso_bench_rx
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
+	ip addr add $ip_peer1/24 dev $peer1
+	ip link set $peer1 up
+	ip netns add $ns
+	ip link set dev $peer2 netns $ns
+	ip netns exec $ns ip addr add $ip_peer2/24 dev $peer2
+	ip netns exec $ns ip link set $peer2 up
+	ip link set $veth1 up
+	ip link set $veth2 up
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
+	echo "Run tcp traffic"
+	./udpgso_bench_rx -t &
+	sleep 1
+	ip netns exec $ns timeout -k 2 10 ./udpgso_bench_tx -t -l 2 -4 -D $ip_peer1 || fail "traffic failed"
+	echo "Test passed"
+}
+
+config
+test_run
+trap - EXIT
+cleanup
-- 
2.30.1

