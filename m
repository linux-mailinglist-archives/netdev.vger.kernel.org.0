Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F6B3E5B5A
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241370AbhHJNZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:25:07 -0400
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:42080
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241334AbhHJNZE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:25:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HdK2dBFG9L54MEQAqNjCwV6MYQUTxgjbCCRHlUIpo/MqAx2zDaK9oKd6BNpzQx3KDHkfJyFjZsJI+kyCn+GUq6hMjM40UghZJAhVct+GGzsza+UE3PbZgdm/+Itcuz2IzkypZt+wVcrDuw4OJh/XlO7rTZvr/8RyoOmih9HAs2EIOfoa1dfzxsIdXed+hbAzXDhq9ZdG2JNkLkEN6qHjYyq2zkeliBN1AxEMaGlrE7fu5t3WFRKHFsLeSaScKKv+0L27SwNrhlqygvRP8VchjLW3H9ukz85nTapq14i86ifGGNvI7tT/nEQAA2UIp6nsURYuhr4sqnr3KrWvqW5Vsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XIZz0T7KW/x9ZpJKkdADEz/jphyki1j0IWRbQqPrBQA=;
 b=NU8vfxiggZ29MLm8wWk0j3vsg/7XVdtBhwQF338PGbRTGvHuvpcU+1J6aH4A0pwHmNHUVZt1Z+ewk+1spSWPeBPJ5Zc4t7BKVgn93AV/HqV/stmPOvZhmAr90eFEwMFpD+FZJ8MMhTAcvhkssU+0GT9N1GQRKpleZRTGDJJ8/PwjRisELEIt0KXrhRbxKInC5GZgez9PPtZ1kmYx/Hb80A9z8B+EZhAcSz3lNuZwHLyUvLRCq/+FGQlBaqP8UmCXIkkombqGWcs0TMCRnwTYu+y0j2e2sIgP7LF5fYwYyUJzOQARII/d2yXm3867xcSBrZesMIR+m4T5mYdb+Ri9TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XIZz0T7KW/x9ZpJKkdADEz/jphyki1j0IWRbQqPrBQA=;
 b=phi+ExbBda7JleGEU12VRQVdMBfbHqaKqUiycGJaXhjzjrkDVktkGl2IJAyxk7B8JifXH1E57JZfhi7U2JgUDISEaHcspUXSHn0bTx1Zyr23IPnVlLEzYeZLk15PHOY2MEkkgEKK4Kx0D4kuvuXKgKfO0z6PgwcqWFZLawiV3Qz2e23qO7dVv8ff+YoqWzzT1pERwpSe3P9spKlgNEs8xQE1ohUmlwAx+SIv7EeZmETRf25u7Cm43IokcRZSiQv7Ee6vabL9F6Nm0rNJFPOuBNE6VRyeHp+/XbS4yGxYpcrNQ0SIDIN7zFtjYoWKKaA3flWAgSCW4t0G5BXXrVNMeQ==
Received: from CO2PR05CA0088.namprd05.prod.outlook.com (2603:10b6:104:1::14)
 by CY4PR12MB1494.namprd12.prod.outlook.com (2603:10b6:910:f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Tue, 10 Aug
 2021 13:24:38 +0000
Received: from CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:1:cafe::5d) by CO2PR05CA0088.outlook.office365.com
 (2603:10b6:104:1::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.4 via Frontend
 Transport; Tue, 10 Aug 2021 13:24:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT067.mail.protection.outlook.com (10.13.174.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Tue, 10 Aug 2021 13:24:38 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Aug
 2021 13:24:37 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-rdma@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        Parav Pandit <parav@nvidia.com>
Subject: [PATCH RESEND net-next 00/10] devlink: Control auxiliary devices
Date:   Tue, 10 Aug 2021 16:24:14 +0300
Message-ID: <20210810132424.9129-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69523da0-d9fa-4e7e-d197-08d95c023422
X-MS-TrafficTypeDiagnostic: CY4PR12MB1494:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1494C98E85E0F49A28834A3EDCF79@CY4PR12MB1494.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WQBEUZdo9aHnYfM5l8crs/O6BVS+QoS2dthrQ4UTyKLUkIATnYUZFsMjb9CYMaGAoNu9x/z1gJUvg0sizpLl/qTHMLmGHYqYcEoBM0ubG+geTEElQLqSuo3rWxsSzRQqZUe+/w5VW1ovtKnZn21cVqlcYhsvHg4xmx/Vdw5wx+GQvHK+AgGu3Z8/ewTFBYc09Lta8wZGzuDMMtzLRneAshtbqoC+6IHlHcgqeP6aVXoGQ0pFFtuxhPBtP+ZY1gGBpeTKXrHTNM6/j/SA1ia9PMZ+HoBTiZbhmGSDplPJzpKzNk5giCKpPlFHxaZRpdFvdR1cizQFmxhJ1RA3Nm1UxV5xXITz2TIK0IVd8ezcX1m/xMXRYMEg4OgE0F8WEMw21mBfEiFD2FKv6pjqavTkJ1UJxh/QZ67v4aVLz/YfyNlKDXaneDoEtJHDUOdRf5BBb7o3DYjAuCjgA9tpTmF4r6CZfc4QradY8vgflIL34cH7Jiak4asQXCkQea1ucvMv7xV9bgQOa+hYf+plaF+IjuekWB44FQ0Llte6N3HP4h0Ww3GXq6JXUSole0T0xQXF0xWgCDqC4rWKLSt+GvSkQfJecduj3mJVdeKXacgQyJk393cNJuCmBOJijhpsfBzOgpLVMQ7QCEw0Q8tDhl9IfWl3sL/KhKik0L46LvPt4xwPG7m8+K6TMj5kko+93Mw087ziRtMrpUTOgrISQ1f1fvubAfX4LbjutDDr1Kc6mjR/ILgMT8DSyz6bMWA4ddyBAAXEhcD0OhJRCNx1VZD9J2U0ETCvINQ5O8Cjo9pRQ9E=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(396003)(39860400002)(46966006)(36840700001)(54906003)(316002)(36906005)(110136005)(4326008)(6666004)(82740400003)(426003)(1076003)(966005)(82310400003)(47076005)(478600001)(7636003)(336012)(5660300002)(2906002)(36756003)(2616005)(8936002)(26005)(36860700001)(83380400001)(356005)(186003)(70206006)(70586007)(8676002)(86362001)(107886003)(16526019);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 13:24:38.3013
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 69523da0-d9fa-4e7e-d197-08d95c023422
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1494
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Resend to CC RDMA and vdpa mailing lists).

Hi Dave, Jakub,

Currently, for mlx5 multi-function device, a user is not able to control
which functionality to enable/disable. For example, each PCI
PF, VF, SF function by default has netdevice, RDMA and vdpa-net
devices always enabled.

Hence, enable user to control which device functionality to enable/disable.

This is achieved by using existing devlink params [1] to
enable/disable eth, rdma and vdpa net functionality control knob.

For example user interested in only vdpa device function: performs,

$ devlink dev param set pci/0000:06:00.0 name enable_rdma value false \
                   cmode driverinit
$ devlink dev param set pci/0000:06:00.0 name enable_eth value false \
                   cmode driverinit
$ devlink dev param set pci/0000:06:00.0 name enable_vnet value true \
                   cmode driverinit

$ devlink dev reload pci/0000:06:00.0

Reload command honors parameters set, initializes the device that user
has composed using devlink dev params and resources.
Devices before reload:

            mlx5_core.sf.4
         (subfunction device)
                  /\
                 /| \
                / |  \
               /  |   \
 mlx5_core.eth.4  |  mlx5_core.rdma.4
(SF eth aux dev)  |  (SF rdma aux dev)
    |             |        |
    |             |        |
 enp6s0f0s88      |      mlx5_0
 (SF netdev)      |  (SF rdma device)
                  |
         mlx5_core.vnet.4
         (SF vnet aux dev)
                 |
                 |
        auxiliary/mlx5_core.sf.4
        (vdpa net mgmt device)

Above example reconfigures the device with only VDPA functionality.
Devices after reload:

            mlx5_core.sf.4
         (subfunction device)
                  /\
                 /  \
                /    \
               /      \
 mlx5_core.vnet.4     no eth, no rdma aux devices
 (SF vnet aux dev) 

Above parameters enable user to compose the device as needed based
on the use case.

Since devlink params are done on the devlink instance, these
knobs are uniformly usable for PCI PF, VF and SF devices.

Patch summary:
patch-1 adds generic enable_eth devlink parameter to control Ethernet
        auxiliary device function
patch-2 adds generic enable_rdma devlink parameter to control RDMA
        auxiliary device function
patch-3 adds generic enable_vnet devlink parameter to control VDPA net
        auxilariy device function
patch-4 rework the code to register single device parameter
patch-5 added APIs to register, unregister single device parameter
patch-6 added APIs to publish, unpublishe single device parameter
patch-7 Fixed missing parameter unpublish call in mlx5 driver
patch-8 extends mlx5 driver to support enable_eth devlink parameter
patch-9 extends mlx5 driver to support enable_rdma devlink parameter
patch-10 extends mlx5 driver to support enable_vnet devlink parameter

Subsequent to this series, in future mlx5 driver will be updated to use
single device parameter API for metadata enable/disable knob which is
only applicable on the eswitch manager device.

[1] https://www.kernel.org/doc/html/latest/networking/devlink/devlink-params.html

Parav Pandit (10):
  devlink: Add new "enable_eth" generic device param
  devlink: Add new "enable_rdma" generic device param
  devlink: Add new "enable_vnet" generic device param
  devlink: Create a helper function for one parameter registration
  devlink: Add API to register and unregister single parameter
  devlink: Add APIs to publish, unpublish individual parameter
  net/mlx5: Fix unpublish devlink parameters
  net/mlx5: Support enable_eth devlink dev param
  net/mlx5: Support enable_rdma devlink dev param
  net/mlx5: Support enable_vnet devlink dev param

 .../networking/devlink/devlink-params.rst     |  12 ++
 drivers/net/ethernet/mellanox/mlx5/core/dev.c |  74 +++++++-
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 159 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   5 +
 include/net/devlink.h                         |  20 +++
 net/core/devlink.c                            | 124 +++++++++++++-
 6 files changed, 382 insertions(+), 12 deletions(-)

-- 
2.26.2

