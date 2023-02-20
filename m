Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A2D69C6AF
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 09:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjBTIah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 03:30:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbjBTIac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 03:30:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5418812F13
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 00:30:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA52CB80B25
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 08:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8107BC433A8;
        Mon, 20 Feb 2023 08:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676881818;
        bh=nYhOZgIKeXYtZHLXpFwqvShiKX5//g4+Kpqy3q5iLiQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sSBkuTMWDODXRPFrAHUZMeiqXSxoPranPUR55lVFLwtZ9akSkVFOWSThX1NtZaW2y
         RwX61mrXAcCPmTzb0Ki5c1AAj0NOhwi7kYoNAlsFHxK7afX1aJmUygFb+mOsZHEAln
         IspnhDvQh9buoox8Xtiv/JjvMKhs3oWnVdLZgXqXldicnqGrbQdIHHeNHJUY4iccdQ
         xoWyuSeTcXAtxViC2269rUmMv9q0e16Hh1r6pABgLNAg80DIdIW//cxDaVeaFupGgW
         iuViwDkKFeySbMQsCHI6sJ7zrY1vm3pbDh/q7HXF05t+FE/N3hbpl6xs8EnqgIVvYh
         EJ7N1LS665JLA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6D36CE68D22;
        Mon, 20 Feb 2023 08:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: add location to trace_consume_skb()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167688181844.23180.9353701235892968755.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Feb 2023 08:30:18 +0000
References: <20230216154718.1548837-1-edumazet@google.com>
In-Reply-To: <20230216154718.1548837-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 16 Feb 2023 15:47:18 +0000 you wrote:
> kfree_skb() includes the location, it makes sense
> to add it to consume_skb() as well.
> 
> After patch:
> 
>  taskd_EventMana  8602 [004]   420.406239: skb:consume_skb: skbaddr=0xffff893a4a6d0500 location=unix_stream_read_generic
>          swapper     0 [011]   422.732607: skb:consume_skb: skbaddr=0xffff89597f68cee0 location=mlx4_en_free_tx_desc
>       discipline  9141 [043]   423.065653: skb:consume_skb: skbaddr=0xffff893a487e9c00 location=skb_consume_udp
>          swapper     0 [010]   423.073166: skb:consume_skb: skbaddr=0xffff8949ce9cdb00 location=icmpv6_rcv
>          borglet  8672 [014]   425.628256: skb:consume_skb: skbaddr=0xffff8949c42e9400 location=netlink_dump
>          swapper     0 [028]   426.263317: skb:consume_skb: skbaddr=0xffff893b1589dce0 location=net_rx_action
>             wget 14339 [009]   426.686380: skb:consume_skb: skbaddr=0xffff893a51b552e0 location=tcp_rcv_state_process
> 
> [...]

Here is the summary with links:
  - [net-next] net: add location to trace_consume_skb()
    https://git.kernel.org/netdev/net-next/c/dd1b527831a3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


