Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9925B160FC
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 11:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfEGJdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 05:33:08 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:40379 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbfEGJdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 05:33:06 -0400
Received: by mail-io1-f71.google.com with SMTP id d24so7408451iob.7
        for <netdev@vger.kernel.org>; Tue, 07 May 2019 02:33:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=aOR6yJjOP+TsGwh0EcqAzW/3dMWPFOD9UXD0P5D61LU=;
        b=ZCg5L0QKsYZ2Rp2uM9owG0LxksgLlX+tKlJbMIldsjwnrxpmyiIcUoIMmfqwNF2zcN
         nSOfNEWFkKa6Rn21upNc9iXAtsN5pxaDzGh4+s5Hpk/q8xeceFVL9A3wE6FPs5/dIx5w
         byW4QUpPVWOn+OO3R8foSo/QpSQ2/ksQen9wl/1Un8s/zVIBuYEtHq/rD5JSa79g7HU7
         NKxrE7Odtq13JZw/jrGoC8wOhmkk3Du39ht0WNjf66esLt8Fy+jMg9q4oYa3MW+2Q85g
         Sd/XFUQ/mh9AJAdcVTvYqXdyERSaokUNOMfjIDgzIHwZLkJK6LQRMui4gyi4PsqAdTXl
         MG5Q==
X-Gm-Message-State: APjAAAXA3V6fAF5AuwpHJeLIQ+bW3DVXwQucUQZc6kkcfPXWyLaP0S7S
        Ue1tlkJPZrdzUJAGsUPrzzO4YYjFCikafMoet8KlXxLZhLkY
X-Google-Smtp-Source: APXvYqwPklXVVpHJNFLLY+OM48bKJ/DEGhmo5SL4yvySc+LrPCuBt5Tzi693BEoHwFHaEJKs1u161NO6xioxZVrzLdSZ++9PNpEZ
MIME-Version: 1.0
X-Received: by 2002:a6b:8b49:: with SMTP id n70mr2330626iod.198.1557221585818;
 Tue, 07 May 2019 02:33:05 -0700 (PDT)
Date:   Tue, 07 May 2019 02:33:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000759a89058848e747@google.com>
Subject: WARNING in __static_key_slow_dec_cpuslocked
From:   syzbot <syzbot+a65e6ce239e4afe6c5e7@syzkaller.appspotmail.com>
To:     ard.biesheuvel@linaro.org, bp@suse.de,
        linux-kernel@vger.kernel.org, mingo@kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de,
        yamada.masahiro@socionext.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    a734d1f4 net: openvswitch: return an error instead of doin..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11467d84a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bcf30bdc781fc378
dashboard link: https://syzkaller.appspot.com/bug?extid=a65e6ce239e4afe6c5e7
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a65e6ce239e4afe6c5e7@syzkaller.appspotmail.com

------------[ cut here ]------------
jump label: negative count!
WARNING: CPU: 0 PID: 16038 at kernel/jump_label.c:219  
__static_key_slow_dec_cpuslocked+0x12d/0x150 kernel/jump_label.c:219
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 16038 Comm: syz-executor.1 Not tainted 5.1.0-rc7+ #167
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2cb/0x65c kernel/panic.c:214
  __warn.cold+0x20/0x45 kernel/panic.c:571
  report_bug+0x263/0x2b0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:973
RIP: 0010:__static_key_slow_dec_cpuslocked+0x12d/0x150  
kernel/jump_label.c:219
Code: 84 d2 75 2d 41 8b 1c 24 31 ff 89 de e8 bc 18 e6 ff 85 db 0f 89 56 ff  
ff ff e8 2f 17 e6 ff 48 c7 c7 00 aa 71 87 e8 01 c5 b8 ff <0f> 0b e9 3e ff  
ff ff 4c 89 e7 e8 a4 a5 1e 00 eb c9 48 c7 c7 78 d6
RSP: 0018:ffff88808ed07910 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815afcc6 RDI: ffffed1011da0f14
RBP: ffff88808ed07930 R08: ffff8880964bc080 R09: ffffed1015d05011
R10: ffffed1015d05010 R11: ffff8880ae828087 R12: ffffffff8b14f560
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
  __static_key_slow_dec kernel/jump_label.c:238 [inline]
  static_key_slow_dec+0x60/0xa0 kernel/jump_label.c:252
  udp_destroy_sock net/ipv4/udp.c:2494 [inline]
  udp_destroy_sock+0x152/0x220 net/ipv4/udp.c:2480
  sk_common_release+0x6d/0x330 net/core/sock.c:3151
  udp_lib_close+0x16/0x20 include/net/udp.h:206
  inet_release+0x105/0x1f0 net/ipv4/af_inet.c:432
  __sock_release+0xd3/0x2b0 net/socket.c:599
  sock_close+0x1b/0x30 net/socket.c:1267
  __fput+0x2e5/0x8d0 fs/file_table.c:278
  ____fput+0x16/0x20 fs/file_table.c:309
  task_work_run+0x14a/0x1c0 kernel/task_work.c:113
  exit_task_work include/linux/task_work.h:22 [inline]
  do_exit+0x90a/0x2fa0 kernel/exit.c:876
  do_group_exit+0x135/0x370 kernel/exit.c:980
  get_signal+0x399/0x1d50 kernel/signal.c:2577
  do_signal+0x87/0x1940 arch/x86/kernel/signal.c:816
  exit_to_usermode_loop+0x244/0x2c0 arch/x86/entry/common.c:162
  prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
  syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
  do_syscall_64+0x52d/0x610 arch/x86/entry/common.c:293
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x458da9
Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f05c42b4c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000458da9
RDX: 0000000020000040 RSI: 0000000000008914 RDI: 0000000000000006
RBP: 000000000073bfa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f05c42b56d4
R13: 00000000004c4635 R14: 00000000004d7ec8 R15: 00000000ffffffff
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
