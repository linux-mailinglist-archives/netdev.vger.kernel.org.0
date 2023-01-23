Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3FC677B01
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 13:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbjAWMdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 07:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbjAWMdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 07:33:15 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CBA1227B2
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 04:33:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yd4aQ6Wypab6xZCgVYmSNNQm9OwYSzen7Pnv09k2KKazS0kEf9vKv3JIap3qxa8ABGTEJCn0Zx+WFm7m3HxQbcbzJpXMv/qXJ0AF7pgUo1hN3p3r2Y4kEcCdMrXG0q905I6UrGwOp3jY/2v8lHKf+2NOnw3Q0YPGazm4fJgx92IJRqOgh5dxzromnzejesI15gYGSLu7BNKyK0O0sgnJmN8JfmQot+gebWJ8M0A/+0s4qB++Fos/vwmaG/ehy1ld+H5h94b3aS3IHUwxUMN4MBQCqHSOW/jUruDBp5JCNWF2kuwFh0/KlN6+ZWZL6SxzFKTXixbeOc0c4CHB6Ie7EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3XtlA3Y4gosBlI8dp17rXx2S8gyVGGzAlPSFD2PZ7pc=;
 b=FwQYOKhLCkMellh9+stgpzd4kpS0JCrYfBOKDTFGQPPqL11azV4J0BPbYs+BUU9uPHyCpNc8s++bwSK9+jS+PywjOMW8G7cpW6gYL7BNUpjZl26szoiB/QlkPv3ZJ4ty2y9VaDWLyZKtTna6dy9cCv9Ll04gRITaYkR0fnV09W3+oK0QxLHB9tMwZjrkXY0fw5+BrmqFyiLhwITo0wq+xytnpeJfsb7DERsecOynfvB50IeDqG48kqCdeJVBGSqKIMkiO5cX6raavOTdYQzmvIv0gmNPJEJO012eeS5ewUYOwPXiOa+WRGSMADbz6Q02Y6foq2UHrKhd/2Pv/S5vyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3XtlA3Y4gosBlI8dp17rXx2S8gyVGGzAlPSFD2PZ7pc=;
 b=N9wUddToCdhPvCAN4zNS8YxKW/yYqGm+T48zbvSk4wWS7uj5tp25F8OEmSUI5Cph1bq00DBdqZwuGxYa8qeY2GSEAmK7JjHrwhVSUIx7EKqydumGTiDyMFLbsjPyEsm0vLNVp910JAa/rM3J7nm41FB/osb1KDW+tFGEc3UuDmnz/TjpdUnplkIjA8Y28GvDmxrmQ6rtn2VxbRh4yBQz7S86rBTESZMrm5Ph6lGtgVTGRKcNtuLgJOrrI3LSf8DWs9d0LcmTB+xYApNJPFXVgsrkCoh05CeBNfHBx2vZqVSlrJzuIB6ICSHQRFX5G85aF0umRWgtgjrt8JFtk/iQhQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 SJ1PR12MB6195.namprd12.prod.outlook.com (2603:10b6:a03:457::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 12:33:00 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9%3]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 12:33:00 +0000
Message-ID: <220db544-01b5-ead7-bc57-b7c7d482ec39@nvidia.com>
Date:   Mon, 23 Jan 2023 14:32:53 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net 1/2] mlx5: fix possible ptp queue fifo overflow
To:     Vadim Fedorenko <vadfed@meta.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20230122161602.1958577-1-vadfed@meta.com>
 <20230122161602.1958577-2-vadfed@meta.com>
Content-Language: en-US
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20230122161602.1958577-2-vadfed@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0142.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c4::16) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|SJ1PR12MB6195:EE_
X-MS-Office365-Filtering-Correlation-Id: 39d6134b-26f2-4621-322d-08dafd3df67f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C9DqL51Dp8vckVGaJKl7GWQXmwq0qjZLDh/A+N/NmmH1hSUJ21MAWYl5FKZQO0qmMNoRgXYn9r2cz1di3KfDNKcLi06lumJ0LD0GDg9/LeS4BL0/SRKaK42MsRgTXtRkW61X/LMVlatdBK5ZN4nAINy4zyVe0shEJgXsBCMPBouUB4uABWHx4GyKzwyCr3moBD6UQF+PxpQATK1QAsnoAGtuoYlcxYyZHgPa8pF/hqqN8e1TV5yHiN01ElVKFGrrDdTlqb3to2eh7yrikse7cKMZO9ky6oTFf0h818UAl8lqG4dOJJxGKAwG/l0aPCkqPP2K3hUPXFyTvO1Kd43X8FSdaG6BpatdJOqyMHDaZW7eQp6LWTihb6Up+i3MzTjM4GoUFBVi8IwnnK2v1xt73iQMoiQJXJljtBzn6QR9bHLmxADkytltsECDbBftCdqxzk97Fhu9XvP2OzhUJLPL6fV515nNsvmDZ57CDreI7txX5BdDjFd6YXFtHDOfpweuxyOSqrKpICRox0qSA5WZ3YI0RmKCiV9qIznq/p3Ra8TUEARND5QUf8oG/i43hVXjbBwrRaS+uTtb8jOex9AD09Phc4Uge2zVepkBucJxp4/kg1qSM7UoqeG6OfiBbRv78EW0CtGkxeoqv4ykQZSftUSnZlTaKedHs2UEw4+UGxsttv94oHnEMjprrBxd3oa+rluUush9B6b3HUx6GboVbQA17nyIdd5fv/6XHDo/xto=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(396003)(366004)(39860400002)(136003)(451199015)(31686004)(66556008)(66946007)(66476007)(4326008)(6486002)(8676002)(2616005)(83380400001)(186003)(8936002)(41300700001)(6512007)(5660300002)(6666004)(6506007)(2906002)(53546011)(26005)(38100700002)(31696002)(478600001)(110136005)(316002)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zk51bjZtMzhEZ2VMSkgvUUFGdFJWc2J5NEtmbWRRQkZLa2prZ2Q4SERIdVpn?=
 =?utf-8?B?VmVFdkM2R0pscDJKc1c1UkFRMzM5RGVJZFVRejIxVWVnK0tReUh1am5walFU?=
 =?utf-8?B?STBna1lVS0ZOeUd2WHc5RTRwZXFoSkF2dSt6QUVmQTBxUzFvVEFUa1BLWE9I?=
 =?utf-8?B?UzZ0UHRKR0xIMVNkaGVpVTF5WHprWFRrMDlKYnA1UVBvQlpNaFJqelRMUTNQ?=
 =?utf-8?B?NVVRMStUVlhTUkMwMzNwa2Z2T1N2UXc0Z2FMVm95UEJkVTJQNDh1bytvRVpS?=
 =?utf-8?B?dHBoWVQxZ29WRTN5dnlsZUQyTldSdGhNK2RzRUhZK2I4WDRUaXFjWHRYMEdE?=
 =?utf-8?B?QVgyb1VxWnBPYXVYV1ZoYVRJQUFwWWpKYy9Gd1NEZ2N3UDBHelZtbG9GSFRS?=
 =?utf-8?B?SEF0eGhWN3Jxa0N3L0JWeXJhQ1NVcEFFaXl3WFFEbzJMb3Z0YURpZVZpQ2wx?=
 =?utf-8?B?b1hoWWJyV0gyMi9YMkM0ZjZWTTFQeU4rTmh3VlR3NWN6NXBWUGVLa3RFdUVL?=
 =?utf-8?B?MFVDT2pkR1dodmxKZzFOQzV5cUNoQjUxTFQwNUFrYzQ0bXhxSU5DdGpWbXhQ?=
 =?utf-8?B?c1Nuc29pRjRnQThPMlFOd0hLWHE3clY5VWt4QU1hQzRrUldqTHRmTlNoQVg1?=
 =?utf-8?B?Z0wvZ1Bza3hYNStOU1pra2RMeEwrZGtZVzNCZHZKS3FJZWtZVCswbVJJcGVN?=
 =?utf-8?B?VzRXems2OTFkSER1RUYwa2tBd3VOOXBNWjM4UVc5VVJieExTTUVHalN4RjJV?=
 =?utf-8?B?VVEvZ2ZXVTNHd0FPZG1lRE9TaVc5SXd1K2hWNW1uQ1lCRUZyL0NhRENwNUhN?=
 =?utf-8?B?WHdYZ25HSGc2c3duQTI0MVdEbEFPK1ZWb0JXUlBPTUFBWjVKVjQrc2JsQ0Zq?=
 =?utf-8?B?N0NXQU9TYSszY2VzSVNYc0p3bzhNd1NuNVFLNHVRU1B0UmFDVXdRZFlha2Nj?=
 =?utf-8?B?WTFibHVUMXJoTEtkNXVkc2xZRGVHUkZWRG1VNVNwYjJCejZncEtkMStHYm80?=
 =?utf-8?B?VzhIbFZ2dDRrS0lQbnlzaWVpaE5GTE0wL1oxdVFrSld1T1BXdkwyWHp6bHpz?=
 =?utf-8?B?Z3hkOVNEUnZuQ0NYRHV3K1Y1aG9pcXNhSVVCV2dmRnJVcEZNckpCcVJwZ1BD?=
 =?utf-8?B?WjJnWUw5bytiQkl0SXplM2JPSWs2UlNTbmhjZnNNM3NpQlJUdUt3ZEkvNktC?=
 =?utf-8?B?dUdYRUpqQWFCY083eUZXV2g3YU9ORjNtWGd6dmhFWWVRSFZ3ZEhTcm81eUp6?=
 =?utf-8?B?UWNrZXczeWJsZkFtaE5OOFpoRWdRUTdaUld4UUZHYmowM2ExejRKek1rYzR6?=
 =?utf-8?B?Y1BLZE0rYll3d2Fha3dlZldpTTgzMUVVTWNnR3J1QkRQR0ViWWltMFhiM2F2?=
 =?utf-8?B?N3h0aXh5ZVVJbGRDczNKVU40cDUvdlJjME8vNlUxNWVTb3BIOURTU21YYzkx?=
 =?utf-8?B?cEVFa29VYWdUSFFPZmo2SkNZa3RyTmNmWERuY3UycUJUam56L0NoMVpxajhJ?=
 =?utf-8?B?VXVRSzcvSU5Dbjl5VExuTllmdnhWc3VCeTRxNWUvTk91ZDlnZk90anQzZ0Nl?=
 =?utf-8?B?VUxKR3ZxZlpETEMvbHVNL2ZWZFZ4TS9iU3hQOWpSQmlmQk9OUWFSMVRhVi92?=
 =?utf-8?B?UHNOc3JvSStUWWlxdnphMDdHVndKSHlSV0w5azRhbytYWDA3NkI4VGQ1S2xD?=
 =?utf-8?B?RlJyWEhFZ0kzZnlBNTQzYkZnMWZVWldXWjdGM2xCRlRuS0p5dGRpNjJacllu?=
 =?utf-8?B?OElqdzBFMTR0N3l2R21CN0wvaDZsNThpT0J2bGxIVzdqRVdzRWwwcEhObzht?=
 =?utf-8?B?bDNXcG12K0xOR2VZaVpROUE4RXcrWkkxYi9JcXVUZVRVK1Y5Qlp1ZGFydktK?=
 =?utf-8?B?cDQ2MFZzNHFyNmtWUjN4aWdaMTNVTVdDSTQ1QTFweG92MUNvemFWazZwTytn?=
 =?utf-8?B?TGU3V1lBaURUaWc1YnpBNGlUaWRDK1B3aERKczlMaGtmUDViQTg5OXRwbElu?=
 =?utf-8?B?M1Y5YXJjRzhFWlhWTFdFNEdOYXduOXc4Q1hSWVBJYkNFZC9sTjJzc0h1M2FB?=
 =?utf-8?B?YlhGdlhlRnlCRFUzdHZVMUVJdVgxL0MwZUtEOTR2cG1qTmRQT0FBRlAvRngz?=
 =?utf-8?Q?0mk3sC7eebwOV/cn3IaSFtUgM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39d6134b-26f2-4621-322d-08dafd3df67f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 12:32:59.9209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +692KVnRttD1JWjbLU5O3GWYchE2Ul/+5zCUgpBtXCSACU6vUZXTPC4UFjBr0VLn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6195
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vadim,

On 22/01/2023 18:16, Vadim Fedorenko wrote:
> Fifo pointers are not checked for overflow and this could potentially
> lead to overflow and double free under heavy PTP traffic.
> 
> Also there were accidental OOO cqe which lead to absolutely broken fifo.
> Add checks to workaround OOO cqe and add counters to show the amount of
> such events.
> 
> Fixes: 19b43a432e3e ("net/mlx5e: Extend SKB room check to include PTP-SQ")

Isn't 58a518948f60 ("net/mlx5e: Add resiliency for PTP TX port
timestamp") more appropriate?

> Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 28 ++++++++++++++-----
>  .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  6 +++-
>  .../ethernet/mellanox/mlx5/core/en_stats.c    |  2 ++
>  .../ethernet/mellanox/mlx5/core/en_stats.h    |  2 ++
>  4 files changed, 30 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
> index 903de88bab53..11a99e0f00c6 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
> @@ -86,20 +86,31 @@ static bool mlx5e_ptp_ts_cqe_drop(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb
>  	return (ptpsq->ts_cqe_ctr_mask && (skb_cc != skb_id));
>  }
>  
> -static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb_id)
> +static bool mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb_id)
>  {
>  	struct skb_shared_hwtstamps hwts = {};
>  	struct sk_buff *skb;
>  
>  	ptpsq->cq_stats->resync_event++;
>  
> -	while (skb_cc != skb_id) {
> -		skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
> +	if (skb_cc > skb_id || PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc) < skb_id) {
> +		ptpsq->cq_stats->ooo_cqe++;
> +		return false;
> +	}

I honestly don't understand how this could happen, can you please
provide more information about your issue? Did you actually witness ooo
completions or is it a theoretical issue?
We know ptp CQEs can be dropped in some rare cases (that's the reason we
implemented this resync flow), but completions should always arrive
in-order.

> +
> +	while (skb_cc != skb_id && (skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo))) {
>  		hwts.hwtstamp = mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp;
>  		skb_tstamp_tx(skb, &hwts);
>  		ptpsq->cq_stats->resync_cqe++;
>  		skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
>  	}
> +
> +	if (!skb) {
> +		ptpsq->cq_stats->fifo_empty++;

Hmm, for this to happen you need _all_ ptp CQEs to drop and wraparound
the SQ?

> +		return false;> +	}
> +
> +	return true;
>  }
>  
>  static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
> @@ -109,7 +120,7 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
>  	u16 skb_id = PTP_WQE_CTR2IDX(be16_to_cpu(cqe->wqe_counter));
>  	u16 skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
>  	struct mlx5e_txqsq *sq = &ptpsq->txqsq;
> -	struct sk_buff *skb;
> +	struct sk_buff *skb = NULL;
>  	ktime_t hwtstamp;
>  
>  	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
> @@ -118,8 +129,10 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
>  		goto out;
>  	}
>  
> -	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id))
> -		mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id);
> +	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id) &&
> +	    !mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id)) {
> +		goto out;
> +	}
>  
>  	skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
>  	hwtstamp = mlx5e_cqe_ts_to_ns(sq->ptp_cyc2time, sq->clock, get_cqe_ts(cqe));
> @@ -128,7 +141,8 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
>  	ptpsq->cq_stats->cqe++;
>  
>  out:
> -	napi_consume_skb(skb, budget);
> +	if (skb)
> +		napi_consume_skb(skb, budget);
>  }
>  
>  static bool mlx5e_ptp_poll_ts_cq(struct mlx5e_cq *cq, int budget)
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> index aeed165a2dec..0bd2dd694f04 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> @@ -81,7 +81,7 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq);
>  static inline bool
>  mlx5e_skb_fifo_has_room(struct mlx5e_skb_fifo *fifo)
>  {
> -	return (*fifo->pc - *fifo->cc) < fifo->mask;
> +	return (u16)(*fifo->pc - *fifo->cc) < fifo->mask;

What is this cast for?

>  }
>  
>  static inline bool
> @@ -291,12 +291,16 @@ void mlx5e_skb_fifo_push(struct mlx5e_skb_fifo *fifo, struct sk_buff *skb)
>  {
>  	struct sk_buff **skb_item = mlx5e_skb_fifo_get(fifo, (*fifo->pc)++);
>  
> +	WARN_ONCE((u16)(*fifo->pc - *fifo->cc) > fifo->mask, "%s overflow", __func__);

The fifo is the same size of the SQ, how can it overflow?

>  	*skb_item = skb;
>  }
