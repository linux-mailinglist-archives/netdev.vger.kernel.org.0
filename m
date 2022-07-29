Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C041584AF1
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 07:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbiG2FAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 01:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234161AbiG2FAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 01:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C1F1573E
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 22:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B956861E83
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 05:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1305CC433D7;
        Fri, 29 Jul 2022 05:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659070816;
        bh=y/SRXULUULDBReY9+DX2mIT7CSx8BAMs9xNbGb2okMY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oA6AzK77ZkMbfs5NRFSyWObtIZJ9y2dyAk207mag4am/hiKFYc639jxbZ9txBouIh
         2s01D8yn4pWUdy/00p3WiJXfI/ZcpL/OHWk+AlKZRJk0zfugU6ZznOHbqM1IRDrjhk
         sneH8LlZQ16nciv5CFugJE063eFTfmk6X4jgz44yw/4CwasZKIBzGQJOG/ixJvZKgY
         Da3KdKgyEVnAlYaCQIXAXEoIexIIi/bZc22ibTXpK07KZ515aElDiD8DG5yaTVTpwv
         Qci/A1tdVU7f55V1PiyH6NUa3gZhiabTv3l49NQACM8VoYHd7svyGKG+up/dxeXhq7
         tKfqiShy+rp9Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DE45FC43140;
        Fri, 29 Jul 2022 05:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V3 0/6] mlx5e use TLS TX pool to improve connection
 rate
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165907081590.3346.4921350979287597508.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jul 2022 05:00:15 +0000
References: <20220727094346.10540-1-tariqt@nvidia.com>
In-Reply-To: <20220727094346.10540-1-tariqt@nvidia.com>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, saeedm@nvidia.com, gal@nvidia.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 27 Jul 2022 12:43:40 +0300 you wrote:
> To offload encryption operations, the mlx5 device maintains state and
> keeps track of every kTLS device-offloaded connection.  Two HW objects
> are used per TX context of a kTLS offloaded connection: a. Transport
> interface send (TIS) object, to reach the HW context.  b. Data Encryption
> Key (DEK) to perform the crypto operations.
> 
> These two objects are created and destroyed per TLS TX context, via FW
> commands.  In total, 4 FW commands are issued per TLS TX context, which
> seriously limits the connection rate.
> 
> [...]

Here is the summary with links:
  - [net-next,V3,1/6] net/tls: Perform immediate device ctx cleanup when possible
    https://git.kernel.org/netdev/net-next/c/113671b255ee
  - [net-next,V3,2/6] net/tls: Multi-threaded calls to TX tls_dev_del
    https://git.kernel.org/netdev/net-next/c/7adc91e0c939
  - [net-next,V3,3/6] net/mlx5e: kTLS, Introduce TLS-specific create TIS
    https://git.kernel.org/netdev/net-next/c/da6682faa82f
  - [net-next,V3,4/6] net/mlx5e: kTLS, Take stats out of OOO handler
    https://git.kernel.org/netdev/net-next/c/23b1cf1e3fe0
  - [net-next,V3,5/6] net/mlx5e: kTLS, Recycle objects of device-offloaded TLS TX connections
    https://git.kernel.org/netdev/net-next/c/c4dfe704f53f
  - [net-next,V3,6/6] net/mlx5e: kTLS, Dynamically re-size TX recycling pool
    https://git.kernel.org/netdev/net-next/c/624bf0992133

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


