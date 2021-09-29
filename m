Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D2B41C31E
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 13:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245454AbhI2LCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 07:02:48 -0400
Received: from mail-dm6nam08on2054.outbound.protection.outlook.com ([40.107.102.54]:53408
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243658AbhI2LCs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 07:02:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xf4n5n6gWekS7AyEGiPLMK8TfDGtZKmekZCwrD5ARgfomnyDyDi0LsZCCqlLW7thqrWFrFLNYha+qDsk6BDVByVzVjrrbva3wUiGlLPe9WV/JXbBr0LSx5NtAsCuqmpYlhNF/QVxPyGjxiARxkfyEvEokhCAXd40U8v9iINnWk5bMCprwDzGCW5krJ4Zpan8Apm1npOUSXbdJ/GuDEUDLOuuGy+pSJxirW03YA3izqMTYJXx3L7wwPVPIXNpYrbf58EDO/B5X5zbL28WFGGJ3L/epyle1LCoHAAhJrFDsoSDYi1H7njVWtGgYicalEJCVTmoysPeAG9MAgP7he227w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=c0M3iWZpxTVf0W3BM1bV3OrzDLwiHj9fWsHbaSGkH08=;
 b=Nc8eYUTTiJyei+lAzaHGppJoSe2pOO75C5b2jnOOEknc+tV3bdJpvjmrA4vxGHhLCg1GAn3gO6YJ9P3OcDrxJ00MLIg1YPH9vC4k4XpB/joK/HGFg7Zo1//pT0xuhQmwKNYxhG/S94V7s2MZq7KdZfZSuCb1AMhn5lmYZuIX/4u6bxobDArO9gEIwBF+P3wWIjVBpZxs01fhFNXv+x1FJZlph9/D4hVnvgbTrdZCP1+aRHMBxlphZmlAjJBm58WK7P04uK8mdL8wDV7Qb5QHY241dhoPflTLUFyoXq7PmkW6zwr2LL2Twajm72kKyiooszUUO1o+8NH7HL9FmHI29Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c0M3iWZpxTVf0W3BM1bV3OrzDLwiHj9fWsHbaSGkH08=;
 b=KS1PNQdpGgybu2iuczLnp81GJLxgXiuarJ64ZrUVqMo1SWEoPJFU5t4r+x7OSySq9Za89dJ7gYgnmppLUczAVcTLmh9+DirpH4XjNKgiOiRZkIG/6MGllRmjHjDeSKwAx0P1TT6KZLnO0c6L08J6KQRtDE7LmoHpZqi/2rRpIvx7RsjVMJeqtNaZ0qDktAFKbq985QWBQNR2jct3iW4fu8DxKPGGBHUbs91k4lQ/pKGz1T2o4KD3B58FflkKGXu61P8aS9AA+hJ+DWOlUHTCndFGUW/BPhXeFglkCQp3/tx8AXbyz2DJDLAOr0Mmv6QgjKoyzviQtAozDtFaBLmm8Q==
Received: from MWHPR1701CA0001.namprd17.prod.outlook.com
 (2603:10b6:301:14::11) by MW3PR12MB4556.namprd12.prod.outlook.com
 (2603:10b6:303:52::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Wed, 29 Sep
 2021 11:01:04 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:14:cafe::6f) by MWHPR1701CA0001.outlook.office365.com
 (2603:10b6:301:14::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend
 Transport; Wed, 29 Sep 2021 11:01:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 11:01:04 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 11:01:04 +0000
Received: from [172.27.12.121] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 29 Sep
 2021 11:01:00 +0000
Message-ID: <7ae9f8f7-c6df-13be-f240-81d5bd4af57c@nvidia.com>
Date:   Wed, 29 Sep 2021 14:00:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:93.0) Gecko/20100101
 Thunderbird/93.0
Subject: Re: [PATCH net-next v4 1/3] net/mlx5e: check return value of
 rhashtable_init
Content-Language: en-US
To:     MichelleJin <shjy180909@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <johannes@sipsolutions.net>
CC:     <saeedm@nvidia.com>, <leon@kernel.org>, <paulb@nvidia.com>,
        <ozsh@nvidia.com>, <lariel@nvidia.com>, <cmi@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>
References: <20210927033457.1020967-1-shjy180909@gmail.com>
 <20210927033457.1020967-2-shjy180909@gmail.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20210927033457.1020967-2-shjy180909@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9632d1ca-a34b-4f33-6aa5-08d983386eac
X-MS-TrafficTypeDiagnostic: MW3PR12MB4556:
X-Microsoft-Antispam-PRVS: <MW3PR12MB4556DFA670658DF2E1FA46EAB8A99@MW3PR12MB4556.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g26qGSP+gKToPRGY1ggiN8GErfMvh2P0grWfqmwWtdy5+dIXOT0MdfP7gSu5vTmHZk5qxXtaJtXeUp4N19QJBxzdcsFWjydfMeLDnzjXm5FTp0XGsCNCjWMyxV6PFS1COVIvyPpEGvImB5E+QFDZ4b/nRsiTsrAHqxVDaQvvfT7fS9V+C1FqRhIwBZDEDcRvM+ycFop4HHO7dTIdFhcrHW10hGAEuqGEdx2WbQ/uo4OJH+2QGIlrlWBzKiDXqbP0mJU4KC1ZWZ5LF4WOucCMAkJWSWJqfIu94Dh/fTZ1yXtTPDiuGtfy06WT/3Ab1voOmJ2fU/6vp7I0CI6jR0oiish1GI7KfjkSPSAhJXbhMnhB2lpHU2bDUNhJ3RnQXxBKtFQORGXc42b0Vznsd8F3URTLhCnyczV1XrWuE/tSNbDnSb8+9Jh8Sno3NTiR9/SUkuovQqeKFpvEqPucyeO5GW6H0MsCgjSz5hZUHUrwqMwqzKZw/Teo1Xlr7b4cszldNj4tlkOn/IGwVpfnzKbsqxYvSVbJUAg6MrGVMwzETjP8qizIuGsz+YM6RkxqTggmeJn/9kAfdDzqMUONNXpGvkFl2CULKht7CskJdhuCaHRIZsD55//HIIV65BFnesP939jWXGsrsKA+SRKlSh63D9g6WI1Cng1DGZPlLdfh3uB5D6znmNsN9rmT8Qp8B8OgH20JbRUf5ZWzYagMOGX7NXarPF8W2Li4mx2jMUDbOKk=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(2906002)(8676002)(5660300002)(426003)(36756003)(110136005)(54906003)(186003)(16526019)(26005)(2616005)(4326008)(70206006)(53546011)(70586007)(16576012)(336012)(8936002)(7416002)(86362001)(36860700001)(83380400001)(356005)(31686004)(31696002)(508600001)(7636003)(36906005)(82310400003)(47076005)(316002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 11:01:04.6746
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9632d1ca-a34b-4f33-6aa5-08d983386eac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4556
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-09-27 6:34 AM, MichelleJin wrote:
> When rhashtable_init() fails, it returns -EINVAL.
> However, since error return value of rhashtable_init is not checked,
> it can cause use of uninitialized pointers.
> So, fix unhandled errors of rhashtable_init.
> 
> Signed-off-by: MichelleJin <shjy180909@gmail.com>
> ---
> 
> v1->v2:
>   - change commit message
>   - fix unneeded destroying of ht
> v2->v3:
>   - nothing changed
> v3->v4:
>   - nothing changed
> 
>   drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 14 +++++++++++---
>   1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> index 6c949abcd2e1..225748a9e52a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> @@ -2127,12 +2127,20 @@ mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
>   
>   	ct_priv->post_act = post_act;
>   	mutex_init(&ct_priv->control_lock);
> -	rhashtable_init(&ct_priv->zone_ht, &zone_params);
> -	rhashtable_init(&ct_priv->ct_tuples_ht, &tuples_ht_params);
> -	rhashtable_init(&ct_priv->ct_tuples_nat_ht, &tuples_nat_ht_params);
> +	if (rhashtable_init(&ct_priv->zone_ht, &zone_params))
> +		goto err_ct_zone_ht;
> +	if (rhashtable_init(&ct_priv->ct_tuples_ht, &tuples_ht_params))
> +		goto err_ct_tuples_ht;
> +	if (rhashtable_init(&ct_priv->ct_tuples_nat_ht, &tuples_nat_ht_params))
> +		goto err_ct_tuples_nat_ht;
>   
>   	return ct_priv;
>   
> +err_ct_tuples_nat_ht:
> +	rhashtable_destroy(&ct_priv->ct_tuples_ht);
> +err_ct_tuples_ht:
> +	rhashtable_destroy(&ct_priv->zone_ht);
> +err_ct_zone_ht:
>   err_ct_nat_tbl:
>   	mlx5_chains_destroy_global_table(chains, ct_priv->ct);
>   err_ct_tbl:
> 

Reviewed-by: Roi Dayan <roid@nvidia.com>
