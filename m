Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA04E2E7238
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 17:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgL2QSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 11:18:43 -0500
Received: from smtprelay0191.hostedemail.com ([216.40.44.191]:38860 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726240AbgL2QSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 11:18:43 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id AC7E21802926E;
        Tue, 29 Dec 2020 16:18:01 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1567:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3876:3877:4321:5007:6114:6642:7652:10004:10400:11026:11232:11473:11657:11658:11914:12043:12048:12297:12438:12740:12895:13069:13311:13357:13439:13894:14659:14721:21080:21627:21990:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:22,LUA_SUMMARY:none
X-HE-Tag: sack33_6103b212749d
X-Filterd-Recvd-Size: 1550
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Tue, 29 Dec 2020 16:18:00 +0000 (UTC)
Message-ID: <dda4079bc35fa6e0846a94e9c2b91b0c3a224c52.camel@perches.com>
Subject: Re: [PATCH net-next] net/mlx5: Use kzalloc for allocating only one
 thing
From:   Joe Perches <joe@perches.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     saeedm@nvidia.com, leon@kernel.org
Date:   Tue, 29 Dec 2020 08:17:58 -0800
In-Reply-To: <20201229135318.24195-1-zhengyongjun3@huawei.com>
References: <20201229135318.24195-1-zhengyongjun3@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-12-29 at 21:53 +0800, Zheng Yongjun wrote:
> Use kzalloc rather than kcalloc(1,...)
[]
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
[]
> @@ -1782,7 +1782,7 @@ static int dr_action_create_modify_action(struct mlx5dr_domain *dmn,
>  	if (!chunk)
>  		return -ENOMEM;
>  
> 
> -	hw_actions = kcalloc(1, max_hw_actions * DR_MODIFY_ACTION_SIZE, GFP_KERNEL);
> +	hw_actions = kzalloc(max_hw_actions * DR_MODIFY_ACTION_SIZE, GFP_KERNEL);

Perhaps instead:

	hw_actions = kcalloc(max_hw_actions, DR_MODIFY_ACTION_SIZE, GFP_KERNEL);


