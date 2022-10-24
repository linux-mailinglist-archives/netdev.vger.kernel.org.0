Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670E260B0A2
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 18:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbiJXQGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 12:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbiJXQFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 12:05:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94ED12CCA9;
        Mon, 24 Oct 2022 07:58:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 104E7B8165D;
        Mon, 24 Oct 2022 12:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B0E53C433D7;
        Mon, 24 Oct 2022 12:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666614015;
        bh=TL2X7LIRmCTcNXxuxzhLmegtwaef2bvC4gUCKxmAuNw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kz1b07sGSzoIzTcBbYG/dqjwG7IPprV+lE4x0gBx0xp5p+2nJLtwGqCwxurISEu1R
         smZzMcBOdBeeuj2eJ9ea39ADR/zRscUQ5bVv0OOqeQpTUvmgEhF985gM3ya5O+gWGe
         DD+l8UA6aGJrUi49mC8rzYa+MVqblVWc2hyrGGyVhxaG70xX4lWVaPtQ5WfqgrwNko
         myJZd11U/5UihDPehZlEyM4gCGQEvCki7kfOg95DN0PPtMbkCxQ+tBO0mEeG/GyWPE
         g4nYIAYJWgjE7wTio4Kjq3h95J9ehyYnlxE8YQyWeVmH7q0NzpqLF8HIPMviOABU3z
         4RlClMnVjkxxw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 894A7E270DE;
        Mon, 24 Oct 2022 12:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net,v3] tcp: fix a signed-integer-overflow bug in
 tcp_add_backlog()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166661401555.23160.8236193741276155568.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Oct 2022 12:20:15 +0000
References: <20221021040622.815143-1-luwei32@huawei.com>
In-Reply-To: <20221021040622.815143-1-luwei32@huawei.com>
To:     Lu Wei <luwei32@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        ast@kernel.org, martin.lau@kernel.org, kuniyu@amazon.com,
        asml.silence@gmail.com, imagedong@tencent.com,
        ncardwell@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 21 Oct 2022 12:06:22 +0800 you wrote:
> The type of sk_rcvbuf and sk_sndbuf in struct sock is int, and
> in tcp_add_backlog(), the variable limit is caculated by adding
> sk_rcvbuf, sk_sndbuf and 64 * 1024, it may exceed the max value
> of int and overflow. This patch reduces the limit budget by
> halving the sndbuf to solve this issue since ACK packets are much
> smaller than the payload.
> 
> [...]

Here is the summary with links:
  - [net,v3] tcp: fix a signed-integer-overflow bug in tcp_add_backlog()
    https://git.kernel.org/netdev/net/c/ec791d8149ff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


