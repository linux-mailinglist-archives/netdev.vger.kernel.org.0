Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7CB410A9C
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 09:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbhISHvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 03:51:50 -0400
Received: from mail-bn8nam12on2054.outbound.protection.outlook.com ([40.107.237.54]:57621
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230463AbhISHvt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 03:51:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVrkfC0Yp2t0ccCw7hfh21JyCPzSeYp3T/sGZjPG97OvNkGqC5mCSr8HT21u/ZHZSOJvsJGZTXJLllPoOkZAPfsIHQK7fbnhN7t24N6n6s6cA6EOtiy7trtiVvbOXldewpm1zpUcfFTY/BnxLUcWq2F0Zz4SUDGCDBf7JT8tkqhHZ6EtJhaid/wXaarfX8Zy9McBvJpXpaIUpxiAiscWE6K1FyeVSt7hPkYLDFEY7EoEsW72Fi6UwmBkNi0/zdHciUwzdGpJWXV5FSQBUsjG+AsMXGRNrN8XbrykgiWgJswhX+fsFKgt6eF6ueEyLI3X4n7eyr9N4Ys2jhvurzTESg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=KOTPHgsXytLgGNt2Yoi8RK5SRkWj00Xkd7YxAh+w8Yg=;
 b=Oor36dJR3qO6gv3AUyPuv0GMowMsG1xnZsmV2w5ebmf2SFhZquLkuNNkpMi+omQyj8KMi495Eah2zj5iEEMchppOt/FzObEyQ2ivXGONkw251BV2qLgwjkpnYJY0xi/D8SnnfogPWOvt5n098CBcK8Fx+lUrnEaqeD8igcwI4adOIC2H7BnjtRWwwNRqyVRisNaR7i/+zLhy7CZ8FqQPH4sfVUKfiqvI0uTWcFfIoKxtSC7RYOsTetAh/GaqeKfZi8GC0nLIRKhgIxYI6vTtzHSuT3vtb1RzGBPjk51wkNLSva753sRO7DgCtfOFoPckGZokG0E+3kvlzeEDMRdyAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KOTPHgsXytLgGNt2Yoi8RK5SRkWj00Xkd7YxAh+w8Yg=;
 b=ak9bo1fgdIcnV8iczcP/DYdT54mNR/7d8biwpCxPANA7cQKpAiMz/ZA56UI2Hjr50vG6LeZgtwpCdFMpXaZaS9d0lAN20M8c4sPWmjl71WF71OcDrQ2C/rb92Zc1J2O8OvNG6qXHyShAaWvKF5fInjqeBf8eQ+J4XsUgnde/m+YLfOhSQ3wn4TFLK0qGefSHflMFJWgz4ms5uj7/x3rJWvSXgfgJc/JYmlekY63gzRQ8Th0O2p8brtYymNOz/KipBS6rhRwGzaMiHtnb56hLv4UrIWgimHjqHLBbAOXdfD+rfxgxK4uNkaOWws02CJWx0QqizOWNJWJTC+eqXcmoLA==
Received: from DM5PR20CA0017.namprd20.prod.outlook.com (2603:10b6:3:93::27) by
 CH2PR12MB3799.namprd12.prod.outlook.com (2603:10b6:610:21::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4523.17; Sun, 19 Sep 2021 07:50:21 +0000
Received: from DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:93:cafe::b6) by DM5PR20CA0017.outlook.office365.com
 (2603:10b6:3:93::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend
 Transport; Sun, 19 Sep 2021 07:50:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT013.mail.protection.outlook.com (10.13.173.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4523.14 via Frontend Transport; Sun, 19 Sep 2021 07:50:21 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 19 Sep
 2021 07:50:19 +0000
Received: from [172.27.12.123] (172.20.187.5) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 19 Sep
 2021 07:50:15 +0000
Message-ID: <05a4a33f-552d-f65f-4d06-33699c5a6a8f@nvidia.com>
Date:   Sun, 19 Sep 2021 10:50:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:93.0) Gecko/20100101
 Thunderbird/93.0
Subject: Re: [PATCH net-next] net: check return value of rhashtable_init
Content-Language: en-US
To:     MichelleJin <shjy180909@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <johannes@sipsolutions.net>
CC:     <saeedm@nvidia.com>, <leon@kernel.org>, <paulb@nvidia.com>,
        <lariel@nvidia.com>, <ozsh@nvidia.com>, <vladbu@nvidia.com>,
        <cmi@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-wireless@vger.kernel.org>
References: <20210914161853.4305-1-shjy180909@gmail.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20210914161853.4305-1-shjy180909@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61ac44b1-607c-4a38-1f29-08d97b4221bb
X-MS-TrafficTypeDiagnostic: CH2PR12MB3799:
X-Microsoft-Antispam-PRVS: <CH2PR12MB3799C2D7F73188F6CD0F85FBB8DF9@CH2PR12MB3799.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hQhA31PClRNWry5aP7g6yfNl7kdpE0Lz8zXL3AHg1PJ+DFCSsJ88KEDgBSmzHB56UONS2qdpBxIMshCupOTVD8NGWTFx4i4H9r16A8KfUO5qU6BYuOuMZkquuPKm2w5df+TN+aByWv/vxZffNnBdSeoumg1uTnbDvEK7QHRKpaeR+/CZNW4YJufhhtafVjFFTRJu4ECPI4L3gZSg1YLqhmzjdhIJtCfbzI5ocPyGgDPrRVxacrAAftzu35oLKR6HsWi59RgexF9gxv/J3Lqbz6xvOktrGPwCIGZGIcej67k3x7rCSYKTGLshlDl99+E4dwauwEbYa+jIfrzo+keQOQor4NYfBqyY3w3n/HCUSDg1J4CRO9yQ31fMDODC0BgoniHNDVplfAtmuvGArP/qxoC58688XMOqvt2SyL+eIHuFbFjCfFebFmMAbKG46Znec88rG2yvF3r/n+a+5TmfWoF6YPA+oUteSVws5yDGedhbuyVocHGqoyl80LG9b/TnT8X2q+866F8TJRpe2rT1lJavri5j6suWUT7iRX05WOYo06mh0bKkVCIYzyTG2nBzzo0+WQVGDWj84WXCll1Mizs7ZF9HOjVoHphnjS0LcNEDJ3LenkAq7sxpLA84TFnjq5IG91/bWxBq8PjeEycFFbxX/ibW7Qu9a1pDovZcd5FrSIRg0f+2TAUYUu1gbEVAuWgLrzlYNg/PjUn0REUCN6ciHy/lb+U400ZWngFKCLo=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(39860400002)(376002)(46966006)(36840700001)(70206006)(8936002)(4326008)(36906005)(316002)(26005)(7636003)(70586007)(110136005)(31696002)(356005)(54906003)(53546011)(16576012)(83380400001)(7416002)(8676002)(2906002)(336012)(86362001)(36756003)(47076005)(82310400003)(478600001)(36860700001)(186003)(16526019)(426003)(5660300002)(31686004)(82740400003)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2021 07:50:21.0840
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61ac44b1-607c-4a38-1f29-08d97b4221bb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3799
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-09-14 7:18 PM, MichelleJin wrote:
> Handling errors of rhashtable_init.
> 
> When rhashtable_init fails, it returns -EINVAL.
> 
> Signed-off-by: MichelleJin <shjy180909@gmail.com>
> ---
>   .../net/ethernet/mellanox/mlx5/core/en/tc_ct.c    | 15 ++++++++++++---
>   net/ipv6/ila/ila_xlat.c                           |  4 +++-
>   net/ipv6/seg6_hmac.c                              |  6 +++++-
>   net/mac80211/mesh_pathtbl.c                       |  3 ++-
>   4 files changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> index 6c949abcd2e1..5ae3b97df10e 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
> @@ -2127,12 +2127,21 @@ mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
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

you don't need to destroy the ht that failed to init.
so if zone_ht fails jump to err_ct_nat_tbl.
and if ct_tuple_ht fails jump to err_ct_zone_ht. etc.

>   	return ct_priv;
>   
> +err_ct_tuples_nat_ht:
> +	rhashtable_destroy(&ct_priv->ct_tuples_nat_ht);
> +err_ct_tuples_ht:
> +	rhashtable_destroy(&ct_priv->ct_tuples_ht);
> +err_ct_zone_ht:
> +	rhashtable_destroy(&ct_priv->zone_ht);
>   err_ct_nat_tbl:
>   	mlx5_chains_destroy_global_table(chains, ct_priv->ct);
>   err_ct_tbl:
> diff --git a/net/ipv6/ila/ila_xlat.c b/net/ipv6/ila/ila_xlat.c
> index a1ac0e3d8c60..481d475353ea 100644
> --- a/net/ipv6/ila/ila_xlat.c
> +++ b/net/ipv6/ila/ila_xlat.c
> @@ -610,7 +610,9 @@ int ila_xlat_init_net(struct net *net)
>   	if (err)
>   		return err;
>   
> -	rhashtable_init(&ilan->xlat.rhash_table, &rht_params);
> +	err = rhashtable_init(&ilan->xlat.rhash_table, &rht_params);
> +	if (err)
> +		return err;
>   

since you return an error i think you need to free the allocated
locks called a line up with alloc_ila_locks(ilan);
I think with free_bucket_spinlocks(ilan->xlat.locks); 



>   	return 0;
>   }
> diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
> index 687d95dce085..a78554993163 100644
> --- a/net/ipv6/seg6_hmac.c
> +++ b/net/ipv6/seg6_hmac.c
> @@ -403,9 +403,13 @@ EXPORT_SYMBOL(seg6_hmac_init);
>   
>   int __net_init seg6_hmac_net_init(struct net *net)
>   {
> +	int err;
> +
>   	struct seg6_pernet_data *sdata = seg6_pernet(net);
>   
> -	rhashtable_init(&sdata->hmac_infos, &rht_params);
> +	err = rhashtable_init(&sdata->hmac_infos, &rht_params);
> +	if (err)
> +		return err;

here you can just return rhashtable_init().
note I see the caller, seg6_net_init(), doesn't check for error.

>   
>   	return 0;
>   }
> diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
> index efbefcbac3ac..3ef5d6e00410 100644
> --- a/net/mac80211/mesh_pathtbl.c
> +++ b/net/mac80211/mesh_pathtbl.c
> @@ -60,7 +60,8 @@ static struct mesh_table *mesh_table_alloc(void)
>   	atomic_set(&newtbl->entries,  0);
>   	spin_lock_init(&newtbl->gates_lock);
>   	spin_lock_init(&newtbl->walk_lock);
> -	rhashtable_init(&newtbl->rhead, &mesh_rht_params);
> +	if (rhashtable_init(&newtbl->rhead, &mesh_rht_params))
> +		return NULL;

looks like there is a memleak here then. you need to release newtbl
before returning null.

>   
>   	return newtbl;
>   }
> 
