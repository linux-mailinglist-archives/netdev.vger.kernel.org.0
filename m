Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373876DCF55
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 03:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjDKBav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 21:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjDKBas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 21:30:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0872D42
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 18:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68E03617EB
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 01:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C6DABC4339B;
        Tue, 11 Apr 2023 01:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681176619;
        bh=/Yyjp4aswBNiFFuiSfU+CvgMect6bhadVZoVfce6rIs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cCHj/9SfNrsJjdBZEoJ8LVls35oNnVCaZSCvGRaRq5gaQnMayTL/OX5Cx1jvf9P0X
         sUZE0/RehjGZ/wBSS1EM2/yZPzmw+mzLpkJtF0TwdffvS9bRyCPOt7TxvW3sp3iMib
         gu8ZcojfY4jBJ0er/XEg1NZE333dsI7LG2EA4jfFSplf6ShB9T5FerN97pvadymJRo
         DDtXwGZ8ftC8Vi5He/92ue1m7f3YJwyOstN3JGnJ/pGC8Xo35unV8q+o+QvsL9MWle
         qb/UwIJqVlApKyTFsWCjgWixYkauhHugkVwOCajz1rYDhF97LjVMPYKv9eksUnHBHP
         Hhby/TNrbYCXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A902FC395C5;
        Tue, 11 Apr 2023 01:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/7] net: lockless stop/wake combo macros
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168117661968.11047.3319343248314930577.git-patchwork-notify@kernel.org>
Date:   Tue, 11 Apr 2023 01:30:19 +0000
References: <20230407012536.273382-1-kuba@kernel.org>
In-Reply-To: <20230407012536.273382-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, herbert@gondor.apana.org.au,
        alexander.duyck@gmail.com, hkallweit1@gmail.com, andrew@lunn.ch,
        willemb@google.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  6 Apr 2023 18:25:29 -0700 you wrote:
> A lot of drivers follow the same scheme to stop / start queues
> without introducing locks between xmit and NAPI tx completions.
> I'm guessing they all copy'n'paste each other's code.
> The original code dates back all the way to e1000 and Linux 2.6.19.
> 
> v4:
>  - adjust a comment in patch 4
>  - use IS_ENABLED() in patch 7
> v3: https://lore.kernel.org/all/20230405223134.94665-1-kuba@kernel.org/
>  - render the info as part of documentation, maybe someone will
>    notice and use it (patches 1, 2, 3 are new)
>  - use the __after_atomic barrier
>  - add last patch to avoid a barrier in the wake path
> more detailed change logs in the patches.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/7] docs: net: reformat driver.rst from a list to sections
    https://git.kernel.org/netdev/net-next/c/d2f5c68e3f71
  - [net-next,v4,2/7] docs: net: move the probe and open/close sections of driver.rst up
    https://git.kernel.org/netdev/net-next/c/da4f0f82ee9d
  - [net-next,v4,3/7] docs: net: use C syntax highlight in driver.rst
    https://git.kernel.org/netdev/net-next/c/8336462539ae
  - [net-next,v4,4/7] net: provide macros for commonly copied lockless queue stop/wake code
    https://git.kernel.org/netdev/net-next/c/c91c46de6bbc
  - [net-next,v4,5/7] ixgbe: use new queue try_stop/try_wake macros
    https://git.kernel.org/netdev/net-next/c/9ded5bc77fe5
  - [net-next,v4,6/7] bnxt: use new queue try_stop/try_wake macros
    https://git.kernel.org/netdev/net-next/c/08a096780d92
  - [net-next,v4,7/7] net: piggy back on the memory barrier in bql when waking queues
    https://git.kernel.org/netdev/net-next/c/301f227fc860

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


