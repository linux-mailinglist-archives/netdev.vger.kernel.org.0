Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9283102B3
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 03:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhBECUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 21:20:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:43690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229766AbhBECUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 21:20:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D0BBB64F9C;
        Fri,  5 Feb 2021 02:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612491606;
        bh=daYqOkOIUN1WEXWYF3Zi2EV+ekIjuWmjvsjaUFs9ZJs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RSNPomI1xbao5gLLuHn/RKL4OyIGXrGXMgUR032LR+RTth732RDyiGiTImmMOe3KU
         YiBu9OzY584tUROzgEs+1IJQYoj7ZKy9tKBi4U8uMnlNR/D9KKwzT4DANQ54FjelD/
         2sG9ZC21EfiDmlFINGbG3eHJeKKdoZWnytuugL4NdZ1BlhsCppRRJwl29keUbfHssD
         eilyoxVw2dTrVXoyit8lO1WbJvYGF/snYOC/eiNhTklYjmFbCE/S432LNYR8vvMVbJ
         ClUsAYecvcDoacvgX+UowPHwJKiUHhNaWb9pt0SPaID5gMayybCQ7POROvbPb8D/GB
         Gp/DYb2SzyqZA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C0550609F1;
        Fri,  5 Feb 2021 02:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rxrpc: Fix clearance of Tx/Rx ring when releasing a call
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161249160678.1910.11108214897689431024.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Feb 2021 02:20:06 +0000
References: <161234207610.653119.5287360098400436976.stgit@warthog.procyon.org.uk>
In-Reply-To: <161234207610.653119.5287360098400436976.stgit@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org,
        syzbot+174de899852504e4a74a@syzkaller.appspotmail.com,
        syzbot+3d1c772efafd3c38d007@syzkaller.appspotmail.com,
        hdanton@sina.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 03 Feb 2021 08:47:56 +0000 you wrote:
> At the end of rxrpc_release_call(), rxrpc_cleanup_ring() is called to clear
> the Rx/Tx skbuff ring, but this doesn't lock the ring whilst it's accessing
> it.  Unfortunately, rxrpc_resend() might be trying to retransmit a packet
> concurrently with this - and whilst it does lock the ring, this isn't
> protection against rxrpc_cleanup_call().
> 
> Fix this by removing the call to rxrpc_cleanup_ring() from
> rxrpc_release_call().  rxrpc_cleanup_ring() will be called again anyway
> from rxrpc_cleanup_call().  The earlier call is just an optimisation to
> recycle skbuffs more quickly.
> 
> [...]

Here is the summary with links:
  - [net] rxrpc: Fix clearance of Tx/Rx ring when releasing a call
    https://git.kernel.org/netdev/net/c/7b5eab57cac4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


