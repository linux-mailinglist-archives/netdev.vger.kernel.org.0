Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7AA68E4E7
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 01:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjBHAUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 19:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBHAUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 19:20:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2EC4208
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 16:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8683660F96
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 00:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E78B7C4339B;
        Wed,  8 Feb 2023 00:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675815618;
        bh=ofJt4b+23p2LPPZ1xyOaiaXA4qdKvTgG80BA1IU9qNE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E2dSf06N0RfEMhZ5MWequXBBgGU50Zi7USdzxVrAotu3HtjIGZovwUjdlygPJkUg7
         srLGCvquuUrFaWssILUE8HfAfz6j6bMACv4b1D8QGM9KGMaKgDwC7epfNARCSMa/j7
         8/Z9xQ8XRqDKGzPfIfdO25MDdLyr8QhGiu+CZUnmBx9B5d7StPeRO6RSYsqcIMEBn1
         o3yRwjWXLNUisWB9hekuav0AZqnznrTIpgOJgAnolGbiroj6U88hYHPipQq1zDkKgD
         +Hg0/rh7lb4AAmFKwyOYiKV7GYfRYNW29+pyhPYJloB+ItQm86u4E6ZPIhsnG4+ZU0
         /Z3RQiDNmjuyg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CEDE5E55F07;
        Wed,  8 Feb 2023 00:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/4] net: core: use a dedicated kmem_cache for skb
 head allocs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167581561784.18957.1538296507272512785.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Feb 2023 00:20:17 +0000
References: <20230206173103.2617121-1-edumazet@google.com>
In-Reply-To: <20230206173103.2617121-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com, soheil@google.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 Feb 2023 17:30:59 +0000 you wrote:
> Our profile data show that using kmalloc(non_const_size)/kfree(ptr)
> has a certain cost, because kfree(ptr) has to pull a 'struct page'
> in cpu caches.
> 
> Using a dedicated kmem_cache for TCP skb->head allocations makes
> a difference, both in cpu cycles and memory savings.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/4] net: add SKB_HEAD_ALIGN() helper
    https://git.kernel.org/netdev/net-next/c/115f1a5c42bd
  - [v2,net-next,2/4] net: remove osize variable in __alloc_skb()
    https://git.kernel.org/netdev/net-next/c/65998d2bf857
  - [v2,net-next,3/4] net: factorize code in kmalloc_reserve()
    https://git.kernel.org/netdev/net-next/c/5c0e820cbbbe
  - [v2,net-next,4/4] net: add dedicated kmem_cache for typical/small skb->head
    https://git.kernel.org/netdev/net-next/c/bf9f1baa279f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


