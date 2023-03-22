Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735F16C41A1
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 05:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjCVEkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 00:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjCVEkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 00:40:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3A717150;
        Tue, 21 Mar 2023 21:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 020AD61F39;
        Wed, 22 Mar 2023 04:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46A25C4339C;
        Wed, 22 Mar 2023 04:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679460018;
        bh=m8ZwRYnfYuOH/6PxAnAuXjVJ8S0Z9PvIUf2Qea14/JY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q6peMgNYB9CIfyl6gGo2HHHlXBvE3dR8aDz4h5kGWcTeJEOsxo03p5wPgNy0H+GH/
         sSroGfYNMjCMIG4Gyud6rQ6PhXe0yd//41c+Dqv5pKu0SB1uBOZkAiu8im/FyJDNo3
         2FqYgmO2DJJM0sPV+NpBAIzXvRMWMqaAHA+xK6allY3V2C66DdUOqzoOjd21TCY0EB
         OkCOOPxEd6NHLXkj2MRQGhJX0V23qAkVZUKENXIvkLwF5GPlfjDt6C0991mQPLMgmq
         VlZ1L0fD4U7RUzFJwowo9Cxuw+MkoaBz0fDcH3dUY8Mjq+K7mN8FLHwQX2Q/JZGxj0
         QZpy/dzBJR2/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 20154E66C8D;
        Wed, 22 Mar 2023 04:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] Fix trainwreck with Ocelot switch statistics counters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167946001812.24938.5518220051677045184.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Mar 2023 04:40:18 +0000
References: <20230321010325.897817-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230321010325.897817-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        colin.foster@in-advantage.com, linux-kernel@vger.kernel.org
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

On Tue, 21 Mar 2023 03:03:22 +0200 you wrote:
> While testing the patch set for preemptible traffic classes with some
> controlled traffic and measuring counter deltas:
> https://lore.kernel.org/netdev/20230220122343.1156614-1-vladimir.oltean@nxp.com/
> 
> I noticed that in the output of "ethtool -S swp0 --groups eth-mac
> eth-phy eth-ctrl rmon -- --src emac | grep -v ': 0'", the TX counters
> were off. Quickly I realized that their values were permutated by 1
> compared to their names, and that for example
> tx-rmon-etherStatsPkts64to64Octets was incrementing when
> tx-rmon-etherStatsPkts65to127Octets should have.
> 
> [...]

Here is the summary with links:
  - [net,1/3] net: mscc: ocelot: fix stats region batching
    https://git.kernel.org/netdev/net/c/6acc72a43eac
  - [net,2/3] net: mscc: ocelot: fix transfer from region->buf to ocelot->stats
    https://git.kernel.org/netdev/net/c/17dfd2104598
  - [net,3/3] net: mscc: ocelot: add TX_MM_HOLD to ocelot_mm_stats_layout
    https://git.kernel.org/netdev/net/c/5291099e0f61

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


