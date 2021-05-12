Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3DB837C0B0
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbhELOvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:51:45 -0400
Received: from mail-dm6nam11on2088.outbound.protection.outlook.com ([40.107.223.88]:15137
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231458AbhELOuy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 10:50:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=evYWVpZShkzuYNFBQcgXjD9J7WwfbdJYinJILYL1fbBkigejbCMBkTxCbzEac1HihGGtlqQQ7loq6yIW14KNncK/QKeQ5RzyyAdkjIK7Z9briiFJQeqngqnGx0wUDnURInPric2OItevJn+xaNLbSo0wIOpFFhvr7LqPL30GZwl6Es/4DO966Zi67+R/y9isrKzZ3hMVbjyVRJb10f0eLEk7bxnfxRFn1JL3NAnTLk6p3mPgr3TgNWvqDDhvXoZ/1alSjPl0A5NyhSlvh7J/PfNtrqrIfVBFEi+xUPRYqtFJ5nvj1Ii4pCL0ME245hWk8We2Fetdd0hsw5cfutEuoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBPq8br7bzVSLj7j04iZjzzzb1UwrpqmKDdAubcS680=;
 b=a7Xz2m2RMgxG7BDR42d7dP4S+LPnNxDFawTqtokQjlhuJb0a4PF71V0HY2mWNEcUjpL2MrJo9r4dws1YTgSd5O60HpXSAg6r2WPhZqtFjleLBbOAcfTHZPtA+oTAVQIca3uTIPhdELrg4sX1iZl/to2F3RXNZx+CmgD76s3DUZwnqccCOCHgYJ+7jco/G13nlZXQQZF4ZYZYoPNZ5jIsZRYvdtQzi85x72guyN4aWXROllwixGCYmr3uYcsrf6dZe3EcYya0KLEY3WtVEsexgt5BkaSWlESSTCtig5SrBbhSSsNZcnMmb/GuKLRHvGECNF1at6nL3AnzHG3vr9eFsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBPq8br7bzVSLj7j04iZjzzzb1UwrpqmKDdAubcS680=;
 b=JSIHyne/1l5wfG6hNTBXIo8geQq/kogu+Vzv2EkbVlRczdcriOFpKaZ9RJ7FcT8k4tlJ+ozrAqCLiVaTQ8M3ctOx07SIOkbxTuNG0b7Pakp0yYTDBIvxAYauu4zL02AFOe00MgnYco7Wxknt3B2yhcLxwuvRobzkVsnDmSRCxnHmWD+FAe3ZQXQMqn+Mtn/Cf+lok99GV7XposMHZOOpu5p0AiBE9qRY5lZz1m8t3cuzlauPbHGyuCZdsld8I1D23sUqQ11sOW+LAOqkKA8x5iTlrhYo8YcXQHWodP7pVWrWA28ulN2oSDCsBWfCZF8oYMoWHnE48iKRoZ29IZNOJg==
Received: from BN9PR03CA0234.namprd03.prod.outlook.com (2603:10b6:408:f8::29)
 by BN6PR1201MB0083.namprd12.prod.outlook.com (2603:10b6:405:54::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.29; Wed, 12 May
 2021 14:49:44 +0000
Received: from BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::4a) by BN9PR03CA0234.outlook.office365.com
 (2603:10b6:408:f8::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Wed, 12 May 2021 14:49:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT006.mail.protection.outlook.com (10.13.177.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 12 May 2021 14:49:44 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 May
 2021 14:49:43 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 14:49:40 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v2 18/18] Documentation: devlink rate objects
Date:   Wed, 12 May 2021 17:48:47 +0300
Message-ID: <1620830927-11828-19-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
References: <1620830927-11828-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f936cc4-fc26-458e-a3b1-08d915552e87
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0083:
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0083F54E59C5DD74EDB7EE62CB529@BN6PR1201MB0083.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: As3b1jNpQI/QYqTU6uayR6TtDB9iymbtk84GY9VxOZENRrmlWU+O3iUjEiJad4dWmIhGr205ErwJWbEmNBJKXafGxaxxlKdoR+up+wAY6M/bSLAMgmy4bmWTIEgXcl1J3SCykn5Mca5e7cmpEcLxehJXmvpOefk3z2JXXkoJ+wrcKgzAR1PEYLV1s2Mc0duhcsLkYM1aEdnb0EFwDGsfvWZ/t+Q1GQSTqEAnWuPW/JJUbuY5nRLxzvAUXKQWPhMW/shmKMWyGwyhxT+2JFh40XmAMpbr+OAnegcVaIHM1o79AtkNTjs6GRv93ZOMPyc614rCpc4EJJiEeLyzhRSViI6ILICExFf16rEq97+GR8SK0/P5fnjBwbogIBOi1Kl9idwTu4G/IRGium9VpLgrMnFlSGH1B8Fgi5Mab7Ir0ThYnEtksqasVtVPte5/qFbZRywyiK2olFaWUbaUEiKLw4Gk+vYcXk4dx6bGShFNZe84ZSF8aPYFI4kBC2JtpOBOiOm0Qceeryr8urD7zpdZsrNBa/yhOrhodGj2mMmk9NM29c79ZWza+obmwovhi+oN6XLqfkj8NdGHqpb0jn2/SnkqNaQnW7AtZ1Ak+cZrx0ibBa5pSsI0Hy1mImgJZHeu1T/UdqzZyLn7LgqG0PFg/8A3Uz0RwJikdliPJMxIzbA=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(8936002)(82310400003)(4326008)(70206006)(70586007)(86362001)(5660300002)(498600001)(6916009)(186003)(426003)(36906005)(36756003)(47076005)(7696005)(336012)(2906002)(2616005)(54906003)(83380400001)(2876002)(8676002)(26005)(356005)(107886003)(7636003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 14:49:44.4821
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f936cc4-fc26-458e-a3b1-08d915552e87
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0083
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

