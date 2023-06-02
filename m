Return-Path: <netdev+bounces-7495-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9AA272077A
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:23:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84C04281A3C
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:23:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 547031D2AC;
	Fri,  2 Jun 2023 16:22:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412D51C750
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 16:22:29 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A661AB;
	Fri,  2 Jun 2023 09:22:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bj5dw4LPZmTtOeEMTFfvCr6uxy/3aFt0yTCSJktv6x3wxYrwrJZI5GmQWrfludshn7bEg1eRLfMA1XuwopaJ5ezGYmhme7gWc8UWJZE8FY3OMC3q5go58mqZeKP4tX9FOG5mWV2FpFpXSfK0drk9acb0AKNJ04jvAq5/3qzvFMqf68CwtKvTD81ruTOLFzgfcLFk1j6fQWo3ogrgiuyneL+9YHK2jY11cHrfjRSOn/P0UTl02TR7vfnL+HQDIRdfMwyTeavNRXyeumi/GmK3/ZBDPAtX8IYMfw16gy/cVhbL+suKT01E9T+6r4EaMN4t2k9evjzEAAde4lp9p4oPrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IJ5mpvWzr3y70pG85Izmkyk3Jg6hTeD6XxEAbG11yqM=;
 b=b8TkS2FzOfkXEwsLzZ3q5JXeaS1wKtma/RGq51lvcRdd2ExziT9lgbAB/cJ4ldrfdMlEoLnWST/DfV2TfIL1h+QbJmBNvwRAGjizJtEbvl8TkmdDCLgDegtbGID5PVm9d/uGVwYLnrGCzAaBC9t49rzHD/+4ExuPAe0AFUsejsic9mcZ7YATVaKu3roulnbYBsSkOdXpqLcREWspPbEjg5Vvku3wPf/S1oybJxCM+VSqYs0F1MQ9470/s2sjWpl0NKGLZE4i5dcKnRE50VcxIJ8VXLFBZR6yVm4UtiN84IB7+11Y+pzueTJliC64KfK+Q4SmLcGwuJYt+/1GXeGmyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJ5mpvWzr3y70pG85Izmkyk3Jg6hTeD6XxEAbG11yqM=;
 b=oArlkeCWq+EnTyZW1IyLOVMQL+m9lo3mKmwx7j9hMF2ggfGQJQJtdwCnEdb28mOF/vx1eRbMRpQsrH9/mC57sjG5uBy292wmNZdfrOlS/R0qDbZR1c7ZenQEitOmPDnqqsmAftqWUiutc44IjJnaLNWGxjiBGFDoZdip8km6DVzwbvNTqS0fdSqlsfCGCYnalOXxZEJD2oAkgOCHSFepEZbSAOd385u3UhsQf1fa7d6kygKpFeu3RBgHH8wHSZv56+1GR1c+d4V/Ms45uvQYpBCUfPyzpxDv59KKgnJFqMGBeNT4CsjDTkdI/oZzze6zNpdIY8IYkwFcEvxmEXf9pg==
Received: from SJ0PR05CA0182.namprd05.prod.outlook.com (2603:10b6:a03:330::7)
 by PH8PR12MB6988.namprd12.prod.outlook.com (2603:10b6:510:1bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Fri, 2 Jun
 2023 16:21:05 +0000
Received: from DM6NAM11FT104.eop-nam11.prod.protection.outlook.com
 (2603:10b6:a03:330:cafe::a8) by SJ0PR05CA0182.outlook.office365.com
 (2603:10b6:a03:330::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.12 via Frontend
 Transport; Fri, 2 Jun 2023 16:21:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT104.mail.protection.outlook.com (10.13.173.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.27 via Frontend Transport; Fri, 2 Jun 2023 16:21:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 2 Jun 2023
 09:20:46 -0700
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 2 Jun 2023
 09:20:44 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, Danielle Ratson <danieller@nvidia.com>,
	<linux-kselftest@vger.kernel.org>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 7/8] selftests: router_bridge_vlan: Add a diagram
Date: Fri, 2 Jun 2023 18:20:11 +0200
Message-ID: <975bdcb89ebe3b04015648f498263ecf24135205.1685720841.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1685720841.git.petrm@nvidia.com>
References: <cover.1685720841.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT104:EE_|PH8PR12MB6988:EE_
X-MS-Office365-Filtering-Correlation-Id: b006cfc0-4b1e-47d2-b433-08db63855cd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jCj8jcI5g7u0sDterfdTTtwdlYGVz8kjE3RRpFk47qgWg/xehFqpXA0mlEpaP/gxAA3BSR8Fkz/jBjoVWi6fuv7T8AJfC2mdzKBzMdWG+AbillmLyGV5KiaADHyuZHHY63liCGrh67jGd9QMgT33+ZzhYBWBsmUlojik+2iG6CCNGXj2oB/ePAioXCFZWt2KlLuIom17iZL7caPi2EXT5saca4bVl4j/U/YFzPDjyv09dciQuze1f0U/TZJgg6WrSNPBmb9YC1z5PK3jg7Jbcg5+L2+M4s9i2zWK+pMZTvLvmNXHy+E3OYvnS48RQMl9EEr/76xxzhTiPffqE5n5MCAi9OsaJQDqmcZExfIOQEAK0J+Cuz4KW1yscIEJ44oVsBVZ9LxxC7dQlxFKn9CEW6bIi8aMYHdWI0bFfVaTxpGLBPXKUBGU9rCpcniiydSlfut/6uCdNyaQ3hf7IAp2xyg2M1H1+xZPCkukw1e6rkSUcGjOtuS8rjBoQ7t7wqy3wNlSYStPo7ZV41jZDlfZHNuZP1dFUC3a0vKAjUHevDvw4xdwlr0CEe7/y8COF4vXpuL2XtQiajesMVemHfoLO6ynwEEjLUh8Y9LvyIGaKFhjbuHDgOsCCD19GSujB8aD5+tmJ9c+7+olIW8zeFoZZ4/+427JHU1ikgAGfaTn9OrNBX+BN+6Ce71u4XeJIIx0DTa2tjXbAgJQZ6R54Rbf/36qeqDAdzhVkx2qOehBiSsQRiB/z9bckzNluRuesEDl
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(136003)(346002)(376002)(451199021)(40470700004)(46966006)(36840700001)(2616005)(36860700001)(66574015)(36756003)(47076005)(426003)(336012)(6666004)(40480700001)(16526019)(186003)(107886003)(26005)(40460700003)(82310400005)(2906002)(110136005)(316002)(41300700001)(5660300002)(70206006)(70586007)(4326008)(54906003)(86362001)(356005)(82740400003)(7636003)(8936002)(8676002)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 16:21:04.1091
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b006cfc0-4b1e-47d2-b433-08db63855cd7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT104.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6988
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add a topology diagram to this selftest to make the configuration easier to
understand.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 .../net/forwarding/router_bridge_vlan.sh      | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/router_bridge_vlan.sh b/tools/testing/selftests/net/forwarding/router_bridge_vlan.sh
index fa6a88c50750..695ef1f12e56 100755
--- a/tools/testing/selftests/net/forwarding/router_bridge_vlan.sh
+++ b/tools/testing/selftests/net/forwarding/router_bridge_vlan.sh
@@ -1,6 +1,28 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
+# +------------------------+                           +----------------------+
+# | H1 (vrf)               |                           |             H2 (vrf) |
+# |    + $h1.555           |                           |  + $h2               |
+# |    | 192.0.2.1/28      |                           |  | 192.0.2.130/28    |
+# |    | 2001:db8:1::1/64  |                           |  | 2001:db8:2::2/64  |
+# |    |                   |                           |  |                   |
+# |    + $h1               |                           |  |                   |
+# +----|-------------------+                           +--|-------------------+
+#      |                                                  |
+# +----|--------------------------------------------------|-------------------+
+# | SW |                                                  |                   |
+# | +--|-------------------------------+                  + $swp2             |
+# | |  + $swp1                         |                    192.0.2.129/28    |
+# | |    vid 555                       |                    2001:db8:2::1/64  |
+# | |                                  |                                      |
+# | |  + BR1 (802.1q)                  |                                      |
+# | |    vid 555 pvid untagged         |                                      |
+# | |    192.0.2.2/28                  |                                      |
+# | |    2001:db8:1::2/64              |                                      |
+# | +----------------------------------+                                      |
+# +---------------------------------------------------------------------------+
+
 ALL_TESTS="
 	ping_ipv4
 	ping_ipv6
-- 
2.40.1


