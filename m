Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804056D1A91
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbjCaImH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbjCaIlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:41:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7DD1D871;
        Fri, 31 Mar 2023 01:41:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B85E562558;
        Fri, 31 Mar 2023 08:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B507C433A0;
        Fri, 31 Mar 2023 08:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680252019;
        bh=MFc42CRC11od6L4dhbhC0cOLgdVUVYfS+K7b97A2Tcc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MMNjDr+mSAYGmag1SbgumSybts688xcU4ggJx8yq1vAB5eldjoySBrbzwWFD2u21E
         0dq1wiI/YtPuCIha7U0A5ssV7Zw3TmcS9+CojYDhtPUTRugUJaOEXELc9ACWI3hoPo
         mZ02BBrrVTYHlCUo0Z15Q3Rv60pejrYA5pb0mIFTeO2mHLKrl7X8PDcEe3u+qjdjde
         /P5J3ZbGOfALN0+bCZpdXcJAlnYQnYz7T7+FJxOGYRuoLovw9scg2E5Co0XXSVPJeM
         +oWIw385fbHrOrcdrXbNls5BLwCaeT3kZzEwgQn72yauvGRxNJoVMoX4UdJDiWVVfJ
         LysVN3t4N2Dfw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DA98EC73FE2;
        Fri, 31 Mar 2023 08:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: wwan: t7xx: do not compile with -Werror
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168025201889.3875.15656293557332805344.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Mar 2023 08:40:18 +0000
References: <20230331063515.947-1-jirislaby@kernel.org>
In-Reply-To: <20230331063515.947-1-jirislaby@kernel.org>
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     kuba@kernel.org, linux-kernel@vger.kernel.org,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        m.chetan.kumar@linux.intel.com, ricardo.martinez@linux.intel.com,
        loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 31 Mar 2023 08:35:15 +0200 you wrote:
> When playing with various compilers or their versions, some choke on
> the t7xx code. For example (with gcc 13):
>  In file included from ./arch/s390/include/generated/asm/rwonce.h:1,
>                   from ../include/linux/compiler.h:247,
>                   from ../include/linux/build_bug.h:5,
>                   from ../include/linux/bits.h:22,
>                   from ../drivers/net/wwan/t7xx/t7xx_state_monitor.c:17:
>  In function 'preempt_count',
>      inlined from 't7xx_fsm_append_event' at ../drivers/net/wwan/t7xx/t7xx_state_monitor.c:439:43:
>  ../include/asm-generic/rwonce.h:44:26: error: array subscript 0 is outside array bounds of 'const volatile int[0]' [-Werror=array-bounds=]
> 
> [...]

Here is the summary with links:
  - net: wwan: t7xx: do not compile with -Werror
    https://git.kernel.org/netdev/net/c/362f0b6678ad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


