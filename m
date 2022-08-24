Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 285CD59FE1E
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 17:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239010AbiHXPTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 11:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238837AbiHXPTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 11:19:45 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2062.outbound.protection.outlook.com [40.107.95.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31B2B5F
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 08:19:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQM21C7NqOgT5sMZW+mHszFXFAuv1WIQh7GT3jmThMfL85nwwWplOJQkleVFuyeZphb1jd5hKVFq9OzZgALJqF1GE1Kgl+Yf60XSPX94d7PwC4SUAmJgw1QyuGZjW85IKzicBVMiO6prNGJQdxoEpp/UoCV78mVNV3/WHbpXYej0kt5MvsBPZ9gBJDlJ7azviwy1t+WNousLbbQeAz/rb2kQfsK/MRXuW6mqUddUTJ+HqS2dp8vL5lfzGGzIKfPbKxTQpAKleFGPfZLiKxUHlHhCNqGY1qjhvjmHKbDGJ7v/xwpoxa6UN9pQaiRMgD9sg2iG/g29ldGc7jEEGRbCmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fg7pRtEcD8A4IPLz56ImIQMFK9WgJ9i/8S9x9gjKHkg=;
 b=XltLPg+AMJLM2a89sqav8K2PA3RgPuhciuQU6jnADFx1nI58M4TJgfluc4gZWnCF37f2Ryn8h349Q4VriFwfeeM4j3SGoayCVKunCGxo8tnG9dHMGOktOLgZk11+c/+r61fE3UfceTzJdYqK0b/AAvDaoYd9zIxgFLB11nilTXQTCAdViIhsbOZ4dgvDzCFE05q9dtZzFctHgKMzti/oekeClMIeBeM50BqqqycOSBPAKDmZCpQfMZe3WmTBarhZDbKj1hO74S8bsGcFpY0E1cHJKb7IFZncHgPBYAhuBzl+7D1S9Q+p/IYHm9e3cq9rjArFAq4DplDOGsrxyi4lpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fg7pRtEcD8A4IPLz56ImIQMFK9WgJ9i/8S9x9gjKHkg=;
 b=AAAhevUWrTQc14QMPmrLknX5jPxZTVibmUBZ6CjFxW6AkxKUIoInwaYmn7W9WTDQfg/d+F3kbvDExcnjHhH1i1ZKOttLC53Rva8uFiLOL10/5AwwHV6FE7q41zdTKtWXXk4kl5OHVTc5bDX8A8ipN0mQVC6kEKxHSei30uFSUoxuJaDPiV6YODQSt0S/GJxlnjHkM9EO7FLh+ipsR8MQECVmCvonkrzt3Obp7Yo7OmS7fgkEynO3KONVuw0ezMD3wQSXavx35cd+XV1A22KLUXbHA/FBbsrYPw0xrkc18JWhaHZ7rRFh8kadv8WRbXJ8nRHKk7wlUmUxXLyCfH4kSg==
Received: from BN8PR04CA0061.namprd04.prod.outlook.com (2603:10b6:408:d4::35)
 by CH2PR12MB4198.namprd12.prod.outlook.com (2603:10b6:610:7e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.20; Wed, 24 Aug
 2022 15:19:43 +0000
Received: from BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::b0) by BN8PR04CA0061.outlook.office365.com
 (2603:10b6:408:d4::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14 via Frontend
 Transport; Wed, 24 Aug 2022 15:19:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT061.mail.protection.outlook.com (10.13.177.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Wed, 24 Aug 2022 15:19:42 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 24 Aug
 2022 15:19:41 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 24 Aug
 2022 08:19:39 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 3/3] mlxsw: Remove unused mlxsw_core_port_type_get()
Date:   Wed, 24 Aug 2022 17:18:51 +0200
Message-ID: <816d47994549a685aa1e2e2cb77b290bfa1c590a.1661350629.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1661350629.git.petrm@nvidia.com>
References: <cover.1661350629.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc77fe9f-090f-4902-15e0-08da85e41214
X-MS-TrafficTypeDiagnostic: CH2PR12MB4198:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lfm308G9ZQyc4ze/mf5xKm52Wug/mNmoVlKXzOyv9C7ZLXRHGgXavg9DVsBEnwZDl+SbXNcEp0Ls1qXKCGXvmuH8VPtZ30vtDwOrFcCF7HmfDuUQtk6nRaCFYEVkP7HGQX4X9C80rVxnR49xRdMb1om1DPtTzs8Bjv2xh6C2bUKlH92Xk90Mv8WYtLW2JyjDma9OnDpfmaTHL3fnbUO0o2wZxGlEjG9QWKDLNx0ZzKuIAuT25eIqFo1xXQk0T5kdDZZEAgUhr8tK69KPyYQHyQfFhpoxOKBliKI9yzA3kUGEcYQY3PtMyixaHqia3MAOSXps33sfowEePfAx5dgf7wEt501bHCsjnatFnoPHYmNdoVB4H3Gcgk1gxGouWCvP21ITtrkb0seYFBLS5vVjd7XFhsvKUFCZb29PlO4ACXYOeQ75sKaxaMoIdPdTfCpgDmdean/6YBPSUZWlHtmf5WR0OODCJSvzBtTBpuP7X7rBV2mfJ4Mjth3CH2M57+4reIr6n/Rt9DiwrG4jymMmcJE3lc0KV4fTVfFWHmSQzSlisTp4qyspes4z8hU+tA5Y7E/gYITn4as3TCGgDT7ENYXDvCJiBvF8Gku3J3ln8m15O57Ed2xOv0HWUcC4sqt+2ELGl/tk7nmw6w4Dz9fzBxmjYQB/mrvColG8svha3ww2duTbuIJGlnCGip1fRAIsLbfKn+T0eRI92XGqiiyneacQvS7Slbjwx3Yb+GoLau+SxCNwarOWpTlkfMehhHCIGfLJEX5FIOVX0ultpLJChGT3KLr9kVbVJqIa+fcAX8+B4SfhE5mdgmTovpnys5ih
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(396003)(346002)(40470700004)(36840700001)(46966006)(6666004)(36756003)(54906003)(8936002)(70206006)(8676002)(4326008)(316002)(110136005)(2906002)(82310400005)(41300700001)(478600001)(5660300002)(26005)(40480700001)(107886003)(83380400001)(2616005)(336012)(426003)(186003)(70586007)(81166007)(47076005)(16526019)(82740400003)(36860700001)(40460700003)(86362001)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 15:19:42.6659
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc77fe9f-090f-4902-15e0-08da85e41214
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4198
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Function mlxsw_core_port_type_get() is no longer used. So remove it.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 12 ------------
 drivers/net/ethernet/mellanox/mlxsw/core.h |  2 --
 2 files changed, 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 250e1236b308..afbe046b35a0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -3179,18 +3179,6 @@ void mlxsw_core_port_clear(struct mlxsw_core *mlxsw_core, u16 local_port,
 }
 EXPORT_SYMBOL(mlxsw_core_port_clear);
 
-enum devlink_port_type mlxsw_core_port_type_get(struct mlxsw_core *mlxsw_core,
-						u16 local_port)
-{
-	struct mlxsw_core_port *mlxsw_core_port =
-					&mlxsw_core->ports[local_port];
-	struct devlink_port *devlink_port = &mlxsw_core_port->devlink_port;
-
-	return devlink_port->type;
-}
-EXPORT_SYMBOL(mlxsw_core_port_type_get);
-
-
 struct devlink_port *
 mlxsw_core_port_devlink_port_get(struct mlxsw_core *mlxsw_core,
 				 u16 local_port)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 8100a7efef90..9de9fa24f27c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -266,8 +266,6 @@ void mlxsw_core_port_eth_set(struct mlxsw_core *mlxsw_core, u16 local_port,
 			     void *port_driver_priv, struct net_device *dev);
 void mlxsw_core_port_clear(struct mlxsw_core *mlxsw_core, u16 local_port,
 			   void *port_driver_priv);
-enum devlink_port_type mlxsw_core_port_type_get(struct mlxsw_core *mlxsw_core,
-						u16 local_port);
 struct devlink_port *
 mlxsw_core_port_devlink_port_get(struct mlxsw_core *mlxsw_core,
 				 u16 local_port);
-- 
2.35.3

