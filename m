Return-Path: <netdev+bounces-12219-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77799736C3D
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:47:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3256F280E7D
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 12:47:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A489154A8;
	Tue, 20 Jun 2023 12:47:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF1D154A4
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 12:47:36 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B7010F8;
	Tue, 20 Jun 2023 05:47:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l5hKIAw3xv0dIpm5uzBI4KBh+HjjW/Hcj6jbgxFuPv+xvOkIK+giLSL5fCQcKUZtH94W+Lc3HKE9ZStK0+PkfQU+ggNET4kf98sF3phbbLl2G+VklYnLukfHuNHq0F7JDS4J16T5ARPn2JjDRhoK1U/OsBnqsmwz5Y2lRylC5nyHK/BydNvib0/VF0QU0lQxNB5t8DEHqlhl2kaGxPg9ZmMHsXAzd6WuvkkODqH8rhTSW39Eyn5FAe8o5Oeur7u195N3ZVtsrDfF6B9Cvgfm9vTsk0R5qoVOlZxwEc7feWfoK1RImD2Yr8/cX7wBi4K0ON1bpSqyNXFF5EzFZxlUtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ecB0MEaScDKpI6VFS9sI1CZgZI+wr2BPROOaXHBrcmc=;
 b=WMaw9zHfs91t1VrB6VGyxCTgbLu2m9tOuBz4pgfprdT0MfFpUbfcw75aW+2JZ2Ki7bzt8kQKX2usiwmD4CIKOxj7DOMPoCVuqU+obAffPQ5Zan6/lITRWg6mGWpLbr3EElB4ITInC7a5HQ7oNSwVi3vTy5FVgqqNovrc8ktJhI10MdggQ+V7ZMkVVk7ZGjBuwZ+snO24VNdpqGkgic9WK83VQ4X5R5vJmaOjEdZhljjDfhVhQyJu9bxIslu5NXRLKWlbissOR0q7QG7lEWfsM+FNMh2+86Zk4VqgSe/F6dSmzFFdgrnuHYuGbyWjF3bPaIVXS0HjJoerVNgMk2HaOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecB0MEaScDKpI6VFS9sI1CZgZI+wr2BPROOaXHBrcmc=;
 b=fK/nqqG0q/dxTHsR44DOfZvoOQ78Z13CriEWYOZIy+zJarJaaO2hpFpBuUqcKrpJZfD3qVZDIm8gjjJ+uuVFPZZ8fOHtfPonW6Ay89bOWTyzv1LsB2dsFr8qvWTZMXEWrUJJ+G+H0KAl8UA4RGyfd7Q53hDLT7H70YVL/OFj/7zqech4WPokdQ1lf4/vxvlGgytExJxsIjY1/qVjiXGhJQW9DwXoSY/cjqVvAprpZ9CbsCswMFcnn16dkljsfZLr3/zvNa3iQFUk4Tf5OvshN/iZUeaT5NjVSWvSook6jMFgI2NPur8g8IduFvO0WrN/+vte0pR9mfP0TRPx8yaGBw==
Received: from DM6PR11CA0057.namprd11.prod.outlook.com (2603:10b6:5:14c::34)
 by DM6PR12MB4090.namprd12.prod.outlook.com (2603:10b6:5:217::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 12:47:33 +0000
Received: from CY4PEPF0000EE3B.namprd03.prod.outlook.com
 (2603:10b6:5:14c:cafe::58) by DM6PR11CA0057.outlook.office365.com
 (2603:10b6:5:14c::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37 via Frontend
 Transport; Tue, 20 Jun 2023 12:47:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE3B.mail.protection.outlook.com (10.167.242.15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6521.17 via Frontend Transport; Tue, 20 Jun 2023 12:47:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 20 Jun 2023
 05:47:22 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 20 Jun 2023 05:47:18 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Petr Machata <petrm@nvidia.com>, Danielle Ratson <danieller@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>,
	<mlxsw@nvidia.com>
Subject: [PATCH net] selftests: forwarding: Fix race condition in mirror installation
Date: Tue, 20 Jun 2023 14:45:15 +0200
Message-ID: <268816ac729cb6028c7a34d4dda6f4ec7af55333.1687264607.git.petrm@nvidia.com>
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
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3B:EE_|DM6PR12MB4090:EE_
X-MS-Office365-Filtering-Correlation-Id: ca93189e-9e94-4f47-b452-08db718c8435
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BO/8vPiKYfHcOyRvnN/GQaHoTvAyQuHh4TT5DNlILx0QdfxtGOGYvVKDubUm3KjwZMMEI+xGuBkUXEM5EANb+7Tp4o6tE0/i/pTuDrc6HdD9TiUW2s3oYO7AY+AUF64tIhs0MqKSp2Dy2Kfh9+w/WnCB1aU047Y87Z0drStlFV1L5dmsBMQgNW/qVKZcuEBs8r9eMci2LjmuHMKnZ58ie2azQ1SH31KjvdYr5cv5u7H16mUUFmvpaZhg9dBt9i+vSR79/Y+VtOk5+WJphxKkd1Wn3nmo5/WrahSuA+1eqzNwKke+bwI4nNb0xnN/g6Nw7ig36psX0CisOFofZF1cqWrGNZLpjZ6RS75jEUXEZqWwCS840c0iD5QXaK0Sl5nwtpnAxDMCdSLRobO0zpOUF9bGZZQ6TuRsal1uNF++1xAExOwPwaahYzHaQxha7Fz7lEVItKc3WQLqPt5yV65lYAW7NAiyelFizSlulDux/Ok53mo9fYiw1adWtAesCmtE2mDIpEKKgBiBeZpsCJapwOzewUKvNdTk6xFSpECh0PQ6J2o8ZeNDRluPQRTA6haDShVAuvHE73c6N2fFkyyksm4xCvLwXQOHwkN/PIDwosFmQQ40zLjvL6uL7On1EFv06fq+k/GBbG4mM2PsfGlVxSLVeA9OCsiLI0dr5CPBT9MkxxlkYgLWhgPKTk0kuViSVOr0Fk6OYNckIK9eNXEkbiGchFuKAr1OtV0vJ71da9UDnMUmysX7mZ7g4+uf8NkY
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(396003)(39860400002)(451199021)(36840700001)(46966006)(40470700004)(8936002)(41300700001)(40460700003)(8676002)(82310400005)(478600001)(82740400003)(16526019)(356005)(7636003)(426003)(336012)(2616005)(6666004)(186003)(26005)(107886003)(36860700001)(7696005)(54906003)(47076005)(40480700001)(110136005)(86362001)(36756003)(316002)(4326008)(70206006)(70586007)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 12:47:32.9123
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca93189e-9e94-4f47-b452-08db718c8435
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4090
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Danielle Ratson <danieller@nvidia.com>

When mirroring to a gretap in hardware the device expects to be
programmed with the egress port and all the encapsulating headers. This
requires the driver to resolve the path the packet will take in the
software data path and program the device accordingly.

If the path cannot be resolved (in this case because of an unresolved
neighbor), then mirror installation fails until the path is resolved.
This results in a race that causes the test to sometimes fail.

Fix this by setting the neighbor's state to permanent in a couple of
tests, so that it is always valid.

Fixes: 35c31d5c323f ("selftests: forwarding: Test mirror-to-gretap w/ UL 802.1d")
Fixes: 239e754af854 ("selftests: forwarding: Test mirror-to-gretap w/ UL 802.1q")
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../testing/selftests/net/forwarding/mirror_gre_bridge_1d.sh  | 4 ++++
 .../testing/selftests/net/forwarding/mirror_gre_bridge_1q.sh  | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d.sh b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d.sh
index c5095da7f6bf..aec752a22e9e 100755
--- a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d.sh
@@ -93,12 +93,16 @@ cleanup()
 
 test_gretap()
 {
+	ip neigh replace 192.0.2.130 lladdr $(mac_get $h3) \
+		 nud permanent dev br2
 	full_test_span_gre_dir gt4 ingress 8 0 "mirror to gretap"
 	full_test_span_gre_dir gt4 egress 0 8 "mirror to gretap"
 }
 
 test_ip6gretap()
 {
+	ip neigh replace 2001:db8:2::2 lladdr $(mac_get $h3) \
+		nud permanent dev br2
 	full_test_span_gre_dir gt6 ingress 8 0 "mirror to ip6gretap"
 	full_test_span_gre_dir gt6 egress 0 8 "mirror to ip6gretap"
 }
diff --git a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q.sh b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q.sh
index 9ff22f28032d..0cf4c47a46f9 100755
--- a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q.sh
@@ -90,12 +90,16 @@ cleanup()
 
 test_gretap()
 {
+	ip neigh replace 192.0.2.130 lladdr $(mac_get $h3) \
+		 nud permanent dev br1
 	full_test_span_gre_dir gt4 ingress 8 0 "mirror to gretap"
 	full_test_span_gre_dir gt4 egress 0 8 "mirror to gretap"
 }
 
 test_ip6gretap()
 {
+	ip neigh replace 2001:db8:2::2 lladdr $(mac_get $h3) \
+		nud permanent dev br1
 	full_test_span_gre_dir gt6 ingress 8 0 "mirror to ip6gretap"
 	full_test_span_gre_dir gt6 egress 0 8 "mirror to ip6gretap"
 }
-- 
2.40.1


