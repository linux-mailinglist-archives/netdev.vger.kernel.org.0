Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F991239CDB
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 00:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgHBWpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 18:45:24 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:39428 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbgHBWpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 18:45:24 -0400
Received: by mail-io1-f70.google.com with SMTP id m26so24163950ioc.6
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 15:45:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=y/UQtEAHqQ0gGfFqBo/fnOSAtAyVPJAKsfBdnRtDUQg=;
        b=HoBBU//XX5wyh7+y+aVUc4+BO/Yg2SOiMfeaJuMenwu4wxKLY/DIsXMLwVxLiyQ+UH
         ZuWUV4EQrrNTQjZ+k1kE5d2N6fd/xu/dpuuTk75H4jZj9ew0Eqgatcs9gHWU2cyBArz1
         pg66psixC29nk1squD455gJ4I8OmQIA0VpieeOreV1k6YTjGBm85RcNaVGc5PG7EK+lO
         0xAGefviT1zSZud4kSkEN9e/39KR2PHkfa7DkAlYL7jSbAcy6l1ahhaHbVErut5TQRJo
         /nnOo7LKCMt2VcfzmRCrMmETBK3zbv2AFo3V/xPxZ9CRo59LANs8YMh28m+iyK2VNarE
         zeIA==
X-Gm-Message-State: AOAM530ry8OGTsZlbpClIfB4JwSkx4VSp3unCCZAt/DCrTuIUeBC8Gb0
        pzae1uN0P2+gEf6G2uh/iOsX5lt/7pyx7rdDkAc9ySQWMwux
X-Google-Smtp-Source: ABdhPJzuMlwxzstXyVLaFS7qoOw8I5av0c896BjiM9El/GRKFz8pt6wY6BJ7pVqR44PFPYPNnoDjF9x3oMiLDB1t8v4kRAWSEcNb
MIME-Version: 1.0
X-Received: by 2002:a6b:7945:: with SMTP id j5mr14291984iop.143.1596408323250;
 Sun, 02 Aug 2020 15:45:23 -0700 (PDT)
Date:   Sun, 02 Aug 2020 15:45:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000006209e05abecc711@google.com>
Subject: BUG: unable to handle kernel NULL pointer dereference in bpf_prog_ADDR
From:   syzbot <syzbot+192a7fbbece55f740074@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ac3a0c84 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13234970900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c0cfcf935bcc94d2
dashboard link: https://syzkaller.appspot.com/bug?extid=192a7fbbece55f740074
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=141541ea900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+192a7fbbece55f740074@syzkaller.appspotmail.com

BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 9176a067 P4D 9176a067 PUD 9176b067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8142 Comm: syz-executor.2 Not tainted 5.8.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:bpf_prog_e48ebe87b99394c4+0x1f/0x590
Code: cc cc cc cc cc cc cc cc cc cc cc 0f 1f 44 00 00 55 48 89 e5 48 81 ec 00 00 00 00 53 41 55 41 56 41 57 6a 00 31 c0 48 8b 47 28 <48> 8b 40 00 8b 80 00 01 00 00 5b 41 5f 41 5e 41 5d 5b c9 c3 cc cc
RSP: 0018:ffffc900038a7b00 EFLAGS: 00010246
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: dffffc0000000000
RDX: ffff88808cfb0200 RSI: ffffc90000e7e038 RDI: ffffc900038a7ca8
RBP: ffffc900038a7b28 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90000e7e000
R13: ffffc90000e7e000 R14: 0000000000000001 R15: 0000000000000000
FS:  00007fda07fef700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000091769000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 bpf_prog_run_xdp include/linux/filter.h:734 [inline]
 bpf_test_run+0x221/0xc70 net/bpf/test_run.c:47
 bpf_prog_test_run_xdp+0x2ca/0x510 net/bpf/test_run.c:524
 bpf_prog_test_run kernel/bpf/syscall.c:2983 [inline]
 __do_sys_bpf+0x2117/0x4b10 kernel/bpf/syscall.c:4135
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45cc79
Code: 2d b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb b5 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fda07feec78 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000001740 RCX: 000000000045cc79
RDX: 0000000000000028 RSI: 0000000020000080 RDI: 000000000000000a
RBP: 000000000078bfe0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bfac
R13: 00007ffc3ef769bf R14: 00007fda07fef9c0 R15: 000000000078bfac
Modules linked in:
CR2: 0000000000000000
---[ end trace b2d24107e7fdae7d ]---
RIP: 0010:bpf_prog_e48ebe87b99394c4+0x1f/0x590
Code: cc cc cc cc cc cc cc cc cc cc cc 0f 1f 44 00 00 55 48 89 e5 48 81 ec 00 00 00 00 53 41 55 41 56 41 57 6a 00 31 c0 48 8b 47 28 <48> 8b 40 00 8b 80 00 01 00 00 5b 41 5f 41 5e 41 5d 5b c9 c3 cc cc
RSP: 0018:ffffc900038a7b00 EFLAGS: 00010246
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: dffffc0000000000
RDX: ffff88808cfb0200 RSI: ffffc90000e7e038 RDI: ffffc900038a7ca8
RBP: ffffc900038a7b28 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90000e7e000
R13: ffffc90000e7e000 R14: 0000000000000001 R15: 0000000000000000
FS:  00007fda07fef700(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000091769000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
