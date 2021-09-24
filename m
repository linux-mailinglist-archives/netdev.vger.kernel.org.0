Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990A8416B51
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 07:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244152AbhIXFuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 01:50:11 -0400
Received: from mail-dm6nam11on2071.outbound.protection.outlook.com ([40.107.223.71]:58625
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229727AbhIXFuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 01:50:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=URklQYXHgCGwdRZoIiZHy9r8/qxHMv+zQ1HEzZApAZxVA3Dv2bmV8gwUp/0jUg9S2H2iVIR6lnQa/cmIz/Q077+3Dvf+U6tiZhldHeH5uvFlxCDb8tPo/ivdTND1gTg4OplOgwixOZKK3/wxII+Xy5eMFTbQwX2CuJvVxwxgeFk5moQwl/e5R1YUNC1pt8rja/xkd0mzhCTj09vg7q+oGyg48S1kqh6ETuZtt+xjaMhvD2qNjzl+SuzTZXNjv7QxYyrnlTX7X8gr6EGnmts6jC2FrZXysLcGDEr31OcWCfX6IZZ7t4BSoKsf21uyAqBejBEHJ/5bl34Nx4Vc0XJ2uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=HtCtGjpvoqhvnVevPhb0a6ckdCdbFOIhRfoZZtXq74s=;
 b=PXkRk4zjLECPqoorVCzur/N598a535K6kuswINTCFDbtSETDL6M7UyRug8w3l3nDJwI3DI95RWftziRaIDnZTDDNbexnionfMtxJbU7X+JJTjk8JtLxmMJJAqsLy1rPZdbscLsNnIer25J8murijnIruDuugCZ7E1t+vna3BVzv1pAuSpVP8G17BJzW9NYuf9yIU/5lFf7DsoFVipjOJ2SwU6OHCjfcekwQou5jYqakJepHX0+TO8k+s45XUfanQZw+fYmHRgKhhgH+WJcSKVQi2Z2Zt4hS4yGOvTArNJ4HArC5MneoCkImh2eTXk8Vs0kBJDz4SEiEMOelHPW6akw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HtCtGjpvoqhvnVevPhb0a6ckdCdbFOIhRfoZZtXq74s=;
 b=PqPBKiNSk/bpWRCznbcvGesE+qTEzFfczpTpFd6stYRHWcQwPB5mPuWpBQ+B3TZ789gnjSGIpvudtB4NyIVF3Sjz7j+wnM3/hywDswqpa3R2TQ6KMY2CwmO8b1lc6lLaVWFL7l4SK4EmuiRHj2UBZtelsx4CkHoC86tq2L6mYBrJCEYtsqOrLvE5kLFD9Nrxf/rAeFnnHhtPh6wSqfIWfaaTUrvYhJAI9z1/avBxi1tPe/xlcZJ4BcOz8cg1pSl3qv26ekO/iS8fkT/JkGG539aSSlNJmqG7yrN8VRe6HycmrhGAfsx0Cfsqr+U6iO0oIA/Fwi39+ERxgTZeEP65Zg==
Received: from BN9PR03CA0408.namprd03.prod.outlook.com (2603:10b6:408:111::23)
 by DM8PR12MB5464.namprd12.prod.outlook.com (2603:10b6:8:3d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Fri, 24 Sep
 2021 05:48:35 +0000
Received: from BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:111:cafe::6d) by BN9PR03CA0408.outlook.office365.com
 (2603:10b6:408:111::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend
 Transport; Fri, 24 Sep 2021 05:48:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT048.mail.protection.outlook.com (10.13.177.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4544.13 via Frontend Transport; Fri, 24 Sep 2021 05:48:34 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 23 Sep
 2021 22:48:33 -0700
Received: from [172.27.4.177] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 24 Sep
 2021 05:48:30 +0000
Subject: Re: [PATCH mlx5-next 4/7] net/mlx5: Introduce migration bits and
 structures
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     Yishai Hadas <yishaih@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <cover.1632305919.git.leonro@nvidia.com>
 <be4ea343f1afd0d49afce7dccaa8fcadebd3fe8d.1632305919.git.leonro@nvidia.com>
From:   Mark Zhang <markzhang@nvidia.com>
Message-ID: <77a12336-ec18-2791-b7b1-744a44eb2e72@nvidia.com>
Date:   Fri, 24 Sep 2021 13:48:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <be4ea343f1afd0d49afce7dccaa8fcadebd3fe8d.1632305919.git.leonro@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ecc9c766-8556-4edc-f10c-08d97f1ef2ea
X-MS-TrafficTypeDiagnostic: DM8PR12MB5464:
X-Microsoft-Antispam-PRVS: <DM8PR12MB546407D272EDBB86F5C7AE63C7A49@DM8PR12MB5464.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3B2ozKG32auxied2gVpjsg+z6n30AplYD/sTxQT0AOhopnvcXkqiZg5nbeJg8EUxdxpjU+poYL7p1GpZICnjqZQsZw86XPBJHw/8bNiAHEJqinlV6AU1HucJBpI2UwU0LmoxHIDzKclK1reoo2A0CwKhToZ3SazjVQGMZL0lIuu5zIZZJTXyQQgNV3eAIBOA91VBbIKJKyWFNhRGbLsd1XNbuGupka3SpKedaHBkjsVuVOEv+Wt7jtP3rwrtqyFTcFftCuKLfdCNnEnULdeLDTSo9ex4ehzgKVbByjCdQGrjB8L0w3WIC9nXWAzuaeGBZ5IOSBMElB9o8ExER4Gc0cF5gfeoS1fYf4y2F1Jc/5aPaRfji628Jd9BPBx+aimnPd0HxaT6Uj1ANQnxwYdEjNu1pcYpfzTNkhf2ojEJQeCk0Y+2Tz4Z+uLr2861NqE5BXh32W4jtLJvovX6kWtsUZz8yn+lmkfSkXy9DHQd8eYKAn6zKzdqvRmSr/EretyAJNzj4W9C98AYcZx1URLyOPLByPid2rTd3Y2gaWU3l/016aufcUTFhXlKBNpeV0lOLti3X67dB9aUX69KjvQvMmPzHX4SBzK/D8+1boaHR68ssgc11xreSCZUUtoYAI7S1RzbtWS5dQFSq7B55NvI44fXHP7eGy2v1CLb39MxLnUb18h42QjnOBf9XQFMuFmNZ2xl/ZR8JvgNdcc2fu625iwKK7sYoHQR+Xn0ydhfH2U=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(508600001)(16526019)(4326008)(26005)(186003)(8676002)(7416002)(86362001)(16576012)(36860700001)(5660300002)(6636002)(316002)(107886003)(82310400003)(426003)(6666004)(31696002)(2906002)(31686004)(54906003)(47076005)(53546011)(110136005)(2616005)(8936002)(356005)(36756003)(83380400001)(336012)(7636003)(70586007)(70206006)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2021 05:48:34.9116
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ecc9c766-8556-4edc-f10c-08d97f1ef2ea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5464
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/2021 6:38 PM, Leon Romanovsky wrote:
> From: Yishai Hadas <yishaih@nvidia.com>
> 
> Introduce migration IFC related stuff to enable migration commands.
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>   include/linux/mlx5/mlx5_ifc.h | 145 +++++++++++++++++++++++++++++++++-
>   1 file changed, 144 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
> index d90a65b6824f..366c7b030eb7 100644
> --- a/include/linux/mlx5/mlx5_ifc.h
> +++ b/include/linux/mlx5/mlx5_ifc.h
> @@ -126,6 +126,11 @@ enum {
>   	MLX5_CMD_OP_QUERY_SF_PARTITION            = 0x111,
>   	MLX5_CMD_OP_ALLOC_SF                      = 0x113,
>   	MLX5_CMD_OP_DEALLOC_SF                    = 0x114,
> +	MLX5_CMD_OP_SUSPEND_VHCA                  = 0x115,
> +	MLX5_CMD_OP_RESUME_VHCA                   = 0x116,
> +	MLX5_CMD_OP_QUERY_VHCA_MIGRATION_STATE    = 0x117,
> +	MLX5_CMD_OP_SAVE_VHCA_STATE               = 0x118,
> +	MLX5_CMD_OP_LOAD_VHCA_STATE               = 0x119,
>   	MLX5_CMD_OP_CREATE_MKEY                   = 0x200,
>   	MLX5_CMD_OP_QUERY_MKEY                    = 0x201,
>   	MLX5_CMD_OP_DESTROY_MKEY                  = 0x202,
> @@ -1719,7 +1724,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
>   	u8         reserved_at_682[0x1];
>   	u8         log_max_sf[0x5];
>   	u8         apu[0x1];
> -	u8         reserved_at_689[0x7];
> +	u8         reserved_at_689[0x4];
> +	u8         migration[0x1];
> +	u8         reserved_at_68d[0x2];

Should it be "reserved_at_68e[0x2]"?

>   	u8         log_min_sf_size[0x8];
>   	u8         max_num_sf_partitions[0x8];
>   

