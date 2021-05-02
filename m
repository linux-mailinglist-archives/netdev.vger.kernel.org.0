Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5DF5370A71
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 08:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhEBGWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 02:22:41 -0400
Received: from mail-bn7nam10on2048.outbound.protection.outlook.com ([40.107.92.48]:60384
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229526AbhEBGWl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 May 2021 02:22:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJISep+XOqgXbNw99UGo0tb8D/OOdGi003wnNm+qc3X6NPVur5I17s2E8eKOufnbtTq5+uCpfOF/mAWZmtnREDSFMNGecQon2xhvzne95eyGTZkT0T+KK7UHAJ+JnmTZIGf/+9ZGm/9bV74ez9t4R5kuvC5G7bYB4eYRHaeeUqrNrD0dlHQ8nPdfucEXwRBYh18QWcusI4yifZnlUT0og/3SFeMeWHz1CCOLAdN7Max3Q7tG32jigpYTOTeCy1lT9tkCn1hZwzst+flSefJqypkLCZfoxp56ITAN0ZTpyub8Ra3sJBZcD6xAe3Lpf8/0BzY6lvPzG8PaYuDnGOZoEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IQyNnH5nax2wgQ0ruvEYAARHkqRjS9QnJAHHEAIpbGU=;
 b=GwMOe5oxstqjxms2zL8lPAAEkHWwOhaY8xevkMD2rHFiXKmcXXq26umfpYo6l7RsWoLW785rnBw8OI02sA0cZNAfAamc2Z4wA/Uy1MaGxHM9wlHu52rnWs2lcWs4wfAmIFViCFCrzRqzF8Hxc2OLJZ4zQjRu1F52x7nhlpxg4WXTGuXjxwaBRsBwYeBT7HL7ThatFOutnxF+xz7BldpzJ0zGGv7KCHwBQlQjDmdGcfeH5+Nk8CjdiRZHSBFkuZui42en4Nn184HRgDXUSn76gvBbz067twBCxy0XQLy5C6Li1UOGNP83y7FcFyzWKcP9WLRjzBzmDnpsIKvvC1wS2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IQyNnH5nax2wgQ0ruvEYAARHkqRjS9QnJAHHEAIpbGU=;
 b=dAafyhz5vBLx7aGGrF41tMRVncx+RakzpgD5gvxMe8nrC00nzBP3+OFKbJ5mPu39JDofgsIaIgCzC8gjNzu/SLApRzjvG1JDy08QYNvz0XHej5mwpNC8n+uDr7/08+zdByUjFjWalbHuy/e6nO2fu5Q2vcnWmxAix697h3rsQQzyl/l3geNGDKk4AB22pOoe5GuM9s27Iwd17Kw8lFIC8J4whqHhzC/Mu715GUtkUcb6sx9y1UQN4hgY+YxhgNyVvNcVQHh9sR1Vi9yHicqfMvCZ2e6GqR2lXnkC64dy8fCqx8mMrOHEnmrYLXgM+aYZQVpfHzh++rCKDn2PTg7tHg==
Received: from MWHPR14CA0031.namprd14.prod.outlook.com (2603:10b6:300:12b::17)
 by DM6PR12MB2794.namprd12.prod.outlook.com (2603:10b6:5:48::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25; Sun, 2 May
 2021 06:21:48 +0000
Received: from CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:12b:cafe::73) by MWHPR14CA0031.outlook.office365.com
 (2603:10b6:300:12b::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend
 Transport; Sun, 2 May 2021 06:21:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT003.mail.protection.outlook.com (10.13.175.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4087.27 via Frontend Transport; Sun, 2 May 2021 06:21:47 +0000
Received: from localhost (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 2 May
 2021 06:21:46 +0000
Date:   Sun, 2 May 2021 09:21:42 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Dennis Afanasev <dennis.afanasev@stateless.net>,
        Vlad Buslov <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>, Roi Dayan <roid@nvidia.com>
CC:     <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>
Subject: Re: PROBLEM: mlx5_core driver crashes when a VRF device with a route
 is added with mlx5 devices in switchdev mode
Message-ID: <YI5E9mgNDzPMXTRh@unreal>
References: <CACJMemXjp6F0KzzAfR8yR4s5BU8zJBpsXmF0LWu3ubmF8Kke3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACJMemXjp6F0KzzAfR8yR4s5BU8zJBpsXmF0LWu3ubmF8Kke3Q@mail.gmail.com>
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f091e4f1-4754-4cc0-2c74-08d90d3290f0
X-MS-TrafficTypeDiagnostic: DM6PR12MB2794:
X-Microsoft-Antispam-PRVS: <DM6PR12MB279492E59F94DB184324D4B2BD5C9@DM6PR12MB2794.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X2fb3AP8nyjXJoB+2qmORhuT92nWBERiBWffk60Ww8Uz49lnkTWAkwYcDgUUBGXy51s7gZmqfyG+DxyBkfOhAAVQzztlKhk5oEVeEZsZB4KX8vXGAYKoDtqRjvAofLc9vgcTEDbqB2gatfdF8awsLFetPJa9YtBXAA4FPQHxbHVwGAum/K4g5U4Wpj3QxhYHQH9UqgAMLMdSFZVgHqeoKGotXBm7rxhlGrQWXUmojx9b+5AkXuEq8PsxgWD7ysnRdG6z+nCn1lC8tuNS3VglrOkUBwCCGZ7zcsLAoe/zVhQ/3jpZf4KfdfdBPuxqjkzjkONqZwW9I8El4st4rcI0jHuOePA7Ys2X7jf6kOK5A+V0jRXb6S10Fu6OYv0h3Dn5+kzU8TMS0FT3iUoJXkbZi54YrF/SB5CNssTQ0w7d9tWY2Eg3DOlivMLVwC4nnT+Jm/rWUqUDvyC8mTRQGYid23T8u7Y6Mn861BD8hfeiULUl2owW8PsU5ToED90WFmzaL97Ipz7mlEasqhQ9UgGKvfTyhSN0Xh3/yb1IUO5Uow/j1Seb6Stosz7glaJFKyonGLswQ6wIWzPYlfUxt/JwYuF+Ml6gHdKNfkqllDwWIsll8vzi9hv0HSO2alsEE84z6ueDiy/wZP1yUprJ4OBpiIB6FqFl1qRZlXtlqcIwgDw=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(7916004)(136003)(346002)(39860400002)(396003)(376002)(36840700001)(46966006)(426003)(82310400003)(7636003)(9686003)(6666004)(8936002)(33716001)(4326008)(36860700001)(86362001)(47076005)(26005)(336012)(16526019)(356005)(54906003)(83380400001)(36906005)(316002)(2906002)(82740400003)(6636002)(186003)(5660300002)(110136005)(478600001)(70206006)(70586007)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2021 06:21:47.9681
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f091e4f1-4754-4cc0-2c74-08d90d3290f0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2794
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the report.

+ more people.

On Fri, Apr 30, 2021 at 04:56:17PM -0400, Dennis Afanasev wrote:
> Dear Saeed and Leo,
> I am reporting a bug in the mlx5_core driver discovered by our team at
> Stateless while setting up SRIOV devices in eswitch mode. Below are the
> details and relevant files that relate to the bug. Please reach out to me
> if I can provide any further information.
> 
>    1.
> 
>    Description of problem: When creating SRIOV devices off physical mlx5
>    PCIe devices and then putting the physical devices into switchdev mode,
>    adding a new VRF device with a default route will cause the mlx5_core
>    driver to segfault (replicate_bug1.sh). In addition, attempting to set the
>    physical devices to switchdev mode after adding a VRF with a default route
>    will cause the mlx5_core driver to segfault (replicate_bug2.sh). The seg
>    fault occurs in the function mlx5e_tc_tun_fib_event in both cases.
>    2.
> 
>    Keywords: mlx5, ml5x_core, mlx5e_tc_tun_fib_event, tc, netdev, 5.12-rc7
>    3.
> 
>    Kernel information: Linux version 5.12.0-rc7 (root@data) (gcc (Debian
>    10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2) #1 SMP
>    4.
> 
>    Kernel config file: File attached - config-5.12.0-rc7
>    5.
> 
>    Oops message: Files attached - dmesg_output_bug1 and dmesg_output_bug2
>    6.
> 
>    Shell script to replicate: Files attached - replicate_bug1.sh and
>    replicate_bug2.sh
>    7.
> 
>    ver_linux output: File attached - ver_linux_output
>    8.
> 
>    Processor information: File attached - cpuinfo
>    9.
> 
>    Module information: File attached - modules
>    10.
> 
>    Loaded driver and hardware: Files attached - ioport and iomem
>    11.
> 
>    PCI information: File attached - pci_info
>    12.
> 
>    Other information - I hardcoded the values of the physical PCIe device
>    and the address of the created SRIOV device. This will have to be adjusted
>    depending on your machine.




> #!/bin/bash
> 
> set -euxETo pipefail
> 
> mst start
> 
> # (Hardcoded) These need to be modified based on the host machine
> nic1_port0="0000:5e:00.0"
> nic1_port1="0000:5e:00.1"
> 
> # Create 1 SRIOV device per NIC port
> echo 1 > /sys/bus/pci/drivers/mlx5_core/$nic1_port0/sriov_numvfs
> echo 1 > /sys/bus/pci/drivers/mlx5_core/$nic1_port1/sriov_numvfs
> 
> # The SRIOV devices are given these addresses
> nic1_port0_vf="0000:5e:00.2"
> nic1_port1_vf="0000:5e:00.4"
> 
> declare -ar PCIE_PHYSICAL_ADDRESSES=($nic1_port0 $nic1_port1)
> declare -ar PCIE_SRIOV_ADDRESSES=($nic1_port0_vf $nic1_port1_vf)
> 
> # Unbind the driver from the SRIOV, required to activate the eswitch
> for pcie_address in "${PCIE_SRIOV_ADDRESSES[@]}"; do
>   echo "${pcie_address}" > /sys/bus/pci/drivers/mlx5_core/unbind
> done
> 
> # Wait for the binds to disappear
> for pcie_address in "${PCIE_SRIOV_ADDRESSES[@]}"; do
>   declare sys_symlink_file="/sys/bus/pci/drivers/mlx5_core/${pcie_address}"
>   until [[ ! -h "${sys_symlink_file}" ]]; do
>     inotifywait --event delete_self --timeout 1 "${sys_symlink_file}" || true
>   done
> done
> sync --file-system /sys
> udevadm settle --timeout=30
> sleep 5
> 
> # Set the cards to 'switchdev'
> for pcie_address in "${PCIE_PHYSICAL_ADDRESSES[@]}"; do
>   devlink dev eswitch set "pci/${pcie_address}" mode switchdev encap-mode basic
> done
> 
> # Wait for the cards to be in switchdev mode
> for pcie_address in "${PCIE_PHYSICAL_ADDRESSES[@]}"; do
>   until [[ "$(devlink -j dev eswitch show "pci/${pcie_address}" |
>     jq --arg dev "pci/${pcie_address}" -r '.dev[$dev].mode' 2> /dev/null)" == "switchdev" ]]; do
>     sleep 1
>   done
> done
> sync --file-system /sys
> udevadm settle --timeout=30
> sleep 5
> 
> for pcie_address in "${PCIE_SRIOV_ADDRESSES[@]}"; do
>   echo "${pcie_address}" > /sys/bus/pci/drivers/mlx5_core/bind
> done
> 
> ip link set group default up
> ip link add vrf0 type vrf table 100
> 
> # This will crash the kernel
> ip route add table 100 unreachable default

> #!/bin/bash
> 
> set -euxETo pipefail
> 
> mst start
> 
> # Add the VRF device and a route
> ip link add vrf0 type vrf table 100
> ip route add table 100 unreachable default
> 
> # (Hardcoded) These need to be modified based on the host machine
> nic1_port0="0000:5e:00.0"
> nic1_port1="0000:5e:00.1"
> 
> # Create 1 SRIOV device per NIC port
> echo 1 > /sys/bus/pci/drivers/mlx5_core/$nic1_port0/sriov_numvfs
> echo 1 > /sys/bus/pci/drivers/mlx5_core/$nic1_port1/sriov_numvfs
> 
> # The SRIOV devices are given these addresses
> nic1_port0_vf="0000:5e:00.2"
> nic1_port1_vf="0000:5e:00.4"
> 
> declare -ar PCIE_PHYSICAL_ADDRESSES=($nic1_port0 $nic1_port1)
> declare -ar PCIE_SRIOV_ADDRESSES=($nic1_port0_vf $nic1_port1_vf)
> 
> # Unbind the driver from the SRIOV, required to activate the eswitch
> for pcie_address in "${PCIE_SRIOV_ADDRESSES[@]}"; do
>   echo "${pcie_address}" > /sys/bus/pci/drivers/mlx5_core/unbind
> done
> 
> # Wait for the binds to disappear
> for pcie_address in "${PCIE_SRIOV_ADDRESSES[@]}"; do
>   declare sys_symlink_file="/sys/bus/pci/drivers/mlx5_core/${pcie_address}"
>   until [[ ! -h "${sys_symlink_file}" ]]; do
>     inotifywait --event delete_self --timeout 1 "${sys_symlink_file}" || true
>   done
> done
> sync --file-system /sys
> udevadm settle --timeout=30
> 
> # set the cards to 'switchdev'
> for pcie_address in "${PCIE_PHYSICAL_ADDRESSES[@]}"; do
>   # This will crash the kernel
>   devlink dev eswitch set "pci/${pcie_address}" mode switchdev encap-mode basic
> done







