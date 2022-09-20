Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8593D5BD947
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiITBUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiITBUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5A93C8FD
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 18:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9553462062
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 01:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F04ADC433D7;
        Tue, 20 Sep 2022 01:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663636815;
        bh=47gye9YqFZ3vsfFnPDvCEOiyb8NBzlXfMg0rVaTH8eI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O8dgfZMbzOV4hNsHyvuO23f9ktpmRQL/WKrTHVXNY4fSTYqQlOYYvxfp2EDCMXpQ2
         6dfIY7vSAQSgnUmR7XR36pUff4tfu96qyqPH7B00+BYcNrUHFnhhpfofLqfgefNCU3
         At/BkJd/xVjssqXNHpquDbsCC8thRkhHBUSa0j2EEPFkq8Dn2D9k2V4b36t3F7fMQ/
         6yURK1LTPZUxWzou9pm6JKD/LGEPqlQxuq3Ns5RXKsKB4iPHjf1HTjcXDcXot44TIf
         HisfhNauBkJ6+RPLbn5r30S88RzOYpwGjzVQizarDJLCkx+afEgSIzCrdRsZG2SMGA
         grwehwe1uA+qA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D48C6C43141;
        Tue, 20 Sep 2022 01:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sfc: fix null pointer dereference in efx_hard_start_xmit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363681486.30260.392346429230209627.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:20:14 +0000
References: <20220914111135.21038-1-ihuguet@redhat.com>
In-Reply-To: <20220914111135.21038-1-ihuguet@redhat.com>
To:     =?utf-8?b?w43DsWlnbyBIdWd1ZXQgPGlodWd1ZXRAcmVkaGF0LmNvbT4=?=@ci.codeaurora.org
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, tizhao@redhat.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 14 Sep 2022 13:11:35 +0200 you wrote:
> Trying to get the channel from the tx_queue variable here is wrong
> because we can only be here if tx_queue is NULL, so we shouldn't
> dereference it. As the above comment in the code says, this is very
> unlikely to happen, but it's wrong anyway so let's fix it.
> 
> I hit this issue because of a different bug that caused tx_queue to be
> NULL. If that happens, this is the error message that we get here:
>   BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
>   [...]
>   RIP: 0010:efx_hard_start_xmit+0x153/0x170 [sfc]
> 
> [...]

Here is the summary with links:
  - [net] sfc: fix null pointer dereference in efx_hard_start_xmit
    https://git.kernel.org/netdev/net/c/0a242eb2913a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


