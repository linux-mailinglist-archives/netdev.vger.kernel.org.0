Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B746EB99D
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 16:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjDVOUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 10:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDVOUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 10:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9437C18E;
        Sat, 22 Apr 2023 07:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3126F60FC9;
        Sat, 22 Apr 2023 14:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83F23C433D2;
        Sat, 22 Apr 2023 14:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682173218;
        bh=e80++jUFws5TeSfyJaAgn0+eWfJrcrfA5wK9pxQYshE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oYlAbmYv5x7PNqOJjVya1GlQGWlBF5zjkFzUeIAJu0xKu9QOjKkzE77LClNJqect1
         KPO83EWafPo4mJhb6v5VpquKrG7jFmNIUan4/tdinUQqO8a051F34TDWXIoqaNYE4b
         WijTrWYycZTuWOo8o10Wrg0j23Ap4GDe68r9kxWsw8+CfQtQhUcIxyZ9lcF9+7Hlie
         1q7Yd4d63SX6UAwFqo9QVIAfwswfyzqajr+Oj8LADiTQEC5aH9VLJc+Wr2beOWpxR7
         LzaDrlI1B0okiVcRSRNsCF7sVQWHCl2StapSwgZYnTvw7v3hEmW8J5pe/S8oSJ7VTM
         ch8peewRvxdJQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 65CAFE270DB;
        Sat, 22 Apr 2023 14:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rxrpc: Fix potential race in error handling in
 afs_make_call()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168217321841.21033.2389844122329288970.git-patchwork-notify@kernel.org>
Date:   Sat, 22 Apr 2023 14:20:18 +0000
References: <228970.1682114626@warthog.procyon.org.uk>
In-Reply-To: <228970.1682114626@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, jaltman@auristor.com,
        kafs-testing+fedora36_64checkkafs-build-306@auristor.com,
        marc.dionne@auristor.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 21 Apr 2023 23:03:46 +0100 you wrote:
> If the rxrpc call set up by afs_make_call() receives an error whilst it is
> transmitting the request, there's the possibility that it may get to the
> point the rxrpc call is ended (after the error_kill_call label) just as the
> call is queued for async processing.
> 
> This could manifest itself as call->rxcall being seen as NULL in
> afs_deliver_to_call() when it tries to lock the call.
> 
> [...]

Here is the summary with links:
  - [net] rxrpc: Fix potential race in error handling in afs_make_call()
    https://git.kernel.org/netdev/net/c/e0416e7d3336

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


