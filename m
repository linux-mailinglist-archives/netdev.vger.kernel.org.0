Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B923EF6F8
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 02:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237008AbhHRAj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 20:39:56 -0400
Received: from smtprelay0052.hostedemail.com ([216.40.44.52]:36988 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232410AbhHRAjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 20:39:55 -0400
Received: from omf09.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 09BE7837F24D;
        Wed, 18 Aug 2021 00:39:21 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf09.hostedemail.com (Postfix) with ESMTPA id A5A501E04D4;
        Wed, 18 Aug 2021 00:39:19 +0000 (UTC)
Message-ID: <d96db1d04062a2a88eb51f319c2aef0a440755c3.camel@perches.com>
Subject: Re: [PATCH] net/mlx4: Use ARRAY_SIZE to get an array's size
From:   Joe Perches <joe@perches.com>
To:     Jason Wang <wangborong@cdjrlc.com>, kuba@kernel.org
Cc:     davem@davemloft.net, tariqt@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 17 Aug 2021 17:39:18 -0700
In-Reply-To: <20210817121106.44189-1-wangborong@cdjrlc.com>
References: <20210817121106.44189-1-wangborong@cdjrlc.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.03
X-Stat-Signature: dz48nf6d9o5s49khmid9bhzxjdkbjf3u
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: A5A501E04D4
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+jgr6IHto8RE+dUh89yfcZj1brUyoKS4E=
X-HE-Tag: 1629247159-857219
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-08-17 at 20:11 +0800, Jason Wang wrote:
> The ARRAY_SIZE macro is defined to get an array's size which is
> more compact and more formal in linux source. Thus, we can replace
> the long sizeof(arr)/sizeof(arr[0]) with the compact ARRAY_SIZE.
[]
> diff --git a/drivers/net/ethernet/mellanox/mlx4/qp.c b/drivers/net/ethernet/mellanox/mlx4/qp.c
[]
> @@ -739,7 +739,7 @@ static void mlx4_cleanup_qp_zones(struct mlx4_dev *dev)
>  		int i;
>  
> 
>  		for (i = 0;
> -		     i < sizeof(qp_table->zones_uids)/sizeof(qp_table->zones_uids[0]);
> +		     i < ARRAY_SIZE(qp_table->zones_uids);
>  		     i++) {

trivia:  could now be a single line

		for (i = 0; i < ARRAY_SIZE(qp_table->zones_uids); i++) {


