Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFE6640219
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbiLBIaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:30:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbiLBI3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:29:16 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20617.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::617])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1810FAD300
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:26:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M8aSRB8OJMdkm1lsiiJ0qcxbJLjnpghqCieX+FDEglZWJJZyGfleqizafHV45MSCH/uDQg8b8iLlFmka0yFnmJhs2krylIATsQ4CBagGHu/ELF9g/uitY6P8pM7ITQhzb4CbtiDVlbgmW6fFmazpnvt2BuABGu2JGPqyzjPK+2VHzmJbyTZYCbD9t/59EugzHFBUfnNt6TlcZl9DzuS7YVkYtmn7ipFovV1arxcu70aEAEa03yGcfl36qPOPbPfEzyhsFI5FHoaRPpZEK22s56zEpiNL5R7PQn8kOAvy9zi9vjUgdmuRoeycpB2edIrauRCP1h9hsg0mEM1WkwKvSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jI0oqAapzluA1YpkyjzcyXMuhaJW2qVrtZSa5F9r4sg=;
 b=hGs0gRiqKO4NvoOr+5z5md/fKPVTquMsmS303n4YfVGMQsSXuAoyxVtyU1PPZMsh/wkW+/CxF1SJqWEJFUFAhslQ2zRVF1BOG85enBn/pDHRk4f4MrxV9qqIxa/G4iGqAyBy1bffUF9Qn1+lPNEnTUaWEJIyjUVW+/4lhREW0UM4KM2EbPgBcei1Tkdllt/TWVlelKhI0Vrtw/+nrYnKQvkW6Y/VT2tMM4SoSh0wHZ/vys0rEAjlVWVJEc9ZbraPNEPVufdZEUNAK3VnR0zMq1eEVu3zMOKBDwRejjfq671wM5tk3kkQaAEeXyc4pNqRVOv8b7yXm0BXNlnbx/5rzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jI0oqAapzluA1YpkyjzcyXMuhaJW2qVrtZSa5F9r4sg=;
 b=GP00q3ZwVnBUyEqNRGRLjMjaIIbAXF4d3iBGBf2ecxX6h7E8fPoXD6jphg4g+PauhA3pK1NgmzRGenhokOc7eWCyNRK5/0nsmX330R2jNWcfQD48AuHr+7I4GkWd2Z0H+tdF9wRUkXy1L6e9TqN7wnB/YEomILK8bgudYu5dX/fBUH0k+wwq7ATXpaXYLWxYHK6gNPZrmU55d+FyAqNrPL9sS/L+t4XhZihzZY6VgdxJGPQ73ioEmwzEbXT0tUGWzWCBc2Ns7CML8711Ll5C++AZrFTtb3szyjmkrz6xQ6F6rlMv7KhCjp2t4vZFEHeZg4UQFC1w6pEqu5hVNwLGeg==
Received: from DM6PR08CA0047.namprd08.prod.outlook.com (2603:10b6:5:1e0::21)
 by BY5PR12MB4163.namprd12.prod.outlook.com (2603:10b6:a03:202::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 08:26:50 +0000
Received: from DM6NAM11FT078.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::3b) by DM6PR08CA0047.outlook.office365.com
 (2603:10b6:5:1e0::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10 via Frontend
 Transport; Fri, 2 Dec 2022 08:26:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT078.mail.protection.outlook.com (10.13.173.183) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Fri, 2 Dec 2022 08:26:49 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 2 Dec 2022
 00:26:42 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Fri, 2 Dec 2022 00:26:39 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH net-next V2 3/8] devlink: Move devlink port function hw_addr attr documentation
Date:   Fri, 2 Dec 2022 10:26:17 +0200
Message-ID: <20221202082622.57765-4-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221202082622.57765-1-shayd@nvidia.com>
References: <20221202082622.57765-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT078:EE_|BY5PR12MB4163:EE_
X-MS-Office365-Filtering-Correlation-Id: aed26a8d-6d75-4622-2d4b-08dad43ef594
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eEaSxDszEQ0hjSuZMatc6FDNO0lR/6IJ110mNF+rvmiB6eoQih3PYfd3YohU0gdMhBr3Fh99Qjq1ASrH9xQ8YYQZiklqEpoIJY8WiLQAGZohQnzn2knhDlyrzjBcGzkGct8tt6oDlpKqxFsCzmU9WXFVCCfzJIKPrmfUQX/pYWKu9r3UDRnDVOhl7mG/oIcWFSnOW/XZNsTBEh19E+tFQxuA4hOpvs4y+GpRnoVNm8WcXhO6f8TpcT4FxkSXhIanATvc3WcG9XPY8lyyKXKbHGxeroUKKWXapgYJdgz6ECu6P+XrpyQhBstMCFH1O73J2bbwAmO5Q4OA7Z19HAWHiL9cpNzAwTb+2l9hpwylPpzIz7jq+paLH49GC0mSmqfLy+4rYcJRhAMSV6+jBSYPOygLrRoVldQLIABFrX9/m/MpH/JTlBWIhWbVba28iuIW9cexFZDQdm+glWvyzQma8hJgnkbZ3NnCU65fskxp0kVyBeueLpQVBrjZYmCZZhQ0bZ2qqsVS4HATZaqGgg/9r52TggCG/iKpDrl4e+Zes28VW0dV9JL+pVE2cfqzhFfDqglnz51vZgSSDbzdCjQNCTFXd0PQRSLWeuENOQhtbM806gnHP3NDN+jgqWE15e1y+3bj1l5AfdQ/k6h2YYf4h6TKY3R04dkzSurlLyq/WNtd3o1/kLOy4Vy41KTe4P6hL40LVTCWqbdklP53OyfAhA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199015)(40470700004)(36840700001)(46966006)(426003)(47076005)(7636003)(40460700003)(40480700001)(2616005)(8676002)(54906003)(41300700001)(5660300002)(336012)(316002)(36756003)(26005)(16526019)(4326008)(70586007)(1076003)(8936002)(82310400005)(186003)(356005)(82740400003)(110136005)(70206006)(2906002)(83380400001)(86362001)(107886003)(6666004)(36860700001)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 08:26:49.7973
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aed26a8d-6d75-4622-2d4b-08dad43ef594
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT078.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4163
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
index e8fa7ac9e6b1..07cfc1b07db3 100644
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
-- Set the MAC address of the SF identified by its unique devlink port index::
-
-    $ devlink port function set pci/0000:06:00.0/32768 hw_addr 00:00:00:00:88:88
-
-    $ devlink port show pci/0000:06:00.0/32768
-    pci/0000:06:00.0/32768: type eth netdev enp6s0pf0sf88 flavour pcisf pfnum 0 sfnum 88
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

