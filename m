Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 602CA6990BB
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 11:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjBPKKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 05:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjBPKKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 05:10:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E1A3A083
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 02:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55901B826BB
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 10:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0127C433D2;
        Thu, 16 Feb 2023 10:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676542217;
        bh=DSxQ2gYtKAKVBQDuzWrLIMDDz9UZHjwouvW5p3BseoU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Vns1R9pgm4REt5EF1OkUsltH5oiNioUFOYPAOLps5Qu2YEn9OPdUCg3FAlQtD3FvP
         +2EsJUlnh2N6EI/hm8NenQOtr3VKQj/aQobWTRykbOAYxRAE6GsVU8e96bQhVamxT/
         Omdh93ejkvf6/WVyms5xMZV8/Fw6t3sTcOALEmLTMXy+CqV/oUpesh69ZuO4u9TWle
         O8wfRUdhDKrNOQx4UQdd6FVZMjLT+NDsZgV2oPwzKe9ZtT9Uua+ku8uiPBNxglAkaj
         iCo/NuuorGv8JrbspYhwSMFDgQWGhpTSZMuptJe5PytlKn3YqyTugjPOMNIo4tJ2rN
         6QpLgF8WE0RDw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C1C0CE270C2;
        Thu, 16 Feb 2023 10:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/4] net/sched: transition actions to pcpu stats
 and rcu
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167654221778.31862.18247521790316228412.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Feb 2023 10:10:17 +0000
References: <20230214211534.735718-1-pctammela@mojatatu.com>
In-Reply-To: <20230214211534.735718-1-pctammela@mojatatu.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 14 Feb 2023 18:15:30 -0300 you wrote:
> Following the work done for act_pedit[0], transition the remaining tc
> actions to percpu stats and rcu, whenever possible.
> Percpu stats make updating the action stats very cheap, while combining
> it with rcu action parameters makes it possible to get rid of the per
> action lock in the datapath.
> 
> For act_connmark and act_nat we run the following tests:
> - tc filter add dev ens2f0 ingress matchall action connmark
> - tc filter add dev ens2f0 ingress matchall action nat ingress any 10.10.10.10
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/4] net/sched: act_nat: transition to percpu stats and rcu
    https://git.kernel.org/netdev/net-next/c/7d12057b45fb
  - [net-next,v2,2/4] net/sched: act_connmark: transition to percpu stats and rcu
    https://git.kernel.org/netdev/net-next/c/288864effe33
  - [net-next,v2,3/4] net/sched: act_gate: use percpu stats
    https://git.kernel.org/netdev/net-next/c/7afd073e5521
  - [net-next,v2,4/4] net/sched: act_pedit: use percpu overlimit counter when available
    https://git.kernel.org/netdev/net-next/c/2d2e75d2d4a2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


