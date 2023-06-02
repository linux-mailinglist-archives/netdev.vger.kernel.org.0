Return-Path: <netdev+bounces-7494-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7C92720777
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:23:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D514281A88
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:23:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54F101C766;
	Fri,  2 Jun 2023 16:22:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446001C750
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 16:22:22 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE3110E6;
	Fri,  2 Jun 2023 09:22:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K4o6Ta2ITlS49SpMT3nAb4AHhNo9uZDOKCR2zcYDAsAenELoVMUTNmUG/A7fXrBOtz4mtIyq7yyb4ytpKkWvpzeS+n3gPokzSrnC4dY6oGR8drByI/MHlAfSaWUxRBORkOtEXHyAD0yxjrCIRHbeyaItAQzdnDTEyP8H+anFlnQ3NpcYCalpF+bw9I6jwl6/6H5vYszkRd6lN5z8ZOO0m4TyJBj3+dvGtDS7afm2u3CsuXPBmBVEH9PNkfJT1o3fZ4EZkfHbvFvo8eVjH8CxlbkGnGp6x4OEdk9iZZsht3Ach+qfA58ECZb4VuvdwSEG73IojSZqADWgVBPC9C5vog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SiszpKMqvloQVF9j8LVfLQwjAD3dpyRGQxiaInpAWjc=;
 b=QYh6RTz0xPwxB/Rm9bmptvw2d9AwC9AtaRd4i4qo5AxCe9nTelWfLo1Po8rSK7wQjrDvvpMjT8WYZEBoEVzYo7pDndcdaohjBstXvN300FyIkzSq7fK31bPim10/tWXWVdotnPlCAV1Hsn526DfYxKjm6fuTcgAKpn/LLVTuqS1y0hbNzRHNFV6jmPf3x0hkIu0UqqMjmxnyZhOzdx6vPHGzRi9rf7N/NbgxIpAAbnVs3AyzifUuCM86LYEcA4UKAi9l1sf4MEJ6HIEsW5pZMFPYwnoQcoYT5utGam27DbJVtNvR+zE21FQ1f1Snr7reb7ceb5K8pVH2mQSyqU5bZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SiszpKMqvloQVF9j8LVfLQwjAD3dpyRGQxiaInpAWjc=;
 b=hInCKDrYzM0vrd9hwzI6S3/iCX6UKIixp6dn3yJWIBETk9p5wJuQnJhRF4lnYSAxAyhVtAHduvO1TUsyUwL3cb99aLDkU6sc7y6bNVtlz61S8ctXF//bV0NoBGMHHgD91RBt0Cv/A+jbDhgeeOACtbAiVpL68vcph6PgEiYVBCEu6AQGmFIibE9xQkRjKvu4d6Uu/FHg/hMFjajM+3ffRCKesC8ryw4Y4+LtrftOFpU0LU3QkbHhke91KsjqPP7eat7aAKxbb5KK0CpL9GdW0+RTpC93nOlCe9nL8iQVPfziYu14ULgYe388C68zwVAuQNF7q+QfnZz/84YAZzFDyg==
Received: from BN9PR03CA0110.namprd03.prod.outlook.com (2603:10b6:408:fd::25)
 by BY5PR12MB4292.namprd12.prod.outlook.com (2603:10b6:a03:212::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Fri, 2 Jun
 2023 16:21:00 +0000
Received: from BN8NAM11FT086.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::4b) by BN9PR03CA0110.outlook.office365.com
 (2603:10b6:408:fd::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.26 via Frontend
 Transport; Fri, 2 Jun 2023 16:21:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT086.mail.protection.outlook.com (10.13.176.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.26 via Frontend Transport; Fri, 2 Jun 2023 16:21:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 2 Jun 2023
 09:20:43 -0700
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Fri, 2 Jun 2023
 09:20:41 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, Danielle Ratson <danieller@nvidia.com>,
	<linux-kselftest@vger.kernel.org>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 6/8] selftests: mlxsw: egress_vid_classification: Fix the diagram
Date: Fri, 2 Jun 2023 18:20:10 +0200
Message-ID: <b746339e6268392dd39debb07d7075dd8252748d.1685720841.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT086:EE_|BY5PR12MB4292:EE_
X-MS-Office365-Filtering-Correlation-Id: fa4db82e-a3a7-4411-7df8-08db63855a76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vBDesdS92K+zJGYXqsVjSMndBUl/XkH+3PVmt0G57wSPgTtTqkq9gk/+L5qZ2ivcksyc3n+mEatJ9zqqQFBHpRsxhDNL2zXk6nCBrOYeDtYQn7lhQePeSP97JhOfWmQLlre3RVV1gGLIdJIBSIJ5931F3RuHuh9rqHdTyMvwIAkVgE4baJ6HAt8Ilatp09XpGFW4XMDbVxdfCKPW7bv5xOSwNcWskr56j1esSVECd/KAzqoiwDeAD/BiLzmzKGclsMnNsL8HcGac0+z5AQI/kf0OnDjd7b74k4Inu+0nrWvT1xE7GIFMGFry4ogKUheVRi2tycdyZkXpqUN3Dv9XvEwWEKKwJfP9t+HGoDO3l3l08/ZkXwI5FY4XngnljucytXd3JEI8o1dY/TUB5tL+ajlLYv6O+hfpVBZnNjfZGzSHmv/9kDdmyhw7rPAcOKzS8YPaowgXubeWnQryQ29+Wywgbg+Bt8rkPTsPpLC9mUWkaQ0Pqr7jNNkguApEdjfD3Lf9boCa+tsHy2qEuySh+iCkQYRUea94a0G2osVuyetJxOAGQVm/d6WGaRlLu14On4i2GMAfsFIWQkC/6D3G+9GWNN1DE6D2J3dY81k5T84Z533vVYp+qhwchGPDEMaWftRMeSJSMILWTxYerPU9p8KeVJx3gP18g1LDS319vzmCpw4QPRciLdIwJHKZeXmJWaf+DSb2uJXrDaM7BBeGNqBalJZiS+QqxAUgOZe8TL1zR1e6u81eSornilNhZCk2
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(346002)(376002)(451199021)(40470700004)(46966006)(36840700001)(54906003)(6666004)(316002)(2616005)(110136005)(478600001)(4326008)(70206006)(26005)(107886003)(426003)(41300700001)(5660300002)(8936002)(2906002)(336012)(8676002)(16526019)(186003)(70586007)(47076005)(83380400001)(36860700001)(356005)(82310400005)(7636003)(82740400003)(40480700001)(36756003)(40460700003)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 16:21:00.0541
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa4db82e-a3a7-4411-7df8-08db63855a76
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT086.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4292
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
 .../selftests/drivers/net/mlxsw/egress_vid_classification.sh | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/egress_vid_classification.sh b/tools/testing/selftests/drivers/net/mlxsw/egress_vid_classification.sh
index 0cf9e47e3209..a5c2aec52898 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/egress_vid_classification.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/egress_vid_classification.sh
@@ -16,10 +16,9 @@
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


