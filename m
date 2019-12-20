Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 844A612734A
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 03:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbfLTCHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 21:07:39 -0500
Received: from smtprelay0157.hostedemail.com ([216.40.44.157]:50013 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726964AbfLTCHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 21:07:39 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 94152837F24D;
        Fri, 20 Dec 2019 02:07:37 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2689:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3871:4250:4321:5007:8603:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12297:12438:12740:12760:12895:13069:13311:13357:13439:14659:14721:21080:21626:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: bag50_5f8a9fc957d61
X-Filterd-Recvd-Size: 1672
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Fri, 20 Dec 2019 02:07:36 +0000 (UTC)
Message-ID: <ff6dc8997083c5d8968df48cc191e5b9e8797618.camel@perches.com>
Subject: Re: [PATCH] net/mlx5e: Fix printk format warning
From:   Joe Perches <joe@perches.com>
To:     Olof Johansson <olof@lixom.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 19 Dec 2019 18:06:57 -0800
In-Reply-To: <20191220001517.105297-1-olof@lixom.net>
References: <20191220001517.105297-1-olof@lixom.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-12-19 at 16:15 -0800, Olof Johansson wrote:
> Use "%zu" for size_t. Seen on ARM allmodconfig:
[]
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.c b/drivers/net/ethernet/mellanox/mlx5/core/wq.c
[]
> @@ -89,7 +89,7 @@ void mlx5_wq_cyc_wqe_dump(struct mlx5_wq_cyc *wq, u16 ix, u8 nstrides)
>  	len = nstrides << wq->fbc.log_stride;
>  	wqe = mlx5_wq_cyc_get_wqe(wq, ix);
>  
> -	pr_info("WQE DUMP: WQ size %d WQ cur size %d, WQE index 0x%x, len: %ld\n",
> +	pr_info("WQE DUMP: WQ size %d WQ cur size %d, WQE index 0x%x, len: %zu\n",
>  		mlx5_wq_cyc_get_size(wq), wq->cur_sz, ix, len);
>  	print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_OFFSET, 16, 1, wqe, len, false);
>  }

One might expect these 2 outputs to be at the same KERN_<LEVEL> too.
One is KERN_INFO the other KERN_WARNING


