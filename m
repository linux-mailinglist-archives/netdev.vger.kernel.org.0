Return-Path: <netdev+bounces-1387-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B50926FDAC4
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:30:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98D981C20C55
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21B8F814;
	Wed, 10 May 2023 09:30:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102CD63E
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BB57FC433D2;
	Wed, 10 May 2023 09:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683711021;
	bh=XJbBdI4h584PLXB5lyZb6KLOaWYYqEnbjZCd6wuh7f8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=BUkh++KuT3L6oMPUgk4r0OK22GUAbouaX9OIlJ0aj04fN+uJPi1DEnQUvas3hFZPU
	 cyPH2KSBwqNwOWkXIVNgaAg5ITT9aOxn9H8DUDfdzMXfvg7mQsQJKeCqrWFi+Fhhv1
	 90rMGBY9H8UHh49Ibf5LQq6aBgpE/mwbPVaNpbW/S9vbtwgYzhht+cJTBKrDW6jud6
	 pobxDPhCJDYb4OLQ9Vr0PZ7c2lTJ43kQ95KwRYIg20ciyIirfsvU7S6XWBM6zDnZ/X
	 yWhB9GYbKlv4XMZGAcXbLxnqMWosse8Q5R4FUT2NTKgZykoGPrVmSpYAsRzHC2AnlQ
	 ctdwrFIZan61g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9BC0DE501FE;
	Wed, 10 May 2023 09:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: add annotations around sk->sk_shutdown accesses
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168371102163.23581.15288352031519386238.git-patchwork-notify@kernel.org>
Date: Wed, 10 May 2023 09:30:21 +0000
References: <20230509203656.3864769-1-edumazet@google.com>
In-Reply-To: <20230509203656.3864769-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, eric.dumazet@gmail.com, syzkaller@googlegroups.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue,  9 May 2023 20:36:56 +0000 you wrote:
> Now sk->sk_shutdown is no longer a bitfield, we can add
> standard READ_ONCE()/WRITE_ONCE() annotations to silence
> KCSAN reports like the following:
> 
> BUG: KCSAN: data-race in tcp_disconnect / tcp_poll
> 
> write to 0xffff88814588582c of 1 bytes by task 3404 on cpu 1:
> tcp_disconnect+0x4d6/0xdb0 net/ipv4/tcp.c:3121
> __inet_stream_connect+0x5dd/0x6e0 net/ipv4/af_inet.c:715
> inet_stream_connect+0x48/0x70 net/ipv4/af_inet.c:727
> __sys_connect_file net/socket.c:2001 [inline]
> __sys_connect+0x19b/0x1b0 net/socket.c:2018
> __do_sys_connect net/socket.c:2028 [inline]
> __se_sys_connect net/socket.c:2025 [inline]
> __x64_sys_connect+0x41/0x50 net/socket.c:2025
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> [...]

Here is the summary with links:
  - [net] tcp: add annotations around sk->sk_shutdown accesses
    https://git.kernel.org/netdev/net/c/e14cadfd80d7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



