Return-Path: <netdev+bounces-7481-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C99E7206C1
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 18:02:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BD8C31C20B94
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:02:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40BBC1C74F;
	Fri,  2 Jun 2023 16:02:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4391B8FE
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 16:02:47 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2121.outbound.protection.outlook.com [40.107.96.121])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0191B7
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 09:02:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RTffIq/oScaly43nh0aLGjj5fQ6NzSYUQal+vOfdKRKQq2rAT5MJ/q5ixvluImsKZcImUJJkjAqqWS9CAxcAC5CbcYx9XiXHEV17YJXg9mnT0TY/20HLdWy1Hoom+n436Plhrsjef6p8lx7SnKJHvBWV0INES5wM75dsUEyrnbEhnsu6+ZyH4Lcq/IQzUMvP+oTpw/mQCo/I6bGS5LZ3OfgYcBaja/WqubUhaCWOH0qZpv0n/9q7cFrRQIVn/71ztDEcbVyTtZx6aFZyepQcCGIcFh/G6iUvqdHAub7qHRPSr8yEnjyJiOFusk0Hf3k6LfKdshlFR4nsYyx7X40qog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nk+7sDCjRN7FAtNBgHD+hAEpp86DBIwa2rT6XSAfhtc=;
 b=bnhhcryebdBWRxZh84ht20AJGmtSEXw0kdYytXCOdkmsGwrah11tmjZnUHcLxTxlaKcaAQcrP+UcpJpjRrojhgl5asfjJuv8YvoADurAx7sEL4Khy42Lm1BWLfq2xM5Ed/xedieEfStAzco88uHTi6vE63NPiKSVsV4qa87aAVJ+EbhNW6mimeQFv9beR7fIafxoNgrqQPdJvGvSbftxRcrfwQd5qRJzTk3fdAj0pugBMR4BMKVm/gh9mVgUq8O71tswq/ViKdHFMrsDLrhihAMpmbHfi+EIfpjlF7kWv3ykD8KMtltGQHMzxrbzDcCfGgT6ZNP1yfgQ0IMY1Y0BmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nk+7sDCjRN7FAtNBgHD+hAEpp86DBIwa2rT6XSAfhtc=;
 b=pChVYIuSmiUHehiJ4m0/dIuDsEpZmASATFZ0VeL9VHN/X6dbdSipbtBdPeA8NzvHRAasfja9LEq/Us5cPOBplrspgMw18J9ZMIVpAWyw9eR3BQ9trRqX1WTv0fY9B5e/gbHIn7eyOwFi+c4TWgyiI0fnPXvE1obKCKK3zuDzY24=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ2PR13MB6069.namprd13.prod.outlook.com (2603:10b6:a03:4f6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Fri, 2 Jun
 2023 16:02:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.026; Fri, 2 Jun 2023
 16:02:38 +0000
Date: Fri, 2 Jun 2023 18:02:30 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Saeed Mahameed <saeed@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
	Shay Drory <shayd@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: Re: [net-next 03/14] net/mlx5e: rep, store send to vport rules per
 peer
Message-ID: <ZHoSlnSX0K4xeZOF@corigine.com>
References: <20230601060118.154015-1-saeed@kernel.org>
 <20230601060118.154015-4-saeed@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601060118.154015-4-saeed@kernel.org>
X-ClientProxiedBy: AM3PR07CA0077.eurprd07.prod.outlook.com
 (2603:10a6:207:6::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ2PR13MB6069:EE_
X-MS-Office365-Filtering-Correlation-Id: a146f313-c1a2-480c-a928-08db6382c95e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Mjxn6zNNkbXqoSI4SnhxxzooJ6fYf3rRpcPM1Hz3sAJnQlnPv9p9ZR1azzt6N0hxRKMcdE4uINrL8mRbiIDOD6/7mqZjGrME54G5MPKbSx0yLs1SGbdO9fjPoP+6EkZt4ZpoqCt3qSpbLJ48FojHr1BfQuDpAnKI03y08dmauCLlYci8cBbgz/dpQ39Njg8BcB1QcNuaBBsbX2P+dwPf3tHUZA0ZVyIdaotoHTVtB1QSaBvrCVZv+q7FhdNtM4MCrGia723AT4guN84RLvqbRJmtqtLi1q+6MfvzXllKJ+Rhp30MVGePgGOP6iAfnXcz6k0/Iz8Df9Ceo0UghKy/hb5jqZqnAIee1zo4QDfHeOO+D9w9m3JVXaL53Lga6vJ+ih6jXmJPEwfrRAm/yk1L74ZlQEJoSIq7hsxjF2eEO0KtALyOixY6uUI0J3n2LmRoyzEy8RCr7jJhnr+pBibP7DdG+iLKgNyKCtkluBZlcva8I/R+YVuM0RMti1uPcB09fDsN/3dZaEG92Zea/2aVgOFESUkldYxIBT2MkUf5mzF+bPwj867Q473mtD4vL0P1
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(366004)(39830400003)(346002)(451199021)(38100700002)(2616005)(83380400001)(66556008)(66476007)(66946007)(6916009)(54906003)(4326008)(86362001)(2906002)(316002)(6512007)(186003)(26005)(6506007)(6486002)(36756003)(44832011)(5660300002)(41300700001)(6666004)(7416002)(8936002)(478600001)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?doYlRmd7xxAmAJpc9ShUsysWZ5gSvp7mZj8QIb9A+z9z7jPQeQr2T4y9kOlw?=
 =?us-ascii?Q?c828Dy5RIO15y90Qao1nmvthqaME3LeNeJT/Dhm2UUlv32kvi/YEomJ8ncbo?=
 =?us-ascii?Q?1i9ZieazMtV++vUdwQ9BNBojeKGYWa+KHQfPuyHKi7OKrbTDGViExMkuaAyH?=
 =?us-ascii?Q?6NwcX6oE1tu3gicuH0QlTIZnYRqL4pxU8zbhRCMRLXHFgiKxxLDpA3C7HfuU?=
 =?us-ascii?Q?3hNW+WOUr9TqqOKztNClwfpFHUSE++ShJtfLBOm/GFgxxL14Vb3nq8+gr/uz?=
 =?us-ascii?Q?o5g3Ux0KTRpdTf2rWaCfZV7NjhfhSXoRZ9rPU+JOAhzN+4YrforUPqOo2aJX?=
 =?us-ascii?Q?n1lYPVYcktAtn8kS8MeFRBLTN/VlBGAGdfQlcNVtjT6GLZlzodV3g9axCnpL?=
 =?us-ascii?Q?s6wVqZB1wlg9LY/+9uliusSvRwYLeDrLw/lBHinTx5DEaVsBnLvLmHapyGL0?=
 =?us-ascii?Q?wQsKPEdXEGq4zvggrpiwYWA1vpwVmUW4NE5eAPDOAZO7W6cZNSip0ghexkB1?=
 =?us-ascii?Q?c+hqJasoroOnvHGIlVfcuN6mm3LDAFLrMnD+mVNoiB1X71ADw5TBk6I/6UvV?=
 =?us-ascii?Q?61JbIt5KgH80Z0uE0IFmNUmo0siIZ7qFDXG79AxBFocU7yav4NCwUhpPzsW9?=
 =?us-ascii?Q?wAXB7utDyob5QG5o5WDTNKeZAuT4iuq2cnXLJzhs9Ar4mY8JUQ1FW1bP0HWC?=
 =?us-ascii?Q?RpTyKb6yN8SnYFRjjNo4zqTnnivr1g3o5QC+rpP7iOC/92uu8qP8sBbYv5Ev?=
 =?us-ascii?Q?0QR32EI8g0VLu8SVwnUv/Ih+aW82EjWThLV892VtlqVoTkETuRJFqVma7fVs?=
 =?us-ascii?Q?HysXxhz56xii4hm/2pECjTaSFAV45Pc34EOUBdyA8o2Wf1wpAhiPw/Mji+MK?=
 =?us-ascii?Q?V/NIynHx+PsuK3QUZksEo9q5DpktihW8oopxjWw0NQRi4TIWRB+KKJYzlyxs?=
 =?us-ascii?Q?Kt5Si23n929t3ZkuhSGOMEStGM5PRtkdeTdDCJ0nV1DH/5vOYPVD0Fkh89o5?=
 =?us-ascii?Q?FbRlGNwVaEHQJrtFil9FtQvlFg0rZ2WuqNh5zn+YUvyDUoBLqrfRc6eEQOJA?=
 =?us-ascii?Q?C53ugSjU6Yp+tZr5S03id9DAPKJoqtvBjdyDb/I2NY8GSs1nVjpZe5l5R6CN?=
 =?us-ascii?Q?dBWQPLBlW4J0AB4Wi+dhTbs4Stefv3KashuBc5KRx4X41GNlqDAOLXPt/6n/?=
 =?us-ascii?Q?CCt9k+Q9SFudPipLqY2Q41vRjHlc61lgoFUJ3Z32GpsuMfTVVpAQ5QWap44I?=
 =?us-ascii?Q?9HUEhE0/rkUMaXzq7yn7jgYVwa14o/D03uB3wnvIg7y7QP6cJ2j0XrR61ETv?=
 =?us-ascii?Q?UzdQz0XB10SBwEmF4BJY4RBrthnRiFrWpKv7u9jWkd6+LKm5bd7C/+t21iKA?=
 =?us-ascii?Q?leH8Un5rUPk2SGm17xVn2TZVPA1mdpTsYa3zOvWnokJ287r5qXuXTKmN5AeB?=
 =?us-ascii?Q?1WrYZ6Z7a/pnZ9eTsqLfnxoOzsFrLiZUTntIEwVAQriY+0ptX1D2kv/cQ1HQ?=
 =?us-ascii?Q?OCEatVT/qeC32BBgecsLRNSYzDMrFN8EBYj/IDOwXkf6OTK3ekAKgHq/qRdI?=
 =?us-ascii?Q?y8qWdAWviLUUosBM5ifB4qGTOJJaYJxBgNkNv0rtBwAkUdY9ZdEKaU2JlcTp?=
 =?us-ascii?Q?LA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a146f313-c1a2-480c-a928-08db6382c95e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 16:02:38.0031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JKfp23l+l5ZpEBW62EXgr9UsMc3XO2hTPHegCY/9vTyEzajinKJg8C1kJwr0BYSoCGis9qB6vvG26IkVhGjOeb1IH7p0xhcZyWEPnKJBaHY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR13MB6069
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 11:01:07PM -0700, Saeed Mahameed wrote:
> From: Mark Bloch <mbloch@nvidia.com>
> 
> Each representor, for each send queue, is holding a
> send_to_vport rule for the peer eswitch.
> 
> In order to support more than one peer, and to map between the peer
> rules and peer eswitches, refactor representor to hold both the peer
> rules and pointer to the peer eswitches.
> This enables mlx5 to store send_to_vport rules per peer, where each
> peer have dedicate index via mlx5_get_dev_index().
> 
> Signed-off-by: Mark Bloch <mbloch@nvidia.com>
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

...

> @@ -426,15 +437,24 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
>  		rep_sq->sqn = sqns_array[i];
>  
>  		if (peer_esw) {
> +			int peer_rule_idx = mlx5_get_dev_index(peer_esw->dev);
> +
> +			sq_peer = kzalloc(sizeof(*sq_peer), GFP_KERNEL);
> +			if (!sq_peer)
> +				goto out_sq_peer_err;

Hi Mark and Saeed,

Jumping to out_sq_peer_err will return err.
But err seems to be uninitialised here.

> +
>  			flow_rule = mlx5_eswitch_add_send_to_vport_rule(peer_esw, esw,
>  									rep, sqns_array[i]);
>  			if (IS_ERR(flow_rule)) {
>  				err = PTR_ERR(flow_rule);
> -				mlx5_eswitch_del_send_to_vport_rule(rep_sq->send_to_vport_rule);
> -				kfree(rep_sq);
> -				goto out_err;
> +				goto out_flow_rule_err;
>  			}
> -			rep_sq->send_to_vport_rule_peer = flow_rule;
> +
> +			sq_peer->rule = flow_rule;
> +			sq_peer->peer = peer_esw;
> +			err = xa_insert(&rep_sq->sq_peer, peer_rule_idx, sq_peer, GFP_KERNEL);
> +			if (err)
> +				goto out_xa_err;
>  		}
>  
>  		list_add(&rep_sq->list, &rpriv->vport_sqs_list);
> @@ -445,6 +465,14 @@ static int mlx5e_sqs2vport_start(struct mlx5_eswitch *esw,
>  
>  	return 0;
>  
> +out_xa_err:
> +	mlx5_eswitch_del_send_to_vport_rule(flow_rule);
> +out_flow_rule_err:
> +	kfree(sq_peer);
> +out_sq_peer_err:
> +	mlx5_eswitch_del_send_to_vport_rule(rep_sq->send_to_vport_rule);
> +	xa_destroy(&rep_sq->sq_peer);
> +	kfree(rep_sq);
>  out_err:
>  	mlx5e_sqs2vport_stop(esw, rep);
>  

...

