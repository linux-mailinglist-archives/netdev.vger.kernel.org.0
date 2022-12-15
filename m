Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0BD64D9FA
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 12:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbiLOLCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 06:02:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiLOLBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 06:01:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514B02DAA8
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 03:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E00D161D96
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 11:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39044C433EF;
        Thu, 15 Dec 2022 11:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671102017;
        bh=HCPPjCGzSl/wDgY5x2be6ahXNjmXYGnNN4TYRWIn7+M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h03/7RCsNXRpjAPxRDEAUkuCZS5MPFzV7lICo34bXhDrf0Uz2lCfXDZoJJgJJ8Tzr
         +dEEgLYd27JHWVgKGncyyV9F2p6tbSyco/btC/KMvVtG4+TwQeddg1IYOx+MrRXh1B
         pN3KPew2wN8WtFA1wyc98jukGRSM9C+OeZA3AJEaQcU1dYCpWstQ8vnawwvQ2X1fSU
         RTFLfTJ0cXmgfsm0GskEKroAq+iSwYmPk7UWqXmUEhrl0Vnv0bboMsN+md7OMiNC1m
         mfIQKiSyQSpPQ+3iVDnwtPjj7/GR8bxJe7B+BiI1gt3cDdoAsidMdF7dAerOTrcZfp
         jFVYUdoYWDv3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 17AB8C197B4;
        Thu, 15 Dec 2022 11:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] unix: Fix race in SOCK_SEQPACKET's
 unix_dgram_sendmsg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167110201709.19422.17327922832094772487.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Dec 2022 11:00:17 +0000
References: <135fda25-22d5-837a-782b-ceee50e19844@ya.ru>
In-Reply-To: <135fda25-22d5-837a-782b-ceee50e19844@ya.ru>
To:     Kirill Tkhai <tkhai@ya.ru>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        kuniyu@amazon.com, pabeni@redhat.com, netdev@vger.kernel.org
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

On Tue, 13 Dec 2022 00:05:53 +0300 you wrote:
> There is a race resulting in alive SOCK_SEQPACKET socket
> may change its state from TCP_ESTABLISHED to TCP_CLOSE:
> 
> unix_release_sock(peer)                  unix_dgram_sendmsg(sk)
>   sock_orphan(peer)
>     sock_set_flag(peer, SOCK_DEAD)
>                                            sock_alloc_send_pskb()
>                                              if !(sk->sk_shutdown & SEND_SHUTDOWN)
>                                                OK
>                                            if sock_flag(peer, SOCK_DEAD)
>                                              sk->sk_state = TCP_CLOSE
>   sk->sk_shutdown = SHUTDOWN_MASK
> 
> [...]

Here is the summary with links:
  - [net,v3] unix: Fix race in SOCK_SEQPACKET's unix_dgram_sendmsg()
    https://git.kernel.org/netdev/net/c/3ff8bff704f4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


