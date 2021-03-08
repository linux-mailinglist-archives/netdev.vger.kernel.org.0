Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02CA03315E7
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 19:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCHSYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 13:24:09 -0500
Received: from mail-dm6nam11on2076.outbound.protection.outlook.com ([40.107.223.76]:42240
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229775AbhCHSXo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 13:23:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mOApJggLRepivMckRZCbdGWg8PLPQ6G7yfEcQOw8PbfMSl4fC0FrPyKgNtWbg3U1apLscKK4V6MwrbHHFqFiakx17CR95yn0Bf0PMizNvpGrQrHp1W8FCdKPfZYJaSNKA4/vM/BPTx63rZHffePW8UIqeKLl4uCq2qyxyzruH1FTemD+gXYaGd+rpG7gk/z8eeZX+Ub2KHItdfy9tAZiVhJ1EKR+hIXUOYRxhPdE6JRIwyXJ0G9+5yWyhMJ6ZLM9atncwuSfJxVCvEpbuJ//1FiU1l8hKYRhHAzVKsINHHvW3kpsrz1JE0wskPpRHiLovrdrvjQCN5BhhVK503Cxew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BOyjHZzv38LdhpRmhtoifbdS6BFOY3aKVTfUCe1n9Jc=;
 b=mU6cUjWxjgep2mnm1K4x8+wA60FjjE4LIX9KNyDEYqMEqOgicskN8wLISSPULcfHxOl1VWxWG8+ILrVRP85WCOUUQ6e3ThAeULdgcx3d/+iGjQix833+dLkxEOWftAflNqI31d2Ct9W4fJ/m3tykcGPM6184WPTTeOxak/Y/tVcPX6tcyybhWFf5H5cWCZGuv5rcI4TVhuLMfVh3zaJDTSpHOZhTjCkHoihnVlKNRZsrGRRukd6B+mDk+DcTFrSba7gyiLnMrZBmy3zDNBPvs1HCh4mMUdGpiap6UuhDEN3qO3j3iWzlH99lnjMi0by6hxiUlJQMa+Q+WGoasz9PyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BOyjHZzv38LdhpRmhtoifbdS6BFOY3aKVTfUCe1n9Jc=;
 b=ZtqFOjhexK8S/ob2RPWLYRkrPRnWaakv4jshFU/wcLqDSpjG32mQsEBvZ7YqeWt4O4wymYQK6QyDAgUH2TPr1WPgQ2o67IZ1iAkiWTzxPAwrSsJQ09Yqcnmbku93MwAXmkXRZ/vkheWa+zMwHs9WHa3VjmCWHZNuVE2rVmD+E2w=
Received: from DM6PR12CA0034.namprd12.prod.outlook.com (2603:10b6:5:1c0::47)
 by MWHPR1201MB0205.namprd12.prod.outlook.com (2603:10b6:301:4e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.26; Mon, 8 Mar
 2021 18:23:39 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::42) by DM6PR12CA0034.outlook.office365.com
 (2603:10b6:5:1c0::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Mon, 8 Mar 2021 18:23:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Mon, 8 Mar 2021 18:23:38 +0000
Received: from [172.27.13.167] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 8 Mar
 2021 18:23:35 +0000
Subject: Re: [PATCH] net/mlx5e: include net/nexthop.h where needed
To:     Arnd Bergmann <arnd@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "Leon Romanovsky" <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
CC:     Arnd Bergmann <arnd@arndb.de>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210308153143.2392122-1-arnd@kernel.org>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <5fd5e630-0db2-f83b-63c8-265c4ac372e8@nvidia.com>
Date:   Mon, 8 Mar 2021 20:23:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210308153143.2392122-1-arnd@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d62fecb-1a7f-4fd2-392a-08d8e25f4b51
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0205:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0205D244E1491112AC6DDAB6B8939@MWHPR1201MB0205.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:126;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9ttofbVBvnsuMVXoIghk+icP+RRdNnJi8GhsEWhpyu/fYmb1CAWXCG/Ked1WssoHGuyItJjF9a0mbp1uUS2Gn3v9+DJwJzQXl4FYleFQfaR4fVCewRQ55FJDdgZgNvGIh4hC8igvuNq52o8id6hugw86xxm3l1KfZgQR4/ph9OvjsTkiU3iItEo6Sl4u36xJGUydObENhePyvMDjoAudol34PamdcRMz3tKWJ58zgEedOdpXRa7N+vNEgG6ez5pj9w185sAFA/MZaeWaDi8yrI4ObjnbKUzI2NrvvwH+PJvraqabcfc9Z62sApwMX70TikdgI6gFn7JPmfTm+BiTyU6hE3mPmcWn/6Y8/YkwmRfZUWsPQkt9/MW0C5YKsBJUC9DRm1lRFyuAflfowwd9Wn7S27m0MKdxz4IMUbKuO7BPAkkSXSbVUbox7/l+yOXfJscR4EWihRwoQyBN32qfuWvODE7Gg13js9TpjDdamJUap8Q/jpcixjWj3coK31oVLsrx2GtyDw1S8LirG6t5UwBrlwTMjLCcfyIP80o/3/UInTQZcFzZoWeJ2nKUS00nSw1mQmKMEpp2JbP1rSWoNn8a15mPJGp0bTWCgK5Tv8nxFS9h4hfSVTgS+LPl6zZnxleMz8slC7UG/SMWxYA4by7L5m1RO9yXh1+UAhW3vR+ZHTMjDK43PrPCNskc+uPW/2FxD5QhYMe593JEmSmE2+t25YL8hk8ISjUvAZpBruU=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(346002)(376002)(46966006)(36840700001)(426003)(7636003)(6636002)(186003)(16526019)(356005)(53546011)(47076005)(83380400001)(70586007)(31696002)(5660300002)(70206006)(6666004)(34020700004)(82310400003)(36756003)(54906003)(36860700001)(2906002)(26005)(86362001)(8676002)(8936002)(4326008)(478600001)(16576012)(110136005)(2616005)(36906005)(336012)(316002)(82740400003)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 18:23:38.5190
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d62fecb-1a7f-4fd2-392a-08d8e25f4b51
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0205
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-03-08 5:31 PM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:1510:12: error: implicit declaration of function 'fib_info_nh' [-Werror,-Wimplicit-function-declaration]
>          fib_dev = fib_info_nh(fen_info->fi, 0)->fib_nh_dev;
>                    ^
> drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:1510:12: note: did you mean 'fib_info_put'?
> include/net/ip_fib.h:529:20: note: 'fib_info_put' declared here
> static inline void fib_info_put(struct fib_info *fi)
>                     ^
> 
> Fixes: 8914add2c9e5 ("net/mlx5e: Handle FIB events to update tunnel endpoint device")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> index 6a116335bb21..32d06fe94acc 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
> @@ -2,6 +2,7 @@
>   /* Copyright (c) 2021 Mellanox Technologies. */
>   
>   #include <net/fib_notifier.h>
> +#include <net/nexthop.h>
>   #include "tc_tun_encap.h"
>   #include "en_tc.h"
>   #include "tc_tun.h"
> 

Hi,

I see internally we have a pending commit from Vlad fixing this already,
with few more fixes. "net/mlx5e: Add missing include"

I'll check why it's being held.

Thanks,
Roi
