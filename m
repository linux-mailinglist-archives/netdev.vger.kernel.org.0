Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD68C59B56F
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 18:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbiHUQVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 12:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiHUQVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 12:21:21 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01781D315
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 09:21:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=er54KWOaPeQ8TgiD9oVErM+oLbMG/JRrbuPVSKQ6uXaFGQdlprOrUNcsz2AgcvC+PnXyIdMaSMUufcMwwhE+6+zh+GNacaUTGtknd9R3jcsACnjFvQFu+PIZmW1GK0x31ng//6S3i7429uIwUBC56oYR0AZ1pU23urXaEVpqHRo+svmeN98an/9TsjWKUS0OZTtMq/uuVappT16jLaFT63UXb984iIIVSHmolrV9Y7vH8++FwQtGYBGdg3T/YtZ8Nb42qtYh2fatIoCf6inydFUAz4IY89IYNakskBN7troQ4OPbJqNOeHAJ2kRaQcgwA/LQrcQYCjrAF/urQ0T7Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7jlK1Fm2vrKWWENhCmTB0NP1Kl6ltEfqeoaRpKqtMb8=;
 b=ZywpSpiJnlFasH8RjHKl8kWVUxInMTgmCPzwj0X9TMR/daZm/PXlhNj87Z7sjuhFInweOVZrbsQpfiVo+Uu8DO3IXZ0fN1MFsnUwadXFTWAteBqzwc6m2qOYwLE1I3KUAbWX3ely3TCjzgu5QqCLCXolZ2H/QGsXHg286oMGdofU8HoPyaUmvAMcWeLd1RdkrXQyZBGU3NG1DQkRHxYRSwUVcOA1Zoiktadsbva9HyOs+1NNBJGQ/RBbKYdx9ifVXdagOr5gfQ0pRoXhhWoAlKVd0rkKy5i0ZBZwqq7Dunu0feN+US9MgYoC8iM8YvqTYou0UVeU/rK/FzlFJqGz+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7jlK1Fm2vrKWWENhCmTB0NP1Kl6ltEfqeoaRpKqtMb8=;
 b=ULuoHS8Q41YOcWOlJV8p6kDUdnvaUlXp7XrPBfO1SGC5GW33wiObb8MqN8kcA874lfUOi7sc8Sm9/Cj/WxcKPrPJOgqEzAHOyrerRwUvBGlZgFhYBhqCKoX8/07DCtBTvGpsxVW++DYRXaaZf5y7wSqPQ9zh/Py+Hz/8X9kTXxGzVGiiRszAEMUM0Z8P0prvs2pQ2qge3eInP6QKN0hT8ZTDzlTLTbgyJ4Q/gpSpiCTfZScixdNxdH/6DEqRmfeIuWOx6ACVO5kbHJqNRqYVKjNb9I/cH2VQgbNQc14JtKOcUPuEd7Zjccarjh/LGo4tOweSvYRM+xLgX+BHaYFSZw==
Received: from MW4PR03CA0116.namprd03.prod.outlook.com (2603:10b6:303:b7::31)
 by CH2PR12MB3879.namprd12.prod.outlook.com (2603:10b6:610:23::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Sun, 21 Aug
 2022 16:21:15 +0000
Received: from CO1NAM11FT093.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b7:cafe::a7) by MW4PR03CA0116.outlook.office365.com
 (2603:10b6:303:b7::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16 via Frontend
 Transport; Sun, 21 Aug 2022 16:21:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT093.mail.protection.outlook.com (10.13.175.59) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Sun, 21 Aug 2022 16:21:14 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Sun, 21 Aug
 2022 16:20:50 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 21 Aug
 2022 09:20:47 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Vadim Pasternak <vadimp@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, <mlxsw@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 6/8] mlxsw: minimal: Move ports allocation to separate routine
Date:   Sun, 21 Aug 2022 18:20:16 +0200
Message-ID: <5063740a8e85aacdd42f429cfd43c23bce9f9b18.1661093502.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1661093502.git.petrm@nvidia.com>
References: <cover.1661093502.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca3f3f18-1303-446a-4ac9-08da83912b61
X-MS-TrafficTypeDiagnostic: CH2PR12MB3879:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DJt/7utDl6XrkOBmVaXbkAuRVUkCGIPET4xXXAXEFIa04W/KTJCPXR3ah5SkKoepWsTYIEUttyvUfN7+AvJ1D2l1fdTSiS4/w2wbJZRh51CWxjCuunl2QdsrBrC/t/Gqga9trV5cKLrAEXI1T9Se2UcObbtO0rFvjzqcC9LQF5DXCksfrXqXED6ummJjsfYPOgTgeGIjkM52+Fa3BTXIot4KbXz/ix3pdZqcjvHpllNYn3X6WYpvabShlwQcc5mJ3pUA2kp6dP1jScmFjl5py1V4fOMiUueAEpxIhPwfp+QJ+bXRHRnLliTvuZoWHfSpA9B6z9u9Wq+sxs9qUscLFWjS7rhY+VmGlnunO3jGakQf1iXhs1DBexHvw9AbXMdec+H8QbB11IMzfaPO5lZnu5fke7MGCwfpdee/ku+yE2/U2/CucDmxDCGUiKKfm5Xk4juPiw6hiMHGUXJpArndhmbOz+kF0ZQY35LftoYXinl9S77vffUoFnqgA8m3WimCFZOzK+w258EWsQ+iz7GsSCoQt8EaaGcOD77guZgW+/HKM2bjxVXzc2I7WUu9riXkjTz0HxckJ/gwUZeiBjbrYBeT+G5AYHvsuRKA3wdpTG350piQyzxE+Xjzb7lPChyz0cLG0CSF9Xb31VkMokM3IuPDe37fkam36PmxaPVKG0lbqJDRCom9q9AV9hajhzLUEYzyKZrvihC1Ot2+9dkhoZn7QXBDp8gLYtKqNx7HTpNYjT7bggRdvdFv7shS89hcZ46LNTCIOynJYUnLzZUzzqTkqWs2Ck5p0lXC/IgacYzSLNOs5VUMJ2S6YDqn1FnS
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(39860400002)(396003)(46966006)(36840700001)(40470700004)(107886003)(2616005)(186003)(16526019)(426003)(336012)(47076005)(82310400005)(83380400001)(2906002)(40460700003)(5660300002)(36756003)(26005)(86362001)(6666004)(40480700001)(316002)(4326008)(478600001)(54906003)(36860700001)(110136005)(41300700001)(8676002)(356005)(70206006)(70586007)(8936002)(82740400003)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2022 16:21:14.6545
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca3f3f18-1303-446a-4ac9-08da83912b61
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT093.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3879
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

Perform ports allocation in a separate routine.
Motivation is to re-use this routine for ports found on line cards.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/minimal.c | 42 +++++++++++++++----
 1 file changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index ecb9f7b6f564..f8dee111d25b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -335,12 +335,10 @@ mlxsw_m_port_module_unmap(struct mlxsw_m *mlxsw_m, u8 slot_index, u8 module)
 	mlxsw_env_module_port_unmap(mlxsw_m->core, slot_index, module);
 }
 
-static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
+static int mlxsw_m_linecards_init(struct mlxsw_m *mlxsw_m)
 {
 	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_m->core);
-	u8 last_module = max_ports;
-	int i;
-	int err;
+	int i, err;
 
 	mlxsw_m->ports = kcalloc(max_ports, sizeof(*mlxsw_m->ports),
 				 GFP_KERNEL);
@@ -358,6 +356,26 @@ static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
 	for (i = 0; i < max_ports; i++)
 		mlxsw_m->module_to_port[i] = -1;
 
+	return 0;
+
+err_module_to_port_alloc:
+	kfree(mlxsw_m->ports);
+	return err;
+}
+
+static void mlxsw_m_linecards_fini(struct mlxsw_m *mlxsw_m)
+{
+	kfree(mlxsw_m->module_to_port);
+	kfree(mlxsw_m->ports);
+}
+
+static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
+{
+	unsigned int max_ports = mlxsw_core_max_ports(mlxsw_m->core);
+	u8 last_module = max_ports;
+	int i;
+	int err;
+
 	/* Fill out module to local port mapping array */
 	for (i = 1; i < max_ports; i++) {
 		err = mlxsw_m_port_module_map(mlxsw_m, i, &last_module);
@@ -388,9 +406,6 @@ static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
 err_module_to_port_map:
 	for (i--; i > 0; i--)
 		mlxsw_m_port_module_unmap(mlxsw_m, 0, i);
-	kfree(mlxsw_m->module_to_port);
-err_module_to_port_alloc:
-	kfree(mlxsw_m->ports);
 	return err;
 }
 
@@ -448,13 +463,23 @@ static int mlxsw_m_init(struct mlxsw_core *mlxsw_core,
 		return err;
 	}
 
+	err = mlxsw_m_linecards_init(mlxsw_m);
+	if (err) {
+		dev_err(mlxsw_m->bus_info->dev, "Failed to create line cards\n");
+		return err;
+	}
+
 	err = mlxsw_m_ports_create(mlxsw_m);
 	if (err) {
 		dev_err(mlxsw_m->bus_info->dev, "Failed to create ports\n");
-		return err;
+		goto err_ports_create;
 	}
 
 	return 0;
+
+err_ports_create:
+	mlxsw_m_linecards_fini(mlxsw_m);
+	return err;
 }
 
 static void mlxsw_m_fini(struct mlxsw_core *mlxsw_core)
@@ -462,6 +487,7 @@ static void mlxsw_m_fini(struct mlxsw_core *mlxsw_core)
 	struct mlxsw_m *mlxsw_m = mlxsw_core_driver_priv(mlxsw_core);
 
 	mlxsw_m_ports_remove(mlxsw_m);
+	mlxsw_m_linecards_fini(mlxsw_m);
 }
 
 static const struct mlxsw_config_profile mlxsw_m_config_profile;
-- 
2.35.3

