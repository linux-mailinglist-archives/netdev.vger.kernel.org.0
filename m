Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B464678DDE
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 03:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbjAXCGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 21:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbjAXCGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 21:06:10 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2076.outbound.protection.outlook.com [40.107.243.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B752BF0F
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:06:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Us+4it+AtJbMMe4cQ2P5pVcGtGLR4OqnRegURTdvgcUesHBGVRqpzvLEwZgz04473UVqM9/iToAr4uMuyL5fKsK9UjRwhbhPVQPG/6NCPyL0BVyYxZDw9KSylTEIIsv51qvDVp296H6ScDISQfyGAU4nVu6+QHRpuum5HY3ZX+8CW5+SL3fQdBawV6npeIo3WGnaX0PRJdbtVhTyCp1sqKjWl6i0g5bb7gow/qd7Z98xoCrmNbSuG5lZ+ngugkUSVdgEVnZN6Wh9AL9RTrcpXvWWFeH5hRMcmnbgxAa+0T6i5La4uxTTbDKInKBPK/e5fpVI9upxzmvc3b+rFgW3Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4N0syLhBR+rmxxZa0dPtnJSB/Hv0gEW2h/MbkG4F2kI=;
 b=Ema1+J9W8baYNbwPZ4dBEO8rzkXYrg/Mz5vncBPxwsNk6zKX41sJoGj7FomWJEi//yFIUvoB5faoXK7SGWEPJ6k1WZluXczlJP+q4FI6kgm1ddmO80CBvaZXuOxSafy8y8YGyqDO3qvm9LoHHOuCjM6UHbVKBeRaHFU/DoMmZdPGPyOQRuP/ZfVY3DO7pAm0G9I3ucxJfV+W5nIhF4xI93FsERu09T8fVGMx+t29YNP3lfHOH1RzXU6FDgeGB5s5n+E3X5+eyJKHXP3sxAEyYCUgtqRQnI9X2vTZA75SXUMnL4W7tDvqbaPY/rsJ4BwUaNpwMgcgDVqRqO8EFPPnUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4N0syLhBR+rmxxZa0dPtnJSB/Hv0gEW2h/MbkG4F2kI=;
 b=dLJ8WH0TLtt+X+7mF1KDb9gMecD705DiikKS61HXRBHqBY99epjNDQAoxJSIY+lylbBs9BhGMMHTCP6N/PgRK8P2ds6RZ54towbtQROLS0R+J8fk7O/Yo+41reyrTuDKbHUH06Xg02MN7g5cJKZoisbT82Z1muPOKXrgsFFkt7X9tlfXDe34WwetwzdXidVGB2hFj3Cqs/GNHUUbg1XzT5tLSamzBxgp078xgIPI4aCGnZF+gVfYwxk8uaSj66kz8C1gSNkoUzZ6E0sCdggZjImAWPi7NOzHNLulfV/owfqNjv5Nkg5FFbR08LLuWI3S9b1zjJffRUHdULzWXFEDtg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by DS7PR12MB6008.namprd12.prod.outlook.com (2603:10b6:8:7f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 02:06:06 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab%7]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 02:06:06 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Vadim Fedorenko <vadfed@fb.com>, Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Gal Pressman <gal@nvidia.com>,
        Vadim Fedorenko <vadfed@meta.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] mlx5: fix possible ptp queue fifo overflow
References: <20230124000836.20523-1-vfedorenko@novek.ru>
        <20230124000836.20523-2-vfedorenko@novek.ru>
Date:   Mon, 23 Jan 2023 18:05:55 -0800
In-Reply-To: <20230124000836.20523-2-vfedorenko@novek.ru> (Vadim Fedorenko's
        message of "Tue, 24 Jan 2023 03:08:35 +0300")
Message-ID: <87zga8sn3w.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0154.namprd03.prod.outlook.com
 (2603:10b6:a03:338::9) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|DS7PR12MB6008:EE_
X-MS-Office365-Filtering-Correlation-Id: 26246d36-3713-4b08-70c3-08dafdaf8d97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mfcFkA0b2s9AIu/vyyzPz3nOiTA4FYeaO6DCHcne4yHFpoWS5gZl0GMaOnhbH7ADfgBPkRIGZL/cQdBUgUbX5qNT1y1cWbpUxpJL5KZTRH48v9Z5n1ugq6nn0MUNpa+iBFQ3pHmOagonSAQD6C+Kn76H6b4RC4RvcjnX0IBaFcjbZyzc3uaH4h3Y8gz4Of316XFu9VUdieZtThwMKfqePWxlrCPKG7NNNVOo4kTPVFytEGSGvs7d32GdCvBqIHf6cRllJlOus13MuWkUFRztnQ5KZl7D1LLtosTlxVvZUnl4D6NP5euV+TxmmEjFnSV1cJ4cDY5GItxWrF3DLEzfVp71uSrOVcs/kBeOx9s4pBVPTmXOIqc1Mjerxa64fj/yRhUBapVgluzv6zgP4WAbZ9ilQ3C72yjLL0ZprGeQMKh1XgGQnmEVKATUCM+Az892quwXxdt2ThOwpbg0e7AU1ejNIRAV/qLFGVT4I91C1ncgMsDTrjJJ1nxcsTsbCCs3nJ3fMhP0lx6ounkiwUJUPzb/btd/QmMEKUVsbVkTBhtjr2YSNHB6mKGO/ZDIVXTcJEd+NL8uB/IBhhhsOy84hu10pHFCDp61WvI3xHUJ5Bp4GKeAVkE+DCbsjXuWM9bikDeVoSQSx/QtBv7ocFn8qw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(366004)(39860400002)(346002)(451199015)(83380400001)(41300700001)(38100700002)(2906002)(86362001)(5660300002)(8936002)(4326008)(186003)(6512007)(8676002)(6506007)(6916009)(6666004)(66946007)(316002)(2616005)(54906003)(66556008)(6486002)(66476007)(478600001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/+wdvbb8TP0+Ew3hG3ucHuqLDGQhd+8+NW9N3WSANiV/TDcE4d1EJ9v26za0?=
 =?us-ascii?Q?MjDtKpDR/9sYIxbm+Jpc4U9IP/VuagDZ9BQ1miot09eyUFVGE/oFboc81YR/?=
 =?us-ascii?Q?cfnonc6H00sEVWEpr5sPP2cl3YBniZcGjfMVgJba0BivBwsS0H9wRekQjH2n?=
 =?us-ascii?Q?UD8PbQ2p4g1xleomkgbhN3EkUbtU2YC6rbYYh7sLfnrnKUVxGDg+g+IlCQuV?=
 =?us-ascii?Q?J13nCb3VD+NlkOmPwsRRD3SAIUCPTIvL8AmABNDZsciyq86Xgs4fbe0khniE?=
 =?us-ascii?Q?VBpwBxnLpN3wDo96P+YnjsnfEvgP7J5J3s4zQB6InJGawZd/s4l8s2z//8ap?=
 =?us-ascii?Q?5XdOvk3SChxu+wvU0ZLEULwI994O3ULe+31vkQwOyxJdnsa2ZqNMwIYtgMcr?=
 =?us-ascii?Q?JM77eArR4ez8ObN7Y/W0EFlzLDvVbmOhv3Fz+00eiyVkFCIA4gsMpMRp+hnV?=
 =?us-ascii?Q?wUjtAdPkAQflx09Drb7420ef94BijsqyLiZvpIC8Y6ZnvlqR8O2ciXSyIXWe?=
 =?us-ascii?Q?eLJYVaoPlItEQ4Wh1kxVjZfhyMsfAUVrU69bM7X58kLD5qC1m7c4k1/7vnKB?=
 =?us-ascii?Q?qAU0lo1k4mCXvBcI5aTiGu/n5YuKYy4E4ocPaPTnWapCQ+HbIjINTJcM5juI?=
 =?us-ascii?Q?pG5gv9EX8Npq4G1OdRtvOaOszJL/6OPXE0LFZkJuz3JrXqt0c82t7Sq5SJIa?=
 =?us-ascii?Q?kTKJj8XVZKw0odkKoTqs6gk/NguCgxkIW6m0wPSJqHi3zDTkbAD28NN4i4Sg?=
 =?us-ascii?Q?1yeGrc9OoBMwb1vcMKIfomC4Kn3zyTOh7+9a7LLHlDO1wJ0RLu8mIDDvZETO?=
 =?us-ascii?Q?aF9p/HVAGWefqyyhz2G6+qoxnIPbPdYJKcM+OQfkE3UUcZJS97CDLQomhvLG?=
 =?us-ascii?Q?FSgfKZNDoRu1BPwZYfP7tEWXuphsfjqSYT0LjdUZqkAGYOYsttNiUvHiGRpx?=
 =?us-ascii?Q?k0DZE60UVQ+V8NIyNASSiDw2UWuQggdsnGwdQMdFjvxv3RT/WM587jcgFNLt?=
 =?us-ascii?Q?rNzHukeAGQK4CC9QAV/KXNih+WU1OlsiN3/d2TkZgvBPW69bydwZ/tUthU6M?=
 =?us-ascii?Q?j/MY1H50jv1Vj2DoC8EvO9PC0PR5rxboccR427fZbGflzf/h/e11mobbpcvV?=
 =?us-ascii?Q?yhv9CnmuuDlJPyhlS9TaTWPh96yoi5K0kNhki9rnl1PeOsCFZS2C94HM20gK?=
 =?us-ascii?Q?nz47nt4/PHfk8m3xtnX06L8j49j8IGYsjaQPgQlnUi3RtfzTRz1ojvw+boXK?=
 =?us-ascii?Q?7n4yICm4/LyGPTLRbA6Tgs4ryazavNIAUc3RQXnnl7k0CxMxEnPDjwV6DIA/?=
 =?us-ascii?Q?S42EWUrTFLvdVgke1hLpI6RMrxlH7OMZYVvIUp+rdBAfzF+4N8nfYxPE7F3Q?=
 =?us-ascii?Q?VU1D+wqtCezx0Dc8gcEzoqHPBIEe/blMfDYRNReEAQY4LtLxL+nIBS7RRtBS?=
 =?us-ascii?Q?tbY/ezITlq3jwRM0KRT5rBuBet6vUA8RvbR4m6tp2RWlcP4GSXsogqxOiGi9?=
 =?us-ascii?Q?oILsJykWiExKOSaoHVwddZ1KF5YXqW03YG4SuiJYnLmo2qTmUha2t3Fti8lp?=
 =?us-ascii?Q?ASVmRNa7PNKjEjk/YQB4a6YXFOZXgfMHil0n5uaOCLwRR/I6I21KjMr1v6Vy?=
 =?us-ascii?Q?qa56AFHroAeK9Pa9IdIJ1+1PhAPov2F+vMf11Tn/aXdiXtcFscc4f6jaNrEf?=
 =?us-ascii?Q?fLM0qw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26246d36-3713-4b08-70c3-08dafdaf8d97
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 02:06:06.5618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c8xsTxsC9CBww3YLv3pfkyGEUZ5ufyUtbb5AgF4dR0oap5jbV5S5wuMDs6V0RB5IWeKsX63s7Ht0NLVK6sUoyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6008
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Jan, 2023 03:08:35 +0300 Vadim Fedorenko <vfedorenko@novek.ru> wrote:
> From: Vadim Fedorenko <vadfed@meta.com>
>
> Fifo pointers are not checked for overflow and this could potentially
> lead to overflow and double free under heavy PTP traffic.
>
> Also there were accidental OOO cqe which lead to absolutely broken fifo.
> Add checks to workaround OOO cqe and add counters to show the amount of
> such events.
>
> Fixes: 58a518948f60 ("net/mlx5e: Add resiliency for PTP TX port timestamp")
> Signed-off-by: Vadim Fedorenko <vadfed@meta.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 28 ++++++++++++++-----
>  .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  6 +++-
>  .../ethernet/mellanox/mlx5/core/en_stats.c    |  2 ++
>  .../ethernet/mellanox/mlx5/core/en_stats.h    |  2 ++
>  4 files changed, 30 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
> index 8469e9c38670..32d6b387af61 100644
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
> +		return false;
> +	}
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
> index 853f312cd757..5fb58764c923 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
> @@ -81,7 +81,7 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq);
>  static inline bool
>  mlx5e_skb_fifo_has_room(struct mlx5e_skb_fifo *fifo)
>  {
> -	return (*fifo->pc - *fifo->cc) < fifo->mask;
> +	return (u16)(*fifo->pc - *fifo->cc) < fifo->mask;
>  }
>  
>  static inline bool
> @@ -291,12 +291,16 @@ void mlx5e_skb_fifo_push(struct mlx5e_skb_fifo *fifo, struct sk_buff *skb)
>  {
>  	struct sk_buff **skb_item = mlx5e_skb_fifo_get(fifo, (*fifo->pc)++);
>  
> +	WARN_ONCE((u16)(*fifo->pc - *fifo->cc) > fifo->mask, "ptp fifo overflow");

I found this pretty tough to read/understand since it needed to account
for the fact that the overflow already occurred. Instead I would
refactor into the following.

  static inline
  void mlx5e_skb_fifo_push(struct mlx5e_skb_fifo *fifo, struct sk_buff *skb)
  {
    struct sk_buff **skb_item;

    WARN_ONCE(!mlx5e_skb_fifo_has_room(fifo), "ptp fifo overflow");
    skb_item = mlx5e_skb_fifo_get(fifo, (*fifo->pc)++);
    *skb_item = skb;
  }

>  	*skb_item = skb;
>  }
>  
>  static inline
>  struct sk_buff *mlx5e_skb_fifo_pop(struct mlx5e_skb_fifo *fifo)
>  {
> +	if (*fifo->pc == *fifo->cc)
> +		return NULL;
> +
>  	return *mlx5e_skb_fifo_get(fifo, (*fifo->cc)++);
>  }
>  
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> index 6687b8136e44..6fbd58d1722a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> @@ -2138,6 +2138,8 @@ static const struct counter_desc ptp_cq_stats_desc[] = {
>  	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, abort_abs_diff_ns) },
>  	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, resync_cqe) },
>  	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, resync_event) },
> +	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, ooo_cqe) },
> +	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, fifo_empty) },
>  };
>  
>  static const struct counter_desc ptp_rq_stats_desc[] = {
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
> index 375752d6546d..51da492169c2 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
> @@ -461,6 +461,8 @@ struct mlx5e_ptp_cq_stats {
>  	u64 abort_abs_diff_ns;
>  	u64 resync_cqe;
>  	u64 resync_event;
> +	u64 ooo_cqe;
> +	u64 fifo_empty;
>  };
>  
>  struct mlx5e_rep_stats {
