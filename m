Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26E241DA3D
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 14:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351108AbhI3Mvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 08:51:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351051AbhI3Mvu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 08:51:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 23BF4613CE;
        Thu, 30 Sep 2021 12:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633006208;
        bh=8utcOUjfKzqKHN/EDglk1mRsNqlNrMkkkULbDjs8LPE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tA9cJ4okaP88O3xA1iLBZLIeoHHHTre4XpmI68qC50MpPuw/vkZhiSDhUjjMGkRAY
         mpivJJUZeOPSMmJZwa/F5UNWPS4exrY3Xx5zLCmsPYZ2aOu1CzZw6Sl6ujUaMsPmkm
         lJ1amw8ofv/AoQvdXKGZB4Rkaj1ztcYBmkJ6JHSA8pKLxE9gK4ws8gzIbe2HRvJ7qH
         OYQf9JsxPdXBDl7EKFP/HFAMZ5/zBHopZGW7iezvGWHJPKPE89S00hO1SLcMjIorjh
         HujwiLKIbT/MLoYL1lUjIbvtG3SHcwZNeqsBeCNpZ65eiqKwf/v/RrfF+FkgBqs4CQ
         qK7LcoqBHIJpA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1762060A7E;
        Thu, 30 Sep 2021 12:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/3] net: add new socket option SO_RESERVE_MEM
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163300620809.1111.4905714212204854007.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Sep 2021 12:50:08 +0000
References: <20210929172513.3930074-1-weiwan@google.com>
In-Reply-To: <20210929172513.3930074-1-weiwan@google.com>
To:     Wei Wang <weiwan@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, shakeelb@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 29 Sep 2021 10:25:10 -0700 you wrote:
> This patch series introduces a new socket option SO_RESERVE_MEM.
> This socket option provides a mechanism for users to reserve a certain
> amount of memory for the socket to use. When this option is set, kernel
> charges the user specified amount of memory to memcg, as well as
> sk_forward_alloc. This amount of memory is not reclaimable and is
> available in sk_forward_alloc for this socket.
> With this socket option set, the networking stack spends less cycles
> doing forward alloc and reclaim, which should lead to better system
> performance, with the cost of an amount of pre-allocated and
> unreclaimable memory, even under memory pressure.
> With a tcp_stream test with 10 flows running on a simulated 100ms RTT
> link, I can see the cycles spent in __sk_mem_raise_allocated() dropping
> by ~0.02%. Not a whole lot, since we already have logic in
> sk_mem_uncharge() to only reclaim 1MB when sk_forward_alloc has more
> than 2MB free space. But on a system suffering memory pressure
> constently, the savings should be more.
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/3] net: add new socket option SO_RESERVE_MEM
    https://git.kernel.org/netdev/net-next/c/2bb2f5fb21b0
  - [v3,net-next,2/3] tcp: adjust sndbuf according to sk_reserved_mem
    https://git.kernel.org/netdev/net-next/c/ca057051cf25
  - [v3,net-next,3/3] tcp: adjust rcv_ssthresh according to sk_reserved_mem
    https://git.kernel.org/netdev/net-next/c/053f368412c9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


