Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457E7398934
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhFBMTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:19:21 -0400
Received: from mail-dm6nam12on2070.outbound.protection.outlook.com ([40.107.243.70]:10165
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229524AbhFBMTU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 08:19:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zoxn4P8CZNdq3ElBajGjr0SOFQFj8ua7h800qe4orkEON1UTUYZo8awXgLMhjnj2zGRrz5YZpYBZ9QX0FPby9ovcNGV2mq3UJAOMqwQeUNS/+W/7hFmU9mce4gZugK4G/jrTs5YH+BN0onInHBfIKQ/Q+cwnU8Vdyd/1Ikq5peQ0o+MYB1oq6nhhXZTxGRVlz9ODsgfm4lTHZkD0wt4uN+EP30Ib7q8dvUFoZbDH1qSx43YkqnA6Y0nchoNa+MaDxb4g4w7wYvI2ynE1q1zdgwJqc06IO/PMJdctj0fG2cTZ2GDHol3Y/zbMe0mgTSMsYQX3wxm9XzzZK5T1gZs+tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hms1YroHujL8JDy6gNP+cKimjRpRNuGN+CTAxVnu3zE=;
 b=FxqFZBhmJ025Z8cl7M06BS0WNQAIOSK3BjM7dNUmSAgr3V5fz6WsFwpW1aYNzEDlQcFJ6sPmJapTup5hAUPMElb2EinHjAherfZtbgCukeRwUpSrgoyInPn2a2TpYGxYDjyD6vDxHSb/iBzM1DLt5XtExx5eygivJlm81CTOsC1r7AYWFwO0uxdR+prt1nLvg0kv5KQ51RoSkfATnDLnfK0QnvD/9oBNVNgk3ghb+vfWBSDkKnuFpMzZlAEdPJRCbvtr9bn3cDFPMgXUFkktiUc+NY4X3UfPZqthI6J+Gty+V+IEFeSJEB8iHkw7sJUgWCvRulq4gOJA9HYUF5W+lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hms1YroHujL8JDy6gNP+cKimjRpRNuGN+CTAxVnu3zE=;
 b=DwnQkKQdgfp2vWMgqzG/YF5FmWmtXJz2VeDPOfrZXjiQSkc4HnPxlmZw7n4yHAX6HLP7kaJRQMy9ywWF81ULjZFSdB11nAVQUXdalFHcxsgevEF9qJ50AIPx2VeQGaeqRL9yM9UDadEPBB9/3CFFy11dmPnJ0FegKJJRcLlxrvy96DtFC0waB35TOxH9wCK9LYoQkLY0bjaCp04abCLT8c7ioIybEc5C6LfXr8adtwKZYCTEQD4k3Qk6s8Bj3aymBVq/3w5425xJSb48MUS6KMxMf6549KdGtvjbhrWOhUW2WZEcOlMgkaA6DVati1zox6XwaMCWVVG4MMiwPPEj8g==
Received: from BN6PR14CA0044.namprd14.prod.outlook.com (2603:10b6:404:13f::30)
 by DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 12:17:36 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:13f:cafe::30) by BN6PR14CA0044.outlook.office365.com
 (2603:10b6:404:13f::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend
 Transport; Wed, 2 Jun 2021 12:17:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 12:17:35 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Jun
 2021 05:17:34 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 2 Jun 2021 05:17:32 -0700
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RESEND net-next v3 00/18] devlink: rate objects API
Date:   Wed, 2 Jun 2021 15:17:13 +0300
Message-ID: <1622636251-29892-1-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02656d74-d7f1-4154-d4dc-08d925c06834
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5070B3E50E9CE6C12A6A2A68CB3D9@DM4PR12MB5070.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eE7X+G+Kakl6kszy1I245xGaTOD6L+QNUgxK9FR8ElxWKYID0MMeFIlcKziHbvxpLJdx4Di3opNdbEW2KC464t3ZdpwSCbaa2pj8NGo+R2zvpij9qyWbk3f2MrJ3FnpN3H76jQemCXNZvuYbqcIWljnR5Etuzs76tl0QDtzfLiNw3C7bDLMXSBcvFgjgvK7Snma6iPwq0/QoCXDPLUVoomZkUgSRVJlxyC82KocjtpZsLlaYUrDFvPuDGo5M6L54FcmcIdflri4upUH9CC+sSmg/s3i8b4wqTaJ5tw/MFRXWVu46pI03pCoQy+YfH8DaRnVlap06RWb1ph+1zCLxhqpyxzS062ZNUDYZFNDG/s1wJ4bFA5AnSMnDxmtohYa5FNE1qqTMl3prpiGkD+acFk67Oc6vbaKDRPv1WlRhJ0K8dIVg6zR1g/WoC3p70JoLhFVCODDo/MIXfNa9EfdVfey6DQgtSIpbVGPVlQAsbmehsq4mNoM7IDl1S3Neob8Y74VdHy1qc86bb8Y910fK9omrx51hojlybFR2dTQR6L2HZU50pkGyJvv+Jh9k4T8NLbch19jSTDCunOBA8S3tQSnJEUbqJWVl/szYDIcl72FeOPfzRDGOdX5km4cBz+LY8Tz34Gz6s9uff8j3QW3mI7kxZtD4bOm9PsU4BbA1CYc=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(136003)(36840700001)(46966006)(316002)(26005)(36860700001)(6666004)(82740400003)(47076005)(36756003)(70206006)(6916009)(356005)(7696005)(70586007)(5660300002)(83380400001)(478600001)(186003)(336012)(426003)(2616005)(54906003)(2876002)(82310400003)(8936002)(8676002)(4326008)(7636003)(2906002)(107886003)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 12:17:35.8828
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02656d74-d7f1-4154-d4dc-08d925c06834
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5070
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Resending without RFC.

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

