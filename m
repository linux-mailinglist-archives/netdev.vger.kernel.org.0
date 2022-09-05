Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F66F5AD3BE
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 15:23:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237587AbiIENUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 09:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237183AbiIENUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 09:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605003C15A;
        Mon,  5 Sep 2022 06:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 137E5B8119C;
        Mon,  5 Sep 2022 13:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B142EC43141;
        Mon,  5 Sep 2022 13:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662384015;
        bh=szAT6+dGFI+pJU9JhkQozMXyv0TluMnN2z3VZBNzSMU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GIUjLk30wORS/+0g7AYumuV1UnABCPWTuhHD57kNbJZFMsRJNmlKkTjnkrLRYuRax
         7f+V+qLt2b/Oe2PmEYOY1ltvtKBhTZCN5L35JMdtyY66czsekgNBCpnGG/LhZNycFO
         Tpxu0z6BDOfSTYVoZYi9EIn3JOTQrRVzhstJaSvC8lP+6WHvz6n1ACTh3wJhiDxLOV
         8efPjrQ1O0mdmMnacRENm8J+mexGVVAuENme6OQbTM49TS5oKAR8MIf1CmTlmyS7hc
         gMSejwyg0eRWbNNZDAr70w2z8C7CYtnQXogyvqXdjKZEPgc4xrfxuPB01UQy5xLuYJ
         JMhJjBIgpoS3w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9B7F0E1CABF;
        Mon,  5 Sep 2022 13:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net-next 0/3] net: dsa: microchip: lan937x: enable interrupt
 for internal phy link detection
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166238401563.22589.9260356369397863227.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Sep 2022 13:20:15 +0000
References: <20220902103210.10743-1-arun.ramadoss@microchip.com>
In-Reply-To: <20220902103210.10743-1-arun.ramadoss@microchip.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 2 Sep 2022 16:02:07 +0530 you wrote:
> This patch series enables the internal phy link detection for lan937x using the
> interrupt method. lan937x acts as the interrupt controller for the internal
> ports and phy, the irq_domain is registered for the individual ports and in
> turn for the individual port interrupts.
> 
> RFC v3 -> Patch v1
> - Removed the RFC v3 1/3 from the series - changing exit from reset
> - Changed the variable name in ksz_port from irq to pirq
> - Added the check for return value of irq_find_mapping during phy irq
>   registeration.
> - Moved the clearing of POR_READY_INT from girq_thread_fn to
>   lan937x_reset_switch
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: dsa: microchip: add reference to ksz_device inside the ksz_port
    https://git.kernel.org/netdev/net-next/c/f3c165459c51
  - [net-next,2/3] net: dsa: microchip: lan937x: clear the POR_READY_INT status bit
    https://git.kernel.org/netdev/net-next/c/f313936261ac
  - [net-next,3/3] net: dsa: microchip: lan937x: add interrupt support for port phy link
    https://git.kernel.org/netdev/net-next/c/c9cd961c0d43

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


