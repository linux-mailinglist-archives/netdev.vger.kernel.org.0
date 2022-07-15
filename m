Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4745760AA
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 13:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbiGOLkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 07:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiGOLkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 07:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6035E334;
        Fri, 15 Jul 2022 04:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E60FB82BAA;
        Fri, 15 Jul 2022 11:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 954B3C3411E;
        Fri, 15 Jul 2022 11:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657885214;
        bh=gPzsRiE5QwZ1jIMh1d6tdWaf8Lar3t+oij2C1a3b6XU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nbVOdS9a2sYOEsZ7Qc1vRcC5hfckjv6exNyLtnyb2yGN1JFGmtIwh7TDf//bvoWGY
         jRqNA0ApxsCiPB1pBU0C8ZGj5aHcHXc97IG5twUrQlQEFFHFUikEhyGf6fiD6Bjgds
         SQnxRlKQRa7J8LpilOcPnVWsvnbfmzzhO30+wOtXnsK64Uqy/6DIxr2Yb4zK/4bnfe
         oHwzLkYsd5zad13UN4iPvAkMXPSG4kQ6S8KuhQZAFNKANhkqRM1zku/8HAQ/4KcdZU
         yHSKrdeeYENNLl53r3zUHiM1Gm5bzOq2wI+Ex8hjOLgXP1OgyDSXQkDwGyIN+wbOEU
         G/U+M9hEVn9Yw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 721ECE45227;
        Fri, 15 Jul 2022 11:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v5 0/3] stmmac: dwmac-mediatek: fix clock issue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165788521446.32301.11367784374221397861.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Jul 2022 11:40:14 +0000
References: <20220714060014.18958-1-biao.huang@mediatek.com>
In-Reply-To: <20220714060014.18958-1-biao.huang@mediatek.com>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     davem@davemloft.net, matthias.bgg@gmail.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        angelogioacchino.delregno@collabora.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, macpaul.lin@mediatek.com,
        jszhang@kernel.org, mohammad.athari.ismail@intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 14 Jul 2022 14:00:11 +0800 you wrote:
> changes in v5:
> 1. add reivewd-by as Matthias's comments.
> 2. fix "warning: unused variable 'ret' [-Wunused-variable]" as Jakub's comments
> 
> changes in v4:
> 1. improve commit message and test ko insertion/remove as Matthias's comments.
> 2. add patch "net: stmmac: fix pm runtime issue in stmmac_dvr_remove()" to
>    fix vlan filter deletion issue.
> 3. add patch "net: stmmac: fix unbalanced ptp clock issue in suspend/resume flow"
>    to fix unbalanced ptp clock issue in suspend/resume flow.
> 
> [...]

Here is the summary with links:
  - [net,v5,1/3] stmmac: dwmac-mediatek: fix clock issue
    https://git.kernel.org/netdev/net/c/fa4b3ca60e80
  - [net,v5,2/3] net: stmmac: fix pm runtime issue in stmmac_dvr_remove()
    https://git.kernel.org/netdev/net/c/0d9a15913b87
  - [net,v5,3/3] net: stmmac: fix unbalanced ptp clock issue in suspend/resume flow
    https://git.kernel.org/netdev/net/c/f4c7d8948e86

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


