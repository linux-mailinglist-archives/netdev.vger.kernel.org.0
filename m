Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA2921529F
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 08:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbgGFGV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 02:21:26 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:44496 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728906AbgGFGVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 02:21:25 -0400
Received: by mail-io1-f70.google.com with SMTP id h15so23004174ioj.11
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 23:21:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=bifEgsdlIbIjEg7pabMBEtW7TXHbbAKTyRXUw/iOlU8=;
        b=jLJ30KDAyoFUpRZZggxSf/tIg3Mfch6i9LAwkZNcApfaEq9OEhi2AzFlwtnt1YY+fi
         efx1FdQ87qzflAn0nRt5lLTEJo58mi0oFBKiqBk2M4QQPleAvR2YnHNhGL5vRBn1I7zb
         FHGlFOir8oCdyx8JXqCk9kWX/fygqVtvNxu9P0NC2uRWnv6Kl9aQ0BdlYEGtZ73T8Upq
         fnbi2LVz+bcnWbTF4du+HQUijjR/n6T8RtSo5GhIek0WMoZ+PGXS274ILIbj12TM3nWU
         yFYukhjChh+rW/ijfMu+EP0LxFrHovoZYznJAkN2AhLQ3qxT5UfPPkYyWocqrKzzk/wG
         TD7A==
X-Gm-Message-State: AOAM530a628+lZCabb9UlAF3N+T6E9YKuOAym3XnyEVCMUeuyR2CWVAO
        7ro0kPrIRUdILxNb56gFugHWxDM35vF/4dKy7vJdm/btHhgt
X-Google-Smtp-Source: ABdhPJw6BPaOH2iRFAYDzIDQMa6riVilt/mJUZnFImpXe7w6tQdhMjaeBAfMXo/O+u1Nxwguoe7XvpMby02Oa+p5AWim5fzXw0F0
MIME-Version: 1.0
X-Received: by 2002:a6b:e20b:: with SMTP id z11mr23417921ioc.2.1594016484899;
 Sun, 05 Jul 2020 23:21:24 -0700 (PDT)
Date:   Sun, 05 Jul 2020 23:21:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000059437305a9bfe2a2@google.com>
Subject: BUG: unable to handle kernel NULL pointer dereference in bpf_prog_ADDR_L
From:   syzbot <syzbot+a4c6e533af740abd3922@syzkaller.appspotmail.com>
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

syzbot found the following crash on:

HEAD commit:    cb8e59cc Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1446cfd3100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a16ddbc78955e3a9
dashboard link: https://syzkaller.appspot.com/bug?extid=a4c6e533af740abd3922
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a4c6e533af740abd3922@syzkaller.appspotmail.com

BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 85748067 P4D 85748067 PUD 61918067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 4768 Comm: syz-executor.0 Not tainted 5.7.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:bpf_prog_6df1c5236f32720a_L+0x1f/0xa18
Code: cc cc cc cc cc cc cc cc cc cc cc 0f 1f 44 00 00 55 48 89 e5 48 81 ec 00 00 00 00 53 41 55 41 56 41 57 6a 00 31 c0 48 8b 7f 28 <48> 8b 7f 00 8b bf 00 01 00 00 5b 41 5f 41 5e 41 5d 5b c9 c3 cc cc
RSP: 0018:ffffc90001ee7ac0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: ffffc900022ea000
RDX: 0000000000000230 RSI: ffffc90000cb8038 RDI: 0000000000000000
RBP: ffffc90001ee7ae8 R08: ffff88805dc5e200 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90000cb8000
R13: dffffc0000000000 R14: 0000000000000001 R15: ffff88805dc5e200
FS:  00007fc83e30f700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000008c0f4000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Call Trace:
 bpf_prog_run_xdp include/linux/filter.h:734 [inline]
 bpf_test_run+0x226/0xc70 net/bpf/test_run.c:47
 bpf_prog_test_run_xdp+0x2ca/0x510 net/bpf/test_run.c:507
 bpf_prog_test_run kernel/bpf/syscall.c:2998 [inline]
 __do_sys_bpf+0x28ce/0x4a80 kernel/bpf/syscall.c:4138
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45cb29
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fc83e30ec78 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00000000004dade0 RCX: 000000000045cb29
RDX: 0000000000000040 RSI: 0000000020000040 RDI: 000000000000000a
RBP: 000000000078bfa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 000000000000005d R14: 00000000004c32db R15: 00007fc83e30f6d4
Modules linked in:
CR2: 0000000000000000
---[ end trace 6c5d2c7e681a670d ]---
RIP: 0010:bpf_prog_6df1c5236f32720a_L+0x1f/0xa18
Code: cc cc cc cc cc cc cc cc cc cc cc 0f 1f 44 00 00 55 48 89 e5 48 81 ec 00 00 00 00 53 41 55 41 56 41 57 6a 00 31 c0 48 8b 7f 28 <48> 8b 7f 00 8b bf 00 01 00 00 5b 41 5f 41 5e 41 5d 5b c9 c3 cc cc
RSP: 0018:ffffc90001ee7ac0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: ffffc900022ea000
RDX: 0000000000000230 RSI: ffffc90000cb8038 RDI: 0000000000000000
RBP: ffffc90001ee7ae8 R08: ffff88805dc5e200 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90000cb8000
R13: dffffc0000000000 R14: 0000000000000001 R15: ffff88805dc5e200
FS:  00007fc83e30f700(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000008c0f4000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
