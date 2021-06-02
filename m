Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB4139894B
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhFBMUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:20:39 -0400
Received: from mail-bn8nam11on2053.outbound.protection.outlook.com ([40.107.236.53]:24737
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229999AbhFBMUM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:20:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TptjN9TbxGNtdipg9fbMqpaKBB9PHUzm6Zlde2rgGmUi5kFHVIdy988YUTxO22rconF5g0ikX3S5751ojlqj7BUiJ8HLHX1zF0/Umc04eLmanApdHJUwao3t61gQxMvd6wCgPuOXs3GDACrXWozbD1yckKj8IHndHxXdlWpGdD3req9adet+QPR7+fLOJN7YK36BZLra8H/vY72e3wcPKqdcKjZKEso0oVncy7A5c3JJeabdBLj4xK/GSG4IVz9P4zuo9UkVgEaZflQtKwNPvIkcYomTxuYvhv/KTvUIS37jDKkoCSia7ibmqb/Sia6+5nmfR0bLwcCG54lC0ZlSfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBPq8br7bzVSLj7j04iZjzzzb1UwrpqmKDdAubcS680=;
 b=fA4vTh/J3fdXq3LVhQkLYKIrJulp1gXSRrVWhlorJPlSHm2Nq3UYLcNBVJb2hfQWiC9yL3OvJLsnEXQdnb2NVjwsA2QMQK5PLttSmX9cFU2dcJ7CgHoBiz8s6QP66oZaj0S2GT5eE/YD53i6XeWUd22g/6B9FwbOF/R49PgXHfW8OPAt7JF1T2p2fyE1JXp7ZviKWBf+jo+vY10p43Wf61SNYryQrvlolbaOXZngtYKmpTGDi0Tz88Y9vmQvbCZtst34sOhcqSNe4dF4EkcsBLvbJllXA/Fbkd84a5GeJecGhb0PiBqgbJoZop5h9NdWRHYke7qZbblpaxG1qTMrBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBPq8br7bzVSLj7j04iZjzzzb1UwrpqmKDdAubcS680=;
 b=uH+Tks5yi/3HGnHtvgOZhU7nXNDBYue187GbuvwUopa7KhM12eIaSN+FshpPcRj/JQRwATUlKJFnaELDAc6xW/5GxlD7vHUwo4AMEVM9YKMXtAT2P2PL5M+NTTalO1aHXcz8cMK7oYo7PpoUnJZqLRpSZwurq0DDdRxC1jzMHJ4gjiSCR7mmCXJUxtJKUm238XFjxfJN1eNJr+EhaP5jTPxl0zqlW4TscU9Xe6eiqbIX1bm1hB2kS+o0UsR8tQwFtLcTgojfSuXEg0SPY1thWJNdERh+0FZ/z07GcCuDmn/Cn08GgxVII1hn25AK5cTuxOpnsV0yzumUP6wuvhviQg==
Received: from BN0PR04CA0150.namprd04.prod.outlook.com (2603:10b6:408:ed::35)
 by BN6PR12MB1571.namprd12.prod.outlook.com (2603:10b6:405:4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 12:18:28 +0000
Received: from BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::63) by BN0PR04CA0150.outlook.office365.com
 (2603:10b6:408:ed::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend
 Transport; Wed, 2 Jun 2021 12:18:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT046.mail.protection.outlook.com (10.13.177.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 12:18:28 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 05:18:26 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Jun 2021 05:18:24 -0700
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND net-next v3 18/18] Documentation: devlink rate objects
Date:   Wed, 2 Jun 2021 15:17:31 +0300
Message-ID: <1622636251-29892-19-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
References: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8d4e993-0839-4a0b-78ba-08d925c08743
X-MS-TrafficTypeDiagnostic: BN6PR12MB1571:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1571797E3626805D38FBDA02CB3D9@BN6PR12MB1571.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TTuwHVAJSyYybTBQT+RZnsIgh6k1cwrw1uUlYibK5cU7Dl3cvjb7sViV0btwL3qFc/zezEEAcqjGnFdYBBhpCsxjrdQNXCjTY4DiMFsGLWvP1ImWl6yAG23Mj1V7l7hf/PxNhw8cuwfxOGHIk8wp7DTtRKJmfnUkxK9/XSnoi5QqMroL1yLJ+NXlEe8QDDERQBneP2dTQfejU+3itTb1h9C962YB2W7uIPD1qeOQ/KSySA+cAzHZLI7XewyDUA2Ex8FxvSk5pVWrkgrH/lKQvcUGYIOs5v7vlf083WYz8qTsGciVSfh7r9xglI0+eirtaZpASpMtBlmCvv/GT3BbCffaBR78Qe7Wu5NAqtdd+qzt2t5dGyxWY/m4BaKGcqMWVmTHjrH0Zn3p7VPefoy4qfQkuKvrrFRaN2Kmf26gp5ZJXttiEADvMEh64ieHfuvK+nBwsHtpZrWW2xKgm9IEVJfbantDB84gLr6tnuEYeh77XF06odmhD9/cBiE8mnZXnXgjX3wPDBReQ1BNY4wsFyd/0iCxRTqb1Q5n7LUH1HuzIRqMl9V4hV0yLs9GxcvJfgA6l2xkbLUtEUb0EmQa7QChM5Z4Jqo7gV2Lmqw6G2r57trwtYcgkcq2apeHIwUiFrTHkHm276Osa+jmNDN+Kv7D5VXGAd5yj48SBQG1QhE=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(136003)(46966006)(36840700001)(356005)(7636003)(478600001)(5660300002)(426003)(82740400003)(316002)(83380400001)(2616005)(107886003)(54906003)(70586007)(6666004)(26005)(186003)(70206006)(2876002)(36860700001)(82310400003)(336012)(47076005)(86362001)(4326008)(36756003)(8676002)(2906002)(8936002)(6916009)(7696005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:18:28.0231
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8d4e993-0839-4a0b-78ba-08d925c08743
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1571
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Add devlink rate objects section at devlink port documentation.
Add devlink rate support info at netdevsim devlink documentation.

Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 Documentation/networking/devlink/devlink-port.rst | 35 +++++++++++++++++++++++
 Documentation/networking/devlink/netdevsim.rst    | 26 +++++++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
index ab790e7..7627b1d 100644
--- a/Documentation/networking/devlink/devlink-port.rst
+++ b/Documentation/networking/devlink/devlink-port.rst
@@ -164,6 +164,41 @@ device to instantiate the subfunction device on particular PCI function.
 A subfunction device is created on the :ref:`Documentation/driver-api/auxiliary_bus.rst <auxiliary_bus>`.
 At this point a matching subfunction driver binds to the subfunction's auxiliary device.
 
+Rate object management
+======================
+
+Devlink provides API to manage tx rates of single devlink port or a group.
+This is done through rate objects, which can be one of the two types:
+
+``leaf``
+  Represents a single devlink port; created/destroyed by the driver. Since leaf
+  have 1to1 mapping to its devlink port, in user space it is referred as
+  ``pci/<bus_addr>/<port_index>``;
+
+``node``
+  Represents a group of rate objects (leafs and/or nodes); created/deleted by
+  request from the userspace; initially empty (no rate objects added). In
+  userspace it is referred as ``pci/<bus_addr>/<node_name>``, where
+  ``node_name`` can be any identifier, except decimal number, to avoid
+  collisions with leafs.
+
+API allows to configure following rate object's parameters:
+
+``tx_share``
+  Minimum TX rate value shared among all other rate objects, or rate objects
+  that parts of the parent group, if it is a part of the same group.
+
+``tx_max``
+  Maximum TX rate value.
+
+``parent``
+  Parent node name. Parent node rate limits are considered as additional limits
+  to all node children limits. ``tx_max`` is an upper limit for children.
+  ``tx_share`` is a total bandwidth distributed among children.
+
+Driver implementations are allowed to support both or either rate object types
+and setting methods of their parameters.
+
 Terms and Definitions
 =====================
 
diff --git a/Documentation/networking/devlink/netdevsim.rst b/Documentation/networking/devlink/netdevsim.rst
index 02c2d20..8a292fb 100644
--- a/Documentation/networking/devlink/netdevsim.rst
+++ b/Documentation/networking/devlink/netdevsim.rst
@@ -57,6 +57,32 @@ entries, FIB rule entries and nexthops that the driver will allow.
     $ devlink resource set netdevsim/netdevsim0 path /nexthops size 16
     $ devlink dev reload netdevsim/netdevsim0
 
+Rate objects
+============
+
+The ``netdevsim`` driver supports rate objects management, which includes:
+
+- registerging/unregistering leaf rate objects per VF devlink port;
+- creation/deletion node rate objects;
+- setting tx_share and tx_max rate values for any rate object type;
+- setting parent node for any rate object type.
+
+Rate nodes and it's parameters are exposed in ``netdevsim`` debugfs in RO mode.
+For example created rate node with name ``some_group``:
+
+.. code:: shell
+
+    $ ls /sys/kernel/debug/netdevsim/netdevsim0/rate_groups/some_group
+    rate_parent  tx_max  tx_share
+
+Same parameters are exposed for leaf objects in corresponding ports directories.
+For ex.:
+
+.. code:: shell
+
+    $ ls /sys/kernel/debug/netdevsim/netdevsim0/ports/1
+    dev  ethtool  rate_parent  tx_max  tx_share
+
 Driver-specific Traps
 =====================
 
-- 
1.8.3.1

