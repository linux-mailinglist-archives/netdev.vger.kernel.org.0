Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEC0629054
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 04:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237503AbiKODDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 22:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237577AbiKODCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 22:02:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A601D67C;
        Mon, 14 Nov 2022 19:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2EF761521;
        Tue, 15 Nov 2022 03:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 21FC1C433D6;
        Tue, 15 Nov 2022 03:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668481216;
        bh=aCjW9I2ksD90tKpnaOHyfyT6OVST/0eUrGqVEB1brmg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DzCG7MrmlIMWFn4uWo5GjDxPaptx3/e5Z11P9a5Q5q7sOrp+AO37XRGHL5iiyJQOu
         TyX5YioVjpRncr5TkAQsk19CC0373S6yDifwbfa6TPO7+NHPhRqrSuXGus04L7lwFR
         j7Sqbur1FxJh8nPdUErEj9xC0+TWsxKlDAbRuRZiMmc6eE82JJw6hTFP7+9tTz2cyr
         xQPb3eJJYvr7pR5zJ7wfpSlBvtWS5n9l9zairTBt5ZyIyLVDJFwVgb++3CrbjpUBSL
         JV4OGC4gFYREuoAeG/wd15NAG3ovMQwLsbZ3Fl79S9DyOG079KqQSvojYc17smwvhM
         GF6aYYoMpcesw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 01C63E50D60;
        Tue, 15 Nov 2022 03:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: renesas: rswitch: Fix build error about ptp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166848121600.31359.6056832532519866210.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Nov 2022 03:00:16 +0000
References: <20221110012720.3552060-1-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20221110012720.3552060-1-yoshihiro.shimoda.uh@renesas.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, lkp@intel.com, arnd@arndb.de
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 10 Nov 2022 10:27:20 +0900 you wrote:
> If CONFIG_PTP_1588_CLOCK_OPTIONAL=m and CONFIG_RENESAS_ETHER_SWITCH=y,
> the following build error happened:
> 
>     aarch64-linux-ld: DWARF error: could not find abbrev number 60
>     drivers/net/ethernet/renesas/rswitch.o: in function `rswitch_get_ts_info':
>     rswitch.c:(.text+0x408): undefined reference to `ptp_clock_index'
>     aarch64-linux-ld: DWARF error: could not find abbrev number 1190123
>     drivers/net/ethernet/renesas/rcar_gen4_ptp.o: in function `rcar_gen4_ptp_register':
>     rcar_gen4_ptp.c:(.text+0x4dc): undefined reference to `ptp_clock_register'
>     aarch64-linux-ld: drivers/net/ethernet/renesas/rcar_gen4_ptp.o: in function `rcar_gen4_ptp_unregister':
>     rcar_gen4_ptp.c:(.text+0x584): undefined reference to `ptp_clock_unregister'
> 
> [...]

Here is the summary with links:
  - net: ethernet: renesas: rswitch: Fix build error about ptp
    https://git.kernel.org/netdev/net-next/c/76ad97e150f1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


