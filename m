Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A20C21250A
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 15:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbgGBNoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 09:44:37 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:18606 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729222AbgGBNog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 09:44:36 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5efde45e0001>; Thu, 02 Jul 2020 06:42:54 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 02 Jul 2020 06:44:35 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 02 Jul 2020 06:44:35 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 2 Jul
 2020 13:44:24 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 2 Jul 2020 13:44:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0h/yz/kRGPPt5DTDMrsWE/K82MyrFwJJ5UyMRjN3rR0kscjVaCxCEd218qzV1n6U2hWvSqgwcWZs+es7wlXYyldxwuluCwv6PziJOsOt6vzxYlypEsrT1ooV9GqUQBDBk0rXCzjeH9sObTKwKIlUXY+kwte2TYgyvjxTasmY5hBufPpURcoLf/JqUYkPLbLkmtbPE+6/jo35Odnvs2Wc9WrSPTlP+7P2GNWAFrUWt1AKAekJPUIsHOKsiNq1u6kn8OuLVAHhoEQHgsCxe7q0291g5FQzZ4fZgJ52QjrNGrcLwvk4Ii/HIp+Bb72MUMjLZY1G5A9rEDWoIlMEvVcgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jSqbFz+nDSD8uIBcoBoLV4Oh0iwmoUixtVUtEnMWeU=;
 b=Br+SsAv8XGwFxo2X/vKC0DFYBxT+ZL5Yp8/6dxDVrYb8HeHL3RzczLPpOwBuTdGxlWr9tkwnLN3hO0VWypHBZydKG68A10QT5oXwr118i70TFCbAP9pCqO7tqV5d3xlYxTQk+nIXQSJC84o3rjVVxrLffntQTlG43TC1/D4O66qR5C+TfD/FbKM/9dAXDF/oyZ5h1k+1xhfI900fZeHav6evS/9m9msr1aIg8xdfIuJ6aQcLnpoxDgjRWSI84FYDSGfGDjU22OFroONf5pksRP/5bHmsZlwxlLs7r+7RW6/iRIohPEw9LyV5/UZZraEJVbFnn0vyGi34JSjJFFp2Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3402.namprd12.prod.outlook.com (2603:10b6:5:3b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Thu, 2 Jul
 2020 13:44:23 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1d53:7cb4:c3d7:2b54]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1d53:7cb4:c3d7:2b54%6]) with mapi id 15.20.3153.027; Thu, 2 Jul 2020
 13:44:23 +0000
Date:   Thu, 2 Jul 2020 10:44:17 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
CC:     Hulk Robot <hulkci@huawei.com>, Tariq Toukan <tariqt@mellanox.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next] mlx4: Mark PM functions as __maybe_unused
Message-ID: <20200702134417.GA689088@nvidia.com>
References: <20200702091946.5144-1-weiyongjun1@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200702091946.5144-1-weiyongjun1@huawei.com>
X-ClientProxiedBy: MN2PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:208:23a::6) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (193.47.165.251) by MN2PR03CA0001.namprd03.prod.outlook.com (2603:10b6:208:23a::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20 via Frontend Transport; Thu, 2 Jul 2020 13:44:22 +0000
Received: from jgg by mlx with local (Exim 4.93)        (envelope-from <jgg@nvidia.com>)        id 1jqzVh-002tJ8-Os; Thu, 02 Jul 2020 10:44:17 -0300
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4608b16-1459-4aa3-1398-08d81e8e0724
X-MS-TrafficTypeDiagnostic: DM6PR12MB3402:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3402C2BBF8C1150DF7FE5D8CC26D0@DM6PR12MB3402.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wcjQDUbPwo7WM0G40riAfEJ5BMx4mDy3vE4VyKMinPuPxnBqiFX3hGKjI/yYkolfwx7wCKXIk3M1vxftaNyaTjQpXoZfuNKk3jVy+kTQV9monAuFFvzzEwzxZuEw3lEybKXxBcpcWAQqc2gmqzqxMO1ixk7D/Z4XJCUchqV0vK5it4eWjOowu6pL0f8XkHb+2HwWzxRvSay04U/kq7nrax9QOr1h4Ji2Db7JeZUyrXz/lmvIl+48r8Ly6EVNstSbWE2E+AltqVzzJHJ6ieoaJ/u66kqAaN4BshHJOANyPnYDoKrUzB6lk/KbebXdC2wmSTG4R+fUc2RHH9DiuEZQq4QmySgkjWa13yexY4aro7uXxGcD1goELl/WUJdhYSPK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(4326008)(186003)(26005)(316002)(478600001)(54906003)(9746002)(83380400001)(8676002)(33656002)(8936002)(9786002)(2616005)(426003)(2906002)(6916009)(36756003)(66946007)(66556008)(66476007)(1076003)(86362001)(5660300002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: +s2YuA6YLivAGDVCepf5t2gB937Z+3w5I6ryFRFsVFc/di/0eN/+e/KfZbFIIL3GKuX9oVlwnllGn91OnW2Vv/TeQEp05dMW+5ZqpGCcB4kETQzL0V4leSYvYMFrz9XVECfrj7nH/FbBzbuGjC5OLGTmJZBu65ZTsIGVsLPD1AYC7W1B4hI5TExZt/QYIiIdFbaetOomFfP3vealzfFc0AIFg+4rZUWJBjh89JVV5JrRASBajFSeHeBR8ZA1jgRN56V2MVHuIvKeQNf6voiXltx5l3IOHhuUJXZcMGQz1FWXs6LZmZFchvGh8ys1CaHmwr13y3SvDpLTpJUDnsxMkcKouBeO1CSb5EEuVYZeL+mIDPH0GkWd37sffJMpz3O9fIf2cXu6VgdiuHQYEACXb34Qlhu1zCMCELgqrZerCj/XSlmQhtUXz1ocSSysJXTV111OqnkwVKflt8sDV4JBWCmApylZ/et5mPSq+9BVDVddxaRVWCsR7yYBzLwqpNO7
X-MS-Exchange-CrossTenant-Network-Message-Id: b4608b16-1459-4aa3-1398-08d81e8e0724
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 13:44:23.2406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h2oekHBVj8+EOmLCWcNwZ6KFLWub3EIkyeiCnQ6pOTJdb6BUBZiMKbqzdnq7/SJG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3402
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1593697374; bh=8jSqbFz+nDSD8uIBcoBoLV4Oh0iwmoUixtVUtEnMWeU=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-Forefront-PRVS:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=n6YqNFDf59OtUnMWBV0Rr+O0YH96cbGDgazw7ZrOuUfOivVc5dxsFZLUXLoOVK0SW
         8r04sX7zr61pWhQGaL0zEVwAgwNF9EnniNMTWQctqyCbJCazmPPFibwgWvj5HJwUCt
         9bjUI8PvZWPJejLVX5BWb0tzPAFHpiO3jaTfAhDJBlMOwLSS2xOBJHvpvi4jG6vLeH
         A74pon2sXpvhWPcy9dSzt4RU4JQXjJ1rfXuyijCZ08OZvnPwVNFBgCiwEJmGroDYDO
         hWEWMhy2D/YmuQvFdre6bM5iLwULlu1IwyB8loCk0QP+aoq6N1SS8bC/AQu8yV7Ukz
         bh4JPcWw7S4XQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 05:19:46PM +0800, Wei Yongjun wrote:
> In certain configurations without power management support, the
> following warnings happen:
> 
> drivers/net/ethernet/mellanox/mlx4/main.c:4388:12:
>  warning: 'mlx4_resume' defined but not used [-Wunused-function]
>  4388 | static int mlx4_resume(struct device *dev_d)
>       |            ^~~~~~~~~~~
> drivers/net/ethernet/mellanox/mlx4/main.c:4373:12: warning:
>  'mlx4_suspend' defined but not used [-Wunused-function]
>  4373 | static int mlx4_suspend(struct device *dev_d)
>       |            ^~~~~~~~~~~~
>       
> Mark these functions as __maybe_unused to make it clear to the
> compiler that this is going to happen based on the configuration,
> which is the standard for these types of functions.
> 
> Fixes: 0e3e206a3e12 ("mlx4: use generic power management")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
>  drivers/net/ethernet/mellanox/mlx4/main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
> index 4cae7db8d49c..954c22c79f6b 100644
> +++ b/drivers/net/ethernet/mellanox/mlx4/main.c
> @@ -4370,7 +4370,7 @@ static const struct pci_error_handlers mlx4_err_handler = {
>  	.resume		= mlx4_pci_resume,
>  };
>  
> -static int mlx4_suspend(struct device *dev_d)
> +static int __maybe_unused mlx4_suspend(struct device *dev_d)
>  {

This seems like a poor idea, every place using SIMPLE_DEV_PM_OPS would
need this annotation.

Seems better to add something to the macro, IMHO

Jason
