Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFB0677B26
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 13:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbjAWMix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 07:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbjAWMiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 07:38:52 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B03EB5D
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 04:38:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jPcFLOrZU3IPx3A4c3ipvx8on3g0Ogj9nH8zugZNzl1V9jSokT4X9+4hPmvV6V8CNqDZW5sYxrb774kkO26UEjZFyM0T9CqDjq19xlZWmSKqBX86PnbX2YsNFwCA1ogQxyXbRreGTYbRaJslxp03svZ3jZ7Q6EYVfTbwIgtyks98cpTPKw3Ydr+5Aokzu+ARjbK9ijaw1VbukJu0BQGjUx3fdxRZ1EDM7EiVJ/MSzuXUiPKwjpVjLXl8cwqejJdVR2Zs/NB/KSKxYIhF2ukzWJRd0A5oUtrJ55og583ilvHkaGCEBuXAI10LFLBretqJ2HYZ8XsFlUMFIyg1vYLMYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=boQp+r+42GQBqSfJRE6OoE8bse/TZZRsjSkgwV2jQhs=;
 b=DCAqc5PxnloI5Svrp+nsr0/jrA8NBZn7y9RTiBY78QYJRaEMWmUownAlvXPPKh4hfhH2aiRaX1XpbsRnPoVwRqhPsr5Radrr9rcwqmM+R24rUOoQMnE2mnV9kp10LZBgeRUpQlzIBc+WoivAxXKw3C93yEfv1LP1QhBnZd1D2gIi67mrXx8T9+YJic9GLWvJXbGXPjXIpHr6hnYvIz25n0eGULviHbLI65NaeEdYHZRWIeIJqrycYKo0O3f5v8ak5BLlgineTRa2D5WvdNvrr9eEyen37TKOQmS4ikuHhMPzZYgDv7CYeur06RddPea/LCBamA7nmOF1vn8RpQqF/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=boQp+r+42GQBqSfJRE6OoE8bse/TZZRsjSkgwV2jQhs=;
 b=TM3YN7gu9wXdrDdEzV3ZfJxPqumQxv5Q8R9PsPvsoDTotdPDTgTqghTxTckc70Srt9O7DaWDWFPlBnxUwZBGF4u7PBdIKTPYyzQtpzB1NdODDjkCajc0QivB5aUZAHssapNPMBOIqYwHZeDTOTnp1ydbtf1d7GT7GBx6VaIl9zD3HeOOw0yFGYz91o8B14HlNg0zlppKg2y+KyQwIlu6Qh0S+jFqnB326C+1UHk1TyiQmPjnDoXyQGMeeRLg8aJzshV94CWhF010ggCT9CkbVQ3BSmEMtxGaXHd3/r1vk3CP6kmtJWkBUt5NEMzRZRvZhDyuVcCNVzJzwU/oTkes1Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 PH8PR12MB7160.namprd12.prod.outlook.com (2603:10b6:510:228::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.33; Mon, 23 Jan 2023 12:38:42 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9%3]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 12:38:42 +0000
Message-ID: <8537aa82-8ac9-3f76-c8ae-395a60ccddf8@nvidia.com>
Date:   Mon, 23 Jan 2023 14:38:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net 2/2] mlx5: fix skb leak while fifo resync
Content-Language: en-US
To:     Vadim Fedorenko <vadfed@meta.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20230122161602.1958577-1-vadfed@meta.com>
 <20230122161602.1958577-3-vadfed@meta.com>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20230122161602.1958577-3-vadfed@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0121.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:97::19) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|PH8PR12MB7160:EE_
X-MS-Office365-Filtering-Correlation-Id: c4069c94-9578-4139-e2a1-08dafd3ec256
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JbAotwPNdYVeBd3TjCAjTvUIyEMCV91LBJdr4Gi9YZyH4bhIsHEJOov4NP+JXrEtJr7DOWsx9AEIMbFoZzARj9UAVp7gkmjAj7G0FkYZGz3CBDr6Ty8hHIzdlcvv6YYxXrb2Bud77t6RIbraOlpa7HmuDIcY5Vv4v7EfrMME55jcNez1Jtq1w9OGjLfyYcepgta25hUaknokzbFnBNc1c+tGrOs1TTsuJJC/qrx8CEuoavr59FiCTlAj5+yKc/th7HyCfForawEW12/q9lHP4fGd2SeuFsrpcWcOiKAw6rWjPHFozrttn1LhWrDeY95OzZDZ/bfXeefcHn5lGuM4UU/pQdkQp1OqNKv+JWm9q1ZX3jDTXH/v1wxw/kMcaX8BIID1CZB81B+nk0I1X3s9rhBZwvdC1PLyZzoLPogpEj2NN4YlukxkFaEQJa41syoRa69ASQZCrYYSg6ESmGohOIZiApNRDA35ZE8Hod8FCzJX09FG+LJdaY9LQOqGyYQkzDzml7hZB6pzxh3McbTHy6ldeSsHpzk2MPVLiJXTbSpaHoeIWBbtkghvb+6MnPz+2j7t6kYErt/O5zUS6KxmDY6TlYoEvrH1ozXzuc3HjM38mUbyuYz+lobZfXPyIKDxZtvdx38Bskq1aNVxTa+yWg8u8K3oCTG0DGr8tq1zpiXaWAhgjDw5pG0BPhJ+9i+IzAqe0xm/r4Jz2hgqpf7rbG22S+VvRMVBw7z6R3rbfxs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(451199015)(36756003)(31696002)(41300700001)(86362001)(5660300002)(8936002)(4326008)(2906002)(38100700002)(6486002)(110136005)(478600001)(31686004)(8676002)(26005)(53546011)(186003)(6512007)(6506007)(316002)(66556008)(66946007)(2616005)(6666004)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OFFmTjFCUlR4bmNBQWoxaFUzc2s4bElZNEdJcFpMNHVycnU0UlBEZTNwMmZo?=
 =?utf-8?B?VDNySG8rQkdVbDdiVzRBK3dYRDRxR3J6eWcwMnNWYU85Y1R6SnhQVHBaVlZX?=
 =?utf-8?B?V294aVp3VXhHcGpNaFJxa2d2djc3a2srczl0TitKMVhOdFVmRFhVWW1jMXd3?=
 =?utf-8?B?ZVB6K1dkUWxUTDFKM0pPTVR3RFo0NnE3RENDcU1lWHhHZ3BvTGtLVVRuYVZX?=
 =?utf-8?B?RHVLQlpVYlo1K1NTU20zdUZkVUpNRlhVOWNZTDI3eXNDZ2JYWVFkSHQyaEk3?=
 =?utf-8?B?R1M0YXJSZmU4SDB1b21EWFUrT09jNXZ1RnBIckN6OFB6RXViMEZFNy9ZMXND?=
 =?utf-8?B?MVdMWHhaQndaTFZiQ1RmY1cvUUJvbis1OHh2ZHM5OUFpeGhhWkFKV0lRMTl2?=
 =?utf-8?B?VndIRUJFRjR3UG1tc29paitOZVF4MWpjbnBTUmdDWFBYNUFNUXNkVFgrQld6?=
 =?utf-8?B?VmxFWGtvVENoZVNhVXU5ZGplMlVzcFJxb1IvcSswRHEwemU2N0VxbWtBQVRY?=
 =?utf-8?B?eWJoOVR5dERIaWlWL2dQcnd6bDRpd2ZVWG84VFdZZlBxdUJiaGhjNlFIajEw?=
 =?utf-8?B?UFNVdy9pTThJcFFacHlHY1BNMlJYcDIxUWN1WVBqWTdIYldXdjR5WTY3QTUx?=
 =?utf-8?B?YXdpVUlTUVZnM3UzSnBHb1BNT1FMbDBXQ3l1ZlVWa1owdGNtVkkrNlIxZGFG?=
 =?utf-8?B?L09SL0E0YUZJSTRiTlJXZU5HeFhaZkFtUzZDQ2NoVitkRFZKbHZNdC8wZUQ5?=
 =?utf-8?B?RUtTdXdQcmoxS1BJSTcyZisxeVMwbyt6WEF0WGpBcEFRaXQ1bW5sU3IwNjFi?=
 =?utf-8?B?bVQ2eXk2d3lUUExsTytMYTFDSVlRYnhHemExaFRKK0owMUw1QWJ6Q2o4cHR0?=
 =?utf-8?B?eWU2cUcyZk16SERQbFg4YzZYRGFaUzUvUzY4RlVjMTRLb01ZZW5LWFRsREM5?=
 =?utf-8?B?c1I3OHArYWhUK2lLNHMxZ1RjWjdUVlY1QVVaM1Z2RTVia29US3FEYjlLa2dh?=
 =?utf-8?B?a2llOHRwZUZUd1dtdTlhQWIwbW1qUmtnSSt3Z1RlUWtBMHp1bmpnaVI3NjlJ?=
 =?utf-8?B?bm9wQ1JiS3E3NVFvem13R2hCcS8wSjdZejZIOU10NXdIZ20vY3ZveWpzdEgw?=
 =?utf-8?B?L2tnY2hiMTRLSnJiOS9zTUxSYmp4MTdlS3UycXdSOU81TmRkVnFuOUVDWStY?=
 =?utf-8?B?UnU3K1JNMUxIdndrWDZnTFJpUTA0V0g3dzZyb2xkNjlseDQweDhRZHYyM1J2?=
 =?utf-8?B?VlJVajhTN3o0OE1yR0Nycm9QSll2YlZaa2xwbWlIeVo5Yk9JRndtY2loZVpw?=
 =?utf-8?B?eDFPMjZxU1RRTFFydGRTNnBjRUR4N25zcTArQTFpWEFPeGF1UE51aVQvM3Fl?=
 =?utf-8?B?Z0ppZUNjSFRhUjdHK3lST3l1QXc4WXNqZk5MMnlRTitjV2ptcjMvWDYrcSti?=
 =?utf-8?B?Tys4RTk3aG84dkRFbjY0SkVUY1FiTzZLZGdaRlFJbGJGdUJZREV3OTVMdmlT?=
 =?utf-8?B?bVlROXE0a0MrR2tnblk3VGlCSkI2N0IyRzFZTjVNS3h2T2kybGpRb1RHcCtX?=
 =?utf-8?B?WW9ZLytBdzdWWVhoM0VQbFVvVTVxVElXNzd1OFVjeVZSdWxnUzVvcHJ0VW9C?=
 =?utf-8?B?R3BGbXNFTUQxS0FxbUlLZHBkQXprVzhVT3hqMk9ZQnNTZzM3MUpJMWMrdTFK?=
 =?utf-8?B?NGlJamlVYjlEbCtYUE9wSmgzOUVHMFc3WHJVakUrd1BHYXR4eDlUbmdZb2tz?=
 =?utf-8?B?b0pwUEdDSXlqUXB5UGV0ZkNLWXJRM1o3cnVDWUxScU9haS83eFFGREhOOFFo?=
 =?utf-8?B?RWUySk13bW5GVlBMVlFHUXZwMTJqenVudmIrTW9KTnY4T3psSzM0a2NxVHhu?=
 =?utf-8?B?c3YwWUpKclBvZEFIZlFjK2h5SUJYOXpOZ0M2OGpiN3RKWGtScnpwenJmNEUy?=
 =?utf-8?B?TkNRWTFMalM0K1czdFovV1NNeGZudzdGUFdKTGNTeDJVK0M3OGlVb0c3dGNk?=
 =?utf-8?B?bkJWTFprMW01RC9VbE9oYlE0SEtWTStydXpnaGdGcnFCYjJOMWpXNGpneFVT?=
 =?utf-8?B?aFpxSExCckpNV0ZvZ2p5UlJOUk1WOTRkUmFYOTBuQ0VnV0ZwOTNqZW5ROUE4?=
 =?utf-8?Q?ZQyWYh9cQE2DcoHkL248ZXsUk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4069c94-9578-4139-e2a1-08dafd3ec256
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 12:38:41.9444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jk6B03IPtfFrCka82FfIzRDuDf7xtVEN45fZkNf4XjCcSzqkRMi7i+vrhc3Mc2Id
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7160
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/01/2023 18:16, Vadim Fedorenko wrote:
> During ptp resync operation SKBs were poped from the fifo but were never
> freed neither by napi_consume nor by dev_kfree_skb_any. Add call to
> napi_consume_skb to properly free SKBs.
> 
> Fixes: 19b43a432e3e ("net/mlx5e: Extend SKB room check to include PTP-SQ")

Same comment as previous patch?

> Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
> index 11a99e0f00c6..d60bb997c53b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
> @@ -102,6 +102,7 @@ static bool mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_
>  		hwts.hwtstamp = mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp;
>  		skb_tstamp_tx(skb, &hwts);
>  		ptpsq->cq_stats->resync_cqe++;
> +		napi_consume_skb(skb, 1);

Was wondering whether we should pass the actual budget here instead of
1, but looking at napi_consume_skb() it doesn't really matter..

Anyway:
Reviewed-by: Gal Pressman <gal@nvidia.com>

>  		skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
>  	}
>  
