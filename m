Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD9F4C4BED
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 18:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbiBYRVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 12:21:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243599AbiBYRVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 12:21:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB19223101
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 09:21:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3FB7B832D2
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 17:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 96969C36AE2;
        Fri, 25 Feb 2022 17:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645809664;
        bh=kKt2WWIC9sQjA3ZVxKRO4C6Ek5Zwb9FUNfOwFqq+yp8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Eor90FwzhQeUnJU15sS53t2IkxKK8dyxLZXBKCgXT+q9QoMA8k3CxxYQJRSVFkJ8+
         m7/GALxXZLt5dqCf5cVNa7iLtKApXhj1DzmtwXBcUi8duBMaottOHspPvQmQb3qjlr
         ESm89/gR9BEXg1zISJ+jtlONav5T4wT7ZFrS5AXcCIb24rUEU5g9yqyvhyV14Uz8Sd
         WErxHMcpN7FTAbmPoSxOvl6cJqBPs8cCdt8Yaw0dYFEPC4EHzcoe+4eiRVxx/fl9su
         1Hk4YO7ZYJ7up9oalC9ayxOkHVvTdw7t8kmOavaSgezflGKqSFTNm4pr1NUajHHBa7
         WvmoErxdp8XbA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 82BEDEAC09C;
        Fri, 25 Feb 2022 17:21:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: fix return value of __setup handler
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164580966453.15608.582946093358485153.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Feb 2022 17:21:04 +0000
References: <20220224033536.25056-1-rdunlap@infradead.org>
In-Reply-To: <20220224033536.25056-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, patches@lists.linux.dev,
        i.zhbanov@omprussia.ru, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, kuba@kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 23 Feb 2022 19:35:36 -0800 you wrote:
> __setup() handlers should return 1 on success, i.e., the parameter
> has been handled. A return of 0 causes the "option=value" string to be
> added to init's environment strings, polluting it.
> 
> Fixes: 47dd7a540b8a ("net: add support for STMicroelectronics Ethernet controllers.")
> Fixes: f3240e2811f0 ("stmmac: remove warning when compile as built-in (V2)")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
> Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> Cc: Jose Abreu <joabreu@synopsys.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - net: stmmac: fix return value of __setup handler
    https://git.kernel.org/netdev/net/c/e01b042e580f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


