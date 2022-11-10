Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA07624493
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 15:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbiKJOoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 09:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiKJOoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 09:44:03 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1DE20BD5;
        Thu, 10 Nov 2022 06:44:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xx/XsDAHRccBMfolYRB6mXxe4bfKFUxh2URzRwyT9BYyWLXsRmNr+IykQD3aG3ymTngBaoYwzWeBIgfWsJx8NjMbhil+GSod+y79vMe2BakIveqTZKISjz0S5n4dZwToQgrT+Jgk/xoA5lVYkasSs2eJ4qffibN/T0/G+gY7Us9zpdhxuSMTHJDO09FDnpo721CTYRCrldjaGTtEdWmOHTxQG8EIDqh9yt8wO9VSlcj19hT9pVspIPS9J7Fxv2ZB8+SfVLjNx1cOYRGbMEpAhAOrWBO4hxbzwQ4Zw2Vpctt+wBDcXUg/5jVJj4HTpsqxFfcpyraT/dlWH6mV2Oivtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VdpW10wksxLxH5VyXFrV5YTx/oG2JSMvpALZPpMUYNw=;
 b=idcRFJnOkpCrCkWmzyt9Ci0s/Pb2xUdmpiyKQNXCE0bR/iBjRMIzRXmxioRaRutyLJhhgfH5aclyjlNrBuGzBpMKDkQ41LIyDZn9EjJFW09OeZUdAe3QlN0ui7p8uHHa0WXkf/tgfgFxJEE8Bx3TbMFjSwnoaAcgcdEJ7xxxDyHyA1TRoQDs3wzc8QDq4vQVARyIpJdK0v1P+/e+cXlOuXHPrmkBy9FbKC4F9XR1E/TF5fpGhoiRZWHc75zkm976EUyEa9VZmnEZb/YDqR2W/MvXOZG4kvL5j78aueT+rOIDt6XyHWitvY7b5FrGR/flzSsTe3iGrzpNAxGco/PU+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VdpW10wksxLxH5VyXFrV5YTx/oG2JSMvpALZPpMUYNw=;
 b=ILaW/+4tYhnj78372fwoyeJjzZXs5n4BYy1WNb1EICBFDzrqSAjWPIDY07d2FNa1myqB3zrCs9xQEkkBDTVDFxQWG2V2gxni7WI5SjQmOznSUjlV6tKSRlAy6jdz7Rt60mInVba8fcv94hKnX75jLbRAQzIb9u022YftLGjFKZbEGRnRJkFt2DK+3LQu9/1mw45PmAZFU3RenpOIUpZHmcQMd6DerN0HGYQEbdYNsSXcQuk4QyudaoQtkBxaztboFO6PlRMtM+y2HzNSdjaEHL1fNrBhEFJwH9EqadPVFHOpcTnuOft0sfWdHT9PqpAFwn7Gdgi8pB5qnF/t4j7F4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by BN9PR12MB5083.namprd12.prod.outlook.com (2603:10b6:408:134::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 14:44:00 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::eabd:c1b9:a96f:9bfa]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::eabd:c1b9:a96f:9bfa%5]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 14:44:00 +0000
Message-ID: <613ca9c7-399b-08ac-8333-907128511e80@nvidia.com>
Date:   Thu, 10 Nov 2022 16:43:53 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:107.0) Gecko/20100101
 Thunderbird/107.0
Subject: Re: [PATCH v2] net/mlx5: DR, Fix uninitialized var warning
Content-Language: en-US
To:     YueHaibing <yuehaibing@huawei.com>, saeedm@nvidia.com,
        leon@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kliteyn@nvidia.com,
        mbloch@nvidia.com, erezsh@mellanox.com, valex@nvidia.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221110134707.43740-1-yuehaibing@huawei.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20221110134707.43740-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0547.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::16) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5330:EE_|BN9PR12MB5083:EE_
X-MS-Office365-Filtering-Correlation-Id: 5853992d-920c-4433-e978-08dac32a00f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JIK1pFyTW52qR20QLd2UrFySRXMc+RhRHTCswpRr3xMh6VAxL7WV/HjO3Pj/tEeN7qbJ+W3nkjqULusr/UOvvDnoFjL3UebPXFO/7k/FVeQl8qdS1vYKtK/mxW7zW4kxDWxSq6A1epli86Mh8r5FPBpZfoV2VmveCtHCWA7ysY7T45L9/g4p/iTHCe3DEOXRQIdoKgNeR3gDqaYTVKEyBuzFdQWWk4sJqtgNhWUhr/Gy1BMXmd5R/5e2huJc6NHV1degJXtLOWfEMdXQonQM1XKcI72vnWSzCsqozOGrV3MCGBM9ELkmC6P5yvbaAi1V4iNjPtzlvBIXfTvjkwOF5nNf9/Kkdpab4Fm6BzeO0TXg9PpdmOzzc6xWdNdl6p2MQOSkVdN6+iEkge35wAjTdnU8TMaCoEItFtoGhH8MirzrfvHJR8Cn8kwGGNaGPDX9k+koTSr9W5dJ9kBMXiQbAL0qvBXjhAjhgqZ7GJNtWJw7ySoJh72yKID+W/4OpdDVPAactCVONy/Sxwrq1d2jGFEBUv3NGP7F6FbAmDDruNQPEjLisL5xV0lPDsBfU4h68rDKoKI4OSgbSJXkT156yeBysryvsG5e1INCVYTh24gwxW+12aZ2G1dMgTcdQ/RIMVL1H/HJ6rhm1CI5fZPo+nZ1j940QIvYELrh6AemK/srCnzYCejmJf5Bjd6Lzoq2Mr+Okho2iUQiPRb7TJxrkMe6hpG4wxXiLRWBLdql6AgeIdhausjE7GiC2vFVKNVAhS+hqhswF/6ZKEGyVazunHXEeErbQ2VdSCxfdGBvwgYPY73/a3etbhmseuBgaq5/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(396003)(346002)(366004)(451199015)(31686004)(36756003)(83380400001)(2906002)(38100700002)(5660300002)(921005)(66946007)(31696002)(86362001)(8676002)(41300700001)(6636002)(66556008)(66476007)(316002)(26005)(6486002)(4326008)(6512007)(186003)(8936002)(2616005)(53546011)(6506007)(478600001)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UTF6V2FVZ0ZTVklJOWE3NmtxdGE3QW1MNzVkNHgvb3RISFc5TG40SWp0WlNW?=
 =?utf-8?B?OVhKS21lL1l4OHBNM2lLcmtkK1d3L1FRRG8rMTM3d3BXNm9od3ZPVzBCajg0?=
 =?utf-8?B?RmZHbTd4K2tsUnhQRXdVZjQvVFNORExaU3RhZFFCT25CRW83dmw5U0kyUnhw?=
 =?utf-8?B?KzJBNkVGQWlCejR3bHhMVWVZOEQrYTNpWkdYSzVxN0VjZFRndVVtVFM2b0ox?=
 =?utf-8?B?SXpsYXRmL3BxakppRTRwKzkrZ3IvOHN6MTNnRGU2c2lRNWcrQTEwdDFkcnRS?=
 =?utf-8?B?bEd1eVlhY1pDMXVMNTM2enlWbjA2UEtZbHBySVBWVjB5LzBlTGFWR3p1QWRM?=
 =?utf-8?B?RkIrc1NQWnA1eXFIR0ZDbXNrN2ZPSmh4Qnp1cDkvSnROOGZxc000anMzSjFx?=
 =?utf-8?B?VmVEbG1DUGdGQmpUZkd2VWxsTTBjbDRhdDRGeVdOVmFwWUN4MmlpWWFmOU5w?=
 =?utf-8?B?eEdtTFpQdzNXT0wrQk8zNzdnY0NqRENCYTl1aFdGanZhSnQzZlpKalhWUXlP?=
 =?utf-8?B?bVhkWmNSb1Y1NE5zOFVjazJYUXloNHZtVGtkUDVyS2RGVXd6K0NnS29hU3Ji?=
 =?utf-8?B?SEFQWkxQSEJwc2dQajZ2YmxsVTZDb05VVVdoUnhQdlIzTUpqejZoRzJ1VUVW?=
 =?utf-8?B?T3dNTjlKZjVjVStxQlpqcWwwTVZWd1ZZdW9KamNFcFNGdXlCQnM3ay9XQzdF?=
 =?utf-8?B?MjJkOWY1bEs3NnFUbDZxb2FiT05rclRPNkpwdmlDa2phNmpGY3FjeGRIQnRy?=
 =?utf-8?B?cjV2V2llZGpTUWZvZFVUUzJjcHJTQTZJd0sybFkvVmxtTldubUp1SzRIWit4?=
 =?utf-8?B?L2FUWWFJUVNKcWg4aGlqZk1QMzYzRm9wdFJqaFN1bWVMNU9mZHJlaVNKZjc3?=
 =?utf-8?B?OGx2dXI4NWRlNXJod21LWG9lcVpseXRpazlqYmU5MFo0T0l6UGwyWEZ5MXZV?=
 =?utf-8?B?M3czc0pSeDlBYVFhTytvNnFPUldSNXluaFZrSWFjWlF0RUVSQzBWQjhQWGxq?=
 =?utf-8?B?dTk5RmtPSEpvaVBuQndlVkZBeHlHdGl0Sis0WlQ2SkwwdU14L3ZVWXVWaVA4?=
 =?utf-8?B?M2E2a3E3ZE14WXlyTk9NSytVbFRGaHpuTCt4K3lGR1d3UWk4LzR0ZGRZNDIy?=
 =?utf-8?B?NXErWDFVRFVUTGpwQ3ZnVjg3M1RUU201V1VlRVFaTFkwNU5wTWwxbmJPTk5M?=
 =?utf-8?B?bHRENGJ0VUdzR3pjbFczdWNoYjZNZ2F6YWZCcVhja3c5Q0hja3JyelZRTjZX?=
 =?utf-8?B?Uk42Y00zU2Y5QitZdzBWNGVvajcvMjlFSTBGdDNlbTQ0OE9BNC83Zm5lU3dT?=
 =?utf-8?B?Q29Rc0cyRGQ4djcyMkcvTHdUUWYzS2Qzbko5VCtKV3lPQmlrS2J0eGNodXFM?=
 =?utf-8?B?dWV2bjRBeWMvYjN0Y0NyS1kxdVpMa2tHRVRnSUZ5UHkzcm1LNng0Q3UvRWFY?=
 =?utf-8?B?T2NkcHpqQkhaL3ZZd0VvemV2NHZoaVdZVFEyeVVXemM1dWJPWEtzMTh4bXRU?=
 =?utf-8?B?dXF2amtHMHkreWZBblhKcnBNSVB6SkpEQnV4cTZzejRQYThodW5tUWF3Wmpz?=
 =?utf-8?B?WkNFUVF0L2lTTFA2MUpSQlYwZGpHZkVFemJWOGx5aVVDTE5qY0ZzMjVVYW11?=
 =?utf-8?B?SjYzbE1xVDNPWVU0cFJWQXBpR3JSeUVWdW1zVmFuRS9WajlJUzBxTXZvNWdl?=
 =?utf-8?B?UVlwZXh1eE4wU2xLVUZsNEtCSjdHZFptNUw5dkdDV3JHR041RGYwRGpqR3Nt?=
 =?utf-8?B?WGdCUlRPTjZPSmIyRTh2UzI5NHFtT0hYL05Oa3QyS2QzTFZTUGJaMUlkbkl0?=
 =?utf-8?B?VGoxNVNqR2lZeDhUa0dJZGZvTis0UTN4b0hlNGhRVHc4N0IxZWZUQ2tYOFY3?=
 =?utf-8?B?bVlpOEtwT1B0SnVBb3ljZ3ZWOWVjMjFET3o0YW9wSG1xbXdJTXlkMklCSzYw?=
 =?utf-8?B?Z2thS0NtQXl4UlZJSWdkZVhXbGNoSWtDVTBmcURLSTJwL09CSnE0aFRPMFAv?=
 =?utf-8?B?S3JNU3h6MDFFSG9uSlVoYnVna21wc3JQNTFwODVzcWtTTDJENHkweVVkbERs?=
 =?utf-8?B?MHNtT002STZoZGx4TzUvRlNtTFg3UTB1MEZ6Q3dodjJVSk5oOG93VlJaaFl0?=
 =?utf-8?Q?c6TvMayFpAtgu8A2LsRl2vXcu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5853992d-920c-4433-e978-08dac32a00f4
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 14:44:00.3608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qNIss9Mksocc649ibwcZchqnkHMKBCsQPtvQM9vffPWdEiqouniYnRS5Rov+Fosz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5083
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/11/2022 15:47, YueHaibing wrote:
> Smatch warns this:
> 
> drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c:81
>  mlx5dr_table_set_miss_action() error: uninitialized symbol 'ret'.
> 
> Initializing ret with -EOPNOTSUPP and fix missing action case.
> 
> Fixes: 7838e1725394 ("net/mlx5: DR, Expose steering table functionality")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
> v2: init ret to -EOPNOTSUPP
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
> index eb81759244d5..7cc4cb7fa392 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
> @@ -46,7 +46,7 @@ static int dr_table_set_miss_action_nic(struct mlx5dr_domain *dmn,
>  int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
>  				 struct mlx5dr_action *action)
>  {
> -	int ret;
> +	int ret = -EOPNOTSUPP;
>  
>  	if (action && action->action_type != DR_ACTION_TYP_FT)
>  		return -EOPNOTSUPP;
> @@ -67,6 +67,9 @@ int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
>  			goto out;
>  	}
>  
> +	if (ret)
> +		goto out;
> +
>  	/* Release old action */
>  	if (tbl->miss_action)
>  		refcount_dec(&tbl->miss_action->refcount);

thanks

Reviewed-by: Roi Dayan <roid@nvidia.com>
