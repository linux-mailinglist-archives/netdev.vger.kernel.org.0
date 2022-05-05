Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B991251BAF8
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 10:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350515AbiEEIyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 04:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239091AbiEEIxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 04:53:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05605C4B;
        Thu,  5 May 2022 01:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B39EAB82C12;
        Thu,  5 May 2022 08:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4BC47C385AC;
        Thu,  5 May 2022 08:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651740612;
        bh=P4arw9lfvJgSArNnU3qzYoGZZpvEIT2ZGcRCPJ4Sm/Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=krXzWQD6GGNm2+N7gQthvdm56Oai6atR3npFNdyde9+DXjrwaVqaw55AvDgh+tskY
         6HhmAaTZYcOJP751H4147oAJqPhaMsyMeE2+ueY+lpwvN58vst8aTBfyeOBuqe8TWC
         vbdqkoDyP+pdLYkvTbCsKGplTLElDDp17Zapd4bh3rZR0H56Mz1XcBe/xGmFn/NjFe
         iMwhAisyYCnjhbx7jde6fR93h1dLVo6UmPh+hzFN/dsekHz648UxbqVx69bkDUaf7l
         uP8AlxAG6buTIY0fZJxzUo5GHO+sh4B7f73XFJyeq9TDkkOmUVUy6NL9Sj6wnSQUo1
         EeDXxMMQSGxQw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2CF57F03848;
        Thu,  5 May 2022 08:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] NFC: netlink: fix sleep in atomic bug when firmware
 download timeout
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165174061217.13051.18017190469574513763.git-patchwork-notify@kernel.org>
Date:   Thu, 05 May 2022 08:50:12 +0000
References: <20220504055847.38026-1-duoming@zju.edu.cn>
In-Reply-To: <20220504055847.38026-1-duoming@zju.edu.cn>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     krzysztof.kozlowski@linaro.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed,  4 May 2022 13:58:47 +0800 you wrote:
> There are sleep in atomic bug that could cause kernel panic during
> firmware download process. The root cause is that nlmsg_new with
> GFP_KERNEL parameter is called in fw_dnld_timeout which is a timer
> handler. The call trace is shown below:
> 
> BUG: sleeping function called from invalid context at include/linux/sched/mm.h:265
> Call Trace:
> kmem_cache_alloc_node
> __alloc_skb
> nfc_genl_fw_download_done
> call_timer_fn
> __run_timers.part.0
> run_timer_softirq
> __do_softirq
> ...
> 
> [...]

Here is the summary with links:
  - [net] NFC: netlink: fix sleep in atomic bug when firmware download timeout
    https://git.kernel.org/netdev/net/c/4071bf121d59

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


