Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7E1634F51
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 06:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235656AbiKWFAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 00:00:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbiKWFAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 00:00:25 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801A8E6767;
        Tue, 22 Nov 2022 21:00:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C9806CE208C;
        Wed, 23 Nov 2022 05:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DDDD3C43470;
        Wed, 23 Nov 2022 05:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669179620;
        bh=ZDJPaxlx5Y2h4EP8//tqBocHHjbuAxhC7dW5z2Pj1iY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Kqkb4QxOvZP5jo0g54jDoSIH2GVl8rVwyoS64D5+fmuqeE4z1xMJuOiMUdP663PzK
         y1EZJC2D01zlbl/DH8LV5MKEI4UT4INovrcwc7Kh5yBsC9q1dQwzBlzxdm4PSZMD5g
         nx0Ip0gEZD/xD4YuZlysbZzzEx1Wtaw1zRj2YMW807u9GCXVl0JPFW//uQon+o8guC
         /xMQ5tJ0mfpsGV/dZXwRmlG0B2l7gvfBC0w1iF2D0xCn6CQ3y+MirXuB9+EyinwDbA
         Z9tiqXQIqAQYXr5ZrS4EtuUYScbQn/d94nnvffRFNrwH7TOMigQ2d/1cTjB/jPDbk9
         kx0NvZXEttGeg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BD645E524E0;
        Wed, 23 Nov 2022 05:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: fix potential memory leak in
 mtk_rx_alloc()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166917961977.4515.16047808004376352912.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Nov 2022 05:00:19 +0000
References: <20221120035405.1464341-1-william.xuanziyang@huawei.com>
In-Reply-To: <20221120035405.1464341-1-william.xuanziyang@huawei.com>
To:     Ziyang Xuan (William) <william.xuanziyang@huawei.com>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        lorenzo@kernel.org
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

On Sun, 20 Nov 2022 11:54:05 +0800 you wrote:
> When fail to dma_map_single() in mtk_rx_alloc(), it returns directly.
> But the memory allocated for local variable data is not freed, and
> local variabel data has not been attached to ring->data[i] yet, so the
> memory allocated for local variable data will not be freed outside
> mtk_rx_alloc() too. Thus memory leak would occur in this scenario.
> 
> Add skb_free_frag(data) when dma_map_single() failed.
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: mtk_eth_soc: fix potential memory leak in mtk_rx_alloc()
    https://git.kernel.org/netdev/net/c/3213f808ae21

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


