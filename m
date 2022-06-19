Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD6C55096F
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 11:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbiFSJAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 05:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiFSJAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 05:00:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42FF2613;
        Sun, 19 Jun 2022 02:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E39760FD6;
        Sun, 19 Jun 2022 09:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A3723C341C5;
        Sun, 19 Jun 2022 09:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655629212;
        bh=0RSX/TxmErEaxscUFd0XIrpAiXT+uc/A13G1miIGl7Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KZceZvpTvOyANXN/s2cAMCgEpeqL6LMUDaP0qA8paP9uEokgHUUgeo7xGPOhNGFhr
         XhZWr/nErL/1By0PxYNtnYzAX5VeVqzEDq3vnpSi09UgYJLhyfU0/+BC4V4xGCIVdh
         YeLoeA+F+7HNV8EWhYkwXGTVf2/jVXmXU6wZKfS4N3oGJ7yLgG4K/AtNXqgC+bEClm
         a/GRY3cCipAYfVjHf7CQkIaWNP5FFOM4b98LXsdypoNANyWfpfKpcOI16fWcSCUhni
         +OpktepM+cvX+XXCQ7yQ6IcsO8LXvBm23Bz/xQElruWQPlYBVktikknMWpv9nw8dVM
         S2gGkky0m+SXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 88C58FD99FB;
        Sun, 19 Jun 2022 09:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: dsa: felix: update base time of time-aware
 shaper when adjusting PTP time
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165562921255.21034.3210903703466134264.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Jun 2022 09:00:12 +0000
References: <20220617032423.13852-1-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20220617032423.13852-1-xiaoliang.yang_1@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, horatiu.vultur@microchip.com,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        fido_max@inbox.ru, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        andrew@lunn.ch, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, yangbo.lu@nxp.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Jun 2022 11:24:23 +0800 you wrote:
> When adjusting the PTP clock, the base time of the TAS configuration
> will become unreliable. We need reset the TAS configuration by using a
> new base time.
> 
> For example, if the driver gets a base time 0 of Qbv configuration from
> user, and current time is 20000. The driver will set the TAS base time
> to be 20000. After the PTP clock adjustment, the current time becomes
> 10000. If the TAS base time is still 20000, it will be a future time,
> and TAS entry list will stop running. Another example, if the current
> time becomes to be 10000000 after PTP clock adjust, a large time offset
> can cause the hardware to hang.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: dsa: felix: update base time of time-aware shaper when adjusting PTP time
    https://git.kernel.org/netdev/net-next/c/8670dc33f48b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


