Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6731362D344
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 07:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiKQGJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 01:09:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiKQGJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 01:09:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49A327CC9;
        Wed, 16 Nov 2022 22:09:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47C7662000;
        Thu, 17 Nov 2022 06:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B7FC433D6;
        Thu, 17 Nov 2022 06:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668665354;
        bh=ykcmlVCcgQuy4ZnpZqtryB1wxlczAG8RFuOU1YA1dlc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kOjXQYoIRl39PI10SkrIGedSsGLdAN3C+MFjYfP8OIQzACnIsN2og2rfQvJFcyK1o
         wUMYNX9uSSjXiGzlYOUz0xILRLKwdIFuPUzSAdTpWuVktK8+epvKkNNEHyRT6wi+5o
         QYB9e4EvG1tdZRtX7N4QB0ojkeCFVWX4HXHPIxxLs/chFpI6Eq8NnOyCcjGYQXUxBf
         tysnzF8h8BrHJywzKOfKcBFgmeDIrqGZJ9yOGHlnaqtE2Tzfr+rCGytNz/RqkC9d9m
         de1XPFeqtXqtMN5uWLKKdvuFh+iOdW98BKSBvAEW+zQbBQK3GKqJk8QY/ByFf3pFjm
         NRxOZ9KQ95sgA==
Date:   Thu, 17 Nov 2022 08:09:09 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Dan Carpenter <error27@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH] net: ethernet: renesas: rswitch: Fix MAC address info
Message-ID: <Y3XQBYdEG5EQFgQ+@unreal>
References: <20221115235519.679115-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115235519.679115-1-yoshihiro.shimoda.uh@renesas.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 08:55:19AM +0900, Yoshihiro Shimoda wrote:
> Smatch detected the following warning.
> 
>     drivers/net/ethernet/renesas/rswitch.c:1717 rswitch_init() warn:
>     '%pM' cannot be followed by 'n'
> 
> The 'n' should be '\n'.
> 
> Reported-by: Dan Carpenter <error27@gmail.com>
> Suggested-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  drivers/net/ethernet/renesas/rswitch.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
> index f3d27aef1286..51ce5c26631b 100644
> --- a/drivers/net/ethernet/renesas/rswitch.c
> +++ b/drivers/net/ethernet/renesas/rswitch.c
> @@ -1714,7 +1714,7 @@ static int rswitch_init(struct rswitch_private *priv)
>  	}
>  
>  	for (i = 0; i < RSWITCH_NUM_PORTS; i++)
> -		netdev_info(priv->rdev[i]->ndev, "MAC address %pMn",
> +		netdev_info(priv->rdev[i]->ndev, "MAC address %pM\n",

You can safely drop '\n' from here. It is not needed while printing one
line.

Thanks

>  			    priv->rdev[i]->ndev->dev_addr);
>  
>  	return 0;
> -- 
> 2.25.1
> 
