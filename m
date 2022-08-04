Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB75589631
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 04:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbiHDCkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 22:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbiHDCkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 22:40:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F78140B6;
        Wed,  3 Aug 2022 19:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D243617C0;
        Thu,  4 Aug 2022 02:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B22A8C433C1;
        Thu,  4 Aug 2022 02:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659580814;
        bh=MZUiCpyW7B9UKs13fFaI8X7dzwo4QUJ1YcUWTlo8s+g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fV8dl0L5DXt99vwQCfrRfpq3GuIYQHkBiGfM2bKA2Hklp1igRDA5NVtR5cELVmZUX
         ji/eEOZMK8SlPWANWBTMwr9ETjd8I0OTc/I/WeQb8Y7yPtC6BqdSSQIi/a89YMp5nQ
         foCiVAjbQpQvRv4/K8xpK7CMp8hxv9qTq/IOrkjKWJ9ft6xn8XFY9L0yBwA6ricgPW
         81VYFo2D30VJ/Xq7K//Cp9ro8OXSV95QQw8dK09SuB4a7lv6P7QnCvUtRtlQB6CXKl
         GmFEQlSMT78hf/91fZtPCrrlq2xs1c2+RCSPfg4WIqUZcrKYrwO6IPZqoV0TEfpyMN
         mrRZt03C7FCdQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9754AC43144;
        Thu,  4 Aug 2022 02:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: Warn about incorrect mdio_bus_phy_resume()
 state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165958081461.15999.9493689639445901983.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Aug 2022 02:40:14 +0000
References: <20220801233403.258871-1-f.fainelli@gmail.com>
In-Reply-To: <20220801233403.258871-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon,  1 Aug 2022 16:34:03 -0700 you wrote:
> Calling mdio_bus_phy_resume() with neither the PHY state machine set to
> PHY_HALTED nor phydev->mac_managed_pm set to true is a good indication
> that we can produce a race condition looking like this:
> 
> CPU0						CPU1
> bcmgenet_resume
>  -> phy_resume
>    -> phy_init_hw
>  -> phy_start
>    -> phy_resume
>                                                 phy_start_aneg()
> mdio_bus_phy_resume
>  -> phy_resume
>     -> phy_write(..., BMCR_RESET)
>      -> usleep()                                  -> phy_read()
> 
> [...]

Here is the summary with links:
  - [net] net: phy: Warn about incorrect mdio_bus_phy_resume() state
    https://git.kernel.org/netdev/net/c/744d23c71af3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


