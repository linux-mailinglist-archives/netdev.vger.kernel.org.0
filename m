Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E86A6102480
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 13:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbfKSMfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 07:35:08 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:54857 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727351AbfKSMfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 07:35:08 -0500
Received: by mail-il1-f198.google.com with SMTP id t67so19197439ill.21
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 04:35:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=y6Aku7oJX0gIXknWTEbNW7ai/Guio2J9Sp/4M8zhwsg=;
        b=ctFWdkhuWBtg4Oy4ouLQz4RU9ML7Lg42/unERTQnLMQlAB2tD1hwSC+vTYow1yu5T/
         Yl6SxySr+g5Gr0J7UTb9TVPBgWalrkhL140wursGvLE1MZi0t3Jcs3bXm/LmI1O7zFf0
         l0fd/e2buz+cWih85LciQRPdCaWkk0i0ybp5LkkQjZugJgPcca1FBWts8rBhat3b2wcU
         Zy88ZbgSpZcN5li9CnP4pjvUQKBGLub7oe7ijH0VzG8dna58tHsePFmvBuWbufZV6sHp
         TJXusXQNf/pbMZALPxMszHhxag66cuTxXTQsDGii+8Av8TAAgOMEmeUFBPJ5YbNmt7WS
         vdLQ==
X-Gm-Message-State: APjAAAVnEDIuSiI0DBEdbLSA700jiwE/1cv7lzf5QgVH+lpDPn+lTfOz
        kW0SpP328siL2M0MY6+Ak01Wki9/qMEmcbzrQPKE+evFwv3i
X-Google-Smtp-Source: APXvYqzhcxgq7Vwsl8zS3M2nFVJF3Ew5GOS7hyZ3meIPc/CYzLwtsco9MojsVoH9eASy8nV1W9Vj5opw2ytMlMhk+Ij4Pd1O0E2z
MIME-Version: 1.0
X-Received: by 2002:a6b:f60f:: with SMTP id n15mr16567480ioh.263.1574166906854;
 Tue, 19 Nov 2019 04:35:06 -0800 (PST)
Date:   Tue, 19 Nov 2019 04:35:06 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004ce83f0597b24bba@google.com>
Subject: general protection fault in virtio_transport_release
From:   syzbot <syzbot+e2e5c07bf353b2f79daa@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, idosch@mellanox.com,
        jakub.kicinski@netronome.com, jiri@mellanox.com, kafai@fb.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com, stefanha@redhat.com,
        syzkaller-bugs@googlegroups.com, vadimp@mellanox.com,
        virtualization@lists.linux-foundation.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    1e8795b1 mscc.c: fix semicolon.cocci warnings
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15d77406e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e855e9c92c9474fe
dashboard link: https://syzkaller.appspot.com/bug?extid=e2e5c07bf353b2f79daa
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1537f46ae00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11359c6ae00000

The bug was bisected to:

commit f366cd2a2e510b155e18b21a2d149332aa08eb61
Author: Vadim Pasternak <vadimp@mellanox.com>
Date:   Mon Oct 21 10:30:30 2019 +0000

     mlxsw: reg: Add macro for getting QSFP module EEPROM page number

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=148945aae00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=168945aae00000
console output: https://syzkaller.appspot.com/x/log.txt?x=128945aae00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+e2e5c07bf353b2f79daa@syzkaller.appspotmail.com
Fixes: f366cd2a2e51 ("mlxsw: reg: Add macro for getting QSFP module EEPROM  
page number")

RDX: 0000000000000010 RSI: 00000000200000c0 RDI: 0000000000000004
RBP: 0000000000000005 R08: 0000000000000001 R09: 00007ffd5b250031
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401e00
R13: 0000000000401e90 R14: 0000000000000000 R15: 0000000000000000
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 8862 Comm: syz-executor079 Not tainted 5.4.0-rc6+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:virtio_transport_release+0x13b/0xcb0  
net/vmw_vsock/virtio_transport_common.c:826
Code: e8 aa e6 2b fa 66 41 83 fd 01 0f 84 34 02 00 00 e8 3a e5 2b fa 48 8b  
95 30 ff ff ff 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f  
85 22 0a 00 00 48 8b bb 98 00 00 00 48 b8 00 00 00
RSP: 0018:ffff888092dbfaf0 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff87474aa0
RDX: 0000000000000013 RSI: ffffffff874747d6 RDI: 0000000000000001
RBP: ffff888092dbfc00 R08: ffff88809245a380 R09: fffffbfff1555fe1
R10: fffffbfff1555fe0 R11: 0000000000000003 R12: ffff888092dbfbd8
R13: 0000000000000007 R14: 0000000000000007 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200000c4 CR3: 0000000008e6d000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  __vsock_release+0x80/0x2d0 net/vmw_vsock/af_vsock.c:733
  vsock_release+0x35/0xa0 net/vmw_vsock/af_vsock.c:806
  __sock_release+0xce/0x280 net/socket.c:590
  sock_close+0x1e/0x30 net/socket.c:1268
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  exit_task_work include/linux/task_work.h:22 [inline]
  do_exit+0x904/0x2e60 kernel/exit.c:817
  do_group_exit+0x135/0x360 kernel/exit.c:921
  __do_sys_exit_group kernel/exit.c:932 [inline]
  __se_sys_exit_group kernel/exit.c:930 [inline]
  __x64_sys_exit_group+0x44/0x50 kernel/exit.c:930
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x43f1d8
Code: Bad RIP value.
RSP: 002b:00007ffd5b25f838 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000000000043f1d8
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00000000004befa8 R08: 00000000000000e7 R09: ffffffffffffffd0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00000000006d1180 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 4b9b883ea3ab661f ]---
RIP: 0010:virtio_transport_release+0x13b/0xcb0  
net/vmw_vsock/virtio_transport_common.c:826
Code: e8 aa e6 2b fa 66 41 83 fd 01 0f 84 34 02 00 00 e8 3a e5 2b fa 48 8b  
95 30 ff ff ff 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f  
85 22 0a 00 00 48 8b bb 98 00 00 00 48 b8 00 00 00
RSP: 0018:ffff888092dbfaf0 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff87474aa0
RDX: 0000000000000013 RSI: ffffffff874747d6 RDI: 0000000000000001
RBP: ffff888092dbfc00 R08: ffff88809245a380 R09: fffffbfff1555fe1
R10: fffffbfff1555fe0 R11: 0000000000000003 R12: ffff888092dbfbd8
R13: 0000000000000007 R14: 0000000000000007 R15: 0000000000000000
FS:  00000000009db880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000043f1ae CR3: 0000000008e6d000 CR4: 00000000001406f0
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
