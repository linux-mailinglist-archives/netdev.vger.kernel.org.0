Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB91C33426B
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 17:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbhCJQFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 11:05:37 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:37073 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbhCJQF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 11:05:26 -0500
Received: by mail-io1-f70.google.com with SMTP id a18so13193631ioo.4
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 08:05:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=qZNVHnR/bDC9xj148yuWgAcFlo0xsdJ2gWgHjhJ2R70=;
        b=ULXbYQ2bhxpO+lY9P3UMLxkG6WEKGAzlqXw2qcGYlHWfuKC2cUaHH8/k3fF+zZL1gZ
         lACzi8rPr3wZhtt1jbl1SrC8zcmKDNdYkadscuwv9ciKgaMAd01nWNFirmoq40KDgHCX
         GcD2UTV0VXEs1n4U1Lde0aOvarrs+d9aweaJ6exe43ybajeUML1A6NyV49hdjajGERDe
         Y42haB8HzCDycQguJRZgRNYxeqov/joZtfa8zdsbTKptpkLlzQ14AAmOeI8gui0asy0Z
         A2Oz3QzmS4l3KkKk3BvDHNq91dyPi8B0MM2htDoT+mW+8TIMuMZAVihdMyLXDJw7UgUi
         xu5A==
X-Gm-Message-State: AOAM533jqhyTq/nAMVokPM2LCorZgVAZpILlR1wHRzNOGD3e8arO6MQM
        lP+meS4Gs8EW44DYf3hVm+ubtOQYGDE/bKQweRz+KpnQgJur
X-Google-Smtp-Source: ABdhPJw7a1swnVOCyzqS79tPGgZfT1srPo/AI8rsI/TK3EdYa9Ee33ce4hE3/A7SlzScOZnD5S3U0UCpcndVAu6q6LzrHOjZpZch
MIME-Version: 1.0
X-Received: by 2002:a02:a809:: with SMTP id f9mr3529472jaj.63.1615392322586;
 Wed, 10 Mar 2021 08:05:22 -0800 (PST)
Date:   Wed, 10 Mar 2021 08:05:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008f912605bd30d5d7@google.com>
Subject: [syzbot] UBSAN: shift-out-of-bounds in ___bpf_prog_run
From:   syzbot <syzbot+bed360704c521841c85d@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    144c79ef Merge tag 'perf-tools-fixes-for-v5.12-2020-03-07'..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1572d952d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccdd84f79f45b23d
dashboard link: https://syzkaller.appspot.com/bug?extid=bed360704c521841c85d

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bed360704c521841c85d@syzkaller.appspotmail.com

================================================================================
UBSAN: shift-out-of-bounds in kernel/bpf/core.c:1420:2
shift exponent 255 is too large for 64-bit type 'long long unsigned int'
CPU: 1 PID: 11097 Comm: syz-executor.4 Not tainted 5.12.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:327
 ___bpf_prog_run.cold+0x19/0x56c kernel/bpf/core.c:1420
 __bpf_prog_run32+0x8f/0xd0 kernel/bpf/core.c:1735
 bpf_dispatcher_nop_func include/linux/bpf.h:644 [inline]
 bpf_prog_run_pin_on_cpu include/linux/filter.h:624 [inline]
 bpf_prog_run_clear_cb include/linux/filter.h:755 [inline]
 run_filter+0x1a1/0x470 net/packet/af_packet.c:2031
 packet_rcv+0x313/0x13e0 net/packet/af_packet.c:2104
 dev_queue_xmit_nit+0x7c2/0xa90 net/core/dev.c:2387
 xmit_one net/core/dev.c:3588 [inline]
 dev_hard_start_xmit+0xad/0x920 net/core/dev.c:3609
 __dev_queue_xmit+0x2121/0x2e00 net/core/dev.c:4182
 __bpf_tx_skb net/core/filter.c:2116 [inline]
 __bpf_redirect_no_mac net/core/filter.c:2141 [inline]
 __bpf_redirect+0x548/0xc80 net/core/filter.c:2164
 ____bpf_clone_redirect net/core/filter.c:2448 [inline]
 bpf_clone_redirect+0x2ae/0x420 net/core/filter.c:2420
 ___bpf_prog_run+0x34e1/0x77d0 kernel/bpf/core.c:1523
 __bpf_prog_run512+0x99/0xe0 kernel/bpf/core.c:1737
 bpf_dispatcher_nop_func include/linux/bpf.h:644 [inline]
 bpf_test_run+0x3ed/0xc50 net/bpf/test_run.c:50
 bpf_prog_test_run_skb+0xabc/0x1c50 net/bpf/test_run.c:582
 bpf_prog_test_run kernel/bpf/syscall.c:3127 [inline]
 __do_sys_bpf+0x1ea9/0x4f00 kernel/bpf/syscall.c:4406
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x465f69
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2797f63188 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000465f69
RDX: 0000000000000028 RSI: 0000000020000080 RDI: 000000000000000a
RBP: 00000000004bfa3f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 00007ffcd53d929f R14: 00007f2797f63300 R15: 0000000000022000
================================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
