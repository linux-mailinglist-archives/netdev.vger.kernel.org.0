Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC5E4FCD62
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 06:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240249AbiDLECq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 00:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237737AbiDLECd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 00:02:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815F52DD60;
        Mon, 11 Apr 2022 21:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F94DB81B13;
        Tue, 12 Apr 2022 04:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 07F3AC385A6;
        Tue, 12 Apr 2022 04:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649736015;
        bh=NpGnYoqN1dqxdcCvJyMG0BfcL+8LYH4s0o/zf+0UoWE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N/O8lMpFRZdDtWM84hz6S+A841eJnasVfQilRz6sVR0W+Dnv+6jToOH5ihouqk/4d
         6vBRwwNY1eryxHSLfT6CmmYU0NUlC/W00pz+J9pH/vDioQ6uj7WTOe38CSHNm5rWSh
         Khn2S1Zv41Bwbphi8zIaeqp/Wl51FPc3TyVeqjSwg/ehquJF1+lZrXrxyvOZQDzntZ
         lV9FWqYTwY0yIOtn6PytyfchiwrOfQ/3VG2LgmxwO5+MbnSeswOijAiwKnlNvqzsob
         0xgQgwtFUyer+Mjxt4nA+pw0dcA/3rx0dJ6OqXlMrnS+SQQONKf/AmCBzL7Yw6e1FG
         opO/VKNlXyd3A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E3AEFE6D402;
        Tue, 12 Apr 2022 04:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: ethernet: ti: am65-cpsw: Fix build error without
 PHYLINK
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164973601492.30868.6935832916847860648.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Apr 2022 04:00:14 +0000
References: <20220409105931.9080-1-yuehaibing@huawei.com>
In-Reply-To: <20220409105931.9080-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, vladimir.oltean@nxp.com, s-vadapalli@ti.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 9 Apr 2022 18:59:31 +0800 you wrote:
> If PHYLINK is n, build fails:
> 
> drivers/net/ethernet/ti/am65-cpsw-ethtool.o: In function `am65_cpsw_set_link_ksettings':
> am65-cpsw-ethtool.c:(.text+0x118): undefined reference to `phylink_ethtool_ksettings_set'
> drivers/net/ethernet/ti/am65-cpsw-ethtool.o: In function `am65_cpsw_get_link_ksettings':
> am65-cpsw-ethtool.c:(.text+0x138): undefined reference to `phylink_ethtool_ksettings_get'
> drivers/net/ethernet/ti/am65-cpsw-ethtool.o: In function `am65_cpsw_set_eee':
> am65-cpsw-ethtool.c:(.text+0x158): undefined reference to `phylink_ethtool_set_eee'
> 
> [...]

Here is the summary with links:
  - [-next] net: ethernet: ti: am65-cpsw: Fix build error without PHYLINK
    https://git.kernel.org/netdev/net-next/c/bfa323c659b1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


