Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 859EE692E02
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 04:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjBKDkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 22:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjBKDkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 22:40:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E1563A080;
        Fri, 10 Feb 2023 19:40:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEB7E61F17;
        Sat, 11 Feb 2023 03:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1A26DC433A1;
        Sat, 11 Feb 2023 03:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676086820;
        bh=+yN+o7R7IDzmO4l3URs0UMnaT3WF6jbhfkYOyRZG2dY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DiKYBe8hHQH/jIcjjZ+7KwGgoQQzjKdBKrkowUFKUoyqkO6RszJwWPIcT56TkDuo6
         jEGGPFI61F0k+qp1DGuiVA21UQGT+DXJzqE9aZHVoOyqx2gtAQv02hKLBxVzIuqzUO
         6XPOUIgbv+UzYeT1SMdW7UCMzyuAll62SE2TZHekgP9KoOm/QqfIISTwg/6FbK1lEA
         puzeYggofEl4gu+czS7obSrhgOrHfsCv9+t34geoKkJ4svgu54zGy3/SKXS4yLf2Ur
         TmXNa3A/GSqwVhyFTeOHQXCp+Uwo/ahqykcxn2cpwAW3v7BSoYCwiNYxk/vobF5MQc
         dYtxfEOIzef+Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F15FAE21ECB;
        Sat, 11 Feb 2023 03:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: ocelot: add PTP dependency for
 NET_DSA_MSCC_OCELOT_EXT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167608681998.24732.13337198831271498674.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Feb 2023 03:40:19 +0000
References: <20230209124435.1317781-1-arnd@kernel.org>
In-Reply-To: <20230209124435.1317781-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        arnd@arndb.de, andrew@lunn.ch, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        colin.foster@in-advantage.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Feb 2023 13:44:17 +0100 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> A new user of MSCC_OCELOT_SWITCH_LIB was added, bringing back an old
> link failure that was fixed with e5f31552674e ("ethernet: fix
> PTP_1588_CLOCK dependencies"):
> 
> x86_64-linux-ld: drivers/net/ethernet/mscc/ocelot_ptp.o: in function `ocelot_ptp_enable':
> ocelot_ptp.c:(.text+0x8ee): undefined reference to `ptp_find_pin'
> x86_64-linux-ld: drivers/net/ethernet/mscc/ocelot_ptp.o: in function `ocelot_get_ts_info':
> ocelot_ptp.c:(.text+0xd5d): undefined reference to `ptp_clock_index'
> x86_64-linux-ld: drivers/net/ethernet/mscc/ocelot_ptp.o: in function `ocelot_init_timestamp':
> ocelot_ptp.c:(.text+0x15ca): undefined reference to `ptp_clock_register'
> x86_64-linux-ld: drivers/net/ethernet/mscc/ocelot_ptp.o: in function `ocelot_deinit_timestamp':
> ocelot_ptp.c:(.text+0x16b7): undefined reference to `ptp_clock_unregister'
> 
> [...]

Here is the summary with links:
  - net: dsa: ocelot: add PTP dependency for NET_DSA_MSCC_OCELOT_EXT
    https://git.kernel.org/netdev/net-next/c/f99f22e02f29

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


