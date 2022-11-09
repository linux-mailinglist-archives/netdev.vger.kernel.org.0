Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B5C622D35
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 15:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbiKIOKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 09:10:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbiKIOKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 09:10:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A4F1740F;
        Wed,  9 Nov 2022 06:10:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5B26B81EC6;
        Wed,  9 Nov 2022 14:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7CE03C433D7;
        Wed,  9 Nov 2022 14:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668003019;
        bh=W5B0br3K6HCYwePGGXnYroApfXp5GQlbN8ymTiCxYOA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XUezKhRhRGTNNu8YZXjwkvRVLAJ4EIbGdk9b66D7pvHS8yxGzDPSSrwhYuQn9Oe7Y
         nTuYVcdWf4EkPFWlgHv7g7oIJWqgbLtc+eR+/RLKYSCZjSu1knrtxpJ0JXk1Nx+sSh
         eo8H7wLrFcQdgvzFB41lCBcLmthOCdj0fXqqHUwMqabWX2uMY0p9p8KWtWglNMwYuO
         1YGWQLC3cdOSyH4Uf09QsAAMacnTTJCb9EBg4P7TkO/I91nfVYRhpicqReULLGx3UZ
         DW3/iMMMVZEYpUtUD/76O3E2iEsHHGu5PLLNtdcg7KCnOKl41B5yRaiL5iskjTLvbO
         lZkb31rra/tDw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 69BFBC395F8;
        Wed,  9 Nov 2022 14:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 00/26] rxrpc: Increasing SACK size and moving away from
 softirq, part 1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166800301942.27724.14016792120529272515.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Nov 2022 14:10:19 +0000
References: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
In-Reply-To: <166794587113.2389296.16484814996876530222.stgit@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David Howells <dhowells@redhat.com>:

On Tue, 08 Nov 2022 22:17:51 +0000 you wrote:
> AF_RXRPC has some issues that need addressing:
> 
>  (1) The SACK table has a maximum capacity of 255, but for modern networks
>      that isn't sufficient.  This is hard to increase in the upstream code
>      because of the way the application thread is coupled to the softirq
>      and retransmission side through a ring buffer.  Adjustments to the rx
>      protocol allows a capacity of up to 8192, and having a ring
>      sufficiently large to accommodate that would use an excessive amount
>      of memory as this is per-call.
> 
> [...]

Here is the summary with links:
  - [net-next,01/26] net, proc: Provide PROC_FS=n fallback for proc_create_net_single_write()
    https://git.kernel.org/netdev/net-next/c/c3d96f690a79
  - [net-next,02/26] rxrpc: Trace setting of the request-ack flag
    https://git.kernel.org/netdev/net-next/c/4d843be56ba6
  - [net-next,03/26] rxrpc: Split call timer-expiration from call timer-set tracepoint
    https://git.kernel.org/netdev/net-next/c/334dfbfc5a71
  - [net-next,04/26] rxrpc: Track highest acked serial
    https://git.kernel.org/netdev/net-next/c/589a0c1e0ac3
  - [net-next,05/26] rxrpc: Add stats procfile and DATA packet stats
    https://git.kernel.org/netdev/net-next/c/b015424695f0
  - [net-next,06/26] rxrpc: Record statistics about ACK types
    https://git.kernel.org/netdev/net-next/c/f2a676d10038
  - [net-next,07/26] rxrpc: Record stats for why the REQUEST-ACK flag is being set
    https://git.kernel.org/netdev/net-next/c/f7fa52421f76
  - [net-next,08/26] rxrpc: Fix ack.bufferSize to be 0 when generating an ack
    https://git.kernel.org/netdev/net-next/c/8889a711f9b4
  - [net-next,09/26] net: Change the udp encap_err_rcv to allow use of {ip,ipv6}_icmp_error()
    https://git.kernel.org/netdev/net-next/c/42fb06b391ac
  - [net-next,10/26] rxrpc: Use the core ICMP/ICMP6 parsers
    https://git.kernel.org/netdev/net-next/c/b6c66c4324e7
  - [net-next,11/26] rxrpc: Call udp_sendmsg() directly
    https://git.kernel.org/netdev/net-next/c/ed472b0c8783
  - [net-next,12/26] rxrpc: Remove unnecessary header inclusions
    https://git.kernel.org/netdev/net-next/c/23b237f32592
  - [net-next,13/26] rxrpc: Remove the flags from the rxrpc_skb tracepoint
    https://git.kernel.org/netdev/net-next/c/27f699ccb89d
  - [net-next,14/26] rxrpc: Remove call->tx_phase
    https://git.kernel.org/netdev/net-next/c/a11e6ff961a0
  - [net-next,15/26] rxrpc: Define rxrpc_txbuf struct to carry data to be transmitted
    https://git.kernel.org/netdev/net-next/c/02a1935640f8
  - [net-next,16/26] rxrpc: Allocate ACK records at proposal and queue for transmission
    https://git.kernel.org/netdev/net-next/c/72f0c6fb0579
  - [net-next,17/26] rxrpc: Clean up ACK handling
    https://git.kernel.org/netdev/net-next/c/530403d9ba1c
  - [net-next,18/26] rxrpc: Split the rxrpc_recvmsg tracepoint
    https://git.kernel.org/netdev/net-next/c/faf92e8d53f5
  - [net-next,19/26] rxrpc: Clone received jumbo subpackets and queue separately
    https://git.kernel.org/netdev/net-next/c/d4d02d8bb5c4
  - [net-next,20/26] rxrpc: Get rid of the Rx ring
    https://git.kernel.org/netdev/net-next/c/5d7edbc9231e
  - [net-next,21/26] rxrpc: Don't use a ring buffer for call Tx queue
    https://git.kernel.org/netdev/net-next/c/a4ea4c477619
  - [net-next,22/26] rxrpc: Remove call->lock
    https://git.kernel.org/netdev/net-next/c/4e76bd406d6e
  - [net-next,23/26] rxrpc: Save last ACK's SACK table rather than marking txbufs
    https://git.kernel.org/netdev/net-next/c/d57a3a151660
  - [net-next,24/26] rxrpc: Remove the rxtx ring
    https://git.kernel.org/netdev/net-next/c/6869ddb87d47
  - [net-next,25/26] rxrpc: Fix congestion management
    https://git.kernel.org/netdev/net-next/c/1fc4fa2ac93d
  - [net-next,26/26] rxrpc: Allocate an skcipher each time needed rather than reusing
    https://git.kernel.org/netdev/net-next/c/30d95efe06e1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


