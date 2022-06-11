Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3909754706B
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 02:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348088AbiFKAKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 20:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240550AbiFKAKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 20:10:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA21419A
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 17:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E422B837FC
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 00:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 53B48C3411B;
        Sat, 11 Jun 2022 00:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654906214;
        bh=EUNr4qBJq6PI/qWh+udlR4SyFEk8G9yGD8pH0kZbUyY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JMfz5hsZ9RD3EE800nBFHFrde1mVp+OU4EmXYGztOmU5sm0rtsjmbuXUDkGxjICm3
         hGiEa6/4ycqKlSBTfOvS/vP0mKwXLEoBkoA+bz+onJG1v8PlGCnRrkXOJv5VB2QOel
         1f2KvMMFgjROEKVbLvelJtaUtueakSwuzA/OVe7+2e0UeWAjfQqMaIH/htKd0cQjXR
         q/agNUHOM0HgbKe5pAJNfNzYGazhm/GJIYx8I32NNJ3/GDF8wOlF4CA6c05Lj0v+e3
         6bU4wmq1XRE6VwX2ZRDLR3qEereHbKb55otFcLaMt9UUbQf5dhW/nPgWfeIK31VuW5
         f6ysbFQkvXaZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 348C4E737EE;
        Sat, 11 Jun 2022 00:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] net: reduce tcp_memory_allocated inflation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165490621420.10458.10325984202458401848.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Jun 2022 00:10:14 +0000
References: <20220609063412.2205738-1-eric.dumazet@gmail.com>
In-Reply-To: <20220609063412.2205738-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, soheil@google.com, weiwan@google.com,
        shakeelb@google.com, ncardwell@google.com, edumazet@google.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Jun 2022 23:34:05 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Hosts with a lot of sockets tend to hit so called TCP memory pressure,
> leading to very bad TCP performance and/or OOM.
> 
> The problem is that some TCP sockets can hold up to 2MB of 'forward
> allocations' in their per-socket cache (sk->sk_forward_alloc),
> and there is no mechanism to make them relinquish their share
> under mem pressure.
> Only under some potentially rare events their share is reclaimed,
> one socket at a time.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] Revert "net: set SK_MEM_QUANTUM to 4096"
    https://git.kernel.org/netdev/net-next/c/e70f3c701276
  - [net-next,2/7] net: remove SK_MEM_QUANTUM and SK_MEM_QUANTUM_SHIFT
    https://git.kernel.org/netdev/net-next/c/100fdd1faf50
  - [net-next,3/7] net: add per_cpu_fw_alloc field to struct proto
    https://git.kernel.org/netdev/net-next/c/0defbb0af775
  - [net-next,4/7] net: implement per-cpu reserves for memory_allocated
    https://git.kernel.org/netdev/net-next/c/3cd3399dd7a8
  - [net-next,5/7] net: fix sk_wmem_schedule() and sk_rmem_schedule() errors
    https://git.kernel.org/netdev/net-next/c/7c80b038d23e
  - [net-next,6/7] net: keep sk->sk_forward_alloc as small as possible
    https://git.kernel.org/netdev/net-next/c/4890b686f408
  - [net-next,7/7] net: unexport __sk_mem_{raise|reduce}_allocated
    https://git.kernel.org/netdev/net-next/c/0f2c2693988a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


