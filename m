Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 620EA13ED79
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406882AbgAPSDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:03:15 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:38793 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387417AbgAPSDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 13:03:14 -0500
Received: by mail-io1-f72.google.com with SMTP id x2so13240267iog.5
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 10:03:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=28w+TnfQPs2OAlAHKwypZqdlk2gBKd0vMI6H+yLAPI0=;
        b=j5H3+SrLZp6HylJvZArQ/D2LtFcgTgBPkS3mjzdSkYGZcpLVUOCHamMxggsTtdKazx
         s1OiYxzZ17TNYTZdls9IGktKF/vD0ZlQRy28RQsDEd8RxGh+SlT50ikCPIu0tfgpXdJV
         M+B+xjPYtekaBl6TkZX5/dLaWw7x5CKpkdyghdIGAyQip1wzH7eEnkB9Qw5xm10j03pW
         MWDFbt3K/F4FhTr4Ra1Oyves2pDeeJS89ed/UVSJhdmq4cgYXm8NfXHyNODE3bitjLW5
         wK7hpy7Zjl+c6Ij+1iUh92nIGmEKWfAZpr0ZyIMVH9WsLU8iQGXfjmSiXPYjD0G+YKKH
         nQvg==
X-Gm-Message-State: APjAAAVyhAgo/4W9sX2rX9RrIvE1DGic/rkgI7IQyjBFIyVJwX0SaC86
        8pxrIHt0haKHjp3WvsxIfQxyatohJYTItaWFveK+Pt7uchEt
X-Google-Smtp-Source: APXvYqybWgtu4NPUk+UyS4Y5Wfio5iwok+mL2fZGLaLlhsUTF1Danv1Hrt5aE7S+K8IOFvuYNfvFLaq3HY6Bplk7v2ee+RfbLs+J
MIME-Version: 1.0
X-Received: by 2002:a92:911b:: with SMTP id t27mr4584673ild.142.1579197793181;
 Thu, 16 Jan 2020 10:03:13 -0800 (PST)
Date:   Thu, 16 Jan 2020 10:03:13 -0800
In-Reply-To: <00000000000074ed27059c33dedc@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007e27cd059c45a3b8@google.com>
Subject: Re: general protection fault in nft_chain_parse_hook
From:   syzbot <syzbot+156a04714799b1d480bc@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    f5ae2ea6 Fix built-in early-load Intel microcode alignment
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=112c92d1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9290aeb7e6cf1c4
dashboard link: https://syzkaller.appspot.com/bug?extid=156a04714799b1d480bc
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=110253aee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=170d8159e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+156a04714799b1d480bc@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9678 Comm: syz-executor546 Not tainted 5.5.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:nft_chain_parse_hook+0x386/0xa10  
net/netfilter/nf_tables_api.c:1767
Code: e8 5f 27 0e fb 41 83 fd 05 0f 87 62 05 00 00 e8 d0 25 0e fb 49 8d 7c  
24 18 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84  
c0 74 08 3c 03 0f 8e a6 05 00 00 44 89 e9 be 01 00
RSP: 0018:ffffc900021370f0 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffffc900021372a0 RCX: ffffffff8666cfa1
RDX: 0000000000000003 RSI: ffffffff8666cfb0 RDI: 0000000000000018
RBP: ffffc900021371e0 R08: ffff88809c7ce380 R09: 0000000000000000
R10: fffff52000426e2d R11: ffffc9000213716f R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: ffffc900021371b8
FS:  0000000000000000(0000) GS:ffff8880ae800000(0063) knlGS:0000000009dfd840
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000020000280 CR3: 00000000a29dd000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  nf_tables_addchain.constprop.0+0x1c1/0x1520  
net/netfilter/nf_tables_api.c:1888
  nf_tables_newchain+0x1033/0x1820 net/netfilter/nf_tables_api.c:2196
  nfnetlink_rcv_batch+0xf42/0x17a0 net/netfilter/nfnetlink.c:433
  nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:543 [inline]
  nfnetlink_rcv+0x3e7/0x460 net/netfilter/nfnetlink.c:561
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:639 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:659
  ____sys_sendmsg+0x753/0x880 net/socket.c:2330
  ___sys_sendmsg+0x100/0x170 net/socket.c:2384
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
  __compat_sys_sendmsg net/compat.c:642 [inline]
  __do_compat_sys_sendmsg net/compat.c:649 [inline]
  __se_compat_sys_sendmsg net/compat.c:646 [inline]
  __ia32_compat_sys_sendmsg+0x7a/0xb0 net/compat.c:646
  do_syscall_32_irqs_on arch/x86/entry/common.c:337 [inline]
  do_fast_syscall_32+0x27b/0xe16 arch/x86/entry/common.c:408
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7fafa39
Code: 00 00 00 89 d3 5b 5e 5f 5d c3 b8 80 96 98 00 eb c4 8b 04 24 c3 8b 1c  
24 c3 8b 34 24 c3 8b 3c 24 c3 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90  
90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000ffc60f6c EFLAGS: 00000202 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 000000002000d400
RDX: 0000000004000000 RSI: 00000000080ea00c RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace ef2c8b24d08b7122 ]---
RIP: 0010:nft_chain_parse_hook+0x386/0xa10  
net/netfilter/nf_tables_api.c:1767
Code: e8 5f 27 0e fb 41 83 fd 05 0f 87 62 05 00 00 e8 d0 25 0e fb 49 8d 7c  
24 18 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84  
c0 74 08 3c 03 0f 8e a6 05 00 00 44 89 e9 be 01 00
RSP: 0018:ffffc900021370f0 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: ffffc900021372a0 RCX: ffffffff8666cfa1
RDX: 0000000000000003 RSI: ffffffff8666cfb0 RDI: 0000000000000018
RBP: ffffc900021371e0 R08: ffff88809c7ce380 R09: 0000000000000000
R10: fffff52000426e2d R11: ffffc9000213716f R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: ffffc900021371b8
FS:  0000000000000000(0000) GS:ffff8880ae800000(0063) knlGS:0000000009dfd840
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000020000280 CR3: 00000000a29dd000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

