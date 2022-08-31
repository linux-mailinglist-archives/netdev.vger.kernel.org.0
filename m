Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E6A5A75D3
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 07:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiHaFkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 01:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiHaFki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 01:40:38 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3FC66A44
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 22:40:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2MMEB+7NsnBEoPlRETpMldVnk1AFb+uTOJ3iW/LMOvnBBNflw1ik92gsDkfCrXo3NlNIgTV5958VvSWsfn0gZIZx4UHYI1WRYmMnY+obbYc/tpQVeSA7NcGhLHWF1AuOP5Ud/9F9GEZp/zJ1hqb5BBwd5WCJG6n8DXCkDDwlzliryxkwX2/yFx6tepYhaXofCXvbkPM9RhM1fTbWxHYZsGYUxk9LRD2YnscKDZgDPXivP56g0L5jWUFE9TsEOMmJpoi3Rwd1GEcmyQs9SfjxMuZbMs+3ffyWUSsYckTJXtNcZvt8oiNQXf7sjtCGA/AfmM5B4h+QGusrx7onzGFVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jVLW8rGabmX4V+V9sGFaGTlPyDqLPhzjHdTKS96Z1D8=;
 b=W4FtLBVw/T9EzE24D7ptU6EZsIjBMKlDR/IyEuc+gkzUyhfPGzEaGvtXK0tWlRo4KqiFQ43cY+ji/UJyQirJc9rAZIMZd+BX94nY3gsQmdmQ97aOzjWNb1UY5vyJI8bONf3HX6cl8wVeU5ZHYpro8fj2BqiE9g7M7Vyc7hAQhDgSFxi1e629YUQm2bEOIVyUS3i+iqydid79UddErTv36HefowmpuwuKOjR8jvmRiPFg7gQs6EIBQwrzmH/f3YMBciNdEbMxWpUW4ir0lGzCGrh6ngIXCu7bPaThtGWPg5J9uZFMDlJKhjyNnqcmqidDlMd0SF24ULdFeN30iL2B+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jVLW8rGabmX4V+V9sGFaGTlPyDqLPhzjHdTKS96Z1D8=;
 b=ewstNlY6jR6nDtY+GJ9Cakwio3xuFZC0s28gGi6SxeIHHScC4pa5oEuf6tsE5hc/+0IoyIX4i1jTZIj/YWbl0eTAuRrqnhl+XeQgY6Jg+H0KtJ84PetS3tVciqeOsfAioHUqqhEXdjm9kOp/y6p3X6mtt7wF+Q+F1wYEBvuEso3gRHLoSmtZotWm9LHIkyghLT62DZujFwHS4VnjSQkOpZpsRzzVLL8I5hIo/uctoRL1RrSNfa0dhxBluSxRfO+I3/K4EWs+y9EEm0leiQxgyD01bfgKvascIrizUi17+CSW0XLkLhrrUP7BgIBWSKn80AHyslaFbajjNKiXaiyb+w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by BY5PR12MB4227.namprd12.prod.outlook.com (2603:10b6:a03:206::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 05:40:34 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::e034:e0b9:a75e:3478]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::e034:e0b9:a75e:3478%8]) with mapi id 15.20.5566.021; Wed, 31 Aug 2022
 05:40:34 +0000
Message-ID: <0a6b1f5f-e470-a747-e45d-56648860d510@nvidia.com>
Date:   Wed, 31 Aug 2022 08:40:28 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:105.0) Gecko/20100101
 Thunderbird/105.0
Subject: Re: [PATCH net-next 1/1] net/mlx5e: Fix returning uninitialized err
Content-Language: en-US
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, alexandr.lobakin@intel.com,
        dan.carpenter@oracle.com
References: <20220830122024.2900197-1-roid@nvidia.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20220830122024.2900197-1-roid@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0087.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::18) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a4f16fb-f30e-451d-8c38-08da8b1352ce
X-MS-TrafficTypeDiagnostic: BY5PR12MB4227:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NGmbazfL12VvS5SPrMALR54K6gezOR4jGNuABCTWRtAU2bfKoWdM6HdOe0HOAnKjIUz+mkxO68SfK75YwaF9NrAnYG7KDR5qVIyeCYAEAxS6RdOYZLqbFxPdPnuZuaNgxRa0BUVPU0cfhRUvXywym3suSqroR2KZxRhhlyBGGvemmhKPWBqeudsusUns65oU7KlcbzK8kdXtVEjh9lpzSoevymPw9Gd41y7vMudKK34cZnkmtYyFWjt/Om51293Yl6ys4SJVO+Hex70EsJvEl2pb15RWhg8vjTYhw9zXg0myixqWOwvvElkiGjyGl4jBRZfX29c2vzQl9kr6Ib5j19G7Wn2Oe7OWX/4ZlRI5IYZK2WD1+ngZ00mhGmbm7gSs/KTXwoNbHvbQ5Y37p5nmls25UTL9LnAUsPzgYhdQwNW6ajvlUvmOSRGGyeG9YpSM2hwFz/pRd+dhucDdtLsWlktHC201H3ktGTJ7/bJE9yoOvtCfruAFd7UOVR8GyhgFK6YHvBKNaaoaU3DeSEB2tdfn6gFMHj/d/T0rUBo2cYMeWM+tAEqRHxZc2PJXbWFRy5D/0a6z0S5is5YLPsUXuU7mC31jZUPRAVqgHQv+1V1XP56RjVZqml3xhkkzg40UpPBvCw7mpcoDtCTtNwOybRHxDhDZEe1Yeq89IW9kjm9/U60ru/rlowIDS7Qo01SausJF9s9z8fFBl6O2Brv8ZaQA3lDuP6xbGJ3mvitPsKX7FgOikkhAvc4kqgMk9+CCgRl5jdUrOxYpyxUAOpgPzThgrPm2a88fyQw52iwoc6w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(39860400002)(376002)(136003)(396003)(66946007)(66476007)(66556008)(8676002)(31686004)(4326008)(316002)(6512007)(53546011)(6916009)(54906003)(26005)(6506007)(6666004)(41300700001)(478600001)(6486002)(86362001)(31696002)(2616005)(38100700002)(83380400001)(2906002)(36756003)(5660300002)(8936002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NlRzbUJuNTNQSDg0dm1iWUQwR2hVTjRJdHB0Y1R4NXFNcGY0amdEcENZVWtU?=
 =?utf-8?B?R3BCT01YNE9JSUtNSSthSFNNYWFqMUVJekpFTVo3UVJkalVVWUlacGZPNDdT?=
 =?utf-8?B?bHp6MitqZFlMeXhIMTVYVnpEN2M2Q3pVeFFqMURRS3l4NXpWbUlwZml3dE04?=
 =?utf-8?B?R2R1bVUwNTZWRUszN1dNLzN3b1FhakE5RXJrMFpyNGtDU3A0dWhVVFZ1eGhn?=
 =?utf-8?B?MUMrUGkvVGlRNUV1TG5pZWErWm5MaDJvd1BKOXV2L04vRUhCcU9pVk80eWQ3?=
 =?utf-8?B?cTBjdUh5ejNRUmo2VGZielp6OWVBd011UW84STJrNUIyUDA5UXQ4OG12Rk1G?=
 =?utf-8?B?VTIyMkE2eFp6WDBnMFFGRzdUaVhrS1FvQXVKa3Nmb3R6S05iamQyRHFuQyty?=
 =?utf-8?B?enBtNVZJQzBGWnBpRE8xSE5EMnpLZFFXbWVXVlJPWU1DWTZhZkErWDR4ZjI5?=
 =?utf-8?B?RlluU0JiL0FMT0N2MzRkU3NCRHUzYVEwS2o5dWNqZElQVXRXRGlmOWM5dlRo?=
 =?utf-8?B?NDVFSkhrUzQ0RTgzdGZDQlozVzR3WTNkL1hKa1JSTjNCNzJoM1BldktEa2o3?=
 =?utf-8?B?dEVVYUtTUlpKYTdoQTBlQ3kxUU5MZ0lld0t4cjZrQWx6MzBncWF5NlYwYjR2?=
 =?utf-8?B?UkJuWVY4RExMbHdLR3R4WnkwNDUvZUdWbXFzdWhSNm1tdUFaRW4yek5Qdk9a?=
 =?utf-8?B?a0dpaDN6NTh3NUZhbEJZZW1XMlFrV3ZpRmFFNkZGSmlLdVpQelpsbzk2SlVl?=
 =?utf-8?B?U2NIR0FUcElQczkyN1lBY2ZMUFhvam9DSzB4ZGxUUWZISzhoNitvcDRmYlBo?=
 =?utf-8?B?ZXMvOWJRK1BSZ0RFOG16SSt0SUJMMVNHZHo1d3dWWURvY0hERk1TTzBTNnls?=
 =?utf-8?B?OVIwRnEycUJ5M1VYYksrYTZQUDcvRlozT3d0bG4wVnU0b2dxRk5PZXdpeWdl?=
 =?utf-8?B?RU5tQk12YWJIZVljTHljVkllL01pQVoxUC9naUM5SEpqd1QwOFZrZnpPUDI3?=
 =?utf-8?B?R2JUbGFoMklacFZXaE5vbmJDNi9KSktmejA2RDh1MmpJUUx2NnZVZGtoSzFr?=
 =?utf-8?B?NEtGejB1T1R0ckg1ejE0RXBJeEVJUGdsYk5iZUpDTWs1aXRuVWpQNjF1bzND?=
 =?utf-8?B?UHNjSTFoK3ZmeGJOQllCNTFqZmw0MjJXVCtNOWRyRUZoZk9wU0FtWnMvRzIy?=
 =?utf-8?B?WllacHZmV01rbHVxRE5CVmVwQisxUG5uT08xQVpZV0FRVlVIVVNVWjY2M21W?=
 =?utf-8?B?N2ViN0ZOZUo4VFA5Tjd4Z2xJR2dpVGtmbHBhYTJlUFg5WFBEcFVtcW1ZQ3Ju?=
 =?utf-8?B?L1BUMGRyKys5WVg1TWp4R0xvT1h1MFNFeHo4eGFLcExaSWYwSXA2SCt0dmpk?=
 =?utf-8?B?ZlZoQmVkRUR3NU5WSDVrRUxsVGZONFcwNWdqNi91cEZHdVI2SmVGMkxFc1BG?=
 =?utf-8?B?WGJCOENIZENXbVRaU0E3eGMvWXdxVDB2SXlUc3l0bzE4TnMwMVFHMGRueVF2?=
 =?utf-8?B?SUdzbTV2K3AramFOMlNrWXhUK2J2TEhzRUs5dTJEMXJPN1VMTDRHK0JqL3Mr?=
 =?utf-8?B?ZFpsS2xWZTdFZVgrVytwUHVxTnR6QUpXNWF3TG1vS01NT2ZxVnNyQmdDR05W?=
 =?utf-8?B?NE9oWmEyQ0pVL0dpS1dhKzZpdzNJZWd2Mm1OYWxJaGtlUGlDSFdXeU9zMU5S?=
 =?utf-8?B?Sm0wRXZOdWxWelpuZ2V4MHRNR04yTjFLZzFmR1VJUzdTZzY0bi8vY2Uzaklm?=
 =?utf-8?B?Zm1BbXc5SG9uNFdjaFZlRkI1WEo0cEFwNnhRQmdMamxIL05TOTEydlBKYmcr?=
 =?utf-8?B?ZFhMQm84QVVLSXZ5VlNCRE9GcTlteFRScmJzdnN3RjNzNC83WFlxTmxxb3Yy?=
 =?utf-8?B?cEtTaXQrZVdRcVVHKzMwRTZGVmRieFlJMUdjcTcyeFRwY3BzYmVrcnZRM1pi?=
 =?utf-8?B?b1I4dUl3cm1IVHIya2FqSWgzZkVma3hUL0lPbGxVczdFZXQwamo4anhRSkts?=
 =?utf-8?B?a2dwNVQ5dnMrc3gwS0tJYis3Nzl1QnIzMjU4cklDUm1wbS9oOXE1VzBHYXVn?=
 =?utf-8?B?YkZzT1VXekpwc20vY3FVcENnbmxJdFJpMGgxcVRlM2RHSXRnalg3dHdwTlFM?=
 =?utf-8?Q?dItIPiOEd5lrxMeszCsEFwiLD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a4f16fb-f30e-451d-8c38-08da8b1352ce
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 05:40:33.9066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ynvvJ3g8pEukcHqD9Wp02h6Cklo7CKlfQlcVAVco/ikL5Db3lxLq8HIBiphEL7mF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4227
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-08-30 3:20 PM, Roi Dayan wrote:
> In the cited commit the function mlx5e_rep_add_meta_tunnel_rule()
> was added and in success flow, err was returned uninitialized.
> Fix it.
> 
> Fixes: 430e2d5e2a98 ("net/mlx5: E-Switch, Move send to vport meta rule creation")
> Reported-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Maor Dickman <maord@nvidia.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 10 +++-------
>   1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> index 914bddbfc1d7..e09bca78df75 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
> @@ -471,22 +471,18 @@ mlx5e_rep_add_meta_tunnel_rule(struct mlx5e_priv *priv)
>   	struct mlx5_eswitch_rep *rep = rpriv->rep;
>   	struct mlx5_flow_handle *flow_rule;
>   	struct mlx5_flow_group *g;
> -	int err;
>   
>   	g = esw->fdb_table.offloads.send_to_vport_meta_grp;
>   	if (!g)
>   		return 0;
>   
>   	flow_rule = mlx5_eswitch_add_send_to_vport_meta_rule(esw, rep->vport);
> -	if (IS_ERR(flow_rule)) {
> -		err = PTR_ERR(flow_rule);
> -		goto out;
> -	}
> +	if (IS_ERR(flow_rule))
> +		return PTR_ERR(flow_rule);
>   
>   	rpriv->send_to_vport_meta_rule = flow_rule;
>   
> -out:
> -	return err;
> +	return 0;
>   }
>   
>   static void

just noticed same patch from Nathan Chancellor.
so can ignore this one.

[PATCH net-next] net/mlx5e: Do not use err uninitialized in 
mlx5e_rep_add_meta_tunnel_rule()
