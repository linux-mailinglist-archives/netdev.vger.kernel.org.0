Return-Path: <netdev+bounces-7493-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 53A35720773
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:23:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C702E1C211CA
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7695E1D2A8;
	Fri,  2 Jun 2023 16:22:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651541C750
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 16:22:13 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2081.outbound.protection.outlook.com [40.107.223.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF87E41;
	Fri,  2 Jun 2023 09:21:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mBLN7wd1b4RdXk+hY6hGNzzSPbC91B9ozsVgnqZh3AG0iDSFLN8fak2+kezeVkV+tmLJwRSVIUmlTuzyO/JHfTsvB5Cr+1iwlXso9xJi9cldpp3T8NtMUIt6VqyaR2mJHMzBEAC8fULiTYWtrrRlR2K0HIZ3bhfjV+GWeWVnbQ3mi5wmlrjh5WFl1Ft/fTFwfOJu64AH6Vq8xgMvX+czSEbV3+z7OIY/FAe7GVH6tPhH6NqnQ7d9FoA8IbPft/N1oJI7/oD15Ed4uC6hXoFGd+j33AiucFAfW4QMg/DJ51RHnh9O0E/0Ib6XOfP8dKOYV8IUsJKFpSyCSqxOl+KNJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U1I2K5VPTzg/HQOEVjSn80QuIB0m4DaRz5l/ujVdtX0=;
 b=j4jLzGuIB9ANwBskCbYqe+cUUi1mn1giWBKqOVDhbNu+AQCl7c6KBbYEz81BWhbGg1ssG8jlK39TlkZVlxmNK76bCqrAqvu054ApezFn4G5ipieJPMAeKVvhM2jZXgePOeq7jaG5ZSGLzPDFrkzCkUsW7gebcqd7aNaM//td7cxm5Ge64rgCuaD0opjHwKKrnNzG6STxgIshoiHu8lsDbe8ySr+rER36FCdfVG/xHW89JxbI1OeMeIMTqU5cNWG80cmF6wiP/Q8UXhvXy6PB6toN6SP8E2WTK0Cp9UCr1j5Z/Al8Ee2emKwkRywqxXgPkPhXgme5pbOHavs0nqwktw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U1I2K5VPTzg/HQOEVjSn80QuIB0m4DaRz5l/ujVdtX0=;
 b=C5u+n3i7tMMkQ+0w3p02rcxty1p+uNBKzAC1IQ5VpPUL0psggJY2gVi2kVeDeKX9X7cFUTqdQnXkhEqr7m4K8JHrGxh/F5JrjC7O2eqG9TsHDBxxZXvHumiRCNofbexG483zRnWwDaQjvKKJPibBujfP2XLCb/mLWdjzEBmiS/dw2K/tPqpPUp2upsQjXyQkqHU8wfA5vZaqXIeB4kng5zDGEvnLzh7BMV7hyPUTXpB3rOPofS6nghagD41ZRvNltIE5Z0YLPXVbmePvMKnmFFXeNzjuVeyE5+Q7VUjIttYUDJNrjn5sGcVVn16mbv3gLkb6VfHqNg/kISxGa5X8Jw==
Received: from DM6PR03CA0100.namprd03.prod.outlook.com (2603:10b6:5:333::33)
 by PH8PR12MB7424.namprd12.prod.outlook.com (2603:10b6:510:228::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Fri, 2 Jun
 2023 16:20:54 +0000
Received: from DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::79) by DM6PR03CA0100.outlook.office365.com
 (2603:10b6:5:333::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.26 via Frontend
 Transport; Fri, 2 Jun 2023 16:20:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT037.mail.protection.outlook.com (10.13.172.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.26 via Frontend Transport; Fri, 2 Jun 2023 16:20:54 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 2 Jun 2023
 09:20:41 -0700
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 2 Jun 2023
 09:20:38 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, Danielle Ratson <danieller@nvidia.com>,
	<linux-kselftest@vger.kernel.org>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 5/8] selftests: mlxsw: ingress_rif_conf_1d: Fix the diagram
Date: Fri, 2 Jun 2023 18:20:09 +0200
Message-ID: <00eb8e5f01883f35852fc49fbd625f2b5fd566ce.1685720841.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT037:EE_|PH8PR12MB7424:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f736c49-9934-45bd-0d1d-08db638556d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+mk7osvbNmyVBiFEgjV/zet4W2RYgG1IyUUPKwGCWOGfcFE2Yd4rjhghM4VaBHXriYieFeiM5E0RtEIN9GBOkHjHl4yMJQETaPTPDOkUTfnHWynZD14iLKpWqs9ww+Ad089g6rtcknqWtn+bZ36U9rpII6NKqviPNRy33RV9VJQV1TFW2rjWEspSUQdI9u3lT7PK9ZxtI/a5ujCmXbvgBB6QzUYOeHVXMQb/9scmUBE0RGYQFhw0jz8Dg/yhOK0tzY6UJmko1o6crNL2M8SL0pQ6a7np/kgDVAZIQktRZ+z8wndN5XD2oLr2jsEJ9PwPdxgXeqTBgUix1dieoa7Z3c4IlOVYcbPB7dAPa5ugzitQ6NjiQ4L1bNedj7B0hXhW8CF/Gb5bPGLaRpZM35hemmZVz9NCgmZR4utznvmC1Bv3WeSThE2c2wEB8jjJctGhQbdSp6ksuVtKHV24gA+MIggCsdJzQPHicef80m4p4LzswzZn8017BGdKQZ4Zf2UQPId7ctFuykKvsEIvMxD3BirVSgaH2hs+dALk0HpVpbUwXHj0pX8sd/fr2ucxrZUb+QWEJFpSyL9TBgd0sbzpQ14JxHqea0h6fAf9EI4UjnssZwIUfUICWRYenJcg01EqSPvCYjGeWU1FyJTy20uScFWnEbjUwkE/qOpFvHZRVbrdXEawhvYI5PJPn/bBBI+w/SgT0tIngtTRzmPNGcpkt+Vi3CuVig1IWBCbaEFvc0cH88YdJbDldXsNpS0bZqC3
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199021)(40470700004)(36840700001)(46966006)(82310400005)(54906003)(478600001)(110136005)(40460700003)(8936002)(8676002)(5660300002)(36756003)(2906002)(7636003)(70586007)(86362001)(4326008)(82740400003)(316002)(40480700001)(356005)(70206006)(41300700001)(83380400001)(47076005)(16526019)(186003)(2616005)(426003)(26005)(36860700001)(336012)(107886003)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 16:20:54.0229
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f736c49-9934-45bd-0d1d-08db638556d7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7424
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The topology diagram implies that $swp1 and $swp2 are members of the bridge
br0, when in fact only their uppers, $swp1.10 and $swp2.10 are. Adjust the
diagram.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/ingress_rif_conf_1d.sh       | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/ingress_rif_conf_1d.sh b/tools/testing/selftests/drivers/net/mlxsw/ingress_rif_conf_1d.sh
index df2b09966886..7d7f862c809c 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/ingress_rif_conf_1d.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/ingress_rif_conf_1d.sh
@@ -15,10 +15,9 @@
 # +----------------|--+                   +--|-----------------+
 #                  |                         |
 # +----------------|-------------------------|-----------------+
-# | SW             |                         |                 |
+# | SW       $swp1 +                         + $swp2           |
+# |                |                         |                 |
 # | +--------------|-------------------------|---------------+ |
-# | |        $swp1 +                         + $swp2         | |
-# | |              |                         |               | |
 # | |     $swp1.10 +                         + $swp2.10      | |
 # | |                                                        | |
 # | |                           br0                          | |
-- 
2.40.1


