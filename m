Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D0C6EBF71
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 14:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjDWMaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 08:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDWMaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 08:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8325E10F0;
        Sun, 23 Apr 2023 05:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EAF860F5A;
        Sun, 23 Apr 2023 12:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 673D6C4339B;
        Sun, 23 Apr 2023 12:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682253018;
        bh=x3u0o4CRVGoUpTOcZqcBpH3LsucNfjILoz6/opJTae8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a39wzx2PLQSP+XYGNFoLqNiK0NnciJyggIxNn8dKzcfAO23vSLJ+RY6n3YkL1p2Ns
         LMm8g82DD6NErlwTkWeC71sLLkSvcV96SzxrCDwHPI87hwX/zli0wj6JYtLmDycQg7
         qYnuOwL6XgfJP+fWCrr5gcte/KF8gwBMPdqsnBvBFF77BlwS4IEI04BIPrYrbhb6uo
         m8C6KhFsSsmTX7DHlWYAGO57/12aCw73xhhdTq8pM2L49ppWWLBO6xJ1WcruuGCI+C
         fhCS1qo21R39aGQ2NGWDa9fRmnZRtjcO3vgmxMyQxfO+JCxs0On+FrVjYQM9ynzNoq
         sO+1BAItIcsvA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 406ACC395EA;
        Sun, 23 Apr 2023 12:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mtk_eth_soc: mediatek: fix ppe flow accounting
 for v1 hardware
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168225301826.6341.12919802141863070642.git-patchwork-notify@kernel.org>
Date:   Sun, 23 Apr 2023 12:30:18 +0000
References: <d8474a95a528a4bec5121252205d179f357c7124.1682024624.git.daniel@makrotopia.org>
In-Reply-To: <d8474a95a528a4bec5121252205d179f357c7124.1682024624.git.daniel@makrotopia.org>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, lorenzo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Thu, 20 Apr 2023 22:06:42 +0100 you wrote:
> From: Felix Fietkau <nbd@nbd.name>
> 
> Older chips (like MT7622) use a different bit in ib2 to enable hardware
> counter support. Add macros for both and select the appropriate bit.
> 
> Fixes: 3fbe4d8c0e53 ("net: ethernet: mtk_eth_soc: ppe: add support for flow accounting")
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net: mtk_eth_soc: mediatek: fix ppe flow accounting for v1 hardware
    https://git.kernel.org/netdev/net-next/c/4eaeca1fc43a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


