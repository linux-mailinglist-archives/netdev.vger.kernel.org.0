Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0008945052B
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 14:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbhKONTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 08:19:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:45896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230253AbhKONTX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 08:19:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0B5F61AA7;
        Mon, 15 Nov 2021 13:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636982188;
        bh=EWSMy60Xc2vO9Yiroqcb76661VKO6rm4jAiUkpY1L/8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Re5pyKeJuBrMPMdUSbeJxCNnGzMABCDxbauNRbF9HNLH00skvMjQxohRJQJOpTZ3P
         LAMtOn6diToRMYWDjav5xNj14F6exWapRSofEvQOtk2hUliKGOE79Rb5jpolGlJUGg
         ippV/fmSMHxfhiCqdie2Cp/kkJ8zKOmPMPcvFokEqy64LZxEH15HasidkPnpcVGVuY
         f3wOKnN2CKfCgVDkpgXDS1f1fAilOjP9WmlNwrC0WNvwFfag7TvSYtReXVAH9Gm7wI
         D0/yFcmQvLU3UQ3IGLd9Ce4XheSflCh9kHPKD9P+fdobbTxJmFG6y1A1rZ1fIM6E2t
         V+4kuXwpG7ZrQ==
Date:   Mon, 15 Nov 2021 15:16:24 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     syzbot <syzbot+9111d2255a9710e87562@syzkaller.appspotmail.com>
Cc:     aharonl@nvidia.com, dledford@redhat.com, jgg@ziepe.ca,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        markzhang@nvidia.com, netao@nvidia.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] general protection fault in nldev_stat_set_doit (2)
Message-ID: <YZJdqHzZB4yq7Yuw@unreal>
References: <000000000000c2c99905d0c63bcf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000c2c99905d0c63bcf@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 14, 2021 at 01:18:28PM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    70701b83e208 tcp: Fix uninitialized access in skb frags ar..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=1654c32ab00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a262045c4c15a9e0
> dashboard link: https://syzkaller.appspot.com/bug?extid=9111d2255a9710e87562
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+9111d2255a9710e87562@syzkaller.appspotmail.com
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 0 PID: 6744 Comm: syz-executor.0 Not tainted 5.15.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:nla_get_u32 include/net/netlink.h:1554 [inline]
> RIP: 0010:nldev_stat_set_mode_doit drivers/infiniband/core/nldev.c:1909 [inline]
> RIP: 0010:nldev_stat_set_doit+0x578/0x10d0 drivers/infiniband/core/nldev.c:2040
> Code: fa 4c 8b a4 24 f8 02 00 00 48 b8 00 00 00 00 00 fc ff df c7 84 24 80 00 00 00 00 00 00 00 49 8d 7c 24 04 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 02
> RSP: 0018:ffffc90004acf2e8 EFLAGS: 00010247
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc90002b94000
> RDX: 0000000000000000 RSI: ffffffff8684c5ff RDI: 0000000000000004
> RBP: ffff88807cda4000 R08: 0000000000000000 R09: ffff888023fb8027
> R10: ffffffff8684c5d7 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000001 R14: ffff888041024280 R15: ffff888031ade780
> FS:  00007eff9dddd700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2ef24000 CR3: 0000000036902000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  rdma_nl_rcv_msg+0x36d/0x690 drivers/infiniband/core/netlink.c:195
>  rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
>  rdma_nl_rcv+0x2ee/0x430 drivers/infiniband/core/netlink.c:259
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x86d/0xda0 net/netlink/af_netlink.c:1916
>  sock_sendmsg_nosec net/socket.c:704 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:724
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7effa0867ae9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007eff9dddd188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007effa097af60 RCX: 00007effa0867ae9
> RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000003
> RBP: 00007effa08c1f6d R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffc008a753f R14: 00007eff9dddd300 R15: 0000000000022000
>  </TASK>
> Modules linked in:
> ---[ end trace bacb470dc6c820de ]---
> RIP: 0010:nla_get_u32 include/net/netlink.h:1554 [inline]
> RIP: 0010:nldev_stat_set_mode_doit drivers/infiniband/core/nldev.c:1909 [inline]
> RIP: 0010:nldev_stat_set_doit+0x578/0x10d0 drivers/infiniband/core/nldev.c:2040
> Code: fa 4c 8b a4 24 f8 02 00 00 48 b8 00 00 00 00 00 fc ff df c7 84 24 80 00 00 00 00 00 00 00 49 8d 7c 24 04 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 02
> RSP: 0018:ffffc90004acf2e8 EFLAGS: 00010247
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc90002b94000
> RDX: 0000000000000000 RSI: ffffffff8684c5ff RDI: 0000000000000004
> RBP: ffff88807cda4000 R08: 0000000000000000 R09: ffff888023fb8027
> R10: ffffffff8684c5d7 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000001 R14: ffff888041024280 R15: ffff888031ade780
> FS:  00007eff9dddd700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2ef24000 CR3: 0000000036902000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess):
>    0:	fa                   	cli
>    1:	4c 8b a4 24 f8 02 00 	mov    0x2f8(%rsp),%r12
>    8:	00
>    9:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
>   10:	fc ff df
>   13:	c7 84 24 80 00 00 00 	movl   $0x0,0x80(%rsp)
>   1a:	00 00 00 00
>   1e:	49 8d 7c 24 04       	lea    0x4(%r12),%rdi
>   23:	48 89 fa             	mov    %rdi,%rdx
>   26:	48 c1 ea 03          	shr    $0x3,%rdx
> * 2a:	0f b6 14 02          	movzbl (%rdx,%rax,1),%edx <-- trapping instruction
>   2e:	48 89 f8             	mov    %rdi,%rax
>   31:	83 e0 07             	and    $0x7,%eax
>   34:	83 c0 03             	add    $0x3,%eax
>   37:	38 d0                	cmp    %dl,%al
>   39:	7c 08                	jl     0x43
>   3b:	84 d2                	test   %dl,%dl
>   3d:	0f                   	.byte 0xf
>   3e:	85 02                	test   %eax,(%rdx)
>

From fb6bcdb798854946a92ec556fbdf4956d0dc0128 Mon Sep 17 00:00:00 2001
Message-Id: <fb6bcdb798854946a92ec556fbdf4956d0dc0128.1636982132.git.leonro@nvidia.com>
From: Leon Romanovsky <leonro@nvidia.com>
Date: Mon, 15 Nov 2021 15:11:40 +0200
Subject: [PATCH] RDMA/nldev: Check stat attribute before accessing it

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 6744 Comm: syz-executor.0 Not tainted 5.15.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:nla_get_u32 include/net/netlink.h:1554 [inline]
RIP: 0010:nldev_stat_set_mode_doit drivers/infiniband/core/nldev.c:1909 [inline]
RIP: 0010:nldev_stat_set_doit+0x578/0x10d0 drivers/infiniband/core/nldev.c:2040
Code: fa 4c 8b a4 24 f8 02 00 00 48 b8 00 00 00 00 00 fc ff df c7 84 24 80 00 00 00 00 00 00 00 49 8d 7c 24 04 48 89
fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 02
RSP: 0018:ffffc90004acf2e8 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc90002b94000
RDX: 0000000000000000 RSI: ffffffff8684c5ff RDI: 0000000000000004
RBP: ffff88807cda4000 R08: 0000000000000000 R09: ffff888023fb8027
R10: ffffffff8684c5d7 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000001 R14: ffff888041024280 R15: ffff888031ade780
FS:  00007eff9dddd700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2ef24000 CR3: 0000000036902000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 rdma_nl_rcv_msg+0x36d/0x690 drivers/infiniband/core/netlink.c:195
 rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
 rdma_nl_rcv+0x2ee/0x430 drivers/infiniband/core/netlink.c:259
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x86d/0xda0 net/netlink/af_netlink.c:1916
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7effa0867ae9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b
4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007eff9dddd188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007effa097af60 RCX: 00007effa0867ae9
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000003
RBP: 00007effa08c1f6d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc008a753f R14: 00007eff9dddd300 R15: 0000000000022000
 </TASK>
Modules linked in:
---[ end trace bacb470dc6c820de ]---
RIP: 0010:nla_get_u32 include/net/netlink.h:1554 [inline]
RIP: 0010:nldev_stat_set_mode_doit drivers/infiniband/core/nldev.c:1909 [inline]
RIP: 0010:nldev_stat_set_doit+0x578/0x10d0 drivers/infiniband/core/nldev.c:2040
Code: fa 4c 8b a4 24 f8 02 00 00 48 b8 00 00 00 00 00 fc ff df c7 84 24 80 00 00 00 00 00 00 00 49 8d 7c 24 04 48 89
fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 02
RSP: 0018:ffffc90004acf2e8 EFLAGS: 00010247
RIP: 0010:nldev_stat_set_mode_doit drivers/infiniband/core/nldev.c:1909 [inline]
RIP: 0010:nldev_stat_set_doit+0x578/0x10d0 drivers/infiniband/core/nldev.c:2040
Code: fa 4c 8b a4 24 f8 02 00 00 48 b8 00 00 00 00 00 fc ff df c7 84 24 80 00 00 00 00 00 00 00 49 8d 7c 24 04 48 89
fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 02
RSP: 0018:ffffc90004acf2e8 EFLAGS: 00010247
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc90002b94000
RDX: 0000000000000000 RSI: ffffffff8684c5ff RDI: 0000000000000004
RBP: ffff88807cda4000 R08: 0000000000000000 R09: ffff888023fb8027
R10: ffffffff8684c5d7 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000001 R14: ffff888041024280 R15: ffff888031ade780
FS:  00007eff9dddd700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2ef24000 CR3: 0000000036902000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

Fixes: 822cf785ac6d ("RDMA/nldev: Split nldev_stat_set_mode_doit out of nldev_stat_set_doit")
Reported-by: syzbot+9111d2255a9710e87562@syzkaller.appspotmail.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/nldev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index fedc0fa6ebf9..f5aacaf7fb8e 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1906,7 +1906,8 @@ static int nldev_stat_set_mode_doit(struct sk_buff *msg,
 	int ret;
 
 	/* Currently only counter for QP is supported */
-	if (nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_RES]) != RDMA_NLDEV_ATTR_RES_QP)
+	if (!tb[RDMA_NLDEV_ATTR_STAT_RES] ||
+	    nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_RES]) != RDMA_NLDEV_ATTR_RES_QP)
 		return -EINVAL;
 
 	mode = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_MODE]);
-- 
2.33.1

