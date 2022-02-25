Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E91ED4C4BEE
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 18:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243595AbiBYRVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 12:21:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbiBYRVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 12:21:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965FB21EBBE
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 09:21:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32D4A61DA4
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 17:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8E1AAC340E7;
        Fri, 25 Feb 2022 17:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645809664;
        bh=18vq3NSLYJyru5g92a4jOWvDxM99YxzbW2EzZr3HN1s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jD5QGiD6s55FTDqVk/8yxLzj3Z0Bb06WwPZOzMcq7YTG84Wy0t2VNRHpVMBEkweuG
         CyTnfgh/5bJ6jqWAhxcYzWXOiImDHPi7JWrwci83GtSP6nJExxTlFmarXKVqhWKEdZ
         CHBd2aeczJwsDXbHrpVSYoX8buiTWXQIk6Y/L3VygD7ZqOnve3gA7l88grc+Zp6+d7
         i5X95T9a1XyvurqGkTJLFU2H67r+ZG44MxxbbKMzEmg6CrX/wlAieCyGnOQ5zaLKG9
         LrHDT5E+QhP4QNoAm6SiwffG8/crehkrC6M7cw9TqjvwDNEcrJ9hEoKAWjmHjwzuc5
         EPNp4JXFY6ICQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 79845E6D453;
        Fri, 25 Feb 2022 17:21:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sxgbe: fix return value of __setup handler
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164580966449.15608.3388758055550072899.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Feb 2022 17:21:04 +0000
References: <20220224033528.24640-1-rdunlap@infradead.org>
In-Reply-To: <20220224033528.24640-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, patches@lists.linux.dev,
        i.zhbanov@omprussia.ru, siva.kallam@samsung.com,
        ks.giri@samsung.com, bh74.an@samsung.com, davem@davemloft.net,
        kuba@kernel.org
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

On Wed, 23 Feb 2022 19:35:28 -0800 you wrote:
> __setup() handlers should return 1 on success, i.e., the parameter
> has been handled. A return of 0 causes the "option=value" string to be
> added to init's environment strings, polluting it.
> 
> Fixes: acc18c147b22 ("net: sxgbe: add EEE(Energy Efficient Ethernet) for Samsung sxgbe")
> Fixes: 1edb9ca69e8a ("net: sxgbe: add basic framework for Samsung 10Gb ethernet driver")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
> Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
> Cc: Siva Reddy <siva.kallam@samsung.com>
> Cc: Girish K S <ks.giri@samsung.com>
> Cc: Byungho An <bh74.an@samsung.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - net: sxgbe: fix return value of __setup handler
    https://git.kernel.org/netdev/net/c/50e06ddceeea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


