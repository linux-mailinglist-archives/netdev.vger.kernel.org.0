Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3455A33A6
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 04:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345243AbiH0CAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 22:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345225AbiH0CAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 22:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CF912AE3;
        Fri, 26 Aug 2022 19:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AED9FB8337F;
        Sat, 27 Aug 2022 02:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65F00C433B5;
        Sat, 27 Aug 2022 02:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661565615;
        bh=9RD3nDAmukIGkRA9JFIEcqp6OtWAATv6G4hOA+eB3Bs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VHdcv6MWw5cfAOh+5ZBfkIFYAMmhjPIQEeLBy32ucwZcX7pqYqQ6a4yklykTIErjK
         lH8wtgIpFjTSWNGp2Rf7kchC5CiiO7QG1VCItBNBCrxpSKnMwOsB1PlczjIgrNtEbR
         P2Bv3M+Ff16U9nYu0ngJTCtzXkP88KVWTzrWjP3UxOtK2KSZkglVHtr7F6+rm0k30d
         ha6mtCvTwzuY7dulKwOkam6Zwj51ihQZrl+Sx3/JFwytcMRrKaOlAoFpRQ/qYAyKsA
         awO5Qv8GVbSM4evSNBRPRq7IAmRsee+SX/9MxHBBxr2wpnL9jLLZQfSBjmFXiM8jyf
         hy4CoQaGTee/g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 480AFC0C3EC;
        Sat, 27 Aug 2022 02:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: smsc911x: Stop and start PHY during suspend and
 resume
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166156561528.8692.16300408724203022261.git-patchwork-notify@kernel.org>
Date:   Sat, 27 Aug 2022 02:00:15 +0000
References: <20220825023951.3220-1-f.fainelli@gmail.com>
In-Reply-To: <20220825023951.3220-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, geert+renesas@glider.be,
        m.szyprowski@samsung.com, steve.glendinning@shawell.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Aug 2022 19:39:51 -0700 you wrote:
> Commit 744d23c71af3 ("net: phy: Warn about incorrect
> mdio_bus_phy_resume() state") unveiled that the smsc911x driver was not
> properly stopping and restarting the PHY during suspend/resume. Correct
> that by indicating that the MAC is in charge of PHY PM operations and
> ensure that all MDIO bus activity is quiescent during suspend.
> 
> Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Fixes: fba863b81604 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
> Fixes: 2aa70f864955 ("net: smsc911x: Quieten netif during suspend")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: smsc911x: Stop and start PHY during suspend and resume
    https://git.kernel.org/netdev/net/c/3ce9f2bef755

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


