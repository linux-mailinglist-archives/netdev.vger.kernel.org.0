Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC7B95FC1EF
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 10:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiJLIYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 04:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiJLIYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 04:24:40 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BE31008
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 01:24:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cOd3BfFBg7S+s5tALYys6z8zAyPNRErrCE+8Xxm5vlXax2z9kZpTKK4/fFCCscgJTwKOvJp/rUR1ScM9BdjTz5JEY8hbVCDgR3/AXMu5ZERMNBFkbuZbbTNm24WZfXrQDA3102HPHKKhyBX6d6I2+au3gCRoQiSoXO4DPFJf98fhH/nmjVKVUrqmJmp0eRrEPnuOzJUUshhjwQIME7EdITZFbUK4GI8m77IVj5KQYt+a6VQa9i/1JnjKoTVDGYFBl7jyZ2fL1PBYxkmPrPkduzNFlOWWyf659pNf6zqtJ413r0iYItEl8jPTJ2wjxdQEiVd+w8XvLkFXUA46HZpVxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XSuDvGbKwxdNQgNhsJ7mG3W+Ij1DzTLf/zWAtuT5k+0=;
 b=mUQ29VyPS5y77Ya4cbH03gOepnhb/hLhYbNQHI+SzuxoWtF2ZSDs+hgy5BwjQhkCjoqWNgwhcKgBdJsfy956vx8RA9Ad10MauWQv99VWY+b7eqPgqTYgJRGh0WOLQePJ2fKl3aHFoCL2TDj4C/42BLW707dacZsTKrCoxXOG4r4eWK+H3rIeZSeIYQ9hF8B9asKcE87U3h3/a3BjAsSxFM+eSMD4LaD1fyNCfA2zROUea6MNnsQ8N6ovofnP8YOluc0YeIDt0sCHFqZpR2oG3j7NwjUqTmgQYnk39WKX361nwnyBikaTJSsARrzgHAzfGGvYSaIyTN8YeGc0sl40dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=iogearbox.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XSuDvGbKwxdNQgNhsJ7mG3W+Ij1DzTLf/zWAtuT5k+0=;
 b=tikUZiCencVEud1dMY1fkuxivx2f2mP7NSiJo4SxvLeH9WaOau7d3EDMR+YSGOcjULN9DZUcYvDVxvvKYNxsEb2DPAtfV882lB+YQs9X5DVwfOp00ghyYHnC9kfunPMESaCeyYPDXLTYNiIysRYTseP1C2xZAYpYZ/y+aZK5X3fSzttqPqRgBfmLmV9a61XOcE55l6t4rBkuVKLcxhCRm9OD+1Z2k1oJe0JU8SFBZUag4yGKJJ6omVgj6SHVGKrZPA7IBgHdBL7gxAqWNLx26XbqI2RCUpCjLM6v1sE+CGTz3iMw9LyJMML0xAfg9X4IOIH23FJY06okkqkakPbSmw==
Received: from MW4PR03CA0012.namprd03.prod.outlook.com (2603:10b6:303:8f::17)
 by BL1PR12MB5377.namprd12.prod.outlook.com (2603:10b6:208:31f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Wed, 12 Oct
 2022 08:24:37 +0000
Received: from CO1NAM11FT100.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::82) by MW4PR03CA0012.outlook.office365.com
 (2603:10b6:303:8f::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.22 via Frontend
 Transport; Wed, 12 Oct 2022 08:24:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT100.mail.protection.outlook.com (10.13.175.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.20 via Frontend Transport; Wed, 12 Oct 2022 08:24:36 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 12 Oct
 2022 01:24:27 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 12 Oct
 2022 01:24:26 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.29 via
 Frontend Transport; Wed, 12 Oct 2022 01:24:24 -0700
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
Date:   Wed, 12 Oct 2022 11:24:13 +0300
Message-ID: <1665563053-29263-3-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1665563053-29263-1-git-send-email-paulb@nvidia.com>
References: <1665563053-29263-1-git-send-email-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT100:EE_|BL1PR12MB5377:EE_
X-MS-Office365-Filtering-Correlation-Id: 565a3bb9-f2c6-4ff2-1bcd-08daac2b32d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: of811gsZOaGlWoSHp0r9gRvor5/mtA7YoxIXTKis6qK6LNha2V18JtPwdfaUbYNkxaoVlW8duD/fZOG2jtPqUrROBPvOs76N1dHyYnib2QFI20IRwUlEk8Gw1u+Ub9fz60J5p0y+hmBiHVQNa5C53ilHIDOcQDN81CN93DDmpKB2K6rC/KVyoSyTjVT0gqsj9+SQUz2fYVvh8nPKKIkSk3rutnm2u9ZyvtjffU7PYe/NAi3ySzkZovftCI1+crtV5TTkpsXO5n+xJTShjO7aYfJgZ0/DiqqqAmMTzABXSbnRlsBlSZCjq9o35PJuZ972lT0PaZ83Jbk9GGrcmnuj7f4/WrK4shGtZNZA+MRPswEcE0RZl1AuW7mYXnVq5tBOlGFMVZ2aZ/1vSuvvz2+CV5UvdNZ3x3T+XiUIf1DmHGGbIpuq6sxXzySbQAtVuXG9KTM1GIcA53P7axkURiEufJW9RFmyRUiKEjIuD5Pf04uhQxIZTmd4cCUHcpRxVkVqQaUO1otvfG8rrO9TO9iIDNtTP4ebLsZ3+8SrEMVDCg5/2hi6FDniautz/E3hAIYvActOl2yjK07lwpbyCE1B4zpcSNveVMeCkchOvLrUaP6Udx13xilRIDFVtenpr83dEeK1mrg6X+vcBuZl4cMyxVkaJT37EXQqija1tBFyej5EUVTd0BeJiHbPsqBEDsoBF1J0NXZ8BZ14wQ0oAGpZOqIExnlk/0erOTrLsYJSnZHJOKqRRi2DLHim/gUx2q+5Ohr1GI+rfK+EEonma49I/A==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(376002)(346002)(396003)(451199015)(40470700004)(46966006)(36840700001)(426003)(47076005)(2906002)(2616005)(40460700003)(36756003)(86362001)(40480700001)(8676002)(4326008)(6666004)(41300700001)(7636003)(82740400003)(356005)(82310400005)(36860700001)(336012)(186003)(5660300002)(110136005)(54906003)(478600001)(6636002)(8936002)(26005)(70586007)(70206006)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 08:24:36.1454
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 565a3bb9-f2c6-4ff2-1bcd-08daac2b32d2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT100.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5377
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 .../net/test_ingress_egress_chaining.sh       | 81 +++++++++++++++++++
 2 files changed, 82 insertions(+)
 create mode 100644 tools/testing/selftests/net/test_ingress_egress_chaining.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index c0ee2955fe54..f4774717c5b6 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -63,6 +63,7 @@ TEST_GEN_FILES += cmsg_sender
 TEST_GEN_FILES += stress_reuseport_listen
 TEST_PROGS += test_vxlan_vnifiltering.sh
 TEST_GEN_FILES += io_uring_zerocopy_tx
+TEST_PROGS += test_ingress_egress_chaining.sh
 
 TEST_FILES := settings
 
diff --git a/tools/testing/selftests/net/test_ingress_egress_chaining.sh b/tools/testing/selftests/net/test_ingress_egress_chaining.sh
new file mode 100644
index 000000000000..193d92078ae0
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
+
+
-- 
2.30.1

