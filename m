Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36DD26D1767
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 08:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjCaGaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 02:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCaGaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 02:30:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3602685;
        Thu, 30 Mar 2023 23:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1A69623A3;
        Fri, 31 Mar 2023 06:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 54A24C4339C;
        Fri, 31 Mar 2023 06:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680244220;
        bh=oVNrIse3VEoOTwiJCZSaD19tmzueBrN/XPGjwvdI2fQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=obV1cb54LwI/ig5zUv5OjGv5bgPZatX/pcn1cwoEvj5DJReOh06kNZlkf03iazlAu
         M1ptqUnRz5ZPihbtmWSfMHUnO+xDINmr/Z9AKKvjuGBVsFig6UdPhAn8LDnIfBEhBt
         WLTWnwzI4JYVt5mEcE5fFbsjAv6HSRvttjWKDUpIrLLWkEtWNy01xwazWkzhApPLCd
         tGOkQLBxtyxMAPnvblsE0N+YWt8o0GZWCGic9yNKLGwwibEqQnuKb+M8AQNXQPqqvg
         tUJ0e1FmDBolx/LyBV3Rjk/JqFuGz3QaTwY0TNHI0eBpbiu0mC0JVvC5BiuLpzVtxT
         zwZJ9th+ePurQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2B776C0C40E;
        Fri, 31 Mar 2023 06:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: ti: Fix format specifier in
 netcp_create_interface()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168024422016.32019.3404856022157277759.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Mar 2023 06:30:20 +0000
References: <20230329-net-ethernet-ti-wformat-v1-1-83d0f799b553@kernel.org>
In-Reply-To: <20230329-net-ethernet-ti-wformat-v1-1-83d0f799b553@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ndesaulniers@google.com, trix@redhat.com,
        razor@blackwall.org, kerneljasonxing@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Mar 2023 08:08:01 -0700 you wrote:
> After commit 3948b05950fd ("net: introduce a config option to tweak
> MAX_SKB_FRAGS"), clang warns:
> 
>   drivers/net/ethernet/ti/netcp_core.c:2085:4: warning: format specifies type 'long' but the argument has type 'int' [-Wformat]
>                           MAX_SKB_FRAGS);
>                           ^~~~~~~~~~~~~
>   include/linux/dev_printk.h:144:65: note: expanded from macro 'dev_err'
>           dev_printk_index_wrap(_dev_err, KERN_ERR, dev, dev_fmt(fmt), ##__VA_ARGS__)
>                                                                  ~~~     ^~~~~~~~~~~
>   include/linux/dev_printk.h:110:23: note: expanded from macro 'dev_printk_index_wrap'
>                   _p_func(dev, fmt, ##__VA_ARGS__);                       \
>                                ~~~    ^~~~~~~~~~~
>   include/linux/skbuff.h:352:23: note: expanded from macro 'MAX_SKB_FRAGS'
>   #define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
>                         ^~~~~~~~~~~~~~~~~~~~
>   ./include/generated/autoconf.h:11789:30: note: expanded from macro 'CONFIG_MAX_SKB_FRAGS'
>   #define CONFIG_MAX_SKB_FRAGS 17
>                                ^~
>   1 warning generated.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: ti: Fix format specifier in netcp_create_interface()
    https://git.kernel.org/netdev/net-next/c/3292004c90c8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


