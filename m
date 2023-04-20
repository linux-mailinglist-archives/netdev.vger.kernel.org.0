Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 244226E87A3
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbjDTBu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjDTBuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:50:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9261B4C22
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 18:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C304635CF
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6F449C433EF;
        Thu, 20 Apr 2023 01:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681955419;
        bh=Cu26XDuyq5lcZoz0ShVQmRachFypR8wCCTGfVCRr0kc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AeNMQfvQL0xUGhQZuwBID+Vfg1KL01GzIazg36wgQpBQjLeyr+EbHsqyuEsqCwNvB
         wlp97j9vNEzaL7Qn2704lFswH4gETlVdMKGuHbSetDGAK0f1P9BYp6+/0UDr0uLLBe
         ua6FVCIWByeAwuQApHRNpRtnsgtjVr7FFXNa24+SHe7QzRUpt4yTanuc/NHODMWw5O
         aAD17rUpoJm5XVDvWLsge1PAa9mCObK91qvVPBTB9RlgVxuzP8+kR263Tuyluuc7dC
         K1q/MYWu0E0vPLRCP874RTsEMCBYEK1sC57HRDuv5qfrBIh2Kmp+jIeHokZZ/dzXY+
         HI7qyXJrRmvOg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4D301E4D033;
        Thu, 20 Apr 2023 01:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: stmmac: dwmac-meson8b: Avoid cast to
 incompatible function type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168195541930.13596.18249490996446633117.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Apr 2023 01:50:19 +0000
References: <20230418-dwmac-meson8b-clk-cb-cast-v1-1-e892b670cbbb@kernel.org>
In-Reply-To: <20230418-dwmac-meson8b-clk-cb-cast-v1-1-e892b670cbbb@kernel.org>
To:     Simon Horman <horms@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        neil.armstrong@linaro.org, khilman@baylibre.com,
        jbrunet@baylibre.com, martin.blumenstingl@googlemail.com,
        mcoquelin.stm32@gmail.com, nathan@kernel.org,
        ndesaulniers@google.com, trix@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, llvm@lists.linux.dev
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 18 Apr 2023 13:07:33 +0200 you wrote:
> Rather than casting clk_disable_unprepare to an incompatible function
> type provide a trivial wrapper with the correct signature for the
> use-case.
> 
> Reported by clang-16 with W=1:
> 
>  drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c:276:6: error: cast from 'void (*)(struct clk *)' to 'void (*)(void *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
>                                         (void(*)(void *))clk_disable_unprepare,
>                                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> No functional change intended.
> Compile tested only.
> 
> [...]

Here is the summary with links:
  - [net-next] net: stmmac: dwmac-meson8b: Avoid cast to incompatible function type
    https://git.kernel.org/netdev/net-next/c/43bb6100d8d5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


