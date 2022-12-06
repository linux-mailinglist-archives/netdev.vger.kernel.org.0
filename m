Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD7EF644147
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 11:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234098AbiLFKaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 05:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233991AbiLFKaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:30:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE78617439;
        Tue,  6 Dec 2022 02:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B70E61620;
        Tue,  6 Dec 2022 10:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4D53C433C1;
        Tue,  6 Dec 2022 10:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670322615;
        bh=gfQX7CEt4GGovjygsGA5Kh6bJN8dVhhWeBVW+GE7oDA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=REo4ngwvT9aDY5YVWbamiUF7rNyqP7ib4Kz1b9U9spRxmng+JJo3N1p/R2OL3tV9V
         i/IV3lhPwuGdH7HoOtAA7NL2qkTgp3iFKmWhtC8JETwSXGEitKm5yGRyPLtBKQo2FW
         dB0MsMJX2nvo/P7vObNmI0OMzLX5ATpCK/DnZSsP+Zna3+yqSSn86FSlu/tofxGDP0
         FDnxQHMTAayP73OsM5fpOhV11cyqOdTb/ZOk0Aoc2T19SnT8eTicOfBY19789W83n6
         0VZ9W5lBp7RgpEsHM2YCzwxZWDC6HgNcyAs7UOgrfgZOJ71Ey3JnBf66/rdIhgqiXK
         oAnklvItNRLqQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 93FDEE270CF;
        Tue,  6 Dec 2022 10:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mana: Fix race on per-CQ variable napi work_done
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167032261559.29141.6212046728615098270.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Dec 2022 10:30:15 +0000
References: <1670010190-28595-1-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1670010190-28595-1-git-send-email-haiyangz@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        decui@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        paulros@microsoft.com, olaf@aepfle.de, vkuznets@redhat.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri,  2 Dec 2022 11:43:10 -0800 you wrote:
> After calling napi_complete_done(), the NAPIF_STATE_SCHED bit may be
> cleared, and another CPU can start napi thread and access per-CQ variable,
> cq->work_done. If the other thread (for example, from busy_poll) sets
> it to a value >= budget, this thread will continue to run when it should
> stop, and cause memory corruption and panic.
> 
> To fix this issue, save the per-CQ work_done variable in a local variable
> before napi_complete_done(), so it won't be corrupted by a possible
> concurrent thread after napi_complete_done().
> 
> [...]

Here is the summary with links:
  - [net] net: mana: Fix race on per-CQ variable napi work_done
    https://git.kernel.org/netdev/net/c/18010ff776fa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


