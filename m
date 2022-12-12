Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1F0649B5D
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 10:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbiLLJkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 04:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231855AbiLLJkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 04:40:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4ED9102B
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 01:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A1F9B80C72
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 09:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0CE52C433F0;
        Mon, 12 Dec 2022 09:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670838015;
        bh=0d/mS0RnJf+wM7UnJ5HgQInufS+eE4+/QnY2AbIRkNE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kW9oisxiU78o+hbhx58Q4ILsAQbsrOWkUzxJxAq0V4LeXYY0dJH5gCM3JLP1L8dt4
         +i/x8Vtix9n2nLH0B0rnlSGSfBkR11UcUOFsU3auzS155Tsos5GqoBoBvauyREg3qj
         AWjMf7dzQB5L4W/WXhzYz93JbAWjj5LdzYbsj+JMbxDR0HHWWxzYD2xD9cXhXq1jB/
         88J67zeqHecpr983DqYTViLgY1T8f7n+w8YUS1shYEYuzuiT4+RpwhevoKfe4lQDWH
         Nk251ZxT/K/yTsOSMZz249N/7lrfzeU51YiLDuDZGDsRgiJupl7vKM+gK3JENjVjMT
         8bxszLDi1uTUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DA3D7C00448;
        Mon, 12 Dec 2022 09:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4] ethernet: s2io: don't call dev_kfree_skb() under
 spin_lock_irqsave()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167083801488.1612.3185444341943921479.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 09:40:14 +0000
References: <20221208120121.2076486-1-yangyingliang@huawei.com>
In-Reply-To: <20221208120121.2076486-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, jdmason@kudzu.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        leon@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 8 Dec 2022 20:01:21 +0800 you wrote:
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
  - [net,v4] ethernet: s2io: don't call dev_kfree_skb() under spin_lock_irqsave()
    https://git.kernel.org/netdev/net/c/6cee96e09df5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


