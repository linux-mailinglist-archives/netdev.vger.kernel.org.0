Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC706EBF90
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 14:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbjDWMuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 08:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjDWMuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 08:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818F310CC
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 05:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EDEB60F0F
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 12:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88D51C4339B;
        Sun, 23 Apr 2023 12:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682254219;
        bh=htwthnm22klySR24DhIdSvCcSX9AAXZfnWR+pAxx6Zo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gq1tU0I5w84y7DN7wJkMsWYwmUEZPWyz5W9vA0EH7ppgcGEmtUEW1n0FyA64kgb0n
         Xw82+tTY3Quk6qwT0L1jmqxiLXhjTpCA12V6bKKYjm+G60ZSTkFbgPngW3Og1dxzpf
         NWzhGSCuY1Cc5/ctO7kXyIXf2jcNP+5fHYnhCTlAAu3aFdOh6tAdEqQyhgBnLLGKKA
         j2WcMmlktvsZs+MtMSU/leAYlu6pPHnaNHnoZyUkEvv+BDPTSCegzLjywUOgkhXIj0
         Yys1QeB1elIxfqyqCKaEwIG/pIn5FmqSdho8/yyZSyz6h0lRuwO40fXiBDfPtwPezx
         uIsZ2e0sQ+FRQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 738DBC395EA;
        Sun, 23 Apr 2023 12:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] net: give napi_threaded_poll() some love
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168225421946.16046.7955850212787041275.git-patchwork-notify@kernel.org>
Date:   Sun, 23 Apr 2023 12:50:19 +0000
References: <20230421094357.1693410-1-edumazet@google.com>
In-Reply-To: <20230421094357.1693410-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 21 Apr 2023 09:43:52 +0000 you wrote:
> There is interest to revert commit 4cd13c21b207
> ("softirq: Let ksoftirqd do its job") and use instead the
> napi_threaded_poll() mode.
> 
> https://lore.kernel.org/netdev/140f61e2e1fcb8cf53619709046e312e343b53ca.camel@redhat.com/T/#m8a8f5b09844adba157ad0d22fc1233d97013de50
> 
> Before doing so, make sure napi_threaded_poll() benefits
> from recent core stack improvements, to further reduce
> softirq triggers.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: add debugging checks in skb_attempt_defer_free()
    https://git.kernel.org/netdev/net-next/c/e8e1ce8454c9
  - [net-next,2/5] net: do not provide hard irq safety for sd->defer_lock
    https://git.kernel.org/netdev/net-next/c/931e93bdf8ca
  - [net-next,3/5] net: move skb_defer_free_flush() up
    https://git.kernel.org/netdev/net-next/c/e6f50edfef04
  - [net-next,4/5] net: make napi_threaded_poll() aware of sd->defer_list
    https://git.kernel.org/netdev/net-next/c/a1aaee7f8f79
  - [net-next,5/5] net: optimize napi_threaded_poll() vs RPS/RFS
    https://git.kernel.org/netdev/net-next/c/87eff2ec57b6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


