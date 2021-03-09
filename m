Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B061332065
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbhCIIVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:21:22 -0500
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:55041
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229544AbhCIIVH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 03:21:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jbo621tgMR1SIWKdV7ozAdGODRMRfp10ADTyagY2Q0Eb8vvEnM4hR8nMxvq6A3/U6QMB7hRd7uaTqHNWTjjeJZLvLE/t+rq38EqnhJquqZLxdHWOmwIBTou+pkXN38yW0J5+VJK1jEusjs06Ou9xwf3vpn8ViP3GvdDlHXUTxXO/LzZ4+mLNyUUWJcKloM3CLmVfmuROVI66IGsQJhN3qMjj7Bhojx5ojiY9zB/Wfxbqg/uzn0S3QdT8IPM3haTMogUh1HTwhr8msC5WJLbvnqsU89JdDiAmL1QfPi4DQ80lj/Itq3Rdb8/1E86nr0VFFV80vbPsyhEw15GdaLrELQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iu/g/TLpL2VFhGhZDyVwvYQ6ja9wVsIG37xH2H24WAc=;
 b=h/nVtzbN8u6TSddc7UhObA+oixcZ5ZUcPX6o9GU37G+Djihpoqsc8Kxgabd0jY4N/7Kfg4cf55jYoxAwht+KJzbatZJGA+KusNJqATtm4j3idvAAvGcnlnCMauISGdixxVWFVI8rgeyF8P4V2ZOM4GZa3KOWdOBtRUSoZQnPDJKGl1GxHFIvbtl0pjdcc8BcHfarf+uM9hI6fYeFs0d+A/FVgwVuCL0tsjhRprr2DECQfwn8KEtkzO5gAFmp0cgkwQum23EfKXE9lWz7T4bu5ZFHifbczv7Qj0ko/a0ENi2xoWeu38YR1wqsMMy4LfDLGnvn4/YxFxhBwuDL9OuGZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iu/g/TLpL2VFhGhZDyVwvYQ6ja9wVsIG37xH2H24WAc=;
 b=qwwbjOxAA2c3vEDF4pHNkoZ4QqvAj9RSW6j3MwYVaKFrJXK3WtayiDSXrE9qQ+Ye8FqqIYmdnqHMzMcsa7CrFYwksV7PRtCln+4Jt0FQtqWi0+yKOz2TptTq7ZLNsYnlc1f7gMpxDcJY/g21v5CvceepJa3Gm1WkQ1M/uYmE8JKWIr0ivzjdKRbRKGxVrOJd53kiqWqhxE0xgho9sehrFYBPpho6Kuq/j7dLluiBoAog8/lL4u3qcFfaFLhmd4g0mRd8SsWz5cOjurY8ocVI6cOJQPKTlO9TH1oRiHagmGRZLbr0X6K5/uIdfsvUYCXgLllSA+SaLnpfZ3NJVZzZPg==
Received: from MW3PR06CA0026.namprd06.prod.outlook.com (2603:10b6:303:2a::31)
 by CY4PR1201MB2551.namprd12.prod.outlook.com (2603:10b6:903:d9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.26; Tue, 9 Mar
 2021 08:21:04 +0000
Received: from CO1NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::9f) by MW3PR06CA0026.outlook.office365.com
 (2603:10b6:303:2a::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.26 via Frontend
 Transport; Tue, 9 Mar 2021 08:21:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT025.mail.protection.outlook.com (10.13.175.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 08:21:03 +0000
Received: from [172.27.14.184] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Mar
 2021 08:20:47 +0000
Subject: Re: [PATCH] net: mellanox: mlx5: fix error return code of
 mlx5e_stats_flower()
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, <saeedm@nvidia.com>,
        <leon@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20210306134718.17566-1-baijiaju1990@gmail.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <99807217-c2a3-928f-4c8c-2195f3500594@nvidia.com>
Date:   Tue, 9 Mar 2021 10:20:45 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210306134718.17566-1-baijiaju1990@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea093b9a-f8ab-4853-66af-08d8e2d44794
X-MS-TrafficTypeDiagnostic: CY4PR1201MB2551:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB25512B51F6D47AB42F483DCFB8929@CY4PR1201MB2551.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8FVhSA62XpHxXW97nym36wdDS71fvKwFdUfyXYDe/M56XcSWto91MT+p/6DLLjmhYGgP5x1nzeTSFFrbShNBLjf+xzWHFJdRsFn0YeFShLcwqzlwWodBv1py3TFk0+PPJWWDa7W2bJCHCE3vQ1X7sn6OsnQens6Y/2DH2cLW+d1M2ufShEthctOTGG2EyGgdM8GhJR/B+fgipMkZBinhCWVCkhz3vkYnxLPe/UkY99mWAeQSv1L1ZoDk5wEhpkE4GXIZpIUsjY90WbtphkSKSs790jWy2nGzkJ7gAk+WZcYsqPIpaYsWPO56EGMO6m1qwePRjILpo5gUK1MlwzBz4Km6qd7BW+XddGPgmnLuoa+GnDfGKIFwZ59K5GQuEAfe9GE0irXMTwUitEG+A2ElLd3W2M6qHsuXUJKnRe09eb6QucaeTql/RfLaV3zic1uXRx5MBoPG44rNmWQcAClA4xYLEDzAe34ForItNxbWqHZCfSh1Jbnu6HIcjCvhDwgISIHx91jSAkA5aJdtA02u7oemKXtq8L5YkMcQ+bUzlT31CoacY5RxUuWrX61DabmJe2gxhUi0vRXmSX55u+BWT85zIINDzeofNMtgc5b3HvTmHXdmawoHDrtEwmdFql7zr/yZPFMnXmua/U3Nzhwr96f7Gzsm8STlcEj7UpyTMa2xj6G5g2wDzWHMqeI4N+DdWZUFwHW2pC0i5JXhAMvF6A==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(46966006)(36840700001)(70206006)(70586007)(82310400003)(426003)(2616005)(5660300002)(336012)(16526019)(8936002)(7636003)(47076005)(82740400003)(356005)(86362001)(36756003)(2906002)(186003)(8676002)(31696002)(316002)(478600001)(110136005)(54906003)(16576012)(36860700001)(53546011)(4326008)(31686004)(26005)(34020700004)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 08:21:03.2868
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea093b9a-f8ab-4853-66af-08d8e2d44794
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2551
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-03-06 3:47 PM, Jia-Ju Bai wrote:
> When mlx5e_tc_get_counter() returns NULL to counter or
> mlx5_devcom_get_peer_data() returns NULL to peer_esw, no error return
> code of mlx5e_stats_flower() is assigned.
> To fix this bug, err is assigned with -EINVAL in these cases.
> 
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 0da69b98f38f..1f2c9da7bd35 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -4380,8 +4380,10 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
>   
>   	if (mlx5e_is_offloaded_flow(flow) || flow_flag_test(flow, CT)) {
>   		counter = mlx5e_tc_get_counter(flow);
> -		if (!counter)
> +		if (!counter) {
> +			err = -EINVAL;
>   			goto errout;
> +		}
>   
>   		mlx5_fc_query_cached(counter, &bytes, &packets, &lastuse);
>   	}
> @@ -4390,8 +4392,10 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
>   	 * un-offloaded while the other rule is offloaded.
>   	 */
>   	peer_esw = mlx5_devcom_get_peer_data(devcom, MLX5_DEVCOM_ESW_OFFLOADS);
> -	if (!peer_esw)
> +	if (!peer_esw) {
> +		err = -EINVAL;

note here it's not an error. it could be there is no peer esw
so just continue with the stats update.

>   		goto out;
> +	}
>   
>   	if (flow_flag_test(flow, DUP) &&
>   	    flow_flag_test(flow->peer_flow, OFFLOADED)) {
> @@ -4400,8 +4404,10 @@ int mlx5e_stats_flower(struct net_device *dev, struct mlx5e_priv *priv,
>   		u64 lastuse2;
>   
>   		counter = mlx5e_tc_get_counter(flow->peer_flow);
> -		if (!counter)
> +		if (!counter) {
> +			err = -EINVAL;
>   			goto no_peer_counter;
> +		}
>   		mlx5_fc_query_cached(counter, &bytes2, &packets2, &lastuse2);
>   
>   		bytes += bytes2;
> 


