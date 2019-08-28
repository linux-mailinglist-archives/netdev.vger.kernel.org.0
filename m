Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 633B19FAA9
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 08:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfH1GiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 02:38:15 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:42810 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbfH1GiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 02:38:08 -0400
Received: by mail-io1-f70.google.com with SMTP id x9so2445776ior.9
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 23:38:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=woeCxsXHnyNdpIBIPZbJhfaZda9otvsrQJ4bJXSooVQ=;
        b=QCe7jV8qWqeBvbh7gfzQ970FNAW75548ta6/brvEeGQruZaM+BshWwU8iiTOLX2uJR
         Kh83LB6pRhKOxefkuGJoSCu9XPhu5CsJUr1O5I7KBWhYA7wxTa4EvXs8O90d+Vu/Pk7z
         15cEdGDu0nDN6wjmHp5C9cog5J/3Vf/8TRmozAzsSTzk3Rg5TAMTvT1joABlpMQ2TVpq
         8y8CUDe9NGUCT4sCteSAUpE9v/RPzK5hC2vLN3fYzRtsL3P3AUC29b7Ddpakdk5Fw6dh
         KIIXReGXMHX/4liTToHlY3JDoNFxKW0y+SryHaPZbiUrZCawRFM8RGcJqPYDg7j0sRVe
         jjlw==
X-Gm-Message-State: APjAAAVBoAEv4FBOKadUTSWTOCqra9GScAW2cQk54QXKYyVFVIAlSxL4
        YFbRqh/Xcv9upD0yUSb7LteJEwv+vd7QFkGQr/Tn5I9v5IPD
X-Google-Smtp-Source: APXvYqxEQdIaLjs0q1sap0kNTSYdolYvDg1ysrcJGvPplzyOPEpEayaDy+oYtrDumQakPVe1knejFOzyWhqhMMwtUwq/aNaAiW3g
MIME-Version: 1.0
X-Received: by 2002:a02:b4a:: with SMTP id 71mr2702946jad.25.1566974287264;
 Tue, 27 Aug 2019 23:38:07 -0700 (PDT)
Date:   Tue, 27 Aug 2019 23:38:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c3c461059127a1c4@google.com>
Subject: general protection fault in tls_sk_proto_close (2)
From:   syzbot <syzbot+7a6ee4d0078eac6bf782@syzkaller.appspotmail.com>
To:     aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    a55aa89a Linux 5.3-rc6
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16c26ebc600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2a6a2b9826fdadf9
dashboard link: https://syzkaller.appspot.com/bug?extid=7a6ee4d0078eac6bf782
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1112a4de600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+7a6ee4d0078eac6bf782@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 10290 Comm: syz-executor.0 Not tainted 5.3.0-rc6 #120
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:tls_sk_proto_close+0xe5/0x990 net/tls/tls_main.c:298
Code: 0f 85 3f 08 00 00 49 8b 84 24 c0 02 00 00 4d 8d 75 14 4c 89 f2 48 c1  
ea 03 48 89 85 50 ff ff ff 48 b8 00 00 00 00 00 fc ff df <0f> b6 04 02 4c  
89 f2 83 e2 07 38 d0 7f 08 84 c0 0f 85 2e 06 00 00
RSP: 0018:ffff88809b23fb90 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: dffffc0000000000 RCX: ffffffff862cb8db
RDX: 0000000000000002 RSI: ffffffff862cb639 RDI: ffff8880a155ef00
RBP: ffff88809b23fc48 R08: ffff888094344640 R09: ffffed10142abd9a
R10: ffffed10142abd99 R11: ffff8880a155eccb R12: ffff8880a155ec40
R13: 0000000000000000 R14: 0000000000000014 R15: 0000000000000001
FS:  00005555556a8940(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f353458e000 CR3: 00000000a9174000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  tls_sk_proto_close+0x35b/0x990 net/tls/tls_main.c:321
  tcp_bpf_close+0x17c/0x390 net/ipv4/tcp_bpf.c:582
  inet_release+0xed/0x200 net/ipv4/af_inet.c:427
  inet6_release+0x53/0x80 net/ipv6/af_inet6.c:470
  __sock_release+0xce/0x280 net/socket.c:590
  sock_close+0x1e/0x30 net/socket.c:1268
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
  exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
  prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
  do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x413540
Code: 01 f0 ff ff 0f 83 30 1b 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f  
44 00 00 83 3d 4d 2d 66 00 00 75 14 b8 03 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 04 1b 00 00 c3 48 83 ec 08 e8 0a fc ff ff
RSP: 002b:00007fff5d481778 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000006 RCX: 0000000000413540
RDX: 0000001b2e520000 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 0000000000000001 R08: 0000000000000000 R09: ffffffffffffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000075bf20
R13: 0000000000000003 R14: 0000000000761220 R15: ffffffffffffffff
Modules linked in:
---[ end trace bdfd4385a0f1f76d ]---
RIP: 0010:tls_sk_proto_close+0xe5/0x990 net/tls/tls_main.c:298
Code: 0f 85 3f 08 00 00 49 8b 84 24 c0 02 00 00 4d 8d 75 14 4c 89 f2 48 c1  
ea 03 48 89 85 50 ff ff ff 48 b8 00 00 00 00 00 fc ff df <0f> b6 04 02 4c  
89 f2 83 e2 07 38 d0 7f 08 84 c0 0f 85 2e 06 00 00
RSP: 0018:ffff88809b23fb90 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: dffffc0000000000 RCX: ffffffff862cb8db
RDX: 0000000000000002 RSI: ffffffff862cb639 RDI: ffff8880a155ef00
RBP: ffff88809b23fc48 R08: ffff888094344640 R09: ffffed10142abd9a
R10: ffffed10142abd99 R11: ffff8880a155eccb R12: ffff8880a155ec40
R13: 0000000000000000 R14: 0000000000000014 R15: 0000000000000001
FS:  00005555556a8940(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f353458e000 CR3: 00000000a9174000 CR4: 00000000001406e0
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
