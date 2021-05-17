Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B748E383B1D
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 19:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240084AbhEQRVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 13:21:04 -0400
Received: from azhdrrw-ex01.nvidia.com ([20.51.104.162]:1239 "EHLO
        AZHDRRW-EX01.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbhEQRVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 13:21:03 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 mxs.oss.nvidia.com (10.13.234.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.12; Mon, 17 May
 2021 10:04:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RGlg0ZJmqo9wDh8Djlu2H+1zxOujlAIrs9K7eFza40O0b2WyQEl925L448MaRaxYLv0eRF5zTUSo/2657r39N88XLYmIuNg/Zejk16gf5W7vMUX1mysD7vD9qkytE90tmDfI1T9NfDhmWP7oa39jYTpgvS60xts3bEFtxSxMyvfFVksGk2FE1TiwfCvfCI30zuDognqGnZhP0iemYqIRZ0+Qz96iqUustub1y9RByWX02LYbp+o2HKkjQ67jWZlE+1e53tLCawMGl5RoK/xfTBTIfrgbZ14/GJdwjOjtpqtBo6X2fJK2mm6BSwStdaUF79uFcKt05VQR8OkfZk2T5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0w+7ShTPONcTgf/CtKyyg/ky9YyQn2HfV3MzJ1vdTGQ=;
 b=oEaJrfjHEvt748sxaY0dT8kQzKAOTbgMfz7caesWFi2QtN3hAp00yVdZCPwa9QsxWFT8pXLFkTIPAdhAPpFhcDq82qWMcBLrJNuN4romkdw+1i7OZILudKuJcumIaxa7Fhqxoc31DeqoeLO7Td3W5jxMk7umeFr3Gl0alo8DJrVvILdJE+g7RVnonoDiolxLYGR99KZ0KTuzDj+EuuIrocaKWmiFYrvtHXQE5HcOnm4Q9pE2ngPd/eQcikL4JNXZmsTfWlg5g5NK39g4zHUfT3O5q7RYbSffCWouzG13fIM04g97tAS35C7LuewfR4Woscra69detVP5WihO1BKX7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0w+7ShTPONcTgf/CtKyyg/ky9YyQn2HfV3MzJ1vdTGQ=;
 b=kFAr0vJDUK1w6G4K7DfpD4wa6lybijRRCJjcAkb/A4bAXLAFjb31Lmnx+Z79hgJTlgeIVvDkLBlsL+elKrFR0FREBFiqCZ8dFjohdSfdd1UR4nyBHS4Ko38UBNWOU6AL2LW1XSv1+TrTMd1V+CcXEdu8+Tbc22mnWMUSG+yJ47AuHJVQdM0Hd7e2RAl9PQdSfVnznw/+QHIjoMZ8a3Nn3xaGB97qRQIk0kIRcwfKa17J1Nq/nqKdRyVTg1AOzwDyhKwFDWiPXBaxlILn/CvDeKlgZeW6asDRJlbsM12NUqAqdkn6EYk9ROjxraOpKfO+bXvYrOyVqWm0pagJC4hIuw==
Received: from DM5PR08CA0030.namprd08.prod.outlook.com (2603:10b6:4:60::19) by
 DM6PR12MB2956.namprd12.prod.outlook.com (2603:10b6:5:182::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.26; Mon, 17 May 2021 17:04:44 +0000
Received: from DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:60:cafe::72) by DM5PR08CA0030.outlook.office365.com
 (2603:10b6:4:60::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend
 Transport; Mon, 17 May 2021 17:04:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT030.mail.protection.outlook.com (10.13.172.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 17:04:44 +0000
Received: from shredder.mellanox.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 17:04:41 +0000
From:   Ido Schimmel <idosch@OSS.NVIDIA.COM>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@OSS.NVIDIA.COM>,
        <petrm@OSS.NVIDIA.COM>, <danieller@OSS.NVIDIA.COM>,
        <amcohen@OSS.NVIDIA.COM>, <mlxsw@OSS.NVIDIA.COM>,
        Ido Schimmel <idosch@OSS.NVIDIA.COM>
Subject: [PATCH net-next 03/11] selftests: mlxsw: qos_headroom: Convert to iproute2 dcb
Date:   Mon, 17 May 2021 20:03:53 +0300
Message-ID: <20210517170401.188563-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517170401.188563-1-idosch@nvidia.com>
References: <20210517170401.188563-1-idosch@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1bde70a-df23-4a96-c029-08d91955dea9
X-MS-TrafficTypeDiagnostic: DM6PR12MB2956:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2956303BE265BDAE76A8D8F2B22D9@DM6PR12MB2956.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zK28MEaAkGWGr3BbZTiYTCOKgPgMqjzHktWhwidgfHAajaBKqxtHAeE5Ved60DfHw8XdLY1D8LVClDeYBrqwae0FZIWjtJfYTnRVBpFGVfvTHNR1F1VUg4S9V1YmLCwuvHdBmpSVpf+3M03MA01+zaZUkbSQK+EqUPwAKhFR2pKPnvC0SrOSL3uWb+K5E7ApafwfIpMMkqdXOJs1UYBwmQnCPGsQb9/NkptoIx3HfMCxP1Q0l90+FjWsIB++mH1JyfmOvsyekJfKxzAiINV2nrxgkZXKhIquF0RkoQYBaR9a2zyCiTdh98X29/1bASwPH0A0bu3ZsZwCs/ZPsFGxqF1e4o4Cg/pAt51tMZ1BmlMQMHSFnxpiAaBXANLXe2jsZYTIi5A0n0FCXAkqU8qzT1dgkskQcBXu9iikCdQu/XBaP/3UNg3pX48tixaZlOPKGzrn6ofpcYUjWppnaaf5YZWIbocEUh/GeQ5wgWGnF3/wqbL1UMQHVzLd4p+I32b3S4B8ygLRt7ihC88Nzv8CPDi8xUq07aYlIyhZx9yzEmPvGLu9PTXgDoAz0rNZXpbYiilADmmpjVmkvymOw3DxvQq/BhbEsL5Ehru3fcv9y3eDN+jQWk8wOMKUx6I1nJiUHjWwMqM2WWbaRn+HGR6HlRpdnW55HESHAY3zYHhzFXJwLlfTyIFSDGS/iHLMXg03
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(39860400002)(36840700001)(46966006)(2906002)(82310400003)(5660300002)(16526019)(6666004)(36860700001)(83380400001)(70206006)(36756003)(70586007)(1076003)(47076005)(336012)(26005)(4326008)(478600001)(36906005)(316002)(54906003)(107886003)(2616005)(8676002)(7636003)(86362001)(186003)(6916009)(356005)(426003)(82740400003)(8936002)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 17:04:44.7077
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1bde70a-df23-4a96-c029-08d91955dea9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2956
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

There is a dedicated tool for configuration of DCB in iproute2 now. Use it
in the selftest instead of mlnx_qos.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../drivers/net/mlxsw/qos_headroom.sh         | 69 ++++++++++---------
 1 file changed, 35 insertions(+), 34 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_headroom.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_headroom.sh
index 27de3d9ed08e..f4493ef9cca1 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_headroom.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_headroom.sh
@@ -29,37 +29,38 @@ cleanup()
 
 get_prio_pg()
 {
-	__mlnx_qos -i $swp | sed -n '/^PFC/,/^[^[:space:]]/p' |
-		grep buffer | sed 's/ \+/ /g' | cut -d' ' -f 2-
+	# Produces a string of numbers "<B0> <B1> ... <B7> ", where BX is number
+	# of buffer that priority X is mapped to.
+	dcb -j buffer show dev $swp |
+		jq -r '[.prio_buffer | .[] | tostring + " "] | add'
 }
 
 get_prio_pfc()
 {
-	__mlnx_qos -i $swp | sed -n '/^PFC/,/^[^[:space:]]/p' |
-		grep enabled | sed 's/ \+/ /g' | cut -d' ' -f 2-
+	# Produces a string of numbers "<P0> <P1> ... <P7> ", where PX denotes
+	# whether priority X has PFC enabled (the value is 1) or disabled (0).
+	dcb -j pfc show dev $swp |
+		jq -r '[.prio_pfc | .[] | if . then "1 " else "0 " end] | add'
 }
 
 get_prio_tc()
 {
-	__mlnx_qos -i $swp | sed -n '/^tc/,$p' |
-		awk '/^tc/ { TC = $2 }
-		     /priority:/ { PRIO[$2]=TC }
-		     END {
-			for (i in PRIO)
-			    printf("%d ", PRIO[i])
-		     }'
+	# Produces a string of numbers "<T0> <T1> ... <T7> ", where TC is number
+	# of TC that priority X is mapped to.
+	dcb -j ets show dev $swp |
+		jq -r '[.prio_tc | .[] | tostring + " "] | add'
 }
 
 get_buf_size()
 {
 	local idx=$1; shift
 
-	__mlnx_qos -i $swp | grep Receive | sed 's/.*: //' | cut -d, -f $((idx + 1))
+	dcb -j buffer show dev $swp | jq ".buffer_size[$idx]"
 }
 
 get_tot_size()
 {
-	__mlnx_qos -i $swp | grep Receive | sed 's/.*total_size=//'
+	dcb -j buffer show dev $swp | jq '.total_size'
 }
 
 check_prio_pg()
@@ -121,18 +122,18 @@ test_dcb_ets()
 {
 	RET=0
 
-	__mlnx_qos -i $swp --prio_tc=0,2,4,6,1,3,5,7 > /dev/null
+	dcb ets set dev $swp prio-tc 0:0 1:2 2:4 3:6 4:1 5:3 6:5 7:7
 
 	check_prio_pg "0 2 4 6 1 3 5 7 "
 	check_prio_tc "0 2 4 6 1 3 5 7 "
 	check_prio_pfc "0 0 0 0 0 0 0 0 "
 
-	__mlnx_qos -i $swp --prio_tc=0,0,0,0,0,0,0,0 > /dev/null
+	dcb ets set dev $swp prio-tc all:0
 
 	check_prio_pg "0 0 0 0 0 0 0 0 "
 	check_prio_tc "0 0 0 0 0 0 0 0 "
 
-	__mlnx_qos -i $swp --prio2buffer=1,3,5,7,0,2,4,6 &> /dev/null
+	dcb buffer set dev $swp prio-buffer 0:1 1:3 2:5 3:7 4:0 5:2 6:4 7:6 2>/dev/null
 	check_fail $? "prio2buffer accepted in DCB mode"
 
 	log_test "Configuring headroom through ETS"
@@ -174,7 +175,7 @@ test_pfc()
 {
 	RET=0
 
-	__mlnx_qos -i $swp --prio_tc=0,0,0,0,0,1,2,3 > /dev/null
+	dcb ets set dev $swp prio-tc all:0 5:1 6:2 7:3
 
 	local buf0size=$(get_buf_size 0)
 	local buf1size=$(get_buf_size 1)
@@ -193,7 +194,7 @@ test_pfc()
 
 	RET=0
 
-	__mlnx_qos -i $swp --pfc=0,0,0,0,0,1,1,1 --cable_len=0 > /dev/null
+	dcb pfc set dev $swp prio-pfc all:off 5:on 6:on 7:on delay 0
 
 	check_prio_pg "0 0 0 0 0 1 2 3 "
 	check_prio_pfc "0 0 0 0 0 1 1 1 "
@@ -210,7 +211,7 @@ test_pfc()
 
 	RET=0
 
-	__mlnx_qos -i $swp --pfc=0,0,0,0,0,1,1,1 --cable_len=1000 > /dev/null
+	dcb pfc set dev $swp delay 1000
 
 	check_buf_size 0 "== $buf0size"
 	check_buf_size 1 "> $buf1size"
@@ -221,8 +222,8 @@ test_pfc()
 
 	RET=0
 
-	__mlnx_qos -i $swp --pfc=0,0,0,0,0,0,0,0 --cable_len=0 > /dev/null
-	__mlnx_qos -i $swp --prio_tc=0,0,0,0,0,0,0,0 > /dev/null
+	dcb pfc set dev $swp prio-pfc all:off delay 0
+	dcb ets set dev $swp prio-tc all:0
 
 	check_prio_pg "0 0 0 0 0 0 0 0 "
 	check_prio_tc "0 0 0 0 0 0 0 0 "
@@ -242,13 +243,13 @@ test_tc_priomap()
 {
 	RET=0
 
-	__mlnx_qos -i $swp --prio_tc=0,1,2,3,4,5,6,7 > /dev/null
+	dcb ets set dev $swp prio-tc 0:0 1:1 2:2 3:3 4:4 5:5 6:6 7:7
 	check_prio_pg "0 1 2 3 4 5 6 7 "
 
 	tc qdisc replace dev $swp root handle 1: bfifo limit 1.5M
 	check_prio_pg "0 0 0 0 0 0 0 0 "
 
-	__mlnx_qos -i $swp --prio2buffer=1,3,5,7,0,2,4,6 > /dev/null
+	dcb buffer set dev $swp prio-buffer 0:1 1:3 2:5 3:7 4:0 5:2 6:4 7:6
 	check_prio_pg "1 3 5 7 0 2 4 6 "
 
 	tc qdisc delete dev $swp root
@@ -256,9 +257,9 @@ test_tc_priomap()
 
 	# Clean up.
 	tc qdisc replace dev $swp root handle 1: bfifo limit 1.5M
-	__mlnx_qos -i $swp --prio2buffer=0,0,0,0,0,0,0,0 > /dev/null
+	dcb buffer set dev $swp prio-buffer all:0
 	tc qdisc delete dev $swp root
-	__mlnx_qos -i $swp --prio_tc=0,0,0,0,0,0,0,0 > /dev/null
+	dcb ets set dev $swp prio-tc all:0
 
 	log_test "TC: priomap"
 }
@@ -270,12 +271,12 @@ test_tc_sizes()
 
 	RET=0
 
-	__mlnx_qos -i $swp --buffer_size=$size,0,0,0,0,0,0,0 &> /dev/null
+	dcb buffer set dev $swp buffer-size all:0 0:$size 2>/dev/null
 	check_fail $? "buffer_size should fail before qdisc is added"
 
 	tc qdisc replace dev $swp root handle 1: bfifo limit 1.5M
 
-	__mlnx_qos -i $swp --buffer_size=$size,0,0,0,0,0,0,0 > /dev/null
+	dcb buffer set dev $swp buffer-size all:0 0:$size
 	check_err $? "buffer_size should pass after qdisc is added"
 	check_buf_size 0 "== $size" "set size: "
 
@@ -283,26 +284,26 @@ test_tc_sizes()
 	check_buf_size 0 "== $size" "set MTU: "
 	mtu_restore $swp
 
-	__mlnx_qos -i $swp --buffer_size=0,0,0,0,0,0,0,0 > /dev/null
+	dcb buffer set dev $swp buffer-size all:0
 
 	# After replacing the qdisc for the same kind, buffer_size still has to
 	# work.
 	tc qdisc replace dev $swp root handle 1: bfifo limit 1M
 
-	__mlnx_qos -i $swp --buffer_size=$size,0,0,0,0,0,0,0 > /dev/null
+	dcb buffer set dev $swp buffer-size all:0 0:$size
 	check_buf_size 0 "== $size" "post replace, set size: "
 
-	__mlnx_qos -i $swp --buffer_size=0,0,0,0,0,0,0,0 > /dev/null
+	dcb buffer set dev $swp buffer-size all:0
 
 	# Likewise after replacing for a different kind.
 	tc qdisc replace dev $swp root handle 2: prio bands 8
 
-	__mlnx_qos -i $swp --buffer_size=$size,0,0,0,0,0,0,0 > /dev/null
+	dcb buffer set dev $swp buffer-size all:0 0:$size
 	check_buf_size 0 "== $size" "post replace different kind, set size: "
 
 	tc qdisc delete dev $swp root
 
-	__mlnx_qos -i $swp --buffer_size=$size,0,0,0,0,0,0,0 &> /dev/null
+	dcb buffer set dev $swp buffer-size all:0 0:$size 2>/dev/null
 	check_fail $? "buffer_size should fail after qdisc is deleted"
 
 	log_test "TC: buffer size"
@@ -363,10 +364,10 @@ test_tc_int_buf()
 	tc qdisc replace dev $swp root handle 1: bfifo limit 1.5M
 	test_int_buf "TC: "
 
-	__mlnx_qos -i $swp --buffer_size=$size,0,0,0,0,0,0,0 > /dev/null
+	dcb buffer set dev $swp buffer-size all:0 0:$size
 	test_int_buf "TC+buffsize: "
 
-	__mlnx_qos -i $swp --buffer_size=0,0,0,0,0,0,0,0 > /dev/null
+	dcb buffer set dev $swp buffer-size all:0
 	tc qdisc delete dev $swp root
 }
 
-- 
2.31.1

