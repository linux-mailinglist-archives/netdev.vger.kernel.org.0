Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 031C3598A9C
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345247AbiHRRko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345219AbiHRRkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:40:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D7F696FF;
        Thu, 18 Aug 2022 10:40:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 060F3B82357;
        Thu, 18 Aug 2022 17:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C93FC433C1;
        Thu, 18 Aug 2022 17:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660844436;
        bh=yNeFws/1Db4rGKVqEFTLGuONzvqcqQUN7ZodpwwhCmU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fgLXQbFEcJQkozcIVtrGPmx0kFbkR0CRxU8sgIUbagwA8UnFrHtD0A2z0rF4L+Zzq
         sCYvgLVILtpUERgXpzSekRXMQoUux0EOztlOJb+xSdA3btxru7Mwl97ykGR07raqvD
         WRCxR4IT+/NB+UtIhL/RxuSi6wQutEXFnYi+QcdTplP4q+FRjy47228anQoatr1VGQ
         Yemk+5CcrEU39LLSnQyyGQLCKtHrTbTYpICaD2jEATdI6Pj9aIoDWugGkTuZLNplhm
         Q/GIxBlub1f06XFnyFkXl7yIJIljxqf6adxOuv8O4TnNH7PDk23brfdFXfAcgDfb/E
         3UoNLMOkAOszg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5DBDDE2A058;
        Thu, 18 Aug 2022 17:40:36 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/2] stmmac: intel: Add a missing clk_disable_unprepare()
 call in intel_eth_pci_remove()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166084443637.19225.202296976141883530.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Aug 2022 17:40:36 +0000
References: <d7c8c1dadf40df3a7c9e643f76ffadd0ccc1ad1b.1660659689.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <d7c8c1dadf40df3a7c9e643f76ffadd0ccc1ad1b.1660659689.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        qiangqing.zhang@nxp.com, andrew@lunn.ch,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        andriy.shevchenko@linux.intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 16 Aug 2022 16:23:57 +0200 you wrote:
> Commit 09f012e64e4b ("stmmac: intel: Fix clock handling on error and remove
> paths") removed this clk_disable_unprepare()
> 
> This was partly revert by commit ac322f86b56c ("net: stmmac: Fix clock
> handling on remove path") which removed this clk_disable_unprepare()
> because:
> "
>    While unloading the dwmac-intel driver, clk_disable_unprepare() is
>    being called twice in stmmac_dvr_remove() and
>    intel_eth_pci_remove(). This causes kernel panic on the second call.
> "
> 
> [...]

Here is the summary with links:
  - [v2,1/2] stmmac: intel: Add a missing clk_disable_unprepare() call in intel_eth_pci_remove()
    https://git.kernel.org/netdev/net/c/5c23d6b717e4
  - [v2,2/2] stmmac: intel: Simplify intel_eth_pci_remove()
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


