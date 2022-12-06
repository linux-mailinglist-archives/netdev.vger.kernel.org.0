Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22319644C05
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiLFSvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiLFSvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:51:45 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B4C3AC02
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 10:51:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nMMWzkg3CpNYSHXL7+e0hAKU9aFUgrRbN+xOubD5J10rnNLIyCKG3A1qyppR2ErI9BiGjewabcCFCETd01FUVvNicWbLIIPhPZKohKTP5qX7a/SJ3b2wLmTPoqYr9Civ8SIRTxEZxrxu0p+3W3F6V/z0URrKEmnOobq+VYQirv4csaEVafO2n7b8LHr2jAE8aJA0+Z1BtXGbmu8kZkFA0eXkEIWje7l1dcd/uoPCZwu5ujKf1xDYQBWd65UDuJr2wc1lrgGrmWDV0PsW0DHhg1tzW4tRnRbvsfbgovf2Qamxgzouqyrc4uJ30BoLWlNeS8BtoC+j5+dTV1nA8f9cEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uZd0MHPhLutaPXSWwRAoKuqIoC3JR38KNSpF6WhHY5A=;
 b=iuwbxilUaO6EIwgagsdXebeiMKkhD2kYe3il5AuWpPXD+WtCLwy8Qs33YcpBkrYRpjHCQT8G8sf/UmMIeeSFC2qvq5o7KXw/NPA8tjEDTff8HjchErsnzkgkvE0LIyBGJODAKj44GJs02yAEKU+JZcT6RWZffkyAxn8hhIRRw+u0zAyKxzkiceNXv85bIaaEekUrgC294pvaHr9nWhuV56fNus6y1ydKZfKxv8dayZ0fZnEKOEZF2KBOANejhlrEhLVZYLs0yw5pCv5zlqGF3nAFO1nhdfUdthFSYCP5JHl4G3/5/C43XRWPAiAHVue7odQrymeL3XiDOpW5kFIAbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uZd0MHPhLutaPXSWwRAoKuqIoC3JR38KNSpF6WhHY5A=;
 b=GDJ7uCRDpZkV7koDWEYf93U7wdhu5qksDoyc0kgjRo3BlmT062gvug8lixXPbW0r7fUDkll+QaS4LF1cCTJR32i/KImcIpFwehwZ3UKIlpfoU75KbnMrjSVE0eefHU+z25dWe4IM8UlULZFwrlgLxtGBHd62QFaxed7sTf9GLZrbmiD3adZsEbyIleavVTOjh31uH14Hx0krqO4lOTo1WvrObA7OPCmJ0RLE0FmagCuHOoY6ltZWmQIAnosKbdQXgaAWbZ1U3dbMtT9xadfF3e9WG9U+We2pmpNZCFtDZPWAqDDYPhnJHHvJeKDXJOFRJDhmFjafDh7g7q1cmEr/og==
Received: from DM6PR06CA0007.namprd06.prod.outlook.com (2603:10b6:5:120::20)
 by DM4PR12MB5280.namprd12.prod.outlook.com (2603:10b6:5:39d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 18:51:40 +0000
Received: from DS1PEPF0000E63E.namprd02.prod.outlook.com
 (2603:10b6:5:120:cafe::d6) by DM6PR06CA0007.outlook.office365.com
 (2603:10b6:5:120::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Tue, 6 Dec 2022 18:51:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E63E.mail.protection.outlook.com (10.167.17.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Tue, 6 Dec 2022 18:51:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 10:51:30 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 6 Dec 2022 10:51:27 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next V4 0/8] devlink: Add port function attribute to enable/disable Roce and migratable
Date:   Tue, 6 Dec 2022 20:51:11 +0200
Message-ID: <20221206185119.380138-1-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E63E:EE_|DM4PR12MB5280:EE_
X-MS-Office365-Filtering-Correlation-Id: a2e57286-9c92-42c3-4be8-08dad7bae93d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JKHwEOasbsZsXnwfieoo4qkFYck9+RYyrJnQmFE4maLYXWqqqTN73wnTkuxZC8/W59SBTzvyB3bMzrP1cOzylKvXSH4dA2Ca8uFXezRD63yS0Pao3dQVftS1uxYuVBUO14W4fX7DH/cZjxI4Nk/bMnq6Ird2UCixtAed9NtngDJ4nCH3DM+W9hdxPCW0pP8SFDuI1rcVM8q8VQZ74cVpPZpUZNnBsvv6NrpzydyUFT7SXNTZGV3D6nOQyqCuqXcX0hsoFdjX3UnaEToEKAOzpuLyfkiaw7avsRmWNjoRuGTHOW9QkFKSXq05VBjIcO/NgDMyHojyvsLx4McNOLUUs5Wxih+nnas5lPDagYqUDG0rq/EdNPnVBMdZaopJDj7MR1EhFYabMzFi9oxfkHdEgpYBZuFHxYVOt3Acv/Ima4ZQ4EFdzW5J3oIaQYExBO58Lk9CYcIvUf0Mjvruobvkllsp089eoT6+/lKRdJBuyZaNi83z2rWaoxJ+4wp8ADFl4pK9zRLLS7RTQEgieHYFuOuwulsujNpP+Q6XxgrbOpF+r08TY7mj3VMfLmGNUx0MepQqtPJnPjlX3XMhr/vR0WX0IiVYMrvRYr4AfAJVSHxd6EUYFnrPlaGaGkEc50mLU+lgExYBgVfj6HvFvoM8PriSipy6WTlbJ4jdhrm0vMDNws/WAn/wa6XHhvfIJ3vXSdsiMBe7xhr6jO3SnC7kWoUJD4U04lnEo5+A2In/6Jl2R0Nc58elZ/cnvIQdBLitkGt+gql1fjz0agmMCROdhKHvsLaiTsXM2QJ/RkjBhY4=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199015)(36840700001)(46966006)(40470700004)(2906002)(8936002)(70586007)(83380400001)(316002)(70206006)(36756003)(4326008)(8676002)(41300700001)(356005)(86362001)(47076005)(426003)(16526019)(82310400005)(2616005)(1076003)(336012)(82740400003)(5660300002)(186003)(107886003)(6666004)(54906003)(36860700001)(7636003)(40460700003)(110136005)(478600001)(966005)(26005)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 18:51:40.1625
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2e57286-9c92-42c3-4be8-08dad7bae93d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E63E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5280
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is a complete rewrite of the series "devlink: Add port
function attribute to enable/disable roce"
link:
https://lore.kernel.org/netdev/20221102163954.279266-1-danielj@nvidia.com/

Currently mlx5 PCI VF and SF are enabled by default for RoCE
functionality. And mlx5 PCI VF is disable by dafault for migratable
functionality.

Currently a user does not have the ability to disable RoCE for a PCI
VF/SF device before such device is enumerated by the driver.

User is also incapable to do such setting from smartnic scenario for a
VF from the smartnic.

Current 'enable_roce' device knob is limited to do setting only at
driverinit time. By this time device is already created and firmware has
already allocated necessary system memory for supporting RoCE.

Also, Currently a user does not have the ability to enable migratable
for a PCI VF.

The above are a hyper visor level control, to set the functionality of
devices passed through to guests.

This is achieved by extending existing 'port function' object to control
capabilities of a function. This enables users to control capability of
the device before enumeration.

Examples when user prefers to disable RoCE for a VF when using switchdev
mode:

$ devlink port show pci/0000:06:00.0/1
pci/0000:06:00.0/1: type eth netdev pf0vf0 flavour pcivf controller 0
pfnum 0 vfnum 0 external false splittable false
  function:
    hw_addr 00:00:00:00:00:00 roce enable

$ devlink port function set pci/0000:06:00.0/1 roce disable
  
$ devlink port show pci/0000:06:00.0/1
pci/0000:06:00.0/1: type eth netdev pf0vf0 flavour pcivf controller 0
pfnum 0 vfnum 0 external false splittable false
  function:
    hw_addr 00:00:00:00:00:00 roce disable

FAQs:
-----
1. What does roce enable/disable do?
Ans: It disables RoCE capability of the function before its enumerated,
so when driver reads the capability from the device firmware, it is
disabled.
At this point RDMA stack will not be able to create UD, QP1, RC, XRC
type of QPs. When RoCE is disabled, the GID table of all ports of the
device is disabled in the device and software stack.

2. How is the roce 'port function' option different from existing
devlink param?
Ans: RoCE attribute at the port function level disables the RoCE
capability at the specific function level; while enable_roce only does
at the software level.

3. Why is this option for disabling only RoCE and not the whole RDMA
device?
Ans: Because user still wants to use the RDMA device for non RoCE
commands in more memory efficient way.

Patch summary:
Patch-1 introduce ifc bits for migratable command
Patch-2 avoid partial port function request processing
Patch-3 move devlink hw_addr attribute doc to devlink file
Patch-4 adds devlink attribute to control roce
Patch-5 add generic setters/getters for other functions caps 
Patch-6 implements mlx5 callbacks for roce control
Patch-7 adds devlink attribute to control migratable
Patch-8 implements mlx5 callbacks for migratable control

---
v3->v4:
 - see patches 4,6-8 for a changelog.
v2->v3:
 - see patches 2,4,7 for a changelog.
v1->v2:
 - see patch 7 for a changelog.

Shay Drory (6):
  devlink: Validate port function request
  devlink: Move devlink port function hw_addr attr documentation
  devlink: Expose port function commands to control RoCE
  net/mlx5: Add generic getters for other functions caps
  devlink: Expose port function commands to control migratable
  net/mlx5: E-Switch, Implement devlink port function cmds to control
    migratable

Yishai Hadas (2):
  net/mlx5: Introduce IFC bits for migratable
  net/mlx5: E-Switch, Implement devlink port function cmds to control
    RoCE

 .../device_drivers/ethernet/mellanox/mlx5.rst |  46 ++--
 .../networking/devlink/devlink-port.rst       | 122 +++++++++-
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   4 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  43 ++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  11 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 211 +++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   5 +-
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c |   3 +-
 .../net/ethernet/mellanox/mlx5/core/vport.c   |  30 ++-
 include/linux/mlx5/mlx5_ifc.h                 |   6 +-
 include/linux/mlx5/vport.h                    |   2 +
 include/net/devlink.h                         |  39 ++++
 include/uapi/linux/devlink.h                  |  13 ++
 net/core/devlink.c                            | 200 ++++++++++++++++-
 14 files changed, 686 insertions(+), 49 deletions(-)

-- 
2.38.1

