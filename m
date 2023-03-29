Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8C86CD7C0
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 12:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjC2Kdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 06:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbjC2Kdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 06:33:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD336422C;
        Wed, 29 Mar 2023 03:33:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1154961C36;
        Wed, 29 Mar 2023 10:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F03C4339B;
        Wed, 29 Mar 2023 10:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680085964;
        bh=vOYzi7+hcrsUCs2akSC8CMn6+Kisn3S6b62l189uz+E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YVeEcyKDS5PnyOWRVI5S+hVao9X9AT3TdMiTGVrzB6m8Shf1WrV/2hPTFyuIgynrA
         dGAhql7lqrx070bz7/0bfKTMCvIBSh6pnd9+PhsQvE+ra7C2UsrPBeVomDERrMUXG5
         Ce6ou4DnDAPgcU3D15fa3Xb7HTXSev/fR/5x6Xb0yWiV6aK4ZQyCL1KA7P3zSYIVO6
         F3vWjsKT4lV8qKAYVbGFtebfHex3aQq7zhZ62FkhODiy6NoZgtdKPfDdasJAPNYjdp
         DxOHH4bTzeUMpbR7+Z9fMyyYwyYoD+NiEDZzx/EFZXrREvmEd9EuAzuk6fO5jpvrGy
         3bbn8hIzqx7sw==
Date:   Wed, 29 Mar 2023 13:32:40 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     saeedm@nvidia.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH 2/2] net/mlx5e: Fix missing error code in
 mlx5e_rx_reporter_err_icosq_cqe_recover()
Message-ID: <20230329103240.GK831478@unreal>
References: <20230324025541.38458-1-jiapeng.chong@linux.alibaba.com>
 <20230324025541.38458-2-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324025541.38458-2-jiapeng.chong@linux.alibaba.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 10:55:41AM +0800, Jiapeng Chong wrote:
> The error code is missing in this code scenario, add the error code
> '-EINVAL' to the return value 'err'.
> 
> drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c:105 mlx5e_tx_reporter_err_cqe_recover() warn: missing error code 'err'.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4600
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
> index 44c1926843a1..5e2e2449668d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
> @@ -101,8 +101,10 @@ static int mlx5e_tx_reporter_err_cqe_recover(void *ctx)
>  		goto out;
>  	}
>  
> -	if (state != MLX5_SQC_STATE_ERR)
> +	if (state != MLX5_SQC_STATE_ERR) {
> +		err = -EINVAL;

Same comment as for patch #1.

>  		goto out;
> +	}
>  
>  	mlx5e_tx_disable_queue(sq->txq);
>  
> -- 
> 2.20.1.7.g153144c
> 
