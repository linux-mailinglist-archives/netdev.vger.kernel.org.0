Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C765F57913A
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 05:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbiGSDUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 23:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233360AbiGSDUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 23:20:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C078183A5;
        Mon, 18 Jul 2022 20:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DE6FB816F8;
        Tue, 19 Jul 2022 03:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A5C3EC341CA;
        Tue, 19 Jul 2022 03:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658200814;
        bh=c+W0yN0thuQ9gLRjN868HNx40Z9Il8fuZwZrOzYSrHg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cA8Njpn682OAE701MxYWMkjTl/WUVYiXO7l1vGMw+kQL+EfWpVa4fLeerH6uPULWu
         2U5yZvFNIxO9SLl0wqvCXLisR+mbbpNqNqhU3BDBUjBgzyTEuk6bqkHIEKV3Gai04+
         jETxf84782+nvR5YA60u42JDooXJtGLD+Ui6kMrzxsAHN2JHUoSidQ4cVwZkTWN8ed
         Bac5BPZUw1RHVaWrUNeYlGx83kgsKEi9yAvrMvOrwYJXF1mZa2doYShMgrjmuSQLdY
         zUx+53KTiVkWehMbmmxDy44Ee4vBBSi9MseQzQE6p4R0V6DhM1wnveWnC3HKEwHXdj
         sbNc4/dkrH2MQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8C69FE451B3;
        Tue, 19 Jul 2022 03:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/5] net: lan966x: Fix issues with MAC table
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165820081457.20693.13587149505441847275.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jul 2022 03:20:14 +0000
References: <20220714194040.231651-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220714194040.231651-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vladimir.oltean@nxp.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 14 Jul 2022 21:40:35 +0200 you wrote:
> The patch series fixes 2 issues:
> - when an entry was forgotten the irq thread was holding a spin lock and then
>   was talking also rtnl_lock.
> - the access to the HW MAC table is indirect, so the access to the HW MAC
>   table was not synchronized, which means that there could be race conditions.
> 
> Horatiu Vultur (5):
>   net: lan966x: Fix taking rtnl_lock while holding spin_lock
>   net: lan966x: Fix usage of lan966x->mac_lock when entry is added
>   net: lan966x: Fix usage of lan966x->mac_lock when entry is removed
>   net: lan966x: Fix usage of lan966x->mac_lock inside
>     lan966x_mac_irq_handler
>   net: lan966x: Fix usage of lan966x->mac_lock when used by FDB
> 
> [...]

Here is the summary with links:
  - [net,1/5] net: lan966x: Fix taking rtnl_lock while holding spin_lock
    https://git.kernel.org/netdev/net/c/45533a534a45
  - [net,2/5] net: lan966x: Fix usage of lan966x->mac_lock when entry is added
    https://git.kernel.org/netdev/net/c/43243bb3195b
  - [net,3/5] net: lan966x: Fix usage of lan966x->mac_lock when entry is removed
    https://git.kernel.org/netdev/net/c/99343cfa4f75
  - [net,4/5] net: lan966x: Fix usage of lan966x->mac_lock inside lan966x_mac_irq_handler
    https://git.kernel.org/netdev/net/c/c19246843697
  - [net,5/5] net: lan966x: Fix usage of lan966x->mac_lock when used by FDB
    https://git.kernel.org/netdev/net/c/675c807ae26b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


