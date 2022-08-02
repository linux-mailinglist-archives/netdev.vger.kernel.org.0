Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4455587D46
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 15:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbiHBNkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 09:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233655AbiHBNkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 09:40:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB28421A6
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 06:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AE83613B3
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 13:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8DDF5C433B5;
        Tue,  2 Aug 2022 13:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659447613;
        bh=X6dtKZtfK+PGipSixoA2x4zXIP15+ToWzgiIePek78I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZTD6Jn1KHtZEc0S3wsjIWcTS45KuUROD2z+N8obujdd6ygHYtl068LhgKcR/ryBXd
         j5JM996zCwuj1sxus3z7hKsGWSoCyzzqVqijRIr3JTK47FHyeWyoI9f/O3tQZtcfz+
         osxQ1bqgqkWVXYTe6KnSaXiBggieFHKSaY9qnbTXN+r4qSwgzkNGxWTbSjcgfpgjyr
         gfkDcSvRjowdMzuOFV3IFYbwZ9uVmrkvH8jgqlV7cKAcOTsw3wojgmbkPshpyZAE/X
         1obxxQcyB4LOm/0PPQD9yWGOKoMfmTsg2GBwyTGYrJscqShi4YV5e3T8IYmQNVUU96
         5J8ywRw50GbEw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 715AAC43140;
        Tue,  2 Aug 2022 13:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx5e: xsk: Discard unaligned XSK frames on striding
 RQ
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165944761345.10883.7988253606238255364.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Aug 2022 13:40:13 +0000
References: <20220729121356.3990867-1-maximmi@nvidia.com>
In-Reply-To: <20220729121356.3990867-1-maximmi@nvidia.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, saeedm@nvidia.com,
        jonathan.lemon@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, tariqt@nvidia.com,
        gal@nvidia.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 29 Jul 2022 15:13:56 +0300 you wrote:
> Striding RQ uses MTT page mapping, where each page corresponds to an XSK
> frame. MTT pages have alignment requirements, and XSK frames don't have
> any alignment guarantees in the unaligned mode. Frames with improper
> alignment must be discarded, otherwise the packet data will be written
> at a wrong address.
> 
> Fixes: 282c0c798f8e ("net/mlx5e: Allow XSK frames smaller than a page")
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net] net/mlx5e: xsk: Discard unaligned XSK frames on striding RQ
    https://git.kernel.org/netdev/net/c/8eaa1d110800

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


