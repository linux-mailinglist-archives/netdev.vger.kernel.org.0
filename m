Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5F35BE68F
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 15:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiITNAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 09:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiITNAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 09:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59BA3DF37
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 06:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 783F56239F
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 13:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D166AC433C1;
        Tue, 20 Sep 2022 13:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663678815;
        bh=SKtEcFgi1iP9KpKkp71yZQFh2o545m3b9QZM/ZjHLQ0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G6ikEbHWyaW//obf/nEPSgfWJWrJ+ALGMcZ1KO1Ac7jEw335xQJnbtQlKwtbUYOiN
         dBe4eoxl8MFFZFeB291ovjWiU67S46v8AV9U0dwlnD3vGv62ReJCSQihJ+65XlULRd
         0eMoZosVyFRN+3pujeNKzliPuv7ZmG/uOX5wuC2flKSa5IRFFa8DupVWfrC9iZadN5
         8Lko5y4RxYj4JxbaczCBFB6d55wcwO6Ym29P7vbyQ5SQn7bIlg1qpU+LqpFuf08z9S
         7QphpZn7Jq41r0hRm4+SL8zzkFKB0Qv3bYY/vaHzskfQ7lYWJAuXlaCipFFAu6dvyZ
         ruSnjrsCqePJA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B6D56E21EDF;
        Tue, 20 Sep 2022 13:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net] tcp: read multiple skbs in tcp_read_skb()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166367881574.10144.3048644265262767799.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 13:00:15 +0000
References: <20220912173553.235838-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20220912173553.235838-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        peilin.ye@bytedance.com, john.fastabend@gmail.com,
        jakub@cloudflare.com, edumazet@google.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 12 Sep 2022 10:35:53 -0700 you wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> Before we switched to ->read_skb(), ->read_sock() was passed with
> desc.count=1, which technically indicates we only read one skb per
> ->sk_data_ready() call. However, for TCP, this is not true.
> 
> TCP at least has sk_rcvlowat which intentionally holds skb's in
> receive queue until this watermark is reached. This means when
> ->sk_data_ready() is invoked there could be multiple skb's in the
> queue, therefore we have to read multiple skbs in tcp_read_skb()
> instead of one.
> 
> [...]

Here is the summary with links:
  - [net] tcp: read multiple skbs in tcp_read_skb()
    https://git.kernel.org/netdev/net/c/db4192a754eb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


