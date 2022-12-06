Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E438644C0A
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiLFSwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiLFSwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:52:06 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D296E3B9CE
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 10:52:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bv+o5BNtacKQhSOURWGIvcfl7DiXhmcNfDWAVek42XL1ErmP1YrEtlaVRH5UXnTXdKb+lBXZjpgbhrbfDWznjweOxgFKy5vvAlyegyfwLRVDMTtx6uzvgsOc3eoHLxjwg9GJvjDfJ2wVITAiOviOnc9UpFLGxwll1yllDk6En0lTUJAGDeNSUxF548jIV5hBfT35ltQg8EvxKJjzkRys/c1BgPAdJYCIJWzKqEqe6c3XvwthRZG73zqWKUkDVDWIzU3E4TVv6LasXmdAQL8mzh/r1OI4d59F5RrT0o0EEWLra/kk4c6FUjXkxpB2rH/nqsUt6VuIxwpKuHkWpGh32A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eyoKRFtcXRa9rAoJOTbpVBI3U6fZeK8XoRhc+Ac85Ak=;
 b=BndtwysYes7PV2xVVeAK8hmvr4Y8ARlD0kbfyiK15zWsw/RKXU7dUIn3cIhrBfwuOuuK97BL03NX65JgGtk5FUr0uY7vI0IVKIgLafjOmgu5JjcsvOCogYdVZ6k69NPQjqBcPo6TRhEYw9JixLKxA3ajagBWlbTxXLhsUpiM8dtPwXtO9ZrfgUbhi00n/3K4fUGBcpkh13EONagnGyKRK6XBtMUh6g/R0bKwEhXH7NL5ZkXiXhSQy+Qhs8UupjkcCmVhiLj14pOErE4lwa+tQzfzQoR2F+dSe6/TC9GqER6fTnMNxj3dLLwK3hbTldgNDwSrU9sfhZxBNHGa0ygTcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eyoKRFtcXRa9rAoJOTbpVBI3U6fZeK8XoRhc+Ac85Ak=;
 b=cXzAeQccGLWz+QWaPyHletpnye25iC76GnmOepWiurnnBZtsuphuclAH56OhBIaXNKjwbtIZ0H+4hXsnCAlV39f8ByRzc30xYu9axtfIEMlnCuRIVQTunTwUVwMMLIe0UyBkdhkexLgJSNv/JorP2Fq7mIFjK2n4SLsE40LGBeVpxxxtVTg2EShjMGivNfa1ASdaGDdHzp9YUMDzjRajY8LqdzxleX9CA7Glrqm9dfxOVC4UOTGxnCGczkQhvJa5WWHOJmDEdRk1cOQTqRXlS6HFHykjlckA684o9kWeDSKK6dht8U7OgcaCf6zz0+kMYPIhNvS8bHd7Oyx5cw1TeQ==
Received: from BN8PR12CA0019.namprd12.prod.outlook.com (2603:10b6:408:60::32)
 by DM4PR12MB6063.namprd12.prod.outlook.com (2603:10b6:8:b1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 18:51:59 +0000
Received: from BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:60:cafe::9e) by BN8PR12CA0019.outlook.office365.com
 (2603:10b6:408:60::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Tue, 6 Dec 2022 18:51:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT025.mail.protection.outlook.com (10.13.177.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5901.14 via Frontend Transport; Tue, 6 Dec 2022 18:51:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 10:51:40 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 6 Dec 2022 10:51:37 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next V4 3/8] devlink: Move devlink port function hw_addr attr documentation
Date:   Tue, 6 Dec 2022 20:51:14 +0200
Message-ID: <20221206185119.380138-4-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221206185119.380138-1-shayd@nvidia.com>
References: <20221206185119.380138-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT025:EE_|DM4PR12MB6063:EE_
X-MS-Office365-Filtering-Correlation-Id: 66dfcea2-9ea2-4ca8-2fcb-08dad7baf462
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iRVp+3DeS5STqLMq+Wnl+RHLBhkL9CUhXl91pW/+2jCw+En20Z4iOArZqWK/jkiJzFEj6Vje7ObDxV7jHvBjvayHH/7ja24W3RZAAF6OV4HubhbNQGSjjflfNj2aGjkw1QphHKRd+VkSPiZ/4TiOS7AgYD2UMNQStg6Y8BdGu7GPek8NK0xiD4o5t1d2d4K9uTAbhtXkyxrYv0PIfIhcFcldULFaciD7uoqBZ/+HxlOHgtLpXM2W2QCb32mzoAxqMDz1St+MzE/jGMSqTTTGgKPNAt+Bt289O3aP7Or0T8zTUk6DAyNs6L/dtNdUpzBaR9FfuAbhDxcC8xFOdoyu3IKwwlGgBzUp58I0+cfCIv/UDU1OvWPHFxuUoJipqzooqABQg+QDKG1d/lBeQshArakx1uH3WKN3svjOcafoU4q8rVt4GKjd5DYq0rm1w+z3Pl6N7ceK6xT8dnnDvA8LFYuApSSiRy9LI4SuH02eNJ5FX1Sr3gHemPqfyJn4v1W3dJwjNF+rTL72YtjsWourIZHoMY3lOuZ1a0EwO+hh09VF4meT5XGrZW1NXRHWuekqQ8MXBWc9Kl3Uqs0RpCOBpSHN65M8vbD0MJQSfOv7rI2F9DhbpzflEuPABD0QrRkubxmSKSYIMmTHR5CvoDijcvX0yj0QSepDw3dc/1PXb2FZnUdgmTHDCGMp4rqy8+h4Y+YTQE41oPNfw/KlScAXtw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(136003)(396003)(376002)(451199015)(36840700001)(40470700004)(46966006)(41300700001)(186003)(16526019)(36860700001)(1076003)(478600001)(6666004)(86362001)(107886003)(82310400005)(2616005)(426003)(26005)(47076005)(336012)(82740400003)(356005)(7636003)(2906002)(8936002)(70206006)(5660300002)(8676002)(54906003)(4326008)(36756003)(40460700003)(316002)(70586007)(110136005)(83380400001)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 18:51:58.8279
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66dfcea2-9ea2-4ca8-2fcb-08dad7baf462
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6063
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
 .../device_drivers/ethernet/mellanox/mlx5.rst | 38 +----------------
 .../networking/devlink/devlink-port.rst       | 42 ++++++++++++++++++-
 2 files changed, 43 insertions(+), 37 deletions(-)

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
index 98557c2ab1c1..2c637f4aae8e 100644
--- a/Documentation/networking/devlink/devlink-port.rst
+++ b/Documentation/networking/devlink/devlink-port.rst
@@ -119,9 +119,49 @@ function device to the driver. For subfunctions, this means user should
 configure port function attribute before activating the port function.
 
 A user may set the hardware address of the function using
-'devlink port function set hw_addr' command. For Ethernet port function
+`devlink port function set hw_addr` command. For Ethernet port function
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
+- Set the MAC address of the SF identified by its unique devlink port index::
+
+    $ devlink port function set pci/0000:06:00.0/32768 hw_addr 00:00:00:00:88:88
+
+    $ devlink port show pci/0000:06:00.0/32768
+    pci/0000:06:00.0/32768: type eth netdev enp6s0pf0sf88 flavour pcisf pfnum 0 sfnum 88
+      function:
+        hw_addr 00:00:00:00:88:88
+
 Subfunction
 ============
 
-- 
2.38.1

