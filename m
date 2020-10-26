Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA9E29999A
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 23:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394059AbgJZWZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 18:25:16 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12417 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393549AbgJZWZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 18:25:15 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f974cb60003>; Mon, 26 Oct 2020 15:24:54 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 26 Oct
 2020 22:25:15 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 26 Oct 2020 22:25:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V83rwHDmIZLy/uMa1bq1GfnoycRHp+2To36Lpo3CbGm/D+H+DE2HSLGjt+Nbu9Qq85wwnEsTWuPCw62ZLsh8bfkb7NXBLSDDN5h2zLAg/5EAJ3UXZ3SDRpO39L/FlYnrB/QWBYROSUj28anxjKHlYVbJMSlqY2zd7+8TRM/kjLIsYoZqPxVva1lK8el5uLPP4CNGtopLvvcJ2++puX3mJxQrjfDvWnbHc+2FM1GD34RnZoXFKcq9T4oPwviye7iJmqTdd7Ximke/wAqtglBZ8Nqc9WR2AOYfS4Dp96YQCSB7TbJY08jD4JhSkXGFIZWQ+vKYlX6BX29S6gWXEg4PTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GNl5jq9HUk30Ro5+CAAxiWjS05geCXV6Kqzf9VlXEHo=;
 b=oAes5vE1PGcGBoCNx4EkamIJPjHeDScSlu4d3KUBMx5YcADaEwsj18vlf6yvlOFajiDVKrpDqofCgKG3w9WZrz2pw6wyn83QX7aPHjhf5bWxwlu71km8FsOpMYwctsdY6la3+yAzt0ZB5XX3m8vsACYBYg0HSTmAGdMRQg/YpZCuFVIwFqc2ojmRDfoCnO6KnYugkUsgRECRtEbJhzVTaCyhsBsTJap4Ax+/5P0ka+l41sJhRSHyp1bLMWXyDcnh4Toz+f1JdD0s3x7aXggyfPyMeZUScEngbTXoMkCD9JB5YWzDEPUk41rCjoYAEx68eq8y97RM3DIYI2hrLCkeSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3114.namprd12.prod.outlook.com (2603:10b6:5:11e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Mon, 26 Oct
 2020 22:25:13 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3477.028; Mon, 26 Oct 2020
 22:25:13 +0000
Date:   Mon, 26 Oct 2020 19:25:12 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>
CC:     <dledford@redhat.com>, <jiri@mellanox.com>,
        <linux-rdma@vger.kernel.org>, <michaelgur@mellanox.com>,
        <netdev@vger.kernel.org>, <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH rdma-rc RESEND v1] RDMA/mlx5: Fix devlink deadlock on net
 namespace deletion
Message-ID: <20201026222512.GB2066862@nvidia.com>
References: <20201019052736.628909-1-leon@kernel.org>
 <20201026134359.23150-1-parav@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201026134359.23150-1-parav@nvidia.com>
X-ClientProxiedBy: BL0PR0102CA0045.prod.exchangelabs.com
 (2603:10b6:208:25::22) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR0102CA0045.prod.exchangelabs.com (2603:10b6:208:25::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Mon, 26 Oct 2020 22:25:13 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kXAvQ-008fip-7w; Mon, 26 Oct 2020 19:25:12 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603751094; bh=GNl5jq9HUk30Ro5+CAAxiWjS05geCXV6Kqzf9VlXEHo=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=TaKVNFfXjc8LCMiDRDJWlrKPJgamXEnZVX0AdLnkPyJtHNlnTinJs2i1WH5orQTR0
         AIBrAGOXfp4aTbhPrZFCZTFy9qTifzmxxXawx383wA83K8G5ke/GgSsoPtwwrKUbZa
         ufq3Blt8hfSnzfKWEkAjJV5DqyY5hzMV+gLfWyFSDBdBYbU1cTGxLcH18mqdtkIB0n
         yQE+Jjnqll5sAOWBQUeo2kExeBzMYmbRuJekkyrSZM3WBrppN2vR/vA4K9WPsqHtkW
         sbTcFRpmDUZZLeIpyxMqZOYdeKwv8yvNXOulMXveeucTmQVLgKhp1F2B0qC0QtgBaL
         9uW07KNVCjY9g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 03:43:59PM +0200, Parav Pandit wrote:
> When a mlx5 core devlink instance is reloaded in different net
> namespace, its associated IB device is deleted and recreated.
> 
> Example sequence is:
> $ ip netns add foo
> $ devlink dev reload pci/0000:00:08.0 netns foo
> $ ip netns del foo
> 
> mlx5 IB device needs to attach and detach the netdevice to it
> through the netdev notifier chain during load and unload sequence.
> A below call graph of the unload flow.
> 
> cleanup_net()
>    down_read(&pernet_ops_rwsem); <- first sem acquired
>      ops_pre_exit_list()
>        pre_exit()
>          devlink_pernet_pre_exit()
>            devlink_reload()
>              mlx5_devlink_reload_down()
>                mlx5_unload_one()
>                [...]
>                  mlx5_ib_remove()
>                    mlx5_ib_unbind_slave_port()
>                      mlx5_remove_netdev_notifier()
>                        unregister_netdevice_notifier()
>                          down_write(&pernet_ops_rwsem);<- recurrsive lock
> 
> Hence, when net namespace is deleted, mlx5 reload results in deadlock.
> 
> When deadlock occurs, devlink mutex is also held. This not only deadlocks
> the mlx5 device under reload, but all the processes which attempt to access
> unrelated devlink devices are deadlocked.
> 
> Hence, fix this by mlx5 ib driver to register for per net netdev
> notifier instead of global one, which operats on the net namespace
> without holding the pernet_ops_rwsem.
> 
> Fixes: 4383cfcc65e7 ("net/mlx5: Add devlink reload")
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
> Changelog:
> v0->v1:
>  - updated comment for mlx5_core_net API to be used by multiple mlx5
>    drivers
> ---
>  drivers/infiniband/hw/mlx5/main.c              |  6 ++++--
>  .../net/ethernet/mellanox/mlx5/core/lib/mlx5.h |  5 -----
>  include/linux/mlx5/driver.h                    | 18 ++++++++++++++++++
>  3 files changed, 22 insertions(+), 7 deletions(-)

Applied to for-rc, thanks

Jason
