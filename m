Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A803144FC
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 01:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbhBIAgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 19:36:04 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:6779 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhBIAgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 19:36:02 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6021d8ca0000>; Mon, 08 Feb 2021 16:35:22 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 9 Feb
 2021 00:35:21 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 9 Feb 2021 00:35:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QhPsWJHXsNssZmq4xuu8zp+3HeBBxdiiapw85qPQibpjQfYUTCSKxtA6emVSl10SR8MLbko7xdYA/NI1yGDtp9Rhh2ZWmFD0Nk1OHp4u5sgPwS0LK83vZh8UnI/WdjVhoI1/KnFBFCOUI6ZyYQdtqdukYN/RxZPHNasQutljIwPgV+pZlMBNsU37+NhBmlYKvMWtJMO5VsXbiOZmG1GYVAclr5yfhR/6cOu43eCSU/PhbgUhcTq4XsJKN3CWBALUlM6aO68vjhFfdsic/VklSrS0oSNkZD2Diqnuk7s9NvCbL8CSgA75D6aCdMoixujiFO+yZ9BXOhANqVb1cpEmcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5jDbva86og4twIh075JX8vufkm/B1lCn2HVVlclSfI=;
 b=i6yZ5s2ezqMt61Z2q0QU3L1odBLZ2A8pBKErx1X4U74Jo2eE5Ea/hHcNndoFQiVgxZpzaB7IUENdpQ1Z9aJme1cQqeGmeo+bENfgIknxHqdlVBLRoYgafwGngsfsXflmZBwryDsckUAapZZxYAKh6dGz28o/YCiOnnxsIyPMREIjBlxacveqDrFUkDsKHW02i/72Y6mlWlQARwSM9xcJcmOnaIac48/kIzRaHBy3Q7SmGrpvVet1e6T7sEU63GAzCCUBqL3onUGT4h9GStvQwfTbZTUOP7q+osdiCmLz/1ux5s41L2DEDkmuyRyibfpTCjdRuhH55f4NPMMFnm3XpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2811.namprd12.prod.outlook.com (2603:10b6:5:45::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Tue, 9 Feb
 2021 00:35:20 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 00:35:20 +0000
Date:   Mon, 8 Feb 2021 20:35:19 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, <linux-rdma@vger.kernel.org>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH mlx5-next v2] RDMA/mlx5: Cleanup the synchronize_srcu()
 from the ODP flow
Message-ID: <20210209003519.GA1244392@nvidia.com>
References: <20210202071309.2057998-1-leon@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210202071309.2057998-1-leon@kernel.org>
X-ClientProxiedBy: MN2PR13CA0018.namprd13.prod.outlook.com
 (2603:10b6:208:160::31) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR13CA0018.namprd13.prod.outlook.com (2603:10b6:208:160::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.11 via Frontend Transport; Tue, 9 Feb 2021 00:35:20 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l9Gzv-005Dju-2a; Mon, 08 Feb 2021 20:35:19 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612830922; bh=r5jDbva86og4twIh075JX8vufkm/B1lCn2HVVlclSfI=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=KvNfITnTZMlbzKGxYp51L4x0ywZTL82TUNYtm/NuTUHphbXuSgNpJietDVwzO9IHt
         X+ncm/EmZltsgB0/srTNTIUVnTvRRaquwijuTg6odgEdGUUF8k3uOduW6eQv4vag3t
         sRiVTOky4/a7HmRDKWxU1BtU0wTnXVLK8Y21OAZhJnpUVvlPtqQ5UUDhAivzkrXiHb
         1CnNsLrDEdEXQG/0+qg27OSBufXZI8uc8cOlrc9br868gVN5/rCybYMkQissvpyeDn
         bWrabZ2mj4L13hscs0ABgrgP/G0o88Km0QfDxv0CKSbadVFZx/GUbZGWNnND4p6JW1
         67U3oaATItn+g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 09:13:09AM +0200, Leon Romanovsky wrote:
> From: Yishai Hadas <yishaih@nvidia.com>
> 
> Cleanup the synchronize_srcu() from the ODP flow as it was found to be a
> very heavy time consumer as part of dereg_mr.
> 
> For example de-registration of 10000 ODP MRs each with size of 2M
> hugepage took 19.6 sec comparing de-registration of same number of non
> ODP MRs that took 172 ms.
> 
> The new locking scheme uses the wait_event() mechanism which follows the
> use count of the MR instead of using synchronize_srcu().
> 
> By that change, the time required for the above test took 95 ms which is
> even better than the non ODP flow.
> 
> Once fully dropped the srcu usage, had to come with a lock to protect
> the XA access.
> 
> As part of using the above mechanism we could also clean the
> num_deferred_work stuff and follow the use count instead.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
> Changelog:
> v2:
>  * Add checks of xa_erase() result as an outcome of memory error injection tests.
>  * Found extra place where we can change open-coded logic to use mlx5r_store_odp_mkey().
> v1: https://lore.kernel.org/linux-rdma/20210128064812.1921519-1-leon@kernel.org
>  * Deleted not-relevant comment implicit_get_child_mr(), I have no idea
>    why wrong version of this patch was sent as v0.
>  * Deleted two new break lines added by me to make code more uniformly
>    in before "return ..." (sometimes it has new line, sometimes doesn't).
> v0: https://lore.kernel.org/linux-rdma/20210127143051.1873866-1-leon@kernel.org
> ---
>  drivers/infiniband/hw/mlx5/devx.c            |  13 +-
>  drivers/infiniband/hw/mlx5/main.c            |   5 -
>  drivers/infiniband/hw/mlx5/mlx5_ib.h         |  31 ++-
>  drivers/infiniband/hw/mlx5/mr.c              |  26 +--
>  drivers/infiniband/hw/mlx5/odp.c             | 224 +++++++------------
>  drivers/net/ethernet/mellanox/mlx5/core/mr.c |   1 +
>  include/linux/mlx5/driver.h                  |   2 +
>  7 files changed, 127 insertions(+), 175 deletions(-)

Applied to for-next, thanks

Jason
