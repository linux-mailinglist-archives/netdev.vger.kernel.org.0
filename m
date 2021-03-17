Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238BA33FAA4
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 22:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhCQVuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 17:50:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:43126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230299AbhCQVuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 17:50:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1E30164F18;
        Wed, 17 Mar 2021 21:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616017808;
        bh=8N/UcL9zHOU1JVTMxG/t4Y6zTt3tVOiZ3f7lfHH3g8k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kooYlyxh/c41ZR4naKroIei1p9grHDz7C0V8xT5636cg+Jq/oCwr8hyqiWofXo1R7
         yYEhyeu9qQV5KVqfRL87dUpDy+s08ZvzGVQVHfd7PcAKVSOGaIPyI681txEken33ox
         dFfc42iA1fLRdJhhZih467uw8uO8cpZw1VlSulwfmCmNrbtAiXA6H9bZuSi17jkvQr
         hxrUmgJMbonk62b5KV/m8N9nM5U5Y+9dJub+1J+9WxUsDDuVuYvOmNErWhlB1vmIeo
         Blu/gg6hc5ZcqC8z9DGK0rRr2HS3cjdaMkRK/98+VYS9zFgPtEJY+FTjU4ryq2JZ6M
         jddUnU4y0suww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 11BAB60A45;
        Wed, 17 Mar 2021 21:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4] net: fix race between napi kthread mode and busy poll
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161601780806.9052.16136317962549586493.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Mar 2021 21:50:08 +0000
References: <20210316223647.4080796-1-weiwan@google.com>
In-Reply-To: <20210316223647.4080796-1-weiwan@google.com>
To:     Wei Wang <weiwan@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        micron10@gmail.com, alexanderduyck@fb.com, edumazet@google.com,
        pabeni@redhat.com, hannes@stressinduktion.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 16 Mar 2021 15:36:47 -0700 you wrote:
> Currently, napi_thread_wait() checks for NAPI_STATE_SCHED bit to
> determine if the kthread owns this napi and could call napi->poll() on
> it. However, if socket busy poll is enabled, it is possible that the
> busy poll thread grabs this SCHED bit (after the previous napi->poll()
> invokes napi_complete_done() and clears SCHED bit) and tries to poll
> on the same napi. napi_disable() could grab the SCHED bit as well.
> This patch tries to fix this race by adding a new bit
> NAPI_STATE_SCHED_THREADED in napi->state. This bit gets set in
> ____napi_schedule() if the threaded mode is enabled, and gets cleared
> in napi_complete_done(), and we only poll the napi in kthread if this
> bit is set. This helps distinguish the ownership of the napi between
> kthread and other scenarios and fixes the race issue.
> 
> [...]

Here is the summary with links:
  - [net,v4] net: fix race between napi kthread mode and busy poll
    https://git.kernel.org/netdev/net/c/cb038357937e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


