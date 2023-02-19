Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F06E69BEDB
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 08:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjBSHIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 02:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBSHIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 02:08:50 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2058.outbound.protection.outlook.com [40.107.95.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DE71117C;
        Sat, 18 Feb 2023 23:08:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ImLdlZDviFgPbaVlowaeF6FfLB8MiGZH+0uJ6XhIglksk7q4oCzFij2N0gMT/BXlIYD+d//K06P5DEHZ5dM87KQlzNoV+5wSyEQI1gRwmRl6Nz9gNN/+8GpT4JYQi2tP07uJHhNOj4Hk43w9Z+FKkYa0HZvSX8zUCINx4Fyx2oP8iBcZq+2WprH5OZ8SPsJrinVzu/6r8wBTv5r6qKc0XUQiuccKtkNwKqyGhYLnHtOtCfa/ml1BwDtgxHKhCVYbmyEdO071yTd5c8gv2rb3YRFu9iJBYGivV+PmRawMR13CR/tUqpNjflacQlDdYQ8N5GMBo0BVuVwYfPqrZwK6cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=urLg0GQbPHbtkmqv0EAxjEGnXf5zCLkIWiZXS/Kk16c=;
 b=W1up/yIBJdWNUO+0DWyZBA5bEWLIVPkcXqa97xSmir7xoxs9GS65hNxpLvN5Rj8LhjR397vt82BOgmgttidMtFbAOXjiO3tw0lMT79eZMDsYfcmBXXKo4Pa139fLDOhRjVxNNqzQbDlTnD4jfV0OWFsIr6sJv0+rIzxTWxxmSmcI2GBJorajRvopkYSuFKQS27/NIW+v9N8qrlpqylQUzI7gYXRFfsgQK7apQpdGfHs4E5o9pIq5hBd8VqKaRKO8X9TgwuDbqx1cprZNKIk4xGIQCpLFL+O4ZVxuLvleBZpqoCp07pI5iKfSIAN844DFPO6WSib2i5NQFO9AW8kL0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urLg0GQbPHbtkmqv0EAxjEGnXf5zCLkIWiZXS/Kk16c=;
 b=FwPCDO4Oo70iKQViHwSllxEEG6rP0rnfENO8Qrc2zOQPnD4e9R1K76iWx+DzFoxe+Glu2G4HWt6d2T7Bh6Bg4Q79Xs8pA5Y9EFwpuJRXylMPyeDzOGbhxV6anWwMZy7k6+xRlCSWG++sQwyqlmNFSz3s1Lt4OcmHpoJ4sX6qBEtgoguvW/aYIM270atqawQnc6eM3bb4uzC/H4t8v7HNYY5qdEBYUqTfnxSDHZiO5hOlPUF/4VPMZ9BGCDiFkj0gkalZAOUQNwF++C1Uuuz1/437B+5DHEmw+uqPjEadyNjF4midGLX5aKgBcYIFw4Xr1Jhnn8PAZ0KuYp/a8EV9Gg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by DS7PR12MB6357.namprd12.prod.outlook.com (2603:10b6:8:96::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Sun, 19 Feb
 2023 07:08:47 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::9ac7:2373:addf:14ec]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::9ac7:2373:addf:14ec%3]) with mapi id 15.20.6111.018; Sun, 19 Feb 2023
 07:08:46 +0000
Message-ID: <f383c515-200e-ae09-755f-c5de1d9ad775@nvidia.com>
Date:   Sun, 19 Feb 2023 09:08:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:110.0) Gecko/20100101
 Thunderbird/110.0
Subject: Re: [PATCH net-next] net/mlx5e: TC, fix return value check in
 mlx5e_tc_act_stats_create()
Content-Language: en-US
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Cc:     saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ozsh@nvidia.com, liwei391@huawei.com
References: <20230217031301.4024714-1-yangyingliang@huawei.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20230217031301.4024714-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0088.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::28) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5330:EE_|DS7PR12MB6357:EE_
X-MS-Office365-Filtering-Correlation-Id: 01679bd6-b547-4541-890f-08db12482469
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v6CDsA23HEZh4qBq9HRzU/uH16Jii5rXwhm76yyTaEeHQ2i3gmZ+OCDV4gCLtVxi3BZzSSBLbnNjcc5n0RARD6CZYLtpDFrpPQSzRl2bKtwCguTBRPA6MQ3wAG3CMY0Tz4/f4iBK8iErzCUYVxn2qc110jUTcHTEEA6AvJvgMmuy9UZtRsbg91glworKp3eGcuuMr+vEigtd/J7bBjV+o/aRbr1HGQaOU32Awixhihjh+6H/imNJNXM5uzvS0GtA6Dtc2jHeLCykcHRGvcRScXYrOKkFfftHGjUQmQAPK8XCkNbIkXfW4lt10JjW2W6rP0NQJVjRSO8YVcvlVkoqdCtM9AkgoZioBW9Al4boD31/D66+Sm0aEB2ItahLe211daw5ZCt3xbcmMRZP0CBKMwL+tGb6Cva/0TpZpeM3/LQmUeAub7T3BH2ahc4ScmLZ9ZpeiRJLoPnS4DN7WfBUR9JOhiHxtRPfA78UOzJ+aWUnyQWszT8jah2bt0HZRrnpaY9czhReW/lREvd3HmL8ksgY78bLz+wbnqAZhlcxu+7FPDYiIolqchqNPgWzknjK+eh0l7L1ygfIatQjCpMpONJkemDcLiaOg0e6ohUrLwnHbd24FdWbd+uyyUw84T72/Qc4n8wauDyxM6aOC0wAAIAreg0o71+jjDa9JFgfypoFmbSFBcX3TssjGersufCR34oU6OOqvdZwvGsso1IHjK2NHfumjr6LxAffAbwJ5q8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(451199018)(31686004)(86362001)(31696002)(36756003)(8676002)(66946007)(4326008)(2906002)(66556008)(66476007)(8936002)(5660300002)(41300700001)(38100700002)(6666004)(478600001)(6486002)(316002)(83380400001)(2616005)(26005)(6512007)(53546011)(186003)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eFVvaVB4RkZLOEhIT1k5K2l3dnh1MGNUWGF0Nys4YUVvbVZ4dlUyUTg3dUVq?=
 =?utf-8?B?QTVycGdBdGprczM2N0NMQ2k3cjBxOUdoc2NDSnJLdGxYU0VIeWxmV2J0NFB0?=
 =?utf-8?B?N2toRitwOUp4Q3llQkhrNVBKOU41SmtGSTkwUDVNYm1UKzlTYmhzMWtqRCsx?=
 =?utf-8?B?bE5CNmNpeVZqcldEZkZsRVNGbmRweEVHNEw0VUZRVWNLOUo5RkZUMk1YNFZk?=
 =?utf-8?B?RnBGS2tuSzZBUSszR0NSRU9rRkZIUngyaW9YVjhYVFFKZGcyc1pNbFV6R2VL?=
 =?utf-8?B?WXJyVVg3R2FXdTJDcTljNGVxT3hQUHpJL3NuNGc1MW1sTUhBYWF5cERncVBC?=
 =?utf-8?B?Rm5UK3pQWUpscWx0YWcrNkQrSHh1SndOeDg5NUdVVFcrTURpRnJ3UGJSaFRv?=
 =?utf-8?B?cXBrcVoxNFg3SXgwOTdOb2dZM0NxVEhBWmxMdWZOZFEwWlRaRnhrQkZMZmh1?=
 =?utf-8?B?MDBYaU9VVExObngzblBCcWowTDU2bmtyYzhxenpqUzh4ZGp0MnZjRm9WcStT?=
 =?utf-8?B?dEhPVWRueGxCem81MHZQbzRFU3BGbFZPWGNCcWkwUURmYjRwNWJ5Z01hNE1F?=
 =?utf-8?B?N2xCUkplOVE1Z1ZVOWcxL0w2eGNLZWJWOWdORWtvNWRmdzg0K1JBS200Qjdn?=
 =?utf-8?B?ZVk2cHAwTkxmb3E1R3ptRExaaGc0NTBPclRFMXJ5QXM0YWU2NUdqai9HMDZy?=
 =?utf-8?B?V2d6S3NNU3Jwa25GWkptR1FGRGppVTJFNHg5QXVJNFl5MG5YLytEVWR4Q1Yx?=
 =?utf-8?B?NjVtUUJ5VVRIaVgySlRMNEhHTWx4bkFRVXlUOUhnNDdYbnlYQ2UrWnZOTjJv?=
 =?utf-8?B?NFVBWmdHS05wM2JmaFY3SmQ3eWdzbnI2VnJCeldDNnJJTkM5TlBoeHY3VlZF?=
 =?utf-8?B?VEJMakFIK0pkTDgyUEQyME9IdDg1blBJaytFc3p1UnBGZTB1b3Iza1lDY3Nn?=
 =?utf-8?B?Q3MxRnQwYjlGSG5lQytDbTBZUGVHdnUrRis5b3hNNTNySVV5RHFybWd0dUhl?=
 =?utf-8?B?OEFPalJOL2Y0aUhOUGxSci9UMHFCVGFLeXBLdktwa01QZmxHbHFydGRsY1pP?=
 =?utf-8?B?SjZYelFhS0o5T1hWclJHUEJTNlErSmZhOVg2QW44RUhVMmFtaUxWamkrQUZt?=
 =?utf-8?B?czQ3aVozazBQS1NpTnNVbm9xWmZ5aUwvV0dHZHJrK25aVWFVMlFGUVZMY0F4?=
 =?utf-8?B?bzJhYjR2WGFQMWdIRGU0a0dWOWg2TG9vTHduNjRuZnFmM1NUM3JId3ZVK3FV?=
 =?utf-8?B?WS8rbklqanVvWUhlRklEa2ZiWmVSU0gxcmdyS25hUjdIbVFBV09HbHhma1B2?=
 =?utf-8?B?MzBJb2hLNXVucTRxek9HM1BOa3pLNHJERW1Kc24yTERhUy93aXFpZFR2a2dU?=
 =?utf-8?B?bDQrK08vSzRlR24xM2ZYM2czQ2VMTlR4KzRJWFVWbzJsMzdGNjBORksrT1pw?=
 =?utf-8?B?RjNlZzRaNzlDOFgyN1BkdGlTdGhvbTJTYlREeGo2SHhzNGZ2bFBGblMreklZ?=
 =?utf-8?B?c0NhWXF0c2FwdFU5dGErc3R0WU5nclBWYlhWWGRjZGhPbjB6U2ZzK1pEaWQy?=
 =?utf-8?B?elVQTDZGYmJqUUhEY1NFVUsxNmMxSzNQMFRWYXA1NVkwYjZXalUzbS9hWGEx?=
 =?utf-8?B?ZUVVMFZPenRJRFFaRHVHMFVHUzhZeU1hS1Rqbk1TUmY3eGhJTGYxcktHRGhS?=
 =?utf-8?B?UTdneHpTdVlkVVFuODZqc1lPdC9XTDBlZ25BWllHcERFSHlRZEdvV2EzaGRZ?=
 =?utf-8?B?ajgrQlVrRVNwajdEZHZVYU9rY2NXRHMyZXRqbk1CMitjY2NqTy9weFJrdlRz?=
 =?utf-8?B?aHB5T3lmRnhEQWtMT0E2aS9CTXorOEl4UjNsQXV0RzgrK1N3QktvellVMEVt?=
 =?utf-8?B?ZjFvUGZnSEcrbUsxMG10VDkxSHRkeWJFY2phNGhORjRDM1VrbkR6UDFUN1Jx?=
 =?utf-8?B?ZlI5WWZqSU16QzEvWm9EemJ4R0g3Ym9xVkdVbjRWeFZRQ2FPSVFTYTJ2UGJR?=
 =?utf-8?B?cEl1ZlRndjFRSDB3MVBNSGdKV2ZaQUpVR3FhYWtER0IzMmh2VXRNZzQwanFU?=
 =?utf-8?B?d2xwSnMrOThsR0dXcTBqNXQ5emtHdGs2Z2JHakF3dEdOYkZ5U29adTF0b2tI?=
 =?utf-8?Q?gXffQpPruAsGWvtiiQkrhITeP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01679bd6-b547-4541-890f-08db12482469
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 07:08:46.3711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BiKejXRMeL3AoHDyTy00yOfVvC6yzIul2kmnuZFPGKnHxvW5lkxikGsV/tpiDDNt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6357
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17/02/2023 5:13, Yang Yingliang wrote:
> kvzalloc() returns NULL pointer not PTR_ERR() when it fails,
> so replace the IS_ERR() check with NULL pointer check.
> 
> Fixes: d13674b1d14c ("net/mlx5e: TC, map tc action cookie to a hw counter")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
> index f71766dca660..626cb7470fa5 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
> @@ -37,7 +37,7 @@ mlx5e_tc_act_stats_create(void)
>  	int err;
>  
>  	handle = kvzalloc(sizeof(*handle), GFP_KERNEL);
> -	if (IS_ERR(handle))
> +	if (!handle)
>  		return ERR_PTR(-ENOMEM);
>  
>  	err = rhashtable_init(&handle->ht, &act_counters_ht_params);

thanks

Reviewed-by: Roi Dayan <roid@nvidia.com>
