Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08DB18984B
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 09:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfHLHwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 03:52:11 -0400
Received: from mail-ot1-f72.google.com ([209.85.210.72]:45508 "EHLO
        mail-ot1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbfHLHwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 03:52:07 -0400
Received: by mail-ot1-f72.google.com with SMTP id k22so2336782otn.12
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 00:52:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=OH93fWca/4l2t0OPYY7fQBiJZLVUQD1baC/AK+EW1xM=;
        b=LE8j3Ks4c666qftFfcCWcUj5ttBXqyFJYHUDLnBzSsTRfRGSpUrJAteBqxFNL0aWJs
         jF2iGbqP6w/+Jyfndz5GdgfVtmbnACCLd7CkjEtLymD2WcCLeqG5zybKHMzFiU4pKKab
         o2APk6py6JlPCdAzcm1o5MVN7eFbuhsqbpLzOrFHwLxTmphxbhkR2jWU0nq6Q1jhQvSu
         SQ0N8ySHmqpt4iOIheDReQppZn+hiy/rjn44DAGoTWRUl7cTOjLqed3Hv66OhwTkSEMM
         H83FsKSee3pYeuE3hkIP48pYlYaKg+FB0yf4ga9xahF8EGMBveale2SpmUvdiNQm4f6w
         Xxfw==
X-Gm-Message-State: APjAAAVdsT4vykd+Qggz+aAhpivlQRboPzwe8jlcgtZs+1VpwLCiqhAT
        8C/zje/0HQJgEnUS2neh4xeUhkVcgJfqw2IpBBvc+03TLz1F
X-Google-Smtp-Source: APXvYqwjiuV14Ib/83tW7qKM3T1Y2FExDsRucLSOJrDxuYNKhCV9LdWnoTshXT4NGQ2cThhzidZhEwAYvcga5JwZ5LB8Vb9GWJt5
MIME-Version: 1.0
X-Received: by 2002:a02:a503:: with SMTP id e3mr15886876jam.134.1565596325373;
 Mon, 12 Aug 2019 00:52:05 -0700 (PDT)
Date:   Mon, 12 Aug 2019 00:52:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d5f091058fe6cc6a@google.com>
Subject: BUG: unable to handle kernel NULL pointer dereference in rxrpc_unuse_local
From:   syzbot <syzbot+ae09baad492cce05644a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    57c722e9 net/tls: swap sk_write_space on close
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=13e6c6ee600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4c9e9f08e9e8960
dashboard link: https://syzkaller.appspot.com/bug?extid=ae09baad492cce05644a
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+ae09baad492cce05644a@syzkaller.appspotmail.com

BUG: kernel NULL pointer dereference, address: 0000000000000010
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
PGD 8bbd0067 P4D 8bbd0067 PUD 907a2067 PMD 0
Oops: 0002 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 11895 Comm: syz-executor.3 Not tainted 5.3.0-rc3+ #157
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:arch_atomic_add_return arch/x86/include/asm/atomic.h:167 [inline]
RIP: 0010:arch_atomic_sub_return arch/x86/include/asm/atomic.h:179 [inline]
RIP: 0010:atomic_sub_return include/asm-generic/atomic-instrumented.h:160  
[inline]
RIP: 0010:atomic_dec_return include/linux/atomic-fallback.h:455 [inline]
RIP: 0010:rxrpc_unuse_local+0x23/0x70 net/rxrpc/local_object.c:405
Code: 1f 84 00 00 00 00 00 55 48 89 e5 41 54 49 89 fc 53 bb ff ff ff ff e8  
4c 1a d7 fa 49 8d 7c 24 10 be 04 00 00 00 e8 8d 09 11 fb <f0> 41 0f c1 5c  
24 10 bf 01 00 00 00 89 de e8 aa 1b d7 fa 83 fb 01
RSP: 0018:ffff88806ab1fb28 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: ffffffff869b6f43
RDX: 0000000000000001 RSI: 0000000000000004 RDI: 0000000000000010
RBP: ffff88806ab1fb38 R08: ffff88805f40a480 R09: ffffed1010e9310f
R10: ffffed1010e9310e R11: ffff888087498877 R12: 0000000000000000
R13: ffff88805f48cd92 R14: ffff888087498680 R15: ffff88805f48d208
FS:  00007fe68c1f5700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000010 CR3: 00000000a1353000 CR4: 00000000001406f0
Call Trace:
  rxrpc_release_sock net/rxrpc/af_rxrpc.c:904 [inline]
  rxrpc_release+0x47d/0x840 net/rxrpc/af_rxrpc.c:930
  __sock_release+0xce/0x280 net/socket.c:590
  sock_close+0x1e/0x30 net/socket.c:1268
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  get_signal+0x2078/0x2500 kernel/signal.c:2523
  do_signal+0x87/0x1700 arch/x86/kernel/signal.c:815
  exit_to_usermode_loop+0x286/0x380 arch/x86/entry/common.c:159
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459829
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fe68c1f4c78 EFLAGS: 00000246 ORIG_RAX: 000000000000010f
RAX: 0000000000000003 RBX: 0000000000000005 RCX: 0000000000459829
RDX: 0000000020003440 RSI: 0000000000000005 RDI: 00000000200033c0
RBP: 000000000075c070 R08: 0000000000000008 R09: 0000000000000000
R10: 0000000020003480 R11: 0000000000000246 R12: 00007fe68c1f56d4
R13: 00000000004c6706 R14: 00000000004db7b8 R15: 00000000ffffffff
Modules linked in:
CR2: 0000000000000010


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
