Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2742B36506A
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 04:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhDTClP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 22:41:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229534AbhDTClO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 22:41:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCC6761026;
        Tue, 20 Apr 2021 02:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618886444;
        bh=k/cyW2vHcGDQhnyv5exNB/c0MFSx+NziYJKuWhZsB4Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Fa+PGzpAuRSG85sPEMNDZzYQ5hDpd/eEE0L/EieBVn9hBDjxNurbxiJHLkDQlFfqW
         +MYeLLuvfkj6S/lbUqzg3iQ8o0seZGTYL+yCHgrcCInBvPFUKI6p1sT1bC0GhQVqaH
         OhlPKhjsmozDjufnM7YrlZJYvJrJ+TzZaeGHpbhCcRZIjcAIAk4g1I9C4TwZ2sneDj
         VIN8BjThIQDx6RMR2Z5uaU+XxXmISqSbKOsqwJ9x+9HLg+SYW0uISzcUnmeMZ4vAQk
         7CvuxFanW+f6T9a9+LFpnFNeLsdLr48aARB6ktDlJm+riYMmmGaCmv5aUAYxxTBEeS
         QUZj37GQeFvIQ==
Message-ID: <5c7d5a18ce4e43e0182a7710511078b444604364.camel@kernel.org>
Subject: Re: [PATCH net] net/mlx5e: Fix uninitialised struct field
 moder.comps
From:   Saeed Mahameed <saeed@kernel.org>
To:     wangyunjian <wangyunjian@huawei.com>, kuba@kernel.org,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, dingxiaoxiong@huawei.com
Date:   Mon, 19 Apr 2021 19:40:42 -0700
In-Reply-To: <1618834662-20292-1-git-send-email-wangyunjian@huawei.com>
References: <1618834662-20292-1-git-send-email-wangyunjian@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-04-19 at 20:17 +0800, wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> The 'comps' struct field in 'moder' is not being initialized
> in mlx5e_get_def_rx_moderation(). So initialize 'moder' to
> zero to avoid the issue.
> 
> Addresses-Coverity: ("Uninitialized scalar variable")
> Fixes: 398c2b05bbee ("linux/dim: Add completions count to
> dim_sample")

net_dim doesn't use the comp value so there is no actual bug here.
Can you please drop the Fixes line and resubmit resubmit this to net-
next ... 



> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 5db63b9f3b70..9bcedfb0adfa 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -4881,7 +4881,7 @@ static struct dim_cq_moder
> mlx5e_get_def_tx_moderation(u8 cq_period_mode)
>  
>  static struct dim_cq_moder mlx5e_get_def_rx_moderation(u8
> cq_period_mode)
>  {

also mlx5e_get_def_tx_moderation needs fixing.

Thanks for the patch, 

Saeed.

> -       struct dim_cq_moder moder;
> +       struct dim_cq_moder moder = {};
>  
>         moder.cq_period_mode = cq_period_mode;
>         moder.pkts = MLX5E_PARAMS_DEFAULT_RX_CQ_MODERATION_PKTS;


