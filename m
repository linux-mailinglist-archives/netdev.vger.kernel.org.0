Return-Path: <netdev+bounces-9641-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28B8872A153
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:35:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76A731C2114D
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:35:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 268822107A;
	Fri,  9 Jun 2023 17:33:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D7620682
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:33:19 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060.outbound.protection.outlook.com [40.107.223.60])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0691E1FDC
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:33:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UNO9QzTbgbP9GiJWFDJFIqgn4LF3kk0boFLAnx3BvrWeYvr8UssOWFc1oM59pHWwIzY0Qlq4gb/UBDYNeJNCxbJjd88wevaF42x8t3OA+9v4GNuHT5qGHCNhTS3M3dvqPFkfQsjTOuFP/Kb908GSNfS08dRvZLl6BDC1JHZ+fijyY53mXT2GZs32BMoElaQiUPh8dc057kAw4kTcjvWcGA4cRpGRIG/d9fsJkpvYd5GoXVDhoM/QfHh5TRWpTrf9j5sPFwxdQKgcmf09Z3KECMSQ1M+ShxTdVXlF37Zkdac4VjtnjZRXQVaTZUiL8mxbmEgqhnWs3uozdIMnjiMcLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vnwrTEypC8oZQ4A9Led5/PWFnux/Eysn7PedjWcenl0=;
 b=DmHfOGyuzh7MvOrND6ULWQuUnuf7IXDCVzipQYtbGqg9EYopj9gsu0fNffkg/zcP1wAPDN6G+Rtp2V1zjE60TI3lzgpWohD3VG2cf2M1K32kkA05i9e/V7BZqZ80DjsIpL2dgJ7cVM0mLuc4Q3s8dGPyBN89Qjt1QBK5JJlRtd3oJiyhzpBtkCHSIyhbjMxos0WLJ/PJwKdvbjFpl7W12JAcTmqu3kkdRAyohEaBoczzrYOaLEAZxjVjDbB2r2eb1mG03ktfuJcGeA/olsWaYLe9lLSXUAvgcD4nG4fsN/VX6GTEbdCm7Ora2xOHiCF04eP56udSV6DdxAgCYC1jAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vnwrTEypC8oZQ4A9Led5/PWFnux/Eysn7PedjWcenl0=;
 b=YMLLvUng9r1EQxtis3V04Bdtg6Ga2r1fKjYv7mZapFaZMSx99kX0xocZo7acGM9R1mU19nVgwNNuu7l/RDwKpuFJ8wqLsjhWocXaeJr8bOxaF7m2rpy15EcglG1Q0lI+g0St/a9er7sh6MD7g9XjAv7izEufDgvFUgSxs9v+ysDCHE11SQ1kW0lJJ2SLJ/uRFHaydx0qeflvVrkIgq0HxY458gWU5W9mLfkR9hndNGOn9bmldu1rLoQ2XuRO3BsFW17aXBctDK0hj5wBdTqSDX0ZBOmNIfJu8V2/BScfKJE1jxJI+2/hh/ZnQ9xz2Pn0mmvKJObvlgF8RqCfKJZl1Q==
Received: from DS7PR03CA0055.namprd03.prod.outlook.com (2603:10b6:5:3b5::30)
 by CH2PR12MB4280.namprd12.prod.outlook.com (2603:10b6:610:ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Fri, 9 Jun
 2023 17:33:16 +0000
Received: from CY4PEPF0000E9DB.namprd05.prod.outlook.com
 (2603:10b6:5:3b5:cafe::9a) by DS7PR03CA0055.outlook.office365.com
 (2603:10b6:5:3b5::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.27 via Frontend
 Transport; Fri, 9 Jun 2023 17:33:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9DB.mail.protection.outlook.com (10.167.241.81) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.13 via Frontend Transport; Fri, 9 Jun 2023 17:33:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 9 Jun 2023
 10:33:00 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 9 Jun 2023 10:32:58 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 8/8] mlxsw: spectrum_router: Privatize mlxsw_sp_rif_dev()
Date: Fri, 9 Jun 2023 19:32:13 +0200
Message-ID: <1e9aef91a823932bee6114371279d5cf2cddf704.1686330239.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1686330238.git.petrm@nvidia.com>
References: <cover.1686330238.git.petrm@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9DB:EE_|CH2PR12MB4280:EE_
X-MS-Office365-Filtering-Correlation-Id: 1acd45a6-17c3-433f-2dca-08db690f9b0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3i0OnLtNeNcySjDRgVEGeQfI1AlQmwc6N/1uSeSUPN+6583Ki4O/1/LbpH0DfmSq1I7v0xOVmrlDJGIE1hNq2i1rZQuxKHBJFnBkny59m69gAaekpKyDe4MLKHD5ZZWMgsAxCXz5Xc0/irJtBsatGSQD+2i2HqrjB1SSy6Jte/cTAc+ln85Jo6i/R2y96AUfHXXBFVwhQMHxo1G6nYrSLTwAIZZk1OoJ3nW32Mz2S6i5TaATp3bkoIJI8uN0jSdU9Lp5PiiZJ/Ulc+ibB97z/bxemp2ypmOUsEGg4qiLBh5/EB6EMdKj0dElxJrwerEq+dBtI1k8guNmDpfXDZJZCaB3K9RRub8xNmQOYKHcmBgyPB6QV59ou9KeT5s/l4d+SHt8ahDs1o8UOGF/5/4TjigF85YAYBpjw+m2dTAOp2gjuttkLQ1xTMEi3tK8yZEJ0G+1CAWuISuCtklj+fVbG2d/p2vAn7xnYx8q+QH0kLZ5rf0ZUfr3YnugkH38Rf09KOxDk+7fEesK1eepOyp0sydPj7aExcz1xFJfb+w5jf5m93dSyEouLgdZGamuxrpnNL/Ax3EjVydzsLMJLPgWQS6YlkgMFYOF9ojlwbEchEL6DBVCM1wVeCKZlFTnIrL5gSBURtagnQtZ+DCuiVMJQFje5ophFICoiYYIguAuB3X2lb/QyM7NzDlDIwHH/RfAT9YlMmVn2T87bA11VAtrsjWvBeu7MQiPlYSP2KzzqcqVG5prB4IJeB5thsa7UOM7
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199021)(46966006)(36840700001)(40470700004)(70586007)(70206006)(4326008)(36756003)(40480700001)(5660300002)(41300700001)(8936002)(8676002)(316002)(54906003)(110136005)(356005)(478600001)(2906002)(40460700003)(7696005)(83380400001)(6666004)(82310400005)(66574015)(426003)(107886003)(186003)(26005)(2616005)(36860700001)(336012)(86362001)(7636003)(16526019)(47076005)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 17:33:14.8368
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1acd45a6-17c3-433f-2dca-08db690f9b0a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9DB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4280
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Now that the external users of mlxsw_sp_rif_dev() have been converted in
the preceding patches, make the function static.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 537730b22c7a..f9328e8410f5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -8075,7 +8075,7 @@ int mlxsw_sp_rif_dev_ifindex(const struct mlxsw_sp_rif *rif)
 	return rif->dev->ifindex;
 }
 
-const struct net_device *mlxsw_sp_rif_dev(const struct mlxsw_sp_rif *rif)
+static const struct net_device *mlxsw_sp_rif_dev(const struct mlxsw_sp_rif *rif)
 {
 	return rif->dev;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index b941e781e476..5ff443f27136 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -93,7 +93,6 @@ u16 mlxsw_sp_ipip_lb_ul_vr_id(const struct mlxsw_sp_rif_ipip_lb *rif);
 u16 mlxsw_sp_ipip_lb_ul_rif_id(const struct mlxsw_sp_rif_ipip_lb *lb_rif);
 u32 mlxsw_sp_ipip_dev_ul_tb_id(const struct net_device *ol_dev);
 int mlxsw_sp_rif_dev_ifindex(const struct mlxsw_sp_rif *rif);
-const struct net_device *mlxsw_sp_rif_dev(const struct mlxsw_sp_rif *rif);
 bool mlxsw_sp_rif_has_dev(const struct mlxsw_sp_rif *rif);
 bool mlxsw_sp_rif_dev_is(const struct mlxsw_sp_rif *rif,
 			 const struct net_device *dev);
-- 
2.40.1


