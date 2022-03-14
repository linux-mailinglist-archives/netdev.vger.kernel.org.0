Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 874F94D800B
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 11:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238617AbiCNKlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 06:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233023AbiCNKlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 06:41:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0033F89A
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 03:40:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B83D60FE3
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 10:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 77563C340F6;
        Mon, 14 Mar 2022 10:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647254410;
        bh=LOpJxW8yuH0WX8TK8+xsvMUIMQ6zx4Z43hnG6GvjDj4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NQ81c5ucaJB2MaXYjUAVMcn+S9rU98LGw0PO0+ZauBAaxbsU+VWbhass5gn8Od+G0
         Ly8LSG/AwFNmWHTvYHp827EUrvNA5RtHuYHFIlGXnTiuWue8aw3Lf6RooBFqNVp50P
         lvTVv3pEPKh9lhhl+yIofS1svJ/WbC9SurV4yri0g0p9CCrk7TKlBC9rGTTxadwzCi
         7WoBuOpflxSKG7bF2xbQmgKeGRtG5TkX+V0Xq/vIv+RVjIiShnfzANQPGyuLpxGOLK
         1+0z0Wo3E3aczClsdgl9m8nHJSGPXsMS1pfAhhBK/CiU0Xh1lBa1U0K4NQNL74wShW
         XuHORKtSOubeA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 578F1EAC09C;
        Mon, 14 Mar 2022 10:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: Add lockdep asserts to ____napi_schedule().
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164725441035.29367.6398947777405338776.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Mar 2022 10:40:10 +0000
References: <YitkzkjU5zng7jAM@linutronix.de>
In-Reply-To: <YitkzkjU5zng7jAM@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, tglx@linutronix.de, peterz@infradead.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri, 11 Mar 2022 16:03:42 +0100 you wrote:
> ____napi_schedule() needs to be invoked with disabled interrupts due to
> __raise_softirq_irqoff (in order not to corrupt the per-CPU list).
> ____napi_schedule() needs also to be invoked from an interrupt context
> so that the raised-softirq is processed while the interrupt context is
> left.
> 
> Add lockdep asserts for both conditions.
> While this is the second time the irq/softirq check is needed, provide a
> generic lockdep_assert_softirq_will_run() which is used by both caller.
> 
> [...]

Here is the summary with links:
  - [net-next] net: Add lockdep asserts to ____napi_schedule().
    https://git.kernel.org/netdev/net-next/c/fbd9a2ceba5c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


