Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E9135CA3E
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 17:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242980AbhDLPk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 11:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240930AbhDLPk1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 11:40:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4E85C6124C;
        Mon, 12 Apr 2021 15:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618242009;
        bh=Wev5x/Wg2gcRxhBYNk5rFUic8hqw0b4ouHq/pmd6fRI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HCiHcNolsPFLpr0JrKEvEk5tDEZZgGNPB4iBRnKcsUQgpZ3Sm6W+XrKDarDrKBYzf
         073rtLc8EfvPOAAueJyxXDCwhPXaCTXgrkpcc5J/cg9C0cBICAjKZYBBWg+E4W36tZ
         CUfoLXBm8r65Ph2ElQ/oFcemNR2vlYWuBZ4mtpK7cnJMCXJGS2QuB4sP7vNsh5aHNO
         9eWPYeaN88Y7CuXN9HfFUiG8ctvappMxFogaxd5xv9r+Aj5ozXKK4nf5b11ZVQumom
         Y1dM+sVMaEKFhZ6CxzABbYf2i0zpOrY/o6aGidiBSG7O/Fynxk2v5NO44l2aSnM78s
         WRoyMop3RI7MA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3E72260A2B;
        Mon, 12 Apr 2021 15:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch bpf-next] sock_map: fix a potential use-after-free in
 sock_map_close()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161824200925.5298.15006225388105379863.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Apr 2021 15:40:09 +0000
References: <20210408030556.45134-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210408030556.45134-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        cong.wang@bytedance.com,
        syzbot+7b6548ae483d6f4c64ae@syzkaller.appspotmail.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        jakub@cloudflare.com, lmb@cloudflare.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Wed,  7 Apr 2021 20:05:56 -0700 you wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> The last refcnt of the psock can be gone right after
> sock_map_remove_links(), so sk_psock_stop() could trigger a UAF.
> The reason why I placed sk_psock_stop() there is to avoid RCU read
> critical section, and more importantly, some callee of
> sock_map_remove_links() is supposed to be called with RCU read lock,
> we can not simply get rid of RCU read lock here. Therefore, the only
> choice we have is to grab an additional refcnt with sk_psock_get()
> and put it back after sk_psock_stop().
> 
> [...]

Here is the summary with links:
  - [bpf-next] sock_map: fix a potential use-after-free in sock_map_close()
    https://git.kernel.org/bpf/bpf-next/c/aadb2bb83ff7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


