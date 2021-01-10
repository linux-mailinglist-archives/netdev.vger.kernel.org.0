Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED6042F048F
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 01:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbhAJAUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 19:20:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:52840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726471AbhAJAUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 19:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 23414238A1;
        Sun, 10 Jan 2021 00:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610238008;
        bh=gixZRw3ki524y85JtTWPeu+3/q6ys6asCWKmczCZMnk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ldPyt8tHvn+uoOoY9dHoWMp0jA/OMih+f+ANByNvQQthdBHGuh0zeEJ3VcZdlZz5E
         AZX3zVwWwom4snmdasFMuPh9R8xBVkpQG3CF3orxxUScVBJUjlclsRAmOUt0MFiCEM
         GTO1EmweWq0ypYA41K9A8dHq4EWSfrz4n4ceA7u+FTuUb5mHyPIWMukgqonjGkCW+t
         GZrVDCy8rVSNMg02IXy0d1uAjg1ujo3J7rsEQUJvtwNjT2Tpo1Sufhpmcy/Ihzp/Db
         G8VzWlgWJBFEdYssM1In8+P/5kdquHfclUiXjVeOfPgz+mYO12+55Uvs4uWOPg7lx3
         NKmgOVuMgmlKg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 131A660661;
        Sun, 10 Jan 2021 00:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net v2] tipc: fix NULL deref in tipc_link_xmit()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161023800807.15950.12209503975498728214.git-patchwork-notify@kernel.org>
Date:   Sun, 10 Jan 2021 00:20:08 +0000
References: <20210108071337.3598-1-hoang.h.le@dektech.com.au>
In-Reply-To: <20210108071337.3598-1-hoang.h.le@dektech.com.au>
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>
Cc:     netdev@vger.kernel.org, ying.xue@windriver.com, maloy@donjonn.com,
        jmaloy@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  8 Jan 2021 14:13:37 +0700 you wrote:
> From: Hoang Le <hoang.h.le@dektech.com.au>
> 
> The buffer list can have zero skb as following path:
> tipc_named_node_up()->tipc_node_xmit()->tipc_link_xmit(), so
> we need to check the list before casting an &sk_buff.
> 
> Fault report:
>  [] tipc: Bulk publication failure
>  [] general protection fault, probably for non-canonical [#1] PREEMPT [...]
>  [] KASAN: null-ptr-deref in range [0x00000000000000c8-0x00000000000000cf]
>  [] CPU: 0 PID: 0 Comm: swapper/0 Kdump: loaded Not tainted 5.10.0-rc4+ #2
>  [] Hardware name: Bochs ..., BIOS Bochs 01/01/2011
>  [] RIP: 0010:tipc_link_xmit+0xc1/0x2180
>  [] Code: 24 b8 00 00 00 00 4d 39 ec 4c 0f 44 e8 e8 d7 0a 10 f9 48 [...]
>  [] RSP: 0018:ffffc90000006ea0 EFLAGS: 00010202
>  [] RAX: dffffc0000000000 RBX: ffff8880224da000 RCX: 1ffff11003d3cc0d
>  [] RDX: 0000000000000019 RSI: ffffffff886007b9 RDI: 00000000000000c8
>  [] RBP: ffffc90000007018 R08: 0000000000000001 R09: fffff52000000ded
>  [] R10: 0000000000000003 R11: fffff52000000dec R12: ffffc90000007148
>  [] R13: 0000000000000000 R14: 0000000000000000 R15: ffffc90000007018
>  [] FS:  0000000000000000(0000) GS:ffff888037400000(0000) knlGS:000[...]
>  [] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  [] CR2: 00007fffd2db5000 CR3: 000000002b08f000 CR4: 00000000000006f0
> 
> [...]

Here is the summary with links:
  - [net,v2] tipc: fix NULL deref in tipc_link_xmit()
    https://git.kernel.org/netdev/net/c/b77413446408

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


