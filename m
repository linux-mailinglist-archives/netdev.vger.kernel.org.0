Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4F559B56A
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 18:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbiHUQVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 12:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbiHUQVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 12:21:15 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831991A073
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 09:21:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEFm02u6Kl2gkOMsOvKAlQaso8kxPKTici9Mr0K84WntjdL1usyixRm34l6EnxegpBng2dmP3OtOyJxTx1++osHbLPnCvWKB04M0aLY/tBwutIVyOgvHnPlHzAzkym5Dab1wjj0JtLyHETpF88HK7SQEH4c2GoOh4BN79CxVOyfZmBIw0Or1yBWbfgAoyiQtEyJ1ISRaKJs0yhIG+yRO24lnst30T/hjiBEtSBBQAeNJ+/LkZQY96p3wUxoiuhIFij02rVuViA8804Bs5JQ0H4TXLEjfGS6Fa+qx9D//uFDBHCpMfzY4/XGqPxz4nzYosDx6ZI0GIP4CYBsws+G85g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vQATnefx2XibPYlej3m2DlXrdDLpup+VwkPDJ/0mzKc=;
 b=GFiJelJKsYZPZVRUafT1bejI95SWnUj+8Y4vzxOxa73Pj0RGaenaNoS3AVFiT34KZB6dc/aprELlVCeb88PlsrEnK8S8yEKDXHqt5HAcxkIcD0Yj/LjVlD6kz/vL2b8JgHq+kmyZ2DfqZWh39IAtZmSPH/1OXr3P5U6vACQ4fYCRNdnUhE2jOlQ1eipzPse53sV7ynKUkBe+IjFCCObGAjpn1KAsxTt2WxGLvYY/A4Hl1knnqJPJx7RFXMN9V0sXXvYv6wZtt3ahHHJDJrE95r26qE215pZ/6EdhXKYQdkkJUnTJVkNlrFX2wvWYSptLUWDGj9b/98z42HoXaTsncQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQATnefx2XibPYlej3m2DlXrdDLpup+VwkPDJ/0mzKc=;
 b=n/XSbyMiu7qZ7u3OQJdjHVJDDAx0mpybz7ipMWNKxAGpsu+9uNUeLpFchXeu27y6EoN3F8GV4ZeEfJ9rzrXvOr1+Y2pMBCWfD1pdE8Epg11I5j0A7k7SBzJj084xFnUC7XxXLEcXz8UtvPflwoxMbnctOA2f528z77Es6w2s4oKjKNF7zEcbjuQfO1kz1xqmj8JMUipMozfpBhjWdLsCWbnuX9HR5WQxKfNoML9/7Dy0sd24KVDB7RX9Ux8B4q3W9NJNUuSPgLuPSZFTWdUY/JSHGyYH/JjAfNQaeMN1FD1oL+sTgHeeIaVUKzjoP/EE3TV+Z57oazC3/QlVvIeF0g==
Received: from DM5PR07CA0110.namprd07.prod.outlook.com (2603:10b6:4:ae::39) by
 BY5PR12MB4803.namprd12.prod.outlook.com (2603:10b6:a03:1b0::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Sun, 21 Aug
 2022 16:21:09 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::fb) by DM5PR07CA0110.outlook.office365.com
 (2603:10b6:4:ae::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22 via Frontend
 Transport; Sun, 21 Aug 2022 16:21:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.15 via Frontend Transport; Sun, 21 Aug 2022 16:21:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Sun, 21 Aug
 2022 16:20:42 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Sun, 21 Aug
 2022 09:20:39 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Vadim Pasternak <vadimp@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, <mlxsw@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 3/8] mlxsw: core_linecards: Register a system event handler
Date:   Sun, 21 Aug 2022 18:20:13 +0200
Message-ID: <a9255db3b84f58154c526c0d6d7ff475bb698ea8.1661093502.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9bb0f64b-4c47-4ee4-9f78-08da8391283e
X-MS-TrafficTypeDiagnostic: BY5PR12MB4803:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bMqDOPOrDCrULqU1pKbU19kA2q59Gp69O5yJMgYO+WIm+/WODm9IGaV8UdMtFhKjXTMkooncpA7socIowahxqN3czD7xhqA3I3wEuo1d5eJy4021lYVLnj0+y74KKLut/d1cWaa8/xChXvTweey/4UA2wEKbhlyPP1iJupMWN6NJcJK5wNzJ3lMx9sXRzCvsxCZbaVrrZaLdTWKgJscqI+xxnxrhdCwWdo+BnmHOWxiA/1KUSOqVQcsTnvcZyWTh/1zU3WfE/MB9fDkZ5IyU8Wb0kwRUb+Ui/EW5KqPhq+iAnrU15TQPqLWVOi/3mpjhAbJngCvR0oIV/h1qDW8AHjYxu55Y8GJvD/iFvyju2WdSa8yzEe13f052DXOzMDiZ107tLz4GWrEcODZbtOTZ+WzcsCOEIaX7rr9euqRrUVuVsFqrxVEAjTvqLvNFYu3c4McCYV9EG0HIgrLNaNox+03PRD17k6ptWG5/qOriG94ZSQid508cL2NAxyZRNO8ZI95vMpQL+LdqRjKttjXLTa5hOTip4ioSdcRnj4fGEGdjxNd9fo6uXyS/qFGs3CoSmF8TKHR+QGkUHa2JjxuhZNoMd9Cpz1A4IGpmivEi/51Z6+8UQe+QJ/bj79QnFRnGBC3s4Brkdl0FtfNVRn1/WxjDEf0NFr3snne+3DwA+8F2qRNqyL3by36181mwTJtgLZi+r8kFUP6IJrvvDWRWQYtNMx5yYdOGd4fEIwOTYatM65BE6QbLrSKDt+oTgLAGm5Jx7c5/c15D3gChRyG8/mfsmlaId6IW4PDlx2THlJ2bYI159PHWVqA+sGfAHio+
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39860400002)(346002)(136003)(40470700004)(46966006)(36840700001)(356005)(70206006)(70586007)(8676002)(4326008)(86362001)(110136005)(54906003)(36756003)(81166007)(36860700001)(82740400003)(2616005)(16526019)(336012)(26005)(426003)(47076005)(107886003)(6666004)(41300700001)(478600001)(186003)(40460700003)(40480700001)(8936002)(316002)(82310400005)(2906002)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2022 16:21:09.3785
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bb0f64b-4c47-4ee4-9f78-08da8391283e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4803
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

Add line card system event handler. Register it with core. It is
triggered by system interrupts raised from chassis programmable logic
devices to CPU. The purpose is to handle line card state changes over
I2C bus.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/core_linecards.c  | 25 +++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index 8549ccbcfe8e..83d2dc91ba2c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
@@ -785,6 +785,21 @@ static int mlxsw_linecard_status_get_and_process(struct mlxsw_core *mlxsw_core,
 	return mlxsw_linecard_status_process(linecards, linecard, mddq_pl);
 }
 
+static void mlxsw_linecards_irq_event_handler(struct mlxsw_core *mlxsw_core)
+{
+	struct mlxsw_linecards *linecards = mlxsw_core_linecards(mlxsw_core);
+	int i;
+
+	/* Handle change of line card active state. */
+	for (i = 0; i < linecards->count; i++) {
+		struct mlxsw_linecard *linecard = mlxsw_linecard_get(linecards,
+								     i + 1);
+
+		mlxsw_linecard_status_get_and_process(mlxsw_core, linecards,
+						      linecard);
+	}
+}
+
 static const char * const mlxsw_linecard_status_event_type_name[] = {
 	[MLXSW_LINECARD_STATUS_EVENT_TYPE_PROVISION] = "provision",
 	[MLXSW_LINECARD_STATUS_EVENT_TYPE_UNPROVISION] = "unprovision",
@@ -1521,6 +1536,11 @@ int mlxsw_linecards_init(struct mlxsw_core *mlxsw_core,
 	if (err)
 		goto err_traps_register;
 
+	err = mlxsw_core_irq_event_handler_register(mlxsw_core,
+						    mlxsw_linecards_irq_event_handler);
+	if (err)
+		goto err_irq_event_handler_register;
+
 	mlxsw_core_linecards_set(mlxsw_core, linecards);
 
 	for (i = 0; i < linecards->count; i++) {
@@ -1545,6 +1565,9 @@ int mlxsw_linecards_init(struct mlxsw_core *mlxsw_core,
 err_linecard_init:
 	for (i--; i >= 0; i--)
 		mlxsw_linecard_fini(mlxsw_core, linecards, i + 1);
+	mlxsw_core_irq_event_handler_unregister(mlxsw_core,
+						mlxsw_linecards_irq_event_handler);
+err_irq_event_handler_register:
 	mlxsw_core_traps_unregister(mlxsw_core, mlxsw_linecard_listener,
 				    ARRAY_SIZE(mlxsw_linecard_listener),
 				    mlxsw_core);
@@ -1566,6 +1589,8 @@ void mlxsw_linecards_fini(struct mlxsw_core *mlxsw_core)
 		mlxsw_linecard_event_delivery_fini(mlxsw_core, linecards, i + 1);
 	for (i = 0; i < linecards->count; i++)
 		mlxsw_linecard_fini(mlxsw_core, linecards, i + 1);
+	mlxsw_core_irq_event_handler_unregister(mlxsw_core,
+						mlxsw_linecards_irq_event_handler);
 	mlxsw_core_traps_unregister(mlxsw_core, mlxsw_linecard_listener,
 				    ARRAY_SIZE(mlxsw_linecard_listener),
 				    mlxsw_core);
-- 
2.35.3

