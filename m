Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C3159B568
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 18:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbiHUQUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 12:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbiHUQUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 12:20:41 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E7B1A073
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 09:20:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n1pc+NfPoaOnYYpctuDFxf1yWLAG8PE09FaHjEfmwJ7CF3PFdop/kiDfGXq1ui6FPg+nRhzX3TpgnLFQxaC1I5JAo9I6T1Xv9KaIIh+F9LdVFHV44n2tjPdLDTeNSkokGHprMQc1vo9LKU3tG15TI+m+KiTgn0ZAcew2YevX8VuecXvo5TltoEIMS1iisNpHEimRuj8egt3YzX8RTnPxK++1llkJ50nVjwejBZCSmq+sRlGvoCf4pSbGMjeWeu/EXtwN+za9W7xCqL3hrTLCOiToWsnRMZJfEC9OvJXSXDBBZCVmroJcplIUxn0WCK8LAcUlPfMUbleLfSlupsBDTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D63SL/zpIe7sRPGz3Bcqbw1s3gDDkTYCzrPhjKlDaC4=;
 b=C/hXhiR+PX6BnDadOHftlFOM4YzHEyNuYe3LEoziRGN9YflpKqtvYg6lalyHIoau4fzfstGPkI3w3dt91DGtJhZVJVlpZq+1n+cNO/PhmO1fgC9M2lMSvoD7XspGaG3O8vi8XQnATFkt+/rUsygnEv/gBdOWLQMmFWySz5AeGewpa5mLpigHa9oWo/hBtSJRb0LBJRu5i9H/LWKdz65Md1W+uF6/D1yJ2sXiV/vZFwLQbnWY8vcXMyGc1ajo3oMHDDmlciYV9wXdENhlki7720OllglIf2cesPFF0ws2AK3xJ3PweBdh97EcdUSpXE+VHPzX7evDRwYP6tfIIu/3nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D63SL/zpIe7sRPGz3Bcqbw1s3gDDkTYCzrPhjKlDaC4=;
 b=eVNGn/t3p698S7upte3Y7AZuwfrQcIWLW2HFPd3fVON1pBpxai50AulM0QLJ6zTz5bAF6RZRP2AXJqYuB4EbKAKzpIoS/7ONLTq4bGaYWuZfs4Id75Z/eJbyIVRXFUkp6vDU39Jf+5xSqXdqOzW5wELHzuiKrFzpQCWpD+2rB5BTbdw8/HErONc07lY2+TCQQbMLS22Ch3KFXAr2llVj8utnp38Llcjm8CYQe+V3FRNh1VU2WTJjGxvFfbbaXw6a8HPuvHMnMUa4tpZX+2BNKCTTkLTlYnrYckb3QTRWNcrylHTl8MTEJX+yApYMCu/fDb8voz4CIaRhL2Kb58yWEA==
Received: from MW4PR04CA0133.namprd04.prod.outlook.com (2603:10b6:303:84::18)
 by CY5PR12MB6321.namprd12.prod.outlook.com (2603:10b6:930:22::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Sun, 21 Aug
 2022 16:20:38 +0000
Received: from CO1NAM11FT106.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:84:cafe::4c) by MW4PR04CA0133.outlook.office365.com
 (2603:10b6:303:84::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21 via Frontend
 Transport; Sun, 21 Aug 2022 16:20:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT106.mail.protection.outlook.com (10.13.175.44) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Sun, 21 Aug 2022 16:20:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Sun, 21 Aug
 2022 16:20:36 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 21 Aug
 2022 09:20:34 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Vadim Pasternak <vadimp@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, <mlxsw@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 1/8] mlxsw: core_linecards: Separate line card init and fini flow
Date:   Sun, 21 Aug 2022 18:20:11 +0200
Message-ID: <836abcd1b4e617b048a2433971dcc691701d8352.1661093502.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 711b2f8c-795c-4dcc-8ba4-08da83911555
X-MS-TrafficTypeDiagnostic: CY5PR12MB6321:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GJ0JhKUZHYJL1C4O5M0jkjovt1XV20+FaM7MEnnl44ROw+B8Tb84m6BfTbQU6UgqAouSkUoopQYslwx2ti8LX0buE2BCSw/2xsrIDZKZASMOdLNlgTFwXJv5POpMkmcPZYJ7Ci5++5uaPpha7OuTjAaDRJPoPd9m+cAPSdNEGm5wuXAGA+Z/9Q8wRaCgAqrMK+iF76Hra3pPapn7Hb4dseFckWsIzkalmWgR0djZHslvETEeoF7Xt36fBmy8W26dpekGclIrZYteHrUQdrddu2rdYXak0ixwKRd+3/R0L8GpRruCJ2aEjcb5cy1pgFHTLMilwvlFT3mkr0xxbTlCrHHT780u2Um/2+vrPq0EFGTW+hSTuFW7bvZ1X7Ml1aILKkYbbSZMZ+QJY8gOkSpnSVxzlkj/f026xrvLua9gHD2DsZc8S3zAZaL1X+dhmV5OcH2Q873PvcsAAjE9k47tWMQ7lKvAwEHLoWSZi/9gil8Gc7CYbmkl4yNSJ3xtfQkMcas2IOp7Q8WhVpcH+KzAAYIsKcSZw0fgKUzXuucLz0Yrgw7ziADoC5bC0HgIkdvzIOrRsOU29s/Nl9zmx+bMJgTQFB5eI6ACac6hMNWSyXsQ64SPGPlXOsLfJ9aPb0H7gHXOx1OTqVD/70jX4dRjWSPS7l3Gg7J5PAw791PEqaq7N/LS6URfaNZ11fZ1UT6Gr/3uOt3NN7FtM/e8KdswuXT+QOfF6xyZQjCiiYbYkD7tFll6zt8pBnscmiO3Ft56p2fenzG03c/rKzCJIUC9vhSu9F24P+HTg4SvBlRBZWxdJvLWZi5igv9sYSOYaOfaZkG/jxAQu6ZZjNFPZfk4Rg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(376002)(346002)(136003)(46966006)(36840700001)(40470700004)(83380400001)(316002)(426003)(336012)(47076005)(16526019)(186003)(356005)(107886003)(2616005)(36756003)(54906003)(110136005)(6666004)(26005)(478600001)(5660300002)(2906002)(86362001)(40460700003)(70586007)(8936002)(4326008)(8676002)(70206006)(41300700001)(82310400005)(40480700001)(82740400003)(81166007)(36860700001)(20673002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2022 16:20:37.6521
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 711b2f8c-795c-4dcc-8ba4-08da83911555
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT106.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6321
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

Currently, each line card is initialized using the following steps:

1. Initializing its various fields (e.g., slot index).
2. Creating the corresponding devlink object.
3. Enabling events (i.e., traps) for changes in line card status.
4. Querying and processing line card status.

Unlike traps, the IRQ that notifies the CPU about line card status
changes cannot be enabled / disabled on a per line card basis.

If a handler is registered before the line cards are initialized, the
handler risks accessing uninitialized memory.

On the other hand, if the handler is registered after initialization,
we risk missing events. For example, in step 4, the driver might see
that a line card is in ready state and will tell the device to enable
it. When enablement is done, the line card will be activated and the
IRQ will be triggered. Since a handler was not registered, the event
will be missed.

Solve this by splitting the initialization sequence into two steps
(1-2 and 3-4). In a subsequent patch, the handler will be registered
between both steps.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/core_linecards.c  | 75 +++++++++++++------
 1 file changed, 52 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index ca59f0b946da..8549ccbcfe8e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
@@ -1238,7 +1238,6 @@ static int mlxsw_linecard_init(struct mlxsw_core *mlxsw_core,
 {
 	struct devlink_linecard *devlink_linecard;
 	struct mlxsw_linecard *linecard;
-	int err;
 
 	linecard = mlxsw_linecard_get(linecards, slot_index);
 	linecard->slot_index = slot_index;
@@ -1248,32 +1247,14 @@ static int mlxsw_linecard_init(struct mlxsw_core *mlxsw_core,
 	devlink_linecard = devlink_linecard_create(priv_to_devlink(mlxsw_core),
 						   slot_index, &mlxsw_linecard_ops,
 						   linecard);
-	if (IS_ERR(devlink_linecard)) {
-		err = PTR_ERR(devlink_linecard);
-		goto err_devlink_linecard_create;
-	}
+	if (IS_ERR(devlink_linecard))
+		return PTR_ERR(devlink_linecard);
+
 	linecard->devlink_linecard = devlink_linecard;
 	INIT_DELAYED_WORK(&linecard->status_event_to_dw,
 			  &mlxsw_linecard_status_event_to_work);
 
-	err = mlxsw_linecard_event_delivery_set(mlxsw_core, linecard, true);
-	if (err)
-		goto err_event_delivery_set;
-
-	err = mlxsw_linecard_status_get_and_process(mlxsw_core, linecards,
-						    linecard);
-	if (err)
-		goto err_status_get_and_process;
-
 	return 0;
-
-err_status_get_and_process:
-	mlxsw_linecard_event_delivery_set(mlxsw_core, linecard, false);
-err_event_delivery_set:
-	devlink_linecard_destroy(linecard->devlink_linecard);
-err_devlink_linecard_create:
-	mutex_destroy(&linecard->lock);
-	return err;
 }
 
 static void mlxsw_linecard_fini(struct mlxsw_core *mlxsw_core,
@@ -1283,7 +1264,6 @@ static void mlxsw_linecard_fini(struct mlxsw_core *mlxsw_core,
 	struct mlxsw_linecard *linecard;
 
 	linecard = mlxsw_linecard_get(linecards, slot_index);
-	mlxsw_linecard_event_delivery_set(mlxsw_core, linecard, false);
 	cancel_delayed_work_sync(&linecard->status_event_to_dw);
 	/* Make sure all scheduled events are processed */
 	mlxsw_core_flush_owq();
@@ -1294,6 +1274,42 @@ static void mlxsw_linecard_fini(struct mlxsw_core *mlxsw_core,
 	mutex_destroy(&linecard->lock);
 }
 
+static int
+mlxsw_linecard_event_delivery_init(struct mlxsw_core *mlxsw_core,
+				   struct mlxsw_linecards *linecards,
+				   u8 slot_index)
+{
+	struct mlxsw_linecard *linecard;
+	int err;
+
+	linecard = mlxsw_linecard_get(linecards, slot_index);
+	err = mlxsw_linecard_event_delivery_set(mlxsw_core, linecard, true);
+	if (err)
+		return err;
+
+	err = mlxsw_linecard_status_get_and_process(mlxsw_core, linecards,
+						    linecard);
+	if (err)
+		goto err_status_get_and_process;
+
+	return 0;
+
+err_status_get_and_process:
+	mlxsw_linecard_event_delivery_set(mlxsw_core, linecard, false);
+	return err;
+}
+
+static void
+mlxsw_linecard_event_delivery_fini(struct mlxsw_core *mlxsw_core,
+				   struct mlxsw_linecards *linecards,
+				   u8 slot_index)
+{
+	struct mlxsw_linecard *linecard;
+
+	linecard = mlxsw_linecard_get(linecards, slot_index);
+	mlxsw_linecard_event_delivery_set(mlxsw_core, linecard, false);
+}
+
 /*       LINECARDS INI BUNDLE FILE
  *  +----------------------------------+
  *  |        MAGIC ("NVLCINI+")        |
@@ -1513,8 +1529,19 @@ int mlxsw_linecards_init(struct mlxsw_core *mlxsw_core,
 			goto err_linecard_init;
 	}
 
+	for (i = 0; i < linecards->count; i++) {
+		err = mlxsw_linecard_event_delivery_init(mlxsw_core, linecards,
+							 i + 1);
+		if (err)
+			goto err_linecard_event_delivery_init;
+	}
+
 	return 0;
 
+err_linecard_event_delivery_init:
+	for (i--; i >= 0; i--)
+		mlxsw_linecard_event_delivery_fini(mlxsw_core, linecards, i + 1);
+	i = linecards->count;
 err_linecard_init:
 	for (i--; i >= 0; i--)
 		mlxsw_linecard_fini(mlxsw_core, linecards, i + 1);
@@ -1535,6 +1562,8 @@ void mlxsw_linecards_fini(struct mlxsw_core *mlxsw_core)
 
 	if (!linecards)
 		return;
+	for (i = 0; i < linecards->count; i++)
+		mlxsw_linecard_event_delivery_fini(mlxsw_core, linecards, i + 1);
 	for (i = 0; i < linecards->count; i++)
 		mlxsw_linecard_fini(mlxsw_core, linecards, i + 1);
 	mlxsw_core_traps_unregister(mlxsw_core, mlxsw_linecard_listener,
-- 
2.35.3

