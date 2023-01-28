Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCEA567F84A
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 14:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234578AbjA1NuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 08:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbjA1NuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 08:50:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FA224135;
        Sat, 28 Jan 2023 05:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38FD260C0B;
        Sat, 28 Jan 2023 13:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8C7D2C433D2;
        Sat, 28 Jan 2023 13:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674913817;
        bh=loBqCJ+Qh7UU3/l0YOccmQieuPwv07+evsG18khX/m0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=STvsptpmrbaedXiFEMkpiFjtuaQG12tKQC0RMxCqLjPYeJPnU1IuX/mJMdz14eA3A
         +L4f3GXAr6f/3M8whQeFYm9z3NP6CN/hhS24cScMf9H8TWGPngiu5gJz7JGvKMwfbF
         UEexmAZ1JqlmfY8OmaN0NRq4mTe9j1rrIEUhjwuALdz+zQZUtyuALsEhsr07mbS+BU
         lYG0yD1SbIvvOpMDeez9ZmbEyvaRmSr1+0Sdb2eUAhd5X8SqGwtM3fVzzu0gFwLCa7
         LV8Ue17eA+zai67IfwPoCT4V3qyz40s+erxqgKO+2vJE/HInU9Dhm5Pq4MsWFiF6cl
         57dvzI9BAmVWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 67C40E54D2D;
        Sat, 28 Jan 2023 13:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] net: wwan: t7xx: Fix Runtime PM implementation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167491381741.30558.11337725225827523567.git-patchwork-notify@kernel.org>
Date:   Sat, 28 Jan 2023 13:50:17 +0000
References: <20230126132535.80339-1-mindal@semihalf.com>
In-Reply-To: <20230126132535.80339-1-mindal@semihalf.com>
To:     =?utf-8?q?Kornel_Dul=C4=99ba_=3Cmindal=40semihalf=2Ecom=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        m.chetan.kumar@linux.intel.com, ricardo.martinez@linux.intel.com,
        loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        rad@semihalf.com, mw@semihalf.com, upstream@semihalf.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 26 Jan 2023 13:25:33 +0000 you wrote:
> d10b3a695ba0 ("net: wwan: t7xx: Runtime PM") introduced support for
> Runtime PM for this driver, but due to a bug in the initialization logic
> the usage refcount would never reach 0, leaving the feature unused.
> This patchset addresses that, together with a bug found after runtime
> suspend was enabled.
> 
> Kornel Dulęba (2):
>   net: wwan: t7xx: Fix Runtime PM resume sequence
>   net: wwan: t7xx: Fix Runtime PM initialization
> 
> [...]

Here is the summary with links:
  - [1/2] net: wwan: t7xx: Fix Runtime PM resume sequence
    https://git.kernel.org/netdev/net/c/364d0221f178
  - [2/2] net: wwan: t7xx: Fix Runtime PM initialization
    https://git.kernel.org/netdev/net/c/e3d6d152a1cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


