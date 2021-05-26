Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C90DC3916EE
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233082AbhEZMDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:03:04 -0400
Received: from mail-bn1nam07on2073.outbound.protection.outlook.com ([40.107.212.73]:15236
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232896AbhEZMDD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 08:03:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ANzBohvh4IGOU4I9U81fqCf7O02Cr2cvOnYQxUzt5brPXmJavFG2b4bdZExxTrci/qVhmRlrrYAfvQpBrf6e/8R5O6RUZbfOpage7crccM2Jk+4rRfip1o5AD99TyWnVcBfa5wmlc0oAke6wzBQP9lwv7bN6v+QsuxZwESasJ1ZU70C1JgiAUmKjZ7MYa0m+F11ZhEn5WExaHPTyiLW8QUDGf0j4qIdW03No76aoqTPG56HToPuxcPaCon4C8QZjPQS+9+/EUCCmj7uHBod8llvSpOPn5Y68hGBiYrFJWK2BmPlvMXC8SOsP6N1m0cR7PN2C3OzslqpNYxUhXDcAGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GGRCrymel375jxGGa9DP76HDlfh4vXygCcqWyR6Cq44=;
 b=LkIMhxHmabGyS4rnhJ1gd9ypxIMOpxLWiEOE2gcNrB8kPjBFLUE/Yu18pr+LwZnzTYEyo7G3upQin+hdX0RM2ENzfgUqrF+tP+Kbcq6kVaaodKo2+ufhLo8I2zTW3KubYyzIAYareJcDcubR+HtLRPHjwXQjZ9WW2Z0l5lmOU7gHxfuxaBaU+KD2KVjvZ21pEAPomtIwbY+bwbS+qm/naayWyHvVr/qzBFTpGglLja7nBac0Ljksmuz/AjKgHOprlIRShInU/2SaEhxP980nCFJdf6/A1YWJ5mT5FHHkpwkql3gjBqM4S3PGxKOxp2jsBmRRNeyjrXUn52lhxX2n1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GGRCrymel375jxGGa9DP76HDlfh4vXygCcqWyR6Cq44=;
 b=LBc/7/FKLVWPyqt9eWHidH9EuVCHx4zIv9yQKGaDYnsoMAM+lsguL1J1SdS613ix/ECcNnMDm4yKfdfq4/9pjh0QadZ1rSGdnCTQ3vbszJA7m1zu5SzycP7BVNvcVnFFEwDoGbQtNBBgDccKHc5dz1agRYS/4BqAPCcl7CSjZm+yR2kPiT+QhdzMu7DiozQVtzBsQXrH59xJF4a+w/uQtdzyFn1ICfNFJTGe9kc9NX7jsmF7uOICzwlP2BCo2igkoBpJTBidY0BEfDFyMO8tn9npNYqmnCNnc1fkDQDCo4bjPXr9ob5M1Hy7GzjMfppPFxYYpiSxUEFeErSrW3wBTw==
Received: from DS7PR03CA0113.namprd03.prod.outlook.com (2603:10b6:5:3b7::28)
 by BN6PR12MB1378.namprd12.prod.outlook.com (2603:10b6:404:1e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27; Wed, 26 May
 2021 12:01:30 +0000
Received: from DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b7:cafe::de) by DS7PR03CA0113.outlook.office365.com
 (2603:10b6:5:3b7::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21 via Frontend
 Transport; Wed, 26 May 2021 12:01:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT041.mail.protection.outlook.com (10.13.172.98) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 12:01:30 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 12:01:14 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 12:01:14 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 12:01:11 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v3 00/18] devlink: rate objects API
Date:   Wed, 26 May 2021 15:00:52 +0300
Message-ID: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41adf86a-5f52-4382-f94b-08d9203dffcb
X-MS-TrafficTypeDiagnostic: BN6PR12MB1378:
X-Microsoft-Antispam-PRVS: <BN6PR12MB13789FD73C5E04C7FB33D021CB249@BN6PR12MB1378.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HPPQrv7m4jSJLh4csV96SEjnamYwIdaiqURBUUSEg6Q2rsZ8fYOjooQ0m1uWC8/laA/LIyoTCiJQCZaD7MQifldBnMFNe4nvI/IxVgCi9CUbaVCqanFVObQ1GmT0J1ykguZRzUGZZMILDcLixS5wPm6iDGCH98gCi0oHApFwR87ZKjzEYGoZMlelu9MXovslnwGunGZ2sme1sq//9Mu14KHaGGocdRtgTAoEADofIT6aeydJ37sv8WWyRn+2S3u0mOoKlGlgBnXa64SatuRY9UPWbvaTvyAfTE6z8ER8iBBTOg01bAs+GsUPPnAAFJCkvSQAHpzBem55fYONVICaXlw2EIAnekK0TSWK2H4FCs5k/ZIccXQcYVigvfDnakuT2hAGHEmh0oT29iQLmSBilQSqBpMroIsgl9U49CxkHMS3pCo18OcxbTWS94roBbiqEgJwfQvsdlVSmLyhg9TQHQZQsV/lN6NTLVkZh19AU778w3UeY1JwH17lAg0bC8FDGtqGL8wEGHzwd7DzG0k5/pIxgCt+yDfqX16fwCa+fwVftJO/FoQUk+qL2vA6owSgRph6fDW+ZFVtGbm3oS6OkwBjTzWO6as2z3A75V1h5uEueI6JYgy2cDMOdh6iuiKa7TWDBcOuMtESGaINZNlaVars/9gS5WiJqmBq71M1p0w=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39850400004)(376002)(136003)(346002)(46966006)(36840700001)(70586007)(36756003)(186003)(54906003)(86362001)(36860700001)(2616005)(82310400003)(47076005)(2906002)(82740400003)(36906005)(2876002)(7696005)(6666004)(107886003)(83380400001)(70206006)(426003)(7636003)(5660300002)(6916009)(336012)(478600001)(8936002)(8676002)(316002)(356005)(4326008)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 12:01:30.5188
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 41adf86a-5f52-4382-f94b-08d9203dffcb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1378
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Currently kernel provides a way to change tx rate of single VF in
switchdev mode via tc-police action. When lots of VFs are configured
management of theirs rates becomes non-trivial task and some grouping
mechanism is required. Implementing such grouping in tc-police will bring
flow related limitations and unwanted complications, like:
- tc-police is a policer and there is a user request for a traffic
  shaper, so shared tc-police action is not suitable;
- flows requires net device to be placed on, means "groups" wouldn't
  have net device instance itself. Taking into the account previous
  point was reviewed a sollution, when representor have a policer and
  the driver use a shaper if qdisc contains group of VFs - such approach
  ugly, compilated and misleading;
- TC is ingress only, while configuring "other" side of the wire looks
  more like a "real" picture where shaping is outside of the steering
  world, similar to "ip link" command;

According to that devlink is the most appropriate place.

This series introduces devlink API for managing tx rate of single devlink
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
- destruction of rate nodes to allow a vendor driver to free allocated
  resources on driver removal or due to the other reasons when nodes
  destruction required

UAPI provides:
- dumping all or single rate objects
- setting tx_{share|max} of rate object of any type
- creating/deleting node rate object
- setting/unsetting parent of any rate object

Added devlink rate object support for netdevsim driver

Issues/open questions:
- Does user need DEVLINK_CMD_RATE_DEL_ALL_CHILD command to clean all
  children of particular parent node? For example:
  $ devlink port function rate flush netdevsim/netdevsim10/group
- priv pointer passed to the callbacks is a source of bugs; in leaf case
  driver can embed rate object into internal structure and use
  container_of() on it; in node case it cannot be done since nodes are
  created from userspace

v1->v2:
- fixed kernel-doc for devlink_rate_leaf_{create|destroy}()
- s/func/function/ for all devlink port command occurences

v2->v3:
- devlink:
  - added devlink_rate_nodes_destroy() function
- netdevsim:
  - added call of devlink_rate_nodes_destroy() function

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
 drivers/net/netdevsim/bus.c                        | 131 +++-
 drivers/net/netdevsim/dev.c                        | 396 ++++++++++++-
 drivers/net/netdevsim/netdev.c                     |  95 ++-
 drivers/net/netdevsim/netdevsim.h                  |  48 ++
 include/net/devlink.h                              |  48 ++
 include/uapi/linux/devlink.h                       |  17 +
 net/core/devlink.c                                 | 660 ++++++++++++++++++++-
 .../selftests/drivers/net/netdevsim/devlink.sh     | 167 +++++-
 10 files changed, 1565 insertions(+), 58 deletions(-)

-- 
1.8.3.1

