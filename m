Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98AA391703
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbhEZMEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:04:47 -0400
Received: from mail-mw2nam10on2069.outbound.protection.outlook.com ([40.107.94.69]:62208
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234692AbhEZMDr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 08:03:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mICKzpCIWkMciHcahnUzp5R+jEtmNItUCQFv3sQrHhTA27yWaAtfeDNmIHr8Nn9eQ71t2BzWf6aFL2mx5hGME5gkufOTN7T1k/D2A9fbHAMhA4X09i41iidZd3htgkFH0pDPDEMocJz0SBCYIH/AO9E6TK+sC2VZt43XMjv2wNsGfU31a+iGYAZokme6JbI6OB9tF82DoEGigmdkYnPisvzV0ZkjdVLJl2egnourCiLvgAMh8TYm3eTa5cSXjKy2wHBP7o/sc8vfS2+DJKlc/EOjC317lCvwvWaSWc3S5eno4wbnCz/Ls1J96IiXm9BTBAKzRhqGT8jizf1bTohoVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBPq8br7bzVSLj7j04iZjzzzb1UwrpqmKDdAubcS680=;
 b=lqxIljcUtGQdybRy4CvilWn6fvkBdXGlqSPtwBNBxRkUvpjnDxHBe/boFSjlcgZ8q7uph9srzOOIv7g+5sSRqzcvp1yonAVL4kmcXDr1IqvBLLHS1RmaS5VW8+xaZSHTtK3DbhkKeV993xjcC5jDNX76bIKv1TY+3LJ0KP/s8hxqIl5gMBHzfhkWhtYmhAay80mvqzT4eHSet3mxmIFrKNGT8bMjoegSlHv/Q2i30JF2No5pgUdG4hRkbomLcsyTllLzfDNGHVNw0c7qYTp21JpAXzBPbI0OJhk55Xj3uGVtwwoyuM19Am1rFRlcWQYnOE+7RIag2mdiPIl4HfxveA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBPq8br7bzVSLj7j04iZjzzzb1UwrpqmKDdAubcS680=;
 b=t5VcREDvkdBLbDg0LHuGwdlKDBn6FCAxcsk9RAIcaGO3EHQuLOp1rxPEJqowioK9YMJ2TrH8w1dfgWulEqWnVnLM+ys5lEXbfEKf45V6Tkt6qe/VcJxdHBwlIXnhF5+iPXf45HSwq0UpS3GcFce/I3qcJ8a/fztkd0hUaMPFJbbuffrmX1MIY/RL/p3Y3eXQUJLuDfwb7PF66bWG5YWHRVaJ+X93o76z6cIUH65yAfPsKZE2bM7Zoa28qPEboy96wFfd6ffzNXdONQwQNe6qa/RrdO9kvtjw9EBU7g5n8+OpEcH49qdsG8l8RtQj28LS3uyHek+QSY0ngpEIrQSuTA==
Received: from DM6PR13CA0066.namprd13.prod.outlook.com (2603:10b6:5:134::43)
 by CH0PR12MB5314.namprd12.prod.outlook.com (2603:10b6:610:d5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 26 May
 2021 12:02:14 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:134:cafe::73) by DM6PR13CA0066.outlook.office365.com
 (2603:10b6:5:134::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.9 via Frontend
 Transport; Wed, 26 May 2021 12:02:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 12:02:14 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 12:02:06 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 12:02:03 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v3 18/18] Documentation: devlink rate objects
Date:   Wed, 26 May 2021 15:01:10 +0300
Message-ID: <1622030470-21434-19-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
References: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1636a64e-0e5b-4de6-329a-08d9203e19da
X-MS-TrafficTypeDiagnostic: CH0PR12MB5314:
X-Microsoft-Antispam-PRVS: <CH0PR12MB5314F05543796EA11BD86A41CB249@CH0PR12MB5314.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s7XCcEDwT0kcJ5TvqeBSvf4dYaMLhsX/obstSXThXNvA3ColmcYXGnOKO3rCWph2L+EfhS9yuIdz6iTrykXsvJZZa7ncJCJGFmiXaLDyoPg1buAQFCpy6Ogwnzm5bwGc9mnGyXuFClGAK3gMKVhRnWQfRHwxadMSklalNPjmeJbMZGCxeU8E92gOMo5VlVE+I3UpeXoWrCknWMMfVvVhSMrabwAku5wfOiB1LlRd9GKcUWcFEqJMVIMK/2te/LzOwL9B78MXFQoCZ7bKjoq6YpbaCHLxLq/diD3LHigZUEEZVNdizk0fMsCEL0WH04GYJc9jwBHX408EfkStba5E84iO13iIFRewLHKWYmIRBSWpSd83UqTo1u2e4HWNbMNEylzNMrhta6RlZ3LYsq8WpvjnCkZJBUc/ic7KB2FsXxsn3Kqyca+tspDT/tq9R0E17aGCmYPkMfzKv3RO2/xEIzK2CI78RYxbgzWU+J4um4cx4rWaiKo8dPPi7+yciAC431g6waeDEfa2rWuUG+drzRdZrbDPKGdRqLxb0zZYTo1+bs/xMVqS1uyEiWc7u+jgqxGNfmB6QT63H9YiurMllaJekW4QOOd/m9QwNIBFKyvgEosCNjGWvFVLxw+rtc3uadWEHEUx4AMPVfhdI3Co1s/Y3iCLBwwkX8LTecUEsvQ=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(36840700001)(46966006)(86362001)(82310400003)(6666004)(2876002)(107886003)(47076005)(36756003)(7636003)(83380400001)(356005)(6916009)(478600001)(26005)(8936002)(336012)(70206006)(186003)(36906005)(54906003)(316002)(2616005)(70586007)(5660300002)(8676002)(36860700001)(7696005)(426003)(2906002)(4326008)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 12:02:14.2267
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1636a64e-0e5b-4de6-329a-08d9203e19da
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5314
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

