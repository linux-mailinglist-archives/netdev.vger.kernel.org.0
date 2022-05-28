Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48238536A31
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 04:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352283AbiE1CUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 22:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiE1CUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 22:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1685BEBE93;
        Fri, 27 May 2022 19:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E24F60F40;
        Sat, 28 May 2022 02:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2B8EC34113;
        Sat, 28 May 2022 02:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653704413;
        bh=o/XjlzHcm4Z3FgMZJdi92PI+sJ669ilzMZZCUVJKzgI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pefiWbyVPY+vRKrb7yeKq3PDAfwRe5RtU6m7a3zES5JOmVZlV0qMJS6fYRYYx4SZO
         FI5vMzQ/5opRKp5Ec63HX8u0dhIpC1GgcoT9PQFteDJIkXJRICDD5lL57a1GEhSKVY
         miGm4CaS/08SkxM+sBP9Wjcu15eTd/baXu4vfU+ezX0Jrzlc3nB7JxJYpUcxdO0Spa
         ok9k36z4Jb8F3HN6rKKw8JOQiUnC3iuFjhhLQnn3RyC4N6vm0BFoEJK2K599l7UdhY
         6httnvKWejcxfSbFPTlOmWoB+lo+gfAstz7MnOaWisdjvFcSUbNfpCRcX2rIRmSXzc
         eLO6jjHczKqiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DA508F03947;
        Sat, 28 May 2022 02:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] net: ipa: fix page free in two spots
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165370441289.6951.6235726319553316017.git-patchwork-notify@kernel.org>
Date:   Sat, 28 May 2022 02:20:12 +0000
References: <20220526152314.1405629-1-elder@linaro.org>
In-Reply-To: <20220526152314.1405629-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mka@chromium.org, evgreen@chromium.org,
        bjorn.andersson@linaro.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 26 May 2022 10:23:12 -0500 you wrote:
> When a receive buffer is not wrapped in an SKB and passed to the
> network stack, the (compound) page gets freed within the IPA driver.
> This is currently quite rare.
> 
> The pages are freed using __free_pages(), but they should instead be
> freed using page_put().  This series fixes this, in two spots.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] net: ipa: fix page free in ipa_endpoint_trans_release()
    https://git.kernel.org/netdev/net/c/155c0c90bca9
  - [net,v2,2/2] net: ipa: fix page free in ipa_endpoint_replenish_one()
    https://git.kernel.org/netdev/net/c/70132763d5d2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


