Return-Path: <netdev+bounces-9904-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7232D72B1A5
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 13:23:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAC911C20A1A
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 11:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68481848D;
	Sun, 11 Jun 2023 11:23:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536C915BE
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 11:23:12 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20628.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::628])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6FF9123
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 04:23:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kzCgr8/I/zoXTSCVQDFuVVBZ542U8bBssmgTyS+EwcH48JwWe0XffotTmI+qP/VVSRhC5J5Nv91OAJsbEkcqewl7rCXQQYRwzEhxkzD+we1SvzEUxHFnQVRDHByWDDrjDeO6Ti+cq3zNktySfjBzy10BD8iszNJrKPP1tJHkgOa3l8I00Q71BXuj6BIiF1MaYAFdMs3Z6XwEhX4IL0jQXM4BaKG7LCcnNPryT0YuBvHa7nwysn9H/0KF1YPfPF6l4r5XV9NySK55smKAbiUrGFEQYE4jLdTW+V+VyFgi2I8b1ALEMMWkMmLgeRjbXxnSjQZjpgCPCZgA8MpK8R550w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P+ExLX6DxyzdCMc2+OGf7X1f4nxlh4oOAvHIB3DtjHo=;
 b=UyxmJH25PGV2nwdS+EvzB9Gb0D5R8GUXAe2f3T1ULfoVPJXdRcM3LS+s51pkMm1hsvQpbREho0lGD61JlGTUG4EV//jK9wEr1GVQoMAGJEnkEEOxJJj0D6mLfqOsWvXvpcvMMilaFdT4dgKgpiFpKRAx4N2QkxIX5bV7xBhU+dcmTtPIAYIRLz8Y9vVCHWZ2iFmJzApogPU0aBGCePqSmv5t8vGfnwe4QrducmDCKYIY0xFg1vT9Ype+5alENydqQ5JX3x6cZVtPvGGpjBt61akTj+KaXsvDzP2HhXLzm+/5zZeUHoZrdSpwHtWszBBXJpvzCWBARb8aiuLo3xrArQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P+ExLX6DxyzdCMc2+OGf7X1f4nxlh4oOAvHIB3DtjHo=;
 b=obB5anhCGFULuB+2DcCUjgAoGtNB+syWXGYlkq/mBet37EPZa5MSNEadlX9qHV2r9iweAP1xhOAiEE/S+l5qikksjByCLgUwUaREYbZfYaqL+vugr8aTzsnhbhTwHSPDZ56DC6TqyDDOhtfCwuV5d0RlOrPVE1y/lRcoV/+bMJJboxd0XOqTvHU4+ev50l7yFwnSuQavmGXxBBoz9Luyt0R7/wiBH7tqsud8CBB7ooyFNXOUH34/LgYUDGaMnbT7PHP4mwSa4j229BylWdYErxhS2tAppkaVcg4zPE0VxFGyM4A4wApBGQvNBrHEAxPuA40nRYi9jSJLJs6BqCLTxA==
Received: from SA9PR10CA0015.namprd10.prod.outlook.com (2603:10b6:806:a7::20)
 by SN7PR12MB7228.namprd12.prod.outlook.com (2603:10b6:806:2ab::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Sun, 11 Jun
 2023 11:23:08 +0000
Received: from SN1PEPF0002636E.namprd02.prod.outlook.com
 (2603:10b6:806:a7:cafe::a3) by SA9PR10CA0015.outlook.office365.com
 (2603:10b6:806:a7::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.32 via Frontend
 Transport; Sun, 11 Jun 2023 11:23:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002636E.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.21 via Frontend Transport; Sun, 11 Jun 2023 11:23:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Sun, 11 Jun 2023
 04:22:58 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Sun, 11 Jun 2023 04:22:55 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <razor@blackwall.org>, <petrm@nvidia.com>, "Ido
 Schimmel" <idosch@nvidia.com>
Subject: [PATCH net-next] selftests: forwarding: Fix layer 2 miss test syntax
Date: Sun, 11 Jun 2023 14:22:18 +0300
Message-ID: <20230611112218.332298-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636E:EE_|SN7PR12MB7228:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cf47f38-1d3c-43d9-0e9d-08db6a6e3bb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	UuaTn6dblEJCQJlbHR7jFjzHFCGRCO11OVCNtTUJeh7gRu9faOEXrx4HsSwe9TYPdB6Dwu5Yy9NwWB6pZUBkixqCd0pOJS76CdCxaVwKkuR7LXJBWwLmGkOudmlBMcmNjeU88S4t7v/s/s835IbwEMGQa9rK5WVaNRMzbNLVvHHuu0oiPDgE8bG4ADxppSzubMQMZVXbM1FFga2khzFHGhMF6jMrCmWUGqRvBlOVmVk8LAvM7KgL8a4jbxx6DNUFgyxNgihYeeAailyp1wzHVFX3G18TgEujIZioIe1dVVYhyyh8UenTJau9ioyo9iDYLjAoQTiP47RuNq2DOSi0l1oVVfwnneuoNddgUOj+LoTk+c225GjdndZmuwqumLsDE9dYitqMvQEVyJkJczq0s6r/z5TsHHBz8k19cjwop8dmWcp8Bc0kQCCVMex1Kg/kahCSUYSXsac+NMyq9XEJInk9gInmRbxWas5ZEQ2xa2dIs3fnlvgMQApQVJ5QN039h32EOGo24MxivLWq1I9kvn/EV2x5EH4ZWqadJqGZj2OLgdhgMiVCiCltsCFNseHOfBDEIWepGJcEOJziQY9HTFiAvFSggaRXAm6bEbWDGM1GYqyfK7OwQ2InHOsveg9HIN+9CW0n3dtiaRscKXhvph1t3sXQvm4KlXX0NPlS+URLmwzjBbf2KjP5bJZSaeV044mOdghUHT9x9z+epFzCDJgu0C1FnLMHCmN59X0wsjjs9vuCJc7JFnmTksZY1VNsaams/ZAx1DC43fIk1gDrX/Vy+ONvcfaBcBC0txmt0Qo=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(376002)(136003)(451199021)(36840700001)(46966006)(40470700004)(40460700003)(82310400005)(107886003)(1076003)(40480700001)(26005)(426003)(5660300002)(41300700001)(16526019)(186003)(36756003)(36860700001)(47076005)(336012)(316002)(70206006)(70586007)(966005)(8936002)(6666004)(82740400003)(478600001)(83380400001)(2616005)(54906003)(8676002)(86362001)(6916009)(2906002)(7636003)(4326008)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2023 11:23:08.2188
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cf47f38-1d3c-43d9-0e9d-08db6a6e3bb3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7228
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The test currently specifies "l2_miss" as "true" / "false", but the
version that eventually landed in iproute2 uses "1" / "0" [1]. Align the
test accordingly.

[1] https://lore.kernel.org/netdev/20230607153550.3829340-1-idosch@nvidia.com/

Fixes: 8c33266ae26a ("selftests: forwarding: Add layer 2 miss test cases")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/net/forwarding/tc_flower_l2_miss.sh  | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/tc_flower_l2_miss.sh b/tools/testing/selftests/net/forwarding/tc_flower_l2_miss.sh
index 37b0369b5246..e22c2d28b6eb 100755
--- a/tools/testing/selftests/net/forwarding/tc_flower_l2_miss.sh
+++ b/tools/testing/selftests/net/forwarding/tc_flower_l2_miss.sh
@@ -78,11 +78,11 @@ test_l2_miss_unicast()
 
 	# Unknown unicast.
 	tc filter add dev $swp2 egress protocol ipv4 handle 101 pref 1 \
-	   flower indev $swp1 l2_miss true dst_mac $dmac src_ip $sip \
+	   flower indev $swp1 l2_miss 1 dst_mac $dmac src_ip $sip \
 	   dst_ip $dip action pass
 	# Known unicast.
 	tc filter add dev $swp2 egress protocol ipv4 handle 102 pref 1 \
-	   flower indev $swp1 l2_miss false dst_mac $dmac src_ip $sip \
+	   flower indev $swp1 l2_miss 0 dst_mac $dmac src_ip $sip \
 	   dst_ip $dip action pass
 
 	# Before adding FDB entry.
@@ -134,11 +134,11 @@ test_l2_miss_multicast_common()
 
 	# Unregistered multicast.
 	tc filter add dev $swp2 egress protocol $proto handle 101 pref 1 \
-	   flower indev $swp1 l2_miss true src_ip $sip dst_ip $dip \
+	   flower indev $swp1 l2_miss 1 src_ip $sip dst_ip $dip \
 	   action pass
 	# Registered multicast.
 	tc filter add dev $swp2 egress protocol $proto handle 102 pref 1 \
-	   flower indev $swp1 l2_miss false src_ip $sip dst_ip $dip \
+	   flower indev $swp1 l2_miss 0 src_ip $sip dst_ip $dip \
 	   action pass
 
 	# Before adding MDB entry.
@@ -245,7 +245,7 @@ test_l2_miss_ll_multicast_common()
 	RET=0
 
 	tc filter add dev $swp2 egress protocol $proto handle 101 pref 1 \
-	   flower indev $swp1 l2_miss true dst_mac $dmac src_ip $sip \
+	   flower indev $swp1 l2_miss 1 dst_mac $dmac src_ip $sip \
 	   dst_ip $dip action pass
 
 	$MZ $mode $h1 -a own -b $dmac -t ip -A $sip -B $dip -c 1 -p 100 -q
@@ -296,10 +296,10 @@ test_l2_miss_broadcast()
 	RET=0
 
 	tc filter add dev $swp2 egress protocol all handle 101 pref 1 \
-	   flower l2_miss true dst_mac $dmac src_mac $smac \
+	   flower l2_miss 1 dst_mac $dmac src_mac $smac \
 	   action pass
 	tc filter add dev $swp2 egress protocol all handle 102 pref 1 \
-	   flower l2_miss false dst_mac $dmac src_mac $smac \
+	   flower l2_miss 0 dst_mac $dmac src_mac $smac \
 	   action pass
 
 	$MZ $h1 -a $smac -b $dmac -c 1 -p 100 -q
-- 
2.40.1


