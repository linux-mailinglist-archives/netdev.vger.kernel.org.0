Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC2BE649B8C
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 11:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbiLLKAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 05:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231961AbiLLKAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 05:00:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698B5AE6C
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 02:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CFA660F49
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 10:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 63B7AC433F2;
        Mon, 12 Dec 2022 10:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670839215;
        bh=24Q+/6AYPgR74LQc5+62qnRrIiJ0QzkRYOwCpsA8fqc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m7zLSbU4JP98HSxEmzELueAJYlSqPIhq7aBYThv7lYWGReTrTgGys0xAt4WBp7AgD
         fTg0MFLfRDU7g6zKt2vGAK18aZWedl7LWcqhhhjMZpST317wl/FEEkqQjYQ8YWRTly
         OmvSdR2n6BWMtWxRwXwEv6RSgKtK9O6uyuzAmu/CJNubTU97c5yMgcIfr7k/DePBDv
         U+uxkoLxYQS6gYKsZUmgIlwMNcVJliDyfnMazSFmsZXWWH6VIt5pr9pg00DZKtOXtO
         UcKDQOL2EQXd8Tdyr+jHURGnBq0w5uMph9Ac6ybvIQYBeKcW8ySrS+Cu2pzG1moiKO
         ycjNBx8QrNyDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4ABFEC00448;
        Mon, 12 Dec 2022 10:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 1/2] net: apple: mace: don't call dev_kfree_skb() under
 spin_lock_irqsave()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167083921530.10817.15399443595105059556.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 10:00:15 +0000
References: <20221208133735.2305751-1-yangyingliang@huawei.com>
In-Reply-To: <20221208133735.2305751-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, leon@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 8 Dec 2022 21:37:34 +0800 you wrote:
> It is not allowed to call kfree_skb() or consume_skb() from hardware
> interrupt context or with hardware interrupts being disabled.
> 
> It should use dev_kfree_skb_irq() or dev_consume_skb_irq() instead.
> The difference between them is free reason, dev_kfree_skb_irq() means
> the SKB is dropped in error and dev_consume_skb_irq() means the SKB
> is consumed in normal.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/2] net: apple: mace: don't call dev_kfree_skb() under spin_lock_irqsave()
    https://git.kernel.org/netdev/net/c/3dfe3486c1cd
  - [net,v3,2/2] net: apple: bmac: don't call dev_kfree_skb() under spin_lock_irqsave()
    https://git.kernel.org/netdev/net/c/5fe02e046e64

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


