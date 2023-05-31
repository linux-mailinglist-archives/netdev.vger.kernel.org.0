Return-Path: <netdev+bounces-6690-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 444EF7176FF
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:40:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF9DB1C20D3F
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 06:40:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5871479DD;
	Wed, 31 May 2023 06:40:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D417477
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 06:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 464F7C4339E;
	Wed, 31 May 2023 06:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685515220;
	bh=qOfsqcDQVftyZME0Y4MF1+NjnMjPTxemly2cwF8OXvc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=UcY+xRdBLD2LtZ1ENdMzu0nzf8oKbqAwZBMjsSNCR0jzHJX17MF8G1HLEVuUrsHXH
	 DrXwCLG6swGiWTqaqNe9XjdH1Koc8/dmYZGwQPTgOMjCv6CJ2889OgWK4WHEjCYEeR
	 61ZoJF829crzSppXK3fLlt1d6vEbugtSiAvFJXfm6xgHFCeCXm9RKg4r9nL+6oKhFv
	 PTX6QV0cW13A61pxevv3V+BpJDk0ru3M8b9BYd/Ic7PTGdrtJ0bV7r4D541ltX0cMp
	 moxk1BfQNIMwCLjaojTxd/RKVD0r9up1KJb9mrgEpbCaKWC10Zc8IMmf1J1vk+YSpc
	 1Kd2hSaz4n7cQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2AB41E21EC7;
	Wed, 31 May 2023 06:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sched: fix NULL pointer dereference in mq_attach
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168551522017.11093.5289353859414201530.git-patchwork-notify@kernel.org>
Date: Wed, 31 May 2023 06:40:20 +0000
References: <20230527093747.3583502-1-shaozhengchao@huawei.com>
In-Reply-To: <20230527093747.3583502-1-shaozhengchao@huawei.com>
To: shaozhengchao <shaozhengchao@huawei.com>
Cc: netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
 jiri@resnulli.us, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, weiyongjun1@huawei.com, yuehaibing@huawei.com,
 wanghai38@huawei.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 27 May 2023 17:37:47 +0800 you wrote:
> When use the following command to test:
> 1)ip link add bond0 type bond
> 2)ip link set bond0 up
> 3)tc qdisc add dev bond0 root handle ffff: mq
> 4)tc qdisc replace dev bond0 parent ffff:fff1 handle ffff: mq
> 
> The kernel reports NULL pointer dereference issue. The stack information
> is as follows:
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
> Internal error: Oops: 0000000096000006 [#1] SMP
> Modules linked in:
> pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : mq_attach+0x44/0xa0
> lr : qdisc_graft+0x20c/0x5cc
> sp : ffff80000e2236a0
> x29: ffff80000e2236a0 x28: ffff0000c0e59d80 x27: ffff0000c0be19c0
> x26: ffff0000cae3e800 x25: 0000000000000010 x24: 00000000fffffff1
> x23: 0000000000000000 x22: ffff0000cae3e800 x21: ffff0000c9df4000
> x20: ffff0000c9df4000 x19: 0000000000000000 x18: ffff80000a934000
> x17: ffff8000f5b56000 x16: ffff80000bb08000 x15: 0000000000000000
> x14: 0000000000000000 x13: 6b6b6b6b6b6b6b6b x12: 6b6b6b6b00000001
> x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
> x8 : ffff0000c0be0730 x7 : bbbbbbbbbbbbbbbb x6 : 0000000000000008
> x5 : ffff0000cae3e864 x4 : 0000000000000000 x3 : 0000000000000001
> x2 : 0000000000000001 x1 : ffff8000090bc23c x0 : 0000000000000000
> Call trace:
> mq_attach+0x44/0xa0
> qdisc_graft+0x20c/0x5cc
> tc_modify_qdisc+0x1c4/0x664
> rtnetlink_rcv_msg+0x354/0x440
> netlink_rcv_skb+0x64/0x144
> rtnetlink_rcv+0x28/0x34
> netlink_unicast+0x1e8/0x2a4
> netlink_sendmsg+0x308/0x4a0
> sock_sendmsg+0x64/0xac
> ____sys_sendmsg+0x29c/0x358
> ___sys_sendmsg+0x90/0xd0
> __sys_sendmsg+0x7c/0xd0
> __arm64_sys_sendmsg+0x2c/0x38
> invoke_syscall+0x54/0x114
> el0_svc_common.constprop.1+0x90/0x174
> do_el0_svc+0x3c/0xb0
> el0_svc+0x24/0xec
> el0t_64_sync_handler+0x90/0xb4
> el0t_64_sync+0x174/0x178
> 
> [...]

Here is the summary with links:
  - [net] net: sched: fix NULL pointer dereference in mq_attach
    https://git.kernel.org/netdev/net/c/36eec020fab6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



