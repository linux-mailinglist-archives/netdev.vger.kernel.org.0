Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4A85797E3
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 12:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237200AbiGSKuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 06:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237187AbiGSKuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 06:50:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA80657C
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 03:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0835761419
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 10:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35D6EC341CA;
        Tue, 19 Jul 2022 10:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658227815;
        bh=4EP2U9oXpAdahWrsC0inkMczDr9XMvopiucP8dgTBwQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eejw2I/Cyoki8ktXo8V6rRCyuPlVTQVANSK70k84lgKpOByU5tPD0owUMvPgLELEr
         UcKJec6Y5Hhcx2mRuT3MGGFbr6YAbd98QlnMYeGNMy0Jm9H/ftnuDn59IHLYn28t4V
         12n1YrG9SPD1rNu0j7VW8BxSz3yFJQmgLZUlWgveST0mEJt61BZ//hlPpl0QWIziFK
         BpBXSuxMCV/SYyKudhdIX5rImMUloeiGV4JDzG9iQYJuVWSJdNjJgfZdLphnxm8Rlq
         WXXLVwCw81AlV+Qe/PM5JiqyZyC1umnW4JTHzt9UMMBgqTvYu5jTS99l+ByjuymTGb
         0yl/cYf9gl3QA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 11DEDE451B0;
        Tue, 19 Jul 2022 10:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/8] amt: fix validation and synchronization bugs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165822781506.1764.166272738384218919.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jul 2022 10:50:15 +0000
References: <20220717160910.19156-1-ap420073@gmail.com>
In-Reply-To: <20220717160910.19156-1-ap420073@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 17 Jul 2022 16:09:02 +0000 you wrote:
> There are some synchronization issues in the amt module.
> Especially, an amt gateway doesn't well synchronize its own variables
> and status(amt->status).
> It tries to use a workqueue for handles in a single thread.
> A global lock is also good, but it would occur complex locking complex.
> 
> In this patchset, only the gateway uses workqueue.
> The reason why only gateway interface uses workqueue is that gateway
> should manage its own states and variables a little bit statefully.
> But relay doesn't need to manage tunnels statefully, stateless is okay.
> So, relay side message handlers are okay to be called concurrently.
> But it doesn't mean that no lock is needed.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/8] amt: use workqueue for gateway side message handling
    https://git.kernel.org/netdev/net/c/30e22a6ebca0
  - [net,v2,2/8] amt: remove unnecessary locks
    https://git.kernel.org/netdev/net/c/9c343ea6185f
  - [net,v2,3/8] amt: use READ_ONCE() in amt module
    https://git.kernel.org/netdev/net/c/928f353cb867
  - [net,v2,4/8] amt: add missing regeneration nonce logic in request logic
    https://git.kernel.org/netdev/net/c/627f16931bf3
  - [net,v2,5/8] amt: drop unexpected advertisement message
    https://git.kernel.org/netdev/net/c/40185f359fba
  - [net,v2,6/8] amt: drop unexpected query message
    https://git.kernel.org/netdev/net/c/239d886601e3
  - [net,v2,7/8] amt: drop unexpected multicast data
    https://git.kernel.org/netdev/net/c/e882827d5b89
  - [net,v2,8/8] amt: do not use amt->nr_tunnels outside of lock
    https://git.kernel.org/netdev/net/c/989918482bbc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


