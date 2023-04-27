Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C07BE6F0256
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 10:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242817AbjD0IKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 04:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbjD0IKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 04:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584A22D71;
        Thu, 27 Apr 2023 01:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E42D263AED;
        Thu, 27 Apr 2023 08:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 409C9C4339B;
        Thu, 27 Apr 2023 08:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682583019;
        bh=3SWEG4ZM5mURpRa/lQ43ANg4nKi9ibLJ1sNHY2sKVik=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=czoPbmwFmg+8B8xuRTnQFbfROi1zo+bgPvADca0WQlSIElJUDZvkC8K81DQg8lu8I
         tHCqoelHLhe3scK1hjpg7KjCbzhCzCvTWow7R/L1YfDaeXf5EKEZ1T/mxGIji8EQUB
         sxdXFO6PwOFe6pTj2bl16DGRSMCNnGBRrCTxh6L+RDiNuaWBaZFCeJx5NnkYxnZJZc
         qlO2DN+7x89e2hnvZg88WCea6iC8Ov3TDFQ14mqyLpv/Tq07ioYtasip9GJCQHjyLE
         4eE/Nir/IrKOlNxwUT25a4Bo67E3kGAaEmne2cs1bEi9aVCa718v2HfBMY4aUyBck3
         j638igLdJ3jjw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 26E91E5FFC8;
        Thu, 27 Apr 2023 08:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rxrpc: Fix potential data race in
 rxrpc_wait_to_be_connected()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168258301915.27262.1188523901051859504.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Apr 2023 08:10:19 +0000
References: <508133.1682427395@warthog.procyon.org.uk>
In-Reply-To: <508133.1682427395@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org,
        syzbot+ebc945fdb4acd72cba78@syzkaller.appspotmail.com,
        marc.dionne@auristor.com, dvyukov@google.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 25 Apr 2023 13:56:35 +0100 you wrote:
> Inside the loop in rxrpc_wait_to_be_connected() it checks call->error to
> see if it should exit the loop without first checking the call state.  This
> is probably safe as if call->error is set, the call is dead anyway, but we
> should probably wait for the call state to have been set to completion
> first, lest it cause surprise on the way out.
> 
> Fix this by only accessing call->error if the call is complete.  We don't
> actually need to access the error inside the loop as we'll do that after.
> 
> [...]

Here is the summary with links:
  - [net] rxrpc: Fix potential data race in rxrpc_wait_to_be_connected()
    https://git.kernel.org/netdev/net/c/2b5fdc0f5caa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


