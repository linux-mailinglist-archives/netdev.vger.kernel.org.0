Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C73D2E7C93
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 23:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730374AbfJ1WzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 18:55:11 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:53511 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730293AbfJ1WzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 18:55:10 -0400
Received: by mail-il1-f199.google.com with SMTP id a17so11076663ilb.20
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 15:55:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=vY/N7v2t/GE362uzn4Abb/5HTpyYYD2/oUVWVp0aInw=;
        b=TQJRxgFiQ0J1Xjjh8TaoxxvfFrfLi1WKqD29kVGM9vi+6dfAF3gkHZaix81t5M0qkn
         PR7PPUUYF+KphgwsdoY0aCAu3aKCWkHR9EDxZMA0NxkkzTz65kIWV838jGry1iIpcCKZ
         tdLodBrDNS+24F9graLkt838N1+ADMOY/uoro0sjLzk3JV7QknyywMIzuCMY9AshRZme
         zrqa/9RxTfs6rg0lTDSNovAxD6RGdDW+E4EQqx8h2xtMN+faKMoeiY6pl5NwHVuBKK/e
         Ohhu/25oR8Qdfs+SjzlNbvbB6wcrS5BnWiS3iZL6rZiov3mHiSh6wNIA1aszheebACIK
         B1fw==
X-Gm-Message-State: APjAAAUr8L1Dx3IbjvPAW2ASbUFEgFIJQ7Ii20833G/0Obldw9mg8LaQ
        cc3HoFTiaAM3wFTt895nndkiKljSQRKOklmkqknvxn6OKsOO
X-Google-Smtp-Source: APXvYqzPfK+JP3d2xM6YXsCnlTrI2nYCxZllII3PTOxvU7AU4AiC4aD61MVhn3Da0ul4xjSyA0WNFZgH00ONhENi/WAwXHH3EUkA
MIME-Version: 1.0
X-Received: by 2002:a92:104a:: with SMTP id y71mr22333594ill.220.1572303309421;
 Mon, 28 Oct 2019 15:55:09 -0700 (PDT)
Date:   Mon, 28 Oct 2019 15:55:09 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003cc4980596006472@google.com>
Subject: general protection fault in ip6_sublist_rcv
From:   syzbot <syzbot+c54f457cad330e57e967@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, ecree@solarflare.com,
        fw@strlen.de, kadlec@netfilter.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    12d61c69 Add linux-next specific files for 20191024
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10608674e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=afb75fd8c9fd5ed8
dashboard link: https://syzkaller.appspot.com/bug?extid=c54f457cad330e57e967
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=134be44ce00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15938e18e00000

The bug was bisected to:

commit ca58fbe06c54795f00db79e447f94c2028d30124
Author: Florian Westphal <fw@strlen.de>
Date:   Thu Oct 10 22:30:37 2019 +0000

     netfilter: add and use nf_hook_slow_list()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16366800e00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=15366800e00000
console output: https://syzkaller.appspot.com/x/log.txt?x=11366800e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c54f457cad330e57e967@syzkaller.appspotmail.com
Fixes: ca58fbe06c54 ("netfilter: add and use nf_hook_slow_list()")

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 9027 Comm: syz-executor906 Not tainted 5.4.0-rc4-next-20191024  
#0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__read_once_size include/linux/compiler.h:199 [inline]
RIP: 0010:NF_HOOK_LIST include/linux/netfilter.h:331 [inline]
RIP: 0010:ip6_sublist_rcv+0x5c9/0x930 net/ipv6/ip6_input.c:292
Code: 0f 85 73 01 00 00 e8 06 63 24 fb 48 8b 85 00 ff ff ff 48 8d b8 10 0f  
00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 44 03 00 00 48 8b 85 00 ff ff ff 4c 8b a0 10 0f
RSP: 0018:ffff8880956af3c0 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff864f0e0e
RDX: 00000000000001e2 RSI: ffffffff864f0c6a RDI: 0000000000000f10
RBP: ffff8880956af4f0 R08: ffff8880a1778040 R09: ffffed1015d26b7d
R10: ffffed1015d26b7c R11: ffff8880ae935be3 R12: 0000000000000001
R13: ffff8880956af4c8 R14: ffff8880956af558 R15: ffff8880956af680
FS:  0000000000819880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000780 CR3: 0000000089dec000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  ipv6_list_rcv+0x373/0x4b0 net/ipv6/ip6_input.c:328
  __netif_receive_skb_list_ptype net/core/dev.c:5274 [inline]
  __netif_receive_skb_list_core+0x5fc/0x9d0 net/core/dev.c:5322
  __netif_receive_skb_list net/core/dev.c:5374 [inline]
  netif_receive_skb_list_internal+0x7eb/0xe50 net/core/dev.c:5469
  gro_normal_list.part.0+0x1e/0xb0 net/core/dev.c:5892
  gro_normal_list net/core/dev.c:5905 [inline]
  gro_normal_one+0x184/0x1d0 net/core/dev.c:5904
  napi_frags_finish net/core/dev.c:6008 [inline]
  napi_gro_frags+0x915/0xd00 net/core/dev.c:6081
  tun_get_user+0x2e8e/0x3f80 drivers/net/tun.c:1976
  tun_chr_write_iter+0xbd/0x156 drivers/net/tun.c:2022
  call_write_iter include/linux/fs.h:1902 [inline]
  do_iter_readv_writev+0x5f8/0x8f0 fs/read_write.c:693
  do_iter_write fs/read_write.c:970 [inline]
  do_iter_write+0x184/0x610 fs/read_write.c:951
  vfs_writev+0x1b3/0x2f0 fs/read_write.c:1015
  do_writev+0x15b/0x330 fs/read_write.c:1058
  __do_sys_writev fs/read_write.c:1131 [inline]
  __se_sys_writev fs/read_write.c:1128 [inline]
  __x64_sys_writev+0x75/0xb0 fs/read_write.c:1128
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441d80
Code: 05 48 3d 01 f0 ff ff 0f 83 5d 09 fc ff c3 66 2e 0f 1f 84 00 00 00 00  
00 66 90 83 3d 91 92 29 00 00 75 14 b8 14 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 34 09 fc ff c3 48 83 ec 08 e8 ba 2b 00 00
RSP: 002b:00007ffc73f8e2e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 00007ffc73f8e300 RCX: 0000000000441d80
RDX: 0000000000000001 RSI: 00007ffc73f8e330 RDI: 00000000000000f0
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000004
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000012dae
R13: 0000000000402bd0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace b92638c9e1a03392 ]---
RIP: 0010:__read_once_size include/linux/compiler.h:199 [inline]
RIP: 0010:NF_HOOK_LIST include/linux/netfilter.h:331 [inline]
RIP: 0010:ip6_sublist_rcv+0x5c9/0x930 net/ipv6/ip6_input.c:292
Code: 0f 85 73 01 00 00 e8 06 63 24 fb 48 8b 85 00 ff ff ff 48 8d b8 10 0f  
00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 44 03 00 00 48 8b 85 00 ff ff ff 4c 8b a0 10 0f
RSP: 0018:ffff8880956af3c0 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff864f0e0e
RDX: 00000000000001e2 RSI: ffffffff864f0c6a RDI: 0000000000000f10
RBP: ffff8880956af4f0 R08: ffff8880a1778040 R09: ffffed1015d26b7d
R10: ffffed1015d26b7c R11: ffff8880ae935be3 R12: 0000000000000001
R13: ffff8880956af4c8 R14: ffff8880956af558 R15: ffff8880956af680
FS:  0000000000819880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000780 CR3: 0000000089dec000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
