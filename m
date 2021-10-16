Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479AE42FF87
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 02:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239231AbhJPAwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 20:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:32854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236462AbhJPAwP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 20:52:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A296361220;
        Sat, 16 Oct 2021 00:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634345408;
        bh=IYD94KkIG3TqqSYyYkAHKZYg5XUsNJHTwmnM5Hy88CU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M6oPuBPQ2LDucf9RfPOM1GhRnvrwOi/4aEYsyXVLhmAMfaRfD7OILeL5HncGHVG/y
         mVryxwZPDYa8vMtP/iXa0me6eGYRkXEewcx1ciqex2+stAwiztLcJDlPm5g/KC+42A
         Nx0cBmd6XnACZQ/iw812EjMF9b+rrItxaS20Tg7rIb3K7djFbg81Z5GU+Q/5HQgpjg
         0K1FtNuNLA+uE/dq+/QpncI7NdTpsvSTdbRgil4e5nlGcW7XCvdZsteYAawSNZTLuX
         27Gpc14lEssnGRGqEnTCgY+Al4VG/ymgn2YMRltb+6LyixYoI/8RDGgIgd/g4zJZ52
         j81kn7rbGl0lQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 90198604EB;
        Sat, 16 Oct 2021 00:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] vsock_diag_test: remove free_sock_stat() call in
 test_no_sockets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163434540858.9644.11112420897494731815.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Oct 2021 00:50:08 +0000
References: <20211014152045.173872-1-sgarzare@redhat.com>
In-Reply-To: <20211014152045.173872-1-sgarzare@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        virtualization@lists.linux-foundation.org, davem@davemloft.net,
        marcandre.lureau@redhat.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 14 Oct 2021 17:20:45 +0200 you wrote:
> In `test_no_sockets` we don't expect any sockets, indeed
> check_no_sockets() prints an error and exits if `sockets` list is
> not empty, so free_sock_stat() call is unnecessary since it would
> only be called when the `sockets` list is empty.
> 
> This was discovered by a strange warning printed by gcc v11.2.1:
>   In file included from ../../include/linux/list.h:7,
>                    from vsock_diag_test.c:18:
>   vsock_diag_test.c: In function ‘test_no_sockets’:
>   ../../include/linux/kernel.h:35:45: error: array subscript ‘struct vsock_stat[0]’ is partly outside array bound
>   s of ‘struct list_head[1]’ [-Werror=array-bounds]
>      35 |         const typeof(((type *)0)->member) * __mptr = (ptr);     \
>         |                                             ^~~~~~
>   ../../include/linux/list.h:352:9: note: in expansion of macro ‘container_of’
>     352 |         container_of(ptr, type, member)
>         |         ^~~~~~~~~~~~
>   ../../include/linux/list.h:393:9: note: in expansion of macro ‘list_entry’
>     393 |         list_entry((pos)->member.next, typeof(*(pos)), member)
>         |         ^~~~~~~~~~
>   ../../include/linux/list.h:522:21: note: in expansion of macro ‘list_next_entry’
>     522 |                 n = list_next_entry(pos, member);                       \
>         |                     ^~~~~~~~~~~~~~~
>   vsock_diag_test.c:325:9: note: in expansion of macro ‘list_for_each_entry_safe’
>     325 |         list_for_each_entry_safe(st, next, sockets, list) {
>         |         ^~~~~~~~~~~~~~~~~~~~~~~~
>   In file included from vsock_diag_test.c:18:
>   vsock_diag_test.c:333:19: note: while referencing ‘sockets’
>     333 |         LIST_HEAD(sockets);
>         |                   ^~~~~~~
>   ../../include/linux/list.h:23:26: note: in definition of macro ‘LIST_HEAD’
>      23 |         struct list_head name = LIST_HEAD_INIT(name)
> 
> [...]

Here is the summary with links:
  - [net] vsock_diag_test: remove free_sock_stat() call in test_no_sockets
    https://git.kernel.org/netdev/net/c/ba95a6225b02

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


