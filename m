Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169923CA548
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 20:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237991AbhGOSW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 14:22:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231627AbhGOSW6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 14:22:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C076361178;
        Thu, 15 Jul 2021 18:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626373204;
        bh=fXdla5zPgOJytMrxkP8fqdb6FUUVZZy9At4qcGgFS3Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pXMKWUx/t5iih8ISFHNAyn6zO9KspYWpwqFdlrH+TNlOUiLtUiIbn5RVsE8DS4dcH
         5Mz4PLh2v4nqlpC8P0c24CaYB5U3Us8/eTeKZox2QZ23ubhjhWvPVr85HSIFUeWKP2
         l52DJtsqqOZkphcIUQL36kNqXs5qa6Hjh9Wz3UjPheoWQZlH1o8Rjjx279z6eDUPz+
         ZQXly5EnlMyv7KA24F3hMclNCCzDw7x76uisb+pgwHMCQgcqcpop4d+retAeCfo+nw
         W9sR7ibMROyPozf9RNelUfSlsUwYGBN0TrVlSu6X/x+DAF6kYbvMHhewsAVs69D8ky
         rszS+7zXeBLJA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B40DD609A3;
        Thu, 15 Jul 2021 18:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: fix uninit-value in caif_seqpkt_sendmsg
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162637320473.7858.7071261121680611982.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Jul 2021 18:20:04 +0000
References: <20210715122204.14043-1-william.xuanziyang@huawei.com>
In-Reply-To: <20210715122204.14043-1-william.xuanziyang@huawei.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        sjur.brandeland@stericsson.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 15 Jul 2021 20:22:04 +0800 you wrote:
> When nr_segs equal to zero in iovec_from_user, the object
> msg->msg_iter.iov is uninit stack memory in caif_seqpkt_sendmsg
> which is defined in ___sys_sendmsg. So we cann't just judge
> msg->msg_iter.iov->base directlly. We can use nr_segs to judge
> msg in caif_seqpkt_sendmsg whether has data buffers.
> 
> =====================================================
> BUG: KMSAN: uninit-value in caif_seqpkt_sendmsg+0x693/0xf60 net/caif/caif_socket.c:542
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1c9/0x220 lib/dump_stack.c:118
>  kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
>  __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
>  caif_seqpkt_sendmsg+0x693/0xf60 net/caif/caif_socket.c:542
>  sock_sendmsg_nosec net/socket.c:652 [inline]
>  sock_sendmsg net/socket.c:672 [inline]
>  ____sys_sendmsg+0x12b6/0x1350 net/socket.c:2343
>  ___sys_sendmsg net/socket.c:2397 [inline]
>  __sys_sendmmsg+0x808/0xc90 net/socket.c:2480
>  __compat_sys_sendmmsg net/compat.c:656 [inline]
> 
> [...]

Here is the summary with links:
  - [net-next] net: fix uninit-value in caif_seqpkt_sendmsg
    https://git.kernel.org/netdev/net/c/991e634360f2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


