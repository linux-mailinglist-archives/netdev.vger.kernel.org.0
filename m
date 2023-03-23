Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4BD6C5EAB
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCWFUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjCWFUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D45171E;
        Wed, 22 Mar 2023 22:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B54E9623E7;
        Thu, 23 Mar 2023 05:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11346C433D2;
        Thu, 23 Mar 2023 05:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679548818;
        bh=gHiDkwY3P3FOscx7QJ+Z452hyjh1QaOF11LfbEWAQvA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tBTNq9OLxSy4VeVhNHuq5TeDen9mkf0B0fF4/AUcqXroaQaItTdg+BCzYkAATyzAs
         ar+tJG188n7K6RsNcNJHToVJl2pbLKvmZybCNG9v6sWzKgemTveuL+SBPIn3ousRix
         zkIKJCgOTfE96TOqBfgSRVa/wnvOfwboXsqEmLALM5apvQ1aHsd2aITnZHSF5mrMsW
         CYXgT8qRsZXIE5vmaqU7ndYw3iUsyuuPvfBYK0XpZklxw2kxJtbqW3BfHxLWXSes2I
         QlBvOw4E0iAjxi/Oyp30VOjWUt0xwnqCvbjf7J5ULNfNVtJIvxH8stOZRGs0ZuyPNQ
         Tg308aIdYp4CQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E5FAEE61B85;
        Thu, 23 Mar 2023 05:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] net: dsa: mt7530: move enabling disabling core clock
 to mt7530_pll_setup()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167954881793.1221.14531504351601272496.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 05:20:17 +0000
References: <20230320190520.124513-1-arinc.unal@arinc9.com>
In-Reply-To: <20230320190520.124513-1-arinc.unal@arinc9.com>
To:     =?utf-8?b?QXLEsW7DpyDDnE5BTCA8YXJpbmM5LnVuYWxAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     sean.wang@mediatek.com, Landen.Chao@mediatek.com, dqfext@gmail.com,
        andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        angelogioacchino.delregno@collabora.com, arinc.unal@arinc9.com,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 20 Mar 2023 22:05:18 +0300 you wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> Split the code that enables and disables TRGMII clocks and core clock.
> Move enabling and disabling core clock to mt7530_pll_setup() as it's
> supposed to be run there.
> 
> Add 20 ms delay before enabling the core clock as seen on the U-Boot
> MediaTek ethernet driver.
> 
> [...]

Here is the summary with links:
  - [net,1/3] net: dsa: mt7530: move enabling disabling core clock to mt7530_pll_setup()
    https://git.kernel.org/netdev/net/c/8f058a6ef99f
  - [net,2/3] net: dsa: mt7530: move lowering TRGMII driving to mt7530_setup()
    https://git.kernel.org/netdev/net/c/fdcc8ccd8237
  - [net,3/3] net: dsa: mt7530: move setting ssc_delta to PHY_INTERFACE_MODE_TRGMII case
    https://git.kernel.org/netdev/net/c/407b508bdd70

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


