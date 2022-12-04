Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02CA1641D60
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 15:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiLDORA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 09:17:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiLDOQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 09:16:53 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B5C1649E
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 06:16:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iruGB+xqK6Qy+pfSLRb7XlVYueL+3PUBMoirb0ibM87wmCnZZItWzR3b8hY2IVBNzVlRDJGsvLD3it4AeREOMbwuAWsMXX5FOEWWaCWVpF710kMT7slVQGjO1oBOvCX5JuCk0vaGd27RWYyDit7VExSsKz3NK/J4UjQyfbqZz/qiJVAXPP2DFd/rA4eQz92q4e76rmftJmn36EMnUFmz3IvFPKhWjQknQ2CBP/GbC2ien68a7KGBHungU7hhot+B67qSjYLIWd3CUzETTPi9Q6hrmwJuuLt4AudfGgOJoJu2zKbYiHwhbtx+vLZXxuUWAs9siJDsoZqrB0rnJ7/Gjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bNzEqKCq/k/IK7ks4rohPu8kMjN+ZOqjVgkXvIiKqsg=;
 b=XSHt3dxUc+7UzQ94ejndkXQ+VMMPeRoWF8JsBnBfV7iDsInvkJ3ylG0QWxyMezwYD61g8Vf0BlyTX/AOLLRUbFehSCaf5e/+0LR89ioLjwfAWHa56YRoAgAtUuBzoIMrfY1ZBzi0+ZbI4XqU7vvDWDLa2g7GV4Q6ulqHc+Bv4tlCLIcqpR/fxW+sOudamv9ld9v3UJeGpnRb1NsWENQ2D5CBRQG8kubL5YgmTCvX9oAVUsc5ZezxpY40Plywcu6Fg8vgV0/yVLhNQYO8duwDIcm2yrPq9U2ugo956A/icM02kMfOTlqzhabhhntfAsDKenh5NrN6hEEMnLdkmFpb8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bNzEqKCq/k/IK7ks4rohPu8kMjN+ZOqjVgkXvIiKqsg=;
 b=eXlQfGzzyzGsfry4306c74udSzV15UuOO9YpH9NWi/7zUfBy9H4j3Fb7b+2zOU57IbTwEW4mBpeR6LVCmtl4UDIovOTpJx50lNr6BnaaXShZrNxtWmhJjujAZudacFhRldx4FopCq1ehMnTtSADo+QHIaxwRX85vjK2xMek2kwNIj5TgYXusaP035RK6PEte48Ha8ypN8vMaHccvJyRFffbnJJ6+qW8u1LPaZY3VHhQk1Z5akIIJLRqDY6rOkOkB0UNBeoov1SGXsaP23ni89tC1LhUeqMnSE6G2W/WmFb2f15wBqHMU8bV+aqqri+pQSjGDKilMmGkp6lxYuS2oUw==
Received: from DM6PR01CA0005.prod.exchangelabs.com (2603:10b6:5:296::10) by
 SJ2PR12MB7964.namprd12.prod.outlook.com (2603:10b6:a03:4cf::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Sun, 4 Dec 2022 14:16:51 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::ea) by DM6PR01CA0005.outlook.office365.com
 (2603:10b6:5:296::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Sun, 4 Dec 2022 14:16:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.13 via Frontend Transport; Sun, 4 Dec 2022 14:16:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 4 Dec 2022
 06:16:42 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 4 Dec 2022 06:16:40 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next V3 0/8] devlink: Add port function attribute to enable/disable Roce and migratable
Date:   Sun, 4 Dec 2022 16:16:24 +0200
Message-ID: <20221204141632.201932-1-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT025:EE_|SJ2PR12MB7964:EE_
X-MS-Office365-Filtering-Correlation-Id: e06c6860-c8b1-4a5b-ac93-08dad6022ff2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WOnF56PoEBtY+5lkG6l/O38aKW1YmqQyYl+4Udz10LdOMQ1Nie8jnD1hW5EE6wFEmJ6IFI5SLCVQxdPUi1TnMiz3+wlDLubLU8VkxQoLeSsCROcqdGstAxFSALZ1gz7XW2aOmtgHda3uPOAv77lr7+aOU4HXut0bWPjVdNvd1aCzZoel6gLd6T3PskNHagMOzhWJTU/Jhyp5aLDNQd8ZH4yJs8meorNVahA1Qw5Nyfr+HMco7t+rXfU/C2baL9XfxudhqYjpUQlr0p+jgDqljnaDrir3KNdNX0rZJPn1nd/VBFAUh8LIbd101NonNICkzyft3mAXl0QzxbdL/JSgctz4MXYfYQ4ssjJfJAja56LmEyOLKkx7EaJsaOFGIXQr/GceWRtQpIVtoQBGJMCFiCfbiozm6tth8/nmEN+gOE7DdUYE5R1+cx4QO3QvuFVN12NhlXcHw7Ip6H4QEn6x5eBH923VqXOJXHB3asXciPABNmt0vcnYO9pn/dgVJ8iDgKM5ikSxnhLsrw+p9P4kZ6q5r3lyQvOD4ioG9BhdP6nViQEOw1WG+0MrzOqwEJBlUEhxPsM6NpRFshV6CGmdGbCiD3DpS+6kDgYMnPc3T7a9Kc1aMCC8VcisbleufWEsLOKB5pHgKCgkKhgfWqPpC9fU4P8yoiLzBZC6KTG65OcHS3IwJUkTZTEC8D1NN8ESOTb/cNw5dFvIWUVbHqnkzYdxzVboODfmMN/TVHk9m2v8p7q/jhCKBWeXFVcLKk2Sbok7Dn/JVMw8xFOfhdghjd16Gq49zpu53z/iMj9/fWw=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(396003)(376002)(451199015)(36840700001)(40470700004)(46966006)(478600001)(7636003)(36756003)(40460700003)(41300700001)(82740400003)(26005)(40480700001)(82310400005)(6666004)(70206006)(356005)(8676002)(70586007)(8936002)(54906003)(316002)(86362001)(4326008)(426003)(5660300002)(47076005)(110136005)(336012)(16526019)(2616005)(966005)(186003)(1076003)(107886003)(83380400001)(2906002)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2022 14:16:50.7652
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e06c6860-c8b1-4a5b-ac93-08dad6022ff2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7964
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 .../mellanox/mlx5/core/eswitch_offloads.c     | 210 +++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   5 +-
 .../net/ethernet/mellanox/mlx5/core/pci_irq.c |   3 +-
 .../net/ethernet/mellanox/mlx5/core/vport.c   |  30 ++-
 include/linux/mlx5/mlx5_ifc.h                 |   6 +-
 include/linux/mlx5/vport.h                    |   2 +
 include/net/devlink.h                         |  40 ++++
 include/uapi/linux/devlink.h                  |  13 ++
 net/core/devlink.c                            | 198 ++++++++++++++++-
 14 files changed, 685 insertions(+), 48 deletions(-)

-- 
2.38.1

