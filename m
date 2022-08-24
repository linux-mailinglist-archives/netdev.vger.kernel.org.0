Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C40459FE1C
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 17:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235726AbiHXPTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 11:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbiHXPTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 11:19:43 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFCA985A2
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 08:19:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cBdZZJWkBDVs1yG2x1lUPRliv7mVZP/FzMrwDwxMmWx8pSpW/UdEXEHnnbjFn6PeZ6ztRoi4eG88K7GOqQx9eE0SVVfXEmswHuLGhR8WlDoB7Erkz5KMoA5j9+MgsEjn3CSgPjxpEEQ4tbaqyd99MmR2c6UTXUYPkGSmeR6EEzVQlbXgKQAUtcC9qRnZEsm9otEORrZl+xHwuHblkpZez/i0VMYKgvRLLN2TJEg6giYJoiH577g7BK5M7pScHh7N+zg93N5ZQY6/YViPKyRjvlQMrynRShwIZGx0bk3Y5qvDxIKETbPljaUtiuaT4aU3y/k+xA0T55Yi7gzcw2iPpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vhJtD4wBbSxYpm9h8HNCEiLjcjJc86Bx9O7DPKg8De8=;
 b=PORFLqSo+z/zGmoPEfn+S7rS2EknreiiA2oyqWlIW5x3MpSt2RZ8Rrbg3ojgu+t8mRhM27RdiX6lankmuckaC6eQPXJRmYW4CDmNUvgZLf41Mz6+ss1Pg/En2UKBjfYeZNMtAns+CYZREbBAaf2bRiGv/9ioQpMD5MYmrt9UxS2BQG84xDllU0gC+Pn/JO+I0hHrGpNsTf3s7KogyVeYZhUAleMrVr0AVSSaCBvbwob7YpVpZbl4oI8aJ9B+Hccfnwx9KVzLxoPOfOzo7UQqzqkMq8C/Y2iq/yVHyErJqyq9PX2s2Jeh5waQcrnQj7v9NRlsGdrVdlcujIDHdZWCqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vhJtD4wBbSxYpm9h8HNCEiLjcjJc86Bx9O7DPKg8De8=;
 b=jkWsmGdHAeNz9u9+OsTWXqz9PCTiPcE6IRwoVFkuK9Ps113RKH9AWFVn2fy8Bip4rSlsxABjHHCXqvPn8IvD66VIAPEHmfdCLRWxjLoSKwI19dxr1HBOqKpJ65IY6ahj26nsHZQI/ezK+HcrwBsLZQE9Gv7pShlmBqf7AlAYi8AqvIIAUYFhff6/KCo1LEEQmd2To9VKjHQsD/6m6dt80W4P5j7xJZyVqCfnaVZCR/g/NXFmNZmC5omX5sugB34s1WlTo9XU69yv8pwo04qdd3AqCtvQVfuB1fIQpg3GYftwZGe4PhOi/6hQow6Ol1CqYblUUSgViehnRwy8gQhmLg==
Received: from MW4PR03CA0336.namprd03.prod.outlook.com (2603:10b6:303:dc::11)
 by MN2PR12MB3710.namprd12.prod.outlook.com (2603:10b6:208:16d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Wed, 24 Aug
 2022 15:19:40 +0000
Received: from CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::64) by MW4PR03CA0336.outlook.office365.com
 (2603:10b6:303:dc::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15 via Frontend
 Transport; Wed, 24 Aug 2022 15:19:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT063.mail.protection.outlook.com (10.13.175.37) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5566.15 via Frontend Transport; Wed, 24 Aug 2022 15:19:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 24 Aug
 2022 15:19:39 +0000
Received: from localhost.localdomain (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 24 Aug
 2022 08:19:36 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 2/3] mlxsw: Remove unused port_type_set devlink op
Date:   Wed, 24 Aug 2022 17:18:50 +0200
Message-ID: <d2e898b0e5dd2d669162b80950d4227fdd15c43c.1661350629.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 86ca9c17-f2a7-47e5-61e7-08da85e41078
X-MS-TrafficTypeDiagnostic: MN2PR12MB3710:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hafBWsjjbnMrHq9MMJ5EFCDm7peD+V2ytU49Pdz0EfYURChuToy/iLsIuJhW1tzS3acGs0NIzOH7RqvzhGe5S9ukx5vO6GBYGppiaHmusPOZXKbaro12gi3nBsJyJLiwLGKIMqqalUoGweF/KlKEJjH2R3J3IDzk06Y08NujMEgoQOqn7Jkf9XMF4qOZHSS/oDCFQECrechgN1+rJwCo9UHIvIbNrfazHRZUEw+5hbArMsBEr27bUSUfYd3eCDKkmfBwNzp1qfOD5nl0BcfGlO9/8fyLc/egC5MzHPg7Zz93IA3ca44wh5IUEmkhG5GUyeOxMnZmdoNgrbES+Yn3ManBTChfvet7Zj0OnlxuA/HoaYpo/kL5ydOj2Xe8Bua57821WkuqCP3oNyk5mgZnThnFOpTYurrp6LGrvN0b9xaf6ZzSR8or8JRoFhxgtW45LbYLVMAOJWl+uoms0p0ZtMveIXs33G3VR4YrcOC7tQPVRPTJyjOERWw94WkskS8ES0B+md7ISS0EEOpe+c1s5DmVo2JnhNfvlLxd305jGSakakwx4dkwTdPbkxXkNhiKMkxj+UmH4rsXvZn+fXrgBkzoGCt9qJLtlkKS960kEhqcag9E/6KZQECJnF1g32beiZBvd/FlL7+7YQINrp3J8IB2Rteqv7u/Mu04FFLtCTuMmbqXLodXg3/cn5fP+cn2LuvXGIEXcUBBZG69C3ulc97N4w9j8fb0TvBwVC0vFVZjgGkv1v7wWCgQgiiALPANfR/28xvenkxjZ7ZeVp8qmzq2jlve4ic+daha27g05bSEdkSYFTtPl8+SRLSX4fUd
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(39860400002)(396003)(346002)(46966006)(36840700001)(40470700004)(107886003)(6666004)(16526019)(83380400001)(47076005)(5660300002)(426003)(2616005)(8936002)(186003)(41300700001)(336012)(36756003)(26005)(478600001)(82310400005)(86362001)(110136005)(82740400003)(40460700003)(36860700001)(8676002)(316002)(54906003)(40480700001)(2906002)(81166007)(356005)(4326008)(70206006)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 15:19:40.0615
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86ca9c17-f2a7-47e5-61e7-08da85e41078
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3710
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

port_type_set devlink op is no longer used by any mlxsw driver,
so remove it.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 16 ----------------
 drivers/net/ethernet/mellanox/mlxsw/core.h |  2 --
 2 files changed, 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index d28c0f999f76..250e1236b308 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1307,21 +1307,6 @@ mlxsw_devlink_sb_pool_set(struct devlink *devlink,
 					 extack);
 }
 
-static int mlxsw_devlink_port_type_set(struct devlink_port *devlink_port,
-				       enum devlink_port_type port_type)
-{
-	struct mlxsw_core *mlxsw_core = devlink_priv(devlink_port->devlink);
-	struct mlxsw_driver *mlxsw_driver = mlxsw_core->driver;
-	struct mlxsw_core_port *mlxsw_core_port = __dl_port(devlink_port);
-
-	if (!mlxsw_driver->port_type_set)
-		return -EOPNOTSUPP;
-
-	return mlxsw_driver->port_type_set(mlxsw_core,
-					   mlxsw_core_port->local_port,
-					   port_type);
-}
-
 static int mlxsw_devlink_sb_port_pool_get(struct devlink_port *devlink_port,
 					  unsigned int sb_index, u16 pool_index,
 					  u32 *p_threshold)
@@ -1652,7 +1637,6 @@ static const struct devlink_ops mlxsw_devlink_ops = {
 				  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
 	.reload_down		= mlxsw_devlink_core_bus_device_reload_down,
 	.reload_up		= mlxsw_devlink_core_bus_device_reload_up,
-	.port_type_set			= mlxsw_devlink_port_type_set,
 	.port_split			= mlxsw_devlink_port_split,
 	.port_unsplit			= mlxsw_devlink_port_unsplit,
 	.sb_pool_get			= mlxsw_devlink_sb_pool_get,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index ca42783f143f..8100a7efef90 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -347,8 +347,6 @@ struct mlxsw_driver {
 		    const struct mlxsw_bus_info *mlxsw_bus_info,
 		    struct netlink_ext_ack *extack);
 	void (*fini)(struct mlxsw_core *mlxsw_core);
-	int (*port_type_set)(struct mlxsw_core *mlxsw_core, u16 local_port,
-			     enum devlink_port_type new_type);
 	int (*port_split)(struct mlxsw_core *mlxsw_core, u16 local_port,
 			  unsigned int count, struct netlink_ext_ack *extack);
 	int (*port_unsplit)(struct mlxsw_core *mlxsw_core, u16 local_port,
-- 
2.35.3

