Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAB1687DC6
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 13:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbjBBMpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 07:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbjBBMpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 07:45:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED00C8D41C;
        Thu,  2 Feb 2023 04:45:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC17361B03;
        Thu,  2 Feb 2023 12:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1EDD2C433A0;
        Thu,  2 Feb 2023 12:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675341618;
        bh=lKCownz5/4U7NVc3nPT9kCP+pGhNqlrUFsCLB1dLSZ0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JVe/OTmrFEQVDGUsoFaYQa33xZic5PZtBvJmiXXg7uLXOfRVvvbYppgx/bDw06VGh
         JfusuWHTw5xOZ9MvsmdfNZyTnxUr+YOGPnxsw3bpFkHC9PzX1ooxntjZW7gHCmglca
         YlC1zFHZVY4ifr51wQkj6TnbCGHFHN7kd3x+tcypYlj9p9secdTmVF6IEaX3D6WKKP
         YqhpXvYQV6a7vfgfg3FCS7zFBAWr+qVlfh54Ks5cKl/xlV7Y3/Qn6xlXj+gARRVBv5
         qkWWSsJ3o5UmMEYQX3UughlVL7DfEpRrEWxjPjoYT5v+1LMvNTOW4MyfDOc+tS77Lp
         SxJx4yAP8m/Kg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 00A73C0C40E;
        Thu,  2 Feb 2023 12:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4 1/4] selftests: net: udpgso_bench_rx: Fix 'used
 uninitialized' compiler warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167534161799.16818.2148957756242883137.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 12:40:17 +0000
References: <20230201001612.515730-1-andrei.gherzan@canonical.com>
In-Reply-To: <20230201001612.515730-1-andrei.gherzan@canonical.com>
To:     Andrei Gherzan <andrei.gherzan@canonical.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed,  1 Feb 2023 00:16:10 +0000 you wrote:
> This change fixes the following compiler warning:
> 
> /usr/include/x86_64-linux-gnu/bits/error.h:40:5: warning: ‘gso_size’ may
> be used uninitialized [-Wmaybe-uninitialized]
>    40 |     __error_noreturn (__status, __errnum, __format,
>    __va_arg_pack ());
>          |
> 	 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 	 udpgso_bench_rx.c: In function ‘main’:
> 	 udpgso_bench_rx.c:253:23: note: ‘gso_size’ was declared here
> 	   253 |         int ret, len, gso_size, budget = 256;
> 
> [...]

Here is the summary with links:
  - [net,v4,1/4] selftests: net: udpgso_bench_rx: Fix 'used uninitialized' compiler warning
    https://git.kernel.org/netdev/net/c/c03c80e3a03f
  - [net,v4,2/4] selftests: net: udpgso_bench_rx/tx: Stop when wrong CLI args are provided
    https://git.kernel.org/netdev/net/c/db9b47ee9f5f
  - [net,v4,3/4] selftests: net: udpgso_bench: Fix racing bug between the rx/tx programs
    https://git.kernel.org/netdev/net/c/dafe93b9ee21
  - [net,v4,4/4] selftests: net: udpgso_bench_tx: Cater for pending datagrams zerocopy benchmarking
    https://git.kernel.org/netdev/net/c/329c9cd769c2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


