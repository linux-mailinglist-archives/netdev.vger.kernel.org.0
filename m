Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41ECF627C81
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 12:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236051AbiKNLkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 06:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236216AbiKNLkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 06:40:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81859DECF;
        Mon, 14 Nov 2022 03:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20A2461053;
        Mon, 14 Nov 2022 11:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 80F67C433C1;
        Mon, 14 Nov 2022 11:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668426018;
        bh=bhT3mDFvQg+74/gwaU0Ud1ZCBtD4pN6Q7E6j/v3FcMM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GApWkA6sxxoYcXGu611Fj5YXSXxkZo22ErV08k2RN+Jey/oCeU++Qk2tepQ5tu9MH
         2uGQJ5+WXhKJa9MFDUrb/yXhU0m6A0XeM3EDLhtDRNTS/nxfQ4E9q1uHMLWS7jV6cY
         /RKjhstU1Fdt1/7CHnCteEpGkHI+y+vKsIk2Gev3LJ+a/ZJMMxG1r4bMMavRDwsixG
         XxYYo5czR0Irabf35wjAJymDCw3dyL4zWSC74kM6Jhgm7WNMCKF+1kDYBKeLlYEWjI
         gT7AtpmfrYLmCRqU3qmTUn7xXWxfUK9FpCG4UHzwCCqdFhZ9zWJyKGC0+K5yIacGQR
         diyIW3mqPWVNw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5A736C395FE;
        Mon, 14 Nov 2022 11:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] Add support for sorted VCAP rules in Sparx5
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166842601836.5995.2799356851718316011.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Nov 2022 11:40:18 +0000
References: <20221111130519.1459549-1-steen.hegelund@microchip.com>
In-Reply-To: <20221111130519.1459549-1-steen.hegelund@microchip.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com,
        rdunlap@infradead.org, casper.casan@gmail.com,
        rmk+kernel@armlinux.org.uk, wanjiabing@vivo.com, nhuck@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Steen.Hegelund@microchip.com,
        daniel.machon@microchip.com, horatiu.vultur@microchip.com,
        lars.povlsen@microchip.com, simon.horman@corigine.com,
        louis.peens@corigine.com, wojciech.drewek@intel.com,
        baowen.zheng@corigine.com, maksym.glubokiy@plvision.eu,
        pablo@netfilter.org
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

On Fri, 11 Nov 2022 14:05:13 +0100 you wrote:
> This provides support for adding Sparx5 VCAP rules in sorted order, VCAP
> rule counters and TC filter matching on ARP frames.
> 
> It builds on top of the initial IS2 VCAP support found in these series:
> 
> https://lore.kernel.org/all/20221020130904.1215072-1-steen.hegelund@microchip.com/
> https://lore.kernel.org/all/20221109114116.3612477-1-steen.hegelund@microchip.com/
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: flow_offload: add support for ARP frame matching
    https://git.kernel.org/netdev/net-next/c/70ea86a0dfed
  - [net-next,2/6] net: microchip: sparx5: Add support for TC flower ARP dissector
    https://git.kernel.org/netdev/net-next/c/3a344f99bb55
  - [net-next,3/6] net: microchip: sparx5: Add/delete rules in sorted order
    https://git.kernel.org/netdev/net-next/c/990e483981ea
  - [net-next,4/6] net: microchip: sparx5: Add support for IS2 VCAP rule counters
    https://git.kernel.org/netdev/net-next/c/f13230a47477
  - [net-next,5/6] net: microchip: sparx5: Add support for TC flower filter statistics
    https://git.kernel.org/netdev/net-next/c/40e7fe18abab
  - [net-next,6/6] net: microchip: sparx5: Add KUNIT test of counters and sorted rules
    https://git.kernel.org/netdev/net-next/c/dccc30cc4906

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


