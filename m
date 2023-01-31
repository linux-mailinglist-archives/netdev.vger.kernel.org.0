Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7005682A03
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 11:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbjAaKKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 05:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbjAaKKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 05:10:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA2955A0;
        Tue, 31 Jan 2023 02:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EB46614A6;
        Tue, 31 Jan 2023 10:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AF0BBC4339C;
        Tue, 31 Jan 2023 10:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675159816;
        bh=DvKtYzzpjflO0vF6Cv4Kw+3GCPHynmxPJ8rU1/hauo4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Rv7AfahQedbQhwLUuO6led/h7alndRek9sv3hZU74MoVu4Urnt2b7W1NS2q3TsV/r
         NdI7xeIRMfclV3u87lUfNtQ+2kcjUkjH1dzu/nm5xC7GKczGLOLxeIfeuTh/FjxC7f
         p/akc579kjY2NJ5HNgYgt97wjQZarUUbHzO1nX8uzzfMD6ff7j5cHEYKUOg30AKjnI
         Dm7Inkc2+pgGBD2mJDAKYJdtWmCVj00VLeUiDKmVz4xbW45Dqd1pPGQ3Wc1zA0pCM2
         GVmjg7KhbSMZh2dyCYoloqF6Zzrg5nbtmZFoDT4Kflwmsy/uOoRz6KsvxpcByCaAcJ
         JsPKkfEHZEtHA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 92F0AC072E7;
        Tue, 31 Jan 2023 10:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sched: sch: Bounds check priority
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167515981659.18378.9901152826514000200.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Jan 2023 10:10:16 +0000
References: <20230127224036.never.561-kees@kernel.org>
In-Reply-To: <20230127224036.never.561-kees@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
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

On Fri, 27 Jan 2023 14:40:37 -0800 you wrote:
> Nothing was explicitly bounds checking the priority index used to access
> clpriop[]. WARN and bail out early if it's pathological. Seen with GCC 13:
> 
> ../net/sched/sch_htb.c: In function 'htb_activate_prios':
> ../net/sched/sch_htb.c:437:44: warning: array subscript [0, 31] is outside array bounds of 'struct htb_prio[8]' [-Warray-bounds=]
>   437 |                         if (p->inner.clprio[prio].feed.rb_node)
>       |                             ~~~~~~~~~~~~~~~^~~~~~
> ../net/sched/sch_htb.c:131:41: note: while referencing 'clprio'
>   131 |                         struct htb_prio clprio[TC_HTB_NUMPRIO];
>       |                                         ^~~~~~
> 
> [...]

Here is the summary with links:
  - net: sched: sch: Bounds check priority
    https://git.kernel.org/netdev/net/c/de5ca4c3852f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


