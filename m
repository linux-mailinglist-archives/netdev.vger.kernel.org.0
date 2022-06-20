Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534405520D7
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242360AbiFTP1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242342AbiFTP1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:27:45 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFE0219
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:27:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xq1q6wjijHWpufGri6YwmcugzXMmjjSgEKAD4JPurrX9Y1QR5uNtcMBbMIFEWrB7fkWXaJZFUPfNA+wSj1G1rQih2bKt79MG1Rbr1xb18izsEHxZ9JnkKTCXEk14Kub05u1AIEawEypitB9t/LfqJvni+YQr5CKSwz0Y0mKVjAzaxKdz3kO5ZHBASPziS+FkiS6CX1squDkzg62bV/og6fJsBc6wIgT9hme22DZLFSYjv3O7Ekkhsu1P6dtJBw8Z0iRDtze2EyAOboO78R+G/rLNh0AZj410CciepCLuPLjD+ANb/CSRIyHG4vKu/EofJqJKTcsDzvdVisILSZt7cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j651VUBtk9j3cjpSaA+14XhYLr5unDGdfaCvNVzsnCo=;
 b=T5DqtcbNGXLtTEMrmxE1y+LVZvihUxxSeMhcEcV7AC/mJOyZigRj6YiPHsOA/wMeyDlIGO09oJLA2W6gFtgcyBUBwSY6Zfd3zJDiNybzPfMUH4qJbGFs7CjpPZG422pUzn4qOIrKigc0RqGDwKXAVlMnNE0N9/TUuseJaO2bukUp8AbVrAjCnr5OlH4+4RKbpflMdixjhJ22ZfXBLWbSRuwa8AvZsVikJ4trle5J5lLOvIEvtSuO/x+1JVwlt525PQBcJyS/Vf4+iepaxIvXTAW2cKcWjIOABoC9qtf2wV+m5qHa+tRtA4nUMS5uNV9SXUwIZEyx27upgeyHihRA/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j651VUBtk9j3cjpSaA+14XhYLr5unDGdfaCvNVzsnCo=;
 b=ZcBUfbFoETvJk+yebG1y+8j/uqiNQHOPKpWlyWth9Tz92kLG4afKx6k41SY6D3yjegtEr0e6DYNNHmjnPlAv4a+U9h00hVOtK3L8dN7k+KRU845FbfqjLHSf5BSqia6WHiuzrFBqSMovo+whmcdtCNIK1wwLwUOOMHUFD63yW127A4rF0qpUIvTQWR2TrM5optvmmmMnNGZLIu89MiEXvimsJsSyq4uWxA/FXPnroCnH7a//YD/pXC1QMhbf2y0kY6khtRZVQMIqhJVC8oa1ergVMD2yiXphcWFdi92hTQ5LglCyRARAyhrlK734XdiKpAkUimUxkfPB8WNv8sJlwA==
Received: from MWHPR15CA0066.namprd15.prod.outlook.com (2603:10b6:301:4c::28)
 by DM4PR12MB5722.namprd12.prod.outlook.com (2603:10b6:8:5d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Mon, 20 Jun
 2022 15:27:39 +0000
Received: from CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4c:cafe::f6) by MWHPR15CA0066.outlook.office365.com
 (2603:10b6:301:4c::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22 via Frontend
 Transport; Mon, 20 Jun 2022 15:27:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT065.mail.protection.outlook.com (10.13.174.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 15:27:38 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 20 Jun 2022 15:27:38 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 20 Jun 2022 08:27:37 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 20 Jun 2022 08:27:35 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Dima Chumak <dchumak@nvidia.com>
Subject: [PATCH net-next 4/5] selftest: netdevsim: Add devlink rate police sub-test
Date:   Mon, 20 Jun 2022 18:26:46 +0300
Message-ID: <20220620152647.2498927-5-dchumak@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220620152647.2498927-1-dchumak@nvidia.com>
References: <20220620152647.2498927-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a74e5a58-57a2-4c9b-e411-08da52d168f0
X-MS-TrafficTypeDiagnostic: DM4PR12MB5722:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB57226FC550BDE94C879DA5EAD5B09@DM4PR12MB5722.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0eSoCQaXPDkJAerN6AnZGM3vhzgxmU5aEdhQUiON+SmXyKlXoqeWcDH70i0UV0mhH4hJnF1Lqm3Dnvr5WfZxD4B8dpwhbIx7MfoKPlw8IkAr+oynB8t8hvKf3Pp0FD7WqTEp1+GOaK947m9Gtx3II7FkECXG3k9Uhl9I3LjPaTn2NvF5aV3v5hLBFN6ezGAiQT78UrjN0KCTofRVokWg+qA8FUp99AZwv9gPltyLzh4cEpbCuTBiAiKVLUFQRhCem2N6qkdlsRtrEWFVAL3U/j57iWv33bIgDA572bZQ/WcuEH2dDtdhL2TReN2bQLuwgC8nWhQGzBS6SonajUetaNbW1n6QRs1BT/nNJ8zzWDF6RUqEauVngvsIMzoKboPmCrAqPKwIBgPfcVzroTLM4Y2OwPTcy/x93CDYtLgT0skTtF+lmsC76PJUP/2fDKoyfR6ofD3frv4/CByo/J+uiKE5huezHrcqw3ol3leBL558blk7rTGcvVVelFuo5pLnnAcMIpjE9q5IQtxE6+Xib4ksQV0ZSldKzGT54BxRqHSLTbdCnOv8k64UcmNv7GEOKrwH4gMCvP7eGIX4hdqU8uIENKMdMhP+yqwCCV1zB5V9auylGcqLLN1mtYEYqw9gT+z8qWZsTx7PJuoEUI4OktbbTGF9xM1fZYzKdu6hd120ssxWO0T5y3+I5/lhiLIYOjTXE23ImRLkeeUD3sY5tzYRPkgym96oPoSfvjq4K+MNM1cPwiycDIX0d25DIorR
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(396003)(136003)(40470700004)(36840700001)(46966006)(316002)(2906002)(8676002)(82740400003)(4326008)(1076003)(47076005)(478600001)(2616005)(26005)(83380400001)(6916009)(7696005)(54906003)(40460700003)(70206006)(70586007)(107886003)(8936002)(6666004)(82310400005)(40480700001)(5660300002)(36756003)(36860700001)(356005)(186003)(336012)(41300700001)(81166007)(426003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 15:27:38.7356
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a74e5a58-57a2-4c9b-e411-08da52d168f0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5722
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test verifies that netdevsim VFs and groups can set and retrieve
the new rate limit_type police attributes via devlink API.

Signed-off-by: Dima Chumak <dchumak@nvidia.com>
---
 .../drivers/net/netdevsim/devlink.sh          | 215 ++++++++++++++++--
 1 file changed, 200 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 9de1d123f4f5..40392dcbb30e 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -534,6 +534,15 @@ rate_attr_set()
 	devlink port function rate set $handle $name $value$units
 }
 
+rate_police_attr_set()
+{
+	local handle=$1
+	local name=$2
+	local value=$3
+
+	devlink port function rate set $handle limit_type police $name $value
+}
+
 rate_attr_get()
 {
 	local handle=$1
@@ -542,7 +551,7 @@ rate_attr_get()
 	cmd_jq "devlink port function rate show $handle -j" '.[][].'$name
 }
 
-rate_attr_tx_rate_check()
+rate_attr_shaping_rate_check()
 {
 	local handle=$1
 	local name=$2
@@ -563,6 +572,35 @@ rate_attr_tx_rate_check()
 	check_err $? "Unexpected $name attr value $api_value != $rate"
 }
 
+rate_attr_police_rate_check()
+{
+	local handle=$1
+	local name=$2
+	local rate=$3
+	local debug_file=$4
+
+	rate_police_attr_set $handle $name $rate
+	check_err $? "Failed to set $name value"
+
+	local debug_value=$(cat $debug_file)
+	check_err $? "Failed to read $name value from debugfs"
+
+	# undo bits->bytes conversion forced by devlink
+	case $name in ([rt]x_max) debug_value=$((debug_value * 8)) ;; esac
+
+	[ "$debug_value" == "$rate" ]
+	check_err $? "Unexpected $name debug value $debug_value != $rate"
+
+	local api_value=$(rate_attr_get $handle $name)
+	check_err $? "Failed to get $name attr value"
+
+	# undo bits->bytes conversion forced by devlink
+	case $name in ([rt]x_max) api_value=$((api_value * 8)) ;; esac
+
+	[ "$api_value" == "$rate" ]
+	check_err $? "Unexpected $name attr value $api_value != $rate"
+}
+
 rate_attr_parent_check()
 {
 	local handle=$1
@@ -586,8 +624,9 @@ rate_attr_parent_check()
 rate_node_add()
 {
 	local handle=$1
+	local limit_type=${2:+limit_type $2}
 
-	devlink port function rate add $handle
+	devlink port function rate add $handle $limit_type
 }
 
 rate_node_del()
@@ -597,21 +636,14 @@ rate_node_del()
 	devlink port function rate del $handle
 }
 
-rate_test()
+rate_shaping_test()
 {
-	RET=0
-
-	echo $VF_COUNT > /sys/bus/netdevsim/devices/$DEV_NAME/sriov_numvfs
-	devlink dev eswitch set $DL_HANDLE mode switchdev
-	local leafs=`rate_leafs_get $DL_HANDLE`
-	local num_leafs=`echo $leafs | wc -w`
-	[ "$num_leafs" == "$VF_COUNT" ]
-	check_err $? "Expected $VF_COUNT rate leafs but got $num_leafs"
+	local leafs=$1
 
 	rate=10
 	for r_obj in $leafs
 	do
-		rate_attr_tx_rate_check $r_obj tx_share $rate \
+		rate_attr_shaping_rate_check $r_obj tx_share $rate \
 			$DEBUGFS_DIR/ports/${r_obj##*/}/tx_share
 		rate=$(($rate+10))
 	done
@@ -619,11 +651,19 @@ rate_test()
 	rate=100
 	for r_obj in $leafs
 	do
-		rate_attr_tx_rate_check $r_obj tx_max $rate \
+		rate_attr_shaping_rate_check $r_obj tx_max $rate \
 			$DEBUGFS_DIR/ports/${r_obj##*/}/tx_max
 		rate=$(($rate+100))
 	done
 
+	for r_obj in $leafs
+	do
+		rate_attr_shaping_rate_check $r_obj tx_share 0 \
+			$DEBUGFS_DIR/ports/${r_obj##*/}/tx_share
+		rate_attr_shaping_rate_check $r_obj tx_max 0 \
+			$DEBUGFS_DIR/ports/${r_obj##*/}/tx_max
+	done
+
 	local node1_name='group1'
 	local node1="$DL_HANDLE/$node1_name"
 	rate_node_add "$node1"
@@ -634,11 +674,11 @@ rate_test()
 	check_err $? "Expected 1 rate node in output but got $num_nodes"
 
 	local node_tx_share=10
-	rate_attr_tx_rate_check $node1 tx_share $node_tx_share \
+	rate_attr_shaping_rate_check $node1 tx_share $node_tx_share \
 		$DEBUGFS_DIR/rate_nodes/${node1##*/}/tx_share
 
 	local node_tx_max=100
-	rate_attr_tx_rate_check $node1 tx_max $node_tx_max \
+	rate_attr_shaping_rate_check $node1 tx_max $node_tx_max \
 		$DEBUGFS_DIR/rate_nodes/${node1##*/}/tx_max
 
 	rate_node_del "$node1"
@@ -668,6 +708,151 @@ rate_test()
 	check_err $? "Failed to unset $r_obj parent node"
 	rate_node_del "$node1"
 	check_err $? "Failed to delete node $node1"
+}
+
+rate_police_test()
+{
+	local leafs=$1
+
+	local rate=$((100 * 1000**2 * 8))
+	for r_obj in $leafs
+	do
+		rate_attr_police_rate_check $r_obj tx_max $rate \
+			$DEBUGFS_DIR/ports/${r_obj##*/}/tx_max
+		rate=$(($rate + 10 * 1000**2 * 8))
+	done
+
+	local size=$((1024**2))
+	for r_obj in $leafs
+	do
+		rate_attr_police_rate_check $r_obj tx_burst $size \
+			$DEBUGFS_DIR/ports/${r_obj##*/}/tx_burst
+		size=$(($size * 2))
+	done
+
+	rate=$((100 * 1000**2 * 8))
+	for r_obj in $leafs
+	do
+		rate_attr_police_rate_check $r_obj rx_max $rate \
+			$DEBUGFS_DIR/ports/${r_obj##*/}/rx_max
+		rate=$(($rate + 10 * 1000**2 * 8))
+	done
+
+	size=$((1024**2))
+	for r_obj in $leafs
+	do
+		rate_attr_police_rate_check $r_obj rx_burst $size \
+			$DEBUGFS_DIR/ports/${r_obj##*/}/rx_burst
+		size=$(($size * 2))
+	done
+
+	local packets=1000
+	for r_obj in $leafs
+	do
+		rate_attr_police_rate_check $r_obj tx_pkts $packets \
+			$DEBUGFS_DIR/ports/${r_obj##*/}/tx_pkts
+		packets=$(($packets * 2))
+	done
+
+	size=$((1024**2))
+	for r_obj in $leafs
+	do
+		rate_attr_police_rate_check $r_obj tx_pkts_burst $size \
+			$DEBUGFS_DIR/ports/${r_obj##*/}/tx_pkts_burst
+		size=$(($size * 2))
+	done
+
+	packets=1000
+	for r_obj in $leafs
+	do
+		rate_attr_police_rate_check $r_obj rx_pkts $packets \
+			$DEBUGFS_DIR/ports/${r_obj##*/}/rx_pkts
+		packets=$(($packets * 2))
+	done
+
+	size=$((1024**2))
+	for r_obj in $leafs
+	do
+		rate_attr_police_rate_check $r_obj rx_pkts_burst $size \
+			$DEBUGFS_DIR/ports/${r_obj##*/}/rx_pkts_burst
+		size=$(($size * 2))
+	done
+
+	local node1_name='group1'
+	local node1="$DL_HANDLE/$node1_name"
+	rate_node_add "$node1" police
+	check_err $? "Failed to add node $node1"
+
+	local num_nodes=`rate_nodes_get $DL_HANDLE | wc -w`
+	[ $num_nodes == 1 ]
+	check_err $? "Expected 1 rate node in output but got $num_nodes"
+
+	rate_attr_police_rate_check $node1 tx_max $((200 * 1000**2 * 8)) \
+		$DEBUGFS_DIR/rate_nodes/${node1##*/}/tx_max
+
+	rate_attr_police_rate_check $node1 tx_burst $((2 * 1024**2)) \
+		$DEBUGFS_DIR/rate_nodes/${node1##*/}/tx_burst
+
+	rate_attr_police_rate_check $node1 rx_max $((300 * 1000**2 * 8)) \
+		$DEBUGFS_DIR/rate_nodes/${node1##*/}/rx_max
+
+	rate_attr_police_rate_check $node1 rx_burst $((3 * 1024**2)) \
+		$DEBUGFS_DIR/rate_nodes/${node1##*/}/rx_burst
+
+	rate_attr_police_rate_check $node1 tx_pkts 4000 \
+		$DEBUGFS_DIR/rate_nodes/${node1##*/}/tx_pkts
+
+	rate_attr_police_rate_check $node1 tx_pkts_burst $((4 * 1024**2)) \
+		$DEBUGFS_DIR/rate_nodes/${node1##*/}/tx_pkts_burst
+
+	rate_attr_police_rate_check $node1 rx_pkts 5000 \
+		$DEBUGFS_DIR/rate_nodes/${node1##*/}/rx_pkts
+
+	rate_attr_police_rate_check $node1 rx_pkts_burst $((5 * 1024**2)) \
+		$DEBUGFS_DIR/rate_nodes/${node1##*/}/rx_pkts_burst
+
+	rate_node_del "$node1"
+	check_err $? "Failed to delete node $node1"
+	num_nodes=`rate_nodes_get $DL_HANDLE | wc -w`
+	[ $num_nodes == 0 ]
+	check_err $? "Expected 0 rate node but got $num_nodes"
+
+	rate_node_add "$node1" police
+	check_err $? "Failed to add node $node1"
+
+	rate_attr_parent_check $r_obj $node1_name \
+		$DEBUGFS_DIR/ports/${r_obj##*/}/rate_parent
+
+	local node2_name='group2'
+	local node2="$DL_HANDLE/$node2_name"
+	rate_node_add "$node2" police
+	check_err $? "Failed to add node $node2"
+
+	rate_attr_parent_check $node2 $node1_name \
+		$DEBUGFS_DIR/rate_nodes/$node2_name/rate_parent
+	rate_node_del "$node2"
+	check_err $? "Failed to delete node $node2"
+	rate_attr_set "$r_obj" noparent
+	check_err $? "Failed to unset $r_obj parent node"
+	rate_node_del "$node1"
+	check_err $? "Failed to delete node $node1"
+}
+
+rate_test()
+{
+	RET=0
+
+	echo $VF_COUNT > /sys/bus/netdevsim/devices/$DEV_NAME/sriov_numvfs
+	devlink dev eswitch set $DL_HANDLE mode switchdev
+	local leafs=`rate_leafs_get $DL_HANDLE`
+	local num_leafs=`echo $leafs | wc -w`
+	[ "$num_leafs" == "$VF_COUNT" ]
+	check_err $? "Expected $VF_COUNT rate leafs but got $num_leafs"
+
+	rate_shaping_test "$leafs"
+	if devlink port function rate help |& grep -qF 'limit_type police' ; then
+		rate_police_test "$leafs"
+	fi
 
 	log_test "rate test"
 }
-- 
2.36.1

