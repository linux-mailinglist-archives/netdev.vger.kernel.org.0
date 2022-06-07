Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01CA353FAE2
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 12:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240648AbiFGKKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 06:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239830AbiFGKKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 06:10:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7F8A30AE;
        Tue,  7 Jun 2022 03:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEBD861372;
        Tue,  7 Jun 2022 10:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5940AC34115;
        Tue,  7 Jun 2022 10:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654596612;
        bh=uxBnGi0lvT4IHjDBL9QfFrsy/vJI+5YmmsBX/iL2cfg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bzZs64XsqxOYukKB6buDwq6W4Pejor7a65ovN2xzSrG10sP/mVTKxieqa4bgYP8ND
         f1pBuFlzMB77VvFKSyZlnRh5w14OPG6OCb43Ku230hyUhvPU5Hjwb1+8RcS7dRhUGF
         MvSxjqXRBImun85jSONPFz47Kp2Ox5EvCVm1LnoB/dg3ZJc7a/fCOn4wqNHaXO4Nfj
         FUiJjdJKYnKrZlmrobhgW13NnYWNUeJ2cARiEtri+m8mw554fmuYX69NpmAAH9X8Kq
         ysZbJjspmv0LEpnO+cWGx+NAY0GoL2D3MbCmHnF2TlV3On0MjyU0mcQwipNz5VuK6u
         iOwPR05l1BdXw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3941CE737E8;
        Tue,  7 Jun 2022 10:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] stmmac: intel: Fix an error handling path in
 intel_eth_pci_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165459661222.7137.14626873072976245963.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Jun 2022 10:10:12 +0000
References: <1ac9b6787b0db83b0095711882c55c77c8ea8da0.1654462241.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <1ac9b6787b0db83b0095711882c55c77c8ea8da0.1654462241.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        vee.khee.wong@linux.intel.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sun,  5 Jun 2022 22:50:48 +0200 you wrote:
> When the managed API is used, there is no need to explicitly call
> pci_free_irq_vectors().
> 
> This looks to be a left-over from the commit in the Fixes tag. Only the
> .remove() function had been updated.
> 
> So remove this unused function call and update goto label accordingly.
> 
> [...]

Here is the summary with links:
  - stmmac: intel: Fix an error handling path in intel_eth_pci_probe()
    https://git.kernel.org/netdev/net/c/5e74a4b3ec18

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


