Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42BC867118C
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 04:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjARDKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 22:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjARDKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 22:10:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2484FCFD
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 19:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8476B81AB0
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 03:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 96272C433F0;
        Wed, 18 Jan 2023 03:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674011416;
        bh=4sX6P3SdBBWcCcddwDecxkcZKfCy57G6Puodhgot/9E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HkQnN9e1qtwxBFK8KUp2c6mFG4XajBix/ROE7h0AXGNc/A4pBcarqBhTdGFnfq6uD
         2TaA/esqWbAm8TkidLsoeOyVZsS6ItUmFDjdbwtXPFQQPugw8sJlJzROx0sVhJwaA/
         qc3+rk49fBOvmjKYGIMgG8IX7wp0G35LSjnKc7G/4EDxB0jo1tOS+kyXhk7e3XIawZ
         8oeQGB7MtPLOWNayMkRdXK97j78ranHTvo5BbslN1X4ISZ/h7kwgHrYzTgmcSZVsXp
         00XuUBRpAXDkTCgGuhgS6Mxbaxhv1Y6c2/nNrMEDfEfF1Ofa8bbHhL0Y6REAHzdkPZ
         NPbuVPfh9d0Aw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 74F9AC43147;
        Wed, 18 Jan 2023 03:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ipa: disable ipa interrupt during suspend
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167401141647.5924.3330867901216842513.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Jan 2023 03:10:16 +0000
References: <20230115175925.465918-1-caleb.connolly@linaro.org>
In-Reply-To: <20230115175925.465918-1-caleb.connolly@linaro.org>
To:     Caleb Connolly <caleb.connolly@linaro.org>
Cc:     elder@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, elder@linaro.org,
        netdev@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 15 Jan 2023 17:59:24 +0000 you wrote:
> The IPA interrupt can fire when pm_runtime is disabled due to it racing
> with the PM suspend/resume code. This causes a splat in the interrupt
> handler when it tries to call pm_runtime_get().
> 
> Explicitly disable the interrupt in our ->suspend callback, and
> re-enable it in ->resume to avoid this. If there is an interrupt pending
> it will be handled after resuming. The interrupt is a wake_irq, as a
> result even when disabled if it fires it will cause the system to wake
> from suspend as well as cancel any suspend transition that may be in
> progress. If there is an interrupt pending, the ipa_isr_thread handler
> will be called after resuming.
> 
> [...]

Here is the summary with links:
  - [net] net: ipa: disable ipa interrupt during suspend
    https://git.kernel.org/netdev/net/c/9ec9b2a30853

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


