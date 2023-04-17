Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDFDC6E409A
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 09:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbjDQHUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 03:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbjDQHUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 03:20:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F9E40F3;
        Mon, 17 Apr 2023 00:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 355A961F10;
        Mon, 17 Apr 2023 07:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88D3AC43324;
        Mon, 17 Apr 2023 07:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681716022;
        bh=MRcsni38SuswxQWUU0ZNYemWToOxSHPkvrnGl2HFYww=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cKPFn3SHo0aLI5+jjfRRRO5LpDHFeSapcvFuzVGckEU/By95ryA/BzLBOpApHT4LS
         4iN60Bn3Jm3xpcA5lRtkt6F423XG5ckx90V/1D+rbKg1FVv+6d7x9KIDLDiDI2H7A1
         o6LXYB4lA+HzSWQVoZdiGCD/O0iJoMRZt6x4Q9zTgA0jifF+pEHInkJ4WwEhCwOf3V
         tQoXeETHZYp6v5yz3R5ge1/xkbIFIdiYdAJv2byrm6gNdayarrhZWM/kKNwZlQPKEY
         A8+3DJOsRiRgAD7hNy78uYQ1asGgW06GXXsI9M2pfiIrADEGx41Qn0dUj9XtYMLXQ6
         CiQm2obaZK5Ag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5F760E330A3;
        Mon, 17 Apr 2023 07:20:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: micrel: Fix PTP_PF_PEROUT for lan8841
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168171602237.1935.11467980613738142039.git-patchwork-notify@kernel.org>
Date:   Mon, 17 Apr 2023 07:20:22 +0000
References: <20230414082659.1321686-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230414082659.1321686-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
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

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 14 Apr 2023 10:26:59 +0200 you wrote:
> If the 1PPS output was enabled and then lan8841 was configured to be a
> follower, then target clock which is used to generate the 1PPS was not
> configure correctly. The problem was that for each adjustments of the
> time, also the nanosecond part of the target clock was changed.
> Therefore the initial nanosecond part of the target clock was changed.
> The issue can be observed if both the leader and the follower are
> generating 1PPS and see that their PPS are not aligned even if the time
> is allined.
> The fix consists of not modifying the nanosecond part of the target
> clock when adjusting the time. In this way the 1PPS get also aligned.
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: micrel: Fix PTP_PF_PEROUT for lan8841
    https://git.kernel.org/netdev/net-next/c/c6d6ef3ee3b6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


