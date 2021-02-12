Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4D331A448
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 19:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbhBLSJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 13:09:03 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:5577 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbhBLSIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 13:08:42 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6026c4010000>; Fri, 12 Feb 2021 10:08:01 -0800
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 18:08:00 +0000
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 18:07:58 +0000
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.53) by
 HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 12 Feb 2021 18:07:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UPsdQ3OhxmFCJlMRmJQCbeM7duvQ7xQCxsv6F8jKHotFuE/N55t7w19wvCCTiztXiFYve33Rneor0iKR0na85MclNYbeNlCTq4Mu/SypMEORV7kChJrR0QbhTzhkPsRRW1t3bEJbhnWKsqcGYGqtPgzAnWTdAQRHkUAe4CuZ1JXDGoKgiel2KN3/Zrbs9OJ5DpavAwKBFt2t13NaEHUJscA66iKLK77uYcPxZH6/JG7L5NV8JdAMBg4926e+bigxpwLM/NMMY+3ncYWIM/etUsYCjwWjWgl3LOK/aenwnnJLNwMTF9DTDDIuifZJJckT04HbT8PnOTIyPSVSxycwjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LL/JEAr54owFaJAblqfnbFelGqRAHtmhJzGX7/PNG00=;
 b=nIWshRl0JtSdcEihaG+EfpgZtGLEBKCTUXczTcEJw5ZuYQLR5su3EM/DPFusSi57e/JGosvywd1h8Z2hWW57cPX8ssxWcRZAz0NGge+h41NqZBqWeblLFClaqbqsYa/s4g5Dark2/tdK2YWg9PoiZdwgZE44z9mzKGWVcI9HqsJ/NM8btEMLVdP7AcqLaXU96+QTEPxQYrF6nGjhPUJ1GO+DJN2tj5zk98kFf/KWfOx9JB/+qrhblfxy04rTvw3XeDmQFszCRTObid9zk5SshnQ5TPLRqcCC/aKf1xFjzgwxyMx2vsPDylBHY42/sHmQPZfgAG4Vhkw9iZbN+OuzHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4356.namprd12.prod.outlook.com (2603:10b6:5:2aa::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.30; Fri, 12 Feb
 2021 18:07:56 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3846.030; Fri, 12 Feb 2021
 18:07:55 +0000
Date:   Fri, 12 Feb 2021 14:07:53 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>, Tal Gilboa <talgi@nvidia.com>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Meir Lichtinger <meirl@nvidia.com>
Subject: Re: [PATCH mlx5-next] RDMA/mlx5: Allow CQ creation without attached
 EQs
Message-ID: <20210212180753.GA1737478@nvidia.com>
References: <20210211085549.1277674-1-leon@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210211085549.1277674-1-leon@kernel.org>
X-ClientProxiedBy: MN2PR18CA0028.namprd18.prod.outlook.com
 (2603:10b6:208:23c::33) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR18CA0028.namprd18.prod.outlook.com (2603:10b6:208:23c::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Fri, 12 Feb 2021 18:07:55 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lAcrB-007I6G-C1; Fri, 12 Feb 2021 14:07:53 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1613153281; bh=LL/JEAr54owFaJAblqfnbFelGqRAHtmhJzGX7/PNG00=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=k+C5lz3VGxjdEU/bvJkJe1O+See5R22YkD0XgqB8htHy8H4xR9+Eia9p9nlWVUWNz
         KR6QVeCLANYQVoTfKdS+0BkjKc81XI5mWdnui5IFKY131F9ETKjttkXuMSs2vLIOcS
         i0287z2zWVRbKh0nR5aCczW5ei/gaXUHuv1w7EeYyh3GguFo4Kz/5XjoQjSvY+qOuW
         8+9JJnx4A+sIW/0yZPJCmvbQjgDMqpjWsD1su0tMWN+PYS/NeOeoxxiNzaxx9mt1id
         sQh8kAQgwNa+jAYy5/rpWB06JrHTbS6z+pm5SDjpaAoB3dfdP4913nRFtM6p6podnd
         cv3vIsmOrzlyQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 10:55:49AM +0200, Leon Romanovsky wrote:
> From: Tal Gilboa <talgi@nvidia.com>
> 
> The traditional DevX CQ creation flow goes through mlx5_core_create_cq()
> which checks that the given EQN corresponds to an existing EQ. For some
> mlx5 devices this behaviour is too strict, they expect EQN assignment
> during modify CQ stage.
> 
> Allow them to create CQ through general command interface.
> 
> Signed-off-by: Tal Gilboa <talgi@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/infiniband/hw/mlx5/devx.c | 13 ++++++++++++-
>  include/linux/mlx5/mlx5_ifc.h     |  5 +++--
>  2 files changed, 15 insertions(+), 3 deletions(-)

Applied to for-next

Thanks,
Jason
