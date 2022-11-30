Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD9263D505
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 12:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234475AbiK3Lxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 06:53:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234023AbiK3LxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 06:53:12 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191816395
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 03:52:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nud7dxsny+t50OYD3f6nN2lbzelQjLE+FiyzRtXRnQFCrEZMAnXqcBhDFZMnTmCITCMFsOYmanenrS87fRPaISXsaihZwEVLR0tZjWogMMIBiUeKwlOJ+yZbI4RjQD59sqfy1fT09y3kO2BlcOEqKXIxZXHH9T5IzJCEPWQphE+nUEZdWBlEKM56LYnLtzSdEkLAOXA8v6ifRIrqFqd9xUWkgyRARknOHjHJN2H2iPNnYjr8+I1RYGGULdgs+wER3X3/Wka7FerLhByXQWC6b2K0fxI4b2zCK19AI5CS4UuxXWxDWyw4GI3dYOHwTugg4yPjAlUJmKp4gnbGJf9lBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uxbjXPUmyVu7jtPYS4lTU8jCr6P3PdNRtmwYwSWthpk=;
 b=C3SnvE3iuGbOtaS9r6H7grMI1h8EULelrUcg6kMQCvmHGDof6C3OGob1xtRxH43I6AJrjJxz3onIYAk2ODiIl/BliRgRabxKmq02Fh2b56Anl6XXu7UJkyl2HDfoEK7SFfwYoLhUssouplJRdwOuc32DrWNAS8DTS9glVBP7bnVSnqCRmAeNutZCjZY2PllWtO/maN2MJfo2s3/XnO7zK8LjmLzMo1necBODj2sSo9IxN1gf1XeZHmmEo+OWmdtk0c+EwcYVLEf0uS09Tri6IFVFjWmRInlALpQRbRLFJ5pYleXxvad9MCqWEfC5ich48nKKLoOH3SFxG8LvE0TF9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uxbjXPUmyVu7jtPYS4lTU8jCr6P3PdNRtmwYwSWthpk=;
 b=oCRMbwqcW2CfOQdozEhCz8Y1+xQIZurqaYeyMsPy7muVaxMjC4vYWx7hXvrR3gjRtF9S/IOyDxwgfZF3pR6Oad/XIuOYDD+R8Kuu8xZ4dN5YR5tKcP/hPJBMlMZ/4DkAUqN/+9Y0XCxR6gLGZSjVpoFYVRqyNjLgi/F8n16ZKYdRWSL2zFFjk0gQdTUNKw2NnOiU1nWlB3nbKtnKnP8CxNqvdN1OJ1lsRBRk798/10gKyaZtLgUo484t3PIP79+c0RYWQRUBlKAL/OdeYqmU7R55eeSY3o5UH1hIO5ckCj+gQHY/xUWP7rBz5Xj1Sza9NsRuipfv2/aLQsdO1rM5XQ==
Received: from BN9PR03CA0588.namprd03.prod.outlook.com (2603:10b6:408:10d::23)
 by SA1PR12MB6702.namprd12.prod.outlook.com (2603:10b6:806:252::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 11:52:57 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10d:cafe::70) by BN9PR03CA0588.outlook.office365.com
 (2603:10b6:408:10d::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Wed, 30 Nov 2022 11:52:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.22 via Frontend Transport; Wed, 30 Nov 2022 11:52:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 30 Nov
 2022 03:52:44 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 30 Nov 2022 03:52:40 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH net-next 3/8] devlink: Move devlink port function hw_addr attr documentation
Date:   Wed, 30 Nov 2022 13:52:12 +0200
Message-ID: <20221130115217.7171-4-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130115217.7171-1-shayd@nvidia.com>
References: <20221130115217.7171-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT051:EE_|SA1PR12MB6702:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e28c3e5-de01-470d-688e-08dad2c96c44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IxExsXfjKXf8tWoP78lTBBcD0XQOJ+94m0of38znyMhyL6titvpk7cCx23Urzm8MjbENfB+JkGtF5rYMXFOO70mH6DTcb3WCHYY35tL6imWZ34Afd0+cLWWaUImkSaksFKt5ZuRqIsd0+j8ZdB0dGa3N/Tb2fdjLnrJ62HQ8smDO61PzYdM1PZTes/aVej70dNV5xnwJUiOYgc70Hno7TblctdEgF1DKtPy4lUFDS3OL0GJRQFqynki9dwECr1K3mrrorsaXapN01ShcwaqfLG6pDKZTMMUCR+uiQB242mgNvqhC3eXFM+iixWYWwwWpPsic6E3B1anes1kMXR4Ap0e1cNX5Klswl7ZtxiPmtFqaamAFKZUmUh+j8f9Xtk3gtmnAICl/ltWnqD6Se5KUJPlAwu9/OM+G0bkrI7pJKjX9Dqnwrup2wojs95aLK3wGGnywCwjtJL25UkslHqF8CA1a9965tOhz8XHP/8PVliVMyHiYAWtIONjGHf+ghyqdPKkj31BVmErBVIT6BTcvkOwr0gHLCaeh7Vgv10V+8DpPkPMKVG6T0kQ/UrvbfEckuaYMTLghDVFxPneSE6Tzjn3iCJD8XAdsQMRLMHuOjS7jaBbqredPOKKmD8LjXUP6ot2cee+iCuQVJsq/cktWiJEQZv32SknnQTHfu6IGddihIHpPNaTJmX1H9U5MqkNoUtrB5pL7E/lKIpZo28o07w==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(136003)(376002)(346002)(451199015)(46966006)(36840700001)(40470700004)(8676002)(41300700001)(70206006)(316002)(110136005)(54906003)(4326008)(5660300002)(8936002)(478600001)(426003)(40460700003)(336012)(26005)(186003)(107886003)(1076003)(2906002)(16526019)(82310400005)(6666004)(47076005)(70586007)(36860700001)(36756003)(82740400003)(2616005)(40480700001)(7636003)(86362001)(83380400001)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 11:52:57.0997
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e28c3e5-de01-470d-688e-08dad2c96c44
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6702
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devlink port function hw_addr attr documentation is in mlx5 specific
file while there is nothing mlx5 specific about it.
Move it to devlink-port.rst.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../device_drivers/ethernet/mellanox/mlx5.rst | 38 +-----------------
 .../networking/devlink/devlink-port.rst       | 40 +++++++++++++++++++
 2 files changed, 42 insertions(+), 36 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
index 5edf50d7dbd5..6ae3b35a17d5 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
@@ -351,42 +351,8 @@ driver.
 
 MAC address setup
 -----------------
-mlx5 driver provides mechanism to setup the MAC address of the PCI VF/SF.
-
-The configured MAC address of the PCI VF/SF will be used by netdevice and rdma
-device created for the PCI VF/SF.
-
-- Get the MAC address of the VF identified by its unique devlink port index::
-
-    $ devlink port show pci/0000:06:00.0/2
-    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
-      function:
-        hw_addr 00:00:00:00:00:00
-
-- Set the MAC address of the VF identified by its unique devlink port index::
-
-    $ devlink port function set pci/0000:06:00.0/2 hw_addr 00:11:22:33:44:55
-
-    $ devlink port show pci/0000:06:00.0/2
-    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
-      function:
-        hw_addr 00:11:22:33:44:55
-
-- Get the MAC address of the SF identified by its unique devlink port index::
-
-    $ devlink port show pci/0000:06:00.0/32768
-    pci/0000:06:00.0/32768: type eth netdev enp6s0pf0sf88 flavour pcisf pfnum 0 sfnum 88
-      function:
-        hw_addr 00:00:00:00:00:00
-
-- Set the MAC address of the VF identified by its unique devlink port index::
-
-    $ devlink port function set pci/0000:06:00.0/32768 hw_addr 00:00:00:00:88:88
-
-    $ devlink port show pci/0000:06:00.0/32768
-    pci/0000:06:00.0/32768: type eth netdev enp6s0pf0sf88 flavour pcivf pfnum 0 sfnum 88
-      function:
-        hw_addr 00:00:00:00:88:88
+mlx5 driver support devlink port function attr mechanism to setup MAC
+address. (refer to Documentation/networking/devlink/devlink-port.rst)
 
 SF state setup
 --------------
diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
index 98557c2ab1c1..0b520363c6af 100644
--- a/Documentation/networking/devlink/devlink-port.rst
+++ b/Documentation/networking/devlink/devlink-port.rst
@@ -122,6 +122,46 @@ A user may set the hardware address of the function using
 'devlink port function set hw_addr' command. For Ethernet port function
 this means a MAC address.
 
+Function attributes
+===================
+
+MAC address setup
+-----------------
+The configured MAC address of the PCI VF/SF will be used by netdevice and rdma
+device created for the PCI VF/SF.
+
+- Get the MAC address of the VF identified by its unique devlink port index::
+
+    $ devlink port show pci/0000:06:00.0/2
+    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
+      function:
+        hw_addr 00:00:00:00:00:00
+
+- Set the MAC address of the VF identified by its unique devlink port index::
+
+    $ devlink port function set pci/0000:06:00.0/2 hw_addr 00:11:22:33:44:55
+
+    $ devlink port show pci/0000:06:00.0/2
+    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
+      function:
+        hw_addr 00:11:22:33:44:55
+
+- Get the MAC address of the SF identified by its unique devlink port index::
+
+    $ devlink port show pci/0000:06:00.0/32768
+    pci/0000:06:00.0/32768: type eth netdev enp6s0pf0sf88 flavour pcisf pfnum 0 sfnum 88
+      function:
+        hw_addr 00:00:00:00:00:00
+
+- Set the MAC address of the VF identified by its unique devlink port index::
+
+    $ devlink port function set pci/0000:06:00.0/32768 hw_addr 00:00:00:00:88:88
+
+    $ devlink port show pci/0000:06:00.0/32768
+    pci/0000:06:00.0/32768: type eth netdev enp6s0pf0sf88 flavour pcivf pfnum 0 sfnum 88
+      function:
+        hw_addr 00:00:00:00:88:88
+
 Subfunction
 ============
 
-- 
2.38.1

