Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7BD52B980
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236053AbiERMAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236025AbiERMAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E319B17CC8D;
        Wed, 18 May 2022 05:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81C11614CA;
        Wed, 18 May 2022 12:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EAADBC385AA;
        Wed, 18 May 2022 12:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652875217;
        bh=N4CG7P7J9ehtboZnNyL/3NxpilnwBDhxeUiHl3WY8Pg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OAddG33cgq4t0ZylC/4RmOyP80rj1uUtjRHVjMivYZbQE1NROZrzXOVKHiWgUkFV9
         TC18Yp5dC6Ahp+C7ZHx4qo5HsswUkxHldDJRFdaGxj6VsTLf6r5rFKPLLJmGkz2Rfd
         UMuth1bWF1gMpDrMrRuOqZLwaH8T/mNwYKFxEZjGZtNRAxQe/tHv2qxCLrC2ZngO43
         pFtxr0v/7U38x5b28kP4Fh+WHFWU+Tie1mPv5iI9V3z08x28d0DGly4iLGfN8I2Die
         sll9hNv0YNMrJAqlDDYD6gd1/FmHFk3f5/NZJE+noLqSnN+hnq1GFD6PDMfUPViHMS
         QwwJPLfnJEDig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D65CFF0383D;
        Wed, 18 May 2022 12:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net-next 0/9] net: dsa: microchip: refactor the ksz switch
 init function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165287521687.18230.9206117173490674365.git-patchwork-notify@kernel.org>
Date:   Wed, 18 May 2022 12:00:16 +0000
References: <20220517094333.27225-1-arun.ramadoss@microchip.com>
In-Reply-To: <20220517094333.27225-1-arun.ramadoss@microchip.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux@armlinux.org.uk, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux@rempel-privat.de, marex@denx.de, m.grzeschik@pengutronix.de,
        edumazet@google.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 17 May 2022 15:13:24 +0530 you wrote:
> During the ksz_switch_register function, it calls the individual switches init
> functions (ksz8795.c and ksz9477.c). Both these functions have few things in
> common like, copying the chip specific data to struct ksz_dev, allocating
> ksz_port memory and mib_names memory & cnt. And to add the new LAN937x series
> switch, these allocations has to be replicated.
> Based on the review feedback of LAN937x part support patch, refactored the
> switch init function to move allocations to switch register.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] net: dsa: microchip: ksz8795: update the port_cnt value in ksz_chip_data
    https://git.kernel.org/netdev/net-next/c/a30bf805592e
  - [net-next,2/9] net: dsa: microchip: move ksz_chip_data to ksz_common
    https://git.kernel.org/netdev/net-next/c/462d525018f0
  - [net-next,3/9] net: dsa: microchip: perform the compatibility check for dev probed
    https://git.kernel.org/netdev/net-next/c/eee16b147121
  - [net-next,4/9] net: dsa: microchip: move struct mib_names to ksz_chip_data
    https://git.kernel.org/netdev/net-next/c/a530e6f2204a
  - [net-next,5/9] net: dsa: microchip: move port memory allocation to ksz_common
    https://git.kernel.org/netdev/net-next/c/198b34783ab1
  - [net-next,6/9] net: dsa: microchip: move get_strings to ksz_common
    https://git.kernel.org/netdev/net-next/c/997d2126ac61
  - [net-next,7/9] net: dsa: move mib->cnt_ptr reset code to ksz_common.c
    https://git.kernel.org/netdev/net-next/c/b094c679662c
  - [net-next,8/9] net: dsa: microchip: add the phylink get_caps
    https://git.kernel.org/netdev/net-next/c/65ac79e18120
  - [net-next,9/9] net: dsa: microchip: remove unused members in ksz_device
    https://git.kernel.org/netdev/net-next/c/008db08b64f4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


