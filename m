Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B66242780E
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 10:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbhJIISa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 04:18:30 -0400
Received: from mail-co1nam11on2073.outbound.protection.outlook.com ([40.107.220.73]:36544
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229618AbhJIIS1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 04:18:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axIM4Q+1cbdbdUNhEXrFIB3xpHKXcksn6xXTf+rwkeS7Hhlj/DfpJJmlOAkATwmVW52xP8fA6tUiIcGj8L+sxPp/UUo59M5znKCxXR2H8yoiN8RbJru1FUyaOkfn70Qdr6EgiGbFANdR9XWyZy1m/thReipucwjqjpSPpPX9LmKa5IkUGU1+3TVUVCBZXB3VuIZlDOLQC6AA0swSdGaXjMfd0/BI+X328KYPQBbDMTODIxhC8ZncjXaQ17zvd9Nhp+feQpHFmkOgFkhk5ghHQAJdEnMw3ffI/fCfFYky+fGbhc9sHo58+v4Z7eSbBvAfPI4YUvRWwP8lKrKdL9Jbow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NvYMzoby6ncxVwcUUqS+N/rtFd1uWuUFn9wTaAq6hu4=;
 b=Rzo4YywPYbM9Xq9TtWd2B/ajNRzm38oqvxqTz8gLL+wPXjxWTpOBUZW+0P8xJW1zQW0acu4glD8JrQ8oBJWAE/HWURjnMO/I1p+RxzPGrz657JktSWKqjLOSmyznUxtKdq8HSwZcVbv3dFrEygHvNIj0mBG9JEAdmi167MgWiN4DncrfyiEx3BSo8VR/VJEwIsnQQM19iR7zJoj/depv+c+HdKtTZ2VLU7gTGgzupaB07UUjXaDlHYRzlqkGV149a5qsxkB5edI/kvW5aZISmuFJwylXM1tRgW5VutplVnGesRNKok8dST6ScLeEu+Xz2AYjTcvas1SZqhcx6uh+BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NvYMzoby6ncxVwcUUqS+N/rtFd1uWuUFn9wTaAq6hu4=;
 b=hOBt+AwtGbe0p2tss8uTJpF92O+eQuGD2zqzl9zSPfmEKWzE8LJ2zHyd81+GV5I0h0bvWhxpDm8ePJ8Etjgx/jk9cmicVF7IKOpvczGHubtfBLSK4xNTy+s7p0cMjhiW+QuPgiegm7DbRuF9erG/EYVOjOgow8JN1rEdmBealbs2zFV54nZLGQH+ajIZ5A/MiRG2C0VDjCvkgYWVIZk0BPCtcLQ1DvhcmO+rgtGfNHPnKDepEQpavJVtIoIJR4dJuX9fGfy0LcePfmjOoeLBO4BJ+R/r/T71Rl7CP3WNGBRt/vAQjbEH8iE6wjCcsQueJZwXq8K5cy312FM41lp2Qw==
Received: from DM6PR02CA0092.namprd02.prod.outlook.com (2603:10b6:5:1f4::33)
 by CY4PR12MB1416.namprd12.prod.outlook.com (2603:10b6:903:44::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24; Sat, 9 Oct
 2021 08:16:28 +0000
Received: from DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::d5) by DM6PR02CA0092.outlook.office365.com
 (2603:10b6:5:1f4::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend
 Transport; Sat, 9 Oct 2021 08:16:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT050.mail.protection.outlook.com (10.13.173.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Sat, 9 Oct 2021 08:16:28 +0000
Received: from localhost (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sat, 9 Oct
 2021 08:16:26 +0000
Date:   Sat, 9 Oct 2021 11:16:22 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Ingo Molnar <mingo@redhat.com>,
        "Jiri Pirko" <jiri@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <mlxsw@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shay Drory <shayd@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next v3 0/5] devlink reload simplification
Message-ID: <YWFP1imsLsAP4Zwq@unreal>
References: <cover.1633589385.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1633589385.git.leonro@nvidia.com>
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32b0ccd7-7e02-4e4b-588f-08d98afd17f3
X-MS-TrafficTypeDiagnostic: CY4PR12MB1416:
X-Microsoft-Antispam-PRVS: <CY4PR12MB141627FB104C77FAFA29C004BDB39@CY4PR12MB1416.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UDYIUdCJsGvRdwNlVNZZEjY1CPoYeZG8q1DFBTW+yACu6CVUKOwQ9Vfv0r346r9d04rJKOgUWnFRAYuRlBoeuFyBAuLAef/BtJH1J7jG6Lwp7zAhDp6d4ZRCtEcFQdzJRXcqmetT0Afd8A6pZbI2khVLIzaMER9LlNP0scZ5Thw+X2419Jc4YJfnkGQ5advnvXaOE96jnlORsr2Qc0D1d8Mjo8I0XI6NMr07kehDPHvQ/Nfq5q/mCZTM2zaf4qLXZunYheHE+8TGUQYrbLt3GvtneMg7Nu0EbAlCWI4fEWPseyntGU1wmO+y7dy163p/4S7/YgciKS3+t1QkL4+UHOPm21sH4b/fodxB1qMoC0tq2+4GpVVMALkw8NcjrMq0oMzXUNu0mp7BhMpXoraSnDy2PeJY9ddsR4BybYNgK+WwYL0BwLcpEon2d0N+u2M4BNJF1+NusejlxZ26kypdUjwyvivXg1yf1XZmF42FL5t06T1/zHJhoeAIckciAozufwH2KPKLWWZIiA6OCuldj8EgEb9Zd9AuqpO3YTb9U6t2AfZTomLJZdShoS3jde3Kp+nn5zGU+jbt6cNuzODPh1e0sLT1z7OiuVJuI6YQFX+Bvth3FswhOln8R+YaHIS16Ki3WZz7ifvVhtI26mimy8dG4ta+AdkuG0jiRT3aosU+eYfXMDeVH4Iy9+TIE0qc07R99lYyUg1IxeNw42I9AzeqM7/INh0HZI0Z4X4fLHNV3E+RVb8rEq5eMx4pzWPTgBwEQKAvbvKdoVVXDkjPOo6pH84ISJpAi57gbA8eGBI=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(7916004)(46966006)(36840700001)(82310400003)(36860700001)(2906002)(9686003)(508600001)(4326008)(426003)(54906003)(5660300002)(33716001)(316002)(110136005)(186003)(7636003)(86362001)(16526019)(70206006)(356005)(70586007)(336012)(26005)(6666004)(8676002)(47076005)(966005)(83380400001)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2021 08:16:28.1709
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32b0ccd7-7e02-4e4b-588f-08d98afd17f3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1416
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 09:55:14AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>

<...>

> Leon Romanovsky (5):
>   devlink: Reduce struct devlink exposure
>   devlink: Annotate devlink API calls
>   devlink: Allow set reload ops callbacks separately
>   net/mlx5: Separate reload devlink ops for multiport device
>   devlink: Delete reload enable/disable interface

Hi,

I see in patchworks that state of this series was marked as "Rejected".
https://patchwork.kernel.org/project/netdevbpf/list/?series=558901&state=*

Can I ask why? How can we proceed with the series?

Thanks


> 
>  .../hisilicon/hns3/hns3pf/hclge_devlink.c     |   7 +-
>  .../hisilicon/hns3/hns3vf/hclgevf_devlink.c   |   7 +-
>  drivers/net/ethernet/mellanox/mlx4/main.c     |  10 +-
>  .../net/ethernet/mellanox/mlx5/core/devlink.c |  13 +-
>  .../net/ethernet/mellanox/mlx5/core/main.c    |   3 -
>  .../mellanox/mlx5/core/sf/dev/driver.c        |   5 +-
>  drivers/net/ethernet/mellanox/mlxfw/mlxfw.h   |   2 +-
>  drivers/net/ethernet/mellanox/mlxsw/core.c    |  19 +-
>  drivers/net/netdevsim/dev.c                   |  13 +-
>  include/net/devlink.h                         |  79 ++------
>  include/trace/events/devlink.h                |  72 ++++----
>  net/core/devlink.c                            | 170 ++++++++++++------
>  12 files changed, 216 insertions(+), 184 deletions(-)
> 
> -- 
> 2.31.1
> 
