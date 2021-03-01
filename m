Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA88D3293CB
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 22:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243913AbhCAVgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 16:36:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:46568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244060AbhCAVat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 16:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D6F026023B;
        Mon,  1 Mar 2021 21:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614634207;
        bh=OK0/BQlK8kT0eyhGoUvDPYVK+OS3ClwfiLrkHWsfpY8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p58SmjO22G1kxP3A4XxVIIIuXgMXN9hz915NijTUFqR87e7wCT2PGqyZPkvvgUkwX
         gsQpkJWdf40E+BAOLIw74LlOqgs/WY/Gtr75dDD54Rsiiq4thGA16kHElr0poFWdls
         m9Wu47RTjsUkOWmhVYb5J8jXdTf664DigalxBy1uZHx8fo/fq3EtQoxEwVtCMB3hX0
         6X/vKere8qRdRNx0dIdDowouQ1+9FUIGAVkjap0AoITE3RkdTE78/pqwGicdX01Qu9
         BLNs3mPIMpc7YSAbKnrqFdjx0zN1QiNg7kBoMXPceqBS8JdZDSyl5nF/D2WjgDYs9L
         tMkhljEpiQMlQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CAE1660C1E;
        Mon,  1 Mar 2021 21:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] net/qrtr: fix __netdev_alloc_skb call
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161463420782.14233.758765929000233110.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Mar 2021 21:30:07 +0000
References: <20210228232240.972205-1-paskripkin@gmail.com>
In-Reply-To: <20210228232240.972205-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     alobakin@pm.me, linmiaohe@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  1 Mar 2021 02:22:40 +0300 you wrote:
> syzbot found WARNING in __alloc_pages_nodemask()[1] when order >= MAX_ORDER.
> It was caused by a huge length value passed from userspace to qrtr_tun_write_iter(),
> which tries to allocate skb. Since the value comes from the untrusted source
> there is no need to raise a warning in __alloc_pages_nodemask().
> 
> [1] WARNING in __alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:5014
> Call Trace:
>  __alloc_pages include/linux/gfp.h:511 [inline]
>  __alloc_pages_node include/linux/gfp.h:524 [inline]
>  alloc_pages_node include/linux/gfp.h:538 [inline]
>  kmalloc_large_node+0x60/0x110 mm/slub.c:3999
>  __kmalloc_node_track_caller+0x319/0x3f0 mm/slub.c:4496
>  __kmalloc_reserve net/core/skbuff.c:150 [inline]
>  __alloc_skb+0x4e4/0x5a0 net/core/skbuff.c:210
>  __netdev_alloc_skb+0x70/0x400 net/core/skbuff.c:446
>  netdev_alloc_skb include/linux/skbuff.h:2832 [inline]
>  qrtr_endpoint_post+0x84/0x11b0 net/qrtr/qrtr.c:442
>  qrtr_tun_write_iter+0x11f/0x1a0 net/qrtr/tun.c:98
>  call_write_iter include/linux/fs.h:1901 [inline]
>  new_sync_write+0x426/0x650 fs/read_write.c:518
>  vfs_write+0x791/0xa30 fs/read_write.c:605
>  ksys_write+0x12d/0x250 fs/read_write.c:658
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> [...]

Here is the summary with links:
  - [v4] net/qrtr: fix __netdev_alloc_skb call
    https://git.kernel.org/netdev/net/c/093b036aa94e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


