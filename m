Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A71366F73
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 17:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243766AbhDUPxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 11:53:48 -0400
Received: from mail-eopbgr700042.outbound.protection.outlook.com ([40.107.70.42]:20618
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235510AbhDUPxp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 11:53:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nJJAaO2AgG4sj33ocgbsKAYtTDtvg4d0xQ6cvx4TCg+SJ7AnARlHG/kFUDW6LCgKQGvCNXa4oASvL30ZkQX2ymfr+M2lfZ4lNuG0coRif8HuzbL0etxn608JpkMDyzl/OIHJwXQ8/etgSpEOQCH2kCqEUb2LSiSdffU4H7cB8ysLa1NJCfnTgL9skw4I/Q5hp5b5bUn5suLbH8ifu3nlTWXGO6C/r8+U2qHdIqJh2b0bpDnyPvMwPQs7otAGYkt+wa0hjb3NuWWILcydRVz+vsC7aAqAbmvWGg5A3zqEHPA4eAnjFeG/Y4eKiHGLNISdni56TgaRpyj6LZwf8gEscw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YyFThaNbhuH4rzTx/tVFqLd8Ba2ZTruwKgN8pusIQrc=;
 b=ZgYAN7vB2tKHPpVJ0WfEVZC/8jJsp1YTYQx2736YDWaaGOR71y3SwUHohU7Y6XOuHmPEOPZCys5E2AfbTRhbpgkiol7x7gYvsr9R1G9exGfRBdha8E53Xgrz51FQuFDUoxxMOkss/yVVBZBxpOuK1ac7BXS/LTM570IXqartaTAAztvRBF8xr/50IAgCBmM28U0Q57bX1YtUMhbbnlr4H1DG86KL14Q6bUTjesYq8Sjt7vlL/m/9gB5L1Q35xBsryKDnorRfksf35RWAlZZarTyITOeAeJD3g7ZSObeLRO7CQcVdHzrle5Z2A0zY0In+O+7tj0DrMictJVkeFLPqRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YyFThaNbhuH4rzTx/tVFqLd8Ba2ZTruwKgN8pusIQrc=;
 b=OJFm7KyaaBIJHr69b5MZU11VFtkGdU5JowObeqwnyMAwXVK5zNjs9IfBXQn/e8+HD6aX+fHw+Dkj25K1rTNwA83Z/ePXl9hTI4nFD/PxLl7Y5v/fXtWLl0vkTeXljUDcg7zSmkHMXkSpS7aeetOesRpxBETQbcLNiF1LBzMYeZJTf5tzuhjYMW0Dg8FUFdP3L8io38Qs2WLDZQyz56GLh4ddnXjyeCSNZVZkkz4Qhi7ZItCpAiwULDYSvGWwUxnviyhDM31qBmAYWcrsJ9JJC9c+xruiV40QsmlcEBORrGMkYczvYiCMyLN/fFXj/9QgOQw/1DBbjfJ9h2UkcJNv9g==
Received: from BN0PR04CA0045.namprd04.prod.outlook.com (2603:10b6:408:e8::20)
 by DM6PR12MB3995.namprd12.prod.outlook.com (2603:10b6:5:1c6::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Wed, 21 Apr
 2021 15:53:11 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e8:cafe::19) by BN0PR04CA0045.outlook.office365.com
 (2603:10b6:408:e8::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 15:53:10 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 15:53:08 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 15:53:06 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND-2 RFC net-next 00/18] devlink: rate objects API
Date:   Wed, 21 Apr 2021 18:52:47 +0300
Message-ID: <1619020385-20220-1-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4209e0a4-dac4-4735-8b13-08d904dd9086
X-MS-TrafficTypeDiagnostic: DM6PR12MB3995:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3995FF141F560F7EB8BED990CB479@DM6PR12MB3995.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w3AVj7ve/jPEdphFUA2zrNG5xYeEuQ93g02I+jZFLx4ZUF8iu1tpc2LT2d5WTEhV8EjrLYh09QhGPB3P8ynccgKi9/04AoAoJ9IQC1E1rESP4mX8Vi27xqY9aQVFBpDy+Jq7ok0RNyO12yET+brPDlTMItGDsFb0KU0E3qoGAzPS0sjSiNw8E2F3zfz5Kux/BpXYzRmWfN+7Btpdrj39H3/TM+BnYSSaVqTW+eqCcH3k4CRB8zZrfhnc6zDhZBNuVD8ny+8g2XDdSO0CH7Oi5fiKs/hrwyazObOFjJf1hRLYO2GiqO4AbxdReQ81qZmGemXmN9VqUcgXDWBAogjbgT0/27BvZHvhYFgBc0qXFYhlr2YGqiy1/DCyJcICrXtv5v4HbcEXMOzqNAS2bjMUUjjHj0MPx05lOBCp2O8qAXEVq62ohQiXInne1jdWLJKQcsjKFasBhqHYFDaukFYrNEl/DxPSz3GrDEpAsQa9fhEXoKm7LQRg3KSf+xu+o6dBy2r5UanHVMUgN+eOUz/t79G8dybd+sV9/iKGHjJ8kMMNvfj4Ju2fqWwSmJTCWQmy7IJBYvSbKh6SGcGKiGl6G+illhJjLaDfuVNJIGW3RCdn/oF7GskBNgkbXiHPBK2N6njPOpH8m92fc++vCRnMG863IEVPxweJxuhUKIwMSxc=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(136003)(36840700001)(46966006)(86362001)(7636003)(26005)(82310400003)(6666004)(36756003)(2616005)(82740400003)(4326008)(70586007)(8676002)(7696005)(356005)(316002)(478600001)(36860700001)(8936002)(6916009)(107886003)(36906005)(54906003)(83380400001)(336012)(426003)(2876002)(70206006)(2906002)(5660300002)(186003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 15:53:10.6637
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4209e0a4-dac4-4735-8b13-08d904dd9086
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3995
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Sorry for annoying. Please, ignore previous RESEND.
Resending, due to the issue with smtp server.

Currently kernel provides a way to change TX rate of single VF in
switchdev mode via tc-police action. When lots of VFs are configured
management of theirs rates becomes non-trivial task and some grouping
mechanism is required. Implementing such grouping in tc-police will bring
flow related limitations and unwanted complications, like:
- flows requires net device to be placed on, which wouldn't exist for
  "groups" instances
- effect of limiting depends on the position of tc-police action in the
  pipeline, while the goal is to have steady behaviour similar to legacy
  ip-link transmit bandwidth control

According to that devlink is the most appropriate place.

This series introduces devlink API for managing TX rate of single devlink
port or of a group by invoking callbacks (see below) of corresponding
driver. Also devlink port or a group can be added to the parent group,
where driver responsible to handle rates of a group elements. To achieve
all of that new rate object is added. It can be one of the two types:
- leaf - represents a single devlink port; created/destroyed by the
  driver and bound to the devlink port. As example, some driver may
  create leaf rate object for every devlink port associated with VF.
  Since leaf have 1to1 mapping to it's devlink port, in user space it is
  referred as pci/<bus_addr>/<port_index>;
- node - represents a group of rate objects; created/deleted by request
  from the userspace; initially empty (no rate objects added). In
  userspace it is referred as pci/<bus_addr>/<node_name>, where node name
  can be any, except decimal number, to avoid collisions with leafs.

devlink_ops extended with following callbacks:
- rate_{leaf|node}_tx_{share|max}_set
- rate_node_{new|del}
- rate_{leaf|node}_parent_set

KAPI provides:
- creation/destruction of the leaf rate object associated with devlink
  port
- storing/retrieving driver specific data in rate object

UAPI provides:
- dumping all or single rate objects
- setting tx_{share|max} of rate object of any type
- creating/deleting node rate object
- setting/unsetting parent of any rate object

Add devlink rate object support for netdevsim driver.
To support devlink rate objects implement VF ports and eswitch mode
selector for netdevsim driver.

Issues/open questions:
- Does user need DEVLINK_CMD_RATE_DEL_ALL_CHILD command to clean all
  children of particular parent node? For example:
  $ devlink port func rate flush netdevsim/netdevsim10/group

Dmytro Linkin (18):
  netdevsim: Add max_vfs to bus_dev
  netdevsim: Disable VFs on nsim_dev_reload_destroy() call
  netdevsim: Implement port types and indexing
  netdevsim: Implement VFs
  netdevsim: Implement legacy/switchdev mode for VFs
  devlink: Introduce rate object
  netdevsim: Register devlink rate leaf objects per VF
  selftest: netdevsim: Add devlink rate test
  devlink: Allow setting tx rate for devlink rate leaf objects
  netdevsim: Implement devlink rate leafs tx rate support
  selftest: netdevsim: Add devlink port shared/max tx rate test
  devlink: Introduce rate nodes
  netdevsim: Implement support for devlink rate nodes
  selftest: netdevsim: Add devlink rate nodes test
  devlink: Allow setting parent node of rate objects
  netdevsim: Allow setting parent node of rate objects
  selftest: netdevsim: Add devlink rate grouping test
  Documentation: devlink rate objects

 Documentation/networking/devlink/devlink-port.rst  |  35 ++
 Documentation/networking/devlink/netdevsim.rst     |  26 +
 drivers/net/netdevsim/bus.c                        | 131 ++++-
 drivers/net/netdevsim/dev.c                        | 393 ++++++++++++-
 drivers/net/netdevsim/netdev.c                     |  95 +++-
 drivers/net/netdevsim/netdevsim.h                  |  48 ++
 include/net/devlink.h                              |  47 ++
 include/uapi/linux/devlink.h                       |  17 +
 net/core/devlink.c                                 | 613 ++++++++++++++++++++-
 .../selftests/drivers/net/netdevsim/devlink.sh     | 167 +++++-
 10 files changed, 1514 insertions(+), 58 deletions(-)

-- 
1.8.3.1

