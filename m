Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C89EC3C4C2
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 09:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404224AbfFKHRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 03:17:06 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:42065 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404163AbfFKHRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 03:17:06 -0400
Received: by mail-io1-f69.google.com with SMTP id f22so9337159ioj.9
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 00:17:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=sw6MqUB744A97+tTNzzmQnwEe7UVA9JNFZ1hLm4vPFM=;
        b=UadulMNikZq+q5thQjnVcjxuo427BOrk3+/+uhSEwXfBUwS7TU4NF0J9IN0iPxr/ze
         k4yJO6h173wowMYwORvqeUp3SF/zC4fWgMK9fJgKRIEnmQta+ggzKNsGb+Tw39iI/tPc
         i4yX+yxFKS7raeDJteA/mRR3UOGEuJvqDNRGPEU3QlbEV0donipga0yAF7DWxbnAzp2S
         qQaPKDT1rNjsva4pXosaZmh1p/x1NX/554o1dyPpfnpKoQmPeLakmrW8qf5VmY5iEUSb
         xb4PKQSEcPOp3AaeRMwMsdVQbqVdkPToEwuVK99swkmwSrbKBhevZPx28u1t7SUYG92F
         +aCg==
X-Gm-Message-State: APjAAAVBUdbpvn0Rz/pDXGGqFpeOK+feGr13XkwsOQwnlHEDSnRejMgL
        aM9PDb9ewywpfbkNn6KKNdG42REkgHrtKOSv9+eFZaI413VG
X-Google-Smtp-Source: APXvYqwn3pmXW0bnHktJx82leAzImdvsX0tuMoPjDTllG79Qm0WhSxoBmMgXZFXeCfhHkPugZzK/D4i1fd9lChS558OIW9GfqdKj
MIME-Version: 1.0
X-Received: by 2002:a6b:4f14:: with SMTP id d20mr3597701iob.219.1560237425296;
 Tue, 11 Jun 2019 00:17:05 -0700 (PDT)
Date:   Tue, 11 Jun 2019 00:17:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000800bf0058b07151d@google.com>
Subject: general protection fault in x25_connect
From:   syzbot <syzbot+2fde26e61fda58e5f88b@syzkaller.appspotmail.com>
To:     allison@lohutok.net, andrew.hendry@gmail.com, arnd@arndb.de,
        davem@davemloft.net, edumazet@google.com,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org,
        ms@dev.tdt.de, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    8d94a873 Merge branch 'PTP-support-for-the-SJA1105-DSA-dri..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1065a26aa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f7a0e5816ab80450
dashboard link: https://syzkaller.appspot.com/bug?extid=2fde26e61fda58e5f88b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2fde26e61fda58e5f88b@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 21527 Comm: syz-executor.0 Not tainted 5.2.0-rc3+ #21
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__read_once_size include/linux/compiler.h:194 [inline]
RIP: 0010:arch_atomic_read arch/x86/include/asm/atomic.h:31 [inline]
RIP: 0010:atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
RIP: 0010:refcount_sub_and_test_checked+0x8e/0x200 lib/refcount.c:182
Code: f3 f3 65 48 8b 04 25 28 00 00 00 48 89 45 d0 31 c0 e8 16 5c 3c fe be  
04 00 00 00 48 89 df e8 49 03 75 fe 48 89 d8 48 c1 e8 03 <42> 0f b6 14 20  
48 89 d8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85
RSP: 0018:ffff8880909dfbc8 EFLAGS: 00010202
RAX: 0000000000000019 RBX: 00000000000000c8 RCX: ffffffff83344bf7
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 00000000000000c8
RBP: ffff8880909dfc60 R08: 1ffffffff12c929c R09: fffffbfff12c929d
R10: fffffbfff12c929c R11: ffffffff896494e3 R12: dffffc0000000000
R13: 0000000000000000 R14: ffff8880909dfc38 R15: 1ffff1101213bf7b
FS:  00007f0de0733700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd127e58000 CR3: 000000008a725000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  refcount_dec_and_test_checked+0x1b/0x20 lib/refcount.c:220
  x25_neigh_put include/net/x25.h:252 [inline]
  x25_connect+0x8d8/0xea0 net/x25/af_x25.c:820
  __sys_connect+0x264/0x330 net/socket.c:1834
  __do_sys_connect net/socket.c:1845 [inline]
  __se_sys_connect net/socket.c:1842 [inline]
  __x64_sys_connect+0x73/0xb0 net/socket.c:1842
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459279
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f0de0732c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459279
RDX: 0000000000000012 RSI: 0000000020000140 RDI: 0000000000000004
RBP: 000000000075c1a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f0de07336d4
R13: 00000000004bf854 R14: 00000000004d1068 R15: 00000000ffffffff
Modules linked in:
---[ end trace 07098343a5405a38 ]---
RIP: 0010:__read_once_size include/linux/compiler.h:194 [inline]
RIP: 0010:arch_atomic_read arch/x86/include/asm/atomic.h:31 [inline]
RIP: 0010:atomic_read include/asm-generic/atomic-instrumented.h:27 [inline]
RIP: 0010:refcount_sub_and_test_checked+0x8e/0x200 lib/refcount.c:182


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
