Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371C86D7237
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 04:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236580AbjDECAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 22:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236228AbjDECAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 22:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8643AB5
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 19:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCE6B63AD0
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2386AC4339B;
        Wed,  5 Apr 2023 02:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680660019;
        bh=QfU+M9k/fB+x7G/7T6xKgTZqsuFSYwKsXggLif8HXXg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AgSaT7qg/MbQhFivFUbN+zcMWGJKFjE2IIS7DJZJnKfa6qIupEDe5FUYZs62o5q+Z
         VGXNJG2QoHW480D9Ziorr2p+BmW3/dsNg0XrJyao5FNwlvnsNTpX163m0tsGn3oa7G
         xrzRm9SEpS0WfjJPPqgTZFX5Bjwmoto9N4EHB9D46NXaIaVKUwuYtBfdWODg3k672d
         TXrzTH9KV852SWbIjBLUE6PkVfFuc35DlaWrx+qUeLw/++Evf3diL0uZnNn8zPYBVN
         7cxxzO3Eog/vb3B9aU5cfWfrD7S5HomNVg67lNHx+Zq1mK0vscEfmIqtB0B2wEK5Pm
         nBSNBC72mv+nw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 08428E5EA85;
        Wed,  5 Apr 2023 02:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net 0/2] raw/ping: Fix locking in /proc/net/{raw,icmp}.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168066001903.10193.5947973039322866412.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Apr 2023 02:00:19 +0000
References: <20230403194959.48928-1-kuniyu@amazon.com>
In-Reply-To: <20230403194959.48928-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kuni1840@gmail.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 3 Apr 2023 12:49:57 -0700 you wrote:
> The first patch fixes a NULL deref for /proc/net/raw and second one fixes
> the same issue for ping sockets.
> 
> The first patch also converts hlist_nulls to hlist, but this is because
> the current code uses sk_nulls_for_each() for lockless readers, instead
> of sk_nulls_for_each_rcu() which adds memory barrier, but raw sockets
> does not use the nulls marker nor SLAB_TYPESAFE_BY_RCU in the first place.
> 
> [...]

Here is the summary with links:
  - [v1,net,1/2] raw: Fix NULL deref in raw_get_next().
    https://git.kernel.org/netdev/net/c/0a78cf7264d2
  - [v1,net,2/2] ping: Fix potentail NULL deref for /proc/net/icmp.
    https://git.kernel.org/netdev/net/c/ab5fb73ffa01

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


