Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3D35A4BAE
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 14:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbiH2M0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 08:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiH2M0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 08:26:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E891E0AC
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 05:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8F40611B3
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 12:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 13A9AC433D6;
        Mon, 29 Aug 2022 12:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661775016;
        bh=v5RCrAaLBnTaojOSrXbqh3EzoHFqoeNi6HOWCOuueqw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dtPd/hxUkxbpPLAkSlGOPslxnDyDxyZqwz6bb554bZahWCjBhbb13hhpcIdjgaZGA
         uyAo4gUQUA1+ZoiaQkDbDWgm9kSNM67ahT+me4PsOXvCEYZQUKvA7zXHQL8yPT4ugM
         /M1OLkeI7eCxOkGd1jKfh9N6W6nMRAh47yZRktqJrbyoa64XI/5AMg89AqhUpg5DaA
         OhaLvzGd+gr+8wIJ3dFGShFlg+nCtl7RZu1leqt//SREWKTBaQ8BP+O32sLXX6rBnw
         YkLdakDscnptAY1rBt34IcpD9zSkgtjr2EzCI2FDpfQRWqjpmzGH8wZdNne1SJKTRE
         n4PkUd3rjKzcQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E71C2E924D6;
        Mon, 29 Aug 2022 12:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net: u64_stats fixups for 32bit.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166177501593.22813.2166930979852446923.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Aug 2022 12:10:15 +0000
References: <20220825113645.212996-1-bigeasy@linutronix.de>
In-Reply-To: <20220825113645.212996-1-bigeasy@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        tglx@linutronix.de, peterz@infradead.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 25 Aug 2022 13:36:43 +0200 you wrote:
> Hi,
> 
> while looking at the u64-stats patch
> 	https://lore.kernel.org/all/20220817162703.728679-10-bigeasy@linutronix.de
> 
> I noticed that u64_stats_fetch_begin() is used. That suspicious thing
> about it is that network processing, including stats update, is
> performed in NAPI and so I would expect to see
> u64_stats_fetch_begin_irq() in order to avoid updates from NAPI during
> the read. This is only needed on 32bit-UP where the seqcount is not
> used. This is address in 2/2. The remaining user take some kind of
> precaution and may use u64_stats_fetch_begin().
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: dsa: xrs700x: Use irqsave variant for u64 stats update
    https://git.kernel.org/netdev/net/c/3f8ae9fe0409
  - [net,2/2] net: Use u64_stats_fetch_begin_irq() for stats fetch.
    https://git.kernel.org/netdev/net/c/278d3ba61563

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


