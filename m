Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E689641D62
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 15:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiLDORM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 09:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiLDORC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 09:17:02 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AE715FE0
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 06:17:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ecOdcWbSc2EGnNNPx8TJnrXbXmbALMsLnp+NNrkzG2HYucEcxKu9IbEhpwtLlp4dd9U08iT45ZOxKpiegtsrSG7oX/QgfRe0oy9QoNhN3Ad8c3SsURs5IUzQSotjRxlM7fi2S0rY3lQ4PzDb6MYq6hbS8j65zMfV3ABPweBtXNlZF9S3iTnVcAM6qff2UyPm/BIQ9B/Uh0Mbdry/2zBdlmUCwHGiln3RCfe3HHPA9HMv4AF3fKHWn82OvNk7xKmErjkLNyVnNfgKRtM8UntYvqQWwTn6Ys4bk2zhAHOamlVgMl3BoGWZJM4i21i/sk70WYLi+frTg5mLJ0ny1J0lzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eyoKRFtcXRa9rAoJOTbpVBI3U6fZeK8XoRhc+Ac85Ak=;
 b=KpfyaWdngZ7hT/6ZOfl6jzN7Jw/78bS/TGRQeZ1B4svoqs8YwRn6B4G4KuflOPKPGpKlHf1VEEjGTvwEcGYt/Fa14DkBNHVt/3Ot6HCx8Q/eknw2laeQExxGS5tgFkEAljHKGFY+2oz9qpmxnj53vNP3zTQrq/jOILjGisOPoyhb8/JQnlW2C7yaxS1z+D9x4HM8o/OfOrLbWGGb1p6PGjcgG9eU85OtHd4cYsJnZJA4LWGNtlug+S4dWy7niH1S47m8ZimemtRrhMQDSMy65l6QoK8BTiTHLGTHpiihUkBx9JPy2WqNdmlEKHbG1ijT4Ew5S+xFiDW7dTTH/F1Leg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eyoKRFtcXRa9rAoJOTbpVBI3U6fZeK8XoRhc+Ac85Ak=;
 b=DegxGrhcDI11RFbQf7qlK0TECd0eartxecU4txfABrgIip87aK5aILK36vTt/5zl1cT89zQtUQPOEcLC6YtRmQ+hI2wpV/FX76e8JExyjEh77v6qsRi/ATCkL2yBxcirL6PJ76YCB1NZVVXJe12I79+LsnZ5H/6coJGoTNxJSVKoYWTA7H3xY/y5wO15xz408qdyjw3/QHyp+DyuvjDmHQjtR34KheVlpfEg/CvoP2bSSLFJT/20TqGr79IUWTYOTyLaTAG7Zh9b0kx+ykQM3nnYObTbxYfIn1j/b8FbBGcfPfheXFjZqj6cAxiePt4CUVEF/SLkklkcmrnH824iNg==
Received: from DS7PR03CA0275.namprd03.prod.outlook.com (2603:10b6:5:3ad::10)
 by MN2PR12MB4358.namprd12.prod.outlook.com (2603:10b6:208:24f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Sun, 4 Dec
 2022 14:16:59 +0000
Received: from DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::f) by DS7PR03CA0275.outlook.office365.com
 (2603:10b6:5:3ad::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13 via Frontend
 Transport; Sun, 4 Dec 2022 14:16:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT018.mail.protection.outlook.com (10.13.172.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.13 via Frontend Transport; Sun, 4 Dec 2022 14:16:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 4 Dec 2022
 06:16:51 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 4 Dec 2022 06:16:49 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next V3 3/8] devlink: Move devlink port function hw_addr attr documentation
Date:   Sun, 4 Dec 2022 16:16:27 +0200
Message-ID: <20221204141632.201932-4-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221204141632.201932-1-shayd@nvidia.com>
References: <20221204141632.201932-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT018:EE_|MN2PR12MB4358:EE_
X-MS-Office365-Filtering-Correlation-Id: bb97196f-4fb0-4bca-0589-08dad602350e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GW4Cj4mkmMfX43tBHyyX9mpJ1vnVGz7RjVwChazQUcvZqr1zEDyEULcEqgdm9+1MzMLZwUu+OG8kIhdWzK2yELyPhW0RXsvdARmHAeHyi92iJ9NY9uy1FdEPgBGnO61HwdRH0O2E9sLYizqahvtlq4L0z3WlBIvmkFLEAL4AULp9Ymq3vcJbRqtCY0Q9oZ2aw6Sc1y5N6XpC3KK+b/aCRIImgXvA31+Ae5XVyDSxKoMehGGQr7nly1woFOP+sg30CdPs5S9Q2KDKUNN42/g/j3vlX6Qwo8FaaJhBchAjyBPEcO5v4pvigozvgGupA5KjFb/+eGC4F7rbfIRKHjF7Mfr4VyN/+/IeFoD/XZZiApBshECN0Fuh1YSMBqoAVH3nMWuy9yQ3EpWaZZHf/0dZeNTSiegFKUEdj9xp7xbPa2usI7smU9ajelHwe9n3oGgqiP/IwzioffHMr5MlKp6D7kzcJqSsqmvvjA2CxeULwjifwAsd5mBVlGIUGdSKKNWDQ81ESwOh4ZWIdPLXkpZjZFl/NSUp+O6R2J93E7KFDaq+PC8HU0mvWdTpFIN3qzG7VxUYnuP+WMY2H70iRi+pdik/pzrBbKRvOqrc7dnLUyVzYXDpbDhgKRzY0giunkDmx4ztRQwJ3NaQDkZn3w2LpF3JcdmnNpbKIu6zL2Ai6sGylYH0mPyhWKYmgWn3BfED6xL/Iu61CQQOWzJQAGQTUQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(396003)(376002)(451199015)(40470700004)(36840700001)(46966006)(82310400005)(36756003)(40480700001)(47076005)(316002)(426003)(83380400001)(26005)(1076003)(186003)(54906003)(107886003)(6666004)(110136005)(86362001)(2906002)(70586007)(70206006)(36860700001)(4326008)(8676002)(336012)(356005)(40460700003)(7636003)(82740400003)(16526019)(478600001)(2616005)(41300700001)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2022 14:16:59.3017
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bb97196f-4fb0-4bca-0589-08dad602350e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4358
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

