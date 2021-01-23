Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31D3301413
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 10:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbhAWJBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 04:01:05 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:43057 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbhAWJBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 04:01:01 -0500
Received: by mail-io1-f71.google.com with SMTP id n18so12485166ioo.10
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 01:00:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=bTBjzUD8RkwnNT4aK1lofX8Qcsy5NjDNHN/mHhMhUF4=;
        b=bi91FJvBVnw4qM5V67E2j3k+2gWOq4zOSg6n9RRNpXjqC1mhNQAMYfnJDyKNqISxW3
         YlDSEv3qPUuj6qjRZk6j5hHfqA07tU6uwgotNhoaCzfG5oDU93CNFR14a7MeQfOJU7Cq
         e0JAJOfU7FNzlfXFdZKxu19weI5vYpx/Fuk5Ftfcdoo6gwhJp0jpbYIZVzFcpuB5Vnq6
         q9hRQybDhC3Ww2E+NQflMUX+xDQCQK4SHEUOa6qDxHtHQSiGb1OxUdxAYz6F6a2E+nwj
         tQRpdIHvBHqGjs4gezHeDWGJf8SQUFHVYpDV2kZ6frq/YP+Rcqzn/8Z5ZaHvkzDX2tbu
         Nraw==
X-Gm-Message-State: AOAM530Jt2ahAP5YEJDJJ5pJbdkdl65Ax1Sm+BwbsAGBbr+paZrlmWuN
        YIsM2U8xAue01gIryjrMxVuTDM6J4gZLuogpQrsHxB3+sCBc
X-Google-Smtp-Source: ABdhPJwE7O0Cl3savSxSMdwLcKqEeCRPK/XSULk8kvwQ9QYBmduR/d6Pi81krbgY+7S6Bp3TS8lE/+7GIfbDhC2JHiZNKuPErp2x
MIME-Version: 1.0
X-Received: by 2002:a6b:681a:: with SMTP id d26mr1998641ioc.144.1611392419610;
 Sat, 23 Jan 2021 01:00:19 -0800 (PST)
Date:   Sat, 23 Jan 2021 01:00:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c3c84605b98d88f9@google.com>
Subject: BUG: unable to handle kernel paging request in bpf_trace_run7
From:   syzbot <syzbot+71ce453661898ec7a122@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, rostedt@goodmis.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7d68e382 bpf: Permit size-0 datasec
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17a5a184d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e0c7843b8af99dff
dashboard link: https://syzkaller.appspot.com/bug?extid=71ce453661898ec7a122
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+71ce453661898ec7a122@syzkaller.appspotmail.com

BUG: unable to handle page fault for address: ffffc90000cc0030
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 10000067 
P4D 10000067 
PUD 101ab067 
PMD 10a9e067 
PTE 0
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 8498 Comm: syz-executor.3 Not tainted 5.11.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:bpf_dispatcher_nop_func include/linux/bpf.h:651 [inline]
RIP: 0010:__bpf_trace_run kernel/trace/bpf_trace.c:2088 [inline]
RIP: 0010:bpf_trace_run7+0x174/0x420 kernel/trace/bpf_trace.c:2130
Code: f7 ff 48 8d 7b 30 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 a1 02 00 00 48 8d 73 38 48 8d 7c 24 28 <ff> 53 30 e8 14 0b f7 ff e8 af 33 7e 07 31 ff 89 c3 89 c6 e8 84 12
RSP: 0018:ffffc900019cf300 EFLAGS: 00010282

RAX: 0000000000000000 RBX: ffffc90000cc0000 RCX: ffffffff817bd211
RDX: 0000000000000000 RSI: ffffc90000cc0038 RDI: ffffc900019cf328
RBP: 1ffff92000339e61 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff817bd17f R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000001000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000002f78940(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90000cc0030 CR3: 00000000533d3000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Call Trace:
 __bpf_trace_percpu_alloc_percpu+0x1dc/0x220 include/trace/events/percpu.h:10
 trace_percpu_alloc_percpu include/trace/events/percpu.h:10 [inline]
 pcpu_alloc+0xba6/0x16f0 mm/percpu.c:1844
 xt_percpu_counter_alloc+0x131/0x1a0 net/netfilter/x_tables.c:1820
 find_check_entry.constprop.0+0xab/0x9a0 net/ipv4/netfilter/ip_tables.c:527
 translate_table+0xc26/0x16a0 net/ipv4/netfilter/ip_tables.c:717
 do_replace net/ipv4/netfilter/ip_tables.c:1135 [inline]
 do_ipt_set_ctl+0x553/0xb50 net/ipv4/netfilter/ip_tables.c:1627
 nf_setsockopt+0x83/0xe0 net/netfilter/nf_sockopt.c:101
 ip_setsockopt+0x3c3/0x3a20 net/ipv4/ip_sockglue.c:1435
 tcp_setsockopt+0x136/0x2440 net/ipv4/tcp.c:3597
 __sys_setsockopt+0x2db/0x610 net/socket.c:2115
 __do_sys_setsockopt net/socket.c:2126 [inline]
 __se_sys_setsockopt net/socket.c:2123 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2123
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x460d4a
Code: 49 89 ca b8 37 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 ca 88 fb ff c3 66 0f 1f 84 00 00 00 00 00 49 89 ca b8 36 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 aa 88 fb ff c3 66 0f 1f 84 00 00 00 00 00
RSP: 002b:00007fff6bb05e38 EFLAGS: 00000202 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007fff6bb05e60 RCX: 0000000000460d4a
RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 000000000074ee60 R08: 00000000000002d8 R09: 0000000000004000
R10: 000000000074cd00 R11: 0000000000000202 R12: 00007fff6bb05ec0
R13: 0000000000000003 R14: 000000000074cca0 R15: 0000000000000000
Modules linked in:
CR2: ffffc90000cc0030
---[ end trace 16413316cc5dacf7 ]---
RIP: 0010:bpf_dispatcher_nop_func include/linux/bpf.h:651 [inline]
RIP: 0010:__bpf_trace_run kernel/trace/bpf_trace.c:2088 [inline]
RIP: 0010:bpf_trace_run7+0x174/0x420 kernel/trace/bpf_trace.c:2130
Code: f7 ff 48 8d 7b 30 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 a1 02 00 00 48 8d 73 38 48 8d 7c 24 28 <ff> 53 30 e8 14 0b f7 ff e8 af 33 7e 07 31 ff 89 c3 89 c6 e8 84 12
RSP: 0018:ffffc900019cf300 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffffc90000cc0000 RCX: ffffffff817bd211
RDX: 0000000000000000 RSI: ffffc90000cc0038 RDI: ffffc900019cf328
RBP: 1ffff92000339e61 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff817bd17f R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000001000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000002f78940(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc90000cc0030 CR3: 00000000533d3000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
