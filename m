Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3334EE8351
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 09:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729781AbfJ2IiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 04:38:11 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:43545 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729754AbfJ2IiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 04:38:10 -0400
Received: by mail-il1-f197.google.com with SMTP id d11so11315228ild.10
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 01:38:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yW+jCv0zd4b+sIjQ5SBw5MYgudn7HjMjQQA3P/FMSgM=;
        b=ASM3pD1WYz8l0XEfFHFlVv7bKkPzM+Min7fJcW9UKgXxyABX9c6PcnndRGksnvb09p
         jCYhGy/zV4hZeJgkPfR3vkkot+CDWjgt++ValJsJyCPU9753EpPgp5+YWQIgbper/As7
         fyBwOq3hLuzsRJCsDBVPWtGES44z5dLzWAgpKU5eKe6BwEs9U0bt+1O898m0z7zjTMXi
         zNLPiQW02ITNAOdLE8IYQL/1FCEClSFEyeZeV/beuIlepZBlDNF3rosTCTjFm+VgVzTI
         YbmX2dT/6kkeHAR4+DuBT1eyEhjGy4CbYvIQHvZwNDF3i6iqaZ9naqCJkcTFiFNa+Im/
         SK1g==
X-Gm-Message-State: APjAAAUawBELuUBt5mf2uWXP3JtRtRjiLajupuxTTQfwRIkceLo1IsaU
        o3v6tUReYGnK4Ct3FK1Qqe9R0iI3saruhyi/YCOab9QvncBU
X-Google-Smtp-Source: APXvYqzJ8QwrCvVd34SJmF0g9JoVfI9omz/GkkPDZySU+/8+eicOV4ZLM9iGms3K1tN+Z9Y50lBPJF2xwqhrITxlTvucG3B5iBmD
MIME-Version: 1.0
X-Received: by 2002:a02:c7d2:: with SMTP id s18mr15406571jao.88.1572338287787;
 Tue, 29 Oct 2019 01:38:07 -0700 (PDT)
Date:   Tue, 29 Oct 2019 01:38:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001c46d5059608892f@google.com>
Subject: general protection fault in process_one_work
From:   syzbot <syzbot+9ed8f68ab30761f3678e@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, jakub.kicinski@netronome.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    38207291 bpf: Prepare btf_ctx_access for non raw_tp use case
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14173c0f600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=41648156aa09be10
dashboard link: https://syzkaller.appspot.com/bug?extid=9ed8f68ab30761f3678e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9ed8f68ab30761f3678e@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 9149 Comm: kworker/1:3 Not tainted 5.4.0-rc1+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events nsim_dev_trap_report_work
RIP: 0010:nsim_dev_trap_report_work+0xc4/0xaf0  
drivers/net/netdevsim/dev.c:409
Code: 89 45 d0 0f 84 8b 07 00 00 49 bc 00 00 00 00 00 fc ff df e8 3e ae ef  
fc 48 8b 45 d0 48 05 68 01 00 00 48 89 45 90 48 c1 e8 03 <42> 80 3c 20 00  
0f 85 b1 09 00 00 48 8b 45 d0 48 8b 98 68 01 00 00
RSP: 0018:ffff88806c98fc90 EFLAGS: 00010a06
RAX: 1bd5a0000000004d RBX: 0000000000000000 RCX: ffffffff84836e22
RDX: 0000000000000000 RSI: ffffffff84836db2 RDI: 0000000000000001
RBP: ffff88806c98fd30 R08: ffff88806c9863c0 R09: ffffed100d75f3d9
R10: ffffed100d75f3d8 R11: ffff88806baf9ec7 R12: dffffc0000000000
R13: ffff88806baf9ec0 R14: ffff8880a9a13900 R15: ffff8880ae934500
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007efdd0c9e000 CR3: 000000009cc1b000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace ba29cd1c27f63d86 ]---
RIP: 0010:nsim_dev_trap_report_work+0xc4/0xaf0  
drivers/net/netdevsim/dev.c:409
Code: 89 45 d0 0f 84 8b 07 00 00 49 bc 00 00 00 00 00 fc ff df e8 3e ae ef  
fc 48 8b 45 d0 48 05 68 01 00 00 48 89 45 90 48 c1 e8 03 <42> 80 3c 20 00  
0f 85 b1 09 00 00 48 8b 45 d0 48 8b 98 68 01 00 00
RSP: 0018:ffff88806c98fc90 EFLAGS: 00010a06
RAX: 1bd5a0000000004d RBX: 0000000000000000 RCX: ffffffff84836e22
RDX: 0000000000000000 RSI: ffffffff84836db2 RDI: 0000000000000001
RBP: ffff88806c98fd30 R08: ffff88806c9863c0 R09: ffffed100d75f3d9
R10: ffffed100d75f3d8 R11: ffff88806baf9ec7 R12: dffffc0000000000
R13: ffff88806baf9ec0 R14: ffff8880a9a13900 R15: ffff8880ae934500
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007efdd0c9e000 CR3: 000000009cc1b000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
