Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51830381AD
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 01:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbfFFXOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 19:14:07 -0400
Received: from mail-it1-f198.google.com ([209.85.166.198]:35524 "EHLO
        mail-it1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbfFFXOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 19:14:07 -0400
Received: by mail-it1-f198.google.com with SMTP id 137so328464itf.0
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 16:14:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=l9pinidd/tGKCpjMseqDc7ZTsfhvn4wdVbMaTBOdGOM=;
        b=SfXGQoFZM20PuBT88xD+IqM+MgILYxJrCcdye3Cq1LxGJoRWiVtSca36rcdyt73I6c
         GDCqHYkOshyGN/swM0U2hs1o0ZQPQOA14ZF3srSJZXLe5R6UMEiPfjVzLQy2ljS9316r
         pwSwHo38512lTfSBTo9CsN3JpKXVHWf3m3tLLUv/CRRmOth94mSe0ZHTbtmgRADmU+r8
         wwEmqmr0OxFZDAKLMeg/QDdEl3vKH+ix7Tj3KvjXIFdgPcr/SGei9zhPlmmFygC/rtTn
         6A+hLdZZQsPA2WVrsBzcCtprbukbrZNVJCAehll/MSsUnaIIDs9NUYOTzLsdnoG1ee3k
         Cjhg==
X-Gm-Message-State: APjAAAXgMtDYbcXu6N9FFi+251y6pyQ+tiiwHZ8oDEcHD2QrUKfZQVt2
        heWC99Ssag6DXQh1bDaDFcjJdnYqWDArPUuifOf21QFLqrGb
X-Google-Smtp-Source: APXvYqxXzf2VfP3HezFCUmwxAxPbzY6848/Uvr4YiHxacLFlLIXnL5YVIpNhLVk/FcFtL6Fq36VBeprvCc22BZWMQ22t5eaKQNia
MIME-Version: 1.0
X-Received: by 2002:a5e:c705:: with SMTP id f5mr33202129iop.113.1559862846161;
 Thu, 06 Jun 2019 16:14:06 -0700 (PDT)
Date:   Thu, 06 Jun 2019 16:14:06 -0700
In-Reply-To: <0000000000006b30f30587a5b569@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d810c9058aafdeb9@google.com>
Subject: Re: general protection fault in ip6_dst_lookup_tail (2)
From:   syzbot <syzbot+58d8f704b86e4e3fb4d3@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, dvyukov@google.com, edumazet@google.com,
        kafai@fb.com, kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    07c3bbdb samples: bpf: print a warning about headers_install
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14424e2ea00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b7b54c66298f8420
dashboard link: https://syzkaller.appspot.com/bug?extid=58d8f704b86e4e3fb4d3
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=117f50e1a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+58d8f704b86e4e3fb4d3@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 14003 Comm: syz-executor.4 Not tainted 5.2.0-rc2+ #14
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:ip6_route_get_saddr include/net/ip6_route.h:120 [inline]
RIP: 0010:ip6_dst_lookup_tail+0xf0e/0x1b30 net/ipv6/ip6_output.c:1032
Code: e6 07 e8 75 66 55 fb 48 85 db 0f 84 83 08 00 00 e8 67 66 55 fb 48 8d  
7b 7c 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48  
89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 07
RSP: 0018:ffff888079027480 EFLAGS: 00010a07
RAX: dffffc0000000000 RBX: ff8880990716c000 RCX: 0000000000000000
RDX: 1ff1101320e2d80f RSI: ffffffff861b3f59 RDI: ff8880990716c07c
RBP: ffff8880790275d8 R08: ffff8880855b43c0 R09: ffffed1015d26be8
R10: ffffed1015d26be7 R11: ffff8880ae935f3b R12: ffff888079027740
R13: 0000000000000000 R14: 0000000000000000 R15: ffff888079027768
FS:  00007f7158009700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd85cf4eb8 CR3: 00000000a96aa000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  ip6_dst_lookup_flow+0xa8/0x220 net/ipv6/ip6_output.c:1155
  tcp_v6_connect+0xda3/0x20a0 net/ipv6/tcp_ipv6.c:282
  __inet_stream_connect+0x834/0xe90 net/ipv4/af_inet.c:659
  tcp_sendmsg_fastopen net/ipv4/tcp.c:1143 [inline]
  tcp_sendmsg_locked+0x2318/0x3920 net/ipv4/tcp.c:1185
  tcp_sendmsg+0x30/0x50 net/ipv4/tcp.c:1419
  inet_sendmsg+0x141/0x5d0 net/ipv4/af_inet.c:802
  sock_sendmsg_nosec net/socket.c:652 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:671
  ___sys_sendmsg+0x803/0x920 net/socket.c:2292
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2330
  __do_sys_sendmsg net/socket.c:2339 [inline]
  __se_sys_sendmsg net/socket.c:2337 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2337
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459279
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f7158008c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459279
RDX: 0000000020008844 RSI: 0000000020000240 RDI: 0000000000000005
RBP: 000000000075bfc0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f71580096d4
R13: 00000000004c6ccc R14: 00000000004dbb30 R15: 00000000ffffffff
Modules linked in:
---[ end trace c968f232eacd4c70 ]---
RIP: 0010:ip6_route_get_saddr include/net/ip6_route.h:120 [inline]
RIP: 0010:ip6_dst_lookup_tail+0xf0e/0x1b30 net/ipv6/ip6_output.c:1032
Code: e6 07 e8 75 66 55 fb 48 85 db 0f 84 83 08 00 00 e8 67 66 55 fb 48 8d  
7b 7c 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48  
89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 07
RSP: 0018:ffff888079027480 EFLAGS: 00010a07
RAX: dffffc0000000000 RBX: ff8880990716c000 RCX: 0000000000000000
RDX: 1ff1101320e2d80f RSI: ffffffff861b3f59 RDI: ff8880990716c07c
RBP: ffff8880790275d8 R08: ffff8880855b43c0 R09: ffffed1015d26be8
R10: ffffed1015d26be7 R11: ffff8880ae935f3b R12: ffff888079027740
R13: 0000000000000000 R14: 0000000000000000 R15: ffff888079027768
FS:  00007f7158009700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000015523b8 CR3: 00000000a96aa000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

