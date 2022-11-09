Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5053D622C1F
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 14:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbiKINKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 08:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKINKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 08:10:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EC5E3E;
        Wed,  9 Nov 2022 05:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B2B7B81EAE;
        Wed,  9 Nov 2022 13:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25992C433D6;
        Wed,  9 Nov 2022 13:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667999416;
        bh=nxTykfjvDfWL5PFCFpolB0OIK6LgHAmJxOElnekym4A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u5aDMIMq5hW5LAsUjCn0VpBN85qyk579fXbW8ETymulTaGeNJq+zVyT8z7PxydvKp
         AW1Jg9m0y+cxDer6V0n6ExK20HCnyKFLMSMJIw5OpI7zLsSKFdsJJmQsJgjz1DTM+q
         UXo/WE4g+ItFjj2cLSJ1p3LnkhtcR2VbwqqCO3Zu6Q1Rg4ymIgMmqDgRHT1N+0CdR5
         uu6G33FRkRrDHUaxQE5E5uGrImA0HZMubWucqUcFdMsdyMEMBXjuTQ3FIjCiXItx8W
         GWdBAKccm1a+Z/q8+V4yz2bcEo4ywnHeH+zKV7dJxknGHJ/uWOd3tUNZ3ncqrofbmI
         ti1rfrKOICXNg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 07440C395FE;
        Wed,  9 Nov 2022 13:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/5] net: dsa: microchip: ksz_pwrite status check
 for lan937x and irq and error checking updates for ksz series
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166799941602.26002.4075414669051316393.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Nov 2022 13:10:16 +0000
References: <20221107092922.5926-1-rakesh.sankaranarayanan@microchip.com>
In-Reply-To: <20221107092922.5926-1-rakesh.sankaranarayanan@microchip.com>
To:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 7 Nov 2022 14:59:17 +0530 you wrote:
> This patch series include following changes,
> - Add KSZ9563 inside ksz_switch_chips. As per current structure,
> KSZ9893 is reused inside ksz_switch_chips structure, but since
> there is a mismatch in number of irq's, new member added for KSZ9563
> and sku detected based on Global Chip ID 4 Register. Compatible
> string from device tree mapped to KSZ9563 for spi and i2c mode
> probes.
> - Assign device interrupt during i2c probe operation.
> - Add error checking for ksz_pwrite inside lan937x_change_mtu. After v6.0,
> ksz_pwrite updated to have return type int instead of void, and
> lan937x_change_mtu still uses ksz_pwrite without status verification.
> - Add port_nirq as 3 for KSZ8563 switch family.
> - Use dev_err_probe() instead of dev_err() to have more standardized error
> formatting and logging.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/5] net: dsa: microchip: add ksz9563 in ksz_switch_ops and select based on compatible string
    https://git.kernel.org/netdev/net-next/c/ef912fe443ad
  - [net-next,v2,2/5] net: dsa: microchip: add irq in i2c probe
    https://git.kernel.org/netdev/net-next/c/a9c6db3bc9d8
  - [net-next,v2,3/5] net: dsa: microchip: add error checking for ksz_pwrite
    https://git.kernel.org/netdev/net-next/c/e06999c3dc62
  - [net-next,v2,4/5] net: dsa: microchip: ksz8563: Add number of port irq
    https://git.kernel.org/netdev/net-next/c/4630d1420f84
  - [net-next,v2,5/5] net: dsa: microchip: add dev_err_probe in probe functions
    https://git.kernel.org/netdev/net-next/c/9b1833170632

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


