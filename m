Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62E818E952
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 12:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731334AbfHOKyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 06:54:08 -0400
Received: from mail-oi1-f197.google.com ([209.85.167.197]:52256 "EHLO
        mail-oi1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731314AbfHOKyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 06:54:07 -0400
Received: by mail-oi1-f197.google.com with SMTP id y1so954142oih.19
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 03:54:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=iu5xMpJVePxmGvQqPz/kzGEyl3lnKN+M2iewRRbTvBs=;
        b=tMh2cLwOOZ2Akj/QyIFlNz2f7ebaOggBsEwyXSnrDNd0a0ti2hHOpv7BlJu8FeiTUL
         zthEYHbJVvlIQo0tjrWaXWtpF8nvWpmZKG9KdzBI6AYMCC/qBAJoBor28Ios74asUtn/
         IQFv82bxb7/1/I7waXrG//Jo3S2s0q7mNuzU5xXoL/WGF1TWGbNR7f2O6Xl2osygbEGt
         SVkcWv1Ww8T+0ljUVeFB5/ziv3b6V6+yjfPZjz9rhU1YoXIGJEro+0C83mIgiPI8npKD
         GdxYFpm16c7CXYFYKO71zk2d98qXp/w8Fckj2mxHQuMOIUFn5POiJ1oMaBgsxovR+SCz
         8oSA==
X-Gm-Message-State: APjAAAVKECN69miTEwSSnyStfE/LwSTBxRgfjiJVGJsgl7JIUWCL0HEw
        3yAa28rIQD3+8L6LRNo2nsl5jSJxXeeGYQoa3ib9bM7BvQKz
X-Google-Smtp-Source: APXvYqyJUfSjq5fX6S07s69c3lj/EQ1Effq/eoWR5+O3xWIoG31oSpaenHel3MEScC5+3znLjx+3Y2HUOE/zfO27k/8/8PQatAkt
MIME-Version: 1.0
X-Received: by 2002:a5e:d70a:: with SMTP id v10mr1960404iom.19.1565866446695;
 Thu, 15 Aug 2019 03:54:06 -0700 (PDT)
Date:   Thu, 15 Aug 2019 03:54:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000523ea3059025b11d@google.com>
Subject: INFO: task hung in tls_sw_release_resources_tx
From:   syzbot <syzbot+6a9ff159672dfbb41c95@syzkaller.appspotmail.com>
To:     ast@kernel.org, aviadye@mellanox.com, borisp@mellanox.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davejwatson@fb.com,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    6d5afe20 sctp: fix memleak in sctp_send_reset_streams
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=16e5536a600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4c9e9f08e9e8960
dashboard link: https://syzkaller.appspot.com/bug?extid=6a9ff159672dfbb41c95
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17cb0502600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14d5dc22600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6a9ff159672dfbb41c95@syzkaller.appspotmail.com

INFO: task syz-executor153:10198 blocked for more than 143 seconds.
       Not tainted 5.3.0-rc3+ #162
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
syz-executor153 D27672 10198  10179 0x80000002
Call Trace:
  context_switch kernel/sched/core.c:3254 [inline]
  __schedule+0x755/0x1580 kernel/sched/core.c:3880
  schedule+0xa8/0x270 kernel/sched/core.c:3944
  schedule_timeout+0x717/0xc50 kernel/time/timer.c:1783
  do_wait_for_common kernel/sched/completion.c:83 [inline]
  __wait_for_common kernel/sched/completion.c:104 [inline]
  wait_for_common kernel/sched/completion.c:115 [inline]
  wait_for_completion+0x29c/0x440 kernel/sched/completion.c:136
  crypto_wait_req include/linux/crypto.h:685 [inline]
  crypto_wait_req include/linux/crypto.h:680 [inline]
  tls_sw_release_resources_tx+0x4ee/0x6b0 net/tls/tls_sw.c:2075
  tls_sk_proto_cleanup net/tls/tls_main.c:275 [inline]
  tls_sk_proto_close+0x686/0x970 net/tls/tls_main.c:305
  inet_release+0xed/0x200 net/ipv4/af_inet.c:427
  inet6_release+0x53/0x80 net/ipv6/af_inet6.c:470
  __sock_release+0xce/0x280 net/socket.c:590
  sock_close+0x1e/0x30 net/socket.c:1268
  __fput+0x2ff/0x890 fs/file_table.c:280
  ____fput+0x16/0x20 fs/file_table.c:313
  task_work_run+0x145/0x1c0 kernel/task_work.c:113
  exit_task_work include/linux/task_work.h:22 [inline]
  do_exit+0x92f/0x2e50 kernel/exit.c:879
  do_group_exit+0x135/0x360 kernel/exit.c:983
  __do_sys_exit_group kernel/exit.c:994 [inline]
  __se_sys_exit_group kernel/exit.c:992 [inline]
  __x64_sys_exit_group+0x44/0x50 kernel/exit.c:992
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x43ff88
Code: 00 00 be 3c 00 00 00 eb 19 66 0f 1f 84 00 00 00 00 00 48 89 d7 89 f0  
0f 05 48 3d 00 f0 ff ff 77 21 f4 48 89 d7 44 89 c0 0f 05 <48> 3d 00 f0 ff  
ff 76 e0 f7 d8 64 41 89 01 eb d8 0f 1f 84 00 00 00
RSP: 002b:00007ffd1c2d0f78 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 000000000043ff88
RDX: 0000000000000000 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00000000004bf890 R08: 00000000000000e7 R09: ffffffffffffffd0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00000000006d1180 R14: 0000000000000000 R15: 0000000000000000
INFO: lockdep is turned off.
NMI backtrace for cpu 0
CPU: 0 PID: 1057 Comm: khungtaskd Not tainted 5.3.0-rc3+ #162
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  nmi_cpu_backtrace.cold+0x70/0xb2 lib/nmi_backtrace.c:101
  nmi_trigger_cpumask_backtrace+0x23b/0x28b lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
  check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
  watchdog+0x9d0/0xef0 kernel/hung_task.c:289
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1 skipped: idling at native_safe_halt+0xe/0x10  
arch/x86/include/asm/irqflags.h:60


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
