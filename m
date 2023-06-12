Return-Path: <netdev+bounces-10144-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BAD0A72C8A9
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:35:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1BB61C20B6A
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7208117FFE;
	Mon, 12 Jun 2023 14:35:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630FA646
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:35:47 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2060.outbound.protection.outlook.com [40.107.92.60])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C6FE4C
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:35:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tv4s9AfYfBCTeO2tk0NEyeebGrPFv3Kvy1T8qjpYhhM9KJ7UTGQ4u7iCAreulbnqrsCL04ocPpV2AWeDT+cq0PxFrXcOepZEQ8fOxA/dUgD9OKrdDfh003OmGAsNzjs8k1BbOoWRTwic6aC/JenUlkyo6Pw7Y9NBiL9AGoydWkDuoXWJbhimRIgrIK1hzFCP6U78U+bt5xHcmjpV61WCN3yHvxJQDntf1ZckacFXwqLaDvYIZAQGrkVvfMmhgzrPBjocDMVWHPMrYItoN1jUSf4vwk964a5+C2vIm+UcX4o4VeJZVrHoQkbb5sD64RpRhRyhrRseP6JYVF+YyAwxkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ACuIxD0pKZKl2WTRbRAGDt5LlhbZUq9Xs5EbjOM2k1I=;
 b=nstTtQuF7eb10gJLodbugl3OuzHWzf/xCWJ9b1+7wNY6LFqmGT8/VXlfTFzKHJjEJm4SUGddbhGsA55n/Nvt3rCqwHJNKS0I9Q1IHzskVbw2UlMRGo+qeSmYycNLFqI2oaroj7IIcpkF3BYC69oYSqlevynJEFPSJcySbJWu8wQvd+zE9yV8zVwjXkK0QU0T+uvHXt6ffSc8QsPlUbcTRKgiaVi1PmWfDRoVgGv0mRdLKXro4VnMzGOX3F6ZNsBVcLvIbKdG36ZfxETaCIw27NpZSCJOu+SEE7ivfYIRQ1anypkMIrCYnMb3ffLrGGj3eppAJW2HJHyVBkZe7zX6ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ACuIxD0pKZKl2WTRbRAGDt5LlhbZUq9Xs5EbjOM2k1I=;
 b=m1ffD+lBhvsN0tunIM1L02ELaz755Kmcs3sG7pBMUjyoS97IK35tqfltBcQbhZH6P/Mo7XJk8s/2UldlBrfXL2VfiNNGXVyJ0rZw5aLaTQzEifk06//FRffXUSLWFxxnlX4wX0yRzA3xPDhSbfVkpnLRAUVX7gY3pVxaOzCU1QYa9FwlyUac1eXnRe5UvxfnyUI+DJKRg7pUiH7uov2eAjpTgtMOHHzMw1SjnszehLP64yGl4AGee1/9anpAL2ZZdJfuCQOhVqycU+b5RmRAHGTQVsaK06xondJtZ8uGi9l7pxjkpJqXOZdO7MesqX2JCGNkv7GIQxJ9NjBr+yTs7g==
Received: from CY5PR19CA0088.namprd19.prod.outlook.com (2603:10b6:930:83::7)
 by DM8PR12MB5432.namprd12.prod.outlook.com (2603:10b6:8:32::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 14:35:43 +0000
Received: from CY4PEPF0000E9D6.namprd05.prod.outlook.com
 (2603:10b6:930:83:cafe::9) by CY5PR19CA0088.outlook.office365.com
 (2603:10b6:930:83::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 14:35:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9D6.mail.protection.outlook.com (10.167.241.80) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 14:35:42 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 12 Jun 2023
 07:35:27 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Mon, 12 Jun 2023 07:35:24 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Shuah Khan <shuah@kernel.org>, Danielle Ratson <danieller@nvidia.com>,
	"Ido Schimmel" <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
	<mlxsw@nvidia.com>
Subject: [PATCH net] selftests: forwarding: hw_stats_l3: Set addrgenmode in a separate step
Date: Mon, 12 Jun 2023 16:34:58 +0200
Message-ID: <f3b05d85b2bc0c3d6168fe8f7207c6c8365703db.1686580046.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D6:EE_|DM8PR12MB5432:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f280cc4-f506-4379-e9b8-08db6b524cf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qSJbIh15dROny008eNiCHK0BX6QOZ9wyAbIVzSyK192ExsTbtQOpOjoAIkbWNP/PH+jMPT5VTpnHKzQGtq+jiWEtXw/IXWczRNT4Pn2XQxpY7SVEuDlWrt9rK8FeqoikDBxFjkN3h9VoKGVOb3GZmIHGq1ZzhR5pD3lBijyeiufh1hcC/GMLiUyFm+yJXWFOJA8WpMmF3gnsLey0Bc0uOJWhYBvys2J1gdhIdsjey1Q6WAHBAzebFt40mf2LIfNk8wFpPyrk2sq1LSjsQYjLzQlAGwVUa7sTFRpNGmpgDKOiAC7uddJP4lz8qg47gpOszLBbjd9jhsn4kJHUa/V43C4kljYqIQe7m/eErApOZCzBS3xfxImys5D9bL75SsRLrY3zhdjaoIg4qbExXhujheKI3L0x0vHnuf3nRm2MD3VvFX4+tY+0nX2XBWPp19mrPxr5YC0bTrxGQxSxy2x6u42Y4gNg2D92/b5+RVD80IDY7IOpElLY3Mzdve9Rg0dekONu59l6H+7wAS8CKtoTuOweeA2b2jMfHWvzAuzgfqd3o/T9GPh/51bnxuX8nKPTviEcFWIUJdIsNNYuE41ljFZk0XrtxV+13aQ8m9GGIJ6r0Gh8ok7ksdBXQxr+5113bqgu0L2lHYXW6i+06A9rdyYtyQgIOrimZFp5nG69NzYLFG9OBFIB06RYRSLY5rCYwQ1Go6pEMp7gv+zPRizPQrWHeo5mE0bHwYbNnmNjFsxR4eaRzj6t6cMc5MjEm5Dd
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(396003)(376002)(346002)(451199021)(36840700001)(46966006)(40470700004)(4326008)(66574015)(426003)(47076005)(70206006)(70586007)(336012)(36756003)(16526019)(186003)(478600001)(110136005)(2616005)(2906002)(54906003)(8676002)(316002)(41300700001)(82310400005)(107886003)(86362001)(7696005)(40460700003)(356005)(6666004)(36860700001)(7636003)(8936002)(83380400001)(82740400003)(5660300002)(26005)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 14:35:42.4744
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f280cc4-f506-4379-e9b8-08db6b524cf9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5432
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Danielle Ratson <danieller@nvidia.com>

Setting the IPv6 address generation mode of a net device during its
creation never worked, but after commit b0ad3c179059 ("rtnetlink: call
validate_linkmsg in rtnl_create_link") it explicitly fails [1]. The
failure is caused by the fact that validate_linkmsg() is called before
the net device is registered, when it still does not have an 'inet6_dev'.

Likewise, raising the net device before setting the address generation
mode is meaningless, because by the time the mode is set, the address
has already been generated.

Therefore, fix the test to first create the net device, then set its
IPv6 address generation mode and finally bring it up.

[1]
 # ip link add name mydev addrgenmode eui64 type dummy
 RTNETLINK answers: Address family not supported by protocol

Fixes: ba95e7930957 ("selftests: forwarding: hw_stats_l3: Add a new test")
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 tools/testing/selftests/net/forwarding/hw_stats_l3.sh | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/hw_stats_l3.sh b/tools/testing/selftests/net/forwarding/hw_stats_l3.sh
index 432fe8469851..48584a51388f 100755
--- a/tools/testing/selftests/net/forwarding/hw_stats_l3.sh
+++ b/tools/testing/selftests/net/forwarding/hw_stats_l3.sh
@@ -84,8 +84,9 @@ h2_destroy()
 
 router_rp1_200_create()
 {
-	ip link add name $rp1.200 up \
-		link $rp1 addrgenmode eui64 type vlan id 200
+	ip link add name $rp1.200 link $rp1 type vlan id 200
+	ip link set dev $rp1.200 addrgenmode eui64
+	ip link set dev $rp1.200 up
 	ip address add dev $rp1.200 192.0.2.2/28
 	ip address add dev $rp1.200 2001:db8:1::2/64
 	ip stats set dev $rp1.200 l3_stats on
@@ -256,9 +257,11 @@ reapply_config()
 
 	router_rp1_200_destroy
 
-	ip link add name $rp1.200 link $rp1 addrgenmode none type vlan id 200
+	ip link add name $rp1.200 link $rp1 type vlan id 200
+	ip link set dev $rp1.200 addrgenmode none
 	ip stats set dev $rp1.200 l3_stats on
-	ip link set dev $rp1.200 up addrgenmode eui64
+	ip link set dev $rp1.200 addrgenmode eui64
+	ip link set dev $rp1.200 up
 	ip address add dev $rp1.200 192.0.2.2/28
 	ip address add dev $rp1.200 2001:db8:1::2/64
 }
-- 
2.40.1


