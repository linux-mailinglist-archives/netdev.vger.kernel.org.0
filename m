Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0DD53FB8A
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 12:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241251AbiFGKkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 06:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241291AbiFGKkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 06:40:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B95C8FFB5
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 03:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E253DB81EED
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 10:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A910FC34114;
        Tue,  7 Jun 2022 10:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654598412;
        bh=ng340RTu9sCSUdpvjUqh9PnVMWecETmt/BxWgxfggUc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=exwSOznnDTAHsYuPyoKgpEunQIQeRWqlZH9E3GDL8lj7NwCB8DttEr5dp/hWqzNZI
         KbyQ9J7K7739OUVpI7LPLIFFU1Fsh+3romlyXr8xTgQ/GxuvjwaWf4c2CTLu3Iv+9J
         WtX799ON1ug2yCCBeyfFb2Dd2OrVZeRzLFHOk7xpDwnXUpiAZy7XQOfPTiabxDtS5n
         ZBYYLAmeU+FZzHlFv7ScJ3Imoxr1mZ7VeuHcLKdCZyy6Rb2ExhujWp7AwkAOfNrlvR
         toJHQctZ0ZcAoOzkUP4fT0h4ycNIzRDlNYVWXYWKDIggrkewrs5Ik4rXtuC0rjjB5J
         ci9UcJLJadLog==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8BD47E737E8;
        Tue,  7 Jun 2022 10:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] af_unix: Fix a data-race in unix_dgram_peer_wake_me().
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165459841256.23793.8301804556926242847.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Jun 2022 10:40:12 +0000
References: <20220605232325.11804-1-kuniyu@amazon.com>
In-Reply-To: <20220605232325.11804-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, rweikusat@mobileactivedefense.com,
        kuni1840@gmail.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 5 Jun 2022 16:23:25 -0700 you wrote:
> unix_dgram_poll() calls unix_dgram_peer_wake_me() without `other`'s
> lock held and check if its receive queue is full.  Here we need to
> use unix_recvq_full_lockless() instead of unix_recvq_full(), otherwise
> KCSAN will report a data-race.
> 
> Fixes: 7d267278a9ec ("unix: avoid use-after-free in ep_remove_wait_queue")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> 
> [...]

Here is the summary with links:
  - [net] af_unix: Fix a data-race in unix_dgram_peer_wake_me().
    https://git.kernel.org/netdev/net/c/662a80946ce1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


