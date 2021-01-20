Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5602FC5BE
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 01:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730847AbhATA0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 19:26:18 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:6225 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730601AbhATA0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 19:26:05 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600778740003>; Tue, 19 Jan 2021 16:25:24 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 20 Jan
 2021 00:25:24 +0000
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.56) by
 HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 20 Jan 2021 00:25:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sn68AnZ3UqKyJc/dt07I7in0I8umsvsb0PwFc2ZXePbbeGQTyk+yaFNj+QXpQ87uIJeyYfajEBukvo1JRoVkMuAYa7+pZZh0W815upcNbRP/YFVWlw9ZRx3RjwSWNJ4TOXWMgRWzt7gPD3fjXSa5658XRftxiz5jvFGhnqPtmxRQ0wzpZ0m4Lo0XeIwXSmGsKNneFK5OrehT3oi1shmG7RXPPrkKIM8s0zMApR89MNs5om/LhUNcL5i/gfMXZfxyyU9zHkdRZ+d7DrneW3d8UMtbC2uonORdS3xLRbHd/jD/s/eSvUXw+6EMr+YClM3UuqtrFEXS0LD7Ad4A9BTSLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U1dbZWBchdknqh56jYHqMHTSlSczRYJPCW+eMTAMwoM=;
 b=CiC5LSbDPQT88Bp8ZNpSDDHwuosUPgiJjWR4nHhFBvZXHKR2ZPyUr9pk1KIzXLdbi9vHOqpgj2CIRfgziCvYyLzxXUhT2r35n1h2SiTVn3pM39ol4PFVK/oQS/rjfqqYVJcQ/CnK2FxxsUKI/eRPGnwECSude4hiRZTLr/jqSuMD1KlAboiqru3bn8Zs2p01TNqP1wA7m3Lij25iFgD8vA5kvAO9AOOz2roUDGRYO9BDUJvRl9jEF/9c+Z/Zl3SWS8UVVqrwxrryl9nq5YIP5xanb4J6kFwWt6Q2s2EltBasQnYEx5RK7rJ9ftpCRp/MQmCgUDXBBxhpBrZAOzNRmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2486.namprd12.prod.outlook.com (2603:10b6:4:b2::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.14; Wed, 20 Jan
 2021 00:25:23 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::546d:512c:72fa:4727%7]) with mapi id 15.20.3784.011; Wed, 20 Jan 2021
 00:25:22 +0000
Date:   Tue, 19 Jan 2021 20:25:21 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, <linux-rdma@vger.kernel.org>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-rc] Revert "RDMA/mlx5: Fix devlink deadlock on net
 namespace deletion"
Message-ID: <20210120002521.GA963641@nvidia.com>
References: <20210117092633.10690-1-leon@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210117092633.10690-1-leon@kernel.org>
X-ClientProxiedBy: MN2PR06CA0013.namprd06.prod.outlook.com
 (2603:10b6:208:23d::18) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR06CA0013.namprd06.prod.outlook.com (2603:10b6:208:23d::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Wed, 20 Jan 2021 00:25:22 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l21JJ-0042hp-4g; Tue, 19 Jan 2021 20:25:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611102324; bh=U1dbZWBchdknqh56jYHqMHTSlSczRYJPCW+eMTAMwoM=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=M7yJZEApY66QYokWzfethwtbLYAqNNGh9/Yw4FrbtJ1ISwRskQ8Dn7JXy6ycnKC8h
         MmxajEbi4Bu4XDyjWkEJJC2BYeGiflsxfFJ5z2IsJvgsRg6bABWiGpoDT1RONYmqau
         WExcLictC2xPr9mZKQwPqBRXN/xF8l4XuKijUq8ejiaWwEC9SRHiII7ij+Bcq/Kltj
         S0AySKfdeKdKUfvPVwmQNRsIXXCHujZfElWY2TDerUN3w2egtj/cT7sbSwU4BoU+sd
         ff43kJL3gaUTbtJIEwj6VuKPyrqs0Rw2b9824pOurVjCD1WQr1iKS9XTIVoeIyF3V8
         SqYIO9psuRMbQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 17, 2021 at 11:26:33AM +0200, Leon Romanovsky wrote:
> From: Parav Pandit <parav@nvidia.com>
> 
> This reverts commit fbdd0049d98d44914fc57d4b91f867f4996c787b.
> 
> Due to commit in fixes tag, netdevice events were received only
> in one net namespace of mlx5_core_dev. Due to this when netdevice
> events arrive in net namespace other than net namespace of mlx5_core_dev,
> they are missed.
> 
> This results in empty GID table due to RDMA device being detached from
> its net device.
> 
> Hence, revert back to receive netdevice events in all net namespaces to
> restore back RDMA functionality in non init_net net namespace.
> 
> Fixes: fbdd0049d98d ("RDMA/mlx5: Fix devlink deadlock on net namespace deletion")
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/infiniband/hw/mlx5/main.c              |  6 ++----
>  .../net/ethernet/mellanox/mlx5/core/lib/mlx5.h |  5 +++++
>  include/linux/mlx5/driver.h                    | 18 ------------------
>  3 files changed, 7 insertions(+), 22 deletions(-)

Applied to for-rc, thanks

Jason
