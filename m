Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9C431AE61
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 23:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhBMWuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 17:50:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229647AbhBMWuu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Feb 2021 17:50:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8F71F64E3D;
        Sat, 13 Feb 2021 22:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613256609;
        bh=JurtvsBujxDb0e6Wm8m1j9eTnFYrYJ0yxwhTLqxaG/Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q51srIelC2qWwx0tmnmJp1BDwYJDDQuN6cd/2tEtkOEwz0yVlE3mSOeXe6gaLM4j0
         6kfdryqn2y3wDhGJZLtGCcQtfSB8YiLJlBbA+8sR1ewT2vjdWq7zdmfq8dcOELIuTP
         TeRan5f4TMRA84qwG2O0sayJTBoXUHc0c5e2Yy+IxvY8Kf28WexEp3I/r1KRm8YDjb
         R9eIO7YC/zFF525td99M6UioeJqQfF11uPz5p/L9ZC5wX5eQQiBqGP43IVygNUj0Ba
         SirhiFheWCsynqvjWYCTYFx65uqw48HIAhvZbacUyRjhuCAi/gcxZL5tJ7CEn+h6sV
         5DcfAaEoN81rA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7A48760A2A;
        Sat, 13 Feb 2021 22:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v6 net-next 00/11] skbuff: introduce skbuff_heads bulking and
 reusing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161325660949.21142.16715175107984485367.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Feb 2021 22:50:09 +0000
References: <20210213141021.87840-1-alobakin@pm.me>
In-Reply-To: <20210213141021.87840-1-alobakin@pm.me>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     davem@davemloft.net, kuba@kernel.org, jonathan.lemon@gmail.com,
        edumazet@google.com, dvyukov@google.com, willemb@google.com,
        rdunlap@infradead.org, haokexin@gmail.com, pablo@netfilter.org,
        jakub@cloudflare.com, elver@google.com, decui@microsoft.com,
        pabeni@redhat.com, brouer@redhat.com, alexanderduyck@fb.com,
        alexander.duyck@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        andriin@fb.com, ap420073@gmail.com, weiwan@google.com,
        xiyou.wangcong@gmail.com, bjorn@kernel.org, linmiaohe@huawei.com,
        gnault@redhat.com, fw@strlen.de, ecree.xilinx@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 13 Feb 2021 14:10:43 +0000 you wrote:
> Currently, all sorts of skb allocation always do allocate
> skbuff_heads one by one via kmem_cache_alloc().
> On the other hand, we have percpu napi_alloc_cache to store
> skbuff_heads queued up for freeing and flush them by bulks.
> 
> We can use this cache not only for bulk-wiping, but also to obtain
> heads for new skbs and avoid unconditional allocations, as well as
> for bulk-allocating (like XDP's cpumap code and veth driver already
> do).
> 
> [...]

Here is the summary with links:
  - [v6,net-next,01/11] skbuff: move __alloc_skb() next to the other skb allocation functions
    https://git.kernel.org/netdev/net-next/c/5381b23d5bf9
  - [v6,net-next,02/11] skbuff: simplify kmalloc_reserve()
    https://git.kernel.org/netdev/net-next/c/ef28095fce66
  - [v6,net-next,03/11] skbuff: make __build_skb_around() return void
    https://git.kernel.org/netdev/net-next/c/483126b3b2c6
  - [v6,net-next,04/11] skbuff: simplify __alloc_skb() a bit
    https://git.kernel.org/netdev/net-next/c/df1ae022af2c
  - [v6,net-next,05/11] skbuff: use __build_skb_around() in __alloc_skb()
    https://git.kernel.org/netdev/net-next/c/f9d6725bf44a
  - [v6,net-next,06/11] skbuff: remove __kfree_skb_flush()
    https://git.kernel.org/netdev/net-next/c/fec6e49b6398
  - [v6,net-next,07/11] skbuff: move NAPI cache declarations upper in the file
    https://git.kernel.org/netdev/net-next/c/50fad4b543b3
  - [v6,net-next,08/11] skbuff: introduce {,__}napi_build_skb() which reuses NAPI cache heads
    https://git.kernel.org/netdev/net-next/c/f450d539c05a
  - [v6,net-next,09/11] skbuff: allow to optionally use NAPI cache from __alloc_skb()
    https://git.kernel.org/netdev/net-next/c/d13612b58e64
  - [v6,net-next,10/11] skbuff: allow to use NAPI cache from __napi_alloc_skb()
    https://git.kernel.org/netdev/net-next/c/cfb8ec659521
  - [v6,net-next,11/11] skbuff: queue NAPI_MERGED_FREE skbs into NAPI cache instead of freeing
    https://git.kernel.org/netdev/net-next/c/9243adfc311a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


