Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA3160EE99
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 05:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbiJ0DbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 23:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234352AbiJ0Dan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 23:30:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3032CE37;
        Wed, 26 Oct 2022 20:30:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D25786215D;
        Thu, 27 Oct 2022 03:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 322FEC43141;
        Thu, 27 Oct 2022 03:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666841424;
        bh=MJ6QXwH1gOUPhZNuYeOn5loUAGcFkX/z0waQRreOYLo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bOCPGnustRZV1sQIBYpRYTG965fngmK2V+IKHkAjckhcNEMa1DpEED/GzSDnsznJp
         nPM1W2Rge4bjpdZ81iT0OkkUCQBxBKsZOCKpxPvGd7UawFnwVCv++3j1LzIXFZzFS6
         iC6lTPOO7crHn3Pf0/laW1DE2r49/sZ6Gj95Rb4sq3BFT31O18rjXpYDQrOeyd3Rk0
         lBUHLHCgJ0wJU8BIISpQUyi0FflHoTY9aqVRqpPmxiaqQw8ty/HIRs4JzOkgjkleGM
         jrG7ESTyvTe+vfDIKB++TI1vSfCQ39RRLboiqf3ZXHU74ASmzObKa/oVTa3OmaoJm2
         1MVhhKQKwgAcA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EA7A6E50D78;
        Thu, 27 Oct 2022 03:30:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: ave: Fix MAC to be in charge of PHY PM
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166684142395.32384.12048362671450534867.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 03:30:23 +0000
References: <20221024072227.24769-1-hayashi.kunihiko@socionext.com>
In-Reply-To: <20221024072227.24769-1-hayashi.kunihiko@socionext.com>
To:     Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Cc:     hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, andrew@lunn.ch,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 24 Oct 2022 16:22:27 +0900 you wrote:
> The phylib callback is called after MAC driver's own resume callback is
> called. For AVE driver, after resuming immediately, PHY state machine is
> in PHY_NOLINK because there is a time lag from link-down to link-up due to
> autoneg. The result is WARN_ON() dump in mdio_bus_phy_resume().
> 
> Since ave_resume() itself calls phy_resume(), AVE driver should manage
> PHY PM. To indicate that MAC driver manages PHY PM, set
> phydev->mac_managed_pm to true to avoid the unnecessary phylib call and
> add missing phy_init_hw() to ave_resume().
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: ave: Fix MAC to be in charge of PHY PM
    https://git.kernel.org/netdev/net/c/e2badb4bd33a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


