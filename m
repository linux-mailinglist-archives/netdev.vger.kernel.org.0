Return-Path: <netdev+bounces-12069-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FACA735E06
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 21:59:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF1EB280F28
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 19:58:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D2B614A88;
	Mon, 19 Jun 2023 19:58:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5054BD53B
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 19:58:57 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2101.outbound.protection.outlook.com [40.107.94.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF21B13D;
	Mon, 19 Jun 2023 12:58:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AgZluPlwyT2Spn6F5ljyH38KDNw9IIRPIm3UbThCkLod8sugIQwkueEYr3AACKtVgkAITA2lQkmbQt88jPoxwUxatLJtTZVF1sDQwlashTv3mJK/K5l+Cq55EB8Utrdg/1C+CY4cz9EJCuLddm+8YGNo2MYuqOSoUGkJ+K3X7IUhAqIA9K6D3ZNuih18mkg8QWvl+eFkIS3w//NsCIy4Q7gW/XR1oj9ZbfCd0PpKDtQ4vkqhxb9iLeZqKwuLA+xC68v9DCmgUBfKk9IvViwiYjZ5Xea7p2/xCar4618q4Y6bSlJpTweyEGAMLmJTqLP7zaK6a4lSDcH0qxvN+DBCXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ghmDJTG0fSED1OQ/hfAUf75+PTQepjS4TecGWvriTvc=;
 b=TBxFofl28zFjRoFgbyi/LOP1T7cjwn7q+5rqRrSioQFItKTNYRBgjxn6Szsg34BpJt1pMOQLEjWZlVFcBt5Hb6qgiDttHLHObDuADvr7wY9nIAzRdjia8DTrbLPz+1V+VNV0C/zq9EKkysZIQzKawH+EzmtWQ37xdxKJEVpJr6Q0lZKrC2U26kGgGFCi3PbUz+1AGDf8VU9XRCKXt3Ld4lHUi5dSaJWRoYngf0S4PvMDdWzReFFNLvQmomCZUEztcCZJEKOJ5diaNWMtEDpulx8XoM0pURUXijXItCaNqngWul/BYIj4VC/iHrDLT9fGLLZGyKSNQmbJd1ZwV7YFjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ghmDJTG0fSED1OQ/hfAUf75+PTQepjS4TecGWvriTvc=;
 b=iy0HoYNxIhCugMypLPGCH4Z+Z69y2VRguzcLZ3Tl1DbGRogDrbTpw+33sTavipIxoNbJLnDCiz6JLoXYrn+4CcRrJrivv/FufGZal1k0DvlzxuaJOIUo7T3AYT9euC6Vt1Iq7b7ds90qScj4gVKs87k6DXqw73/U9QiqEthPnYg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5177.namprd13.prod.outlook.com (2603:10b6:208:340::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Mon, 19 Jun
 2023 19:58:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 19:58:51 +0000
Date: Mon, 19 Jun 2023 21:58:42 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com
Subject: Re: [PATCH net 02/14] netfilter: nf_tables: fix chain binding
 transaction logic
Message-ID: <ZJCzcufoMlCGE64U@corigine.com>
References: <20230619145805.303940-1-pablo@netfilter.org>
 <20230619145805.303940-3-pablo@netfilter.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619145805.303940-3-pablo@netfilter.org>
X-ClientProxiedBy: AM0PR10CA0115.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5177:EE_
X-MS-Office365-Filtering-Correlation-Id: 45957441-d5db-4260-21ea-08db70ff9a5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	yy1GqenKdFKIV/rB2wBnq7XTFi00Gy4rkQc8nE2wPB3DMfintrswlswYuAV1NkJmdqPHLsbS6iiiBotaCKfNIZ8wJtsq71Fpb5Km4EpgZhuJ5fT7SHO/oZ7824zf4Gqrujpx5qVYFJRD9KwKAvUKpMPntRohBueF4h62F1vWiPLPh+U5bF+jEafTaMMPNNMckm/62syf48TYlXU5cU8wiRUctnFJuipX2X/TiQPWRSfiWt6rhp6X/q3HnrHbqt8uKcUAu3vBanGKKYjiLh/KpzECXd+Xox284eCrtRNvE7DkrvKFI1fXW61BVBRhi+RGF/sJ1hA2/r2u5QGTwNr/d0BS1r2jUseD5QCNGBvyvvzeQw+UqtQZUI32Lp0sxCBEpskeFVlw3N5OQrAK3ZmB4AMJF3I8dLHe8XWsXDTkORjGLDuz4zvkO609wwyb0yduWZdKlnumqlgyOQUfL6NnOa0IgKMmTx85+ZEQsROmUEWHzhcDe/UwS7PB41LdXArVbVVoPeJjootYb7ty6e/4dlsWxzaNXTW/yX0yzLYEPKVdJb/fMyL2sqHizv8f7loujtA6c6WT4ZIESw6qRtOx0nHNfrYlJMkgMrLVmY7cD2s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(376002)(346002)(39840400004)(136003)(451199021)(186003)(6666004)(6486002)(86362001)(6506007)(6512007)(478600001)(2616005)(38100700002)(316002)(66946007)(66476007)(66556008)(6916009)(4326008)(41300700001)(5660300002)(44832011)(2906002)(66899021)(36756003)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2JrTC6RPkOoN9Rdi4Wh5n60clEBWHgcWwjVqifv6uuBgPGpHmdGycq2JucRT?=
 =?us-ascii?Q?8spYyD/gNBBhaePovgrAPVdKhUEucsFSnJGJqu9LNVAKykNLBQR6Y1KyYS4s?=
 =?us-ascii?Q?0/GpdAoh3dwD6aEXM6qnyEb/DKzfVxI20pXHLfwY6CVOj+cdTO7pNSJDrvFr?=
 =?us-ascii?Q?n9/tj/LVVcnNQcBZix3YRUthQ1JGX9OpiyfoUHsDAs1Ne9EHd6Vb3smb5XcP?=
 =?us-ascii?Q?zr8fjGeJAazJZbeUC7FEeC8NZOWzLasCKJsLFLpggvhnFxpvJjVkVRI9+Lhd?=
 =?us-ascii?Q?L0vTh6xdy3NVpxNCHKsARN6mClhSjryqYmZ2K90A8s0mUHxC9pV0aarq1SB3?=
 =?us-ascii?Q?9yT74yyxYnh+JcYp8qkH5lMqXmydldWv5h6MDT7vVNEUNQO54UEnZJj/vUK+?=
 =?us-ascii?Q?VqGis7XjZJ0Z0TK4fVU5IYoBBuMpe8mZaoNGokyPNCaPeEEOXPixDlKqlFYo?=
 =?us-ascii?Q?3XjkcCP27CRgK1B/tYbdjWI3bIYDPfJQU2jdnz8h+EwF8bQfqHiEFj6FPk3m?=
 =?us-ascii?Q?u0qWBFOVOY2VVEPdVQIpMHIEuvmnBvbu3Rir7te86XbYfKXiFCm04H5cUOGw?=
 =?us-ascii?Q?fRdu6jH3+2D2hRmYgQRj+c+KMO6Ei1p0FwK3rvoxrXk1pX999TN41CQA923B?=
 =?us-ascii?Q?aN1Z520a3hugU4mXhI7yu2uRBWmFDs0O255yxR+8RR67uEwH0jyOhoKMx5Ld?=
 =?us-ascii?Q?MEsngGZAg0OzjkUFWtFMovF4MQtFL5UKLYe/SWv8PE3LP0oRKg1JEb7zUvt7?=
 =?us-ascii?Q?3V7eTDxgn2ZLG0uwxu0HMf8LpJaMmQXkwqq2LbjvrJQqMPF0ihZ6xBiGAGsK?=
 =?us-ascii?Q?IBv/QcVVyYpi+T5vjBQimushzvmBNG8icYy2bqEvK8UHtncg2uByl1JInbyD?=
 =?us-ascii?Q?PpIpTeT029jxHALJ25Ddeu4HCExBFre/ptU31jAiVSTH6jxy9ZpwARrfp7IK?=
 =?us-ascii?Q?BcZ7BO26ttDw2hhqIMH+PYtjl4cIN/7b+At7sVRsawkYefY7L13ZjwbUiuyL?=
 =?us-ascii?Q?jibgWoKYB0wzLQD03PdrqEYtD6nJCfNp3S+5FJDrJnpc1gLmz9DmKDum3Fs2?=
 =?us-ascii?Q?U7TZwCmpbDgyVpb+OE5vFWFxBGEKvDbVJp2dNwRUtOu3Rt2v2qiTNR50fzMq?=
 =?us-ascii?Q?nSzm6E2I9It1lGi+KbwUUNdfPt4C37fy92ZmhPOYFexfI0lvTJccjplGB/zQ?=
 =?us-ascii?Q?bRUQYJgwZ45TpA0Fet6qk3Toe9ify6eJsrbk0dquwEjM/bl1AcHXGlcAbalw?=
 =?us-ascii?Q?j01IXezpL940HtM5ZyRCCXJsDrVnfWUHPUDR0EjmrnRmpcH65EzY7nRkNBUc?=
 =?us-ascii?Q?gzH6O78ocRzBpt2jpkHMXV/DfILKmvdyvs4nv8Qv6A+PoEpLAxOpj0KxbC+X?=
 =?us-ascii?Q?QlSJ/9Kq4QQHqEwRb9X/9kkT1Dqm6u1f3Aez3SfaQOURntPeXS1/YCcysYSS?=
 =?us-ascii?Q?MVmoTSAzabIFJ4CmUrmIktgaG0MXW+kNFBvwahDxE7xJhMI5Zb85t9L7c8i8?=
 =?us-ascii?Q?kurvwiNUM8c1adXF/V3VtEtAiUkG5rm5k65eQbnNtWHd2uydFluDOLQjK4As?=
 =?us-ascii?Q?h1MwSDPnM8GcLFVWVB0I1u+y8SgyPDRe6YIctxtkGrpwEZLm63YXkfcbKT2c?=
 =?us-ascii?Q?a7zKgsKTyMz60SMDB2bVUZxfZ/ZIvrmpTsHLt2pAdkmfkOcaYiZqjsi4fYZu?=
 =?us-ascii?Q?HdLbyA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45957441-d5db-4260-21ea-08db70ff9a5f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 19:58:51.6391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j2Vvz/XHiXBcTqvu7h/ITc2p0TX6XqgYda+VucY25EF49oHd4b7x6SfL842oQwkw/C4ylOuWXOWGPgm1LMGUQuhmovl8s+u8Yq/u6auyZmI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5177
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 04:57:53PM +0200, Pablo Neira Ayuso wrote:
> Add bound flag to rule and chain transactions as in 6a0a8d10a366
> ("netfilter: nf_tables: use-after-free in failing rule with bound set")
> to skip them in case that the chain is already bound from the abort
> path.
> 
> This patch fixes an imbalance in the chain use refcnt that triggers a
> WARN_ON on the table and chain destroy path.
> 
> This patch also disallows nested chain bindings, which is not
> supported from userspace.
> 
> The logic to deal with chain binding in nft_data_hold() and
> nft_data_release() is not correct. The NFT_TRANS_PREPARE state needs a
> special handling in case a chain is bound but next expressions in the
> same rule fail to initialize as described by 1240eb93f061 ("netfilter:
> nf_tables: incorrect error path handling with NFT_MSG_NEWRULE").
> 
> Fixes: d0e2c7de92c7 ("netfilter: nf_tables: add NFT_CHAIN_BINDING")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

...

> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 69bceefaa5c8..7b3a0bf254e3 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -193,6 +193,48 @@ static void nft_set_trans_bind(const struct nft_ctx *ctx, struct nft_set *set)
>  	}
>  }
>  
> +static void nft_chain_trans_bind(const struct nft_ctx *ctx, struct nft_chain *chain)
> +{
> +	struct nftables_pernet *nft_net;
> +	struct net *net = ctx->net;
> +	struct nft_trans *trans;
> +
> +	if (!nft_chain_binding(chain))
> +		return;
> +
> +	nft_net = nft_pernet(net);
> +	list_for_each_entry_reverse(trans, &nft_net->commit_list, list) {
> +		switch (trans->msg_type) {
> +		case NFT_MSG_NEWCHAIN:
> +			if (nft_trans_chain(trans) == chain)
> +				nft_trans_chain_bound(trans) = true;
> +			break;
> +		case NFT_MSG_NEWRULE:
> +			if (trans->ctx.chain == chain)
> +				nft_trans_rule_bound(trans) = bind;

Hi Pablo,

Maybe something got mixed up here somehow.
It seems that on x86_64 allmodconfig bind is not defined here.

gcc says:

 net/netfilter/nf_tables_api.c: In function 'nft_chain_trans_bind':
 net/netfilter/nf_tables_api.c:214:63: error: 'bind' undeclared (first use in this function)
   214 |                                 nft_trans_rule_bound(trans) = bind;
       |                                                               ^~~~
 net/netfilter/nf_tables_api.c:214:63: note: each undeclared identifier is reported only once for each function it appears in

> +			break;
> +		}
> +	}
> +}

-- 
pw-bot: cr


