Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65C94141F1E
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 17:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgASQ5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 11:57:10 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:33768 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbgASQ5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 11:57:09 -0500
Received: by mail-il1-f200.google.com with SMTP id s9so23382485ilk.0
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 08:57:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=bNseSmDTrA51braKCNj/lz4EvnVrSQC47Ii4IWwahNM=;
        b=RVoxzvq2TYWq8vuWtVHIexWanC/lGFBg+m+bB1i7TC0UggKJMzGPcKBzftTnu7FcRB
         9dnAP4BRyK5My57JhqCV0khBUjK4ne3Ucb7shIHgPdAL+a0+0SRmgt5FYpWb9WQb0TEc
         7GiEUjrmNbrv659g262s/y9fgBvuCz0q4hetsYLIcw9hCt1oCOv341InmokdMmSU8Fh+
         Rt3YnCWi8TiXPkHD9njxSrzTM0GuFpYfZmEAjKk+q3zkCFt9C6x/S54KWs47YYDyEG/i
         4fNAWqTu1KVJxN9jnsKV1SFf6y39+tklkxDlYyiXkgdrAUbm1jqWYNkNC10II4TiHK4k
         GOjw==
X-Gm-Message-State: APjAAAUQP7s8mPI4B5tmn4cFgpO8QhqlEu5qDJ2jiCVaPwLimzyVd1C+
        y8hnrRRXHsiv4UqnMVW4LVJtfMF3USux96OA/lqqaejGolZm
X-Google-Smtp-Source: APXvYqxtY1uF2i55A7gZpgNMxOtW4x67itM8KH16bEC/5RG58vOV3mD7hMCXY16SO+/4dgwzcRHUgxN9JvTO3yqcH2EcO5KclOcY
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:10d1:: with SMTP id s17mr7555983ilj.198.1579453028684;
 Sun, 19 Jan 2020 08:57:08 -0800 (PST)
Date:   Sun, 19 Jan 2020 08:57:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b6da7b059c8110c4@google.com>
Subject: general protection fault in nf_flow_table_offload_setup
From:   syzbot <syzbot+e93c1d9ae19a0236289c@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    7f013ede Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=133bfa85e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=66d8660c57ff3c98
dashboard link: https://syzkaller.appspot.com/bug?extid=e93c1d9ae19a0236289c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=166d8faee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11aec135e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e93c1d9ae19a0236289c@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 9684 Comm: syz-executor080 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__list_splice include/linux/list.h:408 [inline]
RIP: 0010:list_splice include/linux/list.h:424 [inline]
RIP: 0010:nf_flow_table_block_setup net/netfilter/nf_flow_table_offload.c:825 [inline]
RIP: 0010:nf_flow_table_offload_setup+0x4dc/0x6d0 net/netfilter/nf_flow_table_offload.c:882
Code: bc 24 50 ff ff ff 48 ba 00 00 00 00 00 fc ff df 4d 8b ae 00 02 00 00 4d 8b a4 24 58 ff ff ff 49 8d 7f 08 48 89 f9 48 c1 e9 03 <80> 3c 11 00 0f 85 cd 01 00 00 4c 89 e2 49 89 47 08 48 b8 00 00 00
RSP: 0018:ffffc90002007228 EFLAGS: 00010202
RAX: ffff888091272a50 RBX: 1ffff92000400e49 RCX: 0000000000000001
RDX: dffffc0000000000 RSI: ffffffff8673172e RDI: 0000000000000008
RBP: ffffc90002007370 R08: ffff888097816580 R09: fffff52000400e54
R10: fffff52000400e53 R11: ffffc9000200729e R12: ffffffff894a1188
R13: ffff888091272a50 R14: ffff888091272850 R15: 0000000000000000
FS:  0000000000ca3880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000104 CR3: 0000000092cc9000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 nft_register_flowtable_net_hooks net/netfilter/nf_tables_api.c:6025 [inline]
 nf_tables_newflowtable+0x1352/0x1e20 net/netfilter/nf_tables_api.c:6142
 nfnetlink_rcv_batch+0xf42/0x17a0 net/netfilter/nfnetlink.c:433
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:543 [inline]
 nfnetlink_rcv+0x3e7/0x460 net/netfilter/nfnetlink.c:561
 netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
 netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1328
 netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:672
 ____sys_sendmsg+0x753/0x880 net/socket.c:2343
 ___sys_sendmsg+0x100/0x170 net/socket.c:2397
 __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
 __do_sys_sendmsg net/socket.c:2439 [inline]
 __se_sys_sendmsg net/socket.c:2437 [inline]
 __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
 do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440519
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd2c0117d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440519
RDX: 0000000000000000 RSI: 0000000020003e00 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000401da0
R13: 0000000000401e30 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 536c0ff4bab32d1b ]---
RIP: 0010:__list_splice include/linux/list.h:408 [inline]
RIP: 0010:list_splice include/linux/list.h:424 [inline]
RIP: 0010:nf_flow_table_block_setup net/netfilter/nf_flow_table_offload.c:825 [inline]
RIP: 0010:nf_flow_table_offload_setup+0x4dc/0x6d0 net/netfilter/nf_flow_table_offload.c:882
Code: bc 24 50 ff ff ff 48 ba 00 00 00 00 00 fc ff df 4d 8b ae 00 02 00 00 4d 8b a4 24 58 ff ff ff 49 8d 7f 08 48 89 f9 48 c1 e9 03 <80> 3c 11 00 0f 85 cd 01 00 00 4c 89 e2 49 89 47 08 48 b8 00 00 00
RSP: 0018:ffffc90002007228 EFLAGS: 00010202
RAX: ffff888091272a50 RBX: 1ffff92000400e49 RCX: 0000000000000001
RDX: dffffc0000000000 RSI: ffffffff8673172e RDI: 0000000000000008
RBP: ffffc90002007370 R08: ffff888097816580 R09: fffff52000400e54
R10: fffff52000400e53 R11: ffffc9000200729e R12: ffffffff894a1188
R13: ffff888091272a50 R14: ffff888091272850 R15: 0000000000000000
FS:  0000000000ca3880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000104 CR3: 0000000092cc9000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
