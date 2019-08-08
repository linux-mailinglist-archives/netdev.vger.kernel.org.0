Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 653BF867E3
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 19:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404259AbfHHRYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 13:24:11 -0400
Received: from mail-ot1-f72.google.com ([209.85.210.72]:48670 "EHLO
        mail-ot1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404225AbfHHRYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 13:24:07 -0400
Received: by mail-ot1-f72.google.com with SMTP id b4so63135851otf.15
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 10:24:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=e1gv1WeJMlHGANR4IY6E8iV8unm9tW2t77TdB7HR+60=;
        b=KjCkYYHOTUpo6WEgRxPPusauA+RYxEKVRrLW4lU553QmBjvtdL5W55fnkliflJytVi
         iIRsrmvCIUHQDbbCEBREnLY3/Dnw7a4AHJNVAWuND+uh57qbtgpY5qpuKt0e2+p8OhnM
         SU3NY17kiM+eQVWYptLqrZOIyaskf4ZiRAgT5vZpRAcfU/8tsj/1u0ZdIudtwjtR4sQu
         omgWSvRSe58HQn0yk4o7uroF1GDQJMSi2ecItuCQuvo0ZxSTrHdf3PDdrJtvYPiEoezX
         tS2jb0P00aNW638i05yJUaPIEpuHBypSUM3D9rbguhwEaYZXOih0cL7sRob1EYFarRyj
         L+7A==
X-Gm-Message-State: APjAAAWPd7qr6s1T4vGcq1th6MPqf2gIogDR0xairxhdB62Sm6xir1q8
        y5Y/V0zNx2Zb8BITsyX+JqK/Us5hodE0V395EUygwMMt9kBH
X-Google-Smtp-Source: APXvYqzHlVEvfdz4GO9vSY+QKFPioOgYcsWeEKwBh81ovnl0oAHiXc6BpMVJ4i5rb188ZzJ2tLSS7sfQWxzKOCnTzVv6npF1DGib
MIME-Version: 1.0
X-Received: by 2002:a02:c012:: with SMTP id y18mr6831313jai.85.1565285046564;
 Thu, 08 Aug 2019 10:24:06 -0700 (PDT)
Date:   Thu, 08 Aug 2019 10:24:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002c418a058f9e53cf@google.com>
Subject: general protection fault in perf_tp_event_match (2)
From:   syzbot <syzbot+076ba900c4a9a0f67aba@syzkaller.appspotmail.com>
To:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        jolsa@redhat.com, kafai@fb.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
        peterz@infradead.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    1e78030e Merge tag 'mmc-v5.3-rc1' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1011831a600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4c7b914a2680c9c6
dashboard link: https://syzkaller.appspot.com/bug?extid=076ba900c4a9a0f67aba
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+076ba900c4a9a0f67aba@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 22070 Comm: syz-executor.3 Not tainted 5.3.0-rc2+ #86
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:perf_tp_event_match+0x31/0x260 kernel/events/core.c:8560
Code: 89 f6 41 55 49 89 d5 41 54 53 48 89 fb e8 b7 0e ea ff 48 8d bb d0 01  
00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84  
c0 74 08 3c 03 0f 8e cc 01 00 00 44 8b a3 d0 01 00
RSP: 0018:ffff88804ffa7790 EFLAGS: 00010007
RAX: dffffc0000000000 RBX: 00000000ffffff9f RCX: ffffffff818bcb73
RDX: 000000002000002d RSI: ffffffff818890b9 RDI: 000000010000016f
RBP: ffff88804ffa77b0 R08: ffff8880531ba640 R09: ffffed100a6374c9
R10: ffffed100a6374c8 R11: ffff8880531ba647 R12: ffff8880ae830860
R13: ffff8880ae830860 R14: ffff88804ffa7880 R15: dffffc0000000000
FS:  00005555556d7940(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000738008 CR3: 000000004cad5000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  perf_tp_event+0x1ea/0x730 kernel/events/core.c:8611
  perf_trace_run_bpf_submit+0x131/0x190 kernel/events/core.c:8586
  perf_trace_sched_wakeup_template+0x42d/0x5d0  
include/trace/events/sched.h:57
  trace_sched_wakeup_new include/trace/events/sched.h:103 [inline]
  wake_up_new_task+0x70f/0xbd0 kernel/sched/core.c:2848
  _do_fork+0x26c/0xfa0 kernel/fork.c:2393
  __do_sys_clone kernel/fork.c:2524 [inline]
  __se_sys_clone kernel/fork.c:2505 [inline]
  __x64_sys_clone+0x18d/0x250 kernel/fork.c:2505
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x457dfa
Code: f7 d8 64 89 04 25 d4 02 00 00 64 4c 8b 0c 25 10 00 00 00 31 d2 4d 8d  
91 d0 02 00 00 31 f6 bf 11 00 20 01 b8 38 00 00 00 0f 05 <48> 3d 00 f0 ff  
ff 0f 87 f5 00 00 00 85 c0 41 89 c5 0f 85 fc 00 00
RSP: 002b:00007ffcf0b1c640 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007ffcf0b1c640 RCX: 0000000000457dfa
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000001200011
RBP: 00007ffcf0b1c680 R08: 0000000000000001 R09: 00005555556d7940
R10: 00005555556d7c10 R11: 0000000000000246 R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000000 R15: 00007ffcf0b1c6d0
Modules linked in:
---[ end trace 8f4efeb0ada52ec1 ]---
RIP: 0010:perf_tp_event_match+0x31/0x260 kernel/events/core.c:8560
Code: 89 f6 41 55 49 89 d5 41 54 53 48 89 fb e8 b7 0e ea ff 48 8d bb d0 01  
00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84  
c0 74 08 3c 03 0f 8e cc 01 00 00 44 8b a3 d0 01 00
RSP: 0018:ffff88804ffa7790 EFLAGS: 00010007
RAX: dffffc0000000000 RBX: 00000000ffffff9f RCX: ffffffff818bcb73
RDX: 000000002000002d RSI: ffffffff818890b9 RDI: 000000010000016f
RBP: ffff88804ffa77b0 R08: ffff8880531ba640 R09: ffffed100a6374c9
R10: ffffed100a6374c8 R11: ffff8880531ba647 R12: ffff8880ae830860
R13: ffff8880ae830860 R14: ffff88804ffa7880 R15: dffffc0000000000
FS:  00005555556d7940(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000738008 CR3: 000000004cad5000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
