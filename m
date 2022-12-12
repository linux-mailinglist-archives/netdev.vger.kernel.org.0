Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7438649BC3
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 11:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbiLLKLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 05:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbiLLKLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 05:11:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E6A10575;
        Mon, 12 Dec 2022 02:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E18260F8D;
        Mon, 12 Dec 2022 10:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4B5CC433D2;
        Mon, 12 Dec 2022 10:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670839816;
        bh=QFNLzaGC3QQ2Tj6+OzuD4bFPgh429PAk7aeLLtqqlfc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I4MLg2BWjXyINZYUI2Ti7MSte7xMMmcjpturaSpA448ggWU3cSlpbyntrDBXAd7fQ
         3012/t3JOwT9u4LkIDk/5f5CZqrIjm6p4SBvYK5cGTpKU7Lal4ma/StpsYJtKtnhZE
         GVrI5opa2DKNLZ2CCkp6LEKZUKr1rpKk0T+bAkmcNHRuRWZVdwb8BvQcIHp1jRy1dW
         SvCnSQMNgON8dS3ONtc8IK7MWe8JQNAlbnYsjripo4wtP0D9HD0avIYY5/X5U+A1Om
         bl3BGQUx4Q4jxhHsNOkevd58JGbqNvKLmeA/ft8Ier1i8JOpLnvMMJtjsXB2tXjz/r
         ybFFKFUzg/DEQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 90798C00448;
        Mon, 12 Dec 2022 10:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/4] net: don't call dev_kfree_skb() under
 spin_lock_irqsave()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167083981658.16910.12851344633864662339.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 10:10:16 +0000
References: <20221208142147.2376671-1-yangyingliang@huawei.com>
In-Reply-To: <20221208142147.2376671-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, leon@kernel.org,
        michal.simek@xilinx.com, john.linn@xilinx.com, sadanan@xilinx.com,
        linux-arm-kernel@lists.infradead.org, yanok@emcraft.com,
        jreuter@yaina.de, linux-hams@vger.kernel.org
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

On Thu, 8 Dec 2022 22:21:43 +0800 you wrote:
> It is not allowed to call consume_skb() from hardware interrupt context
> or with interrupts being disabled. This patchset replace dev_kfree_skb()
> with dev_kfree_skb_irq/dev_consume_skb_irq() under spin_lock_irqsave()
> in some drivers, or move dev_kfree_skb() after spin_unlock_irqrestore().
> 
> v2 -> v3:
>   Update commit message, and change to use dev_kfree_skb_irq() in patch #1, #3.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/4] net: emaclite: don't call dev_kfree_skb() under spin_lock_irqsave()
    https://git.kernel.org/netdev/net/c/d1678bf45f21
  - [net,v3,2/4] net: ethernet: dnet: don't call dev_kfree_skb() under spin_lock_irqsave()
    https://git.kernel.org/netdev/net/c/f07fadcbee2a
  - [net,v3,3/4] hamradio: don't call dev_kfree_skb() under spin_lock_irqsave()
    https://git.kernel.org/netdev/net/c/3727f742915f
  - [net,v3,4/4] net: amd: lance: don't call dev_kfree_skb() under spin_lock_irqsave()
    https://git.kernel.org/netdev/net/c/6151d105dfce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


