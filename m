Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73C74366F83
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244164AbhDUPyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:54:45 -0400
Received: from mail-mw2nam08on2059.outbound.protection.outlook.com ([40.107.101.59]:9697
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244158AbhDUPy2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 11:54:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dfbypZRJB8FFqYIyEw5JjwSY7sVrlMStKSFqMF8v87veHq6aKMkCCROZpX/inUqyBoCD9JZ9RFzdsCff4bLwm0HSsWGXpV9aumEtE4nZjpKuWiSSFYmP+x1ER6bIZc5UNAeePn9/SxNgydWJCs9dd6cepwKT3DPQ201qqiBFVytsQaJ4bDr28oTIrt5wVnqXxVT87VVr/CD//b5y4QTjcKW4Y2bkbybf36F9sPihTaPKl1YzCzt+52hdA7WnTl4Y4klGE1KVWJUU9meCeeUiIejard0F+5Syzx8Uw3D+2bu7kkNlw8pI51RgJagfAJdkcoFSGD6qoYQ3u18GAipjSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBPq8br7bzVSLj7j04iZjzzzb1UwrpqmKDdAubcS680=;
 b=RIYHD16GjASpgUYImN9eeBkgnVPBzmDO/oiY3Sw3Mu7I2ElluLTyevy77BBkfflYXvn2rzAU3QqVAwwo1/KQxokGDnxZobl/roRcGtoxi1F6rvqyjDMTJUDOO0XAARaSoLJXMYs0W5iimcReYhKWsucskb3XXHruodyRDM2dXMT8iviYXYjwr5xa6JA7GYzy2eSWhli4qvmjWF6h11U0pfBC5f327UYQbNpO3nbNmM/IJpC4KdGik5HHXya8BClph2vw2Zu+6c4ZZew266HTZaz08mAQ2Nz6d8g1/2zDQaN8SGfTBpZsae/sAl1s0KH8lKjaBaHsDorr1H6OUbJ57w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBPq8br7bzVSLj7j04iZjzzzb1UwrpqmKDdAubcS680=;
 b=QA59NZ+NnUtsOa1ld8ipNDBJTIzAV3x7XGJpM81icClxYnVVu73BBwolySzj6pHGShMcURw7s4ExwiQFhSqnusXaglrN02nwsMQdMdAkfFlcsi/51zj9tIu0yfkUMPpgmt0mZ/gk8vZpfXTLvHYm66lkzD1Cme/Xt8rdeKSMzua18KA/VrsrxVDzvtmr5G+qCu6zY9rdNGxCs8WvKfR/xr/cjkYkZIS+RwnVK48vSyTzTN83jq2yOFvgjTwODT0Lbl1Ckajs5N/nklCWsmMvbOb/0hmtWmf0qwUvyPQtAIU/m9681fXiGF06XXIzRK3qDcAG4MWpO/wcVbZjsc9SZQ==
Received: from BN9PR03CA0566.namprd03.prod.outlook.com (2603:10b6:408:138::31)
 by DM4PR12MB5264.namprd12.prod.outlook.com (2603:10b6:5:39c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Wed, 21 Apr
 2021 15:53:54 +0000
Received: from BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:138:cafe::24) by BN9PR03CA0566.outlook.office365.com
 (2603:10b6:408:138::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT027.mail.protection.outlook.com (10.13.177.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 15:53:53 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 15:53:52 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:50 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND-2 RFC net-next 18/18] Documentation: devlink rate objects
Date:   Wed, 21 Apr 2021 18:53:05 +0300
Message-ID: <1619020385-20220-19-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
References: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a5ab0ff-b7a4-4d92-5017-08d904ddaa39
X-MS-TrafficTypeDiagnostic: DM4PR12MB5264:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5264B4F48756039C63C1C81ECB479@DM4PR12MB5264.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3ulDCNg2Hkc9zoi0eSyI5WWovIiUaI/1OzabSsUekv5rZyoyP8USDnEF1AcmYO54rqjtMeazfcoZABpoBnLsWAvRGId1b7fAXvofKJX7xodHhCv/HeyYEhqafSn9FSZ20KMRA/JkpLrZrYo/WXS65uC9/voluo2+X3DY3ykNIdnt+tFjUnG8iB3E6KOyejxw+Dxr+ebR3hAx1N0KbpEry5/C/pnOXjprEZspGtUFYbGYAmJoa4SMMaUm8RA9vQiKxgCxsas9Y47DOwGRzFRwFZ2TGYy7L3BK6Vr+VFbRSukWFmgHmliQfqPHq0Ri55oOhQkJ5CzRIYbNlv+7ljSNfIXeTMdpNlAFr8abByXwbrSW4hp7IHYq9Q5RJJGVY+EFQE/teRr3FNYuLnFFnDDEi8USLBbzUaYz8tNPbYNJ0pNVs2ESuCORK6q/ui/1r8A2GMd+8ogijQXuPunIFXMUDls3m943pztbp+0uZmODdUse+EabQ/njFoAS8+y9rZX+GMdtCJyyfMb5eFwY4KGkOlEB831tmY9k4ezGD+EWqMv6uCbcZz9ulW4vhZAQ4R93DrKwnSKQOqTbHU6Cd6LcjiJg0fefnw5OPmAp4bwiOMOWOT6AFfS464jEgcYb50RhqDtNBfU+3NLqcv1E1rHUcgiD0/UHj7pdUrRFd0bAmcE=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(39860400002)(396003)(376002)(46966006)(36840700001)(356005)(26005)(336012)(86362001)(426003)(7696005)(2906002)(2616005)(107886003)(7636003)(83380400001)(6666004)(54906003)(8676002)(82310400003)(186003)(478600001)(316002)(70206006)(70586007)(2876002)(47076005)(8936002)(36756003)(4326008)(36860700001)(82740400003)(36906005)(5660300002)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 15:53:53.7823
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a5ab0ff-b7a4-4d92-5017-08d904ddaa39
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5264
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

