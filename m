Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF693F2D74
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 15:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240787AbhHTNyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 09:54:43 -0400
Received: from mail-dm6nam11on2066.outbound.protection.outlook.com ([40.107.223.66]:59105
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232665AbhHTNyj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 09:54:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dqQxOaMkEJAKkZwgta02V91lCAr8qGpppug68juWNcxJIMIlVrIbAUsaScjfbxJUHTxeo27/mEd1Y9hPmVqVHBNsA3FArXHptVS+170GN3RQ7T/wyZsfNXoEaKRqgNOUgI3blsy7uVfdjVO2agDAEnhtbL8JFanYptdYqXB0BAGwJwr1JqM7m64BeKvIYHiGkbn624bYNMxSFaaIK8b8ZWA2pi7cTaGKYA0FXNWpvkxX5oT+rUZDvyY/ttoo9fsENbgBhm+6zE6Iy4VaC5fVHqF0pR2VzXOZ4psrelbiFfOpg0szM+St/j5VZi3OgCa6xOf7oqdincNowre+qplc4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cFnfvjmhybY63KA/0XWVJT2EgZ31RIZDyxvol6uHZ70=;
 b=g6a2cxWKqegizXTHyAJo43THb4I+Z+R20Y005d0wjEhvbuw1ZO9LHQxT9NcOGV0oqNcB+hl3eROufNdKFb0QJ2/1B+nrTtsg9lAHQbYc7MK+E5RMPwlWgYi4r/TklYJkX2m3JPowilCT0pQF4yqmKaOBzQOogRy1UsYRyiTenvH2FnfsGEgyy4mhdnTVW7oiiVSNFkRGwyQhVYXDY38vgIlMnzp3IKTWcP7ocfMb5qhVRmscARldDie/hB12O5b69tIrp7n7MlZ8pYuh8B0G7xSSmewAH3QOCgOM1QZz54ExzS+Q5U1ggF93hqfGcZFK8Q495gkZCnSdYbKtabwTqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cFnfvjmhybY63KA/0XWVJT2EgZ31RIZDyxvol6uHZ70=;
 b=jdNGCkbQRpkB0Y4Vrm64Ep4O56izBDF0JjlZKChn20rRBDcgzG5r/caz2mUS/vyGvBP1D5mVQK1nGquA21vemzlX0NY9/B+dDnq2JJX9LgqJP4BM9HzEIY2C2idknyNtE6wz4LnQLq5BYZGAR+ba0+crfb3M0GIbPt4kGYVXtgz69w8hWCHBuZQxkHZVrRF1so0H4zRPPOu3ePTjBvndsHtI5I+aSJBQ7ven095DZpUqnKqwFnARxvizT/vCUgVzzGprvkNX8VarwR0mxPPNSVjecTnxRVkE3gdUOsdOierb6qj1WmHE3/DI2bS4wIDwu8rcAyQ3nuzDhUJ6dp6nLA==
Received: from DM5PR04CA0025.namprd04.prod.outlook.com (2603:10b6:3:12b::11)
 by MN2PR12MB3280.namprd12.prod.outlook.com (2603:10b6:208:ad::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 13:54:00 +0000
Received: from DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:12b:cafe::41) by DM5PR04CA0025.outlook.office365.com
 (2603:10b6:3:12b::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Fri, 20 Aug 2021 13:54:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT016.mail.protection.outlook.com (10.13.173.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Fri, 20 Aug 2021 13:53:59 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 20 Aug
 2021 13:53:57 +0000
Received: from localhost (172.20.187.6) by DRHQMAIL107.nvidia.com (10.27.9.16)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 20 Aug 2021 13:53:57
 +0000
Date:   Fri, 20 Aug 2021 16:53:53 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Yicong Yang <yangyicong@hisilicon.com>, <saeedm@nvidia.com>
CC:     <dlinkin@nvidia.com>, <roid@nvidia.com>, <netdev@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>
Subject: Re: [Issue] mlx5_core probe failed with error -17 when rescanning
 devices
Message-ID: <YR+z8VlDWqLeLbRl@unreal>
References: <87040cfb-6f16-8a66-5ef7-ca5acc2beb05@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <87040cfb-6f16-8a66-5ef7-ca5acc2beb05@hisilicon.com>
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 022b51a7-d65d-4d65-f282-08d963e1f611
X-MS-TrafficTypeDiagnostic: MN2PR12MB3280:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3280DF37561066BEB29EF136BDC19@MN2PR12MB3280.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: asyspDK850TM7qAxP6nZy/AnD6HbCpy4Om8OmByQ12uDWJXln/hZjfJy0KXyBcGJa8MgrQ1jeIpPfTTScFOrRtxnsMMMXOe8sJWy4yohjfc2aev25uSU6Spy8uck0o99PDYJKQvGb43ttN7FpSK2t2rr7vVrUql5B8DlKNEUUKwH7C/1tqeZ0WwqBSvgXopUzCou/s9Q+PHwgVJ4O3PIPeXSXDA1a2FVNe+Tq2Ne6czRP7dzzZF7cf/5OjaOME5wRMRSDT1KWbI4l+xBeJkZ2rlRYBPnZkL2wozFmQieqhbVPV+PjXua8hPkpWe+TTlzaM8I+jo5hIn5iTlxMmBhOg4cDOCNmdP6juVIp1Qame6fJ5bqdNS2dPZcBNM/GZKsc70rJph0tVXPe61wHVBx/RA4fktEiKcvGyv28JeIDdEoQaEiu9GXc21Cm89VljSi+4BrxX6LRRNC1G7k8lIR5Pn4uc8VDIN32aFeCANqx+yMOukZuDJMdf8KHu8fk8DiPWpehnAprgGG1lYyKXl+rcEJoGjiPxxkHkx7GlFk6/kJ6PWY8DG81mtAoWfCRXVJzdcrVM1MxFd6F56um9k0eZd07rvSwWJ2nkg0qIBMrQj7N5EY/TaOKgM1dJoeDTW8QKAgWQ5pi8F/pP0ICJZnzKP62+8ArHuKQZEJcV8olizZrAYPvl+2hNK6/P+POv3GCBlaVkNYGPApbn5dv+omvwbOrgjU19qRRtvdgwH9T1S5stIVAHADWaJU8tfLCtnA
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(7916004)(4636009)(39860400002)(396003)(136003)(346002)(376002)(46966006)(36840700001)(426003)(6666004)(33716001)(336012)(36860700001)(5660300002)(70586007)(70206006)(6636002)(2906002)(8936002)(316002)(186003)(82740400003)(16526019)(7636003)(86362001)(26005)(478600001)(356005)(82310400003)(47076005)(4326008)(9686003)(110136005)(83380400001)(8676002)(54906003)(67856001)(505234006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 13:53:59.4699
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 022b51a7-d65d-4d65-f282-08d963e1f611
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3280
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 08:46:32PM +0800, Yicong Yang wrote:
> Hi,
> 
> I met an issue of mlx5_core on v5.14-rc6. After performing hot reset of root port
> where mellanox connectX-4 locates, I remove the root port and rescan the pci bus,
> but the driver cannot probe the device. The hirarchy of the devices:
> 
> # lspci -tv
> [...]
>  +-[0000:80]-+-00.0-[81]--+-00.0  Intel Corporation I350 Gigabit Network Connection
>  |           |            +-00.1  Intel Corporation I350 Gigabit Network Connection
>  |           |            +-00.2  Intel Corporation I350 Gigabit Network Connection
>  |           |            \-00.3  Intel Corporation I350 Gigabit Network Connection
>  |           +-04.0-[82]--+-00.0  Mellanox Technologies MT27710 Family [ConnectX-4 Lx]
>  |           |            \-00.1  Mellanox Technologies MT27710 Family [ConnectX-4 Lx]
> [...]
> # lspci -vx -s 82:00.0
> 82:00.0 Ethernet controller: Mellanox Technologies MT27710 Family [ConnectX-4 Lx]
> 	Subsystem: Mellanox Technologies MT27710 Family [ConnectX-4 Lx]
> 	Flags: fast devsel, IRQ 42, NUMA node 2, IOMMU group 13
> 	Memory at 280000000000 (64-bit, prefetchable) [size=32M]
> 	Expansion ROM at f0700000 [disabled] [size=1M]
> 	Capabilities: [60] Express Endpoint, MSI 00
> 	Capabilities: [48] Vital Product Data
> 	Capabilities: [9c] MSI-X: Enable- Count=64 Masked-
> 	Capabilities: [c0] Vendor Specific Information: Len=18 <?>
> 	Capabilities: [40] Power Management version 3
> 	Capabilities: [100] Advanced Error Reporting
> 	Capabilities: [150] Alternative Routing-ID Interpretation (ARI)
> 	Capabilities: [180] Single Root I/O Virtualization (SR-IOV)
> 	Capabilities: [1c0] Secondary PCI Express
> 	Capabilities: [230] Access Control Services
> 00: b3 15 15 10 42 01 10 00 00 00 00 02 08 00 80 00
> 10: 0c 00 00 00 00 28 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 b3 15 9c 00
> 30: 00 00 10 f0 60 00 00 00 00 00 00 00 ff 01 00 00
> 
> Here is the error log:
> 
> [...]
> [13904.335445] mlx5_core 0000:82:00.1: Adding to iommu group 29
> [13904.341460] mlx5_core 0000:82:00.1: firmware version: 14.22.1002
> [13904.347479] mlx5_core 0000:82:00.1: 63.008 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x8 link)
> [13904.880505] mlx5_core 0000:82:00.1: E-Switch: Total vports 6, per vport: max uc(1024) max mc(16384)
> [13904.893763] mlx5_core 0000:82:00.1: Port module event: module 1, Cable plugged
> [13904.917246] sysfs: cannot create duplicate filename '/bus/auxiliary/devices/mlx5_core.eth.2'
> [13904.925656] CPU: 64 PID: 957 Comm: kworker/64:2 Tainted: G        W         5.13.0-rc3-bisect+ #37
> [13904.934573] Hardware name: Huawei TaiShan 200 (Model 2280)/BC82AMDD, BIOS 2280-V2 CS V5.B170.01 06/30/2021
> [13904.944181] Workqueue: events work_for_cpu_fn
> [13904.948522] Call trace:
> [13904.950949]  dump_backtrace+0x0/0x19c
> [13904.954598]  show_stack+0x24/0x30
> [13904.957899]  dump_stack+0xc8/0x104
> [13904.961287]  sysfs_warn_dup+0x70/0x90
> [13904.964936]  sysfs_do_create_link_sd+0xf8/0x100
> [13904.969448]  sysfs_create_link+0x2c/0x50
> [13904.973355]  bus_add_device+0x74/0x120
> [13904.977088]  device_add+0x2f4/0x840
> [13904.980562]  __auxiliary_device_add+0x4c/0xb0
> [13904.984901]  add_adev+0x9c/0xf0
> [13904.988030]  mlx5_rescan_drivers_locked.part.0+0x154/0x1c0
> [13904.993491]  mlx5_register_device+0x80/0xe0
> [13904.997656]  mlx5_init_one+0x224/0x4dc
> [13905.001389]  probe_one+0x1dc/0x4cc
> [13905.004776]  local_pci_probe+0x4c/0xc0
> [13905.008500]  work_for_cpu_fn+0x28/0x40
> [13905.012232]  process_one_work+0x1dc/0x48c
> [13905.016223]  worker_thread+0x2e8/0x464
> [13905.019955]  kthread+0x168/0x16c
> [13905.023171]  ret_from_fork+0x10/0x18
> [13905.026764] auxiliary mlx5_core.eth.2: adding auxiliary device failed!: -17
> [13905.033698] mlx5_core 0000:82:00.1: add_drivers:424:(pid 957): Device[0] (eth) failed to load
> [13907.274212] mlx5_core 0000:82:00.1: E-Switch: cleanup
> [13907.896435] mlx5_core 0000:82:00.1: probe_one:1484:(pid 957): mlx5_init_one failed with error code -17
> [13907.905855] mlx5_core: probe of 0000:82:00.1 failed with error -17
> 
> The test script I used:
> 
> #!/bin/bash
> setpci -s 80:04.0 0x3e.b=0x43 # perform hot reset by setting secondary bus reset bit
> setpci -s 80:04.0 0x3e.b=0x3 # clear secondary bus reset bit
> echo 1 > /sys/bus/pci/devices/0000:80:04.0/remove
> echo 1 > /sys/bus/pci/rescan
> 
> There is no such issue on v5.13-rc4. So I did a git bisect and here is log:
> 
> [...]
> # good: [c7d2ef5dd4b03ed0ee1d13bc0c55f9cf62d49bd6] net/packet: annotate accesses to po->bind
> git bisect good c7d2ef5dd4b03ed0ee1d13bc0c55f9cf62d49bd6
> # bad: [bc39f6792ede3a830b1893c9133636b9f6991e59] Merge tag 'mlx5-fixes-2021-06-16' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
> git bisect bad bc39f6792ede3a830b1893c9133636b9f6991e59
> # good: [94a4b8414d3e91104873007b659252f855ee344a] net/mlx5: Fix error path for set HCA defaults
> git bisect good 94a4b8414d3e91104873007b659252f855ee344a
> # good: [65fb7d109abe3a1a9f1c2d3ba7e1249bc978d5f0] net/mlx5: DR, Fix STEv1 incorrect L3 decapsulation padding
> git bisect good 65fb7d109abe3a1a9f1c2d3ba7e1249bc978d5f0
> # bad: [0232fc2ddcf4ffe01069fd1aa07922652120f44a] net/mlx5: Reset mkey index on creation
> git bisect bad 0232fc2ddcf4ffe01069fd1aa07922652120f44a
> # bad: [a5ae8fc9058e37437c8c1f82b3d412b4abd1b9e6] net/mlx5e: Don't create devices during unload flow
> git bisect bad a5ae8fc9058e37437c8c1f82b3d412b4abd1b9e6
> # first bad commit: [a5ae8fc9058e37437c8c1f82b3d412b4abd1b9e6] net/mlx5e: Don't create devices during unload flow
> 
> So after reverting a5ae8fc9058e ("net/mlx5e: Don't create devices during unload flow") the issue
> is resolved. Seems the devlink file is not removed properly and the unremoved file fails the
> probe process. I don't know about the driver so I hope somebody can get this fixed.

Thank you for your report,

Your command "echo 1 > /sys/bus/pci/devices/0000:80:04.0/remove" was
supposed to remove all auxiliary devices, but because of commit
a5ae8fc9058e ("net/mlx5e: Don't create devices during unload flow"),
the deletion was skipped.

Can you please try this patch instead of revert?

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index ff6b03dc7e32..e8093c4e09d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -450,7 +450,7 @@ int mlx5_register_device(struct mlx5_core_dev *dev)
 void mlx5_unregister_device(struct mlx5_core_dev *dev)
 {
        mutex_lock(&mlx5_intf_mutex);
-       dev->priv.flags |= MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
+       dev->priv.flags = MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
        mlx5_rescan_drivers_locked(dev);
        mutex_unlock(&mlx5_intf_mutex);
 }


> 
> Thanks,
> Yicong
> 
> 
