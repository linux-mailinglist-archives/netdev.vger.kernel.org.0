Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 006B562BF7E
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 14:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbiKPNaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 08:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232775AbiKPNaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 08:30:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E121F7662
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 05:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8998E61DA9
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 13:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D8B8AC433D7;
        Wed, 16 Nov 2022 13:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668605417;
        bh=pG72HBkEAG/HVK6u4IyUj7U8URaOI9bpLV0rL781AGo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ojQ6ypdkMzgg7QgE9kC+KW+tyyDa6ZyB6IgFnmrrKgPdvhs/zbaQAFta0HGouno2I
         H6Ke32Fc5IHhtFPg4JcsF9YPN/Z/ZPcNyntxzu0N0h6Yk8w9Ls4D9XWniplnwqJfdy
         n/4nR+SdREY6xjt2m7dYXC+7aUfs1Dj8qU+ioSRpblK9LnlXG9RFPyVrSiiN8pgQsR
         kFbaLpcNeVjKsl9ctLRq2xsEatXy1qMCwk/wWg0ev+H11eoUAbK8saTcsKmyvmx0BS
         1/Ml546WMZHsqohYL4K7h1vdsuuQqqKAk3ddQW1semNo+tlHcw6wVMDL9HDU29t4ez
         G0MVdOT0UsehA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B8B4CC395F3;
        Wed, 16 Nov 2022 13:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4] l2tp: Serialize access to sk_user_data with
 sk_callback_lock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166860541774.25745.4396978792984957790.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Nov 2022 13:30:17 +0000
References: <20221114191619.124659-1-jakub@cloudflare.com>
In-Reply-To: <20221114191619.124659-1-jakub@cloudflare.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, tparkin@katalix.com,
        g1042620637@gmail.com
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

On Mon, 14 Nov 2022 20:16:19 +0100 you wrote:
> sk->sk_user_data has multiple users, which are not compatible with each
> other. Writers must synchronize by grabbing the sk->sk_callback_lock.
> 
> l2tp currently fails to grab the lock when modifying the underlying tunnel
> socket fields. Fix it by adding appropriate locking.
> 
> We err on the side of safety and grab the sk_callback_lock also inside the
> sk_destruct callback overridden by l2tp, even though there should be no
> refs allowing access to the sock at the time when sk_destruct gets called.
> 
> [...]

Here is the summary with links:
  - [net,v4] l2tp: Serialize access to sk_user_data with sk_callback_lock
    https://git.kernel.org/netdev/net/c/b68777d54fac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


