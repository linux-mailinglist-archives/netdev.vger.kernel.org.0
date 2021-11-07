Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D6D447214
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 08:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbhKGHwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 02:52:39 -0500
Received: from mail-mw2nam12on2062.outbound.protection.outlook.com ([40.107.244.62]:52256
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235036AbhKGHwi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Nov 2021 02:52:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M3sYBh97ULtoF/7Os6893XlosBR15G/uz1T0D2hmSx6Vh9gPNIw77ldPGMD/zjPNTeZ0uPbypL4q1Epau2ldgNnbb5GBZjWpMn9RqQJfOPXkGiattxSpagTCTs19e33WaqrAcRUWpK2tMI7yop4UbkMq48nQyLlhGnHjXArwGeyPu//UinAq8BVdXsEg7kNl2MNmMCZvG6oIE0B6fAYvYkrNtwJNYYXyid4x/tHGOANd7lezbWanOMWfS0T2CBk1Bp2+SuLKa/yp/1sprX98and6a4vJYgX3xWmKSvu2P1A+t2xIqs3j2bzsdk+TyMHHfCElakXZNprkh3vii7A8ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=om8l3+jh4ujTlwoJf4ByzG7dVxMASjxFxLh5VGQFQOY=;
 b=IY+cUbagXOI5zfiYTU0VkWd1O42ITBVzXYI0HDorJ4GXGKnRAy2FQAI9yhztvGWTgtCcmfoqPZmZ4U+2MFi3qkqrZVocn3l+5+VDIx+KODf7xrmcSjKmNM0TVi+TlMNsL3F6uFThzbBtZsH++fxdAeJJIPylyhPVTAFo0fMpRpp5Kc25dImDiPchI871TehFsHlfq3BWE75VQDvcQ40JlZmjykapcwjdyDhG+YV0pLVADp8H95FE1EW6XhC4fOfBdmkIzECjCeOQbFGFVa8Ek+gx5L+JRQqRhrRvFkzthJzj+vBV0vnoUYgVeYqP2mUIM7iFwLkXyqlz8v8aG2FXnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=om8l3+jh4ujTlwoJf4ByzG7dVxMASjxFxLh5VGQFQOY=;
 b=WWjBBjey1SmrDnfCAyGHGHM5pYrHPrT6erlyLm6z9iXmdytMqsgFq5yYg+oqfe30AgyTqI7nda97p5WIIkeJOHR1XzZQ8vhCZielfaCyosChZukROWVQSqdqys3ykDIzsawHwjeRgozUgB9SM1YjdLcmeRN7qAYLNtzh2Rb6HuYdr9ZmVlU3EzGbNRW9ocEIkHrDfoY8MF2J7b35w9ziWDETMVU0n4vfhiAUnXD78FP5sNE77jS2AjO4zFx6iV72gComPHuPF7j6e32/rb7tSRhHCwB5gabbM0+oKCDNtQG9ydu2DhvtTJLyc8c8VLtbiVCzEiQwAowuG8vMpcFo7w==
Received: from BN6PR20CA0065.namprd20.prod.outlook.com (2603:10b6:404:151::27)
 by BY5PR12MB5542.namprd12.prod.outlook.com (2603:10b6:a03:1db::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Sun, 7 Nov
 2021 07:49:54 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:151:cafe::60) by BN6PR20CA0065.outlook.office365.com
 (2603:10b6:404:151::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.15 via Frontend
 Transport; Sun, 7 Nov 2021 07:49:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4669.10 via Frontend Transport; Sun, 7 Nov 2021 07:49:53 +0000
Received: from [172.27.14.198] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 7 Nov
 2021 07:49:50 +0000
Message-ID: <c76779a3-aa4a-98af-f04d-3a8b41a58cb6@nvidia.com>
Date:   Sun, 7 Nov 2021 09:49:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:95.0) Gecko/20100101
 Thunderbird/95.0
Subject: Re: [PATCH] net/mlx5: Fix some error handling paths in
 'mlx5e_tc_add_fdb_flow()'
Content-Language: en-US
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        <saeedm@nvidia.com>, <leon@kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <vladbu@nvidia.com>, <paulb@nvidia.com>,
        <lariel@nvidia.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
References: <3055988affc39dff4d2a5c00a8d18474b0d63e26.1636218396.git.christophe.jaillet@wanadoo.fr>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <3055988affc39dff4d2a5c00a8d18474b0d63e26.1636218396.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3be8c76b-3f6b-4d5f-1a63-08d9a1c32fb9
X-MS-TrafficTypeDiagnostic: BY5PR12MB5542:
X-Microsoft-Antispam-PRVS: <BY5PR12MB5542F209A535D613B3E6760AB8909@BY5PR12MB5542.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DbsgtJWs2/inlAtNmtAoyp6nqKaebKpF7icmrQx2U4NPTkVQGdzc8uoNYCMtX+X7+QEMe1zYJLwQbcDTPB2BizDHMN6AT3sjWAlH/5ovQ2c9/OlfNbFgXnIqxhijJeBq8iH+/F493N7RCacwRLBEUuLN/B9AAKeT1zgaDIBvfUdNxOtty2EwG3rOuEpNTXIqzGhX+A4to5wTnoxpdQk4Cs1jtSb4d/25YmR79347R5Y4PYja1kT1ZluDACc+Xs9zQiaUoCPl2H1uuwLVxflOrIbN0dtJpb3fDVjS4IpIo+T7vAorbuam0bDse8j2eODC8vFeFqdVOYSrU4t6uMKbtD3XhQR4dmYeXpUwpDIzJvPGDmgWVs3TndWFJc4CV3u4RKQg5qr07Jkfl5kGtFrhejmbQ1LmMhPUqbZBQnHL8B7O4L/bb3XE2bVXrXTifXkfFfhNLgGQ6Q1uJIh95qlt9sU9WjHwI42Vgwfl/M/+zR1SvCOjzH7g1uXgFcFwmL8lygEfSB6pCJvALIRLPy8AVT++E/sHZC+9WYggCOPwZOuaFz8fiYBw0WB4v/vwC10dNhyHKGKG/SlrpRvKe0QdkQaeaYzB0cnQ5zZla0F1bjFCTFIGBoA6Hn43strOV6RanU7aWdI67oKMj1pvIBkgj6lrdCZP2EPsO9eW3xcbs7jlILJpziLRl2aJ5O7CIcKsW5lszTzLStZv9QDqJ2/EE0L/b+SsfB9PtsJnVQXTlXo=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(336012)(8936002)(70206006)(70586007)(16526019)(356005)(316002)(31696002)(7636003)(16576012)(53546011)(508600001)(54906003)(31686004)(6666004)(86362001)(26005)(82310400003)(83380400001)(2906002)(6636002)(110136005)(36756003)(426003)(2616005)(36906005)(8676002)(36860700001)(4326008)(5660300002)(47076005)(186003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2021 07:49:53.9301
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3be8c76b-3f6b-4d5f-1a63-08d9a1c32fb9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5542
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-11-06 7:08 PM, Christophe JAILLET wrote:
> All the error handling paths of 'mlx5e_tc_add_fdb_flow()' end to 'err_out'
> where 'flow_flag_set(flow, FAILED);' is called.
> 
> All but the new error handling paths added by the commits given in the
> Fixes tag below.
> 
> Fix these error handling paths and branch to 'err_out'.
> 
> Fixes: 166f431ec6be ("net/mlx5e: Add indirect tc offload of ovs internal port")
> Fixes: b16eb3c81fe2 ("net/mlx5: Support internal port as decap route device")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> This patch is speculative, review with care.
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 14 +++++++++-----
>   1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> index 835caa1c7b74..ff881307c744 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> @@ -1445,7 +1445,7 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
>   							MLX5_FLOW_NAMESPACE_FDB, VPORT_TO_REG,
>   							metadata);
>   			if (err)
> -				return err;
> +				goto err_out;
>   		}
>   	}
>   
> @@ -1461,13 +1461,15 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
>   		if (attr->chain) {
>   			NL_SET_ERR_MSG_MOD(extack,
>   					   "Internal port rule is only supported on chain 0");
> -			return -EOPNOTSUPP;
> +			err = -EOPNOTSUPP;
> +			goto err_out;
>   		}
>   
>   		if (attr->dest_chain) {
>   			NL_SET_ERR_MSG_MOD(extack,
>   					   "Internal port rule offload doesn't support goto action");
> -			return -EOPNOTSUPP;
> +			err = -EOPNOTSUPP;
> +			goto err_out;
>   		}
>   
>   		int_port = mlx5e_tc_int_port_get(mlx5e_get_int_port_priv(priv),
> @@ -1475,8 +1477,10 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
>   						 flow_flag_test(flow, EGRESS) ?
>   						 MLX5E_TC_INT_PORT_EGRESS :
>   						 MLX5E_TC_INT_PORT_INGRESS);
> -		if (IS_ERR(int_port))
> -			return PTR_ERR(int_port);
> +		if (IS_ERR(int_port)) {
> +			err = PTR_ERR(int_port);
> +			goto err_out;
> +		}
>   
>   		esw_attr->int_port = int_port;
>   	}
> 


thanks for catching this.

Reviewed-by: Roi Dayan <roid@nvidia.com>

