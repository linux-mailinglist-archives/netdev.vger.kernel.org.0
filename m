Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2511BB598
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 06:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgD1E6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 00:58:15 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:38569 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbgD1E6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 00:58:14 -0400
Received: by mail-io1-f69.google.com with SMTP id j17so22996889iow.5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 21:58:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=jDxTq18iQLRP71qk5eZAXRKfx5I/e7pacfifgvLqqOY=;
        b=ZhJzosV01jKOFg36KVQdDpfjnhe4CeMcAm3AKo+URki7jdJPFI7jl4gTOiJaC+aLRI
         9IS1CF1SkmsVYEDb5imwY6Zm999R9GJ9AGdJDEAMIrYtKwt1nWbkemEb+wt5HYcW29hy
         +DSyrUmQvirVZldqFiyoXDGwPIA7Yu7s+9ESnkFUT/mw2w8ovgZHlgQqjUJjo+21fAK/
         E8j9jjlt8eqk5unNLR3uut5GfNNBLcsnzPjri0NXaWTb+mBYigVqNfpOjq7GBgUrzoZC
         thI1tYgYhKCDZn/9IOO4eAD21TKncKlwxM8ci75IygcKfjcbH4KEqWjaAqqJBSqKZrro
         9rBA==
X-Gm-Message-State: AGi0PuaRnzSIW4gS0jg7EJKYQxQN2cErQrmFodkyDfr46/C+AB1iw+DV
        9zWKgigcMT01eziGY9VY0mHQ9MpyrazPPsTlIViW45lsofQY
X-Google-Smtp-Source: APiQypKO9qT/WbPujDkprL5mYneQXm6Kg8tQh8e3bmDL4h64jSR4p3haxuo0qZycTXhbhCbPjGczxXFFh3CIJ4A2NyTkzmECUpH3
MIME-Version: 1.0
X-Received: by 2002:a5d:8c81:: with SMTP id g1mr8512085ion.197.1588049893648;
 Mon, 27 Apr 2020 21:58:13 -0700 (PDT)
Date:   Mon, 27 Apr 2020 21:58:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cbf17205a452ad4f@google.com>
Subject: net test error: KASAN: null-ptr-deref Write in x25_disconnect
From:   syzbot <syzbot+6db548b615e5aeefdce2@syzkaller.appspotmail.com>
To:     andrew.hendry@gmail.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tanxin.ctf@gmail.com, tglx@linutronix.de, xiyuyang19@fudan.edu.cn
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    37255e7a Merge tag 'batadv-net-for-davem-20200427' of git:..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=12b2e5d8100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b7a70e992f2f9b68
dashboard link: https://syzkaller.appspot.com/bug?extid=6db548b615e5aeefdce2
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6db548b615e5aeefdce2@syzkaller.appspotmail.com

can: request_module (can-proto-0) failed.
can: request_module (can-proto-0) failed.
can: request_module (can-proto-0) failed.
==================================================================
BUG: KASAN: null-ptr-deref in atomic_fetch_sub include/asm-generic/atomic-instrumented.h:199 [inline]
BUG: KASAN: null-ptr-deref in refcount_sub_and_test include/linux/refcount.h:266 [inline]
BUG: KASAN: null-ptr-deref in refcount_dec_and_test include/linux/refcount.h:294 [inline]
BUG: KASAN: null-ptr-deref in x25_neigh_put include/net/x25.h:253 [inline]
BUG: KASAN: null-ptr-deref in x25_disconnect+0x253/0x370 net/x25/x25_subr.c:361
Write of size 4 at addr 00000000000000d8 by task syz-fuzzer/7147

CPU: 0 PID: 7147 Comm: syz-fuzzer Not tainted 5.7.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 __kasan_report.cold+0x5/0x4d mm/kasan/report.c:515
 kasan_report+0x33/0x50 mm/kasan/common.c:625
 check_memory_region_inline mm/kasan/generic.c:187 [inline]
 check_memory_region+0x141/0x190 mm/kasan/generic.c:193
 atomic_fetch_sub include/asm-generic/atomic-instrumented.h:199 [inline]
 refcount_sub_and_test include/linux/refcount.h:266 [inline]
 refcount_dec_and_test include/linux/refcount.h:294 [inline]
 x25_neigh_put include/net/x25.h:253 [inline]
 x25_disconnect+0x253/0x370 net/x25/x25_subr.c:361
 x25_release+0x345/0x420 net/x25/af_x25.c:665
 __sock_release+0xcd/0x280 net/socket.c:605
 sock_close+0x18/0x20 net/socket.c:1283
 __fput+0x33e/0x880 fs/file_table.c:280
 task_work_run+0xf4/0x1b0 kernel/task_work.c:123
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop+0x2fa/0x360 arch/x86/entry/common.c:165
 prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
 do_syscall_64+0x6b1/0x7d0 arch/x86/entry/common.c:305
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x4afb40
Code: 8b 7c 24 10 48 8b 74 24 18 48 8b 54 24 20 49 c7 c2 00 00 00 00 49 c7 c0 00 00 00 00 49 c7 c1 00 00 00 00 48 8b 44 24 08 0f 05 <48> 3d 01 f0 ff ff 76 20 48 c7 44 24 28 ff ff ff ff 48 c7 44 24 30
RSP: 002b:000000c0001e94f8 EFLAGS: 00000216 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 000000c00002c000 RCX: 00000000004afb40
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 000000c0001e9538 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000216 R12: ffffffffffffffff
R13: 0000000000000164 R14: 0000000000000163 R15: 0000000000000200
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
