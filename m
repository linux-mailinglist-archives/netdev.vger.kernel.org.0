Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75EA4B219A
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 10:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346668AbiBKJVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 04:21:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234834AbiBKJVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 04:21:03 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465D8102D;
        Fri, 11 Feb 2022 01:21:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fo5f9o29h+Pbrpi992+giUcvNIJymC3vcKzeShRILiSCqwBLi+TJSRvmvSbL/mY0qf9Pxx3IpMFucJgZtiaiPrFT+ICtBaW9Fh0nUQiZsbC4zQ+/uLGDhSADzVQlxm+gEbBi5MSZ3Jl+lKmTgFRFyCTS8RVUTqX+fOmv2HeIpms31lBARPTIAG5MYAHEPDTIjJmKeXBwS6Sorq7zxwktQ5WPLeEZAiIB79jLWGMIb8TAcwNonnh+hd2OUWX6bPl7D25Nd5ceIAtScZZHYUd8Kc+zRn148Nmt7lHyVkT5U/cWHOlkoRXleXjRZsgE1r024tqsYHn1+8Z/2UivOKi8cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O9SpnAZFq6PFMtygOpdxQylPAuS6Us4gXIQSvjUc1O8=;
 b=DQHxvzDmPfr/5Sn4A2z0cjL8jMFDf6cXSCHAXml1txlU3gVv4WK4HQHJ51ABsfSUQavXS5CNXfGqUmjpKxkeGqnVhzgAq749AuUw5mRs5/hHlaUNPFGstNDXtiPAzWh0RuRazXaiYB/VQ8ieMne/EWckJs4UcAFEtD97aeCbC1IRxgHkNNL+rDBYP2txWZRRA9ddPGLTs6grRe+VAwwaSt7cWuGKRHByh+YEQYIOIWsWJYOZhGteOCBPmuhr5AFes/WTAgkoYMQyHlXCKbkdzE/B6iHTN/VQ7JPRplmGmltIDVKNl/xVzkbGTKMCuvp3rLEHxRt/D+JGakKrU4xwUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O9SpnAZFq6PFMtygOpdxQylPAuS6Us4gXIQSvjUc1O8=;
 b=CiX5NSj+aAzb6En2E9zWDZYNIcD97EIGAKjzGDG7LjeGTvBkGtMaz2bZfrJ1tMOzwuH2lnexKP36YoRL2gDFdTT9yjOa24Bq++b6AdGvzxUV6SGPP61DFAV92pSqz0a8NXbC/5kC2YA7vuaH0bt+fmPCpEhriKCYS4dbjtE7MQ+8S4eEzvYbZ4hZyz8FGh3w0D8Mb3maDQNMB7KMT8lLUmfBthRKTSOFg4Ha/HdtPUzPfo8g76YSYMfHgDDksGl7FfCImkcywwzENKpRvSGbUwPLqDuI/nmeEfn6dHaA7sFmp8sl/dru8wKg2zjR73c5k559iOlv/r6HMtnTQziN0g==
Received: from DM5PR13CA0048.namprd13.prod.outlook.com (2603:10b6:3:7b::34) by
 CH2PR12MB3655.namprd12.prod.outlook.com (2603:10b6:610:25::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.11; Fri, 11 Feb 2022 09:20:59 +0000
Received: from DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:7b:cafe::5e) by DM5PR13CA0048.outlook.office365.com
 (2603:10b6:3:7b::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.6 via Frontend
 Transport; Fri, 11 Feb 2022 09:20:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT018.mail.protection.outlook.com (10.13.172.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Fri, 11 Feb 2022 09:20:59 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 11 Feb
 2022 09:20:58 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Fri, 11 Feb 2022
 01:20:58 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Fri, 11 Feb
 2022 01:20:56 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Parav Pandit <parav@nvidia.com>
CC:     Jiri Pirko <jiri@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next v2 2/4] net/mlx5: Delete redundant default assignment of runtime devlink params
Date:   Fri, 11 Feb 2022 11:20:19 +0200
Message-ID: <1644571221-237302-3-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1644571221-237302-1-git-send-email-moshe@nvidia.com>
References: <1644571221-237302-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b83ad22f-0e79-482b-da1f-08d9ed3fd119
X-MS-TrafficTypeDiagnostic: CH2PR12MB3655:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB3655563B90941D845DB41EF8D4309@CH2PR12MB3655.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PvO39q9WN3Ac7CzBDYjsd43m+Gz78EnEaQWcWfGkW1szLRgZICn9KyztgL01fF51MtJb2OuMbYF4Sm3VCmaubBNHpPpTYLHauJKhqwxZ6Xkee4V2AThYfRx1ICZgUwbF2Kl64TRID4yJZ2Cgu0uWBHnQ8Na2DMWTlRGWmPrQGkjptUTkvtCy8MRzwRLQtACx68Dsf4sH5YHl5jHqjv6qsJysURzN6i4NkG2+4HJzBKveYV6FWLjjuIKyEjqoj+MH3W3KjZufVmtNsrIRJk91tvz3S+/aJbsCVjUSrmreFMJBt9/mqVKFXN8AHDsJtZvgdiJQ41lG6PhBKhMCoANt0GfAgZWpCWOYYWe98wxeFfPF5CkpoCcUnSJdVUjejaFT+GcwpeMnUk3m2a1aX6wcOePHFU8oz80GPtMf5kaWVI/kIOf1zhJZyq0rcxeGe5C5V7nHnULw7QrcJL/bpUS1+RDXuFZN5hsjLEuY+/BPsXAlNxZgiy+PhWs1J0LyLzvNJJ/Q+VGQtu7YJfwTL5y8iHpIh3WYPLpCNW22EJD6UjgJIm6+s9rY/psiFoz3r+ne2Gg6WRUk9pkvpi3I6LkLhPMD8DIFHviZPmOXOZrRfMKGwUH+/BhDV3F39GF3AIN6XIn4gadFXZH+DFDrruv3555XurRyKGtH/0JQzZ7Q6IId5cwinTba9ogfuitI56ZAwgjvUPjawfflwZXIOpRCUQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(110136005)(316002)(54906003)(8936002)(4326008)(86362001)(6636002)(6666004)(7696005)(36860700001)(47076005)(36756003)(356005)(81166007)(8676002)(2616005)(82310400004)(83380400001)(508600001)(107886003)(26005)(70206006)(5660300002)(70586007)(336012)(426003)(2906002)(40460700003)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 09:20:59.5240
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b83ad22f-0e79-482b-da1f-08d9ed3fd119
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3655
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Runtime devlink params always read their values from the get() callbacks.
Also, it is an error to set driverinit_value for params which don't
support driverinit cmode. Delete such assignments.

In addition, move the set of default matching mode inside eswitch code.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 20 -------------------
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  3 +++
 2 files changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index d1093bb2d436..e832a3f4c18a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -588,14 +588,6 @@ static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	union devlink_param_value value;
 
-	if (dev->priv.steering->mode == MLX5_FLOW_STEERING_MODE_DMFS)
-		strcpy(value.vstr, "dmfs");
-	else
-		strcpy(value.vstr, "smfs");
-	devlink_param_driverinit_value_set(devlink,
-					   MLX5_DEVLINK_PARAM_ID_FLOW_STEERING_MODE,
-					   value);
-
 	value.vbool = MLX5_CAP_GEN(dev, roce);
 	devlink_param_driverinit_value_set(devlink,
 					   DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
@@ -606,18 +598,6 @@ static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
 	devlink_param_driverinit_value_set(devlink,
 					   MLX5_DEVLINK_PARAM_ID_ESW_LARGE_GROUP_NUM,
 					   value);
-
-	if (MLX5_ESWITCH_MANAGER(dev)) {
-		if (mlx5_esw_vport_match_metadata_supported(dev->priv.eswitch)) {
-			dev->priv.eswitch->flags |= MLX5_ESWITCH_VPORT_MATCH_METADATA;
-			value.vbool = true;
-		} else {
-			value.vbool = false;
-		}
-		devlink_param_driverinit_value_set(devlink,
-						   MLX5_DEVLINK_PARAM_ID_ESW_PORT_METADATA,
-						   value);
-	}
 #endif
 
 	value.vu32 = MLX5_COMP_EQ_SIZE;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 458ec0bca1b8..25f2d2717aaa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1582,6 +1582,9 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 		esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_BASIC;
 	else
 		esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_NONE;
+	if (MLX5_ESWITCH_MANAGER(dev) &&
+	    mlx5_esw_vport_match_metadata_supported(esw))
+		esw->flags |= MLX5_ESWITCH_VPORT_MATCH_METADATA;
 
 	dev->priv.eswitch = esw;
 	BLOCKING_INIT_NOTIFIER_HEAD(&esw->n_head);
-- 
2.26.3

