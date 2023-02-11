Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74D15692E18
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 04:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjBKDuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 22:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjBKDuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 22:50:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4131770714
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 19:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF51F61EAF
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 03:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 21651C433EF;
        Sat, 11 Feb 2023 03:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676087418;
        bh=1sx2Mhvnl6fJd9w6uoecZbyPWtwDQmAlmp2sjcxb8JE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bXCVub9E4YIOikq30Q10UC56Ahh2LZ6DJLeIeGIOENFFMzSzREYnMJeRrcS8ud1Ap
         Loiq4s0eSqV6dcIPvyzDBMUG1Du1feUipSsbYiUFKxBGFyisjaEnVrth1w3HLAmxDq
         UW/BftoNpdl/jpxEW7a24s+2FC3Fg3FE8E7P14YyZLsS8o+zv78A9zzKWpZv2RnNtT
         aaKChhnwwMM/xdhLb01/7yqoKUMz8V2QaRwPLHOkZ5YbbDpEv20hjmLadh1bBxGwEx
         e8qlwbQ+xzGbbmnWDN3XXfk11Y3soYc+y6toja2TKnXHVMFB/3XD8SfIM+Rl7p82Fq
         5er5fH3imhdBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 03049E21ECB;
        Sat, 11 Feb 2023 03:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: tcindex: update imperfect hash filters
 respecting rcu
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167608741800.28853.10844322195002364834.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Feb 2023 03:50:18 +0000
References: <20230209143739.279867-1-pctammela@mojatatu.com>
In-Reply-To: <20230209143739.279867-1-pctammela@mojatatu.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, sec@valis.email
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Feb 2023 11:37:39 -0300 you wrote:
> The imperfect hash area can be updated while packets are traversing,
> which will cause a use-after-free when 'tcf_exts_exec()' is called
> with the destroyed tcf_ext.
> 
> CPU 0:               CPU 1:
> tcindex_set_parms    tcindex_classify
> tcindex_lookup
>                      tcindex_lookup
> tcf_exts_change
>                      tcf_exts_exec [UAF]
> 
> [...]

Here is the summary with links:
  - [net] net/sched: tcindex: update imperfect hash filters respecting rcu
    https://git.kernel.org/netdev/net/c/ee059170b1f7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


