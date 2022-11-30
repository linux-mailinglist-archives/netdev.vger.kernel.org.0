Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933EB63D502
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 12:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234650AbiK3Lx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 06:53:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233249AbiK3Lw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 06:52:59 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20620.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::620])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE1645096
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 03:52:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DiZaGW4IuvREBrgQDG6N1f72v9ko0eS9yhyNaIl6BlKHG4AseWeRbhlym9T+T85dXt6qOnr74L6ahsfIOtgwB+mmeVjmUSCnawpFoXeEa6a9UfKbFjPZjEyMbGphkH1bVT/i8107Uu3qty/h0piAJPfTRwImcQovy+/HvNrPRdNtT9c6JzZkZ8Msxtwd93r3HqEuwEH+EnGKLwO09gXdNx9tCGj1fVWqDHvAUZTV5J/tYnWdNtE0Rgr6zIeSF8kMKtCkipWOtp75r/GURB1HVicYSDsBiAqHRgjtebH23m7JxXJvnsGTFsCY2IlGTP4RdoMdKPDKe9n6Bm8yIU195Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i7JozeEOKZjJcf9TEr9zFefIWXMA5Fc32vGkoUjSWN4=;
 b=SgrqS6e2xN8oMrAS4Ixf3FXNsMvuiq95GGfn7chIjjToWNdyN2KcCo7fmFsRLX20gi8Y9daXxVNLNwlXxjzwkhIJHBXUkdgDlMIp572QROQ1vBFlW3aHHheA9Xgk40KlEARSzlLUISDLBMJZlQ3tihK0ohSxCy/2aQuqxEY6RaBZpbFwFlCJHhPSFBTjOIxeCAZqPehdjl4nji0r6XnfYqLPA2XofcZ8V+Bh8oZdvNYvfdmjnxCeruzylx3UvTZ5KhjovtQ6kENomyR25gLCSudx0yqkjCJPoSHZNP2C9OpJ3iEOiNPiaEdsmJlVxobH8+dYo/JemirdMsgjP2UPCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i7JozeEOKZjJcf9TEr9zFefIWXMA5Fc32vGkoUjSWN4=;
 b=c8S54EdZyKw3M5GDoflVKNeC3kibZZQdTVJSPyJSISIICuG4XlpyT9Vc7m1YkEcAje4E5QgdqX3bgYGipd8ZzSuuliSC7K8Tnw0LTUM5JsP8Uy9eBpR4crsEs7MUv+DGUug/iGB0LZ6FvYOVejmM1QZaCavx0H1PaSSUNekIuZ1lxSfr6Dn1uJ+oruPu8V/KiOKUmiGgqHeCJaKXfaZytEG5qowkS+EN59omxf/cmYJekP42Nfrcqz3QofnfwziTtmMvONBA2sEunok4LFPql2F3WKAA/vpalTVD4zjEJW1Nxwucr1VrqzetHFz/VCcdxPdH1lrTfD8GJFoc+dB+zQ==
Received: from BN0PR03CA0028.namprd03.prod.outlook.com (2603:10b6:408:e6::33)
 by PH8PR12MB6820.namprd12.prod.outlook.com (2603:10b6:510:1cb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 11:52:45 +0000
Received: from BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::db) by BN0PR03CA0028.outlook.office365.com
 (2603:10b6:408:e6::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Wed, 30 Nov 2022 11:52:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT039.mail.protection.outlook.com (10.13.177.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Wed, 30 Nov 2022 11:52:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 30 Nov
 2022 03:52:31 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 30 Nov 2022 03:52:26 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH net-next 0/8] devlink: Add port function attribute to enable/disable Roce and migratable
Date:   Wed, 30 Nov 2022 13:52:09 +0200
Message-ID: <20221130115217.7171-1-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT039:EE_|PH8PR12MB6820:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c329924-4e6d-4044-76fe-08dad2c9653b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RmAH1q55/CnX0y90aa3qdtYvpgdb09eYA85F6abcaroB8AGnEwS2kKVcqtp2DpQo3GSTA+8oys86qOS8+8XFhFxB8NfVj+U/2JdmunSYrdiaVOELNuJJLZlXlZY5LAV3WT4LFIA0/3Ffo7gzCVsMJuzDeIYBoThF51SMmfhrYW8beznZawB2VE+iAHkYFByaW/UV3AK/QSTfdrqE6NdbG4fbkLZW+vdOjJhz8Ja9Oq6QQc+SDSCLLsYLmeA82YjYOKJHrPBGEr+a9dON+cO/ekRRCgL6KiZsxtKeijAIerk/vgphjWUtgkjAP6lw6J+jxkta5MAnCa6gYY/oeJ57QSveRjS/9DCbMLQVzsvPPV1MA4GElGzEr33D4mLJVYpray2SBWNZBChVtqHr/g4q2JcT+hv6WasEq/mrZQx3MeEb320qJ8lvZVp3Jar1f/u3ssQjhTHiy+qYdtV5iAvQ5JlSIU32v0qhIttfHbok8hj0vcoktlBe50ogNrDRGA/PzvBCuo+fe3HFvyZDetsIuIN0zEozsbif+lSw3wHTWDdGkR1UMzhVtPoTa3xfih6QQcSfwYRUYHxVvp+BvIZKmIKDLhT/F1AaVmRxDabugNc4sI2e1tob73JVZ4qXzP0AtEakKm9j0HObEYkgjv3Sq5uQKshfD3ZRtEGpSlAcS/LKwxJFa3a3ad45eiuKvC7uPQs/AOX1v/8vIbfgWsYtEl+6qZe462f9iRpQqRHFs80Yj4h8WgC6mwgrZifByIFjXA0aRLqXkjNw5vVpUxrcccTTiUFbqjEg+yHdNdd8Lck=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(136003)(396003)(451199015)(40470700004)(46966006)(36840700001)(7636003)(356005)(40480700001)(86362001)(36756003)(316002)(54906003)(40460700003)(110136005)(36860700001)(478600001)(41300700001)(966005)(2906002)(8676002)(70206006)(5660300002)(4326008)(70586007)(8936002)(107886003)(83380400001)(82310400005)(82740400003)(426003)(26005)(6666004)(47076005)(336012)(2616005)(16526019)(1076003)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 11:52:45.2970
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c329924-4e6d-4044-76fe-08dad2c9653b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6820
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
 .../networking/devlink/devlink-port.rst       | 119 +++++++++-
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
 net/core/devlink.c                            | 195 +++++++++++++++-
 14 files changed, 681 insertions(+), 46 deletions(-)

-- 
2.38.1

