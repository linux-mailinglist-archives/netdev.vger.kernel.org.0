Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFE5597E01
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 07:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243388AbiHRFUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 01:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242805AbiHRFUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 01:20:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B38F7D1C8
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 22:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA6BEB820C3
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 05:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A16ABC433C1;
        Thu, 18 Aug 2022 05:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660800017;
        bh=n+hFHxlyhBvzQxqVp4E0yjkuj0lKvwSEirRwoAQOad8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q08LR0uMYA5/U27bFz4LpTDRrNj76aKDiLBoQh2hIoRPtxC8XYWLjnzmYblg7Q9Wm
         /8B5Iyr8dEiICAaPaK8RH+9ezhu7tQfi+CFQ739LI699KfXAbIUDw/hfo/YaKhJOj1
         73U1OwFmlPGuRsf9QRX803hcxPFssUgqBFKfalGANQA6Yz8sAGASInQqmgyKCOXc+b
         6trbR3AVonbwZ8clZHIChZIqgPPyGr+RKq8KLvgxIGLknRKQcRJbGDt9PTZel5+6Nu
         SqR/mciVPpymxMRqNfEnQTKYvgcKWwOXvrEhtelRsHgoQW8CcQ4SRAVsZ6kz4w0AYK
         UykCHyh++DGsQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7A169E2A04C;
        Thu, 18 Aug 2022 05:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/8] Fixes for Ocelot driver statistics
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166080001748.8479.564394540738537882.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Aug 2022 05:20:17 +0000
References: <20220816135352.1431497-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220816135352.1431497-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, colin.foster@in-advantage.com, fido_max@inbox.ru
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 16 Aug 2022 16:53:44 +0300 you wrote:
> This series contains bug fixes for the ocelot drivers (both switchdev
> and DSA). Some concern the counters exposed to ethtool -S, and others to
> the counters exposed to ifconfig. I'm aware that the changes are fairly
> large, but I wanted to prioritize on a proper approach to addressing the
> issues rather than a quick hack.
> 
> Some of the noticed problems:
> - bad register offsets for some counters
> - unhandled concurrency leading to corrupted counters
> - unhandled 32-bit wraparound of ifconfig counters
> 
> [...]

Here is the summary with links:
  - [net,1/8] net: dsa: felix: fix ethtool 256-511 and 512-1023 TX packet counters
    https://git.kernel.org/netdev/net/c/40d21c4565bc
  - [net,2/8] net: mscc: ocelot: fix incorrect ndo_get_stats64 packet counters
    https://git.kernel.org/netdev/net/c/5152de7b79ab
  - [net,3/8] net: mscc: ocelot: fix address of SYS_COUNT_TX_AGING counter
    https://git.kernel.org/netdev/net/c/173ca86618d7
  - [net,4/8] net: mscc: ocelot: turn stats_lock into a spinlock
    https://git.kernel.org/netdev/net/c/22d842e3efe5
  - [net,5/8] net: mscc: ocelot: fix race between ndo_get_stats64 and ocelot_check_stats_work
    https://git.kernel.org/netdev/net/c/18d8e67df184
  - [net,6/8] net: mscc: ocelot: make struct ocelot_stat_layout array indexable
    https://git.kernel.org/netdev/net/c/9190460084dd
  - [net,7/8] net: mscc: ocelot: keep ocelot_stat_layout by reg address, not offset
    https://git.kernel.org/netdev/net/c/d4c367650704
  - [net,8/8] net: mscc: ocelot: report ndo_get_stats64 from the wraparound-resistant ocelot->stats
    https://git.kernel.org/netdev/net/c/e780e3193e88

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


