Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623DC4ED7F3
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 12:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbiCaKwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 06:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234742AbiCaKv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 06:51:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D7E1BA6AC;
        Thu, 31 Mar 2022 03:50:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 890986114A;
        Thu, 31 Mar 2022 10:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E67CDC34110;
        Thu, 31 Mar 2022 10:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648723810;
        bh=xIf87JHdIZuYqsFvHaZsgub5aabPOxvd6947cpvOSoE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qr5bpGXlmUrdgTAdsvN1/BH6w7v35kSKGV00gKHOp4o+ooeDcOzP44wfWinMj1tR+
         6+wm+7f5VpTLQOOL43rLeCY075OG+0q/Gms+Hx/kj0ID8qfWckInVBes6ktCe6gakg
         TuX9wcvxTzUC8K+oLiP4tQvvVB8pDvj/MNt5F/udo+vPlBFIdHhJToFR5HFvXqOuwP
         5OJeVfZt2mSPGRpU5mqruVKVnxyaP9GtPpdSsmQr0OjrZqoNkvrHX8eNssM16M7FA9
         pb6DmMU2X2C79Eyl30NwLAxc/QLK58NW1EYotCvW3pWmp/ud4vd+Tx90tpzczsdA3f
         4EEayCv7a5WXg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA303EAC09B;
        Thu, 31 Mar 2022 10:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rxrpc: Fix call timer start racing with call destruction
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164872381082.31367.2236478294404070151.git-patchwork-notify@kernel.org>
Date:   Thu, 31 Mar 2022 10:50:10 +0000
References: <164865115696.2943015.11097991776647323586.stgit@warthog.procyon.org.uk>
In-Reply-To: <164865115696.2943015.11097991776647323586.stgit@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, marc.dionne@auristor.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 30 Mar 2022 15:39:16 +0100 you wrote:
> The rxrpc_call struct has a timer used to handle various timed events
> relating to a call.  This timer can get started from the packet input
> routines that are run in softirq mode with just the RCU read lock held.
> Unfortunately, because only the RCU read lock is held - and neither ref or
> other lock is taken - the call can start getting destroyed at the same time
> a packet comes in addressed to that call.  This causes the timer - which
> was already stopped - to get restarted.  Later, the timer dispatch code may
> then oops if the timer got deallocated first.
> 
> [...]

Here is the summary with links:
  - [net] rxrpc: Fix call timer start racing with call destruction
    https://git.kernel.org/netdev/net/c/4a7f62f91933

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


