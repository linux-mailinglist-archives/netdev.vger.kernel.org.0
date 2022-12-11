Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6B364940A
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 12:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiLKL7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 06:59:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiLKL7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 06:59:16 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2081.outbound.protection.outlook.com [40.107.223.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4881F036
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 03:59:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YTU3louIgvssho9m/JYRsN9OHSfPlyKFVn3wIMmXcJ+lGrF1GCL5kDURX75wSpRmGKDIvOGjy9MWnZNleW3aHv3jpQ6TcRAPtq3ld8keFgF7Uz9AXYv/K9k+7pzqMTLSjvCBazJkBiopHWN2zLqJhUicfffcOSkwWf6tEaago4l7AXT/e0UPg2box4+CoaCzwel1PsorJ/JwPVhKoTfWDgY0uzcWK0bK8DY/rKBN5OI5cSW2QoC355nQMdQ1HLRJ4Byhm4DAYo6FC6BZgXQduTDTGwBqiRWcuysUcHvojQXpyzr1ow195AW9DtGm1jLnf+yKKMijncTDC/8ONNYmiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GtHrRKLtjUeyt8cbBT/8jsFx3i8Gs9UC1OOqZnOtWYE=;
 b=CXEyM9EOeixG87kp+fgDMvG3Vy60c5D9QKx/ZsfzMbm2Qwu0i3L109x0buEnrVEghP/KVhqsONo7aJaLRmgDPzZ6mqpR0g53HiZfq7PvagTLvCoXZ/A5i8mjphaU3sQJIzP7FaDsDS46uKdL30Qw1/XV223mLn3IJWka2XAi2Om8FYV2EodE4cHpfMduK+CdiKgt8c960YKZPoQiAXUctke+ycXlwM22rsgcolYWD62uiDN1SUlg4zOk94bvMktG+iGHqwf2KdqrY0QBGO6F+PTqcal5e1NVP7GAYI6MZXxpVF+ufAiNhPMtGZgkkfVLBix03fqrOez9qgtWIjAJXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GtHrRKLtjUeyt8cbBT/8jsFx3i8Gs9UC1OOqZnOtWYE=;
 b=hgfQF5qALcYI+FK1k2vEVk5zSS6DOTTq9Clc0eXj8Tmg7l1Uxfl3P9btWrlHTdHAXR+MKwl+XQZtS3d4NQW5f4BD5EbimEJ7AHUFyo99f02K2vejWUIl1gwiEGFQV8akNZb9mp7vy64MlRoMub8ycf9r7IB1BRfHGxfBvfALDO/xox6deekh0ds6CohAUsFCicMyXAsqJmHBlmOcGHTfP4Ybk5TL7AiazfizUB/BMYFJwwP7q00813uzaemG/neSPjpfgSDtKeUMkHjmAN9E20g7igPB6Aryx8ZSwfAi/39seKBhcJIxnXKR2ND+zSUusvsI61eSu5fpRezEMqzAaA==
Received: from BN0PR04CA0042.namprd04.prod.outlook.com (2603:10b6:408:e8::17)
 by SJ1PR12MB6097.namprd12.prod.outlook.com (2603:10b6:a03:488::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sun, 11 Dec
 2022 11:59:12 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e8:cafe::63) by BN0PR04CA0042.outlook.office365.com
 (2603:10b6:408:e8::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19 via Frontend
 Transport; Sun, 11 Dec 2022 11:59:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5901.20 via Frontend Transport; Sun, 11 Dec 2022 11:59:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 11 Dec
 2022 03:59:05 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 11 Dec 2022 03:59:03 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>, <jiri@nvidia.com>
Subject: [PATCH iproute2-next 3/4] devlink: Support setting port function migratable cap
Date:   Sun, 11 Dec 2022 13:58:48 +0200
Message-ID: <20221211115849.510284-4-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221211115849.510284-1-shayd@nvidia.com>
References: <20221211115849.510284-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT026:EE_|SJ1PR12MB6097:EE_
X-MS-Office365-Filtering-Correlation-Id: 567b4baf-3d9c-43e5-4094-08dadb6f1dd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6pqxmRhqS/j1h6WwKfLX/2mJiM8SfjtUWy2pP7b9c9P1K3iMGVQy2tij6Db2Ti+Tmenw1v1vx6FdkTC2u1T5TG2cgUl59duL0/iLNCvi7xfKbHEB8rtKCmZgMxr4F+yIzxfRQCXEdnIvOCCuesnjo194EXvtFz8m47mxYrazrX2+se5PyDSoHjSRDgX4/YOv3Si6csS08cbsrUwVtWqyi7uGY+BNPBxSbIyvyueNW7q14JvYw/ewGM3o3nS+E2/5El6OZWXASCSSEYv70803k+jyek7tp2QKiTAyWGw2w+ZwlWkGg7DYxHx43JjvCV1l9wk/U3HTL88A3Li1uCXxWQXxCi7GfEZdAOS1m3h9FLAsCQ2Kik6t+xTnL56Iu3Aze02jJqEJ12DIHfFfKh+1LWoFIejfj06GJ5+5vbHIVZzaNC8PZPM4xuS4DfDp+S7rgopwdPEpe0/fTLk+weJnzp5Cxiu0jjA5G0Py/v5wRtTxjXB01I1M9X6vb2u2AFf7JEn2DcaEMiEFPqvVtEV6iNdd3xDt3z66B8Op4ZYmZazFNkfSZcQtm8RhwRsYc6+r6onfPcz9VhrwlqUvHMjIpo19a1qQp7k0NESkDAFnFl9SF0ISMH087y20LljfNBZUJ8qJZ2Ukvt6QoY4hujXVlL/P2YzuuGLijYqPQS1QcKaOWHnntZwMOh4ch5KoqS63agROfP3CgE4BF/ctR2VmNA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(136003)(39860400002)(376002)(451199015)(40470700004)(46966006)(36840700001)(478600001)(6666004)(186003)(2616005)(1076003)(26005)(40460700003)(41300700001)(110136005)(83380400001)(47076005)(82310400005)(426003)(336012)(36756003)(86362001)(6636002)(36860700001)(316002)(2906002)(8676002)(16526019)(70586007)(70206006)(8936002)(5660300002)(40480700001)(82740400003)(356005)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2022 11:59:11.2748
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 567b4baf-3d9c-43e5-4094-08dadb6f1dd6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6097
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Suppor port function commands to enable / disable migratable
capability, this is used to set the port function as migratable.

Live migration is the process of transferring a live virtual machine
from one physical host to another without disrupting its normal
operation.

In order for a VM to be able to perform LM, all the VM components must
be able to perform migration. e.g.: to be migratable.
In order for VF to be migratable, VF must be bound to VFIO driver with
migration support.

When migratable capability is enable for a function of the port, the
device is making the necessary preparations for the function to be
migratable, which might include disabling features which cannot be
migrated.

Example of LM with migratable function configuration:
Set migratable of the VF's port function.

$ devlink port show pci/0000:06:00.0/2
pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0
vfnum 1
    function:
        hw_addr 00:00:00:00:00:00 migratable disable

$ devlink port function set pci/0000:06:00.0/2 migratable enable

$ devlink port show pci/0000:06:00.0/2
pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0
vfnum 1
    function:
        hw_addr 00:00:00:00:00:00 migratable enable

Bind VF to VFIO driver with migration support:
$ echo <pci_id> > /sys/bus/pci/devices/0000:08:00.0/driver/unbind
$ echo mlx5_vfio_pci > /sys/bus/pci/devices/0000:08:00.0/driver_override
$ echo <pci_id> > /sys/bus/pci/devices/0000:08:00.0/driver/bind

Attach VF to the VM.
Start the VM.
Perform LM.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 devlink/devlink.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 66cc0415..be0c1455 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -2130,6 +2130,18 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (roce)
 				opts->port_fn_caps.value |= DEVLINK_PORT_FN_CAP_ROCE;
 			o_found |= DL_OPT_PORT_FN_CAPS;
+		} else if (dl_argv_match(dl, "migratable") &&
+			   (o_all & DL_OPT_PORT_FN_CAPS)) {
+			bool mig;
+
+			dl_arg_inc(dl);
+			err = dl_argv_bool(dl, &mig);
+			if (err)
+				return err;
+			opts->port_fn_caps.selector |= DEVLINK_PORT_FN_CAP_MIGRATABLE;
+			if (mig)
+				opts->port_fn_caps.value |= DEVLINK_PORT_FN_CAP_MIGRATABLE;
+			o_found |= DL_OPT_PORT_FN_CAPS;
 		} else {
 			pr_err("Unknown option \"%s\"\n", dl_argv(dl));
 			return -EINVAL;
@@ -4405,7 +4417,7 @@ static void cmd_port_help(void)
 	pr_err("       devlink port split DEV/PORT_INDEX count COUNT\n");
 	pr_err("       devlink port unsplit DEV/PORT_INDEX\n");
 	pr_err("       devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ] [ state { active | inactive } ]\n");
-	pr_err("                      [ roce { enable | disable } ]\n");
+	pr_err("                      [ roce { enable | disable } ] [ migratable { enable | disable } ]\n");
 	pr_err("       devlink port function rate { help | show | add | del | set }\n");
 	pr_err("       devlink port param set DEV/PORT_INDEX name PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
 	pr_err("       devlink port param show [DEV/PORT_INDEX name PARAMETER]\n");
@@ -4527,6 +4539,10 @@ static void pr_out_port_function(struct dl *dl, struct nlattr **tb_port)
 			print_string(PRINT_ANY, "roce", " roce %s",
 				     port_fn_caps->value & DEVLINK_PORT_FN_CAP_ROCE ?
 				     "enable" : "disable");
+		if (port_fn_caps->selector & DEVLINK_PORT_FN_CAP_MIGRATABLE)
+			print_string(PRINT_ANY, "migratable", " migratable %s",
+				     port_fn_caps->value & DEVLINK_PORT_FN_CAP_MIGRATABLE ?
+				     "enable" : "disable");
 	}
 
 	if (!dl->json_output)
@@ -4722,7 +4738,7 @@ static int cmd_port_param_show(struct dl *dl)
 static void cmd_port_function_help(void)
 {
 	pr_err("Usage: devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ] [ state STATE ]\n");
-	pr_err("                      [ roce { enable | disable } ]\n");
+	pr_err("                      [ roce { enable | disable } ] [ migratable { enable | disable } ]\n");
 	pr_err("       devlink port function rate { help | show | add | del | set }\n");
 }
 
-- 
2.38.1

