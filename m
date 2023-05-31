Return-Path: <netdev+bounces-6657-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C5CF717405
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 05:05:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CA9A1C20DB5
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 03:05:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD5B5EC4;
	Wed, 31 May 2023 03:05:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B5AEA6
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 03:05:52 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6E3121
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 20:05:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GXvWDePEvUufAo/fxz1xHAHfv4IKmKyYqrbGciml+rsSfNpVmTN85G7afHDRZa8NdH5noR0d0Ih8c0ACzXwk4QXf3kf+qwPRQ/CsXr1Z3ZIPKpe5EvnohCIQKjpDrdn9iCN8ICePu9D9YZpZ1T3GhDBCG5kwqQpDbnlLSg709s2PkNiQc3Z9t4MnyABv77oF4Ct104UloKp/++GhxAdg9b9IXFjDggSxZXB4vtZVKNA45gGwihCCmPNFnXS99wvkKuqymrz1vMaQFVdVpfg/3Z9G2aoXecdgAYQx5/lMo2vuMHOi7b4Zcel0/4Za+5rbVronDE0eamPj4L81N4OtHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SBDWkAqnL9nM/MTBRuLd2Vj+s+rV8UWpV567ZGdRgKQ=;
 b=GPJuWcIN6+nNtOVRZvDvV4agQ1M4HPGDOMyCQcn0uEWvO9Z2AfXAnlWqWOyX9KFXEWSjhh9DX6yjho5GUGeYOHdhK74r3/yC20th9vO51r5u8/zssEoQBt8T+A8Rrbf4T9LAMJGr5oKy0QX30PQoqTQ0ED4CMvwzmMc4Bx5xp3mrFXhMb4BmXENBLUwDPjnroe6E6cO79WTCqCJJJXShPDe8dUj+TOZuqQF4vNEVsFZAerCZGnGYR64Tvf/O0sK/oLYvQP4R5B3EbY8KfJ8y4JZVLeoLYSDnkeks3QoV+tqfqe8DPeDksQxzdRYp4RzMueCK6OpogDN3AwZzE0qzjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBDWkAqnL9nM/MTBRuLd2Vj+s+rV8UWpV567ZGdRgKQ=;
 b=f0e/m5lN+SZ7B+F/dWEWDcdsUUGcDIBnwG0dzDu4tGcwDuMZYYRI2+B2hvibHhOSGPjMohqcATTAAxDtEBhJmQW86F6hFqR7o0K2aKxttRCfaoukO5z3W9RsmrdkIrDp/rK5nMpt4LoxYfBUayZFlEdaksIDXzRyyx7Q4rZ7CERv3AOoRwfrxdXuzPA+s69VpZp2pmHs2C6SSTkdHQUPw3EkuLB6RmHYYoqHcCXd0OVbNvbvmNO7gRaCu2UEBDU40Ji+Rum03yFaX6yfRff22CQy+ol5WSr5wIVAzi4XRihISVYgbYwxytKMlz7Xv3FdopW0zVc1+bP8LyvXNBUNOA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SN6PR12MB2749.namprd12.prod.outlook.com (2603:10b6:805:6d::18)
 by CY8PR12MB7414.namprd12.prod.outlook.com (2603:10b6:930:5e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 03:05:47 +0000
Received: from SN6PR12MB2749.namprd12.prod.outlook.com
 ([fe80::5437:dc62:eadf:d50c]) by SN6PR12MB2749.namprd12.prod.outlook.com
 ([fe80::5437:dc62:eadf:d50c%4]) with mapi id 15.20.6455.020; Wed, 31 May 2023
 03:05:47 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: saeedm@nvidia.com,  netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5e: simplify condition after napi
 budget handling change
References: <20230531020051.52655-1-kuba@kernel.org>
Date: Tue, 30 May 2023 20:05:32 -0700
In-Reply-To: <20230531020051.52655-1-kuba@kernel.org> (Jakub Kicinski's
	message of "Tue, 30 May 2023 19:00:51 -0700")
Message-ID: <87sfbd9p4z.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0223.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::18) To SN6PR12MB2749.namprd12.prod.outlook.com
 (2603:10b6:805:6d::18)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2749:EE_|CY8PR12MB7414:EE_
X-MS-Office365-Filtering-Correlation-Id: 03547d19-c2e5-4724-a147-08db6183ee7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	U2KhfC0E7ZBr06apb7YXR1BMkC3KiDVyJkP1xeEnqlpIausTVcEYOOgq9uUZAdI/8ab776vY9jTV/coHE5TGdNqP1KY9k6Zdg2+eF4WGjH5gyd2y+e4AVoH5Hv8GNgpFRpyNLEwPhBQf9rbCG6z42JniQTZ87GOxVE7roUDZ24/eIRAmZUbVpIc8FuohSlXGuy77dhRTj6rmUnnjPYHqlsn9qEFQFiaoqpLljijaah7Yp7PXsHaw0i51Q4RFNDn28y51K92pL8TNSA3k6+M3URd+5QCCSag46jlnRwwNybp/NH2iYZSQJZYQnq3Vz45qRnDK1DB+qL5pTTpeSIaUXITELDmjHopQr+tfEUytNuJjIHDQ2kPs8uOPEnmP70v0IAV4FcStjElRzWpEGHVAEKm56i1tDtZy0tiMkLVR3nMwsb1TZeaKSk9GNgSLpPpMp3958SWm6JX3dq9qCyYUnuAtg9xgk2SMEsAbBEQ0Eipz3m6QFhRUKjEJWG3Ln71ig5MFR25ssqsVPbG6SuxwNobdmmtxkGbA+OEeyUii08I2h4qylsfVXMKcC1w7Z4vn
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2749.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(451199021)(86362001)(36756003)(478600001)(4326008)(316002)(66476007)(66946007)(66556008)(6916009)(6486002)(6666004)(5660300002)(2906002)(8936002)(41300700001)(8676002)(83380400001)(2616005)(38100700002)(26005)(186003)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iN6g7Yz7zhD2r+qIc+Y/MkPGjIehvgLLudMwlsFuJmisnJTzwkEPTTDNzDW2?=
 =?us-ascii?Q?I5pIcbIGrhxGC7QOqawS5OKP9d8/OsydToGxVAW+SM3omaQIssf/OL2Pqxg0?=
 =?us-ascii?Q?0XViOUjm9GK2WBc6xuylow+2zAsl3wsH3txaGkDa7KglXlF7WLvq4aBYpYF0?=
 =?us-ascii?Q?u2YTDHX0Gq3DzehU05B0TyIOmw6jDwGUVtWdwQIaO1ysmQEBqNnfjsthvwxj?=
 =?us-ascii?Q?6uYUNz/6HaewtTsqabh6qQ0PutrqMaEp2hXK41wd8vexiq9zXjyrHthGu9uJ?=
 =?us-ascii?Q?Cw1WC4MwwzOkP+rdxz3ayMFNRHXTjt3Vk/gVfXeGWHX+IE12ZVhkbc9CNKxq?=
 =?us-ascii?Q?SbYI69GTsJgTKvSfTQw7WcMkV4dYuPmNPkIBourhHLsQOYJ9r4h6gsuPi1SV?=
 =?us-ascii?Q?omLc5QnXyzITyF2qrOK2J8X0aYOoGdQaB9j3LuI5QUCldHMMRKzB0cMsXGzp?=
 =?us-ascii?Q?ZIC/9kKxQde7++y0W9+O3IZcXg1ZPj9S9HS4ZmGm008a1fsyNW1C30saTieB?=
 =?us-ascii?Q?B6ixQtCLZiJx5ZqYAsNup6hIADoLtWA3uAkC+OUeHRJxpIwZUH2BSYWMYBiq?=
 =?us-ascii?Q?9At4hqPkgjNMyMhbIMsx4a/LfabKqB+o6ZSKkPN6C82mcox3TTEM/YKMW1bq?=
 =?us-ascii?Q?PcpnIZFZpG5rxTaB7afM6XgxK1JfGoFVsB0libKys3zZBtDZ5xNZkCPptrSZ?=
 =?us-ascii?Q?wjbvezvLccJlUQksyjh5A1N8rG92vSZ/XtO0WqmGd23YQd8oAA8i9p4C1i9m?=
 =?us-ascii?Q?2KW8hFTJpxqjuz23zt+2luksQhZZNe4Gg7kZHC9exG8KA+Q8xtQ9bwNmCNYY?=
 =?us-ascii?Q?nM532umV5YTBne8ubIei20EBFX0X8AEptM2AAtqqQUVjct2PD+MphwghYQq1?=
 =?us-ascii?Q?/QtwTa6cKtxIMxJnCbcAKyVqozxof2GPy0rkTROgSrn2fL+cAvHMQugSN2CQ?=
 =?us-ascii?Q?DTeL6nynYALx3q+sQrsrmHZx6MI+w9ZGEt4I6tvo5eYh//vHjhVhB8722fgy?=
 =?us-ascii?Q?WIsp241/hf6nvzTRVlBpNfbxkf6hAZB8KIEGeSMxcV4Eqt0NxQR0vPgEqTss?=
 =?us-ascii?Q?3SOB37nyZ7o+WOYoi8QSiN+wK0zCD9bbChIg8rRRWrrqzgAJCqPx7UekWP8R?=
 =?us-ascii?Q?9f+2WjPjEvYSG2YVV8NJU+6O1R107CzDB1jUcbfMkMGVqrc75wNoqcvbJ2un?=
 =?us-ascii?Q?ZIlsJ7cyHNTbR+uDsk5bvP/sAhk4dP+7dlPKXtQasCrYp67rOLPoZBsQPojX?=
 =?us-ascii?Q?1o4kSI8y0QVqyh/wIqSVjsand7wspazU2vWYDpnbiCdHurXuTAREDFnfckJK?=
 =?us-ascii?Q?yxCVPEIpCWbTYuqGjB/m37onwMEPfTt+Hi5YlzRPpdld/8PCah2yyPjEpQBr?=
 =?us-ascii?Q?d19bU/+4+zFiS4BqE9y0O2CKlHi9/i16E3wt8CH3p2lhysUml9FD80WaUaBq?=
 =?us-ascii?Q?ouwjlb5QRhgW++juH7yExmacEfPgQYZkRA5ZSP5buq1mK/HwpIzZBQxfy672?=
 =?us-ascii?Q?WZ/cWlv6TfKRk5IZYpZlAdYTTiIopm4IapqJye3WOShFIFYhH72AWKKo0EVk?=
 =?us-ascii?Q?XuweoP3jDO6+j04FCqW5psxG01XnxZhLlGQEZyFx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03547d19-c2e5-4724-a147-08db6183ee7a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2749.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 03:05:47.5529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jY/RcaCFaD9oLR6Y+uX7V9KRCwg8JPr123TRFfv1PM9o6CvAfRkgNTc2ZKQwyjGo7W3huhA+tGMg51oDmMg3Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7414
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

You might want to clean up
drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c as well in the
mlx5e_ptp_napi_poll function as well.

  static int mlx5e_ptp_napi_poll(struct napi_struct *napi, int budget)
  {
    struct mlx5e_ptp *c = container_of(napi, struct mlx5e_ptp, napi);
    struct mlx5e_ch_stats *ch_stats = c->stats;
    struct mlx5e_rq *rq = &c->rq;
    bool busy = false;
    int work_done = 0;
    int i;

    rcu_read_lock();

    ch_stats->poll++;

    if (test_bit(MLX5E_PTP_STATE_TX, c->state)) {
      for (i = 0; i < c->num_tc; i++) {
        busy |= mlx5e_poll_tx_cq(&c->ptpsq[i].txqsq.cq, budget);
        busy |= mlx5e_ptp_poll_ts_cq(&c->ptpsq[i].ts_cq, budget);
      }
    }
    if (test_bit(MLX5E_PTP_STATE_RX, c->state) && likely(budget)) {

That last conditional would be reduced to the following with this commit.

    if (test_bit(MLX5E_PTP_STATE_RX, c->state)) {

On Tue, 30 May, 2023 19:00:51 -0700 Jakub Kicinski <kuba@kernel.org> wrote:
> Since recent commit budget can't be 0 here.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> pw-bot: au
>
>  drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
> index fbb2d963fb7e..a7d9b7cb4297 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
> @@ -207,7 +207,7 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
>  		}
>  		ch_stats->aff_change++;
>  		aff_change = true;
> -		if (budget && work_done == budget)
> +		if (work_done == budget)
>  			work_done--;
>  	}

-- Rahul Rameshbabu

