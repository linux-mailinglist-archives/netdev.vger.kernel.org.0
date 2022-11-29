Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 470C863C60C
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 18:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235803AbiK2RDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 12:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236582AbiK2RCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 12:02:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3786DCC0
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 09:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24B686186B
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 17:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6ECA8C4314F;
        Tue, 29 Nov 2022 17:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669741218;
        bh=f1ssiwileycc6un5qlFX7XlYKXjz0LbA0CQRYT4SxK0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AjZSVGolDExBeyLDAdx++h/iqAOKX2q/C0avY3AKSEyq8dIfEikmx6BgX+lr/gYkW
         3XyqxJZwKaHiLs/EmtNkBj5rgApyOnsfCtwkTi5hRHoSalwm9ABy0cPEl2DsHa/Qr3
         bnMO16v7vB+EOPlBSwuVle3a7yzMNlLBXIEdG1VamxArWQ+0WOz9uN45oimvwD1D7S
         MvLiCf8xHJv9RQ8V6rDX8Jyocg0bI8X23g9BZ15od4YHvVaxAGhCKTXD+Du5z6KIFT
         WoE4M3QXZncI9Q6YEnP/iyeBAeda1fCOGV7VHUc+/RQdLz9CZeGdiGDPwpOMh0Wlnj
         2bvmUL40tyiOw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 52DD8E4D010;
        Tue, 29 Nov 2022 17:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] Revert "net/mlx5e: MACsec,
 remove replay window size limitation in offload path"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166974121833.7750.15463012802754678898.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 17:00:18 +0000
References: <20221129093006.378840-1-saeed@kernel.org>
In-Reply-To: <20221129093006.378840-1-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, jacob.e.keller@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 29 Nov 2022 01:30:05 -0800 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> This reverts commit c0071be0e16c461680d87b763ba1ee5e46548fde.
> 
> The cited commit removed the validity checks which initialized the
> window_sz and never removed the use of the now uninitialized variable,
> so now we are left with wrong value in the window size and the following
> clang warning: [-Wuninitialized]
> drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c:232:45:
>        warning: variable 'window_sz' is uninitialized when used here
>        MLX5_SET(macsec_aso, aso_ctx, window_size, window_sz);
> 
> [...]

Here is the summary with links:
  - [net,1/2] Revert "net/mlx5e: MACsec, remove replay window size limitation in offload path"
    https://git.kernel.org/netdev/net/c/dda3bbbb26c8
  - [net,2/2] net/mlx5: Lag, Fix for loop when checking lag
    https://git.kernel.org/netdev/net/c/0e682f04b4b5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


