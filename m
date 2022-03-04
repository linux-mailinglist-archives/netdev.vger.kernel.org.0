Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42614CD40C
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 13:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239692AbiCDMLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 07:11:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbiCDMLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 07:11:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B0A1A6F8B;
        Fri,  4 Mar 2022 04:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BB1561DD1;
        Fri,  4 Mar 2022 12:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9B265C340F0;
        Fri,  4 Mar 2022 12:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646395812;
        bh=Xieg0ITcJqTt/jIZLiexhbijH6baoMOJ0W7XtQGkkzM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qs7Adw1hN+QtMwm6shLuEst5UfUV5331LQwMSDpww+D4iEiW0ZHDRBG4khl5mwlDa
         0Tn4o1Zf6YT3OF5RQBoYo2qdYJbH744V2oAei+fgZbbNyE+bMUEfcsPMyXq2UT5+uq
         o2F+YzWtER3Dz/zkw1pqP/FJlW8pXWH0732imUCqFkoCLdIVZs/Z5MVJD2wnCCg8yx
         V9QLXQmgp3dxlc43g3J/KtcNg4xHW6441wjpR7hDrPmm8t/CNuOBI15FnLHvsU2hHW
         aEnjr3s0akp5MLgFg3DmG/ybA4itaYzoswOzjoaywsyareJs9+44/pYetEYuVYbyC7
         nW7v75Ht5o9SA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 84066EAC099;
        Fri,  4 Mar 2022 12:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] net: Convert user to netif_rx().
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164639581253.6905.17402968335901101140.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Mar 2022 12:10:12 +0000
References: <20220303171505.1604775-1-bigeasy@linutronix.de>
In-Reply-To: <20220303171505.1604775-1-bigeasy@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        tglx@linutronix.de, andrew@lunn.ch,
        bridge@lists.linux-foundation.org, chris@zankel.net,
        f.fainelli@gmail.com, horatiu.vultur@microchip.com, corbet@lwn.net,
        kurt@linutronix.de, linux-doc@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, l.stelmach@samsung.com,
        jcmvbkbc@gmail.com, mike.travis@hpe.com, razor@blackwall.org,
        robinmholt@gmail.com, roopa@nvidia.com, steve.wahl@hpe.com,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        olteanv@gmail.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu,  3 Mar 2022 18:14:56 +0100 you wrote:
> This is the first batch of converting netif_rx_ni() caller to
> netif_rx(). The change making this possible is net-next and
> netif_rx_ni() is a wrapper around netif_rx(). This is a clean up in
> order to remove netif_rx_ni().
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: bridge@lists.linux-foundation.org
> Cc: Chris Zankel <chris@zankel.net>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Kurt Kanzenbach <kurt@linutronix.de>
> Cc: linux-doc@vger.kernel.org
> Cc: linux-xtensa@linux-xtensa.org
> Cc: Łukasz Stelmach <l.stelmach@samsung.com>
> Cc: Max Filippov <jcmvbkbc@gmail.com>
> Cc: Mike Travis <mike.travis@hpe.com>
> Cc: Nikolay Aleksandrov <razor@blackwall.org>
> Cc: Robin Holt <robinmholt@gmail.com>
> Cc: Roopa Prabhu <roopa@nvidia.com>
> Cc: Steve Wahl <steve.wahl@hpe.com>
> Cc: UNGLinuxDriver@microchip.com
> Cc: Vivien Didelot <vivien.didelot@gmail.com>
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Sebastian

Here is the summary with links:
  - [net-next,1/9] docs: networking: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/21f95a88eab4
  - [net-next,2/9] net: xtensa: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/aa4e5761bff5
  - [net-next,3/9] net: sgi-xp: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/4343b866aa94
  - [net-next,4/9] net: caif: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/3fb4430e73bf
  - [net-next,5/9] net: dsa: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/db00cc9da079
  - [net-next,6/9] net: ethernet: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/90f77c1c512f
  - [net-next,7/9] net: macvlan: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/566214f44697
  - [net-next,8/9] net: bridge: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/2e83bdd5d6cf
  - [net-next,9/9] net: dev: Use netif_rx().
    https://git.kernel.org/netdev/net-next/c/ad0a043fc26c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


